
obj/user/tst_free_3:     file format elf32-i386


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
  800031:	e8 3e 14 00 00       	call   801474 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

#define numOfAccessesFor3MB 7
#define numOfAccessesFor8MB 4
void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 7c 01 00 00    	sub    $0x17c,%esp



	int Mega = 1024*1024;
  800044:	c7 45 d4 00 00 10 00 	movl   $0x100000,-0x2c(%ebp)
	int kilo = 1024;
  80004b:	c7 45 d0 00 04 00 00 	movl   $0x400,-0x30(%ebp)
	char minByte = 1<<7;
  800052:	c6 45 cf 80          	movb   $0x80,-0x31(%ebp)
	char maxByte = 0x7F;
  800056:	c6 45 ce 7f          	movb   $0x7f,-0x32(%ebp)
	short minShort = 1<<15 ;
  80005a:	66 c7 45 cc 00 80    	movw   $0x8000,-0x34(%ebp)
	short maxShort = 0x7FFF;
  800060:	66 c7 45 ca ff 7f    	movw   $0x7fff,-0x36(%ebp)
	int minInt = 1<<31 ;
  800066:	c7 45 c4 00 00 00 80 	movl   $0x80000000,-0x3c(%ebp)
	int maxInt = 0x7FFFFFFF;
  80006d:	c7 45 c0 ff ff ff 7f 	movl   $0x7fffffff,-0x40(%ebp)
	char *byteArr, *byteArr2 ;
	short *shortArr, *shortArr2 ;
	int *intArr;
	int lastIndexOfByte, lastIndexOfByte2, lastIndexOfShort, lastIndexOfShort2, lastIndexOfInt, lastIndexOfStruct;
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  800074:	83 ec 0c             	sub    $0xc,%esp
  800077:	6a 00                	push   $0x0
  800079:	e8 a8 25 00 00       	call   802626 <malloc>
  80007e:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/
	//("STEP 0: checking Initial WS entries ...\n");
	{
		if( ROUNDDOWN(myEnv->__uptr_pws[0].virtual_address,PAGE_SIZE) !=   0x200000)  	panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800081:	a1 20 60 80 00       	mov    0x806020,%eax
  800086:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  80008c:	8b 00                	mov    (%eax),%eax
  80008e:	89 45 bc             	mov    %eax,-0x44(%ebp)
  800091:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800094:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800099:	3d 00 00 20 00       	cmp    $0x200000,%eax
  80009e:	74 14                	je     8000b4 <_main+0x7c>
  8000a0:	83 ec 04             	sub    $0x4,%esp
  8000a3:	68 80 48 80 00       	push   $0x804880
  8000a8:	6a 20                	push   $0x20
  8000aa:	68 c1 48 80 00       	push   $0x8048c1
  8000af:	e8 05 15 00 00       	call   8015b9 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[1].virtual_address,PAGE_SIZE) !=   0x201000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8000b4:	a1 20 60 80 00       	mov    0x806020,%eax
  8000b9:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  8000bf:	83 c0 18             	add    $0x18,%eax
  8000c2:	8b 00                	mov    (%eax),%eax
  8000c4:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8000c7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8000ca:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000cf:	3d 00 10 20 00       	cmp    $0x201000,%eax
  8000d4:	74 14                	je     8000ea <_main+0xb2>
  8000d6:	83 ec 04             	sub    $0x4,%esp
  8000d9:	68 80 48 80 00       	push   $0x804880
  8000de:	6a 21                	push   $0x21
  8000e0:	68 c1 48 80 00       	push   $0x8048c1
  8000e5:	e8 cf 14 00 00       	call   8015b9 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[2].virtual_address,PAGE_SIZE) !=   0x202000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8000ea:	a1 20 60 80 00       	mov    0x806020,%eax
  8000ef:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  8000f5:	83 c0 30             	add    $0x30,%eax
  8000f8:	8b 00                	mov    (%eax),%eax
  8000fa:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8000fd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800100:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800105:	3d 00 20 20 00       	cmp    $0x202000,%eax
  80010a:	74 14                	je     800120 <_main+0xe8>
  80010c:	83 ec 04             	sub    $0x4,%esp
  80010f:	68 80 48 80 00       	push   $0x804880
  800114:	6a 22                	push   $0x22
  800116:	68 c1 48 80 00       	push   $0x8048c1
  80011b:	e8 99 14 00 00       	call   8015b9 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[3].virtual_address,PAGE_SIZE) !=   0x203000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800120:	a1 20 60 80 00       	mov    0x806020,%eax
  800125:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  80012b:	83 c0 48             	add    $0x48,%eax
  80012e:	8b 00                	mov    (%eax),%eax
  800130:	89 45 b0             	mov    %eax,-0x50(%ebp)
  800133:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800136:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80013b:	3d 00 30 20 00       	cmp    $0x203000,%eax
  800140:	74 14                	je     800156 <_main+0x11e>
  800142:	83 ec 04             	sub    $0x4,%esp
  800145:	68 80 48 80 00       	push   $0x804880
  80014a:	6a 23                	push   $0x23
  80014c:	68 c1 48 80 00       	push   $0x8048c1
  800151:	e8 63 14 00 00       	call   8015b9 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[4].virtual_address,PAGE_SIZE) !=   0x204000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800156:	a1 20 60 80 00       	mov    0x806020,%eax
  80015b:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  800161:	83 c0 60             	add    $0x60,%eax
  800164:	8b 00                	mov    (%eax),%eax
  800166:	89 45 ac             	mov    %eax,-0x54(%ebp)
  800169:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80016c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800171:	3d 00 40 20 00       	cmp    $0x204000,%eax
  800176:	74 14                	je     80018c <_main+0x154>
  800178:	83 ec 04             	sub    $0x4,%esp
  80017b:	68 80 48 80 00       	push   $0x804880
  800180:	6a 24                	push   $0x24
  800182:	68 c1 48 80 00       	push   $0x8048c1
  800187:	e8 2d 14 00 00       	call   8015b9 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[5].virtual_address,PAGE_SIZE) !=   0x205000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80018c:	a1 20 60 80 00       	mov    0x806020,%eax
  800191:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  800197:	83 c0 78             	add    $0x78,%eax
  80019a:	8b 00                	mov    (%eax),%eax
  80019c:	89 45 a8             	mov    %eax,-0x58(%ebp)
  80019f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8001a2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001a7:	3d 00 50 20 00       	cmp    $0x205000,%eax
  8001ac:	74 14                	je     8001c2 <_main+0x18a>
  8001ae:	83 ec 04             	sub    $0x4,%esp
  8001b1:	68 80 48 80 00       	push   $0x804880
  8001b6:	6a 25                	push   $0x25
  8001b8:	68 c1 48 80 00       	push   $0x8048c1
  8001bd:	e8 f7 13 00 00       	call   8015b9 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[6].virtual_address,PAGE_SIZE) !=   0x800000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8001c2:	a1 20 60 80 00       	mov    0x806020,%eax
  8001c7:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  8001cd:	05 90 00 00 00       	add    $0x90,%eax
  8001d2:	8b 00                	mov    (%eax),%eax
  8001d4:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  8001d7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8001da:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001df:	3d 00 00 80 00       	cmp    $0x800000,%eax
  8001e4:	74 14                	je     8001fa <_main+0x1c2>
  8001e6:	83 ec 04             	sub    $0x4,%esp
  8001e9:	68 80 48 80 00       	push   $0x804880
  8001ee:	6a 26                	push   $0x26
  8001f0:	68 c1 48 80 00       	push   $0x8048c1
  8001f5:	e8 bf 13 00 00       	call   8015b9 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=   0x801000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8001fa:	a1 20 60 80 00       	mov    0x806020,%eax
  8001ff:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  800205:	05 a8 00 00 00       	add    $0xa8,%eax
  80020a:	8b 00                	mov    (%eax),%eax
  80020c:	89 45 a0             	mov    %eax,-0x60(%ebp)
  80020f:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800212:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800217:	3d 00 10 80 00       	cmp    $0x801000,%eax
  80021c:	74 14                	je     800232 <_main+0x1fa>
  80021e:	83 ec 04             	sub    $0x4,%esp
  800221:	68 80 48 80 00       	push   $0x804880
  800226:	6a 27                	push   $0x27
  800228:	68 c1 48 80 00       	push   $0x8048c1
  80022d:	e8 87 13 00 00       	call   8015b9 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=   0x802000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800232:	a1 20 60 80 00       	mov    0x806020,%eax
  800237:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  80023d:	05 c0 00 00 00       	add    $0xc0,%eax
  800242:	8b 00                	mov    (%eax),%eax
  800244:	89 45 9c             	mov    %eax,-0x64(%ebp)
  800247:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80024a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80024f:	3d 00 20 80 00       	cmp    $0x802000,%eax
  800254:	74 14                	je     80026a <_main+0x232>
  800256:	83 ec 04             	sub    $0x4,%esp
  800259:	68 80 48 80 00       	push   $0x804880
  80025e:	6a 28                	push   $0x28
  800260:	68 c1 48 80 00       	push   $0x8048c1
  800265:	e8 4f 13 00 00       	call   8015b9 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=   0xeebfd000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80026a:	a1 20 60 80 00       	mov    0x806020,%eax
  80026f:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  800275:	05 d8 00 00 00       	add    $0xd8,%eax
  80027a:	8b 00                	mov    (%eax),%eax
  80027c:	89 45 98             	mov    %eax,-0x68(%ebp)
  80027f:	8b 45 98             	mov    -0x68(%ebp),%eax
  800282:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800287:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  80028c:	74 14                	je     8002a2 <_main+0x26a>
  80028e:	83 ec 04             	sub    $0x4,%esp
  800291:	68 80 48 80 00       	push   $0x804880
  800296:	6a 29                	push   $0x29
  800298:	68 c1 48 80 00       	push   $0x8048c1
  80029d:	e8 17 13 00 00       	call   8015b9 <_panic>
		if( myEnv->page_last_WS_index !=  0)  										panic("INITIAL PAGE WS last index checking failed! Review size of the WS..!!");
  8002a2:	a1 20 60 80 00       	mov    0x806020,%eax
  8002a7:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
  8002ad:	85 c0                	test   %eax,%eax
  8002af:	74 14                	je     8002c5 <_main+0x28d>
  8002b1:	83 ec 04             	sub    $0x4,%esp
  8002b4:	68 d4 48 80 00       	push   $0x8048d4
  8002b9:	6a 2a                	push   $0x2a
  8002bb:	68 c1 48 80 00       	push   $0x8048c1
  8002c0:	e8 f4 12 00 00       	call   8015b9 <_panic>
	}

	int start_freeFrames = sys_calculate_free_frames() ;
  8002c5:	e8 31 2b 00 00       	call   802dfb <sys_calculate_free_frames>
  8002ca:	89 45 94             	mov    %eax,-0x6c(%ebp)

	int indicesOf3MB[numOfAccessesFor3MB];
	int indicesOf8MB[numOfAccessesFor8MB];
	int var, i, j;

	void* ptr_allocations[20] = {0};
  8002cd:	8d 95 80 fe ff ff    	lea    -0x180(%ebp),%edx
  8002d3:	b9 14 00 00 00       	mov    $0x14,%ecx
  8002d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8002dd:	89 d7                	mov    %edx,%edi
  8002df:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		/*ALLOCATE 2 MB*/
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002e1:	e8 60 2b 00 00       	call   802e46 <sys_pf_calculate_allocated_pages>
  8002e6:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  8002e9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002ec:	01 c0                	add    %eax,%eax
  8002ee:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8002f1:	83 ec 0c             	sub    $0xc,%esp
  8002f4:	50                   	push   %eax
  8002f5:	e8 2c 23 00 00       	call   802626 <malloc>
  8002fa:	83 c4 10             	add    $0x10,%esp
  8002fd:	89 85 80 fe ff ff    	mov    %eax,-0x180(%ebp)
		//check return address & page file
		if ((uint32) ptr_allocations[0] <  (USER_HEAP_START) || (uint32) ptr_allocations[0] > (USER_HEAP_START+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800303:	8b 85 80 fe ff ff    	mov    -0x180(%ebp),%eax
  800309:	85 c0                	test   %eax,%eax
  80030b:	79 0d                	jns    80031a <_main+0x2e2>
  80030d:	8b 85 80 fe ff ff    	mov    -0x180(%ebp),%eax
  800313:	3d 00 10 00 80       	cmp    $0x80001000,%eax
  800318:	76 14                	jbe    80032e <_main+0x2f6>
  80031a:	83 ec 04             	sub    $0x4,%esp
  80031d:	68 1c 49 80 00       	push   $0x80491c
  800322:	6a 39                	push   $0x39
  800324:	68 c1 48 80 00       	push   $0x8048c1
  800329:	e8 8b 12 00 00       	call   8015b9 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  80032e:	e8 13 2b 00 00       	call   802e46 <sys_pf_calculate_allocated_pages>
  800333:	2b 45 90             	sub    -0x70(%ebp),%eax
  800336:	3d 00 02 00 00       	cmp    $0x200,%eax
  80033b:	74 14                	je     800351 <_main+0x319>
  80033d:	83 ec 04             	sub    $0x4,%esp
  800340:	68 84 49 80 00       	push   $0x804984
  800345:	6a 3a                	push   $0x3a
  800347:	68 c1 48 80 00       	push   $0x8048c1
  80034c:	e8 68 12 00 00       	call   8015b9 <_panic>

		/*ALLOCATE 3 MB*/
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800351:	e8 f0 2a 00 00       	call   802e46 <sys_pf_calculate_allocated_pages>
  800356:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[1] = malloc(3*Mega-kilo);
  800359:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80035c:	89 c2                	mov    %eax,%edx
  80035e:	01 d2                	add    %edx,%edx
  800360:	01 d0                	add    %edx,%eax
  800362:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800365:	83 ec 0c             	sub    $0xc,%esp
  800368:	50                   	push   %eax
  800369:	e8 b8 22 00 00       	call   802626 <malloc>
  80036e:	83 c4 10             	add    $0x10,%esp
  800371:	89 85 84 fe ff ff    	mov    %eax,-0x17c(%ebp)
		//check return address & page file
		if ((uint32) ptr_allocations[1] < (USER_HEAP_START + 2*Mega) || (uint32) ptr_allocations[1] > (USER_HEAP_START+ 2*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800377:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  80037d:	89 c2                	mov    %eax,%edx
  80037f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800382:	01 c0                	add    %eax,%eax
  800384:	05 00 00 00 80       	add    $0x80000000,%eax
  800389:	39 c2                	cmp    %eax,%edx
  80038b:	72 16                	jb     8003a3 <_main+0x36b>
  80038d:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  800393:	89 c2                	mov    %eax,%edx
  800395:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800398:	01 c0                	add    %eax,%eax
  80039a:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80039f:	39 c2                	cmp    %eax,%edx
  8003a1:	76 14                	jbe    8003b7 <_main+0x37f>
  8003a3:	83 ec 04             	sub    $0x4,%esp
  8003a6:	68 1c 49 80 00       	push   $0x80491c
  8003ab:	6a 40                	push   $0x40
  8003ad:	68 c1 48 80 00       	push   $0x8048c1
  8003b2:	e8 02 12 00 00       	call   8015b9 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 3*Mega/PAGE_SIZE) panic("Extra or less pages are allocated in PageFile");
  8003b7:	e8 8a 2a 00 00       	call   802e46 <sys_pf_calculate_allocated_pages>
  8003bc:	2b 45 90             	sub    -0x70(%ebp),%eax
  8003bf:	89 c2                	mov    %eax,%edx
  8003c1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003c4:	89 c1                	mov    %eax,%ecx
  8003c6:	01 c9                	add    %ecx,%ecx
  8003c8:	01 c8                	add    %ecx,%eax
  8003ca:	85 c0                	test   %eax,%eax
  8003cc:	79 05                	jns    8003d3 <_main+0x39b>
  8003ce:	05 ff 0f 00 00       	add    $0xfff,%eax
  8003d3:	c1 f8 0c             	sar    $0xc,%eax
  8003d6:	39 c2                	cmp    %eax,%edx
  8003d8:	74 14                	je     8003ee <_main+0x3b6>
  8003da:	83 ec 04             	sub    $0x4,%esp
  8003dd:	68 84 49 80 00       	push   $0x804984
  8003e2:	6a 41                	push   $0x41
  8003e4:	68 c1 48 80 00       	push   $0x8048c1
  8003e9:	e8 cb 11 00 00       	call   8015b9 <_panic>

		/*ALLOCATE 8 MB*/
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003ee:	e8 53 2a 00 00       	call   802e46 <sys_pf_calculate_allocated_pages>
  8003f3:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[2] = malloc(8*Mega-kilo);
  8003f6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003f9:	c1 e0 03             	shl    $0x3,%eax
  8003fc:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8003ff:	83 ec 0c             	sub    $0xc,%esp
  800402:	50                   	push   %eax
  800403:	e8 1e 22 00 00       	call   802626 <malloc>
  800408:	83 c4 10             	add    $0x10,%esp
  80040b:	89 85 88 fe ff ff    	mov    %eax,-0x178(%ebp)
		//check return address & page file
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 5*Mega) || (uint32) ptr_allocations[2] > (USER_HEAP_START+ 5*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800411:	8b 85 88 fe ff ff    	mov    -0x178(%ebp),%eax
  800417:	89 c1                	mov    %eax,%ecx
  800419:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80041c:	89 d0                	mov    %edx,%eax
  80041e:	c1 e0 02             	shl    $0x2,%eax
  800421:	01 d0                	add    %edx,%eax
  800423:	05 00 00 00 80       	add    $0x80000000,%eax
  800428:	39 c1                	cmp    %eax,%ecx
  80042a:	72 1b                	jb     800447 <_main+0x40f>
  80042c:	8b 85 88 fe ff ff    	mov    -0x178(%ebp),%eax
  800432:	89 c1                	mov    %eax,%ecx
  800434:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800437:	89 d0                	mov    %edx,%eax
  800439:	c1 e0 02             	shl    $0x2,%eax
  80043c:	01 d0                	add    %edx,%eax
  80043e:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800443:	39 c1                	cmp    %eax,%ecx
  800445:	76 14                	jbe    80045b <_main+0x423>
  800447:	83 ec 04             	sub    $0x4,%esp
  80044a:	68 1c 49 80 00       	push   $0x80491c
  80044f:	6a 47                	push   $0x47
  800451:	68 c1 48 80 00       	push   $0x8048c1
  800456:	e8 5e 11 00 00       	call   8015b9 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 8*Mega/PAGE_SIZE) panic("Extra or less pages are allocated in PageFile");
  80045b:	e8 e6 29 00 00       	call   802e46 <sys_pf_calculate_allocated_pages>
  800460:	2b 45 90             	sub    -0x70(%ebp),%eax
  800463:	89 c2                	mov    %eax,%edx
  800465:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800468:	c1 e0 03             	shl    $0x3,%eax
  80046b:	85 c0                	test   %eax,%eax
  80046d:	79 05                	jns    800474 <_main+0x43c>
  80046f:	05 ff 0f 00 00       	add    $0xfff,%eax
  800474:	c1 f8 0c             	sar    $0xc,%eax
  800477:	39 c2                	cmp    %eax,%edx
  800479:	74 14                	je     80048f <_main+0x457>
  80047b:	83 ec 04             	sub    $0x4,%esp
  80047e:	68 84 49 80 00       	push   $0x804984
  800483:	6a 48                	push   $0x48
  800485:	68 c1 48 80 00       	push   $0x8048c1
  80048a:	e8 2a 11 00 00       	call   8015b9 <_panic>

		/*ALLOCATE 7 MB*/
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80048f:	e8 b2 29 00 00       	call   802e46 <sys_pf_calculate_allocated_pages>
  800494:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[3] = malloc(7*Mega-kilo);
  800497:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80049a:	89 d0                	mov    %edx,%eax
  80049c:	01 c0                	add    %eax,%eax
  80049e:	01 d0                	add    %edx,%eax
  8004a0:	01 c0                	add    %eax,%eax
  8004a2:	01 d0                	add    %edx,%eax
  8004a4:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8004a7:	83 ec 0c             	sub    $0xc,%esp
  8004aa:	50                   	push   %eax
  8004ab:	e8 76 21 00 00       	call   802626 <malloc>
  8004b0:	83 c4 10             	add    $0x10,%esp
  8004b3:	89 85 8c fe ff ff    	mov    %eax,-0x174(%ebp)
		//check return address & page file
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 13*Mega) || (uint32) ptr_allocations[3] > (USER_HEAP_START+ 13*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8004b9:	8b 85 8c fe ff ff    	mov    -0x174(%ebp),%eax
  8004bf:	89 c1                	mov    %eax,%ecx
  8004c1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8004c4:	89 d0                	mov    %edx,%eax
  8004c6:	01 c0                	add    %eax,%eax
  8004c8:	01 d0                	add    %edx,%eax
  8004ca:	c1 e0 02             	shl    $0x2,%eax
  8004cd:	01 d0                	add    %edx,%eax
  8004cf:	05 00 00 00 80       	add    $0x80000000,%eax
  8004d4:	39 c1                	cmp    %eax,%ecx
  8004d6:	72 1f                	jb     8004f7 <_main+0x4bf>
  8004d8:	8b 85 8c fe ff ff    	mov    -0x174(%ebp),%eax
  8004de:	89 c1                	mov    %eax,%ecx
  8004e0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8004e3:	89 d0                	mov    %edx,%eax
  8004e5:	01 c0                	add    %eax,%eax
  8004e7:	01 d0                	add    %edx,%eax
  8004e9:	c1 e0 02             	shl    $0x2,%eax
  8004ec:	01 d0                	add    %edx,%eax
  8004ee:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8004f3:	39 c1                	cmp    %eax,%ecx
  8004f5:	76 14                	jbe    80050b <_main+0x4d3>
  8004f7:	83 ec 04             	sub    $0x4,%esp
  8004fa:	68 1c 49 80 00       	push   $0x80491c
  8004ff:	6a 4e                	push   $0x4e
  800501:	68 c1 48 80 00       	push   $0x8048c1
  800506:	e8 ae 10 00 00       	call   8015b9 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 7*Mega/PAGE_SIZE) panic("Extra or less pages are allocated in PageFile");
  80050b:	e8 36 29 00 00       	call   802e46 <sys_pf_calculate_allocated_pages>
  800510:	2b 45 90             	sub    -0x70(%ebp),%eax
  800513:	89 c1                	mov    %eax,%ecx
  800515:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800518:	89 d0                	mov    %edx,%eax
  80051a:	01 c0                	add    %eax,%eax
  80051c:	01 d0                	add    %edx,%eax
  80051e:	01 c0                	add    %eax,%eax
  800520:	01 d0                	add    %edx,%eax
  800522:	85 c0                	test   %eax,%eax
  800524:	79 05                	jns    80052b <_main+0x4f3>
  800526:	05 ff 0f 00 00       	add    $0xfff,%eax
  80052b:	c1 f8 0c             	sar    $0xc,%eax
  80052e:	39 c1                	cmp    %eax,%ecx
  800530:	74 14                	je     800546 <_main+0x50e>
  800532:	83 ec 04             	sub    $0x4,%esp
  800535:	68 84 49 80 00       	push   $0x804984
  80053a:	6a 4f                	push   $0x4f
  80053c:	68 c1 48 80 00       	push   $0x8048c1
  800541:	e8 73 10 00 00       	call   8015b9 <_panic>

		/*access 3 MB*/// should bring 6 pages into WS (3 r, 4 w)
		int freeFrames = sys_calculate_free_frames() ;
  800546:	e8 b0 28 00 00       	call   802dfb <sys_calculate_free_frames>
  80054b:	89 45 8c             	mov    %eax,-0x74(%ebp)
		int modFrames = sys_calculate_modified_frames();
  80054e:	e8 c1 28 00 00       	call   802e14 <sys_calculate_modified_frames>
  800553:	89 45 88             	mov    %eax,-0x78(%ebp)
		lastIndexOfByte = (3*Mega-kilo)/sizeof(char) - 1;
  800556:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800559:	89 c2                	mov    %eax,%edx
  80055b:	01 d2                	add    %edx,%edx
  80055d:	01 d0                	add    %edx,%eax
  80055f:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800562:	48                   	dec    %eax
  800563:	89 45 84             	mov    %eax,-0x7c(%ebp)
		int inc = lastIndexOfByte / numOfAccessesFor3MB;
  800566:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800569:	bf 07 00 00 00       	mov    $0x7,%edi
  80056e:	99                   	cltd   
  80056f:	f7 ff                	idiv   %edi
  800571:	89 45 80             	mov    %eax,-0x80(%ebp)
		for (var = 0; var < numOfAccessesFor3MB; ++var)
  800574:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80057b:	eb 16                	jmp    800593 <_main+0x55b>
		{
			indicesOf3MB[var] = var * inc ;
  80057d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800580:	0f af 45 80          	imul   -0x80(%ebp),%eax
  800584:	89 c2                	mov    %eax,%edx
  800586:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800589:	89 94 85 e0 fe ff ff 	mov    %edx,-0x120(%ebp,%eax,4)
		/*access 3 MB*/// should bring 6 pages into WS (3 r, 4 w)
		int freeFrames = sys_calculate_free_frames() ;
		int modFrames = sys_calculate_modified_frames();
		lastIndexOfByte = (3*Mega-kilo)/sizeof(char) - 1;
		int inc = lastIndexOfByte / numOfAccessesFor3MB;
		for (var = 0; var < numOfAccessesFor3MB; ++var)
  800590:	ff 45 e4             	incl   -0x1c(%ebp)
  800593:	83 7d e4 06          	cmpl   $0x6,-0x1c(%ebp)
  800597:	7e e4                	jle    80057d <_main+0x545>
		{
			indicesOf3MB[var] = var * inc ;
		}
		byteArr = (char *) ptr_allocations[1];
  800599:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  80059f:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
		//3 reads
		int sum = 0;
  8005a5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
		for (var = 0; var < numOfAccessesFor3MB/2; ++var)
  8005ac:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8005b3:	eb 1f                	jmp    8005d4 <_main+0x59c>
		{
			sum += byteArr[indicesOf3MB[var]] ;
  8005b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005b8:	8b 84 85 e0 fe ff ff 	mov    -0x120(%ebp,%eax,4),%eax
  8005bf:	89 c2                	mov    %eax,%edx
  8005c1:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8005c7:	01 d0                	add    %edx,%eax
  8005c9:	8a 00                	mov    (%eax),%al
  8005cb:	0f be c0             	movsbl %al,%eax
  8005ce:	01 45 dc             	add    %eax,-0x24(%ebp)
			indicesOf3MB[var] = var * inc ;
		}
		byteArr = (char *) ptr_allocations[1];
		//3 reads
		int sum = 0;
		for (var = 0; var < numOfAccessesFor3MB/2; ++var)
  8005d1:	ff 45 e4             	incl   -0x1c(%ebp)
  8005d4:	83 7d e4 02          	cmpl   $0x2,-0x1c(%ebp)
  8005d8:	7e db                	jle    8005b5 <_main+0x57d>
		{
			sum += byteArr[indicesOf3MB[var]] ;
		}
		//4 writes
		for (var = numOfAccessesFor3MB/2; var < numOfAccessesFor3MB; ++var)
  8005da:	c7 45 e4 03 00 00 00 	movl   $0x3,-0x1c(%ebp)
  8005e1:	eb 1c                	jmp    8005ff <_main+0x5c7>
		{
			byteArr[indicesOf3MB[var]] = maxByte ;
  8005e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005e6:	8b 84 85 e0 fe ff ff 	mov    -0x120(%ebp,%eax,4),%eax
  8005ed:	89 c2                	mov    %eax,%edx
  8005ef:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8005f5:	01 c2                	add    %eax,%edx
  8005f7:	8a 45 ce             	mov    -0x32(%ebp),%al
  8005fa:	88 02                	mov    %al,(%edx)
		for (var = 0; var < numOfAccessesFor3MB/2; ++var)
		{
			sum += byteArr[indicesOf3MB[var]] ;
		}
		//4 writes
		for (var = numOfAccessesFor3MB/2; var < numOfAccessesFor3MB; ++var)
  8005fc:	ff 45 e4             	incl   -0x1c(%ebp)
  8005ff:	83 7d e4 06          	cmpl   $0x6,-0x1c(%ebp)
  800603:	7e de                	jle    8005e3 <_main+0x5ab>
		{
			byteArr[indicesOf3MB[var]] = maxByte ;
		}
		//check memory & WS
		if (((freeFrames+modFrames) - (sys_calculate_free_frames()+sys_calculate_modified_frames())) != 0 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800605:	8b 55 8c             	mov    -0x74(%ebp),%edx
  800608:	8b 45 88             	mov    -0x78(%ebp),%eax
  80060b:	01 d0                	add    %edx,%eax
  80060d:	89 c6                	mov    %eax,%esi
  80060f:	e8 e7 27 00 00       	call   802dfb <sys_calculate_free_frames>
  800614:	89 c3                	mov    %eax,%ebx
  800616:	e8 f9 27 00 00       	call   802e14 <sys_calculate_modified_frames>
  80061b:	01 d8                	add    %ebx,%eax
  80061d:	29 c6                	sub    %eax,%esi
  80061f:	89 f0                	mov    %esi,%eax
  800621:	83 f8 02             	cmp    $0x2,%eax
  800624:	74 14                	je     80063a <_main+0x602>
  800626:	83 ec 04             	sub    $0x4,%esp
  800629:	68 b4 49 80 00       	push   $0x8049b4
  80062e:	6a 67                	push   $0x67
  800630:	68 c1 48 80 00       	push   $0x8048c1
  800635:	e8 7f 0f 00 00       	call   8015b9 <_panic>
		int found = 0;
  80063a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		for (var = 0; var < numOfAccessesFor3MB ; ++var)
  800641:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800648:	eb 7b                	jmp    8006c5 <_main+0x68d>
		{
			for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  80064a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800651:	eb 5d                	jmp    8006b0 <_main+0x678>
			{
				if(ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[indicesOf3MB[var]])), PAGE_SIZE))
  800653:	a1 20 60 80 00       	mov    0x806020,%eax
  800658:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  80065e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800661:	89 d0                	mov    %edx,%eax
  800663:	01 c0                	add    %eax,%eax
  800665:	01 d0                	add    %edx,%eax
  800667:	c1 e0 03             	shl    $0x3,%eax
  80066a:	01 c8                	add    %ecx,%eax
  80066c:	8b 00                	mov    (%eax),%eax
  80066e:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
  800674:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80067a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80067f:	89 c2                	mov    %eax,%edx
  800681:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800684:	8b 84 85 e0 fe ff ff 	mov    -0x120(%ebp,%eax,4),%eax
  80068b:	89 c1                	mov    %eax,%ecx
  80068d:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800693:	01 c8                	add    %ecx,%eax
  800695:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
  80069b:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8006a1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8006a6:	39 c2                	cmp    %eax,%edx
  8006a8:	75 03                	jne    8006ad <_main+0x675>
				{
					found++;
  8006aa:	ff 45 d8             	incl   -0x28(%ebp)
		//check memory & WS
		if (((freeFrames+modFrames) - (sys_calculate_free_frames()+sys_calculate_modified_frames())) != 0 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		int found = 0;
		for (var = 0; var < numOfAccessesFor3MB ; ++var)
		{
			for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  8006ad:	ff 45 e0             	incl   -0x20(%ebp)
  8006b0:	a1 20 60 80 00       	mov    0x806020,%eax
  8006b5:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8006bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006be:	39 c2                	cmp    %eax,%edx
  8006c0:	77 91                	ja     800653 <_main+0x61b>
			byteArr[indicesOf3MB[var]] = maxByte ;
		}
		//check memory & WS
		if (((freeFrames+modFrames) - (sys_calculate_free_frames()+sys_calculate_modified_frames())) != 0 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		int found = 0;
		for (var = 0; var < numOfAccessesFor3MB ; ++var)
  8006c2:	ff 45 e4             	incl   -0x1c(%ebp)
  8006c5:	83 7d e4 06          	cmpl   $0x6,-0x1c(%ebp)
  8006c9:	0f 8e 7b ff ff ff    	jle    80064a <_main+0x612>
				{
					found++;
				}
			}
		}
		if (found != numOfAccessesFor3MB) panic("malloc: page is not added to WS");
  8006cf:	83 7d d8 07          	cmpl   $0x7,-0x28(%ebp)
  8006d3:	74 14                	je     8006e9 <_main+0x6b1>
  8006d5:	83 ec 04             	sub    $0x4,%esp
  8006d8:	68 f8 49 80 00       	push   $0x8049f8
  8006dd:	6a 73                	push   $0x73
  8006df:	68 c1 48 80 00       	push   $0x8048c1
  8006e4:	e8 d0 0e 00 00       	call   8015b9 <_panic>

		/*access 8 MB*/// should bring 4 pages into WS (2 r, 2 w) and victimize 4 pages from 3 MB allocation
		freeFrames = sys_calculate_free_frames() ;
  8006e9:	e8 0d 27 00 00       	call   802dfb <sys_calculate_free_frames>
  8006ee:	89 45 8c             	mov    %eax,-0x74(%ebp)
		modFrames = sys_calculate_modified_frames();
  8006f1:	e8 1e 27 00 00       	call   802e14 <sys_calculate_modified_frames>
  8006f6:	89 45 88             	mov    %eax,-0x78(%ebp)
		lastIndexOfShort = (8*Mega-kilo)/sizeof(short) - 1;
  8006f9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006fc:	c1 e0 03             	shl    $0x3,%eax
  8006ff:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800702:	d1 e8                	shr    %eax
  800704:	48                   	dec    %eax
  800705:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
		indicesOf8MB[0] = lastIndexOfShort * 1 / 2;
  80070b:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800711:	89 c2                	mov    %eax,%edx
  800713:	c1 ea 1f             	shr    $0x1f,%edx
  800716:	01 d0                	add    %edx,%eax
  800718:	d1 f8                	sar    %eax
  80071a:	89 85 d0 fe ff ff    	mov    %eax,-0x130(%ebp)
		indicesOf8MB[1] = lastIndexOfShort * 2 / 3;
  800720:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800726:	01 c0                	add    %eax,%eax
  800728:	89 c1                	mov    %eax,%ecx
  80072a:	b8 56 55 55 55       	mov    $0x55555556,%eax
  80072f:	f7 e9                	imul   %ecx
  800731:	c1 f9 1f             	sar    $0x1f,%ecx
  800734:	89 d0                	mov    %edx,%eax
  800736:	29 c8                	sub    %ecx,%eax
  800738:	89 85 d4 fe ff ff    	mov    %eax,-0x12c(%ebp)
		indicesOf8MB[2] = lastIndexOfShort * 3 / 4;
  80073e:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800744:	89 c2                	mov    %eax,%edx
  800746:	01 d2                	add    %edx,%edx
  800748:	01 d0                	add    %edx,%eax
  80074a:	85 c0                	test   %eax,%eax
  80074c:	79 03                	jns    800751 <_main+0x719>
  80074e:	83 c0 03             	add    $0x3,%eax
  800751:	c1 f8 02             	sar    $0x2,%eax
  800754:	89 85 d8 fe ff ff    	mov    %eax,-0x128(%ebp)
		indicesOf8MB[3] = lastIndexOfShort ;
  80075a:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800760:	89 85 dc fe ff ff    	mov    %eax,-0x124(%ebp)

		//use one of the read pages from 3 MB to avoid victimizing it
		sum += byteArr[indicesOf3MB[0]] ;
  800766:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  80076c:	89 c2                	mov    %eax,%edx
  80076e:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800774:	01 d0                	add    %edx,%eax
  800776:	8a 00                	mov    (%eax),%al
  800778:	0f be c0             	movsbl %al,%eax
  80077b:	01 45 dc             	add    %eax,-0x24(%ebp)

		shortArr = (short *) ptr_allocations[2];
  80077e:	8b 85 88 fe ff ff    	mov    -0x178(%ebp),%eax
  800784:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
		//2 reads
		sum = 0;
  80078a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
		for (var = 0; var < numOfAccessesFor8MB/2; ++var)
  800791:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800798:	eb 20                	jmp    8007ba <_main+0x782>
		{
			sum += shortArr[indicesOf8MB[var]] ;
  80079a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80079d:	8b 84 85 d0 fe ff ff 	mov    -0x130(%ebp,%eax,4),%eax
  8007a4:	01 c0                	add    %eax,%eax
  8007a6:	89 c2                	mov    %eax,%edx
  8007a8:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  8007ae:	01 d0                	add    %edx,%eax
  8007b0:	66 8b 00             	mov    (%eax),%ax
  8007b3:	98                   	cwtl   
  8007b4:	01 45 dc             	add    %eax,-0x24(%ebp)
		sum += byteArr[indicesOf3MB[0]] ;

		shortArr = (short *) ptr_allocations[2];
		//2 reads
		sum = 0;
		for (var = 0; var < numOfAccessesFor8MB/2; ++var)
  8007b7:	ff 45 e4             	incl   -0x1c(%ebp)
  8007ba:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  8007be:	7e da                	jle    80079a <_main+0x762>
		{
			sum += shortArr[indicesOf8MB[var]] ;
		}
		//2 writes
		for (var = numOfAccessesFor8MB/2; var < numOfAccessesFor8MB; ++var)
  8007c0:	c7 45 e4 02 00 00 00 	movl   $0x2,-0x1c(%ebp)
  8007c7:	eb 20                	jmp    8007e9 <_main+0x7b1>
		{
			shortArr[indicesOf8MB[var]] = maxShort ;
  8007c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007cc:	8b 84 85 d0 fe ff ff 	mov    -0x130(%ebp,%eax,4),%eax
  8007d3:	01 c0                	add    %eax,%eax
  8007d5:	89 c2                	mov    %eax,%edx
  8007d7:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  8007dd:	01 c2                	add    %eax,%edx
  8007df:	66 8b 45 ca          	mov    -0x36(%ebp),%ax
  8007e3:	66 89 02             	mov    %ax,(%edx)
		for (var = 0; var < numOfAccessesFor8MB/2; ++var)
		{
			sum += shortArr[indicesOf8MB[var]] ;
		}
		//2 writes
		for (var = numOfAccessesFor8MB/2; var < numOfAccessesFor8MB; ++var)
  8007e6:	ff 45 e4             	incl   -0x1c(%ebp)
  8007e9:	83 7d e4 03          	cmpl   $0x3,-0x1c(%ebp)
  8007ed:	7e da                	jle    8007c9 <_main+0x791>
		{
			shortArr[indicesOf8MB[var]] = maxShort ;
		}
		//check memory & WS
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  8007ef:	8b 5d 8c             	mov    -0x74(%ebp),%ebx
  8007f2:	e8 04 26 00 00       	call   802dfb <sys_calculate_free_frames>
  8007f7:	29 c3                	sub    %eax,%ebx
  8007f9:	89 d8                	mov    %ebx,%eax
  8007fb:	83 f8 04             	cmp    $0x4,%eax
  8007fe:	74 17                	je     800817 <_main+0x7df>
  800800:	83 ec 04             	sub    $0x4,%esp
  800803:	68 b4 49 80 00       	push   $0x8049b4
  800808:	68 8e 00 00 00       	push   $0x8e
  80080d:	68 c1 48 80 00       	push   $0x8048c1
  800812:	e8 a2 0d 00 00       	call   8015b9 <_panic>
		if ((modFrames - sys_calculate_modified_frames()) != -2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800817:	8b 5d 88             	mov    -0x78(%ebp),%ebx
  80081a:	e8 f5 25 00 00       	call   802e14 <sys_calculate_modified_frames>
  80081f:	29 c3                	sub    %eax,%ebx
  800821:	89 d8                	mov    %ebx,%eax
  800823:	83 f8 fe             	cmp    $0xfffffffe,%eax
  800826:	74 17                	je     80083f <_main+0x807>
  800828:	83 ec 04             	sub    $0x4,%esp
  80082b:	68 b4 49 80 00       	push   $0x8049b4
  800830:	68 8f 00 00 00       	push   $0x8f
  800835:	68 c1 48 80 00       	push   $0x8048c1
  80083a:	e8 7a 0d 00 00       	call   8015b9 <_panic>
		found = 0;
  80083f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		for (var = 0; var < numOfAccessesFor8MB ; ++var)
  800846:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80084d:	eb 7d                	jmp    8008cc <_main+0x894>
		{
			for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  80084f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800856:	eb 5f                	jmp    8008b7 <_main+0x87f>
			{
				if(ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[indicesOf8MB[var]])), PAGE_SIZE))
  800858:	a1 20 60 80 00       	mov    0x806020,%eax
  80085d:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800863:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800866:	89 d0                	mov    %edx,%eax
  800868:	01 c0                	add    %eax,%eax
  80086a:	01 d0                	add    %edx,%eax
  80086c:	c1 e0 03             	shl    $0x3,%eax
  80086f:	01 c8                	add    %ecx,%eax
  800871:	8b 00                	mov    (%eax),%eax
  800873:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
  800879:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  80087f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800884:	89 c2                	mov    %eax,%edx
  800886:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800889:	8b 84 85 d0 fe ff ff 	mov    -0x130(%ebp,%eax,4),%eax
  800890:	01 c0                	add    %eax,%eax
  800892:	89 c1                	mov    %eax,%ecx
  800894:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  80089a:	01 c8                	add    %ecx,%eax
  80089c:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
  8008a2:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  8008a8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008ad:	39 c2                	cmp    %eax,%edx
  8008af:	75 03                	jne    8008b4 <_main+0x87c>
				{
					found++;
  8008b1:	ff 45 d8             	incl   -0x28(%ebp)
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		if ((modFrames - sys_calculate_modified_frames()) != -2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < numOfAccessesFor8MB ; ++var)
		{
			for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  8008b4:	ff 45 e0             	incl   -0x20(%ebp)
  8008b7:	a1 20 60 80 00       	mov    0x806020,%eax
  8008bc:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8008c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c5:	39 c2                	cmp    %eax,%edx
  8008c7:	77 8f                	ja     800858 <_main+0x820>
		}
		//check memory & WS
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		if ((modFrames - sys_calculate_modified_frames()) != -2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < numOfAccessesFor8MB ; ++var)
  8008c9:	ff 45 e4             	incl   -0x1c(%ebp)
  8008cc:	83 7d e4 03          	cmpl   $0x3,-0x1c(%ebp)
  8008d0:	0f 8e 79 ff ff ff    	jle    80084f <_main+0x817>
				{
					found++;
				}
			}
		}
		if (found != numOfAccessesFor8MB) panic("malloc: page is not added to WS");
  8008d6:	83 7d d8 04          	cmpl   $0x4,-0x28(%ebp)
  8008da:	74 17                	je     8008f3 <_main+0x8bb>
  8008dc:	83 ec 04             	sub    $0x4,%esp
  8008df:	68 f8 49 80 00       	push   $0x8049f8
  8008e4:	68 9b 00 00 00       	push   $0x9b
  8008e9:	68 c1 48 80 00       	push   $0x8048c1
  8008ee:	e8 c6 0c 00 00       	call   8015b9 <_panic>

		/* Free 3 MB */// remove 3 pages from WS, 2 from free buffer, 2 from mod buffer and 2 tables
		freeFrames = sys_calculate_free_frames() ;
  8008f3:	e8 03 25 00 00       	call   802dfb <sys_calculate_free_frames>
  8008f8:	89 45 8c             	mov    %eax,-0x74(%ebp)
		modFrames = sys_calculate_modified_frames();
  8008fb:	e8 14 25 00 00       	call   802e14 <sys_calculate_modified_frames>
  800900:	89 45 88             	mov    %eax,-0x78(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800903:	e8 3e 25 00 00       	call   802e46 <sys_pf_calculate_allocated_pages>
  800908:	89 45 90             	mov    %eax,-0x70(%ebp)

		free(ptr_allocations[1]);
  80090b:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  800911:	83 ec 0c             	sub    $0xc,%esp
  800914:	50                   	push   %eax
  800915:	e8 c2 1e 00 00       	call   8027dc <free>
  80091a:	83 c4 10             	add    $0x10,%esp

		//check page file
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 3*Mega/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  80091d:	e8 24 25 00 00       	call   802e46 <sys_pf_calculate_allocated_pages>
  800922:	8b 55 90             	mov    -0x70(%ebp),%edx
  800925:	89 d1                	mov    %edx,%ecx
  800927:	29 c1                	sub    %eax,%ecx
  800929:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80092c:	89 c2                	mov    %eax,%edx
  80092e:	01 d2                	add    %edx,%edx
  800930:	01 d0                	add    %edx,%eax
  800932:	85 c0                	test   %eax,%eax
  800934:	79 05                	jns    80093b <_main+0x903>
  800936:	05 ff 0f 00 00       	add    $0xfff,%eax
  80093b:	c1 f8 0c             	sar    $0xc,%eax
  80093e:	39 c1                	cmp    %eax,%ecx
  800940:	74 17                	je     800959 <_main+0x921>
  800942:	83 ec 04             	sub    $0x4,%esp
  800945:	68 18 4a 80 00       	push   $0x804a18
  80094a:	68 a5 00 00 00       	push   $0xa5
  80094f:	68 c1 48 80 00       	push   $0x8048c1
  800954:	e8 60 0c 00 00       	call   8015b9 <_panic>
		//check memory and buffers
		if ((sys_calculate_free_frames() - freeFrames) != 3 + 2 + 2) panic("Wrong free: WS pages in memory, buffers and/or page tables are not freed correctly");
  800959:	e8 9d 24 00 00       	call   802dfb <sys_calculate_free_frames>
  80095e:	89 c2                	mov    %eax,%edx
  800960:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800963:	29 c2                	sub    %eax,%edx
  800965:	89 d0                	mov    %edx,%eax
  800967:	83 f8 07             	cmp    $0x7,%eax
  80096a:	74 17                	je     800983 <_main+0x94b>
  80096c:	83 ec 04             	sub    $0x4,%esp
  80096f:	68 54 4a 80 00       	push   $0x804a54
  800974:	68 a7 00 00 00       	push   $0xa7
  800979:	68 c1 48 80 00       	push   $0x8048c1
  80097e:	e8 36 0c 00 00       	call   8015b9 <_panic>
		if ((sys_calculate_modified_frames() - modFrames) != 2) panic("Wrong free: pages mod buffers are not freed correctly");
  800983:	e8 8c 24 00 00       	call   802e14 <sys_calculate_modified_frames>
  800988:	89 c2                	mov    %eax,%edx
  80098a:	8b 45 88             	mov    -0x78(%ebp),%eax
  80098d:	29 c2                	sub    %eax,%edx
  80098f:	89 d0                	mov    %edx,%eax
  800991:	83 f8 02             	cmp    $0x2,%eax
  800994:	74 17                	je     8009ad <_main+0x975>
  800996:	83 ec 04             	sub    $0x4,%esp
  800999:	68 a8 4a 80 00       	push   $0x804aa8
  80099e:	68 a8 00 00 00       	push   $0xa8
  8009a3:	68 c1 48 80 00       	push   $0x8048c1
  8009a8:	e8 0c 0c 00 00       	call   8015b9 <_panic>
		//check WS
		for (var = 0; var < numOfAccessesFor3MB ; ++var)
  8009ad:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8009b4:	e9 93 00 00 00       	jmp    800a4c <_main+0xa14>
		{
			for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  8009b9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8009c0:	eb 71                	jmp    800a33 <_main+0x9fb>
			{
				if(ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[indicesOf3MB[var]])), PAGE_SIZE))
  8009c2:	a1 20 60 80 00       	mov    0x806020,%eax
  8009c7:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8009cd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009d0:	89 d0                	mov    %edx,%eax
  8009d2:	01 c0                	add    %eax,%eax
  8009d4:	01 d0                	add    %edx,%eax
  8009d6:	c1 e0 03             	shl    $0x3,%eax
  8009d9:	01 c8                	add    %ecx,%eax
  8009db:	8b 00                	mov    (%eax),%eax
  8009dd:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  8009e3:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  8009e9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8009ee:	89 c2                	mov    %eax,%edx
  8009f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8009f3:	8b 84 85 e0 fe ff ff 	mov    -0x120(%ebp,%eax,4),%eax
  8009fa:	89 c1                	mov    %eax,%ecx
  8009fc:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800a02:	01 c8                	add    %ecx,%eax
  800a04:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  800a0a:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800a10:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a15:	39 c2                	cmp    %eax,%edx
  800a17:	75 17                	jne    800a30 <_main+0x9f8>
				{
					panic("free: page is not removed from WS");
  800a19:	83 ec 04             	sub    $0x4,%esp
  800a1c:	68 e0 4a 80 00       	push   $0x804ae0
  800a21:	68 b0 00 00 00       	push   $0xb0
  800a26:	68 c1 48 80 00       	push   $0x8048c1
  800a2b:	e8 89 0b 00 00       	call   8015b9 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 3 + 2 + 2) panic("Wrong free: WS pages in memory, buffers and/or page tables are not freed correctly");
		if ((sys_calculate_modified_frames() - modFrames) != 2) panic("Wrong free: pages mod buffers are not freed correctly");
		//check WS
		for (var = 0; var < numOfAccessesFor3MB ; ++var)
		{
			for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  800a30:	ff 45 e0             	incl   -0x20(%ebp)
  800a33:	a1 20 60 80 00       	mov    0x806020,%eax
  800a38:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800a3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a41:	39 c2                	cmp    %eax,%edx
  800a43:	0f 87 79 ff ff ff    	ja     8009c2 <_main+0x98a>
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 3*Mega/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
		//check memory and buffers
		if ((sys_calculate_free_frames() - freeFrames) != 3 + 2 + 2) panic("Wrong free: WS pages in memory, buffers and/or page tables are not freed correctly");
		if ((sys_calculate_modified_frames() - modFrames) != 2) panic("Wrong free: pages mod buffers are not freed correctly");
		//check WS
		for (var = 0; var < numOfAccessesFor3MB ; ++var)
  800a49:	ff 45 e4             	incl   -0x1c(%ebp)
  800a4c:	83 7d e4 06          	cmpl   $0x6,-0x1c(%ebp)
  800a50:	0f 8e 63 ff ff ff    	jle    8009b9 <_main+0x981>
			}
		}



		freeFrames = sys_calculate_free_frames() ;
  800a56:	e8 a0 23 00 00       	call   802dfb <sys_calculate_free_frames>
  800a5b:	89 45 8c             	mov    %eax,-0x74(%ebp)
		shortArr = (short *) ptr_allocations[2];
  800a5e:	8b 85 88 fe ff ff    	mov    -0x178(%ebp),%eax
  800a64:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
		lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  800a6a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800a6d:	01 c0                	add    %eax,%eax
  800a6f:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800a72:	d1 e8                	shr    %eax
  800a74:	48                   	dec    %eax
  800a75:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
		shortArr[0] = minShort;
  800a7b:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
  800a81:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800a84:	66 89 02             	mov    %ax,(%edx)
		shortArr[lastIndexOfShort] = maxShort;
  800a87:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800a8d:	01 c0                	add    %eax,%eax
  800a8f:	89 c2                	mov    %eax,%edx
  800a91:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800a97:	01 c2                	add    %eax,%edx
  800a99:	66 8b 45 ca          	mov    -0x36(%ebp),%ax
  800a9d:	66 89 02             	mov    %ax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2 ) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800aa0:	8b 5d 8c             	mov    -0x74(%ebp),%ebx
  800aa3:	e8 53 23 00 00       	call   802dfb <sys_calculate_free_frames>
  800aa8:	29 c3                	sub    %eax,%ebx
  800aaa:	89 d8                	mov    %ebx,%eax
  800aac:	83 f8 02             	cmp    $0x2,%eax
  800aaf:	74 17                	je     800ac8 <_main+0xa90>
  800ab1:	83 ec 04             	sub    $0x4,%esp
  800ab4:	68 b4 49 80 00       	push   $0x8049b4
  800ab9:	68 bc 00 00 00       	push   $0xbc
  800abe:	68 c1 48 80 00       	push   $0x8048c1
  800ac3:	e8 f1 0a 00 00       	call   8015b9 <_panic>
		found = 0;
  800ac8:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800acf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800ad6:	e9 a7 00 00 00       	jmp    800b82 <_main+0xb4a>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
  800adb:	a1 20 60 80 00       	mov    0x806020,%eax
  800ae0:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800ae6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
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
  800b09:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800b0f:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
  800b15:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800b1b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b20:	39 c2                	cmp    %eax,%edx
  800b22:	75 03                	jne    800b27 <_main+0xaef>
				found++;
  800b24:	ff 45 d8             	incl   -0x28(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
  800b27:	a1 20 60 80 00       	mov    0x806020,%eax
  800b2c:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800b32:	8b 55 e4             	mov    -0x1c(%ebp),%edx
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
  800b55:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800b5b:	01 c0                	add    %eax,%eax
  800b5d:	89 c1                	mov    %eax,%ecx
  800b5f:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800b65:	01 c8                	add    %ecx,%eax
  800b67:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  800b6d:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800b73:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b78:	39 c2                	cmp    %eax,%edx
  800b7a:	75 03                	jne    800b7f <_main+0xb47>
				found++;
  800b7c:	ff 45 d8             	incl   -0x28(%ebp)
		lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
		shortArr[0] = minShort;
		shortArr[lastIndexOfShort] = maxShort;
		if ((freeFrames - sys_calculate_free_frames()) != 2 ) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800b7f:	ff 45 e4             	incl   -0x1c(%ebp)
  800b82:	a1 20 60 80 00       	mov    0x806020,%eax
  800b87:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800b8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800b90:	39 c2                	cmp    %eax,%edx
  800b92:	0f 87 43 ff ff ff    	ja     800adb <_main+0xaa3>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  800b98:	83 7d d8 02          	cmpl   $0x2,-0x28(%ebp)
  800b9c:	74 17                	je     800bb5 <_main+0xb7d>
  800b9e:	83 ec 04             	sub    $0x4,%esp
  800ba1:	68 f8 49 80 00       	push   $0x8049f8
  800ba6:	68 c5 00 00 00       	push   $0xc5
  800bab:	68 c1 48 80 00       	push   $0x8048c1
  800bb0:	e8 04 0a 00 00       	call   8015b9 <_panic>

		//2 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800bb5:	e8 8c 22 00 00       	call   802e46 <sys_pf_calculate_allocated_pages>
  800bba:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[2] = malloc(2*kilo);
  800bbd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800bc0:	01 c0                	add    %eax,%eax
  800bc2:	83 ec 0c             	sub    $0xc,%esp
  800bc5:	50                   	push   %eax
  800bc6:	e8 5b 1a 00 00       	call   802626 <malloc>
  800bcb:	83 c4 10             	add    $0x10,%esp
  800bce:	89 85 88 fe ff ff    	mov    %eax,-0x178(%ebp)
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 4*Mega) || (uint32) ptr_allocations[2] > (USER_HEAP_START+ 4*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800bd4:	8b 85 88 fe ff ff    	mov    -0x178(%ebp),%eax
  800bda:	89 c2                	mov    %eax,%edx
  800bdc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800bdf:	c1 e0 02             	shl    $0x2,%eax
  800be2:	05 00 00 00 80       	add    $0x80000000,%eax
  800be7:	39 c2                	cmp    %eax,%edx
  800be9:	72 17                	jb     800c02 <_main+0xbca>
  800beb:	8b 85 88 fe ff ff    	mov    -0x178(%ebp),%eax
  800bf1:	89 c2                	mov    %eax,%edx
  800bf3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800bf6:	c1 e0 02             	shl    $0x2,%eax
  800bf9:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800bfe:	39 c2                	cmp    %eax,%edx
  800c00:	76 17                	jbe    800c19 <_main+0xbe1>
  800c02:	83 ec 04             	sub    $0x4,%esp
  800c05:	68 1c 49 80 00       	push   $0x80491c
  800c0a:	68 ca 00 00 00       	push   $0xca
  800c0f:	68 c1 48 80 00       	push   $0x8048c1
  800c14:	e8 a0 09 00 00       	call   8015b9 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  800c19:	e8 28 22 00 00       	call   802e46 <sys_pf_calculate_allocated_pages>
  800c1e:	2b 45 90             	sub    -0x70(%ebp),%eax
  800c21:	83 f8 01             	cmp    $0x1,%eax
  800c24:	74 17                	je     800c3d <_main+0xc05>
  800c26:	83 ec 04             	sub    $0x4,%esp
  800c29:	68 84 49 80 00       	push   $0x804984
  800c2e:	68 cb 00 00 00       	push   $0xcb
  800c33:	68 c1 48 80 00       	push   $0x8048c1
  800c38:	e8 7c 09 00 00       	call   8015b9 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800c3d:	e8 b9 21 00 00       	call   802dfb <sys_calculate_free_frames>
  800c42:	89 45 8c             	mov    %eax,-0x74(%ebp)
		intArr = (int *) ptr_allocations[2];
  800c45:	8b 85 88 fe ff ff    	mov    -0x178(%ebp),%eax
  800c4b:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
		lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
  800c51:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800c54:	01 c0                	add    %eax,%eax
  800c56:	c1 e8 02             	shr    $0x2,%eax
  800c59:	48                   	dec    %eax
  800c5a:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
		intArr[0] = minInt;
  800c60:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800c66:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800c69:	89 10                	mov    %edx,(%eax)
		intArr[lastIndexOfInt] = maxInt;
  800c6b:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  800c71:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800c78:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800c7e:	01 c2                	add    %eax,%edx
  800c80:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800c83:	89 02                	mov    %eax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 1 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800c85:	8b 5d 8c             	mov    -0x74(%ebp),%ebx
  800c88:	e8 6e 21 00 00       	call   802dfb <sys_calculate_free_frames>
  800c8d:	29 c3                	sub    %eax,%ebx
  800c8f:	89 d8                	mov    %ebx,%eax
  800c91:	83 f8 02             	cmp    $0x2,%eax
  800c94:	74 17                	je     800cad <_main+0xc75>
  800c96:	83 ec 04             	sub    $0x4,%esp
  800c99:	68 b4 49 80 00       	push   $0x8049b4
  800c9e:	68 d2 00 00 00       	push   $0xd2
  800ca3:	68 c1 48 80 00       	push   $0x8048c1
  800ca8:	e8 0c 09 00 00       	call   8015b9 <_panic>
		found = 0;
  800cad:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800cb4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800cbb:	e9 aa 00 00 00       	jmp    800d6a <_main+0xd32>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
  800cc0:	a1 20 60 80 00       	mov    0x806020,%eax
  800cc5:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800ccb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800cce:	89 d0                	mov    %edx,%eax
  800cd0:	01 c0                	add    %eax,%eax
  800cd2:	01 d0                	add    %edx,%eax
  800cd4:	c1 e0 03             	shl    $0x3,%eax
  800cd7:	01 c8                	add    %ecx,%eax
  800cd9:	8b 00                	mov    (%eax),%eax
  800cdb:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  800ce1:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800ce7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800cec:	89 c2                	mov    %eax,%edx
  800cee:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800cf4:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
  800cfa:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800d00:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d05:	39 c2                	cmp    %eax,%edx
  800d07:	75 03                	jne    800d0c <_main+0xcd4>
				found++;
  800d09:	ff 45 d8             	incl   -0x28(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
  800d0c:	a1 20 60 80 00       	mov    0x806020,%eax
  800d11:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800d17:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800d1a:	89 d0                	mov    %edx,%eax
  800d1c:	01 c0                	add    %eax,%eax
  800d1e:	01 d0                	add    %edx,%eax
  800d20:	c1 e0 03             	shl    $0x3,%eax
  800d23:	01 c8                	add    %ecx,%eax
  800d25:	8b 00                	mov    (%eax),%eax
  800d27:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)
  800d2d:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800d33:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d38:	89 c2                	mov    %eax,%edx
  800d3a:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  800d40:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800d47:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800d4d:	01 c8                	add    %ecx,%eax
  800d4f:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)
  800d55:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800d5b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d60:	39 c2                	cmp    %eax,%edx
  800d62:	75 03                	jne    800d67 <_main+0xd2f>
				found++;
  800d64:	ff 45 d8             	incl   -0x28(%ebp)
		lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
		intArr[0] = minInt;
		intArr[lastIndexOfInt] = maxInt;
		if ((freeFrames - sys_calculate_free_frames()) != 1 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800d67:	ff 45 e4             	incl   -0x1c(%ebp)
  800d6a:	a1 20 60 80 00       	mov    0x806020,%eax
  800d6f:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800d75:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800d78:	39 c2                	cmp    %eax,%edx
  800d7a:	0f 87 40 ff ff ff    	ja     800cc0 <_main+0xc88>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  800d80:	83 7d d8 02          	cmpl   $0x2,-0x28(%ebp)
  800d84:	74 17                	je     800d9d <_main+0xd65>
  800d86:	83 ec 04             	sub    $0x4,%esp
  800d89:	68 f8 49 80 00       	push   $0x8049f8
  800d8e:	68 db 00 00 00       	push   $0xdb
  800d93:	68 c1 48 80 00       	push   $0x8048c1
  800d98:	e8 1c 08 00 00       	call   8015b9 <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  800d9d:	e8 59 20 00 00       	call   802dfb <sys_calculate_free_frames>
  800da2:	89 45 8c             	mov    %eax,-0x74(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800da5:	e8 9c 20 00 00       	call   802e46 <sys_pf_calculate_allocated_pages>
  800daa:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[3] = malloc(2*kilo);
  800dad:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800db0:	01 c0                	add    %eax,%eax
  800db2:	83 ec 0c             	sub    $0xc,%esp
  800db5:	50                   	push   %eax
  800db6:	e8 6b 18 00 00       	call   802626 <malloc>
  800dbb:	83 c4 10             	add    $0x10,%esp
  800dbe:	89 85 8c fe ff ff    	mov    %eax,-0x174(%ebp)
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 4*Mega + 4*kilo) || (uint32) ptr_allocations[3] > (USER_HEAP_START+ 4*Mega + 4*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800dc4:	8b 85 8c fe ff ff    	mov    -0x174(%ebp),%eax
  800dca:	89 c2                	mov    %eax,%edx
  800dcc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800dcf:	c1 e0 02             	shl    $0x2,%eax
  800dd2:	89 c1                	mov    %eax,%ecx
  800dd4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800dd7:	c1 e0 02             	shl    $0x2,%eax
  800dda:	01 c8                	add    %ecx,%eax
  800ddc:	05 00 00 00 80       	add    $0x80000000,%eax
  800de1:	39 c2                	cmp    %eax,%edx
  800de3:	72 21                	jb     800e06 <_main+0xdce>
  800de5:	8b 85 8c fe ff ff    	mov    -0x174(%ebp),%eax
  800deb:	89 c2                	mov    %eax,%edx
  800ded:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800df0:	c1 e0 02             	shl    $0x2,%eax
  800df3:	89 c1                	mov    %eax,%ecx
  800df5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800df8:	c1 e0 02             	shl    $0x2,%eax
  800dfb:	01 c8                	add    %ecx,%eax
  800dfd:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800e02:	39 c2                	cmp    %eax,%edx
  800e04:	76 17                	jbe    800e1d <_main+0xde5>
  800e06:	83 ec 04             	sub    $0x4,%esp
  800e09:	68 1c 49 80 00       	push   $0x80491c
  800e0e:	68 e1 00 00 00       	push   $0xe1
  800e13:	68 c1 48 80 00       	push   $0x8048c1
  800e18:	e8 9c 07 00 00       	call   8015b9 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  800e1d:	e8 24 20 00 00       	call   802e46 <sys_pf_calculate_allocated_pages>
  800e22:	2b 45 90             	sub    -0x70(%ebp),%eax
  800e25:	83 f8 01             	cmp    $0x1,%eax
  800e28:	74 17                	je     800e41 <_main+0xe09>
  800e2a:	83 ec 04             	sub    $0x4,%esp
  800e2d:	68 84 49 80 00       	push   $0x804984
  800e32:	68 e2 00 00 00       	push   $0xe2
  800e37:	68 c1 48 80 00       	push   $0x8048c1
  800e3c:	e8 78 07 00 00       	call   8015b9 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//7 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e41:	e8 00 20 00 00       	call   802e46 <sys_pf_calculate_allocated_pages>
  800e46:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  800e49:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800e4c:	89 d0                	mov    %edx,%eax
  800e4e:	01 c0                	add    %eax,%eax
  800e50:	01 d0                	add    %edx,%eax
  800e52:	01 c0                	add    %eax,%eax
  800e54:	01 d0                	add    %edx,%eax
  800e56:	83 ec 0c             	sub    $0xc,%esp
  800e59:	50                   	push   %eax
  800e5a:	e8 c7 17 00 00       	call   802626 <malloc>
  800e5f:	83 c4 10             	add    $0x10,%esp
  800e62:	89 85 90 fe ff ff    	mov    %eax,-0x170(%ebp)
		if ((uint32) ptr_allocations[4] < (USER_HEAP_START + 4*Mega + 8*kilo)|| (uint32) ptr_allocations[4] > (USER_HEAP_START+ 4*Mega + 8*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800e68:	8b 85 90 fe ff ff    	mov    -0x170(%ebp),%eax
  800e6e:	89 c2                	mov    %eax,%edx
  800e70:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800e73:	c1 e0 02             	shl    $0x2,%eax
  800e76:	89 c1                	mov    %eax,%ecx
  800e78:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800e7b:	c1 e0 03             	shl    $0x3,%eax
  800e7e:	01 c8                	add    %ecx,%eax
  800e80:	05 00 00 00 80       	add    $0x80000000,%eax
  800e85:	39 c2                	cmp    %eax,%edx
  800e87:	72 21                	jb     800eaa <_main+0xe72>
  800e89:	8b 85 90 fe ff ff    	mov    -0x170(%ebp),%eax
  800e8f:	89 c2                	mov    %eax,%edx
  800e91:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800e94:	c1 e0 02             	shl    $0x2,%eax
  800e97:	89 c1                	mov    %eax,%ecx
  800e99:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800e9c:	c1 e0 03             	shl    $0x3,%eax
  800e9f:	01 c8                	add    %ecx,%eax
  800ea1:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800ea6:	39 c2                	cmp    %eax,%edx
  800ea8:	76 17                	jbe    800ec1 <_main+0xe89>
  800eaa:	83 ec 04             	sub    $0x4,%esp
  800ead:	68 1c 49 80 00       	push   $0x80491c
  800eb2:	68 e8 00 00 00       	push   $0xe8
  800eb7:	68 c1 48 80 00       	push   $0x8048c1
  800ebc:	e8 f8 06 00 00       	call   8015b9 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 2) panic("Extra or less pages are allocated in PageFile");
  800ec1:	e8 80 1f 00 00       	call   802e46 <sys_pf_calculate_allocated_pages>
  800ec6:	2b 45 90             	sub    -0x70(%ebp),%eax
  800ec9:	83 f8 02             	cmp    $0x2,%eax
  800ecc:	74 17                	je     800ee5 <_main+0xead>
  800ece:	83 ec 04             	sub    $0x4,%esp
  800ed1:	68 84 49 80 00       	push   $0x804984
  800ed6:	68 e9 00 00 00       	push   $0xe9
  800edb:	68 c1 48 80 00       	push   $0x8048c1
  800ee0:	e8 d4 06 00 00       	call   8015b9 <_panic>


		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  800ee5:	e8 11 1f 00 00       	call   802dfb <sys_calculate_free_frames>
  800eea:	89 45 8c             	mov    %eax,-0x74(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800eed:	e8 54 1f 00 00       	call   802e46 <sys_pf_calculate_allocated_pages>
  800ef2:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  800ef5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800ef8:	89 c2                	mov    %eax,%edx
  800efa:	01 d2                	add    %edx,%edx
  800efc:	01 d0                	add    %edx,%eax
  800efe:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800f01:	83 ec 0c             	sub    $0xc,%esp
  800f04:	50                   	push   %eax
  800f05:	e8 1c 17 00 00       	call   802626 <malloc>
  800f0a:	83 c4 10             	add    $0x10,%esp
  800f0d:	89 85 94 fe ff ff    	mov    %eax,-0x16c(%ebp)
		if ((uint32) ptr_allocations[5] < (USER_HEAP_START + 4*Mega + 16*kilo) || (uint32) ptr_allocations[5] > (USER_HEAP_START+ 4*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800f13:	8b 85 94 fe ff ff    	mov    -0x16c(%ebp),%eax
  800f19:	89 c2                	mov    %eax,%edx
  800f1b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800f1e:	c1 e0 02             	shl    $0x2,%eax
  800f21:	89 c1                	mov    %eax,%ecx
  800f23:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800f26:	c1 e0 04             	shl    $0x4,%eax
  800f29:	01 c8                	add    %ecx,%eax
  800f2b:	05 00 00 00 80       	add    $0x80000000,%eax
  800f30:	39 c2                	cmp    %eax,%edx
  800f32:	72 21                	jb     800f55 <_main+0xf1d>
  800f34:	8b 85 94 fe ff ff    	mov    -0x16c(%ebp),%eax
  800f3a:	89 c2                	mov    %eax,%edx
  800f3c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800f3f:	c1 e0 02             	shl    $0x2,%eax
  800f42:	89 c1                	mov    %eax,%ecx
  800f44:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800f47:	c1 e0 04             	shl    $0x4,%eax
  800f4a:	01 c8                	add    %ecx,%eax
  800f4c:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800f51:	39 c2                	cmp    %eax,%edx
  800f53:	76 17                	jbe    800f6c <_main+0xf34>
  800f55:	83 ec 04             	sub    $0x4,%esp
  800f58:	68 1c 49 80 00       	push   $0x80491c
  800f5d:	68 f0 00 00 00       	push   $0xf0
  800f62:	68 c1 48 80 00       	push   $0x8048c1
  800f67:	e8 4d 06 00 00       	call   8015b9 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 3*Mega/4096) panic("Extra or less pages are allocated in PageFile");
  800f6c:	e8 d5 1e 00 00       	call   802e46 <sys_pf_calculate_allocated_pages>
  800f71:	2b 45 90             	sub    -0x70(%ebp),%eax
  800f74:	89 c2                	mov    %eax,%edx
  800f76:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800f79:	89 c1                	mov    %eax,%ecx
  800f7b:	01 c9                	add    %ecx,%ecx
  800f7d:	01 c8                	add    %ecx,%eax
  800f7f:	85 c0                	test   %eax,%eax
  800f81:	79 05                	jns    800f88 <_main+0xf50>
  800f83:	05 ff 0f 00 00       	add    $0xfff,%eax
  800f88:	c1 f8 0c             	sar    $0xc,%eax
  800f8b:	39 c2                	cmp    %eax,%edx
  800f8d:	74 17                	je     800fa6 <_main+0xf6e>
  800f8f:	83 ec 04             	sub    $0x4,%esp
  800f92:	68 84 49 80 00       	push   $0x804984
  800f97:	68 f1 00 00 00       	push   $0xf1
  800f9c:	68 c1 48 80 00       	push   $0x8048c1
  800fa1:	e8 13 06 00 00       	call   8015b9 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//6 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800fa6:	e8 9b 1e 00 00       	call   802e46 <sys_pf_calculate_allocated_pages>
  800fab:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[6] = malloc(6*Mega-kilo);
  800fae:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800fb1:	89 d0                	mov    %edx,%eax
  800fb3:	01 c0                	add    %eax,%eax
  800fb5:	01 d0                	add    %edx,%eax
  800fb7:	01 c0                	add    %eax,%eax
  800fb9:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800fbc:	83 ec 0c             	sub    $0xc,%esp
  800fbf:	50                   	push   %eax
  800fc0:	e8 61 16 00 00       	call   802626 <malloc>
  800fc5:	83 c4 10             	add    $0x10,%esp
  800fc8:	89 85 98 fe ff ff    	mov    %eax,-0x168(%ebp)
		if ((uint32) ptr_allocations[6] < (USER_HEAP_START + 7*Mega + 16*kilo) || (uint32) ptr_allocations[6] > (USER_HEAP_START+ 7*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800fce:	8b 85 98 fe ff ff    	mov    -0x168(%ebp),%eax
  800fd4:	89 c1                	mov    %eax,%ecx
  800fd6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800fd9:	89 d0                	mov    %edx,%eax
  800fdb:	01 c0                	add    %eax,%eax
  800fdd:	01 d0                	add    %edx,%eax
  800fdf:	01 c0                	add    %eax,%eax
  800fe1:	01 d0                	add    %edx,%eax
  800fe3:	89 c2                	mov    %eax,%edx
  800fe5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800fe8:	c1 e0 04             	shl    $0x4,%eax
  800feb:	01 d0                	add    %edx,%eax
  800fed:	05 00 00 00 80       	add    $0x80000000,%eax
  800ff2:	39 c1                	cmp    %eax,%ecx
  800ff4:	72 28                	jb     80101e <_main+0xfe6>
  800ff6:	8b 85 98 fe ff ff    	mov    -0x168(%ebp),%eax
  800ffc:	89 c1                	mov    %eax,%ecx
  800ffe:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801001:	89 d0                	mov    %edx,%eax
  801003:	01 c0                	add    %eax,%eax
  801005:	01 d0                	add    %edx,%eax
  801007:	01 c0                	add    %eax,%eax
  801009:	01 d0                	add    %edx,%eax
  80100b:	89 c2                	mov    %eax,%edx
  80100d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801010:	c1 e0 04             	shl    $0x4,%eax
  801013:	01 d0                	add    %edx,%eax
  801015:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80101a:	39 c1                	cmp    %eax,%ecx
  80101c:	76 17                	jbe    801035 <_main+0xffd>
  80101e:	83 ec 04             	sub    $0x4,%esp
  801021:	68 1c 49 80 00       	push   $0x80491c
  801026:	68 f7 00 00 00       	push   $0xf7
  80102b:	68 c1 48 80 00       	push   $0x8048c1
  801030:	e8 84 05 00 00       	call   8015b9 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 6*Mega/4096) panic("Extra or less pages are allocated in PageFile");
  801035:	e8 0c 1e 00 00       	call   802e46 <sys_pf_calculate_allocated_pages>
  80103a:	2b 45 90             	sub    -0x70(%ebp),%eax
  80103d:	89 c1                	mov    %eax,%ecx
  80103f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801042:	89 d0                	mov    %edx,%eax
  801044:	01 c0                	add    %eax,%eax
  801046:	01 d0                	add    %edx,%eax
  801048:	01 c0                	add    %eax,%eax
  80104a:	85 c0                	test   %eax,%eax
  80104c:	79 05                	jns    801053 <_main+0x101b>
  80104e:	05 ff 0f 00 00       	add    $0xfff,%eax
  801053:	c1 f8 0c             	sar    $0xc,%eax
  801056:	39 c1                	cmp    %eax,%ecx
  801058:	74 17                	je     801071 <_main+0x1039>
  80105a:	83 ec 04             	sub    $0x4,%esp
  80105d:	68 84 49 80 00       	push   $0x804984
  801062:	68 f8 00 00 00       	push   $0xf8
  801067:	68 c1 48 80 00       	push   $0x8048c1
  80106c:	e8 48 05 00 00       	call   8015b9 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  801071:	e8 85 1d 00 00       	call   802dfb <sys_calculate_free_frames>
  801076:	89 45 8c             	mov    %eax,-0x74(%ebp)
		lastIndexOfByte2 = (6*Mega-kilo)/sizeof(char) - 1;
  801079:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80107c:	89 d0                	mov    %edx,%eax
  80107e:	01 c0                	add    %eax,%eax
  801080:	01 d0                	add    %edx,%eax
  801082:	01 c0                	add    %eax,%eax
  801084:	2b 45 d0             	sub    -0x30(%ebp),%eax
  801087:	48                   	dec    %eax
  801088:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)
		byteArr2 = (char *) ptr_allocations[6];
  80108e:	8b 85 98 fe ff ff    	mov    -0x168(%ebp),%eax
  801094:	89 85 2c ff ff ff    	mov    %eax,-0xd4(%ebp)
		byteArr2[0] = minByte ;
  80109a:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  8010a0:	8a 55 cf             	mov    -0x31(%ebp),%dl
  8010a3:	88 10                	mov    %dl,(%eax)
		byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
  8010a5:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  8010ab:	89 c2                	mov    %eax,%edx
  8010ad:	c1 ea 1f             	shr    $0x1f,%edx
  8010b0:	01 d0                	add    %edx,%eax
  8010b2:	d1 f8                	sar    %eax
  8010b4:	89 c2                	mov    %eax,%edx
  8010b6:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  8010bc:	01 c2                	add    %eax,%edx
  8010be:	8a 45 ce             	mov    -0x32(%ebp),%al
  8010c1:	88 c1                	mov    %al,%cl
  8010c3:	c0 e9 07             	shr    $0x7,%cl
  8010c6:	01 c8                	add    %ecx,%eax
  8010c8:	d0 f8                	sar    %al
  8010ca:	88 02                	mov    %al,(%edx)
		byteArr2[lastIndexOfByte2] = maxByte ;
  8010cc:	8b 95 30 ff ff ff    	mov    -0xd0(%ebp),%edx
  8010d2:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  8010d8:	01 c2                	add    %eax,%edx
  8010da:	8a 45 ce             	mov    -0x32(%ebp),%al
  8010dd:	88 02                	mov    %al,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 3 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  8010df:	8b 5d 8c             	mov    -0x74(%ebp),%ebx
  8010e2:	e8 14 1d 00 00       	call   802dfb <sys_calculate_free_frames>
  8010e7:	29 c3                	sub    %eax,%ebx
  8010e9:	89 d8                	mov    %ebx,%eax
  8010eb:	83 f8 05             	cmp    $0x5,%eax
  8010ee:	74 17                	je     801107 <_main+0x10cf>
  8010f0:	83 ec 04             	sub    $0x4,%esp
  8010f3:	68 b4 49 80 00       	push   $0x8049b4
  8010f8:	68 00 01 00 00       	push   $0x100
  8010fd:	68 c1 48 80 00       	push   $0x8048c1
  801102:	e8 b2 04 00 00       	call   8015b9 <_panic>
		found = 0;
  801107:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  80110e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801115:	e9 02 01 00 00       	jmp    80121c <_main+0x11e4>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE))
  80111a:	a1 20 60 80 00       	mov    0x806020,%eax
  80111f:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  801125:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801128:	89 d0                	mov    %edx,%eax
  80112a:	01 c0                	add    %eax,%eax
  80112c:	01 d0                	add    %edx,%eax
  80112e:	c1 e0 03             	shl    $0x3,%eax
  801131:	01 c8                	add    %ecx,%eax
  801133:	8b 00                	mov    (%eax),%eax
  801135:	89 85 28 ff ff ff    	mov    %eax,-0xd8(%ebp)
  80113b:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
  801141:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801146:	89 c2                	mov    %eax,%edx
  801148:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  80114e:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
  801154:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  80115a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80115f:	39 c2                	cmp    %eax,%edx
  801161:	75 03                	jne    801166 <_main+0x112e>
				found++;
  801163:	ff 45 d8             	incl   -0x28(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
  801166:	a1 20 60 80 00       	mov    0x806020,%eax
  80116b:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  801171:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801174:	89 d0                	mov    %edx,%eax
  801176:	01 c0                	add    %eax,%eax
  801178:	01 d0                	add    %edx,%eax
  80117a:	c1 e0 03             	shl    $0x3,%eax
  80117d:	01 c8                	add    %ecx,%eax
  80117f:	8b 00                	mov    (%eax),%eax
  801181:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
  801187:	8b 85 20 ff ff ff    	mov    -0xe0(%ebp),%eax
  80118d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801192:	89 c2                	mov    %eax,%edx
  801194:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  80119a:	89 c1                	mov    %eax,%ecx
  80119c:	c1 e9 1f             	shr    $0x1f,%ecx
  80119f:	01 c8                	add    %ecx,%eax
  8011a1:	d1 f8                	sar    %eax
  8011a3:	89 c1                	mov    %eax,%ecx
  8011a5:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  8011ab:	01 c8                	add    %ecx,%eax
  8011ad:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%ebp)
  8011b3:	8b 85 1c ff ff ff    	mov    -0xe4(%ebp),%eax
  8011b9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011be:	39 c2                	cmp    %eax,%edx
  8011c0:	75 03                	jne    8011c5 <_main+0x118d>
				found++;
  8011c2:	ff 45 d8             	incl   -0x28(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
  8011c5:	a1 20 60 80 00       	mov    0x806020,%eax
  8011ca:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8011d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8011d3:	89 d0                	mov    %edx,%eax
  8011d5:	01 c0                	add    %eax,%eax
  8011d7:	01 d0                	add    %edx,%eax
  8011d9:	c1 e0 03             	shl    $0x3,%eax
  8011dc:	01 c8                	add    %ecx,%eax
  8011de:	8b 00                	mov    (%eax),%eax
  8011e0:	89 85 18 ff ff ff    	mov    %eax,-0xe8(%ebp)
  8011e6:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
  8011ec:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011f1:	89 c1                	mov    %eax,%ecx
  8011f3:	8b 95 30 ff ff ff    	mov    -0xd0(%ebp),%edx
  8011f9:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  8011ff:	01 d0                	add    %edx,%eax
  801201:	89 85 14 ff ff ff    	mov    %eax,-0xec(%ebp)
  801207:	8b 85 14 ff ff ff    	mov    -0xec(%ebp),%eax
  80120d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801212:	39 c1                	cmp    %eax,%ecx
  801214:	75 03                	jne    801219 <_main+0x11e1>
				found++;
  801216:	ff 45 d8             	incl   -0x28(%ebp)
		byteArr2[0] = minByte ;
		byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
		byteArr2[lastIndexOfByte2] = maxByte ;
		if ((freeFrames - sys_calculate_free_frames()) != 3 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  801219:	ff 45 e4             	incl   -0x1c(%ebp)
  80121c:	a1 20 60 80 00       	mov    0x806020,%eax
  801221:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801227:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80122a:	39 c2                	cmp    %eax,%edx
  80122c:	0f 87 e8 fe ff ff    	ja     80111a <_main+0x10e2>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
				found++;
		}
		if (found != 3) panic("malloc: page is not added to WS");
  801232:	83 7d d8 03          	cmpl   $0x3,-0x28(%ebp)
  801236:	74 17                	je     80124f <_main+0x1217>
  801238:	83 ec 04             	sub    $0x4,%esp
  80123b:	68 f8 49 80 00       	push   $0x8049f8
  801240:	68 0b 01 00 00       	push   $0x10b
  801245:	68 c1 48 80 00       	push   $0x8048c1
  80124a:	e8 6a 03 00 00       	call   8015b9 <_panic>

		//14 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80124f:	e8 f2 1b 00 00       	call   802e46 <sys_pf_calculate_allocated_pages>
  801254:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[7] = malloc(14*kilo);
  801257:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80125a:	89 d0                	mov    %edx,%eax
  80125c:	01 c0                	add    %eax,%eax
  80125e:	01 d0                	add    %edx,%eax
  801260:	01 c0                	add    %eax,%eax
  801262:	01 d0                	add    %edx,%eax
  801264:	01 c0                	add    %eax,%eax
  801266:	83 ec 0c             	sub    $0xc,%esp
  801269:	50                   	push   %eax
  80126a:	e8 b7 13 00 00       	call   802626 <malloc>
  80126f:	83 c4 10             	add    $0x10,%esp
  801272:	89 85 9c fe ff ff    	mov    %eax,-0x164(%ebp)
		if ((uint32) ptr_allocations[7] < (USER_HEAP_START + 13*Mega + 16*kilo)|| (uint32) ptr_allocations[7] > (USER_HEAP_START+ 13*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  801278:	8b 85 9c fe ff ff    	mov    -0x164(%ebp),%eax
  80127e:	89 c1                	mov    %eax,%ecx
  801280:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801283:	89 d0                	mov    %edx,%eax
  801285:	01 c0                	add    %eax,%eax
  801287:	01 d0                	add    %edx,%eax
  801289:	c1 e0 02             	shl    $0x2,%eax
  80128c:	01 d0                	add    %edx,%eax
  80128e:	89 c2                	mov    %eax,%edx
  801290:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801293:	c1 e0 04             	shl    $0x4,%eax
  801296:	01 d0                	add    %edx,%eax
  801298:	05 00 00 00 80       	add    $0x80000000,%eax
  80129d:	39 c1                	cmp    %eax,%ecx
  80129f:	72 29                	jb     8012ca <_main+0x1292>
  8012a1:	8b 85 9c fe ff ff    	mov    -0x164(%ebp),%eax
  8012a7:	89 c1                	mov    %eax,%ecx
  8012a9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8012ac:	89 d0                	mov    %edx,%eax
  8012ae:	01 c0                	add    %eax,%eax
  8012b0:	01 d0                	add    %edx,%eax
  8012b2:	c1 e0 02             	shl    $0x2,%eax
  8012b5:	01 d0                	add    %edx,%eax
  8012b7:	89 c2                	mov    %eax,%edx
  8012b9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8012bc:	c1 e0 04             	shl    $0x4,%eax
  8012bf:	01 d0                	add    %edx,%eax
  8012c1:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8012c6:	39 c1                	cmp    %eax,%ecx
  8012c8:	76 17                	jbe    8012e1 <_main+0x12a9>
  8012ca:	83 ec 04             	sub    $0x4,%esp
  8012cd:	68 1c 49 80 00       	push   $0x80491c
  8012d2:	68 10 01 00 00       	push   $0x110
  8012d7:	68 c1 48 80 00       	push   $0x8048c1
  8012dc:	e8 d8 02 00 00       	call   8015b9 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 4) panic("Extra or less pages are allocated in PageFile");
  8012e1:	e8 60 1b 00 00       	call   802e46 <sys_pf_calculate_allocated_pages>
  8012e6:	2b 45 90             	sub    -0x70(%ebp),%eax
  8012e9:	83 f8 04             	cmp    $0x4,%eax
  8012ec:	74 17                	je     801305 <_main+0x12cd>
  8012ee:	83 ec 04             	sub    $0x4,%esp
  8012f1:	68 84 49 80 00       	push   $0x804984
  8012f6:	68 11 01 00 00       	push   $0x111
  8012fb:	68 c1 48 80 00       	push   $0x8048c1
  801300:	e8 b4 02 00 00       	call   8015b9 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  801305:	e8 f1 1a 00 00       	call   802dfb <sys_calculate_free_frames>
  80130a:	89 45 8c             	mov    %eax,-0x74(%ebp)
		shortArr2 = (short *) ptr_allocations[7];
  80130d:	8b 85 9c fe ff ff    	mov    -0x164(%ebp),%eax
  801313:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
		lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
  801319:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80131c:	89 d0                	mov    %edx,%eax
  80131e:	01 c0                	add    %eax,%eax
  801320:	01 d0                	add    %edx,%eax
  801322:	01 c0                	add    %eax,%eax
  801324:	01 d0                	add    %edx,%eax
  801326:	01 c0                	add    %eax,%eax
  801328:	d1 e8                	shr    %eax
  80132a:	48                   	dec    %eax
  80132b:	89 85 0c ff ff ff    	mov    %eax,-0xf4(%ebp)
		shortArr2[0] = minShort;
  801331:	8b 95 10 ff ff ff    	mov    -0xf0(%ebp),%edx
  801337:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80133a:	66 89 02             	mov    %ax,(%edx)
		shortArr2[lastIndexOfShort2] = maxShort;
  80133d:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
  801343:	01 c0                	add    %eax,%eax
  801345:	89 c2                	mov    %eax,%edx
  801347:	8b 85 10 ff ff ff    	mov    -0xf0(%ebp),%eax
  80134d:	01 c2                	add    %eax,%edx
  80134f:	66 8b 45 ca          	mov    -0x36(%ebp),%ax
  801353:	66 89 02             	mov    %ax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  801356:	8b 5d 8c             	mov    -0x74(%ebp),%ebx
  801359:	e8 9d 1a 00 00       	call   802dfb <sys_calculate_free_frames>
  80135e:	29 c3                	sub    %eax,%ebx
  801360:	89 d8                	mov    %ebx,%eax
  801362:	83 f8 02             	cmp    $0x2,%eax
  801365:	74 17                	je     80137e <_main+0x1346>
  801367:	83 ec 04             	sub    $0x4,%esp
  80136a:	68 b4 49 80 00       	push   $0x8049b4
  80136f:	68 18 01 00 00       	push   $0x118
  801374:	68 c1 48 80 00       	push   $0x8048c1
  801379:	e8 3b 02 00 00       	call   8015b9 <_panic>
		found = 0;
  80137e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  801385:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80138c:	e9 a7 00 00 00       	jmp    801438 <_main+0x1400>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
  801391:	a1 20 60 80 00       	mov    0x806020,%eax
  801396:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  80139c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80139f:	89 d0                	mov    %edx,%eax
  8013a1:	01 c0                	add    %eax,%eax
  8013a3:	01 d0                	add    %edx,%eax
  8013a5:	c1 e0 03             	shl    $0x3,%eax
  8013a8:	01 c8                	add    %ecx,%eax
  8013aa:	8b 00                	mov    (%eax),%eax
  8013ac:	89 85 08 ff ff ff    	mov    %eax,-0xf8(%ebp)
  8013b2:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
  8013b8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013bd:	89 c2                	mov    %eax,%edx
  8013bf:	8b 85 10 ff ff ff    	mov    -0xf0(%ebp),%eax
  8013c5:	89 85 04 ff ff ff    	mov    %eax,-0xfc(%ebp)
  8013cb:	8b 85 04 ff ff ff    	mov    -0xfc(%ebp),%eax
  8013d1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013d6:	39 c2                	cmp    %eax,%edx
  8013d8:	75 03                	jne    8013dd <_main+0x13a5>
				found++;
  8013da:	ff 45 d8             	incl   -0x28(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE))
  8013dd:	a1 20 60 80 00       	mov    0x806020,%eax
  8013e2:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8013e8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013eb:	89 d0                	mov    %edx,%eax
  8013ed:	01 c0                	add    %eax,%eax
  8013ef:	01 d0                	add    %edx,%eax
  8013f1:	c1 e0 03             	shl    $0x3,%eax
  8013f4:	01 c8                	add    %ecx,%eax
  8013f6:	8b 00                	mov    (%eax),%eax
  8013f8:	89 85 00 ff ff ff    	mov    %eax,-0x100(%ebp)
  8013fe:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
  801404:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801409:	89 c2                	mov    %eax,%edx
  80140b:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
  801411:	01 c0                	add    %eax,%eax
  801413:	89 c1                	mov    %eax,%ecx
  801415:	8b 85 10 ff ff ff    	mov    -0xf0(%ebp),%eax
  80141b:	01 c8                	add    %ecx,%eax
  80141d:	89 85 fc fe ff ff    	mov    %eax,-0x104(%ebp)
  801423:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
  801429:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80142e:	39 c2                	cmp    %eax,%edx
  801430:	75 03                	jne    801435 <_main+0x13fd>
				found++;
  801432:	ff 45 d8             	incl   -0x28(%ebp)
		lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
		shortArr2[0] = minShort;
		shortArr2[lastIndexOfShort2] = maxShort;
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  801435:	ff 45 e4             	incl   -0x1c(%ebp)
  801438:	a1 20 60 80 00       	mov    0x806020,%eax
  80143d:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801443:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801446:	39 c2                	cmp    %eax,%edx
  801448:	0f 87 43 ff ff ff    	ja     801391 <_main+0x1359>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  80144e:	83 7d d8 02          	cmpl   $0x2,-0x28(%ebp)
  801452:	74 17                	je     80146b <_main+0x1433>
  801454:	83 ec 04             	sub    $0x4,%esp
  801457:	68 f8 49 80 00       	push   $0x8049f8
  80145c:	68 21 01 00 00       	push   $0x121
  801461:	68 c1 48 80 00       	push   $0x8048c1
  801466:	e8 4e 01 00 00       	call   8015b9 <_panic>
		if(start_freeFrames != (sys_calculate_free_frames() + 4)) {panic("Wrong free: not all pages removed correctly at end");}
	}

	cprintf("Congratulations!! test free [1] completed successfully.\n");
	 */
	return;
  80146b:	90                   	nop
}
  80146c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80146f:	5b                   	pop    %ebx
  801470:	5e                   	pop    %esi
  801471:	5f                   	pop    %edi
  801472:	5d                   	pop    %ebp
  801473:	c3                   	ret    

00801474 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  801474:	55                   	push   %ebp
  801475:	89 e5                	mov    %esp,%ebp
  801477:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80147a:	e8 45 1b 00 00       	call   802fc4 <sys_getenvindex>
  80147f:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  801482:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801485:	89 d0                	mov    %edx,%eax
  801487:	c1 e0 02             	shl    $0x2,%eax
  80148a:	01 d0                	add    %edx,%eax
  80148c:	c1 e0 03             	shl    $0x3,%eax
  80148f:	01 d0                	add    %edx,%eax
  801491:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  801498:	01 d0                	add    %edx,%eax
  80149a:	c1 e0 02             	shl    $0x2,%eax
  80149d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8014a2:	a3 20 60 80 00       	mov    %eax,0x806020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8014a7:	a1 20 60 80 00       	mov    0x806020,%eax
  8014ac:	8a 40 20             	mov    0x20(%eax),%al
  8014af:	84 c0                	test   %al,%al
  8014b1:	74 0d                	je     8014c0 <libmain+0x4c>
		binaryname = myEnv->prog_name;
  8014b3:	a1 20 60 80 00       	mov    0x806020,%eax
  8014b8:	83 c0 20             	add    $0x20,%eax
  8014bb:	a3 04 60 80 00       	mov    %eax,0x806004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8014c0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014c4:	7e 0a                	jle    8014d0 <libmain+0x5c>
		binaryname = argv[0];
  8014c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c9:	8b 00                	mov    (%eax),%eax
  8014cb:	a3 04 60 80 00       	mov    %eax,0x806004

	// call user main routine
	_main(argc, argv);
  8014d0:	83 ec 08             	sub    $0x8,%esp
  8014d3:	ff 75 0c             	pushl  0xc(%ebp)
  8014d6:	ff 75 08             	pushl  0x8(%ebp)
  8014d9:	e8 5a eb ff ff       	call   800038 <_main>
  8014de:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8014e1:	a1 00 60 80 00       	mov    0x806000,%eax
  8014e6:	85 c0                	test   %eax,%eax
  8014e8:	0f 84 9f 00 00 00    	je     80158d <libmain+0x119>
	{
		sys_lock_cons();
  8014ee:	e8 55 18 00 00       	call   802d48 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8014f3:	83 ec 0c             	sub    $0xc,%esp
  8014f6:	68 1c 4b 80 00       	push   $0x804b1c
  8014fb:	e8 76 03 00 00       	call   801876 <cprintf>
  801500:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  801503:	a1 20 60 80 00       	mov    0x806020,%eax
  801508:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  80150e:	a1 20 60 80 00       	mov    0x806020,%eax
  801513:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  801519:	83 ec 04             	sub    $0x4,%esp
  80151c:	52                   	push   %edx
  80151d:	50                   	push   %eax
  80151e:	68 44 4b 80 00       	push   $0x804b44
  801523:	e8 4e 03 00 00       	call   801876 <cprintf>
  801528:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80152b:	a1 20 60 80 00       	mov    0x806020,%eax
  801530:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  801536:	a1 20 60 80 00       	mov    0x806020,%eax
  80153b:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  801541:	a1 20 60 80 00       	mov    0x806020,%eax
  801546:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  80154c:	51                   	push   %ecx
  80154d:	52                   	push   %edx
  80154e:	50                   	push   %eax
  80154f:	68 6c 4b 80 00       	push   $0x804b6c
  801554:	e8 1d 03 00 00       	call   801876 <cprintf>
  801559:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80155c:	a1 20 60 80 00       	mov    0x806020,%eax
  801561:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  801567:	83 ec 08             	sub    $0x8,%esp
  80156a:	50                   	push   %eax
  80156b:	68 c4 4b 80 00       	push   $0x804bc4
  801570:	e8 01 03 00 00       	call   801876 <cprintf>
  801575:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  801578:	83 ec 0c             	sub    $0xc,%esp
  80157b:	68 1c 4b 80 00       	push   $0x804b1c
  801580:	e8 f1 02 00 00       	call   801876 <cprintf>
  801585:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  801588:	e8 d5 17 00 00       	call   802d62 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80158d:	e8 19 00 00 00       	call   8015ab <exit>
}
  801592:	90                   	nop
  801593:	c9                   	leave  
  801594:	c3                   	ret    

00801595 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  801595:	55                   	push   %ebp
  801596:	89 e5                	mov    %esp,%ebp
  801598:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80159b:	83 ec 0c             	sub    $0xc,%esp
  80159e:	6a 00                	push   $0x0
  8015a0:	e8 eb 19 00 00       	call   802f90 <sys_destroy_env>
  8015a5:	83 c4 10             	add    $0x10,%esp
}
  8015a8:	90                   	nop
  8015a9:	c9                   	leave  
  8015aa:	c3                   	ret    

008015ab <exit>:

void
exit(void)
{
  8015ab:	55                   	push   %ebp
  8015ac:	89 e5                	mov    %esp,%ebp
  8015ae:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8015b1:	e8 40 1a 00 00       	call   802ff6 <sys_exit_env>
}
  8015b6:	90                   	nop
  8015b7:	c9                   	leave  
  8015b8:	c3                   	ret    

008015b9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8015b9:	55                   	push   %ebp
  8015ba:	89 e5                	mov    %esp,%ebp
  8015bc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8015bf:	8d 45 10             	lea    0x10(%ebp),%eax
  8015c2:	83 c0 04             	add    $0x4,%eax
  8015c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8015c8:	a1 60 60 98 00       	mov    0x986060,%eax
  8015cd:	85 c0                	test   %eax,%eax
  8015cf:	74 16                	je     8015e7 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8015d1:	a1 60 60 98 00       	mov    0x986060,%eax
  8015d6:	83 ec 08             	sub    $0x8,%esp
  8015d9:	50                   	push   %eax
  8015da:	68 d8 4b 80 00       	push   $0x804bd8
  8015df:	e8 92 02 00 00       	call   801876 <cprintf>
  8015e4:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8015e7:	a1 04 60 80 00       	mov    0x806004,%eax
  8015ec:	ff 75 0c             	pushl  0xc(%ebp)
  8015ef:	ff 75 08             	pushl  0x8(%ebp)
  8015f2:	50                   	push   %eax
  8015f3:	68 dd 4b 80 00       	push   $0x804bdd
  8015f8:	e8 79 02 00 00       	call   801876 <cprintf>
  8015fd:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801600:	8b 45 10             	mov    0x10(%ebp),%eax
  801603:	83 ec 08             	sub    $0x8,%esp
  801606:	ff 75 f4             	pushl  -0xc(%ebp)
  801609:	50                   	push   %eax
  80160a:	e8 fc 01 00 00       	call   80180b <vcprintf>
  80160f:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801612:	83 ec 08             	sub    $0x8,%esp
  801615:	6a 00                	push   $0x0
  801617:	68 f9 4b 80 00       	push   $0x804bf9
  80161c:	e8 ea 01 00 00       	call   80180b <vcprintf>
  801621:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801624:	e8 82 ff ff ff       	call   8015ab <exit>

	// should not return here
	while (1) ;
  801629:	eb fe                	jmp    801629 <_panic+0x70>

0080162b <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80162b:	55                   	push   %ebp
  80162c:	89 e5                	mov    %esp,%ebp
  80162e:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801631:	a1 20 60 80 00       	mov    0x806020,%eax
  801636:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80163c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80163f:	39 c2                	cmp    %eax,%edx
  801641:	74 14                	je     801657 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801643:	83 ec 04             	sub    $0x4,%esp
  801646:	68 fc 4b 80 00       	push   $0x804bfc
  80164b:	6a 26                	push   $0x26
  80164d:	68 48 4c 80 00       	push   $0x804c48
  801652:	e8 62 ff ff ff       	call   8015b9 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801657:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80165e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801665:	e9 c5 00 00 00       	jmp    80172f <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80166a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80166d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801674:	8b 45 08             	mov    0x8(%ebp),%eax
  801677:	01 d0                	add    %edx,%eax
  801679:	8b 00                	mov    (%eax),%eax
  80167b:	85 c0                	test   %eax,%eax
  80167d:	75 08                	jne    801687 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80167f:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801682:	e9 a5 00 00 00       	jmp    80172c <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801687:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80168e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801695:	eb 69                	jmp    801700 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801697:	a1 20 60 80 00       	mov    0x806020,%eax
  80169c:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8016a2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8016a5:	89 d0                	mov    %edx,%eax
  8016a7:	01 c0                	add    %eax,%eax
  8016a9:	01 d0                	add    %edx,%eax
  8016ab:	c1 e0 03             	shl    $0x3,%eax
  8016ae:	01 c8                	add    %ecx,%eax
  8016b0:	8a 40 04             	mov    0x4(%eax),%al
  8016b3:	84 c0                	test   %al,%al
  8016b5:	75 46                	jne    8016fd <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8016b7:	a1 20 60 80 00       	mov    0x806020,%eax
  8016bc:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8016c2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8016c5:	89 d0                	mov    %edx,%eax
  8016c7:	01 c0                	add    %eax,%eax
  8016c9:	01 d0                	add    %edx,%eax
  8016cb:	c1 e0 03             	shl    $0x3,%eax
  8016ce:	01 c8                	add    %ecx,%eax
  8016d0:	8b 00                	mov    (%eax),%eax
  8016d2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8016d5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016d8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016dd:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8016df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e2:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8016e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ec:	01 c8                	add    %ecx,%eax
  8016ee:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8016f0:	39 c2                	cmp    %eax,%edx
  8016f2:	75 09                	jne    8016fd <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8016f4:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8016fb:	eb 15                	jmp    801712 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8016fd:	ff 45 e8             	incl   -0x18(%ebp)
  801700:	a1 20 60 80 00       	mov    0x806020,%eax
  801705:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80170b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80170e:	39 c2                	cmp    %eax,%edx
  801710:	77 85                	ja     801697 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801712:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801716:	75 14                	jne    80172c <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801718:	83 ec 04             	sub    $0x4,%esp
  80171b:	68 54 4c 80 00       	push   $0x804c54
  801720:	6a 3a                	push   $0x3a
  801722:	68 48 4c 80 00       	push   $0x804c48
  801727:	e8 8d fe ff ff       	call   8015b9 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80172c:	ff 45 f0             	incl   -0x10(%ebp)
  80172f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801732:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801735:	0f 8c 2f ff ff ff    	jl     80166a <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80173b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801742:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801749:	eb 26                	jmp    801771 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80174b:	a1 20 60 80 00       	mov    0x806020,%eax
  801750:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  801756:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801759:	89 d0                	mov    %edx,%eax
  80175b:	01 c0                	add    %eax,%eax
  80175d:	01 d0                	add    %edx,%eax
  80175f:	c1 e0 03             	shl    $0x3,%eax
  801762:	01 c8                	add    %ecx,%eax
  801764:	8a 40 04             	mov    0x4(%eax),%al
  801767:	3c 01                	cmp    $0x1,%al
  801769:	75 03                	jne    80176e <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80176b:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80176e:	ff 45 e0             	incl   -0x20(%ebp)
  801771:	a1 20 60 80 00       	mov    0x806020,%eax
  801776:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80177c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80177f:	39 c2                	cmp    %eax,%edx
  801781:	77 c8                	ja     80174b <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801783:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801786:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801789:	74 14                	je     80179f <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80178b:	83 ec 04             	sub    $0x4,%esp
  80178e:	68 a8 4c 80 00       	push   $0x804ca8
  801793:	6a 44                	push   $0x44
  801795:	68 48 4c 80 00       	push   $0x804c48
  80179a:	e8 1a fe ff ff       	call   8015b9 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80179f:	90                   	nop
  8017a0:	c9                   	leave  
  8017a1:	c3                   	ret    

008017a2 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8017a2:	55                   	push   %ebp
  8017a3:	89 e5                	mov    %esp,%ebp
  8017a5:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8017a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ab:	8b 00                	mov    (%eax),%eax
  8017ad:	8d 48 01             	lea    0x1(%eax),%ecx
  8017b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b3:	89 0a                	mov    %ecx,(%edx)
  8017b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8017b8:	88 d1                	mov    %dl,%cl
  8017ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017bd:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8017c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c4:	8b 00                	mov    (%eax),%eax
  8017c6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8017cb:	75 2c                	jne    8017f9 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8017cd:	a0 44 60 98 00       	mov    0x986044,%al
  8017d2:	0f b6 c0             	movzbl %al,%eax
  8017d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017d8:	8b 12                	mov    (%edx),%edx
  8017da:	89 d1                	mov    %edx,%ecx
  8017dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017df:	83 c2 08             	add    $0x8,%edx
  8017e2:	83 ec 04             	sub    $0x4,%esp
  8017e5:	50                   	push   %eax
  8017e6:	51                   	push   %ecx
  8017e7:	52                   	push   %edx
  8017e8:	e8 19 15 00 00       	call   802d06 <sys_cputs>
  8017ed:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8017f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8017f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017fc:	8b 40 04             	mov    0x4(%eax),%eax
  8017ff:	8d 50 01             	lea    0x1(%eax),%edx
  801802:	8b 45 0c             	mov    0xc(%ebp),%eax
  801805:	89 50 04             	mov    %edx,0x4(%eax)
}
  801808:	90                   	nop
  801809:	c9                   	leave  
  80180a:	c3                   	ret    

0080180b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80180b:	55                   	push   %ebp
  80180c:	89 e5                	mov    %esp,%ebp
  80180e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801814:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80181b:	00 00 00 
	b.cnt = 0;
  80181e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801825:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801828:	ff 75 0c             	pushl  0xc(%ebp)
  80182b:	ff 75 08             	pushl  0x8(%ebp)
  80182e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801834:	50                   	push   %eax
  801835:	68 a2 17 80 00       	push   $0x8017a2
  80183a:	e8 11 02 00 00       	call   801a50 <vprintfmt>
  80183f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  801842:	a0 44 60 98 00       	mov    0x986044,%al
  801847:	0f b6 c0             	movzbl %al,%eax
  80184a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  801850:	83 ec 04             	sub    $0x4,%esp
  801853:	50                   	push   %eax
  801854:	52                   	push   %edx
  801855:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80185b:	83 c0 08             	add    $0x8,%eax
  80185e:	50                   	push   %eax
  80185f:	e8 a2 14 00 00       	call   802d06 <sys_cputs>
  801864:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801867:	c6 05 44 60 98 00 00 	movb   $0x0,0x986044
	return b.cnt;
  80186e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801874:	c9                   	leave  
  801875:	c3                   	ret    

00801876 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  801876:	55                   	push   %ebp
  801877:	89 e5                	mov    %esp,%ebp
  801879:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80187c:	c6 05 44 60 98 00 01 	movb   $0x1,0x986044
	va_start(ap, fmt);
  801883:	8d 45 0c             	lea    0xc(%ebp),%eax
  801886:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801889:	8b 45 08             	mov    0x8(%ebp),%eax
  80188c:	83 ec 08             	sub    $0x8,%esp
  80188f:	ff 75 f4             	pushl  -0xc(%ebp)
  801892:	50                   	push   %eax
  801893:	e8 73 ff ff ff       	call   80180b <vcprintf>
  801898:	83 c4 10             	add    $0x10,%esp
  80189b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80189e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018a1:	c9                   	leave  
  8018a2:	c3                   	ret    

008018a3 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8018a3:	55                   	push   %ebp
  8018a4:	89 e5                	mov    %esp,%ebp
  8018a6:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8018a9:	e8 9a 14 00 00       	call   802d48 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8018ae:	8d 45 0c             	lea    0xc(%ebp),%eax
  8018b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8018b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b7:	83 ec 08             	sub    $0x8,%esp
  8018ba:	ff 75 f4             	pushl  -0xc(%ebp)
  8018bd:	50                   	push   %eax
  8018be:	e8 48 ff ff ff       	call   80180b <vcprintf>
  8018c3:	83 c4 10             	add    $0x10,%esp
  8018c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8018c9:	e8 94 14 00 00       	call   802d62 <sys_unlock_cons>
	return cnt;
  8018ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018d1:	c9                   	leave  
  8018d2:	c3                   	ret    

008018d3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8018d3:	55                   	push   %ebp
  8018d4:	89 e5                	mov    %esp,%ebp
  8018d6:	53                   	push   %ebx
  8018d7:	83 ec 14             	sub    $0x14,%esp
  8018da:	8b 45 10             	mov    0x10(%ebp),%eax
  8018dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8018e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8018e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8018e6:	8b 45 18             	mov    0x18(%ebp),%eax
  8018e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ee:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8018f1:	77 55                	ja     801948 <printnum+0x75>
  8018f3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8018f6:	72 05                	jb     8018fd <printnum+0x2a>
  8018f8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018fb:	77 4b                	ja     801948 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8018fd:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801900:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801903:	8b 45 18             	mov    0x18(%ebp),%eax
  801906:	ba 00 00 00 00       	mov    $0x0,%edx
  80190b:	52                   	push   %edx
  80190c:	50                   	push   %eax
  80190d:	ff 75 f4             	pushl  -0xc(%ebp)
  801910:	ff 75 f0             	pushl  -0x10(%ebp)
  801913:	e8 f0 2c 00 00       	call   804608 <__udivdi3>
  801918:	83 c4 10             	add    $0x10,%esp
  80191b:	83 ec 04             	sub    $0x4,%esp
  80191e:	ff 75 20             	pushl  0x20(%ebp)
  801921:	53                   	push   %ebx
  801922:	ff 75 18             	pushl  0x18(%ebp)
  801925:	52                   	push   %edx
  801926:	50                   	push   %eax
  801927:	ff 75 0c             	pushl  0xc(%ebp)
  80192a:	ff 75 08             	pushl  0x8(%ebp)
  80192d:	e8 a1 ff ff ff       	call   8018d3 <printnum>
  801932:	83 c4 20             	add    $0x20,%esp
  801935:	eb 1a                	jmp    801951 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801937:	83 ec 08             	sub    $0x8,%esp
  80193a:	ff 75 0c             	pushl  0xc(%ebp)
  80193d:	ff 75 20             	pushl  0x20(%ebp)
  801940:	8b 45 08             	mov    0x8(%ebp),%eax
  801943:	ff d0                	call   *%eax
  801945:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801948:	ff 4d 1c             	decl   0x1c(%ebp)
  80194b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80194f:	7f e6                	jg     801937 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801951:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801954:	bb 00 00 00 00       	mov    $0x0,%ebx
  801959:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80195c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80195f:	53                   	push   %ebx
  801960:	51                   	push   %ecx
  801961:	52                   	push   %edx
  801962:	50                   	push   %eax
  801963:	e8 b0 2d 00 00       	call   804718 <__umoddi3>
  801968:	83 c4 10             	add    $0x10,%esp
  80196b:	05 14 4f 80 00       	add    $0x804f14,%eax
  801970:	8a 00                	mov    (%eax),%al
  801972:	0f be c0             	movsbl %al,%eax
  801975:	83 ec 08             	sub    $0x8,%esp
  801978:	ff 75 0c             	pushl  0xc(%ebp)
  80197b:	50                   	push   %eax
  80197c:	8b 45 08             	mov    0x8(%ebp),%eax
  80197f:	ff d0                	call   *%eax
  801981:	83 c4 10             	add    $0x10,%esp
}
  801984:	90                   	nop
  801985:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801988:	c9                   	leave  
  801989:	c3                   	ret    

0080198a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80198a:	55                   	push   %ebp
  80198b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80198d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801991:	7e 1c                	jle    8019af <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801993:	8b 45 08             	mov    0x8(%ebp),%eax
  801996:	8b 00                	mov    (%eax),%eax
  801998:	8d 50 08             	lea    0x8(%eax),%edx
  80199b:	8b 45 08             	mov    0x8(%ebp),%eax
  80199e:	89 10                	mov    %edx,(%eax)
  8019a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a3:	8b 00                	mov    (%eax),%eax
  8019a5:	83 e8 08             	sub    $0x8,%eax
  8019a8:	8b 50 04             	mov    0x4(%eax),%edx
  8019ab:	8b 00                	mov    (%eax),%eax
  8019ad:	eb 40                	jmp    8019ef <getuint+0x65>
	else if (lflag)
  8019af:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8019b3:	74 1e                	je     8019d3 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8019b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b8:	8b 00                	mov    (%eax),%eax
  8019ba:	8d 50 04             	lea    0x4(%eax),%edx
  8019bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c0:	89 10                	mov    %edx,(%eax)
  8019c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c5:	8b 00                	mov    (%eax),%eax
  8019c7:	83 e8 04             	sub    $0x4,%eax
  8019ca:	8b 00                	mov    (%eax),%eax
  8019cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8019d1:	eb 1c                	jmp    8019ef <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8019d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d6:	8b 00                	mov    (%eax),%eax
  8019d8:	8d 50 04             	lea    0x4(%eax),%edx
  8019db:	8b 45 08             	mov    0x8(%ebp),%eax
  8019de:	89 10                	mov    %edx,(%eax)
  8019e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e3:	8b 00                	mov    (%eax),%eax
  8019e5:	83 e8 04             	sub    $0x4,%eax
  8019e8:	8b 00                	mov    (%eax),%eax
  8019ea:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8019ef:	5d                   	pop    %ebp
  8019f0:	c3                   	ret    

008019f1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8019f1:	55                   	push   %ebp
  8019f2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8019f4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8019f8:	7e 1c                	jle    801a16 <getint+0x25>
		return va_arg(*ap, long long);
  8019fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fd:	8b 00                	mov    (%eax),%eax
  8019ff:	8d 50 08             	lea    0x8(%eax),%edx
  801a02:	8b 45 08             	mov    0x8(%ebp),%eax
  801a05:	89 10                	mov    %edx,(%eax)
  801a07:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0a:	8b 00                	mov    (%eax),%eax
  801a0c:	83 e8 08             	sub    $0x8,%eax
  801a0f:	8b 50 04             	mov    0x4(%eax),%edx
  801a12:	8b 00                	mov    (%eax),%eax
  801a14:	eb 38                	jmp    801a4e <getint+0x5d>
	else if (lflag)
  801a16:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a1a:	74 1a                	je     801a36 <getint+0x45>
		return va_arg(*ap, long);
  801a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1f:	8b 00                	mov    (%eax),%eax
  801a21:	8d 50 04             	lea    0x4(%eax),%edx
  801a24:	8b 45 08             	mov    0x8(%ebp),%eax
  801a27:	89 10                	mov    %edx,(%eax)
  801a29:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2c:	8b 00                	mov    (%eax),%eax
  801a2e:	83 e8 04             	sub    $0x4,%eax
  801a31:	8b 00                	mov    (%eax),%eax
  801a33:	99                   	cltd   
  801a34:	eb 18                	jmp    801a4e <getint+0x5d>
	else
		return va_arg(*ap, int);
  801a36:	8b 45 08             	mov    0x8(%ebp),%eax
  801a39:	8b 00                	mov    (%eax),%eax
  801a3b:	8d 50 04             	lea    0x4(%eax),%edx
  801a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a41:	89 10                	mov    %edx,(%eax)
  801a43:	8b 45 08             	mov    0x8(%ebp),%eax
  801a46:	8b 00                	mov    (%eax),%eax
  801a48:	83 e8 04             	sub    $0x4,%eax
  801a4b:	8b 00                	mov    (%eax),%eax
  801a4d:	99                   	cltd   
}
  801a4e:	5d                   	pop    %ebp
  801a4f:	c3                   	ret    

00801a50 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801a50:	55                   	push   %ebp
  801a51:	89 e5                	mov    %esp,%ebp
  801a53:	56                   	push   %esi
  801a54:	53                   	push   %ebx
  801a55:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801a58:	eb 17                	jmp    801a71 <vprintfmt+0x21>
			if (ch == '\0')
  801a5a:	85 db                	test   %ebx,%ebx
  801a5c:	0f 84 c1 03 00 00    	je     801e23 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  801a62:	83 ec 08             	sub    $0x8,%esp
  801a65:	ff 75 0c             	pushl  0xc(%ebp)
  801a68:	53                   	push   %ebx
  801a69:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6c:	ff d0                	call   *%eax
  801a6e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801a71:	8b 45 10             	mov    0x10(%ebp),%eax
  801a74:	8d 50 01             	lea    0x1(%eax),%edx
  801a77:	89 55 10             	mov    %edx,0x10(%ebp)
  801a7a:	8a 00                	mov    (%eax),%al
  801a7c:	0f b6 d8             	movzbl %al,%ebx
  801a7f:	83 fb 25             	cmp    $0x25,%ebx
  801a82:	75 d6                	jne    801a5a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801a84:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801a88:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801a8f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801a96:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801a9d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801aa4:	8b 45 10             	mov    0x10(%ebp),%eax
  801aa7:	8d 50 01             	lea    0x1(%eax),%edx
  801aaa:	89 55 10             	mov    %edx,0x10(%ebp)
  801aad:	8a 00                	mov    (%eax),%al
  801aaf:	0f b6 d8             	movzbl %al,%ebx
  801ab2:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801ab5:	83 f8 5b             	cmp    $0x5b,%eax
  801ab8:	0f 87 3d 03 00 00    	ja     801dfb <vprintfmt+0x3ab>
  801abe:	8b 04 85 38 4f 80 00 	mov    0x804f38(,%eax,4),%eax
  801ac5:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801ac7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801acb:	eb d7                	jmp    801aa4 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801acd:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801ad1:	eb d1                	jmp    801aa4 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801ad3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801ada:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801add:	89 d0                	mov    %edx,%eax
  801adf:	c1 e0 02             	shl    $0x2,%eax
  801ae2:	01 d0                	add    %edx,%eax
  801ae4:	01 c0                	add    %eax,%eax
  801ae6:	01 d8                	add    %ebx,%eax
  801ae8:	83 e8 30             	sub    $0x30,%eax
  801aeb:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801aee:	8b 45 10             	mov    0x10(%ebp),%eax
  801af1:	8a 00                	mov    (%eax),%al
  801af3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801af6:	83 fb 2f             	cmp    $0x2f,%ebx
  801af9:	7e 3e                	jle    801b39 <vprintfmt+0xe9>
  801afb:	83 fb 39             	cmp    $0x39,%ebx
  801afe:	7f 39                	jg     801b39 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801b00:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801b03:	eb d5                	jmp    801ada <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801b05:	8b 45 14             	mov    0x14(%ebp),%eax
  801b08:	83 c0 04             	add    $0x4,%eax
  801b0b:	89 45 14             	mov    %eax,0x14(%ebp)
  801b0e:	8b 45 14             	mov    0x14(%ebp),%eax
  801b11:	83 e8 04             	sub    $0x4,%eax
  801b14:	8b 00                	mov    (%eax),%eax
  801b16:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801b19:	eb 1f                	jmp    801b3a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801b1b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b1f:	79 83                	jns    801aa4 <vprintfmt+0x54>
				width = 0;
  801b21:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801b28:	e9 77 ff ff ff       	jmp    801aa4 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801b2d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801b34:	e9 6b ff ff ff       	jmp    801aa4 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801b39:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801b3a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b3e:	0f 89 60 ff ff ff    	jns    801aa4 <vprintfmt+0x54>
				width = precision, precision = -1;
  801b44:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b47:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b4a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801b51:	e9 4e ff ff ff       	jmp    801aa4 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801b56:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801b59:	e9 46 ff ff ff       	jmp    801aa4 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801b5e:	8b 45 14             	mov    0x14(%ebp),%eax
  801b61:	83 c0 04             	add    $0x4,%eax
  801b64:	89 45 14             	mov    %eax,0x14(%ebp)
  801b67:	8b 45 14             	mov    0x14(%ebp),%eax
  801b6a:	83 e8 04             	sub    $0x4,%eax
  801b6d:	8b 00                	mov    (%eax),%eax
  801b6f:	83 ec 08             	sub    $0x8,%esp
  801b72:	ff 75 0c             	pushl  0xc(%ebp)
  801b75:	50                   	push   %eax
  801b76:	8b 45 08             	mov    0x8(%ebp),%eax
  801b79:	ff d0                	call   *%eax
  801b7b:	83 c4 10             	add    $0x10,%esp
			break;
  801b7e:	e9 9b 02 00 00       	jmp    801e1e <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801b83:	8b 45 14             	mov    0x14(%ebp),%eax
  801b86:	83 c0 04             	add    $0x4,%eax
  801b89:	89 45 14             	mov    %eax,0x14(%ebp)
  801b8c:	8b 45 14             	mov    0x14(%ebp),%eax
  801b8f:	83 e8 04             	sub    $0x4,%eax
  801b92:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801b94:	85 db                	test   %ebx,%ebx
  801b96:	79 02                	jns    801b9a <vprintfmt+0x14a>
				err = -err;
  801b98:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801b9a:	83 fb 64             	cmp    $0x64,%ebx
  801b9d:	7f 0b                	jg     801baa <vprintfmt+0x15a>
  801b9f:	8b 34 9d 80 4d 80 00 	mov    0x804d80(,%ebx,4),%esi
  801ba6:	85 f6                	test   %esi,%esi
  801ba8:	75 19                	jne    801bc3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801baa:	53                   	push   %ebx
  801bab:	68 25 4f 80 00       	push   $0x804f25
  801bb0:	ff 75 0c             	pushl  0xc(%ebp)
  801bb3:	ff 75 08             	pushl  0x8(%ebp)
  801bb6:	e8 70 02 00 00       	call   801e2b <printfmt>
  801bbb:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801bbe:	e9 5b 02 00 00       	jmp    801e1e <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801bc3:	56                   	push   %esi
  801bc4:	68 2e 4f 80 00       	push   $0x804f2e
  801bc9:	ff 75 0c             	pushl  0xc(%ebp)
  801bcc:	ff 75 08             	pushl  0x8(%ebp)
  801bcf:	e8 57 02 00 00       	call   801e2b <printfmt>
  801bd4:	83 c4 10             	add    $0x10,%esp
			break;
  801bd7:	e9 42 02 00 00       	jmp    801e1e <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801bdc:	8b 45 14             	mov    0x14(%ebp),%eax
  801bdf:	83 c0 04             	add    $0x4,%eax
  801be2:	89 45 14             	mov    %eax,0x14(%ebp)
  801be5:	8b 45 14             	mov    0x14(%ebp),%eax
  801be8:	83 e8 04             	sub    $0x4,%eax
  801beb:	8b 30                	mov    (%eax),%esi
  801bed:	85 f6                	test   %esi,%esi
  801bef:	75 05                	jne    801bf6 <vprintfmt+0x1a6>
				p = "(null)";
  801bf1:	be 31 4f 80 00       	mov    $0x804f31,%esi
			if (width > 0 && padc != '-')
  801bf6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801bfa:	7e 6d                	jle    801c69 <vprintfmt+0x219>
  801bfc:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801c00:	74 67                	je     801c69 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801c02:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c05:	83 ec 08             	sub    $0x8,%esp
  801c08:	50                   	push   %eax
  801c09:	56                   	push   %esi
  801c0a:	e8 1e 03 00 00       	call   801f2d <strnlen>
  801c0f:	83 c4 10             	add    $0x10,%esp
  801c12:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801c15:	eb 16                	jmp    801c2d <vprintfmt+0x1dd>
					putch(padc, putdat);
  801c17:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801c1b:	83 ec 08             	sub    $0x8,%esp
  801c1e:	ff 75 0c             	pushl  0xc(%ebp)
  801c21:	50                   	push   %eax
  801c22:	8b 45 08             	mov    0x8(%ebp),%eax
  801c25:	ff d0                	call   *%eax
  801c27:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801c2a:	ff 4d e4             	decl   -0x1c(%ebp)
  801c2d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801c31:	7f e4                	jg     801c17 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801c33:	eb 34                	jmp    801c69 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801c35:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801c39:	74 1c                	je     801c57 <vprintfmt+0x207>
  801c3b:	83 fb 1f             	cmp    $0x1f,%ebx
  801c3e:	7e 05                	jle    801c45 <vprintfmt+0x1f5>
  801c40:	83 fb 7e             	cmp    $0x7e,%ebx
  801c43:	7e 12                	jle    801c57 <vprintfmt+0x207>
					putch('?', putdat);
  801c45:	83 ec 08             	sub    $0x8,%esp
  801c48:	ff 75 0c             	pushl  0xc(%ebp)
  801c4b:	6a 3f                	push   $0x3f
  801c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c50:	ff d0                	call   *%eax
  801c52:	83 c4 10             	add    $0x10,%esp
  801c55:	eb 0f                	jmp    801c66 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801c57:	83 ec 08             	sub    $0x8,%esp
  801c5a:	ff 75 0c             	pushl  0xc(%ebp)
  801c5d:	53                   	push   %ebx
  801c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c61:	ff d0                	call   *%eax
  801c63:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801c66:	ff 4d e4             	decl   -0x1c(%ebp)
  801c69:	89 f0                	mov    %esi,%eax
  801c6b:	8d 70 01             	lea    0x1(%eax),%esi
  801c6e:	8a 00                	mov    (%eax),%al
  801c70:	0f be d8             	movsbl %al,%ebx
  801c73:	85 db                	test   %ebx,%ebx
  801c75:	74 24                	je     801c9b <vprintfmt+0x24b>
  801c77:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c7b:	78 b8                	js     801c35 <vprintfmt+0x1e5>
  801c7d:	ff 4d e0             	decl   -0x20(%ebp)
  801c80:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c84:	79 af                	jns    801c35 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801c86:	eb 13                	jmp    801c9b <vprintfmt+0x24b>
				putch(' ', putdat);
  801c88:	83 ec 08             	sub    $0x8,%esp
  801c8b:	ff 75 0c             	pushl  0xc(%ebp)
  801c8e:	6a 20                	push   $0x20
  801c90:	8b 45 08             	mov    0x8(%ebp),%eax
  801c93:	ff d0                	call   *%eax
  801c95:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801c98:	ff 4d e4             	decl   -0x1c(%ebp)
  801c9b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801c9f:	7f e7                	jg     801c88 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801ca1:	e9 78 01 00 00       	jmp    801e1e <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801ca6:	83 ec 08             	sub    $0x8,%esp
  801ca9:	ff 75 e8             	pushl  -0x18(%ebp)
  801cac:	8d 45 14             	lea    0x14(%ebp),%eax
  801caf:	50                   	push   %eax
  801cb0:	e8 3c fd ff ff       	call   8019f1 <getint>
  801cb5:	83 c4 10             	add    $0x10,%esp
  801cb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801cbb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801cbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cc1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cc4:	85 d2                	test   %edx,%edx
  801cc6:	79 23                	jns    801ceb <vprintfmt+0x29b>
				putch('-', putdat);
  801cc8:	83 ec 08             	sub    $0x8,%esp
  801ccb:	ff 75 0c             	pushl  0xc(%ebp)
  801cce:	6a 2d                	push   $0x2d
  801cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd3:	ff d0                	call   *%eax
  801cd5:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801cd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cdb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cde:	f7 d8                	neg    %eax
  801ce0:	83 d2 00             	adc    $0x0,%edx
  801ce3:	f7 da                	neg    %edx
  801ce5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ce8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801ceb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801cf2:	e9 bc 00 00 00       	jmp    801db3 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801cf7:	83 ec 08             	sub    $0x8,%esp
  801cfa:	ff 75 e8             	pushl  -0x18(%ebp)
  801cfd:	8d 45 14             	lea    0x14(%ebp),%eax
  801d00:	50                   	push   %eax
  801d01:	e8 84 fc ff ff       	call   80198a <getuint>
  801d06:	83 c4 10             	add    $0x10,%esp
  801d09:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d0c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801d0f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801d16:	e9 98 00 00 00       	jmp    801db3 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801d1b:	83 ec 08             	sub    $0x8,%esp
  801d1e:	ff 75 0c             	pushl  0xc(%ebp)
  801d21:	6a 58                	push   $0x58
  801d23:	8b 45 08             	mov    0x8(%ebp),%eax
  801d26:	ff d0                	call   *%eax
  801d28:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801d2b:	83 ec 08             	sub    $0x8,%esp
  801d2e:	ff 75 0c             	pushl  0xc(%ebp)
  801d31:	6a 58                	push   $0x58
  801d33:	8b 45 08             	mov    0x8(%ebp),%eax
  801d36:	ff d0                	call   *%eax
  801d38:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801d3b:	83 ec 08             	sub    $0x8,%esp
  801d3e:	ff 75 0c             	pushl  0xc(%ebp)
  801d41:	6a 58                	push   $0x58
  801d43:	8b 45 08             	mov    0x8(%ebp),%eax
  801d46:	ff d0                	call   *%eax
  801d48:	83 c4 10             	add    $0x10,%esp
			break;
  801d4b:	e9 ce 00 00 00       	jmp    801e1e <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801d50:	83 ec 08             	sub    $0x8,%esp
  801d53:	ff 75 0c             	pushl  0xc(%ebp)
  801d56:	6a 30                	push   $0x30
  801d58:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5b:	ff d0                	call   *%eax
  801d5d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801d60:	83 ec 08             	sub    $0x8,%esp
  801d63:	ff 75 0c             	pushl  0xc(%ebp)
  801d66:	6a 78                	push   $0x78
  801d68:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6b:	ff d0                	call   *%eax
  801d6d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801d70:	8b 45 14             	mov    0x14(%ebp),%eax
  801d73:	83 c0 04             	add    $0x4,%eax
  801d76:	89 45 14             	mov    %eax,0x14(%ebp)
  801d79:	8b 45 14             	mov    0x14(%ebp),%eax
  801d7c:	83 e8 04             	sub    $0x4,%eax
  801d7f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801d81:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d84:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801d8b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801d92:	eb 1f                	jmp    801db3 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801d94:	83 ec 08             	sub    $0x8,%esp
  801d97:	ff 75 e8             	pushl  -0x18(%ebp)
  801d9a:	8d 45 14             	lea    0x14(%ebp),%eax
  801d9d:	50                   	push   %eax
  801d9e:	e8 e7 fb ff ff       	call   80198a <getuint>
  801da3:	83 c4 10             	add    $0x10,%esp
  801da6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801da9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801dac:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801db3:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801db7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dba:	83 ec 04             	sub    $0x4,%esp
  801dbd:	52                   	push   %edx
  801dbe:	ff 75 e4             	pushl  -0x1c(%ebp)
  801dc1:	50                   	push   %eax
  801dc2:	ff 75 f4             	pushl  -0xc(%ebp)
  801dc5:	ff 75 f0             	pushl  -0x10(%ebp)
  801dc8:	ff 75 0c             	pushl  0xc(%ebp)
  801dcb:	ff 75 08             	pushl  0x8(%ebp)
  801dce:	e8 00 fb ff ff       	call   8018d3 <printnum>
  801dd3:	83 c4 20             	add    $0x20,%esp
			break;
  801dd6:	eb 46                	jmp    801e1e <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801dd8:	83 ec 08             	sub    $0x8,%esp
  801ddb:	ff 75 0c             	pushl  0xc(%ebp)
  801dde:	53                   	push   %ebx
  801ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  801de2:	ff d0                	call   *%eax
  801de4:	83 c4 10             	add    $0x10,%esp
			break;
  801de7:	eb 35                	jmp    801e1e <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801de9:	c6 05 44 60 98 00 00 	movb   $0x0,0x986044
			break;
  801df0:	eb 2c                	jmp    801e1e <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801df2:	c6 05 44 60 98 00 01 	movb   $0x1,0x986044
			break;
  801df9:	eb 23                	jmp    801e1e <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801dfb:	83 ec 08             	sub    $0x8,%esp
  801dfe:	ff 75 0c             	pushl  0xc(%ebp)
  801e01:	6a 25                	push   $0x25
  801e03:	8b 45 08             	mov    0x8(%ebp),%eax
  801e06:	ff d0                	call   *%eax
  801e08:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801e0b:	ff 4d 10             	decl   0x10(%ebp)
  801e0e:	eb 03                	jmp    801e13 <vprintfmt+0x3c3>
  801e10:	ff 4d 10             	decl   0x10(%ebp)
  801e13:	8b 45 10             	mov    0x10(%ebp),%eax
  801e16:	48                   	dec    %eax
  801e17:	8a 00                	mov    (%eax),%al
  801e19:	3c 25                	cmp    $0x25,%al
  801e1b:	75 f3                	jne    801e10 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801e1d:	90                   	nop
		}
	}
  801e1e:	e9 35 fc ff ff       	jmp    801a58 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801e23:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801e24:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e27:	5b                   	pop    %ebx
  801e28:	5e                   	pop    %esi
  801e29:	5d                   	pop    %ebp
  801e2a:	c3                   	ret    

00801e2b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801e2b:	55                   	push   %ebp
  801e2c:	89 e5                	mov    %esp,%ebp
  801e2e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801e31:	8d 45 10             	lea    0x10(%ebp),%eax
  801e34:	83 c0 04             	add    $0x4,%eax
  801e37:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801e3a:	8b 45 10             	mov    0x10(%ebp),%eax
  801e3d:	ff 75 f4             	pushl  -0xc(%ebp)
  801e40:	50                   	push   %eax
  801e41:	ff 75 0c             	pushl  0xc(%ebp)
  801e44:	ff 75 08             	pushl  0x8(%ebp)
  801e47:	e8 04 fc ff ff       	call   801a50 <vprintfmt>
  801e4c:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801e4f:	90                   	nop
  801e50:	c9                   	leave  
  801e51:	c3                   	ret    

00801e52 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801e52:	55                   	push   %ebp
  801e53:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801e55:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e58:	8b 40 08             	mov    0x8(%eax),%eax
  801e5b:	8d 50 01             	lea    0x1(%eax),%edx
  801e5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e61:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801e64:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e67:	8b 10                	mov    (%eax),%edx
  801e69:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e6c:	8b 40 04             	mov    0x4(%eax),%eax
  801e6f:	39 c2                	cmp    %eax,%edx
  801e71:	73 12                	jae    801e85 <sprintputch+0x33>
		*b->buf++ = ch;
  801e73:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e76:	8b 00                	mov    (%eax),%eax
  801e78:	8d 48 01             	lea    0x1(%eax),%ecx
  801e7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e7e:	89 0a                	mov    %ecx,(%edx)
  801e80:	8b 55 08             	mov    0x8(%ebp),%edx
  801e83:	88 10                	mov    %dl,(%eax)
}
  801e85:	90                   	nop
  801e86:	5d                   	pop    %ebp
  801e87:	c3                   	ret    

00801e88 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801e88:	55                   	push   %ebp
  801e89:	89 e5                	mov    %esp,%ebp
  801e8b:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e91:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801e94:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e97:	8d 50 ff             	lea    -0x1(%eax),%edx
  801e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9d:	01 d0                	add    %edx,%eax
  801e9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ea2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801ea9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ead:	74 06                	je     801eb5 <vsnprintf+0x2d>
  801eaf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801eb3:	7f 07                	jg     801ebc <vsnprintf+0x34>
		return -E_INVAL;
  801eb5:	b8 03 00 00 00       	mov    $0x3,%eax
  801eba:	eb 20                	jmp    801edc <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801ebc:	ff 75 14             	pushl  0x14(%ebp)
  801ebf:	ff 75 10             	pushl  0x10(%ebp)
  801ec2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801ec5:	50                   	push   %eax
  801ec6:	68 52 1e 80 00       	push   $0x801e52
  801ecb:	e8 80 fb ff ff       	call   801a50 <vprintfmt>
  801ed0:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801ed3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ed6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801ed9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801edc:	c9                   	leave  
  801edd:	c3                   	ret    

00801ede <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801ede:	55                   	push   %ebp
  801edf:	89 e5                	mov    %esp,%ebp
  801ee1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801ee4:	8d 45 10             	lea    0x10(%ebp),%eax
  801ee7:	83 c0 04             	add    $0x4,%eax
  801eea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801eed:	8b 45 10             	mov    0x10(%ebp),%eax
  801ef0:	ff 75 f4             	pushl  -0xc(%ebp)
  801ef3:	50                   	push   %eax
  801ef4:	ff 75 0c             	pushl  0xc(%ebp)
  801ef7:	ff 75 08             	pushl  0x8(%ebp)
  801efa:	e8 89 ff ff ff       	call   801e88 <vsnprintf>
  801eff:	83 c4 10             	add    $0x10,%esp
  801f02:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801f05:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f08:	c9                   	leave  
  801f09:	c3                   	ret    

00801f0a <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  801f0a:	55                   	push   %ebp
  801f0b:	89 e5                	mov    %esp,%ebp
  801f0d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801f10:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801f17:	eb 06                	jmp    801f1f <strlen+0x15>
		n++;
  801f19:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801f1c:	ff 45 08             	incl   0x8(%ebp)
  801f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f22:	8a 00                	mov    (%eax),%al
  801f24:	84 c0                	test   %al,%al
  801f26:	75 f1                	jne    801f19 <strlen+0xf>
		n++;
	return n;
  801f28:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801f2b:	c9                   	leave  
  801f2c:	c3                   	ret    

00801f2d <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801f2d:	55                   	push   %ebp
  801f2e:	89 e5                	mov    %esp,%ebp
  801f30:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801f33:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801f3a:	eb 09                	jmp    801f45 <strnlen+0x18>
		n++;
  801f3c:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801f3f:	ff 45 08             	incl   0x8(%ebp)
  801f42:	ff 4d 0c             	decl   0xc(%ebp)
  801f45:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f49:	74 09                	je     801f54 <strnlen+0x27>
  801f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4e:	8a 00                	mov    (%eax),%al
  801f50:	84 c0                	test   %al,%al
  801f52:	75 e8                	jne    801f3c <strnlen+0xf>
		n++;
	return n;
  801f54:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801f57:	c9                   	leave  
  801f58:	c3                   	ret    

00801f59 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801f59:	55                   	push   %ebp
  801f5a:	89 e5                	mov    %esp,%ebp
  801f5c:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f62:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801f65:	90                   	nop
  801f66:	8b 45 08             	mov    0x8(%ebp),%eax
  801f69:	8d 50 01             	lea    0x1(%eax),%edx
  801f6c:	89 55 08             	mov    %edx,0x8(%ebp)
  801f6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f72:	8d 4a 01             	lea    0x1(%edx),%ecx
  801f75:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801f78:	8a 12                	mov    (%edx),%dl
  801f7a:	88 10                	mov    %dl,(%eax)
  801f7c:	8a 00                	mov    (%eax),%al
  801f7e:	84 c0                	test   %al,%al
  801f80:	75 e4                	jne    801f66 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801f82:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801f85:	c9                   	leave  
  801f86:	c3                   	ret    

00801f87 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801f87:	55                   	push   %ebp
  801f88:	89 e5                	mov    %esp,%ebp
  801f8a:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f90:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801f93:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801f9a:	eb 1f                	jmp    801fbb <strncpy+0x34>
		*dst++ = *src;
  801f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9f:	8d 50 01             	lea    0x1(%eax),%edx
  801fa2:	89 55 08             	mov    %edx,0x8(%ebp)
  801fa5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fa8:	8a 12                	mov    (%edx),%dl
  801faa:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801fac:	8b 45 0c             	mov    0xc(%ebp),%eax
  801faf:	8a 00                	mov    (%eax),%al
  801fb1:	84 c0                	test   %al,%al
  801fb3:	74 03                	je     801fb8 <strncpy+0x31>
			src++;
  801fb5:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801fb8:	ff 45 fc             	incl   -0x4(%ebp)
  801fbb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fbe:	3b 45 10             	cmp    0x10(%ebp),%eax
  801fc1:	72 d9                	jb     801f9c <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801fc3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801fc6:	c9                   	leave  
  801fc7:	c3                   	ret    

00801fc8 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801fc8:	55                   	push   %ebp
  801fc9:	89 e5                	mov    %esp,%ebp
  801fcb:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801fce:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801fd4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fd8:	74 30                	je     80200a <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801fda:	eb 16                	jmp    801ff2 <strlcpy+0x2a>
			*dst++ = *src++;
  801fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdf:	8d 50 01             	lea    0x1(%eax),%edx
  801fe2:	89 55 08             	mov    %edx,0x8(%ebp)
  801fe5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fe8:	8d 4a 01             	lea    0x1(%edx),%ecx
  801feb:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801fee:	8a 12                	mov    (%edx),%dl
  801ff0:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801ff2:	ff 4d 10             	decl   0x10(%ebp)
  801ff5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ff9:	74 09                	je     802004 <strlcpy+0x3c>
  801ffb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ffe:	8a 00                	mov    (%eax),%al
  802000:	84 c0                	test   %al,%al
  802002:	75 d8                	jne    801fdc <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  802004:	8b 45 08             	mov    0x8(%ebp),%eax
  802007:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80200a:	8b 55 08             	mov    0x8(%ebp),%edx
  80200d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802010:	29 c2                	sub    %eax,%edx
  802012:	89 d0                	mov    %edx,%eax
}
  802014:	c9                   	leave  
  802015:	c3                   	ret    

00802016 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  802016:	55                   	push   %ebp
  802017:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  802019:	eb 06                	jmp    802021 <strcmp+0xb>
		p++, q++;
  80201b:	ff 45 08             	incl   0x8(%ebp)
  80201e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  802021:	8b 45 08             	mov    0x8(%ebp),%eax
  802024:	8a 00                	mov    (%eax),%al
  802026:	84 c0                	test   %al,%al
  802028:	74 0e                	je     802038 <strcmp+0x22>
  80202a:	8b 45 08             	mov    0x8(%ebp),%eax
  80202d:	8a 10                	mov    (%eax),%dl
  80202f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802032:	8a 00                	mov    (%eax),%al
  802034:	38 c2                	cmp    %al,%dl
  802036:	74 e3                	je     80201b <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802038:	8b 45 08             	mov    0x8(%ebp),%eax
  80203b:	8a 00                	mov    (%eax),%al
  80203d:	0f b6 d0             	movzbl %al,%edx
  802040:	8b 45 0c             	mov    0xc(%ebp),%eax
  802043:	8a 00                	mov    (%eax),%al
  802045:	0f b6 c0             	movzbl %al,%eax
  802048:	29 c2                	sub    %eax,%edx
  80204a:	89 d0                	mov    %edx,%eax
}
  80204c:	5d                   	pop    %ebp
  80204d:	c3                   	ret    

0080204e <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80204e:	55                   	push   %ebp
  80204f:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  802051:	eb 09                	jmp    80205c <strncmp+0xe>
		n--, p++, q++;
  802053:	ff 4d 10             	decl   0x10(%ebp)
  802056:	ff 45 08             	incl   0x8(%ebp)
  802059:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80205c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802060:	74 17                	je     802079 <strncmp+0x2b>
  802062:	8b 45 08             	mov    0x8(%ebp),%eax
  802065:	8a 00                	mov    (%eax),%al
  802067:	84 c0                	test   %al,%al
  802069:	74 0e                	je     802079 <strncmp+0x2b>
  80206b:	8b 45 08             	mov    0x8(%ebp),%eax
  80206e:	8a 10                	mov    (%eax),%dl
  802070:	8b 45 0c             	mov    0xc(%ebp),%eax
  802073:	8a 00                	mov    (%eax),%al
  802075:	38 c2                	cmp    %al,%dl
  802077:	74 da                	je     802053 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  802079:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80207d:	75 07                	jne    802086 <strncmp+0x38>
		return 0;
  80207f:	b8 00 00 00 00       	mov    $0x0,%eax
  802084:	eb 14                	jmp    80209a <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802086:	8b 45 08             	mov    0x8(%ebp),%eax
  802089:	8a 00                	mov    (%eax),%al
  80208b:	0f b6 d0             	movzbl %al,%edx
  80208e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802091:	8a 00                	mov    (%eax),%al
  802093:	0f b6 c0             	movzbl %al,%eax
  802096:	29 c2                	sub    %eax,%edx
  802098:	89 d0                	mov    %edx,%eax
}
  80209a:	5d                   	pop    %ebp
  80209b:	c3                   	ret    

0080209c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80209c:	55                   	push   %ebp
  80209d:	89 e5                	mov    %esp,%ebp
  80209f:	83 ec 04             	sub    $0x4,%esp
  8020a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a5:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8020a8:	eb 12                	jmp    8020bc <strchr+0x20>
		if (*s == c)
  8020aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ad:	8a 00                	mov    (%eax),%al
  8020af:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8020b2:	75 05                	jne    8020b9 <strchr+0x1d>
			return (char *) s;
  8020b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b7:	eb 11                	jmp    8020ca <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8020b9:	ff 45 08             	incl   0x8(%ebp)
  8020bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bf:	8a 00                	mov    (%eax),%al
  8020c1:	84 c0                	test   %al,%al
  8020c3:	75 e5                	jne    8020aa <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8020c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020ca:	c9                   	leave  
  8020cb:	c3                   	ret    

008020cc <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8020cc:	55                   	push   %ebp
  8020cd:	89 e5                	mov    %esp,%ebp
  8020cf:	83 ec 04             	sub    $0x4,%esp
  8020d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020d5:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8020d8:	eb 0d                	jmp    8020e7 <strfind+0x1b>
		if (*s == c)
  8020da:	8b 45 08             	mov    0x8(%ebp),%eax
  8020dd:	8a 00                	mov    (%eax),%al
  8020df:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8020e2:	74 0e                	je     8020f2 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8020e4:	ff 45 08             	incl   0x8(%ebp)
  8020e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ea:	8a 00                	mov    (%eax),%al
  8020ec:	84 c0                	test   %al,%al
  8020ee:	75 ea                	jne    8020da <strfind+0xe>
  8020f0:	eb 01                	jmp    8020f3 <strfind+0x27>
		if (*s == c)
			break;
  8020f2:	90                   	nop
	return (char *) s;
  8020f3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8020f6:	c9                   	leave  
  8020f7:	c3                   	ret    

008020f8 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8020f8:	55                   	push   %ebp
  8020f9:	89 e5                	mov    %esp,%ebp
  8020fb:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8020fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802101:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  802104:	8b 45 10             	mov    0x10(%ebp),%eax
  802107:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80210a:	eb 0e                	jmp    80211a <memset+0x22>
		*p++ = c;
  80210c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80210f:	8d 50 01             	lea    0x1(%eax),%edx
  802112:	89 55 fc             	mov    %edx,-0x4(%ebp)
  802115:	8b 55 0c             	mov    0xc(%ebp),%edx
  802118:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80211a:	ff 4d f8             	decl   -0x8(%ebp)
  80211d:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  802121:	79 e9                	jns    80210c <memset+0x14>
		*p++ = c;

	return v;
  802123:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802126:	c9                   	leave  
  802127:	c3                   	ret    

00802128 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  802128:	55                   	push   %ebp
  802129:	89 e5                	mov    %esp,%ebp
  80212b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80212e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802131:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  802134:	8b 45 08             	mov    0x8(%ebp),%eax
  802137:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80213a:	eb 16                	jmp    802152 <memcpy+0x2a>
		*d++ = *s++;
  80213c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80213f:	8d 50 01             	lea    0x1(%eax),%edx
  802142:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802145:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802148:	8d 4a 01             	lea    0x1(%edx),%ecx
  80214b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80214e:	8a 12                	mov    (%edx),%dl
  802150:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  802152:	8b 45 10             	mov    0x10(%ebp),%eax
  802155:	8d 50 ff             	lea    -0x1(%eax),%edx
  802158:	89 55 10             	mov    %edx,0x10(%ebp)
  80215b:	85 c0                	test   %eax,%eax
  80215d:	75 dd                	jne    80213c <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80215f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802162:	c9                   	leave  
  802163:	c3                   	ret    

00802164 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  802164:	55                   	push   %ebp
  802165:	89 e5                	mov    %esp,%ebp
  802167:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80216a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80216d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  802170:	8b 45 08             	mov    0x8(%ebp),%eax
  802173:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  802176:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802179:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80217c:	73 50                	jae    8021ce <memmove+0x6a>
  80217e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802181:	8b 45 10             	mov    0x10(%ebp),%eax
  802184:	01 d0                	add    %edx,%eax
  802186:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802189:	76 43                	jbe    8021ce <memmove+0x6a>
		s += n;
  80218b:	8b 45 10             	mov    0x10(%ebp),%eax
  80218e:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  802191:	8b 45 10             	mov    0x10(%ebp),%eax
  802194:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  802197:	eb 10                	jmp    8021a9 <memmove+0x45>
			*--d = *--s;
  802199:	ff 4d f8             	decl   -0x8(%ebp)
  80219c:	ff 4d fc             	decl   -0x4(%ebp)
  80219f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021a2:	8a 10                	mov    (%eax),%dl
  8021a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021a7:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8021a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8021ac:	8d 50 ff             	lea    -0x1(%eax),%edx
  8021af:	89 55 10             	mov    %edx,0x10(%ebp)
  8021b2:	85 c0                	test   %eax,%eax
  8021b4:	75 e3                	jne    802199 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8021b6:	eb 23                	jmp    8021db <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8021b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021bb:	8d 50 01             	lea    0x1(%eax),%edx
  8021be:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8021c1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8021c4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8021c7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8021ca:	8a 12                	mov    (%edx),%dl
  8021cc:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8021ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8021d1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8021d4:	89 55 10             	mov    %edx,0x10(%ebp)
  8021d7:	85 c0                	test   %eax,%eax
  8021d9:	75 dd                	jne    8021b8 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8021db:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8021de:	c9                   	leave  
  8021df:	c3                   	ret    

008021e0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8021e0:	55                   	push   %ebp
  8021e1:	89 e5                	mov    %esp,%ebp
  8021e3:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8021e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8021ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ef:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8021f2:	eb 2a                	jmp    80221e <memcmp+0x3e>
		if (*s1 != *s2)
  8021f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021f7:	8a 10                	mov    (%eax),%dl
  8021f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021fc:	8a 00                	mov    (%eax),%al
  8021fe:	38 c2                	cmp    %al,%dl
  802200:	74 16                	je     802218 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  802202:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802205:	8a 00                	mov    (%eax),%al
  802207:	0f b6 d0             	movzbl %al,%edx
  80220a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80220d:	8a 00                	mov    (%eax),%al
  80220f:	0f b6 c0             	movzbl %al,%eax
  802212:	29 c2                	sub    %eax,%edx
  802214:	89 d0                	mov    %edx,%eax
  802216:	eb 18                	jmp    802230 <memcmp+0x50>
		s1++, s2++;
  802218:	ff 45 fc             	incl   -0x4(%ebp)
  80221b:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80221e:	8b 45 10             	mov    0x10(%ebp),%eax
  802221:	8d 50 ff             	lea    -0x1(%eax),%edx
  802224:	89 55 10             	mov    %edx,0x10(%ebp)
  802227:	85 c0                	test   %eax,%eax
  802229:	75 c9                	jne    8021f4 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80222b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802230:	c9                   	leave  
  802231:	c3                   	ret    

00802232 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  802232:	55                   	push   %ebp
  802233:	89 e5                	mov    %esp,%ebp
  802235:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  802238:	8b 55 08             	mov    0x8(%ebp),%edx
  80223b:	8b 45 10             	mov    0x10(%ebp),%eax
  80223e:	01 d0                	add    %edx,%eax
  802240:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  802243:	eb 15                	jmp    80225a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  802245:	8b 45 08             	mov    0x8(%ebp),%eax
  802248:	8a 00                	mov    (%eax),%al
  80224a:	0f b6 d0             	movzbl %al,%edx
  80224d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802250:	0f b6 c0             	movzbl %al,%eax
  802253:	39 c2                	cmp    %eax,%edx
  802255:	74 0d                	je     802264 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802257:	ff 45 08             	incl   0x8(%ebp)
  80225a:	8b 45 08             	mov    0x8(%ebp),%eax
  80225d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802260:	72 e3                	jb     802245 <memfind+0x13>
  802262:	eb 01                	jmp    802265 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  802264:	90                   	nop
	return (void *) s;
  802265:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802268:	c9                   	leave  
  802269:	c3                   	ret    

0080226a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80226a:	55                   	push   %ebp
  80226b:	89 e5                	mov    %esp,%ebp
  80226d:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  802270:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  802277:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80227e:	eb 03                	jmp    802283 <strtol+0x19>
		s++;
  802280:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802283:	8b 45 08             	mov    0x8(%ebp),%eax
  802286:	8a 00                	mov    (%eax),%al
  802288:	3c 20                	cmp    $0x20,%al
  80228a:	74 f4                	je     802280 <strtol+0x16>
  80228c:	8b 45 08             	mov    0x8(%ebp),%eax
  80228f:	8a 00                	mov    (%eax),%al
  802291:	3c 09                	cmp    $0x9,%al
  802293:	74 eb                	je     802280 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  802295:	8b 45 08             	mov    0x8(%ebp),%eax
  802298:	8a 00                	mov    (%eax),%al
  80229a:	3c 2b                	cmp    $0x2b,%al
  80229c:	75 05                	jne    8022a3 <strtol+0x39>
		s++;
  80229e:	ff 45 08             	incl   0x8(%ebp)
  8022a1:	eb 13                	jmp    8022b6 <strtol+0x4c>
	else if (*s == '-')
  8022a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a6:	8a 00                	mov    (%eax),%al
  8022a8:	3c 2d                	cmp    $0x2d,%al
  8022aa:	75 0a                	jne    8022b6 <strtol+0x4c>
		s++, neg = 1;
  8022ac:	ff 45 08             	incl   0x8(%ebp)
  8022af:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8022b6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022ba:	74 06                	je     8022c2 <strtol+0x58>
  8022bc:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8022c0:	75 20                	jne    8022e2 <strtol+0x78>
  8022c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c5:	8a 00                	mov    (%eax),%al
  8022c7:	3c 30                	cmp    $0x30,%al
  8022c9:	75 17                	jne    8022e2 <strtol+0x78>
  8022cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ce:	40                   	inc    %eax
  8022cf:	8a 00                	mov    (%eax),%al
  8022d1:	3c 78                	cmp    $0x78,%al
  8022d3:	75 0d                	jne    8022e2 <strtol+0x78>
		s += 2, base = 16;
  8022d5:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8022d9:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8022e0:	eb 28                	jmp    80230a <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8022e2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022e6:	75 15                	jne    8022fd <strtol+0x93>
  8022e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022eb:	8a 00                	mov    (%eax),%al
  8022ed:	3c 30                	cmp    $0x30,%al
  8022ef:	75 0c                	jne    8022fd <strtol+0x93>
		s++, base = 8;
  8022f1:	ff 45 08             	incl   0x8(%ebp)
  8022f4:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8022fb:	eb 0d                	jmp    80230a <strtol+0xa0>
	else if (base == 0)
  8022fd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802301:	75 07                	jne    80230a <strtol+0xa0>
		base = 10;
  802303:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80230a:	8b 45 08             	mov    0x8(%ebp),%eax
  80230d:	8a 00                	mov    (%eax),%al
  80230f:	3c 2f                	cmp    $0x2f,%al
  802311:	7e 19                	jle    80232c <strtol+0xc2>
  802313:	8b 45 08             	mov    0x8(%ebp),%eax
  802316:	8a 00                	mov    (%eax),%al
  802318:	3c 39                	cmp    $0x39,%al
  80231a:	7f 10                	jg     80232c <strtol+0xc2>
			dig = *s - '0';
  80231c:	8b 45 08             	mov    0x8(%ebp),%eax
  80231f:	8a 00                	mov    (%eax),%al
  802321:	0f be c0             	movsbl %al,%eax
  802324:	83 e8 30             	sub    $0x30,%eax
  802327:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80232a:	eb 42                	jmp    80236e <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80232c:	8b 45 08             	mov    0x8(%ebp),%eax
  80232f:	8a 00                	mov    (%eax),%al
  802331:	3c 60                	cmp    $0x60,%al
  802333:	7e 19                	jle    80234e <strtol+0xe4>
  802335:	8b 45 08             	mov    0x8(%ebp),%eax
  802338:	8a 00                	mov    (%eax),%al
  80233a:	3c 7a                	cmp    $0x7a,%al
  80233c:	7f 10                	jg     80234e <strtol+0xe4>
			dig = *s - 'a' + 10;
  80233e:	8b 45 08             	mov    0x8(%ebp),%eax
  802341:	8a 00                	mov    (%eax),%al
  802343:	0f be c0             	movsbl %al,%eax
  802346:	83 e8 57             	sub    $0x57,%eax
  802349:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80234c:	eb 20                	jmp    80236e <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80234e:	8b 45 08             	mov    0x8(%ebp),%eax
  802351:	8a 00                	mov    (%eax),%al
  802353:	3c 40                	cmp    $0x40,%al
  802355:	7e 39                	jle    802390 <strtol+0x126>
  802357:	8b 45 08             	mov    0x8(%ebp),%eax
  80235a:	8a 00                	mov    (%eax),%al
  80235c:	3c 5a                	cmp    $0x5a,%al
  80235e:	7f 30                	jg     802390 <strtol+0x126>
			dig = *s - 'A' + 10;
  802360:	8b 45 08             	mov    0x8(%ebp),%eax
  802363:	8a 00                	mov    (%eax),%al
  802365:	0f be c0             	movsbl %al,%eax
  802368:	83 e8 37             	sub    $0x37,%eax
  80236b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80236e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802371:	3b 45 10             	cmp    0x10(%ebp),%eax
  802374:	7d 19                	jge    80238f <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  802376:	ff 45 08             	incl   0x8(%ebp)
  802379:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80237c:	0f af 45 10          	imul   0x10(%ebp),%eax
  802380:	89 c2                	mov    %eax,%edx
  802382:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802385:	01 d0                	add    %edx,%eax
  802387:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80238a:	e9 7b ff ff ff       	jmp    80230a <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80238f:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  802390:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802394:	74 08                	je     80239e <strtol+0x134>
		*endptr = (char *) s;
  802396:	8b 45 0c             	mov    0xc(%ebp),%eax
  802399:	8b 55 08             	mov    0x8(%ebp),%edx
  80239c:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80239e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8023a2:	74 07                	je     8023ab <strtol+0x141>
  8023a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8023a7:	f7 d8                	neg    %eax
  8023a9:	eb 03                	jmp    8023ae <strtol+0x144>
  8023ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8023ae:	c9                   	leave  
  8023af:	c3                   	ret    

008023b0 <ltostr>:

void
ltostr(long value, char *str)
{
  8023b0:	55                   	push   %ebp
  8023b1:	89 e5                	mov    %esp,%ebp
  8023b3:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8023b6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8023bd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8023c4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023c8:	79 13                	jns    8023dd <ltostr+0x2d>
	{
		neg = 1;
  8023ca:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8023d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023d4:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8023d7:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8023da:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8023dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e0:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8023e5:	99                   	cltd   
  8023e6:	f7 f9                	idiv   %ecx
  8023e8:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8023eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8023ee:	8d 50 01             	lea    0x1(%eax),%edx
  8023f1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8023f4:	89 c2                	mov    %eax,%edx
  8023f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023f9:	01 d0                	add    %edx,%eax
  8023fb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023fe:	83 c2 30             	add    $0x30,%edx
  802401:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  802403:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802406:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80240b:	f7 e9                	imul   %ecx
  80240d:	c1 fa 02             	sar    $0x2,%edx
  802410:	89 c8                	mov    %ecx,%eax
  802412:	c1 f8 1f             	sar    $0x1f,%eax
  802415:	29 c2                	sub    %eax,%edx
  802417:	89 d0                	mov    %edx,%eax
  802419:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80241c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802420:	75 bb                	jne    8023dd <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  802422:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  802429:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80242c:	48                   	dec    %eax
  80242d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  802430:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802434:	74 3d                	je     802473 <ltostr+0xc3>
		start = 1 ;
  802436:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80243d:	eb 34                	jmp    802473 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80243f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802442:	8b 45 0c             	mov    0xc(%ebp),%eax
  802445:	01 d0                	add    %edx,%eax
  802447:	8a 00                	mov    (%eax),%al
  802449:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80244c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80244f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802452:	01 c2                	add    %eax,%edx
  802454:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802457:	8b 45 0c             	mov    0xc(%ebp),%eax
  80245a:	01 c8                	add    %ecx,%eax
  80245c:	8a 00                	mov    (%eax),%al
  80245e:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  802460:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802463:	8b 45 0c             	mov    0xc(%ebp),%eax
  802466:	01 c2                	add    %eax,%edx
  802468:	8a 45 eb             	mov    -0x15(%ebp),%al
  80246b:	88 02                	mov    %al,(%edx)
		start++ ;
  80246d:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  802470:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  802473:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802476:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802479:	7c c4                	jl     80243f <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80247b:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80247e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802481:	01 d0                	add    %edx,%eax
  802483:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  802486:	90                   	nop
  802487:	c9                   	leave  
  802488:	c3                   	ret    

00802489 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  802489:	55                   	push   %ebp
  80248a:	89 e5                	mov    %esp,%ebp
  80248c:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80248f:	ff 75 08             	pushl  0x8(%ebp)
  802492:	e8 73 fa ff ff       	call   801f0a <strlen>
  802497:	83 c4 04             	add    $0x4,%esp
  80249a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80249d:	ff 75 0c             	pushl  0xc(%ebp)
  8024a0:	e8 65 fa ff ff       	call   801f0a <strlen>
  8024a5:	83 c4 04             	add    $0x4,%esp
  8024a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8024ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8024b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8024b9:	eb 17                	jmp    8024d2 <strcconcat+0x49>
		final[s] = str1[s] ;
  8024bb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024be:	8b 45 10             	mov    0x10(%ebp),%eax
  8024c1:	01 c2                	add    %eax,%edx
  8024c3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8024c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c9:	01 c8                	add    %ecx,%eax
  8024cb:	8a 00                	mov    (%eax),%al
  8024cd:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8024cf:	ff 45 fc             	incl   -0x4(%ebp)
  8024d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024d5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8024d8:	7c e1                	jl     8024bb <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8024da:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8024e1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8024e8:	eb 1f                	jmp    802509 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8024ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024ed:	8d 50 01             	lea    0x1(%eax),%edx
  8024f0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8024f3:	89 c2                	mov    %eax,%edx
  8024f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8024f8:	01 c2                	add    %eax,%edx
  8024fa:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8024fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802500:	01 c8                	add    %ecx,%eax
  802502:	8a 00                	mov    (%eax),%al
  802504:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  802506:	ff 45 f8             	incl   -0x8(%ebp)
  802509:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80250c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80250f:	7c d9                	jl     8024ea <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  802511:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802514:	8b 45 10             	mov    0x10(%ebp),%eax
  802517:	01 d0                	add    %edx,%eax
  802519:	c6 00 00             	movb   $0x0,(%eax)
}
  80251c:	90                   	nop
  80251d:	c9                   	leave  
  80251e:	c3                   	ret    

0080251f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80251f:	55                   	push   %ebp
  802520:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  802522:	8b 45 14             	mov    0x14(%ebp),%eax
  802525:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80252b:	8b 45 14             	mov    0x14(%ebp),%eax
  80252e:	8b 00                	mov    (%eax),%eax
  802530:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802537:	8b 45 10             	mov    0x10(%ebp),%eax
  80253a:	01 d0                	add    %edx,%eax
  80253c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802542:	eb 0c                	jmp    802550 <strsplit+0x31>
			*string++ = 0;
  802544:	8b 45 08             	mov    0x8(%ebp),%eax
  802547:	8d 50 01             	lea    0x1(%eax),%edx
  80254a:	89 55 08             	mov    %edx,0x8(%ebp)
  80254d:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802550:	8b 45 08             	mov    0x8(%ebp),%eax
  802553:	8a 00                	mov    (%eax),%al
  802555:	84 c0                	test   %al,%al
  802557:	74 18                	je     802571 <strsplit+0x52>
  802559:	8b 45 08             	mov    0x8(%ebp),%eax
  80255c:	8a 00                	mov    (%eax),%al
  80255e:	0f be c0             	movsbl %al,%eax
  802561:	50                   	push   %eax
  802562:	ff 75 0c             	pushl  0xc(%ebp)
  802565:	e8 32 fb ff ff       	call   80209c <strchr>
  80256a:	83 c4 08             	add    $0x8,%esp
  80256d:	85 c0                	test   %eax,%eax
  80256f:	75 d3                	jne    802544 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  802571:	8b 45 08             	mov    0x8(%ebp),%eax
  802574:	8a 00                	mov    (%eax),%al
  802576:	84 c0                	test   %al,%al
  802578:	74 5a                	je     8025d4 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80257a:	8b 45 14             	mov    0x14(%ebp),%eax
  80257d:	8b 00                	mov    (%eax),%eax
  80257f:	83 f8 0f             	cmp    $0xf,%eax
  802582:	75 07                	jne    80258b <strsplit+0x6c>
		{
			return 0;
  802584:	b8 00 00 00 00       	mov    $0x0,%eax
  802589:	eb 66                	jmp    8025f1 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80258b:	8b 45 14             	mov    0x14(%ebp),%eax
  80258e:	8b 00                	mov    (%eax),%eax
  802590:	8d 48 01             	lea    0x1(%eax),%ecx
  802593:	8b 55 14             	mov    0x14(%ebp),%edx
  802596:	89 0a                	mov    %ecx,(%edx)
  802598:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80259f:	8b 45 10             	mov    0x10(%ebp),%eax
  8025a2:	01 c2                	add    %eax,%edx
  8025a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a7:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8025a9:	eb 03                	jmp    8025ae <strsplit+0x8f>
			string++;
  8025ab:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8025ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b1:	8a 00                	mov    (%eax),%al
  8025b3:	84 c0                	test   %al,%al
  8025b5:	74 8b                	je     802542 <strsplit+0x23>
  8025b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ba:	8a 00                	mov    (%eax),%al
  8025bc:	0f be c0             	movsbl %al,%eax
  8025bf:	50                   	push   %eax
  8025c0:	ff 75 0c             	pushl  0xc(%ebp)
  8025c3:	e8 d4 fa ff ff       	call   80209c <strchr>
  8025c8:	83 c4 08             	add    $0x8,%esp
  8025cb:	85 c0                	test   %eax,%eax
  8025cd:	74 dc                	je     8025ab <strsplit+0x8c>
			string++;
	}
  8025cf:	e9 6e ff ff ff       	jmp    802542 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8025d4:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8025d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8025d8:	8b 00                	mov    (%eax),%eax
  8025da:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8025e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8025e4:	01 d0                	add    %edx,%eax
  8025e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8025ec:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8025f1:	c9                   	leave  
  8025f2:	c3                   	ret    

008025f3 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8025f3:	55                   	push   %ebp
  8025f4:	89 e5                	mov    %esp,%ebp
  8025f6:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8025f9:	83 ec 04             	sub    $0x4,%esp
  8025fc:	68 a8 50 80 00       	push   $0x8050a8
  802601:	68 3f 01 00 00       	push   $0x13f
  802606:	68 ca 50 80 00       	push   $0x8050ca
  80260b:	e8 a9 ef ff ff       	call   8015b9 <_panic>

00802610 <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  802610:	55                   	push   %ebp
  802611:	89 e5                	mov    %esp,%ebp
  802613:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  802616:	83 ec 0c             	sub    $0xc,%esp
  802619:	ff 75 08             	pushl  0x8(%ebp)
  80261c:	e8 90 0c 00 00       	call   8032b1 <sys_sbrk>
  802621:	83 c4 10             	add    $0x10,%esp
}
  802624:	c9                   	leave  
  802625:	c3                   	ret    

00802626 <malloc>:
#define num_of_page ((USER_HEAP_MAX - USER_HEAP_START) / PAGE_SIZE)

int pagesAllocated[num_of_page] = { 0 };
int shardIDs[num_of_page] = { 0 };
bool markedPages[num_of_page] = { 0 };
void* malloc(uint32 size) {
  802626:	55                   	push   %ebp
  802627:	89 e5                	mov    %esp,%ebp
  802629:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  80262c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802630:	75 0a                	jne    80263c <malloc+0x16>
		return NULL;
  802632:	b8 00 00 00 00       	mov    $0x0,%eax
  802637:	e9 9e 01 00 00       	jmp    8027da <malloc+0x1b4>

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

	//  our new code
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  80263c:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802643:	77 2c                	ja     802671 <malloc+0x4b>
		if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  802645:	e8 eb 0a 00 00       	call   803135 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80264a:	85 c0                	test   %eax,%eax
  80264c:	74 19                	je     802667 <malloc+0x41>

			void * block = alloc_block_FF(size);
  80264e:	83 ec 0c             	sub    $0xc,%esp
  802651:	ff 75 08             	pushl  0x8(%ebp)
  802654:	e8 85 11 00 00       	call   8037de <alloc_block_FF>
  802659:	83 c4 10             	add    $0x10,%esp
  80265c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			return block;
  80265f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802662:	e9 73 01 00 00       	jmp    8027da <malloc+0x1b4>
		} else {
			return NULL;
  802667:	b8 00 00 00 00       	mov    $0x0,%eax
  80266c:	e9 69 01 00 00       	jmp    8027da <malloc+0x1b4>
		}
	}

	uint32 numOfPages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  802671:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802678:	8b 55 08             	mov    0x8(%ebp),%edx
  80267b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80267e:	01 d0                	add    %edx,%eax
  802680:	48                   	dec    %eax
  802681:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802684:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802687:	ba 00 00 00 00       	mov    $0x0,%edx
  80268c:	f7 75 e0             	divl   -0x20(%ebp)
  80268f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802692:	29 d0                	sub    %edx,%eax
  802694:	c1 e8 0c             	shr    $0xc,%eax
  802697:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 freePagesCount = 0;
  80269a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  8026a1:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  8026a8:	a1 20 60 80 00       	mov    0x806020,%eax
  8026ad:	8b 40 7c             	mov    0x7c(%eax),%eax
  8026b0:	05 00 10 00 00       	add    $0x1000,%eax
  8026b5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  8026b8:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8026bd:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8026c0:	89 45 d0             	mov    %eax,-0x30(%ebp)

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  8026c3:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8026ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8026cd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8026d0:	01 d0                	add    %edx,%eax
  8026d2:	48                   	dec    %eax
  8026d3:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8026d6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8026d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8026de:	f7 75 cc             	divl   -0x34(%ebp)
  8026e1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8026e4:	29 d0                	sub    %edx,%eax
  8026e6:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8026e9:	76 0a                	jbe    8026f5 <malloc+0xcf>
		return NULL;
  8026eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8026f0:	e9 e5 00 00 00       	jmp    8027da <malloc+0x1b4>
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  8026f5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026f8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8026fb:	eb 48                	jmp    802745 <malloc+0x11f>
	{
		uint32 idx = (i - currentAddr) / PAGE_SIZE;
  8026fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802700:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  802703:	c1 e8 0c             	shr    $0xc,%eax
  802706:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if (!markedPages[idx]) {
  802709:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80270c:	8b 04 85 40 60 90 00 	mov    0x906040(,%eax,4),%eax
  802713:	85 c0                	test   %eax,%eax
  802715:	75 11                	jne    802728 <malloc+0x102>
			freePagesCount++;
  802717:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  80271a:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80271e:	75 16                	jne    802736 <malloc+0x110>
				start = i;
  802720:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802723:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802726:	eb 0e                	jmp    802736 <malloc+0x110>
			}
		} else {
			freePagesCount = 0;
  802728:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  80272f:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == numOfPages) {
  802736:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802739:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80273c:	74 12                	je     802750 <malloc+0x12a>

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  80273e:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  802745:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  80274c:	76 af                	jbe    8026fd <malloc+0xd7>
  80274e:	eb 01                	jmp    802751 <malloc+0x12b>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == numOfPages) {
			break;
  802750:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
  802751:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802755:	74 08                	je     80275f <malloc+0x139>
  802757:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275a:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80275d:	74 07                	je     802766 <malloc+0x140>
		return NULL;
  80275f:	b8 00 00 00 00       	mov    $0x0,%eax
  802764:	eb 74                	jmp    8027da <malloc+0x1b4>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  802766:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802769:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80276c:	c1 e8 0c             	shr    $0xc,%eax
  80276f:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numOfPages;
  802772:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802775:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802778:	89 14 85 40 60 80 00 	mov    %edx,0x806040(,%eax,4)
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  80277f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802782:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802785:	eb 11                	jmp    802798 <malloc+0x172>
		markedPages[i] = 1;
  802787:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80278a:	c7 04 85 40 60 90 00 	movl   $0x1,0x906040(,%eax,4)
  802791:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = numOfPages;
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  802795:	ff 45 e8             	incl   -0x18(%ebp)
  802798:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80279b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80279e:	01 d0                	add    %edx,%eax
  8027a0:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8027a3:	77 e2                	ja     802787 <malloc+0x161>
		markedPages[i] = 1;
	}

	sys_allocate_user_mem(start, ROUNDUP(size, PAGE_SIZE));
  8027a5:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  8027ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8027af:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8027b2:	01 d0                	add    %edx,%eax
  8027b4:	48                   	dec    %eax
  8027b5:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8027b8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8027bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8027c0:	f7 75 bc             	divl   -0x44(%ebp)
  8027c3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8027c6:	29 d0                	sub    %edx,%eax
  8027c8:	83 ec 08             	sub    $0x8,%esp
  8027cb:	50                   	push   %eax
  8027cc:	ff 75 f0             	pushl  -0x10(%ebp)
  8027cf:	e8 14 0b 00 00       	call   8032e8 <sys_allocate_user_mem>
  8027d4:	83 c4 10             	add    $0x10,%esp
	return (void*) start;
  8027d7:	8b 45 f0             	mov    -0x10(%ebp),%eax

}
  8027da:	c9                   	leave  
  8027db:	c3                   	ret    

008027dc <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address) {
  8027dc:	55                   	push   %ebp
  8027dd:	89 e5                	mov    %esp,%ebp
  8027df:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
  8027e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027e6:	0f 84 ee 00 00 00    	je     8028da <free+0xfe>
		return;
	}

	if (virtual_address
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  8027ec:	a1 20 60 80 00       	mov    0x806020,%eax
  8027f1:	8b 40 74             	mov    0x74(%eax),%eax

	if (virtual_address == NULL) {
		return;
	}

	if (virtual_address
  8027f4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027f7:	77 09                	ja     802802 <free+0x26>
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  8027f9:	81 7d 08 00 00 00 a0 	cmpl   $0xa0000000,0x8(%ebp)
  802800:	76 14                	jbe    802816 <free+0x3a>
		panic("INVALID VIRTUAL ADDRESS!!");
  802802:	83 ec 04             	sub    $0x4,%esp
  802805:	68 d8 50 80 00       	push   $0x8050d8
  80280a:	6a 68                	push   $0x68
  80280c:	68 f2 50 80 00       	push   $0x8050f2
  802811:	e8 a3 ed ff ff       	call   8015b9 <_panic>
	}
	if (virtual_address >= (void *) (myEnv->uheapStart)
  802816:	a1 20 60 80 00       	mov    0x806020,%eax
  80281b:	8b 40 74             	mov    0x74(%eax),%eax
  80281e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802821:	77 20                	ja     802843 <free+0x67>
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
  802823:	a1 20 60 80 00       	mov    0x806020,%eax
  802828:	8b 40 78             	mov    0x78(%eax),%eax
  80282b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80282e:	76 13                	jbe    802843 <free+0x67>
		free_block(virtual_address);
  802830:	83 ec 0c             	sub    $0xc,%esp
  802833:	ff 75 08             	pushl  0x8(%ebp)
  802836:	e8 6c 16 00 00       	call   803ea7 <free_block>
  80283b:	83 c4 10             	add    $0x10,%esp
		return;
  80283e:	e9 98 00 00 00       	jmp    8028db <free+0xff>
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  802843:	8b 55 08             	mov    0x8(%ebp),%edx
  802846:	a1 20 60 80 00       	mov    0x806020,%eax
  80284b:	8b 40 7c             	mov    0x7c(%eax),%eax
  80284e:	29 c2                	sub    %eax,%edx
  802850:	89 d0                	mov    %edx,%eax
  802852:	2d 00 10 00 00       	sub    $0x1000,%eax
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
		free_block(virtual_address);
		return;
	}

	uint32 pageIdx = ((uint32) virtual_address
  802857:	c1 e8 0c             	shr    $0xc,%eax
  80285a:	89 45 ec             	mov    %eax,-0x14(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  80285d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802864:	eb 16                	jmp    80287c <free+0xa0>
		markedPages[idx + pageIdx] = 0;
  802866:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802869:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80286c:	01 d0                	add    %edx,%eax
  80286e:	c7 04 85 40 60 90 00 	movl   $0x0,0x906040(,%eax,4)
  802875:	00 00 00 00 
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  802879:	ff 45 f4             	incl   -0xc(%ebp)
  80287c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80287f:	8b 04 85 40 60 80 00 	mov    0x806040(,%eax,4),%eax
  802886:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802889:	7f db                	jg     802866 <free+0x8a>
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;
  80288b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80288e:	8b 04 85 40 60 80 00 	mov    0x806040(,%eax,4),%eax
  802895:	c1 e0 0c             	shl    $0xc,%eax
  802898:	89 45 e8             	mov    %eax,-0x18(%ebp)

	for (uint32 i = (uint32) virtual_address;
  80289b:	8b 45 08             	mov    0x8(%ebp),%eax
  80289e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8028a1:	eb 1a                	jmp    8028bd <free+0xe1>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
  8028a3:	83 ec 08             	sub    $0x8,%esp
  8028a6:	68 00 10 00 00       	push   $0x1000
  8028ab:	ff 75 f0             	pushl  -0x10(%ebp)
  8028ae:	e8 19 0a 00 00       	call   8032cc <sys_free_user_mem>
  8028b3:	83 c4 10             	add    $0x10,%esp
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
  8028b6:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  8028bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8028c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028c3:	01 d0                	add    %edx,%eax
	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
  8028c5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8028c8:	77 d9                	ja     8028a3 <free+0xc7>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;
  8028ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028cd:	c7 04 85 40 60 80 00 	movl   $0x0,0x806040(,%eax,4)
  8028d4:	00 00 00 00 
  8028d8:	eb 01                	jmp    8028db <free+0xff>
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
		return;
  8028da:	90                   	nop
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;

}
  8028db:	c9                   	leave  
  8028dc:	c3                   	ret    

008028dd <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  8028dd:	55                   	push   %ebp
  8028de:	89 e5                	mov    %esp,%ebp
  8028e0:	83 ec 58             	sub    $0x58,%esp
  8028e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8028e6:	88 45 b4             	mov    %al,-0x4c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  8028e9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8028ed:	75 0a                	jne    8028f9 <smalloc+0x1c>
		return NULL;
  8028ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8028f4:	e9 7d 01 00 00       	jmp    802a76 <smalloc+0x199>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	uint32 num_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  8028f9:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  802900:	8b 55 0c             	mov    0xc(%ebp),%edx
  802903:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802906:	01 d0                	add    %edx,%eax
  802908:	48                   	dec    %eax
  802909:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80290c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80290f:	ba 00 00 00 00       	mov    $0x0,%edx
  802914:	f7 75 e4             	divl   -0x1c(%ebp)
  802917:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80291a:	29 d0                	sub    %edx,%eax
  80291c:	c1 e8 0c             	shr    $0xc,%eax
  80291f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 freePagesCount = 0;
  802922:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  802929:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  802930:	a1 20 60 80 00       	mov    0x806020,%eax
  802935:	8b 40 7c             	mov    0x7c(%eax),%eax
  802938:	05 00 10 00 00       	add    $0x1000,%eax
  80293d:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  802940:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  802945:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802948:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  80294b:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  802952:	8b 55 0c             	mov    0xc(%ebp),%edx
  802955:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802958:	01 d0                	add    %edx,%eax
  80295a:	48                   	dec    %eax
  80295b:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80295e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802961:	ba 00 00 00 00       	mov    $0x0,%edx
  802966:	f7 75 d0             	divl   -0x30(%ebp)
  802969:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80296c:	29 d0                	sub    %edx,%eax
  80296e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  802971:	76 0a                	jbe    80297d <smalloc+0xa0>
		return NULL;
  802973:	b8 00 00 00 00       	mov    $0x0,%eax
  802978:	e9 f9 00 00 00       	jmp    802a76 <smalloc+0x199>
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  80297d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802980:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802983:	eb 48                	jmp    8029cd <smalloc+0xf0>
		uint32 idx = (s - currentAddr) / PAGE_SIZE;
  802985:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802988:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80298b:	c1 e8 0c             	shr    $0xc,%eax
  80298e:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (!markedPages[idx]) {
  802991:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802994:	8b 04 85 40 60 90 00 	mov    0x906040(,%eax,4),%eax
  80299b:	85 c0                	test   %eax,%eax
  80299d:	75 11                	jne    8029b0 <smalloc+0xd3>
			freePagesCount++;
  80299f:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  8029a2:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8029a6:	75 16                	jne    8029be <smalloc+0xe1>
				start = s;
  8029a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8029ae:	eb 0e                	jmp    8029be <smalloc+0xe1>
			}
		} else {
			freePagesCount = 0;
  8029b0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  8029b7:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == num_Of_Pages) {
  8029be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8029c4:	74 12                	je     8029d8 <smalloc+0xfb>
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  8029c6:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  8029cd:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  8029d4:	76 af                	jbe    802985 <smalloc+0xa8>
  8029d6:	eb 01                	jmp    8029d9 <smalloc+0xfc>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == num_Of_Pages) {
			break;
  8029d8:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
  8029d9:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8029dd:	74 08                	je     8029e7 <smalloc+0x10a>
  8029df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e2:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8029e5:	74 0a                	je     8029f1 <smalloc+0x114>
		return NULL;
  8029e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8029ec:	e9 85 00 00 00       	jmp    802a76 <smalloc+0x199>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  8029f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f4:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8029f7:	c1 e8 0c             	shr    $0xc,%eax
  8029fa:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	pagesAllocated[startPage] = num_Of_Pages;
  8029fd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802a00:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802a03:	89 14 85 40 60 80 00 	mov    %edx,0x806040(,%eax,4)
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  802a0a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802a0d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802a10:	eb 11                	jmp    802a23 <smalloc+0x146>
		markedPages[s] = 1;
  802a12:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a15:	c7 04 85 40 60 90 00 	movl   $0x1,0x906040(,%eax,4)
  802a1c:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = num_Of_Pages;
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  802a20:	ff 45 e8             	incl   -0x18(%ebp)
  802a23:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802a26:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a29:	01 d0                	add    %edx,%eax
  802a2b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802a2e:	77 e2                	ja     802a12 <smalloc+0x135>
		markedPages[s] = 1;
	}
	int sharedobjID = sys_createSharedObject(sharedVarName, size, isWritable,
  802a30:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a33:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
  802a37:	52                   	push   %edx
  802a38:	50                   	push   %eax
  802a39:	ff 75 0c             	pushl  0xc(%ebp)
  802a3c:	ff 75 08             	pushl  0x8(%ebp)
  802a3f:	e8 8f 04 00 00       	call   802ed3 <sys_createSharedObject>
  802a44:	83 c4 10             	add    $0x10,%esp
  802a47:	89 45 c0             	mov    %eax,-0x40(%ebp)
			(void*) start);

	if (sharedobjID >= 0) {
  802a4a:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  802a4e:	78 12                	js     802a62 <smalloc+0x185>
		shardIDs[startPage] = sharedobjID;
  802a50:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802a53:	8b 55 c0             	mov    -0x40(%ebp),%edx
  802a56:	89 14 85 40 60 88 00 	mov    %edx,0x886040(,%eax,4)
		return (void*) start;
  802a5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a60:	eb 14                	jmp    802a76 <smalloc+0x199>
	}
	free((void*) start);
  802a62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a65:	83 ec 0c             	sub    $0xc,%esp
  802a68:	50                   	push   %eax
  802a69:	e8 6e fd ff ff       	call   8027dc <free>
  802a6e:	83 c4 10             	add    $0x10,%esp
	return NULL;
  802a71:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a76:	c9                   	leave  
  802a77:	c3                   	ret    

00802a78 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  802a78:	55                   	push   %ebp
  802a79:	89 e5                	mov    %esp,%ebp
  802a7b:	83 ec 48             	sub    $0x48,%esp
	//cprintf("SSSSSGEEETTT\n");
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID, sharedVarName);
  802a7e:	83 ec 08             	sub    $0x8,%esp
  802a81:	ff 75 0c             	pushl  0xc(%ebp)
  802a84:	ff 75 08             	pushl  0x8(%ebp)
  802a87:	e8 71 04 00 00       	call   802efd <sys_getSizeOfSharedObject>
  802a8c:	83 c4 10             	add    $0x10,%esp
  802a8f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (size < 0)
		return NULL;
	uint32 numb_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  802a92:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802a99:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a9f:	01 d0                	add    %edx,%eax
  802aa1:	48                   	dec    %eax
  802aa2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802aa5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802aa8:	ba 00 00 00 00       	mov    $0x0,%edx
  802aad:	f7 75 e0             	divl   -0x20(%ebp)
  802ab0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ab3:	29 d0                	sub    %edx,%eax
  802ab5:	c1 e8 0c             	shr    $0xc,%eax
  802ab8:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 free_Pages_Count = 0;
  802abb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  802ac2:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
  802ac9:	a1 20 60 80 00       	mov    0x806020,%eax
  802ace:	8b 40 7c             	mov    0x7c(%eax),%eax
  802ad1:	05 00 10 00 00       	add    $0x1000,%eax
  802ad6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
  802ad9:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  802ade:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  802ae1:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
  802ae4:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802aeb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802aee:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802af1:	01 d0                	add    %edx,%eax
  802af3:	48                   	dec    %eax
  802af4:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802af7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802afa:	ba 00 00 00 00       	mov    $0x0,%edx
  802aff:	f7 75 cc             	divl   -0x34(%ebp)
  802b02:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802b05:	29 d0                	sub    %edx,%eax
  802b07:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802b0a:	76 0a                	jbe    802b16 <sget+0x9e>
		return NULL;
  802b0c:	b8 00 00 00 00       	mov    $0x0,%eax
  802b11:	e9 f7 00 00 00       	jmp    802c0d <sget+0x195>
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  802b16:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802b19:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802b1c:	eb 48                	jmp    802b66 <sget+0xee>
		uint32 idx = (s - current_Addr) / PAGE_SIZE;
  802b1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b21:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  802b24:	c1 e8 0c             	shr    $0xc,%eax
  802b27:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if (!markedPages[idx]) {
  802b2a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802b2d:	8b 04 85 40 60 90 00 	mov    0x906040(,%eax,4),%eax
  802b34:	85 c0                	test   %eax,%eax
  802b36:	75 11                	jne    802b49 <sget+0xd1>
			free_Pages_Count++;
  802b38:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  802b3b:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802b3f:	75 16                	jne    802b57 <sget+0xdf>
				start = s;
  802b41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b44:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802b47:	eb 0e                	jmp    802b57 <sget+0xdf>
			}
		} else {
			free_Pages_Count = 0;
  802b49:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  802b50:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (free_Pages_Count == numb_Of_Pages) {
  802b57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5a:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  802b5d:	74 12                	je     802b71 <sget+0xf9>
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
		return NULL;
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  802b5f:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  802b66:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  802b6d:	76 af                	jbe    802b1e <sget+0xa6>
  802b6f:	eb 01                	jmp    802b72 <sget+0xfa>
		} else {
			free_Pages_Count = 0;
			start = (uint32) -1;
		}
		if (free_Pages_Count == numb_Of_Pages) {
			break;
  802b71:	90                   	nop
		}
	}
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
  802b72:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802b76:	74 08                	je     802b80 <sget+0x108>
  802b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7b:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  802b7e:	74 0a                	je     802b8a <sget+0x112>
		return NULL;
  802b80:	b8 00 00 00 00       	mov    $0x0,%eax
  802b85:	e9 83 00 00 00       	jmp    802c0d <sget+0x195>
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
  802b8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b8d:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  802b90:	c1 e8 0c             	shr    $0xc,%eax
  802b93:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numb_Of_Pages;
  802b96:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802b99:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802b9c:	89 14 85 40 60 80 00 	mov    %edx,0x806040(,%eax,4)
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  802ba3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802ba6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802ba9:	eb 11                	jmp    802bbc <sget+0x144>
		markedPages[k] = 1;
  802bab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bae:	c7 04 85 40 60 90 00 	movl   $0x1,0x906040(,%eax,4)
  802bb5:	01 00 00 00 
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
	pagesAllocated[startPage] = numb_Of_Pages;
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  802bb9:	ff 45 e8             	incl   -0x18(%ebp)
  802bbc:	8b 55 c0             	mov    -0x40(%ebp),%edx
  802bbf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802bc2:	01 d0                	add    %edx,%eax
  802bc4:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802bc7:	77 e2                	ja     802bab <sget+0x133>
		markedPages[k] = 1;
	}
	int ss = sys_getSharedObject(ownerEnvID, sharedVarName, (void*) start);
  802bc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bcc:	83 ec 04             	sub    $0x4,%esp
  802bcf:	50                   	push   %eax
  802bd0:	ff 75 0c             	pushl  0xc(%ebp)
  802bd3:	ff 75 08             	pushl  0x8(%ebp)
  802bd6:	e8 3f 03 00 00       	call   802f1a <sys_getSharedObject>
  802bdb:	83 c4 10             	add    $0x10,%esp
  802bde:	89 45 bc             	mov    %eax,-0x44(%ebp)
	if (ss >= 0) {
  802be1:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  802be5:	78 12                	js     802bf9 <sget+0x181>
		shardIDs[startPage] = ss;
  802be7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802bea:	8b 55 bc             	mov    -0x44(%ebp),%edx
  802bed:	89 14 85 40 60 88 00 	mov    %edx,0x886040(,%eax,4)
		return (void*) start;
  802bf4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf7:	eb 14                	jmp    802c0d <sget+0x195>
	}
	free((void*) start);
  802bf9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bfc:	83 ec 0c             	sub    $0xc,%esp
  802bff:	50                   	push   %eax
  802c00:	e8 d7 fb ff ff       	call   8027dc <free>
  802c05:	83 c4 10             	add    $0x10,%esp
	return NULL;
  802c08:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c0d:	c9                   	leave  
  802c0e:	c3                   	ret    

00802c0f <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  802c0f:	55                   	push   %ebp
  802c10:	89 e5                	mov    %esp,%ebp
  802c12:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  802c15:	8b 55 08             	mov    0x8(%ebp),%edx
  802c18:	a1 20 60 80 00       	mov    0x806020,%eax
  802c1d:	8b 40 7c             	mov    0x7c(%eax),%eax
  802c20:	29 c2                	sub    %eax,%edx
  802c22:	89 d0                	mov    %edx,%eax
  802c24:	2d 00 10 00 00       	sub    $0x1000,%eax

void sfree(void* virtual_address) {
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
  802c29:	c1 e8 0c             	shr    $0xc,%eax
  802c2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
	int id = shardIDs[pageIdx];
  802c2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c32:	8b 04 85 40 60 88 00 	mov    0x886040(,%eax,4),%eax
  802c39:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int result = sys_freeSharedObject(id, virtual_address);
  802c3c:	83 ec 08             	sub    $0x8,%esp
  802c3f:	ff 75 08             	pushl  0x8(%ebp)
  802c42:	ff 75 f0             	pushl  -0x10(%ebp)
  802c45:	e8 ef 02 00 00       	call   802f39 <sys_freeSharedObject>
  802c4a:	83 c4 10             	add    $0x10,%esp
  802c4d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (result == 0) {
  802c50:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c54:	75 0e                	jne    802c64 <sfree+0x55>
		shardIDs[pageIdx] = -1;  // Reset the ID after freeing
  802c56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c59:	c7 04 85 40 60 88 00 	movl   $0xffffffff,0x886040(,%eax,4)
  802c60:	ff ff ff ff 
	}

}
  802c64:	90                   	nop
  802c65:	c9                   	leave  
  802c66:	c3                   	ret    

00802c67 <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  802c67:	55                   	push   %ebp
  802c68:	89 e5                	mov    %esp,%ebp
  802c6a:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802c6d:	83 ec 04             	sub    $0x4,%esp
  802c70:	68 00 51 80 00       	push   $0x805100
  802c75:	68 19 01 00 00       	push   $0x119
  802c7a:	68 f2 50 80 00       	push   $0x8050f2
  802c7f:	e8 35 e9 ff ff       	call   8015b9 <_panic>

00802c84 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  802c84:	55                   	push   %ebp
  802c85:	89 e5                	mov    %esp,%ebp
  802c87:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802c8a:	83 ec 04             	sub    $0x4,%esp
  802c8d:	68 26 51 80 00       	push   $0x805126
  802c92:	68 23 01 00 00       	push   $0x123
  802c97:	68 f2 50 80 00       	push   $0x8050f2
  802c9c:	e8 18 e9 ff ff       	call   8015b9 <_panic>

00802ca1 <shrink>:

}
void shrink(uint32 newSize) {
  802ca1:	55                   	push   %ebp
  802ca2:	89 e5                	mov    %esp,%ebp
  802ca4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802ca7:	83 ec 04             	sub    $0x4,%esp
  802caa:	68 26 51 80 00       	push   $0x805126
  802caf:	68 27 01 00 00       	push   $0x127
  802cb4:	68 f2 50 80 00       	push   $0x8050f2
  802cb9:	e8 fb e8 ff ff       	call   8015b9 <_panic>

00802cbe <freeHeap>:

}
void freeHeap(void* virtual_address) {
  802cbe:	55                   	push   %ebp
  802cbf:	89 e5                	mov    %esp,%ebp
  802cc1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802cc4:	83 ec 04             	sub    $0x4,%esp
  802cc7:	68 26 51 80 00       	push   $0x805126
  802ccc:	68 2b 01 00 00       	push   $0x12b
  802cd1:	68 f2 50 80 00       	push   $0x8050f2
  802cd6:	e8 de e8 ff ff       	call   8015b9 <_panic>

00802cdb <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  802cdb:	55                   	push   %ebp
  802cdc:	89 e5                	mov    %esp,%ebp
  802cde:	57                   	push   %edi
  802cdf:	56                   	push   %esi
  802ce0:	53                   	push   %ebx
  802ce1:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce7:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cea:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802ced:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802cf0:	8b 7d 18             	mov    0x18(%ebp),%edi
  802cf3:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802cf6:	cd 30                	int    $0x30
  802cf8:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  802cfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802cfe:	83 c4 10             	add    $0x10,%esp
  802d01:	5b                   	pop    %ebx
  802d02:	5e                   	pop    %esi
  802d03:	5f                   	pop    %edi
  802d04:	5d                   	pop    %ebp
  802d05:	c3                   	ret    

00802d06 <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  802d06:	55                   	push   %ebp
  802d07:	89 e5                	mov    %esp,%ebp
  802d09:	83 ec 04             	sub    $0x4,%esp
  802d0c:	8b 45 10             	mov    0x10(%ebp),%eax
  802d0f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  802d12:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802d16:	8b 45 08             	mov    0x8(%ebp),%eax
  802d19:	6a 00                	push   $0x0
  802d1b:	6a 00                	push   $0x0
  802d1d:	52                   	push   %edx
  802d1e:	ff 75 0c             	pushl  0xc(%ebp)
  802d21:	50                   	push   %eax
  802d22:	6a 00                	push   $0x0
  802d24:	e8 b2 ff ff ff       	call   802cdb <syscall>
  802d29:	83 c4 18             	add    $0x18,%esp
}
  802d2c:	90                   	nop
  802d2d:	c9                   	leave  
  802d2e:	c3                   	ret    

00802d2f <sys_cgetc>:

int sys_cgetc(void) {
  802d2f:	55                   	push   %ebp
  802d30:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802d32:	6a 00                	push   $0x0
  802d34:	6a 00                	push   $0x0
  802d36:	6a 00                	push   $0x0
  802d38:	6a 00                	push   $0x0
  802d3a:	6a 00                	push   $0x0
  802d3c:	6a 02                	push   $0x2
  802d3e:	e8 98 ff ff ff       	call   802cdb <syscall>
  802d43:	83 c4 18             	add    $0x18,%esp
}
  802d46:	c9                   	leave  
  802d47:	c3                   	ret    

00802d48 <sys_lock_cons>:

void sys_lock_cons(void) {
  802d48:	55                   	push   %ebp
  802d49:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802d4b:	6a 00                	push   $0x0
  802d4d:	6a 00                	push   $0x0
  802d4f:	6a 00                	push   $0x0
  802d51:	6a 00                	push   $0x0
  802d53:	6a 00                	push   $0x0
  802d55:	6a 03                	push   $0x3
  802d57:	e8 7f ff ff ff       	call   802cdb <syscall>
  802d5c:	83 c4 18             	add    $0x18,%esp
}
  802d5f:	90                   	nop
  802d60:	c9                   	leave  
  802d61:	c3                   	ret    

00802d62 <sys_unlock_cons>:
void sys_unlock_cons(void) {
  802d62:	55                   	push   %ebp
  802d63:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802d65:	6a 00                	push   $0x0
  802d67:	6a 00                	push   $0x0
  802d69:	6a 00                	push   $0x0
  802d6b:	6a 00                	push   $0x0
  802d6d:	6a 00                	push   $0x0
  802d6f:	6a 04                	push   $0x4
  802d71:	e8 65 ff ff ff       	call   802cdb <syscall>
  802d76:	83 c4 18             	add    $0x18,%esp
}
  802d79:	90                   	nop
  802d7a:	c9                   	leave  
  802d7b:	c3                   	ret    

00802d7c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  802d7c:	55                   	push   %ebp
  802d7d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  802d7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d82:	8b 45 08             	mov    0x8(%ebp),%eax
  802d85:	6a 00                	push   $0x0
  802d87:	6a 00                	push   $0x0
  802d89:	6a 00                	push   $0x0
  802d8b:	52                   	push   %edx
  802d8c:	50                   	push   %eax
  802d8d:	6a 08                	push   $0x8
  802d8f:	e8 47 ff ff ff       	call   802cdb <syscall>
  802d94:	83 c4 18             	add    $0x18,%esp
}
  802d97:	c9                   	leave  
  802d98:	c3                   	ret    

00802d99 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  802d99:	55                   	push   %ebp
  802d9a:	89 e5                	mov    %esp,%ebp
  802d9c:	56                   	push   %esi
  802d9d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  802d9e:	8b 75 18             	mov    0x18(%ebp),%esi
  802da1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802da4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802da7:	8b 55 0c             	mov    0xc(%ebp),%edx
  802daa:	8b 45 08             	mov    0x8(%ebp),%eax
  802dad:	56                   	push   %esi
  802dae:	53                   	push   %ebx
  802daf:	51                   	push   %ecx
  802db0:	52                   	push   %edx
  802db1:	50                   	push   %eax
  802db2:	6a 09                	push   $0x9
  802db4:	e8 22 ff ff ff       	call   802cdb <syscall>
  802db9:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  802dbc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802dbf:	5b                   	pop    %ebx
  802dc0:	5e                   	pop    %esi
  802dc1:	5d                   	pop    %ebp
  802dc2:	c3                   	ret    

00802dc3 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  802dc3:	55                   	push   %ebp
  802dc4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802dc6:	8b 55 0c             	mov    0xc(%ebp),%edx
  802dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dcc:	6a 00                	push   $0x0
  802dce:	6a 00                	push   $0x0
  802dd0:	6a 00                	push   $0x0
  802dd2:	52                   	push   %edx
  802dd3:	50                   	push   %eax
  802dd4:	6a 0a                	push   $0xa
  802dd6:	e8 00 ff ff ff       	call   802cdb <syscall>
  802ddb:	83 c4 18             	add    $0x18,%esp
}
  802dde:	c9                   	leave  
  802ddf:	c3                   	ret    

00802de0 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  802de0:	55                   	push   %ebp
  802de1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  802de3:	6a 00                	push   $0x0
  802de5:	6a 00                	push   $0x0
  802de7:	6a 00                	push   $0x0
  802de9:	ff 75 0c             	pushl  0xc(%ebp)
  802dec:	ff 75 08             	pushl  0x8(%ebp)
  802def:	6a 0b                	push   $0xb
  802df1:	e8 e5 fe ff ff       	call   802cdb <syscall>
  802df6:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  802df9:	c9                   	leave  
  802dfa:	c3                   	ret    

00802dfb <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  802dfb:	55                   	push   %ebp
  802dfc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802dfe:	6a 00                	push   $0x0
  802e00:	6a 00                	push   $0x0
  802e02:	6a 00                	push   $0x0
  802e04:	6a 00                	push   $0x0
  802e06:	6a 00                	push   $0x0
  802e08:	6a 0c                	push   $0xc
  802e0a:	e8 cc fe ff ff       	call   802cdb <syscall>
  802e0f:	83 c4 18             	add    $0x18,%esp
}
  802e12:	c9                   	leave  
  802e13:	c3                   	ret    

00802e14 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  802e14:	55                   	push   %ebp
  802e15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802e17:	6a 00                	push   $0x0
  802e19:	6a 00                	push   $0x0
  802e1b:	6a 00                	push   $0x0
  802e1d:	6a 00                	push   $0x0
  802e1f:	6a 00                	push   $0x0
  802e21:	6a 0d                	push   $0xd
  802e23:	e8 b3 fe ff ff       	call   802cdb <syscall>
  802e28:	83 c4 18             	add    $0x18,%esp
}
  802e2b:	c9                   	leave  
  802e2c:	c3                   	ret    

00802e2d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  802e2d:	55                   	push   %ebp
  802e2e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802e30:	6a 00                	push   $0x0
  802e32:	6a 00                	push   $0x0
  802e34:	6a 00                	push   $0x0
  802e36:	6a 00                	push   $0x0
  802e38:	6a 00                	push   $0x0
  802e3a:	6a 0e                	push   $0xe
  802e3c:	e8 9a fe ff ff       	call   802cdb <syscall>
  802e41:	83 c4 18             	add    $0x18,%esp
}
  802e44:	c9                   	leave  
  802e45:	c3                   	ret    

00802e46 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  802e46:	55                   	push   %ebp
  802e47:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  802e49:	6a 00                	push   $0x0
  802e4b:	6a 00                	push   $0x0
  802e4d:	6a 00                	push   $0x0
  802e4f:	6a 00                	push   $0x0
  802e51:	6a 00                	push   $0x0
  802e53:	6a 0f                	push   $0xf
  802e55:	e8 81 fe ff ff       	call   802cdb <syscall>
  802e5a:	83 c4 18             	add    $0x18,%esp
}
  802e5d:	c9                   	leave  
  802e5e:	c3                   	ret    

00802e5f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  802e5f:	55                   	push   %ebp
  802e60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  802e62:	6a 00                	push   $0x0
  802e64:	6a 00                	push   $0x0
  802e66:	6a 00                	push   $0x0
  802e68:	6a 00                	push   $0x0
  802e6a:	ff 75 08             	pushl  0x8(%ebp)
  802e6d:	6a 10                	push   $0x10
  802e6f:	e8 67 fe ff ff       	call   802cdb <syscall>
  802e74:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  802e77:	c9                   	leave  
  802e78:	c3                   	ret    

00802e79 <sys_scarce_memory>:

void sys_scarce_memory() {
  802e79:	55                   	push   %ebp
  802e7a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  802e7c:	6a 00                	push   $0x0
  802e7e:	6a 00                	push   $0x0
  802e80:	6a 00                	push   $0x0
  802e82:	6a 00                	push   $0x0
  802e84:	6a 00                	push   $0x0
  802e86:	6a 11                	push   $0x11
  802e88:	e8 4e fe ff ff       	call   802cdb <syscall>
  802e8d:	83 c4 18             	add    $0x18,%esp
}
  802e90:	90                   	nop
  802e91:	c9                   	leave  
  802e92:	c3                   	ret    

00802e93 <sys_cputc>:

void sys_cputc(const char c) {
  802e93:	55                   	push   %ebp
  802e94:	89 e5                	mov    %esp,%ebp
  802e96:	83 ec 04             	sub    $0x4,%esp
  802e99:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802e9f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802ea3:	6a 00                	push   $0x0
  802ea5:	6a 00                	push   $0x0
  802ea7:	6a 00                	push   $0x0
  802ea9:	6a 00                	push   $0x0
  802eab:	50                   	push   %eax
  802eac:	6a 01                	push   $0x1
  802eae:	e8 28 fe ff ff       	call   802cdb <syscall>
  802eb3:	83 c4 18             	add    $0x18,%esp
}
  802eb6:	90                   	nop
  802eb7:	c9                   	leave  
  802eb8:	c3                   	ret    

00802eb9 <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  802eb9:	55                   	push   %ebp
  802eba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  802ebc:	6a 00                	push   $0x0
  802ebe:	6a 00                	push   $0x0
  802ec0:	6a 00                	push   $0x0
  802ec2:	6a 00                	push   $0x0
  802ec4:	6a 00                	push   $0x0
  802ec6:	6a 14                	push   $0x14
  802ec8:	e8 0e fe ff ff       	call   802cdb <syscall>
  802ecd:	83 c4 18             	add    $0x18,%esp
}
  802ed0:	90                   	nop
  802ed1:	c9                   	leave  
  802ed2:	c3                   	ret    

00802ed3 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  802ed3:	55                   	push   %ebp
  802ed4:	89 e5                	mov    %esp,%ebp
  802ed6:	83 ec 04             	sub    $0x4,%esp
  802ed9:	8b 45 10             	mov    0x10(%ebp),%eax
  802edc:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  802edf:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802ee2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee9:	6a 00                	push   $0x0
  802eeb:	51                   	push   %ecx
  802eec:	52                   	push   %edx
  802eed:	ff 75 0c             	pushl  0xc(%ebp)
  802ef0:	50                   	push   %eax
  802ef1:	6a 15                	push   $0x15
  802ef3:	e8 e3 fd ff ff       	call   802cdb <syscall>
  802ef8:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  802efb:	c9                   	leave  
  802efc:	c3                   	ret    

00802efd <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  802efd:	55                   	push   %ebp
  802efe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  802f00:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f03:	8b 45 08             	mov    0x8(%ebp),%eax
  802f06:	6a 00                	push   $0x0
  802f08:	6a 00                	push   $0x0
  802f0a:	6a 00                	push   $0x0
  802f0c:	52                   	push   %edx
  802f0d:	50                   	push   %eax
  802f0e:	6a 16                	push   $0x16
  802f10:	e8 c6 fd ff ff       	call   802cdb <syscall>
  802f15:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  802f18:	c9                   	leave  
  802f19:	c3                   	ret    

00802f1a <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  802f1a:	55                   	push   %ebp
  802f1b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  802f1d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802f20:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f23:	8b 45 08             	mov    0x8(%ebp),%eax
  802f26:	6a 00                	push   $0x0
  802f28:	6a 00                	push   $0x0
  802f2a:	51                   	push   %ecx
  802f2b:	52                   	push   %edx
  802f2c:	50                   	push   %eax
  802f2d:	6a 17                	push   $0x17
  802f2f:	e8 a7 fd ff ff       	call   802cdb <syscall>
  802f34:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  802f37:	c9                   	leave  
  802f38:	c3                   	ret    

00802f39 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  802f39:	55                   	push   %ebp
  802f3a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  802f3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f42:	6a 00                	push   $0x0
  802f44:	6a 00                	push   $0x0
  802f46:	6a 00                	push   $0x0
  802f48:	52                   	push   %edx
  802f49:	50                   	push   %eax
  802f4a:	6a 18                	push   $0x18
  802f4c:	e8 8a fd ff ff       	call   802cdb <syscall>
  802f51:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  802f54:	c9                   	leave  
  802f55:	c3                   	ret    

00802f56 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  802f56:	55                   	push   %ebp
  802f57:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  802f59:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5c:	6a 00                	push   $0x0
  802f5e:	ff 75 14             	pushl  0x14(%ebp)
  802f61:	ff 75 10             	pushl  0x10(%ebp)
  802f64:	ff 75 0c             	pushl  0xc(%ebp)
  802f67:	50                   	push   %eax
  802f68:	6a 19                	push   $0x19
  802f6a:	e8 6c fd ff ff       	call   802cdb <syscall>
  802f6f:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  802f72:	c9                   	leave  
  802f73:	c3                   	ret    

00802f74 <sys_run_env>:

void sys_run_env(int32 envId) {
  802f74:	55                   	push   %ebp
  802f75:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  802f77:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7a:	6a 00                	push   $0x0
  802f7c:	6a 00                	push   $0x0
  802f7e:	6a 00                	push   $0x0
  802f80:	6a 00                	push   $0x0
  802f82:	50                   	push   %eax
  802f83:	6a 1a                	push   $0x1a
  802f85:	e8 51 fd ff ff       	call   802cdb <syscall>
  802f8a:	83 c4 18             	add    $0x18,%esp
}
  802f8d:	90                   	nop
  802f8e:	c9                   	leave  
  802f8f:	c3                   	ret    

00802f90 <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  802f90:	55                   	push   %ebp
  802f91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802f93:	8b 45 08             	mov    0x8(%ebp),%eax
  802f96:	6a 00                	push   $0x0
  802f98:	6a 00                	push   $0x0
  802f9a:	6a 00                	push   $0x0
  802f9c:	6a 00                	push   $0x0
  802f9e:	50                   	push   %eax
  802f9f:	6a 1b                	push   $0x1b
  802fa1:	e8 35 fd ff ff       	call   802cdb <syscall>
  802fa6:	83 c4 18             	add    $0x18,%esp
}
  802fa9:	c9                   	leave  
  802faa:	c3                   	ret    

00802fab <sys_getenvid>:

int32 sys_getenvid(void) {
  802fab:	55                   	push   %ebp
  802fac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802fae:	6a 00                	push   $0x0
  802fb0:	6a 00                	push   $0x0
  802fb2:	6a 00                	push   $0x0
  802fb4:	6a 00                	push   $0x0
  802fb6:	6a 00                	push   $0x0
  802fb8:	6a 05                	push   $0x5
  802fba:	e8 1c fd ff ff       	call   802cdb <syscall>
  802fbf:	83 c4 18             	add    $0x18,%esp
}
  802fc2:	c9                   	leave  
  802fc3:	c3                   	ret    

00802fc4 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  802fc4:	55                   	push   %ebp
  802fc5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802fc7:	6a 00                	push   $0x0
  802fc9:	6a 00                	push   $0x0
  802fcb:	6a 00                	push   $0x0
  802fcd:	6a 00                	push   $0x0
  802fcf:	6a 00                	push   $0x0
  802fd1:	6a 06                	push   $0x6
  802fd3:	e8 03 fd ff ff       	call   802cdb <syscall>
  802fd8:	83 c4 18             	add    $0x18,%esp
}
  802fdb:	c9                   	leave  
  802fdc:	c3                   	ret    

00802fdd <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  802fdd:	55                   	push   %ebp
  802fde:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802fe0:	6a 00                	push   $0x0
  802fe2:	6a 00                	push   $0x0
  802fe4:	6a 00                	push   $0x0
  802fe6:	6a 00                	push   $0x0
  802fe8:	6a 00                	push   $0x0
  802fea:	6a 07                	push   $0x7
  802fec:	e8 ea fc ff ff       	call   802cdb <syscall>
  802ff1:	83 c4 18             	add    $0x18,%esp
}
  802ff4:	c9                   	leave  
  802ff5:	c3                   	ret    

00802ff6 <sys_exit_env>:

void sys_exit_env(void) {
  802ff6:	55                   	push   %ebp
  802ff7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802ff9:	6a 00                	push   $0x0
  802ffb:	6a 00                	push   $0x0
  802ffd:	6a 00                	push   $0x0
  802fff:	6a 00                	push   $0x0
  803001:	6a 00                	push   $0x0
  803003:	6a 1c                	push   $0x1c
  803005:	e8 d1 fc ff ff       	call   802cdb <syscall>
  80300a:	83 c4 18             	add    $0x18,%esp
}
  80300d:	90                   	nop
  80300e:	c9                   	leave  
  80300f:	c3                   	ret    

00803010 <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  803010:	55                   	push   %ebp
  803011:	89 e5                	mov    %esp,%ebp
  803013:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  803016:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803019:	8d 50 04             	lea    0x4(%eax),%edx
  80301c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80301f:	6a 00                	push   $0x0
  803021:	6a 00                	push   $0x0
  803023:	6a 00                	push   $0x0
  803025:	52                   	push   %edx
  803026:	50                   	push   %eax
  803027:	6a 1d                	push   $0x1d
  803029:	e8 ad fc ff ff       	call   802cdb <syscall>
  80302e:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  803031:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803034:	8b 45 f8             	mov    -0x8(%ebp),%eax
  803037:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80303a:	89 01                	mov    %eax,(%ecx)
  80303c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80303f:	8b 45 08             	mov    0x8(%ebp),%eax
  803042:	c9                   	leave  
  803043:	c2 04 00             	ret    $0x4

00803046 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  803046:	55                   	push   %ebp
  803047:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  803049:	6a 00                	push   $0x0
  80304b:	6a 00                	push   $0x0
  80304d:	ff 75 10             	pushl  0x10(%ebp)
  803050:	ff 75 0c             	pushl  0xc(%ebp)
  803053:	ff 75 08             	pushl  0x8(%ebp)
  803056:	6a 13                	push   $0x13
  803058:	e8 7e fc ff ff       	call   802cdb <syscall>
  80305d:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  803060:	90                   	nop
}
  803061:	c9                   	leave  
  803062:	c3                   	ret    

00803063 <sys_rcr2>:
uint32 sys_rcr2() {
  803063:	55                   	push   %ebp
  803064:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  803066:	6a 00                	push   $0x0
  803068:	6a 00                	push   $0x0
  80306a:	6a 00                	push   $0x0
  80306c:	6a 00                	push   $0x0
  80306e:	6a 00                	push   $0x0
  803070:	6a 1e                	push   $0x1e
  803072:	e8 64 fc ff ff       	call   802cdb <syscall>
  803077:	83 c4 18             	add    $0x18,%esp
}
  80307a:	c9                   	leave  
  80307b:	c3                   	ret    

0080307c <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  80307c:	55                   	push   %ebp
  80307d:	89 e5                	mov    %esp,%ebp
  80307f:	83 ec 04             	sub    $0x4,%esp
  803082:	8b 45 08             	mov    0x8(%ebp),%eax
  803085:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  803088:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80308c:	6a 00                	push   $0x0
  80308e:	6a 00                	push   $0x0
  803090:	6a 00                	push   $0x0
  803092:	6a 00                	push   $0x0
  803094:	50                   	push   %eax
  803095:	6a 1f                	push   $0x1f
  803097:	e8 3f fc ff ff       	call   802cdb <syscall>
  80309c:	83 c4 18             	add    $0x18,%esp
	return;
  80309f:	90                   	nop
}
  8030a0:	c9                   	leave  
  8030a1:	c3                   	ret    

008030a2 <rsttst>:
void rsttst() {
  8030a2:	55                   	push   %ebp
  8030a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8030a5:	6a 00                	push   $0x0
  8030a7:	6a 00                	push   $0x0
  8030a9:	6a 00                	push   $0x0
  8030ab:	6a 00                	push   $0x0
  8030ad:	6a 00                	push   $0x0
  8030af:	6a 21                	push   $0x21
  8030b1:	e8 25 fc ff ff       	call   802cdb <syscall>
  8030b6:	83 c4 18             	add    $0x18,%esp
	return;
  8030b9:	90                   	nop
}
  8030ba:	c9                   	leave  
  8030bb:	c3                   	ret    

008030bc <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  8030bc:	55                   	push   %ebp
  8030bd:	89 e5                	mov    %esp,%ebp
  8030bf:	83 ec 04             	sub    $0x4,%esp
  8030c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8030c5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8030c8:	8b 55 18             	mov    0x18(%ebp),%edx
  8030cb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8030cf:	52                   	push   %edx
  8030d0:	50                   	push   %eax
  8030d1:	ff 75 10             	pushl  0x10(%ebp)
  8030d4:	ff 75 0c             	pushl  0xc(%ebp)
  8030d7:	ff 75 08             	pushl  0x8(%ebp)
  8030da:	6a 20                	push   $0x20
  8030dc:	e8 fa fb ff ff       	call   802cdb <syscall>
  8030e1:	83 c4 18             	add    $0x18,%esp
	return;
  8030e4:	90                   	nop
}
  8030e5:	c9                   	leave  
  8030e6:	c3                   	ret    

008030e7 <chktst>:
void chktst(uint32 n) {
  8030e7:	55                   	push   %ebp
  8030e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8030ea:	6a 00                	push   $0x0
  8030ec:	6a 00                	push   $0x0
  8030ee:	6a 00                	push   $0x0
  8030f0:	6a 00                	push   $0x0
  8030f2:	ff 75 08             	pushl  0x8(%ebp)
  8030f5:	6a 22                	push   $0x22
  8030f7:	e8 df fb ff ff       	call   802cdb <syscall>
  8030fc:	83 c4 18             	add    $0x18,%esp
	return;
  8030ff:	90                   	nop
}
  803100:	c9                   	leave  
  803101:	c3                   	ret    

00803102 <inctst>:

void inctst() {
  803102:	55                   	push   %ebp
  803103:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  803105:	6a 00                	push   $0x0
  803107:	6a 00                	push   $0x0
  803109:	6a 00                	push   $0x0
  80310b:	6a 00                	push   $0x0
  80310d:	6a 00                	push   $0x0
  80310f:	6a 23                	push   $0x23
  803111:	e8 c5 fb ff ff       	call   802cdb <syscall>
  803116:	83 c4 18             	add    $0x18,%esp
	return;
  803119:	90                   	nop
}
  80311a:	c9                   	leave  
  80311b:	c3                   	ret    

0080311c <gettst>:
uint32 gettst() {
  80311c:	55                   	push   %ebp
  80311d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80311f:	6a 00                	push   $0x0
  803121:	6a 00                	push   $0x0
  803123:	6a 00                	push   $0x0
  803125:	6a 00                	push   $0x0
  803127:	6a 00                	push   $0x0
  803129:	6a 24                	push   $0x24
  80312b:	e8 ab fb ff ff       	call   802cdb <syscall>
  803130:	83 c4 18             	add    $0x18,%esp
}
  803133:	c9                   	leave  
  803134:	c3                   	ret    

00803135 <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  803135:	55                   	push   %ebp
  803136:	89 e5                	mov    %esp,%ebp
  803138:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80313b:	6a 00                	push   $0x0
  80313d:	6a 00                	push   $0x0
  80313f:	6a 00                	push   $0x0
  803141:	6a 00                	push   $0x0
  803143:	6a 00                	push   $0x0
  803145:	6a 25                	push   $0x25
  803147:	e8 8f fb ff ff       	call   802cdb <syscall>
  80314c:	83 c4 18             	add    $0x18,%esp
  80314f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  803152:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  803156:	75 07                	jne    80315f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  803158:	b8 01 00 00 00       	mov    $0x1,%eax
  80315d:	eb 05                	jmp    803164 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80315f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803164:	c9                   	leave  
  803165:	c3                   	ret    

00803166 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  803166:	55                   	push   %ebp
  803167:	89 e5                	mov    %esp,%ebp
  803169:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80316c:	6a 00                	push   $0x0
  80316e:	6a 00                	push   $0x0
  803170:	6a 00                	push   $0x0
  803172:	6a 00                	push   $0x0
  803174:	6a 00                	push   $0x0
  803176:	6a 25                	push   $0x25
  803178:	e8 5e fb ff ff       	call   802cdb <syscall>
  80317d:	83 c4 18             	add    $0x18,%esp
  803180:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  803183:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  803187:	75 07                	jne    803190 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  803189:	b8 01 00 00 00       	mov    $0x1,%eax
  80318e:	eb 05                	jmp    803195 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  803190:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803195:	c9                   	leave  
  803196:	c3                   	ret    

00803197 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  803197:	55                   	push   %ebp
  803198:	89 e5                	mov    %esp,%ebp
  80319a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80319d:	6a 00                	push   $0x0
  80319f:	6a 00                	push   $0x0
  8031a1:	6a 00                	push   $0x0
  8031a3:	6a 00                	push   $0x0
  8031a5:	6a 00                	push   $0x0
  8031a7:	6a 25                	push   $0x25
  8031a9:	e8 2d fb ff ff       	call   802cdb <syscall>
  8031ae:	83 c4 18             	add    $0x18,%esp
  8031b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8031b4:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8031b8:	75 07                	jne    8031c1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8031ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8031bf:	eb 05                	jmp    8031c6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8031c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031c6:	c9                   	leave  
  8031c7:	c3                   	ret    

008031c8 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  8031c8:	55                   	push   %ebp
  8031c9:	89 e5                	mov    %esp,%ebp
  8031cb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8031ce:	6a 00                	push   $0x0
  8031d0:	6a 00                	push   $0x0
  8031d2:	6a 00                	push   $0x0
  8031d4:	6a 00                	push   $0x0
  8031d6:	6a 00                	push   $0x0
  8031d8:	6a 25                	push   $0x25
  8031da:	e8 fc fa ff ff       	call   802cdb <syscall>
  8031df:	83 c4 18             	add    $0x18,%esp
  8031e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8031e5:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8031e9:	75 07                	jne    8031f2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8031eb:	b8 01 00 00 00       	mov    $0x1,%eax
  8031f0:	eb 05                	jmp    8031f7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8031f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031f7:	c9                   	leave  
  8031f8:	c3                   	ret    

008031f9 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  8031f9:	55                   	push   %ebp
  8031fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8031fc:	6a 00                	push   $0x0
  8031fe:	6a 00                	push   $0x0
  803200:	6a 00                	push   $0x0
  803202:	6a 00                	push   $0x0
  803204:	ff 75 08             	pushl  0x8(%ebp)
  803207:	6a 26                	push   $0x26
  803209:	e8 cd fa ff ff       	call   802cdb <syscall>
  80320e:	83 c4 18             	add    $0x18,%esp
	return;
  803211:	90                   	nop
}
  803212:	c9                   	leave  
  803213:	c3                   	ret    

00803214 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  803214:	55                   	push   %ebp
  803215:	89 e5                	mov    %esp,%ebp
  803217:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  803218:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80321b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80321e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803221:	8b 45 08             	mov    0x8(%ebp),%eax
  803224:	6a 00                	push   $0x0
  803226:	53                   	push   %ebx
  803227:	51                   	push   %ecx
  803228:	52                   	push   %edx
  803229:	50                   	push   %eax
  80322a:	6a 27                	push   $0x27
  80322c:	e8 aa fa ff ff       	call   802cdb <syscall>
  803231:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  803234:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803237:	c9                   	leave  
  803238:	c3                   	ret    

00803239 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  803239:	55                   	push   %ebp
  80323a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  80323c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80323f:	8b 45 08             	mov    0x8(%ebp),%eax
  803242:	6a 00                	push   $0x0
  803244:	6a 00                	push   $0x0
  803246:	6a 00                	push   $0x0
  803248:	52                   	push   %edx
  803249:	50                   	push   %eax
  80324a:	6a 28                	push   $0x28
  80324c:	e8 8a fa ff ff       	call   802cdb <syscall>
  803251:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  803254:	c9                   	leave  
  803255:	c3                   	ret    

00803256 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  803256:	55                   	push   %ebp
  803257:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  803259:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80325c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80325f:	8b 45 08             	mov    0x8(%ebp),%eax
  803262:	6a 00                	push   $0x0
  803264:	51                   	push   %ecx
  803265:	ff 75 10             	pushl  0x10(%ebp)
  803268:	52                   	push   %edx
  803269:	50                   	push   %eax
  80326a:	6a 29                	push   $0x29
  80326c:	e8 6a fa ff ff       	call   802cdb <syscall>
  803271:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  803274:	c9                   	leave  
  803275:	c3                   	ret    

00803276 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  803276:	55                   	push   %ebp
  803277:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  803279:	6a 00                	push   $0x0
  80327b:	6a 00                	push   $0x0
  80327d:	ff 75 10             	pushl  0x10(%ebp)
  803280:	ff 75 0c             	pushl  0xc(%ebp)
  803283:	ff 75 08             	pushl  0x8(%ebp)
  803286:	6a 12                	push   $0x12
  803288:	e8 4e fa ff ff       	call   802cdb <syscall>
  80328d:	83 c4 18             	add    $0x18,%esp
	return;
  803290:	90                   	nop
}
  803291:	c9                   	leave  
  803292:	c3                   	ret    

00803293 <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  803293:	55                   	push   %ebp
  803294:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  803296:	8b 55 0c             	mov    0xc(%ebp),%edx
  803299:	8b 45 08             	mov    0x8(%ebp),%eax
  80329c:	6a 00                	push   $0x0
  80329e:	6a 00                	push   $0x0
  8032a0:	6a 00                	push   $0x0
  8032a2:	52                   	push   %edx
  8032a3:	50                   	push   %eax
  8032a4:	6a 2a                	push   $0x2a
  8032a6:	e8 30 fa ff ff       	call   802cdb <syscall>
  8032ab:	83 c4 18             	add    $0x18,%esp
	return;
  8032ae:	90                   	nop
}
  8032af:	c9                   	leave  
  8032b0:	c3                   	ret    

008032b1 <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  8032b1:	55                   	push   %ebp
  8032b2:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  8032b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b7:	6a 00                	push   $0x0
  8032b9:	6a 00                	push   $0x0
  8032bb:	6a 00                	push   $0x0
  8032bd:	6a 00                	push   $0x0
  8032bf:	50                   	push   %eax
  8032c0:	6a 2b                	push   $0x2b
  8032c2:	e8 14 fa ff ff       	call   802cdb <syscall>
  8032c7:	83 c4 18             	add    $0x18,%esp
}
  8032ca:	c9                   	leave  
  8032cb:	c3                   	ret    

008032cc <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  8032cc:	55                   	push   %ebp
  8032cd:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8032cf:	6a 00                	push   $0x0
  8032d1:	6a 00                	push   $0x0
  8032d3:	6a 00                	push   $0x0
  8032d5:	ff 75 0c             	pushl  0xc(%ebp)
  8032d8:	ff 75 08             	pushl  0x8(%ebp)
  8032db:	6a 2c                	push   $0x2c
  8032dd:	e8 f9 f9 ff ff       	call   802cdb <syscall>
  8032e2:	83 c4 18             	add    $0x18,%esp
	return;
  8032e5:	90                   	nop
}
  8032e6:	c9                   	leave  
  8032e7:	c3                   	ret    

008032e8 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  8032e8:	55                   	push   %ebp
  8032e9:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8032eb:	6a 00                	push   $0x0
  8032ed:	6a 00                	push   $0x0
  8032ef:	6a 00                	push   $0x0
  8032f1:	ff 75 0c             	pushl  0xc(%ebp)
  8032f4:	ff 75 08             	pushl  0x8(%ebp)
  8032f7:	6a 2d                	push   $0x2d
  8032f9:	e8 dd f9 ff ff       	call   802cdb <syscall>
  8032fe:	83 c4 18             	add    $0x18,%esp
	return;
  803301:	90                   	nop
}
  803302:	c9                   	leave  
  803303:	c3                   	ret    

00803304 <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  803304:	55                   	push   %ebp
  803305:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  803307:	8b 45 08             	mov    0x8(%ebp),%eax
  80330a:	6a 00                	push   $0x0
  80330c:	6a 00                	push   $0x0
  80330e:	6a 00                	push   $0x0
  803310:	6a 00                	push   $0x0
  803312:	50                   	push   %eax
  803313:	6a 2f                	push   $0x2f
  803315:	e8 c1 f9 ff ff       	call   802cdb <syscall>
  80331a:	83 c4 18             	add    $0x18,%esp
	return;
  80331d:	90                   	nop
}
  80331e:	c9                   	leave  
  80331f:	c3                   	ret    

00803320 <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  803320:	55                   	push   %ebp
  803321:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  803323:	8b 55 0c             	mov    0xc(%ebp),%edx
  803326:	8b 45 08             	mov    0x8(%ebp),%eax
  803329:	6a 00                	push   $0x0
  80332b:	6a 00                	push   $0x0
  80332d:	6a 00                	push   $0x0
  80332f:	52                   	push   %edx
  803330:	50                   	push   %eax
  803331:	6a 30                	push   $0x30
  803333:	e8 a3 f9 ff ff       	call   802cdb <syscall>
  803338:	83 c4 18             	add    $0x18,%esp
	return;
  80333b:	90                   	nop
}
  80333c:	c9                   	leave  
  80333d:	c3                   	ret    

0080333e <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  80333e:	55                   	push   %ebp
  80333f:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  803341:	8b 45 08             	mov    0x8(%ebp),%eax
  803344:	6a 00                	push   $0x0
  803346:	6a 00                	push   $0x0
  803348:	6a 00                	push   $0x0
  80334a:	6a 00                	push   $0x0
  80334c:	50                   	push   %eax
  80334d:	6a 31                	push   $0x31
  80334f:	e8 87 f9 ff ff       	call   802cdb <syscall>
  803354:	83 c4 18             	add    $0x18,%esp
	return;
  803357:	90                   	nop
}
  803358:	c9                   	leave  
  803359:	c3                   	ret    

0080335a <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  80335a:	55                   	push   %ebp
  80335b:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  80335d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803360:	8b 45 08             	mov    0x8(%ebp),%eax
  803363:	6a 00                	push   $0x0
  803365:	6a 00                	push   $0x0
  803367:	6a 00                	push   $0x0
  803369:	52                   	push   %edx
  80336a:	50                   	push   %eax
  80336b:	6a 2e                	push   $0x2e
  80336d:	e8 69 f9 ff ff       	call   802cdb <syscall>
  803372:	83 c4 18             	add    $0x18,%esp
    return;
  803375:	90                   	nop
}
  803376:	c9                   	leave  
  803377:	c3                   	ret    

00803378 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  803378:	55                   	push   %ebp
  803379:	89 e5                	mov    %esp,%ebp
  80337b:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80337e:	8b 45 08             	mov    0x8(%ebp),%eax
  803381:	83 e8 04             	sub    $0x4,%eax
  803384:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  803387:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80338a:	8b 00                	mov    (%eax),%eax
  80338c:	83 e0 fe             	and    $0xfffffffe,%eax
}
  80338f:	c9                   	leave  
  803390:	c3                   	ret    

00803391 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  803391:	55                   	push   %ebp
  803392:	89 e5                	mov    %esp,%ebp
  803394:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  803397:	8b 45 08             	mov    0x8(%ebp),%eax
  80339a:	83 e8 04             	sub    $0x4,%eax
  80339d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  8033a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8033a3:	8b 00                	mov    (%eax),%eax
  8033a5:	83 e0 01             	and    $0x1,%eax
  8033a8:	85 c0                	test   %eax,%eax
  8033aa:	0f 94 c0             	sete   %al
}
  8033ad:	c9                   	leave  
  8033ae:	c3                   	ret    

008033af <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8033af:	55                   	push   %ebp
  8033b0:	89 e5                	mov    %esp,%ebp
  8033b2:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8033b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8033bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033bf:	83 f8 02             	cmp    $0x2,%eax
  8033c2:	74 2b                	je     8033ef <alloc_block+0x40>
  8033c4:	83 f8 02             	cmp    $0x2,%eax
  8033c7:	7f 07                	jg     8033d0 <alloc_block+0x21>
  8033c9:	83 f8 01             	cmp    $0x1,%eax
  8033cc:	74 0e                	je     8033dc <alloc_block+0x2d>
  8033ce:	eb 58                	jmp    803428 <alloc_block+0x79>
  8033d0:	83 f8 03             	cmp    $0x3,%eax
  8033d3:	74 2d                	je     803402 <alloc_block+0x53>
  8033d5:	83 f8 04             	cmp    $0x4,%eax
  8033d8:	74 3b                	je     803415 <alloc_block+0x66>
  8033da:	eb 4c                	jmp    803428 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8033dc:	83 ec 0c             	sub    $0xc,%esp
  8033df:	ff 75 08             	pushl  0x8(%ebp)
  8033e2:	e8 f7 03 00 00       	call   8037de <alloc_block_FF>
  8033e7:	83 c4 10             	add    $0x10,%esp
  8033ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8033ed:	eb 4a                	jmp    803439 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8033ef:	83 ec 0c             	sub    $0xc,%esp
  8033f2:	ff 75 08             	pushl  0x8(%ebp)
  8033f5:	e8 f0 11 00 00       	call   8045ea <alloc_block_NF>
  8033fa:	83 c4 10             	add    $0x10,%esp
  8033fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  803400:	eb 37                	jmp    803439 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  803402:	83 ec 0c             	sub    $0xc,%esp
  803405:	ff 75 08             	pushl  0x8(%ebp)
  803408:	e8 08 08 00 00       	call   803c15 <alloc_block_BF>
  80340d:	83 c4 10             	add    $0x10,%esp
  803410:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  803413:	eb 24                	jmp    803439 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  803415:	83 ec 0c             	sub    $0xc,%esp
  803418:	ff 75 08             	pushl  0x8(%ebp)
  80341b:	e8 ad 11 00 00       	call   8045cd <alloc_block_WF>
  803420:	83 c4 10             	add    $0x10,%esp
  803423:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  803426:	eb 11                	jmp    803439 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  803428:	83 ec 0c             	sub    $0xc,%esp
  80342b:	68 38 51 80 00       	push   $0x805138
  803430:	e8 41 e4 ff ff       	call   801876 <cprintf>
  803435:	83 c4 10             	add    $0x10,%esp
		break;
  803438:	90                   	nop
	}
	return va;
  803439:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80343c:	c9                   	leave  
  80343d:	c3                   	ret    

0080343e <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  80343e:	55                   	push   %ebp
  80343f:	89 e5                	mov    %esp,%ebp
  803441:	53                   	push   %ebx
  803442:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  803445:	83 ec 0c             	sub    $0xc,%esp
  803448:	68 58 51 80 00       	push   $0x805158
  80344d:	e8 24 e4 ff ff       	call   801876 <cprintf>
  803452:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  803455:	83 ec 0c             	sub    $0xc,%esp
  803458:	68 83 51 80 00       	push   $0x805183
  80345d:	e8 14 e4 ff ff       	call   801876 <cprintf>
  803462:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  803465:	8b 45 08             	mov    0x8(%ebp),%eax
  803468:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80346b:	eb 37                	jmp    8034a4 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  80346d:	83 ec 0c             	sub    $0xc,%esp
  803470:	ff 75 f4             	pushl  -0xc(%ebp)
  803473:	e8 19 ff ff ff       	call   803391 <is_free_block>
  803478:	83 c4 10             	add    $0x10,%esp
  80347b:	0f be d8             	movsbl %al,%ebx
  80347e:	83 ec 0c             	sub    $0xc,%esp
  803481:	ff 75 f4             	pushl  -0xc(%ebp)
  803484:	e8 ef fe ff ff       	call   803378 <get_block_size>
  803489:	83 c4 10             	add    $0x10,%esp
  80348c:	83 ec 04             	sub    $0x4,%esp
  80348f:	53                   	push   %ebx
  803490:	50                   	push   %eax
  803491:	68 9b 51 80 00       	push   $0x80519b
  803496:	e8 db e3 ff ff       	call   801876 <cprintf>
  80349b:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  80349e:	8b 45 10             	mov    0x10(%ebp),%eax
  8034a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034a8:	74 07                	je     8034b1 <print_blocks_list+0x73>
  8034aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ad:	8b 00                	mov    (%eax),%eax
  8034af:	eb 05                	jmp    8034b6 <print_blocks_list+0x78>
  8034b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8034b6:	89 45 10             	mov    %eax,0x10(%ebp)
  8034b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8034bc:	85 c0                	test   %eax,%eax
  8034be:	75 ad                	jne    80346d <print_blocks_list+0x2f>
  8034c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034c4:	75 a7                	jne    80346d <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8034c6:	83 ec 0c             	sub    $0xc,%esp
  8034c9:	68 58 51 80 00       	push   $0x805158
  8034ce:	e8 a3 e3 ff ff       	call   801876 <cprintf>
  8034d3:	83 c4 10             	add    $0x10,%esp

}
  8034d6:	90                   	nop
  8034d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8034da:	c9                   	leave  
  8034db:	c3                   	ret    

008034dc <initialize_dynamic_allocator>:

//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8034dc:	55                   	push   %ebp
  8034dd:	89 e5                	mov    %esp,%ebp
  8034df:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8034e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034e5:	83 e0 01             	and    $0x1,%eax
  8034e8:	85 c0                	test   %eax,%eax
  8034ea:	74 03                	je     8034ef <initialize_dynamic_allocator+0x13>
  8034ec:	ff 45 0c             	incl   0xc(%ebp)
		if (initSizeOfAllocatedSpace == 0)
  8034ef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8034f3:	0f 84 f8 00 00 00    	je     8035f1 <initialize_dynamic_allocator+0x115>
			return ;
		is_initialized = 1;
  8034f9:	c7 05 40 60 98 00 01 	movl   $0x1,0x986040
  803500:	00 00 00 
	//TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("initialize_dynamic_allocator is not implemented yet");
	//Your Code is Here...

	if(is_initialized){
  803503:	a1 40 60 98 00       	mov    0x986040,%eax
  803508:	85 c0                	test   %eax,%eax
  80350a:	0f 84 e2 00 00 00    	je     8035f2 <initialize_dynamic_allocator+0x116>

		// begin block with size 0 and lsb = 1 (allocated)
		uint32* beginBlock = (uint32*)daStart;
  803510:	8b 45 08             	mov    0x8(%ebp),%eax
  803513:	89 45 f4             	mov    %eax,-0xc(%ebp)
		*beginBlock = 0 | 1; // size = 0, LSB as a flag = 1
  803516:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803519:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		// end block with size 0 and lsb = 1 (allocated)
		uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);
  80351f:	8b 55 08             	mov    0x8(%ebp),%edx
  803522:	8b 45 0c             	mov    0xc(%ebp),%eax
  803525:	01 d0                	add    %edx,%eax
  803527:	83 e8 04             	sub    $0x4,%eax
  80352a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		*endBlock = 0 | 1; // size = 0, LSB as a flag = 1
  80352d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803530:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

		// the block that between begin and end blocks
		struct BlockElement* block = (struct BlockElement*)(daStart + 8);
  803536:	8b 45 08             	mov    0x8(%ebp),%eax
  803539:	83 c0 08             	add    $0x8,%eax
  80353c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 blockSize = initSizeOfAllocatedSpace - 8; // subtract size of begin and end blocks
  80353f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803542:	83 e8 08             	sub    $0x8,%eax
  803545:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(block,blockSize,0);
  803548:	83 ec 04             	sub    $0x4,%esp
  80354b:	6a 00                	push   $0x0
  80354d:	ff 75 e8             	pushl  -0x18(%ebp)
  803550:	ff 75 ec             	pushl  -0x14(%ebp)
  803553:	e8 9c 00 00 00       	call   8035f4 <set_block_data>
  803558:	83 c4 10             	add    $0x10,%esp

		block->prev_next_info.le_next = NULL;
  80355b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80355e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block->prev_next_info.le_prev = NULL;
  803564:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803567:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

		LIST_INIT(&freeBlocksList);
  80356e:	c7 05 48 60 98 00 00 	movl   $0x0,0x986048
  803575:	00 00 00 
  803578:	c7 05 4c 60 98 00 00 	movl   $0x0,0x98604c
  80357f:	00 00 00 
  803582:	c7 05 54 60 98 00 00 	movl   $0x0,0x986054
  803589:	00 00 00 
		LIST_INSERT_HEAD(&freeBlocksList, block);
  80358c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803590:	75 17                	jne    8035a9 <initialize_dynamic_allocator+0xcd>
  803592:	83 ec 04             	sub    $0x4,%esp
  803595:	68 b4 51 80 00       	push   $0x8051b4
  80359a:	68 80 00 00 00       	push   $0x80
  80359f:	68 d7 51 80 00       	push   $0x8051d7
  8035a4:	e8 10 e0 ff ff       	call   8015b9 <_panic>
  8035a9:	8b 15 48 60 98 00    	mov    0x986048,%edx
  8035af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035b2:	89 10                	mov    %edx,(%eax)
  8035b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035b7:	8b 00                	mov    (%eax),%eax
  8035b9:	85 c0                	test   %eax,%eax
  8035bb:	74 0d                	je     8035ca <initialize_dynamic_allocator+0xee>
  8035bd:	a1 48 60 98 00       	mov    0x986048,%eax
  8035c2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8035c5:	89 50 04             	mov    %edx,0x4(%eax)
  8035c8:	eb 08                	jmp    8035d2 <initialize_dynamic_allocator+0xf6>
  8035ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035cd:	a3 4c 60 98 00       	mov    %eax,0x98604c
  8035d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035d5:	a3 48 60 98 00       	mov    %eax,0x986048
  8035da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035dd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035e4:	a1 54 60 98 00       	mov    0x986054,%eax
  8035e9:	40                   	inc    %eax
  8035ea:	a3 54 60 98 00       	mov    %eax,0x986054
  8035ef:	eb 01                	jmp    8035f2 <initialize_dynamic_allocator+0x116>
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
		if (initSizeOfAllocatedSpace == 0)
			return ;
  8035f1:	90                   	nop
		block->prev_next_info.le_prev = NULL;

		LIST_INIT(&freeBlocksList);
		LIST_INSERT_HEAD(&freeBlocksList, block);
	}
}
  8035f2:	c9                   	leave  
  8035f3:	c3                   	ret    

008035f4 <set_block_data>:
//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8035f4:	55                   	push   %ebp
  8035f5:	89 e5                	mov    %esp,%ebp
  8035f7:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("set_block_data is not implemented yet");
	//Your Code is Here...

	if(totalSize % 2 != 0)
  8035fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035fd:	83 e0 01             	and    $0x1,%eax
  803600:	85 c0                	test   %eax,%eax
  803602:	74 03                	je     803607 <set_block_data+0x13>
	{
		totalSize++;
  803604:	ff 45 0c             	incl   0xc(%ebp)
	}

	uint32* header = (uint32 *)((uint32*)va-1);
  803607:	8b 45 08             	mov    0x8(%ebp),%eax
  80360a:	83 e8 04             	sub    $0x4,%eax
  80360d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//	size => totalSize with LSB = 0		 set LSB = 1 if isAllocated
	*header = (totalSize & ~1) | (isAllocated & 1);
  803610:	8b 45 0c             	mov    0xc(%ebp),%eax
  803613:	83 e0 fe             	and    $0xfffffffe,%eax
  803616:	89 c2                	mov    %eax,%edx
  803618:	8b 45 10             	mov    0x10(%ebp),%eax
  80361b:	83 e0 01             	and    $0x1,%eax
  80361e:	09 c2                	or     %eax,%edx
  803620:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803623:	89 10                	mov    %edx,(%eax)
	uint32* footer = (uint32*) (va + totalSize - 8);
  803625:	8b 45 0c             	mov    0xc(%ebp),%eax
  803628:	8d 50 f8             	lea    -0x8(%eax),%edx
  80362b:	8b 45 08             	mov    0x8(%ebp),%eax
  80362e:	01 d0                	add    %edx,%eax
  803630:	89 45 f8             	mov    %eax,-0x8(%ebp)
	*footer = (totalSize & ~1) | (isAllocated & 1);
  803633:	8b 45 0c             	mov    0xc(%ebp),%eax
  803636:	83 e0 fe             	and    $0xfffffffe,%eax
  803639:	89 c2                	mov    %eax,%edx
  80363b:	8b 45 10             	mov    0x10(%ebp),%eax
  80363e:	83 e0 01             	and    $0x1,%eax
  803641:	09 c2                	or     %eax,%edx
  803643:	8b 45 f8             	mov    -0x8(%ebp),%eax
  803646:	89 10                	mov    %edx,(%eax)
}
  803648:	90                   	nop
  803649:	c9                   	leave  
  80364a:	c3                   	ret    

0080364b <insert_sorted_in_freeList>:
//=========================================
void insert_sorted_in_freeList(struct BlockElement *newBlock)
{
  80364b:	55                   	push   %ebp
  80364c:	89 e5                	mov    %esp,%ebp
  80364e:	83 ec 18             	sub    $0x18,%esp
	if(LIST_EMPTY(&freeBlocksList))
  803651:	a1 48 60 98 00       	mov    0x986048,%eax
  803656:	85 c0                	test   %eax,%eax
  803658:	75 68                	jne    8036c2 <insert_sorted_in_freeList+0x77>
	{
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
  80365a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80365e:	75 17                	jne    803677 <insert_sorted_in_freeList+0x2c>
  803660:	83 ec 04             	sub    $0x4,%esp
  803663:	68 b4 51 80 00       	push   $0x8051b4
  803668:	68 9d 00 00 00       	push   $0x9d
  80366d:	68 d7 51 80 00       	push   $0x8051d7
  803672:	e8 42 df ff ff       	call   8015b9 <_panic>
  803677:	8b 15 48 60 98 00    	mov    0x986048,%edx
  80367d:	8b 45 08             	mov    0x8(%ebp),%eax
  803680:	89 10                	mov    %edx,(%eax)
  803682:	8b 45 08             	mov    0x8(%ebp),%eax
  803685:	8b 00                	mov    (%eax),%eax
  803687:	85 c0                	test   %eax,%eax
  803689:	74 0d                	je     803698 <insert_sorted_in_freeList+0x4d>
  80368b:	a1 48 60 98 00       	mov    0x986048,%eax
  803690:	8b 55 08             	mov    0x8(%ebp),%edx
  803693:	89 50 04             	mov    %edx,0x4(%eax)
  803696:	eb 08                	jmp    8036a0 <insert_sorted_in_freeList+0x55>
  803698:	8b 45 08             	mov    0x8(%ebp),%eax
  80369b:	a3 4c 60 98 00       	mov    %eax,0x98604c
  8036a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a3:	a3 48 60 98 00       	mov    %eax,0x986048
  8036a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036b2:	a1 54 60 98 00       	mov    0x986054,%eax
  8036b7:	40                   	inc    %eax
  8036b8:	a3 54 60 98 00       	mov    %eax,0x986054
		return;
  8036bd:	e9 1a 01 00 00       	jmp    8037dc <insert_sorted_in_freeList+0x191>
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  8036c2:	a1 48 60 98 00       	mov    0x986048,%eax
  8036c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036ca:	eb 7f                	jmp    80374b <insert_sorted_in_freeList+0x100>
	{
		if(blk > newBlock) // if address of blk > address of newBlock => add newBlock before blk
  8036cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036cf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8036d2:	76 6f                	jbe    803743 <insert_sorted_in_freeList+0xf8>
		{
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
  8036d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036d8:	74 06                	je     8036e0 <insert_sorted_in_freeList+0x95>
  8036da:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036de:	75 17                	jne    8036f7 <insert_sorted_in_freeList+0xac>
  8036e0:	83 ec 04             	sub    $0x4,%esp
  8036e3:	68 f0 51 80 00       	push   $0x8051f0
  8036e8:	68 a6 00 00 00       	push   $0xa6
  8036ed:	68 d7 51 80 00       	push   $0x8051d7
  8036f2:	e8 c2 de ff ff       	call   8015b9 <_panic>
  8036f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036fa:	8b 50 04             	mov    0x4(%eax),%edx
  8036fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803700:	89 50 04             	mov    %edx,0x4(%eax)
  803703:	8b 45 08             	mov    0x8(%ebp),%eax
  803706:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803709:	89 10                	mov    %edx,(%eax)
  80370b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80370e:	8b 40 04             	mov    0x4(%eax),%eax
  803711:	85 c0                	test   %eax,%eax
  803713:	74 0d                	je     803722 <insert_sorted_in_freeList+0xd7>
  803715:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803718:	8b 40 04             	mov    0x4(%eax),%eax
  80371b:	8b 55 08             	mov    0x8(%ebp),%edx
  80371e:	89 10                	mov    %edx,(%eax)
  803720:	eb 08                	jmp    80372a <insert_sorted_in_freeList+0xdf>
  803722:	8b 45 08             	mov    0x8(%ebp),%eax
  803725:	a3 48 60 98 00       	mov    %eax,0x986048
  80372a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80372d:	8b 55 08             	mov    0x8(%ebp),%edx
  803730:	89 50 04             	mov    %edx,0x4(%eax)
  803733:	a1 54 60 98 00       	mov    0x986054,%eax
  803738:	40                   	inc    %eax
  803739:	a3 54 60 98 00       	mov    %eax,0x986054
			return;
  80373e:	e9 99 00 00 00       	jmp    8037dc <insert_sorted_in_freeList+0x191>
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
		return;
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  803743:	a1 50 60 98 00       	mov    0x986050,%eax
  803748:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80374b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80374f:	74 07                	je     803758 <insert_sorted_in_freeList+0x10d>
  803751:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803754:	8b 00                	mov    (%eax),%eax
  803756:	eb 05                	jmp    80375d <insert_sorted_in_freeList+0x112>
  803758:	b8 00 00 00 00       	mov    $0x0,%eax
  80375d:	a3 50 60 98 00       	mov    %eax,0x986050
  803762:	a1 50 60 98 00       	mov    0x986050,%eax
  803767:	85 c0                	test   %eax,%eax
  803769:	0f 85 5d ff ff ff    	jne    8036cc <insert_sorted_in_freeList+0x81>
  80376f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803773:	0f 85 53 ff ff ff    	jne    8036cc <insert_sorted_in_freeList+0x81>
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
			return;
		}
	}
	// if no blk its address > newBlock
	LIST_INSERT_TAIL(&freeBlocksList, newBlock);
  803779:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80377d:	75 17                	jne    803796 <insert_sorted_in_freeList+0x14b>
  80377f:	83 ec 04             	sub    $0x4,%esp
  803782:	68 28 52 80 00       	push   $0x805228
  803787:	68 ab 00 00 00       	push   $0xab
  80378c:	68 d7 51 80 00       	push   $0x8051d7
  803791:	e8 23 de ff ff       	call   8015b9 <_panic>
  803796:	8b 15 4c 60 98 00    	mov    0x98604c,%edx
  80379c:	8b 45 08             	mov    0x8(%ebp),%eax
  80379f:	89 50 04             	mov    %edx,0x4(%eax)
  8037a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a5:	8b 40 04             	mov    0x4(%eax),%eax
  8037a8:	85 c0                	test   %eax,%eax
  8037aa:	74 0c                	je     8037b8 <insert_sorted_in_freeList+0x16d>
  8037ac:	a1 4c 60 98 00       	mov    0x98604c,%eax
  8037b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8037b4:	89 10                	mov    %edx,(%eax)
  8037b6:	eb 08                	jmp    8037c0 <insert_sorted_in_freeList+0x175>
  8037b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8037bb:	a3 48 60 98 00       	mov    %eax,0x986048
  8037c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c3:	a3 4c 60 98 00       	mov    %eax,0x98604c
  8037c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8037cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037d1:	a1 54 60 98 00       	mov    0x986054,%eax
  8037d6:	40                   	inc    %eax
  8037d7:	a3 54 60 98 00       	mov    %eax,0x986054
}
  8037dc:	c9                   	leave  
  8037dd:	c3                   	ret    

008037de <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  8037de:	55                   	push   %ebp
  8037df:	89 e5                	mov    %esp,%ebp
  8037e1:	83 ec 78             	sub    $0x78,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8037e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e7:	83 e0 01             	and    $0x1,%eax
  8037ea:	85 c0                	test   %eax,%eax
  8037ec:	74 03                	je     8037f1 <alloc_block_FF+0x13>
  8037ee:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8037f1:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8037f5:	77 07                	ja     8037fe <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8037f7:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8037fe:	a1 40 60 98 00       	mov    0x986040,%eax
  803803:	85 c0                	test   %eax,%eax
  803805:	75 63                	jne    80386a <alloc_block_FF+0x8c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  803807:	8b 45 08             	mov    0x8(%ebp),%eax
  80380a:	83 c0 10             	add    $0x10,%eax
  80380d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  803810:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  803817:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80381a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80381d:	01 d0                	add    %edx,%eax
  80381f:	48                   	dec    %eax
  803820:	89 45 e8             	mov    %eax,-0x18(%ebp)
  803823:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803826:	ba 00 00 00 00       	mov    $0x0,%edx
  80382b:	f7 75 ec             	divl   -0x14(%ebp)
  80382e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803831:	29 d0                	sub    %edx,%eax
  803833:	c1 e8 0c             	shr    $0xc,%eax
  803836:	83 ec 0c             	sub    $0xc,%esp
  803839:	50                   	push   %eax
  80383a:	e8 d1 ed ff ff       	call   802610 <sbrk>
  80383f:	83 c4 10             	add    $0x10,%esp
  803842:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  803845:	83 ec 0c             	sub    $0xc,%esp
  803848:	6a 00                	push   $0x0
  80384a:	e8 c1 ed ff ff       	call   802610 <sbrk>
  80384f:	83 c4 10             	add    $0x10,%esp
  803852:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  803855:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803858:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80385b:	83 ec 08             	sub    $0x8,%esp
  80385e:	50                   	push   %eax
  80385f:	ff 75 e4             	pushl  -0x1c(%ebp)
  803862:	e8 75 fc ff ff       	call   8034dc <initialize_dynamic_allocator>
  803867:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(size == 0)
  80386a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80386e:	75 0a                	jne    80387a <alloc_block_FF+0x9c>
	{
		return NULL;
  803870:	b8 00 00 00 00       	mov    $0x0,%eax
  803875:	e9 99 03 00 00       	jmp    803c13 <alloc_block_FF+0x435>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  80387a:	8b 45 08             	mov    0x8(%ebp),%eax
  80387d:	83 c0 08             	add    $0x8,%eax
  803880:	89 45 dc             	mov    %eax,-0x24(%ebp)

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  803883:	a1 48 60 98 00       	mov    0x986048,%eax
  803888:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80388b:	e9 03 02 00 00       	jmp    803a93 <alloc_block_FF+0x2b5>
	{
		uint32 blockSize = get_block_size(block); // Get size without the (LSB) allocation flag
  803890:	83 ec 0c             	sub    $0xc,%esp
  803893:	ff 75 f4             	pushl  -0xc(%ebp)
  803896:	e8 dd fa ff ff       	call   803378 <get_block_size>
  80389b:	83 c4 10             	add    $0x10,%esp
  80389e:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if(blockSize >= totalSize)
  8038a1:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8038a4:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8038a7:	0f 82 de 01 00 00    	jb     803a8b <alloc_block_FF+0x2ad>
		{	//if we can put another block with min size 16
			if(blockSize >= totalSize + 4*sizeof(uint32))
  8038ad:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038b0:	83 c0 10             	add    $0x10,%eax
  8038b3:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  8038b6:	0f 87 32 01 00 00    	ja     8039ee <alloc_block_FF+0x210>
			{
				// the size that will remain from the block that we will allocate a new block in it
				uint32 remainingSize = blockSize - totalSize;
  8038bc:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8038bf:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8038c2:	89 45 98             	mov    %eax,-0x68(%ebp)

				// the remaining free space from the block that we use to allocate in it
				struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)block + totalSize);
  8038c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8038c8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038cb:	01 d0                	add    %edx,%eax
  8038cd:	89 45 94             	mov    %eax,-0x6c(%ebp)
				set_block_data(remainingFreeBlock, remainingSize, 0);
  8038d0:	83 ec 04             	sub    $0x4,%esp
  8038d3:	6a 00                	push   $0x0
  8038d5:	ff 75 98             	pushl  -0x68(%ebp)
  8038d8:	ff 75 94             	pushl  -0x6c(%ebp)
  8038db:	e8 14 fd ff ff       	call   8035f4 <set_block_data>
  8038e0:	83 c4 10             	add    $0x10,%esp
				// add it after the block we allocated to be sorted by addresses
				LIST_INSERT_AFTER(&freeBlocksList, block,remainingFreeBlock);
  8038e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038e7:	74 06                	je     8038ef <alloc_block_FF+0x111>
  8038e9:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
  8038ed:	75 17                	jne    803906 <alloc_block_FF+0x128>
  8038ef:	83 ec 04             	sub    $0x4,%esp
  8038f2:	68 4c 52 80 00       	push   $0x80524c
  8038f7:	68 de 00 00 00       	push   $0xde
  8038fc:	68 d7 51 80 00       	push   $0x8051d7
  803901:	e8 b3 dc ff ff       	call   8015b9 <_panic>
  803906:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803909:	8b 10                	mov    (%eax),%edx
  80390b:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80390e:	89 10                	mov    %edx,(%eax)
  803910:	8b 45 94             	mov    -0x6c(%ebp),%eax
  803913:	8b 00                	mov    (%eax),%eax
  803915:	85 c0                	test   %eax,%eax
  803917:	74 0b                	je     803924 <alloc_block_FF+0x146>
  803919:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80391c:	8b 00                	mov    (%eax),%eax
  80391e:	8b 55 94             	mov    -0x6c(%ebp),%edx
  803921:	89 50 04             	mov    %edx,0x4(%eax)
  803924:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803927:	8b 55 94             	mov    -0x6c(%ebp),%edx
  80392a:	89 10                	mov    %edx,(%eax)
  80392c:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80392f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803932:	89 50 04             	mov    %edx,0x4(%eax)
  803935:	8b 45 94             	mov    -0x6c(%ebp),%eax
  803938:	8b 00                	mov    (%eax),%eax
  80393a:	85 c0                	test   %eax,%eax
  80393c:	75 08                	jne    803946 <alloc_block_FF+0x168>
  80393e:	8b 45 94             	mov    -0x6c(%ebp),%eax
  803941:	a3 4c 60 98 00       	mov    %eax,0x98604c
  803946:	a1 54 60 98 00       	mov    0x986054,%eax
  80394b:	40                   	inc    %eax
  80394c:	a3 54 60 98 00       	mov    %eax,0x986054

				// update the allocated block and remove it from freeBlocksList
				set_block_data(block,totalSize,1);
  803951:	83 ec 04             	sub    $0x4,%esp
  803954:	6a 01                	push   $0x1
  803956:	ff 75 dc             	pushl  -0x24(%ebp)
  803959:	ff 75 f4             	pushl  -0xc(%ebp)
  80395c:	e8 93 fc ff ff       	call   8035f4 <set_block_data>
  803961:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  803964:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803968:	75 17                	jne    803981 <alloc_block_FF+0x1a3>
  80396a:	83 ec 04             	sub    $0x4,%esp
  80396d:	68 80 52 80 00       	push   $0x805280
  803972:	68 e3 00 00 00       	push   $0xe3
  803977:	68 d7 51 80 00       	push   $0x8051d7
  80397c:	e8 38 dc ff ff       	call   8015b9 <_panic>
  803981:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803984:	8b 00                	mov    (%eax),%eax
  803986:	85 c0                	test   %eax,%eax
  803988:	74 10                	je     80399a <alloc_block_FF+0x1bc>
  80398a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80398d:	8b 00                	mov    (%eax),%eax
  80398f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803992:	8b 52 04             	mov    0x4(%edx),%edx
  803995:	89 50 04             	mov    %edx,0x4(%eax)
  803998:	eb 0b                	jmp    8039a5 <alloc_block_FF+0x1c7>
  80399a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80399d:	8b 40 04             	mov    0x4(%eax),%eax
  8039a0:	a3 4c 60 98 00       	mov    %eax,0x98604c
  8039a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039a8:	8b 40 04             	mov    0x4(%eax),%eax
  8039ab:	85 c0                	test   %eax,%eax
  8039ad:	74 0f                	je     8039be <alloc_block_FF+0x1e0>
  8039af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039b2:	8b 40 04             	mov    0x4(%eax),%eax
  8039b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8039b8:	8b 12                	mov    (%edx),%edx
  8039ba:	89 10                	mov    %edx,(%eax)
  8039bc:	eb 0a                	jmp    8039c8 <alloc_block_FF+0x1ea>
  8039be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039c1:	8b 00                	mov    (%eax),%eax
  8039c3:	a3 48 60 98 00       	mov    %eax,0x986048
  8039c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039d4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039db:	a1 54 60 98 00       	mov    0x986054,%eax
  8039e0:	48                   	dec    %eax
  8039e1:	a3 54 60 98 00       	mov    %eax,0x986054
				return (void*)((uint32*)block);
  8039e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039e9:	e9 25 02 00 00       	jmp    803c13 <alloc_block_FF+0x435>
			}
			else // if set internal fragmentation
			{
				// add the remaining size to the block we allocate so it will be the same main block size
				set_block_data(block,blockSize,1);
  8039ee:	83 ec 04             	sub    $0x4,%esp
  8039f1:	6a 01                	push   $0x1
  8039f3:	ff 75 9c             	pushl  -0x64(%ebp)
  8039f6:	ff 75 f4             	pushl  -0xc(%ebp)
  8039f9:	e8 f6 fb ff ff       	call   8035f4 <set_block_data>
  8039fe:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  803a01:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a05:	75 17                	jne    803a1e <alloc_block_FF+0x240>
  803a07:	83 ec 04             	sub    $0x4,%esp
  803a0a:	68 80 52 80 00       	push   $0x805280
  803a0f:	68 eb 00 00 00       	push   $0xeb
  803a14:	68 d7 51 80 00       	push   $0x8051d7
  803a19:	e8 9b db ff ff       	call   8015b9 <_panic>
  803a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a21:	8b 00                	mov    (%eax),%eax
  803a23:	85 c0                	test   %eax,%eax
  803a25:	74 10                	je     803a37 <alloc_block_FF+0x259>
  803a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a2a:	8b 00                	mov    (%eax),%eax
  803a2c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a2f:	8b 52 04             	mov    0x4(%edx),%edx
  803a32:	89 50 04             	mov    %edx,0x4(%eax)
  803a35:	eb 0b                	jmp    803a42 <alloc_block_FF+0x264>
  803a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a3a:	8b 40 04             	mov    0x4(%eax),%eax
  803a3d:	a3 4c 60 98 00       	mov    %eax,0x98604c
  803a42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a45:	8b 40 04             	mov    0x4(%eax),%eax
  803a48:	85 c0                	test   %eax,%eax
  803a4a:	74 0f                	je     803a5b <alloc_block_FF+0x27d>
  803a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a4f:	8b 40 04             	mov    0x4(%eax),%eax
  803a52:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a55:	8b 12                	mov    (%edx),%edx
  803a57:	89 10                	mov    %edx,(%eax)
  803a59:	eb 0a                	jmp    803a65 <alloc_block_FF+0x287>
  803a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a5e:	8b 00                	mov    (%eax),%eax
  803a60:	a3 48 60 98 00       	mov    %eax,0x986048
  803a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a68:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a71:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a78:	a1 54 60 98 00       	mov    0x986054,%eax
  803a7d:	48                   	dec    %eax
  803a7e:	a3 54 60 98 00       	mov    %eax,0x986054
				return (void*)((uint32*)block);
  803a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a86:	e9 88 01 00 00       	jmp    803c13 <alloc_block_FF+0x435>
		return NULL;
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  803a8b:	a1 50 60 98 00       	mov    0x986050,%eax
  803a90:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a93:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a97:	74 07                	je     803aa0 <alloc_block_FF+0x2c2>
  803a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a9c:	8b 00                	mov    (%eax),%eax
  803a9e:	eb 05                	jmp    803aa5 <alloc_block_FF+0x2c7>
  803aa0:	b8 00 00 00 00       	mov    $0x0,%eax
  803aa5:	a3 50 60 98 00       	mov    %eax,0x986050
  803aaa:	a1 50 60 98 00       	mov    0x986050,%eax
  803aaf:	85 c0                	test   %eax,%eax
  803ab1:	0f 85 d9 fd ff ff    	jne    803890 <alloc_block_FF+0xb2>
  803ab7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803abb:	0f 85 cf fd ff ff    	jne    803890 <alloc_block_FF+0xb2>

//	uint32 *endBlock = &kheapBreak;

	// if we don't find any enough space to allocate the block

	void *oldBreak = sbrk(ROUNDUP(totalSize, PAGE_SIZE) / PAGE_SIZE);
  803ac1:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  803ac8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803acb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803ace:	01 d0                	add    %edx,%eax
  803ad0:	48                   	dec    %eax
  803ad1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  803ad4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ad7:	ba 00 00 00 00       	mov    $0x0,%edx
  803adc:	f7 75 d8             	divl   -0x28(%ebp)
  803adf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ae2:	29 d0                	sub    %edx,%eax
  803ae4:	c1 e8 0c             	shr    $0xc,%eax
  803ae7:	83 ec 0c             	sub    $0xc,%esp
  803aea:	50                   	push   %eax
  803aeb:	e8 20 eb ff ff       	call   802610 <sbrk>
  803af0:	83 c4 10             	add    $0x10,%esp
  803af3:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (oldBreak == (void*)-1) {
  803af6:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  803afa:	75 0a                	jne    803b06 <alloc_block_FF+0x328>
		return NULL;
  803afc:	b8 00 00 00 00       	mov    $0x0,%eax
  803b01:	e9 0d 01 00 00       	jmp    803c13 <alloc_block_FF+0x435>
	}
	//uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);

	uint32* endBlk = (uint32 *)((char *)oldBreak - 4);
  803b06:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b09:	83 e8 04             	sub    $0x4,%eax
  803b0c:	89 45 cc             	mov    %eax,-0x34(%ebp)
	//endBlk = endBlk+(char *) ROUNDUP(totalSize, PAGE_SIZE);

	endBlk = endBlk + (ROUNDUP(totalSize, PAGE_SIZE) / sizeof(uint32));
  803b0f:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  803b16:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803b19:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b1c:	01 d0                	add    %edx,%eax
  803b1e:	48                   	dec    %eax
  803b1f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  803b22:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803b25:	ba 00 00 00 00       	mov    $0x0,%edx
  803b2a:	f7 75 c8             	divl   -0x38(%ebp)
  803b2d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803b30:	29 d0                	sub    %edx,%eax
  803b32:	c1 e8 02             	shr    $0x2,%eax
  803b35:	c1 e0 02             	shl    $0x2,%eax
  803b38:	01 45 cc             	add    %eax,-0x34(%ebp)
	*endBlk = 0 | 1;
  803b3b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803b3e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	uint32 *footerLast = ((uint32*)oldBreak - 2);
  803b44:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b47:	83 e8 08             	sub    $0x8,%eax
  803b4a:	89 45 c0             	mov    %eax,-0x40(%ebp)
	uint32 lastSize = (*footerLast) & ~(0x1);
  803b4d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803b50:	8b 00                	mov    (%eax),%eax
  803b52:	83 e0 fe             	and    $0xfffffffe,%eax
  803b55:	89 45 bc             	mov    %eax,-0x44(%ebp)
	// the last block for the block that we want to free it
	struct BlockElement *laskBlk = (struct BlockElement *)((char*)oldBreak - lastSize);
  803b58:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803b5b:	f7 d8                	neg    %eax
  803b5d:	89 c2                	mov    %eax,%edx
  803b5f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b62:	01 d0                	add    %edx,%eax
  803b64:	89 45 b8             	mov    %eax,-0x48(%ebp)
	uint32 isLastFree = is_free_block(laskBlk);
  803b67:	83 ec 0c             	sub    $0xc,%esp
  803b6a:	ff 75 b8             	pushl  -0x48(%ebp)
  803b6d:	e8 1f f8 ff ff       	call   803391 <is_free_block>
  803b72:	83 c4 10             	add    $0x10,%esp
  803b75:	0f be c0             	movsbl %al,%eax
  803b78:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(isLastFree)
  803b7b:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  803b7f:	74 42                	je     803bc3 <alloc_block_FF+0x3e5>
	{
		// merge the block will be free with its prev block
		uint32 newBlkSize = lastSize + ROUNDUP(totalSize, PAGE_SIZE); // size of main block and its prev block
  803b81:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  803b88:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803b8b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803b8e:	01 d0                	add    %edx,%eax
  803b90:	48                   	dec    %eax
  803b91:	89 45 ac             	mov    %eax,-0x54(%ebp)
  803b94:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803b97:	ba 00 00 00 00       	mov    $0x0,%edx
  803b9c:	f7 75 b0             	divl   -0x50(%ebp)
  803b9f:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803ba2:	29 d0                	sub    %edx,%eax
  803ba4:	89 c2                	mov    %eax,%edx
  803ba6:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803ba9:	01 d0                	add    %edx,%eax
  803bab:	89 45 a8             	mov    %eax,-0x58(%ebp)
		// extends last block size to contain its size and the size of new space
		set_block_data(laskBlk,newBlkSize,0);
  803bae:	83 ec 04             	sub    $0x4,%esp
  803bb1:	6a 00                	push   $0x0
  803bb3:	ff 75 a8             	pushl  -0x58(%ebp)
  803bb6:	ff 75 b8             	pushl  -0x48(%ebp)
  803bb9:	e8 36 fa ff ff       	call   8035f4 <set_block_data>
  803bbe:	83 c4 10             	add    $0x10,%esp
  803bc1:	eb 42                	jmp    803c05 <alloc_block_FF+0x427>
	}
	else
	{
		set_block_data(oldBreak,ROUNDUP(totalSize, PAGE_SIZE),0);
  803bc3:	c7 45 a4 00 10 00 00 	movl   $0x1000,-0x5c(%ebp)
  803bca:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803bcd:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803bd0:	01 d0                	add    %edx,%eax
  803bd2:	48                   	dec    %eax
  803bd3:	89 45 a0             	mov    %eax,-0x60(%ebp)
  803bd6:	8b 45 a0             	mov    -0x60(%ebp),%eax
  803bd9:	ba 00 00 00 00       	mov    $0x0,%edx
  803bde:	f7 75 a4             	divl   -0x5c(%ebp)
  803be1:	8b 45 a0             	mov    -0x60(%ebp),%eax
  803be4:	29 d0                	sub    %edx,%eax
  803be6:	83 ec 04             	sub    $0x4,%esp
  803be9:	6a 00                	push   $0x0
  803beb:	50                   	push   %eax
  803bec:	ff 75 d0             	pushl  -0x30(%ebp)
  803bef:	e8 00 fa ff ff       	call   8035f4 <set_block_data>
  803bf4:	83 c4 10             	add    $0x10,%esp
		insert_sorted_in_freeList((struct BlockElement *)oldBreak);
  803bf7:	83 ec 0c             	sub    $0xc,%esp
  803bfa:	ff 75 d0             	pushl  -0x30(%ebp)
  803bfd:	e8 49 fa ff ff       	call   80364b <insert_sorted_in_freeList>
  803c02:	83 c4 10             	add    $0x10,%esp
//		LIST_INSERT_TAIL(&freeBlocksList,newBreak);
	}
//	set_block_data((struct BlockElement *)newBreak, totalSize, 1);
	return alloc_block_FF(size);
  803c05:	83 ec 0c             	sub    $0xc,%esp
  803c08:	ff 75 08             	pushl  0x8(%ebp)
  803c0b:	e8 ce fb ff ff       	call   8037de <alloc_block_FF>
  803c10:	83 c4 10             	add    $0x10,%esp
}
  803c13:	c9                   	leave  
  803c14:	c3                   	ret    

00803c15 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  803c15:	55                   	push   %ebp
  803c16:	89 e5                	mov    %esp,%ebp
  803c18:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS1 - BONUS] [3] DYNAMIC ALLOCATOR - alloc_block_BF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_BF is not implemented yet");
	//Your Code is Here...
	if(size == 0)
  803c1b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c1f:	75 0a                	jne    803c2b <alloc_block_BF+0x16>
	{
		return NULL;
  803c21:	b8 00 00 00 00       	mov    $0x0,%eax
  803c26:	e9 7a 02 00 00       	jmp    803ea5 <alloc_block_BF+0x290>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  803c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  803c2e:	83 c0 08             	add    $0x8,%eax
  803c31:	89 45 e8             	mov    %eax,-0x18(%ebp)

	struct BlockElement *minBlk= NULL;
  803c34:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 minSize = 0xfffffff; // a large number
  803c3b:	c7 45 f0 ff ff ff 0f 	movl   $0xfffffff,-0x10(%ebp)
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  803c42:	a1 48 60 98 00       	mov    0x986048,%eax
  803c47:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803c4a:	eb 32                	jmp    803c7e <alloc_block_BF+0x69>
	{
		uint32 blockSize = get_block_size(block);
  803c4c:	ff 75 ec             	pushl  -0x14(%ebp)
  803c4f:	e8 24 f7 ff ff       	call   803378 <get_block_size>
  803c54:	83 c4 04             	add    $0x4,%esp
  803c57:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		// if this block can take the new block and its size < min size of all blocks
		if(blockSize >= totalSize && blockSize < minSize)
  803c5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c5d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803c60:	72 14                	jb     803c76 <alloc_block_BF+0x61>
  803c62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c65:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803c68:	73 0c                	jae    803c76 <alloc_block_BF+0x61>
		{
			minBlk = block;
  803c6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
			minSize = blockSize;
  803c70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c73:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *minBlk= NULL;
	uint32 minSize = 0xfffffff; // a large number
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  803c76:	a1 50 60 98 00       	mov    0x986050,%eax
  803c7b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803c7e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803c82:	74 07                	je     803c8b <alloc_block_BF+0x76>
  803c84:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c87:	8b 00                	mov    (%eax),%eax
  803c89:	eb 05                	jmp    803c90 <alloc_block_BF+0x7b>
  803c8b:	b8 00 00 00 00       	mov    $0x0,%eax
  803c90:	a3 50 60 98 00       	mov    %eax,0x986050
  803c95:	a1 50 60 98 00       	mov    0x986050,%eax
  803c9a:	85 c0                	test   %eax,%eax
  803c9c:	75 ae                	jne    803c4c <alloc_block_BF+0x37>
  803c9e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803ca2:	75 a8                	jne    803c4c <alloc_block_BF+0x37>
			minSize = blockSize;
		}
	}

	// if we don't find any enough space to allocate the block
	if(minBlk == NULL)
  803ca4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ca8:	75 22                	jne    803ccc <alloc_block_BF+0xb7>
	{
		void *newBlock = sbrk(totalSize);
  803caa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cad:	83 ec 0c             	sub    $0xc,%esp
  803cb0:	50                   	push   %eax
  803cb1:	e8 5a e9 ff ff       	call   802610 <sbrk>
  803cb6:	83 c4 10             	add    $0x10,%esp
  803cb9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (newBlock == (void*)-1) {
  803cbc:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  803cc0:	75 0a                	jne    803ccc <alloc_block_BF+0xb7>
			return NULL;
  803cc2:	b8 00 00 00 00       	mov    $0x0,%eax
  803cc7:	e9 d9 01 00 00       	jmp    803ea5 <alloc_block_BF+0x290>
		}
	}

	//if we can put another block with min size 16
	if(minSize >= totalSize + 4*sizeof(uint32))
  803ccc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ccf:	83 c0 10             	add    $0x10,%eax
  803cd2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803cd5:	0f 87 32 01 00 00    	ja     803e0d <alloc_block_BF+0x1f8>
	{
		// the size that will remain from the block that we will allocate a new block in it
		uint32 remainingSize= minSize - totalSize;
  803cdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cde:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803ce1:	89 45 dc             	mov    %eax,-0x24(%ebp)

		// the remaining free space from the block that we use to allocate in it
		struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)minBlk + totalSize);
  803ce4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ce7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cea:	01 d0                	add    %edx,%eax
  803cec:	89 45 d8             	mov    %eax,-0x28(%ebp)
		set_block_data(remainingFreeBlock, remainingSize, 0);
  803cef:	83 ec 04             	sub    $0x4,%esp
  803cf2:	6a 00                	push   $0x0
  803cf4:	ff 75 dc             	pushl  -0x24(%ebp)
  803cf7:	ff 75 d8             	pushl  -0x28(%ebp)
  803cfa:	e8 f5 f8 ff ff       	call   8035f4 <set_block_data>
  803cff:	83 c4 10             	add    $0x10,%esp
		// add it after the block we allocated to be sorted by addresses
		LIST_INSERT_AFTER(&freeBlocksList, minBlk,remainingFreeBlock);
  803d02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d06:	74 06                	je     803d0e <alloc_block_BF+0xf9>
  803d08:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  803d0c:	75 17                	jne    803d25 <alloc_block_BF+0x110>
  803d0e:	83 ec 04             	sub    $0x4,%esp
  803d11:	68 4c 52 80 00       	push   $0x80524c
  803d16:	68 49 01 00 00       	push   $0x149
  803d1b:	68 d7 51 80 00       	push   $0x8051d7
  803d20:	e8 94 d8 ff ff       	call   8015b9 <_panic>
  803d25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d28:	8b 10                	mov    (%eax),%edx
  803d2a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803d2d:	89 10                	mov    %edx,(%eax)
  803d2f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803d32:	8b 00                	mov    (%eax),%eax
  803d34:	85 c0                	test   %eax,%eax
  803d36:	74 0b                	je     803d43 <alloc_block_BF+0x12e>
  803d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d3b:	8b 00                	mov    (%eax),%eax
  803d3d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803d40:	89 50 04             	mov    %edx,0x4(%eax)
  803d43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d46:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803d49:	89 10                	mov    %edx,(%eax)
  803d4b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803d4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d51:	89 50 04             	mov    %edx,0x4(%eax)
  803d54:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803d57:	8b 00                	mov    (%eax),%eax
  803d59:	85 c0                	test   %eax,%eax
  803d5b:	75 08                	jne    803d65 <alloc_block_BF+0x150>
  803d5d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803d60:	a3 4c 60 98 00       	mov    %eax,0x98604c
  803d65:	a1 54 60 98 00       	mov    0x986054,%eax
  803d6a:	40                   	inc    %eax
  803d6b:	a3 54 60 98 00       	mov    %eax,0x986054

		// update the allocated block and remove it from freeBlocksList
		set_block_data(minBlk,totalSize,1);
  803d70:	83 ec 04             	sub    $0x4,%esp
  803d73:	6a 01                	push   $0x1
  803d75:	ff 75 e8             	pushl  -0x18(%ebp)
  803d78:	ff 75 f4             	pushl  -0xc(%ebp)
  803d7b:	e8 74 f8 ff ff       	call   8035f4 <set_block_data>
  803d80:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  803d83:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d87:	75 17                	jne    803da0 <alloc_block_BF+0x18b>
  803d89:	83 ec 04             	sub    $0x4,%esp
  803d8c:	68 80 52 80 00       	push   $0x805280
  803d91:	68 4e 01 00 00       	push   $0x14e
  803d96:	68 d7 51 80 00       	push   $0x8051d7
  803d9b:	e8 19 d8 ff ff       	call   8015b9 <_panic>
  803da0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803da3:	8b 00                	mov    (%eax),%eax
  803da5:	85 c0                	test   %eax,%eax
  803da7:	74 10                	je     803db9 <alloc_block_BF+0x1a4>
  803da9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dac:	8b 00                	mov    (%eax),%eax
  803dae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803db1:	8b 52 04             	mov    0x4(%edx),%edx
  803db4:	89 50 04             	mov    %edx,0x4(%eax)
  803db7:	eb 0b                	jmp    803dc4 <alloc_block_BF+0x1af>
  803db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dbc:	8b 40 04             	mov    0x4(%eax),%eax
  803dbf:	a3 4c 60 98 00       	mov    %eax,0x98604c
  803dc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dc7:	8b 40 04             	mov    0x4(%eax),%eax
  803dca:	85 c0                	test   %eax,%eax
  803dcc:	74 0f                	je     803ddd <alloc_block_BF+0x1c8>
  803dce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dd1:	8b 40 04             	mov    0x4(%eax),%eax
  803dd4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803dd7:	8b 12                	mov    (%edx),%edx
  803dd9:	89 10                	mov    %edx,(%eax)
  803ddb:	eb 0a                	jmp    803de7 <alloc_block_BF+0x1d2>
  803ddd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803de0:	8b 00                	mov    (%eax),%eax
  803de2:	a3 48 60 98 00       	mov    %eax,0x986048
  803de7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803df3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803dfa:	a1 54 60 98 00       	mov    0x986054,%eax
  803dff:	48                   	dec    %eax
  803e00:	a3 54 60 98 00       	mov    %eax,0x986054
		return (void*)((uint32*)minBlk);
  803e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e08:	e9 98 00 00 00       	jmp    803ea5 <alloc_block_BF+0x290>
	}
	else // if set internal fragmentation
	{
		// add the remaining size to the block we allocate so it will be the same main block size
		set_block_data(minBlk,minSize,1);
  803e0d:	83 ec 04             	sub    $0x4,%esp
  803e10:	6a 01                	push   $0x1
  803e12:	ff 75 f0             	pushl  -0x10(%ebp)
  803e15:	ff 75 f4             	pushl  -0xc(%ebp)
  803e18:	e8 d7 f7 ff ff       	call   8035f4 <set_block_data>
  803e1d:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  803e20:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e24:	75 17                	jne    803e3d <alloc_block_BF+0x228>
  803e26:	83 ec 04             	sub    $0x4,%esp
  803e29:	68 80 52 80 00       	push   $0x805280
  803e2e:	68 56 01 00 00       	push   $0x156
  803e33:	68 d7 51 80 00       	push   $0x8051d7
  803e38:	e8 7c d7 ff ff       	call   8015b9 <_panic>
  803e3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e40:	8b 00                	mov    (%eax),%eax
  803e42:	85 c0                	test   %eax,%eax
  803e44:	74 10                	je     803e56 <alloc_block_BF+0x241>
  803e46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e49:	8b 00                	mov    (%eax),%eax
  803e4b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803e4e:	8b 52 04             	mov    0x4(%edx),%edx
  803e51:	89 50 04             	mov    %edx,0x4(%eax)
  803e54:	eb 0b                	jmp    803e61 <alloc_block_BF+0x24c>
  803e56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e59:	8b 40 04             	mov    0x4(%eax),%eax
  803e5c:	a3 4c 60 98 00       	mov    %eax,0x98604c
  803e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e64:	8b 40 04             	mov    0x4(%eax),%eax
  803e67:	85 c0                	test   %eax,%eax
  803e69:	74 0f                	je     803e7a <alloc_block_BF+0x265>
  803e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e6e:	8b 40 04             	mov    0x4(%eax),%eax
  803e71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803e74:	8b 12                	mov    (%edx),%edx
  803e76:	89 10                	mov    %edx,(%eax)
  803e78:	eb 0a                	jmp    803e84 <alloc_block_BF+0x26f>
  803e7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e7d:	8b 00                	mov    (%eax),%eax
  803e7f:	a3 48 60 98 00       	mov    %eax,0x986048
  803e84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e87:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e90:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e97:	a1 54 60 98 00       	mov    0x986054,%eax
  803e9c:	48                   	dec    %eax
  803e9d:	a3 54 60 98 00       	mov    %eax,0x986054
		return (void*)((uint32*)minBlk);
  803ea2:	8b 45 f4             	mov    -0xc(%ebp),%eax
	}
	return NULL;
}
  803ea5:	c9                   	leave  
  803ea6:	c3                   	ret    

00803ea7 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803ea7:	55                   	push   %ebp
  803ea8:	89 e5                	mov    %esp,%ebp
  803eaa:	83 ec 48             	sub    $0x48,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
  803ead:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803eb1:	0f 84 6a 02 00 00    	je     804121 <free_block+0x27a>
	{
		return;
	}

	uint32 freeSize = get_block_size(va);
  803eb7:	ff 75 08             	pushl  0x8(%ebp)
  803eba:	e8 b9 f4 ff ff       	call   803378 <get_block_size>
  803ebf:	83 c4 04             	add    $0x4,%esp
  803ec2:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// footer for the prev block for the block that we want to free it
	uint32 *footerPrev = ((uint32*)va - 2 );
  803ec5:	8b 45 08             	mov    0x8(%ebp),%eax
  803ec8:	83 e8 08             	sub    $0x8,%eax
  803ecb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 pSize = (*footerPrev) & ~(0x1);
  803ece:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ed1:	8b 00                	mov    (%eax),%eax
  803ed3:	83 e0 fe             	and    $0xfffffffe,%eax
  803ed6:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// the prev block for the block that we want to free it
	struct BlockElement * prevBlk = (struct BlockElement *)((char*)va - pSize);
  803ed9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803edc:	f7 d8                	neg    %eax
  803ede:	89 c2                	mov    %eax,%edx
  803ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  803ee3:	01 d0                	add    %edx,%eax
  803ee5:	89 45 e8             	mov    %eax,-0x18(%ebp)
	uint32 isPrevFree = is_free_block(prevBlk);
  803ee8:	ff 75 e8             	pushl  -0x18(%ebp)
  803eeb:	e8 a1 f4 ff ff       	call   803391 <is_free_block>
  803ef0:	83 c4 04             	add    $0x4,%esp
  803ef3:	0f be c0             	movsbl %al,%eax
  803ef6:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
  803ef9:	8b 55 08             	mov    0x8(%ebp),%edx
  803efc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803eff:	01 d0                	add    %edx,%eax
  803f01:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  803f04:	ff 75 e0             	pushl  -0x20(%ebp)
  803f07:	e8 85 f4 ff ff       	call   803391 <is_free_block>
  803f0c:	83 c4 04             	add    $0x4,%esp
  803f0f:	0f be c0             	movsbl %al,%eax
  803f12:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if(isPrevFree == 1 && isNextFree == 0)
  803f15:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  803f19:	75 34                	jne    803f4f <free_block+0xa8>
  803f1b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803f1f:	75 2e                	jne    803f4f <free_block+0xa8>
	{
		// merge the block will be free with its prev block
		uint32 prevSize = get_block_size(prevBlk);
  803f21:	ff 75 e8             	pushl  -0x18(%ebp)
  803f24:	e8 4f f4 ff ff       	call   803378 <get_block_size>
  803f29:	83 c4 04             	add    $0x4,%esp
  803f2c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
  803f2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803f32:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803f35:	01 d0                	add    %edx,%eax
  803f37:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
  803f3a:	6a 00                	push   $0x0
  803f3c:	ff 75 d4             	pushl  -0x2c(%ebp)
  803f3f:	ff 75 e8             	pushl  -0x18(%ebp)
  803f42:	e8 ad f6 ff ff       	call   8035f4 <set_block_data>
  803f47:	83 c4 0c             	add    $0xc,%esp
	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
	uint32 isNextFree = is_free_block(nextBlk);

	if(isPrevFree == 1 && isNextFree == 0)
	{
  803f4a:	e9 d3 01 00 00       	jmp    804122 <free_block+0x27b>
		uint32 prevSize = get_block_size(prevBlk);
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
  803f4f:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  803f53:	0f 85 c8 00 00 00    	jne    804021 <free_block+0x17a>
  803f59:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803f5d:	0f 85 be 00 00 00    	jne    804021 <free_block+0x17a>
	{
		// merge the block will be free with its next block
		uint32 nextSize = get_block_size(nextBlk);
  803f63:	ff 75 e0             	pushl  -0x20(%ebp)
  803f66:	e8 0d f4 ff ff       	call   803378 <get_block_size>
  803f6b:	83 c4 04             	add    $0x4,%esp
  803f6e:	89 45 d0             	mov    %eax,-0x30(%ebp)
		uint32 totalSize = freeSize + nextSize; // size of main block and its next block
  803f71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803f74:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803f77:	01 d0                	add    %edx,%eax
  803f79:	89 45 cc             	mov    %eax,-0x34(%ebp)
		// update the size of block to contain its size and the size of next block
		set_block_data(va,totalSize,0);
  803f7c:	6a 00                	push   $0x0
  803f7e:	ff 75 cc             	pushl  -0x34(%ebp)
  803f81:	ff 75 08             	pushl  0x8(%ebp)
  803f84:	e8 6b f6 ff ff       	call   8035f4 <set_block_data>
  803f89:	83 c4 0c             	add    $0xc,%esp
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
  803f8c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803f90:	75 17                	jne    803fa9 <free_block+0x102>
  803f92:	83 ec 04             	sub    $0x4,%esp
  803f95:	68 80 52 80 00       	push   $0x805280
  803f9a:	68 87 01 00 00       	push   $0x187
  803f9f:	68 d7 51 80 00       	push   $0x8051d7
  803fa4:	e8 10 d6 ff ff       	call   8015b9 <_panic>
  803fa9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803fac:	8b 00                	mov    (%eax),%eax
  803fae:	85 c0                	test   %eax,%eax
  803fb0:	74 10                	je     803fc2 <free_block+0x11b>
  803fb2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803fb5:	8b 00                	mov    (%eax),%eax
  803fb7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803fba:	8b 52 04             	mov    0x4(%edx),%edx
  803fbd:	89 50 04             	mov    %edx,0x4(%eax)
  803fc0:	eb 0b                	jmp    803fcd <free_block+0x126>
  803fc2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803fc5:	8b 40 04             	mov    0x4(%eax),%eax
  803fc8:	a3 4c 60 98 00       	mov    %eax,0x98604c
  803fcd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803fd0:	8b 40 04             	mov    0x4(%eax),%eax
  803fd3:	85 c0                	test   %eax,%eax
  803fd5:	74 0f                	je     803fe6 <free_block+0x13f>
  803fd7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803fda:	8b 40 04             	mov    0x4(%eax),%eax
  803fdd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803fe0:	8b 12                	mov    (%edx),%edx
  803fe2:	89 10                	mov    %edx,(%eax)
  803fe4:	eb 0a                	jmp    803ff0 <free_block+0x149>
  803fe6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803fe9:	8b 00                	mov    (%eax),%eax
  803feb:	a3 48 60 98 00       	mov    %eax,0x986048
  803ff0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ff3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ff9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ffc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804003:	a1 54 60 98 00       	mov    0x986054,%eax
  804008:	48                   	dec    %eax
  804009:	a3 54 60 98 00       	mov    %eax,0x986054
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  80400e:	83 ec 0c             	sub    $0xc,%esp
  804011:	ff 75 08             	pushl  0x8(%ebp)
  804014:	e8 32 f6 ff ff       	call   80364b <insert_sorted_in_freeList>
  804019:	83 c4 10             	add    $0x10,%esp
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
	{
  80401c:	e9 01 01 00 00       	jmp    804122 <free_block+0x27b>
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
  804021:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  804025:	0f 85 d3 00 00 00    	jne    8040fe <free_block+0x257>
  80402b:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  80402f:	0f 85 c9 00 00 00    	jne    8040fe <free_block+0x257>
	{
		// merge the block will be free with its prev and next blocks
		uint32 prevSize = get_block_size(prevBlk);
  804035:	83 ec 0c             	sub    $0xc,%esp
  804038:	ff 75 e8             	pushl  -0x18(%ebp)
  80403b:	e8 38 f3 ff ff       	call   803378 <get_block_size>
  804040:	83 c4 10             	add    $0x10,%esp
  804043:	89 45 c8             	mov    %eax,-0x38(%ebp)
		uint32 nextSize = get_block_size(nextBlk);
  804046:	83 ec 0c             	sub    $0xc,%esp
  804049:	ff 75 e0             	pushl  -0x20(%ebp)
  80404c:	e8 27 f3 ff ff       	call   803378 <get_block_size>
  804051:	83 c4 10             	add    $0x10,%esp
  804054:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 totalSize = freeSize + prevSize + nextSize; // size of main block and its prev and next blocks
  804057:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80405a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80405d:	01 c2                	add    %eax,%edx
  80405f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  804062:	01 d0                	add    %edx,%eax
  804064:	89 45 c0             	mov    %eax,-0x40(%ebp)
		// extends prev block size to contain its size and the size of main and next blocks
		set_block_data(prevBlk,totalSize,0);
  804067:	83 ec 04             	sub    $0x4,%esp
  80406a:	6a 00                	push   $0x0
  80406c:	ff 75 c0             	pushl  -0x40(%ebp)
  80406f:	ff 75 e8             	pushl  -0x18(%ebp)
  804072:	e8 7d f5 ff ff       	call   8035f4 <set_block_data>
  804077:	83 c4 10             	add    $0x10,%esp
		// remove next block because we merge it with its prev blocks
		LIST_REMOVE(&freeBlocksList, nextBlk);
  80407a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80407e:	75 17                	jne    804097 <free_block+0x1f0>
  804080:	83 ec 04             	sub    $0x4,%esp
  804083:	68 80 52 80 00       	push   $0x805280
  804088:	68 94 01 00 00       	push   $0x194
  80408d:	68 d7 51 80 00       	push   $0x8051d7
  804092:	e8 22 d5 ff ff       	call   8015b9 <_panic>
  804097:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80409a:	8b 00                	mov    (%eax),%eax
  80409c:	85 c0                	test   %eax,%eax
  80409e:	74 10                	je     8040b0 <free_block+0x209>
  8040a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8040a3:	8b 00                	mov    (%eax),%eax
  8040a5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8040a8:	8b 52 04             	mov    0x4(%edx),%edx
  8040ab:	89 50 04             	mov    %edx,0x4(%eax)
  8040ae:	eb 0b                	jmp    8040bb <free_block+0x214>
  8040b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8040b3:	8b 40 04             	mov    0x4(%eax),%eax
  8040b6:	a3 4c 60 98 00       	mov    %eax,0x98604c
  8040bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8040be:	8b 40 04             	mov    0x4(%eax),%eax
  8040c1:	85 c0                	test   %eax,%eax
  8040c3:	74 0f                	je     8040d4 <free_block+0x22d>
  8040c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8040c8:	8b 40 04             	mov    0x4(%eax),%eax
  8040cb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8040ce:	8b 12                	mov    (%edx),%edx
  8040d0:	89 10                	mov    %edx,(%eax)
  8040d2:	eb 0a                	jmp    8040de <free_block+0x237>
  8040d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8040d7:	8b 00                	mov    (%eax),%eax
  8040d9:	a3 48 60 98 00       	mov    %eax,0x986048
  8040de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8040e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8040e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8040ea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8040f1:	a1 54 60 98 00       	mov    0x986054,%eax
  8040f6:	48                   	dec    %eax
  8040f7:	a3 54 60 98 00       	mov    %eax,0x986054
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
	{
  8040fc:	eb 24                	jmp    804122 <free_block+0x27b>
	}
	else
	{
		// free it without any merge
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
  8040fe:	83 ec 04             	sub    $0x4,%esp
  804101:	6a 00                	push   $0x0
  804103:	ff 75 f4             	pushl  -0xc(%ebp)
  804106:	ff 75 08             	pushl  0x8(%ebp)
  804109:	e8 e6 f4 ff ff       	call   8035f4 <set_block_data>
  80410e:	83 c4 10             	add    $0x10,%esp
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  804111:	83 ec 0c             	sub    $0xc,%esp
  804114:	ff 75 08             	pushl  0x8(%ebp)
  804117:	e8 2f f5 ff ff       	call   80364b <insert_sorted_in_freeList>
  80411c:	83 c4 10             	add    $0x10,%esp
  80411f:	eb 01                	jmp    804122 <free_block+0x27b>
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
	{
		return;
  804121:	90                   	nop
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
}
  804122:	c9                   	leave  
  804123:	c3                   	ret    

00804124 <realloc_block_FF>:
//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
  804124:	55                   	push   %ebp
  804125:	89 e5                	mov    %esp,%ebp
  804127:	83 ec 38             	sub    $0x38,%esp
	//TODO: [PROJECT'24.MS1 - #08] [3] DYNAMIC ALLOCATOR - realloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(va == NULL && new_size == 0)
  80412a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80412e:	75 10                	jne    804140 <realloc_block_FF+0x1c>
  804130:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  804134:	75 0a                	jne    804140 <realloc_block_FF+0x1c>
	{
		return NULL;
  804136:	b8 00 00 00 00       	mov    $0x0,%eax
  80413b:	e9 8b 04 00 00       	jmp    8045cb <realloc_block_FF+0x4a7>
	}

	if(new_size == 0)
  804140:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  804144:	75 18                	jne    80415e <realloc_block_FF+0x3a>
	{
		free_block(va);
  804146:	83 ec 0c             	sub    $0xc,%esp
  804149:	ff 75 08             	pushl  0x8(%ebp)
  80414c:	e8 56 fd ff ff       	call   803ea7 <free_block>
  804151:	83 c4 10             	add    $0x10,%esp
		return NULL;
  804154:	b8 00 00 00 00       	mov    $0x0,%eax
  804159:	e9 6d 04 00 00       	jmp    8045cb <realloc_block_FF+0x4a7>
	}

	if(va == NULL)
  80415e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804162:	75 13                	jne    804177 <realloc_block_FF+0x53>
	{
		return alloc_block_FF(new_size);
  804164:	83 ec 0c             	sub    $0xc,%esp
  804167:	ff 75 0c             	pushl  0xc(%ebp)
  80416a:	e8 6f f6 ff ff       	call   8037de <alloc_block_FF>
  80416f:	83 c4 10             	add    $0x10,%esp
  804172:	e9 54 04 00 00       	jmp    8045cb <realloc_block_FF+0x4a7>
	}

	// if size is odd must be increment it by one
	if (new_size % 2 != 0)
  804177:	8b 45 0c             	mov    0xc(%ebp),%eax
  80417a:	83 e0 01             	and    $0x1,%eax
  80417d:	85 c0                	test   %eax,%eax
  80417f:	74 03                	je     804184 <realloc_block_FF+0x60>
	{
		new_size++;
  804181:	ff 45 0c             	incl   0xc(%ebp)
	}

	// if size < 8 must be equal it to 8 because min size 8 excluding metadata
	if(new_size < 8)
  804184:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  804188:	77 07                	ja     804191 <realloc_block_FF+0x6d>
	{
		new_size = 8;
  80418a:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	}

	new_size += 8; // adds its footer and header size
  804191:	83 45 0c 08          	addl   $0x8,0xc(%ebp)

	uint32 actualSize = get_block_size(va);
  804195:	83 ec 0c             	sub    $0xc,%esp
  804198:	ff 75 08             	pushl  0x8(%ebp)
  80419b:	e8 d8 f1 ff ff       	call   803378 <get_block_size>
  8041a0:	83 c4 10             	add    $0x10,%esp
  8041a3:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(actualSize == new_size)
  8041a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041a9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8041ac:	75 08                	jne    8041b6 <realloc_block_FF+0x92>
	{
		// don't change any thing
		return va;
  8041ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8041b1:	e9 15 04 00 00       	jmp    8045cb <realloc_block_FF+0x4a7>
	}

	// next block for the block we want to change its size
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + actualSize);
  8041b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8041b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041bc:	01 d0                	add    %edx,%eax
  8041be:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  8041c1:	83 ec 0c             	sub    $0xc,%esp
  8041c4:	ff 75 f0             	pushl  -0x10(%ebp)
  8041c7:	e8 c5 f1 ff ff       	call   803391 <is_free_block>
  8041cc:	83 c4 10             	add    $0x10,%esp
  8041cf:	0f be c0             	movsbl %al,%eax
  8041d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 nextSize = get_block_size(nextBlk);
  8041d5:	83 ec 0c             	sub    $0xc,%esp
  8041d8:	ff 75 f0             	pushl  -0x10(%ebp)
  8041db:	e8 98 f1 ff ff       	call   803378 <get_block_size>
  8041e0:	83 c4 10             	add    $0x10,%esp
  8041e3:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// increase the size of block
	if(new_size > actualSize)
  8041e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8041e9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8041ec:	0f 86 a7 02 00 00    	jbe    804499 <realloc_block_FF+0x375>
	{
		if(isNextFree)
  8041f2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8041f6:	0f 84 86 02 00 00    	je     804482 <realloc_block_FF+0x35e>
		{
			if(nextSize + actualSize == new_size) // block and nextblock = newSizeBlock
  8041fc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8041ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804202:	01 d0                	add    %edx,%eax
  804204:	3b 45 0c             	cmp    0xc(%ebp),%eax
  804207:	0f 85 b2 00 00 00    	jne    8042bf <realloc_block_FF+0x19b>
			{
				set_block_data(va,new_size,!(is_free_block(va)));// update size in block
  80420d:	83 ec 0c             	sub    $0xc,%esp
  804210:	ff 75 08             	pushl  0x8(%ebp)
  804213:	e8 79 f1 ff ff       	call   803391 <is_free_block>
  804218:	83 c4 10             	add    $0x10,%esp
  80421b:	84 c0                	test   %al,%al
  80421d:	0f 94 c0             	sete   %al
  804220:	0f b6 c0             	movzbl %al,%eax
  804223:	83 ec 04             	sub    $0x4,%esp
  804226:	50                   	push   %eax
  804227:	ff 75 0c             	pushl  0xc(%ebp)
  80422a:	ff 75 08             	pushl  0x8(%ebp)
  80422d:	e8 c2 f3 ff ff       	call   8035f4 <set_block_data>
  804232:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);// remove next because it is = zero
  804235:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804239:	75 17                	jne    804252 <realloc_block_FF+0x12e>
  80423b:	83 ec 04             	sub    $0x4,%esp
  80423e:	68 80 52 80 00       	push   $0x805280
  804243:	68 db 01 00 00       	push   $0x1db
  804248:	68 d7 51 80 00       	push   $0x8051d7
  80424d:	e8 67 d3 ff ff       	call   8015b9 <_panic>
  804252:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804255:	8b 00                	mov    (%eax),%eax
  804257:	85 c0                	test   %eax,%eax
  804259:	74 10                	je     80426b <realloc_block_FF+0x147>
  80425b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80425e:	8b 00                	mov    (%eax),%eax
  804260:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804263:	8b 52 04             	mov    0x4(%edx),%edx
  804266:	89 50 04             	mov    %edx,0x4(%eax)
  804269:	eb 0b                	jmp    804276 <realloc_block_FF+0x152>
  80426b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80426e:	8b 40 04             	mov    0x4(%eax),%eax
  804271:	a3 4c 60 98 00       	mov    %eax,0x98604c
  804276:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804279:	8b 40 04             	mov    0x4(%eax),%eax
  80427c:	85 c0                	test   %eax,%eax
  80427e:	74 0f                	je     80428f <realloc_block_FF+0x16b>
  804280:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804283:	8b 40 04             	mov    0x4(%eax),%eax
  804286:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804289:	8b 12                	mov    (%edx),%edx
  80428b:	89 10                	mov    %edx,(%eax)
  80428d:	eb 0a                	jmp    804299 <realloc_block_FF+0x175>
  80428f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804292:	8b 00                	mov    (%eax),%eax
  804294:	a3 48 60 98 00       	mov    %eax,0x986048
  804299:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80429c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8042a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8042ac:	a1 54 60 98 00       	mov    0x986054,%eax
  8042b1:	48                   	dec    %eax
  8042b2:	a3 54 60 98 00       	mov    %eax,0x986054
				return va;
  8042b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8042ba:	e9 0c 03 00 00       	jmp    8045cb <realloc_block_FF+0x4a7>
			}
			else if(nextSize + actualSize > new_size) // new size is less than next and main blocks
  8042bf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8042c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042c5:	01 d0                	add    %edx,%eax
  8042c7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8042ca:	0f 86 b2 01 00 00    	jbe    804482 <realloc_block_FF+0x35e>
			{
				uint32 requiredSize = new_size - actualSize; // size that we need from the next block
  8042d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8042d3:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8042d6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				uint32 remainingNext = nextSize - requiredSize; // size that will remain from the next block after we split it
  8042d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8042dc:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8042df:	89 45 e0             	mov    %eax,-0x20(%ebp)

				// if next size will not fit another block (internal fragmentation)
				if(remainingNext < 16)
  8042e2:	83 7d e0 0f          	cmpl   $0xf,-0x20(%ebp)
  8042e6:	0f 87 b8 00 00 00    	ja     8043a4 <realloc_block_FF+0x280>
				{
					// we will take the main size of the block and its next size also
					set_block_data(va,actualSize + nextSize,!(is_free_block(va)));
  8042ec:	83 ec 0c             	sub    $0xc,%esp
  8042ef:	ff 75 08             	pushl  0x8(%ebp)
  8042f2:	e8 9a f0 ff ff       	call   803391 <is_free_block>
  8042f7:	83 c4 10             	add    $0x10,%esp
  8042fa:	84 c0                	test   %al,%al
  8042fc:	0f 94 c0             	sete   %al
  8042ff:	0f b6 c0             	movzbl %al,%eax
  804302:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  804305:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804308:	01 ca                	add    %ecx,%edx
  80430a:	83 ec 04             	sub    $0x4,%esp
  80430d:	50                   	push   %eax
  80430e:	52                   	push   %edx
  80430f:	ff 75 08             	pushl  0x8(%ebp)
  804312:	e8 dd f2 ff ff       	call   8035f4 <set_block_data>
  804317:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,nextBlk);
  80431a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80431e:	75 17                	jne    804337 <realloc_block_FF+0x213>
  804320:	83 ec 04             	sub    $0x4,%esp
  804323:	68 80 52 80 00       	push   $0x805280
  804328:	68 e8 01 00 00       	push   $0x1e8
  80432d:	68 d7 51 80 00       	push   $0x8051d7
  804332:	e8 82 d2 ff ff       	call   8015b9 <_panic>
  804337:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80433a:	8b 00                	mov    (%eax),%eax
  80433c:	85 c0                	test   %eax,%eax
  80433e:	74 10                	je     804350 <realloc_block_FF+0x22c>
  804340:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804343:	8b 00                	mov    (%eax),%eax
  804345:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804348:	8b 52 04             	mov    0x4(%edx),%edx
  80434b:	89 50 04             	mov    %edx,0x4(%eax)
  80434e:	eb 0b                	jmp    80435b <realloc_block_FF+0x237>
  804350:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804353:	8b 40 04             	mov    0x4(%eax),%eax
  804356:	a3 4c 60 98 00       	mov    %eax,0x98604c
  80435b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80435e:	8b 40 04             	mov    0x4(%eax),%eax
  804361:	85 c0                	test   %eax,%eax
  804363:	74 0f                	je     804374 <realloc_block_FF+0x250>
  804365:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804368:	8b 40 04             	mov    0x4(%eax),%eax
  80436b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80436e:	8b 12                	mov    (%edx),%edx
  804370:	89 10                	mov    %edx,(%eax)
  804372:	eb 0a                	jmp    80437e <realloc_block_FF+0x25a>
  804374:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804377:	8b 00                	mov    (%eax),%eax
  804379:	a3 48 60 98 00       	mov    %eax,0x986048
  80437e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804381:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804387:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80438a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804391:	a1 54 60 98 00       	mov    0x986054,%eax
  804396:	48                   	dec    %eax
  804397:	a3 54 60 98 00       	mov    %eax,0x986054
					return va;
  80439c:	8b 45 08             	mov    0x8(%ebp),%eax
  80439f:	e9 27 02 00 00       	jmp    8045cb <realloc_block_FF+0x4a7>
				}
				else // if next size can be fit another block (split)
				{
					LIST_REMOVE(&freeBlocksList,nextBlk);
  8043a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8043a8:	75 17                	jne    8043c1 <realloc_block_FF+0x29d>
  8043aa:	83 ec 04             	sub    $0x4,%esp
  8043ad:	68 80 52 80 00       	push   $0x805280
  8043b2:	68 ed 01 00 00       	push   $0x1ed
  8043b7:	68 d7 51 80 00       	push   $0x8051d7
  8043bc:	e8 f8 d1 ff ff       	call   8015b9 <_panic>
  8043c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8043c4:	8b 00                	mov    (%eax),%eax
  8043c6:	85 c0                	test   %eax,%eax
  8043c8:	74 10                	je     8043da <realloc_block_FF+0x2b6>
  8043ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8043cd:	8b 00                	mov    (%eax),%eax
  8043cf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8043d2:	8b 52 04             	mov    0x4(%edx),%edx
  8043d5:	89 50 04             	mov    %edx,0x4(%eax)
  8043d8:	eb 0b                	jmp    8043e5 <realloc_block_FF+0x2c1>
  8043da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8043dd:	8b 40 04             	mov    0x4(%eax),%eax
  8043e0:	a3 4c 60 98 00       	mov    %eax,0x98604c
  8043e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8043e8:	8b 40 04             	mov    0x4(%eax),%eax
  8043eb:	85 c0                	test   %eax,%eax
  8043ed:	74 0f                	je     8043fe <realloc_block_FF+0x2da>
  8043ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8043f2:	8b 40 04             	mov    0x4(%eax),%eax
  8043f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8043f8:	8b 12                	mov    (%edx),%edx
  8043fa:	89 10                	mov    %edx,(%eax)
  8043fc:	eb 0a                	jmp    804408 <realloc_block_FF+0x2e4>
  8043fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804401:	8b 00                	mov    (%eax),%eax
  804403:	a3 48 60 98 00       	mov    %eax,0x986048
  804408:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80440b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804411:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804414:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80441b:	a1 54 60 98 00       	mov    0x986054,%eax
  804420:	48                   	dec    %eax
  804421:	a3 54 60 98 00       	mov    %eax,0x986054
					nextBlk = (struct BlockElement *)((char *)va + new_size); //update nextBlk address
  804426:	8b 55 08             	mov    0x8(%ebp),%edx
  804429:	8b 45 0c             	mov    0xc(%ebp),%eax
  80442c:	01 d0                	add    %edx,%eax
  80442e:	89 45 f0             	mov    %eax,-0x10(%ebp)
					set_block_data(nextBlk,remainingNext,0); // update nextBlkSize
  804431:	83 ec 04             	sub    $0x4,%esp
  804434:	6a 00                	push   $0x0
  804436:	ff 75 e0             	pushl  -0x20(%ebp)
  804439:	ff 75 f0             	pushl  -0x10(%ebp)
  80443c:	e8 b3 f1 ff ff       	call   8035f4 <set_block_data>
  804441:	83 c4 10             	add    $0x10,%esp
					set_block_data(va,new_size,!(is_free_block(va))); // update size of newblock
  804444:	83 ec 0c             	sub    $0xc,%esp
  804447:	ff 75 08             	pushl  0x8(%ebp)
  80444a:	e8 42 ef ff ff       	call   803391 <is_free_block>
  80444f:	83 c4 10             	add    $0x10,%esp
  804452:	84 c0                	test   %al,%al
  804454:	0f 94 c0             	sete   %al
  804457:	0f b6 c0             	movzbl %al,%eax
  80445a:	83 ec 04             	sub    $0x4,%esp
  80445d:	50                   	push   %eax
  80445e:	ff 75 0c             	pushl  0xc(%ebp)
  804461:	ff 75 08             	pushl  0x8(%ebp)
  804464:	e8 8b f1 ff ff       	call   8035f4 <set_block_data>
  804469:	83 c4 10             	add    $0x10,%esp
					insert_sorted_in_freeList(nextBlk);
  80446c:	83 ec 0c             	sub    $0xc,%esp
  80446f:	ff 75 f0             	pushl  -0x10(%ebp)
  804472:	e8 d4 f1 ff ff       	call   80364b <insert_sorted_in_freeList>
  804477:	83 c4 10             	add    $0x10,%esp
					return va;
  80447a:	8b 45 08             	mov    0x8(%ebp),%eax
  80447d:	e9 49 01 00 00       	jmp    8045cb <realloc_block_FF+0x4a7>
				}
			}
		}
		// if next block isn't free or not fit the new size
		return alloc_block_FF(new_size - 8);
  804482:	8b 45 0c             	mov    0xc(%ebp),%eax
  804485:	83 e8 08             	sub    $0x8,%eax
  804488:	83 ec 0c             	sub    $0xc,%esp
  80448b:	50                   	push   %eax
  80448c:	e8 4d f3 ff ff       	call   8037de <alloc_block_FF>
  804491:	83 c4 10             	add    $0x10,%esp
  804494:	e9 32 01 00 00       	jmp    8045cb <realloc_block_FF+0x4a7>
	}
	else if(new_size < actualSize) // to shrink block
  804499:	8b 45 0c             	mov    0xc(%ebp),%eax
  80449c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80449f:	0f 83 21 01 00 00    	jae    8045c6 <realloc_block_FF+0x4a2>
	{
		uint32 remainingSize = actualSize - new_size; // size that will remain from the main block after we shrink it
  8044a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8044a8:	2b 45 0c             	sub    0xc(%ebp),%eax
  8044ab:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(remainingSize < 16 && isNextFree == 0) // internal fragmentation
  8044ae:	83 7d dc 0f          	cmpl   $0xf,-0x24(%ebp)
  8044b2:	77 0e                	ja     8044c2 <realloc_block_FF+0x39e>
  8044b4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8044b8:	75 08                	jne    8044c2 <realloc_block_FF+0x39e>
		{
			// don't change its size
			return va;
  8044ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8044bd:	e9 09 01 00 00       	jmp    8045cb <realloc_block_FF+0x4a7>
		}
		else // remainingSize fit in a new block
		{
			struct BlockElement *mainBlk = (struct BlockElement *)va;
  8044c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8044c5:	89 45 d8             	mov    %eax,-0x28(%ebp)
			// update main block with new size
			set_block_data(mainBlk,new_size,!(is_free_block(va)));
  8044c8:	83 ec 0c             	sub    $0xc,%esp
  8044cb:	ff 75 08             	pushl  0x8(%ebp)
  8044ce:	e8 be ee ff ff       	call   803391 <is_free_block>
  8044d3:	83 c4 10             	add    $0x10,%esp
  8044d6:	84 c0                	test   %al,%al
  8044d8:	0f 94 c0             	sete   %al
  8044db:	0f b6 c0             	movzbl %al,%eax
  8044de:	83 ec 04             	sub    $0x4,%esp
  8044e1:	50                   	push   %eax
  8044e2:	ff 75 0c             	pushl  0xc(%ebp)
  8044e5:	ff 75 d8             	pushl  -0x28(%ebp)
  8044e8:	e8 07 f1 ff ff       	call   8035f4 <set_block_data>
  8044ed:	83 c4 10             	add    $0x10,%esp

			// the blk with remaining size
			struct BlockElement *remainingBlk=(struct BlockElement *)((char*)mainBlk + new_size);
  8044f0:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8044f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8044f6:	01 d0                	add    %edx,%eax
  8044f8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			set_block_data(remainingBlk,remainingSize,0);
  8044fb:	83 ec 04             	sub    $0x4,%esp
  8044fe:	6a 00                	push   $0x0
  804500:	ff 75 dc             	pushl  -0x24(%ebp)
  804503:	ff 75 d4             	pushl  -0x2c(%ebp)
  804506:	e8 e9 f0 ff ff       	call   8035f4 <set_block_data>
  80450b:	83 c4 10             	add    $0x10,%esp

			if(isNextFree)
  80450e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  804512:	0f 84 9b 00 00 00    	je     8045b3 <realloc_block_FF+0x48f>
			{
				// merge splited block with its next block
				set_block_data(remainingBlk,(remainingSize + nextSize),0);//merge remaining with its next block
  804518:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80451b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80451e:	01 d0                	add    %edx,%eax
  804520:	83 ec 04             	sub    $0x4,%esp
  804523:	6a 00                	push   $0x0
  804525:	50                   	push   %eax
  804526:	ff 75 d4             	pushl  -0x2c(%ebp)
  804529:	e8 c6 f0 ff ff       	call   8035f4 <set_block_data>
  80452e:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);
  804531:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804535:	75 17                	jne    80454e <realloc_block_FF+0x42a>
  804537:	83 ec 04             	sub    $0x4,%esp
  80453a:	68 80 52 80 00       	push   $0x805280
  80453f:	68 10 02 00 00       	push   $0x210
  804544:	68 d7 51 80 00       	push   $0x8051d7
  804549:	e8 6b d0 ff ff       	call   8015b9 <_panic>
  80454e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804551:	8b 00                	mov    (%eax),%eax
  804553:	85 c0                	test   %eax,%eax
  804555:	74 10                	je     804567 <realloc_block_FF+0x443>
  804557:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80455a:	8b 00                	mov    (%eax),%eax
  80455c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80455f:	8b 52 04             	mov    0x4(%edx),%edx
  804562:	89 50 04             	mov    %edx,0x4(%eax)
  804565:	eb 0b                	jmp    804572 <realloc_block_FF+0x44e>
  804567:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80456a:	8b 40 04             	mov    0x4(%eax),%eax
  80456d:	a3 4c 60 98 00       	mov    %eax,0x98604c
  804572:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804575:	8b 40 04             	mov    0x4(%eax),%eax
  804578:	85 c0                	test   %eax,%eax
  80457a:	74 0f                	je     80458b <realloc_block_FF+0x467>
  80457c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80457f:	8b 40 04             	mov    0x4(%eax),%eax
  804582:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804585:	8b 12                	mov    (%edx),%edx
  804587:	89 10                	mov    %edx,(%eax)
  804589:	eb 0a                	jmp    804595 <realloc_block_FF+0x471>
  80458b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80458e:	8b 00                	mov    (%eax),%eax
  804590:	a3 48 60 98 00       	mov    %eax,0x986048
  804595:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804598:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80459e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8045a1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8045a8:	a1 54 60 98 00       	mov    0x986054,%eax
  8045ad:	48                   	dec    %eax
  8045ae:	a3 54 60 98 00       	mov    %eax,0x986054
			}
			insert_sorted_in_freeList(remainingBlk);
  8045b3:	83 ec 0c             	sub    $0xc,%esp
  8045b6:	ff 75 d4             	pushl  -0x2c(%ebp)
  8045b9:	e8 8d f0 ff ff       	call   80364b <insert_sorted_in_freeList>
  8045be:	83 c4 10             	add    $0x10,%esp
			return mainBlk;
  8045c1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8045c4:	eb 05                	jmp    8045cb <realloc_block_FF+0x4a7>
		}
	}
	return NULL;
  8045c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8045cb:	c9                   	leave  
  8045cc:	c3                   	ret    

008045cd <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8045cd:	55                   	push   %ebp
  8045ce:	89 e5                	mov    %esp,%ebp
  8045d0:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8045d3:	83 ec 04             	sub    $0x4,%esp
  8045d6:	68 a0 52 80 00       	push   $0x8052a0
  8045db:	68 20 02 00 00       	push   $0x220
  8045e0:	68 d7 51 80 00       	push   $0x8051d7
  8045e5:	e8 cf cf ff ff       	call   8015b9 <_panic>

008045ea <alloc_block_NF>:
}
//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8045ea:	55                   	push   %ebp
  8045eb:	89 e5                	mov    %esp,%ebp
  8045ed:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8045f0:	83 ec 04             	sub    $0x4,%esp
  8045f3:	68 c8 52 80 00       	push   $0x8052c8
  8045f8:	68 28 02 00 00       	push   $0x228
  8045fd:	68 d7 51 80 00       	push   $0x8051d7
  804602:	e8 b2 cf ff ff       	call   8015b9 <_panic>
  804607:	90                   	nop

00804608 <__udivdi3>:
  804608:	55                   	push   %ebp
  804609:	57                   	push   %edi
  80460a:	56                   	push   %esi
  80460b:	53                   	push   %ebx
  80460c:	83 ec 1c             	sub    $0x1c,%esp
  80460f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804613:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804617:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80461b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80461f:	89 ca                	mov    %ecx,%edx
  804621:	89 f8                	mov    %edi,%eax
  804623:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804627:	85 f6                	test   %esi,%esi
  804629:	75 2d                	jne    804658 <__udivdi3+0x50>
  80462b:	39 cf                	cmp    %ecx,%edi
  80462d:	77 65                	ja     804694 <__udivdi3+0x8c>
  80462f:	89 fd                	mov    %edi,%ebp
  804631:	85 ff                	test   %edi,%edi
  804633:	75 0b                	jne    804640 <__udivdi3+0x38>
  804635:	b8 01 00 00 00       	mov    $0x1,%eax
  80463a:	31 d2                	xor    %edx,%edx
  80463c:	f7 f7                	div    %edi
  80463e:	89 c5                	mov    %eax,%ebp
  804640:	31 d2                	xor    %edx,%edx
  804642:	89 c8                	mov    %ecx,%eax
  804644:	f7 f5                	div    %ebp
  804646:	89 c1                	mov    %eax,%ecx
  804648:	89 d8                	mov    %ebx,%eax
  80464a:	f7 f5                	div    %ebp
  80464c:	89 cf                	mov    %ecx,%edi
  80464e:	89 fa                	mov    %edi,%edx
  804650:	83 c4 1c             	add    $0x1c,%esp
  804653:	5b                   	pop    %ebx
  804654:	5e                   	pop    %esi
  804655:	5f                   	pop    %edi
  804656:	5d                   	pop    %ebp
  804657:	c3                   	ret    
  804658:	39 ce                	cmp    %ecx,%esi
  80465a:	77 28                	ja     804684 <__udivdi3+0x7c>
  80465c:	0f bd fe             	bsr    %esi,%edi
  80465f:	83 f7 1f             	xor    $0x1f,%edi
  804662:	75 40                	jne    8046a4 <__udivdi3+0x9c>
  804664:	39 ce                	cmp    %ecx,%esi
  804666:	72 0a                	jb     804672 <__udivdi3+0x6a>
  804668:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80466c:	0f 87 9e 00 00 00    	ja     804710 <__udivdi3+0x108>
  804672:	b8 01 00 00 00       	mov    $0x1,%eax
  804677:	89 fa                	mov    %edi,%edx
  804679:	83 c4 1c             	add    $0x1c,%esp
  80467c:	5b                   	pop    %ebx
  80467d:	5e                   	pop    %esi
  80467e:	5f                   	pop    %edi
  80467f:	5d                   	pop    %ebp
  804680:	c3                   	ret    
  804681:	8d 76 00             	lea    0x0(%esi),%esi
  804684:	31 ff                	xor    %edi,%edi
  804686:	31 c0                	xor    %eax,%eax
  804688:	89 fa                	mov    %edi,%edx
  80468a:	83 c4 1c             	add    $0x1c,%esp
  80468d:	5b                   	pop    %ebx
  80468e:	5e                   	pop    %esi
  80468f:	5f                   	pop    %edi
  804690:	5d                   	pop    %ebp
  804691:	c3                   	ret    
  804692:	66 90                	xchg   %ax,%ax
  804694:	89 d8                	mov    %ebx,%eax
  804696:	f7 f7                	div    %edi
  804698:	31 ff                	xor    %edi,%edi
  80469a:	89 fa                	mov    %edi,%edx
  80469c:	83 c4 1c             	add    $0x1c,%esp
  80469f:	5b                   	pop    %ebx
  8046a0:	5e                   	pop    %esi
  8046a1:	5f                   	pop    %edi
  8046a2:	5d                   	pop    %ebp
  8046a3:	c3                   	ret    
  8046a4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8046a9:	89 eb                	mov    %ebp,%ebx
  8046ab:	29 fb                	sub    %edi,%ebx
  8046ad:	89 f9                	mov    %edi,%ecx
  8046af:	d3 e6                	shl    %cl,%esi
  8046b1:	89 c5                	mov    %eax,%ebp
  8046b3:	88 d9                	mov    %bl,%cl
  8046b5:	d3 ed                	shr    %cl,%ebp
  8046b7:	89 e9                	mov    %ebp,%ecx
  8046b9:	09 f1                	or     %esi,%ecx
  8046bb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8046bf:	89 f9                	mov    %edi,%ecx
  8046c1:	d3 e0                	shl    %cl,%eax
  8046c3:	89 c5                	mov    %eax,%ebp
  8046c5:	89 d6                	mov    %edx,%esi
  8046c7:	88 d9                	mov    %bl,%cl
  8046c9:	d3 ee                	shr    %cl,%esi
  8046cb:	89 f9                	mov    %edi,%ecx
  8046cd:	d3 e2                	shl    %cl,%edx
  8046cf:	8b 44 24 08          	mov    0x8(%esp),%eax
  8046d3:	88 d9                	mov    %bl,%cl
  8046d5:	d3 e8                	shr    %cl,%eax
  8046d7:	09 c2                	or     %eax,%edx
  8046d9:	89 d0                	mov    %edx,%eax
  8046db:	89 f2                	mov    %esi,%edx
  8046dd:	f7 74 24 0c          	divl   0xc(%esp)
  8046e1:	89 d6                	mov    %edx,%esi
  8046e3:	89 c3                	mov    %eax,%ebx
  8046e5:	f7 e5                	mul    %ebp
  8046e7:	39 d6                	cmp    %edx,%esi
  8046e9:	72 19                	jb     804704 <__udivdi3+0xfc>
  8046eb:	74 0b                	je     8046f8 <__udivdi3+0xf0>
  8046ed:	89 d8                	mov    %ebx,%eax
  8046ef:	31 ff                	xor    %edi,%edi
  8046f1:	e9 58 ff ff ff       	jmp    80464e <__udivdi3+0x46>
  8046f6:	66 90                	xchg   %ax,%ax
  8046f8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8046fc:	89 f9                	mov    %edi,%ecx
  8046fe:	d3 e2                	shl    %cl,%edx
  804700:	39 c2                	cmp    %eax,%edx
  804702:	73 e9                	jae    8046ed <__udivdi3+0xe5>
  804704:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804707:	31 ff                	xor    %edi,%edi
  804709:	e9 40 ff ff ff       	jmp    80464e <__udivdi3+0x46>
  80470e:	66 90                	xchg   %ax,%ax
  804710:	31 c0                	xor    %eax,%eax
  804712:	e9 37 ff ff ff       	jmp    80464e <__udivdi3+0x46>
  804717:	90                   	nop

00804718 <__umoddi3>:
  804718:	55                   	push   %ebp
  804719:	57                   	push   %edi
  80471a:	56                   	push   %esi
  80471b:	53                   	push   %ebx
  80471c:	83 ec 1c             	sub    $0x1c,%esp
  80471f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804723:	8b 74 24 34          	mov    0x34(%esp),%esi
  804727:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80472b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80472f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804733:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804737:	89 f3                	mov    %esi,%ebx
  804739:	89 fa                	mov    %edi,%edx
  80473b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80473f:	89 34 24             	mov    %esi,(%esp)
  804742:	85 c0                	test   %eax,%eax
  804744:	75 1a                	jne    804760 <__umoddi3+0x48>
  804746:	39 f7                	cmp    %esi,%edi
  804748:	0f 86 a2 00 00 00    	jbe    8047f0 <__umoddi3+0xd8>
  80474e:	89 c8                	mov    %ecx,%eax
  804750:	89 f2                	mov    %esi,%edx
  804752:	f7 f7                	div    %edi
  804754:	89 d0                	mov    %edx,%eax
  804756:	31 d2                	xor    %edx,%edx
  804758:	83 c4 1c             	add    $0x1c,%esp
  80475b:	5b                   	pop    %ebx
  80475c:	5e                   	pop    %esi
  80475d:	5f                   	pop    %edi
  80475e:	5d                   	pop    %ebp
  80475f:	c3                   	ret    
  804760:	39 f0                	cmp    %esi,%eax
  804762:	0f 87 ac 00 00 00    	ja     804814 <__umoddi3+0xfc>
  804768:	0f bd e8             	bsr    %eax,%ebp
  80476b:	83 f5 1f             	xor    $0x1f,%ebp
  80476e:	0f 84 ac 00 00 00    	je     804820 <__umoddi3+0x108>
  804774:	bf 20 00 00 00       	mov    $0x20,%edi
  804779:	29 ef                	sub    %ebp,%edi
  80477b:	89 fe                	mov    %edi,%esi
  80477d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804781:	89 e9                	mov    %ebp,%ecx
  804783:	d3 e0                	shl    %cl,%eax
  804785:	89 d7                	mov    %edx,%edi
  804787:	89 f1                	mov    %esi,%ecx
  804789:	d3 ef                	shr    %cl,%edi
  80478b:	09 c7                	or     %eax,%edi
  80478d:	89 e9                	mov    %ebp,%ecx
  80478f:	d3 e2                	shl    %cl,%edx
  804791:	89 14 24             	mov    %edx,(%esp)
  804794:	89 d8                	mov    %ebx,%eax
  804796:	d3 e0                	shl    %cl,%eax
  804798:	89 c2                	mov    %eax,%edx
  80479a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80479e:	d3 e0                	shl    %cl,%eax
  8047a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8047a4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8047a8:	89 f1                	mov    %esi,%ecx
  8047aa:	d3 e8                	shr    %cl,%eax
  8047ac:	09 d0                	or     %edx,%eax
  8047ae:	d3 eb                	shr    %cl,%ebx
  8047b0:	89 da                	mov    %ebx,%edx
  8047b2:	f7 f7                	div    %edi
  8047b4:	89 d3                	mov    %edx,%ebx
  8047b6:	f7 24 24             	mull   (%esp)
  8047b9:	89 c6                	mov    %eax,%esi
  8047bb:	89 d1                	mov    %edx,%ecx
  8047bd:	39 d3                	cmp    %edx,%ebx
  8047bf:	0f 82 87 00 00 00    	jb     80484c <__umoddi3+0x134>
  8047c5:	0f 84 91 00 00 00    	je     80485c <__umoddi3+0x144>
  8047cb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8047cf:	29 f2                	sub    %esi,%edx
  8047d1:	19 cb                	sbb    %ecx,%ebx
  8047d3:	89 d8                	mov    %ebx,%eax
  8047d5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8047d9:	d3 e0                	shl    %cl,%eax
  8047db:	89 e9                	mov    %ebp,%ecx
  8047dd:	d3 ea                	shr    %cl,%edx
  8047df:	09 d0                	or     %edx,%eax
  8047e1:	89 e9                	mov    %ebp,%ecx
  8047e3:	d3 eb                	shr    %cl,%ebx
  8047e5:	89 da                	mov    %ebx,%edx
  8047e7:	83 c4 1c             	add    $0x1c,%esp
  8047ea:	5b                   	pop    %ebx
  8047eb:	5e                   	pop    %esi
  8047ec:	5f                   	pop    %edi
  8047ed:	5d                   	pop    %ebp
  8047ee:	c3                   	ret    
  8047ef:	90                   	nop
  8047f0:	89 fd                	mov    %edi,%ebp
  8047f2:	85 ff                	test   %edi,%edi
  8047f4:	75 0b                	jne    804801 <__umoddi3+0xe9>
  8047f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8047fb:	31 d2                	xor    %edx,%edx
  8047fd:	f7 f7                	div    %edi
  8047ff:	89 c5                	mov    %eax,%ebp
  804801:	89 f0                	mov    %esi,%eax
  804803:	31 d2                	xor    %edx,%edx
  804805:	f7 f5                	div    %ebp
  804807:	89 c8                	mov    %ecx,%eax
  804809:	f7 f5                	div    %ebp
  80480b:	89 d0                	mov    %edx,%eax
  80480d:	e9 44 ff ff ff       	jmp    804756 <__umoddi3+0x3e>
  804812:	66 90                	xchg   %ax,%ax
  804814:	89 c8                	mov    %ecx,%eax
  804816:	89 f2                	mov    %esi,%edx
  804818:	83 c4 1c             	add    $0x1c,%esp
  80481b:	5b                   	pop    %ebx
  80481c:	5e                   	pop    %esi
  80481d:	5f                   	pop    %edi
  80481e:	5d                   	pop    %ebp
  80481f:	c3                   	ret    
  804820:	3b 04 24             	cmp    (%esp),%eax
  804823:	72 06                	jb     80482b <__umoddi3+0x113>
  804825:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804829:	77 0f                	ja     80483a <__umoddi3+0x122>
  80482b:	89 f2                	mov    %esi,%edx
  80482d:	29 f9                	sub    %edi,%ecx
  80482f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804833:	89 14 24             	mov    %edx,(%esp)
  804836:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80483a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80483e:	8b 14 24             	mov    (%esp),%edx
  804841:	83 c4 1c             	add    $0x1c,%esp
  804844:	5b                   	pop    %ebx
  804845:	5e                   	pop    %esi
  804846:	5f                   	pop    %edi
  804847:	5d                   	pop    %ebp
  804848:	c3                   	ret    
  804849:	8d 76 00             	lea    0x0(%esi),%esi
  80484c:	2b 04 24             	sub    (%esp),%eax
  80484f:	19 fa                	sbb    %edi,%edx
  804851:	89 d1                	mov    %edx,%ecx
  804853:	89 c6                	mov    %eax,%esi
  804855:	e9 71 ff ff ff       	jmp    8047cb <__umoddi3+0xb3>
  80485a:	66 90                	xchg   %ax,%ax
  80485c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804860:	72 ea                	jb     80484c <__umoddi3+0x134>
  804862:	89 d9                	mov    %ebx,%ecx
  804864:	e9 62 ff ff ff       	jmp    8047cb <__umoddi3+0xb3>
