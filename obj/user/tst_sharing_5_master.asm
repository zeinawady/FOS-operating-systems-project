
obj/user/tst_sharing_5_master:     file format elf32-i386


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
  800031:	e8 e2 03 00 00       	call   800418 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

extern volatile bool printStats;
void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 44             	sub    $0x44,%esp
	printStats = 0;
  80003f:	c7 05 00 50 80 00 00 	movl   $0x0,0x805000
  800046:	00 00 00 

	/*=================================================*/
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  800049:	a1 20 50 80 00       	mov    0x805020,%eax
  80004e:	8b 90 a0 00 00 00    	mov    0xa0(%eax),%edx
  800054:	a1 20 50 80 00       	mov    0x805020,%eax
  800059:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  80005f:	39 c2                	cmp    %eax,%edx
  800061:	72 14                	jb     800077 <_main+0x3f>
			panic("Please increase the WS size");
  800063:	83 ec 04             	sub    $0x4,%esp
  800066:	68 e0 38 80 00       	push   $0x8038e0
  80006b:	6a 15                	push   $0x15
  80006d:	68 fc 38 80 00       	push   $0x8038fc
  800072:	e8 e6 04 00 00       	call   80055d <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  800077:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)
	uint32 *x, *y, *z ;
	int freeFrames, diff, expected;

	cprintf("************************************************\n");
  80007e:	83 ec 0c             	sub    $0xc,%esp
  800081:	68 18 39 80 00       	push   $0x803918
  800086:	e8 8f 07 00 00       	call   80081a <cprintf>
  80008b:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  80008e:	83 ec 0c             	sub    $0xc,%esp
  800091:	68 4c 39 80 00       	push   $0x80394c
  800096:	e8 7f 07 00 00       	call   80081a <cprintf>
  80009b:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	68 a8 39 80 00       	push   $0x8039a8
  8000a6:	e8 6f 07 00 00       	call   80081a <cprintf>
  8000ab:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8000ae:	e8 9c 1e 00 00       	call   801f4f <sys_getenvid>
  8000b3:	89 45 f0             	mov    %eax,-0x10(%ebp)

	cprintf("STEP A: checking free of shared object using 2 environments... \n");
  8000b6:	83 ec 0c             	sub    $0xc,%esp
  8000b9:	68 dc 39 80 00       	push   $0x8039dc
  8000be:	e8 57 07 00 00       	call   80081a <cprintf>
  8000c3:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x;
		int32 envIdSlave1 = sys_create_env("tshr5slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8000c6:	a1 20 50 80 00       	mov    0x805020,%eax
  8000cb:	8b 90 90 05 00 00    	mov    0x590(%eax),%edx
  8000d1:	a1 20 50 80 00       	mov    0x805020,%eax
  8000d6:	8b 80 88 05 00 00    	mov    0x588(%eax),%eax
  8000dc:	89 c1                	mov    %eax,%ecx
  8000de:	a1 20 50 80 00       	mov    0x805020,%eax
  8000e3:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  8000e9:	52                   	push   %edx
  8000ea:	51                   	push   %ecx
  8000eb:	50                   	push   %eax
  8000ec:	68 1d 3a 80 00       	push   $0x803a1d
  8000f1:	e8 04 1e 00 00       	call   801efa <sys_create_env>
  8000f6:	83 c4 10             	add    $0x10,%esp
  8000f9:	89 45 ec             	mov    %eax,-0x14(%ebp)
		int32 envIdSlave2 = sys_create_env("tshr5slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8000fc:	a1 20 50 80 00       	mov    0x805020,%eax
  800101:	8b 90 90 05 00 00    	mov    0x590(%eax),%edx
  800107:	a1 20 50 80 00       	mov    0x805020,%eax
  80010c:	8b 80 88 05 00 00    	mov    0x588(%eax),%eax
  800112:	89 c1                	mov    %eax,%ecx
  800114:	a1 20 50 80 00       	mov    0x805020,%eax
  800119:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  80011f:	52                   	push   %edx
  800120:	51                   	push   %ecx
  800121:	50                   	push   %eax
  800122:	68 1d 3a 80 00       	push   $0x803a1d
  800127:	e8 ce 1d 00 00       	call   801efa <sys_create_env>
  80012c:	83 c4 10             	add    $0x10,%esp
  80012f:	89 45 e8             	mov    %eax,-0x18(%ebp)

		int freeFrames = sys_calculate_free_frames() ;
  800132:	e8 68 1c 00 00       	call   801d9f <sys_calculate_free_frames>
  800137:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		x = smalloc("x", PAGE_SIZE, 1);
  80013a:	83 ec 04             	sub    $0x4,%esp
  80013d:	6a 01                	push   $0x1
  80013f:	68 00 10 00 00       	push   $0x1000
  800144:	68 28 3a 80 00       	push   $0x803a28
  800149:	e8 33 17 00 00       	call   801881 <smalloc>
  80014e:	83 c4 10             	add    $0x10,%esp
  800151:	89 45 e0             	mov    %eax,-0x20(%ebp)

		cprintf("Master env created x (1 page) \n");
  800154:	83 ec 0c             	sub    $0xc,%esp
  800157:	68 2c 3a 80 00       	push   $0x803a2c
  80015c:	e8 b9 06 00 00       	call   80081a <cprintf>
  800161:	83 c4 10             	add    $0x10,%esp
		if (x != (uint32*)pagealloc_start) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800164:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800167:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  80016a:	74 14                	je     800180 <_main+0x148>
  80016c:	83 ec 04             	sub    $0x4,%esp
  80016f:	68 4c 3a 80 00       	push   $0x803a4c
  800174:	6a 31                	push   $0x31
  800176:	68 fc 38 80 00       	push   $0x8038fc
  80017b:	e8 dd 03 00 00       	call   80055d <_panic>
		expected = 1+1 ; /*1page +1table*/
  800180:	c7 45 dc 02 00 00 00 	movl   $0x2,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800187:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80018a:	e8 10 1c 00 00       	call   801d9f <sys_calculate_free_frames>
  80018f:	29 c3                	sub    %eax,%ebx
  800191:	89 d8                	mov    %ebx,%eax
  800193:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/)
  800196:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800199:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80019c:	7c 0b                	jl     8001a9 <_main+0x171>
  80019e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001a1:	83 c0 02             	add    $0x2,%eax
  8001a4:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8001a7:	7d 24                	jge    8001cd <_main+0x195>
			panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  8001a9:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8001ac:	e8 ee 1b 00 00       	call   801d9f <sys_calculate_free_frames>
  8001b1:	29 c3                	sub    %eax,%ebx
  8001b3:	89 d8                	mov    %ebx,%eax
  8001b5:	83 ec 0c             	sub    $0xc,%esp
  8001b8:	ff 75 dc             	pushl  -0x24(%ebp)
  8001bb:	50                   	push   %eax
  8001bc:	68 b8 3a 80 00       	push   $0x803ab8
  8001c1:	6a 35                	push   $0x35
  8001c3:	68 fc 38 80 00       	push   $0x8038fc
  8001c8:	e8 90 03 00 00       	call   80055d <_panic>

		//to check that the slave environments completed successfully
		rsttst();
  8001cd:	e8 74 1e 00 00       	call   802046 <rsttst>

		sys_run_env(envIdSlave1);
  8001d2:	83 ec 0c             	sub    $0xc,%esp
  8001d5:	ff 75 ec             	pushl  -0x14(%ebp)
  8001d8:	e8 3b 1d 00 00       	call   801f18 <sys_run_env>
  8001dd:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlave2);
  8001e0:	83 ec 0c             	sub    $0xc,%esp
  8001e3:	ff 75 e8             	pushl  -0x18(%ebp)
  8001e6:	e8 2d 1d 00 00       	call   801f18 <sys_run_env>
  8001eb:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  8001ee:	83 ec 0c             	sub    $0xc,%esp
  8001f1:	68 50 3b 80 00       	push   $0x803b50
  8001f6:	e8 1f 06 00 00       	call   80081a <cprintf>
  8001fb:	83 c4 10             	add    $0x10,%esp
		env_sleep(3000);
  8001fe:	83 ec 0c             	sub    $0xc,%esp
  800201:	68 b8 0b 00 00       	push   $0xbb8
  800206:	e8 a0 33 00 00       	call   8035ab <env_sleep>
  80020b:	83 c4 10             	add    $0x10,%esp

		//to ensure that the slave environments completed successfully
		while (gettst()!=2) ;// panic("test failed");
  80020e:	90                   	nop
  80020f:	e8 ac 1e 00 00       	call   8020c0 <gettst>
  800214:	83 f8 02             	cmp    $0x2,%eax
  800217:	75 f6                	jne    80020f <_main+0x1d7>

		freeFrames = sys_calculate_free_frames() ;
  800219:	e8 81 1b 00 00       	call   801d9f <sys_calculate_free_frames>
  80021e:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		sfree(x);
  800221:	83 ec 0c             	sub    $0xc,%esp
  800224:	ff 75 e0             	pushl  -0x20(%ebp)
  800227:	e8 87 19 00 00       	call   801bb3 <sfree>
  80022c:	83 c4 10             	add    $0x10,%esp

		cprintf("Master env removed x (1 page) \n");
  80022f:	83 ec 0c             	sub    $0xc,%esp
  800232:	68 68 3b 80 00       	push   $0x803b68
  800237:	e8 de 05 00 00       	call   80081a <cprintf>
  80023c:	83 c4 10             	add    $0x10,%esp
		int diff2 = (sys_calculate_free_frames() - freeFrames);
  80023f:	e8 5b 1b 00 00       	call   801d9f <sys_calculate_free_frames>
  800244:	89 c2                	mov    %eax,%edx
  800246:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800249:	29 c2                	sub    %eax,%edx
  80024b:	89 d0                	mov    %edx,%eax
  80024d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		expected = 1+1; /*1page+1table*/
  800250:	c7 45 dc 02 00 00 00 	movl   $0x2,-0x24(%ebp)
		if (diff != expected) panic("Wrong free (diff=%d, expected=%d): revise your freeSharedObject logic\n", diff, expected);
  800257:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80025a:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80025d:	74 1a                	je     800279 <_main+0x241>
  80025f:	83 ec 0c             	sub    $0xc,%esp
  800262:	ff 75 dc             	pushl  -0x24(%ebp)
  800265:	ff 75 d8             	pushl  -0x28(%ebp)
  800268:	68 88 3b 80 00       	push   $0x803b88
  80026d:	6a 4a                	push   $0x4a
  80026f:	68 fc 38 80 00       	push   $0x8038fc
  800274:	e8 e4 02 00 00       	call   80055d <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  800279:	83 ec 0c             	sub    $0xc,%esp
  80027c:	68 d0 3b 80 00       	push   $0x803bd0
  800281:	e8 94 05 00 00       	call   80081a <cprintf>
  800286:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP B: checking free of 2 shared objects ... \n");
  800289:	83 ec 0c             	sub    $0xc,%esp
  80028c:	68 f4 3b 80 00       	push   $0x803bf4
  800291:	e8 84 05 00 00       	call   80081a <cprintf>
  800296:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		int32 envIdSlaveB1 = sys_create_env("tshr5slaveB1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800299:	a1 20 50 80 00       	mov    0x805020,%eax
  80029e:	8b 90 90 05 00 00    	mov    0x590(%eax),%edx
  8002a4:	a1 20 50 80 00       	mov    0x805020,%eax
  8002a9:	8b 80 88 05 00 00    	mov    0x588(%eax),%eax
  8002af:	89 c1                	mov    %eax,%ecx
  8002b1:	a1 20 50 80 00       	mov    0x805020,%eax
  8002b6:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  8002bc:	52                   	push   %edx
  8002bd:	51                   	push   %ecx
  8002be:	50                   	push   %eax
  8002bf:	68 24 3c 80 00       	push   $0x803c24
  8002c4:	e8 31 1c 00 00       	call   801efa <sys_create_env>
  8002c9:	83 c4 10             	add    $0x10,%esp
  8002cc:	89 45 d0             	mov    %eax,-0x30(%ebp)
		int32 envIdSlaveB2 = sys_create_env("tshr5slaveB2", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8002cf:	a1 20 50 80 00       	mov    0x805020,%eax
  8002d4:	8b 90 90 05 00 00    	mov    0x590(%eax),%edx
  8002da:	a1 20 50 80 00       	mov    0x805020,%eax
  8002df:	8b 80 88 05 00 00    	mov    0x588(%eax),%eax
  8002e5:	89 c1                	mov    %eax,%ecx
  8002e7:	a1 20 50 80 00       	mov    0x805020,%eax
  8002ec:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  8002f2:	52                   	push   %edx
  8002f3:	51                   	push   %ecx
  8002f4:	50                   	push   %eax
  8002f5:	68 31 3c 80 00       	push   $0x803c31
  8002fa:	e8 fb 1b 00 00       	call   801efa <sys_create_env>
  8002ff:	83 c4 10             	add    $0x10,%esp
  800302:	89 45 cc             	mov    %eax,-0x34(%ebp)

		z = smalloc("z", PAGE_SIZE+1, 1);
  800305:	83 ec 04             	sub    $0x4,%esp
  800308:	6a 01                	push   $0x1
  80030a:	68 01 10 00 00       	push   $0x1001
  80030f:	68 3e 3c 80 00       	push   $0x803c3e
  800314:	e8 68 15 00 00       	call   801881 <smalloc>
  800319:	83 c4 10             	add    $0x10,%esp
  80031c:	89 45 c8             	mov    %eax,-0x38(%ebp)
		cprintf("Master env created z (2 pages) \n");
  80031f:	83 ec 0c             	sub    $0xc,%esp
  800322:	68 40 3c 80 00       	push   $0x803c40
  800327:	e8 ee 04 00 00       	call   80081a <cprintf>
  80032c:	83 c4 10             	add    $0x10,%esp

		x = smalloc("x", PAGE_SIZE+1024, 1);
  80032f:	83 ec 04             	sub    $0x4,%esp
  800332:	6a 01                	push   $0x1
  800334:	68 00 14 00 00       	push   $0x1400
  800339:	68 28 3a 80 00       	push   $0x803a28
  80033e:	e8 3e 15 00 00       	call   801881 <smalloc>
  800343:	83 c4 10             	add    $0x10,%esp
  800346:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		cprintf("Master env created x (2 pages) \n");
  800349:	83 ec 0c             	sub    $0xc,%esp
  80034c:	68 64 3c 80 00       	push   $0x803c64
  800351:	e8 c4 04 00 00       	call   80081a <cprintf>
  800356:	83 c4 10             	add    $0x10,%esp

		rsttst();
  800359:	e8 e8 1c 00 00       	call   802046 <rsttst>

		sys_run_env(envIdSlaveB1);
  80035e:	83 ec 0c             	sub    $0xc,%esp
  800361:	ff 75 d0             	pushl  -0x30(%ebp)
  800364:	e8 af 1b 00 00       	call   801f18 <sys_run_env>
  800369:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlaveB2);
  80036c:	83 ec 0c             	sub    $0xc,%esp
  80036f:	ff 75 cc             	pushl  -0x34(%ebp)
  800372:	e8 a1 1b 00 00       	call   801f18 <sys_run_env>
  800377:	83 c4 10             	add    $0x10,%esp

		//give slaves time to catch the shared object before removal
		{
//			env_sleep(4000);
			while (gettst()!=2) ;
  80037a:	90                   	nop
  80037b:	e8 40 1d 00 00       	call   8020c0 <gettst>
  800380:	83 f8 02             	cmp    $0x2,%eax
  800383:	75 f6                	jne    80037b <_main+0x343>
		}

//		rsttst();

		int freeFrames = sys_calculate_free_frames() ;
  800385:	e8 15 1a 00 00       	call   801d9f <sys_calculate_free_frames>
  80038a:	89 45 c0             	mov    %eax,-0x40(%ebp)

		sfree(z);
  80038d:	83 ec 0c             	sub    $0xc,%esp
  800390:	ff 75 c8             	pushl  -0x38(%ebp)
  800393:	e8 1b 18 00 00       	call   801bb3 <sfree>
  800398:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed z\n");
  80039b:	83 ec 0c             	sub    $0xc,%esp
  80039e:	68 85 3c 80 00       	push   $0x803c85
  8003a3:	e8 72 04 00 00       	call   80081a <cprintf>
  8003a8:	83 c4 10             	add    $0x10,%esp

		sfree(x);
  8003ab:	83 ec 0c             	sub    $0xc,%esp
  8003ae:	ff 75 c4             	pushl  -0x3c(%ebp)
  8003b1:	e8 fd 17 00 00       	call   801bb3 <sfree>
  8003b6:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x\n");
  8003b9:	83 ec 0c             	sub    $0xc,%esp
  8003bc:	68 9b 3c 80 00       	push   $0x803c9b
  8003c1:	e8 54 04 00 00       	call   80081a <cprintf>
  8003c6:	83 c4 10             	add    $0x10,%esp

		int diff = (sys_calculate_free_frames() - freeFrames);
  8003c9:	e8 d1 19 00 00       	call   801d9f <sys_calculate_free_frames>
  8003ce:	89 c2                	mov    %eax,%edx
  8003d0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8003d3:	29 c2                	sub    %eax,%edx
  8003d5:	89 d0                	mov    %edx,%eax
  8003d7:	89 45 bc             	mov    %eax,-0x44(%ebp)
		expected = 1 /*table*/;
  8003da:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
		if (diff !=  expected) panic("Wrong free: frames removed not equal 1 !, correct frames to be removed are 1:\nfrom the env: 1 table\nframes_storage of z & x: should NOT cleared yet (still in use!)\n");
  8003e1:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8003e4:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8003e7:	74 14                	je     8003fd <_main+0x3c5>
  8003e9:	83 ec 04             	sub    $0x4,%esp
  8003ec:	68 b4 3c 80 00       	push   $0x803cb4
  8003f1:	6a 71                	push   $0x71
  8003f3:	68 fc 38 80 00       	push   $0x8038fc
  8003f8:	e8 60 01 00 00       	call   80055d <_panic>

		//To indicate that it's completed successfully
		cprintf("Master is completed.\n");
  8003fd:	83 ec 0c             	sub    $0xc,%esp
  800400:	68 59 3d 80 00       	push   $0x803d59
  800405:	e8 10 04 00 00       	call   80081a <cprintf>
  80040a:	83 c4 10             	add    $0x10,%esp
		inctst();
  80040d:	e8 94 1c 00 00       	call   8020a6 <inctst>
	}


	return;
  800412:	90                   	nop
}
  800413:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800416:	c9                   	leave  
  800417:	c3                   	ret    

00800418 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800418:	55                   	push   %ebp
  800419:	89 e5                	mov    %esp,%ebp
  80041b:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80041e:	e8 45 1b 00 00       	call   801f68 <sys_getenvindex>
  800423:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800426:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800429:	89 d0                	mov    %edx,%eax
  80042b:	c1 e0 02             	shl    $0x2,%eax
  80042e:	01 d0                	add    %edx,%eax
  800430:	c1 e0 03             	shl    $0x3,%eax
  800433:	01 d0                	add    %edx,%eax
  800435:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80043c:	01 d0                	add    %edx,%eax
  80043e:	c1 e0 02             	shl    $0x2,%eax
  800441:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800446:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80044b:	a1 20 50 80 00       	mov    0x805020,%eax
  800450:	8a 40 20             	mov    0x20(%eax),%al
  800453:	84 c0                	test   %al,%al
  800455:	74 0d                	je     800464 <libmain+0x4c>
		binaryname = myEnv->prog_name;
  800457:	a1 20 50 80 00       	mov    0x805020,%eax
  80045c:	83 c0 20             	add    $0x20,%eax
  80045f:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800464:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800468:	7e 0a                	jle    800474 <libmain+0x5c>
		binaryname = argv[0];
  80046a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80046d:	8b 00                	mov    (%eax),%eax
  80046f:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  800474:	83 ec 08             	sub    $0x8,%esp
  800477:	ff 75 0c             	pushl  0xc(%ebp)
  80047a:	ff 75 08             	pushl  0x8(%ebp)
  80047d:	e8 b6 fb ff ff       	call   800038 <_main>
  800482:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800485:	a1 00 50 80 00       	mov    0x805000,%eax
  80048a:	85 c0                	test   %eax,%eax
  80048c:	0f 84 9f 00 00 00    	je     800531 <libmain+0x119>
	{
		sys_lock_cons();
  800492:	e8 55 18 00 00       	call   801cec <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800497:	83 ec 0c             	sub    $0xc,%esp
  80049a:	68 88 3d 80 00       	push   $0x803d88
  80049f:	e8 76 03 00 00       	call   80081a <cprintf>
  8004a4:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8004a7:	a1 20 50 80 00       	mov    0x805020,%eax
  8004ac:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8004b2:	a1 20 50 80 00       	mov    0x805020,%eax
  8004b7:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8004bd:	83 ec 04             	sub    $0x4,%esp
  8004c0:	52                   	push   %edx
  8004c1:	50                   	push   %eax
  8004c2:	68 b0 3d 80 00       	push   $0x803db0
  8004c7:	e8 4e 03 00 00       	call   80081a <cprintf>
  8004cc:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8004cf:	a1 20 50 80 00       	mov    0x805020,%eax
  8004d4:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8004da:	a1 20 50 80 00       	mov    0x805020,%eax
  8004df:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8004e5:	a1 20 50 80 00       	mov    0x805020,%eax
  8004ea:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  8004f0:	51                   	push   %ecx
  8004f1:	52                   	push   %edx
  8004f2:	50                   	push   %eax
  8004f3:	68 d8 3d 80 00       	push   $0x803dd8
  8004f8:	e8 1d 03 00 00       	call   80081a <cprintf>
  8004fd:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800500:	a1 20 50 80 00       	mov    0x805020,%eax
  800505:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  80050b:	83 ec 08             	sub    $0x8,%esp
  80050e:	50                   	push   %eax
  80050f:	68 30 3e 80 00       	push   $0x803e30
  800514:	e8 01 03 00 00       	call   80081a <cprintf>
  800519:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80051c:	83 ec 0c             	sub    $0xc,%esp
  80051f:	68 88 3d 80 00       	push   $0x803d88
  800524:	e8 f1 02 00 00       	call   80081a <cprintf>
  800529:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80052c:	e8 d5 17 00 00       	call   801d06 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800531:	e8 19 00 00 00       	call   80054f <exit>
}
  800536:	90                   	nop
  800537:	c9                   	leave  
  800538:	c3                   	ret    

00800539 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800539:	55                   	push   %ebp
  80053a:	89 e5                	mov    %esp,%ebp
  80053c:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80053f:	83 ec 0c             	sub    $0xc,%esp
  800542:	6a 00                	push   $0x0
  800544:	e8 eb 19 00 00       	call   801f34 <sys_destroy_env>
  800549:	83 c4 10             	add    $0x10,%esp
}
  80054c:	90                   	nop
  80054d:	c9                   	leave  
  80054e:	c3                   	ret    

0080054f <exit>:

void
exit(void)
{
  80054f:	55                   	push   %ebp
  800550:	89 e5                	mov    %esp,%ebp
  800552:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800555:	e8 40 1a 00 00       	call   801f9a <sys_exit_env>
}
  80055a:	90                   	nop
  80055b:	c9                   	leave  
  80055c:	c3                   	ret    

0080055d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80055d:	55                   	push   %ebp
  80055e:	89 e5                	mov    %esp,%ebp
  800560:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800563:	8d 45 10             	lea    0x10(%ebp),%eax
  800566:	83 c0 04             	add    $0x4,%eax
  800569:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80056c:	a1 60 50 98 00       	mov    0x985060,%eax
  800571:	85 c0                	test   %eax,%eax
  800573:	74 16                	je     80058b <_panic+0x2e>
		cprintf("%s: ", argv0);
  800575:	a1 60 50 98 00       	mov    0x985060,%eax
  80057a:	83 ec 08             	sub    $0x8,%esp
  80057d:	50                   	push   %eax
  80057e:	68 44 3e 80 00       	push   $0x803e44
  800583:	e8 92 02 00 00       	call   80081a <cprintf>
  800588:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80058b:	a1 04 50 80 00       	mov    0x805004,%eax
  800590:	ff 75 0c             	pushl  0xc(%ebp)
  800593:	ff 75 08             	pushl  0x8(%ebp)
  800596:	50                   	push   %eax
  800597:	68 49 3e 80 00       	push   $0x803e49
  80059c:	e8 79 02 00 00       	call   80081a <cprintf>
  8005a1:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8005a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8005a7:	83 ec 08             	sub    $0x8,%esp
  8005aa:	ff 75 f4             	pushl  -0xc(%ebp)
  8005ad:	50                   	push   %eax
  8005ae:	e8 fc 01 00 00       	call   8007af <vcprintf>
  8005b3:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8005b6:	83 ec 08             	sub    $0x8,%esp
  8005b9:	6a 00                	push   $0x0
  8005bb:	68 65 3e 80 00       	push   $0x803e65
  8005c0:	e8 ea 01 00 00       	call   8007af <vcprintf>
  8005c5:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8005c8:	e8 82 ff ff ff       	call   80054f <exit>

	// should not return here
	while (1) ;
  8005cd:	eb fe                	jmp    8005cd <_panic+0x70>

008005cf <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8005cf:	55                   	push   %ebp
  8005d0:	89 e5                	mov    %esp,%ebp
  8005d2:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8005d5:	a1 20 50 80 00       	mov    0x805020,%eax
  8005da:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8005e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e3:	39 c2                	cmp    %eax,%edx
  8005e5:	74 14                	je     8005fb <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8005e7:	83 ec 04             	sub    $0x4,%esp
  8005ea:	68 68 3e 80 00       	push   $0x803e68
  8005ef:	6a 26                	push   $0x26
  8005f1:	68 b4 3e 80 00       	push   $0x803eb4
  8005f6:	e8 62 ff ff ff       	call   80055d <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8005fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800602:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800609:	e9 c5 00 00 00       	jmp    8006d3 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80060e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800611:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800618:	8b 45 08             	mov    0x8(%ebp),%eax
  80061b:	01 d0                	add    %edx,%eax
  80061d:	8b 00                	mov    (%eax),%eax
  80061f:	85 c0                	test   %eax,%eax
  800621:	75 08                	jne    80062b <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800623:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800626:	e9 a5 00 00 00       	jmp    8006d0 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80062b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800632:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800639:	eb 69                	jmp    8006a4 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80063b:	a1 20 50 80 00       	mov    0x805020,%eax
  800640:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800646:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800649:	89 d0                	mov    %edx,%eax
  80064b:	01 c0                	add    %eax,%eax
  80064d:	01 d0                	add    %edx,%eax
  80064f:	c1 e0 03             	shl    $0x3,%eax
  800652:	01 c8                	add    %ecx,%eax
  800654:	8a 40 04             	mov    0x4(%eax),%al
  800657:	84 c0                	test   %al,%al
  800659:	75 46                	jne    8006a1 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80065b:	a1 20 50 80 00       	mov    0x805020,%eax
  800660:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800666:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800669:	89 d0                	mov    %edx,%eax
  80066b:	01 c0                	add    %eax,%eax
  80066d:	01 d0                	add    %edx,%eax
  80066f:	c1 e0 03             	shl    $0x3,%eax
  800672:	01 c8                	add    %ecx,%eax
  800674:	8b 00                	mov    (%eax),%eax
  800676:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800679:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80067c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800681:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800683:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800686:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80068d:	8b 45 08             	mov    0x8(%ebp),%eax
  800690:	01 c8                	add    %ecx,%eax
  800692:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800694:	39 c2                	cmp    %eax,%edx
  800696:	75 09                	jne    8006a1 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800698:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80069f:	eb 15                	jmp    8006b6 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006a1:	ff 45 e8             	incl   -0x18(%ebp)
  8006a4:	a1 20 50 80 00       	mov    0x805020,%eax
  8006a9:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8006af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006b2:	39 c2                	cmp    %eax,%edx
  8006b4:	77 85                	ja     80063b <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8006b6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8006ba:	75 14                	jne    8006d0 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8006bc:	83 ec 04             	sub    $0x4,%esp
  8006bf:	68 c0 3e 80 00       	push   $0x803ec0
  8006c4:	6a 3a                	push   $0x3a
  8006c6:	68 b4 3e 80 00       	push   $0x803eb4
  8006cb:	e8 8d fe ff ff       	call   80055d <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8006d0:	ff 45 f0             	incl   -0x10(%ebp)
  8006d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006d6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006d9:	0f 8c 2f ff ff ff    	jl     80060e <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8006df:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006e6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8006ed:	eb 26                	jmp    800715 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8006ef:	a1 20 50 80 00       	mov    0x805020,%eax
  8006f4:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8006fa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006fd:	89 d0                	mov    %edx,%eax
  8006ff:	01 c0                	add    %eax,%eax
  800701:	01 d0                	add    %edx,%eax
  800703:	c1 e0 03             	shl    $0x3,%eax
  800706:	01 c8                	add    %ecx,%eax
  800708:	8a 40 04             	mov    0x4(%eax),%al
  80070b:	3c 01                	cmp    $0x1,%al
  80070d:	75 03                	jne    800712 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80070f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800712:	ff 45 e0             	incl   -0x20(%ebp)
  800715:	a1 20 50 80 00       	mov    0x805020,%eax
  80071a:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800720:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800723:	39 c2                	cmp    %eax,%edx
  800725:	77 c8                	ja     8006ef <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800727:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80072a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80072d:	74 14                	je     800743 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80072f:	83 ec 04             	sub    $0x4,%esp
  800732:	68 14 3f 80 00       	push   $0x803f14
  800737:	6a 44                	push   $0x44
  800739:	68 b4 3e 80 00       	push   $0x803eb4
  80073e:	e8 1a fe ff ff       	call   80055d <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800743:	90                   	nop
  800744:	c9                   	leave  
  800745:	c3                   	ret    

00800746 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800746:	55                   	push   %ebp
  800747:	89 e5                	mov    %esp,%ebp
  800749:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80074c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80074f:	8b 00                	mov    (%eax),%eax
  800751:	8d 48 01             	lea    0x1(%eax),%ecx
  800754:	8b 55 0c             	mov    0xc(%ebp),%edx
  800757:	89 0a                	mov    %ecx,(%edx)
  800759:	8b 55 08             	mov    0x8(%ebp),%edx
  80075c:	88 d1                	mov    %dl,%cl
  80075e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800761:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800765:	8b 45 0c             	mov    0xc(%ebp),%eax
  800768:	8b 00                	mov    (%eax),%eax
  80076a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80076f:	75 2c                	jne    80079d <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800771:	a0 44 50 98 00       	mov    0x985044,%al
  800776:	0f b6 c0             	movzbl %al,%eax
  800779:	8b 55 0c             	mov    0xc(%ebp),%edx
  80077c:	8b 12                	mov    (%edx),%edx
  80077e:	89 d1                	mov    %edx,%ecx
  800780:	8b 55 0c             	mov    0xc(%ebp),%edx
  800783:	83 c2 08             	add    $0x8,%edx
  800786:	83 ec 04             	sub    $0x4,%esp
  800789:	50                   	push   %eax
  80078a:	51                   	push   %ecx
  80078b:	52                   	push   %edx
  80078c:	e8 19 15 00 00       	call   801caa <sys_cputs>
  800791:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800794:	8b 45 0c             	mov    0xc(%ebp),%eax
  800797:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80079d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007a0:	8b 40 04             	mov    0x4(%eax),%eax
  8007a3:	8d 50 01             	lea    0x1(%eax),%edx
  8007a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007a9:	89 50 04             	mov    %edx,0x4(%eax)
}
  8007ac:	90                   	nop
  8007ad:	c9                   	leave  
  8007ae:	c3                   	ret    

008007af <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8007af:	55                   	push   %ebp
  8007b0:	89 e5                	mov    %esp,%ebp
  8007b2:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8007b8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8007bf:	00 00 00 
	b.cnt = 0;
  8007c2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8007c9:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8007cc:	ff 75 0c             	pushl  0xc(%ebp)
  8007cf:	ff 75 08             	pushl  0x8(%ebp)
  8007d2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007d8:	50                   	push   %eax
  8007d9:	68 46 07 80 00       	push   $0x800746
  8007de:	e8 11 02 00 00       	call   8009f4 <vprintfmt>
  8007e3:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8007e6:	a0 44 50 98 00       	mov    0x985044,%al
  8007eb:	0f b6 c0             	movzbl %al,%eax
  8007ee:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8007f4:	83 ec 04             	sub    $0x4,%esp
  8007f7:	50                   	push   %eax
  8007f8:	52                   	push   %edx
  8007f9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007ff:	83 c0 08             	add    $0x8,%eax
  800802:	50                   	push   %eax
  800803:	e8 a2 14 00 00       	call   801caa <sys_cputs>
  800808:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80080b:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
	return b.cnt;
  800812:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800818:	c9                   	leave  
  800819:	c3                   	ret    

0080081a <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80081a:	55                   	push   %ebp
  80081b:	89 e5                	mov    %esp,%ebp
  80081d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800820:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
	va_start(ap, fmt);
  800827:	8d 45 0c             	lea    0xc(%ebp),%eax
  80082a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80082d:	8b 45 08             	mov    0x8(%ebp),%eax
  800830:	83 ec 08             	sub    $0x8,%esp
  800833:	ff 75 f4             	pushl  -0xc(%ebp)
  800836:	50                   	push   %eax
  800837:	e8 73 ff ff ff       	call   8007af <vcprintf>
  80083c:	83 c4 10             	add    $0x10,%esp
  80083f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800842:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800845:	c9                   	leave  
  800846:	c3                   	ret    

00800847 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800847:	55                   	push   %ebp
  800848:	89 e5                	mov    %esp,%ebp
  80084a:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80084d:	e8 9a 14 00 00       	call   801cec <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800852:	8d 45 0c             	lea    0xc(%ebp),%eax
  800855:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800858:	8b 45 08             	mov    0x8(%ebp),%eax
  80085b:	83 ec 08             	sub    $0x8,%esp
  80085e:	ff 75 f4             	pushl  -0xc(%ebp)
  800861:	50                   	push   %eax
  800862:	e8 48 ff ff ff       	call   8007af <vcprintf>
  800867:	83 c4 10             	add    $0x10,%esp
  80086a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80086d:	e8 94 14 00 00       	call   801d06 <sys_unlock_cons>
	return cnt;
  800872:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800875:	c9                   	leave  
  800876:	c3                   	ret    

00800877 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800877:	55                   	push   %ebp
  800878:	89 e5                	mov    %esp,%ebp
  80087a:	53                   	push   %ebx
  80087b:	83 ec 14             	sub    $0x14,%esp
  80087e:	8b 45 10             	mov    0x10(%ebp),%eax
  800881:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800884:	8b 45 14             	mov    0x14(%ebp),%eax
  800887:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80088a:	8b 45 18             	mov    0x18(%ebp),%eax
  80088d:	ba 00 00 00 00       	mov    $0x0,%edx
  800892:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800895:	77 55                	ja     8008ec <printnum+0x75>
  800897:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80089a:	72 05                	jb     8008a1 <printnum+0x2a>
  80089c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80089f:	77 4b                	ja     8008ec <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8008a1:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8008a4:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8008a7:	8b 45 18             	mov    0x18(%ebp),%eax
  8008aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8008af:	52                   	push   %edx
  8008b0:	50                   	push   %eax
  8008b1:	ff 75 f4             	pushl  -0xc(%ebp)
  8008b4:	ff 75 f0             	pushl  -0x10(%ebp)
  8008b7:	e8 a4 2d 00 00       	call   803660 <__udivdi3>
  8008bc:	83 c4 10             	add    $0x10,%esp
  8008bf:	83 ec 04             	sub    $0x4,%esp
  8008c2:	ff 75 20             	pushl  0x20(%ebp)
  8008c5:	53                   	push   %ebx
  8008c6:	ff 75 18             	pushl  0x18(%ebp)
  8008c9:	52                   	push   %edx
  8008ca:	50                   	push   %eax
  8008cb:	ff 75 0c             	pushl  0xc(%ebp)
  8008ce:	ff 75 08             	pushl  0x8(%ebp)
  8008d1:	e8 a1 ff ff ff       	call   800877 <printnum>
  8008d6:	83 c4 20             	add    $0x20,%esp
  8008d9:	eb 1a                	jmp    8008f5 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8008db:	83 ec 08             	sub    $0x8,%esp
  8008de:	ff 75 0c             	pushl  0xc(%ebp)
  8008e1:	ff 75 20             	pushl  0x20(%ebp)
  8008e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e7:	ff d0                	call   *%eax
  8008e9:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008ec:	ff 4d 1c             	decl   0x1c(%ebp)
  8008ef:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8008f3:	7f e6                	jg     8008db <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008f5:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8008f8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800900:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800903:	53                   	push   %ebx
  800904:	51                   	push   %ecx
  800905:	52                   	push   %edx
  800906:	50                   	push   %eax
  800907:	e8 64 2e 00 00       	call   803770 <__umoddi3>
  80090c:	83 c4 10             	add    $0x10,%esp
  80090f:	05 74 41 80 00       	add    $0x804174,%eax
  800914:	8a 00                	mov    (%eax),%al
  800916:	0f be c0             	movsbl %al,%eax
  800919:	83 ec 08             	sub    $0x8,%esp
  80091c:	ff 75 0c             	pushl  0xc(%ebp)
  80091f:	50                   	push   %eax
  800920:	8b 45 08             	mov    0x8(%ebp),%eax
  800923:	ff d0                	call   *%eax
  800925:	83 c4 10             	add    $0x10,%esp
}
  800928:	90                   	nop
  800929:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80092c:	c9                   	leave  
  80092d:	c3                   	ret    

0080092e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80092e:	55                   	push   %ebp
  80092f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800931:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800935:	7e 1c                	jle    800953 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800937:	8b 45 08             	mov    0x8(%ebp),%eax
  80093a:	8b 00                	mov    (%eax),%eax
  80093c:	8d 50 08             	lea    0x8(%eax),%edx
  80093f:	8b 45 08             	mov    0x8(%ebp),%eax
  800942:	89 10                	mov    %edx,(%eax)
  800944:	8b 45 08             	mov    0x8(%ebp),%eax
  800947:	8b 00                	mov    (%eax),%eax
  800949:	83 e8 08             	sub    $0x8,%eax
  80094c:	8b 50 04             	mov    0x4(%eax),%edx
  80094f:	8b 00                	mov    (%eax),%eax
  800951:	eb 40                	jmp    800993 <getuint+0x65>
	else if (lflag)
  800953:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800957:	74 1e                	je     800977 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800959:	8b 45 08             	mov    0x8(%ebp),%eax
  80095c:	8b 00                	mov    (%eax),%eax
  80095e:	8d 50 04             	lea    0x4(%eax),%edx
  800961:	8b 45 08             	mov    0x8(%ebp),%eax
  800964:	89 10                	mov    %edx,(%eax)
  800966:	8b 45 08             	mov    0x8(%ebp),%eax
  800969:	8b 00                	mov    (%eax),%eax
  80096b:	83 e8 04             	sub    $0x4,%eax
  80096e:	8b 00                	mov    (%eax),%eax
  800970:	ba 00 00 00 00       	mov    $0x0,%edx
  800975:	eb 1c                	jmp    800993 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800977:	8b 45 08             	mov    0x8(%ebp),%eax
  80097a:	8b 00                	mov    (%eax),%eax
  80097c:	8d 50 04             	lea    0x4(%eax),%edx
  80097f:	8b 45 08             	mov    0x8(%ebp),%eax
  800982:	89 10                	mov    %edx,(%eax)
  800984:	8b 45 08             	mov    0x8(%ebp),%eax
  800987:	8b 00                	mov    (%eax),%eax
  800989:	83 e8 04             	sub    $0x4,%eax
  80098c:	8b 00                	mov    (%eax),%eax
  80098e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800993:	5d                   	pop    %ebp
  800994:	c3                   	ret    

00800995 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800995:	55                   	push   %ebp
  800996:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800998:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80099c:	7e 1c                	jle    8009ba <getint+0x25>
		return va_arg(*ap, long long);
  80099e:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a1:	8b 00                	mov    (%eax),%eax
  8009a3:	8d 50 08             	lea    0x8(%eax),%edx
  8009a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a9:	89 10                	mov    %edx,(%eax)
  8009ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ae:	8b 00                	mov    (%eax),%eax
  8009b0:	83 e8 08             	sub    $0x8,%eax
  8009b3:	8b 50 04             	mov    0x4(%eax),%edx
  8009b6:	8b 00                	mov    (%eax),%eax
  8009b8:	eb 38                	jmp    8009f2 <getint+0x5d>
	else if (lflag)
  8009ba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009be:	74 1a                	je     8009da <getint+0x45>
		return va_arg(*ap, long);
  8009c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c3:	8b 00                	mov    (%eax),%eax
  8009c5:	8d 50 04             	lea    0x4(%eax),%edx
  8009c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cb:	89 10                	mov    %edx,(%eax)
  8009cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d0:	8b 00                	mov    (%eax),%eax
  8009d2:	83 e8 04             	sub    $0x4,%eax
  8009d5:	8b 00                	mov    (%eax),%eax
  8009d7:	99                   	cltd   
  8009d8:	eb 18                	jmp    8009f2 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8009da:	8b 45 08             	mov    0x8(%ebp),%eax
  8009dd:	8b 00                	mov    (%eax),%eax
  8009df:	8d 50 04             	lea    0x4(%eax),%edx
  8009e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e5:	89 10                	mov    %edx,(%eax)
  8009e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ea:	8b 00                	mov    (%eax),%eax
  8009ec:	83 e8 04             	sub    $0x4,%eax
  8009ef:	8b 00                	mov    (%eax),%eax
  8009f1:	99                   	cltd   
}
  8009f2:	5d                   	pop    %ebp
  8009f3:	c3                   	ret    

008009f4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009f4:	55                   	push   %ebp
  8009f5:	89 e5                	mov    %esp,%ebp
  8009f7:	56                   	push   %esi
  8009f8:	53                   	push   %ebx
  8009f9:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009fc:	eb 17                	jmp    800a15 <vprintfmt+0x21>
			if (ch == '\0')
  8009fe:	85 db                	test   %ebx,%ebx
  800a00:	0f 84 c1 03 00 00    	je     800dc7 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800a06:	83 ec 08             	sub    $0x8,%esp
  800a09:	ff 75 0c             	pushl  0xc(%ebp)
  800a0c:	53                   	push   %ebx
  800a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a10:	ff d0                	call   *%eax
  800a12:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a15:	8b 45 10             	mov    0x10(%ebp),%eax
  800a18:	8d 50 01             	lea    0x1(%eax),%edx
  800a1b:	89 55 10             	mov    %edx,0x10(%ebp)
  800a1e:	8a 00                	mov    (%eax),%al
  800a20:	0f b6 d8             	movzbl %al,%ebx
  800a23:	83 fb 25             	cmp    $0x25,%ebx
  800a26:	75 d6                	jne    8009fe <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a28:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800a2c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800a33:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a3a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a41:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a48:	8b 45 10             	mov    0x10(%ebp),%eax
  800a4b:	8d 50 01             	lea    0x1(%eax),%edx
  800a4e:	89 55 10             	mov    %edx,0x10(%ebp)
  800a51:	8a 00                	mov    (%eax),%al
  800a53:	0f b6 d8             	movzbl %al,%ebx
  800a56:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a59:	83 f8 5b             	cmp    $0x5b,%eax
  800a5c:	0f 87 3d 03 00 00    	ja     800d9f <vprintfmt+0x3ab>
  800a62:	8b 04 85 98 41 80 00 	mov    0x804198(,%eax,4),%eax
  800a69:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a6b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a6f:	eb d7                	jmp    800a48 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a71:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a75:	eb d1                	jmp    800a48 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a77:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a7e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a81:	89 d0                	mov    %edx,%eax
  800a83:	c1 e0 02             	shl    $0x2,%eax
  800a86:	01 d0                	add    %edx,%eax
  800a88:	01 c0                	add    %eax,%eax
  800a8a:	01 d8                	add    %ebx,%eax
  800a8c:	83 e8 30             	sub    $0x30,%eax
  800a8f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a92:	8b 45 10             	mov    0x10(%ebp),%eax
  800a95:	8a 00                	mov    (%eax),%al
  800a97:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a9a:	83 fb 2f             	cmp    $0x2f,%ebx
  800a9d:	7e 3e                	jle    800add <vprintfmt+0xe9>
  800a9f:	83 fb 39             	cmp    $0x39,%ebx
  800aa2:	7f 39                	jg     800add <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800aa4:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800aa7:	eb d5                	jmp    800a7e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800aa9:	8b 45 14             	mov    0x14(%ebp),%eax
  800aac:	83 c0 04             	add    $0x4,%eax
  800aaf:	89 45 14             	mov    %eax,0x14(%ebp)
  800ab2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab5:	83 e8 04             	sub    $0x4,%eax
  800ab8:	8b 00                	mov    (%eax),%eax
  800aba:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800abd:	eb 1f                	jmp    800ade <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800abf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ac3:	79 83                	jns    800a48 <vprintfmt+0x54>
				width = 0;
  800ac5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800acc:	e9 77 ff ff ff       	jmp    800a48 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800ad1:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800ad8:	e9 6b ff ff ff       	jmp    800a48 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800add:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800ade:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ae2:	0f 89 60 ff ff ff    	jns    800a48 <vprintfmt+0x54>
				width = precision, precision = -1;
  800ae8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800aeb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800aee:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800af5:	e9 4e ff ff ff       	jmp    800a48 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800afa:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800afd:	e9 46 ff ff ff       	jmp    800a48 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800b02:	8b 45 14             	mov    0x14(%ebp),%eax
  800b05:	83 c0 04             	add    $0x4,%eax
  800b08:	89 45 14             	mov    %eax,0x14(%ebp)
  800b0b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0e:	83 e8 04             	sub    $0x4,%eax
  800b11:	8b 00                	mov    (%eax),%eax
  800b13:	83 ec 08             	sub    $0x8,%esp
  800b16:	ff 75 0c             	pushl  0xc(%ebp)
  800b19:	50                   	push   %eax
  800b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1d:	ff d0                	call   *%eax
  800b1f:	83 c4 10             	add    $0x10,%esp
			break;
  800b22:	e9 9b 02 00 00       	jmp    800dc2 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b27:	8b 45 14             	mov    0x14(%ebp),%eax
  800b2a:	83 c0 04             	add    $0x4,%eax
  800b2d:	89 45 14             	mov    %eax,0x14(%ebp)
  800b30:	8b 45 14             	mov    0x14(%ebp),%eax
  800b33:	83 e8 04             	sub    $0x4,%eax
  800b36:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b38:	85 db                	test   %ebx,%ebx
  800b3a:	79 02                	jns    800b3e <vprintfmt+0x14a>
				err = -err;
  800b3c:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b3e:	83 fb 64             	cmp    $0x64,%ebx
  800b41:	7f 0b                	jg     800b4e <vprintfmt+0x15a>
  800b43:	8b 34 9d e0 3f 80 00 	mov    0x803fe0(,%ebx,4),%esi
  800b4a:	85 f6                	test   %esi,%esi
  800b4c:	75 19                	jne    800b67 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b4e:	53                   	push   %ebx
  800b4f:	68 85 41 80 00       	push   $0x804185
  800b54:	ff 75 0c             	pushl  0xc(%ebp)
  800b57:	ff 75 08             	pushl  0x8(%ebp)
  800b5a:	e8 70 02 00 00       	call   800dcf <printfmt>
  800b5f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b62:	e9 5b 02 00 00       	jmp    800dc2 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b67:	56                   	push   %esi
  800b68:	68 8e 41 80 00       	push   $0x80418e
  800b6d:	ff 75 0c             	pushl  0xc(%ebp)
  800b70:	ff 75 08             	pushl  0x8(%ebp)
  800b73:	e8 57 02 00 00       	call   800dcf <printfmt>
  800b78:	83 c4 10             	add    $0x10,%esp
			break;
  800b7b:	e9 42 02 00 00       	jmp    800dc2 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b80:	8b 45 14             	mov    0x14(%ebp),%eax
  800b83:	83 c0 04             	add    $0x4,%eax
  800b86:	89 45 14             	mov    %eax,0x14(%ebp)
  800b89:	8b 45 14             	mov    0x14(%ebp),%eax
  800b8c:	83 e8 04             	sub    $0x4,%eax
  800b8f:	8b 30                	mov    (%eax),%esi
  800b91:	85 f6                	test   %esi,%esi
  800b93:	75 05                	jne    800b9a <vprintfmt+0x1a6>
				p = "(null)";
  800b95:	be 91 41 80 00       	mov    $0x804191,%esi
			if (width > 0 && padc != '-')
  800b9a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b9e:	7e 6d                	jle    800c0d <vprintfmt+0x219>
  800ba0:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ba4:	74 67                	je     800c0d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ba6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ba9:	83 ec 08             	sub    $0x8,%esp
  800bac:	50                   	push   %eax
  800bad:	56                   	push   %esi
  800bae:	e8 1e 03 00 00       	call   800ed1 <strnlen>
  800bb3:	83 c4 10             	add    $0x10,%esp
  800bb6:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800bb9:	eb 16                	jmp    800bd1 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800bbb:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800bbf:	83 ec 08             	sub    $0x8,%esp
  800bc2:	ff 75 0c             	pushl  0xc(%ebp)
  800bc5:	50                   	push   %eax
  800bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc9:	ff d0                	call   *%eax
  800bcb:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800bce:	ff 4d e4             	decl   -0x1c(%ebp)
  800bd1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bd5:	7f e4                	jg     800bbb <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bd7:	eb 34                	jmp    800c0d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800bd9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800bdd:	74 1c                	je     800bfb <vprintfmt+0x207>
  800bdf:	83 fb 1f             	cmp    $0x1f,%ebx
  800be2:	7e 05                	jle    800be9 <vprintfmt+0x1f5>
  800be4:	83 fb 7e             	cmp    $0x7e,%ebx
  800be7:	7e 12                	jle    800bfb <vprintfmt+0x207>
					putch('?', putdat);
  800be9:	83 ec 08             	sub    $0x8,%esp
  800bec:	ff 75 0c             	pushl  0xc(%ebp)
  800bef:	6a 3f                	push   $0x3f
  800bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf4:	ff d0                	call   *%eax
  800bf6:	83 c4 10             	add    $0x10,%esp
  800bf9:	eb 0f                	jmp    800c0a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800bfb:	83 ec 08             	sub    $0x8,%esp
  800bfe:	ff 75 0c             	pushl  0xc(%ebp)
  800c01:	53                   	push   %ebx
  800c02:	8b 45 08             	mov    0x8(%ebp),%eax
  800c05:	ff d0                	call   *%eax
  800c07:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c0a:	ff 4d e4             	decl   -0x1c(%ebp)
  800c0d:	89 f0                	mov    %esi,%eax
  800c0f:	8d 70 01             	lea    0x1(%eax),%esi
  800c12:	8a 00                	mov    (%eax),%al
  800c14:	0f be d8             	movsbl %al,%ebx
  800c17:	85 db                	test   %ebx,%ebx
  800c19:	74 24                	je     800c3f <vprintfmt+0x24b>
  800c1b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c1f:	78 b8                	js     800bd9 <vprintfmt+0x1e5>
  800c21:	ff 4d e0             	decl   -0x20(%ebp)
  800c24:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c28:	79 af                	jns    800bd9 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c2a:	eb 13                	jmp    800c3f <vprintfmt+0x24b>
				putch(' ', putdat);
  800c2c:	83 ec 08             	sub    $0x8,%esp
  800c2f:	ff 75 0c             	pushl  0xc(%ebp)
  800c32:	6a 20                	push   $0x20
  800c34:	8b 45 08             	mov    0x8(%ebp),%eax
  800c37:	ff d0                	call   *%eax
  800c39:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c3c:	ff 4d e4             	decl   -0x1c(%ebp)
  800c3f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c43:	7f e7                	jg     800c2c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800c45:	e9 78 01 00 00       	jmp    800dc2 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c4a:	83 ec 08             	sub    $0x8,%esp
  800c4d:	ff 75 e8             	pushl  -0x18(%ebp)
  800c50:	8d 45 14             	lea    0x14(%ebp),%eax
  800c53:	50                   	push   %eax
  800c54:	e8 3c fd ff ff       	call   800995 <getint>
  800c59:	83 c4 10             	add    $0x10,%esp
  800c5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c5f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c65:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c68:	85 d2                	test   %edx,%edx
  800c6a:	79 23                	jns    800c8f <vprintfmt+0x29b>
				putch('-', putdat);
  800c6c:	83 ec 08             	sub    $0x8,%esp
  800c6f:	ff 75 0c             	pushl  0xc(%ebp)
  800c72:	6a 2d                	push   $0x2d
  800c74:	8b 45 08             	mov    0x8(%ebp),%eax
  800c77:	ff d0                	call   *%eax
  800c79:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c82:	f7 d8                	neg    %eax
  800c84:	83 d2 00             	adc    $0x0,%edx
  800c87:	f7 da                	neg    %edx
  800c89:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c8c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c8f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c96:	e9 bc 00 00 00       	jmp    800d57 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c9b:	83 ec 08             	sub    $0x8,%esp
  800c9e:	ff 75 e8             	pushl  -0x18(%ebp)
  800ca1:	8d 45 14             	lea    0x14(%ebp),%eax
  800ca4:	50                   	push   %eax
  800ca5:	e8 84 fc ff ff       	call   80092e <getuint>
  800caa:	83 c4 10             	add    $0x10,%esp
  800cad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cb0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800cb3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800cba:	e9 98 00 00 00       	jmp    800d57 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800cbf:	83 ec 08             	sub    $0x8,%esp
  800cc2:	ff 75 0c             	pushl  0xc(%ebp)
  800cc5:	6a 58                	push   $0x58
  800cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cca:	ff d0                	call   *%eax
  800ccc:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ccf:	83 ec 08             	sub    $0x8,%esp
  800cd2:	ff 75 0c             	pushl  0xc(%ebp)
  800cd5:	6a 58                	push   $0x58
  800cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cda:	ff d0                	call   *%eax
  800cdc:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800cdf:	83 ec 08             	sub    $0x8,%esp
  800ce2:	ff 75 0c             	pushl  0xc(%ebp)
  800ce5:	6a 58                	push   $0x58
  800ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cea:	ff d0                	call   *%eax
  800cec:	83 c4 10             	add    $0x10,%esp
			break;
  800cef:	e9 ce 00 00 00       	jmp    800dc2 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800cf4:	83 ec 08             	sub    $0x8,%esp
  800cf7:	ff 75 0c             	pushl  0xc(%ebp)
  800cfa:	6a 30                	push   $0x30
  800cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cff:	ff d0                	call   *%eax
  800d01:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800d04:	83 ec 08             	sub    $0x8,%esp
  800d07:	ff 75 0c             	pushl  0xc(%ebp)
  800d0a:	6a 78                	push   $0x78
  800d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0f:	ff d0                	call   *%eax
  800d11:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800d14:	8b 45 14             	mov    0x14(%ebp),%eax
  800d17:	83 c0 04             	add    $0x4,%eax
  800d1a:	89 45 14             	mov    %eax,0x14(%ebp)
  800d1d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d20:	83 e8 04             	sub    $0x4,%eax
  800d23:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d25:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d28:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800d2f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800d36:	eb 1f                	jmp    800d57 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d38:	83 ec 08             	sub    $0x8,%esp
  800d3b:	ff 75 e8             	pushl  -0x18(%ebp)
  800d3e:	8d 45 14             	lea    0x14(%ebp),%eax
  800d41:	50                   	push   %eax
  800d42:	e8 e7 fb ff ff       	call   80092e <getuint>
  800d47:	83 c4 10             	add    $0x10,%esp
  800d4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d4d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d50:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d57:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d5e:	83 ec 04             	sub    $0x4,%esp
  800d61:	52                   	push   %edx
  800d62:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d65:	50                   	push   %eax
  800d66:	ff 75 f4             	pushl  -0xc(%ebp)
  800d69:	ff 75 f0             	pushl  -0x10(%ebp)
  800d6c:	ff 75 0c             	pushl  0xc(%ebp)
  800d6f:	ff 75 08             	pushl  0x8(%ebp)
  800d72:	e8 00 fb ff ff       	call   800877 <printnum>
  800d77:	83 c4 20             	add    $0x20,%esp
			break;
  800d7a:	eb 46                	jmp    800dc2 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d7c:	83 ec 08             	sub    $0x8,%esp
  800d7f:	ff 75 0c             	pushl  0xc(%ebp)
  800d82:	53                   	push   %ebx
  800d83:	8b 45 08             	mov    0x8(%ebp),%eax
  800d86:	ff d0                	call   *%eax
  800d88:	83 c4 10             	add    $0x10,%esp
			break;
  800d8b:	eb 35                	jmp    800dc2 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d8d:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
			break;
  800d94:	eb 2c                	jmp    800dc2 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d96:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
			break;
  800d9d:	eb 23                	jmp    800dc2 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d9f:	83 ec 08             	sub    $0x8,%esp
  800da2:	ff 75 0c             	pushl  0xc(%ebp)
  800da5:	6a 25                	push   $0x25
  800da7:	8b 45 08             	mov    0x8(%ebp),%eax
  800daa:	ff d0                	call   *%eax
  800dac:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800daf:	ff 4d 10             	decl   0x10(%ebp)
  800db2:	eb 03                	jmp    800db7 <vprintfmt+0x3c3>
  800db4:	ff 4d 10             	decl   0x10(%ebp)
  800db7:	8b 45 10             	mov    0x10(%ebp),%eax
  800dba:	48                   	dec    %eax
  800dbb:	8a 00                	mov    (%eax),%al
  800dbd:	3c 25                	cmp    $0x25,%al
  800dbf:	75 f3                	jne    800db4 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800dc1:	90                   	nop
		}
	}
  800dc2:	e9 35 fc ff ff       	jmp    8009fc <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800dc7:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800dc8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800dcb:	5b                   	pop    %ebx
  800dcc:	5e                   	pop    %esi
  800dcd:	5d                   	pop    %ebp
  800dce:	c3                   	ret    

00800dcf <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800dcf:	55                   	push   %ebp
  800dd0:	89 e5                	mov    %esp,%ebp
  800dd2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800dd5:	8d 45 10             	lea    0x10(%ebp),%eax
  800dd8:	83 c0 04             	add    $0x4,%eax
  800ddb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800dde:	8b 45 10             	mov    0x10(%ebp),%eax
  800de1:	ff 75 f4             	pushl  -0xc(%ebp)
  800de4:	50                   	push   %eax
  800de5:	ff 75 0c             	pushl  0xc(%ebp)
  800de8:	ff 75 08             	pushl  0x8(%ebp)
  800deb:	e8 04 fc ff ff       	call   8009f4 <vprintfmt>
  800df0:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800df3:	90                   	nop
  800df4:	c9                   	leave  
  800df5:	c3                   	ret    

00800df6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800df6:	55                   	push   %ebp
  800df7:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800df9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dfc:	8b 40 08             	mov    0x8(%eax),%eax
  800dff:	8d 50 01             	lea    0x1(%eax),%edx
  800e02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e05:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800e08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0b:	8b 10                	mov    (%eax),%edx
  800e0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e10:	8b 40 04             	mov    0x4(%eax),%eax
  800e13:	39 c2                	cmp    %eax,%edx
  800e15:	73 12                	jae    800e29 <sprintputch+0x33>
		*b->buf++ = ch;
  800e17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1a:	8b 00                	mov    (%eax),%eax
  800e1c:	8d 48 01             	lea    0x1(%eax),%ecx
  800e1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e22:	89 0a                	mov    %ecx,(%edx)
  800e24:	8b 55 08             	mov    0x8(%ebp),%edx
  800e27:	88 10                	mov    %dl,(%eax)
}
  800e29:	90                   	nop
  800e2a:	5d                   	pop    %ebp
  800e2b:	c3                   	ret    

00800e2c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e2c:	55                   	push   %ebp
  800e2d:	89 e5                	mov    %esp,%ebp
  800e2f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e32:	8b 45 08             	mov    0x8(%ebp),%eax
  800e35:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e41:	01 d0                	add    %edx,%eax
  800e43:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e46:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e4d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e51:	74 06                	je     800e59 <vsnprintf+0x2d>
  800e53:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e57:	7f 07                	jg     800e60 <vsnprintf+0x34>
		return -E_INVAL;
  800e59:	b8 03 00 00 00       	mov    $0x3,%eax
  800e5e:	eb 20                	jmp    800e80 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e60:	ff 75 14             	pushl  0x14(%ebp)
  800e63:	ff 75 10             	pushl  0x10(%ebp)
  800e66:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e69:	50                   	push   %eax
  800e6a:	68 f6 0d 80 00       	push   $0x800df6
  800e6f:	e8 80 fb ff ff       	call   8009f4 <vprintfmt>
  800e74:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e7a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e80:	c9                   	leave  
  800e81:	c3                   	ret    

00800e82 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e82:	55                   	push   %ebp
  800e83:	89 e5                	mov    %esp,%ebp
  800e85:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e88:	8d 45 10             	lea    0x10(%ebp),%eax
  800e8b:	83 c0 04             	add    $0x4,%eax
  800e8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e91:	8b 45 10             	mov    0x10(%ebp),%eax
  800e94:	ff 75 f4             	pushl  -0xc(%ebp)
  800e97:	50                   	push   %eax
  800e98:	ff 75 0c             	pushl  0xc(%ebp)
  800e9b:	ff 75 08             	pushl  0x8(%ebp)
  800e9e:	e8 89 ff ff ff       	call   800e2c <vsnprintf>
  800ea3:	83 c4 10             	add    $0x10,%esp
  800ea6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ea9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800eac:	c9                   	leave  
  800ead:	c3                   	ret    

00800eae <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800eae:	55                   	push   %ebp
  800eaf:	89 e5                	mov    %esp,%ebp
  800eb1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800eb4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ebb:	eb 06                	jmp    800ec3 <strlen+0x15>
		n++;
  800ebd:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ec0:	ff 45 08             	incl   0x8(%ebp)
  800ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec6:	8a 00                	mov    (%eax),%al
  800ec8:	84 c0                	test   %al,%al
  800eca:	75 f1                	jne    800ebd <strlen+0xf>
		n++;
	return n;
  800ecc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ecf:	c9                   	leave  
  800ed0:	c3                   	ret    

00800ed1 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ed1:	55                   	push   %ebp
  800ed2:	89 e5                	mov    %esp,%ebp
  800ed4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ed7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ede:	eb 09                	jmp    800ee9 <strnlen+0x18>
		n++;
  800ee0:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ee3:	ff 45 08             	incl   0x8(%ebp)
  800ee6:	ff 4d 0c             	decl   0xc(%ebp)
  800ee9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800eed:	74 09                	je     800ef8 <strnlen+0x27>
  800eef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef2:	8a 00                	mov    (%eax),%al
  800ef4:	84 c0                	test   %al,%al
  800ef6:	75 e8                	jne    800ee0 <strnlen+0xf>
		n++;
	return n;
  800ef8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800efb:	c9                   	leave  
  800efc:	c3                   	ret    

00800efd <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800efd:	55                   	push   %ebp
  800efe:	89 e5                	mov    %esp,%ebp
  800f00:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800f03:	8b 45 08             	mov    0x8(%ebp),%eax
  800f06:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800f09:	90                   	nop
  800f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0d:	8d 50 01             	lea    0x1(%eax),%edx
  800f10:	89 55 08             	mov    %edx,0x8(%ebp)
  800f13:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f16:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f19:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f1c:	8a 12                	mov    (%edx),%dl
  800f1e:	88 10                	mov    %dl,(%eax)
  800f20:	8a 00                	mov    (%eax),%al
  800f22:	84 c0                	test   %al,%al
  800f24:	75 e4                	jne    800f0a <strcpy+0xd>
		/* do nothing */;
	return ret;
  800f26:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f29:	c9                   	leave  
  800f2a:	c3                   	ret    

00800f2b <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800f2b:	55                   	push   %ebp
  800f2c:	89 e5                	mov    %esp,%ebp
  800f2e:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800f31:	8b 45 08             	mov    0x8(%ebp),%eax
  800f34:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800f37:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f3e:	eb 1f                	jmp    800f5f <strncpy+0x34>
		*dst++ = *src;
  800f40:	8b 45 08             	mov    0x8(%ebp),%eax
  800f43:	8d 50 01             	lea    0x1(%eax),%edx
  800f46:	89 55 08             	mov    %edx,0x8(%ebp)
  800f49:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f4c:	8a 12                	mov    (%edx),%dl
  800f4e:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f53:	8a 00                	mov    (%eax),%al
  800f55:	84 c0                	test   %al,%al
  800f57:	74 03                	je     800f5c <strncpy+0x31>
			src++;
  800f59:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f5c:	ff 45 fc             	incl   -0x4(%ebp)
  800f5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f62:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f65:	72 d9                	jb     800f40 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f67:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f6a:	c9                   	leave  
  800f6b:	c3                   	ret    

00800f6c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f6c:	55                   	push   %ebp
  800f6d:	89 e5                	mov    %esp,%ebp
  800f6f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f72:	8b 45 08             	mov    0x8(%ebp),%eax
  800f75:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f78:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f7c:	74 30                	je     800fae <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f7e:	eb 16                	jmp    800f96 <strlcpy+0x2a>
			*dst++ = *src++;
  800f80:	8b 45 08             	mov    0x8(%ebp),%eax
  800f83:	8d 50 01             	lea    0x1(%eax),%edx
  800f86:	89 55 08             	mov    %edx,0x8(%ebp)
  800f89:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f8c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f8f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f92:	8a 12                	mov    (%edx),%dl
  800f94:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f96:	ff 4d 10             	decl   0x10(%ebp)
  800f99:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f9d:	74 09                	je     800fa8 <strlcpy+0x3c>
  800f9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa2:	8a 00                	mov    (%eax),%al
  800fa4:	84 c0                	test   %al,%al
  800fa6:	75 d8                	jne    800f80 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fab:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800fae:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fb4:	29 c2                	sub    %eax,%edx
  800fb6:	89 d0                	mov    %edx,%eax
}
  800fb8:	c9                   	leave  
  800fb9:	c3                   	ret    

00800fba <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800fba:	55                   	push   %ebp
  800fbb:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800fbd:	eb 06                	jmp    800fc5 <strcmp+0xb>
		p++, q++;
  800fbf:	ff 45 08             	incl   0x8(%ebp)
  800fc2:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc8:	8a 00                	mov    (%eax),%al
  800fca:	84 c0                	test   %al,%al
  800fcc:	74 0e                	je     800fdc <strcmp+0x22>
  800fce:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd1:	8a 10                	mov    (%eax),%dl
  800fd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd6:	8a 00                	mov    (%eax),%al
  800fd8:	38 c2                	cmp    %al,%dl
  800fda:	74 e3                	je     800fbf <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdf:	8a 00                	mov    (%eax),%al
  800fe1:	0f b6 d0             	movzbl %al,%edx
  800fe4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe7:	8a 00                	mov    (%eax),%al
  800fe9:	0f b6 c0             	movzbl %al,%eax
  800fec:	29 c2                	sub    %eax,%edx
  800fee:	89 d0                	mov    %edx,%eax
}
  800ff0:	5d                   	pop    %ebp
  800ff1:	c3                   	ret    

00800ff2 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800ff2:	55                   	push   %ebp
  800ff3:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800ff5:	eb 09                	jmp    801000 <strncmp+0xe>
		n--, p++, q++;
  800ff7:	ff 4d 10             	decl   0x10(%ebp)
  800ffa:	ff 45 08             	incl   0x8(%ebp)
  800ffd:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801000:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801004:	74 17                	je     80101d <strncmp+0x2b>
  801006:	8b 45 08             	mov    0x8(%ebp),%eax
  801009:	8a 00                	mov    (%eax),%al
  80100b:	84 c0                	test   %al,%al
  80100d:	74 0e                	je     80101d <strncmp+0x2b>
  80100f:	8b 45 08             	mov    0x8(%ebp),%eax
  801012:	8a 10                	mov    (%eax),%dl
  801014:	8b 45 0c             	mov    0xc(%ebp),%eax
  801017:	8a 00                	mov    (%eax),%al
  801019:	38 c2                	cmp    %al,%dl
  80101b:	74 da                	je     800ff7 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80101d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801021:	75 07                	jne    80102a <strncmp+0x38>
		return 0;
  801023:	b8 00 00 00 00       	mov    $0x0,%eax
  801028:	eb 14                	jmp    80103e <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80102a:	8b 45 08             	mov    0x8(%ebp),%eax
  80102d:	8a 00                	mov    (%eax),%al
  80102f:	0f b6 d0             	movzbl %al,%edx
  801032:	8b 45 0c             	mov    0xc(%ebp),%eax
  801035:	8a 00                	mov    (%eax),%al
  801037:	0f b6 c0             	movzbl %al,%eax
  80103a:	29 c2                	sub    %eax,%edx
  80103c:	89 d0                	mov    %edx,%eax
}
  80103e:	5d                   	pop    %ebp
  80103f:	c3                   	ret    

00801040 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801040:	55                   	push   %ebp
  801041:	89 e5                	mov    %esp,%ebp
  801043:	83 ec 04             	sub    $0x4,%esp
  801046:	8b 45 0c             	mov    0xc(%ebp),%eax
  801049:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80104c:	eb 12                	jmp    801060 <strchr+0x20>
		if (*s == c)
  80104e:	8b 45 08             	mov    0x8(%ebp),%eax
  801051:	8a 00                	mov    (%eax),%al
  801053:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801056:	75 05                	jne    80105d <strchr+0x1d>
			return (char *) s;
  801058:	8b 45 08             	mov    0x8(%ebp),%eax
  80105b:	eb 11                	jmp    80106e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80105d:	ff 45 08             	incl   0x8(%ebp)
  801060:	8b 45 08             	mov    0x8(%ebp),%eax
  801063:	8a 00                	mov    (%eax),%al
  801065:	84 c0                	test   %al,%al
  801067:	75 e5                	jne    80104e <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801069:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80106e:	c9                   	leave  
  80106f:	c3                   	ret    

00801070 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801070:	55                   	push   %ebp
  801071:	89 e5                	mov    %esp,%ebp
  801073:	83 ec 04             	sub    $0x4,%esp
  801076:	8b 45 0c             	mov    0xc(%ebp),%eax
  801079:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80107c:	eb 0d                	jmp    80108b <strfind+0x1b>
		if (*s == c)
  80107e:	8b 45 08             	mov    0x8(%ebp),%eax
  801081:	8a 00                	mov    (%eax),%al
  801083:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801086:	74 0e                	je     801096 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801088:	ff 45 08             	incl   0x8(%ebp)
  80108b:	8b 45 08             	mov    0x8(%ebp),%eax
  80108e:	8a 00                	mov    (%eax),%al
  801090:	84 c0                	test   %al,%al
  801092:	75 ea                	jne    80107e <strfind+0xe>
  801094:	eb 01                	jmp    801097 <strfind+0x27>
		if (*s == c)
			break;
  801096:	90                   	nop
	return (char *) s;
  801097:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80109a:	c9                   	leave  
  80109b:	c3                   	ret    

0080109c <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80109c:	55                   	push   %ebp
  80109d:	89 e5                	mov    %esp,%ebp
  80109f:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8010a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8010a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ab:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8010ae:	eb 0e                	jmp    8010be <memset+0x22>
		*p++ = c;
  8010b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010b3:	8d 50 01             	lea    0x1(%eax),%edx
  8010b6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010bc:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8010be:	ff 4d f8             	decl   -0x8(%ebp)
  8010c1:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8010c5:	79 e9                	jns    8010b0 <memset+0x14>
		*p++ = c;

	return v;
  8010c7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010ca:	c9                   	leave  
  8010cb:	c3                   	ret    

008010cc <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010cc:	55                   	push   %ebp
  8010cd:	89 e5                	mov    %esp,%ebp
  8010cf:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010db:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8010de:	eb 16                	jmp    8010f6 <memcpy+0x2a>
		*d++ = *s++;
  8010e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e3:	8d 50 01             	lea    0x1(%eax),%edx
  8010e6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010e9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010ec:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010ef:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010f2:	8a 12                	mov    (%edx),%dl
  8010f4:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8010f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010fc:	89 55 10             	mov    %edx,0x10(%ebp)
  8010ff:	85 c0                	test   %eax,%eax
  801101:	75 dd                	jne    8010e0 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801103:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801106:	c9                   	leave  
  801107:	c3                   	ret    

00801108 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801108:	55                   	push   %ebp
  801109:	89 e5                	mov    %esp,%ebp
  80110b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80110e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801111:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801114:	8b 45 08             	mov    0x8(%ebp),%eax
  801117:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80111a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80111d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801120:	73 50                	jae    801172 <memmove+0x6a>
  801122:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801125:	8b 45 10             	mov    0x10(%ebp),%eax
  801128:	01 d0                	add    %edx,%eax
  80112a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80112d:	76 43                	jbe    801172 <memmove+0x6a>
		s += n;
  80112f:	8b 45 10             	mov    0x10(%ebp),%eax
  801132:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801135:	8b 45 10             	mov    0x10(%ebp),%eax
  801138:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80113b:	eb 10                	jmp    80114d <memmove+0x45>
			*--d = *--s;
  80113d:	ff 4d f8             	decl   -0x8(%ebp)
  801140:	ff 4d fc             	decl   -0x4(%ebp)
  801143:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801146:	8a 10                	mov    (%eax),%dl
  801148:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80114b:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80114d:	8b 45 10             	mov    0x10(%ebp),%eax
  801150:	8d 50 ff             	lea    -0x1(%eax),%edx
  801153:	89 55 10             	mov    %edx,0x10(%ebp)
  801156:	85 c0                	test   %eax,%eax
  801158:	75 e3                	jne    80113d <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80115a:	eb 23                	jmp    80117f <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80115c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80115f:	8d 50 01             	lea    0x1(%eax),%edx
  801162:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801165:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801168:	8d 4a 01             	lea    0x1(%edx),%ecx
  80116b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80116e:	8a 12                	mov    (%edx),%dl
  801170:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801172:	8b 45 10             	mov    0x10(%ebp),%eax
  801175:	8d 50 ff             	lea    -0x1(%eax),%edx
  801178:	89 55 10             	mov    %edx,0x10(%ebp)
  80117b:	85 c0                	test   %eax,%eax
  80117d:	75 dd                	jne    80115c <memmove+0x54>
			*d++ = *s++;

	return dst;
  80117f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801182:	c9                   	leave  
  801183:	c3                   	ret    

00801184 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801184:	55                   	push   %ebp
  801185:	89 e5                	mov    %esp,%ebp
  801187:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80118a:	8b 45 08             	mov    0x8(%ebp),%eax
  80118d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801190:	8b 45 0c             	mov    0xc(%ebp),%eax
  801193:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801196:	eb 2a                	jmp    8011c2 <memcmp+0x3e>
		if (*s1 != *s2)
  801198:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80119b:	8a 10                	mov    (%eax),%dl
  80119d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a0:	8a 00                	mov    (%eax),%al
  8011a2:	38 c2                	cmp    %al,%dl
  8011a4:	74 16                	je     8011bc <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011a9:	8a 00                	mov    (%eax),%al
  8011ab:	0f b6 d0             	movzbl %al,%edx
  8011ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011b1:	8a 00                	mov    (%eax),%al
  8011b3:	0f b6 c0             	movzbl %al,%eax
  8011b6:	29 c2                	sub    %eax,%edx
  8011b8:	89 d0                	mov    %edx,%eax
  8011ba:	eb 18                	jmp    8011d4 <memcmp+0x50>
		s1++, s2++;
  8011bc:	ff 45 fc             	incl   -0x4(%ebp)
  8011bf:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011c8:	89 55 10             	mov    %edx,0x10(%ebp)
  8011cb:	85 c0                	test   %eax,%eax
  8011cd:	75 c9                	jne    801198 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011d4:	c9                   	leave  
  8011d5:	c3                   	ret    

008011d6 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8011d6:	55                   	push   %ebp
  8011d7:	89 e5                	mov    %esp,%ebp
  8011d9:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8011dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8011df:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e2:	01 d0                	add    %edx,%eax
  8011e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8011e7:	eb 15                	jmp    8011fe <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8011e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ec:	8a 00                	mov    (%eax),%al
  8011ee:	0f b6 d0             	movzbl %al,%edx
  8011f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f4:	0f b6 c0             	movzbl %al,%eax
  8011f7:	39 c2                	cmp    %eax,%edx
  8011f9:	74 0d                	je     801208 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8011fb:	ff 45 08             	incl   0x8(%ebp)
  8011fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801201:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801204:	72 e3                	jb     8011e9 <memfind+0x13>
  801206:	eb 01                	jmp    801209 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801208:	90                   	nop
	return (void *) s;
  801209:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80120c:	c9                   	leave  
  80120d:	c3                   	ret    

0080120e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80120e:	55                   	push   %ebp
  80120f:	89 e5                	mov    %esp,%ebp
  801211:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801214:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80121b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801222:	eb 03                	jmp    801227 <strtol+0x19>
		s++;
  801224:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801227:	8b 45 08             	mov    0x8(%ebp),%eax
  80122a:	8a 00                	mov    (%eax),%al
  80122c:	3c 20                	cmp    $0x20,%al
  80122e:	74 f4                	je     801224 <strtol+0x16>
  801230:	8b 45 08             	mov    0x8(%ebp),%eax
  801233:	8a 00                	mov    (%eax),%al
  801235:	3c 09                	cmp    $0x9,%al
  801237:	74 eb                	je     801224 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801239:	8b 45 08             	mov    0x8(%ebp),%eax
  80123c:	8a 00                	mov    (%eax),%al
  80123e:	3c 2b                	cmp    $0x2b,%al
  801240:	75 05                	jne    801247 <strtol+0x39>
		s++;
  801242:	ff 45 08             	incl   0x8(%ebp)
  801245:	eb 13                	jmp    80125a <strtol+0x4c>
	else if (*s == '-')
  801247:	8b 45 08             	mov    0x8(%ebp),%eax
  80124a:	8a 00                	mov    (%eax),%al
  80124c:	3c 2d                	cmp    $0x2d,%al
  80124e:	75 0a                	jne    80125a <strtol+0x4c>
		s++, neg = 1;
  801250:	ff 45 08             	incl   0x8(%ebp)
  801253:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80125a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80125e:	74 06                	je     801266 <strtol+0x58>
  801260:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801264:	75 20                	jne    801286 <strtol+0x78>
  801266:	8b 45 08             	mov    0x8(%ebp),%eax
  801269:	8a 00                	mov    (%eax),%al
  80126b:	3c 30                	cmp    $0x30,%al
  80126d:	75 17                	jne    801286 <strtol+0x78>
  80126f:	8b 45 08             	mov    0x8(%ebp),%eax
  801272:	40                   	inc    %eax
  801273:	8a 00                	mov    (%eax),%al
  801275:	3c 78                	cmp    $0x78,%al
  801277:	75 0d                	jne    801286 <strtol+0x78>
		s += 2, base = 16;
  801279:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80127d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801284:	eb 28                	jmp    8012ae <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801286:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80128a:	75 15                	jne    8012a1 <strtol+0x93>
  80128c:	8b 45 08             	mov    0x8(%ebp),%eax
  80128f:	8a 00                	mov    (%eax),%al
  801291:	3c 30                	cmp    $0x30,%al
  801293:	75 0c                	jne    8012a1 <strtol+0x93>
		s++, base = 8;
  801295:	ff 45 08             	incl   0x8(%ebp)
  801298:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80129f:	eb 0d                	jmp    8012ae <strtol+0xa0>
	else if (base == 0)
  8012a1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012a5:	75 07                	jne    8012ae <strtol+0xa0>
		base = 10;
  8012a7:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b1:	8a 00                	mov    (%eax),%al
  8012b3:	3c 2f                	cmp    $0x2f,%al
  8012b5:	7e 19                	jle    8012d0 <strtol+0xc2>
  8012b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ba:	8a 00                	mov    (%eax),%al
  8012bc:	3c 39                	cmp    $0x39,%al
  8012be:	7f 10                	jg     8012d0 <strtol+0xc2>
			dig = *s - '0';
  8012c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c3:	8a 00                	mov    (%eax),%al
  8012c5:	0f be c0             	movsbl %al,%eax
  8012c8:	83 e8 30             	sub    $0x30,%eax
  8012cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012ce:	eb 42                	jmp    801312 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8012d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d3:	8a 00                	mov    (%eax),%al
  8012d5:	3c 60                	cmp    $0x60,%al
  8012d7:	7e 19                	jle    8012f2 <strtol+0xe4>
  8012d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dc:	8a 00                	mov    (%eax),%al
  8012de:	3c 7a                	cmp    $0x7a,%al
  8012e0:	7f 10                	jg     8012f2 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8012e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e5:	8a 00                	mov    (%eax),%al
  8012e7:	0f be c0             	movsbl %al,%eax
  8012ea:	83 e8 57             	sub    $0x57,%eax
  8012ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012f0:	eb 20                	jmp    801312 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8012f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f5:	8a 00                	mov    (%eax),%al
  8012f7:	3c 40                	cmp    $0x40,%al
  8012f9:	7e 39                	jle    801334 <strtol+0x126>
  8012fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fe:	8a 00                	mov    (%eax),%al
  801300:	3c 5a                	cmp    $0x5a,%al
  801302:	7f 30                	jg     801334 <strtol+0x126>
			dig = *s - 'A' + 10;
  801304:	8b 45 08             	mov    0x8(%ebp),%eax
  801307:	8a 00                	mov    (%eax),%al
  801309:	0f be c0             	movsbl %al,%eax
  80130c:	83 e8 37             	sub    $0x37,%eax
  80130f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801312:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801315:	3b 45 10             	cmp    0x10(%ebp),%eax
  801318:	7d 19                	jge    801333 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80131a:	ff 45 08             	incl   0x8(%ebp)
  80131d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801320:	0f af 45 10          	imul   0x10(%ebp),%eax
  801324:	89 c2                	mov    %eax,%edx
  801326:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801329:	01 d0                	add    %edx,%eax
  80132b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80132e:	e9 7b ff ff ff       	jmp    8012ae <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801333:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801334:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801338:	74 08                	je     801342 <strtol+0x134>
		*endptr = (char *) s;
  80133a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133d:	8b 55 08             	mov    0x8(%ebp),%edx
  801340:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801342:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801346:	74 07                	je     80134f <strtol+0x141>
  801348:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80134b:	f7 d8                	neg    %eax
  80134d:	eb 03                	jmp    801352 <strtol+0x144>
  80134f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801352:	c9                   	leave  
  801353:	c3                   	ret    

00801354 <ltostr>:

void
ltostr(long value, char *str)
{
  801354:	55                   	push   %ebp
  801355:	89 e5                	mov    %esp,%ebp
  801357:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80135a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801361:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801368:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80136c:	79 13                	jns    801381 <ltostr+0x2d>
	{
		neg = 1;
  80136e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801375:	8b 45 0c             	mov    0xc(%ebp),%eax
  801378:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80137b:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80137e:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801381:	8b 45 08             	mov    0x8(%ebp),%eax
  801384:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801389:	99                   	cltd   
  80138a:	f7 f9                	idiv   %ecx
  80138c:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80138f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801392:	8d 50 01             	lea    0x1(%eax),%edx
  801395:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801398:	89 c2                	mov    %eax,%edx
  80139a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139d:	01 d0                	add    %edx,%eax
  80139f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013a2:	83 c2 30             	add    $0x30,%edx
  8013a5:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013aa:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013af:	f7 e9                	imul   %ecx
  8013b1:	c1 fa 02             	sar    $0x2,%edx
  8013b4:	89 c8                	mov    %ecx,%eax
  8013b6:	c1 f8 1f             	sar    $0x1f,%eax
  8013b9:	29 c2                	sub    %eax,%edx
  8013bb:	89 d0                	mov    %edx,%eax
  8013bd:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8013c0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013c4:	75 bb                	jne    801381 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8013c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013d0:	48                   	dec    %eax
  8013d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8013d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013d8:	74 3d                	je     801417 <ltostr+0xc3>
		start = 1 ;
  8013da:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013e1:	eb 34                	jmp    801417 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8013e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e9:	01 d0                	add    %edx,%eax
  8013eb:	8a 00                	mov    (%eax),%al
  8013ed:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8013f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f6:	01 c2                	add    %eax,%edx
  8013f8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8013fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013fe:	01 c8                	add    %ecx,%eax
  801400:	8a 00                	mov    (%eax),%al
  801402:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801404:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801407:	8b 45 0c             	mov    0xc(%ebp),%eax
  80140a:	01 c2                	add    %eax,%edx
  80140c:	8a 45 eb             	mov    -0x15(%ebp),%al
  80140f:	88 02                	mov    %al,(%edx)
		start++ ;
  801411:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801414:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801417:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80141a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80141d:	7c c4                	jl     8013e3 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80141f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801422:	8b 45 0c             	mov    0xc(%ebp),%eax
  801425:	01 d0                	add    %edx,%eax
  801427:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80142a:	90                   	nop
  80142b:	c9                   	leave  
  80142c:	c3                   	ret    

0080142d <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80142d:	55                   	push   %ebp
  80142e:	89 e5                	mov    %esp,%ebp
  801430:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801433:	ff 75 08             	pushl  0x8(%ebp)
  801436:	e8 73 fa ff ff       	call   800eae <strlen>
  80143b:	83 c4 04             	add    $0x4,%esp
  80143e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801441:	ff 75 0c             	pushl  0xc(%ebp)
  801444:	e8 65 fa ff ff       	call   800eae <strlen>
  801449:	83 c4 04             	add    $0x4,%esp
  80144c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80144f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801456:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80145d:	eb 17                	jmp    801476 <strcconcat+0x49>
		final[s] = str1[s] ;
  80145f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801462:	8b 45 10             	mov    0x10(%ebp),%eax
  801465:	01 c2                	add    %eax,%edx
  801467:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80146a:	8b 45 08             	mov    0x8(%ebp),%eax
  80146d:	01 c8                	add    %ecx,%eax
  80146f:	8a 00                	mov    (%eax),%al
  801471:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801473:	ff 45 fc             	incl   -0x4(%ebp)
  801476:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801479:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80147c:	7c e1                	jl     80145f <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80147e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801485:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80148c:	eb 1f                	jmp    8014ad <strcconcat+0x80>
		final[s++] = str2[i] ;
  80148e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801491:	8d 50 01             	lea    0x1(%eax),%edx
  801494:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801497:	89 c2                	mov    %eax,%edx
  801499:	8b 45 10             	mov    0x10(%ebp),%eax
  80149c:	01 c2                	add    %eax,%edx
  80149e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a4:	01 c8                	add    %ecx,%eax
  8014a6:	8a 00                	mov    (%eax),%al
  8014a8:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8014aa:	ff 45 f8             	incl   -0x8(%ebp)
  8014ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014b0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014b3:	7c d9                	jl     80148e <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8014bb:	01 d0                	add    %edx,%eax
  8014bd:	c6 00 00             	movb   $0x0,(%eax)
}
  8014c0:	90                   	nop
  8014c1:	c9                   	leave  
  8014c2:	c3                   	ret    

008014c3 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014c3:	55                   	push   %ebp
  8014c4:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8014c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8014c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8014cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8014d2:	8b 00                	mov    (%eax),%eax
  8014d4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014db:	8b 45 10             	mov    0x10(%ebp),%eax
  8014de:	01 d0                	add    %edx,%eax
  8014e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014e6:	eb 0c                	jmp    8014f4 <strsplit+0x31>
			*string++ = 0;
  8014e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014eb:	8d 50 01             	lea    0x1(%eax),%edx
  8014ee:	89 55 08             	mov    %edx,0x8(%ebp)
  8014f1:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f7:	8a 00                	mov    (%eax),%al
  8014f9:	84 c0                	test   %al,%al
  8014fb:	74 18                	je     801515 <strsplit+0x52>
  8014fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801500:	8a 00                	mov    (%eax),%al
  801502:	0f be c0             	movsbl %al,%eax
  801505:	50                   	push   %eax
  801506:	ff 75 0c             	pushl  0xc(%ebp)
  801509:	e8 32 fb ff ff       	call   801040 <strchr>
  80150e:	83 c4 08             	add    $0x8,%esp
  801511:	85 c0                	test   %eax,%eax
  801513:	75 d3                	jne    8014e8 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801515:	8b 45 08             	mov    0x8(%ebp),%eax
  801518:	8a 00                	mov    (%eax),%al
  80151a:	84 c0                	test   %al,%al
  80151c:	74 5a                	je     801578 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80151e:	8b 45 14             	mov    0x14(%ebp),%eax
  801521:	8b 00                	mov    (%eax),%eax
  801523:	83 f8 0f             	cmp    $0xf,%eax
  801526:	75 07                	jne    80152f <strsplit+0x6c>
		{
			return 0;
  801528:	b8 00 00 00 00       	mov    $0x0,%eax
  80152d:	eb 66                	jmp    801595 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80152f:	8b 45 14             	mov    0x14(%ebp),%eax
  801532:	8b 00                	mov    (%eax),%eax
  801534:	8d 48 01             	lea    0x1(%eax),%ecx
  801537:	8b 55 14             	mov    0x14(%ebp),%edx
  80153a:	89 0a                	mov    %ecx,(%edx)
  80153c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801543:	8b 45 10             	mov    0x10(%ebp),%eax
  801546:	01 c2                	add    %eax,%edx
  801548:	8b 45 08             	mov    0x8(%ebp),%eax
  80154b:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80154d:	eb 03                	jmp    801552 <strsplit+0x8f>
			string++;
  80154f:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801552:	8b 45 08             	mov    0x8(%ebp),%eax
  801555:	8a 00                	mov    (%eax),%al
  801557:	84 c0                	test   %al,%al
  801559:	74 8b                	je     8014e6 <strsplit+0x23>
  80155b:	8b 45 08             	mov    0x8(%ebp),%eax
  80155e:	8a 00                	mov    (%eax),%al
  801560:	0f be c0             	movsbl %al,%eax
  801563:	50                   	push   %eax
  801564:	ff 75 0c             	pushl  0xc(%ebp)
  801567:	e8 d4 fa ff ff       	call   801040 <strchr>
  80156c:	83 c4 08             	add    $0x8,%esp
  80156f:	85 c0                	test   %eax,%eax
  801571:	74 dc                	je     80154f <strsplit+0x8c>
			string++;
	}
  801573:	e9 6e ff ff ff       	jmp    8014e6 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801578:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801579:	8b 45 14             	mov    0x14(%ebp),%eax
  80157c:	8b 00                	mov    (%eax),%eax
  80157e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801585:	8b 45 10             	mov    0x10(%ebp),%eax
  801588:	01 d0                	add    %edx,%eax
  80158a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801590:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801595:	c9                   	leave  
  801596:	c3                   	ret    

00801597 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801597:	55                   	push   %ebp
  801598:	89 e5                	mov    %esp,%ebp
  80159a:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  80159d:	83 ec 04             	sub    $0x4,%esp
  8015a0:	68 08 43 80 00       	push   $0x804308
  8015a5:	68 3f 01 00 00       	push   $0x13f
  8015aa:	68 2a 43 80 00       	push   $0x80432a
  8015af:	e8 a9 ef ff ff       	call   80055d <_panic>

008015b4 <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  8015b4:	55                   	push   %ebp
  8015b5:	89 e5                	mov    %esp,%ebp
  8015b7:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  8015ba:	83 ec 0c             	sub    $0xc,%esp
  8015bd:	ff 75 08             	pushl  0x8(%ebp)
  8015c0:	e8 90 0c 00 00       	call   802255 <sys_sbrk>
  8015c5:	83 c4 10             	add    $0x10,%esp
}
  8015c8:	c9                   	leave  
  8015c9:	c3                   	ret    

008015ca <malloc>:
#define num_of_page ((USER_HEAP_MAX - USER_HEAP_START) / PAGE_SIZE)

int pagesAllocated[num_of_page] = { 0 };
int shardIDs[num_of_page] = { 0 };
bool markedPages[num_of_page] = { 0 };
void* malloc(uint32 size) {
  8015ca:	55                   	push   %ebp
  8015cb:	89 e5                	mov    %esp,%ebp
  8015cd:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  8015d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015d4:	75 0a                	jne    8015e0 <malloc+0x16>
		return NULL;
  8015d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8015db:	e9 9e 01 00 00       	jmp    80177e <malloc+0x1b4>

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

	//  our new code
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  8015e0:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8015e7:	77 2c                	ja     801615 <malloc+0x4b>
		if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  8015e9:	e8 eb 0a 00 00       	call   8020d9 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015ee:	85 c0                	test   %eax,%eax
  8015f0:	74 19                	je     80160b <malloc+0x41>

			void * block = alloc_block_FF(size);
  8015f2:	83 ec 0c             	sub    $0xc,%esp
  8015f5:	ff 75 08             	pushl  0x8(%ebp)
  8015f8:	e8 85 11 00 00       	call   802782 <alloc_block_FF>
  8015fd:	83 c4 10             	add    $0x10,%esp
  801600:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			return block;
  801603:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801606:	e9 73 01 00 00       	jmp    80177e <malloc+0x1b4>
		} else {
			return NULL;
  80160b:	b8 00 00 00 00       	mov    $0x0,%eax
  801610:	e9 69 01 00 00       	jmp    80177e <malloc+0x1b4>
		}
	}

	uint32 numOfPages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801615:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80161c:	8b 55 08             	mov    0x8(%ebp),%edx
  80161f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801622:	01 d0                	add    %edx,%eax
  801624:	48                   	dec    %eax
  801625:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801628:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80162b:	ba 00 00 00 00       	mov    $0x0,%edx
  801630:	f7 75 e0             	divl   -0x20(%ebp)
  801633:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801636:	29 d0                	sub    %edx,%eax
  801638:	c1 e8 0c             	shr    $0xc,%eax
  80163b:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 freePagesCount = 0;
  80163e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801645:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  80164c:	a1 20 50 80 00       	mov    0x805020,%eax
  801651:	8b 40 7c             	mov    0x7c(%eax),%eax
  801654:	05 00 10 00 00       	add    $0x1000,%eax
  801659:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  80165c:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801661:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801664:	89 45 d0             	mov    %eax,-0x30(%ebp)

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  801667:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80166e:	8b 55 08             	mov    0x8(%ebp),%edx
  801671:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801674:	01 d0                	add    %edx,%eax
  801676:	48                   	dec    %eax
  801677:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80167a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80167d:	ba 00 00 00 00       	mov    $0x0,%edx
  801682:	f7 75 cc             	divl   -0x34(%ebp)
  801685:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801688:	29 d0                	sub    %edx,%eax
  80168a:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80168d:	76 0a                	jbe    801699 <malloc+0xcf>
		return NULL;
  80168f:	b8 00 00 00 00       	mov    $0x0,%eax
  801694:	e9 e5 00 00 00       	jmp    80177e <malloc+0x1b4>
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  801699:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80169c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80169f:	eb 48                	jmp    8016e9 <malloc+0x11f>
	{
		uint32 idx = (i - currentAddr) / PAGE_SIZE;
  8016a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016a4:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8016a7:	c1 e8 0c             	shr    $0xc,%eax
  8016aa:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if (!markedPages[idx]) {
  8016ad:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8016b0:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  8016b7:	85 c0                	test   %eax,%eax
  8016b9:	75 11                	jne    8016cc <malloc+0x102>
			freePagesCount++;
  8016bb:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  8016be:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8016c2:	75 16                	jne    8016da <malloc+0x110>
				start = i;
  8016c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016ca:	eb 0e                	jmp    8016da <malloc+0x110>
			}
		} else {
			freePagesCount = 0;
  8016cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  8016d3:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == numOfPages) {
  8016da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016dd:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8016e0:	74 12                	je     8016f4 <malloc+0x12a>

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  8016e2:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  8016e9:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  8016f0:	76 af                	jbe    8016a1 <malloc+0xd7>
  8016f2:	eb 01                	jmp    8016f5 <malloc+0x12b>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == numOfPages) {
			break;
  8016f4:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
  8016f5:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8016f9:	74 08                	je     801703 <malloc+0x139>
  8016fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016fe:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801701:	74 07                	je     80170a <malloc+0x140>
		return NULL;
  801703:	b8 00 00 00 00       	mov    $0x0,%eax
  801708:	eb 74                	jmp    80177e <malloc+0x1b4>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  80170a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80170d:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801710:	c1 e8 0c             	shr    $0xc,%eax
  801713:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numOfPages;
  801716:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801719:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80171c:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  801723:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801726:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801729:	eb 11                	jmp    80173c <malloc+0x172>
		markedPages[i] = 1;
  80172b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80172e:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  801735:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = numOfPages;
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  801739:	ff 45 e8             	incl   -0x18(%ebp)
  80173c:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80173f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801742:	01 d0                	add    %edx,%eax
  801744:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801747:	77 e2                	ja     80172b <malloc+0x161>
		markedPages[i] = 1;
	}

	sys_allocate_user_mem(start, ROUNDUP(size, PAGE_SIZE));
  801749:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801750:	8b 55 08             	mov    0x8(%ebp),%edx
  801753:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801756:	01 d0                	add    %edx,%eax
  801758:	48                   	dec    %eax
  801759:	89 45 b8             	mov    %eax,-0x48(%ebp)
  80175c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80175f:	ba 00 00 00 00       	mov    $0x0,%edx
  801764:	f7 75 bc             	divl   -0x44(%ebp)
  801767:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80176a:	29 d0                	sub    %edx,%eax
  80176c:	83 ec 08             	sub    $0x8,%esp
  80176f:	50                   	push   %eax
  801770:	ff 75 f0             	pushl  -0x10(%ebp)
  801773:	e8 14 0b 00 00       	call   80228c <sys_allocate_user_mem>
  801778:	83 c4 10             	add    $0x10,%esp
	return (void*) start;
  80177b:	8b 45 f0             	mov    -0x10(%ebp),%eax

}
  80177e:	c9                   	leave  
  80177f:	c3                   	ret    

00801780 <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address) {
  801780:	55                   	push   %ebp
  801781:	89 e5                	mov    %esp,%ebp
  801783:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
  801786:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80178a:	0f 84 ee 00 00 00    	je     80187e <free+0xfe>
		return;
	}

	if (virtual_address
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  801790:	a1 20 50 80 00       	mov    0x805020,%eax
  801795:	8b 40 74             	mov    0x74(%eax),%eax

	if (virtual_address == NULL) {
		return;
	}

	if (virtual_address
  801798:	3b 45 08             	cmp    0x8(%ebp),%eax
  80179b:	77 09                	ja     8017a6 <free+0x26>
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  80179d:	81 7d 08 00 00 00 a0 	cmpl   $0xa0000000,0x8(%ebp)
  8017a4:	76 14                	jbe    8017ba <free+0x3a>
		panic("INVALID VIRTUAL ADDRESS!!");
  8017a6:	83 ec 04             	sub    $0x4,%esp
  8017a9:	68 38 43 80 00       	push   $0x804338
  8017ae:	6a 68                	push   $0x68
  8017b0:	68 52 43 80 00       	push   $0x804352
  8017b5:	e8 a3 ed ff ff       	call   80055d <_panic>
	}
	if (virtual_address >= (void *) (myEnv->uheapStart)
  8017ba:	a1 20 50 80 00       	mov    0x805020,%eax
  8017bf:	8b 40 74             	mov    0x74(%eax),%eax
  8017c2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8017c5:	77 20                	ja     8017e7 <free+0x67>
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
  8017c7:	a1 20 50 80 00       	mov    0x805020,%eax
  8017cc:	8b 40 78             	mov    0x78(%eax),%eax
  8017cf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8017d2:	76 13                	jbe    8017e7 <free+0x67>
		free_block(virtual_address);
  8017d4:	83 ec 0c             	sub    $0xc,%esp
  8017d7:	ff 75 08             	pushl  0x8(%ebp)
  8017da:	e8 6c 16 00 00       	call   802e4b <free_block>
  8017df:	83 c4 10             	add    $0x10,%esp
		return;
  8017e2:	e9 98 00 00 00       	jmp    80187f <free+0xff>
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  8017e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8017ea:	a1 20 50 80 00       	mov    0x805020,%eax
  8017ef:	8b 40 7c             	mov    0x7c(%eax),%eax
  8017f2:	29 c2                	sub    %eax,%edx
  8017f4:	89 d0                	mov    %edx,%eax
  8017f6:	2d 00 10 00 00       	sub    $0x1000,%eax
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
		free_block(virtual_address);
		return;
	}

	uint32 pageIdx = ((uint32) virtual_address
  8017fb:	c1 e8 0c             	shr    $0xc,%eax
  8017fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  801801:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801808:	eb 16                	jmp    801820 <free+0xa0>
		markedPages[idx + pageIdx] = 0;
  80180a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80180d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801810:	01 d0                	add    %edx,%eax
  801812:	c7 04 85 40 50 90 00 	movl   $0x0,0x905040(,%eax,4)
  801819:	00 00 00 00 
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  80181d:	ff 45 f4             	incl   -0xc(%ebp)
  801820:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801823:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  80182a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80182d:	7f db                	jg     80180a <free+0x8a>
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;
  80182f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801832:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  801839:	c1 e0 0c             	shl    $0xc,%eax
  80183c:	89 45 e8             	mov    %eax,-0x18(%ebp)

	for (uint32 i = (uint32) virtual_address;
  80183f:	8b 45 08             	mov    0x8(%ebp),%eax
  801842:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801845:	eb 1a                	jmp    801861 <free+0xe1>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
  801847:	83 ec 08             	sub    $0x8,%esp
  80184a:	68 00 10 00 00       	push   $0x1000
  80184f:	ff 75 f0             	pushl  -0x10(%ebp)
  801852:	e8 19 0a 00 00       	call   802270 <sys_free_user_mem>
  801857:	83 c4 10             	add    $0x10,%esp
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
  80185a:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  801861:	8b 55 08             	mov    0x8(%ebp),%edx
  801864:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801867:	01 d0                	add    %edx,%eax
	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
  801869:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80186c:	77 d9                	ja     801847 <free+0xc7>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;
  80186e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801871:	c7 04 85 40 50 80 00 	movl   $0x0,0x805040(,%eax,4)
  801878:	00 00 00 00 
  80187c:	eb 01                	jmp    80187f <free+0xff>
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
		return;
  80187e:	90                   	nop
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;

}
  80187f:	c9                   	leave  
  801880:	c3                   	ret    

00801881 <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  801881:	55                   	push   %ebp
  801882:	89 e5                	mov    %esp,%ebp
  801884:	83 ec 58             	sub    $0x58,%esp
  801887:	8b 45 10             	mov    0x10(%ebp),%eax
  80188a:	88 45 b4             	mov    %al,-0x4c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  80188d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801891:	75 0a                	jne    80189d <smalloc+0x1c>
		return NULL;
  801893:	b8 00 00 00 00       	mov    $0x0,%eax
  801898:	e9 7d 01 00 00       	jmp    801a1a <smalloc+0x199>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	uint32 num_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  80189d:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  8018a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018aa:	01 d0                	add    %edx,%eax
  8018ac:	48                   	dec    %eax
  8018ad:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8018b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8018b8:	f7 75 e4             	divl   -0x1c(%ebp)
  8018bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018be:	29 d0                	sub    %edx,%eax
  8018c0:	c1 e8 0c             	shr    $0xc,%eax
  8018c3:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 freePagesCount = 0;
  8018c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  8018cd:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  8018d4:	a1 20 50 80 00       	mov    0x805020,%eax
  8018d9:	8b 40 7c             	mov    0x7c(%eax),%eax
  8018dc:	05 00 10 00 00       	add    $0x1000,%eax
  8018e1:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  8018e4:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8018e9:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8018ec:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  8018ef:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  8018f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8018fc:	01 d0                	add    %edx,%eax
  8018fe:	48                   	dec    %eax
  8018ff:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801902:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801905:	ba 00 00 00 00       	mov    $0x0,%edx
  80190a:	f7 75 d0             	divl   -0x30(%ebp)
  80190d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801910:	29 d0                	sub    %edx,%eax
  801912:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801915:	76 0a                	jbe    801921 <smalloc+0xa0>
		return NULL;
  801917:	b8 00 00 00 00       	mov    $0x0,%eax
  80191c:	e9 f9 00 00 00       	jmp    801a1a <smalloc+0x199>
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801921:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801924:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801927:	eb 48                	jmp    801971 <smalloc+0xf0>
		uint32 idx = (s - currentAddr) / PAGE_SIZE;
  801929:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80192c:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80192f:	c1 e8 0c             	shr    $0xc,%eax
  801932:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (!markedPages[idx]) {
  801935:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801938:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  80193f:	85 c0                	test   %eax,%eax
  801941:	75 11                	jne    801954 <smalloc+0xd3>
			freePagesCount++;
  801943:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801946:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80194a:	75 16                	jne    801962 <smalloc+0xe1>
				start = s;
  80194c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80194f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801952:	eb 0e                	jmp    801962 <smalloc+0xe1>
			}
		} else {
			freePagesCount = 0;
  801954:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  80195b:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == num_Of_Pages) {
  801962:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801965:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801968:	74 12                	je     80197c <smalloc+0xfb>
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  80196a:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801971:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801978:	76 af                	jbe    801929 <smalloc+0xa8>
  80197a:	eb 01                	jmp    80197d <smalloc+0xfc>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == num_Of_Pages) {
			break;
  80197c:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
  80197d:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801981:	74 08                	je     80198b <smalloc+0x10a>
  801983:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801986:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801989:	74 0a                	je     801995 <smalloc+0x114>
		return NULL;
  80198b:	b8 00 00 00 00       	mov    $0x0,%eax
  801990:	e9 85 00 00 00       	jmp    801a1a <smalloc+0x199>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  801995:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801998:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80199b:	c1 e8 0c             	shr    $0xc,%eax
  80199e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	pagesAllocated[startPage] = num_Of_Pages;
  8019a1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8019a4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8019a7:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  8019ae:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8019b1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8019b4:	eb 11                	jmp    8019c7 <smalloc+0x146>
		markedPages[s] = 1;
  8019b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019b9:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  8019c0:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = num_Of_Pages;
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  8019c4:	ff 45 e8             	incl   -0x18(%ebp)
  8019c7:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8019ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8019cd:	01 d0                	add    %edx,%eax
  8019cf:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8019d2:	77 e2                	ja     8019b6 <smalloc+0x135>
		markedPages[s] = 1;
	}
	int sharedobjID = sys_createSharedObject(sharedVarName, size, isWritable,
  8019d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019d7:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
  8019db:	52                   	push   %edx
  8019dc:	50                   	push   %eax
  8019dd:	ff 75 0c             	pushl  0xc(%ebp)
  8019e0:	ff 75 08             	pushl  0x8(%ebp)
  8019e3:	e8 8f 04 00 00       	call   801e77 <sys_createSharedObject>
  8019e8:	83 c4 10             	add    $0x10,%esp
  8019eb:	89 45 c0             	mov    %eax,-0x40(%ebp)
			(void*) start);

	if (sharedobjID >= 0) {
  8019ee:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  8019f2:	78 12                	js     801a06 <smalloc+0x185>
		shardIDs[startPage] = sharedobjID;
  8019f4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8019f7:	8b 55 c0             	mov    -0x40(%ebp),%edx
  8019fa:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  801a01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a04:	eb 14                	jmp    801a1a <smalloc+0x199>
	}
	free((void*) start);
  801a06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a09:	83 ec 0c             	sub    $0xc,%esp
  801a0c:	50                   	push   %eax
  801a0d:	e8 6e fd ff ff       	call   801780 <free>
  801a12:	83 c4 10             	add    $0x10,%esp
	return NULL;
  801a15:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a1a:	c9                   	leave  
  801a1b:	c3                   	ret    

00801a1c <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  801a1c:	55                   	push   %ebp
  801a1d:	89 e5                	mov    %esp,%ebp
  801a1f:	83 ec 48             	sub    $0x48,%esp
	//cprintf("SSSSSGEEETTT\n");
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID, sharedVarName);
  801a22:	83 ec 08             	sub    $0x8,%esp
  801a25:	ff 75 0c             	pushl  0xc(%ebp)
  801a28:	ff 75 08             	pushl  0x8(%ebp)
  801a2b:	e8 71 04 00 00       	call   801ea1 <sys_getSizeOfSharedObject>
  801a30:	83 c4 10             	add    $0x10,%esp
  801a33:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (size < 0)
		return NULL;
	uint32 numb_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801a36:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801a3d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a40:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a43:	01 d0                	add    %edx,%eax
  801a45:	48                   	dec    %eax
  801a46:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801a49:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a4c:	ba 00 00 00 00       	mov    $0x0,%edx
  801a51:	f7 75 e0             	divl   -0x20(%ebp)
  801a54:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a57:	29 d0                	sub    %edx,%eax
  801a59:	c1 e8 0c             	shr    $0xc,%eax
  801a5c:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 free_Pages_Count = 0;
  801a5f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801a66:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
  801a6d:	a1 20 50 80 00       	mov    0x805020,%eax
  801a72:	8b 40 7c             	mov    0x7c(%eax),%eax
  801a75:	05 00 10 00 00       	add    $0x1000,%eax
  801a7a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
  801a7d:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801a82:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801a85:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
  801a88:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  801a8f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a92:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801a95:	01 d0                	add    %edx,%eax
  801a97:	48                   	dec    %eax
  801a98:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801a9b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801a9e:	ba 00 00 00 00       	mov    $0x0,%edx
  801aa3:	f7 75 cc             	divl   -0x34(%ebp)
  801aa6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801aa9:	29 d0                	sub    %edx,%eax
  801aab:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801aae:	76 0a                	jbe    801aba <sget+0x9e>
		return NULL;
  801ab0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ab5:	e9 f7 00 00 00       	jmp    801bb1 <sget+0x195>
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801aba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801abd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ac0:	eb 48                	jmp    801b0a <sget+0xee>
		uint32 idx = (s - current_Addr) / PAGE_SIZE;
  801ac2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ac5:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801ac8:	c1 e8 0c             	shr    $0xc,%eax
  801acb:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if (!markedPages[idx]) {
  801ace:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801ad1:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  801ad8:	85 c0                	test   %eax,%eax
  801ada:	75 11                	jne    801aed <sget+0xd1>
			free_Pages_Count++;
  801adc:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801adf:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801ae3:	75 16                	jne    801afb <sget+0xdf>
				start = s;
  801ae5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ae8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801aeb:	eb 0e                	jmp    801afb <sget+0xdf>
			}
		} else {
			free_Pages_Count = 0;
  801aed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  801af4:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (free_Pages_Count == numb_Of_Pages) {
  801afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801afe:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801b01:	74 12                	je     801b15 <sget+0xf9>
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
		return NULL;
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801b03:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801b0a:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801b11:	76 af                	jbe    801ac2 <sget+0xa6>
  801b13:	eb 01                	jmp    801b16 <sget+0xfa>
		} else {
			free_Pages_Count = 0;
			start = (uint32) -1;
		}
		if (free_Pages_Count == numb_Of_Pages) {
			break;
  801b15:	90                   	nop
		}
	}
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
  801b16:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801b1a:	74 08                	je     801b24 <sget+0x108>
  801b1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b1f:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801b22:	74 0a                	je     801b2e <sget+0x112>
		return NULL;
  801b24:	b8 00 00 00 00       	mov    $0x0,%eax
  801b29:	e9 83 00 00 00       	jmp    801bb1 <sget+0x195>
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
  801b2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b31:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801b34:	c1 e8 0c             	shr    $0xc,%eax
  801b37:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numb_Of_Pages;
  801b3a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801b3d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801b40:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  801b47:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801b4a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801b4d:	eb 11                	jmp    801b60 <sget+0x144>
		markedPages[k] = 1;
  801b4f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b52:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  801b59:	01 00 00 00 
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
	pagesAllocated[startPage] = numb_Of_Pages;
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  801b5d:	ff 45 e8             	incl   -0x18(%ebp)
  801b60:	8b 55 c0             	mov    -0x40(%ebp),%edx
  801b63:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b66:	01 d0                	add    %edx,%eax
  801b68:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801b6b:	77 e2                	ja     801b4f <sget+0x133>
		markedPages[k] = 1;
	}
	int ss = sys_getSharedObject(ownerEnvID, sharedVarName, (void*) start);
  801b6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b70:	83 ec 04             	sub    $0x4,%esp
  801b73:	50                   	push   %eax
  801b74:	ff 75 0c             	pushl  0xc(%ebp)
  801b77:	ff 75 08             	pushl  0x8(%ebp)
  801b7a:	e8 3f 03 00 00       	call   801ebe <sys_getSharedObject>
  801b7f:	83 c4 10             	add    $0x10,%esp
  801b82:	89 45 bc             	mov    %eax,-0x44(%ebp)
	if (ss >= 0) {
  801b85:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  801b89:	78 12                	js     801b9d <sget+0x181>
		shardIDs[startPage] = ss;
  801b8b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801b8e:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801b91:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  801b98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b9b:	eb 14                	jmp    801bb1 <sget+0x195>
	}
	free((void*) start);
  801b9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ba0:	83 ec 0c             	sub    $0xc,%esp
  801ba3:	50                   	push   %eax
  801ba4:	e8 d7 fb ff ff       	call   801780 <free>
  801ba9:	83 c4 10             	add    $0x10,%esp
	return NULL;
  801bac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bb1:	c9                   	leave  
  801bb2:	c3                   	ret    

00801bb3 <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  801bb3:	55                   	push   %ebp
  801bb4:	89 e5                	mov    %esp,%ebp
  801bb6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  801bb9:	8b 55 08             	mov    0x8(%ebp),%edx
  801bbc:	a1 20 50 80 00       	mov    0x805020,%eax
  801bc1:	8b 40 7c             	mov    0x7c(%eax),%eax
  801bc4:	29 c2                	sub    %eax,%edx
  801bc6:	89 d0                	mov    %edx,%eax
  801bc8:	2d 00 10 00 00       	sub    $0x1000,%eax

void sfree(void* virtual_address) {
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
  801bcd:	c1 e8 0c             	shr    $0xc,%eax
  801bd0:	89 45 f4             	mov    %eax,-0xc(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
	int id = shardIDs[pageIdx];
  801bd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bd6:	8b 04 85 40 50 88 00 	mov    0x885040(,%eax,4),%eax
  801bdd:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int result = sys_freeSharedObject(id, virtual_address);
  801be0:	83 ec 08             	sub    $0x8,%esp
  801be3:	ff 75 08             	pushl  0x8(%ebp)
  801be6:	ff 75 f0             	pushl  -0x10(%ebp)
  801be9:	e8 ef 02 00 00       	call   801edd <sys_freeSharedObject>
  801bee:	83 c4 10             	add    $0x10,%esp
  801bf1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (result == 0) {
  801bf4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801bf8:	75 0e                	jne    801c08 <sfree+0x55>
		shardIDs[pageIdx] = -1;  // Reset the ID after freeing
  801bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bfd:	c7 04 85 40 50 88 00 	movl   $0xffffffff,0x885040(,%eax,4)
  801c04:	ff ff ff ff 
	}

}
  801c08:	90                   	nop
  801c09:	c9                   	leave  
  801c0a:	c3                   	ret    

00801c0b <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  801c0b:	55                   	push   %ebp
  801c0c:	89 e5                	mov    %esp,%ebp
  801c0e:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801c11:	83 ec 04             	sub    $0x4,%esp
  801c14:	68 60 43 80 00       	push   $0x804360
  801c19:	68 19 01 00 00       	push   $0x119
  801c1e:	68 52 43 80 00       	push   $0x804352
  801c23:	e8 35 e9 ff ff       	call   80055d <_panic>

00801c28 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  801c28:	55                   	push   %ebp
  801c29:	89 e5                	mov    %esp,%ebp
  801c2b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c2e:	83 ec 04             	sub    $0x4,%esp
  801c31:	68 86 43 80 00       	push   $0x804386
  801c36:	68 23 01 00 00       	push   $0x123
  801c3b:	68 52 43 80 00       	push   $0x804352
  801c40:	e8 18 e9 ff ff       	call   80055d <_panic>

00801c45 <shrink>:

}
void shrink(uint32 newSize) {
  801c45:	55                   	push   %ebp
  801c46:	89 e5                	mov    %esp,%ebp
  801c48:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c4b:	83 ec 04             	sub    $0x4,%esp
  801c4e:	68 86 43 80 00       	push   $0x804386
  801c53:	68 27 01 00 00       	push   $0x127
  801c58:	68 52 43 80 00       	push   $0x804352
  801c5d:	e8 fb e8 ff ff       	call   80055d <_panic>

00801c62 <freeHeap>:

}
void freeHeap(void* virtual_address) {
  801c62:	55                   	push   %ebp
  801c63:	89 e5                	mov    %esp,%ebp
  801c65:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c68:	83 ec 04             	sub    $0x4,%esp
  801c6b:	68 86 43 80 00       	push   $0x804386
  801c70:	68 2b 01 00 00       	push   $0x12b
  801c75:	68 52 43 80 00       	push   $0x804352
  801c7a:	e8 de e8 ff ff       	call   80055d <_panic>

00801c7f <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  801c7f:	55                   	push   %ebp
  801c80:	89 e5                	mov    %esp,%ebp
  801c82:	57                   	push   %edi
  801c83:	56                   	push   %esi
  801c84:	53                   	push   %ebx
  801c85:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801c88:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c8e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c91:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c94:	8b 7d 18             	mov    0x18(%ebp),%edi
  801c97:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801c9a:	cd 30                	int    $0x30
  801c9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  801c9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ca2:	83 c4 10             	add    $0x10,%esp
  801ca5:	5b                   	pop    %ebx
  801ca6:	5e                   	pop    %esi
  801ca7:	5f                   	pop    %edi
  801ca8:	5d                   	pop    %ebp
  801ca9:	c3                   	ret    

00801caa <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  801caa:	55                   	push   %ebp
  801cab:	89 e5                	mov    %esp,%ebp
  801cad:	83 ec 04             	sub    $0x4,%esp
  801cb0:	8b 45 10             	mov    0x10(%ebp),%eax
  801cb3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  801cb6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801cba:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	52                   	push   %edx
  801cc2:	ff 75 0c             	pushl  0xc(%ebp)
  801cc5:	50                   	push   %eax
  801cc6:	6a 00                	push   $0x0
  801cc8:	e8 b2 ff ff ff       	call   801c7f <syscall>
  801ccd:	83 c4 18             	add    $0x18,%esp
}
  801cd0:	90                   	nop
  801cd1:	c9                   	leave  
  801cd2:	c3                   	ret    

00801cd3 <sys_cgetc>:

int sys_cgetc(void) {
  801cd3:	55                   	push   %ebp
  801cd4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 02                	push   $0x2
  801ce2:	e8 98 ff ff ff       	call   801c7f <syscall>
  801ce7:	83 c4 18             	add    $0x18,%esp
}
  801cea:	c9                   	leave  
  801ceb:	c3                   	ret    

00801cec <sys_lock_cons>:

void sys_lock_cons(void) {
  801cec:	55                   	push   %ebp
  801ced:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 03                	push   $0x3
  801cfb:	e8 7f ff ff ff       	call   801c7f <syscall>
  801d00:	83 c4 18             	add    $0x18,%esp
}
  801d03:	90                   	nop
  801d04:	c9                   	leave  
  801d05:	c3                   	ret    

00801d06 <sys_unlock_cons>:
void sys_unlock_cons(void) {
  801d06:	55                   	push   %ebp
  801d07:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	6a 04                	push   $0x4
  801d15:	e8 65 ff ff ff       	call   801c7f <syscall>
  801d1a:	83 c4 18             	add    $0x18,%esp
}
  801d1d:	90                   	nop
  801d1e:	c9                   	leave  
  801d1f:	c3                   	ret    

00801d20 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  801d20:	55                   	push   %ebp
  801d21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  801d23:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d26:	8b 45 08             	mov    0x8(%ebp),%eax
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	52                   	push   %edx
  801d30:	50                   	push   %eax
  801d31:	6a 08                	push   $0x8
  801d33:	e8 47 ff ff ff       	call   801c7f <syscall>
  801d38:	83 c4 18             	add    $0x18,%esp
}
  801d3b:	c9                   	leave  
  801d3c:	c3                   	ret    

00801d3d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  801d3d:	55                   	push   %ebp
  801d3e:	89 e5                	mov    %esp,%ebp
  801d40:	56                   	push   %esi
  801d41:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  801d42:	8b 75 18             	mov    0x18(%ebp),%esi
  801d45:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d48:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d51:	56                   	push   %esi
  801d52:	53                   	push   %ebx
  801d53:	51                   	push   %ecx
  801d54:	52                   	push   %edx
  801d55:	50                   	push   %eax
  801d56:	6a 09                	push   $0x9
  801d58:	e8 22 ff ff ff       	call   801c7f <syscall>
  801d5d:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  801d60:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d63:	5b                   	pop    %ebx
  801d64:	5e                   	pop    %esi
  801d65:	5d                   	pop    %ebp
  801d66:	c3                   	ret    

00801d67 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  801d67:	55                   	push   %ebp
  801d68:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801d6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d70:	6a 00                	push   $0x0
  801d72:	6a 00                	push   $0x0
  801d74:	6a 00                	push   $0x0
  801d76:	52                   	push   %edx
  801d77:	50                   	push   %eax
  801d78:	6a 0a                	push   $0xa
  801d7a:	e8 00 ff ff ff       	call   801c7f <syscall>
  801d7f:	83 c4 18             	add    $0x18,%esp
}
  801d82:	c9                   	leave  
  801d83:	c3                   	ret    

00801d84 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  801d84:	55                   	push   %ebp
  801d85:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	ff 75 0c             	pushl  0xc(%ebp)
  801d90:	ff 75 08             	pushl  0x8(%ebp)
  801d93:	6a 0b                	push   $0xb
  801d95:	e8 e5 fe ff ff       	call   801c7f <syscall>
  801d9a:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  801d9d:	c9                   	leave  
  801d9e:	c3                   	ret    

00801d9f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  801d9f:	55                   	push   %ebp
  801da0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801da2:	6a 00                	push   $0x0
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	6a 00                	push   $0x0
  801daa:	6a 00                	push   $0x0
  801dac:	6a 0c                	push   $0xc
  801dae:	e8 cc fe ff ff       	call   801c7f <syscall>
  801db3:	83 c4 18             	add    $0x18,%esp
}
  801db6:	c9                   	leave  
  801db7:	c3                   	ret    

00801db8 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  801db8:	55                   	push   %ebp
  801db9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 0d                	push   $0xd
  801dc7:	e8 b3 fe ff ff       	call   801c7f <syscall>
  801dcc:	83 c4 18             	add    $0x18,%esp
}
  801dcf:	c9                   	leave  
  801dd0:	c3                   	ret    

00801dd1 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  801dd1:	55                   	push   %ebp
  801dd2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 0e                	push   $0xe
  801de0:	e8 9a fe ff ff       	call   801c7f <syscall>
  801de5:	83 c4 18             	add    $0x18,%esp
}
  801de8:	c9                   	leave  
  801de9:	c3                   	ret    

00801dea <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  801dea:	55                   	push   %ebp
  801deb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  801ded:	6a 00                	push   $0x0
  801def:	6a 00                	push   $0x0
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	6a 0f                	push   $0xf
  801df9:	e8 81 fe ff ff       	call   801c7f <syscall>
  801dfe:	83 c4 18             	add    $0x18,%esp
}
  801e01:	c9                   	leave  
  801e02:	c3                   	ret    

00801e03 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  801e03:	55                   	push   %ebp
  801e04:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  801e06:	6a 00                	push   $0x0
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 00                	push   $0x0
  801e0e:	ff 75 08             	pushl  0x8(%ebp)
  801e11:	6a 10                	push   $0x10
  801e13:	e8 67 fe ff ff       	call   801c7f <syscall>
  801e18:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  801e1b:	c9                   	leave  
  801e1c:	c3                   	ret    

00801e1d <sys_scarce_memory>:

void sys_scarce_memory() {
  801e1d:	55                   	push   %ebp
  801e1e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	6a 00                	push   $0x0
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 11                	push   $0x11
  801e2c:	e8 4e fe ff ff       	call   801c7f <syscall>
  801e31:	83 c4 18             	add    $0x18,%esp
}
  801e34:	90                   	nop
  801e35:	c9                   	leave  
  801e36:	c3                   	ret    

00801e37 <sys_cputc>:

void sys_cputc(const char c) {
  801e37:	55                   	push   %ebp
  801e38:	89 e5                	mov    %esp,%ebp
  801e3a:	83 ec 04             	sub    $0x4,%esp
  801e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e40:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801e43:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e47:	6a 00                	push   $0x0
  801e49:	6a 00                	push   $0x0
  801e4b:	6a 00                	push   $0x0
  801e4d:	6a 00                	push   $0x0
  801e4f:	50                   	push   %eax
  801e50:	6a 01                	push   $0x1
  801e52:	e8 28 fe ff ff       	call   801c7f <syscall>
  801e57:	83 c4 18             	add    $0x18,%esp
}
  801e5a:	90                   	nop
  801e5b:	c9                   	leave  
  801e5c:	c3                   	ret    

00801e5d <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  801e5d:	55                   	push   %ebp
  801e5e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  801e60:	6a 00                	push   $0x0
  801e62:	6a 00                	push   $0x0
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 14                	push   $0x14
  801e6c:	e8 0e fe ff ff       	call   801c7f <syscall>
  801e71:	83 c4 18             	add    $0x18,%esp
}
  801e74:	90                   	nop
  801e75:	c9                   	leave  
  801e76:	c3                   	ret    

00801e77 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  801e77:	55                   	push   %ebp
  801e78:	89 e5                	mov    %esp,%ebp
  801e7a:	83 ec 04             	sub    $0x4,%esp
  801e7d:	8b 45 10             	mov    0x10(%ebp),%eax
  801e80:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  801e83:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e86:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8d:	6a 00                	push   $0x0
  801e8f:	51                   	push   %ecx
  801e90:	52                   	push   %edx
  801e91:	ff 75 0c             	pushl  0xc(%ebp)
  801e94:	50                   	push   %eax
  801e95:	6a 15                	push   $0x15
  801e97:	e8 e3 fd ff ff       	call   801c7f <syscall>
  801e9c:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  801e9f:	c9                   	leave  
  801ea0:	c3                   	ret    

00801ea1 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  801ea1:	55                   	push   %ebp
  801ea2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  801ea4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 00                	push   $0x0
  801eae:	6a 00                	push   $0x0
  801eb0:	52                   	push   %edx
  801eb1:	50                   	push   %eax
  801eb2:	6a 16                	push   $0x16
  801eb4:	e8 c6 fd ff ff       	call   801c7f <syscall>
  801eb9:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  801ebc:	c9                   	leave  
  801ebd:	c3                   	ret    

00801ebe <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  801ebe:	55                   	push   %ebp
  801ebf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  801ec1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ec4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	51                   	push   %ecx
  801ecf:	52                   	push   %edx
  801ed0:	50                   	push   %eax
  801ed1:	6a 17                	push   $0x17
  801ed3:	e8 a7 fd ff ff       	call   801c7f <syscall>
  801ed8:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  801edb:	c9                   	leave  
  801edc:	c3                   	ret    

00801edd <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  801edd:	55                   	push   %ebp
  801ede:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  801ee0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee6:	6a 00                	push   $0x0
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 00                	push   $0x0
  801eec:	52                   	push   %edx
  801eed:	50                   	push   %eax
  801eee:	6a 18                	push   $0x18
  801ef0:	e8 8a fd ff ff       	call   801c7f <syscall>
  801ef5:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  801ef8:	c9                   	leave  
  801ef9:	c3                   	ret    

00801efa <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  801efa:	55                   	push   %ebp
  801efb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  801efd:	8b 45 08             	mov    0x8(%ebp),%eax
  801f00:	6a 00                	push   $0x0
  801f02:	ff 75 14             	pushl  0x14(%ebp)
  801f05:	ff 75 10             	pushl  0x10(%ebp)
  801f08:	ff 75 0c             	pushl  0xc(%ebp)
  801f0b:	50                   	push   %eax
  801f0c:	6a 19                	push   $0x19
  801f0e:	e8 6c fd ff ff       	call   801c7f <syscall>
  801f13:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  801f16:	c9                   	leave  
  801f17:	c3                   	ret    

00801f18 <sys_run_env>:

void sys_run_env(int32 envId) {
  801f18:	55                   	push   %ebp
  801f19:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  801f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1e:	6a 00                	push   $0x0
  801f20:	6a 00                	push   $0x0
  801f22:	6a 00                	push   $0x0
  801f24:	6a 00                	push   $0x0
  801f26:	50                   	push   %eax
  801f27:	6a 1a                	push   $0x1a
  801f29:	e8 51 fd ff ff       	call   801c7f <syscall>
  801f2e:	83 c4 18             	add    $0x18,%esp
}
  801f31:	90                   	nop
  801f32:	c9                   	leave  
  801f33:	c3                   	ret    

00801f34 <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  801f34:	55                   	push   %ebp
  801f35:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801f37:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3a:	6a 00                	push   $0x0
  801f3c:	6a 00                	push   $0x0
  801f3e:	6a 00                	push   $0x0
  801f40:	6a 00                	push   $0x0
  801f42:	50                   	push   %eax
  801f43:	6a 1b                	push   $0x1b
  801f45:	e8 35 fd ff ff       	call   801c7f <syscall>
  801f4a:	83 c4 18             	add    $0x18,%esp
}
  801f4d:	c9                   	leave  
  801f4e:	c3                   	ret    

00801f4f <sys_getenvid>:

int32 sys_getenvid(void) {
  801f4f:	55                   	push   %ebp
  801f50:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801f52:	6a 00                	push   $0x0
  801f54:	6a 00                	push   $0x0
  801f56:	6a 00                	push   $0x0
  801f58:	6a 00                	push   $0x0
  801f5a:	6a 00                	push   $0x0
  801f5c:	6a 05                	push   $0x5
  801f5e:	e8 1c fd ff ff       	call   801c7f <syscall>
  801f63:	83 c4 18             	add    $0x18,%esp
}
  801f66:	c9                   	leave  
  801f67:	c3                   	ret    

00801f68 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  801f68:	55                   	push   %ebp
  801f69:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801f6b:	6a 00                	push   $0x0
  801f6d:	6a 00                	push   $0x0
  801f6f:	6a 00                	push   $0x0
  801f71:	6a 00                	push   $0x0
  801f73:	6a 00                	push   $0x0
  801f75:	6a 06                	push   $0x6
  801f77:	e8 03 fd ff ff       	call   801c7f <syscall>
  801f7c:	83 c4 18             	add    $0x18,%esp
}
  801f7f:	c9                   	leave  
  801f80:	c3                   	ret    

00801f81 <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  801f81:	55                   	push   %ebp
  801f82:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801f84:	6a 00                	push   $0x0
  801f86:	6a 00                	push   $0x0
  801f88:	6a 00                	push   $0x0
  801f8a:	6a 00                	push   $0x0
  801f8c:	6a 00                	push   $0x0
  801f8e:	6a 07                	push   $0x7
  801f90:	e8 ea fc ff ff       	call   801c7f <syscall>
  801f95:	83 c4 18             	add    $0x18,%esp
}
  801f98:	c9                   	leave  
  801f99:	c3                   	ret    

00801f9a <sys_exit_env>:

void sys_exit_env(void) {
  801f9a:	55                   	push   %ebp
  801f9b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801f9d:	6a 00                	push   $0x0
  801f9f:	6a 00                	push   $0x0
  801fa1:	6a 00                	push   $0x0
  801fa3:	6a 00                	push   $0x0
  801fa5:	6a 00                	push   $0x0
  801fa7:	6a 1c                	push   $0x1c
  801fa9:	e8 d1 fc ff ff       	call   801c7f <syscall>
  801fae:	83 c4 18             	add    $0x18,%esp
}
  801fb1:	90                   	nop
  801fb2:	c9                   	leave  
  801fb3:	c3                   	ret    

00801fb4 <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  801fb4:	55                   	push   %ebp
  801fb5:	89 e5                	mov    %esp,%ebp
  801fb7:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  801fba:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801fbd:	8d 50 04             	lea    0x4(%eax),%edx
  801fc0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801fc3:	6a 00                	push   $0x0
  801fc5:	6a 00                	push   $0x0
  801fc7:	6a 00                	push   $0x0
  801fc9:	52                   	push   %edx
  801fca:	50                   	push   %eax
  801fcb:	6a 1d                	push   $0x1d
  801fcd:	e8 ad fc ff ff       	call   801c7f <syscall>
  801fd2:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  801fd5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fd8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801fdb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801fde:	89 01                	mov    %eax,(%ecx)
  801fe0:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe6:	c9                   	leave  
  801fe7:	c2 04 00             	ret    $0x4

00801fea <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  801fea:	55                   	push   %ebp
  801feb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  801fed:	6a 00                	push   $0x0
  801fef:	6a 00                	push   $0x0
  801ff1:	ff 75 10             	pushl  0x10(%ebp)
  801ff4:	ff 75 0c             	pushl  0xc(%ebp)
  801ff7:	ff 75 08             	pushl  0x8(%ebp)
  801ffa:	6a 13                	push   $0x13
  801ffc:	e8 7e fc ff ff       	call   801c7f <syscall>
  802001:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  802004:	90                   	nop
}
  802005:	c9                   	leave  
  802006:	c3                   	ret    

00802007 <sys_rcr2>:
uint32 sys_rcr2() {
  802007:	55                   	push   %ebp
  802008:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80200a:	6a 00                	push   $0x0
  80200c:	6a 00                	push   $0x0
  80200e:	6a 00                	push   $0x0
  802010:	6a 00                	push   $0x0
  802012:	6a 00                	push   $0x0
  802014:	6a 1e                	push   $0x1e
  802016:	e8 64 fc ff ff       	call   801c7f <syscall>
  80201b:	83 c4 18             	add    $0x18,%esp
}
  80201e:	c9                   	leave  
  80201f:	c3                   	ret    

00802020 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  802020:	55                   	push   %ebp
  802021:	89 e5                	mov    %esp,%ebp
  802023:	83 ec 04             	sub    $0x4,%esp
  802026:	8b 45 08             	mov    0x8(%ebp),%eax
  802029:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80202c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802030:	6a 00                	push   $0x0
  802032:	6a 00                	push   $0x0
  802034:	6a 00                	push   $0x0
  802036:	6a 00                	push   $0x0
  802038:	50                   	push   %eax
  802039:	6a 1f                	push   $0x1f
  80203b:	e8 3f fc ff ff       	call   801c7f <syscall>
  802040:	83 c4 18             	add    $0x18,%esp
	return;
  802043:	90                   	nop
}
  802044:	c9                   	leave  
  802045:	c3                   	ret    

00802046 <rsttst>:
void rsttst() {
  802046:	55                   	push   %ebp
  802047:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802049:	6a 00                	push   $0x0
  80204b:	6a 00                	push   $0x0
  80204d:	6a 00                	push   $0x0
  80204f:	6a 00                	push   $0x0
  802051:	6a 00                	push   $0x0
  802053:	6a 21                	push   $0x21
  802055:	e8 25 fc ff ff       	call   801c7f <syscall>
  80205a:	83 c4 18             	add    $0x18,%esp
	return;
  80205d:	90                   	nop
}
  80205e:	c9                   	leave  
  80205f:	c3                   	ret    

00802060 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  802060:	55                   	push   %ebp
  802061:	89 e5                	mov    %esp,%ebp
  802063:	83 ec 04             	sub    $0x4,%esp
  802066:	8b 45 14             	mov    0x14(%ebp),%eax
  802069:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80206c:	8b 55 18             	mov    0x18(%ebp),%edx
  80206f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802073:	52                   	push   %edx
  802074:	50                   	push   %eax
  802075:	ff 75 10             	pushl  0x10(%ebp)
  802078:	ff 75 0c             	pushl  0xc(%ebp)
  80207b:	ff 75 08             	pushl  0x8(%ebp)
  80207e:	6a 20                	push   $0x20
  802080:	e8 fa fb ff ff       	call   801c7f <syscall>
  802085:	83 c4 18             	add    $0x18,%esp
	return;
  802088:	90                   	nop
}
  802089:	c9                   	leave  
  80208a:	c3                   	ret    

0080208b <chktst>:
void chktst(uint32 n) {
  80208b:	55                   	push   %ebp
  80208c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80208e:	6a 00                	push   $0x0
  802090:	6a 00                	push   $0x0
  802092:	6a 00                	push   $0x0
  802094:	6a 00                	push   $0x0
  802096:	ff 75 08             	pushl  0x8(%ebp)
  802099:	6a 22                	push   $0x22
  80209b:	e8 df fb ff ff       	call   801c7f <syscall>
  8020a0:	83 c4 18             	add    $0x18,%esp
	return;
  8020a3:	90                   	nop
}
  8020a4:	c9                   	leave  
  8020a5:	c3                   	ret    

008020a6 <inctst>:

void inctst() {
  8020a6:	55                   	push   %ebp
  8020a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8020a9:	6a 00                	push   $0x0
  8020ab:	6a 00                	push   $0x0
  8020ad:	6a 00                	push   $0x0
  8020af:	6a 00                	push   $0x0
  8020b1:	6a 00                	push   $0x0
  8020b3:	6a 23                	push   $0x23
  8020b5:	e8 c5 fb ff ff       	call   801c7f <syscall>
  8020ba:	83 c4 18             	add    $0x18,%esp
	return;
  8020bd:	90                   	nop
}
  8020be:	c9                   	leave  
  8020bf:	c3                   	ret    

008020c0 <gettst>:
uint32 gettst() {
  8020c0:	55                   	push   %ebp
  8020c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8020c3:	6a 00                	push   $0x0
  8020c5:	6a 00                	push   $0x0
  8020c7:	6a 00                	push   $0x0
  8020c9:	6a 00                	push   $0x0
  8020cb:	6a 00                	push   $0x0
  8020cd:	6a 24                	push   $0x24
  8020cf:	e8 ab fb ff ff       	call   801c7f <syscall>
  8020d4:	83 c4 18             	add    $0x18,%esp
}
  8020d7:	c9                   	leave  
  8020d8:	c3                   	ret    

008020d9 <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  8020d9:	55                   	push   %ebp
  8020da:	89 e5                	mov    %esp,%ebp
  8020dc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020df:	6a 00                	push   $0x0
  8020e1:	6a 00                	push   $0x0
  8020e3:	6a 00                	push   $0x0
  8020e5:	6a 00                	push   $0x0
  8020e7:	6a 00                	push   $0x0
  8020e9:	6a 25                	push   $0x25
  8020eb:	e8 8f fb ff ff       	call   801c7f <syscall>
  8020f0:	83 c4 18             	add    $0x18,%esp
  8020f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8020f6:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8020fa:	75 07                	jne    802103 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8020fc:	b8 01 00 00 00       	mov    $0x1,%eax
  802101:	eb 05                	jmp    802108 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802103:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802108:	c9                   	leave  
  802109:	c3                   	ret    

0080210a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  80210a:	55                   	push   %ebp
  80210b:	89 e5                	mov    %esp,%ebp
  80210d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802110:	6a 00                	push   $0x0
  802112:	6a 00                	push   $0x0
  802114:	6a 00                	push   $0x0
  802116:	6a 00                	push   $0x0
  802118:	6a 00                	push   $0x0
  80211a:	6a 25                	push   $0x25
  80211c:	e8 5e fb ff ff       	call   801c7f <syscall>
  802121:	83 c4 18             	add    $0x18,%esp
  802124:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802127:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80212b:	75 07                	jne    802134 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80212d:	b8 01 00 00 00       	mov    $0x1,%eax
  802132:	eb 05                	jmp    802139 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802134:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802139:	c9                   	leave  
  80213a:	c3                   	ret    

0080213b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  80213b:	55                   	push   %ebp
  80213c:	89 e5                	mov    %esp,%ebp
  80213e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802141:	6a 00                	push   $0x0
  802143:	6a 00                	push   $0x0
  802145:	6a 00                	push   $0x0
  802147:	6a 00                	push   $0x0
  802149:	6a 00                	push   $0x0
  80214b:	6a 25                	push   $0x25
  80214d:	e8 2d fb ff ff       	call   801c7f <syscall>
  802152:	83 c4 18             	add    $0x18,%esp
  802155:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802158:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80215c:	75 07                	jne    802165 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80215e:	b8 01 00 00 00       	mov    $0x1,%eax
  802163:	eb 05                	jmp    80216a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802165:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80216a:	c9                   	leave  
  80216b:	c3                   	ret    

0080216c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  80216c:	55                   	push   %ebp
  80216d:	89 e5                	mov    %esp,%ebp
  80216f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802172:	6a 00                	push   $0x0
  802174:	6a 00                	push   $0x0
  802176:	6a 00                	push   $0x0
  802178:	6a 00                	push   $0x0
  80217a:	6a 00                	push   $0x0
  80217c:	6a 25                	push   $0x25
  80217e:	e8 fc fa ff ff       	call   801c7f <syscall>
  802183:	83 c4 18             	add    $0x18,%esp
  802186:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802189:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80218d:	75 07                	jne    802196 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80218f:	b8 01 00 00 00       	mov    $0x1,%eax
  802194:	eb 05                	jmp    80219b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802196:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80219b:	c9                   	leave  
  80219c:	c3                   	ret    

0080219d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  80219d:	55                   	push   %ebp
  80219e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8021a0:	6a 00                	push   $0x0
  8021a2:	6a 00                	push   $0x0
  8021a4:	6a 00                	push   $0x0
  8021a6:	6a 00                	push   $0x0
  8021a8:	ff 75 08             	pushl  0x8(%ebp)
  8021ab:	6a 26                	push   $0x26
  8021ad:	e8 cd fa ff ff       	call   801c7f <syscall>
  8021b2:	83 c4 18             	add    $0x18,%esp
	return;
  8021b5:	90                   	nop
}
  8021b6:	c9                   	leave  
  8021b7:	c3                   	ret    

008021b8 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  8021b8:	55                   	push   %ebp
  8021b9:	89 e5                	mov    %esp,%ebp
  8021bb:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  8021bc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021bf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c8:	6a 00                	push   $0x0
  8021ca:	53                   	push   %ebx
  8021cb:	51                   	push   %ecx
  8021cc:	52                   	push   %edx
  8021cd:	50                   	push   %eax
  8021ce:	6a 27                	push   $0x27
  8021d0:	e8 aa fa ff ff       	call   801c7f <syscall>
  8021d5:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  8021d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021db:	c9                   	leave  
  8021dc:	c3                   	ret    

008021dd <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  8021dd:	55                   	push   %ebp
  8021de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  8021e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e6:	6a 00                	push   $0x0
  8021e8:	6a 00                	push   $0x0
  8021ea:	6a 00                	push   $0x0
  8021ec:	52                   	push   %edx
  8021ed:	50                   	push   %eax
  8021ee:	6a 28                	push   $0x28
  8021f0:	e8 8a fa ff ff       	call   801c7f <syscall>
  8021f5:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  8021f8:	c9                   	leave  
  8021f9:	c3                   	ret    

008021fa <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  8021fa:	55                   	push   %ebp
  8021fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  8021fd:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802200:	8b 55 0c             	mov    0xc(%ebp),%edx
  802203:	8b 45 08             	mov    0x8(%ebp),%eax
  802206:	6a 00                	push   $0x0
  802208:	51                   	push   %ecx
  802209:	ff 75 10             	pushl  0x10(%ebp)
  80220c:	52                   	push   %edx
  80220d:	50                   	push   %eax
  80220e:	6a 29                	push   $0x29
  802210:	e8 6a fa ff ff       	call   801c7f <syscall>
  802215:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  802218:	c9                   	leave  
  802219:	c3                   	ret    

0080221a <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  80221a:	55                   	push   %ebp
  80221b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80221d:	6a 00                	push   $0x0
  80221f:	6a 00                	push   $0x0
  802221:	ff 75 10             	pushl  0x10(%ebp)
  802224:	ff 75 0c             	pushl  0xc(%ebp)
  802227:	ff 75 08             	pushl  0x8(%ebp)
  80222a:	6a 12                	push   $0x12
  80222c:	e8 4e fa ff ff       	call   801c7f <syscall>
  802231:	83 c4 18             	add    $0x18,%esp
	return;
  802234:	90                   	nop
}
  802235:	c9                   	leave  
  802236:	c3                   	ret    

00802237 <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  802237:	55                   	push   %ebp
  802238:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  80223a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80223d:	8b 45 08             	mov    0x8(%ebp),%eax
  802240:	6a 00                	push   $0x0
  802242:	6a 00                	push   $0x0
  802244:	6a 00                	push   $0x0
  802246:	52                   	push   %edx
  802247:	50                   	push   %eax
  802248:	6a 2a                	push   $0x2a
  80224a:	e8 30 fa ff ff       	call   801c7f <syscall>
  80224f:	83 c4 18             	add    $0x18,%esp
	return;
  802252:	90                   	nop
}
  802253:	c9                   	leave  
  802254:	c3                   	ret    

00802255 <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  802255:	55                   	push   %ebp
  802256:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  802258:	8b 45 08             	mov    0x8(%ebp),%eax
  80225b:	6a 00                	push   $0x0
  80225d:	6a 00                	push   $0x0
  80225f:	6a 00                	push   $0x0
  802261:	6a 00                	push   $0x0
  802263:	50                   	push   %eax
  802264:	6a 2b                	push   $0x2b
  802266:	e8 14 fa ff ff       	call   801c7f <syscall>
  80226b:	83 c4 18             	add    $0x18,%esp
}
  80226e:	c9                   	leave  
  80226f:	c3                   	ret    

00802270 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  802270:	55                   	push   %ebp
  802271:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802273:	6a 00                	push   $0x0
  802275:	6a 00                	push   $0x0
  802277:	6a 00                	push   $0x0
  802279:	ff 75 0c             	pushl  0xc(%ebp)
  80227c:	ff 75 08             	pushl  0x8(%ebp)
  80227f:	6a 2c                	push   $0x2c
  802281:	e8 f9 f9 ff ff       	call   801c7f <syscall>
  802286:	83 c4 18             	add    $0x18,%esp
	return;
  802289:	90                   	nop
}
  80228a:	c9                   	leave  
  80228b:	c3                   	ret    

0080228c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  80228c:	55                   	push   %ebp
  80228d:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80228f:	6a 00                	push   $0x0
  802291:	6a 00                	push   $0x0
  802293:	6a 00                	push   $0x0
  802295:	ff 75 0c             	pushl  0xc(%ebp)
  802298:	ff 75 08             	pushl  0x8(%ebp)
  80229b:	6a 2d                	push   $0x2d
  80229d:	e8 dd f9 ff ff       	call   801c7f <syscall>
  8022a2:	83 c4 18             	add    $0x18,%esp
	return;
  8022a5:	90                   	nop
}
  8022a6:	c9                   	leave  
  8022a7:	c3                   	ret    

008022a8 <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  8022a8:	55                   	push   %ebp
  8022a9:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  8022ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ae:	6a 00                	push   $0x0
  8022b0:	6a 00                	push   $0x0
  8022b2:	6a 00                	push   $0x0
  8022b4:	6a 00                	push   $0x0
  8022b6:	50                   	push   %eax
  8022b7:	6a 2f                	push   $0x2f
  8022b9:	e8 c1 f9 ff ff       	call   801c7f <syscall>
  8022be:	83 c4 18             	add    $0x18,%esp
	return;
  8022c1:	90                   	nop
}
  8022c2:	c9                   	leave  
  8022c3:	c3                   	ret    

008022c4 <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  8022c4:	55                   	push   %ebp
  8022c5:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  8022c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cd:	6a 00                	push   $0x0
  8022cf:	6a 00                	push   $0x0
  8022d1:	6a 00                	push   $0x0
  8022d3:	52                   	push   %edx
  8022d4:	50                   	push   %eax
  8022d5:	6a 30                	push   $0x30
  8022d7:	e8 a3 f9 ff ff       	call   801c7f <syscall>
  8022dc:	83 c4 18             	add    $0x18,%esp
	return;
  8022df:	90                   	nop
}
  8022e0:	c9                   	leave  
  8022e1:	c3                   	ret    

008022e2 <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  8022e2:	55                   	push   %ebp
  8022e3:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  8022e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e8:	6a 00                	push   $0x0
  8022ea:	6a 00                	push   $0x0
  8022ec:	6a 00                	push   $0x0
  8022ee:	6a 00                	push   $0x0
  8022f0:	50                   	push   %eax
  8022f1:	6a 31                	push   $0x31
  8022f3:	e8 87 f9 ff ff       	call   801c7f <syscall>
  8022f8:	83 c4 18             	add    $0x18,%esp
	return;
  8022fb:	90                   	nop
}
  8022fc:	c9                   	leave  
  8022fd:	c3                   	ret    

008022fe <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  8022fe:	55                   	push   %ebp
  8022ff:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  802301:	8b 55 0c             	mov    0xc(%ebp),%edx
  802304:	8b 45 08             	mov    0x8(%ebp),%eax
  802307:	6a 00                	push   $0x0
  802309:	6a 00                	push   $0x0
  80230b:	6a 00                	push   $0x0
  80230d:	52                   	push   %edx
  80230e:	50                   	push   %eax
  80230f:	6a 2e                	push   $0x2e
  802311:	e8 69 f9 ff ff       	call   801c7f <syscall>
  802316:	83 c4 18             	add    $0x18,%esp
    return;
  802319:	90                   	nop
}
  80231a:	c9                   	leave  
  80231b:	c3                   	ret    

0080231c <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  80231c:	55                   	push   %ebp
  80231d:	89 e5                	mov    %esp,%ebp
  80231f:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802322:	8b 45 08             	mov    0x8(%ebp),%eax
  802325:	83 e8 04             	sub    $0x4,%eax
  802328:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  80232b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80232e:	8b 00                	mov    (%eax),%eax
  802330:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802333:	c9                   	leave  
  802334:	c3                   	ret    

00802335 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802335:	55                   	push   %ebp
  802336:	89 e5                	mov    %esp,%ebp
  802338:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80233b:	8b 45 08             	mov    0x8(%ebp),%eax
  80233e:	83 e8 04             	sub    $0x4,%eax
  802341:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802344:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802347:	8b 00                	mov    (%eax),%eax
  802349:	83 e0 01             	and    $0x1,%eax
  80234c:	85 c0                	test   %eax,%eax
  80234e:	0f 94 c0             	sete   %al
}
  802351:	c9                   	leave  
  802352:	c3                   	ret    

00802353 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802353:	55                   	push   %ebp
  802354:	89 e5                	mov    %esp,%ebp
  802356:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802359:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802360:	8b 45 0c             	mov    0xc(%ebp),%eax
  802363:	83 f8 02             	cmp    $0x2,%eax
  802366:	74 2b                	je     802393 <alloc_block+0x40>
  802368:	83 f8 02             	cmp    $0x2,%eax
  80236b:	7f 07                	jg     802374 <alloc_block+0x21>
  80236d:	83 f8 01             	cmp    $0x1,%eax
  802370:	74 0e                	je     802380 <alloc_block+0x2d>
  802372:	eb 58                	jmp    8023cc <alloc_block+0x79>
  802374:	83 f8 03             	cmp    $0x3,%eax
  802377:	74 2d                	je     8023a6 <alloc_block+0x53>
  802379:	83 f8 04             	cmp    $0x4,%eax
  80237c:	74 3b                	je     8023b9 <alloc_block+0x66>
  80237e:	eb 4c                	jmp    8023cc <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802380:	83 ec 0c             	sub    $0xc,%esp
  802383:	ff 75 08             	pushl  0x8(%ebp)
  802386:	e8 f7 03 00 00       	call   802782 <alloc_block_FF>
  80238b:	83 c4 10             	add    $0x10,%esp
  80238e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802391:	eb 4a                	jmp    8023dd <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802393:	83 ec 0c             	sub    $0xc,%esp
  802396:	ff 75 08             	pushl  0x8(%ebp)
  802399:	e8 f0 11 00 00       	call   80358e <alloc_block_NF>
  80239e:	83 c4 10             	add    $0x10,%esp
  8023a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8023a4:	eb 37                	jmp    8023dd <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8023a6:	83 ec 0c             	sub    $0xc,%esp
  8023a9:	ff 75 08             	pushl  0x8(%ebp)
  8023ac:	e8 08 08 00 00       	call   802bb9 <alloc_block_BF>
  8023b1:	83 c4 10             	add    $0x10,%esp
  8023b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8023b7:	eb 24                	jmp    8023dd <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8023b9:	83 ec 0c             	sub    $0xc,%esp
  8023bc:	ff 75 08             	pushl  0x8(%ebp)
  8023bf:	e8 ad 11 00 00       	call   803571 <alloc_block_WF>
  8023c4:	83 c4 10             	add    $0x10,%esp
  8023c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8023ca:	eb 11                	jmp    8023dd <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8023cc:	83 ec 0c             	sub    $0xc,%esp
  8023cf:	68 98 43 80 00       	push   $0x804398
  8023d4:	e8 41 e4 ff ff       	call   80081a <cprintf>
  8023d9:	83 c4 10             	add    $0x10,%esp
		break;
  8023dc:	90                   	nop
	}
	return va;
  8023dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8023e0:	c9                   	leave  
  8023e1:	c3                   	ret    

008023e2 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8023e2:	55                   	push   %ebp
  8023e3:	89 e5                	mov    %esp,%ebp
  8023e5:	53                   	push   %ebx
  8023e6:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8023e9:	83 ec 0c             	sub    $0xc,%esp
  8023ec:	68 b8 43 80 00       	push   $0x8043b8
  8023f1:	e8 24 e4 ff ff       	call   80081a <cprintf>
  8023f6:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8023f9:	83 ec 0c             	sub    $0xc,%esp
  8023fc:	68 e3 43 80 00       	push   $0x8043e3
  802401:	e8 14 e4 ff ff       	call   80081a <cprintf>
  802406:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802409:	8b 45 08             	mov    0x8(%ebp),%eax
  80240c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80240f:	eb 37                	jmp    802448 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802411:	83 ec 0c             	sub    $0xc,%esp
  802414:	ff 75 f4             	pushl  -0xc(%ebp)
  802417:	e8 19 ff ff ff       	call   802335 <is_free_block>
  80241c:	83 c4 10             	add    $0x10,%esp
  80241f:	0f be d8             	movsbl %al,%ebx
  802422:	83 ec 0c             	sub    $0xc,%esp
  802425:	ff 75 f4             	pushl  -0xc(%ebp)
  802428:	e8 ef fe ff ff       	call   80231c <get_block_size>
  80242d:	83 c4 10             	add    $0x10,%esp
  802430:	83 ec 04             	sub    $0x4,%esp
  802433:	53                   	push   %ebx
  802434:	50                   	push   %eax
  802435:	68 fb 43 80 00       	push   $0x8043fb
  80243a:	e8 db e3 ff ff       	call   80081a <cprintf>
  80243f:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802442:	8b 45 10             	mov    0x10(%ebp),%eax
  802445:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802448:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80244c:	74 07                	je     802455 <print_blocks_list+0x73>
  80244e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802451:	8b 00                	mov    (%eax),%eax
  802453:	eb 05                	jmp    80245a <print_blocks_list+0x78>
  802455:	b8 00 00 00 00       	mov    $0x0,%eax
  80245a:	89 45 10             	mov    %eax,0x10(%ebp)
  80245d:	8b 45 10             	mov    0x10(%ebp),%eax
  802460:	85 c0                	test   %eax,%eax
  802462:	75 ad                	jne    802411 <print_blocks_list+0x2f>
  802464:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802468:	75 a7                	jne    802411 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  80246a:	83 ec 0c             	sub    $0xc,%esp
  80246d:	68 b8 43 80 00       	push   $0x8043b8
  802472:	e8 a3 e3 ff ff       	call   80081a <cprintf>
  802477:	83 c4 10             	add    $0x10,%esp

}
  80247a:	90                   	nop
  80247b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80247e:	c9                   	leave  
  80247f:	c3                   	ret    

00802480 <initialize_dynamic_allocator>:

//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802480:	55                   	push   %ebp
  802481:	89 e5                	mov    %esp,%ebp
  802483:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802486:	8b 45 0c             	mov    0xc(%ebp),%eax
  802489:	83 e0 01             	and    $0x1,%eax
  80248c:	85 c0                	test   %eax,%eax
  80248e:	74 03                	je     802493 <initialize_dynamic_allocator+0x13>
  802490:	ff 45 0c             	incl   0xc(%ebp)
		if (initSizeOfAllocatedSpace == 0)
  802493:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802497:	0f 84 f8 00 00 00    	je     802595 <initialize_dynamic_allocator+0x115>
			return ;
		is_initialized = 1;
  80249d:	c7 05 40 50 98 00 01 	movl   $0x1,0x985040
  8024a4:	00 00 00 
	//TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("initialize_dynamic_allocator is not implemented yet");
	//Your Code is Here...

	if(is_initialized){
  8024a7:	a1 40 50 98 00       	mov    0x985040,%eax
  8024ac:	85 c0                	test   %eax,%eax
  8024ae:	0f 84 e2 00 00 00    	je     802596 <initialize_dynamic_allocator+0x116>

		// begin block with size 0 and lsb = 1 (allocated)
		uint32* beginBlock = (uint32*)daStart;
  8024b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		*beginBlock = 0 | 1; // size = 0, LSB as a flag = 1
  8024ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bd:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		// end block with size 0 and lsb = 1 (allocated)
		uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);
  8024c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8024c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024c9:	01 d0                	add    %edx,%eax
  8024cb:	83 e8 04             	sub    $0x4,%eax
  8024ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
		*endBlock = 0 | 1; // size = 0, LSB as a flag = 1
  8024d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

		// the block that between begin and end blocks
		struct BlockElement* block = (struct BlockElement*)(daStart + 8);
  8024da:	8b 45 08             	mov    0x8(%ebp),%eax
  8024dd:	83 c0 08             	add    $0x8,%eax
  8024e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 blockSize = initSizeOfAllocatedSpace - 8; // subtract size of begin and end blocks
  8024e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024e6:	83 e8 08             	sub    $0x8,%eax
  8024e9:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(block,blockSize,0);
  8024ec:	83 ec 04             	sub    $0x4,%esp
  8024ef:	6a 00                	push   $0x0
  8024f1:	ff 75 e8             	pushl  -0x18(%ebp)
  8024f4:	ff 75 ec             	pushl  -0x14(%ebp)
  8024f7:	e8 9c 00 00 00       	call   802598 <set_block_data>
  8024fc:	83 c4 10             	add    $0x10,%esp

		block->prev_next_info.le_next = NULL;
  8024ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802502:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block->prev_next_info.le_prev = NULL;
  802508:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80250b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

		LIST_INIT(&freeBlocksList);
  802512:	c7 05 48 50 98 00 00 	movl   $0x0,0x985048
  802519:	00 00 00 
  80251c:	c7 05 4c 50 98 00 00 	movl   $0x0,0x98504c
  802523:	00 00 00 
  802526:	c7 05 54 50 98 00 00 	movl   $0x0,0x985054
  80252d:	00 00 00 
		LIST_INSERT_HEAD(&freeBlocksList, block);
  802530:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802534:	75 17                	jne    80254d <initialize_dynamic_allocator+0xcd>
  802536:	83 ec 04             	sub    $0x4,%esp
  802539:	68 14 44 80 00       	push   $0x804414
  80253e:	68 80 00 00 00       	push   $0x80
  802543:	68 37 44 80 00       	push   $0x804437
  802548:	e8 10 e0 ff ff       	call   80055d <_panic>
  80254d:	8b 15 48 50 98 00    	mov    0x985048,%edx
  802553:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802556:	89 10                	mov    %edx,(%eax)
  802558:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80255b:	8b 00                	mov    (%eax),%eax
  80255d:	85 c0                	test   %eax,%eax
  80255f:	74 0d                	je     80256e <initialize_dynamic_allocator+0xee>
  802561:	a1 48 50 98 00       	mov    0x985048,%eax
  802566:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802569:	89 50 04             	mov    %edx,0x4(%eax)
  80256c:	eb 08                	jmp    802576 <initialize_dynamic_allocator+0xf6>
  80256e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802571:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802576:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802579:	a3 48 50 98 00       	mov    %eax,0x985048
  80257e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802581:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802588:	a1 54 50 98 00       	mov    0x985054,%eax
  80258d:	40                   	inc    %eax
  80258e:	a3 54 50 98 00       	mov    %eax,0x985054
  802593:	eb 01                	jmp    802596 <initialize_dynamic_allocator+0x116>
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
		if (initSizeOfAllocatedSpace == 0)
			return ;
  802595:	90                   	nop
		block->prev_next_info.le_prev = NULL;

		LIST_INIT(&freeBlocksList);
		LIST_INSERT_HEAD(&freeBlocksList, block);
	}
}
  802596:	c9                   	leave  
  802597:	c3                   	ret    

00802598 <set_block_data>:
//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802598:	55                   	push   %ebp
  802599:	89 e5                	mov    %esp,%ebp
  80259b:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("set_block_data is not implemented yet");
	//Your Code is Here...

	if(totalSize % 2 != 0)
  80259e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025a1:	83 e0 01             	and    $0x1,%eax
  8025a4:	85 c0                	test   %eax,%eax
  8025a6:	74 03                	je     8025ab <set_block_data+0x13>
	{
		totalSize++;
  8025a8:	ff 45 0c             	incl   0xc(%ebp)
	}

	uint32* header = (uint32 *)((uint32*)va-1);
  8025ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ae:	83 e8 04             	sub    $0x4,%eax
  8025b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//	size => totalSize with LSB = 0		 set LSB = 1 if isAllocated
	*header = (totalSize & ~1) | (isAllocated & 1);
  8025b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025b7:	83 e0 fe             	and    $0xfffffffe,%eax
  8025ba:	89 c2                	mov    %eax,%edx
  8025bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8025bf:	83 e0 01             	and    $0x1,%eax
  8025c2:	09 c2                	or     %eax,%edx
  8025c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025c7:	89 10                	mov    %edx,(%eax)
	uint32* footer = (uint32*) (va + totalSize - 8);
  8025c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025cc:	8d 50 f8             	lea    -0x8(%eax),%edx
  8025cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d2:	01 d0                	add    %edx,%eax
  8025d4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	*footer = (totalSize & ~1) | (isAllocated & 1);
  8025d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025da:	83 e0 fe             	and    $0xfffffffe,%eax
  8025dd:	89 c2                	mov    %eax,%edx
  8025df:	8b 45 10             	mov    0x10(%ebp),%eax
  8025e2:	83 e0 01             	and    $0x1,%eax
  8025e5:	09 c2                	or     %eax,%edx
  8025e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8025ea:	89 10                	mov    %edx,(%eax)
}
  8025ec:	90                   	nop
  8025ed:	c9                   	leave  
  8025ee:	c3                   	ret    

008025ef <insert_sorted_in_freeList>:
//=========================================
void insert_sorted_in_freeList(struct BlockElement *newBlock)
{
  8025ef:	55                   	push   %ebp
  8025f0:	89 e5                	mov    %esp,%ebp
  8025f2:	83 ec 18             	sub    $0x18,%esp
	if(LIST_EMPTY(&freeBlocksList))
  8025f5:	a1 48 50 98 00       	mov    0x985048,%eax
  8025fa:	85 c0                	test   %eax,%eax
  8025fc:	75 68                	jne    802666 <insert_sorted_in_freeList+0x77>
	{
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
  8025fe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802602:	75 17                	jne    80261b <insert_sorted_in_freeList+0x2c>
  802604:	83 ec 04             	sub    $0x4,%esp
  802607:	68 14 44 80 00       	push   $0x804414
  80260c:	68 9d 00 00 00       	push   $0x9d
  802611:	68 37 44 80 00       	push   $0x804437
  802616:	e8 42 df ff ff       	call   80055d <_panic>
  80261b:	8b 15 48 50 98 00    	mov    0x985048,%edx
  802621:	8b 45 08             	mov    0x8(%ebp),%eax
  802624:	89 10                	mov    %edx,(%eax)
  802626:	8b 45 08             	mov    0x8(%ebp),%eax
  802629:	8b 00                	mov    (%eax),%eax
  80262b:	85 c0                	test   %eax,%eax
  80262d:	74 0d                	je     80263c <insert_sorted_in_freeList+0x4d>
  80262f:	a1 48 50 98 00       	mov    0x985048,%eax
  802634:	8b 55 08             	mov    0x8(%ebp),%edx
  802637:	89 50 04             	mov    %edx,0x4(%eax)
  80263a:	eb 08                	jmp    802644 <insert_sorted_in_freeList+0x55>
  80263c:	8b 45 08             	mov    0x8(%ebp),%eax
  80263f:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802644:	8b 45 08             	mov    0x8(%ebp),%eax
  802647:	a3 48 50 98 00       	mov    %eax,0x985048
  80264c:	8b 45 08             	mov    0x8(%ebp),%eax
  80264f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802656:	a1 54 50 98 00       	mov    0x985054,%eax
  80265b:	40                   	inc    %eax
  80265c:	a3 54 50 98 00       	mov    %eax,0x985054
		return;
  802661:	e9 1a 01 00 00       	jmp    802780 <insert_sorted_in_freeList+0x191>
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  802666:	a1 48 50 98 00       	mov    0x985048,%eax
  80266b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80266e:	eb 7f                	jmp    8026ef <insert_sorted_in_freeList+0x100>
	{
		if(blk > newBlock) // if address of blk > address of newBlock => add newBlock before blk
  802670:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802673:	3b 45 08             	cmp    0x8(%ebp),%eax
  802676:	76 6f                	jbe    8026e7 <insert_sorted_in_freeList+0xf8>
		{
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
  802678:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80267c:	74 06                	je     802684 <insert_sorted_in_freeList+0x95>
  80267e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802682:	75 17                	jne    80269b <insert_sorted_in_freeList+0xac>
  802684:	83 ec 04             	sub    $0x4,%esp
  802687:	68 50 44 80 00       	push   $0x804450
  80268c:	68 a6 00 00 00       	push   $0xa6
  802691:	68 37 44 80 00       	push   $0x804437
  802696:	e8 c2 de ff ff       	call   80055d <_panic>
  80269b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269e:	8b 50 04             	mov    0x4(%eax),%edx
  8026a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a4:	89 50 04             	mov    %edx,0x4(%eax)
  8026a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026ad:	89 10                	mov    %edx,(%eax)
  8026af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b2:	8b 40 04             	mov    0x4(%eax),%eax
  8026b5:	85 c0                	test   %eax,%eax
  8026b7:	74 0d                	je     8026c6 <insert_sorted_in_freeList+0xd7>
  8026b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bc:	8b 40 04             	mov    0x4(%eax),%eax
  8026bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8026c2:	89 10                	mov    %edx,(%eax)
  8026c4:	eb 08                	jmp    8026ce <insert_sorted_in_freeList+0xdf>
  8026c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c9:	a3 48 50 98 00       	mov    %eax,0x985048
  8026ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8026d4:	89 50 04             	mov    %edx,0x4(%eax)
  8026d7:	a1 54 50 98 00       	mov    0x985054,%eax
  8026dc:	40                   	inc    %eax
  8026dd:	a3 54 50 98 00       	mov    %eax,0x985054
			return;
  8026e2:	e9 99 00 00 00       	jmp    802780 <insert_sorted_in_freeList+0x191>
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
		return;
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  8026e7:	a1 50 50 98 00       	mov    0x985050,%eax
  8026ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026f3:	74 07                	je     8026fc <insert_sorted_in_freeList+0x10d>
  8026f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f8:	8b 00                	mov    (%eax),%eax
  8026fa:	eb 05                	jmp    802701 <insert_sorted_in_freeList+0x112>
  8026fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802701:	a3 50 50 98 00       	mov    %eax,0x985050
  802706:	a1 50 50 98 00       	mov    0x985050,%eax
  80270b:	85 c0                	test   %eax,%eax
  80270d:	0f 85 5d ff ff ff    	jne    802670 <insert_sorted_in_freeList+0x81>
  802713:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802717:	0f 85 53 ff ff ff    	jne    802670 <insert_sorted_in_freeList+0x81>
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
			return;
		}
	}
	// if no blk its address > newBlock
	LIST_INSERT_TAIL(&freeBlocksList, newBlock);
  80271d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802721:	75 17                	jne    80273a <insert_sorted_in_freeList+0x14b>
  802723:	83 ec 04             	sub    $0x4,%esp
  802726:	68 88 44 80 00       	push   $0x804488
  80272b:	68 ab 00 00 00       	push   $0xab
  802730:	68 37 44 80 00       	push   $0x804437
  802735:	e8 23 de ff ff       	call   80055d <_panic>
  80273a:	8b 15 4c 50 98 00    	mov    0x98504c,%edx
  802740:	8b 45 08             	mov    0x8(%ebp),%eax
  802743:	89 50 04             	mov    %edx,0x4(%eax)
  802746:	8b 45 08             	mov    0x8(%ebp),%eax
  802749:	8b 40 04             	mov    0x4(%eax),%eax
  80274c:	85 c0                	test   %eax,%eax
  80274e:	74 0c                	je     80275c <insert_sorted_in_freeList+0x16d>
  802750:	a1 4c 50 98 00       	mov    0x98504c,%eax
  802755:	8b 55 08             	mov    0x8(%ebp),%edx
  802758:	89 10                	mov    %edx,(%eax)
  80275a:	eb 08                	jmp    802764 <insert_sorted_in_freeList+0x175>
  80275c:	8b 45 08             	mov    0x8(%ebp),%eax
  80275f:	a3 48 50 98 00       	mov    %eax,0x985048
  802764:	8b 45 08             	mov    0x8(%ebp),%eax
  802767:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80276c:	8b 45 08             	mov    0x8(%ebp),%eax
  80276f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802775:	a1 54 50 98 00       	mov    0x985054,%eax
  80277a:	40                   	inc    %eax
  80277b:	a3 54 50 98 00       	mov    %eax,0x985054
}
  802780:	c9                   	leave  
  802781:	c3                   	ret    

00802782 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  802782:	55                   	push   %ebp
  802783:	89 e5                	mov    %esp,%ebp
  802785:	83 ec 78             	sub    $0x78,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802788:	8b 45 08             	mov    0x8(%ebp),%eax
  80278b:	83 e0 01             	and    $0x1,%eax
  80278e:	85 c0                	test   %eax,%eax
  802790:	74 03                	je     802795 <alloc_block_FF+0x13>
  802792:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802795:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802799:	77 07                	ja     8027a2 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80279b:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8027a2:	a1 40 50 98 00       	mov    0x985040,%eax
  8027a7:	85 c0                	test   %eax,%eax
  8027a9:	75 63                	jne    80280e <alloc_block_FF+0x8c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8027ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ae:	83 c0 10             	add    $0x10,%eax
  8027b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8027b4:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8027bb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027c1:	01 d0                	add    %edx,%eax
  8027c3:	48                   	dec    %eax
  8027c4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8027c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8027cf:	f7 75 ec             	divl   -0x14(%ebp)
  8027d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027d5:	29 d0                	sub    %edx,%eax
  8027d7:	c1 e8 0c             	shr    $0xc,%eax
  8027da:	83 ec 0c             	sub    $0xc,%esp
  8027dd:	50                   	push   %eax
  8027de:	e8 d1 ed ff ff       	call   8015b4 <sbrk>
  8027e3:	83 c4 10             	add    $0x10,%esp
  8027e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8027e9:	83 ec 0c             	sub    $0xc,%esp
  8027ec:	6a 00                	push   $0x0
  8027ee:	e8 c1 ed ff ff       	call   8015b4 <sbrk>
  8027f3:	83 c4 10             	add    $0x10,%esp
  8027f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8027f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027fc:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8027ff:	83 ec 08             	sub    $0x8,%esp
  802802:	50                   	push   %eax
  802803:	ff 75 e4             	pushl  -0x1c(%ebp)
  802806:	e8 75 fc ff ff       	call   802480 <initialize_dynamic_allocator>
  80280b:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(size == 0)
  80280e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802812:	75 0a                	jne    80281e <alloc_block_FF+0x9c>
	{
		return NULL;
  802814:	b8 00 00 00 00       	mov    $0x0,%eax
  802819:	e9 99 03 00 00       	jmp    802bb7 <alloc_block_FF+0x435>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  80281e:	8b 45 08             	mov    0x8(%ebp),%eax
  802821:	83 c0 08             	add    $0x8,%eax
  802824:	89 45 dc             	mov    %eax,-0x24(%ebp)

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802827:	a1 48 50 98 00       	mov    0x985048,%eax
  80282c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80282f:	e9 03 02 00 00       	jmp    802a37 <alloc_block_FF+0x2b5>
	{
		uint32 blockSize = get_block_size(block); // Get size without the (LSB) allocation flag
  802834:	83 ec 0c             	sub    $0xc,%esp
  802837:	ff 75 f4             	pushl  -0xc(%ebp)
  80283a:	e8 dd fa ff ff       	call   80231c <get_block_size>
  80283f:	83 c4 10             	add    $0x10,%esp
  802842:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if(blockSize >= totalSize)
  802845:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802848:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80284b:	0f 82 de 01 00 00    	jb     802a2f <alloc_block_FF+0x2ad>
		{	//if we can put another block with min size 16
			if(blockSize >= totalSize + 4*sizeof(uint32))
  802851:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802854:	83 c0 10             	add    $0x10,%eax
  802857:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  80285a:	0f 87 32 01 00 00    	ja     802992 <alloc_block_FF+0x210>
			{
				// the size that will remain from the block that we will allocate a new block in it
				uint32 remainingSize = blockSize - totalSize;
  802860:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802863:	2b 45 dc             	sub    -0x24(%ebp),%eax
  802866:	89 45 98             	mov    %eax,-0x68(%ebp)

				// the remaining free space from the block that we use to allocate in it
				struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)block + totalSize);
  802869:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80286c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80286f:	01 d0                	add    %edx,%eax
  802871:	89 45 94             	mov    %eax,-0x6c(%ebp)
				set_block_data(remainingFreeBlock, remainingSize, 0);
  802874:	83 ec 04             	sub    $0x4,%esp
  802877:	6a 00                	push   $0x0
  802879:	ff 75 98             	pushl  -0x68(%ebp)
  80287c:	ff 75 94             	pushl  -0x6c(%ebp)
  80287f:	e8 14 fd ff ff       	call   802598 <set_block_data>
  802884:	83 c4 10             	add    $0x10,%esp
				// add it after the block we allocated to be sorted by addresses
				LIST_INSERT_AFTER(&freeBlocksList, block,remainingFreeBlock);
  802887:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80288b:	74 06                	je     802893 <alloc_block_FF+0x111>
  80288d:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
  802891:	75 17                	jne    8028aa <alloc_block_FF+0x128>
  802893:	83 ec 04             	sub    $0x4,%esp
  802896:	68 ac 44 80 00       	push   $0x8044ac
  80289b:	68 de 00 00 00       	push   $0xde
  8028a0:	68 37 44 80 00       	push   $0x804437
  8028a5:	e8 b3 dc ff ff       	call   80055d <_panic>
  8028aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ad:	8b 10                	mov    (%eax),%edx
  8028af:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8028b2:	89 10                	mov    %edx,(%eax)
  8028b4:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8028b7:	8b 00                	mov    (%eax),%eax
  8028b9:	85 c0                	test   %eax,%eax
  8028bb:	74 0b                	je     8028c8 <alloc_block_FF+0x146>
  8028bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c0:	8b 00                	mov    (%eax),%eax
  8028c2:	8b 55 94             	mov    -0x6c(%ebp),%edx
  8028c5:	89 50 04             	mov    %edx,0x4(%eax)
  8028c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cb:	8b 55 94             	mov    -0x6c(%ebp),%edx
  8028ce:	89 10                	mov    %edx,(%eax)
  8028d0:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8028d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028d6:	89 50 04             	mov    %edx,0x4(%eax)
  8028d9:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8028dc:	8b 00                	mov    (%eax),%eax
  8028de:	85 c0                	test   %eax,%eax
  8028e0:	75 08                	jne    8028ea <alloc_block_FF+0x168>
  8028e2:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8028e5:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8028ea:	a1 54 50 98 00       	mov    0x985054,%eax
  8028ef:	40                   	inc    %eax
  8028f0:	a3 54 50 98 00       	mov    %eax,0x985054

				// update the allocated block and remove it from freeBlocksList
				set_block_data(block,totalSize,1);
  8028f5:	83 ec 04             	sub    $0x4,%esp
  8028f8:	6a 01                	push   $0x1
  8028fa:	ff 75 dc             	pushl  -0x24(%ebp)
  8028fd:	ff 75 f4             	pushl  -0xc(%ebp)
  802900:	e8 93 fc ff ff       	call   802598 <set_block_data>
  802905:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  802908:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80290c:	75 17                	jne    802925 <alloc_block_FF+0x1a3>
  80290e:	83 ec 04             	sub    $0x4,%esp
  802911:	68 e0 44 80 00       	push   $0x8044e0
  802916:	68 e3 00 00 00       	push   $0xe3
  80291b:	68 37 44 80 00       	push   $0x804437
  802920:	e8 38 dc ff ff       	call   80055d <_panic>
  802925:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802928:	8b 00                	mov    (%eax),%eax
  80292a:	85 c0                	test   %eax,%eax
  80292c:	74 10                	je     80293e <alloc_block_FF+0x1bc>
  80292e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802931:	8b 00                	mov    (%eax),%eax
  802933:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802936:	8b 52 04             	mov    0x4(%edx),%edx
  802939:	89 50 04             	mov    %edx,0x4(%eax)
  80293c:	eb 0b                	jmp    802949 <alloc_block_FF+0x1c7>
  80293e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802941:	8b 40 04             	mov    0x4(%eax),%eax
  802944:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802949:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294c:	8b 40 04             	mov    0x4(%eax),%eax
  80294f:	85 c0                	test   %eax,%eax
  802951:	74 0f                	je     802962 <alloc_block_FF+0x1e0>
  802953:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802956:	8b 40 04             	mov    0x4(%eax),%eax
  802959:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80295c:	8b 12                	mov    (%edx),%edx
  80295e:	89 10                	mov    %edx,(%eax)
  802960:	eb 0a                	jmp    80296c <alloc_block_FF+0x1ea>
  802962:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802965:	8b 00                	mov    (%eax),%eax
  802967:	a3 48 50 98 00       	mov    %eax,0x985048
  80296c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802975:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802978:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80297f:	a1 54 50 98 00       	mov    0x985054,%eax
  802984:	48                   	dec    %eax
  802985:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  80298a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298d:	e9 25 02 00 00       	jmp    802bb7 <alloc_block_FF+0x435>
			}
			else // if set internal fragmentation
			{
				// add the remaining size to the block we allocate so it will be the same main block size
				set_block_data(block,blockSize,1);
  802992:	83 ec 04             	sub    $0x4,%esp
  802995:	6a 01                	push   $0x1
  802997:	ff 75 9c             	pushl  -0x64(%ebp)
  80299a:	ff 75 f4             	pushl  -0xc(%ebp)
  80299d:	e8 f6 fb ff ff       	call   802598 <set_block_data>
  8029a2:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  8029a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029a9:	75 17                	jne    8029c2 <alloc_block_FF+0x240>
  8029ab:	83 ec 04             	sub    $0x4,%esp
  8029ae:	68 e0 44 80 00       	push   $0x8044e0
  8029b3:	68 eb 00 00 00       	push   $0xeb
  8029b8:	68 37 44 80 00       	push   $0x804437
  8029bd:	e8 9b db ff ff       	call   80055d <_panic>
  8029c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c5:	8b 00                	mov    (%eax),%eax
  8029c7:	85 c0                	test   %eax,%eax
  8029c9:	74 10                	je     8029db <alloc_block_FF+0x259>
  8029cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ce:	8b 00                	mov    (%eax),%eax
  8029d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029d3:	8b 52 04             	mov    0x4(%edx),%edx
  8029d6:	89 50 04             	mov    %edx,0x4(%eax)
  8029d9:	eb 0b                	jmp    8029e6 <alloc_block_FF+0x264>
  8029db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029de:	8b 40 04             	mov    0x4(%eax),%eax
  8029e1:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8029e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e9:	8b 40 04             	mov    0x4(%eax),%eax
  8029ec:	85 c0                	test   %eax,%eax
  8029ee:	74 0f                	je     8029ff <alloc_block_FF+0x27d>
  8029f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f3:	8b 40 04             	mov    0x4(%eax),%eax
  8029f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029f9:	8b 12                	mov    (%edx),%edx
  8029fb:	89 10                	mov    %edx,(%eax)
  8029fd:	eb 0a                	jmp    802a09 <alloc_block_FF+0x287>
  8029ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a02:	8b 00                	mov    (%eax),%eax
  802a04:	a3 48 50 98 00       	mov    %eax,0x985048
  802a09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a15:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a1c:	a1 54 50 98 00       	mov    0x985054,%eax
  802a21:	48                   	dec    %eax
  802a22:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  802a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2a:	e9 88 01 00 00       	jmp    802bb7 <alloc_block_FF+0x435>
		return NULL;
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802a2f:	a1 50 50 98 00       	mov    0x985050,%eax
  802a34:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a37:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a3b:	74 07                	je     802a44 <alloc_block_FF+0x2c2>
  802a3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a40:	8b 00                	mov    (%eax),%eax
  802a42:	eb 05                	jmp    802a49 <alloc_block_FF+0x2c7>
  802a44:	b8 00 00 00 00       	mov    $0x0,%eax
  802a49:	a3 50 50 98 00       	mov    %eax,0x985050
  802a4e:	a1 50 50 98 00       	mov    0x985050,%eax
  802a53:	85 c0                	test   %eax,%eax
  802a55:	0f 85 d9 fd ff ff    	jne    802834 <alloc_block_FF+0xb2>
  802a5b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a5f:	0f 85 cf fd ff ff    	jne    802834 <alloc_block_FF+0xb2>

//	uint32 *endBlock = &kheapBreak;

	// if we don't find any enough space to allocate the block

	void *oldBreak = sbrk(ROUNDUP(totalSize, PAGE_SIZE) / PAGE_SIZE);
  802a65:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802a6c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802a6f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a72:	01 d0                	add    %edx,%eax
  802a74:	48                   	dec    %eax
  802a75:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802a78:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802a7b:	ba 00 00 00 00       	mov    $0x0,%edx
  802a80:	f7 75 d8             	divl   -0x28(%ebp)
  802a83:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802a86:	29 d0                	sub    %edx,%eax
  802a88:	c1 e8 0c             	shr    $0xc,%eax
  802a8b:	83 ec 0c             	sub    $0xc,%esp
  802a8e:	50                   	push   %eax
  802a8f:	e8 20 eb ff ff       	call   8015b4 <sbrk>
  802a94:	83 c4 10             	add    $0x10,%esp
  802a97:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (oldBreak == (void*)-1) {
  802a9a:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802a9e:	75 0a                	jne    802aaa <alloc_block_FF+0x328>
		return NULL;
  802aa0:	b8 00 00 00 00       	mov    $0x0,%eax
  802aa5:	e9 0d 01 00 00       	jmp    802bb7 <alloc_block_FF+0x435>
	}
	//uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);

	uint32* endBlk = (uint32 *)((char *)oldBreak - 4);
  802aaa:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802aad:	83 e8 04             	sub    $0x4,%eax
  802ab0:	89 45 cc             	mov    %eax,-0x34(%ebp)
	//endBlk = endBlk+(char *) ROUNDUP(totalSize, PAGE_SIZE);

	endBlk = endBlk + (ROUNDUP(totalSize, PAGE_SIZE) / sizeof(uint32));
  802ab3:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  802aba:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802abd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802ac0:	01 d0                	add    %edx,%eax
  802ac2:	48                   	dec    %eax
  802ac3:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  802ac6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802ac9:	ba 00 00 00 00       	mov    $0x0,%edx
  802ace:	f7 75 c8             	divl   -0x38(%ebp)
  802ad1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802ad4:	29 d0                	sub    %edx,%eax
  802ad6:	c1 e8 02             	shr    $0x2,%eax
  802ad9:	c1 e0 02             	shl    $0x2,%eax
  802adc:	01 45 cc             	add    %eax,-0x34(%ebp)
	*endBlk = 0 | 1;
  802adf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ae2:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	uint32 *footerLast = ((uint32*)oldBreak - 2);
  802ae8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802aeb:	83 e8 08             	sub    $0x8,%eax
  802aee:	89 45 c0             	mov    %eax,-0x40(%ebp)
	uint32 lastSize = (*footerLast) & ~(0x1);
  802af1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802af4:	8b 00                	mov    (%eax),%eax
  802af6:	83 e0 fe             	and    $0xfffffffe,%eax
  802af9:	89 45 bc             	mov    %eax,-0x44(%ebp)
	// the last block for the block that we want to free it
	struct BlockElement *laskBlk = (struct BlockElement *)((char*)oldBreak - lastSize);
  802afc:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802aff:	f7 d8                	neg    %eax
  802b01:	89 c2                	mov    %eax,%edx
  802b03:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802b06:	01 d0                	add    %edx,%eax
  802b08:	89 45 b8             	mov    %eax,-0x48(%ebp)
	uint32 isLastFree = is_free_block(laskBlk);
  802b0b:	83 ec 0c             	sub    $0xc,%esp
  802b0e:	ff 75 b8             	pushl  -0x48(%ebp)
  802b11:	e8 1f f8 ff ff       	call   802335 <is_free_block>
  802b16:	83 c4 10             	add    $0x10,%esp
  802b19:	0f be c0             	movsbl %al,%eax
  802b1c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(isLastFree)
  802b1f:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  802b23:	74 42                	je     802b67 <alloc_block_FF+0x3e5>
	{
		// merge the block will be free with its prev block
		uint32 newBlkSize = lastSize + ROUNDUP(totalSize, PAGE_SIZE); // size of main block and its prev block
  802b25:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802b2c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802b2f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b32:	01 d0                	add    %edx,%eax
  802b34:	48                   	dec    %eax
  802b35:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802b38:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802b3b:	ba 00 00 00 00       	mov    $0x0,%edx
  802b40:	f7 75 b0             	divl   -0x50(%ebp)
  802b43:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802b46:	29 d0                	sub    %edx,%eax
  802b48:	89 c2                	mov    %eax,%edx
  802b4a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802b4d:	01 d0                	add    %edx,%eax
  802b4f:	89 45 a8             	mov    %eax,-0x58(%ebp)
		// extends last block size to contain its size and the size of new space
		set_block_data(laskBlk,newBlkSize,0);
  802b52:	83 ec 04             	sub    $0x4,%esp
  802b55:	6a 00                	push   $0x0
  802b57:	ff 75 a8             	pushl  -0x58(%ebp)
  802b5a:	ff 75 b8             	pushl  -0x48(%ebp)
  802b5d:	e8 36 fa ff ff       	call   802598 <set_block_data>
  802b62:	83 c4 10             	add    $0x10,%esp
  802b65:	eb 42                	jmp    802ba9 <alloc_block_FF+0x427>
	}
	else
	{
		set_block_data(oldBreak,ROUNDUP(totalSize, PAGE_SIZE),0);
  802b67:	c7 45 a4 00 10 00 00 	movl   $0x1000,-0x5c(%ebp)
  802b6e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802b71:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802b74:	01 d0                	add    %edx,%eax
  802b76:	48                   	dec    %eax
  802b77:	89 45 a0             	mov    %eax,-0x60(%ebp)
  802b7a:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802b7d:	ba 00 00 00 00       	mov    $0x0,%edx
  802b82:	f7 75 a4             	divl   -0x5c(%ebp)
  802b85:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802b88:	29 d0                	sub    %edx,%eax
  802b8a:	83 ec 04             	sub    $0x4,%esp
  802b8d:	6a 00                	push   $0x0
  802b8f:	50                   	push   %eax
  802b90:	ff 75 d0             	pushl  -0x30(%ebp)
  802b93:	e8 00 fa ff ff       	call   802598 <set_block_data>
  802b98:	83 c4 10             	add    $0x10,%esp
		insert_sorted_in_freeList((struct BlockElement *)oldBreak);
  802b9b:	83 ec 0c             	sub    $0xc,%esp
  802b9e:	ff 75 d0             	pushl  -0x30(%ebp)
  802ba1:	e8 49 fa ff ff       	call   8025ef <insert_sorted_in_freeList>
  802ba6:	83 c4 10             	add    $0x10,%esp
//		LIST_INSERT_TAIL(&freeBlocksList,newBreak);
	}
//	set_block_data((struct BlockElement *)newBreak, totalSize, 1);
	return alloc_block_FF(size);
  802ba9:	83 ec 0c             	sub    $0xc,%esp
  802bac:	ff 75 08             	pushl  0x8(%ebp)
  802baf:	e8 ce fb ff ff       	call   802782 <alloc_block_FF>
  802bb4:	83 c4 10             	add    $0x10,%esp
}
  802bb7:	c9                   	leave  
  802bb8:	c3                   	ret    

00802bb9 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802bb9:	55                   	push   %ebp
  802bba:	89 e5                	mov    %esp,%ebp
  802bbc:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS1 - BONUS] [3] DYNAMIC ALLOCATOR - alloc_block_BF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_BF is not implemented yet");
	//Your Code is Here...
	if(size == 0)
  802bbf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bc3:	75 0a                	jne    802bcf <alloc_block_BF+0x16>
	{
		return NULL;
  802bc5:	b8 00 00 00 00       	mov    $0x0,%eax
  802bca:	e9 7a 02 00 00       	jmp    802e49 <alloc_block_BF+0x290>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  802bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd2:	83 c0 08             	add    $0x8,%eax
  802bd5:	89 45 e8             	mov    %eax,-0x18(%ebp)

	struct BlockElement *minBlk= NULL;
  802bd8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 minSize = 0xfffffff; // a large number
  802bdf:	c7 45 f0 ff ff ff 0f 	movl   $0xfffffff,-0x10(%ebp)
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802be6:	a1 48 50 98 00       	mov    0x985048,%eax
  802beb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802bee:	eb 32                	jmp    802c22 <alloc_block_BF+0x69>
	{
		uint32 blockSize = get_block_size(block);
  802bf0:	ff 75 ec             	pushl  -0x14(%ebp)
  802bf3:	e8 24 f7 ff ff       	call   80231c <get_block_size>
  802bf8:	83 c4 04             	add    $0x4,%esp
  802bfb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		// if this block can take the new block and its size < min size of all blocks
		if(blockSize >= totalSize && blockSize < minSize)
  802bfe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c01:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802c04:	72 14                	jb     802c1a <alloc_block_BF+0x61>
  802c06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c09:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802c0c:	73 0c                	jae    802c1a <alloc_block_BF+0x61>
		{
			minBlk = block;
  802c0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c11:	89 45 f4             	mov    %eax,-0xc(%ebp)
			minSize = blockSize;
  802c14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c17:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *minBlk= NULL;
	uint32 minSize = 0xfffffff; // a large number
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802c1a:	a1 50 50 98 00       	mov    0x985050,%eax
  802c1f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802c22:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c26:	74 07                	je     802c2f <alloc_block_BF+0x76>
  802c28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c2b:	8b 00                	mov    (%eax),%eax
  802c2d:	eb 05                	jmp    802c34 <alloc_block_BF+0x7b>
  802c2f:	b8 00 00 00 00       	mov    $0x0,%eax
  802c34:	a3 50 50 98 00       	mov    %eax,0x985050
  802c39:	a1 50 50 98 00       	mov    0x985050,%eax
  802c3e:	85 c0                	test   %eax,%eax
  802c40:	75 ae                	jne    802bf0 <alloc_block_BF+0x37>
  802c42:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c46:	75 a8                	jne    802bf0 <alloc_block_BF+0x37>
			minSize = blockSize;
		}
	}

	// if we don't find any enough space to allocate the block
	if(minBlk == NULL)
  802c48:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c4c:	75 22                	jne    802c70 <alloc_block_BF+0xb7>
	{
		void *newBlock = sbrk(totalSize);
  802c4e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c51:	83 ec 0c             	sub    $0xc,%esp
  802c54:	50                   	push   %eax
  802c55:	e8 5a e9 ff ff       	call   8015b4 <sbrk>
  802c5a:	83 c4 10             	add    $0x10,%esp
  802c5d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (newBlock == (void*)-1) {
  802c60:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  802c64:	75 0a                	jne    802c70 <alloc_block_BF+0xb7>
			return NULL;
  802c66:	b8 00 00 00 00       	mov    $0x0,%eax
  802c6b:	e9 d9 01 00 00       	jmp    802e49 <alloc_block_BF+0x290>
		}
	}

	//if we can put another block with min size 16
	if(minSize >= totalSize + 4*sizeof(uint32))
  802c70:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c73:	83 c0 10             	add    $0x10,%eax
  802c76:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802c79:	0f 87 32 01 00 00    	ja     802db1 <alloc_block_BF+0x1f8>
	{
		// the size that will remain from the block that we will allocate a new block in it
		uint32 remainingSize= minSize - totalSize;
  802c7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c82:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802c85:	89 45 dc             	mov    %eax,-0x24(%ebp)

		// the remaining free space from the block that we use to allocate in it
		struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)minBlk + totalSize);
  802c88:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c8b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c8e:	01 d0                	add    %edx,%eax
  802c90:	89 45 d8             	mov    %eax,-0x28(%ebp)
		set_block_data(remainingFreeBlock, remainingSize, 0);
  802c93:	83 ec 04             	sub    $0x4,%esp
  802c96:	6a 00                	push   $0x0
  802c98:	ff 75 dc             	pushl  -0x24(%ebp)
  802c9b:	ff 75 d8             	pushl  -0x28(%ebp)
  802c9e:	e8 f5 f8 ff ff       	call   802598 <set_block_data>
  802ca3:	83 c4 10             	add    $0x10,%esp
		// add it after the block we allocated to be sorted by addresses
		LIST_INSERT_AFTER(&freeBlocksList, minBlk,remainingFreeBlock);
  802ca6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802caa:	74 06                	je     802cb2 <alloc_block_BF+0xf9>
  802cac:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802cb0:	75 17                	jne    802cc9 <alloc_block_BF+0x110>
  802cb2:	83 ec 04             	sub    $0x4,%esp
  802cb5:	68 ac 44 80 00       	push   $0x8044ac
  802cba:	68 49 01 00 00       	push   $0x149
  802cbf:	68 37 44 80 00       	push   $0x804437
  802cc4:	e8 94 d8 ff ff       	call   80055d <_panic>
  802cc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccc:	8b 10                	mov    (%eax),%edx
  802cce:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802cd1:	89 10                	mov    %edx,(%eax)
  802cd3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802cd6:	8b 00                	mov    (%eax),%eax
  802cd8:	85 c0                	test   %eax,%eax
  802cda:	74 0b                	je     802ce7 <alloc_block_BF+0x12e>
  802cdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdf:	8b 00                	mov    (%eax),%eax
  802ce1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802ce4:	89 50 04             	mov    %edx,0x4(%eax)
  802ce7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cea:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802ced:	89 10                	mov    %edx,(%eax)
  802cef:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802cf2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cf5:	89 50 04             	mov    %edx,0x4(%eax)
  802cf8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802cfb:	8b 00                	mov    (%eax),%eax
  802cfd:	85 c0                	test   %eax,%eax
  802cff:	75 08                	jne    802d09 <alloc_block_BF+0x150>
  802d01:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802d04:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802d09:	a1 54 50 98 00       	mov    0x985054,%eax
  802d0e:	40                   	inc    %eax
  802d0f:	a3 54 50 98 00       	mov    %eax,0x985054

		// update the allocated block and remove it from freeBlocksList
		set_block_data(minBlk,totalSize,1);
  802d14:	83 ec 04             	sub    $0x4,%esp
  802d17:	6a 01                	push   $0x1
  802d19:	ff 75 e8             	pushl  -0x18(%ebp)
  802d1c:	ff 75 f4             	pushl  -0xc(%ebp)
  802d1f:	e8 74 f8 ff ff       	call   802598 <set_block_data>
  802d24:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  802d27:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d2b:	75 17                	jne    802d44 <alloc_block_BF+0x18b>
  802d2d:	83 ec 04             	sub    $0x4,%esp
  802d30:	68 e0 44 80 00       	push   $0x8044e0
  802d35:	68 4e 01 00 00       	push   $0x14e
  802d3a:	68 37 44 80 00       	push   $0x804437
  802d3f:	e8 19 d8 ff ff       	call   80055d <_panic>
  802d44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d47:	8b 00                	mov    (%eax),%eax
  802d49:	85 c0                	test   %eax,%eax
  802d4b:	74 10                	je     802d5d <alloc_block_BF+0x1a4>
  802d4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d50:	8b 00                	mov    (%eax),%eax
  802d52:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d55:	8b 52 04             	mov    0x4(%edx),%edx
  802d58:	89 50 04             	mov    %edx,0x4(%eax)
  802d5b:	eb 0b                	jmp    802d68 <alloc_block_BF+0x1af>
  802d5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d60:	8b 40 04             	mov    0x4(%eax),%eax
  802d63:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802d68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6b:	8b 40 04             	mov    0x4(%eax),%eax
  802d6e:	85 c0                	test   %eax,%eax
  802d70:	74 0f                	je     802d81 <alloc_block_BF+0x1c8>
  802d72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d75:	8b 40 04             	mov    0x4(%eax),%eax
  802d78:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d7b:	8b 12                	mov    (%edx),%edx
  802d7d:	89 10                	mov    %edx,(%eax)
  802d7f:	eb 0a                	jmp    802d8b <alloc_block_BF+0x1d2>
  802d81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d84:	8b 00                	mov    (%eax),%eax
  802d86:	a3 48 50 98 00       	mov    %eax,0x985048
  802d8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d97:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d9e:	a1 54 50 98 00       	mov    0x985054,%eax
  802da3:	48                   	dec    %eax
  802da4:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  802da9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dac:	e9 98 00 00 00       	jmp    802e49 <alloc_block_BF+0x290>
	}
	else // if set internal fragmentation
	{
		// add the remaining size to the block we allocate so it will be the same main block size
		set_block_data(minBlk,minSize,1);
  802db1:	83 ec 04             	sub    $0x4,%esp
  802db4:	6a 01                	push   $0x1
  802db6:	ff 75 f0             	pushl  -0x10(%ebp)
  802db9:	ff 75 f4             	pushl  -0xc(%ebp)
  802dbc:	e8 d7 f7 ff ff       	call   802598 <set_block_data>
  802dc1:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  802dc4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dc8:	75 17                	jne    802de1 <alloc_block_BF+0x228>
  802dca:	83 ec 04             	sub    $0x4,%esp
  802dcd:	68 e0 44 80 00       	push   $0x8044e0
  802dd2:	68 56 01 00 00       	push   $0x156
  802dd7:	68 37 44 80 00       	push   $0x804437
  802ddc:	e8 7c d7 ff ff       	call   80055d <_panic>
  802de1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de4:	8b 00                	mov    (%eax),%eax
  802de6:	85 c0                	test   %eax,%eax
  802de8:	74 10                	je     802dfa <alloc_block_BF+0x241>
  802dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ded:	8b 00                	mov    (%eax),%eax
  802def:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802df2:	8b 52 04             	mov    0x4(%edx),%edx
  802df5:	89 50 04             	mov    %edx,0x4(%eax)
  802df8:	eb 0b                	jmp    802e05 <alloc_block_BF+0x24c>
  802dfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfd:	8b 40 04             	mov    0x4(%eax),%eax
  802e00:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e08:	8b 40 04             	mov    0x4(%eax),%eax
  802e0b:	85 c0                	test   %eax,%eax
  802e0d:	74 0f                	je     802e1e <alloc_block_BF+0x265>
  802e0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e12:	8b 40 04             	mov    0x4(%eax),%eax
  802e15:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e18:	8b 12                	mov    (%edx),%edx
  802e1a:	89 10                	mov    %edx,(%eax)
  802e1c:	eb 0a                	jmp    802e28 <alloc_block_BF+0x26f>
  802e1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e21:	8b 00                	mov    (%eax),%eax
  802e23:	a3 48 50 98 00       	mov    %eax,0x985048
  802e28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e34:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e3b:	a1 54 50 98 00       	mov    0x985054,%eax
  802e40:	48                   	dec    %eax
  802e41:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  802e46:	8b 45 f4             	mov    -0xc(%ebp),%eax
	}
	return NULL;
}
  802e49:	c9                   	leave  
  802e4a:	c3                   	ret    

00802e4b <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802e4b:	55                   	push   %ebp
  802e4c:	89 e5                	mov    %esp,%ebp
  802e4e:	83 ec 48             	sub    $0x48,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
  802e51:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e55:	0f 84 6a 02 00 00    	je     8030c5 <free_block+0x27a>
	{
		return;
	}

	uint32 freeSize = get_block_size(va);
  802e5b:	ff 75 08             	pushl  0x8(%ebp)
  802e5e:	e8 b9 f4 ff ff       	call   80231c <get_block_size>
  802e63:	83 c4 04             	add    $0x4,%esp
  802e66:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// footer for the prev block for the block that we want to free it
	uint32 *footerPrev = ((uint32*)va - 2 );
  802e69:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6c:	83 e8 08             	sub    $0x8,%eax
  802e6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 pSize = (*footerPrev) & ~(0x1);
  802e72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e75:	8b 00                	mov    (%eax),%eax
  802e77:	83 e0 fe             	and    $0xfffffffe,%eax
  802e7a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// the prev block for the block that we want to free it
	struct BlockElement * prevBlk = (struct BlockElement *)((char*)va - pSize);
  802e7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e80:	f7 d8                	neg    %eax
  802e82:	89 c2                	mov    %eax,%edx
  802e84:	8b 45 08             	mov    0x8(%ebp),%eax
  802e87:	01 d0                	add    %edx,%eax
  802e89:	89 45 e8             	mov    %eax,-0x18(%ebp)
	uint32 isPrevFree = is_free_block(prevBlk);
  802e8c:	ff 75 e8             	pushl  -0x18(%ebp)
  802e8f:	e8 a1 f4 ff ff       	call   802335 <is_free_block>
  802e94:	83 c4 04             	add    $0x4,%esp
  802e97:	0f be c0             	movsbl %al,%eax
  802e9a:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
  802e9d:	8b 55 08             	mov    0x8(%ebp),%edx
  802ea0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea3:	01 d0                	add    %edx,%eax
  802ea5:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  802ea8:	ff 75 e0             	pushl  -0x20(%ebp)
  802eab:	e8 85 f4 ff ff       	call   802335 <is_free_block>
  802eb0:	83 c4 04             	add    $0x4,%esp
  802eb3:	0f be c0             	movsbl %al,%eax
  802eb6:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if(isPrevFree == 1 && isNextFree == 0)
  802eb9:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  802ebd:	75 34                	jne    802ef3 <free_block+0xa8>
  802ebf:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802ec3:	75 2e                	jne    802ef3 <free_block+0xa8>
	{
		// merge the block will be free with its prev block
		uint32 prevSize = get_block_size(prevBlk);
  802ec5:	ff 75 e8             	pushl  -0x18(%ebp)
  802ec8:	e8 4f f4 ff ff       	call   80231c <get_block_size>
  802ecd:	83 c4 04             	add    $0x4,%esp
  802ed0:	89 45 d8             	mov    %eax,-0x28(%ebp)
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
  802ed3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ed6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ed9:	01 d0                	add    %edx,%eax
  802edb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
  802ede:	6a 00                	push   $0x0
  802ee0:	ff 75 d4             	pushl  -0x2c(%ebp)
  802ee3:	ff 75 e8             	pushl  -0x18(%ebp)
  802ee6:	e8 ad f6 ff ff       	call   802598 <set_block_data>
  802eeb:	83 c4 0c             	add    $0xc,%esp
	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
	uint32 isNextFree = is_free_block(nextBlk);

	if(isPrevFree == 1 && isNextFree == 0)
	{
  802eee:	e9 d3 01 00 00       	jmp    8030c6 <free_block+0x27b>
		uint32 prevSize = get_block_size(prevBlk);
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
  802ef3:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  802ef7:	0f 85 c8 00 00 00    	jne    802fc5 <free_block+0x17a>
  802efd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802f01:	0f 85 be 00 00 00    	jne    802fc5 <free_block+0x17a>
	{
		// merge the block will be free with its next block
		uint32 nextSize = get_block_size(nextBlk);
  802f07:	ff 75 e0             	pushl  -0x20(%ebp)
  802f0a:	e8 0d f4 ff ff       	call   80231c <get_block_size>
  802f0f:	83 c4 04             	add    $0x4,%esp
  802f12:	89 45 d0             	mov    %eax,-0x30(%ebp)
		uint32 totalSize = freeSize + nextSize; // size of main block and its next block
  802f15:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f18:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f1b:	01 d0                	add    %edx,%eax
  802f1d:	89 45 cc             	mov    %eax,-0x34(%ebp)
		// update the size of block to contain its size and the size of next block
		set_block_data(va,totalSize,0);
  802f20:	6a 00                	push   $0x0
  802f22:	ff 75 cc             	pushl  -0x34(%ebp)
  802f25:	ff 75 08             	pushl  0x8(%ebp)
  802f28:	e8 6b f6 ff ff       	call   802598 <set_block_data>
  802f2d:	83 c4 0c             	add    $0xc,%esp
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
  802f30:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802f34:	75 17                	jne    802f4d <free_block+0x102>
  802f36:	83 ec 04             	sub    $0x4,%esp
  802f39:	68 e0 44 80 00       	push   $0x8044e0
  802f3e:	68 87 01 00 00       	push   $0x187
  802f43:	68 37 44 80 00       	push   $0x804437
  802f48:	e8 10 d6 ff ff       	call   80055d <_panic>
  802f4d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f50:	8b 00                	mov    (%eax),%eax
  802f52:	85 c0                	test   %eax,%eax
  802f54:	74 10                	je     802f66 <free_block+0x11b>
  802f56:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f59:	8b 00                	mov    (%eax),%eax
  802f5b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f5e:	8b 52 04             	mov    0x4(%edx),%edx
  802f61:	89 50 04             	mov    %edx,0x4(%eax)
  802f64:	eb 0b                	jmp    802f71 <free_block+0x126>
  802f66:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f69:	8b 40 04             	mov    0x4(%eax),%eax
  802f6c:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802f71:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f74:	8b 40 04             	mov    0x4(%eax),%eax
  802f77:	85 c0                	test   %eax,%eax
  802f79:	74 0f                	je     802f8a <free_block+0x13f>
  802f7b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f7e:	8b 40 04             	mov    0x4(%eax),%eax
  802f81:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f84:	8b 12                	mov    (%edx),%edx
  802f86:	89 10                	mov    %edx,(%eax)
  802f88:	eb 0a                	jmp    802f94 <free_block+0x149>
  802f8a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f8d:	8b 00                	mov    (%eax),%eax
  802f8f:	a3 48 50 98 00       	mov    %eax,0x985048
  802f94:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f97:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fa0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fa7:	a1 54 50 98 00       	mov    0x985054,%eax
  802fac:	48                   	dec    %eax
  802fad:	a3 54 50 98 00       	mov    %eax,0x985054
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  802fb2:	83 ec 0c             	sub    $0xc,%esp
  802fb5:	ff 75 08             	pushl  0x8(%ebp)
  802fb8:	e8 32 f6 ff ff       	call   8025ef <insert_sorted_in_freeList>
  802fbd:	83 c4 10             	add    $0x10,%esp
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
	{
  802fc0:	e9 01 01 00 00       	jmp    8030c6 <free_block+0x27b>
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
  802fc5:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  802fc9:	0f 85 d3 00 00 00    	jne    8030a2 <free_block+0x257>
  802fcf:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  802fd3:	0f 85 c9 00 00 00    	jne    8030a2 <free_block+0x257>
	{
		// merge the block will be free with its prev and next blocks
		uint32 prevSize = get_block_size(prevBlk);
  802fd9:	83 ec 0c             	sub    $0xc,%esp
  802fdc:	ff 75 e8             	pushl  -0x18(%ebp)
  802fdf:	e8 38 f3 ff ff       	call   80231c <get_block_size>
  802fe4:	83 c4 10             	add    $0x10,%esp
  802fe7:	89 45 c8             	mov    %eax,-0x38(%ebp)
		uint32 nextSize = get_block_size(nextBlk);
  802fea:	83 ec 0c             	sub    $0xc,%esp
  802fed:	ff 75 e0             	pushl  -0x20(%ebp)
  802ff0:	e8 27 f3 ff ff       	call   80231c <get_block_size>
  802ff5:	83 c4 10             	add    $0x10,%esp
  802ff8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 totalSize = freeSize + prevSize + nextSize; // size of main block and its prev and next blocks
  802ffb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ffe:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803001:	01 c2                	add    %eax,%edx
  803003:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803006:	01 d0                	add    %edx,%eax
  803008:	89 45 c0             	mov    %eax,-0x40(%ebp)
		// extends prev block size to contain its size and the size of main and next blocks
		set_block_data(prevBlk,totalSize,0);
  80300b:	83 ec 04             	sub    $0x4,%esp
  80300e:	6a 00                	push   $0x0
  803010:	ff 75 c0             	pushl  -0x40(%ebp)
  803013:	ff 75 e8             	pushl  -0x18(%ebp)
  803016:	e8 7d f5 ff ff       	call   802598 <set_block_data>
  80301b:	83 c4 10             	add    $0x10,%esp
		// remove next block because we merge it with its prev blocks
		LIST_REMOVE(&freeBlocksList, nextBlk);
  80301e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803022:	75 17                	jne    80303b <free_block+0x1f0>
  803024:	83 ec 04             	sub    $0x4,%esp
  803027:	68 e0 44 80 00       	push   $0x8044e0
  80302c:	68 94 01 00 00       	push   $0x194
  803031:	68 37 44 80 00       	push   $0x804437
  803036:	e8 22 d5 ff ff       	call   80055d <_panic>
  80303b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80303e:	8b 00                	mov    (%eax),%eax
  803040:	85 c0                	test   %eax,%eax
  803042:	74 10                	je     803054 <free_block+0x209>
  803044:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803047:	8b 00                	mov    (%eax),%eax
  803049:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80304c:	8b 52 04             	mov    0x4(%edx),%edx
  80304f:	89 50 04             	mov    %edx,0x4(%eax)
  803052:	eb 0b                	jmp    80305f <free_block+0x214>
  803054:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803057:	8b 40 04             	mov    0x4(%eax),%eax
  80305a:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80305f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803062:	8b 40 04             	mov    0x4(%eax),%eax
  803065:	85 c0                	test   %eax,%eax
  803067:	74 0f                	je     803078 <free_block+0x22d>
  803069:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80306c:	8b 40 04             	mov    0x4(%eax),%eax
  80306f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803072:	8b 12                	mov    (%edx),%edx
  803074:	89 10                	mov    %edx,(%eax)
  803076:	eb 0a                	jmp    803082 <free_block+0x237>
  803078:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80307b:	8b 00                	mov    (%eax),%eax
  80307d:	a3 48 50 98 00       	mov    %eax,0x985048
  803082:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803085:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80308b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80308e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803095:	a1 54 50 98 00       	mov    0x985054,%eax
  80309a:	48                   	dec    %eax
  80309b:	a3 54 50 98 00       	mov    %eax,0x985054
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
	{
  8030a0:	eb 24                	jmp    8030c6 <free_block+0x27b>
	}
	else
	{
		// free it without any merge
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
  8030a2:	83 ec 04             	sub    $0x4,%esp
  8030a5:	6a 00                	push   $0x0
  8030a7:	ff 75 f4             	pushl  -0xc(%ebp)
  8030aa:	ff 75 08             	pushl  0x8(%ebp)
  8030ad:	e8 e6 f4 ff ff       	call   802598 <set_block_data>
  8030b2:	83 c4 10             	add    $0x10,%esp
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  8030b5:	83 ec 0c             	sub    $0xc,%esp
  8030b8:	ff 75 08             	pushl  0x8(%ebp)
  8030bb:	e8 2f f5 ff ff       	call   8025ef <insert_sorted_in_freeList>
  8030c0:	83 c4 10             	add    $0x10,%esp
  8030c3:	eb 01                	jmp    8030c6 <free_block+0x27b>
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
	{
		return;
  8030c5:	90                   	nop
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
}
  8030c6:	c9                   	leave  
  8030c7:	c3                   	ret    

008030c8 <realloc_block_FF>:
//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
  8030c8:	55                   	push   %ebp
  8030c9:	89 e5                	mov    %esp,%ebp
  8030cb:	83 ec 38             	sub    $0x38,%esp
	//TODO: [PROJECT'24.MS1 - #08] [3] DYNAMIC ALLOCATOR - realloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(va == NULL && new_size == 0)
  8030ce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030d2:	75 10                	jne    8030e4 <realloc_block_FF+0x1c>
  8030d4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8030d8:	75 0a                	jne    8030e4 <realloc_block_FF+0x1c>
	{
		return NULL;
  8030da:	b8 00 00 00 00       	mov    $0x0,%eax
  8030df:	e9 8b 04 00 00       	jmp    80356f <realloc_block_FF+0x4a7>
	}

	if(new_size == 0)
  8030e4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8030e8:	75 18                	jne    803102 <realloc_block_FF+0x3a>
	{
		free_block(va);
  8030ea:	83 ec 0c             	sub    $0xc,%esp
  8030ed:	ff 75 08             	pushl  0x8(%ebp)
  8030f0:	e8 56 fd ff ff       	call   802e4b <free_block>
  8030f5:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8030f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8030fd:	e9 6d 04 00 00       	jmp    80356f <realloc_block_FF+0x4a7>
	}

	if(va == NULL)
  803102:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803106:	75 13                	jne    80311b <realloc_block_FF+0x53>
	{
		return alloc_block_FF(new_size);
  803108:	83 ec 0c             	sub    $0xc,%esp
  80310b:	ff 75 0c             	pushl  0xc(%ebp)
  80310e:	e8 6f f6 ff ff       	call   802782 <alloc_block_FF>
  803113:	83 c4 10             	add    $0x10,%esp
  803116:	e9 54 04 00 00       	jmp    80356f <realloc_block_FF+0x4a7>
	}

	// if size is odd must be increment it by one
	if (new_size % 2 != 0)
  80311b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80311e:	83 e0 01             	and    $0x1,%eax
  803121:	85 c0                	test   %eax,%eax
  803123:	74 03                	je     803128 <realloc_block_FF+0x60>
	{
		new_size++;
  803125:	ff 45 0c             	incl   0xc(%ebp)
	}

	// if size < 8 must be equal it to 8 because min size 8 excluding metadata
	if(new_size < 8)
  803128:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80312c:	77 07                	ja     803135 <realloc_block_FF+0x6d>
	{
		new_size = 8;
  80312e:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	}

	new_size += 8; // adds its footer and header size
  803135:	83 45 0c 08          	addl   $0x8,0xc(%ebp)

	uint32 actualSize = get_block_size(va);
  803139:	83 ec 0c             	sub    $0xc,%esp
  80313c:	ff 75 08             	pushl  0x8(%ebp)
  80313f:	e8 d8 f1 ff ff       	call   80231c <get_block_size>
  803144:	83 c4 10             	add    $0x10,%esp
  803147:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(actualSize == new_size)
  80314a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803150:	75 08                	jne    80315a <realloc_block_FF+0x92>
	{
		// don't change any thing
		return va;
  803152:	8b 45 08             	mov    0x8(%ebp),%eax
  803155:	e9 15 04 00 00       	jmp    80356f <realloc_block_FF+0x4a7>
	}

	// next block for the block we want to change its size
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + actualSize);
  80315a:	8b 55 08             	mov    0x8(%ebp),%edx
  80315d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803160:	01 d0                	add    %edx,%eax
  803162:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  803165:	83 ec 0c             	sub    $0xc,%esp
  803168:	ff 75 f0             	pushl  -0x10(%ebp)
  80316b:	e8 c5 f1 ff ff       	call   802335 <is_free_block>
  803170:	83 c4 10             	add    $0x10,%esp
  803173:	0f be c0             	movsbl %al,%eax
  803176:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 nextSize = get_block_size(nextBlk);
  803179:	83 ec 0c             	sub    $0xc,%esp
  80317c:	ff 75 f0             	pushl  -0x10(%ebp)
  80317f:	e8 98 f1 ff ff       	call   80231c <get_block_size>
  803184:	83 c4 10             	add    $0x10,%esp
  803187:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// increase the size of block
	if(new_size > actualSize)
  80318a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80318d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803190:	0f 86 a7 02 00 00    	jbe    80343d <realloc_block_FF+0x375>
	{
		if(isNextFree)
  803196:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80319a:	0f 84 86 02 00 00    	je     803426 <realloc_block_FF+0x35e>
		{
			if(nextSize + actualSize == new_size) // block and nextblock = newSizeBlock
  8031a0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a6:	01 d0                	add    %edx,%eax
  8031a8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8031ab:	0f 85 b2 00 00 00    	jne    803263 <realloc_block_FF+0x19b>
			{
				set_block_data(va,new_size,!(is_free_block(va)));// update size in block
  8031b1:	83 ec 0c             	sub    $0xc,%esp
  8031b4:	ff 75 08             	pushl  0x8(%ebp)
  8031b7:	e8 79 f1 ff ff       	call   802335 <is_free_block>
  8031bc:	83 c4 10             	add    $0x10,%esp
  8031bf:	84 c0                	test   %al,%al
  8031c1:	0f 94 c0             	sete   %al
  8031c4:	0f b6 c0             	movzbl %al,%eax
  8031c7:	83 ec 04             	sub    $0x4,%esp
  8031ca:	50                   	push   %eax
  8031cb:	ff 75 0c             	pushl  0xc(%ebp)
  8031ce:	ff 75 08             	pushl  0x8(%ebp)
  8031d1:	e8 c2 f3 ff ff       	call   802598 <set_block_data>
  8031d6:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);// remove next because it is = zero
  8031d9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031dd:	75 17                	jne    8031f6 <realloc_block_FF+0x12e>
  8031df:	83 ec 04             	sub    $0x4,%esp
  8031e2:	68 e0 44 80 00       	push   $0x8044e0
  8031e7:	68 db 01 00 00       	push   $0x1db
  8031ec:	68 37 44 80 00       	push   $0x804437
  8031f1:	e8 67 d3 ff ff       	call   80055d <_panic>
  8031f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f9:	8b 00                	mov    (%eax),%eax
  8031fb:	85 c0                	test   %eax,%eax
  8031fd:	74 10                	je     80320f <realloc_block_FF+0x147>
  8031ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803202:	8b 00                	mov    (%eax),%eax
  803204:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803207:	8b 52 04             	mov    0x4(%edx),%edx
  80320a:	89 50 04             	mov    %edx,0x4(%eax)
  80320d:	eb 0b                	jmp    80321a <realloc_block_FF+0x152>
  80320f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803212:	8b 40 04             	mov    0x4(%eax),%eax
  803215:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80321a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80321d:	8b 40 04             	mov    0x4(%eax),%eax
  803220:	85 c0                	test   %eax,%eax
  803222:	74 0f                	je     803233 <realloc_block_FF+0x16b>
  803224:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803227:	8b 40 04             	mov    0x4(%eax),%eax
  80322a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80322d:	8b 12                	mov    (%edx),%edx
  80322f:	89 10                	mov    %edx,(%eax)
  803231:	eb 0a                	jmp    80323d <realloc_block_FF+0x175>
  803233:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803236:	8b 00                	mov    (%eax),%eax
  803238:	a3 48 50 98 00       	mov    %eax,0x985048
  80323d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803240:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803246:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803249:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803250:	a1 54 50 98 00       	mov    0x985054,%eax
  803255:	48                   	dec    %eax
  803256:	a3 54 50 98 00       	mov    %eax,0x985054
				return va;
  80325b:	8b 45 08             	mov    0x8(%ebp),%eax
  80325e:	e9 0c 03 00 00       	jmp    80356f <realloc_block_FF+0x4a7>
			}
			else if(nextSize + actualSize > new_size) // new size is less than next and main blocks
  803263:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803266:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803269:	01 d0                	add    %edx,%eax
  80326b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80326e:	0f 86 b2 01 00 00    	jbe    803426 <realloc_block_FF+0x35e>
			{
				uint32 requiredSize = new_size - actualSize; // size that we need from the next block
  803274:	8b 45 0c             	mov    0xc(%ebp),%eax
  803277:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80327a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				uint32 remainingNext = nextSize - requiredSize; // size that will remain from the next block after we split it
  80327d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803280:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  803283:	89 45 e0             	mov    %eax,-0x20(%ebp)

				// if next size will not fit another block (internal fragmentation)
				if(remainingNext < 16)
  803286:	83 7d e0 0f          	cmpl   $0xf,-0x20(%ebp)
  80328a:	0f 87 b8 00 00 00    	ja     803348 <realloc_block_FF+0x280>
				{
					// we will take the main size of the block and its next size also
					set_block_data(va,actualSize + nextSize,!(is_free_block(va)));
  803290:	83 ec 0c             	sub    $0xc,%esp
  803293:	ff 75 08             	pushl  0x8(%ebp)
  803296:	e8 9a f0 ff ff       	call   802335 <is_free_block>
  80329b:	83 c4 10             	add    $0x10,%esp
  80329e:	84 c0                	test   %al,%al
  8032a0:	0f 94 c0             	sete   %al
  8032a3:	0f b6 c0             	movzbl %al,%eax
  8032a6:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8032a9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032ac:	01 ca                	add    %ecx,%edx
  8032ae:	83 ec 04             	sub    $0x4,%esp
  8032b1:	50                   	push   %eax
  8032b2:	52                   	push   %edx
  8032b3:	ff 75 08             	pushl  0x8(%ebp)
  8032b6:	e8 dd f2 ff ff       	call   802598 <set_block_data>
  8032bb:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,nextBlk);
  8032be:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8032c2:	75 17                	jne    8032db <realloc_block_FF+0x213>
  8032c4:	83 ec 04             	sub    $0x4,%esp
  8032c7:	68 e0 44 80 00       	push   $0x8044e0
  8032cc:	68 e8 01 00 00       	push   $0x1e8
  8032d1:	68 37 44 80 00       	push   $0x804437
  8032d6:	e8 82 d2 ff ff       	call   80055d <_panic>
  8032db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032de:	8b 00                	mov    (%eax),%eax
  8032e0:	85 c0                	test   %eax,%eax
  8032e2:	74 10                	je     8032f4 <realloc_block_FF+0x22c>
  8032e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032e7:	8b 00                	mov    (%eax),%eax
  8032e9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032ec:	8b 52 04             	mov    0x4(%edx),%edx
  8032ef:	89 50 04             	mov    %edx,0x4(%eax)
  8032f2:	eb 0b                	jmp    8032ff <realloc_block_FF+0x237>
  8032f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032f7:	8b 40 04             	mov    0x4(%eax),%eax
  8032fa:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8032ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803302:	8b 40 04             	mov    0x4(%eax),%eax
  803305:	85 c0                	test   %eax,%eax
  803307:	74 0f                	je     803318 <realloc_block_FF+0x250>
  803309:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80330c:	8b 40 04             	mov    0x4(%eax),%eax
  80330f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803312:	8b 12                	mov    (%edx),%edx
  803314:	89 10                	mov    %edx,(%eax)
  803316:	eb 0a                	jmp    803322 <realloc_block_FF+0x25a>
  803318:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80331b:	8b 00                	mov    (%eax),%eax
  80331d:	a3 48 50 98 00       	mov    %eax,0x985048
  803322:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803325:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80332b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80332e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803335:	a1 54 50 98 00       	mov    0x985054,%eax
  80333a:	48                   	dec    %eax
  80333b:	a3 54 50 98 00       	mov    %eax,0x985054
					return va;
  803340:	8b 45 08             	mov    0x8(%ebp),%eax
  803343:	e9 27 02 00 00       	jmp    80356f <realloc_block_FF+0x4a7>
				}
				else // if next size can be fit another block (split)
				{
					LIST_REMOVE(&freeBlocksList,nextBlk);
  803348:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80334c:	75 17                	jne    803365 <realloc_block_FF+0x29d>
  80334e:	83 ec 04             	sub    $0x4,%esp
  803351:	68 e0 44 80 00       	push   $0x8044e0
  803356:	68 ed 01 00 00       	push   $0x1ed
  80335b:	68 37 44 80 00       	push   $0x804437
  803360:	e8 f8 d1 ff ff       	call   80055d <_panic>
  803365:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803368:	8b 00                	mov    (%eax),%eax
  80336a:	85 c0                	test   %eax,%eax
  80336c:	74 10                	je     80337e <realloc_block_FF+0x2b6>
  80336e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803371:	8b 00                	mov    (%eax),%eax
  803373:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803376:	8b 52 04             	mov    0x4(%edx),%edx
  803379:	89 50 04             	mov    %edx,0x4(%eax)
  80337c:	eb 0b                	jmp    803389 <realloc_block_FF+0x2c1>
  80337e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803381:	8b 40 04             	mov    0x4(%eax),%eax
  803384:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803389:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80338c:	8b 40 04             	mov    0x4(%eax),%eax
  80338f:	85 c0                	test   %eax,%eax
  803391:	74 0f                	je     8033a2 <realloc_block_FF+0x2da>
  803393:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803396:	8b 40 04             	mov    0x4(%eax),%eax
  803399:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80339c:	8b 12                	mov    (%edx),%edx
  80339e:	89 10                	mov    %edx,(%eax)
  8033a0:	eb 0a                	jmp    8033ac <realloc_block_FF+0x2e4>
  8033a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033a5:	8b 00                	mov    (%eax),%eax
  8033a7:	a3 48 50 98 00       	mov    %eax,0x985048
  8033ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033b8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033bf:	a1 54 50 98 00       	mov    0x985054,%eax
  8033c4:	48                   	dec    %eax
  8033c5:	a3 54 50 98 00       	mov    %eax,0x985054
					nextBlk = (struct BlockElement *)((char *)va + new_size); //update nextBlk address
  8033ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8033cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033d0:	01 d0                	add    %edx,%eax
  8033d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
					set_block_data(nextBlk,remainingNext,0); // update nextBlkSize
  8033d5:	83 ec 04             	sub    $0x4,%esp
  8033d8:	6a 00                	push   $0x0
  8033da:	ff 75 e0             	pushl  -0x20(%ebp)
  8033dd:	ff 75 f0             	pushl  -0x10(%ebp)
  8033e0:	e8 b3 f1 ff ff       	call   802598 <set_block_data>
  8033e5:	83 c4 10             	add    $0x10,%esp
					set_block_data(va,new_size,!(is_free_block(va))); // update size of newblock
  8033e8:	83 ec 0c             	sub    $0xc,%esp
  8033eb:	ff 75 08             	pushl  0x8(%ebp)
  8033ee:	e8 42 ef ff ff       	call   802335 <is_free_block>
  8033f3:	83 c4 10             	add    $0x10,%esp
  8033f6:	84 c0                	test   %al,%al
  8033f8:	0f 94 c0             	sete   %al
  8033fb:	0f b6 c0             	movzbl %al,%eax
  8033fe:	83 ec 04             	sub    $0x4,%esp
  803401:	50                   	push   %eax
  803402:	ff 75 0c             	pushl  0xc(%ebp)
  803405:	ff 75 08             	pushl  0x8(%ebp)
  803408:	e8 8b f1 ff ff       	call   802598 <set_block_data>
  80340d:	83 c4 10             	add    $0x10,%esp
					insert_sorted_in_freeList(nextBlk);
  803410:	83 ec 0c             	sub    $0xc,%esp
  803413:	ff 75 f0             	pushl  -0x10(%ebp)
  803416:	e8 d4 f1 ff ff       	call   8025ef <insert_sorted_in_freeList>
  80341b:	83 c4 10             	add    $0x10,%esp
					return va;
  80341e:	8b 45 08             	mov    0x8(%ebp),%eax
  803421:	e9 49 01 00 00       	jmp    80356f <realloc_block_FF+0x4a7>
				}
			}
		}
		// if next block isn't free or not fit the new size
		return alloc_block_FF(new_size - 8);
  803426:	8b 45 0c             	mov    0xc(%ebp),%eax
  803429:	83 e8 08             	sub    $0x8,%eax
  80342c:	83 ec 0c             	sub    $0xc,%esp
  80342f:	50                   	push   %eax
  803430:	e8 4d f3 ff ff       	call   802782 <alloc_block_FF>
  803435:	83 c4 10             	add    $0x10,%esp
  803438:	e9 32 01 00 00       	jmp    80356f <realloc_block_FF+0x4a7>
	}
	else if(new_size < actualSize) // to shrink block
  80343d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803440:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803443:	0f 83 21 01 00 00    	jae    80356a <realloc_block_FF+0x4a2>
	{
		uint32 remainingSize = actualSize - new_size; // size that will remain from the main block after we shrink it
  803449:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80344c:	2b 45 0c             	sub    0xc(%ebp),%eax
  80344f:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(remainingSize < 16 && isNextFree == 0) // internal fragmentation
  803452:	83 7d dc 0f          	cmpl   $0xf,-0x24(%ebp)
  803456:	77 0e                	ja     803466 <realloc_block_FF+0x39e>
  803458:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80345c:	75 08                	jne    803466 <realloc_block_FF+0x39e>
		{
			// don't change its size
			return va;
  80345e:	8b 45 08             	mov    0x8(%ebp),%eax
  803461:	e9 09 01 00 00       	jmp    80356f <realloc_block_FF+0x4a7>
		}
		else // remainingSize fit in a new block
		{
			struct BlockElement *mainBlk = (struct BlockElement *)va;
  803466:	8b 45 08             	mov    0x8(%ebp),%eax
  803469:	89 45 d8             	mov    %eax,-0x28(%ebp)
			// update main block with new size
			set_block_data(mainBlk,new_size,!(is_free_block(va)));
  80346c:	83 ec 0c             	sub    $0xc,%esp
  80346f:	ff 75 08             	pushl  0x8(%ebp)
  803472:	e8 be ee ff ff       	call   802335 <is_free_block>
  803477:	83 c4 10             	add    $0x10,%esp
  80347a:	84 c0                	test   %al,%al
  80347c:	0f 94 c0             	sete   %al
  80347f:	0f b6 c0             	movzbl %al,%eax
  803482:	83 ec 04             	sub    $0x4,%esp
  803485:	50                   	push   %eax
  803486:	ff 75 0c             	pushl  0xc(%ebp)
  803489:	ff 75 d8             	pushl  -0x28(%ebp)
  80348c:	e8 07 f1 ff ff       	call   802598 <set_block_data>
  803491:	83 c4 10             	add    $0x10,%esp

			// the blk with remaining size
			struct BlockElement *remainingBlk=(struct BlockElement *)((char*)mainBlk + new_size);
  803494:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803497:	8b 45 0c             	mov    0xc(%ebp),%eax
  80349a:	01 d0                	add    %edx,%eax
  80349c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			set_block_data(remainingBlk,remainingSize,0);
  80349f:	83 ec 04             	sub    $0x4,%esp
  8034a2:	6a 00                	push   $0x0
  8034a4:	ff 75 dc             	pushl  -0x24(%ebp)
  8034a7:	ff 75 d4             	pushl  -0x2c(%ebp)
  8034aa:	e8 e9 f0 ff ff       	call   802598 <set_block_data>
  8034af:	83 c4 10             	add    $0x10,%esp

			if(isNextFree)
  8034b2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8034b6:	0f 84 9b 00 00 00    	je     803557 <realloc_block_FF+0x48f>
			{
				// merge splited block with its next block
				set_block_data(remainingBlk,(remainingSize + nextSize),0);//merge remaining with its next block
  8034bc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8034bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034c2:	01 d0                	add    %edx,%eax
  8034c4:	83 ec 04             	sub    $0x4,%esp
  8034c7:	6a 00                	push   $0x0
  8034c9:	50                   	push   %eax
  8034ca:	ff 75 d4             	pushl  -0x2c(%ebp)
  8034cd:	e8 c6 f0 ff ff       	call   802598 <set_block_data>
  8034d2:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);
  8034d5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8034d9:	75 17                	jne    8034f2 <realloc_block_FF+0x42a>
  8034db:	83 ec 04             	sub    $0x4,%esp
  8034de:	68 e0 44 80 00       	push   $0x8044e0
  8034e3:	68 10 02 00 00       	push   $0x210
  8034e8:	68 37 44 80 00       	push   $0x804437
  8034ed:	e8 6b d0 ff ff       	call   80055d <_panic>
  8034f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034f5:	8b 00                	mov    (%eax),%eax
  8034f7:	85 c0                	test   %eax,%eax
  8034f9:	74 10                	je     80350b <realloc_block_FF+0x443>
  8034fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034fe:	8b 00                	mov    (%eax),%eax
  803500:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803503:	8b 52 04             	mov    0x4(%edx),%edx
  803506:	89 50 04             	mov    %edx,0x4(%eax)
  803509:	eb 0b                	jmp    803516 <realloc_block_FF+0x44e>
  80350b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80350e:	8b 40 04             	mov    0x4(%eax),%eax
  803511:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803516:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803519:	8b 40 04             	mov    0x4(%eax),%eax
  80351c:	85 c0                	test   %eax,%eax
  80351e:	74 0f                	je     80352f <realloc_block_FF+0x467>
  803520:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803523:	8b 40 04             	mov    0x4(%eax),%eax
  803526:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803529:	8b 12                	mov    (%edx),%edx
  80352b:	89 10                	mov    %edx,(%eax)
  80352d:	eb 0a                	jmp    803539 <realloc_block_FF+0x471>
  80352f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803532:	8b 00                	mov    (%eax),%eax
  803534:	a3 48 50 98 00       	mov    %eax,0x985048
  803539:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80353c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803542:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803545:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80354c:	a1 54 50 98 00       	mov    0x985054,%eax
  803551:	48                   	dec    %eax
  803552:	a3 54 50 98 00       	mov    %eax,0x985054
			}
			insert_sorted_in_freeList(remainingBlk);
  803557:	83 ec 0c             	sub    $0xc,%esp
  80355a:	ff 75 d4             	pushl  -0x2c(%ebp)
  80355d:	e8 8d f0 ff ff       	call   8025ef <insert_sorted_in_freeList>
  803562:	83 c4 10             	add    $0x10,%esp
			return mainBlk;
  803565:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803568:	eb 05                	jmp    80356f <realloc_block_FF+0x4a7>
		}
	}
	return NULL;
  80356a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80356f:	c9                   	leave  
  803570:	c3                   	ret    

00803571 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803571:	55                   	push   %ebp
  803572:	89 e5                	mov    %esp,%ebp
  803574:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803577:	83 ec 04             	sub    $0x4,%esp
  80357a:	68 00 45 80 00       	push   $0x804500
  80357f:	68 20 02 00 00       	push   $0x220
  803584:	68 37 44 80 00       	push   $0x804437
  803589:	e8 cf cf ff ff       	call   80055d <_panic>

0080358e <alloc_block_NF>:
}
//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  80358e:	55                   	push   %ebp
  80358f:	89 e5                	mov    %esp,%ebp
  803591:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803594:	83 ec 04             	sub    $0x4,%esp
  803597:	68 28 45 80 00       	push   $0x804528
  80359c:	68 28 02 00 00       	push   $0x228
  8035a1:	68 37 44 80 00       	push   $0x804437
  8035a6:	e8 b2 cf ff ff       	call   80055d <_panic>

008035ab <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8035ab:	55                   	push   %ebp
  8035ac:	89 e5                	mov    %esp,%ebp
  8035ae:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8035b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8035b4:	89 d0                	mov    %edx,%eax
  8035b6:	c1 e0 02             	shl    $0x2,%eax
  8035b9:	01 d0                	add    %edx,%eax
  8035bb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8035c2:	01 d0                	add    %edx,%eax
  8035c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8035cb:	01 d0                	add    %edx,%eax
  8035cd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8035d4:	01 d0                	add    %edx,%eax
  8035d6:	c1 e0 04             	shl    $0x4,%eax
  8035d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8035dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8035e3:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8035e6:	83 ec 0c             	sub    $0xc,%esp
  8035e9:	50                   	push   %eax
  8035ea:	e8 c5 e9 ff ff       	call   801fb4 <sys_get_virtual_time>
  8035ef:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8035f2:	eb 41                	jmp    803635 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8035f4:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8035f7:	83 ec 0c             	sub    $0xc,%esp
  8035fa:	50                   	push   %eax
  8035fb:	e8 b4 e9 ff ff       	call   801fb4 <sys_get_virtual_time>
  803600:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803603:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803606:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803609:	29 c2                	sub    %eax,%edx
  80360b:	89 d0                	mov    %edx,%eax
  80360d:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803610:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803613:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803616:	89 d1                	mov    %edx,%ecx
  803618:	29 c1                	sub    %eax,%ecx
  80361a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80361d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803620:	39 c2                	cmp    %eax,%edx
  803622:	0f 97 c0             	seta   %al
  803625:	0f b6 c0             	movzbl %al,%eax
  803628:	29 c1                	sub    %eax,%ecx
  80362a:	89 c8                	mov    %ecx,%eax
  80362c:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80362f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803632:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803638:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80363b:	72 b7                	jb     8035f4 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80363d:	90                   	nop
  80363e:	c9                   	leave  
  80363f:	c3                   	ret    

00803640 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803640:	55                   	push   %ebp
  803641:	89 e5                	mov    %esp,%ebp
  803643:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803646:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80364d:	eb 03                	jmp    803652 <busy_wait+0x12>
  80364f:	ff 45 fc             	incl   -0x4(%ebp)
  803652:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803655:	3b 45 08             	cmp    0x8(%ebp),%eax
  803658:	72 f5                	jb     80364f <busy_wait+0xf>
	return i;
  80365a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80365d:	c9                   	leave  
  80365e:	c3                   	ret    
  80365f:	90                   	nop

00803660 <__udivdi3>:
  803660:	55                   	push   %ebp
  803661:	57                   	push   %edi
  803662:	56                   	push   %esi
  803663:	53                   	push   %ebx
  803664:	83 ec 1c             	sub    $0x1c,%esp
  803667:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80366b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80366f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803673:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803677:	89 ca                	mov    %ecx,%edx
  803679:	89 f8                	mov    %edi,%eax
  80367b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80367f:	85 f6                	test   %esi,%esi
  803681:	75 2d                	jne    8036b0 <__udivdi3+0x50>
  803683:	39 cf                	cmp    %ecx,%edi
  803685:	77 65                	ja     8036ec <__udivdi3+0x8c>
  803687:	89 fd                	mov    %edi,%ebp
  803689:	85 ff                	test   %edi,%edi
  80368b:	75 0b                	jne    803698 <__udivdi3+0x38>
  80368d:	b8 01 00 00 00       	mov    $0x1,%eax
  803692:	31 d2                	xor    %edx,%edx
  803694:	f7 f7                	div    %edi
  803696:	89 c5                	mov    %eax,%ebp
  803698:	31 d2                	xor    %edx,%edx
  80369a:	89 c8                	mov    %ecx,%eax
  80369c:	f7 f5                	div    %ebp
  80369e:	89 c1                	mov    %eax,%ecx
  8036a0:	89 d8                	mov    %ebx,%eax
  8036a2:	f7 f5                	div    %ebp
  8036a4:	89 cf                	mov    %ecx,%edi
  8036a6:	89 fa                	mov    %edi,%edx
  8036a8:	83 c4 1c             	add    $0x1c,%esp
  8036ab:	5b                   	pop    %ebx
  8036ac:	5e                   	pop    %esi
  8036ad:	5f                   	pop    %edi
  8036ae:	5d                   	pop    %ebp
  8036af:	c3                   	ret    
  8036b0:	39 ce                	cmp    %ecx,%esi
  8036b2:	77 28                	ja     8036dc <__udivdi3+0x7c>
  8036b4:	0f bd fe             	bsr    %esi,%edi
  8036b7:	83 f7 1f             	xor    $0x1f,%edi
  8036ba:	75 40                	jne    8036fc <__udivdi3+0x9c>
  8036bc:	39 ce                	cmp    %ecx,%esi
  8036be:	72 0a                	jb     8036ca <__udivdi3+0x6a>
  8036c0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8036c4:	0f 87 9e 00 00 00    	ja     803768 <__udivdi3+0x108>
  8036ca:	b8 01 00 00 00       	mov    $0x1,%eax
  8036cf:	89 fa                	mov    %edi,%edx
  8036d1:	83 c4 1c             	add    $0x1c,%esp
  8036d4:	5b                   	pop    %ebx
  8036d5:	5e                   	pop    %esi
  8036d6:	5f                   	pop    %edi
  8036d7:	5d                   	pop    %ebp
  8036d8:	c3                   	ret    
  8036d9:	8d 76 00             	lea    0x0(%esi),%esi
  8036dc:	31 ff                	xor    %edi,%edi
  8036de:	31 c0                	xor    %eax,%eax
  8036e0:	89 fa                	mov    %edi,%edx
  8036e2:	83 c4 1c             	add    $0x1c,%esp
  8036e5:	5b                   	pop    %ebx
  8036e6:	5e                   	pop    %esi
  8036e7:	5f                   	pop    %edi
  8036e8:	5d                   	pop    %ebp
  8036e9:	c3                   	ret    
  8036ea:	66 90                	xchg   %ax,%ax
  8036ec:	89 d8                	mov    %ebx,%eax
  8036ee:	f7 f7                	div    %edi
  8036f0:	31 ff                	xor    %edi,%edi
  8036f2:	89 fa                	mov    %edi,%edx
  8036f4:	83 c4 1c             	add    $0x1c,%esp
  8036f7:	5b                   	pop    %ebx
  8036f8:	5e                   	pop    %esi
  8036f9:	5f                   	pop    %edi
  8036fa:	5d                   	pop    %ebp
  8036fb:	c3                   	ret    
  8036fc:	bd 20 00 00 00       	mov    $0x20,%ebp
  803701:	89 eb                	mov    %ebp,%ebx
  803703:	29 fb                	sub    %edi,%ebx
  803705:	89 f9                	mov    %edi,%ecx
  803707:	d3 e6                	shl    %cl,%esi
  803709:	89 c5                	mov    %eax,%ebp
  80370b:	88 d9                	mov    %bl,%cl
  80370d:	d3 ed                	shr    %cl,%ebp
  80370f:	89 e9                	mov    %ebp,%ecx
  803711:	09 f1                	or     %esi,%ecx
  803713:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803717:	89 f9                	mov    %edi,%ecx
  803719:	d3 e0                	shl    %cl,%eax
  80371b:	89 c5                	mov    %eax,%ebp
  80371d:	89 d6                	mov    %edx,%esi
  80371f:	88 d9                	mov    %bl,%cl
  803721:	d3 ee                	shr    %cl,%esi
  803723:	89 f9                	mov    %edi,%ecx
  803725:	d3 e2                	shl    %cl,%edx
  803727:	8b 44 24 08          	mov    0x8(%esp),%eax
  80372b:	88 d9                	mov    %bl,%cl
  80372d:	d3 e8                	shr    %cl,%eax
  80372f:	09 c2                	or     %eax,%edx
  803731:	89 d0                	mov    %edx,%eax
  803733:	89 f2                	mov    %esi,%edx
  803735:	f7 74 24 0c          	divl   0xc(%esp)
  803739:	89 d6                	mov    %edx,%esi
  80373b:	89 c3                	mov    %eax,%ebx
  80373d:	f7 e5                	mul    %ebp
  80373f:	39 d6                	cmp    %edx,%esi
  803741:	72 19                	jb     80375c <__udivdi3+0xfc>
  803743:	74 0b                	je     803750 <__udivdi3+0xf0>
  803745:	89 d8                	mov    %ebx,%eax
  803747:	31 ff                	xor    %edi,%edi
  803749:	e9 58 ff ff ff       	jmp    8036a6 <__udivdi3+0x46>
  80374e:	66 90                	xchg   %ax,%ax
  803750:	8b 54 24 08          	mov    0x8(%esp),%edx
  803754:	89 f9                	mov    %edi,%ecx
  803756:	d3 e2                	shl    %cl,%edx
  803758:	39 c2                	cmp    %eax,%edx
  80375a:	73 e9                	jae    803745 <__udivdi3+0xe5>
  80375c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80375f:	31 ff                	xor    %edi,%edi
  803761:	e9 40 ff ff ff       	jmp    8036a6 <__udivdi3+0x46>
  803766:	66 90                	xchg   %ax,%ax
  803768:	31 c0                	xor    %eax,%eax
  80376a:	e9 37 ff ff ff       	jmp    8036a6 <__udivdi3+0x46>
  80376f:	90                   	nop

00803770 <__umoddi3>:
  803770:	55                   	push   %ebp
  803771:	57                   	push   %edi
  803772:	56                   	push   %esi
  803773:	53                   	push   %ebx
  803774:	83 ec 1c             	sub    $0x1c,%esp
  803777:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80377b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80377f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803783:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803787:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80378b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80378f:	89 f3                	mov    %esi,%ebx
  803791:	89 fa                	mov    %edi,%edx
  803793:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803797:	89 34 24             	mov    %esi,(%esp)
  80379a:	85 c0                	test   %eax,%eax
  80379c:	75 1a                	jne    8037b8 <__umoddi3+0x48>
  80379e:	39 f7                	cmp    %esi,%edi
  8037a0:	0f 86 a2 00 00 00    	jbe    803848 <__umoddi3+0xd8>
  8037a6:	89 c8                	mov    %ecx,%eax
  8037a8:	89 f2                	mov    %esi,%edx
  8037aa:	f7 f7                	div    %edi
  8037ac:	89 d0                	mov    %edx,%eax
  8037ae:	31 d2                	xor    %edx,%edx
  8037b0:	83 c4 1c             	add    $0x1c,%esp
  8037b3:	5b                   	pop    %ebx
  8037b4:	5e                   	pop    %esi
  8037b5:	5f                   	pop    %edi
  8037b6:	5d                   	pop    %ebp
  8037b7:	c3                   	ret    
  8037b8:	39 f0                	cmp    %esi,%eax
  8037ba:	0f 87 ac 00 00 00    	ja     80386c <__umoddi3+0xfc>
  8037c0:	0f bd e8             	bsr    %eax,%ebp
  8037c3:	83 f5 1f             	xor    $0x1f,%ebp
  8037c6:	0f 84 ac 00 00 00    	je     803878 <__umoddi3+0x108>
  8037cc:	bf 20 00 00 00       	mov    $0x20,%edi
  8037d1:	29 ef                	sub    %ebp,%edi
  8037d3:	89 fe                	mov    %edi,%esi
  8037d5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8037d9:	89 e9                	mov    %ebp,%ecx
  8037db:	d3 e0                	shl    %cl,%eax
  8037dd:	89 d7                	mov    %edx,%edi
  8037df:	89 f1                	mov    %esi,%ecx
  8037e1:	d3 ef                	shr    %cl,%edi
  8037e3:	09 c7                	or     %eax,%edi
  8037e5:	89 e9                	mov    %ebp,%ecx
  8037e7:	d3 e2                	shl    %cl,%edx
  8037e9:	89 14 24             	mov    %edx,(%esp)
  8037ec:	89 d8                	mov    %ebx,%eax
  8037ee:	d3 e0                	shl    %cl,%eax
  8037f0:	89 c2                	mov    %eax,%edx
  8037f2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037f6:	d3 e0                	shl    %cl,%eax
  8037f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8037fc:	8b 44 24 08          	mov    0x8(%esp),%eax
  803800:	89 f1                	mov    %esi,%ecx
  803802:	d3 e8                	shr    %cl,%eax
  803804:	09 d0                	or     %edx,%eax
  803806:	d3 eb                	shr    %cl,%ebx
  803808:	89 da                	mov    %ebx,%edx
  80380a:	f7 f7                	div    %edi
  80380c:	89 d3                	mov    %edx,%ebx
  80380e:	f7 24 24             	mull   (%esp)
  803811:	89 c6                	mov    %eax,%esi
  803813:	89 d1                	mov    %edx,%ecx
  803815:	39 d3                	cmp    %edx,%ebx
  803817:	0f 82 87 00 00 00    	jb     8038a4 <__umoddi3+0x134>
  80381d:	0f 84 91 00 00 00    	je     8038b4 <__umoddi3+0x144>
  803823:	8b 54 24 04          	mov    0x4(%esp),%edx
  803827:	29 f2                	sub    %esi,%edx
  803829:	19 cb                	sbb    %ecx,%ebx
  80382b:	89 d8                	mov    %ebx,%eax
  80382d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803831:	d3 e0                	shl    %cl,%eax
  803833:	89 e9                	mov    %ebp,%ecx
  803835:	d3 ea                	shr    %cl,%edx
  803837:	09 d0                	or     %edx,%eax
  803839:	89 e9                	mov    %ebp,%ecx
  80383b:	d3 eb                	shr    %cl,%ebx
  80383d:	89 da                	mov    %ebx,%edx
  80383f:	83 c4 1c             	add    $0x1c,%esp
  803842:	5b                   	pop    %ebx
  803843:	5e                   	pop    %esi
  803844:	5f                   	pop    %edi
  803845:	5d                   	pop    %ebp
  803846:	c3                   	ret    
  803847:	90                   	nop
  803848:	89 fd                	mov    %edi,%ebp
  80384a:	85 ff                	test   %edi,%edi
  80384c:	75 0b                	jne    803859 <__umoddi3+0xe9>
  80384e:	b8 01 00 00 00       	mov    $0x1,%eax
  803853:	31 d2                	xor    %edx,%edx
  803855:	f7 f7                	div    %edi
  803857:	89 c5                	mov    %eax,%ebp
  803859:	89 f0                	mov    %esi,%eax
  80385b:	31 d2                	xor    %edx,%edx
  80385d:	f7 f5                	div    %ebp
  80385f:	89 c8                	mov    %ecx,%eax
  803861:	f7 f5                	div    %ebp
  803863:	89 d0                	mov    %edx,%eax
  803865:	e9 44 ff ff ff       	jmp    8037ae <__umoddi3+0x3e>
  80386a:	66 90                	xchg   %ax,%ax
  80386c:	89 c8                	mov    %ecx,%eax
  80386e:	89 f2                	mov    %esi,%edx
  803870:	83 c4 1c             	add    $0x1c,%esp
  803873:	5b                   	pop    %ebx
  803874:	5e                   	pop    %esi
  803875:	5f                   	pop    %edi
  803876:	5d                   	pop    %ebp
  803877:	c3                   	ret    
  803878:	3b 04 24             	cmp    (%esp),%eax
  80387b:	72 06                	jb     803883 <__umoddi3+0x113>
  80387d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803881:	77 0f                	ja     803892 <__umoddi3+0x122>
  803883:	89 f2                	mov    %esi,%edx
  803885:	29 f9                	sub    %edi,%ecx
  803887:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80388b:	89 14 24             	mov    %edx,(%esp)
  80388e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803892:	8b 44 24 04          	mov    0x4(%esp),%eax
  803896:	8b 14 24             	mov    (%esp),%edx
  803899:	83 c4 1c             	add    $0x1c,%esp
  80389c:	5b                   	pop    %ebx
  80389d:	5e                   	pop    %esi
  80389e:	5f                   	pop    %edi
  80389f:	5d                   	pop    %ebp
  8038a0:	c3                   	ret    
  8038a1:	8d 76 00             	lea    0x0(%esi),%esi
  8038a4:	2b 04 24             	sub    (%esp),%eax
  8038a7:	19 fa                	sbb    %edi,%edx
  8038a9:	89 d1                	mov    %edx,%ecx
  8038ab:	89 c6                	mov    %eax,%esi
  8038ad:	e9 71 ff ff ff       	jmp    803823 <__umoddi3+0xb3>
  8038b2:	66 90                	xchg   %ax,%ax
  8038b4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8038b8:	72 ea                	jb     8038a4 <__umoddi3+0x134>
  8038ba:	89 d9                	mov    %ebx,%ecx
  8038bc:	e9 62 ff ff ff       	jmp    803823 <__umoddi3+0xb3>
