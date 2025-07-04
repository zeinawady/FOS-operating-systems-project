
obj/user/tst_sharing_3:     file format elf32-i386


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
  800031:	e8 45 02 00 00       	call   80027b <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the SPECIAL CASES during the creation & get of shared variables
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 38             	sub    $0x38,%esp
	/*=================================================*/
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  80003e:	a1 20 50 80 00       	mov    0x805020,%eax
  800043:	8b 90 a0 00 00 00    	mov    0xa0(%eax),%edx
  800049:	a1 20 50 80 00       	mov    0x805020,%eax
  80004e:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  800054:	39 c2                	cmp    %eax,%edx
  800056:	72 14                	jb     80006c <_main+0x34>
			panic("Please increase the WS size");
  800058:	83 ec 04             	sub    $0x4,%esp
  80005b:	68 80 36 80 00       	push   $0x803680
  800060:	6a 0c                	push   $0xc
  800062:	68 9c 36 80 00       	push   $0x80369c
  800067:	e8 54 03 00 00       	call   8003c0 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	cprintf("************************************************\n");
  80006c:	83 ec 0c             	sub    $0xc,%esp
  80006f:	68 b4 36 80 00       	push   $0x8036b4
  800074:	e8 04 06 00 00       	call   80067d <cprintf>
  800079:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  80007c:	83 ec 0c             	sub    $0xc,%esp
  80007f:	68 e8 36 80 00       	push   $0x8036e8
  800084:	e8 f4 05 00 00       	call   80067d <cprintf>
  800089:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  80008c:	83 ec 0c             	sub    $0xc,%esp
  80008f:	68 44 37 80 00       	push   $0x803744
  800094:	e8 e4 05 00 00       	call   80067d <cprintf>
  800099:	83 c4 10             	add    $0x10,%esp

	int eval = 0;
  80009c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool is_correct = 1;
  8000a3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  8000aa:	c7 45 ec 00 10 00 82 	movl   $0x82001000,-0x14(%ebp)

	uint32 *x, *y, *z ;
	cprintf("STEP A: checking creation of shared object that is already exists... [35%] \n\n");
  8000b1:	83 ec 0c             	sub    $0xc,%esp
  8000b4:	68 78 37 80 00       	push   $0x803778
  8000b9:	e8 bf 05 00 00       	call   80067d <cprintf>
  8000be:	83 c4 10             	add    $0x10,%esp
	{
		int ret ;
		//int ret = sys_createSharedObject("x", PAGE_SIZE, 1, (void*)&x);
		x = smalloc("x", PAGE_SIZE, 1);
  8000c1:	83 ec 04             	sub    $0x4,%esp
  8000c4:	6a 01                	push   $0x1
  8000c6:	68 00 10 00 00       	push   $0x1000
  8000cb:	68 c6 37 80 00       	push   $0x8037c6
  8000d0:	e8 0f 16 00 00       	call   8016e4 <smalloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 e8             	mov    %eax,-0x18(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  8000db:	e8 22 1b 00 00       	call   801c02 <sys_calculate_free_frames>
  8000e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000e3:	83 ec 04             	sub    $0x4,%esp
  8000e6:	6a 01                	push   $0x1
  8000e8:	68 00 10 00 00       	push   $0x1000
  8000ed:	68 c6 37 80 00       	push   $0x8037c6
  8000f2:	e8 ed 15 00 00       	call   8016e4 <smalloc>
  8000f7:	83 c4 10             	add    $0x10,%esp
  8000fa:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (x != NULL) {is_correct = 0; cprintf("Trying to create an already exists object and corresponding error is not returned!!");}
  8000fd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800101:	74 17                	je     80011a <_main+0xe2>
  800103:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80010a:	83 ec 0c             	sub    $0xc,%esp
  80010d:	68 c8 37 80 00       	push   $0x8037c8
  800112:	e8 66 05 00 00       	call   80067d <cprintf>
  800117:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) {is_correct = 0; cprintf("Wrong allocation: make sure that you don't allocate any memory if the shared object exists");}
  80011a:	e8 e3 1a 00 00       	call   801c02 <sys_calculate_free_frames>
  80011f:	89 c2                	mov    %eax,%edx
  800121:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800124:	39 c2                	cmp    %eax,%edx
  800126:	74 17                	je     80013f <_main+0x107>
  800128:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80012f:	83 ec 0c             	sub    $0xc,%esp
  800132:	68 1c 38 80 00       	push   $0x80381c
  800137:	e8 41 05 00 00       	call   80067d <cprintf>
  80013c:	83 c4 10             	add    $0x10,%esp
	}
	if (is_correct)	eval+=35;
  80013f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800143:	74 04                	je     800149 <_main+0x111>
  800145:	83 45 f4 23          	addl   $0x23,-0xc(%ebp)
	is_correct = 1;
  800149:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	cprintf("STEP B: checking getting shared object that is NOT exists... [35%]\n\n");
  800150:	83 ec 0c             	sub    $0xc,%esp
  800153:	68 78 38 80 00       	push   $0x803878
  800158:	e8 20 05 00 00       	call   80067d <cprintf>
  80015d:	83 c4 10             	add    $0x10,%esp
	{
		int ret ;
		x = sget(myEnv->env_id, "xx");
  800160:	a1 20 50 80 00       	mov    0x805020,%eax
  800165:	8b 40 10             	mov    0x10(%eax),%eax
  800168:	83 ec 08             	sub    $0x8,%esp
  80016b:	68 bd 38 80 00       	push   $0x8038bd
  800170:	50                   	push   %eax
  800171:	e8 09 17 00 00       	call   80187f <sget>
  800176:	83 c4 10             	add    $0x10,%esp
  800179:	89 45 e8             	mov    %eax,-0x18(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  80017c:	e8 81 1a 00 00       	call   801c02 <sys_calculate_free_frames>
  800181:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (x != NULL) {is_correct = 0; cprintf("Trying to get a NON existing object and corresponding error is not returned!!");}
  800184:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800188:	74 17                	je     8001a1 <_main+0x169>
  80018a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800191:	83 ec 0c             	sub    $0xc,%esp
  800194:	68 c0 38 80 00       	push   $0x8038c0
  800199:	e8 df 04 00 00       	call   80067d <cprintf>
  80019e:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) {is_correct = 0; cprintf("Wrong get: make sure that you don't allocate any memory if the shared object not exists");}
  8001a1:	e8 5c 1a 00 00       	call   801c02 <sys_calculate_free_frames>
  8001a6:	89 c2                	mov    %eax,%edx
  8001a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001ab:	39 c2                	cmp    %eax,%edx
  8001ad:	74 17                	je     8001c6 <_main+0x18e>
  8001af:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001b6:	83 ec 0c             	sub    $0xc,%esp
  8001b9:	68 10 39 80 00       	push   $0x803910
  8001be:	e8 ba 04 00 00       	call   80067d <cprintf>
  8001c3:	83 c4 10             	add    $0x10,%esp
	}
	if (is_correct)	eval+=35;
  8001c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8001ca:	74 04                	je     8001d0 <_main+0x198>
  8001cc:	83 45 f4 23          	addl   $0x23,-0xc(%ebp)
	is_correct = 1;
  8001d0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	cprintf("STEP C: checking the creation of shared object that exceeds the SHARED area limit... [30%]\n\n");
  8001d7:	83 ec 0c             	sub    $0xc,%esp
  8001da:	68 68 39 80 00       	push   $0x803968
  8001df:	e8 99 04 00 00       	call   80067d <cprintf>
  8001e4:	83 c4 10             	add    $0x10,%esp
	{
		int freeFrames = sys_calculate_free_frames() ;
  8001e7:	e8 16 1a 00 00       	call   801c02 <sys_calculate_free_frames>
  8001ec:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uint32 size = USER_HEAP_MAX - pagealloc_start - PAGE_SIZE + 1;
  8001ef:	b8 01 f0 ff 9f       	mov    $0x9ffff001,%eax
  8001f4:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8001f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
		y = smalloc("y", size, 1);
  8001fa:	83 ec 04             	sub    $0x4,%esp
  8001fd:	6a 01                	push   $0x1
  8001ff:	ff 75 d8             	pushl  -0x28(%ebp)
  800202:	68 c5 39 80 00       	push   $0x8039c5
  800207:	e8 d8 14 00 00       	call   8016e4 <smalloc>
  80020c:	83 c4 10             	add    $0x10,%esp
  80020f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (y != NULL) {is_correct = 0; cprintf("Trying to create a shared object that exceed the SHARED area limit and the corresponding error is not returned!!");}
  800212:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800216:	74 17                	je     80022f <_main+0x1f7>
  800218:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80021f:	83 ec 0c             	sub    $0xc,%esp
  800222:	68 c8 39 80 00       	push   $0x8039c8
  800227:	e8 51 04 00 00       	call   80067d <cprintf>
  80022c:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) {is_correct = 0; cprintf("Wrong allocation: make sure that you don't allocate any memory if the shared object exceed the SHARED area limit");}
  80022f:	e8 ce 19 00 00       	call   801c02 <sys_calculate_free_frames>
  800234:	89 c2                	mov    %eax,%edx
  800236:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800239:	39 c2                	cmp    %eax,%edx
  80023b:	74 17                	je     800254 <_main+0x21c>
  80023d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 3c 3a 80 00       	push   $0x803a3c
  80024c:	e8 2c 04 00 00       	call   80067d <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
	}
	if (is_correct)	eval+=30;
  800254:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800258:	74 04                	je     80025e <_main+0x226>
  80025a:	83 45 f4 1e          	addl   $0x1e,-0xc(%ebp)
	is_correct = 1;
  80025e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	cprintf("\n%~Test of Shared Variables [Create & Get: Special Cases] completed. Eval = %d%%\n\n", eval);
  800265:	83 ec 08             	sub    $0x8,%esp
  800268:	ff 75 f4             	pushl  -0xc(%ebp)
  80026b:	68 b0 3a 80 00       	push   $0x803ab0
  800270:	e8 08 04 00 00       	call   80067d <cprintf>
  800275:	83 c4 10             	add    $0x10,%esp

}
  800278:	90                   	nop
  800279:	c9                   	leave  
  80027a:	c3                   	ret    

0080027b <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80027b:	55                   	push   %ebp
  80027c:	89 e5                	mov    %esp,%ebp
  80027e:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800281:	e8 45 1b 00 00       	call   801dcb <sys_getenvindex>
  800286:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800289:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80028c:	89 d0                	mov    %edx,%eax
  80028e:	c1 e0 02             	shl    $0x2,%eax
  800291:	01 d0                	add    %edx,%eax
  800293:	c1 e0 03             	shl    $0x3,%eax
  800296:	01 d0                	add    %edx,%eax
  800298:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80029f:	01 d0                	add    %edx,%eax
  8002a1:	c1 e0 02             	shl    $0x2,%eax
  8002a4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002a9:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002ae:	a1 20 50 80 00       	mov    0x805020,%eax
  8002b3:	8a 40 20             	mov    0x20(%eax),%al
  8002b6:	84 c0                	test   %al,%al
  8002b8:	74 0d                	je     8002c7 <libmain+0x4c>
		binaryname = myEnv->prog_name;
  8002ba:	a1 20 50 80 00       	mov    0x805020,%eax
  8002bf:	83 c0 20             	add    $0x20,%eax
  8002c2:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002c7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002cb:	7e 0a                	jle    8002d7 <libmain+0x5c>
		binaryname = argv[0];
  8002cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d0:	8b 00                	mov    (%eax),%eax
  8002d2:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  8002d7:	83 ec 08             	sub    $0x8,%esp
  8002da:	ff 75 0c             	pushl  0xc(%ebp)
  8002dd:	ff 75 08             	pushl  0x8(%ebp)
  8002e0:	e8 53 fd ff ff       	call   800038 <_main>
  8002e5:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8002e8:	a1 00 50 80 00       	mov    0x805000,%eax
  8002ed:	85 c0                	test   %eax,%eax
  8002ef:	0f 84 9f 00 00 00    	je     800394 <libmain+0x119>
	{
		sys_lock_cons();
  8002f5:	e8 55 18 00 00       	call   801b4f <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8002fa:	83 ec 0c             	sub    $0xc,%esp
  8002fd:	68 1c 3b 80 00       	push   $0x803b1c
  800302:	e8 76 03 00 00       	call   80067d <cprintf>
  800307:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80030a:	a1 20 50 80 00       	mov    0x805020,%eax
  80030f:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800315:	a1 20 50 80 00       	mov    0x805020,%eax
  80031a:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800320:	83 ec 04             	sub    $0x4,%esp
  800323:	52                   	push   %edx
  800324:	50                   	push   %eax
  800325:	68 44 3b 80 00       	push   $0x803b44
  80032a:	e8 4e 03 00 00       	call   80067d <cprintf>
  80032f:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800332:	a1 20 50 80 00       	mov    0x805020,%eax
  800337:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  80033d:	a1 20 50 80 00       	mov    0x805020,%eax
  800342:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800348:	a1 20 50 80 00       	mov    0x805020,%eax
  80034d:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800353:	51                   	push   %ecx
  800354:	52                   	push   %edx
  800355:	50                   	push   %eax
  800356:	68 6c 3b 80 00       	push   $0x803b6c
  80035b:	e8 1d 03 00 00       	call   80067d <cprintf>
  800360:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800363:	a1 20 50 80 00       	mov    0x805020,%eax
  800368:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  80036e:	83 ec 08             	sub    $0x8,%esp
  800371:	50                   	push   %eax
  800372:	68 c4 3b 80 00       	push   $0x803bc4
  800377:	e8 01 03 00 00       	call   80067d <cprintf>
  80037c:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80037f:	83 ec 0c             	sub    $0xc,%esp
  800382:	68 1c 3b 80 00       	push   $0x803b1c
  800387:	e8 f1 02 00 00       	call   80067d <cprintf>
  80038c:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80038f:	e8 d5 17 00 00       	call   801b69 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800394:	e8 19 00 00 00       	call   8003b2 <exit>
}
  800399:	90                   	nop
  80039a:	c9                   	leave  
  80039b:	c3                   	ret    

0080039c <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80039c:	55                   	push   %ebp
  80039d:	89 e5                	mov    %esp,%ebp
  80039f:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8003a2:	83 ec 0c             	sub    $0xc,%esp
  8003a5:	6a 00                	push   $0x0
  8003a7:	e8 eb 19 00 00       	call   801d97 <sys_destroy_env>
  8003ac:	83 c4 10             	add    $0x10,%esp
}
  8003af:	90                   	nop
  8003b0:	c9                   	leave  
  8003b1:	c3                   	ret    

008003b2 <exit>:

void
exit(void)
{
  8003b2:	55                   	push   %ebp
  8003b3:	89 e5                	mov    %esp,%ebp
  8003b5:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8003b8:	e8 40 1a 00 00       	call   801dfd <sys_exit_env>
}
  8003bd:	90                   	nop
  8003be:	c9                   	leave  
  8003bf:	c3                   	ret    

008003c0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8003c0:	55                   	push   %ebp
  8003c1:	89 e5                	mov    %esp,%ebp
  8003c3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8003c6:	8d 45 10             	lea    0x10(%ebp),%eax
  8003c9:	83 c0 04             	add    $0x4,%eax
  8003cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8003cf:	a1 60 50 98 00       	mov    0x985060,%eax
  8003d4:	85 c0                	test   %eax,%eax
  8003d6:	74 16                	je     8003ee <_panic+0x2e>
		cprintf("%s: ", argv0);
  8003d8:	a1 60 50 98 00       	mov    0x985060,%eax
  8003dd:	83 ec 08             	sub    $0x8,%esp
  8003e0:	50                   	push   %eax
  8003e1:	68 d8 3b 80 00       	push   $0x803bd8
  8003e6:	e8 92 02 00 00       	call   80067d <cprintf>
  8003eb:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003ee:	a1 04 50 80 00       	mov    0x805004,%eax
  8003f3:	ff 75 0c             	pushl  0xc(%ebp)
  8003f6:	ff 75 08             	pushl  0x8(%ebp)
  8003f9:	50                   	push   %eax
  8003fa:	68 dd 3b 80 00       	push   $0x803bdd
  8003ff:	e8 79 02 00 00       	call   80067d <cprintf>
  800404:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800407:	8b 45 10             	mov    0x10(%ebp),%eax
  80040a:	83 ec 08             	sub    $0x8,%esp
  80040d:	ff 75 f4             	pushl  -0xc(%ebp)
  800410:	50                   	push   %eax
  800411:	e8 fc 01 00 00       	call   800612 <vcprintf>
  800416:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800419:	83 ec 08             	sub    $0x8,%esp
  80041c:	6a 00                	push   $0x0
  80041e:	68 f9 3b 80 00       	push   $0x803bf9
  800423:	e8 ea 01 00 00       	call   800612 <vcprintf>
  800428:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80042b:	e8 82 ff ff ff       	call   8003b2 <exit>

	// should not return here
	while (1) ;
  800430:	eb fe                	jmp    800430 <_panic+0x70>

00800432 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800432:	55                   	push   %ebp
  800433:	89 e5                	mov    %esp,%ebp
  800435:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800438:	a1 20 50 80 00       	mov    0x805020,%eax
  80043d:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800443:	8b 45 0c             	mov    0xc(%ebp),%eax
  800446:	39 c2                	cmp    %eax,%edx
  800448:	74 14                	je     80045e <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80044a:	83 ec 04             	sub    $0x4,%esp
  80044d:	68 fc 3b 80 00       	push   $0x803bfc
  800452:	6a 26                	push   $0x26
  800454:	68 48 3c 80 00       	push   $0x803c48
  800459:	e8 62 ff ff ff       	call   8003c0 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80045e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800465:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80046c:	e9 c5 00 00 00       	jmp    800536 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800471:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800474:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80047b:	8b 45 08             	mov    0x8(%ebp),%eax
  80047e:	01 d0                	add    %edx,%eax
  800480:	8b 00                	mov    (%eax),%eax
  800482:	85 c0                	test   %eax,%eax
  800484:	75 08                	jne    80048e <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800486:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800489:	e9 a5 00 00 00       	jmp    800533 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80048e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800495:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80049c:	eb 69                	jmp    800507 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80049e:	a1 20 50 80 00       	mov    0x805020,%eax
  8004a3:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8004a9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004ac:	89 d0                	mov    %edx,%eax
  8004ae:	01 c0                	add    %eax,%eax
  8004b0:	01 d0                	add    %edx,%eax
  8004b2:	c1 e0 03             	shl    $0x3,%eax
  8004b5:	01 c8                	add    %ecx,%eax
  8004b7:	8a 40 04             	mov    0x4(%eax),%al
  8004ba:	84 c0                	test   %al,%al
  8004bc:	75 46                	jne    800504 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004be:	a1 20 50 80 00       	mov    0x805020,%eax
  8004c3:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8004c9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004cc:	89 d0                	mov    %edx,%eax
  8004ce:	01 c0                	add    %eax,%eax
  8004d0:	01 d0                	add    %edx,%eax
  8004d2:	c1 e0 03             	shl    $0x3,%eax
  8004d5:	01 c8                	add    %ecx,%eax
  8004d7:	8b 00                	mov    (%eax),%eax
  8004d9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004df:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8004e4:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8004e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004e9:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f3:	01 c8                	add    %ecx,%eax
  8004f5:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004f7:	39 c2                	cmp    %eax,%edx
  8004f9:	75 09                	jne    800504 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8004fb:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800502:	eb 15                	jmp    800519 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800504:	ff 45 e8             	incl   -0x18(%ebp)
  800507:	a1 20 50 80 00       	mov    0x805020,%eax
  80050c:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800512:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800515:	39 c2                	cmp    %eax,%edx
  800517:	77 85                	ja     80049e <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800519:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80051d:	75 14                	jne    800533 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80051f:	83 ec 04             	sub    $0x4,%esp
  800522:	68 54 3c 80 00       	push   $0x803c54
  800527:	6a 3a                	push   $0x3a
  800529:	68 48 3c 80 00       	push   $0x803c48
  80052e:	e8 8d fe ff ff       	call   8003c0 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800533:	ff 45 f0             	incl   -0x10(%ebp)
  800536:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800539:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80053c:	0f 8c 2f ff ff ff    	jl     800471 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800542:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800549:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800550:	eb 26                	jmp    800578 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800552:	a1 20 50 80 00       	mov    0x805020,%eax
  800557:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  80055d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800560:	89 d0                	mov    %edx,%eax
  800562:	01 c0                	add    %eax,%eax
  800564:	01 d0                	add    %edx,%eax
  800566:	c1 e0 03             	shl    $0x3,%eax
  800569:	01 c8                	add    %ecx,%eax
  80056b:	8a 40 04             	mov    0x4(%eax),%al
  80056e:	3c 01                	cmp    $0x1,%al
  800570:	75 03                	jne    800575 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800572:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800575:	ff 45 e0             	incl   -0x20(%ebp)
  800578:	a1 20 50 80 00       	mov    0x805020,%eax
  80057d:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800583:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800586:	39 c2                	cmp    %eax,%edx
  800588:	77 c8                	ja     800552 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80058a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80058d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800590:	74 14                	je     8005a6 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800592:	83 ec 04             	sub    $0x4,%esp
  800595:	68 a8 3c 80 00       	push   $0x803ca8
  80059a:	6a 44                	push   $0x44
  80059c:	68 48 3c 80 00       	push   $0x803c48
  8005a1:	e8 1a fe ff ff       	call   8003c0 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8005a6:	90                   	nop
  8005a7:	c9                   	leave  
  8005a8:	c3                   	ret    

008005a9 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8005a9:	55                   	push   %ebp
  8005aa:	89 e5                	mov    %esp,%ebp
  8005ac:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8005af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005b2:	8b 00                	mov    (%eax),%eax
  8005b4:	8d 48 01             	lea    0x1(%eax),%ecx
  8005b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ba:	89 0a                	mov    %ecx,(%edx)
  8005bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8005bf:	88 d1                	mov    %dl,%cl
  8005c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005c4:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8005c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005cb:	8b 00                	mov    (%eax),%eax
  8005cd:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005d2:	75 2c                	jne    800600 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8005d4:	a0 44 50 98 00       	mov    0x985044,%al
  8005d9:	0f b6 c0             	movzbl %al,%eax
  8005dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005df:	8b 12                	mov    (%edx),%edx
  8005e1:	89 d1                	mov    %edx,%ecx
  8005e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005e6:	83 c2 08             	add    $0x8,%edx
  8005e9:	83 ec 04             	sub    $0x4,%esp
  8005ec:	50                   	push   %eax
  8005ed:	51                   	push   %ecx
  8005ee:	52                   	push   %edx
  8005ef:	e8 19 15 00 00       	call   801b0d <sys_cputs>
  8005f4:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800600:	8b 45 0c             	mov    0xc(%ebp),%eax
  800603:	8b 40 04             	mov    0x4(%eax),%eax
  800606:	8d 50 01             	lea    0x1(%eax),%edx
  800609:	8b 45 0c             	mov    0xc(%ebp),%eax
  80060c:	89 50 04             	mov    %edx,0x4(%eax)
}
  80060f:	90                   	nop
  800610:	c9                   	leave  
  800611:	c3                   	ret    

00800612 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800612:	55                   	push   %ebp
  800613:	89 e5                	mov    %esp,%ebp
  800615:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80061b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800622:	00 00 00 
	b.cnt = 0;
  800625:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80062c:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80062f:	ff 75 0c             	pushl  0xc(%ebp)
  800632:	ff 75 08             	pushl  0x8(%ebp)
  800635:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80063b:	50                   	push   %eax
  80063c:	68 a9 05 80 00       	push   $0x8005a9
  800641:	e8 11 02 00 00       	call   800857 <vprintfmt>
  800646:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800649:	a0 44 50 98 00       	mov    0x985044,%al
  80064e:	0f b6 c0             	movzbl %al,%eax
  800651:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800657:	83 ec 04             	sub    $0x4,%esp
  80065a:	50                   	push   %eax
  80065b:	52                   	push   %edx
  80065c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800662:	83 c0 08             	add    $0x8,%eax
  800665:	50                   	push   %eax
  800666:	e8 a2 14 00 00       	call   801b0d <sys_cputs>
  80066b:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80066e:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
	return b.cnt;
  800675:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80067b:	c9                   	leave  
  80067c:	c3                   	ret    

0080067d <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80067d:	55                   	push   %ebp
  80067e:	89 e5                	mov    %esp,%ebp
  800680:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800683:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
	va_start(ap, fmt);
  80068a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80068d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800690:	8b 45 08             	mov    0x8(%ebp),%eax
  800693:	83 ec 08             	sub    $0x8,%esp
  800696:	ff 75 f4             	pushl  -0xc(%ebp)
  800699:	50                   	push   %eax
  80069a:	e8 73 ff ff ff       	call   800612 <vcprintf>
  80069f:	83 c4 10             	add    $0x10,%esp
  8006a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006a8:	c9                   	leave  
  8006a9:	c3                   	ret    

008006aa <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8006aa:	55                   	push   %ebp
  8006ab:	89 e5                	mov    %esp,%ebp
  8006ad:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8006b0:	e8 9a 14 00 00       	call   801b4f <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8006b5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8006bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006be:	83 ec 08             	sub    $0x8,%esp
  8006c1:	ff 75 f4             	pushl  -0xc(%ebp)
  8006c4:	50                   	push   %eax
  8006c5:	e8 48 ff ff ff       	call   800612 <vcprintf>
  8006ca:	83 c4 10             	add    $0x10,%esp
  8006cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8006d0:	e8 94 14 00 00       	call   801b69 <sys_unlock_cons>
	return cnt;
  8006d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006d8:	c9                   	leave  
  8006d9:	c3                   	ret    

008006da <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006da:	55                   	push   %ebp
  8006db:	89 e5                	mov    %esp,%ebp
  8006dd:	53                   	push   %ebx
  8006de:	83 ec 14             	sub    $0x14,%esp
  8006e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8006e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006ed:	8b 45 18             	mov    0x18(%ebp),%eax
  8006f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8006f5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006f8:	77 55                	ja     80074f <printnum+0x75>
  8006fa:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006fd:	72 05                	jb     800704 <printnum+0x2a>
  8006ff:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800702:	77 4b                	ja     80074f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800704:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800707:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80070a:	8b 45 18             	mov    0x18(%ebp),%eax
  80070d:	ba 00 00 00 00       	mov    $0x0,%edx
  800712:	52                   	push   %edx
  800713:	50                   	push   %eax
  800714:	ff 75 f4             	pushl  -0xc(%ebp)
  800717:	ff 75 f0             	pushl  -0x10(%ebp)
  80071a:	e8 f1 2c 00 00       	call   803410 <__udivdi3>
  80071f:	83 c4 10             	add    $0x10,%esp
  800722:	83 ec 04             	sub    $0x4,%esp
  800725:	ff 75 20             	pushl  0x20(%ebp)
  800728:	53                   	push   %ebx
  800729:	ff 75 18             	pushl  0x18(%ebp)
  80072c:	52                   	push   %edx
  80072d:	50                   	push   %eax
  80072e:	ff 75 0c             	pushl  0xc(%ebp)
  800731:	ff 75 08             	pushl  0x8(%ebp)
  800734:	e8 a1 ff ff ff       	call   8006da <printnum>
  800739:	83 c4 20             	add    $0x20,%esp
  80073c:	eb 1a                	jmp    800758 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80073e:	83 ec 08             	sub    $0x8,%esp
  800741:	ff 75 0c             	pushl  0xc(%ebp)
  800744:	ff 75 20             	pushl  0x20(%ebp)
  800747:	8b 45 08             	mov    0x8(%ebp),%eax
  80074a:	ff d0                	call   *%eax
  80074c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80074f:	ff 4d 1c             	decl   0x1c(%ebp)
  800752:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800756:	7f e6                	jg     80073e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800758:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80075b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800760:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800763:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800766:	53                   	push   %ebx
  800767:	51                   	push   %ecx
  800768:	52                   	push   %edx
  800769:	50                   	push   %eax
  80076a:	e8 b1 2d 00 00       	call   803520 <__umoddi3>
  80076f:	83 c4 10             	add    $0x10,%esp
  800772:	05 14 3f 80 00       	add    $0x803f14,%eax
  800777:	8a 00                	mov    (%eax),%al
  800779:	0f be c0             	movsbl %al,%eax
  80077c:	83 ec 08             	sub    $0x8,%esp
  80077f:	ff 75 0c             	pushl  0xc(%ebp)
  800782:	50                   	push   %eax
  800783:	8b 45 08             	mov    0x8(%ebp),%eax
  800786:	ff d0                	call   *%eax
  800788:	83 c4 10             	add    $0x10,%esp
}
  80078b:	90                   	nop
  80078c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80078f:	c9                   	leave  
  800790:	c3                   	ret    

00800791 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800791:	55                   	push   %ebp
  800792:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800794:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800798:	7e 1c                	jle    8007b6 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80079a:	8b 45 08             	mov    0x8(%ebp),%eax
  80079d:	8b 00                	mov    (%eax),%eax
  80079f:	8d 50 08             	lea    0x8(%eax),%edx
  8007a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a5:	89 10                	mov    %edx,(%eax)
  8007a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007aa:	8b 00                	mov    (%eax),%eax
  8007ac:	83 e8 08             	sub    $0x8,%eax
  8007af:	8b 50 04             	mov    0x4(%eax),%edx
  8007b2:	8b 00                	mov    (%eax),%eax
  8007b4:	eb 40                	jmp    8007f6 <getuint+0x65>
	else if (lflag)
  8007b6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007ba:	74 1e                	je     8007da <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bf:	8b 00                	mov    (%eax),%eax
  8007c1:	8d 50 04             	lea    0x4(%eax),%edx
  8007c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c7:	89 10                	mov    %edx,(%eax)
  8007c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cc:	8b 00                	mov    (%eax),%eax
  8007ce:	83 e8 04             	sub    $0x4,%eax
  8007d1:	8b 00                	mov    (%eax),%eax
  8007d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d8:	eb 1c                	jmp    8007f6 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8007da:	8b 45 08             	mov    0x8(%ebp),%eax
  8007dd:	8b 00                	mov    (%eax),%eax
  8007df:	8d 50 04             	lea    0x4(%eax),%edx
  8007e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e5:	89 10                	mov    %edx,(%eax)
  8007e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ea:	8b 00                	mov    (%eax),%eax
  8007ec:	83 e8 04             	sub    $0x4,%eax
  8007ef:	8b 00                	mov    (%eax),%eax
  8007f1:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007f6:	5d                   	pop    %ebp
  8007f7:	c3                   	ret    

008007f8 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007f8:	55                   	push   %ebp
  8007f9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007fb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007ff:	7e 1c                	jle    80081d <getint+0x25>
		return va_arg(*ap, long long);
  800801:	8b 45 08             	mov    0x8(%ebp),%eax
  800804:	8b 00                	mov    (%eax),%eax
  800806:	8d 50 08             	lea    0x8(%eax),%edx
  800809:	8b 45 08             	mov    0x8(%ebp),%eax
  80080c:	89 10                	mov    %edx,(%eax)
  80080e:	8b 45 08             	mov    0x8(%ebp),%eax
  800811:	8b 00                	mov    (%eax),%eax
  800813:	83 e8 08             	sub    $0x8,%eax
  800816:	8b 50 04             	mov    0x4(%eax),%edx
  800819:	8b 00                	mov    (%eax),%eax
  80081b:	eb 38                	jmp    800855 <getint+0x5d>
	else if (lflag)
  80081d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800821:	74 1a                	je     80083d <getint+0x45>
		return va_arg(*ap, long);
  800823:	8b 45 08             	mov    0x8(%ebp),%eax
  800826:	8b 00                	mov    (%eax),%eax
  800828:	8d 50 04             	lea    0x4(%eax),%edx
  80082b:	8b 45 08             	mov    0x8(%ebp),%eax
  80082e:	89 10                	mov    %edx,(%eax)
  800830:	8b 45 08             	mov    0x8(%ebp),%eax
  800833:	8b 00                	mov    (%eax),%eax
  800835:	83 e8 04             	sub    $0x4,%eax
  800838:	8b 00                	mov    (%eax),%eax
  80083a:	99                   	cltd   
  80083b:	eb 18                	jmp    800855 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80083d:	8b 45 08             	mov    0x8(%ebp),%eax
  800840:	8b 00                	mov    (%eax),%eax
  800842:	8d 50 04             	lea    0x4(%eax),%edx
  800845:	8b 45 08             	mov    0x8(%ebp),%eax
  800848:	89 10                	mov    %edx,(%eax)
  80084a:	8b 45 08             	mov    0x8(%ebp),%eax
  80084d:	8b 00                	mov    (%eax),%eax
  80084f:	83 e8 04             	sub    $0x4,%eax
  800852:	8b 00                	mov    (%eax),%eax
  800854:	99                   	cltd   
}
  800855:	5d                   	pop    %ebp
  800856:	c3                   	ret    

00800857 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800857:	55                   	push   %ebp
  800858:	89 e5                	mov    %esp,%ebp
  80085a:	56                   	push   %esi
  80085b:	53                   	push   %ebx
  80085c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80085f:	eb 17                	jmp    800878 <vprintfmt+0x21>
			if (ch == '\0')
  800861:	85 db                	test   %ebx,%ebx
  800863:	0f 84 c1 03 00 00    	je     800c2a <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800869:	83 ec 08             	sub    $0x8,%esp
  80086c:	ff 75 0c             	pushl  0xc(%ebp)
  80086f:	53                   	push   %ebx
  800870:	8b 45 08             	mov    0x8(%ebp),%eax
  800873:	ff d0                	call   *%eax
  800875:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800878:	8b 45 10             	mov    0x10(%ebp),%eax
  80087b:	8d 50 01             	lea    0x1(%eax),%edx
  80087e:	89 55 10             	mov    %edx,0x10(%ebp)
  800881:	8a 00                	mov    (%eax),%al
  800883:	0f b6 d8             	movzbl %al,%ebx
  800886:	83 fb 25             	cmp    $0x25,%ebx
  800889:	75 d6                	jne    800861 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80088b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80088f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800896:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80089d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008a4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ae:	8d 50 01             	lea    0x1(%eax),%edx
  8008b1:	89 55 10             	mov    %edx,0x10(%ebp)
  8008b4:	8a 00                	mov    (%eax),%al
  8008b6:	0f b6 d8             	movzbl %al,%ebx
  8008b9:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008bc:	83 f8 5b             	cmp    $0x5b,%eax
  8008bf:	0f 87 3d 03 00 00    	ja     800c02 <vprintfmt+0x3ab>
  8008c5:	8b 04 85 38 3f 80 00 	mov    0x803f38(,%eax,4),%eax
  8008cc:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008ce:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8008d2:	eb d7                	jmp    8008ab <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008d4:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8008d8:	eb d1                	jmp    8008ab <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008da:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8008e1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008e4:	89 d0                	mov    %edx,%eax
  8008e6:	c1 e0 02             	shl    $0x2,%eax
  8008e9:	01 d0                	add    %edx,%eax
  8008eb:	01 c0                	add    %eax,%eax
  8008ed:	01 d8                	add    %ebx,%eax
  8008ef:	83 e8 30             	sub    $0x30,%eax
  8008f2:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8008f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8008f8:	8a 00                	mov    (%eax),%al
  8008fa:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008fd:	83 fb 2f             	cmp    $0x2f,%ebx
  800900:	7e 3e                	jle    800940 <vprintfmt+0xe9>
  800902:	83 fb 39             	cmp    $0x39,%ebx
  800905:	7f 39                	jg     800940 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800907:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80090a:	eb d5                	jmp    8008e1 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80090c:	8b 45 14             	mov    0x14(%ebp),%eax
  80090f:	83 c0 04             	add    $0x4,%eax
  800912:	89 45 14             	mov    %eax,0x14(%ebp)
  800915:	8b 45 14             	mov    0x14(%ebp),%eax
  800918:	83 e8 04             	sub    $0x4,%eax
  80091b:	8b 00                	mov    (%eax),%eax
  80091d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800920:	eb 1f                	jmp    800941 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800922:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800926:	79 83                	jns    8008ab <vprintfmt+0x54>
				width = 0;
  800928:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80092f:	e9 77 ff ff ff       	jmp    8008ab <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800934:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80093b:	e9 6b ff ff ff       	jmp    8008ab <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800940:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800941:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800945:	0f 89 60 ff ff ff    	jns    8008ab <vprintfmt+0x54>
				width = precision, precision = -1;
  80094b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80094e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800951:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800958:	e9 4e ff ff ff       	jmp    8008ab <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80095d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800960:	e9 46 ff ff ff       	jmp    8008ab <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800965:	8b 45 14             	mov    0x14(%ebp),%eax
  800968:	83 c0 04             	add    $0x4,%eax
  80096b:	89 45 14             	mov    %eax,0x14(%ebp)
  80096e:	8b 45 14             	mov    0x14(%ebp),%eax
  800971:	83 e8 04             	sub    $0x4,%eax
  800974:	8b 00                	mov    (%eax),%eax
  800976:	83 ec 08             	sub    $0x8,%esp
  800979:	ff 75 0c             	pushl  0xc(%ebp)
  80097c:	50                   	push   %eax
  80097d:	8b 45 08             	mov    0x8(%ebp),%eax
  800980:	ff d0                	call   *%eax
  800982:	83 c4 10             	add    $0x10,%esp
			break;
  800985:	e9 9b 02 00 00       	jmp    800c25 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80098a:	8b 45 14             	mov    0x14(%ebp),%eax
  80098d:	83 c0 04             	add    $0x4,%eax
  800990:	89 45 14             	mov    %eax,0x14(%ebp)
  800993:	8b 45 14             	mov    0x14(%ebp),%eax
  800996:	83 e8 04             	sub    $0x4,%eax
  800999:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80099b:	85 db                	test   %ebx,%ebx
  80099d:	79 02                	jns    8009a1 <vprintfmt+0x14a>
				err = -err;
  80099f:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009a1:	83 fb 64             	cmp    $0x64,%ebx
  8009a4:	7f 0b                	jg     8009b1 <vprintfmt+0x15a>
  8009a6:	8b 34 9d 80 3d 80 00 	mov    0x803d80(,%ebx,4),%esi
  8009ad:	85 f6                	test   %esi,%esi
  8009af:	75 19                	jne    8009ca <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009b1:	53                   	push   %ebx
  8009b2:	68 25 3f 80 00       	push   $0x803f25
  8009b7:	ff 75 0c             	pushl  0xc(%ebp)
  8009ba:	ff 75 08             	pushl  0x8(%ebp)
  8009bd:	e8 70 02 00 00       	call   800c32 <printfmt>
  8009c2:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009c5:	e9 5b 02 00 00       	jmp    800c25 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009ca:	56                   	push   %esi
  8009cb:	68 2e 3f 80 00       	push   $0x803f2e
  8009d0:	ff 75 0c             	pushl  0xc(%ebp)
  8009d3:	ff 75 08             	pushl  0x8(%ebp)
  8009d6:	e8 57 02 00 00       	call   800c32 <printfmt>
  8009db:	83 c4 10             	add    $0x10,%esp
			break;
  8009de:	e9 42 02 00 00       	jmp    800c25 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e6:	83 c0 04             	add    $0x4,%eax
  8009e9:	89 45 14             	mov    %eax,0x14(%ebp)
  8009ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ef:	83 e8 04             	sub    $0x4,%eax
  8009f2:	8b 30                	mov    (%eax),%esi
  8009f4:	85 f6                	test   %esi,%esi
  8009f6:	75 05                	jne    8009fd <vprintfmt+0x1a6>
				p = "(null)";
  8009f8:	be 31 3f 80 00       	mov    $0x803f31,%esi
			if (width > 0 && padc != '-')
  8009fd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a01:	7e 6d                	jle    800a70 <vprintfmt+0x219>
  800a03:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a07:	74 67                	je     800a70 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a09:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a0c:	83 ec 08             	sub    $0x8,%esp
  800a0f:	50                   	push   %eax
  800a10:	56                   	push   %esi
  800a11:	e8 1e 03 00 00       	call   800d34 <strnlen>
  800a16:	83 c4 10             	add    $0x10,%esp
  800a19:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a1c:	eb 16                	jmp    800a34 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a1e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a22:	83 ec 08             	sub    $0x8,%esp
  800a25:	ff 75 0c             	pushl  0xc(%ebp)
  800a28:	50                   	push   %eax
  800a29:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2c:	ff d0                	call   *%eax
  800a2e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a31:	ff 4d e4             	decl   -0x1c(%ebp)
  800a34:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a38:	7f e4                	jg     800a1e <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a3a:	eb 34                	jmp    800a70 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a3c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a40:	74 1c                	je     800a5e <vprintfmt+0x207>
  800a42:	83 fb 1f             	cmp    $0x1f,%ebx
  800a45:	7e 05                	jle    800a4c <vprintfmt+0x1f5>
  800a47:	83 fb 7e             	cmp    $0x7e,%ebx
  800a4a:	7e 12                	jle    800a5e <vprintfmt+0x207>
					putch('?', putdat);
  800a4c:	83 ec 08             	sub    $0x8,%esp
  800a4f:	ff 75 0c             	pushl  0xc(%ebp)
  800a52:	6a 3f                	push   $0x3f
  800a54:	8b 45 08             	mov    0x8(%ebp),%eax
  800a57:	ff d0                	call   *%eax
  800a59:	83 c4 10             	add    $0x10,%esp
  800a5c:	eb 0f                	jmp    800a6d <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a5e:	83 ec 08             	sub    $0x8,%esp
  800a61:	ff 75 0c             	pushl  0xc(%ebp)
  800a64:	53                   	push   %ebx
  800a65:	8b 45 08             	mov    0x8(%ebp),%eax
  800a68:	ff d0                	call   *%eax
  800a6a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a6d:	ff 4d e4             	decl   -0x1c(%ebp)
  800a70:	89 f0                	mov    %esi,%eax
  800a72:	8d 70 01             	lea    0x1(%eax),%esi
  800a75:	8a 00                	mov    (%eax),%al
  800a77:	0f be d8             	movsbl %al,%ebx
  800a7a:	85 db                	test   %ebx,%ebx
  800a7c:	74 24                	je     800aa2 <vprintfmt+0x24b>
  800a7e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a82:	78 b8                	js     800a3c <vprintfmt+0x1e5>
  800a84:	ff 4d e0             	decl   -0x20(%ebp)
  800a87:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a8b:	79 af                	jns    800a3c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a8d:	eb 13                	jmp    800aa2 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a8f:	83 ec 08             	sub    $0x8,%esp
  800a92:	ff 75 0c             	pushl  0xc(%ebp)
  800a95:	6a 20                	push   $0x20
  800a97:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9a:	ff d0                	call   *%eax
  800a9c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a9f:	ff 4d e4             	decl   -0x1c(%ebp)
  800aa2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800aa6:	7f e7                	jg     800a8f <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800aa8:	e9 78 01 00 00       	jmp    800c25 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800aad:	83 ec 08             	sub    $0x8,%esp
  800ab0:	ff 75 e8             	pushl  -0x18(%ebp)
  800ab3:	8d 45 14             	lea    0x14(%ebp),%eax
  800ab6:	50                   	push   %eax
  800ab7:	e8 3c fd ff ff       	call   8007f8 <getint>
  800abc:	83 c4 10             	add    $0x10,%esp
  800abf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ac2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ac5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ac8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800acb:	85 d2                	test   %edx,%edx
  800acd:	79 23                	jns    800af2 <vprintfmt+0x29b>
				putch('-', putdat);
  800acf:	83 ec 08             	sub    $0x8,%esp
  800ad2:	ff 75 0c             	pushl  0xc(%ebp)
  800ad5:	6a 2d                	push   $0x2d
  800ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  800ada:	ff d0                	call   *%eax
  800adc:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800adf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ae2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ae5:	f7 d8                	neg    %eax
  800ae7:	83 d2 00             	adc    $0x0,%edx
  800aea:	f7 da                	neg    %edx
  800aec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aef:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800af2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800af9:	e9 bc 00 00 00       	jmp    800bba <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800afe:	83 ec 08             	sub    $0x8,%esp
  800b01:	ff 75 e8             	pushl  -0x18(%ebp)
  800b04:	8d 45 14             	lea    0x14(%ebp),%eax
  800b07:	50                   	push   %eax
  800b08:	e8 84 fc ff ff       	call   800791 <getuint>
  800b0d:	83 c4 10             	add    $0x10,%esp
  800b10:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b13:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b16:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b1d:	e9 98 00 00 00       	jmp    800bba <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b22:	83 ec 08             	sub    $0x8,%esp
  800b25:	ff 75 0c             	pushl  0xc(%ebp)
  800b28:	6a 58                	push   $0x58
  800b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2d:	ff d0                	call   *%eax
  800b2f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b32:	83 ec 08             	sub    $0x8,%esp
  800b35:	ff 75 0c             	pushl  0xc(%ebp)
  800b38:	6a 58                	push   $0x58
  800b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3d:	ff d0                	call   *%eax
  800b3f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b42:	83 ec 08             	sub    $0x8,%esp
  800b45:	ff 75 0c             	pushl  0xc(%ebp)
  800b48:	6a 58                	push   $0x58
  800b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4d:	ff d0                	call   *%eax
  800b4f:	83 c4 10             	add    $0x10,%esp
			break;
  800b52:	e9 ce 00 00 00       	jmp    800c25 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800b57:	83 ec 08             	sub    $0x8,%esp
  800b5a:	ff 75 0c             	pushl  0xc(%ebp)
  800b5d:	6a 30                	push   $0x30
  800b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b62:	ff d0                	call   *%eax
  800b64:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b67:	83 ec 08             	sub    $0x8,%esp
  800b6a:	ff 75 0c             	pushl  0xc(%ebp)
  800b6d:	6a 78                	push   $0x78
  800b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b72:	ff d0                	call   *%eax
  800b74:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b77:	8b 45 14             	mov    0x14(%ebp),%eax
  800b7a:	83 c0 04             	add    $0x4,%eax
  800b7d:	89 45 14             	mov    %eax,0x14(%ebp)
  800b80:	8b 45 14             	mov    0x14(%ebp),%eax
  800b83:	83 e8 04             	sub    $0x4,%eax
  800b86:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b88:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b8b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b92:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b99:	eb 1f                	jmp    800bba <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b9b:	83 ec 08             	sub    $0x8,%esp
  800b9e:	ff 75 e8             	pushl  -0x18(%ebp)
  800ba1:	8d 45 14             	lea    0x14(%ebp),%eax
  800ba4:	50                   	push   %eax
  800ba5:	e8 e7 fb ff ff       	call   800791 <getuint>
  800baa:	83 c4 10             	add    $0x10,%esp
  800bad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800bb3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bba:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800bbe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bc1:	83 ec 04             	sub    $0x4,%esp
  800bc4:	52                   	push   %edx
  800bc5:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bc8:	50                   	push   %eax
  800bc9:	ff 75 f4             	pushl  -0xc(%ebp)
  800bcc:	ff 75 f0             	pushl  -0x10(%ebp)
  800bcf:	ff 75 0c             	pushl  0xc(%ebp)
  800bd2:	ff 75 08             	pushl  0x8(%ebp)
  800bd5:	e8 00 fb ff ff       	call   8006da <printnum>
  800bda:	83 c4 20             	add    $0x20,%esp
			break;
  800bdd:	eb 46                	jmp    800c25 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800bdf:	83 ec 08             	sub    $0x8,%esp
  800be2:	ff 75 0c             	pushl  0xc(%ebp)
  800be5:	53                   	push   %ebx
  800be6:	8b 45 08             	mov    0x8(%ebp),%eax
  800be9:	ff d0                	call   *%eax
  800beb:	83 c4 10             	add    $0x10,%esp
			break;
  800bee:	eb 35                	jmp    800c25 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800bf0:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
			break;
  800bf7:	eb 2c                	jmp    800c25 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800bf9:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
			break;
  800c00:	eb 23                	jmp    800c25 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c02:	83 ec 08             	sub    $0x8,%esp
  800c05:	ff 75 0c             	pushl  0xc(%ebp)
  800c08:	6a 25                	push   $0x25
  800c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0d:	ff d0                	call   *%eax
  800c0f:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c12:	ff 4d 10             	decl   0x10(%ebp)
  800c15:	eb 03                	jmp    800c1a <vprintfmt+0x3c3>
  800c17:	ff 4d 10             	decl   0x10(%ebp)
  800c1a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c1d:	48                   	dec    %eax
  800c1e:	8a 00                	mov    (%eax),%al
  800c20:	3c 25                	cmp    $0x25,%al
  800c22:	75 f3                	jne    800c17 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800c24:	90                   	nop
		}
	}
  800c25:	e9 35 fc ff ff       	jmp    80085f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c2a:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c2b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c2e:	5b                   	pop    %ebx
  800c2f:	5e                   	pop    %esi
  800c30:	5d                   	pop    %ebp
  800c31:	c3                   	ret    

00800c32 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c32:	55                   	push   %ebp
  800c33:	89 e5                	mov    %esp,%ebp
  800c35:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c38:	8d 45 10             	lea    0x10(%ebp),%eax
  800c3b:	83 c0 04             	add    $0x4,%eax
  800c3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c41:	8b 45 10             	mov    0x10(%ebp),%eax
  800c44:	ff 75 f4             	pushl  -0xc(%ebp)
  800c47:	50                   	push   %eax
  800c48:	ff 75 0c             	pushl  0xc(%ebp)
  800c4b:	ff 75 08             	pushl  0x8(%ebp)
  800c4e:	e8 04 fc ff ff       	call   800857 <vprintfmt>
  800c53:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c56:	90                   	nop
  800c57:	c9                   	leave  
  800c58:	c3                   	ret    

00800c59 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c59:	55                   	push   %ebp
  800c5a:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5f:	8b 40 08             	mov    0x8(%eax),%eax
  800c62:	8d 50 01             	lea    0x1(%eax),%edx
  800c65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c68:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6e:	8b 10                	mov    (%eax),%edx
  800c70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c73:	8b 40 04             	mov    0x4(%eax),%eax
  800c76:	39 c2                	cmp    %eax,%edx
  800c78:	73 12                	jae    800c8c <sprintputch+0x33>
		*b->buf++ = ch;
  800c7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7d:	8b 00                	mov    (%eax),%eax
  800c7f:	8d 48 01             	lea    0x1(%eax),%ecx
  800c82:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c85:	89 0a                	mov    %ecx,(%edx)
  800c87:	8b 55 08             	mov    0x8(%ebp),%edx
  800c8a:	88 10                	mov    %dl,(%eax)
}
  800c8c:	90                   	nop
  800c8d:	5d                   	pop    %ebp
  800c8e:	c3                   	ret    

00800c8f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c8f:	55                   	push   %ebp
  800c90:	89 e5                	mov    %esp,%ebp
  800c92:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c95:	8b 45 08             	mov    0x8(%ebp),%eax
  800c98:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca4:	01 d0                	add    %edx,%eax
  800ca6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ca9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800cb0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800cb4:	74 06                	je     800cbc <vsnprintf+0x2d>
  800cb6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cba:	7f 07                	jg     800cc3 <vsnprintf+0x34>
		return -E_INVAL;
  800cbc:	b8 03 00 00 00       	mov    $0x3,%eax
  800cc1:	eb 20                	jmp    800ce3 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800cc3:	ff 75 14             	pushl  0x14(%ebp)
  800cc6:	ff 75 10             	pushl  0x10(%ebp)
  800cc9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ccc:	50                   	push   %eax
  800ccd:	68 59 0c 80 00       	push   $0x800c59
  800cd2:	e8 80 fb ff ff       	call   800857 <vprintfmt>
  800cd7:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800cda:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cdd:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ce3:	c9                   	leave  
  800ce4:	c3                   	ret    

00800ce5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ce5:	55                   	push   %ebp
  800ce6:	89 e5                	mov    %esp,%ebp
  800ce8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ceb:	8d 45 10             	lea    0x10(%ebp),%eax
  800cee:	83 c0 04             	add    $0x4,%eax
  800cf1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800cf4:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf7:	ff 75 f4             	pushl  -0xc(%ebp)
  800cfa:	50                   	push   %eax
  800cfb:	ff 75 0c             	pushl  0xc(%ebp)
  800cfe:	ff 75 08             	pushl  0x8(%ebp)
  800d01:	e8 89 ff ff ff       	call   800c8f <vsnprintf>
  800d06:	83 c4 10             	add    $0x10,%esp
  800d09:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d0f:	c9                   	leave  
  800d10:	c3                   	ret    

00800d11 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800d11:	55                   	push   %ebp
  800d12:	89 e5                	mov    %esp,%ebp
  800d14:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d17:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d1e:	eb 06                	jmp    800d26 <strlen+0x15>
		n++;
  800d20:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d23:	ff 45 08             	incl   0x8(%ebp)
  800d26:	8b 45 08             	mov    0x8(%ebp),%eax
  800d29:	8a 00                	mov    (%eax),%al
  800d2b:	84 c0                	test   %al,%al
  800d2d:	75 f1                	jne    800d20 <strlen+0xf>
		n++;
	return n;
  800d2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d32:	c9                   	leave  
  800d33:	c3                   	ret    

00800d34 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d34:	55                   	push   %ebp
  800d35:	89 e5                	mov    %esp,%ebp
  800d37:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d3a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d41:	eb 09                	jmp    800d4c <strnlen+0x18>
		n++;
  800d43:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d46:	ff 45 08             	incl   0x8(%ebp)
  800d49:	ff 4d 0c             	decl   0xc(%ebp)
  800d4c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d50:	74 09                	je     800d5b <strnlen+0x27>
  800d52:	8b 45 08             	mov    0x8(%ebp),%eax
  800d55:	8a 00                	mov    (%eax),%al
  800d57:	84 c0                	test   %al,%al
  800d59:	75 e8                	jne    800d43 <strnlen+0xf>
		n++;
	return n;
  800d5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d5e:	c9                   	leave  
  800d5f:	c3                   	ret    

00800d60 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d60:	55                   	push   %ebp
  800d61:	89 e5                	mov    %esp,%ebp
  800d63:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d66:	8b 45 08             	mov    0x8(%ebp),%eax
  800d69:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d6c:	90                   	nop
  800d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d70:	8d 50 01             	lea    0x1(%eax),%edx
  800d73:	89 55 08             	mov    %edx,0x8(%ebp)
  800d76:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d79:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d7c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d7f:	8a 12                	mov    (%edx),%dl
  800d81:	88 10                	mov    %dl,(%eax)
  800d83:	8a 00                	mov    (%eax),%al
  800d85:	84 c0                	test   %al,%al
  800d87:	75 e4                	jne    800d6d <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d89:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d8c:	c9                   	leave  
  800d8d:	c3                   	ret    

00800d8e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d8e:	55                   	push   %ebp
  800d8f:	89 e5                	mov    %esp,%ebp
  800d91:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d94:	8b 45 08             	mov    0x8(%ebp),%eax
  800d97:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d9a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800da1:	eb 1f                	jmp    800dc2 <strncpy+0x34>
		*dst++ = *src;
  800da3:	8b 45 08             	mov    0x8(%ebp),%eax
  800da6:	8d 50 01             	lea    0x1(%eax),%edx
  800da9:	89 55 08             	mov    %edx,0x8(%ebp)
  800dac:	8b 55 0c             	mov    0xc(%ebp),%edx
  800daf:	8a 12                	mov    (%edx),%dl
  800db1:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800db3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db6:	8a 00                	mov    (%eax),%al
  800db8:	84 c0                	test   %al,%al
  800dba:	74 03                	je     800dbf <strncpy+0x31>
			src++;
  800dbc:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800dbf:	ff 45 fc             	incl   -0x4(%ebp)
  800dc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dc5:	3b 45 10             	cmp    0x10(%ebp),%eax
  800dc8:	72 d9                	jb     800da3 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800dca:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800dcd:	c9                   	leave  
  800dce:	c3                   	ret    

00800dcf <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800dcf:	55                   	push   %ebp
  800dd0:	89 e5                	mov    %esp,%ebp
  800dd2:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ddb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ddf:	74 30                	je     800e11 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800de1:	eb 16                	jmp    800df9 <strlcpy+0x2a>
			*dst++ = *src++;
  800de3:	8b 45 08             	mov    0x8(%ebp),%eax
  800de6:	8d 50 01             	lea    0x1(%eax),%edx
  800de9:	89 55 08             	mov    %edx,0x8(%ebp)
  800dec:	8b 55 0c             	mov    0xc(%ebp),%edx
  800def:	8d 4a 01             	lea    0x1(%edx),%ecx
  800df2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800df5:	8a 12                	mov    (%edx),%dl
  800df7:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800df9:	ff 4d 10             	decl   0x10(%ebp)
  800dfc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e00:	74 09                	je     800e0b <strlcpy+0x3c>
  800e02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e05:	8a 00                	mov    (%eax),%al
  800e07:	84 c0                	test   %al,%al
  800e09:	75 d8                	jne    800de3 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e11:	8b 55 08             	mov    0x8(%ebp),%edx
  800e14:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e17:	29 c2                	sub    %eax,%edx
  800e19:	89 d0                	mov    %edx,%eax
}
  800e1b:	c9                   	leave  
  800e1c:	c3                   	ret    

00800e1d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e1d:	55                   	push   %ebp
  800e1e:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e20:	eb 06                	jmp    800e28 <strcmp+0xb>
		p++, q++;
  800e22:	ff 45 08             	incl   0x8(%ebp)
  800e25:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e28:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2b:	8a 00                	mov    (%eax),%al
  800e2d:	84 c0                	test   %al,%al
  800e2f:	74 0e                	je     800e3f <strcmp+0x22>
  800e31:	8b 45 08             	mov    0x8(%ebp),%eax
  800e34:	8a 10                	mov    (%eax),%dl
  800e36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e39:	8a 00                	mov    (%eax),%al
  800e3b:	38 c2                	cmp    %al,%dl
  800e3d:	74 e3                	je     800e22 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e42:	8a 00                	mov    (%eax),%al
  800e44:	0f b6 d0             	movzbl %al,%edx
  800e47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4a:	8a 00                	mov    (%eax),%al
  800e4c:	0f b6 c0             	movzbl %al,%eax
  800e4f:	29 c2                	sub    %eax,%edx
  800e51:	89 d0                	mov    %edx,%eax
}
  800e53:	5d                   	pop    %ebp
  800e54:	c3                   	ret    

00800e55 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e55:	55                   	push   %ebp
  800e56:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e58:	eb 09                	jmp    800e63 <strncmp+0xe>
		n--, p++, q++;
  800e5a:	ff 4d 10             	decl   0x10(%ebp)
  800e5d:	ff 45 08             	incl   0x8(%ebp)
  800e60:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e63:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e67:	74 17                	je     800e80 <strncmp+0x2b>
  800e69:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6c:	8a 00                	mov    (%eax),%al
  800e6e:	84 c0                	test   %al,%al
  800e70:	74 0e                	je     800e80 <strncmp+0x2b>
  800e72:	8b 45 08             	mov    0x8(%ebp),%eax
  800e75:	8a 10                	mov    (%eax),%dl
  800e77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7a:	8a 00                	mov    (%eax),%al
  800e7c:	38 c2                	cmp    %al,%dl
  800e7e:	74 da                	je     800e5a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e80:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e84:	75 07                	jne    800e8d <strncmp+0x38>
		return 0;
  800e86:	b8 00 00 00 00       	mov    $0x0,%eax
  800e8b:	eb 14                	jmp    800ea1 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e90:	8a 00                	mov    (%eax),%al
  800e92:	0f b6 d0             	movzbl %al,%edx
  800e95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e98:	8a 00                	mov    (%eax),%al
  800e9a:	0f b6 c0             	movzbl %al,%eax
  800e9d:	29 c2                	sub    %eax,%edx
  800e9f:	89 d0                	mov    %edx,%eax
}
  800ea1:	5d                   	pop    %ebp
  800ea2:	c3                   	ret    

00800ea3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ea3:	55                   	push   %ebp
  800ea4:	89 e5                	mov    %esp,%ebp
  800ea6:	83 ec 04             	sub    $0x4,%esp
  800ea9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eac:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800eaf:	eb 12                	jmp    800ec3 <strchr+0x20>
		if (*s == c)
  800eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb4:	8a 00                	mov    (%eax),%al
  800eb6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800eb9:	75 05                	jne    800ec0 <strchr+0x1d>
			return (char *) s;
  800ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebe:	eb 11                	jmp    800ed1 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ec0:	ff 45 08             	incl   0x8(%ebp)
  800ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec6:	8a 00                	mov    (%eax),%al
  800ec8:	84 c0                	test   %al,%al
  800eca:	75 e5                	jne    800eb1 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ecc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ed1:	c9                   	leave  
  800ed2:	c3                   	ret    

00800ed3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ed3:	55                   	push   %ebp
  800ed4:	89 e5                	mov    %esp,%ebp
  800ed6:	83 ec 04             	sub    $0x4,%esp
  800ed9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800edc:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800edf:	eb 0d                	jmp    800eee <strfind+0x1b>
		if (*s == c)
  800ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee4:	8a 00                	mov    (%eax),%al
  800ee6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ee9:	74 0e                	je     800ef9 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800eeb:	ff 45 08             	incl   0x8(%ebp)
  800eee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef1:	8a 00                	mov    (%eax),%al
  800ef3:	84 c0                	test   %al,%al
  800ef5:	75 ea                	jne    800ee1 <strfind+0xe>
  800ef7:	eb 01                	jmp    800efa <strfind+0x27>
		if (*s == c)
			break;
  800ef9:	90                   	nop
	return (char *) s;
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800efd:	c9                   	leave  
  800efe:	c3                   	ret    

00800eff <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800eff:	55                   	push   %ebp
  800f00:	89 e5                	mov    %esp,%ebp
  800f02:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800f05:	8b 45 08             	mov    0x8(%ebp),%eax
  800f08:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800f0b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f11:	eb 0e                	jmp    800f21 <memset+0x22>
		*p++ = c;
  800f13:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f16:	8d 50 01             	lea    0x1(%eax),%edx
  800f19:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f1f:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800f21:	ff 4d f8             	decl   -0x8(%ebp)
  800f24:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f28:	79 e9                	jns    800f13 <memset+0x14>
		*p++ = c;

	return v;
  800f2a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f2d:	c9                   	leave  
  800f2e:	c3                   	ret    

00800f2f <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f2f:	55                   	push   %ebp
  800f30:	89 e5                	mov    %esp,%ebp
  800f32:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f38:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f41:	eb 16                	jmp    800f59 <memcpy+0x2a>
		*d++ = *s++;
  800f43:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f46:	8d 50 01             	lea    0x1(%eax),%edx
  800f49:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f4c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f4f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f52:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f55:	8a 12                	mov    (%edx),%dl
  800f57:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f59:	8b 45 10             	mov    0x10(%ebp),%eax
  800f5c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f5f:	89 55 10             	mov    %edx,0x10(%ebp)
  800f62:	85 c0                	test   %eax,%eax
  800f64:	75 dd                	jne    800f43 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f66:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f69:	c9                   	leave  
  800f6a:	c3                   	ret    

00800f6b <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f6b:	55                   	push   %ebp
  800f6c:	89 e5                	mov    %esp,%ebp
  800f6e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f74:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f77:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f80:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f83:	73 50                	jae    800fd5 <memmove+0x6a>
  800f85:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f88:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8b:	01 d0                	add    %edx,%eax
  800f8d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f90:	76 43                	jbe    800fd5 <memmove+0x6a>
		s += n;
  800f92:	8b 45 10             	mov    0x10(%ebp),%eax
  800f95:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f98:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f9e:	eb 10                	jmp    800fb0 <memmove+0x45>
			*--d = *--s;
  800fa0:	ff 4d f8             	decl   -0x8(%ebp)
  800fa3:	ff 4d fc             	decl   -0x4(%ebp)
  800fa6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fa9:	8a 10                	mov    (%eax),%dl
  800fab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fae:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fb0:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fb6:	89 55 10             	mov    %edx,0x10(%ebp)
  800fb9:	85 c0                	test   %eax,%eax
  800fbb:	75 e3                	jne    800fa0 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fbd:	eb 23                	jmp    800fe2 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fbf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc2:	8d 50 01             	lea    0x1(%eax),%edx
  800fc5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fc8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fcb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fce:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fd1:	8a 12                	mov    (%edx),%dl
  800fd3:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fd5:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fdb:	89 55 10             	mov    %edx,0x10(%ebp)
  800fde:	85 c0                	test   %eax,%eax
  800fe0:	75 dd                	jne    800fbf <memmove+0x54>
			*d++ = *s++;

	return dst;
  800fe2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fe5:	c9                   	leave  
  800fe6:	c3                   	ret    

00800fe7 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800fe7:	55                   	push   %ebp
  800fe8:	89 e5                	mov    %esp,%ebp
  800fea:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800fed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ff3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff6:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ff9:	eb 2a                	jmp    801025 <memcmp+0x3e>
		if (*s1 != *s2)
  800ffb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ffe:	8a 10                	mov    (%eax),%dl
  801000:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801003:	8a 00                	mov    (%eax),%al
  801005:	38 c2                	cmp    %al,%dl
  801007:	74 16                	je     80101f <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801009:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80100c:	8a 00                	mov    (%eax),%al
  80100e:	0f b6 d0             	movzbl %al,%edx
  801011:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801014:	8a 00                	mov    (%eax),%al
  801016:	0f b6 c0             	movzbl %al,%eax
  801019:	29 c2                	sub    %eax,%edx
  80101b:	89 d0                	mov    %edx,%eax
  80101d:	eb 18                	jmp    801037 <memcmp+0x50>
		s1++, s2++;
  80101f:	ff 45 fc             	incl   -0x4(%ebp)
  801022:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801025:	8b 45 10             	mov    0x10(%ebp),%eax
  801028:	8d 50 ff             	lea    -0x1(%eax),%edx
  80102b:	89 55 10             	mov    %edx,0x10(%ebp)
  80102e:	85 c0                	test   %eax,%eax
  801030:	75 c9                	jne    800ffb <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801032:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801037:	c9                   	leave  
  801038:	c3                   	ret    

00801039 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801039:	55                   	push   %ebp
  80103a:	89 e5                	mov    %esp,%ebp
  80103c:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80103f:	8b 55 08             	mov    0x8(%ebp),%edx
  801042:	8b 45 10             	mov    0x10(%ebp),%eax
  801045:	01 d0                	add    %edx,%eax
  801047:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80104a:	eb 15                	jmp    801061 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80104c:	8b 45 08             	mov    0x8(%ebp),%eax
  80104f:	8a 00                	mov    (%eax),%al
  801051:	0f b6 d0             	movzbl %al,%edx
  801054:	8b 45 0c             	mov    0xc(%ebp),%eax
  801057:	0f b6 c0             	movzbl %al,%eax
  80105a:	39 c2                	cmp    %eax,%edx
  80105c:	74 0d                	je     80106b <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80105e:	ff 45 08             	incl   0x8(%ebp)
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
  801064:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801067:	72 e3                	jb     80104c <memfind+0x13>
  801069:	eb 01                	jmp    80106c <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80106b:	90                   	nop
	return (void *) s;
  80106c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80106f:	c9                   	leave  
  801070:	c3                   	ret    

00801071 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801071:	55                   	push   %ebp
  801072:	89 e5                	mov    %esp,%ebp
  801074:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801077:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80107e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801085:	eb 03                	jmp    80108a <strtol+0x19>
		s++;
  801087:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80108a:	8b 45 08             	mov    0x8(%ebp),%eax
  80108d:	8a 00                	mov    (%eax),%al
  80108f:	3c 20                	cmp    $0x20,%al
  801091:	74 f4                	je     801087 <strtol+0x16>
  801093:	8b 45 08             	mov    0x8(%ebp),%eax
  801096:	8a 00                	mov    (%eax),%al
  801098:	3c 09                	cmp    $0x9,%al
  80109a:	74 eb                	je     801087 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80109c:	8b 45 08             	mov    0x8(%ebp),%eax
  80109f:	8a 00                	mov    (%eax),%al
  8010a1:	3c 2b                	cmp    $0x2b,%al
  8010a3:	75 05                	jne    8010aa <strtol+0x39>
		s++;
  8010a5:	ff 45 08             	incl   0x8(%ebp)
  8010a8:	eb 13                	jmp    8010bd <strtol+0x4c>
	else if (*s == '-')
  8010aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ad:	8a 00                	mov    (%eax),%al
  8010af:	3c 2d                	cmp    $0x2d,%al
  8010b1:	75 0a                	jne    8010bd <strtol+0x4c>
		s++, neg = 1;
  8010b3:	ff 45 08             	incl   0x8(%ebp)
  8010b6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010bd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010c1:	74 06                	je     8010c9 <strtol+0x58>
  8010c3:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010c7:	75 20                	jne    8010e9 <strtol+0x78>
  8010c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cc:	8a 00                	mov    (%eax),%al
  8010ce:	3c 30                	cmp    $0x30,%al
  8010d0:	75 17                	jne    8010e9 <strtol+0x78>
  8010d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d5:	40                   	inc    %eax
  8010d6:	8a 00                	mov    (%eax),%al
  8010d8:	3c 78                	cmp    $0x78,%al
  8010da:	75 0d                	jne    8010e9 <strtol+0x78>
		s += 2, base = 16;
  8010dc:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010e0:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010e7:	eb 28                	jmp    801111 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8010e9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010ed:	75 15                	jne    801104 <strtol+0x93>
  8010ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f2:	8a 00                	mov    (%eax),%al
  8010f4:	3c 30                	cmp    $0x30,%al
  8010f6:	75 0c                	jne    801104 <strtol+0x93>
		s++, base = 8;
  8010f8:	ff 45 08             	incl   0x8(%ebp)
  8010fb:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801102:	eb 0d                	jmp    801111 <strtol+0xa0>
	else if (base == 0)
  801104:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801108:	75 07                	jne    801111 <strtol+0xa0>
		base = 10;
  80110a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801111:	8b 45 08             	mov    0x8(%ebp),%eax
  801114:	8a 00                	mov    (%eax),%al
  801116:	3c 2f                	cmp    $0x2f,%al
  801118:	7e 19                	jle    801133 <strtol+0xc2>
  80111a:	8b 45 08             	mov    0x8(%ebp),%eax
  80111d:	8a 00                	mov    (%eax),%al
  80111f:	3c 39                	cmp    $0x39,%al
  801121:	7f 10                	jg     801133 <strtol+0xc2>
			dig = *s - '0';
  801123:	8b 45 08             	mov    0x8(%ebp),%eax
  801126:	8a 00                	mov    (%eax),%al
  801128:	0f be c0             	movsbl %al,%eax
  80112b:	83 e8 30             	sub    $0x30,%eax
  80112e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801131:	eb 42                	jmp    801175 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801133:	8b 45 08             	mov    0x8(%ebp),%eax
  801136:	8a 00                	mov    (%eax),%al
  801138:	3c 60                	cmp    $0x60,%al
  80113a:	7e 19                	jle    801155 <strtol+0xe4>
  80113c:	8b 45 08             	mov    0x8(%ebp),%eax
  80113f:	8a 00                	mov    (%eax),%al
  801141:	3c 7a                	cmp    $0x7a,%al
  801143:	7f 10                	jg     801155 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801145:	8b 45 08             	mov    0x8(%ebp),%eax
  801148:	8a 00                	mov    (%eax),%al
  80114a:	0f be c0             	movsbl %al,%eax
  80114d:	83 e8 57             	sub    $0x57,%eax
  801150:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801153:	eb 20                	jmp    801175 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801155:	8b 45 08             	mov    0x8(%ebp),%eax
  801158:	8a 00                	mov    (%eax),%al
  80115a:	3c 40                	cmp    $0x40,%al
  80115c:	7e 39                	jle    801197 <strtol+0x126>
  80115e:	8b 45 08             	mov    0x8(%ebp),%eax
  801161:	8a 00                	mov    (%eax),%al
  801163:	3c 5a                	cmp    $0x5a,%al
  801165:	7f 30                	jg     801197 <strtol+0x126>
			dig = *s - 'A' + 10;
  801167:	8b 45 08             	mov    0x8(%ebp),%eax
  80116a:	8a 00                	mov    (%eax),%al
  80116c:	0f be c0             	movsbl %al,%eax
  80116f:	83 e8 37             	sub    $0x37,%eax
  801172:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801175:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801178:	3b 45 10             	cmp    0x10(%ebp),%eax
  80117b:	7d 19                	jge    801196 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80117d:	ff 45 08             	incl   0x8(%ebp)
  801180:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801183:	0f af 45 10          	imul   0x10(%ebp),%eax
  801187:	89 c2                	mov    %eax,%edx
  801189:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80118c:	01 d0                	add    %edx,%eax
  80118e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801191:	e9 7b ff ff ff       	jmp    801111 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801196:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801197:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80119b:	74 08                	je     8011a5 <strtol+0x134>
		*endptr = (char *) s;
  80119d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a3:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011a9:	74 07                	je     8011b2 <strtol+0x141>
  8011ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ae:	f7 d8                	neg    %eax
  8011b0:	eb 03                	jmp    8011b5 <strtol+0x144>
  8011b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011b5:	c9                   	leave  
  8011b6:	c3                   	ret    

008011b7 <ltostr>:

void
ltostr(long value, char *str)
{
  8011b7:	55                   	push   %ebp
  8011b8:	89 e5                	mov    %esp,%ebp
  8011ba:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011c4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011cb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011cf:	79 13                	jns    8011e4 <ltostr+0x2d>
	{
		neg = 1;
  8011d1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011db:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011de:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011e1:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011ec:	99                   	cltd   
  8011ed:	f7 f9                	idiv   %ecx
  8011ef:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011f5:	8d 50 01             	lea    0x1(%eax),%edx
  8011f8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011fb:	89 c2                	mov    %eax,%edx
  8011fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801200:	01 d0                	add    %edx,%eax
  801202:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801205:	83 c2 30             	add    $0x30,%edx
  801208:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80120a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80120d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801212:	f7 e9                	imul   %ecx
  801214:	c1 fa 02             	sar    $0x2,%edx
  801217:	89 c8                	mov    %ecx,%eax
  801219:	c1 f8 1f             	sar    $0x1f,%eax
  80121c:	29 c2                	sub    %eax,%edx
  80121e:	89 d0                	mov    %edx,%eax
  801220:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801223:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801227:	75 bb                	jne    8011e4 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801229:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801230:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801233:	48                   	dec    %eax
  801234:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801237:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80123b:	74 3d                	je     80127a <ltostr+0xc3>
		start = 1 ;
  80123d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801244:	eb 34                	jmp    80127a <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801246:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801249:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124c:	01 d0                	add    %edx,%eax
  80124e:	8a 00                	mov    (%eax),%al
  801250:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801253:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801256:	8b 45 0c             	mov    0xc(%ebp),%eax
  801259:	01 c2                	add    %eax,%edx
  80125b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80125e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801261:	01 c8                	add    %ecx,%eax
  801263:	8a 00                	mov    (%eax),%al
  801265:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801267:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80126a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126d:	01 c2                	add    %eax,%edx
  80126f:	8a 45 eb             	mov    -0x15(%ebp),%al
  801272:	88 02                	mov    %al,(%edx)
		start++ ;
  801274:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801277:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80127a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80127d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801280:	7c c4                	jl     801246 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801282:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801285:	8b 45 0c             	mov    0xc(%ebp),%eax
  801288:	01 d0                	add    %edx,%eax
  80128a:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80128d:	90                   	nop
  80128e:	c9                   	leave  
  80128f:	c3                   	ret    

00801290 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801290:	55                   	push   %ebp
  801291:	89 e5                	mov    %esp,%ebp
  801293:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801296:	ff 75 08             	pushl  0x8(%ebp)
  801299:	e8 73 fa ff ff       	call   800d11 <strlen>
  80129e:	83 c4 04             	add    $0x4,%esp
  8012a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012a4:	ff 75 0c             	pushl  0xc(%ebp)
  8012a7:	e8 65 fa ff ff       	call   800d11 <strlen>
  8012ac:	83 c4 04             	add    $0x4,%esp
  8012af:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012c0:	eb 17                	jmp    8012d9 <strcconcat+0x49>
		final[s] = str1[s] ;
  8012c2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c8:	01 c2                	add    %eax,%edx
  8012ca:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d0:	01 c8                	add    %ecx,%eax
  8012d2:	8a 00                	mov    (%eax),%al
  8012d4:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012d6:	ff 45 fc             	incl   -0x4(%ebp)
  8012d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012dc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012df:	7c e1                	jl     8012c2 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012e1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012e8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012ef:	eb 1f                	jmp    801310 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012f4:	8d 50 01             	lea    0x1(%eax),%edx
  8012f7:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012fa:	89 c2                	mov    %eax,%edx
  8012fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ff:	01 c2                	add    %eax,%edx
  801301:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801304:	8b 45 0c             	mov    0xc(%ebp),%eax
  801307:	01 c8                	add    %ecx,%eax
  801309:	8a 00                	mov    (%eax),%al
  80130b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80130d:	ff 45 f8             	incl   -0x8(%ebp)
  801310:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801313:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801316:	7c d9                	jl     8012f1 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801318:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80131b:	8b 45 10             	mov    0x10(%ebp),%eax
  80131e:	01 d0                	add    %edx,%eax
  801320:	c6 00 00             	movb   $0x0,(%eax)
}
  801323:	90                   	nop
  801324:	c9                   	leave  
  801325:	c3                   	ret    

00801326 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801326:	55                   	push   %ebp
  801327:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801329:	8b 45 14             	mov    0x14(%ebp),%eax
  80132c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801332:	8b 45 14             	mov    0x14(%ebp),%eax
  801335:	8b 00                	mov    (%eax),%eax
  801337:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80133e:	8b 45 10             	mov    0x10(%ebp),%eax
  801341:	01 d0                	add    %edx,%eax
  801343:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801349:	eb 0c                	jmp    801357 <strsplit+0x31>
			*string++ = 0;
  80134b:	8b 45 08             	mov    0x8(%ebp),%eax
  80134e:	8d 50 01             	lea    0x1(%eax),%edx
  801351:	89 55 08             	mov    %edx,0x8(%ebp)
  801354:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801357:	8b 45 08             	mov    0x8(%ebp),%eax
  80135a:	8a 00                	mov    (%eax),%al
  80135c:	84 c0                	test   %al,%al
  80135e:	74 18                	je     801378 <strsplit+0x52>
  801360:	8b 45 08             	mov    0x8(%ebp),%eax
  801363:	8a 00                	mov    (%eax),%al
  801365:	0f be c0             	movsbl %al,%eax
  801368:	50                   	push   %eax
  801369:	ff 75 0c             	pushl  0xc(%ebp)
  80136c:	e8 32 fb ff ff       	call   800ea3 <strchr>
  801371:	83 c4 08             	add    $0x8,%esp
  801374:	85 c0                	test   %eax,%eax
  801376:	75 d3                	jne    80134b <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801378:	8b 45 08             	mov    0x8(%ebp),%eax
  80137b:	8a 00                	mov    (%eax),%al
  80137d:	84 c0                	test   %al,%al
  80137f:	74 5a                	je     8013db <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801381:	8b 45 14             	mov    0x14(%ebp),%eax
  801384:	8b 00                	mov    (%eax),%eax
  801386:	83 f8 0f             	cmp    $0xf,%eax
  801389:	75 07                	jne    801392 <strsplit+0x6c>
		{
			return 0;
  80138b:	b8 00 00 00 00       	mov    $0x0,%eax
  801390:	eb 66                	jmp    8013f8 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801392:	8b 45 14             	mov    0x14(%ebp),%eax
  801395:	8b 00                	mov    (%eax),%eax
  801397:	8d 48 01             	lea    0x1(%eax),%ecx
  80139a:	8b 55 14             	mov    0x14(%ebp),%edx
  80139d:	89 0a                	mov    %ecx,(%edx)
  80139f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a9:	01 c2                	add    %eax,%edx
  8013ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ae:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013b0:	eb 03                	jmp    8013b5 <strsplit+0x8f>
			string++;
  8013b2:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b8:	8a 00                	mov    (%eax),%al
  8013ba:	84 c0                	test   %al,%al
  8013bc:	74 8b                	je     801349 <strsplit+0x23>
  8013be:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c1:	8a 00                	mov    (%eax),%al
  8013c3:	0f be c0             	movsbl %al,%eax
  8013c6:	50                   	push   %eax
  8013c7:	ff 75 0c             	pushl  0xc(%ebp)
  8013ca:	e8 d4 fa ff ff       	call   800ea3 <strchr>
  8013cf:	83 c4 08             	add    $0x8,%esp
  8013d2:	85 c0                	test   %eax,%eax
  8013d4:	74 dc                	je     8013b2 <strsplit+0x8c>
			string++;
	}
  8013d6:	e9 6e ff ff ff       	jmp    801349 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013db:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8013df:	8b 00                	mov    (%eax),%eax
  8013e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8013eb:	01 d0                	add    %edx,%eax
  8013ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013f3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013f8:	c9                   	leave  
  8013f9:	c3                   	ret    

008013fa <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8013fa:	55                   	push   %ebp
  8013fb:	89 e5                	mov    %esp,%ebp
  8013fd:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801400:	83 ec 04             	sub    $0x4,%esp
  801403:	68 a8 40 80 00       	push   $0x8040a8
  801408:	68 3f 01 00 00       	push   $0x13f
  80140d:	68 ca 40 80 00       	push   $0x8040ca
  801412:	e8 a9 ef ff ff       	call   8003c0 <_panic>

00801417 <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  801417:	55                   	push   %ebp
  801418:	89 e5                	mov    %esp,%ebp
  80141a:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  80141d:	83 ec 0c             	sub    $0xc,%esp
  801420:	ff 75 08             	pushl  0x8(%ebp)
  801423:	e8 90 0c 00 00       	call   8020b8 <sys_sbrk>
  801428:	83 c4 10             	add    $0x10,%esp
}
  80142b:	c9                   	leave  
  80142c:	c3                   	ret    

0080142d <malloc>:
#define num_of_page ((USER_HEAP_MAX - USER_HEAP_START) / PAGE_SIZE)

int pagesAllocated[num_of_page] = { 0 };
int shardIDs[num_of_page] = { 0 };
bool markedPages[num_of_page] = { 0 };
void* malloc(uint32 size) {
  80142d:	55                   	push   %ebp
  80142e:	89 e5                	mov    %esp,%ebp
  801430:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  801433:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801437:	75 0a                	jne    801443 <malloc+0x16>
		return NULL;
  801439:	b8 00 00 00 00       	mov    $0x0,%eax
  80143e:	e9 9e 01 00 00       	jmp    8015e1 <malloc+0x1b4>

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

	//  our new code
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  801443:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  80144a:	77 2c                	ja     801478 <malloc+0x4b>
		if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  80144c:	e8 eb 0a 00 00       	call   801f3c <sys_isUHeapPlacementStrategyFIRSTFIT>
  801451:	85 c0                	test   %eax,%eax
  801453:	74 19                	je     80146e <malloc+0x41>

			void * block = alloc_block_FF(size);
  801455:	83 ec 0c             	sub    $0xc,%esp
  801458:	ff 75 08             	pushl  0x8(%ebp)
  80145b:	e8 85 11 00 00       	call   8025e5 <alloc_block_FF>
  801460:	83 c4 10             	add    $0x10,%esp
  801463:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			return block;
  801466:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801469:	e9 73 01 00 00       	jmp    8015e1 <malloc+0x1b4>
		} else {
			return NULL;
  80146e:	b8 00 00 00 00       	mov    $0x0,%eax
  801473:	e9 69 01 00 00       	jmp    8015e1 <malloc+0x1b4>
		}
	}

	uint32 numOfPages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801478:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80147f:	8b 55 08             	mov    0x8(%ebp),%edx
  801482:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801485:	01 d0                	add    %edx,%eax
  801487:	48                   	dec    %eax
  801488:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80148b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80148e:	ba 00 00 00 00       	mov    $0x0,%edx
  801493:	f7 75 e0             	divl   -0x20(%ebp)
  801496:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801499:	29 d0                	sub    %edx,%eax
  80149b:	c1 e8 0c             	shr    $0xc,%eax
  80149e:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 freePagesCount = 0;
  8014a1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  8014a8:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  8014af:	a1 20 50 80 00       	mov    0x805020,%eax
  8014b4:	8b 40 7c             	mov    0x7c(%eax),%eax
  8014b7:	05 00 10 00 00       	add    $0x1000,%eax
  8014bc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  8014bf:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8014c4:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8014c7:	89 45 d0             	mov    %eax,-0x30(%ebp)

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  8014ca:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8014d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8014d4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8014d7:	01 d0                	add    %edx,%eax
  8014d9:	48                   	dec    %eax
  8014da:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8014dd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8014e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8014e5:	f7 75 cc             	divl   -0x34(%ebp)
  8014e8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8014eb:	29 d0                	sub    %edx,%eax
  8014ed:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8014f0:	76 0a                	jbe    8014fc <malloc+0xcf>
		return NULL;
  8014f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8014f7:	e9 e5 00 00 00       	jmp    8015e1 <malloc+0x1b4>
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  8014fc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8014ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801502:	eb 48                	jmp    80154c <malloc+0x11f>
	{
		uint32 idx = (i - currentAddr) / PAGE_SIZE;
  801504:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801507:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80150a:	c1 e8 0c             	shr    $0xc,%eax
  80150d:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if (!markedPages[idx]) {
  801510:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801513:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  80151a:	85 c0                	test   %eax,%eax
  80151c:	75 11                	jne    80152f <malloc+0x102>
			freePagesCount++;
  80151e:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801521:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801525:	75 16                	jne    80153d <malloc+0x110>
				start = i;
  801527:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80152a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80152d:	eb 0e                	jmp    80153d <malloc+0x110>
			}
		} else {
			freePagesCount = 0;
  80152f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  801536:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == numOfPages) {
  80153d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801540:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801543:	74 12                	je     801557 <malloc+0x12a>

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  801545:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  80154c:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801553:	76 af                	jbe    801504 <malloc+0xd7>
  801555:	eb 01                	jmp    801558 <malloc+0x12b>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == numOfPages) {
			break;
  801557:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
  801558:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80155c:	74 08                	je     801566 <malloc+0x139>
  80155e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801561:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801564:	74 07                	je     80156d <malloc+0x140>
		return NULL;
  801566:	b8 00 00 00 00       	mov    $0x0,%eax
  80156b:	eb 74                	jmp    8015e1 <malloc+0x1b4>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  80156d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801570:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801573:	c1 e8 0c             	shr    $0xc,%eax
  801576:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numOfPages;
  801579:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80157c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80157f:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  801586:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801589:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80158c:	eb 11                	jmp    80159f <malloc+0x172>
		markedPages[i] = 1;
  80158e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801591:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  801598:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = numOfPages;
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  80159c:	ff 45 e8             	incl   -0x18(%ebp)
  80159f:	8b 55 c0             	mov    -0x40(%ebp),%edx
  8015a2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8015a5:	01 d0                	add    %edx,%eax
  8015a7:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8015aa:	77 e2                	ja     80158e <malloc+0x161>
		markedPages[i] = 1;
	}

	sys_allocate_user_mem(start, ROUNDUP(size, PAGE_SIZE));
  8015ac:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  8015b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8015b6:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8015b9:	01 d0                	add    %edx,%eax
  8015bb:	48                   	dec    %eax
  8015bc:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8015bf:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8015c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8015c7:	f7 75 bc             	divl   -0x44(%ebp)
  8015ca:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8015cd:	29 d0                	sub    %edx,%eax
  8015cf:	83 ec 08             	sub    $0x8,%esp
  8015d2:	50                   	push   %eax
  8015d3:	ff 75 f0             	pushl  -0x10(%ebp)
  8015d6:	e8 14 0b 00 00       	call   8020ef <sys_allocate_user_mem>
  8015db:	83 c4 10             	add    $0x10,%esp
	return (void*) start;
  8015de:	8b 45 f0             	mov    -0x10(%ebp),%eax

}
  8015e1:	c9                   	leave  
  8015e2:	c3                   	ret    

008015e3 <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address) {
  8015e3:	55                   	push   %ebp
  8015e4:	89 e5                	mov    %esp,%ebp
  8015e6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
  8015e9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015ed:	0f 84 ee 00 00 00    	je     8016e1 <free+0xfe>
		return;
	}

	if (virtual_address
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  8015f3:	a1 20 50 80 00       	mov    0x805020,%eax
  8015f8:	8b 40 74             	mov    0x74(%eax),%eax

	if (virtual_address == NULL) {
		return;
	}

	if (virtual_address
  8015fb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8015fe:	77 09                	ja     801609 <free+0x26>
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  801600:	81 7d 08 00 00 00 a0 	cmpl   $0xa0000000,0x8(%ebp)
  801607:	76 14                	jbe    80161d <free+0x3a>
		panic("INVALID VIRTUAL ADDRESS!!");
  801609:	83 ec 04             	sub    $0x4,%esp
  80160c:	68 d8 40 80 00       	push   $0x8040d8
  801611:	6a 68                	push   $0x68
  801613:	68 f2 40 80 00       	push   $0x8040f2
  801618:	e8 a3 ed ff ff       	call   8003c0 <_panic>
	}
	if (virtual_address >= (void *) (myEnv->uheapStart)
  80161d:	a1 20 50 80 00       	mov    0x805020,%eax
  801622:	8b 40 74             	mov    0x74(%eax),%eax
  801625:	3b 45 08             	cmp    0x8(%ebp),%eax
  801628:	77 20                	ja     80164a <free+0x67>
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
  80162a:	a1 20 50 80 00       	mov    0x805020,%eax
  80162f:	8b 40 78             	mov    0x78(%eax),%eax
  801632:	3b 45 08             	cmp    0x8(%ebp),%eax
  801635:	76 13                	jbe    80164a <free+0x67>
		free_block(virtual_address);
  801637:	83 ec 0c             	sub    $0xc,%esp
  80163a:	ff 75 08             	pushl  0x8(%ebp)
  80163d:	e8 6c 16 00 00       	call   802cae <free_block>
  801642:	83 c4 10             	add    $0x10,%esp
		return;
  801645:	e9 98 00 00 00       	jmp    8016e2 <free+0xff>
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  80164a:	8b 55 08             	mov    0x8(%ebp),%edx
  80164d:	a1 20 50 80 00       	mov    0x805020,%eax
  801652:	8b 40 7c             	mov    0x7c(%eax),%eax
  801655:	29 c2                	sub    %eax,%edx
  801657:	89 d0                	mov    %edx,%eax
  801659:	2d 00 10 00 00       	sub    $0x1000,%eax
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
		free_block(virtual_address);
		return;
	}

	uint32 pageIdx = ((uint32) virtual_address
  80165e:	c1 e8 0c             	shr    $0xc,%eax
  801661:	89 45 ec             	mov    %eax,-0x14(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  801664:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80166b:	eb 16                	jmp    801683 <free+0xa0>
		markedPages[idx + pageIdx] = 0;
  80166d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801670:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801673:	01 d0                	add    %edx,%eax
  801675:	c7 04 85 40 50 90 00 	movl   $0x0,0x905040(,%eax,4)
  80167c:	00 00 00 00 
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  801680:	ff 45 f4             	incl   -0xc(%ebp)
  801683:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801686:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  80168d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801690:	7f db                	jg     80166d <free+0x8a>
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;
  801692:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801695:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  80169c:	c1 e0 0c             	shl    $0xc,%eax
  80169f:	89 45 e8             	mov    %eax,-0x18(%ebp)

	for (uint32 i = (uint32) virtual_address;
  8016a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016a8:	eb 1a                	jmp    8016c4 <free+0xe1>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
  8016aa:	83 ec 08             	sub    $0x8,%esp
  8016ad:	68 00 10 00 00       	push   $0x1000
  8016b2:	ff 75 f0             	pushl  -0x10(%ebp)
  8016b5:	e8 19 0a 00 00       	call   8020d3 <sys_free_user_mem>
  8016ba:	83 c4 10             	add    $0x10,%esp
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
  8016bd:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  8016c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8016c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016ca:	01 d0                	add    %edx,%eax
	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
  8016cc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8016cf:	77 d9                	ja     8016aa <free+0xc7>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;
  8016d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016d4:	c7 04 85 40 50 80 00 	movl   $0x0,0x805040(,%eax,4)
  8016db:	00 00 00 00 
  8016df:	eb 01                	jmp    8016e2 <free+0xff>
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
		return;
  8016e1:	90                   	nop
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;

}
  8016e2:	c9                   	leave  
  8016e3:	c3                   	ret    

008016e4 <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  8016e4:	55                   	push   %ebp
  8016e5:	89 e5                	mov    %esp,%ebp
  8016e7:	83 ec 58             	sub    $0x58,%esp
  8016ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ed:	88 45 b4             	mov    %al,-0x4c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  8016f0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016f4:	75 0a                	jne    801700 <smalloc+0x1c>
		return NULL;
  8016f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8016fb:	e9 7d 01 00 00       	jmp    80187d <smalloc+0x199>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	uint32 num_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801700:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  801707:	8b 55 0c             	mov    0xc(%ebp),%edx
  80170a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80170d:	01 d0                	add    %edx,%eax
  80170f:	48                   	dec    %eax
  801710:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801713:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801716:	ba 00 00 00 00       	mov    $0x0,%edx
  80171b:	f7 75 e4             	divl   -0x1c(%ebp)
  80171e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801721:	29 d0                	sub    %edx,%eax
  801723:	c1 e8 0c             	shr    $0xc,%eax
  801726:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 freePagesCount = 0;
  801729:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801730:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  801737:	a1 20 50 80 00       	mov    0x805020,%eax
  80173c:	8b 40 7c             	mov    0x7c(%eax),%eax
  80173f:	05 00 10 00 00       	add    $0x1000,%eax
  801744:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  801747:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  80174c:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80174f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  801752:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801759:	8b 55 0c             	mov    0xc(%ebp),%edx
  80175c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80175f:	01 d0                	add    %edx,%eax
  801761:	48                   	dec    %eax
  801762:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801765:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801768:	ba 00 00 00 00       	mov    $0x0,%edx
  80176d:	f7 75 d0             	divl   -0x30(%ebp)
  801770:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801773:	29 d0                	sub    %edx,%eax
  801775:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801778:	76 0a                	jbe    801784 <smalloc+0xa0>
		return NULL;
  80177a:	b8 00 00 00 00       	mov    $0x0,%eax
  80177f:	e9 f9 00 00 00       	jmp    80187d <smalloc+0x199>
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801784:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801787:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80178a:	eb 48                	jmp    8017d4 <smalloc+0xf0>
		uint32 idx = (s - currentAddr) / PAGE_SIZE;
  80178c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80178f:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801792:	c1 e8 0c             	shr    $0xc,%eax
  801795:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (!markedPages[idx]) {
  801798:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80179b:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  8017a2:	85 c0                	test   %eax,%eax
  8017a4:	75 11                	jne    8017b7 <smalloc+0xd3>
			freePagesCount++;
  8017a6:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  8017a9:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8017ad:	75 16                	jne    8017c5 <smalloc+0xe1>
				start = s;
  8017af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8017b5:	eb 0e                	jmp    8017c5 <smalloc+0xe1>
			}
		} else {
			freePagesCount = 0;
  8017b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  8017be:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == num_Of_Pages) {
  8017c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017c8:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8017cb:	74 12                	je     8017df <smalloc+0xfb>
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  8017cd:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  8017d4:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  8017db:	76 af                	jbe    80178c <smalloc+0xa8>
  8017dd:	eb 01                	jmp    8017e0 <smalloc+0xfc>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == num_Of_Pages) {
			break;
  8017df:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
  8017e0:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8017e4:	74 08                	je     8017ee <smalloc+0x10a>
  8017e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017e9:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8017ec:	74 0a                	je     8017f8 <smalloc+0x114>
		return NULL;
  8017ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f3:	e9 85 00 00 00       	jmp    80187d <smalloc+0x199>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  8017f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017fb:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8017fe:	c1 e8 0c             	shr    $0xc,%eax
  801801:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	pagesAllocated[startPage] = num_Of_Pages;
  801804:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801807:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80180a:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  801811:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801814:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801817:	eb 11                	jmp    80182a <smalloc+0x146>
		markedPages[s] = 1;
  801819:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80181c:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  801823:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = num_Of_Pages;
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  801827:	ff 45 e8             	incl   -0x18(%ebp)
  80182a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80182d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801830:	01 d0                	add    %edx,%eax
  801832:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801835:	77 e2                	ja     801819 <smalloc+0x135>
		markedPages[s] = 1;
	}
	int sharedobjID = sys_createSharedObject(sharedVarName, size, isWritable,
  801837:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80183a:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
  80183e:	52                   	push   %edx
  80183f:	50                   	push   %eax
  801840:	ff 75 0c             	pushl  0xc(%ebp)
  801843:	ff 75 08             	pushl  0x8(%ebp)
  801846:	e8 8f 04 00 00       	call   801cda <sys_createSharedObject>
  80184b:	83 c4 10             	add    $0x10,%esp
  80184e:	89 45 c0             	mov    %eax,-0x40(%ebp)
			(void*) start);

	if (sharedobjID >= 0) {
  801851:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  801855:	78 12                	js     801869 <smalloc+0x185>
		shardIDs[startPage] = sharedobjID;
  801857:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80185a:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80185d:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  801864:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801867:	eb 14                	jmp    80187d <smalloc+0x199>
	}
	free((void*) start);
  801869:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80186c:	83 ec 0c             	sub    $0xc,%esp
  80186f:	50                   	push   %eax
  801870:	e8 6e fd ff ff       	call   8015e3 <free>
  801875:	83 c4 10             	add    $0x10,%esp
	return NULL;
  801878:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80187d:	c9                   	leave  
  80187e:	c3                   	ret    

0080187f <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  80187f:	55                   	push   %ebp
  801880:	89 e5                	mov    %esp,%ebp
  801882:	83 ec 48             	sub    $0x48,%esp
	//cprintf("SSSSSGEEETTT\n");
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID, sharedVarName);
  801885:	83 ec 08             	sub    $0x8,%esp
  801888:	ff 75 0c             	pushl  0xc(%ebp)
  80188b:	ff 75 08             	pushl  0x8(%ebp)
  80188e:	e8 71 04 00 00       	call   801d04 <sys_getSizeOfSharedObject>
  801893:	83 c4 10             	add    $0x10,%esp
  801896:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (size < 0)
		return NULL;
	uint32 numb_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801899:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8018a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8018a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018a6:	01 d0                	add    %edx,%eax
  8018a8:	48                   	dec    %eax
  8018a9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8018ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018af:	ba 00 00 00 00       	mov    $0x0,%edx
  8018b4:	f7 75 e0             	divl   -0x20(%ebp)
  8018b7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018ba:	29 d0                	sub    %edx,%eax
  8018bc:	c1 e8 0c             	shr    $0xc,%eax
  8018bf:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 free_Pages_Count = 0;
  8018c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  8018c9:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
  8018d0:	a1 20 50 80 00       	mov    0x805020,%eax
  8018d5:	8b 40 7c             	mov    0x7c(%eax),%eax
  8018d8:	05 00 10 00 00       	add    $0x1000,%eax
  8018dd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
  8018e0:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8018e5:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8018e8:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
  8018eb:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8018f2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8018f5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8018f8:	01 d0                	add    %edx,%eax
  8018fa:	48                   	dec    %eax
  8018fb:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8018fe:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801901:	ba 00 00 00 00       	mov    $0x0,%edx
  801906:	f7 75 cc             	divl   -0x34(%ebp)
  801909:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80190c:	29 d0                	sub    %edx,%eax
  80190e:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801911:	76 0a                	jbe    80191d <sget+0x9e>
		return NULL;
  801913:	b8 00 00 00 00       	mov    $0x0,%eax
  801918:	e9 f7 00 00 00       	jmp    801a14 <sget+0x195>
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  80191d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801920:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801923:	eb 48                	jmp    80196d <sget+0xee>
		uint32 idx = (s - current_Addr) / PAGE_SIZE;
  801925:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801928:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80192b:	c1 e8 0c             	shr    $0xc,%eax
  80192e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if (!markedPages[idx]) {
  801931:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801934:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  80193b:	85 c0                	test   %eax,%eax
  80193d:	75 11                	jne    801950 <sget+0xd1>
			free_Pages_Count++;
  80193f:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801942:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801946:	75 16                	jne    80195e <sget+0xdf>
				start = s;
  801948:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80194b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80194e:	eb 0e                	jmp    80195e <sget+0xdf>
			}
		} else {
			free_Pages_Count = 0;
  801950:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  801957:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (free_Pages_Count == numb_Of_Pages) {
  80195e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801961:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801964:	74 12                	je     801978 <sget+0xf9>
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
		return NULL;
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801966:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  80196d:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801974:	76 af                	jbe    801925 <sget+0xa6>
  801976:	eb 01                	jmp    801979 <sget+0xfa>
		} else {
			free_Pages_Count = 0;
			start = (uint32) -1;
		}
		if (free_Pages_Count == numb_Of_Pages) {
			break;
  801978:	90                   	nop
		}
	}
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
  801979:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80197d:	74 08                	je     801987 <sget+0x108>
  80197f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801982:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801985:	74 0a                	je     801991 <sget+0x112>
		return NULL;
  801987:	b8 00 00 00 00       	mov    $0x0,%eax
  80198c:	e9 83 00 00 00       	jmp    801a14 <sget+0x195>
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
  801991:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801994:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801997:	c1 e8 0c             	shr    $0xc,%eax
  80199a:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numb_Of_Pages;
  80199d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8019a0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8019a3:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  8019aa:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8019ad:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8019b0:	eb 11                	jmp    8019c3 <sget+0x144>
		markedPages[k] = 1;
  8019b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019b5:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  8019bc:	01 00 00 00 
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
	pagesAllocated[startPage] = numb_Of_Pages;
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  8019c0:	ff 45 e8             	incl   -0x18(%ebp)
  8019c3:	8b 55 c0             	mov    -0x40(%ebp),%edx
  8019c6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8019c9:	01 d0                	add    %edx,%eax
  8019cb:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8019ce:	77 e2                	ja     8019b2 <sget+0x133>
		markedPages[k] = 1;
	}
	int ss = sys_getSharedObject(ownerEnvID, sharedVarName, (void*) start);
  8019d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019d3:	83 ec 04             	sub    $0x4,%esp
  8019d6:	50                   	push   %eax
  8019d7:	ff 75 0c             	pushl  0xc(%ebp)
  8019da:	ff 75 08             	pushl  0x8(%ebp)
  8019dd:	e8 3f 03 00 00       	call   801d21 <sys_getSharedObject>
  8019e2:	83 c4 10             	add    $0x10,%esp
  8019e5:	89 45 bc             	mov    %eax,-0x44(%ebp)
	if (ss >= 0) {
  8019e8:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  8019ec:	78 12                	js     801a00 <sget+0x181>
		shardIDs[startPage] = ss;
  8019ee:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8019f1:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8019f4:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  8019fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019fe:	eb 14                	jmp    801a14 <sget+0x195>
	}
	free((void*) start);
  801a00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a03:	83 ec 0c             	sub    $0xc,%esp
  801a06:	50                   	push   %eax
  801a07:	e8 d7 fb ff ff       	call   8015e3 <free>
  801a0c:	83 c4 10             	add    $0x10,%esp
	return NULL;
  801a0f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a14:	c9                   	leave  
  801a15:	c3                   	ret    

00801a16 <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  801a16:	55                   	push   %ebp
  801a17:	89 e5                	mov    %esp,%ebp
  801a19:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  801a1c:	8b 55 08             	mov    0x8(%ebp),%edx
  801a1f:	a1 20 50 80 00       	mov    0x805020,%eax
  801a24:	8b 40 7c             	mov    0x7c(%eax),%eax
  801a27:	29 c2                	sub    %eax,%edx
  801a29:	89 d0                	mov    %edx,%eax
  801a2b:	2d 00 10 00 00       	sub    $0x1000,%eax

void sfree(void* virtual_address) {
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
  801a30:	c1 e8 0c             	shr    $0xc,%eax
  801a33:	89 45 f4             	mov    %eax,-0xc(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
	int id = shardIDs[pageIdx];
  801a36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a39:	8b 04 85 40 50 88 00 	mov    0x885040(,%eax,4),%eax
  801a40:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int result = sys_freeSharedObject(id, virtual_address);
  801a43:	83 ec 08             	sub    $0x8,%esp
  801a46:	ff 75 08             	pushl  0x8(%ebp)
  801a49:	ff 75 f0             	pushl  -0x10(%ebp)
  801a4c:	e8 ef 02 00 00       	call   801d40 <sys_freeSharedObject>
  801a51:	83 c4 10             	add    $0x10,%esp
  801a54:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (result == 0) {
  801a57:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a5b:	75 0e                	jne    801a6b <sfree+0x55>
		shardIDs[pageIdx] = -1;  // Reset the ID after freeing
  801a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a60:	c7 04 85 40 50 88 00 	movl   $0xffffffff,0x885040(,%eax,4)
  801a67:	ff ff ff ff 
	}

}
  801a6b:	90                   	nop
  801a6c:	c9                   	leave  
  801a6d:	c3                   	ret    

00801a6e <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  801a6e:	55                   	push   %ebp
  801a6f:	89 e5                	mov    %esp,%ebp
  801a71:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801a74:	83 ec 04             	sub    $0x4,%esp
  801a77:	68 00 41 80 00       	push   $0x804100
  801a7c:	68 19 01 00 00       	push   $0x119
  801a81:	68 f2 40 80 00       	push   $0x8040f2
  801a86:	e8 35 e9 ff ff       	call   8003c0 <_panic>

00801a8b <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  801a8b:	55                   	push   %ebp
  801a8c:	89 e5                	mov    %esp,%ebp
  801a8e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a91:	83 ec 04             	sub    $0x4,%esp
  801a94:	68 26 41 80 00       	push   $0x804126
  801a99:	68 23 01 00 00       	push   $0x123
  801a9e:	68 f2 40 80 00       	push   $0x8040f2
  801aa3:	e8 18 e9 ff ff       	call   8003c0 <_panic>

00801aa8 <shrink>:

}
void shrink(uint32 newSize) {
  801aa8:	55                   	push   %ebp
  801aa9:	89 e5                	mov    %esp,%ebp
  801aab:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801aae:	83 ec 04             	sub    $0x4,%esp
  801ab1:	68 26 41 80 00       	push   $0x804126
  801ab6:	68 27 01 00 00       	push   $0x127
  801abb:	68 f2 40 80 00       	push   $0x8040f2
  801ac0:	e8 fb e8 ff ff       	call   8003c0 <_panic>

00801ac5 <freeHeap>:

}
void freeHeap(void* virtual_address) {
  801ac5:	55                   	push   %ebp
  801ac6:	89 e5                	mov    %esp,%ebp
  801ac8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801acb:	83 ec 04             	sub    $0x4,%esp
  801ace:	68 26 41 80 00       	push   $0x804126
  801ad3:	68 2b 01 00 00       	push   $0x12b
  801ad8:	68 f2 40 80 00       	push   $0x8040f2
  801add:	e8 de e8 ff ff       	call   8003c0 <_panic>

00801ae2 <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  801ae2:	55                   	push   %ebp
  801ae3:	89 e5                	mov    %esp,%ebp
  801ae5:	57                   	push   %edi
  801ae6:	56                   	push   %esi
  801ae7:	53                   	push   %ebx
  801ae8:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  801aee:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801af4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801af7:	8b 7d 18             	mov    0x18(%ebp),%edi
  801afa:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801afd:	cd 30                	int    $0x30
  801aff:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  801b02:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b05:	83 c4 10             	add    $0x10,%esp
  801b08:	5b                   	pop    %ebx
  801b09:	5e                   	pop    %esi
  801b0a:	5f                   	pop    %edi
  801b0b:	5d                   	pop    %ebp
  801b0c:	c3                   	ret    

00801b0d <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  801b0d:	55                   	push   %ebp
  801b0e:	89 e5                	mov    %esp,%ebp
  801b10:	83 ec 04             	sub    $0x4,%esp
  801b13:	8b 45 10             	mov    0x10(%ebp),%eax
  801b16:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  801b19:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	52                   	push   %edx
  801b25:	ff 75 0c             	pushl  0xc(%ebp)
  801b28:	50                   	push   %eax
  801b29:	6a 00                	push   $0x0
  801b2b:	e8 b2 ff ff ff       	call   801ae2 <syscall>
  801b30:	83 c4 18             	add    $0x18,%esp
}
  801b33:	90                   	nop
  801b34:	c9                   	leave  
  801b35:	c3                   	ret    

00801b36 <sys_cgetc>:

int sys_cgetc(void) {
  801b36:	55                   	push   %ebp
  801b37:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	6a 02                	push   $0x2
  801b45:	e8 98 ff ff ff       	call   801ae2 <syscall>
  801b4a:	83 c4 18             	add    $0x18,%esp
}
  801b4d:	c9                   	leave  
  801b4e:	c3                   	ret    

00801b4f <sys_lock_cons>:

void sys_lock_cons(void) {
  801b4f:	55                   	push   %ebp
  801b50:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 03                	push   $0x3
  801b5e:	e8 7f ff ff ff       	call   801ae2 <syscall>
  801b63:	83 c4 18             	add    $0x18,%esp
}
  801b66:	90                   	nop
  801b67:	c9                   	leave  
  801b68:	c3                   	ret    

00801b69 <sys_unlock_cons>:
void sys_unlock_cons(void) {
  801b69:	55                   	push   %ebp
  801b6a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 04                	push   $0x4
  801b78:	e8 65 ff ff ff       	call   801ae2 <syscall>
  801b7d:	83 c4 18             	add    $0x18,%esp
}
  801b80:	90                   	nop
  801b81:	c9                   	leave  
  801b82:	c3                   	ret    

00801b83 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  801b83:	55                   	push   %ebp
  801b84:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  801b86:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b89:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	52                   	push   %edx
  801b93:	50                   	push   %eax
  801b94:	6a 08                	push   $0x8
  801b96:	e8 47 ff ff ff       	call   801ae2 <syscall>
  801b9b:	83 c4 18             	add    $0x18,%esp
}
  801b9e:	c9                   	leave  
  801b9f:	c3                   	ret    

00801ba0 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  801ba0:	55                   	push   %ebp
  801ba1:	89 e5                	mov    %esp,%ebp
  801ba3:	56                   	push   %esi
  801ba4:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  801ba5:	8b 75 18             	mov    0x18(%ebp),%esi
  801ba8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801bab:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bae:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb4:	56                   	push   %esi
  801bb5:	53                   	push   %ebx
  801bb6:	51                   	push   %ecx
  801bb7:	52                   	push   %edx
  801bb8:	50                   	push   %eax
  801bb9:	6a 09                	push   $0x9
  801bbb:	e8 22 ff ff ff       	call   801ae2 <syscall>
  801bc0:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  801bc3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bc6:	5b                   	pop    %ebx
  801bc7:	5e                   	pop    %esi
  801bc8:	5d                   	pop    %ebp
  801bc9:	c3                   	ret    

00801bca <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  801bca:	55                   	push   %ebp
  801bcb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801bcd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	52                   	push   %edx
  801bda:	50                   	push   %eax
  801bdb:	6a 0a                	push   $0xa
  801bdd:	e8 00 ff ff ff       	call   801ae2 <syscall>
  801be2:	83 c4 18             	add    $0x18,%esp
}
  801be5:	c9                   	leave  
  801be6:	c3                   	ret    

00801be7 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  801be7:	55                   	push   %ebp
  801be8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	ff 75 0c             	pushl  0xc(%ebp)
  801bf3:	ff 75 08             	pushl  0x8(%ebp)
  801bf6:	6a 0b                	push   $0xb
  801bf8:	e8 e5 fe ff ff       	call   801ae2 <syscall>
  801bfd:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  801c00:	c9                   	leave  
  801c01:	c3                   	ret    

00801c02 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  801c02:	55                   	push   %ebp
  801c03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 0c                	push   $0xc
  801c11:	e8 cc fe ff ff       	call   801ae2 <syscall>
  801c16:	83 c4 18             	add    $0x18,%esp
}
  801c19:	c9                   	leave  
  801c1a:	c3                   	ret    

00801c1b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  801c1b:	55                   	push   %ebp
  801c1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	6a 0d                	push   $0xd
  801c2a:	e8 b3 fe ff ff       	call   801ae2 <syscall>
  801c2f:	83 c4 18             	add    $0x18,%esp
}
  801c32:	c9                   	leave  
  801c33:	c3                   	ret    

00801c34 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  801c34:	55                   	push   %ebp
  801c35:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 0e                	push   $0xe
  801c43:	e8 9a fe ff ff       	call   801ae2 <syscall>
  801c48:	83 c4 18             	add    $0x18,%esp
}
  801c4b:	c9                   	leave  
  801c4c:	c3                   	ret    

00801c4d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  801c4d:	55                   	push   %ebp
  801c4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 0f                	push   $0xf
  801c5c:	e8 81 fe ff ff       	call   801ae2 <syscall>
  801c61:	83 c4 18             	add    $0x18,%esp
}
  801c64:	c9                   	leave  
  801c65:	c3                   	ret    

00801c66 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  801c66:	55                   	push   %ebp
  801c67:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	ff 75 08             	pushl  0x8(%ebp)
  801c74:	6a 10                	push   $0x10
  801c76:	e8 67 fe ff ff       	call   801ae2 <syscall>
  801c7b:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  801c7e:	c9                   	leave  
  801c7f:	c3                   	ret    

00801c80 <sys_scarce_memory>:

void sys_scarce_memory() {
  801c80:	55                   	push   %ebp
  801c81:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 11                	push   $0x11
  801c8f:	e8 4e fe ff ff       	call   801ae2 <syscall>
  801c94:	83 c4 18             	add    $0x18,%esp
}
  801c97:	90                   	nop
  801c98:	c9                   	leave  
  801c99:	c3                   	ret    

00801c9a <sys_cputc>:

void sys_cputc(const char c) {
  801c9a:	55                   	push   %ebp
  801c9b:	89 e5                	mov    %esp,%ebp
  801c9d:	83 ec 04             	sub    $0x4,%esp
  801ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ca6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	50                   	push   %eax
  801cb3:	6a 01                	push   $0x1
  801cb5:	e8 28 fe ff ff       	call   801ae2 <syscall>
  801cba:	83 c4 18             	add    $0x18,%esp
}
  801cbd:	90                   	nop
  801cbe:	c9                   	leave  
  801cbf:	c3                   	ret    

00801cc0 <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  801cc0:	55                   	push   %ebp
  801cc1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 14                	push   $0x14
  801ccf:	e8 0e fe ff ff       	call   801ae2 <syscall>
  801cd4:	83 c4 18             	add    $0x18,%esp
}
  801cd7:	90                   	nop
  801cd8:	c9                   	leave  
  801cd9:	c3                   	ret    

00801cda <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  801cda:	55                   	push   %ebp
  801cdb:	89 e5                	mov    %esp,%ebp
  801cdd:	83 ec 04             	sub    $0x4,%esp
  801ce0:	8b 45 10             	mov    0x10(%ebp),%eax
  801ce3:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  801ce6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ce9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ced:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf0:	6a 00                	push   $0x0
  801cf2:	51                   	push   %ecx
  801cf3:	52                   	push   %edx
  801cf4:	ff 75 0c             	pushl  0xc(%ebp)
  801cf7:	50                   	push   %eax
  801cf8:	6a 15                	push   $0x15
  801cfa:	e8 e3 fd ff ff       	call   801ae2 <syscall>
  801cff:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  801d02:	c9                   	leave  
  801d03:	c3                   	ret    

00801d04 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  801d04:	55                   	push   %ebp
  801d05:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  801d07:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	52                   	push   %edx
  801d14:	50                   	push   %eax
  801d15:	6a 16                	push   $0x16
  801d17:	e8 c6 fd ff ff       	call   801ae2 <syscall>
  801d1c:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  801d1f:	c9                   	leave  
  801d20:	c3                   	ret    

00801d21 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  801d21:	55                   	push   %ebp
  801d22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  801d24:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d27:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	51                   	push   %ecx
  801d32:	52                   	push   %edx
  801d33:	50                   	push   %eax
  801d34:	6a 17                	push   $0x17
  801d36:	e8 a7 fd ff ff       	call   801ae2 <syscall>
  801d3b:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  801d3e:	c9                   	leave  
  801d3f:	c3                   	ret    

00801d40 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  801d40:	55                   	push   %ebp
  801d41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  801d43:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d46:	8b 45 08             	mov    0x8(%ebp),%eax
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	52                   	push   %edx
  801d50:	50                   	push   %eax
  801d51:	6a 18                	push   $0x18
  801d53:	e8 8a fd ff ff       	call   801ae2 <syscall>
  801d58:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  801d5b:	c9                   	leave  
  801d5c:	c3                   	ret    

00801d5d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  801d5d:	55                   	push   %ebp
  801d5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  801d60:	8b 45 08             	mov    0x8(%ebp),%eax
  801d63:	6a 00                	push   $0x0
  801d65:	ff 75 14             	pushl  0x14(%ebp)
  801d68:	ff 75 10             	pushl  0x10(%ebp)
  801d6b:	ff 75 0c             	pushl  0xc(%ebp)
  801d6e:	50                   	push   %eax
  801d6f:	6a 19                	push   $0x19
  801d71:	e8 6c fd ff ff       	call   801ae2 <syscall>
  801d76:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  801d79:	c9                   	leave  
  801d7a:	c3                   	ret    

00801d7b <sys_run_env>:

void sys_run_env(int32 envId) {
  801d7b:	55                   	push   %ebp
  801d7c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  801d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d81:	6a 00                	push   $0x0
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	50                   	push   %eax
  801d8a:	6a 1a                	push   $0x1a
  801d8c:	e8 51 fd ff ff       	call   801ae2 <syscall>
  801d91:	83 c4 18             	add    $0x18,%esp
}
  801d94:	90                   	nop
  801d95:	c9                   	leave  
  801d96:	c3                   	ret    

00801d97 <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  801d97:	55                   	push   %ebp
  801d98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 00                	push   $0x0
  801da3:	6a 00                	push   $0x0
  801da5:	50                   	push   %eax
  801da6:	6a 1b                	push   $0x1b
  801da8:	e8 35 fd ff ff       	call   801ae2 <syscall>
  801dad:	83 c4 18             	add    $0x18,%esp
}
  801db0:	c9                   	leave  
  801db1:	c3                   	ret    

00801db2 <sys_getenvid>:

int32 sys_getenvid(void) {
  801db2:	55                   	push   %ebp
  801db3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 05                	push   $0x5
  801dc1:	e8 1c fd ff ff       	call   801ae2 <syscall>
  801dc6:	83 c4 18             	add    $0x18,%esp
}
  801dc9:	c9                   	leave  
  801dca:	c3                   	ret    

00801dcb <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  801dcb:	55                   	push   %ebp
  801dcc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 06                	push   $0x6
  801dda:	e8 03 fd ff ff       	call   801ae2 <syscall>
  801ddf:	83 c4 18             	add    $0x18,%esp
}
  801de2:	c9                   	leave  
  801de3:	c3                   	ret    

00801de4 <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  801de4:	55                   	push   %ebp
  801de5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801de7:	6a 00                	push   $0x0
  801de9:	6a 00                	push   $0x0
  801deb:	6a 00                	push   $0x0
  801ded:	6a 00                	push   $0x0
  801def:	6a 00                	push   $0x0
  801df1:	6a 07                	push   $0x7
  801df3:	e8 ea fc ff ff       	call   801ae2 <syscall>
  801df8:	83 c4 18             	add    $0x18,%esp
}
  801dfb:	c9                   	leave  
  801dfc:	c3                   	ret    

00801dfd <sys_exit_env>:

void sys_exit_env(void) {
  801dfd:	55                   	push   %ebp
  801dfe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801e00:	6a 00                	push   $0x0
  801e02:	6a 00                	push   $0x0
  801e04:	6a 00                	push   $0x0
  801e06:	6a 00                	push   $0x0
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 1c                	push   $0x1c
  801e0c:	e8 d1 fc ff ff       	call   801ae2 <syscall>
  801e11:	83 c4 18             	add    $0x18,%esp
}
  801e14:	90                   	nop
  801e15:	c9                   	leave  
  801e16:	c3                   	ret    

00801e17 <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  801e17:	55                   	push   %ebp
  801e18:	89 e5                	mov    %esp,%ebp
  801e1a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  801e1d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e20:	8d 50 04             	lea    0x4(%eax),%edx
  801e23:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e26:	6a 00                	push   $0x0
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 00                	push   $0x0
  801e2c:	52                   	push   %edx
  801e2d:	50                   	push   %eax
  801e2e:	6a 1d                	push   $0x1d
  801e30:	e8 ad fc ff ff       	call   801ae2 <syscall>
  801e35:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  801e38:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e3b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e3e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e41:	89 01                	mov    %eax,(%ecx)
  801e43:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e46:	8b 45 08             	mov    0x8(%ebp),%eax
  801e49:	c9                   	leave  
  801e4a:	c2 04 00             	ret    $0x4

00801e4d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  801e4d:	55                   	push   %ebp
  801e4e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  801e50:	6a 00                	push   $0x0
  801e52:	6a 00                	push   $0x0
  801e54:	ff 75 10             	pushl  0x10(%ebp)
  801e57:	ff 75 0c             	pushl  0xc(%ebp)
  801e5a:	ff 75 08             	pushl  0x8(%ebp)
  801e5d:	6a 13                	push   $0x13
  801e5f:	e8 7e fc ff ff       	call   801ae2 <syscall>
  801e64:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  801e67:	90                   	nop
}
  801e68:	c9                   	leave  
  801e69:	c3                   	ret    

00801e6a <sys_rcr2>:
uint32 sys_rcr2() {
  801e6a:	55                   	push   %ebp
  801e6b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	6a 00                	push   $0x0
  801e75:	6a 00                	push   $0x0
  801e77:	6a 1e                	push   $0x1e
  801e79:	e8 64 fc ff ff       	call   801ae2 <syscall>
  801e7e:	83 c4 18             	add    $0x18,%esp
}
  801e81:	c9                   	leave  
  801e82:	c3                   	ret    

00801e83 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  801e83:	55                   	push   %ebp
  801e84:	89 e5                	mov    %esp,%ebp
  801e86:	83 ec 04             	sub    $0x4,%esp
  801e89:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e8f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e93:	6a 00                	push   $0x0
  801e95:	6a 00                	push   $0x0
  801e97:	6a 00                	push   $0x0
  801e99:	6a 00                	push   $0x0
  801e9b:	50                   	push   %eax
  801e9c:	6a 1f                	push   $0x1f
  801e9e:	e8 3f fc ff ff       	call   801ae2 <syscall>
  801ea3:	83 c4 18             	add    $0x18,%esp
	return;
  801ea6:	90                   	nop
}
  801ea7:	c9                   	leave  
  801ea8:	c3                   	ret    

00801ea9 <rsttst>:
void rsttst() {
  801ea9:	55                   	push   %ebp
  801eaa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801eac:	6a 00                	push   $0x0
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 21                	push   $0x21
  801eb8:	e8 25 fc ff ff       	call   801ae2 <syscall>
  801ebd:	83 c4 18             	add    $0x18,%esp
	return;
  801ec0:	90                   	nop
}
  801ec1:	c9                   	leave  
  801ec2:	c3                   	ret    

00801ec3 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  801ec3:	55                   	push   %ebp
  801ec4:	89 e5                	mov    %esp,%ebp
  801ec6:	83 ec 04             	sub    $0x4,%esp
  801ec9:	8b 45 14             	mov    0x14(%ebp),%eax
  801ecc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ecf:	8b 55 18             	mov    0x18(%ebp),%edx
  801ed2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ed6:	52                   	push   %edx
  801ed7:	50                   	push   %eax
  801ed8:	ff 75 10             	pushl  0x10(%ebp)
  801edb:	ff 75 0c             	pushl  0xc(%ebp)
  801ede:	ff 75 08             	pushl  0x8(%ebp)
  801ee1:	6a 20                	push   $0x20
  801ee3:	e8 fa fb ff ff       	call   801ae2 <syscall>
  801ee8:	83 c4 18             	add    $0x18,%esp
	return;
  801eeb:	90                   	nop
}
  801eec:	c9                   	leave  
  801eed:	c3                   	ret    

00801eee <chktst>:
void chktst(uint32 n) {
  801eee:	55                   	push   %ebp
  801eef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ef1:	6a 00                	push   $0x0
  801ef3:	6a 00                	push   $0x0
  801ef5:	6a 00                	push   $0x0
  801ef7:	6a 00                	push   $0x0
  801ef9:	ff 75 08             	pushl  0x8(%ebp)
  801efc:	6a 22                	push   $0x22
  801efe:	e8 df fb ff ff       	call   801ae2 <syscall>
  801f03:	83 c4 18             	add    $0x18,%esp
	return;
  801f06:	90                   	nop
}
  801f07:	c9                   	leave  
  801f08:	c3                   	ret    

00801f09 <inctst>:

void inctst() {
  801f09:	55                   	push   %ebp
  801f0a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f0c:	6a 00                	push   $0x0
  801f0e:	6a 00                	push   $0x0
  801f10:	6a 00                	push   $0x0
  801f12:	6a 00                	push   $0x0
  801f14:	6a 00                	push   $0x0
  801f16:	6a 23                	push   $0x23
  801f18:	e8 c5 fb ff ff       	call   801ae2 <syscall>
  801f1d:	83 c4 18             	add    $0x18,%esp
	return;
  801f20:	90                   	nop
}
  801f21:	c9                   	leave  
  801f22:	c3                   	ret    

00801f23 <gettst>:
uint32 gettst() {
  801f23:	55                   	push   %ebp
  801f24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f26:	6a 00                	push   $0x0
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 00                	push   $0x0
  801f2c:	6a 00                	push   $0x0
  801f2e:	6a 00                	push   $0x0
  801f30:	6a 24                	push   $0x24
  801f32:	e8 ab fb ff ff       	call   801ae2 <syscall>
  801f37:	83 c4 18             	add    $0x18,%esp
}
  801f3a:	c9                   	leave  
  801f3b:	c3                   	ret    

00801f3c <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  801f3c:	55                   	push   %ebp
  801f3d:	89 e5                	mov    %esp,%ebp
  801f3f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f42:	6a 00                	push   $0x0
  801f44:	6a 00                	push   $0x0
  801f46:	6a 00                	push   $0x0
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 25                	push   $0x25
  801f4e:	e8 8f fb ff ff       	call   801ae2 <syscall>
  801f53:	83 c4 18             	add    $0x18,%esp
  801f56:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f59:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f5d:	75 07                	jne    801f66 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f5f:	b8 01 00 00 00       	mov    $0x1,%eax
  801f64:	eb 05                	jmp    801f6b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f66:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f6b:	c9                   	leave  
  801f6c:	c3                   	ret    

00801f6d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  801f6d:	55                   	push   %ebp
  801f6e:	89 e5                	mov    %esp,%ebp
  801f70:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f73:	6a 00                	push   $0x0
  801f75:	6a 00                	push   $0x0
  801f77:	6a 00                	push   $0x0
  801f79:	6a 00                	push   $0x0
  801f7b:	6a 00                	push   $0x0
  801f7d:	6a 25                	push   $0x25
  801f7f:	e8 5e fb ff ff       	call   801ae2 <syscall>
  801f84:	83 c4 18             	add    $0x18,%esp
  801f87:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f8a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f8e:	75 07                	jne    801f97 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f90:	b8 01 00 00 00       	mov    $0x1,%eax
  801f95:	eb 05                	jmp    801f9c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f97:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f9c:	c9                   	leave  
  801f9d:	c3                   	ret    

00801f9e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  801f9e:	55                   	push   %ebp
  801f9f:	89 e5                	mov    %esp,%ebp
  801fa1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fa4:	6a 00                	push   $0x0
  801fa6:	6a 00                	push   $0x0
  801fa8:	6a 00                	push   $0x0
  801faa:	6a 00                	push   $0x0
  801fac:	6a 00                	push   $0x0
  801fae:	6a 25                	push   $0x25
  801fb0:	e8 2d fb ff ff       	call   801ae2 <syscall>
  801fb5:	83 c4 18             	add    $0x18,%esp
  801fb8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801fbb:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801fbf:	75 07                	jne    801fc8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801fc1:	b8 01 00 00 00       	mov    $0x1,%eax
  801fc6:	eb 05                	jmp    801fcd <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801fc8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fcd:	c9                   	leave  
  801fce:	c3                   	ret    

00801fcf <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  801fcf:	55                   	push   %ebp
  801fd0:	89 e5                	mov    %esp,%ebp
  801fd2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fd5:	6a 00                	push   $0x0
  801fd7:	6a 00                	push   $0x0
  801fd9:	6a 00                	push   $0x0
  801fdb:	6a 00                	push   $0x0
  801fdd:	6a 00                	push   $0x0
  801fdf:	6a 25                	push   $0x25
  801fe1:	e8 fc fa ff ff       	call   801ae2 <syscall>
  801fe6:	83 c4 18             	add    $0x18,%esp
  801fe9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801fec:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ff0:	75 07                	jne    801ff9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ff2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ff7:	eb 05                	jmp    801ffe <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ff9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ffe:	c9                   	leave  
  801fff:	c3                   	ret    

00802000 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  802000:	55                   	push   %ebp
  802001:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802003:	6a 00                	push   $0x0
  802005:	6a 00                	push   $0x0
  802007:	6a 00                	push   $0x0
  802009:	6a 00                	push   $0x0
  80200b:	ff 75 08             	pushl  0x8(%ebp)
  80200e:	6a 26                	push   $0x26
  802010:	e8 cd fa ff ff       	call   801ae2 <syscall>
  802015:	83 c4 18             	add    $0x18,%esp
	return;
  802018:	90                   	nop
}
  802019:	c9                   	leave  
  80201a:	c3                   	ret    

0080201b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  80201b:	55                   	push   %ebp
  80201c:	89 e5                	mov    %esp,%ebp
  80201e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  80201f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802022:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802025:	8b 55 0c             	mov    0xc(%ebp),%edx
  802028:	8b 45 08             	mov    0x8(%ebp),%eax
  80202b:	6a 00                	push   $0x0
  80202d:	53                   	push   %ebx
  80202e:	51                   	push   %ecx
  80202f:	52                   	push   %edx
  802030:	50                   	push   %eax
  802031:	6a 27                	push   $0x27
  802033:	e8 aa fa ff ff       	call   801ae2 <syscall>
  802038:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  80203b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80203e:	c9                   	leave  
  80203f:	c3                   	ret    

00802040 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  802040:	55                   	push   %ebp
  802041:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  802043:	8b 55 0c             	mov    0xc(%ebp),%edx
  802046:	8b 45 08             	mov    0x8(%ebp),%eax
  802049:	6a 00                	push   $0x0
  80204b:	6a 00                	push   $0x0
  80204d:	6a 00                	push   $0x0
  80204f:	52                   	push   %edx
  802050:	50                   	push   %eax
  802051:	6a 28                	push   $0x28
  802053:	e8 8a fa ff ff       	call   801ae2 <syscall>
  802058:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  80205b:	c9                   	leave  
  80205c:	c3                   	ret    

0080205d <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  80205d:	55                   	push   %ebp
  80205e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  802060:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802063:	8b 55 0c             	mov    0xc(%ebp),%edx
  802066:	8b 45 08             	mov    0x8(%ebp),%eax
  802069:	6a 00                	push   $0x0
  80206b:	51                   	push   %ecx
  80206c:	ff 75 10             	pushl  0x10(%ebp)
  80206f:	52                   	push   %edx
  802070:	50                   	push   %eax
  802071:	6a 29                	push   $0x29
  802073:	e8 6a fa ff ff       	call   801ae2 <syscall>
  802078:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  80207b:	c9                   	leave  
  80207c:	c3                   	ret    

0080207d <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  80207d:	55                   	push   %ebp
  80207e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802080:	6a 00                	push   $0x0
  802082:	6a 00                	push   $0x0
  802084:	ff 75 10             	pushl  0x10(%ebp)
  802087:	ff 75 0c             	pushl  0xc(%ebp)
  80208a:	ff 75 08             	pushl  0x8(%ebp)
  80208d:	6a 12                	push   $0x12
  80208f:	e8 4e fa ff ff       	call   801ae2 <syscall>
  802094:	83 c4 18             	add    $0x18,%esp
	return;
  802097:	90                   	nop
}
  802098:	c9                   	leave  
  802099:	c3                   	ret    

0080209a <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  80209a:	55                   	push   %ebp
  80209b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  80209d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a3:	6a 00                	push   $0x0
  8020a5:	6a 00                	push   $0x0
  8020a7:	6a 00                	push   $0x0
  8020a9:	52                   	push   %edx
  8020aa:	50                   	push   %eax
  8020ab:	6a 2a                	push   $0x2a
  8020ad:	e8 30 fa ff ff       	call   801ae2 <syscall>
  8020b2:	83 c4 18             	add    $0x18,%esp
	return;
  8020b5:	90                   	nop
}
  8020b6:	c9                   	leave  
  8020b7:	c3                   	ret    

008020b8 <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  8020b8:	55                   	push   %ebp
  8020b9:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  8020bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020be:	6a 00                	push   $0x0
  8020c0:	6a 00                	push   $0x0
  8020c2:	6a 00                	push   $0x0
  8020c4:	6a 00                	push   $0x0
  8020c6:	50                   	push   %eax
  8020c7:	6a 2b                	push   $0x2b
  8020c9:	e8 14 fa ff ff       	call   801ae2 <syscall>
  8020ce:	83 c4 18             	add    $0x18,%esp
}
  8020d1:	c9                   	leave  
  8020d2:	c3                   	ret    

008020d3 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  8020d3:	55                   	push   %ebp
  8020d4:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8020d6:	6a 00                	push   $0x0
  8020d8:	6a 00                	push   $0x0
  8020da:	6a 00                	push   $0x0
  8020dc:	ff 75 0c             	pushl  0xc(%ebp)
  8020df:	ff 75 08             	pushl  0x8(%ebp)
  8020e2:	6a 2c                	push   $0x2c
  8020e4:	e8 f9 f9 ff ff       	call   801ae2 <syscall>
  8020e9:	83 c4 18             	add    $0x18,%esp
	return;
  8020ec:	90                   	nop
}
  8020ed:	c9                   	leave  
  8020ee:	c3                   	ret    

008020ef <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  8020ef:	55                   	push   %ebp
  8020f0:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8020f2:	6a 00                	push   $0x0
  8020f4:	6a 00                	push   $0x0
  8020f6:	6a 00                	push   $0x0
  8020f8:	ff 75 0c             	pushl  0xc(%ebp)
  8020fb:	ff 75 08             	pushl  0x8(%ebp)
  8020fe:	6a 2d                	push   $0x2d
  802100:	e8 dd f9 ff ff       	call   801ae2 <syscall>
  802105:	83 c4 18             	add    $0x18,%esp
	return;
  802108:	90                   	nop
}
  802109:	c9                   	leave  
  80210a:	c3                   	ret    

0080210b <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  80210b:	55                   	push   %ebp
  80210c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  80210e:	8b 45 08             	mov    0x8(%ebp),%eax
  802111:	6a 00                	push   $0x0
  802113:	6a 00                	push   $0x0
  802115:	6a 00                	push   $0x0
  802117:	6a 00                	push   $0x0
  802119:	50                   	push   %eax
  80211a:	6a 2f                	push   $0x2f
  80211c:	e8 c1 f9 ff ff       	call   801ae2 <syscall>
  802121:	83 c4 18             	add    $0x18,%esp
	return;
  802124:	90                   	nop
}
  802125:	c9                   	leave  
  802126:	c3                   	ret    

00802127 <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  802127:	55                   	push   %ebp
  802128:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  80212a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80212d:	8b 45 08             	mov    0x8(%ebp),%eax
  802130:	6a 00                	push   $0x0
  802132:	6a 00                	push   $0x0
  802134:	6a 00                	push   $0x0
  802136:	52                   	push   %edx
  802137:	50                   	push   %eax
  802138:	6a 30                	push   $0x30
  80213a:	e8 a3 f9 ff ff       	call   801ae2 <syscall>
  80213f:	83 c4 18             	add    $0x18,%esp
	return;
  802142:	90                   	nop
}
  802143:	c9                   	leave  
  802144:	c3                   	ret    

00802145 <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  802145:	55                   	push   %ebp
  802146:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  802148:	8b 45 08             	mov    0x8(%ebp),%eax
  80214b:	6a 00                	push   $0x0
  80214d:	6a 00                	push   $0x0
  80214f:	6a 00                	push   $0x0
  802151:	6a 00                	push   $0x0
  802153:	50                   	push   %eax
  802154:	6a 31                	push   $0x31
  802156:	e8 87 f9 ff ff       	call   801ae2 <syscall>
  80215b:	83 c4 18             	add    $0x18,%esp
	return;
  80215e:	90                   	nop
}
  80215f:	c9                   	leave  
  802160:	c3                   	ret    

00802161 <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  802161:	55                   	push   %ebp
  802162:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  802164:	8b 55 0c             	mov    0xc(%ebp),%edx
  802167:	8b 45 08             	mov    0x8(%ebp),%eax
  80216a:	6a 00                	push   $0x0
  80216c:	6a 00                	push   $0x0
  80216e:	6a 00                	push   $0x0
  802170:	52                   	push   %edx
  802171:	50                   	push   %eax
  802172:	6a 2e                	push   $0x2e
  802174:	e8 69 f9 ff ff       	call   801ae2 <syscall>
  802179:	83 c4 18             	add    $0x18,%esp
    return;
  80217c:	90                   	nop
}
  80217d:	c9                   	leave  
  80217e:	c3                   	ret    

0080217f <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  80217f:	55                   	push   %ebp
  802180:	89 e5                	mov    %esp,%ebp
  802182:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802185:	8b 45 08             	mov    0x8(%ebp),%eax
  802188:	83 e8 04             	sub    $0x4,%eax
  80218b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  80218e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802191:	8b 00                	mov    (%eax),%eax
  802193:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802196:	c9                   	leave  
  802197:	c3                   	ret    

00802198 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802198:	55                   	push   %ebp
  802199:	89 e5                	mov    %esp,%ebp
  80219b:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80219e:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a1:	83 e8 04             	sub    $0x4,%eax
  8021a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  8021a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021aa:	8b 00                	mov    (%eax),%eax
  8021ac:	83 e0 01             	and    $0x1,%eax
  8021af:	85 c0                	test   %eax,%eax
  8021b1:	0f 94 c0             	sete   %al
}
  8021b4:	c9                   	leave  
  8021b5:	c3                   	ret    

008021b6 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8021b6:	55                   	push   %ebp
  8021b7:	89 e5                	mov    %esp,%ebp
  8021b9:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8021bc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8021c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021c6:	83 f8 02             	cmp    $0x2,%eax
  8021c9:	74 2b                	je     8021f6 <alloc_block+0x40>
  8021cb:	83 f8 02             	cmp    $0x2,%eax
  8021ce:	7f 07                	jg     8021d7 <alloc_block+0x21>
  8021d0:	83 f8 01             	cmp    $0x1,%eax
  8021d3:	74 0e                	je     8021e3 <alloc_block+0x2d>
  8021d5:	eb 58                	jmp    80222f <alloc_block+0x79>
  8021d7:	83 f8 03             	cmp    $0x3,%eax
  8021da:	74 2d                	je     802209 <alloc_block+0x53>
  8021dc:	83 f8 04             	cmp    $0x4,%eax
  8021df:	74 3b                	je     80221c <alloc_block+0x66>
  8021e1:	eb 4c                	jmp    80222f <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8021e3:	83 ec 0c             	sub    $0xc,%esp
  8021e6:	ff 75 08             	pushl  0x8(%ebp)
  8021e9:	e8 f7 03 00 00       	call   8025e5 <alloc_block_FF>
  8021ee:	83 c4 10             	add    $0x10,%esp
  8021f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8021f4:	eb 4a                	jmp    802240 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8021f6:	83 ec 0c             	sub    $0xc,%esp
  8021f9:	ff 75 08             	pushl  0x8(%ebp)
  8021fc:	e8 f0 11 00 00       	call   8033f1 <alloc_block_NF>
  802201:	83 c4 10             	add    $0x10,%esp
  802204:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802207:	eb 37                	jmp    802240 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802209:	83 ec 0c             	sub    $0xc,%esp
  80220c:	ff 75 08             	pushl  0x8(%ebp)
  80220f:	e8 08 08 00 00       	call   802a1c <alloc_block_BF>
  802214:	83 c4 10             	add    $0x10,%esp
  802217:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80221a:	eb 24                	jmp    802240 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  80221c:	83 ec 0c             	sub    $0xc,%esp
  80221f:	ff 75 08             	pushl  0x8(%ebp)
  802222:	e8 ad 11 00 00       	call   8033d4 <alloc_block_WF>
  802227:	83 c4 10             	add    $0x10,%esp
  80222a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80222d:	eb 11                	jmp    802240 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  80222f:	83 ec 0c             	sub    $0xc,%esp
  802232:	68 38 41 80 00       	push   $0x804138
  802237:	e8 41 e4 ff ff       	call   80067d <cprintf>
  80223c:	83 c4 10             	add    $0x10,%esp
		break;
  80223f:	90                   	nop
	}
	return va;
  802240:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802243:	c9                   	leave  
  802244:	c3                   	ret    

00802245 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802245:	55                   	push   %ebp
  802246:	89 e5                	mov    %esp,%ebp
  802248:	53                   	push   %ebx
  802249:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  80224c:	83 ec 0c             	sub    $0xc,%esp
  80224f:	68 58 41 80 00       	push   $0x804158
  802254:	e8 24 e4 ff ff       	call   80067d <cprintf>
  802259:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  80225c:	83 ec 0c             	sub    $0xc,%esp
  80225f:	68 83 41 80 00       	push   $0x804183
  802264:	e8 14 e4 ff ff       	call   80067d <cprintf>
  802269:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  80226c:	8b 45 08             	mov    0x8(%ebp),%eax
  80226f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802272:	eb 37                	jmp    8022ab <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802274:	83 ec 0c             	sub    $0xc,%esp
  802277:	ff 75 f4             	pushl  -0xc(%ebp)
  80227a:	e8 19 ff ff ff       	call   802198 <is_free_block>
  80227f:	83 c4 10             	add    $0x10,%esp
  802282:	0f be d8             	movsbl %al,%ebx
  802285:	83 ec 0c             	sub    $0xc,%esp
  802288:	ff 75 f4             	pushl  -0xc(%ebp)
  80228b:	e8 ef fe ff ff       	call   80217f <get_block_size>
  802290:	83 c4 10             	add    $0x10,%esp
  802293:	83 ec 04             	sub    $0x4,%esp
  802296:	53                   	push   %ebx
  802297:	50                   	push   %eax
  802298:	68 9b 41 80 00       	push   $0x80419b
  80229d:	e8 db e3 ff ff       	call   80067d <cprintf>
  8022a2:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8022a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8022a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022af:	74 07                	je     8022b8 <print_blocks_list+0x73>
  8022b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b4:	8b 00                	mov    (%eax),%eax
  8022b6:	eb 05                	jmp    8022bd <print_blocks_list+0x78>
  8022b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8022bd:	89 45 10             	mov    %eax,0x10(%ebp)
  8022c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8022c3:	85 c0                	test   %eax,%eax
  8022c5:	75 ad                	jne    802274 <print_blocks_list+0x2f>
  8022c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022cb:	75 a7                	jne    802274 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8022cd:	83 ec 0c             	sub    $0xc,%esp
  8022d0:	68 58 41 80 00       	push   $0x804158
  8022d5:	e8 a3 e3 ff ff       	call   80067d <cprintf>
  8022da:	83 c4 10             	add    $0x10,%esp

}
  8022dd:	90                   	nop
  8022de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022e1:	c9                   	leave  
  8022e2:	c3                   	ret    

008022e3 <initialize_dynamic_allocator>:

//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8022e3:	55                   	push   %ebp
  8022e4:	89 e5                	mov    %esp,%ebp
  8022e6:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8022e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ec:	83 e0 01             	and    $0x1,%eax
  8022ef:	85 c0                	test   %eax,%eax
  8022f1:	74 03                	je     8022f6 <initialize_dynamic_allocator+0x13>
  8022f3:	ff 45 0c             	incl   0xc(%ebp)
		if (initSizeOfAllocatedSpace == 0)
  8022f6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8022fa:	0f 84 f8 00 00 00    	je     8023f8 <initialize_dynamic_allocator+0x115>
			return ;
		is_initialized = 1;
  802300:	c7 05 40 50 98 00 01 	movl   $0x1,0x985040
  802307:	00 00 00 
	//TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("initialize_dynamic_allocator is not implemented yet");
	//Your Code is Here...

	if(is_initialized){
  80230a:	a1 40 50 98 00       	mov    0x985040,%eax
  80230f:	85 c0                	test   %eax,%eax
  802311:	0f 84 e2 00 00 00    	je     8023f9 <initialize_dynamic_allocator+0x116>

		// begin block with size 0 and lsb = 1 (allocated)
		uint32* beginBlock = (uint32*)daStart;
  802317:	8b 45 08             	mov    0x8(%ebp),%eax
  80231a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		*beginBlock = 0 | 1; // size = 0, LSB as a flag = 1
  80231d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802320:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		// end block with size 0 and lsb = 1 (allocated)
		uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);
  802326:	8b 55 08             	mov    0x8(%ebp),%edx
  802329:	8b 45 0c             	mov    0xc(%ebp),%eax
  80232c:	01 d0                	add    %edx,%eax
  80232e:	83 e8 04             	sub    $0x4,%eax
  802331:	89 45 f0             	mov    %eax,-0x10(%ebp)
		*endBlock = 0 | 1; // size = 0, LSB as a flag = 1
  802334:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802337:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

		// the block that between begin and end blocks
		struct BlockElement* block = (struct BlockElement*)(daStart + 8);
  80233d:	8b 45 08             	mov    0x8(%ebp),%eax
  802340:	83 c0 08             	add    $0x8,%eax
  802343:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 blockSize = initSizeOfAllocatedSpace - 8; // subtract size of begin and end blocks
  802346:	8b 45 0c             	mov    0xc(%ebp),%eax
  802349:	83 e8 08             	sub    $0x8,%eax
  80234c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(block,blockSize,0);
  80234f:	83 ec 04             	sub    $0x4,%esp
  802352:	6a 00                	push   $0x0
  802354:	ff 75 e8             	pushl  -0x18(%ebp)
  802357:	ff 75 ec             	pushl  -0x14(%ebp)
  80235a:	e8 9c 00 00 00       	call   8023fb <set_block_data>
  80235f:	83 c4 10             	add    $0x10,%esp

		block->prev_next_info.le_next = NULL;
  802362:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802365:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block->prev_next_info.le_prev = NULL;
  80236b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80236e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

		LIST_INIT(&freeBlocksList);
  802375:	c7 05 48 50 98 00 00 	movl   $0x0,0x985048
  80237c:	00 00 00 
  80237f:	c7 05 4c 50 98 00 00 	movl   $0x0,0x98504c
  802386:	00 00 00 
  802389:	c7 05 54 50 98 00 00 	movl   $0x0,0x985054
  802390:	00 00 00 
		LIST_INSERT_HEAD(&freeBlocksList, block);
  802393:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802397:	75 17                	jne    8023b0 <initialize_dynamic_allocator+0xcd>
  802399:	83 ec 04             	sub    $0x4,%esp
  80239c:	68 b4 41 80 00       	push   $0x8041b4
  8023a1:	68 80 00 00 00       	push   $0x80
  8023a6:	68 d7 41 80 00       	push   $0x8041d7
  8023ab:	e8 10 e0 ff ff       	call   8003c0 <_panic>
  8023b0:	8b 15 48 50 98 00    	mov    0x985048,%edx
  8023b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023b9:	89 10                	mov    %edx,(%eax)
  8023bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023be:	8b 00                	mov    (%eax),%eax
  8023c0:	85 c0                	test   %eax,%eax
  8023c2:	74 0d                	je     8023d1 <initialize_dynamic_allocator+0xee>
  8023c4:	a1 48 50 98 00       	mov    0x985048,%eax
  8023c9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023cc:	89 50 04             	mov    %edx,0x4(%eax)
  8023cf:	eb 08                	jmp    8023d9 <initialize_dynamic_allocator+0xf6>
  8023d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023d4:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8023d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023dc:	a3 48 50 98 00       	mov    %eax,0x985048
  8023e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023e4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023eb:	a1 54 50 98 00       	mov    0x985054,%eax
  8023f0:	40                   	inc    %eax
  8023f1:	a3 54 50 98 00       	mov    %eax,0x985054
  8023f6:	eb 01                	jmp    8023f9 <initialize_dynamic_allocator+0x116>
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
		if (initSizeOfAllocatedSpace == 0)
			return ;
  8023f8:	90                   	nop
		block->prev_next_info.le_prev = NULL;

		LIST_INIT(&freeBlocksList);
		LIST_INSERT_HEAD(&freeBlocksList, block);
	}
}
  8023f9:	c9                   	leave  
  8023fa:	c3                   	ret    

008023fb <set_block_data>:
//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8023fb:	55                   	push   %ebp
  8023fc:	89 e5                	mov    %esp,%ebp
  8023fe:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("set_block_data is not implemented yet");
	//Your Code is Here...

	if(totalSize % 2 != 0)
  802401:	8b 45 0c             	mov    0xc(%ebp),%eax
  802404:	83 e0 01             	and    $0x1,%eax
  802407:	85 c0                	test   %eax,%eax
  802409:	74 03                	je     80240e <set_block_data+0x13>
	{
		totalSize++;
  80240b:	ff 45 0c             	incl   0xc(%ebp)
	}

	uint32* header = (uint32 *)((uint32*)va-1);
  80240e:	8b 45 08             	mov    0x8(%ebp),%eax
  802411:	83 e8 04             	sub    $0x4,%eax
  802414:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//	size => totalSize with LSB = 0		 set LSB = 1 if isAllocated
	*header = (totalSize & ~1) | (isAllocated & 1);
  802417:	8b 45 0c             	mov    0xc(%ebp),%eax
  80241a:	83 e0 fe             	and    $0xfffffffe,%eax
  80241d:	89 c2                	mov    %eax,%edx
  80241f:	8b 45 10             	mov    0x10(%ebp),%eax
  802422:	83 e0 01             	and    $0x1,%eax
  802425:	09 c2                	or     %eax,%edx
  802427:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80242a:	89 10                	mov    %edx,(%eax)
	uint32* footer = (uint32*) (va + totalSize - 8);
  80242c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80242f:	8d 50 f8             	lea    -0x8(%eax),%edx
  802432:	8b 45 08             	mov    0x8(%ebp),%eax
  802435:	01 d0                	add    %edx,%eax
  802437:	89 45 f8             	mov    %eax,-0x8(%ebp)
	*footer = (totalSize & ~1) | (isAllocated & 1);
  80243a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80243d:	83 e0 fe             	and    $0xfffffffe,%eax
  802440:	89 c2                	mov    %eax,%edx
  802442:	8b 45 10             	mov    0x10(%ebp),%eax
  802445:	83 e0 01             	and    $0x1,%eax
  802448:	09 c2                	or     %eax,%edx
  80244a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80244d:	89 10                	mov    %edx,(%eax)
}
  80244f:	90                   	nop
  802450:	c9                   	leave  
  802451:	c3                   	ret    

00802452 <insert_sorted_in_freeList>:
//=========================================
void insert_sorted_in_freeList(struct BlockElement *newBlock)
{
  802452:	55                   	push   %ebp
  802453:	89 e5                	mov    %esp,%ebp
  802455:	83 ec 18             	sub    $0x18,%esp
	if(LIST_EMPTY(&freeBlocksList))
  802458:	a1 48 50 98 00       	mov    0x985048,%eax
  80245d:	85 c0                	test   %eax,%eax
  80245f:	75 68                	jne    8024c9 <insert_sorted_in_freeList+0x77>
	{
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
  802461:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802465:	75 17                	jne    80247e <insert_sorted_in_freeList+0x2c>
  802467:	83 ec 04             	sub    $0x4,%esp
  80246a:	68 b4 41 80 00       	push   $0x8041b4
  80246f:	68 9d 00 00 00       	push   $0x9d
  802474:	68 d7 41 80 00       	push   $0x8041d7
  802479:	e8 42 df ff ff       	call   8003c0 <_panic>
  80247e:	8b 15 48 50 98 00    	mov    0x985048,%edx
  802484:	8b 45 08             	mov    0x8(%ebp),%eax
  802487:	89 10                	mov    %edx,(%eax)
  802489:	8b 45 08             	mov    0x8(%ebp),%eax
  80248c:	8b 00                	mov    (%eax),%eax
  80248e:	85 c0                	test   %eax,%eax
  802490:	74 0d                	je     80249f <insert_sorted_in_freeList+0x4d>
  802492:	a1 48 50 98 00       	mov    0x985048,%eax
  802497:	8b 55 08             	mov    0x8(%ebp),%edx
  80249a:	89 50 04             	mov    %edx,0x4(%eax)
  80249d:	eb 08                	jmp    8024a7 <insert_sorted_in_freeList+0x55>
  80249f:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a2:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8024a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024aa:	a3 48 50 98 00       	mov    %eax,0x985048
  8024af:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024b9:	a1 54 50 98 00       	mov    0x985054,%eax
  8024be:	40                   	inc    %eax
  8024bf:	a3 54 50 98 00       	mov    %eax,0x985054
		return;
  8024c4:	e9 1a 01 00 00       	jmp    8025e3 <insert_sorted_in_freeList+0x191>
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  8024c9:	a1 48 50 98 00       	mov    0x985048,%eax
  8024ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024d1:	eb 7f                	jmp    802552 <insert_sorted_in_freeList+0x100>
	{
		if(blk > newBlock) // if address of blk > address of newBlock => add newBlock before blk
  8024d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024d9:	76 6f                	jbe    80254a <insert_sorted_in_freeList+0xf8>
		{
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
  8024db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024df:	74 06                	je     8024e7 <insert_sorted_in_freeList+0x95>
  8024e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024e5:	75 17                	jne    8024fe <insert_sorted_in_freeList+0xac>
  8024e7:	83 ec 04             	sub    $0x4,%esp
  8024ea:	68 f0 41 80 00       	push   $0x8041f0
  8024ef:	68 a6 00 00 00       	push   $0xa6
  8024f4:	68 d7 41 80 00       	push   $0x8041d7
  8024f9:	e8 c2 de ff ff       	call   8003c0 <_panic>
  8024fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802501:	8b 50 04             	mov    0x4(%eax),%edx
  802504:	8b 45 08             	mov    0x8(%ebp),%eax
  802507:	89 50 04             	mov    %edx,0x4(%eax)
  80250a:	8b 45 08             	mov    0x8(%ebp),%eax
  80250d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802510:	89 10                	mov    %edx,(%eax)
  802512:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802515:	8b 40 04             	mov    0x4(%eax),%eax
  802518:	85 c0                	test   %eax,%eax
  80251a:	74 0d                	je     802529 <insert_sorted_in_freeList+0xd7>
  80251c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251f:	8b 40 04             	mov    0x4(%eax),%eax
  802522:	8b 55 08             	mov    0x8(%ebp),%edx
  802525:	89 10                	mov    %edx,(%eax)
  802527:	eb 08                	jmp    802531 <insert_sorted_in_freeList+0xdf>
  802529:	8b 45 08             	mov    0x8(%ebp),%eax
  80252c:	a3 48 50 98 00       	mov    %eax,0x985048
  802531:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802534:	8b 55 08             	mov    0x8(%ebp),%edx
  802537:	89 50 04             	mov    %edx,0x4(%eax)
  80253a:	a1 54 50 98 00       	mov    0x985054,%eax
  80253f:	40                   	inc    %eax
  802540:	a3 54 50 98 00       	mov    %eax,0x985054
			return;
  802545:	e9 99 00 00 00       	jmp    8025e3 <insert_sorted_in_freeList+0x191>
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
		return;
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  80254a:	a1 50 50 98 00       	mov    0x985050,%eax
  80254f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802552:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802556:	74 07                	je     80255f <insert_sorted_in_freeList+0x10d>
  802558:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255b:	8b 00                	mov    (%eax),%eax
  80255d:	eb 05                	jmp    802564 <insert_sorted_in_freeList+0x112>
  80255f:	b8 00 00 00 00       	mov    $0x0,%eax
  802564:	a3 50 50 98 00       	mov    %eax,0x985050
  802569:	a1 50 50 98 00       	mov    0x985050,%eax
  80256e:	85 c0                	test   %eax,%eax
  802570:	0f 85 5d ff ff ff    	jne    8024d3 <insert_sorted_in_freeList+0x81>
  802576:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80257a:	0f 85 53 ff ff ff    	jne    8024d3 <insert_sorted_in_freeList+0x81>
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
			return;
		}
	}
	// if no blk its address > newBlock
	LIST_INSERT_TAIL(&freeBlocksList, newBlock);
  802580:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802584:	75 17                	jne    80259d <insert_sorted_in_freeList+0x14b>
  802586:	83 ec 04             	sub    $0x4,%esp
  802589:	68 28 42 80 00       	push   $0x804228
  80258e:	68 ab 00 00 00       	push   $0xab
  802593:	68 d7 41 80 00       	push   $0x8041d7
  802598:	e8 23 de ff ff       	call   8003c0 <_panic>
  80259d:	8b 15 4c 50 98 00    	mov    0x98504c,%edx
  8025a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a6:	89 50 04             	mov    %edx,0x4(%eax)
  8025a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ac:	8b 40 04             	mov    0x4(%eax),%eax
  8025af:	85 c0                	test   %eax,%eax
  8025b1:	74 0c                	je     8025bf <insert_sorted_in_freeList+0x16d>
  8025b3:	a1 4c 50 98 00       	mov    0x98504c,%eax
  8025b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8025bb:	89 10                	mov    %edx,(%eax)
  8025bd:	eb 08                	jmp    8025c7 <insert_sorted_in_freeList+0x175>
  8025bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c2:	a3 48 50 98 00       	mov    %eax,0x985048
  8025c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ca:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8025cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025d8:	a1 54 50 98 00       	mov    0x985054,%eax
  8025dd:	40                   	inc    %eax
  8025de:	a3 54 50 98 00       	mov    %eax,0x985054
}
  8025e3:	c9                   	leave  
  8025e4:	c3                   	ret    

008025e5 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  8025e5:	55                   	push   %ebp
  8025e6:	89 e5                	mov    %esp,%ebp
  8025e8:	83 ec 78             	sub    $0x78,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8025eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ee:	83 e0 01             	and    $0x1,%eax
  8025f1:	85 c0                	test   %eax,%eax
  8025f3:	74 03                	je     8025f8 <alloc_block_FF+0x13>
  8025f5:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8025f8:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8025fc:	77 07                	ja     802605 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8025fe:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802605:	a1 40 50 98 00       	mov    0x985040,%eax
  80260a:	85 c0                	test   %eax,%eax
  80260c:	75 63                	jne    802671 <alloc_block_FF+0x8c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80260e:	8b 45 08             	mov    0x8(%ebp),%eax
  802611:	83 c0 10             	add    $0x10,%eax
  802614:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802617:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80261e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802621:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802624:	01 d0                	add    %edx,%eax
  802626:	48                   	dec    %eax
  802627:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80262a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80262d:	ba 00 00 00 00       	mov    $0x0,%edx
  802632:	f7 75 ec             	divl   -0x14(%ebp)
  802635:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802638:	29 d0                	sub    %edx,%eax
  80263a:	c1 e8 0c             	shr    $0xc,%eax
  80263d:	83 ec 0c             	sub    $0xc,%esp
  802640:	50                   	push   %eax
  802641:	e8 d1 ed ff ff       	call   801417 <sbrk>
  802646:	83 c4 10             	add    $0x10,%esp
  802649:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80264c:	83 ec 0c             	sub    $0xc,%esp
  80264f:	6a 00                	push   $0x0
  802651:	e8 c1 ed ff ff       	call   801417 <sbrk>
  802656:	83 c4 10             	add    $0x10,%esp
  802659:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80265c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80265f:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802662:	83 ec 08             	sub    $0x8,%esp
  802665:	50                   	push   %eax
  802666:	ff 75 e4             	pushl  -0x1c(%ebp)
  802669:	e8 75 fc ff ff       	call   8022e3 <initialize_dynamic_allocator>
  80266e:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(size == 0)
  802671:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802675:	75 0a                	jne    802681 <alloc_block_FF+0x9c>
	{
		return NULL;
  802677:	b8 00 00 00 00       	mov    $0x0,%eax
  80267c:	e9 99 03 00 00       	jmp    802a1a <alloc_block_FF+0x435>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  802681:	8b 45 08             	mov    0x8(%ebp),%eax
  802684:	83 c0 08             	add    $0x8,%eax
  802687:	89 45 dc             	mov    %eax,-0x24(%ebp)

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  80268a:	a1 48 50 98 00       	mov    0x985048,%eax
  80268f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802692:	e9 03 02 00 00       	jmp    80289a <alloc_block_FF+0x2b5>
	{
		uint32 blockSize = get_block_size(block); // Get size without the (LSB) allocation flag
  802697:	83 ec 0c             	sub    $0xc,%esp
  80269a:	ff 75 f4             	pushl  -0xc(%ebp)
  80269d:	e8 dd fa ff ff       	call   80217f <get_block_size>
  8026a2:	83 c4 10             	add    $0x10,%esp
  8026a5:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if(blockSize >= totalSize)
  8026a8:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8026ab:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8026ae:	0f 82 de 01 00 00    	jb     802892 <alloc_block_FF+0x2ad>
		{	//if we can put another block with min size 16
			if(blockSize >= totalSize + 4*sizeof(uint32))
  8026b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8026b7:	83 c0 10             	add    $0x10,%eax
  8026ba:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  8026bd:	0f 87 32 01 00 00    	ja     8027f5 <alloc_block_FF+0x210>
			{
				// the size that will remain from the block that we will allocate a new block in it
				uint32 remainingSize = blockSize - totalSize;
  8026c3:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8026c6:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8026c9:	89 45 98             	mov    %eax,-0x68(%ebp)

				// the remaining free space from the block that we use to allocate in it
				struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)block + totalSize);
  8026cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8026d2:	01 d0                	add    %edx,%eax
  8026d4:	89 45 94             	mov    %eax,-0x6c(%ebp)
				set_block_data(remainingFreeBlock, remainingSize, 0);
  8026d7:	83 ec 04             	sub    $0x4,%esp
  8026da:	6a 00                	push   $0x0
  8026dc:	ff 75 98             	pushl  -0x68(%ebp)
  8026df:	ff 75 94             	pushl  -0x6c(%ebp)
  8026e2:	e8 14 fd ff ff       	call   8023fb <set_block_data>
  8026e7:	83 c4 10             	add    $0x10,%esp
				// add it after the block we allocated to be sorted by addresses
				LIST_INSERT_AFTER(&freeBlocksList, block,remainingFreeBlock);
  8026ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ee:	74 06                	je     8026f6 <alloc_block_FF+0x111>
  8026f0:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
  8026f4:	75 17                	jne    80270d <alloc_block_FF+0x128>
  8026f6:	83 ec 04             	sub    $0x4,%esp
  8026f9:	68 4c 42 80 00       	push   $0x80424c
  8026fe:	68 de 00 00 00       	push   $0xde
  802703:	68 d7 41 80 00       	push   $0x8041d7
  802708:	e8 b3 dc ff ff       	call   8003c0 <_panic>
  80270d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802710:	8b 10                	mov    (%eax),%edx
  802712:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802715:	89 10                	mov    %edx,(%eax)
  802717:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80271a:	8b 00                	mov    (%eax),%eax
  80271c:	85 c0                	test   %eax,%eax
  80271e:	74 0b                	je     80272b <alloc_block_FF+0x146>
  802720:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802723:	8b 00                	mov    (%eax),%eax
  802725:	8b 55 94             	mov    -0x6c(%ebp),%edx
  802728:	89 50 04             	mov    %edx,0x4(%eax)
  80272b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272e:	8b 55 94             	mov    -0x6c(%ebp),%edx
  802731:	89 10                	mov    %edx,(%eax)
  802733:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802736:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802739:	89 50 04             	mov    %edx,0x4(%eax)
  80273c:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80273f:	8b 00                	mov    (%eax),%eax
  802741:	85 c0                	test   %eax,%eax
  802743:	75 08                	jne    80274d <alloc_block_FF+0x168>
  802745:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802748:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80274d:	a1 54 50 98 00       	mov    0x985054,%eax
  802752:	40                   	inc    %eax
  802753:	a3 54 50 98 00       	mov    %eax,0x985054

				// update the allocated block and remove it from freeBlocksList
				set_block_data(block,totalSize,1);
  802758:	83 ec 04             	sub    $0x4,%esp
  80275b:	6a 01                	push   $0x1
  80275d:	ff 75 dc             	pushl  -0x24(%ebp)
  802760:	ff 75 f4             	pushl  -0xc(%ebp)
  802763:	e8 93 fc ff ff       	call   8023fb <set_block_data>
  802768:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  80276b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80276f:	75 17                	jne    802788 <alloc_block_FF+0x1a3>
  802771:	83 ec 04             	sub    $0x4,%esp
  802774:	68 80 42 80 00       	push   $0x804280
  802779:	68 e3 00 00 00       	push   $0xe3
  80277e:	68 d7 41 80 00       	push   $0x8041d7
  802783:	e8 38 dc ff ff       	call   8003c0 <_panic>
  802788:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278b:	8b 00                	mov    (%eax),%eax
  80278d:	85 c0                	test   %eax,%eax
  80278f:	74 10                	je     8027a1 <alloc_block_FF+0x1bc>
  802791:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802794:	8b 00                	mov    (%eax),%eax
  802796:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802799:	8b 52 04             	mov    0x4(%edx),%edx
  80279c:	89 50 04             	mov    %edx,0x4(%eax)
  80279f:	eb 0b                	jmp    8027ac <alloc_block_FF+0x1c7>
  8027a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a4:	8b 40 04             	mov    0x4(%eax),%eax
  8027a7:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8027ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027af:	8b 40 04             	mov    0x4(%eax),%eax
  8027b2:	85 c0                	test   %eax,%eax
  8027b4:	74 0f                	je     8027c5 <alloc_block_FF+0x1e0>
  8027b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b9:	8b 40 04             	mov    0x4(%eax),%eax
  8027bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027bf:	8b 12                	mov    (%edx),%edx
  8027c1:	89 10                	mov    %edx,(%eax)
  8027c3:	eb 0a                	jmp    8027cf <alloc_block_FF+0x1ea>
  8027c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c8:	8b 00                	mov    (%eax),%eax
  8027ca:	a3 48 50 98 00       	mov    %eax,0x985048
  8027cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027db:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027e2:	a1 54 50 98 00       	mov    0x985054,%eax
  8027e7:	48                   	dec    %eax
  8027e8:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  8027ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f0:	e9 25 02 00 00       	jmp    802a1a <alloc_block_FF+0x435>
			}
			else // if set internal fragmentation
			{
				// add the remaining size to the block we allocate so it will be the same main block size
				set_block_data(block,blockSize,1);
  8027f5:	83 ec 04             	sub    $0x4,%esp
  8027f8:	6a 01                	push   $0x1
  8027fa:	ff 75 9c             	pushl  -0x64(%ebp)
  8027fd:	ff 75 f4             	pushl  -0xc(%ebp)
  802800:	e8 f6 fb ff ff       	call   8023fb <set_block_data>
  802805:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  802808:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80280c:	75 17                	jne    802825 <alloc_block_FF+0x240>
  80280e:	83 ec 04             	sub    $0x4,%esp
  802811:	68 80 42 80 00       	push   $0x804280
  802816:	68 eb 00 00 00       	push   $0xeb
  80281b:	68 d7 41 80 00       	push   $0x8041d7
  802820:	e8 9b db ff ff       	call   8003c0 <_panic>
  802825:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802828:	8b 00                	mov    (%eax),%eax
  80282a:	85 c0                	test   %eax,%eax
  80282c:	74 10                	je     80283e <alloc_block_FF+0x259>
  80282e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802831:	8b 00                	mov    (%eax),%eax
  802833:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802836:	8b 52 04             	mov    0x4(%edx),%edx
  802839:	89 50 04             	mov    %edx,0x4(%eax)
  80283c:	eb 0b                	jmp    802849 <alloc_block_FF+0x264>
  80283e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802841:	8b 40 04             	mov    0x4(%eax),%eax
  802844:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802849:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284c:	8b 40 04             	mov    0x4(%eax),%eax
  80284f:	85 c0                	test   %eax,%eax
  802851:	74 0f                	je     802862 <alloc_block_FF+0x27d>
  802853:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802856:	8b 40 04             	mov    0x4(%eax),%eax
  802859:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80285c:	8b 12                	mov    (%edx),%edx
  80285e:	89 10                	mov    %edx,(%eax)
  802860:	eb 0a                	jmp    80286c <alloc_block_FF+0x287>
  802862:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802865:	8b 00                	mov    (%eax),%eax
  802867:	a3 48 50 98 00       	mov    %eax,0x985048
  80286c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802875:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802878:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80287f:	a1 54 50 98 00       	mov    0x985054,%eax
  802884:	48                   	dec    %eax
  802885:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  80288a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288d:	e9 88 01 00 00       	jmp    802a1a <alloc_block_FF+0x435>
		return NULL;
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802892:	a1 50 50 98 00       	mov    0x985050,%eax
  802897:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80289a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80289e:	74 07                	je     8028a7 <alloc_block_FF+0x2c2>
  8028a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a3:	8b 00                	mov    (%eax),%eax
  8028a5:	eb 05                	jmp    8028ac <alloc_block_FF+0x2c7>
  8028a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8028ac:	a3 50 50 98 00       	mov    %eax,0x985050
  8028b1:	a1 50 50 98 00       	mov    0x985050,%eax
  8028b6:	85 c0                	test   %eax,%eax
  8028b8:	0f 85 d9 fd ff ff    	jne    802697 <alloc_block_FF+0xb2>
  8028be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028c2:	0f 85 cf fd ff ff    	jne    802697 <alloc_block_FF+0xb2>

//	uint32 *endBlock = &kheapBreak;

	// if we don't find any enough space to allocate the block

	void *oldBreak = sbrk(ROUNDUP(totalSize, PAGE_SIZE) / PAGE_SIZE);
  8028c8:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8028cf:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8028d2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8028d5:	01 d0                	add    %edx,%eax
  8028d7:	48                   	dec    %eax
  8028d8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8028db:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8028de:	ba 00 00 00 00       	mov    $0x0,%edx
  8028e3:	f7 75 d8             	divl   -0x28(%ebp)
  8028e6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8028e9:	29 d0                	sub    %edx,%eax
  8028eb:	c1 e8 0c             	shr    $0xc,%eax
  8028ee:	83 ec 0c             	sub    $0xc,%esp
  8028f1:	50                   	push   %eax
  8028f2:	e8 20 eb ff ff       	call   801417 <sbrk>
  8028f7:	83 c4 10             	add    $0x10,%esp
  8028fa:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (oldBreak == (void*)-1) {
  8028fd:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802901:	75 0a                	jne    80290d <alloc_block_FF+0x328>
		return NULL;
  802903:	b8 00 00 00 00       	mov    $0x0,%eax
  802908:	e9 0d 01 00 00       	jmp    802a1a <alloc_block_FF+0x435>
	}
	//uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);

	uint32* endBlk = (uint32 *)((char *)oldBreak - 4);
  80290d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802910:	83 e8 04             	sub    $0x4,%eax
  802913:	89 45 cc             	mov    %eax,-0x34(%ebp)
	//endBlk = endBlk+(char *) ROUNDUP(totalSize, PAGE_SIZE);

	endBlk = endBlk + (ROUNDUP(totalSize, PAGE_SIZE) / sizeof(uint32));
  802916:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  80291d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802920:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802923:	01 d0                	add    %edx,%eax
  802925:	48                   	dec    %eax
  802926:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  802929:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80292c:	ba 00 00 00 00       	mov    $0x0,%edx
  802931:	f7 75 c8             	divl   -0x38(%ebp)
  802934:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802937:	29 d0                	sub    %edx,%eax
  802939:	c1 e8 02             	shr    $0x2,%eax
  80293c:	c1 e0 02             	shl    $0x2,%eax
  80293f:	01 45 cc             	add    %eax,-0x34(%ebp)
	*endBlk = 0 | 1;
  802942:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802945:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	uint32 *footerLast = ((uint32*)oldBreak - 2);
  80294b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80294e:	83 e8 08             	sub    $0x8,%eax
  802951:	89 45 c0             	mov    %eax,-0x40(%ebp)
	uint32 lastSize = (*footerLast) & ~(0x1);
  802954:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802957:	8b 00                	mov    (%eax),%eax
  802959:	83 e0 fe             	and    $0xfffffffe,%eax
  80295c:	89 45 bc             	mov    %eax,-0x44(%ebp)
	// the last block for the block that we want to free it
	struct BlockElement *laskBlk = (struct BlockElement *)((char*)oldBreak - lastSize);
  80295f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802962:	f7 d8                	neg    %eax
  802964:	89 c2                	mov    %eax,%edx
  802966:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802969:	01 d0                	add    %edx,%eax
  80296b:	89 45 b8             	mov    %eax,-0x48(%ebp)
	uint32 isLastFree = is_free_block(laskBlk);
  80296e:	83 ec 0c             	sub    $0xc,%esp
  802971:	ff 75 b8             	pushl  -0x48(%ebp)
  802974:	e8 1f f8 ff ff       	call   802198 <is_free_block>
  802979:	83 c4 10             	add    $0x10,%esp
  80297c:	0f be c0             	movsbl %al,%eax
  80297f:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(isLastFree)
  802982:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  802986:	74 42                	je     8029ca <alloc_block_FF+0x3e5>
	{
		// merge the block will be free with its prev block
		uint32 newBlkSize = lastSize + ROUNDUP(totalSize, PAGE_SIZE); // size of main block and its prev block
  802988:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  80298f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802992:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802995:	01 d0                	add    %edx,%eax
  802997:	48                   	dec    %eax
  802998:	89 45 ac             	mov    %eax,-0x54(%ebp)
  80299b:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80299e:	ba 00 00 00 00       	mov    $0x0,%edx
  8029a3:	f7 75 b0             	divl   -0x50(%ebp)
  8029a6:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8029a9:	29 d0                	sub    %edx,%eax
  8029ab:	89 c2                	mov    %eax,%edx
  8029ad:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8029b0:	01 d0                	add    %edx,%eax
  8029b2:	89 45 a8             	mov    %eax,-0x58(%ebp)
		// extends last block size to contain its size and the size of new space
		set_block_data(laskBlk,newBlkSize,0);
  8029b5:	83 ec 04             	sub    $0x4,%esp
  8029b8:	6a 00                	push   $0x0
  8029ba:	ff 75 a8             	pushl  -0x58(%ebp)
  8029bd:	ff 75 b8             	pushl  -0x48(%ebp)
  8029c0:	e8 36 fa ff ff       	call   8023fb <set_block_data>
  8029c5:	83 c4 10             	add    $0x10,%esp
  8029c8:	eb 42                	jmp    802a0c <alloc_block_FF+0x427>
	}
	else
	{
		set_block_data(oldBreak,ROUNDUP(totalSize, PAGE_SIZE),0);
  8029ca:	c7 45 a4 00 10 00 00 	movl   $0x1000,-0x5c(%ebp)
  8029d1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8029d4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8029d7:	01 d0                	add    %edx,%eax
  8029d9:	48                   	dec    %eax
  8029da:	89 45 a0             	mov    %eax,-0x60(%ebp)
  8029dd:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8029e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8029e5:	f7 75 a4             	divl   -0x5c(%ebp)
  8029e8:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8029eb:	29 d0                	sub    %edx,%eax
  8029ed:	83 ec 04             	sub    $0x4,%esp
  8029f0:	6a 00                	push   $0x0
  8029f2:	50                   	push   %eax
  8029f3:	ff 75 d0             	pushl  -0x30(%ebp)
  8029f6:	e8 00 fa ff ff       	call   8023fb <set_block_data>
  8029fb:	83 c4 10             	add    $0x10,%esp
		insert_sorted_in_freeList((struct BlockElement *)oldBreak);
  8029fe:	83 ec 0c             	sub    $0xc,%esp
  802a01:	ff 75 d0             	pushl  -0x30(%ebp)
  802a04:	e8 49 fa ff ff       	call   802452 <insert_sorted_in_freeList>
  802a09:	83 c4 10             	add    $0x10,%esp
//		LIST_INSERT_TAIL(&freeBlocksList,newBreak);
	}
//	set_block_data((struct BlockElement *)newBreak, totalSize, 1);
	return alloc_block_FF(size);
  802a0c:	83 ec 0c             	sub    $0xc,%esp
  802a0f:	ff 75 08             	pushl  0x8(%ebp)
  802a12:	e8 ce fb ff ff       	call   8025e5 <alloc_block_FF>
  802a17:	83 c4 10             	add    $0x10,%esp
}
  802a1a:	c9                   	leave  
  802a1b:	c3                   	ret    

00802a1c <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802a1c:	55                   	push   %ebp
  802a1d:	89 e5                	mov    %esp,%ebp
  802a1f:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS1 - BONUS] [3] DYNAMIC ALLOCATOR - alloc_block_BF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_BF is not implemented yet");
	//Your Code is Here...
	if(size == 0)
  802a22:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a26:	75 0a                	jne    802a32 <alloc_block_BF+0x16>
	{
		return NULL;
  802a28:	b8 00 00 00 00       	mov    $0x0,%eax
  802a2d:	e9 7a 02 00 00       	jmp    802cac <alloc_block_BF+0x290>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  802a32:	8b 45 08             	mov    0x8(%ebp),%eax
  802a35:	83 c0 08             	add    $0x8,%eax
  802a38:	89 45 e8             	mov    %eax,-0x18(%ebp)

	struct BlockElement *minBlk= NULL;
  802a3b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 minSize = 0xfffffff; // a large number
  802a42:	c7 45 f0 ff ff ff 0f 	movl   $0xfffffff,-0x10(%ebp)
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802a49:	a1 48 50 98 00       	mov    0x985048,%eax
  802a4e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802a51:	eb 32                	jmp    802a85 <alloc_block_BF+0x69>
	{
		uint32 blockSize = get_block_size(block);
  802a53:	ff 75 ec             	pushl  -0x14(%ebp)
  802a56:	e8 24 f7 ff ff       	call   80217f <get_block_size>
  802a5b:	83 c4 04             	add    $0x4,%esp
  802a5e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		// if this block can take the new block and its size < min size of all blocks
		if(blockSize >= totalSize && blockSize < minSize)
  802a61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a64:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802a67:	72 14                	jb     802a7d <alloc_block_BF+0x61>
  802a69:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a6c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802a6f:	73 0c                	jae    802a7d <alloc_block_BF+0x61>
		{
			minBlk = block;
  802a71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a74:	89 45 f4             	mov    %eax,-0xc(%ebp)
			minSize = blockSize;
  802a77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *minBlk= NULL;
	uint32 minSize = 0xfffffff; // a large number
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802a7d:	a1 50 50 98 00       	mov    0x985050,%eax
  802a82:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802a85:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a89:	74 07                	je     802a92 <alloc_block_BF+0x76>
  802a8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a8e:	8b 00                	mov    (%eax),%eax
  802a90:	eb 05                	jmp    802a97 <alloc_block_BF+0x7b>
  802a92:	b8 00 00 00 00       	mov    $0x0,%eax
  802a97:	a3 50 50 98 00       	mov    %eax,0x985050
  802a9c:	a1 50 50 98 00       	mov    0x985050,%eax
  802aa1:	85 c0                	test   %eax,%eax
  802aa3:	75 ae                	jne    802a53 <alloc_block_BF+0x37>
  802aa5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802aa9:	75 a8                	jne    802a53 <alloc_block_BF+0x37>
			minSize = blockSize;
		}
	}

	// if we don't find any enough space to allocate the block
	if(minBlk == NULL)
  802aab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aaf:	75 22                	jne    802ad3 <alloc_block_BF+0xb7>
	{
		void *newBlock = sbrk(totalSize);
  802ab1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ab4:	83 ec 0c             	sub    $0xc,%esp
  802ab7:	50                   	push   %eax
  802ab8:	e8 5a e9 ff ff       	call   801417 <sbrk>
  802abd:	83 c4 10             	add    $0x10,%esp
  802ac0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (newBlock == (void*)-1) {
  802ac3:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  802ac7:	75 0a                	jne    802ad3 <alloc_block_BF+0xb7>
			return NULL;
  802ac9:	b8 00 00 00 00       	mov    $0x0,%eax
  802ace:	e9 d9 01 00 00       	jmp    802cac <alloc_block_BF+0x290>
		}
	}

	//if we can put another block with min size 16
	if(minSize >= totalSize + 4*sizeof(uint32))
  802ad3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ad6:	83 c0 10             	add    $0x10,%eax
  802ad9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802adc:	0f 87 32 01 00 00    	ja     802c14 <alloc_block_BF+0x1f8>
	{
		// the size that will remain from the block that we will allocate a new block in it
		uint32 remainingSize= minSize - totalSize;
  802ae2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae5:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802ae8:	89 45 dc             	mov    %eax,-0x24(%ebp)

		// the remaining free space from the block that we use to allocate in it
		struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)minBlk + totalSize);
  802aeb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802af1:	01 d0                	add    %edx,%eax
  802af3:	89 45 d8             	mov    %eax,-0x28(%ebp)
		set_block_data(remainingFreeBlock, remainingSize, 0);
  802af6:	83 ec 04             	sub    $0x4,%esp
  802af9:	6a 00                	push   $0x0
  802afb:	ff 75 dc             	pushl  -0x24(%ebp)
  802afe:	ff 75 d8             	pushl  -0x28(%ebp)
  802b01:	e8 f5 f8 ff ff       	call   8023fb <set_block_data>
  802b06:	83 c4 10             	add    $0x10,%esp
		// add it after the block we allocated to be sorted by addresses
		LIST_INSERT_AFTER(&freeBlocksList, minBlk,remainingFreeBlock);
  802b09:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b0d:	74 06                	je     802b15 <alloc_block_BF+0xf9>
  802b0f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802b13:	75 17                	jne    802b2c <alloc_block_BF+0x110>
  802b15:	83 ec 04             	sub    $0x4,%esp
  802b18:	68 4c 42 80 00       	push   $0x80424c
  802b1d:	68 49 01 00 00       	push   $0x149
  802b22:	68 d7 41 80 00       	push   $0x8041d7
  802b27:	e8 94 d8 ff ff       	call   8003c0 <_panic>
  802b2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2f:	8b 10                	mov    (%eax),%edx
  802b31:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802b34:	89 10                	mov    %edx,(%eax)
  802b36:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802b39:	8b 00                	mov    (%eax),%eax
  802b3b:	85 c0                	test   %eax,%eax
  802b3d:	74 0b                	je     802b4a <alloc_block_BF+0x12e>
  802b3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b42:	8b 00                	mov    (%eax),%eax
  802b44:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802b47:	89 50 04             	mov    %edx,0x4(%eax)
  802b4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802b50:	89 10                	mov    %edx,(%eax)
  802b52:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802b55:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b58:	89 50 04             	mov    %edx,0x4(%eax)
  802b5b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802b5e:	8b 00                	mov    (%eax),%eax
  802b60:	85 c0                	test   %eax,%eax
  802b62:	75 08                	jne    802b6c <alloc_block_BF+0x150>
  802b64:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802b67:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802b6c:	a1 54 50 98 00       	mov    0x985054,%eax
  802b71:	40                   	inc    %eax
  802b72:	a3 54 50 98 00       	mov    %eax,0x985054

		// update the allocated block and remove it from freeBlocksList
		set_block_data(minBlk,totalSize,1);
  802b77:	83 ec 04             	sub    $0x4,%esp
  802b7a:	6a 01                	push   $0x1
  802b7c:	ff 75 e8             	pushl  -0x18(%ebp)
  802b7f:	ff 75 f4             	pushl  -0xc(%ebp)
  802b82:	e8 74 f8 ff ff       	call   8023fb <set_block_data>
  802b87:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  802b8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b8e:	75 17                	jne    802ba7 <alloc_block_BF+0x18b>
  802b90:	83 ec 04             	sub    $0x4,%esp
  802b93:	68 80 42 80 00       	push   $0x804280
  802b98:	68 4e 01 00 00       	push   $0x14e
  802b9d:	68 d7 41 80 00       	push   $0x8041d7
  802ba2:	e8 19 d8 ff ff       	call   8003c0 <_panic>
  802ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802baa:	8b 00                	mov    (%eax),%eax
  802bac:	85 c0                	test   %eax,%eax
  802bae:	74 10                	je     802bc0 <alloc_block_BF+0x1a4>
  802bb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb3:	8b 00                	mov    (%eax),%eax
  802bb5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bb8:	8b 52 04             	mov    0x4(%edx),%edx
  802bbb:	89 50 04             	mov    %edx,0x4(%eax)
  802bbe:	eb 0b                	jmp    802bcb <alloc_block_BF+0x1af>
  802bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc3:	8b 40 04             	mov    0x4(%eax),%eax
  802bc6:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802bcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bce:	8b 40 04             	mov    0x4(%eax),%eax
  802bd1:	85 c0                	test   %eax,%eax
  802bd3:	74 0f                	je     802be4 <alloc_block_BF+0x1c8>
  802bd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd8:	8b 40 04             	mov    0x4(%eax),%eax
  802bdb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bde:	8b 12                	mov    (%edx),%edx
  802be0:	89 10                	mov    %edx,(%eax)
  802be2:	eb 0a                	jmp    802bee <alloc_block_BF+0x1d2>
  802be4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be7:	8b 00                	mov    (%eax),%eax
  802be9:	a3 48 50 98 00       	mov    %eax,0x985048
  802bee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c01:	a1 54 50 98 00       	mov    0x985054,%eax
  802c06:	48                   	dec    %eax
  802c07:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  802c0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0f:	e9 98 00 00 00       	jmp    802cac <alloc_block_BF+0x290>
	}
	else // if set internal fragmentation
	{
		// add the remaining size to the block we allocate so it will be the same main block size
		set_block_data(minBlk,minSize,1);
  802c14:	83 ec 04             	sub    $0x4,%esp
  802c17:	6a 01                	push   $0x1
  802c19:	ff 75 f0             	pushl  -0x10(%ebp)
  802c1c:	ff 75 f4             	pushl  -0xc(%ebp)
  802c1f:	e8 d7 f7 ff ff       	call   8023fb <set_block_data>
  802c24:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  802c27:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c2b:	75 17                	jne    802c44 <alloc_block_BF+0x228>
  802c2d:	83 ec 04             	sub    $0x4,%esp
  802c30:	68 80 42 80 00       	push   $0x804280
  802c35:	68 56 01 00 00       	push   $0x156
  802c3a:	68 d7 41 80 00       	push   $0x8041d7
  802c3f:	e8 7c d7 ff ff       	call   8003c0 <_panic>
  802c44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c47:	8b 00                	mov    (%eax),%eax
  802c49:	85 c0                	test   %eax,%eax
  802c4b:	74 10                	je     802c5d <alloc_block_BF+0x241>
  802c4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c50:	8b 00                	mov    (%eax),%eax
  802c52:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c55:	8b 52 04             	mov    0x4(%edx),%edx
  802c58:	89 50 04             	mov    %edx,0x4(%eax)
  802c5b:	eb 0b                	jmp    802c68 <alloc_block_BF+0x24c>
  802c5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c60:	8b 40 04             	mov    0x4(%eax),%eax
  802c63:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802c68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6b:	8b 40 04             	mov    0x4(%eax),%eax
  802c6e:	85 c0                	test   %eax,%eax
  802c70:	74 0f                	je     802c81 <alloc_block_BF+0x265>
  802c72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c75:	8b 40 04             	mov    0x4(%eax),%eax
  802c78:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c7b:	8b 12                	mov    (%edx),%edx
  802c7d:	89 10                	mov    %edx,(%eax)
  802c7f:	eb 0a                	jmp    802c8b <alloc_block_BF+0x26f>
  802c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c84:	8b 00                	mov    (%eax),%eax
  802c86:	a3 48 50 98 00       	mov    %eax,0x985048
  802c8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c97:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c9e:	a1 54 50 98 00       	mov    0x985054,%eax
  802ca3:	48                   	dec    %eax
  802ca4:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  802ca9:	8b 45 f4             	mov    -0xc(%ebp),%eax
	}
	return NULL;
}
  802cac:	c9                   	leave  
  802cad:	c3                   	ret    

00802cae <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802cae:	55                   	push   %ebp
  802caf:	89 e5                	mov    %esp,%ebp
  802cb1:	83 ec 48             	sub    $0x48,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
  802cb4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cb8:	0f 84 6a 02 00 00    	je     802f28 <free_block+0x27a>
	{
		return;
	}

	uint32 freeSize = get_block_size(va);
  802cbe:	ff 75 08             	pushl  0x8(%ebp)
  802cc1:	e8 b9 f4 ff ff       	call   80217f <get_block_size>
  802cc6:	83 c4 04             	add    $0x4,%esp
  802cc9:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// footer for the prev block for the block that we want to free it
	uint32 *footerPrev = ((uint32*)va - 2 );
  802ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccf:	83 e8 08             	sub    $0x8,%eax
  802cd2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 pSize = (*footerPrev) & ~(0x1);
  802cd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd8:	8b 00                	mov    (%eax),%eax
  802cda:	83 e0 fe             	and    $0xfffffffe,%eax
  802cdd:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// the prev block for the block that we want to free it
	struct BlockElement * prevBlk = (struct BlockElement *)((char*)va - pSize);
  802ce0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ce3:	f7 d8                	neg    %eax
  802ce5:	89 c2                	mov    %eax,%edx
  802ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cea:	01 d0                	add    %edx,%eax
  802cec:	89 45 e8             	mov    %eax,-0x18(%ebp)
	uint32 isPrevFree = is_free_block(prevBlk);
  802cef:	ff 75 e8             	pushl  -0x18(%ebp)
  802cf2:	e8 a1 f4 ff ff       	call   802198 <is_free_block>
  802cf7:	83 c4 04             	add    $0x4,%esp
  802cfa:	0f be c0             	movsbl %al,%eax
  802cfd:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
  802d00:	8b 55 08             	mov    0x8(%ebp),%edx
  802d03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d06:	01 d0                	add    %edx,%eax
  802d08:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  802d0b:	ff 75 e0             	pushl  -0x20(%ebp)
  802d0e:	e8 85 f4 ff ff       	call   802198 <is_free_block>
  802d13:	83 c4 04             	add    $0x4,%esp
  802d16:	0f be c0             	movsbl %al,%eax
  802d19:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if(isPrevFree == 1 && isNextFree == 0)
  802d1c:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  802d20:	75 34                	jne    802d56 <free_block+0xa8>
  802d22:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802d26:	75 2e                	jne    802d56 <free_block+0xa8>
	{
		// merge the block will be free with its prev block
		uint32 prevSize = get_block_size(prevBlk);
  802d28:	ff 75 e8             	pushl  -0x18(%ebp)
  802d2b:	e8 4f f4 ff ff       	call   80217f <get_block_size>
  802d30:	83 c4 04             	add    $0x4,%esp
  802d33:	89 45 d8             	mov    %eax,-0x28(%ebp)
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
  802d36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d39:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802d3c:	01 d0                	add    %edx,%eax
  802d3e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
  802d41:	6a 00                	push   $0x0
  802d43:	ff 75 d4             	pushl  -0x2c(%ebp)
  802d46:	ff 75 e8             	pushl  -0x18(%ebp)
  802d49:	e8 ad f6 ff ff       	call   8023fb <set_block_data>
  802d4e:	83 c4 0c             	add    $0xc,%esp
	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
	uint32 isNextFree = is_free_block(nextBlk);

	if(isPrevFree == 1 && isNextFree == 0)
	{
  802d51:	e9 d3 01 00 00       	jmp    802f29 <free_block+0x27b>
		uint32 prevSize = get_block_size(prevBlk);
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
  802d56:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  802d5a:	0f 85 c8 00 00 00    	jne    802e28 <free_block+0x17a>
  802d60:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802d64:	0f 85 be 00 00 00    	jne    802e28 <free_block+0x17a>
	{
		// merge the block will be free with its next block
		uint32 nextSize = get_block_size(nextBlk);
  802d6a:	ff 75 e0             	pushl  -0x20(%ebp)
  802d6d:	e8 0d f4 ff ff       	call   80217f <get_block_size>
  802d72:	83 c4 04             	add    $0x4,%esp
  802d75:	89 45 d0             	mov    %eax,-0x30(%ebp)
		uint32 totalSize = freeSize + nextSize; // size of main block and its next block
  802d78:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d7b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d7e:	01 d0                	add    %edx,%eax
  802d80:	89 45 cc             	mov    %eax,-0x34(%ebp)
		// update the size of block to contain its size and the size of next block
		set_block_data(va,totalSize,0);
  802d83:	6a 00                	push   $0x0
  802d85:	ff 75 cc             	pushl  -0x34(%ebp)
  802d88:	ff 75 08             	pushl  0x8(%ebp)
  802d8b:	e8 6b f6 ff ff       	call   8023fb <set_block_data>
  802d90:	83 c4 0c             	add    $0xc,%esp
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
  802d93:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802d97:	75 17                	jne    802db0 <free_block+0x102>
  802d99:	83 ec 04             	sub    $0x4,%esp
  802d9c:	68 80 42 80 00       	push   $0x804280
  802da1:	68 87 01 00 00       	push   $0x187
  802da6:	68 d7 41 80 00       	push   $0x8041d7
  802dab:	e8 10 d6 ff ff       	call   8003c0 <_panic>
  802db0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802db3:	8b 00                	mov    (%eax),%eax
  802db5:	85 c0                	test   %eax,%eax
  802db7:	74 10                	je     802dc9 <free_block+0x11b>
  802db9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dbc:	8b 00                	mov    (%eax),%eax
  802dbe:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802dc1:	8b 52 04             	mov    0x4(%edx),%edx
  802dc4:	89 50 04             	mov    %edx,0x4(%eax)
  802dc7:	eb 0b                	jmp    802dd4 <free_block+0x126>
  802dc9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dcc:	8b 40 04             	mov    0x4(%eax),%eax
  802dcf:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802dd4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dd7:	8b 40 04             	mov    0x4(%eax),%eax
  802dda:	85 c0                	test   %eax,%eax
  802ddc:	74 0f                	je     802ded <free_block+0x13f>
  802dde:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802de1:	8b 40 04             	mov    0x4(%eax),%eax
  802de4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802de7:	8b 12                	mov    (%edx),%edx
  802de9:	89 10                	mov    %edx,(%eax)
  802deb:	eb 0a                	jmp    802df7 <free_block+0x149>
  802ded:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802df0:	8b 00                	mov    (%eax),%eax
  802df2:	a3 48 50 98 00       	mov    %eax,0x985048
  802df7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dfa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e00:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e03:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e0a:	a1 54 50 98 00       	mov    0x985054,%eax
  802e0f:	48                   	dec    %eax
  802e10:	a3 54 50 98 00       	mov    %eax,0x985054
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  802e15:	83 ec 0c             	sub    $0xc,%esp
  802e18:	ff 75 08             	pushl  0x8(%ebp)
  802e1b:	e8 32 f6 ff ff       	call   802452 <insert_sorted_in_freeList>
  802e20:	83 c4 10             	add    $0x10,%esp
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
	{
  802e23:	e9 01 01 00 00       	jmp    802f29 <free_block+0x27b>
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
  802e28:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  802e2c:	0f 85 d3 00 00 00    	jne    802f05 <free_block+0x257>
  802e32:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  802e36:	0f 85 c9 00 00 00    	jne    802f05 <free_block+0x257>
	{
		// merge the block will be free with its prev and next blocks
		uint32 prevSize = get_block_size(prevBlk);
  802e3c:	83 ec 0c             	sub    $0xc,%esp
  802e3f:	ff 75 e8             	pushl  -0x18(%ebp)
  802e42:	e8 38 f3 ff ff       	call   80217f <get_block_size>
  802e47:	83 c4 10             	add    $0x10,%esp
  802e4a:	89 45 c8             	mov    %eax,-0x38(%ebp)
		uint32 nextSize = get_block_size(nextBlk);
  802e4d:	83 ec 0c             	sub    $0xc,%esp
  802e50:	ff 75 e0             	pushl  -0x20(%ebp)
  802e53:	e8 27 f3 ff ff       	call   80217f <get_block_size>
  802e58:	83 c4 10             	add    $0x10,%esp
  802e5b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 totalSize = freeSize + prevSize + nextSize; // size of main block and its prev and next blocks
  802e5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e61:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802e64:	01 c2                	add    %eax,%edx
  802e66:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802e69:	01 d0                	add    %edx,%eax
  802e6b:	89 45 c0             	mov    %eax,-0x40(%ebp)
		// extends prev block size to contain its size and the size of main and next blocks
		set_block_data(prevBlk,totalSize,0);
  802e6e:	83 ec 04             	sub    $0x4,%esp
  802e71:	6a 00                	push   $0x0
  802e73:	ff 75 c0             	pushl  -0x40(%ebp)
  802e76:	ff 75 e8             	pushl  -0x18(%ebp)
  802e79:	e8 7d f5 ff ff       	call   8023fb <set_block_data>
  802e7e:	83 c4 10             	add    $0x10,%esp
		// remove next block because we merge it with its prev blocks
		LIST_REMOVE(&freeBlocksList, nextBlk);
  802e81:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802e85:	75 17                	jne    802e9e <free_block+0x1f0>
  802e87:	83 ec 04             	sub    $0x4,%esp
  802e8a:	68 80 42 80 00       	push   $0x804280
  802e8f:	68 94 01 00 00       	push   $0x194
  802e94:	68 d7 41 80 00       	push   $0x8041d7
  802e99:	e8 22 d5 ff ff       	call   8003c0 <_panic>
  802e9e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ea1:	8b 00                	mov    (%eax),%eax
  802ea3:	85 c0                	test   %eax,%eax
  802ea5:	74 10                	je     802eb7 <free_block+0x209>
  802ea7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802eaa:	8b 00                	mov    (%eax),%eax
  802eac:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802eaf:	8b 52 04             	mov    0x4(%edx),%edx
  802eb2:	89 50 04             	mov    %edx,0x4(%eax)
  802eb5:	eb 0b                	jmp    802ec2 <free_block+0x214>
  802eb7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802eba:	8b 40 04             	mov    0x4(%eax),%eax
  802ebd:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802ec2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ec5:	8b 40 04             	mov    0x4(%eax),%eax
  802ec8:	85 c0                	test   %eax,%eax
  802eca:	74 0f                	je     802edb <free_block+0x22d>
  802ecc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ecf:	8b 40 04             	mov    0x4(%eax),%eax
  802ed2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ed5:	8b 12                	mov    (%edx),%edx
  802ed7:	89 10                	mov    %edx,(%eax)
  802ed9:	eb 0a                	jmp    802ee5 <free_block+0x237>
  802edb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ede:	8b 00                	mov    (%eax),%eax
  802ee0:	a3 48 50 98 00       	mov    %eax,0x985048
  802ee5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ee8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ef1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ef8:	a1 54 50 98 00       	mov    0x985054,%eax
  802efd:	48                   	dec    %eax
  802efe:	a3 54 50 98 00       	mov    %eax,0x985054
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
	{
  802f03:	eb 24                	jmp    802f29 <free_block+0x27b>
	}
	else
	{
		// free it without any merge
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
  802f05:	83 ec 04             	sub    $0x4,%esp
  802f08:	6a 00                	push   $0x0
  802f0a:	ff 75 f4             	pushl  -0xc(%ebp)
  802f0d:	ff 75 08             	pushl  0x8(%ebp)
  802f10:	e8 e6 f4 ff ff       	call   8023fb <set_block_data>
  802f15:	83 c4 10             	add    $0x10,%esp
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  802f18:	83 ec 0c             	sub    $0xc,%esp
  802f1b:	ff 75 08             	pushl  0x8(%ebp)
  802f1e:	e8 2f f5 ff ff       	call   802452 <insert_sorted_in_freeList>
  802f23:	83 c4 10             	add    $0x10,%esp
  802f26:	eb 01                	jmp    802f29 <free_block+0x27b>
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
	{
		return;
  802f28:	90                   	nop
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
}
  802f29:	c9                   	leave  
  802f2a:	c3                   	ret    

00802f2b <realloc_block_FF>:
//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
  802f2b:	55                   	push   %ebp
  802f2c:	89 e5                	mov    %esp,%ebp
  802f2e:	83 ec 38             	sub    $0x38,%esp
	//TODO: [PROJECT'24.MS1 - #08] [3] DYNAMIC ALLOCATOR - realloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(va == NULL && new_size == 0)
  802f31:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f35:	75 10                	jne    802f47 <realloc_block_FF+0x1c>
  802f37:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f3b:	75 0a                	jne    802f47 <realloc_block_FF+0x1c>
	{
		return NULL;
  802f3d:	b8 00 00 00 00       	mov    $0x0,%eax
  802f42:	e9 8b 04 00 00       	jmp    8033d2 <realloc_block_FF+0x4a7>
	}

	if(new_size == 0)
  802f47:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f4b:	75 18                	jne    802f65 <realloc_block_FF+0x3a>
	{
		free_block(va);
  802f4d:	83 ec 0c             	sub    $0xc,%esp
  802f50:	ff 75 08             	pushl  0x8(%ebp)
  802f53:	e8 56 fd ff ff       	call   802cae <free_block>
  802f58:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802f5b:	b8 00 00 00 00       	mov    $0x0,%eax
  802f60:	e9 6d 04 00 00       	jmp    8033d2 <realloc_block_FF+0x4a7>
	}

	if(va == NULL)
  802f65:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f69:	75 13                	jne    802f7e <realloc_block_FF+0x53>
	{
		return alloc_block_FF(new_size);
  802f6b:	83 ec 0c             	sub    $0xc,%esp
  802f6e:	ff 75 0c             	pushl  0xc(%ebp)
  802f71:	e8 6f f6 ff ff       	call   8025e5 <alloc_block_FF>
  802f76:	83 c4 10             	add    $0x10,%esp
  802f79:	e9 54 04 00 00       	jmp    8033d2 <realloc_block_FF+0x4a7>
	}

	// if size is odd must be increment it by one
	if (new_size % 2 != 0)
  802f7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f81:	83 e0 01             	and    $0x1,%eax
  802f84:	85 c0                	test   %eax,%eax
  802f86:	74 03                	je     802f8b <realloc_block_FF+0x60>
	{
		new_size++;
  802f88:	ff 45 0c             	incl   0xc(%ebp)
	}

	// if size < 8 must be equal it to 8 because min size 8 excluding metadata
	if(new_size < 8)
  802f8b:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  802f8f:	77 07                	ja     802f98 <realloc_block_FF+0x6d>
	{
		new_size = 8;
  802f91:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	}

	new_size += 8; // adds its footer and header size
  802f98:	83 45 0c 08          	addl   $0x8,0xc(%ebp)

	uint32 actualSize = get_block_size(va);
  802f9c:	83 ec 0c             	sub    $0xc,%esp
  802f9f:	ff 75 08             	pushl  0x8(%ebp)
  802fa2:	e8 d8 f1 ff ff       	call   80217f <get_block_size>
  802fa7:	83 c4 10             	add    $0x10,%esp
  802faa:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(actualSize == new_size)
  802fad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802fb3:	75 08                	jne    802fbd <realloc_block_FF+0x92>
	{
		// don't change any thing
		return va;
  802fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb8:	e9 15 04 00 00       	jmp    8033d2 <realloc_block_FF+0x4a7>
	}

	// next block for the block we want to change its size
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + actualSize);
  802fbd:	8b 55 08             	mov    0x8(%ebp),%edx
  802fc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc3:	01 d0                	add    %edx,%eax
  802fc5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  802fc8:	83 ec 0c             	sub    $0xc,%esp
  802fcb:	ff 75 f0             	pushl  -0x10(%ebp)
  802fce:	e8 c5 f1 ff ff       	call   802198 <is_free_block>
  802fd3:	83 c4 10             	add    $0x10,%esp
  802fd6:	0f be c0             	movsbl %al,%eax
  802fd9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 nextSize = get_block_size(nextBlk);
  802fdc:	83 ec 0c             	sub    $0xc,%esp
  802fdf:	ff 75 f0             	pushl  -0x10(%ebp)
  802fe2:	e8 98 f1 ff ff       	call   80217f <get_block_size>
  802fe7:	83 c4 10             	add    $0x10,%esp
  802fea:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// increase the size of block
	if(new_size > actualSize)
  802fed:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ff0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802ff3:	0f 86 a7 02 00 00    	jbe    8032a0 <realloc_block_FF+0x375>
	{
		if(isNextFree)
  802ff9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ffd:	0f 84 86 02 00 00    	je     803289 <realloc_block_FF+0x35e>
		{
			if(nextSize + actualSize == new_size) // block and nextblock = newSizeBlock
  803003:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803006:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803009:	01 d0                	add    %edx,%eax
  80300b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80300e:	0f 85 b2 00 00 00    	jne    8030c6 <realloc_block_FF+0x19b>
			{
				set_block_data(va,new_size,!(is_free_block(va)));// update size in block
  803014:	83 ec 0c             	sub    $0xc,%esp
  803017:	ff 75 08             	pushl  0x8(%ebp)
  80301a:	e8 79 f1 ff ff       	call   802198 <is_free_block>
  80301f:	83 c4 10             	add    $0x10,%esp
  803022:	84 c0                	test   %al,%al
  803024:	0f 94 c0             	sete   %al
  803027:	0f b6 c0             	movzbl %al,%eax
  80302a:	83 ec 04             	sub    $0x4,%esp
  80302d:	50                   	push   %eax
  80302e:	ff 75 0c             	pushl  0xc(%ebp)
  803031:	ff 75 08             	pushl  0x8(%ebp)
  803034:	e8 c2 f3 ff ff       	call   8023fb <set_block_data>
  803039:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);// remove next because it is = zero
  80303c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803040:	75 17                	jne    803059 <realloc_block_FF+0x12e>
  803042:	83 ec 04             	sub    $0x4,%esp
  803045:	68 80 42 80 00       	push   $0x804280
  80304a:	68 db 01 00 00       	push   $0x1db
  80304f:	68 d7 41 80 00       	push   $0x8041d7
  803054:	e8 67 d3 ff ff       	call   8003c0 <_panic>
  803059:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80305c:	8b 00                	mov    (%eax),%eax
  80305e:	85 c0                	test   %eax,%eax
  803060:	74 10                	je     803072 <realloc_block_FF+0x147>
  803062:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803065:	8b 00                	mov    (%eax),%eax
  803067:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80306a:	8b 52 04             	mov    0x4(%edx),%edx
  80306d:	89 50 04             	mov    %edx,0x4(%eax)
  803070:	eb 0b                	jmp    80307d <realloc_block_FF+0x152>
  803072:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803075:	8b 40 04             	mov    0x4(%eax),%eax
  803078:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80307d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803080:	8b 40 04             	mov    0x4(%eax),%eax
  803083:	85 c0                	test   %eax,%eax
  803085:	74 0f                	je     803096 <realloc_block_FF+0x16b>
  803087:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80308a:	8b 40 04             	mov    0x4(%eax),%eax
  80308d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803090:	8b 12                	mov    (%edx),%edx
  803092:	89 10                	mov    %edx,(%eax)
  803094:	eb 0a                	jmp    8030a0 <realloc_block_FF+0x175>
  803096:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803099:	8b 00                	mov    (%eax),%eax
  80309b:	a3 48 50 98 00       	mov    %eax,0x985048
  8030a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030b3:	a1 54 50 98 00       	mov    0x985054,%eax
  8030b8:	48                   	dec    %eax
  8030b9:	a3 54 50 98 00       	mov    %eax,0x985054
				return va;
  8030be:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c1:	e9 0c 03 00 00       	jmp    8033d2 <realloc_block_FF+0x4a7>
			}
			else if(nextSize + actualSize > new_size) // new size is less than next and main blocks
  8030c6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030cc:	01 d0                	add    %edx,%eax
  8030ce:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8030d1:	0f 86 b2 01 00 00    	jbe    803289 <realloc_block_FF+0x35e>
			{
				uint32 requiredSize = new_size - actualSize; // size that we need from the next block
  8030d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030da:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8030dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				uint32 remainingNext = nextSize - requiredSize; // size that will remain from the next block after we split it
  8030e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e3:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8030e6:	89 45 e0             	mov    %eax,-0x20(%ebp)

				// if next size will not fit another block (internal fragmentation)
				if(remainingNext < 16)
  8030e9:	83 7d e0 0f          	cmpl   $0xf,-0x20(%ebp)
  8030ed:	0f 87 b8 00 00 00    	ja     8031ab <realloc_block_FF+0x280>
				{
					// we will take the main size of the block and its next size also
					set_block_data(va,actualSize + nextSize,!(is_free_block(va)));
  8030f3:	83 ec 0c             	sub    $0xc,%esp
  8030f6:	ff 75 08             	pushl  0x8(%ebp)
  8030f9:	e8 9a f0 ff ff       	call   802198 <is_free_block>
  8030fe:	83 c4 10             	add    $0x10,%esp
  803101:	84 c0                	test   %al,%al
  803103:	0f 94 c0             	sete   %al
  803106:	0f b6 c0             	movzbl %al,%eax
  803109:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80310c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80310f:	01 ca                	add    %ecx,%edx
  803111:	83 ec 04             	sub    $0x4,%esp
  803114:	50                   	push   %eax
  803115:	52                   	push   %edx
  803116:	ff 75 08             	pushl  0x8(%ebp)
  803119:	e8 dd f2 ff ff       	call   8023fb <set_block_data>
  80311e:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,nextBlk);
  803121:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803125:	75 17                	jne    80313e <realloc_block_FF+0x213>
  803127:	83 ec 04             	sub    $0x4,%esp
  80312a:	68 80 42 80 00       	push   $0x804280
  80312f:	68 e8 01 00 00       	push   $0x1e8
  803134:	68 d7 41 80 00       	push   $0x8041d7
  803139:	e8 82 d2 ff ff       	call   8003c0 <_panic>
  80313e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803141:	8b 00                	mov    (%eax),%eax
  803143:	85 c0                	test   %eax,%eax
  803145:	74 10                	je     803157 <realloc_block_FF+0x22c>
  803147:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80314a:	8b 00                	mov    (%eax),%eax
  80314c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80314f:	8b 52 04             	mov    0x4(%edx),%edx
  803152:	89 50 04             	mov    %edx,0x4(%eax)
  803155:	eb 0b                	jmp    803162 <realloc_block_FF+0x237>
  803157:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80315a:	8b 40 04             	mov    0x4(%eax),%eax
  80315d:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803162:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803165:	8b 40 04             	mov    0x4(%eax),%eax
  803168:	85 c0                	test   %eax,%eax
  80316a:	74 0f                	je     80317b <realloc_block_FF+0x250>
  80316c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80316f:	8b 40 04             	mov    0x4(%eax),%eax
  803172:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803175:	8b 12                	mov    (%edx),%edx
  803177:	89 10                	mov    %edx,(%eax)
  803179:	eb 0a                	jmp    803185 <realloc_block_FF+0x25a>
  80317b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80317e:	8b 00                	mov    (%eax),%eax
  803180:	a3 48 50 98 00       	mov    %eax,0x985048
  803185:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803188:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80318e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803191:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803198:	a1 54 50 98 00       	mov    0x985054,%eax
  80319d:	48                   	dec    %eax
  80319e:	a3 54 50 98 00       	mov    %eax,0x985054
					return va;
  8031a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a6:	e9 27 02 00 00       	jmp    8033d2 <realloc_block_FF+0x4a7>
				}
				else // if next size can be fit another block (split)
				{
					LIST_REMOVE(&freeBlocksList,nextBlk);
  8031ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031af:	75 17                	jne    8031c8 <realloc_block_FF+0x29d>
  8031b1:	83 ec 04             	sub    $0x4,%esp
  8031b4:	68 80 42 80 00       	push   $0x804280
  8031b9:	68 ed 01 00 00       	push   $0x1ed
  8031be:	68 d7 41 80 00       	push   $0x8041d7
  8031c3:	e8 f8 d1 ff ff       	call   8003c0 <_panic>
  8031c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031cb:	8b 00                	mov    (%eax),%eax
  8031cd:	85 c0                	test   %eax,%eax
  8031cf:	74 10                	je     8031e1 <realloc_block_FF+0x2b6>
  8031d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031d4:	8b 00                	mov    (%eax),%eax
  8031d6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031d9:	8b 52 04             	mov    0x4(%edx),%edx
  8031dc:	89 50 04             	mov    %edx,0x4(%eax)
  8031df:	eb 0b                	jmp    8031ec <realloc_block_FF+0x2c1>
  8031e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031e4:	8b 40 04             	mov    0x4(%eax),%eax
  8031e7:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8031ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ef:	8b 40 04             	mov    0x4(%eax),%eax
  8031f2:	85 c0                	test   %eax,%eax
  8031f4:	74 0f                	je     803205 <realloc_block_FF+0x2da>
  8031f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f9:	8b 40 04             	mov    0x4(%eax),%eax
  8031fc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031ff:	8b 12                	mov    (%edx),%edx
  803201:	89 10                	mov    %edx,(%eax)
  803203:	eb 0a                	jmp    80320f <realloc_block_FF+0x2e4>
  803205:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803208:	8b 00                	mov    (%eax),%eax
  80320a:	a3 48 50 98 00       	mov    %eax,0x985048
  80320f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803212:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803218:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80321b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803222:	a1 54 50 98 00       	mov    0x985054,%eax
  803227:	48                   	dec    %eax
  803228:	a3 54 50 98 00       	mov    %eax,0x985054
					nextBlk = (struct BlockElement *)((char *)va + new_size); //update nextBlk address
  80322d:	8b 55 08             	mov    0x8(%ebp),%edx
  803230:	8b 45 0c             	mov    0xc(%ebp),%eax
  803233:	01 d0                	add    %edx,%eax
  803235:	89 45 f0             	mov    %eax,-0x10(%ebp)
					set_block_data(nextBlk,remainingNext,0); // update nextBlkSize
  803238:	83 ec 04             	sub    $0x4,%esp
  80323b:	6a 00                	push   $0x0
  80323d:	ff 75 e0             	pushl  -0x20(%ebp)
  803240:	ff 75 f0             	pushl  -0x10(%ebp)
  803243:	e8 b3 f1 ff ff       	call   8023fb <set_block_data>
  803248:	83 c4 10             	add    $0x10,%esp
					set_block_data(va,new_size,!(is_free_block(va))); // update size of newblock
  80324b:	83 ec 0c             	sub    $0xc,%esp
  80324e:	ff 75 08             	pushl  0x8(%ebp)
  803251:	e8 42 ef ff ff       	call   802198 <is_free_block>
  803256:	83 c4 10             	add    $0x10,%esp
  803259:	84 c0                	test   %al,%al
  80325b:	0f 94 c0             	sete   %al
  80325e:	0f b6 c0             	movzbl %al,%eax
  803261:	83 ec 04             	sub    $0x4,%esp
  803264:	50                   	push   %eax
  803265:	ff 75 0c             	pushl  0xc(%ebp)
  803268:	ff 75 08             	pushl  0x8(%ebp)
  80326b:	e8 8b f1 ff ff       	call   8023fb <set_block_data>
  803270:	83 c4 10             	add    $0x10,%esp
					insert_sorted_in_freeList(nextBlk);
  803273:	83 ec 0c             	sub    $0xc,%esp
  803276:	ff 75 f0             	pushl  -0x10(%ebp)
  803279:	e8 d4 f1 ff ff       	call   802452 <insert_sorted_in_freeList>
  80327e:	83 c4 10             	add    $0x10,%esp
					return va;
  803281:	8b 45 08             	mov    0x8(%ebp),%eax
  803284:	e9 49 01 00 00       	jmp    8033d2 <realloc_block_FF+0x4a7>
				}
			}
		}
		// if next block isn't free or not fit the new size
		return alloc_block_FF(new_size - 8);
  803289:	8b 45 0c             	mov    0xc(%ebp),%eax
  80328c:	83 e8 08             	sub    $0x8,%eax
  80328f:	83 ec 0c             	sub    $0xc,%esp
  803292:	50                   	push   %eax
  803293:	e8 4d f3 ff ff       	call   8025e5 <alloc_block_FF>
  803298:	83 c4 10             	add    $0x10,%esp
  80329b:	e9 32 01 00 00       	jmp    8033d2 <realloc_block_FF+0x4a7>
	}
	else if(new_size < actualSize) // to shrink block
  8032a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032a3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8032a6:	0f 83 21 01 00 00    	jae    8033cd <realloc_block_FF+0x4a2>
	{
		uint32 remainingSize = actualSize - new_size; // size that will remain from the main block after we shrink it
  8032ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032af:	2b 45 0c             	sub    0xc(%ebp),%eax
  8032b2:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(remainingSize < 16 && isNextFree == 0) // internal fragmentation
  8032b5:	83 7d dc 0f          	cmpl   $0xf,-0x24(%ebp)
  8032b9:	77 0e                	ja     8032c9 <realloc_block_FF+0x39e>
  8032bb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8032bf:	75 08                	jne    8032c9 <realloc_block_FF+0x39e>
		{
			// don't change its size
			return va;
  8032c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c4:	e9 09 01 00 00       	jmp    8033d2 <realloc_block_FF+0x4a7>
		}
		else // remainingSize fit in a new block
		{
			struct BlockElement *mainBlk = (struct BlockElement *)va;
  8032c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032cc:	89 45 d8             	mov    %eax,-0x28(%ebp)
			// update main block with new size
			set_block_data(mainBlk,new_size,!(is_free_block(va)));
  8032cf:	83 ec 0c             	sub    $0xc,%esp
  8032d2:	ff 75 08             	pushl  0x8(%ebp)
  8032d5:	e8 be ee ff ff       	call   802198 <is_free_block>
  8032da:	83 c4 10             	add    $0x10,%esp
  8032dd:	84 c0                	test   %al,%al
  8032df:	0f 94 c0             	sete   %al
  8032e2:	0f b6 c0             	movzbl %al,%eax
  8032e5:	83 ec 04             	sub    $0x4,%esp
  8032e8:	50                   	push   %eax
  8032e9:	ff 75 0c             	pushl  0xc(%ebp)
  8032ec:	ff 75 d8             	pushl  -0x28(%ebp)
  8032ef:	e8 07 f1 ff ff       	call   8023fb <set_block_data>
  8032f4:	83 c4 10             	add    $0x10,%esp

			// the blk with remaining size
			struct BlockElement *remainingBlk=(struct BlockElement *)((char*)mainBlk + new_size);
  8032f7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8032fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032fd:	01 d0                	add    %edx,%eax
  8032ff:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			set_block_data(remainingBlk,remainingSize,0);
  803302:	83 ec 04             	sub    $0x4,%esp
  803305:	6a 00                	push   $0x0
  803307:	ff 75 dc             	pushl  -0x24(%ebp)
  80330a:	ff 75 d4             	pushl  -0x2c(%ebp)
  80330d:	e8 e9 f0 ff ff       	call   8023fb <set_block_data>
  803312:	83 c4 10             	add    $0x10,%esp

			if(isNextFree)
  803315:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803319:	0f 84 9b 00 00 00    	je     8033ba <realloc_block_FF+0x48f>
			{
				// merge splited block with its next block
				set_block_data(remainingBlk,(remainingSize + nextSize),0);//merge remaining with its next block
  80331f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803322:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803325:	01 d0                	add    %edx,%eax
  803327:	83 ec 04             	sub    $0x4,%esp
  80332a:	6a 00                	push   $0x0
  80332c:	50                   	push   %eax
  80332d:	ff 75 d4             	pushl  -0x2c(%ebp)
  803330:	e8 c6 f0 ff ff       	call   8023fb <set_block_data>
  803335:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);
  803338:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80333c:	75 17                	jne    803355 <realloc_block_FF+0x42a>
  80333e:	83 ec 04             	sub    $0x4,%esp
  803341:	68 80 42 80 00       	push   $0x804280
  803346:	68 10 02 00 00       	push   $0x210
  80334b:	68 d7 41 80 00       	push   $0x8041d7
  803350:	e8 6b d0 ff ff       	call   8003c0 <_panic>
  803355:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803358:	8b 00                	mov    (%eax),%eax
  80335a:	85 c0                	test   %eax,%eax
  80335c:	74 10                	je     80336e <realloc_block_FF+0x443>
  80335e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803361:	8b 00                	mov    (%eax),%eax
  803363:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803366:	8b 52 04             	mov    0x4(%edx),%edx
  803369:	89 50 04             	mov    %edx,0x4(%eax)
  80336c:	eb 0b                	jmp    803379 <realloc_block_FF+0x44e>
  80336e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803371:	8b 40 04             	mov    0x4(%eax),%eax
  803374:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803379:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80337c:	8b 40 04             	mov    0x4(%eax),%eax
  80337f:	85 c0                	test   %eax,%eax
  803381:	74 0f                	je     803392 <realloc_block_FF+0x467>
  803383:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803386:	8b 40 04             	mov    0x4(%eax),%eax
  803389:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80338c:	8b 12                	mov    (%edx),%edx
  80338e:	89 10                	mov    %edx,(%eax)
  803390:	eb 0a                	jmp    80339c <realloc_block_FF+0x471>
  803392:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803395:	8b 00                	mov    (%eax),%eax
  803397:	a3 48 50 98 00       	mov    %eax,0x985048
  80339c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80339f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033a8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033af:	a1 54 50 98 00       	mov    0x985054,%eax
  8033b4:	48                   	dec    %eax
  8033b5:	a3 54 50 98 00       	mov    %eax,0x985054
			}
			insert_sorted_in_freeList(remainingBlk);
  8033ba:	83 ec 0c             	sub    $0xc,%esp
  8033bd:	ff 75 d4             	pushl  -0x2c(%ebp)
  8033c0:	e8 8d f0 ff ff       	call   802452 <insert_sorted_in_freeList>
  8033c5:	83 c4 10             	add    $0x10,%esp
			return mainBlk;
  8033c8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033cb:	eb 05                	jmp    8033d2 <realloc_block_FF+0x4a7>
		}
	}
	return NULL;
  8033cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033d2:	c9                   	leave  
  8033d3:	c3                   	ret    

008033d4 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8033d4:	55                   	push   %ebp
  8033d5:	89 e5                	mov    %esp,%ebp
  8033d7:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8033da:	83 ec 04             	sub    $0x4,%esp
  8033dd:	68 a0 42 80 00       	push   $0x8042a0
  8033e2:	68 20 02 00 00       	push   $0x220
  8033e7:	68 d7 41 80 00       	push   $0x8041d7
  8033ec:	e8 cf cf ff ff       	call   8003c0 <_panic>

008033f1 <alloc_block_NF>:
}
//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8033f1:	55                   	push   %ebp
  8033f2:	89 e5                	mov    %esp,%ebp
  8033f4:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8033f7:	83 ec 04             	sub    $0x4,%esp
  8033fa:	68 c8 42 80 00       	push   $0x8042c8
  8033ff:	68 28 02 00 00       	push   $0x228
  803404:	68 d7 41 80 00       	push   $0x8041d7
  803409:	e8 b2 cf ff ff       	call   8003c0 <_panic>
  80340e:	66 90                	xchg   %ax,%ax

00803410 <__udivdi3>:
  803410:	55                   	push   %ebp
  803411:	57                   	push   %edi
  803412:	56                   	push   %esi
  803413:	53                   	push   %ebx
  803414:	83 ec 1c             	sub    $0x1c,%esp
  803417:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80341b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80341f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803423:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803427:	89 ca                	mov    %ecx,%edx
  803429:	89 f8                	mov    %edi,%eax
  80342b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80342f:	85 f6                	test   %esi,%esi
  803431:	75 2d                	jne    803460 <__udivdi3+0x50>
  803433:	39 cf                	cmp    %ecx,%edi
  803435:	77 65                	ja     80349c <__udivdi3+0x8c>
  803437:	89 fd                	mov    %edi,%ebp
  803439:	85 ff                	test   %edi,%edi
  80343b:	75 0b                	jne    803448 <__udivdi3+0x38>
  80343d:	b8 01 00 00 00       	mov    $0x1,%eax
  803442:	31 d2                	xor    %edx,%edx
  803444:	f7 f7                	div    %edi
  803446:	89 c5                	mov    %eax,%ebp
  803448:	31 d2                	xor    %edx,%edx
  80344a:	89 c8                	mov    %ecx,%eax
  80344c:	f7 f5                	div    %ebp
  80344e:	89 c1                	mov    %eax,%ecx
  803450:	89 d8                	mov    %ebx,%eax
  803452:	f7 f5                	div    %ebp
  803454:	89 cf                	mov    %ecx,%edi
  803456:	89 fa                	mov    %edi,%edx
  803458:	83 c4 1c             	add    $0x1c,%esp
  80345b:	5b                   	pop    %ebx
  80345c:	5e                   	pop    %esi
  80345d:	5f                   	pop    %edi
  80345e:	5d                   	pop    %ebp
  80345f:	c3                   	ret    
  803460:	39 ce                	cmp    %ecx,%esi
  803462:	77 28                	ja     80348c <__udivdi3+0x7c>
  803464:	0f bd fe             	bsr    %esi,%edi
  803467:	83 f7 1f             	xor    $0x1f,%edi
  80346a:	75 40                	jne    8034ac <__udivdi3+0x9c>
  80346c:	39 ce                	cmp    %ecx,%esi
  80346e:	72 0a                	jb     80347a <__udivdi3+0x6a>
  803470:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803474:	0f 87 9e 00 00 00    	ja     803518 <__udivdi3+0x108>
  80347a:	b8 01 00 00 00       	mov    $0x1,%eax
  80347f:	89 fa                	mov    %edi,%edx
  803481:	83 c4 1c             	add    $0x1c,%esp
  803484:	5b                   	pop    %ebx
  803485:	5e                   	pop    %esi
  803486:	5f                   	pop    %edi
  803487:	5d                   	pop    %ebp
  803488:	c3                   	ret    
  803489:	8d 76 00             	lea    0x0(%esi),%esi
  80348c:	31 ff                	xor    %edi,%edi
  80348e:	31 c0                	xor    %eax,%eax
  803490:	89 fa                	mov    %edi,%edx
  803492:	83 c4 1c             	add    $0x1c,%esp
  803495:	5b                   	pop    %ebx
  803496:	5e                   	pop    %esi
  803497:	5f                   	pop    %edi
  803498:	5d                   	pop    %ebp
  803499:	c3                   	ret    
  80349a:	66 90                	xchg   %ax,%ax
  80349c:	89 d8                	mov    %ebx,%eax
  80349e:	f7 f7                	div    %edi
  8034a0:	31 ff                	xor    %edi,%edi
  8034a2:	89 fa                	mov    %edi,%edx
  8034a4:	83 c4 1c             	add    $0x1c,%esp
  8034a7:	5b                   	pop    %ebx
  8034a8:	5e                   	pop    %esi
  8034a9:	5f                   	pop    %edi
  8034aa:	5d                   	pop    %ebp
  8034ab:	c3                   	ret    
  8034ac:	bd 20 00 00 00       	mov    $0x20,%ebp
  8034b1:	89 eb                	mov    %ebp,%ebx
  8034b3:	29 fb                	sub    %edi,%ebx
  8034b5:	89 f9                	mov    %edi,%ecx
  8034b7:	d3 e6                	shl    %cl,%esi
  8034b9:	89 c5                	mov    %eax,%ebp
  8034bb:	88 d9                	mov    %bl,%cl
  8034bd:	d3 ed                	shr    %cl,%ebp
  8034bf:	89 e9                	mov    %ebp,%ecx
  8034c1:	09 f1                	or     %esi,%ecx
  8034c3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8034c7:	89 f9                	mov    %edi,%ecx
  8034c9:	d3 e0                	shl    %cl,%eax
  8034cb:	89 c5                	mov    %eax,%ebp
  8034cd:	89 d6                	mov    %edx,%esi
  8034cf:	88 d9                	mov    %bl,%cl
  8034d1:	d3 ee                	shr    %cl,%esi
  8034d3:	89 f9                	mov    %edi,%ecx
  8034d5:	d3 e2                	shl    %cl,%edx
  8034d7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034db:	88 d9                	mov    %bl,%cl
  8034dd:	d3 e8                	shr    %cl,%eax
  8034df:	09 c2                	or     %eax,%edx
  8034e1:	89 d0                	mov    %edx,%eax
  8034e3:	89 f2                	mov    %esi,%edx
  8034e5:	f7 74 24 0c          	divl   0xc(%esp)
  8034e9:	89 d6                	mov    %edx,%esi
  8034eb:	89 c3                	mov    %eax,%ebx
  8034ed:	f7 e5                	mul    %ebp
  8034ef:	39 d6                	cmp    %edx,%esi
  8034f1:	72 19                	jb     80350c <__udivdi3+0xfc>
  8034f3:	74 0b                	je     803500 <__udivdi3+0xf0>
  8034f5:	89 d8                	mov    %ebx,%eax
  8034f7:	31 ff                	xor    %edi,%edi
  8034f9:	e9 58 ff ff ff       	jmp    803456 <__udivdi3+0x46>
  8034fe:	66 90                	xchg   %ax,%ax
  803500:	8b 54 24 08          	mov    0x8(%esp),%edx
  803504:	89 f9                	mov    %edi,%ecx
  803506:	d3 e2                	shl    %cl,%edx
  803508:	39 c2                	cmp    %eax,%edx
  80350a:	73 e9                	jae    8034f5 <__udivdi3+0xe5>
  80350c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80350f:	31 ff                	xor    %edi,%edi
  803511:	e9 40 ff ff ff       	jmp    803456 <__udivdi3+0x46>
  803516:	66 90                	xchg   %ax,%ax
  803518:	31 c0                	xor    %eax,%eax
  80351a:	e9 37 ff ff ff       	jmp    803456 <__udivdi3+0x46>
  80351f:	90                   	nop

00803520 <__umoddi3>:
  803520:	55                   	push   %ebp
  803521:	57                   	push   %edi
  803522:	56                   	push   %esi
  803523:	53                   	push   %ebx
  803524:	83 ec 1c             	sub    $0x1c,%esp
  803527:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80352b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80352f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803533:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803537:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80353b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80353f:	89 f3                	mov    %esi,%ebx
  803541:	89 fa                	mov    %edi,%edx
  803543:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803547:	89 34 24             	mov    %esi,(%esp)
  80354a:	85 c0                	test   %eax,%eax
  80354c:	75 1a                	jne    803568 <__umoddi3+0x48>
  80354e:	39 f7                	cmp    %esi,%edi
  803550:	0f 86 a2 00 00 00    	jbe    8035f8 <__umoddi3+0xd8>
  803556:	89 c8                	mov    %ecx,%eax
  803558:	89 f2                	mov    %esi,%edx
  80355a:	f7 f7                	div    %edi
  80355c:	89 d0                	mov    %edx,%eax
  80355e:	31 d2                	xor    %edx,%edx
  803560:	83 c4 1c             	add    $0x1c,%esp
  803563:	5b                   	pop    %ebx
  803564:	5e                   	pop    %esi
  803565:	5f                   	pop    %edi
  803566:	5d                   	pop    %ebp
  803567:	c3                   	ret    
  803568:	39 f0                	cmp    %esi,%eax
  80356a:	0f 87 ac 00 00 00    	ja     80361c <__umoddi3+0xfc>
  803570:	0f bd e8             	bsr    %eax,%ebp
  803573:	83 f5 1f             	xor    $0x1f,%ebp
  803576:	0f 84 ac 00 00 00    	je     803628 <__umoddi3+0x108>
  80357c:	bf 20 00 00 00       	mov    $0x20,%edi
  803581:	29 ef                	sub    %ebp,%edi
  803583:	89 fe                	mov    %edi,%esi
  803585:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803589:	89 e9                	mov    %ebp,%ecx
  80358b:	d3 e0                	shl    %cl,%eax
  80358d:	89 d7                	mov    %edx,%edi
  80358f:	89 f1                	mov    %esi,%ecx
  803591:	d3 ef                	shr    %cl,%edi
  803593:	09 c7                	or     %eax,%edi
  803595:	89 e9                	mov    %ebp,%ecx
  803597:	d3 e2                	shl    %cl,%edx
  803599:	89 14 24             	mov    %edx,(%esp)
  80359c:	89 d8                	mov    %ebx,%eax
  80359e:	d3 e0                	shl    %cl,%eax
  8035a0:	89 c2                	mov    %eax,%edx
  8035a2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035a6:	d3 e0                	shl    %cl,%eax
  8035a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8035ac:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035b0:	89 f1                	mov    %esi,%ecx
  8035b2:	d3 e8                	shr    %cl,%eax
  8035b4:	09 d0                	or     %edx,%eax
  8035b6:	d3 eb                	shr    %cl,%ebx
  8035b8:	89 da                	mov    %ebx,%edx
  8035ba:	f7 f7                	div    %edi
  8035bc:	89 d3                	mov    %edx,%ebx
  8035be:	f7 24 24             	mull   (%esp)
  8035c1:	89 c6                	mov    %eax,%esi
  8035c3:	89 d1                	mov    %edx,%ecx
  8035c5:	39 d3                	cmp    %edx,%ebx
  8035c7:	0f 82 87 00 00 00    	jb     803654 <__umoddi3+0x134>
  8035cd:	0f 84 91 00 00 00    	je     803664 <__umoddi3+0x144>
  8035d3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8035d7:	29 f2                	sub    %esi,%edx
  8035d9:	19 cb                	sbb    %ecx,%ebx
  8035db:	89 d8                	mov    %ebx,%eax
  8035dd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8035e1:	d3 e0                	shl    %cl,%eax
  8035e3:	89 e9                	mov    %ebp,%ecx
  8035e5:	d3 ea                	shr    %cl,%edx
  8035e7:	09 d0                	or     %edx,%eax
  8035e9:	89 e9                	mov    %ebp,%ecx
  8035eb:	d3 eb                	shr    %cl,%ebx
  8035ed:	89 da                	mov    %ebx,%edx
  8035ef:	83 c4 1c             	add    $0x1c,%esp
  8035f2:	5b                   	pop    %ebx
  8035f3:	5e                   	pop    %esi
  8035f4:	5f                   	pop    %edi
  8035f5:	5d                   	pop    %ebp
  8035f6:	c3                   	ret    
  8035f7:	90                   	nop
  8035f8:	89 fd                	mov    %edi,%ebp
  8035fa:	85 ff                	test   %edi,%edi
  8035fc:	75 0b                	jne    803609 <__umoddi3+0xe9>
  8035fe:	b8 01 00 00 00       	mov    $0x1,%eax
  803603:	31 d2                	xor    %edx,%edx
  803605:	f7 f7                	div    %edi
  803607:	89 c5                	mov    %eax,%ebp
  803609:	89 f0                	mov    %esi,%eax
  80360b:	31 d2                	xor    %edx,%edx
  80360d:	f7 f5                	div    %ebp
  80360f:	89 c8                	mov    %ecx,%eax
  803611:	f7 f5                	div    %ebp
  803613:	89 d0                	mov    %edx,%eax
  803615:	e9 44 ff ff ff       	jmp    80355e <__umoddi3+0x3e>
  80361a:	66 90                	xchg   %ax,%ax
  80361c:	89 c8                	mov    %ecx,%eax
  80361e:	89 f2                	mov    %esi,%edx
  803620:	83 c4 1c             	add    $0x1c,%esp
  803623:	5b                   	pop    %ebx
  803624:	5e                   	pop    %esi
  803625:	5f                   	pop    %edi
  803626:	5d                   	pop    %ebp
  803627:	c3                   	ret    
  803628:	3b 04 24             	cmp    (%esp),%eax
  80362b:	72 06                	jb     803633 <__umoddi3+0x113>
  80362d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803631:	77 0f                	ja     803642 <__umoddi3+0x122>
  803633:	89 f2                	mov    %esi,%edx
  803635:	29 f9                	sub    %edi,%ecx
  803637:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80363b:	89 14 24             	mov    %edx,(%esp)
  80363e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803642:	8b 44 24 04          	mov    0x4(%esp),%eax
  803646:	8b 14 24             	mov    (%esp),%edx
  803649:	83 c4 1c             	add    $0x1c,%esp
  80364c:	5b                   	pop    %ebx
  80364d:	5e                   	pop    %esi
  80364e:	5f                   	pop    %edi
  80364f:	5d                   	pop    %ebp
  803650:	c3                   	ret    
  803651:	8d 76 00             	lea    0x0(%esi),%esi
  803654:	2b 04 24             	sub    (%esp),%eax
  803657:	19 fa                	sbb    %edi,%edx
  803659:	89 d1                	mov    %edx,%ecx
  80365b:	89 c6                	mov    %eax,%esi
  80365d:	e9 71 ff ff ff       	jmp    8035d3 <__umoddi3+0xb3>
  803662:	66 90                	xchg   %ax,%ax
  803664:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803668:	72 ea                	jb     803654 <__umoddi3+0x134>
  80366a:	89 d9                	mov    %ebx,%ecx
  80366c:	e9 62 ff ff ff       	jmp    8035d3 <__umoddi3+0xb3>
