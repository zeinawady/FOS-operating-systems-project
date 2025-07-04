
obj/user/tst_chan_all_master:     file format elf32-i386


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
  800031:	e8 99 01 00 00       	call   8001cf <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Master program: create and run slaves, wait them to finish
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 38             	sub    $0x38,%esp
	int envID = sys_getenvid();
  80003e:	e8 00 18 00 00       	call   801843 <sys_getenvid>
  800043:	89 45 e8             	mov    %eax,-0x18(%ebp)
	char slavesCnt[10];
	readline("Enter the number of Slave Programs: ", slavesCnt);
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	8d 45 da             	lea    -0x26(%ebp),%eax
  80004c:	50                   	push   %eax
  80004d:	68 80 1f 80 00       	push   $0x801f80
  800052:	e8 0e 0c 00 00       	call   800c65 <readline>
  800057:	83 c4 10             	add    $0x10,%esp
	int numOfSlaves = strtol(slavesCnt, NULL, 10);
  80005a:	83 ec 04             	sub    $0x4,%esp
  80005d:	6a 0a                	push   $0xa
  80005f:	6a 00                	push   $0x0
  800061:	8d 45 da             	lea    -0x26(%ebp),%eax
  800064:	50                   	push   %eax
  800065:	e8 63 11 00 00       	call   8011cd <strtol>
  80006a:	83 c4 10             	add    $0x10,%esp
  80006d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	//Create and run slave programs that should sleep
	int id;
	for (int i = 0; i < numOfSlaves; ++i)
  800070:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800077:	eb 68                	jmp    8000e1 <_main+0xa9>
	{
		id = sys_create_env("tstChanAllSlave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800079:	a1 08 30 80 00       	mov    0x803008,%eax
  80007e:	8b 90 90 05 00 00    	mov    0x590(%eax),%edx
  800084:	a1 08 30 80 00       	mov    0x803008,%eax
  800089:	8b 80 88 05 00 00    	mov    0x588(%eax),%eax
  80008f:	89 c1                	mov    %eax,%ecx
  800091:	a1 08 30 80 00       	mov    0x803008,%eax
  800096:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  80009c:	52                   	push   %edx
  80009d:	51                   	push   %ecx
  80009e:	50                   	push   %eax
  80009f:	68 a5 1f 80 00       	push   $0x801fa5
  8000a4:	e8 45 17 00 00       	call   8017ee <sys_create_env>
  8000a9:	83 c4 10             	add    $0x10,%esp
  8000ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (id== E_ENV_CREATION_ERROR)
  8000af:	83 7d e4 ef          	cmpl   $0xffffffef,-0x1c(%ebp)
  8000b3:	75 1b                	jne    8000d0 <_main+0x98>
		{
			cprintf("\n%~insufficient number of processes in the system! only %d slave processes are created\n", i);
  8000b5:	83 ec 08             	sub    $0x8,%esp
  8000b8:	ff 75 f0             	pushl  -0x10(%ebp)
  8000bb:	68 b8 1f 80 00       	push   $0x801fb8
  8000c0:	e8 0c 05 00 00       	call   8005d1 <cprintf>
  8000c5:	83 c4 10             	add    $0x10,%esp
			numOfSlaves = i;
  8000c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
			break;
  8000ce:	eb 19                	jmp    8000e9 <_main+0xb1>
		}
		sys_run_env(id);
  8000d0:	83 ec 0c             	sub    $0xc,%esp
  8000d3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000d6:	e8 31 17 00 00       	call   80180c <sys_run_env>
  8000db:	83 c4 10             	add    $0x10,%esp
	readline("Enter the number of Slave Programs: ", slavesCnt);
	int numOfSlaves = strtol(slavesCnt, NULL, 10);

	//Create and run slave programs that should sleep
	int id;
	for (int i = 0; i < numOfSlaves; ++i)
  8000de:	ff 45 f0             	incl   -0x10(%ebp)
  8000e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000e4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8000e7:	7c 90                	jl     800079 <_main+0x41>
		}
		sys_run_env(id);
	}

	//Wait until all slaves are blocked
	int numOfBlockedProcesses = 0;
  8000e9:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
	sys_utilities("__GetChanQueueSize__", (uint32)(&numOfBlockedProcesses));
  8000f0:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  8000f3:	83 ec 08             	sub    $0x8,%esp
  8000f6:	50                   	push   %eax
  8000f7:	68 10 20 80 00       	push   $0x802010
  8000fc:	e8 2a 1a 00 00       	call   801b2b <sys_utilities>
  800101:	83 c4 10             	add    $0x10,%esp
	int cnt = 0;
  800104:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	while (numOfBlockedProcesses != numOfSlaves)
  80010b:	eb 4a                	jmp    800157 <_main+0x11f>
	{
		env_sleep(1000);
  80010d:	83 ec 0c             	sub    $0xc,%esp
  800110:	68 e8 03 00 00       	push   $0x3e8
  800115:	e8 f6 1a 00 00       	call   801c10 <env_sleep>
  80011a:	83 c4 10             	add    $0x10,%esp
		cnt++ ;
  80011d:	ff 45 ec             	incl   -0x14(%ebp)
		if (cnt == numOfSlaves)
  800120:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800123:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800126:	75 1b                	jne    800143 <_main+0x10b>
		{
			panic("%~test channels failed! unexpected number of blocked slaves. Expected = %d, Current = %d", numOfSlaves, numOfBlockedProcesses);
  800128:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80012b:	83 ec 0c             	sub    $0xc,%esp
  80012e:	50                   	push   %eax
  80012f:	ff 75 f4             	pushl  -0xc(%ebp)
  800132:	68 28 20 80 00       	push   $0x802028
  800137:	6a 25                	push   $0x25
  800139:	68 81 20 80 00       	push   $0x802081
  80013e:	e8 d1 01 00 00       	call   800314 <_panic>
		}
		sys_utilities("__GetChanQueueSize__", (uint32)(&numOfBlockedProcesses));
  800143:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  800146:	83 ec 08             	sub    $0x8,%esp
  800149:	50                   	push   %eax
  80014a:	68 10 20 80 00       	push   $0x802010
  80014f:	e8 d7 19 00 00       	call   801b2b <sys_utilities>
  800154:	83 c4 10             	add    $0x10,%esp

	//Wait until all slaves are blocked
	int numOfBlockedProcesses = 0;
	sys_utilities("__GetChanQueueSize__", (uint32)(&numOfBlockedProcesses));
	int cnt = 0;
	while (numOfBlockedProcesses != numOfSlaves)
  800157:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80015a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80015d:	75 ae                	jne    80010d <_main+0xd5>
			panic("%~test channels failed! unexpected number of blocked slaves. Expected = %d, Current = %d", numOfSlaves, numOfBlockedProcesses);
		}
		sys_utilities("__GetChanQueueSize__", (uint32)(&numOfBlockedProcesses));
	}

	rsttst();
  80015f:	e8 d6 17 00 00       	call   80193a <rsttst>

	//Wakeup all
	sys_utilities("__WakeupAll__", 0);
  800164:	83 ec 08             	sub    $0x8,%esp
  800167:	6a 00                	push   $0x0
  800169:	68 9c 20 80 00       	push   $0x80209c
  80016e:	e8 b8 19 00 00       	call   801b2b <sys_utilities>
  800173:	83 c4 10             	add    $0x10,%esp

	//Wait until all slave finished
	cnt = 0;
  800176:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	while (gettst() != numOfSlaves)
  80017d:	eb 2f                	jmp    8001ae <_main+0x176>
	{
		env_sleep(1000);
  80017f:	83 ec 0c             	sub    $0xc,%esp
  800182:	68 e8 03 00 00       	push   $0x3e8
  800187:	e8 84 1a 00 00       	call   801c10 <env_sleep>
  80018c:	83 c4 10             	add    $0x10,%esp
		cnt++ ;
  80018f:	ff 45 ec             	incl   -0x14(%ebp)
		if (cnt == numOfSlaves)
  800192:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800195:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800198:	75 14                	jne    8001ae <_main+0x176>
		{
			panic("%~test channels failed! not all slaves finished");
  80019a:	83 ec 04             	sub    $0x4,%esp
  80019d:	68 ac 20 80 00       	push   $0x8020ac
  8001a2:	6a 37                	push   $0x37
  8001a4:	68 81 20 80 00       	push   $0x802081
  8001a9:	e8 66 01 00 00       	call   800314 <_panic>
	//Wakeup all
	sys_utilities("__WakeupAll__", 0);

	//Wait until all slave finished
	cnt = 0;
	while (gettst() != numOfSlaves)
  8001ae:	e8 01 18 00 00       	call   8019b4 <gettst>
  8001b3:	89 c2                	mov    %eax,%edx
  8001b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001b8:	39 c2                	cmp    %eax,%edx
  8001ba:	75 c3                	jne    80017f <_main+0x147>
		{
			panic("%~test channels failed! not all slaves finished");
		}
	}

	cprintf("Congratulations!! Test of Channel (sleep & wakeup ALL) completed successfully!!\n\n\n");
  8001bc:	83 ec 0c             	sub    $0xc,%esp
  8001bf:	68 dc 20 80 00       	push   $0x8020dc
  8001c4:	e8 08 04 00 00       	call   8005d1 <cprintf>
  8001c9:	83 c4 10             	add    $0x10,%esp

	return;
  8001cc:	90                   	nop
}
  8001cd:	c9                   	leave  
  8001ce:	c3                   	ret    

008001cf <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8001cf:	55                   	push   %ebp
  8001d0:	89 e5                	mov    %esp,%ebp
  8001d2:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8001d5:	e8 82 16 00 00       	call   80185c <sys_getenvindex>
  8001da:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8001dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001e0:	89 d0                	mov    %edx,%eax
  8001e2:	c1 e0 02             	shl    $0x2,%eax
  8001e5:	01 d0                	add    %edx,%eax
  8001e7:	c1 e0 03             	shl    $0x3,%eax
  8001ea:	01 d0                	add    %edx,%eax
  8001ec:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8001f3:	01 d0                	add    %edx,%eax
  8001f5:	c1 e0 02             	shl    $0x2,%eax
  8001f8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001fd:	a3 08 30 80 00       	mov    %eax,0x803008

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800202:	a1 08 30 80 00       	mov    0x803008,%eax
  800207:	8a 40 20             	mov    0x20(%eax),%al
  80020a:	84 c0                	test   %al,%al
  80020c:	74 0d                	je     80021b <libmain+0x4c>
		binaryname = myEnv->prog_name;
  80020e:	a1 08 30 80 00       	mov    0x803008,%eax
  800213:	83 c0 20             	add    $0x20,%eax
  800216:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80021b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80021f:	7e 0a                	jle    80022b <libmain+0x5c>
		binaryname = argv[0];
  800221:	8b 45 0c             	mov    0xc(%ebp),%eax
  800224:	8b 00                	mov    (%eax),%eax
  800226:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  80022b:	83 ec 08             	sub    $0x8,%esp
  80022e:	ff 75 0c             	pushl  0xc(%ebp)
  800231:	ff 75 08             	pushl  0x8(%ebp)
  800234:	e8 ff fd ff ff       	call   800038 <_main>
  800239:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80023c:	a1 00 30 80 00       	mov    0x803000,%eax
  800241:	85 c0                	test   %eax,%eax
  800243:	0f 84 9f 00 00 00    	je     8002e8 <libmain+0x119>
	{
		sys_lock_cons();
  800249:	e8 92 13 00 00       	call   8015e0 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80024e:	83 ec 0c             	sub    $0xc,%esp
  800251:	68 48 21 80 00       	push   $0x802148
  800256:	e8 76 03 00 00       	call   8005d1 <cprintf>
  80025b:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80025e:	a1 08 30 80 00       	mov    0x803008,%eax
  800263:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800269:	a1 08 30 80 00       	mov    0x803008,%eax
  80026e:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800274:	83 ec 04             	sub    $0x4,%esp
  800277:	52                   	push   %edx
  800278:	50                   	push   %eax
  800279:	68 70 21 80 00       	push   $0x802170
  80027e:	e8 4e 03 00 00       	call   8005d1 <cprintf>
  800283:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800286:	a1 08 30 80 00       	mov    0x803008,%eax
  80028b:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800291:	a1 08 30 80 00       	mov    0x803008,%eax
  800296:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  80029c:	a1 08 30 80 00       	mov    0x803008,%eax
  8002a1:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  8002a7:	51                   	push   %ecx
  8002a8:	52                   	push   %edx
  8002a9:	50                   	push   %eax
  8002aa:	68 98 21 80 00       	push   $0x802198
  8002af:	e8 1d 03 00 00       	call   8005d1 <cprintf>
  8002b4:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002b7:	a1 08 30 80 00       	mov    0x803008,%eax
  8002bc:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8002c2:	83 ec 08             	sub    $0x8,%esp
  8002c5:	50                   	push   %eax
  8002c6:	68 f0 21 80 00       	push   $0x8021f0
  8002cb:	e8 01 03 00 00       	call   8005d1 <cprintf>
  8002d0:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8002d3:	83 ec 0c             	sub    $0xc,%esp
  8002d6:	68 48 21 80 00       	push   $0x802148
  8002db:	e8 f1 02 00 00       	call   8005d1 <cprintf>
  8002e0:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8002e3:	e8 12 13 00 00       	call   8015fa <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8002e8:	e8 19 00 00 00       	call   800306 <exit>
}
  8002ed:	90                   	nop
  8002ee:	c9                   	leave  
  8002ef:	c3                   	ret    

008002f0 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002f0:	55                   	push   %ebp
  8002f1:	89 e5                	mov    %esp,%ebp
  8002f3:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002f6:	83 ec 0c             	sub    $0xc,%esp
  8002f9:	6a 00                	push   $0x0
  8002fb:	e8 28 15 00 00       	call   801828 <sys_destroy_env>
  800300:	83 c4 10             	add    $0x10,%esp
}
  800303:	90                   	nop
  800304:	c9                   	leave  
  800305:	c3                   	ret    

00800306 <exit>:

void
exit(void)
{
  800306:	55                   	push   %ebp
  800307:	89 e5                	mov    %esp,%ebp
  800309:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80030c:	e8 7d 15 00 00       	call   80188e <sys_exit_env>
}
  800311:	90                   	nop
  800312:	c9                   	leave  
  800313:	c3                   	ret    

00800314 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800314:	55                   	push   %ebp
  800315:	89 e5                	mov    %esp,%ebp
  800317:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80031a:	8d 45 10             	lea    0x10(%ebp),%eax
  80031d:	83 c0 04             	add    $0x4,%eax
  800320:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800323:	a1 28 30 80 00       	mov    0x803028,%eax
  800328:	85 c0                	test   %eax,%eax
  80032a:	74 16                	je     800342 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80032c:	a1 28 30 80 00       	mov    0x803028,%eax
  800331:	83 ec 08             	sub    $0x8,%esp
  800334:	50                   	push   %eax
  800335:	68 04 22 80 00       	push   $0x802204
  80033a:	e8 92 02 00 00       	call   8005d1 <cprintf>
  80033f:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800342:	a1 04 30 80 00       	mov    0x803004,%eax
  800347:	ff 75 0c             	pushl  0xc(%ebp)
  80034a:	ff 75 08             	pushl  0x8(%ebp)
  80034d:	50                   	push   %eax
  80034e:	68 09 22 80 00       	push   $0x802209
  800353:	e8 79 02 00 00       	call   8005d1 <cprintf>
  800358:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80035b:	8b 45 10             	mov    0x10(%ebp),%eax
  80035e:	83 ec 08             	sub    $0x8,%esp
  800361:	ff 75 f4             	pushl  -0xc(%ebp)
  800364:	50                   	push   %eax
  800365:	e8 fc 01 00 00       	call   800566 <vcprintf>
  80036a:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80036d:	83 ec 08             	sub    $0x8,%esp
  800370:	6a 00                	push   $0x0
  800372:	68 25 22 80 00       	push   $0x802225
  800377:	e8 ea 01 00 00       	call   800566 <vcprintf>
  80037c:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80037f:	e8 82 ff ff ff       	call   800306 <exit>

	// should not return here
	while (1) ;
  800384:	eb fe                	jmp    800384 <_panic+0x70>

00800386 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800386:	55                   	push   %ebp
  800387:	89 e5                	mov    %esp,%ebp
  800389:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80038c:	a1 08 30 80 00       	mov    0x803008,%eax
  800391:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800397:	8b 45 0c             	mov    0xc(%ebp),%eax
  80039a:	39 c2                	cmp    %eax,%edx
  80039c:	74 14                	je     8003b2 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80039e:	83 ec 04             	sub    $0x4,%esp
  8003a1:	68 28 22 80 00       	push   $0x802228
  8003a6:	6a 26                	push   $0x26
  8003a8:	68 74 22 80 00       	push   $0x802274
  8003ad:	e8 62 ff ff ff       	call   800314 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8003b2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8003b9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003c0:	e9 c5 00 00 00       	jmp    80048a <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8003c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003c8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d2:	01 d0                	add    %edx,%eax
  8003d4:	8b 00                	mov    (%eax),%eax
  8003d6:	85 c0                	test   %eax,%eax
  8003d8:	75 08                	jne    8003e2 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8003da:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003dd:	e9 a5 00 00 00       	jmp    800487 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8003e2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003e9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003f0:	eb 69                	jmp    80045b <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003f2:	a1 08 30 80 00       	mov    0x803008,%eax
  8003f7:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8003fd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800400:	89 d0                	mov    %edx,%eax
  800402:	01 c0                	add    %eax,%eax
  800404:	01 d0                	add    %edx,%eax
  800406:	c1 e0 03             	shl    $0x3,%eax
  800409:	01 c8                	add    %ecx,%eax
  80040b:	8a 40 04             	mov    0x4(%eax),%al
  80040e:	84 c0                	test   %al,%al
  800410:	75 46                	jne    800458 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800412:	a1 08 30 80 00       	mov    0x803008,%eax
  800417:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  80041d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800420:	89 d0                	mov    %edx,%eax
  800422:	01 c0                	add    %eax,%eax
  800424:	01 d0                	add    %edx,%eax
  800426:	c1 e0 03             	shl    $0x3,%eax
  800429:	01 c8                	add    %ecx,%eax
  80042b:	8b 00                	mov    (%eax),%eax
  80042d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800430:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800433:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800438:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80043a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80043d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800444:	8b 45 08             	mov    0x8(%ebp),%eax
  800447:	01 c8                	add    %ecx,%eax
  800449:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80044b:	39 c2                	cmp    %eax,%edx
  80044d:	75 09                	jne    800458 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80044f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800456:	eb 15                	jmp    80046d <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800458:	ff 45 e8             	incl   -0x18(%ebp)
  80045b:	a1 08 30 80 00       	mov    0x803008,%eax
  800460:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800466:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800469:	39 c2                	cmp    %eax,%edx
  80046b:	77 85                	ja     8003f2 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80046d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800471:	75 14                	jne    800487 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800473:	83 ec 04             	sub    $0x4,%esp
  800476:	68 80 22 80 00       	push   $0x802280
  80047b:	6a 3a                	push   $0x3a
  80047d:	68 74 22 80 00       	push   $0x802274
  800482:	e8 8d fe ff ff       	call   800314 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800487:	ff 45 f0             	incl   -0x10(%ebp)
  80048a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80048d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800490:	0f 8c 2f ff ff ff    	jl     8003c5 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800496:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80049d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004a4:	eb 26                	jmp    8004cc <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8004a6:	a1 08 30 80 00       	mov    0x803008,%eax
  8004ab:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8004b1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004b4:	89 d0                	mov    %edx,%eax
  8004b6:	01 c0                	add    %eax,%eax
  8004b8:	01 d0                	add    %edx,%eax
  8004ba:	c1 e0 03             	shl    $0x3,%eax
  8004bd:	01 c8                	add    %ecx,%eax
  8004bf:	8a 40 04             	mov    0x4(%eax),%al
  8004c2:	3c 01                	cmp    $0x1,%al
  8004c4:	75 03                	jne    8004c9 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8004c6:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004c9:	ff 45 e0             	incl   -0x20(%ebp)
  8004cc:	a1 08 30 80 00       	mov    0x803008,%eax
  8004d1:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8004d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004da:	39 c2                	cmp    %eax,%edx
  8004dc:	77 c8                	ja     8004a6 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004e1:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004e4:	74 14                	je     8004fa <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8004e6:	83 ec 04             	sub    $0x4,%esp
  8004e9:	68 d4 22 80 00       	push   $0x8022d4
  8004ee:	6a 44                	push   $0x44
  8004f0:	68 74 22 80 00       	push   $0x802274
  8004f5:	e8 1a fe ff ff       	call   800314 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004fa:	90                   	nop
  8004fb:	c9                   	leave  
  8004fc:	c3                   	ret    

008004fd <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8004fd:	55                   	push   %ebp
  8004fe:	89 e5                	mov    %esp,%ebp
  800500:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800503:	8b 45 0c             	mov    0xc(%ebp),%eax
  800506:	8b 00                	mov    (%eax),%eax
  800508:	8d 48 01             	lea    0x1(%eax),%ecx
  80050b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80050e:	89 0a                	mov    %ecx,(%edx)
  800510:	8b 55 08             	mov    0x8(%ebp),%edx
  800513:	88 d1                	mov    %dl,%cl
  800515:	8b 55 0c             	mov    0xc(%ebp),%edx
  800518:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80051c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80051f:	8b 00                	mov    (%eax),%eax
  800521:	3d ff 00 00 00       	cmp    $0xff,%eax
  800526:	75 2c                	jne    800554 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800528:	a0 0c 30 80 00       	mov    0x80300c,%al
  80052d:	0f b6 c0             	movzbl %al,%eax
  800530:	8b 55 0c             	mov    0xc(%ebp),%edx
  800533:	8b 12                	mov    (%edx),%edx
  800535:	89 d1                	mov    %edx,%ecx
  800537:	8b 55 0c             	mov    0xc(%ebp),%edx
  80053a:	83 c2 08             	add    $0x8,%edx
  80053d:	83 ec 04             	sub    $0x4,%esp
  800540:	50                   	push   %eax
  800541:	51                   	push   %ecx
  800542:	52                   	push   %edx
  800543:	e8 56 10 00 00       	call   80159e <sys_cputs>
  800548:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80054b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80054e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800554:	8b 45 0c             	mov    0xc(%ebp),%eax
  800557:	8b 40 04             	mov    0x4(%eax),%eax
  80055a:	8d 50 01             	lea    0x1(%eax),%edx
  80055d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800560:	89 50 04             	mov    %edx,0x4(%eax)
}
  800563:	90                   	nop
  800564:	c9                   	leave  
  800565:	c3                   	ret    

00800566 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800566:	55                   	push   %ebp
  800567:	89 e5                	mov    %esp,%ebp
  800569:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80056f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800576:	00 00 00 
	b.cnt = 0;
  800579:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800580:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800583:	ff 75 0c             	pushl  0xc(%ebp)
  800586:	ff 75 08             	pushl  0x8(%ebp)
  800589:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80058f:	50                   	push   %eax
  800590:	68 fd 04 80 00       	push   $0x8004fd
  800595:	e8 11 02 00 00       	call   8007ab <vprintfmt>
  80059a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80059d:	a0 0c 30 80 00       	mov    0x80300c,%al
  8005a2:	0f b6 c0             	movzbl %al,%eax
  8005a5:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8005ab:	83 ec 04             	sub    $0x4,%esp
  8005ae:	50                   	push   %eax
  8005af:	52                   	push   %edx
  8005b0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005b6:	83 c0 08             	add    $0x8,%eax
  8005b9:	50                   	push   %eax
  8005ba:	e8 df 0f 00 00       	call   80159e <sys_cputs>
  8005bf:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005c2:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
	return b.cnt;
  8005c9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005cf:	c9                   	leave  
  8005d0:	c3                   	ret    

008005d1 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8005d1:	55                   	push   %ebp
  8005d2:	89 e5                	mov    %esp,%ebp
  8005d4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005d7:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
	va_start(ap, fmt);
  8005de:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e7:	83 ec 08             	sub    $0x8,%esp
  8005ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8005ed:	50                   	push   %eax
  8005ee:	e8 73 ff ff ff       	call   800566 <vcprintf>
  8005f3:	83 c4 10             	add    $0x10,%esp
  8005f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005fc:	c9                   	leave  
  8005fd:	c3                   	ret    

008005fe <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8005fe:	55                   	push   %ebp
  8005ff:	89 e5                	mov    %esp,%ebp
  800601:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800604:	e8 d7 0f 00 00       	call   8015e0 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800609:	8d 45 0c             	lea    0xc(%ebp),%eax
  80060c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80060f:	8b 45 08             	mov    0x8(%ebp),%eax
  800612:	83 ec 08             	sub    $0x8,%esp
  800615:	ff 75 f4             	pushl  -0xc(%ebp)
  800618:	50                   	push   %eax
  800619:	e8 48 ff ff ff       	call   800566 <vcprintf>
  80061e:	83 c4 10             	add    $0x10,%esp
  800621:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800624:	e8 d1 0f 00 00       	call   8015fa <sys_unlock_cons>
	return cnt;
  800629:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80062c:	c9                   	leave  
  80062d:	c3                   	ret    

0080062e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80062e:	55                   	push   %ebp
  80062f:	89 e5                	mov    %esp,%ebp
  800631:	53                   	push   %ebx
  800632:	83 ec 14             	sub    $0x14,%esp
  800635:	8b 45 10             	mov    0x10(%ebp),%eax
  800638:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80063b:	8b 45 14             	mov    0x14(%ebp),%eax
  80063e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800641:	8b 45 18             	mov    0x18(%ebp),%eax
  800644:	ba 00 00 00 00       	mov    $0x0,%edx
  800649:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80064c:	77 55                	ja     8006a3 <printnum+0x75>
  80064e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800651:	72 05                	jb     800658 <printnum+0x2a>
  800653:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800656:	77 4b                	ja     8006a3 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800658:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80065b:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80065e:	8b 45 18             	mov    0x18(%ebp),%eax
  800661:	ba 00 00 00 00       	mov    $0x0,%edx
  800666:	52                   	push   %edx
  800667:	50                   	push   %eax
  800668:	ff 75 f4             	pushl  -0xc(%ebp)
  80066b:	ff 75 f0             	pushl  -0x10(%ebp)
  80066e:	e8 8d 16 00 00       	call   801d00 <__udivdi3>
  800673:	83 c4 10             	add    $0x10,%esp
  800676:	83 ec 04             	sub    $0x4,%esp
  800679:	ff 75 20             	pushl  0x20(%ebp)
  80067c:	53                   	push   %ebx
  80067d:	ff 75 18             	pushl  0x18(%ebp)
  800680:	52                   	push   %edx
  800681:	50                   	push   %eax
  800682:	ff 75 0c             	pushl  0xc(%ebp)
  800685:	ff 75 08             	pushl  0x8(%ebp)
  800688:	e8 a1 ff ff ff       	call   80062e <printnum>
  80068d:	83 c4 20             	add    $0x20,%esp
  800690:	eb 1a                	jmp    8006ac <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800692:	83 ec 08             	sub    $0x8,%esp
  800695:	ff 75 0c             	pushl  0xc(%ebp)
  800698:	ff 75 20             	pushl  0x20(%ebp)
  80069b:	8b 45 08             	mov    0x8(%ebp),%eax
  80069e:	ff d0                	call   *%eax
  8006a0:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006a3:	ff 4d 1c             	decl   0x1c(%ebp)
  8006a6:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006aa:	7f e6                	jg     800692 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006ac:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006af:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006ba:	53                   	push   %ebx
  8006bb:	51                   	push   %ecx
  8006bc:	52                   	push   %edx
  8006bd:	50                   	push   %eax
  8006be:	e8 4d 17 00 00       	call   801e10 <__umoddi3>
  8006c3:	83 c4 10             	add    $0x10,%esp
  8006c6:	05 34 25 80 00       	add    $0x802534,%eax
  8006cb:	8a 00                	mov    (%eax),%al
  8006cd:	0f be c0             	movsbl %al,%eax
  8006d0:	83 ec 08             	sub    $0x8,%esp
  8006d3:	ff 75 0c             	pushl  0xc(%ebp)
  8006d6:	50                   	push   %eax
  8006d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006da:	ff d0                	call   *%eax
  8006dc:	83 c4 10             	add    $0x10,%esp
}
  8006df:	90                   	nop
  8006e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006e3:	c9                   	leave  
  8006e4:	c3                   	ret    

008006e5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006e5:	55                   	push   %ebp
  8006e6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006e8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006ec:	7e 1c                	jle    80070a <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f1:	8b 00                	mov    (%eax),%eax
  8006f3:	8d 50 08             	lea    0x8(%eax),%edx
  8006f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f9:	89 10                	mov    %edx,(%eax)
  8006fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fe:	8b 00                	mov    (%eax),%eax
  800700:	83 e8 08             	sub    $0x8,%eax
  800703:	8b 50 04             	mov    0x4(%eax),%edx
  800706:	8b 00                	mov    (%eax),%eax
  800708:	eb 40                	jmp    80074a <getuint+0x65>
	else if (lflag)
  80070a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80070e:	74 1e                	je     80072e <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800710:	8b 45 08             	mov    0x8(%ebp),%eax
  800713:	8b 00                	mov    (%eax),%eax
  800715:	8d 50 04             	lea    0x4(%eax),%edx
  800718:	8b 45 08             	mov    0x8(%ebp),%eax
  80071b:	89 10                	mov    %edx,(%eax)
  80071d:	8b 45 08             	mov    0x8(%ebp),%eax
  800720:	8b 00                	mov    (%eax),%eax
  800722:	83 e8 04             	sub    $0x4,%eax
  800725:	8b 00                	mov    (%eax),%eax
  800727:	ba 00 00 00 00       	mov    $0x0,%edx
  80072c:	eb 1c                	jmp    80074a <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80072e:	8b 45 08             	mov    0x8(%ebp),%eax
  800731:	8b 00                	mov    (%eax),%eax
  800733:	8d 50 04             	lea    0x4(%eax),%edx
  800736:	8b 45 08             	mov    0x8(%ebp),%eax
  800739:	89 10                	mov    %edx,(%eax)
  80073b:	8b 45 08             	mov    0x8(%ebp),%eax
  80073e:	8b 00                	mov    (%eax),%eax
  800740:	83 e8 04             	sub    $0x4,%eax
  800743:	8b 00                	mov    (%eax),%eax
  800745:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80074a:	5d                   	pop    %ebp
  80074b:	c3                   	ret    

0080074c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80074c:	55                   	push   %ebp
  80074d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80074f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800753:	7e 1c                	jle    800771 <getint+0x25>
		return va_arg(*ap, long long);
  800755:	8b 45 08             	mov    0x8(%ebp),%eax
  800758:	8b 00                	mov    (%eax),%eax
  80075a:	8d 50 08             	lea    0x8(%eax),%edx
  80075d:	8b 45 08             	mov    0x8(%ebp),%eax
  800760:	89 10                	mov    %edx,(%eax)
  800762:	8b 45 08             	mov    0x8(%ebp),%eax
  800765:	8b 00                	mov    (%eax),%eax
  800767:	83 e8 08             	sub    $0x8,%eax
  80076a:	8b 50 04             	mov    0x4(%eax),%edx
  80076d:	8b 00                	mov    (%eax),%eax
  80076f:	eb 38                	jmp    8007a9 <getint+0x5d>
	else if (lflag)
  800771:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800775:	74 1a                	je     800791 <getint+0x45>
		return va_arg(*ap, long);
  800777:	8b 45 08             	mov    0x8(%ebp),%eax
  80077a:	8b 00                	mov    (%eax),%eax
  80077c:	8d 50 04             	lea    0x4(%eax),%edx
  80077f:	8b 45 08             	mov    0x8(%ebp),%eax
  800782:	89 10                	mov    %edx,(%eax)
  800784:	8b 45 08             	mov    0x8(%ebp),%eax
  800787:	8b 00                	mov    (%eax),%eax
  800789:	83 e8 04             	sub    $0x4,%eax
  80078c:	8b 00                	mov    (%eax),%eax
  80078e:	99                   	cltd   
  80078f:	eb 18                	jmp    8007a9 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800791:	8b 45 08             	mov    0x8(%ebp),%eax
  800794:	8b 00                	mov    (%eax),%eax
  800796:	8d 50 04             	lea    0x4(%eax),%edx
  800799:	8b 45 08             	mov    0x8(%ebp),%eax
  80079c:	89 10                	mov    %edx,(%eax)
  80079e:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a1:	8b 00                	mov    (%eax),%eax
  8007a3:	83 e8 04             	sub    $0x4,%eax
  8007a6:	8b 00                	mov    (%eax),%eax
  8007a8:	99                   	cltd   
}
  8007a9:	5d                   	pop    %ebp
  8007aa:	c3                   	ret    

008007ab <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007ab:	55                   	push   %ebp
  8007ac:	89 e5                	mov    %esp,%ebp
  8007ae:	56                   	push   %esi
  8007af:	53                   	push   %ebx
  8007b0:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007b3:	eb 17                	jmp    8007cc <vprintfmt+0x21>
			if (ch == '\0')
  8007b5:	85 db                	test   %ebx,%ebx
  8007b7:	0f 84 c1 03 00 00    	je     800b7e <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8007bd:	83 ec 08             	sub    $0x8,%esp
  8007c0:	ff 75 0c             	pushl  0xc(%ebp)
  8007c3:	53                   	push   %ebx
  8007c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c7:	ff d0                	call   *%eax
  8007c9:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8007cf:	8d 50 01             	lea    0x1(%eax),%edx
  8007d2:	89 55 10             	mov    %edx,0x10(%ebp)
  8007d5:	8a 00                	mov    (%eax),%al
  8007d7:	0f b6 d8             	movzbl %al,%ebx
  8007da:	83 fb 25             	cmp    $0x25,%ebx
  8007dd:	75 d6                	jne    8007b5 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007df:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007e3:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007ea:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007f1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007f8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007ff:	8b 45 10             	mov    0x10(%ebp),%eax
  800802:	8d 50 01             	lea    0x1(%eax),%edx
  800805:	89 55 10             	mov    %edx,0x10(%ebp)
  800808:	8a 00                	mov    (%eax),%al
  80080a:	0f b6 d8             	movzbl %al,%ebx
  80080d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800810:	83 f8 5b             	cmp    $0x5b,%eax
  800813:	0f 87 3d 03 00 00    	ja     800b56 <vprintfmt+0x3ab>
  800819:	8b 04 85 58 25 80 00 	mov    0x802558(,%eax,4),%eax
  800820:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800822:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800826:	eb d7                	jmp    8007ff <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800828:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80082c:	eb d1                	jmp    8007ff <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80082e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800835:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800838:	89 d0                	mov    %edx,%eax
  80083a:	c1 e0 02             	shl    $0x2,%eax
  80083d:	01 d0                	add    %edx,%eax
  80083f:	01 c0                	add    %eax,%eax
  800841:	01 d8                	add    %ebx,%eax
  800843:	83 e8 30             	sub    $0x30,%eax
  800846:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800849:	8b 45 10             	mov    0x10(%ebp),%eax
  80084c:	8a 00                	mov    (%eax),%al
  80084e:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800851:	83 fb 2f             	cmp    $0x2f,%ebx
  800854:	7e 3e                	jle    800894 <vprintfmt+0xe9>
  800856:	83 fb 39             	cmp    $0x39,%ebx
  800859:	7f 39                	jg     800894 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80085b:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80085e:	eb d5                	jmp    800835 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800860:	8b 45 14             	mov    0x14(%ebp),%eax
  800863:	83 c0 04             	add    $0x4,%eax
  800866:	89 45 14             	mov    %eax,0x14(%ebp)
  800869:	8b 45 14             	mov    0x14(%ebp),%eax
  80086c:	83 e8 04             	sub    $0x4,%eax
  80086f:	8b 00                	mov    (%eax),%eax
  800871:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800874:	eb 1f                	jmp    800895 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800876:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80087a:	79 83                	jns    8007ff <vprintfmt+0x54>
				width = 0;
  80087c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800883:	e9 77 ff ff ff       	jmp    8007ff <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800888:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80088f:	e9 6b ff ff ff       	jmp    8007ff <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800894:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800895:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800899:	0f 89 60 ff ff ff    	jns    8007ff <vprintfmt+0x54>
				width = precision, precision = -1;
  80089f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008a5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008ac:	e9 4e ff ff ff       	jmp    8007ff <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008b1:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008b4:	e9 46 ff ff ff       	jmp    8007ff <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bc:	83 c0 04             	add    $0x4,%eax
  8008bf:	89 45 14             	mov    %eax,0x14(%ebp)
  8008c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c5:	83 e8 04             	sub    $0x4,%eax
  8008c8:	8b 00                	mov    (%eax),%eax
  8008ca:	83 ec 08             	sub    $0x8,%esp
  8008cd:	ff 75 0c             	pushl  0xc(%ebp)
  8008d0:	50                   	push   %eax
  8008d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d4:	ff d0                	call   *%eax
  8008d6:	83 c4 10             	add    $0x10,%esp
			break;
  8008d9:	e9 9b 02 00 00       	jmp    800b79 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008de:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e1:	83 c0 04             	add    $0x4,%eax
  8008e4:	89 45 14             	mov    %eax,0x14(%ebp)
  8008e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ea:	83 e8 04             	sub    $0x4,%eax
  8008ed:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008ef:	85 db                	test   %ebx,%ebx
  8008f1:	79 02                	jns    8008f5 <vprintfmt+0x14a>
				err = -err;
  8008f3:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008f5:	83 fb 64             	cmp    $0x64,%ebx
  8008f8:	7f 0b                	jg     800905 <vprintfmt+0x15a>
  8008fa:	8b 34 9d a0 23 80 00 	mov    0x8023a0(,%ebx,4),%esi
  800901:	85 f6                	test   %esi,%esi
  800903:	75 19                	jne    80091e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800905:	53                   	push   %ebx
  800906:	68 45 25 80 00       	push   $0x802545
  80090b:	ff 75 0c             	pushl  0xc(%ebp)
  80090e:	ff 75 08             	pushl  0x8(%ebp)
  800911:	e8 70 02 00 00       	call   800b86 <printfmt>
  800916:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800919:	e9 5b 02 00 00       	jmp    800b79 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80091e:	56                   	push   %esi
  80091f:	68 4e 25 80 00       	push   $0x80254e
  800924:	ff 75 0c             	pushl  0xc(%ebp)
  800927:	ff 75 08             	pushl  0x8(%ebp)
  80092a:	e8 57 02 00 00       	call   800b86 <printfmt>
  80092f:	83 c4 10             	add    $0x10,%esp
			break;
  800932:	e9 42 02 00 00       	jmp    800b79 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800937:	8b 45 14             	mov    0x14(%ebp),%eax
  80093a:	83 c0 04             	add    $0x4,%eax
  80093d:	89 45 14             	mov    %eax,0x14(%ebp)
  800940:	8b 45 14             	mov    0x14(%ebp),%eax
  800943:	83 e8 04             	sub    $0x4,%eax
  800946:	8b 30                	mov    (%eax),%esi
  800948:	85 f6                	test   %esi,%esi
  80094a:	75 05                	jne    800951 <vprintfmt+0x1a6>
				p = "(null)";
  80094c:	be 51 25 80 00       	mov    $0x802551,%esi
			if (width > 0 && padc != '-')
  800951:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800955:	7e 6d                	jle    8009c4 <vprintfmt+0x219>
  800957:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80095b:	74 67                	je     8009c4 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80095d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800960:	83 ec 08             	sub    $0x8,%esp
  800963:	50                   	push   %eax
  800964:	56                   	push   %esi
  800965:	e8 26 05 00 00       	call   800e90 <strnlen>
  80096a:	83 c4 10             	add    $0x10,%esp
  80096d:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800970:	eb 16                	jmp    800988 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800972:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800976:	83 ec 08             	sub    $0x8,%esp
  800979:	ff 75 0c             	pushl  0xc(%ebp)
  80097c:	50                   	push   %eax
  80097d:	8b 45 08             	mov    0x8(%ebp),%eax
  800980:	ff d0                	call   *%eax
  800982:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800985:	ff 4d e4             	decl   -0x1c(%ebp)
  800988:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80098c:	7f e4                	jg     800972 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80098e:	eb 34                	jmp    8009c4 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800990:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800994:	74 1c                	je     8009b2 <vprintfmt+0x207>
  800996:	83 fb 1f             	cmp    $0x1f,%ebx
  800999:	7e 05                	jle    8009a0 <vprintfmt+0x1f5>
  80099b:	83 fb 7e             	cmp    $0x7e,%ebx
  80099e:	7e 12                	jle    8009b2 <vprintfmt+0x207>
					putch('?', putdat);
  8009a0:	83 ec 08             	sub    $0x8,%esp
  8009a3:	ff 75 0c             	pushl  0xc(%ebp)
  8009a6:	6a 3f                	push   $0x3f
  8009a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ab:	ff d0                	call   *%eax
  8009ad:	83 c4 10             	add    $0x10,%esp
  8009b0:	eb 0f                	jmp    8009c1 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009b2:	83 ec 08             	sub    $0x8,%esp
  8009b5:	ff 75 0c             	pushl  0xc(%ebp)
  8009b8:	53                   	push   %ebx
  8009b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bc:	ff d0                	call   *%eax
  8009be:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009c1:	ff 4d e4             	decl   -0x1c(%ebp)
  8009c4:	89 f0                	mov    %esi,%eax
  8009c6:	8d 70 01             	lea    0x1(%eax),%esi
  8009c9:	8a 00                	mov    (%eax),%al
  8009cb:	0f be d8             	movsbl %al,%ebx
  8009ce:	85 db                	test   %ebx,%ebx
  8009d0:	74 24                	je     8009f6 <vprintfmt+0x24b>
  8009d2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009d6:	78 b8                	js     800990 <vprintfmt+0x1e5>
  8009d8:	ff 4d e0             	decl   -0x20(%ebp)
  8009db:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009df:	79 af                	jns    800990 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009e1:	eb 13                	jmp    8009f6 <vprintfmt+0x24b>
				putch(' ', putdat);
  8009e3:	83 ec 08             	sub    $0x8,%esp
  8009e6:	ff 75 0c             	pushl  0xc(%ebp)
  8009e9:	6a 20                	push   $0x20
  8009eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ee:	ff d0                	call   *%eax
  8009f0:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009f3:	ff 4d e4             	decl   -0x1c(%ebp)
  8009f6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009fa:	7f e7                	jg     8009e3 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009fc:	e9 78 01 00 00       	jmp    800b79 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a01:	83 ec 08             	sub    $0x8,%esp
  800a04:	ff 75 e8             	pushl  -0x18(%ebp)
  800a07:	8d 45 14             	lea    0x14(%ebp),%eax
  800a0a:	50                   	push   %eax
  800a0b:	e8 3c fd ff ff       	call   80074c <getint>
  800a10:	83 c4 10             	add    $0x10,%esp
  800a13:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a16:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a1f:	85 d2                	test   %edx,%edx
  800a21:	79 23                	jns    800a46 <vprintfmt+0x29b>
				putch('-', putdat);
  800a23:	83 ec 08             	sub    $0x8,%esp
  800a26:	ff 75 0c             	pushl  0xc(%ebp)
  800a29:	6a 2d                	push   $0x2d
  800a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2e:	ff d0                	call   *%eax
  800a30:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a39:	f7 d8                	neg    %eax
  800a3b:	83 d2 00             	adc    $0x0,%edx
  800a3e:	f7 da                	neg    %edx
  800a40:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a43:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a46:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a4d:	e9 bc 00 00 00       	jmp    800b0e <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a52:	83 ec 08             	sub    $0x8,%esp
  800a55:	ff 75 e8             	pushl  -0x18(%ebp)
  800a58:	8d 45 14             	lea    0x14(%ebp),%eax
  800a5b:	50                   	push   %eax
  800a5c:	e8 84 fc ff ff       	call   8006e5 <getuint>
  800a61:	83 c4 10             	add    $0x10,%esp
  800a64:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a67:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a6a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a71:	e9 98 00 00 00       	jmp    800b0e <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a76:	83 ec 08             	sub    $0x8,%esp
  800a79:	ff 75 0c             	pushl  0xc(%ebp)
  800a7c:	6a 58                	push   $0x58
  800a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a81:	ff d0                	call   *%eax
  800a83:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a86:	83 ec 08             	sub    $0x8,%esp
  800a89:	ff 75 0c             	pushl  0xc(%ebp)
  800a8c:	6a 58                	push   $0x58
  800a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a91:	ff d0                	call   *%eax
  800a93:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a96:	83 ec 08             	sub    $0x8,%esp
  800a99:	ff 75 0c             	pushl  0xc(%ebp)
  800a9c:	6a 58                	push   $0x58
  800a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa1:	ff d0                	call   *%eax
  800aa3:	83 c4 10             	add    $0x10,%esp
			break;
  800aa6:	e9 ce 00 00 00       	jmp    800b79 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800aab:	83 ec 08             	sub    $0x8,%esp
  800aae:	ff 75 0c             	pushl  0xc(%ebp)
  800ab1:	6a 30                	push   $0x30
  800ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab6:	ff d0                	call   *%eax
  800ab8:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800abb:	83 ec 08             	sub    $0x8,%esp
  800abe:	ff 75 0c             	pushl  0xc(%ebp)
  800ac1:	6a 78                	push   $0x78
  800ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac6:	ff d0                	call   *%eax
  800ac8:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800acb:	8b 45 14             	mov    0x14(%ebp),%eax
  800ace:	83 c0 04             	add    $0x4,%eax
  800ad1:	89 45 14             	mov    %eax,0x14(%ebp)
  800ad4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad7:	83 e8 04             	sub    $0x4,%eax
  800ada:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800adc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800adf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ae6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800aed:	eb 1f                	jmp    800b0e <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800aef:	83 ec 08             	sub    $0x8,%esp
  800af2:	ff 75 e8             	pushl  -0x18(%ebp)
  800af5:	8d 45 14             	lea    0x14(%ebp),%eax
  800af8:	50                   	push   %eax
  800af9:	e8 e7 fb ff ff       	call   8006e5 <getuint>
  800afe:	83 c4 10             	add    $0x10,%esp
  800b01:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b04:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b07:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b0e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b15:	83 ec 04             	sub    $0x4,%esp
  800b18:	52                   	push   %edx
  800b19:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b1c:	50                   	push   %eax
  800b1d:	ff 75 f4             	pushl  -0xc(%ebp)
  800b20:	ff 75 f0             	pushl  -0x10(%ebp)
  800b23:	ff 75 0c             	pushl  0xc(%ebp)
  800b26:	ff 75 08             	pushl  0x8(%ebp)
  800b29:	e8 00 fb ff ff       	call   80062e <printnum>
  800b2e:	83 c4 20             	add    $0x20,%esp
			break;
  800b31:	eb 46                	jmp    800b79 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b33:	83 ec 08             	sub    $0x8,%esp
  800b36:	ff 75 0c             	pushl  0xc(%ebp)
  800b39:	53                   	push   %ebx
  800b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3d:	ff d0                	call   *%eax
  800b3f:	83 c4 10             	add    $0x10,%esp
			break;
  800b42:	eb 35                	jmp    800b79 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b44:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
			break;
  800b4b:	eb 2c                	jmp    800b79 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b4d:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
			break;
  800b54:	eb 23                	jmp    800b79 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b56:	83 ec 08             	sub    $0x8,%esp
  800b59:	ff 75 0c             	pushl  0xc(%ebp)
  800b5c:	6a 25                	push   $0x25
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b61:	ff d0                	call   *%eax
  800b63:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b66:	ff 4d 10             	decl   0x10(%ebp)
  800b69:	eb 03                	jmp    800b6e <vprintfmt+0x3c3>
  800b6b:	ff 4d 10             	decl   0x10(%ebp)
  800b6e:	8b 45 10             	mov    0x10(%ebp),%eax
  800b71:	48                   	dec    %eax
  800b72:	8a 00                	mov    (%eax),%al
  800b74:	3c 25                	cmp    $0x25,%al
  800b76:	75 f3                	jne    800b6b <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800b78:	90                   	nop
		}
	}
  800b79:	e9 35 fc ff ff       	jmp    8007b3 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b7e:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b7f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b82:	5b                   	pop    %ebx
  800b83:	5e                   	pop    %esi
  800b84:	5d                   	pop    %ebp
  800b85:	c3                   	ret    

00800b86 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b86:	55                   	push   %ebp
  800b87:	89 e5                	mov    %esp,%ebp
  800b89:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b8c:	8d 45 10             	lea    0x10(%ebp),%eax
  800b8f:	83 c0 04             	add    $0x4,%eax
  800b92:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b95:	8b 45 10             	mov    0x10(%ebp),%eax
  800b98:	ff 75 f4             	pushl  -0xc(%ebp)
  800b9b:	50                   	push   %eax
  800b9c:	ff 75 0c             	pushl  0xc(%ebp)
  800b9f:	ff 75 08             	pushl  0x8(%ebp)
  800ba2:	e8 04 fc ff ff       	call   8007ab <vprintfmt>
  800ba7:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800baa:	90                   	nop
  800bab:	c9                   	leave  
  800bac:	c3                   	ret    

00800bad <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bad:	55                   	push   %ebp
  800bae:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb3:	8b 40 08             	mov    0x8(%eax),%eax
  800bb6:	8d 50 01             	lea    0x1(%eax),%edx
  800bb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbc:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc2:	8b 10                	mov    (%eax),%edx
  800bc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc7:	8b 40 04             	mov    0x4(%eax),%eax
  800bca:	39 c2                	cmp    %eax,%edx
  800bcc:	73 12                	jae    800be0 <sprintputch+0x33>
		*b->buf++ = ch;
  800bce:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd1:	8b 00                	mov    (%eax),%eax
  800bd3:	8d 48 01             	lea    0x1(%eax),%ecx
  800bd6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bd9:	89 0a                	mov    %ecx,(%edx)
  800bdb:	8b 55 08             	mov    0x8(%ebp),%edx
  800bde:	88 10                	mov    %dl,(%eax)
}
  800be0:	90                   	nop
  800be1:	5d                   	pop    %ebp
  800be2:	c3                   	ret    

00800be3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800be3:	55                   	push   %ebp
  800be4:	89 e5                	mov    %esp,%ebp
  800be6:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800be9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bec:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf8:	01 d0                	add    %edx,%eax
  800bfa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bfd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c04:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c08:	74 06                	je     800c10 <vsnprintf+0x2d>
  800c0a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c0e:	7f 07                	jg     800c17 <vsnprintf+0x34>
		return -E_INVAL;
  800c10:	b8 03 00 00 00       	mov    $0x3,%eax
  800c15:	eb 20                	jmp    800c37 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c17:	ff 75 14             	pushl  0x14(%ebp)
  800c1a:	ff 75 10             	pushl  0x10(%ebp)
  800c1d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c20:	50                   	push   %eax
  800c21:	68 ad 0b 80 00       	push   $0x800bad
  800c26:	e8 80 fb ff ff       	call   8007ab <vprintfmt>
  800c2b:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c31:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c34:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c37:	c9                   	leave  
  800c38:	c3                   	ret    

00800c39 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c39:	55                   	push   %ebp
  800c3a:	89 e5                	mov    %esp,%ebp
  800c3c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c3f:	8d 45 10             	lea    0x10(%ebp),%eax
  800c42:	83 c0 04             	add    $0x4,%eax
  800c45:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c48:	8b 45 10             	mov    0x10(%ebp),%eax
  800c4b:	ff 75 f4             	pushl  -0xc(%ebp)
  800c4e:	50                   	push   %eax
  800c4f:	ff 75 0c             	pushl  0xc(%ebp)
  800c52:	ff 75 08             	pushl  0x8(%ebp)
  800c55:	e8 89 ff ff ff       	call   800be3 <vsnprintf>
  800c5a:	83 c4 10             	add    $0x10,%esp
  800c5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c60:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c63:	c9                   	leave  
  800c64:	c3                   	ret    

00800c65 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800c65:	55                   	push   %ebp
  800c66:	89 e5                	mov    %esp,%ebp
  800c68:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  800c6b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c6f:	74 13                	je     800c84 <readline+0x1f>
		cprintf("%s", prompt);
  800c71:	83 ec 08             	sub    $0x8,%esp
  800c74:	ff 75 08             	pushl  0x8(%ebp)
  800c77:	68 c8 26 80 00       	push   $0x8026c8
  800c7c:	e8 50 f9 ff ff       	call   8005d1 <cprintf>
  800c81:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800c84:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800c8b:	83 ec 0c             	sub    $0xc,%esp
  800c8e:	6a 00                	push   $0x0
  800c90:	e8 61 10 00 00       	call   801cf6 <iscons>
  800c95:	83 c4 10             	add    $0x10,%esp
  800c98:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800c9b:	e8 43 10 00 00       	call   801ce3 <getchar>
  800ca0:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800ca3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800ca7:	79 22                	jns    800ccb <readline+0x66>
			if (c != -E_EOF)
  800ca9:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800cad:	0f 84 ad 00 00 00    	je     800d60 <readline+0xfb>
				cprintf("read error: %e\n", c);
  800cb3:	83 ec 08             	sub    $0x8,%esp
  800cb6:	ff 75 ec             	pushl  -0x14(%ebp)
  800cb9:	68 cb 26 80 00       	push   $0x8026cb
  800cbe:	e8 0e f9 ff ff       	call   8005d1 <cprintf>
  800cc3:	83 c4 10             	add    $0x10,%esp
			break;
  800cc6:	e9 95 00 00 00       	jmp    800d60 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800ccb:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800ccf:	7e 34                	jle    800d05 <readline+0xa0>
  800cd1:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800cd8:	7f 2b                	jg     800d05 <readline+0xa0>
			if (echoing)
  800cda:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800cde:	74 0e                	je     800cee <readline+0x89>
				cputchar(c);
  800ce0:	83 ec 0c             	sub    $0xc,%esp
  800ce3:	ff 75 ec             	pushl  -0x14(%ebp)
  800ce6:	e8 d9 0f 00 00       	call   801cc4 <cputchar>
  800ceb:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800cee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cf1:	8d 50 01             	lea    0x1(%eax),%edx
  800cf4:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800cf7:	89 c2                	mov    %eax,%edx
  800cf9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cfc:	01 d0                	add    %edx,%eax
  800cfe:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800d01:	88 10                	mov    %dl,(%eax)
  800d03:	eb 56                	jmp    800d5b <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800d05:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800d09:	75 1f                	jne    800d2a <readline+0xc5>
  800d0b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800d0f:	7e 19                	jle    800d2a <readline+0xc5>
			if (echoing)
  800d11:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800d15:	74 0e                	je     800d25 <readline+0xc0>
				cputchar(c);
  800d17:	83 ec 0c             	sub    $0xc,%esp
  800d1a:	ff 75 ec             	pushl  -0x14(%ebp)
  800d1d:	e8 a2 0f 00 00       	call   801cc4 <cputchar>
  800d22:	83 c4 10             	add    $0x10,%esp

			i--;
  800d25:	ff 4d f4             	decl   -0xc(%ebp)
  800d28:	eb 31                	jmp    800d5b <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800d2a:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800d2e:	74 0a                	je     800d3a <readline+0xd5>
  800d30:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800d34:	0f 85 61 ff ff ff    	jne    800c9b <readline+0x36>
			if (echoing)
  800d3a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800d3e:	74 0e                	je     800d4e <readline+0xe9>
				cputchar(c);
  800d40:	83 ec 0c             	sub    $0xc,%esp
  800d43:	ff 75 ec             	pushl  -0x14(%ebp)
  800d46:	e8 79 0f 00 00       	call   801cc4 <cputchar>
  800d4b:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800d4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d54:	01 d0                	add    %edx,%eax
  800d56:	c6 00 00             	movb   $0x0,(%eax)
			break;
  800d59:	eb 06                	jmp    800d61 <readline+0xfc>
		}
	}
  800d5b:	e9 3b ff ff ff       	jmp    800c9b <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  800d60:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  800d61:	90                   	nop
  800d62:	c9                   	leave  
  800d63:	c3                   	ret    

00800d64 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800d64:	55                   	push   %ebp
  800d65:	89 e5                	mov    %esp,%ebp
  800d67:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  800d6a:	e8 71 08 00 00       	call   8015e0 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800d6f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d73:	74 13                	je     800d88 <atomic_readline+0x24>
			cprintf("%s", prompt);
  800d75:	83 ec 08             	sub    $0x8,%esp
  800d78:	ff 75 08             	pushl  0x8(%ebp)
  800d7b:	68 c8 26 80 00       	push   $0x8026c8
  800d80:	e8 4c f8 ff ff       	call   8005d1 <cprintf>
  800d85:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800d88:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800d8f:	83 ec 0c             	sub    $0xc,%esp
  800d92:	6a 00                	push   $0x0
  800d94:	e8 5d 0f 00 00       	call   801cf6 <iscons>
  800d99:	83 c4 10             	add    $0x10,%esp
  800d9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800d9f:	e8 3f 0f 00 00       	call   801ce3 <getchar>
  800da4:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  800da7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800dab:	79 22                	jns    800dcf <atomic_readline+0x6b>
				if (c != -E_EOF)
  800dad:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800db1:	0f 84 ad 00 00 00    	je     800e64 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  800db7:	83 ec 08             	sub    $0x8,%esp
  800dba:	ff 75 ec             	pushl  -0x14(%ebp)
  800dbd:	68 cb 26 80 00       	push   $0x8026cb
  800dc2:	e8 0a f8 ff ff       	call   8005d1 <cprintf>
  800dc7:	83 c4 10             	add    $0x10,%esp
				break;
  800dca:	e9 95 00 00 00       	jmp    800e64 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  800dcf:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800dd3:	7e 34                	jle    800e09 <atomic_readline+0xa5>
  800dd5:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800ddc:	7f 2b                	jg     800e09 <atomic_readline+0xa5>
				if (echoing)
  800dde:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800de2:	74 0e                	je     800df2 <atomic_readline+0x8e>
					cputchar(c);
  800de4:	83 ec 0c             	sub    $0xc,%esp
  800de7:	ff 75 ec             	pushl  -0x14(%ebp)
  800dea:	e8 d5 0e 00 00       	call   801cc4 <cputchar>
  800def:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  800df2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800df5:	8d 50 01             	lea    0x1(%eax),%edx
  800df8:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800dfb:	89 c2                	mov    %eax,%edx
  800dfd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e00:	01 d0                	add    %edx,%eax
  800e02:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800e05:	88 10                	mov    %dl,(%eax)
  800e07:	eb 56                	jmp    800e5f <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  800e09:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800e0d:	75 1f                	jne    800e2e <atomic_readline+0xca>
  800e0f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800e13:	7e 19                	jle    800e2e <atomic_readline+0xca>
				if (echoing)
  800e15:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800e19:	74 0e                	je     800e29 <atomic_readline+0xc5>
					cputchar(c);
  800e1b:	83 ec 0c             	sub    $0xc,%esp
  800e1e:	ff 75 ec             	pushl  -0x14(%ebp)
  800e21:	e8 9e 0e 00 00       	call   801cc4 <cputchar>
  800e26:	83 c4 10             	add    $0x10,%esp
				i--;
  800e29:	ff 4d f4             	decl   -0xc(%ebp)
  800e2c:	eb 31                	jmp    800e5f <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  800e2e:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800e32:	74 0a                	je     800e3e <atomic_readline+0xda>
  800e34:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800e38:	0f 85 61 ff ff ff    	jne    800d9f <atomic_readline+0x3b>
				if (echoing)
  800e3e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800e42:	74 0e                	je     800e52 <atomic_readline+0xee>
					cputchar(c);
  800e44:	83 ec 0c             	sub    $0xc,%esp
  800e47:	ff 75 ec             	pushl  -0x14(%ebp)
  800e4a:	e8 75 0e 00 00       	call   801cc4 <cputchar>
  800e4f:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  800e52:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e58:	01 d0                	add    %edx,%eax
  800e5a:	c6 00 00             	movb   $0x0,(%eax)
				break;
  800e5d:	eb 06                	jmp    800e65 <atomic_readline+0x101>
			}
		}
  800e5f:	e9 3b ff ff ff       	jmp    800d9f <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  800e64:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  800e65:	e8 90 07 00 00       	call   8015fa <sys_unlock_cons>
}
  800e6a:	90                   	nop
  800e6b:	c9                   	leave  
  800e6c:	c3                   	ret    

00800e6d <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800e6d:	55                   	push   %ebp
  800e6e:	89 e5                	mov    %esp,%ebp
  800e70:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e73:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e7a:	eb 06                	jmp    800e82 <strlen+0x15>
		n++;
  800e7c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e7f:	ff 45 08             	incl   0x8(%ebp)
  800e82:	8b 45 08             	mov    0x8(%ebp),%eax
  800e85:	8a 00                	mov    (%eax),%al
  800e87:	84 c0                	test   %al,%al
  800e89:	75 f1                	jne    800e7c <strlen+0xf>
		n++;
	return n;
  800e8b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e8e:	c9                   	leave  
  800e8f:	c3                   	ret    

00800e90 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e90:	55                   	push   %ebp
  800e91:	89 e5                	mov    %esp,%ebp
  800e93:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e96:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e9d:	eb 09                	jmp    800ea8 <strnlen+0x18>
		n++;
  800e9f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ea2:	ff 45 08             	incl   0x8(%ebp)
  800ea5:	ff 4d 0c             	decl   0xc(%ebp)
  800ea8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800eac:	74 09                	je     800eb7 <strnlen+0x27>
  800eae:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb1:	8a 00                	mov    (%eax),%al
  800eb3:	84 c0                	test   %al,%al
  800eb5:	75 e8                	jne    800e9f <strnlen+0xf>
		n++;
	return n;
  800eb7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800eba:	c9                   	leave  
  800ebb:	c3                   	ret    

00800ebc <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ebc:	55                   	push   %ebp
  800ebd:	89 e5                	mov    %esp,%ebp
  800ebf:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800ec8:	90                   	nop
  800ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecc:	8d 50 01             	lea    0x1(%eax),%edx
  800ecf:	89 55 08             	mov    %edx,0x8(%ebp)
  800ed2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ed5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ed8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800edb:	8a 12                	mov    (%edx),%dl
  800edd:	88 10                	mov    %dl,(%eax)
  800edf:	8a 00                	mov    (%eax),%al
  800ee1:	84 c0                	test   %al,%al
  800ee3:	75 e4                	jne    800ec9 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ee5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ee8:	c9                   	leave  
  800ee9:	c3                   	ret    

00800eea <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800eea:	55                   	push   %ebp
  800eeb:	89 e5                	mov    %esp,%ebp
  800eed:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ef6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800efd:	eb 1f                	jmp    800f1e <strncpy+0x34>
		*dst++ = *src;
  800eff:	8b 45 08             	mov    0x8(%ebp),%eax
  800f02:	8d 50 01             	lea    0x1(%eax),%edx
  800f05:	89 55 08             	mov    %edx,0x8(%ebp)
  800f08:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f0b:	8a 12                	mov    (%edx),%dl
  800f0d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f12:	8a 00                	mov    (%eax),%al
  800f14:	84 c0                	test   %al,%al
  800f16:	74 03                	je     800f1b <strncpy+0x31>
			src++;
  800f18:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f1b:	ff 45 fc             	incl   -0x4(%ebp)
  800f1e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f21:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f24:	72 d9                	jb     800eff <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f26:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f29:	c9                   	leave  
  800f2a:	c3                   	ret    

00800f2b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f2b:	55                   	push   %ebp
  800f2c:	89 e5                	mov    %esp,%ebp
  800f2e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f31:	8b 45 08             	mov    0x8(%ebp),%eax
  800f34:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f37:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f3b:	74 30                	je     800f6d <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f3d:	eb 16                	jmp    800f55 <strlcpy+0x2a>
			*dst++ = *src++;
  800f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f42:	8d 50 01             	lea    0x1(%eax),%edx
  800f45:	89 55 08             	mov    %edx,0x8(%ebp)
  800f48:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f4b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f4e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f51:	8a 12                	mov    (%edx),%dl
  800f53:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f55:	ff 4d 10             	decl   0x10(%ebp)
  800f58:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f5c:	74 09                	je     800f67 <strlcpy+0x3c>
  800f5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f61:	8a 00                	mov    (%eax),%al
  800f63:	84 c0                	test   %al,%al
  800f65:	75 d8                	jne    800f3f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f67:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f6d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f70:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f73:	29 c2                	sub    %eax,%edx
  800f75:	89 d0                	mov    %edx,%eax
}
  800f77:	c9                   	leave  
  800f78:	c3                   	ret    

00800f79 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f79:	55                   	push   %ebp
  800f7a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f7c:	eb 06                	jmp    800f84 <strcmp+0xb>
		p++, q++;
  800f7e:	ff 45 08             	incl   0x8(%ebp)
  800f81:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f84:	8b 45 08             	mov    0x8(%ebp),%eax
  800f87:	8a 00                	mov    (%eax),%al
  800f89:	84 c0                	test   %al,%al
  800f8b:	74 0e                	je     800f9b <strcmp+0x22>
  800f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f90:	8a 10                	mov    (%eax),%dl
  800f92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f95:	8a 00                	mov    (%eax),%al
  800f97:	38 c2                	cmp    %al,%dl
  800f99:	74 e3                	je     800f7e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9e:	8a 00                	mov    (%eax),%al
  800fa0:	0f b6 d0             	movzbl %al,%edx
  800fa3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa6:	8a 00                	mov    (%eax),%al
  800fa8:	0f b6 c0             	movzbl %al,%eax
  800fab:	29 c2                	sub    %eax,%edx
  800fad:	89 d0                	mov    %edx,%eax
}
  800faf:	5d                   	pop    %ebp
  800fb0:	c3                   	ret    

00800fb1 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800fb1:	55                   	push   %ebp
  800fb2:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800fb4:	eb 09                	jmp    800fbf <strncmp+0xe>
		n--, p++, q++;
  800fb6:	ff 4d 10             	decl   0x10(%ebp)
  800fb9:	ff 45 08             	incl   0x8(%ebp)
  800fbc:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800fbf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fc3:	74 17                	je     800fdc <strncmp+0x2b>
  800fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc8:	8a 00                	mov    (%eax),%al
  800fca:	84 c0                	test   %al,%al
  800fcc:	74 0e                	je     800fdc <strncmp+0x2b>
  800fce:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd1:	8a 10                	mov    (%eax),%dl
  800fd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd6:	8a 00                	mov    (%eax),%al
  800fd8:	38 c2                	cmp    %al,%dl
  800fda:	74 da                	je     800fb6 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800fdc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fe0:	75 07                	jne    800fe9 <strncmp+0x38>
		return 0;
  800fe2:	b8 00 00 00 00       	mov    $0x0,%eax
  800fe7:	eb 14                	jmp    800ffd <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fec:	8a 00                	mov    (%eax),%al
  800fee:	0f b6 d0             	movzbl %al,%edx
  800ff1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff4:	8a 00                	mov    (%eax),%al
  800ff6:	0f b6 c0             	movzbl %al,%eax
  800ff9:	29 c2                	sub    %eax,%edx
  800ffb:	89 d0                	mov    %edx,%eax
}
  800ffd:	5d                   	pop    %ebp
  800ffe:	c3                   	ret    

00800fff <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fff:	55                   	push   %ebp
  801000:	89 e5                	mov    %esp,%ebp
  801002:	83 ec 04             	sub    $0x4,%esp
  801005:	8b 45 0c             	mov    0xc(%ebp),%eax
  801008:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80100b:	eb 12                	jmp    80101f <strchr+0x20>
		if (*s == c)
  80100d:	8b 45 08             	mov    0x8(%ebp),%eax
  801010:	8a 00                	mov    (%eax),%al
  801012:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801015:	75 05                	jne    80101c <strchr+0x1d>
			return (char *) s;
  801017:	8b 45 08             	mov    0x8(%ebp),%eax
  80101a:	eb 11                	jmp    80102d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80101c:	ff 45 08             	incl   0x8(%ebp)
  80101f:	8b 45 08             	mov    0x8(%ebp),%eax
  801022:	8a 00                	mov    (%eax),%al
  801024:	84 c0                	test   %al,%al
  801026:	75 e5                	jne    80100d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801028:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80102d:	c9                   	leave  
  80102e:	c3                   	ret    

0080102f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80102f:	55                   	push   %ebp
  801030:	89 e5                	mov    %esp,%ebp
  801032:	83 ec 04             	sub    $0x4,%esp
  801035:	8b 45 0c             	mov    0xc(%ebp),%eax
  801038:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80103b:	eb 0d                	jmp    80104a <strfind+0x1b>
		if (*s == c)
  80103d:	8b 45 08             	mov    0x8(%ebp),%eax
  801040:	8a 00                	mov    (%eax),%al
  801042:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801045:	74 0e                	je     801055 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801047:	ff 45 08             	incl   0x8(%ebp)
  80104a:	8b 45 08             	mov    0x8(%ebp),%eax
  80104d:	8a 00                	mov    (%eax),%al
  80104f:	84 c0                	test   %al,%al
  801051:	75 ea                	jne    80103d <strfind+0xe>
  801053:	eb 01                	jmp    801056 <strfind+0x27>
		if (*s == c)
			break;
  801055:	90                   	nop
	return (char *) s;
  801056:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801059:	c9                   	leave  
  80105a:	c3                   	ret    

0080105b <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80105b:	55                   	push   %ebp
  80105c:	89 e5                	mov    %esp,%ebp
  80105e:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
  801064:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801067:	8b 45 10             	mov    0x10(%ebp),%eax
  80106a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80106d:	eb 0e                	jmp    80107d <memset+0x22>
		*p++ = c;
  80106f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801072:	8d 50 01             	lea    0x1(%eax),%edx
  801075:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801078:	8b 55 0c             	mov    0xc(%ebp),%edx
  80107b:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80107d:	ff 4d f8             	decl   -0x8(%ebp)
  801080:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801084:	79 e9                	jns    80106f <memset+0x14>
		*p++ = c;

	return v;
  801086:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801089:	c9                   	leave  
  80108a:	c3                   	ret    

0080108b <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80108b:	55                   	push   %ebp
  80108c:	89 e5                	mov    %esp,%ebp
  80108e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801091:	8b 45 0c             	mov    0xc(%ebp),%eax
  801094:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801097:	8b 45 08             	mov    0x8(%ebp),%eax
  80109a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80109d:	eb 16                	jmp    8010b5 <memcpy+0x2a>
		*d++ = *s++;
  80109f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a2:	8d 50 01             	lea    0x1(%eax),%edx
  8010a5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010a8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010ab:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010ae:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010b1:	8a 12                	mov    (%edx),%dl
  8010b3:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8010b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010bb:	89 55 10             	mov    %edx,0x10(%ebp)
  8010be:	85 c0                	test   %eax,%eax
  8010c0:	75 dd                	jne    80109f <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8010c2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010c5:	c9                   	leave  
  8010c6:	c3                   	ret    

008010c7 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8010c7:	55                   	push   %ebp
  8010c8:	89 e5                	mov    %esp,%ebp
  8010ca:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8010d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010dc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010df:	73 50                	jae    801131 <memmove+0x6a>
  8010e1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e7:	01 d0                	add    %edx,%eax
  8010e9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010ec:	76 43                	jbe    801131 <memmove+0x6a>
		s += n;
  8010ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f1:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8010f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f7:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010fa:	eb 10                	jmp    80110c <memmove+0x45>
			*--d = *--s;
  8010fc:	ff 4d f8             	decl   -0x8(%ebp)
  8010ff:	ff 4d fc             	decl   -0x4(%ebp)
  801102:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801105:	8a 10                	mov    (%eax),%dl
  801107:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80110a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80110c:	8b 45 10             	mov    0x10(%ebp),%eax
  80110f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801112:	89 55 10             	mov    %edx,0x10(%ebp)
  801115:	85 c0                	test   %eax,%eax
  801117:	75 e3                	jne    8010fc <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801119:	eb 23                	jmp    80113e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80111b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80111e:	8d 50 01             	lea    0x1(%eax),%edx
  801121:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801124:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801127:	8d 4a 01             	lea    0x1(%edx),%ecx
  80112a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80112d:	8a 12                	mov    (%edx),%dl
  80112f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801131:	8b 45 10             	mov    0x10(%ebp),%eax
  801134:	8d 50 ff             	lea    -0x1(%eax),%edx
  801137:	89 55 10             	mov    %edx,0x10(%ebp)
  80113a:	85 c0                	test   %eax,%eax
  80113c:	75 dd                	jne    80111b <memmove+0x54>
			*d++ = *s++;

	return dst;
  80113e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801141:	c9                   	leave  
  801142:	c3                   	ret    

00801143 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801143:	55                   	push   %ebp
  801144:	89 e5                	mov    %esp,%ebp
  801146:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801149:	8b 45 08             	mov    0x8(%ebp),%eax
  80114c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80114f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801152:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801155:	eb 2a                	jmp    801181 <memcmp+0x3e>
		if (*s1 != *s2)
  801157:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80115a:	8a 10                	mov    (%eax),%dl
  80115c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80115f:	8a 00                	mov    (%eax),%al
  801161:	38 c2                	cmp    %al,%dl
  801163:	74 16                	je     80117b <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801165:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801168:	8a 00                	mov    (%eax),%al
  80116a:	0f b6 d0             	movzbl %al,%edx
  80116d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801170:	8a 00                	mov    (%eax),%al
  801172:	0f b6 c0             	movzbl %al,%eax
  801175:	29 c2                	sub    %eax,%edx
  801177:	89 d0                	mov    %edx,%eax
  801179:	eb 18                	jmp    801193 <memcmp+0x50>
		s1++, s2++;
  80117b:	ff 45 fc             	incl   -0x4(%ebp)
  80117e:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801181:	8b 45 10             	mov    0x10(%ebp),%eax
  801184:	8d 50 ff             	lea    -0x1(%eax),%edx
  801187:	89 55 10             	mov    %edx,0x10(%ebp)
  80118a:	85 c0                	test   %eax,%eax
  80118c:	75 c9                	jne    801157 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80118e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801193:	c9                   	leave  
  801194:	c3                   	ret    

00801195 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801195:	55                   	push   %ebp
  801196:	89 e5                	mov    %esp,%ebp
  801198:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80119b:	8b 55 08             	mov    0x8(%ebp),%edx
  80119e:	8b 45 10             	mov    0x10(%ebp),%eax
  8011a1:	01 d0                	add    %edx,%eax
  8011a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8011a6:	eb 15                	jmp    8011bd <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8011a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ab:	8a 00                	mov    (%eax),%al
  8011ad:	0f b6 d0             	movzbl %al,%edx
  8011b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b3:	0f b6 c0             	movzbl %al,%eax
  8011b6:	39 c2                	cmp    %eax,%edx
  8011b8:	74 0d                	je     8011c7 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8011ba:	ff 45 08             	incl   0x8(%ebp)
  8011bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011c3:	72 e3                	jb     8011a8 <memfind+0x13>
  8011c5:	eb 01                	jmp    8011c8 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8011c7:	90                   	nop
	return (void *) s;
  8011c8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011cb:	c9                   	leave  
  8011cc:	c3                   	ret    

008011cd <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8011cd:	55                   	push   %ebp
  8011ce:	89 e5                	mov    %esp,%ebp
  8011d0:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8011d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8011da:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011e1:	eb 03                	jmp    8011e6 <strtol+0x19>
		s++;
  8011e3:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e9:	8a 00                	mov    (%eax),%al
  8011eb:	3c 20                	cmp    $0x20,%al
  8011ed:	74 f4                	je     8011e3 <strtol+0x16>
  8011ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f2:	8a 00                	mov    (%eax),%al
  8011f4:	3c 09                	cmp    $0x9,%al
  8011f6:	74 eb                	je     8011e3 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8011f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fb:	8a 00                	mov    (%eax),%al
  8011fd:	3c 2b                	cmp    $0x2b,%al
  8011ff:	75 05                	jne    801206 <strtol+0x39>
		s++;
  801201:	ff 45 08             	incl   0x8(%ebp)
  801204:	eb 13                	jmp    801219 <strtol+0x4c>
	else if (*s == '-')
  801206:	8b 45 08             	mov    0x8(%ebp),%eax
  801209:	8a 00                	mov    (%eax),%al
  80120b:	3c 2d                	cmp    $0x2d,%al
  80120d:	75 0a                	jne    801219 <strtol+0x4c>
		s++, neg = 1;
  80120f:	ff 45 08             	incl   0x8(%ebp)
  801212:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801219:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80121d:	74 06                	je     801225 <strtol+0x58>
  80121f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801223:	75 20                	jne    801245 <strtol+0x78>
  801225:	8b 45 08             	mov    0x8(%ebp),%eax
  801228:	8a 00                	mov    (%eax),%al
  80122a:	3c 30                	cmp    $0x30,%al
  80122c:	75 17                	jne    801245 <strtol+0x78>
  80122e:	8b 45 08             	mov    0x8(%ebp),%eax
  801231:	40                   	inc    %eax
  801232:	8a 00                	mov    (%eax),%al
  801234:	3c 78                	cmp    $0x78,%al
  801236:	75 0d                	jne    801245 <strtol+0x78>
		s += 2, base = 16;
  801238:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80123c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801243:	eb 28                	jmp    80126d <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801245:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801249:	75 15                	jne    801260 <strtol+0x93>
  80124b:	8b 45 08             	mov    0x8(%ebp),%eax
  80124e:	8a 00                	mov    (%eax),%al
  801250:	3c 30                	cmp    $0x30,%al
  801252:	75 0c                	jne    801260 <strtol+0x93>
		s++, base = 8;
  801254:	ff 45 08             	incl   0x8(%ebp)
  801257:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80125e:	eb 0d                	jmp    80126d <strtol+0xa0>
	else if (base == 0)
  801260:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801264:	75 07                	jne    80126d <strtol+0xa0>
		base = 10;
  801266:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80126d:	8b 45 08             	mov    0x8(%ebp),%eax
  801270:	8a 00                	mov    (%eax),%al
  801272:	3c 2f                	cmp    $0x2f,%al
  801274:	7e 19                	jle    80128f <strtol+0xc2>
  801276:	8b 45 08             	mov    0x8(%ebp),%eax
  801279:	8a 00                	mov    (%eax),%al
  80127b:	3c 39                	cmp    $0x39,%al
  80127d:	7f 10                	jg     80128f <strtol+0xc2>
			dig = *s - '0';
  80127f:	8b 45 08             	mov    0x8(%ebp),%eax
  801282:	8a 00                	mov    (%eax),%al
  801284:	0f be c0             	movsbl %al,%eax
  801287:	83 e8 30             	sub    $0x30,%eax
  80128a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80128d:	eb 42                	jmp    8012d1 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80128f:	8b 45 08             	mov    0x8(%ebp),%eax
  801292:	8a 00                	mov    (%eax),%al
  801294:	3c 60                	cmp    $0x60,%al
  801296:	7e 19                	jle    8012b1 <strtol+0xe4>
  801298:	8b 45 08             	mov    0x8(%ebp),%eax
  80129b:	8a 00                	mov    (%eax),%al
  80129d:	3c 7a                	cmp    $0x7a,%al
  80129f:	7f 10                	jg     8012b1 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8012a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a4:	8a 00                	mov    (%eax),%al
  8012a6:	0f be c0             	movsbl %al,%eax
  8012a9:	83 e8 57             	sub    $0x57,%eax
  8012ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012af:	eb 20                	jmp    8012d1 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8012b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b4:	8a 00                	mov    (%eax),%al
  8012b6:	3c 40                	cmp    $0x40,%al
  8012b8:	7e 39                	jle    8012f3 <strtol+0x126>
  8012ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bd:	8a 00                	mov    (%eax),%al
  8012bf:	3c 5a                	cmp    $0x5a,%al
  8012c1:	7f 30                	jg     8012f3 <strtol+0x126>
			dig = *s - 'A' + 10;
  8012c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c6:	8a 00                	mov    (%eax),%al
  8012c8:	0f be c0             	movsbl %al,%eax
  8012cb:	83 e8 37             	sub    $0x37,%eax
  8012ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8012d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012d4:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012d7:	7d 19                	jge    8012f2 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8012d9:	ff 45 08             	incl   0x8(%ebp)
  8012dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012df:	0f af 45 10          	imul   0x10(%ebp),%eax
  8012e3:	89 c2                	mov    %eax,%edx
  8012e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012e8:	01 d0                	add    %edx,%eax
  8012ea:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8012ed:	e9 7b ff ff ff       	jmp    80126d <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8012f2:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8012f3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012f7:	74 08                	je     801301 <strtol+0x134>
		*endptr = (char *) s;
  8012f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8012ff:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801301:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801305:	74 07                	je     80130e <strtol+0x141>
  801307:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80130a:	f7 d8                	neg    %eax
  80130c:	eb 03                	jmp    801311 <strtol+0x144>
  80130e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801311:	c9                   	leave  
  801312:	c3                   	ret    

00801313 <ltostr>:

void
ltostr(long value, char *str)
{
  801313:	55                   	push   %ebp
  801314:	89 e5                	mov    %esp,%ebp
  801316:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801319:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801320:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801327:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80132b:	79 13                	jns    801340 <ltostr+0x2d>
	{
		neg = 1;
  80132d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801334:	8b 45 0c             	mov    0xc(%ebp),%eax
  801337:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80133a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80133d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801340:	8b 45 08             	mov    0x8(%ebp),%eax
  801343:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801348:	99                   	cltd   
  801349:	f7 f9                	idiv   %ecx
  80134b:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80134e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801351:	8d 50 01             	lea    0x1(%eax),%edx
  801354:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801357:	89 c2                	mov    %eax,%edx
  801359:	8b 45 0c             	mov    0xc(%ebp),%eax
  80135c:	01 d0                	add    %edx,%eax
  80135e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801361:	83 c2 30             	add    $0x30,%edx
  801364:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801366:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801369:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80136e:	f7 e9                	imul   %ecx
  801370:	c1 fa 02             	sar    $0x2,%edx
  801373:	89 c8                	mov    %ecx,%eax
  801375:	c1 f8 1f             	sar    $0x1f,%eax
  801378:	29 c2                	sub    %eax,%edx
  80137a:	89 d0                	mov    %edx,%eax
  80137c:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80137f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801383:	75 bb                	jne    801340 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801385:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80138c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80138f:	48                   	dec    %eax
  801390:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801393:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801397:	74 3d                	je     8013d6 <ltostr+0xc3>
		start = 1 ;
  801399:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013a0:	eb 34                	jmp    8013d6 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8013a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a8:	01 d0                	add    %edx,%eax
  8013aa:	8a 00                	mov    (%eax),%al
  8013ac:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8013af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b5:	01 c2                	add    %eax,%edx
  8013b7:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8013ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013bd:	01 c8                	add    %ecx,%eax
  8013bf:	8a 00                	mov    (%eax),%al
  8013c1:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8013c3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c9:	01 c2                	add    %eax,%edx
  8013cb:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013ce:	88 02                	mov    %al,(%edx)
		start++ ;
  8013d0:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013d3:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013d9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013dc:	7c c4                	jl     8013a2 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8013de:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8013e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e4:	01 d0                	add    %edx,%eax
  8013e6:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013e9:	90                   	nop
  8013ea:	c9                   	leave  
  8013eb:	c3                   	ret    

008013ec <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013ec:	55                   	push   %ebp
  8013ed:	89 e5                	mov    %esp,%ebp
  8013ef:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013f2:	ff 75 08             	pushl  0x8(%ebp)
  8013f5:	e8 73 fa ff ff       	call   800e6d <strlen>
  8013fa:	83 c4 04             	add    $0x4,%esp
  8013fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801400:	ff 75 0c             	pushl  0xc(%ebp)
  801403:	e8 65 fa ff ff       	call   800e6d <strlen>
  801408:	83 c4 04             	add    $0x4,%esp
  80140b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80140e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801415:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80141c:	eb 17                	jmp    801435 <strcconcat+0x49>
		final[s] = str1[s] ;
  80141e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801421:	8b 45 10             	mov    0x10(%ebp),%eax
  801424:	01 c2                	add    %eax,%edx
  801426:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801429:	8b 45 08             	mov    0x8(%ebp),%eax
  80142c:	01 c8                	add    %ecx,%eax
  80142e:	8a 00                	mov    (%eax),%al
  801430:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801432:	ff 45 fc             	incl   -0x4(%ebp)
  801435:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801438:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80143b:	7c e1                	jl     80141e <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80143d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801444:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80144b:	eb 1f                	jmp    80146c <strcconcat+0x80>
		final[s++] = str2[i] ;
  80144d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801450:	8d 50 01             	lea    0x1(%eax),%edx
  801453:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801456:	89 c2                	mov    %eax,%edx
  801458:	8b 45 10             	mov    0x10(%ebp),%eax
  80145b:	01 c2                	add    %eax,%edx
  80145d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801460:	8b 45 0c             	mov    0xc(%ebp),%eax
  801463:	01 c8                	add    %ecx,%eax
  801465:	8a 00                	mov    (%eax),%al
  801467:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801469:	ff 45 f8             	incl   -0x8(%ebp)
  80146c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80146f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801472:	7c d9                	jl     80144d <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801474:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801477:	8b 45 10             	mov    0x10(%ebp),%eax
  80147a:	01 d0                	add    %edx,%eax
  80147c:	c6 00 00             	movb   $0x0,(%eax)
}
  80147f:	90                   	nop
  801480:	c9                   	leave  
  801481:	c3                   	ret    

00801482 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801482:	55                   	push   %ebp
  801483:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801485:	8b 45 14             	mov    0x14(%ebp),%eax
  801488:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80148e:	8b 45 14             	mov    0x14(%ebp),%eax
  801491:	8b 00                	mov    (%eax),%eax
  801493:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80149a:	8b 45 10             	mov    0x10(%ebp),%eax
  80149d:	01 d0                	add    %edx,%eax
  80149f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014a5:	eb 0c                	jmp    8014b3 <strsplit+0x31>
			*string++ = 0;
  8014a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014aa:	8d 50 01             	lea    0x1(%eax),%edx
  8014ad:	89 55 08             	mov    %edx,0x8(%ebp)
  8014b0:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b6:	8a 00                	mov    (%eax),%al
  8014b8:	84 c0                	test   %al,%al
  8014ba:	74 18                	je     8014d4 <strsplit+0x52>
  8014bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bf:	8a 00                	mov    (%eax),%al
  8014c1:	0f be c0             	movsbl %al,%eax
  8014c4:	50                   	push   %eax
  8014c5:	ff 75 0c             	pushl  0xc(%ebp)
  8014c8:	e8 32 fb ff ff       	call   800fff <strchr>
  8014cd:	83 c4 08             	add    $0x8,%esp
  8014d0:	85 c0                	test   %eax,%eax
  8014d2:	75 d3                	jne    8014a7 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d7:	8a 00                	mov    (%eax),%al
  8014d9:	84 c0                	test   %al,%al
  8014db:	74 5a                	je     801537 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8014dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8014e0:	8b 00                	mov    (%eax),%eax
  8014e2:	83 f8 0f             	cmp    $0xf,%eax
  8014e5:	75 07                	jne    8014ee <strsplit+0x6c>
		{
			return 0;
  8014e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ec:	eb 66                	jmp    801554 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8014f1:	8b 00                	mov    (%eax),%eax
  8014f3:	8d 48 01             	lea    0x1(%eax),%ecx
  8014f6:	8b 55 14             	mov    0x14(%ebp),%edx
  8014f9:	89 0a                	mov    %ecx,(%edx)
  8014fb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801502:	8b 45 10             	mov    0x10(%ebp),%eax
  801505:	01 c2                	add    %eax,%edx
  801507:	8b 45 08             	mov    0x8(%ebp),%eax
  80150a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80150c:	eb 03                	jmp    801511 <strsplit+0x8f>
			string++;
  80150e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801511:	8b 45 08             	mov    0x8(%ebp),%eax
  801514:	8a 00                	mov    (%eax),%al
  801516:	84 c0                	test   %al,%al
  801518:	74 8b                	je     8014a5 <strsplit+0x23>
  80151a:	8b 45 08             	mov    0x8(%ebp),%eax
  80151d:	8a 00                	mov    (%eax),%al
  80151f:	0f be c0             	movsbl %al,%eax
  801522:	50                   	push   %eax
  801523:	ff 75 0c             	pushl  0xc(%ebp)
  801526:	e8 d4 fa ff ff       	call   800fff <strchr>
  80152b:	83 c4 08             	add    $0x8,%esp
  80152e:	85 c0                	test   %eax,%eax
  801530:	74 dc                	je     80150e <strsplit+0x8c>
			string++;
	}
  801532:	e9 6e ff ff ff       	jmp    8014a5 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801537:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801538:	8b 45 14             	mov    0x14(%ebp),%eax
  80153b:	8b 00                	mov    (%eax),%eax
  80153d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801544:	8b 45 10             	mov    0x10(%ebp),%eax
  801547:	01 d0                	add    %edx,%eax
  801549:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80154f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801554:	c9                   	leave  
  801555:	c3                   	ret    

00801556 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801556:	55                   	push   %ebp
  801557:	89 e5                	mov    %esp,%ebp
  801559:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  80155c:	83 ec 04             	sub    $0x4,%esp
  80155f:	68 dc 26 80 00       	push   $0x8026dc
  801564:	68 3f 01 00 00       	push   $0x13f
  801569:	68 fe 26 80 00       	push   $0x8026fe
  80156e:	e8 a1 ed ff ff       	call   800314 <_panic>

00801573 <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  801573:	55                   	push   %ebp
  801574:	89 e5                	mov    %esp,%ebp
  801576:	57                   	push   %edi
  801577:	56                   	push   %esi
  801578:	53                   	push   %ebx
  801579:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80157c:	8b 45 08             	mov    0x8(%ebp),%eax
  80157f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801582:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801585:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801588:	8b 7d 18             	mov    0x18(%ebp),%edi
  80158b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80158e:	cd 30                	int    $0x30
  801590:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  801593:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801596:	83 c4 10             	add    $0x10,%esp
  801599:	5b                   	pop    %ebx
  80159a:	5e                   	pop    %esi
  80159b:	5f                   	pop    %edi
  80159c:	5d                   	pop    %ebp
  80159d:	c3                   	ret    

0080159e <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  80159e:	55                   	push   %ebp
  80159f:	89 e5                	mov    %esp,%ebp
  8015a1:	83 ec 04             	sub    $0x4,%esp
  8015a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  8015aa:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b1:	6a 00                	push   $0x0
  8015b3:	6a 00                	push   $0x0
  8015b5:	52                   	push   %edx
  8015b6:	ff 75 0c             	pushl  0xc(%ebp)
  8015b9:	50                   	push   %eax
  8015ba:	6a 00                	push   $0x0
  8015bc:	e8 b2 ff ff ff       	call   801573 <syscall>
  8015c1:	83 c4 18             	add    $0x18,%esp
}
  8015c4:	90                   	nop
  8015c5:	c9                   	leave  
  8015c6:	c3                   	ret    

008015c7 <sys_cgetc>:

int sys_cgetc(void) {
  8015c7:	55                   	push   %ebp
  8015c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8015ca:	6a 00                	push   $0x0
  8015cc:	6a 00                	push   $0x0
  8015ce:	6a 00                	push   $0x0
  8015d0:	6a 00                	push   $0x0
  8015d2:	6a 00                	push   $0x0
  8015d4:	6a 02                	push   $0x2
  8015d6:	e8 98 ff ff ff       	call   801573 <syscall>
  8015db:	83 c4 18             	add    $0x18,%esp
}
  8015de:	c9                   	leave  
  8015df:	c3                   	ret    

008015e0 <sys_lock_cons>:

void sys_lock_cons(void) {
  8015e0:	55                   	push   %ebp
  8015e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8015e3:	6a 00                	push   $0x0
  8015e5:	6a 00                	push   $0x0
  8015e7:	6a 00                	push   $0x0
  8015e9:	6a 00                	push   $0x0
  8015eb:	6a 00                	push   $0x0
  8015ed:	6a 03                	push   $0x3
  8015ef:	e8 7f ff ff ff       	call   801573 <syscall>
  8015f4:	83 c4 18             	add    $0x18,%esp
}
  8015f7:	90                   	nop
  8015f8:	c9                   	leave  
  8015f9:	c3                   	ret    

008015fa <sys_unlock_cons>:
void sys_unlock_cons(void) {
  8015fa:	55                   	push   %ebp
  8015fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8015fd:	6a 00                	push   $0x0
  8015ff:	6a 00                	push   $0x0
  801601:	6a 00                	push   $0x0
  801603:	6a 00                	push   $0x0
  801605:	6a 00                	push   $0x0
  801607:	6a 04                	push   $0x4
  801609:	e8 65 ff ff ff       	call   801573 <syscall>
  80160e:	83 c4 18             	add    $0x18,%esp
}
  801611:	90                   	nop
  801612:	c9                   	leave  
  801613:	c3                   	ret    

00801614 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  801614:	55                   	push   %ebp
  801615:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  801617:	8b 55 0c             	mov    0xc(%ebp),%edx
  80161a:	8b 45 08             	mov    0x8(%ebp),%eax
  80161d:	6a 00                	push   $0x0
  80161f:	6a 00                	push   $0x0
  801621:	6a 00                	push   $0x0
  801623:	52                   	push   %edx
  801624:	50                   	push   %eax
  801625:	6a 08                	push   $0x8
  801627:	e8 47 ff ff ff       	call   801573 <syscall>
  80162c:	83 c4 18             	add    $0x18,%esp
}
  80162f:	c9                   	leave  
  801630:	c3                   	ret    

00801631 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  801631:	55                   	push   %ebp
  801632:	89 e5                	mov    %esp,%ebp
  801634:	56                   	push   %esi
  801635:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  801636:	8b 75 18             	mov    0x18(%ebp),%esi
  801639:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80163c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80163f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801642:	8b 45 08             	mov    0x8(%ebp),%eax
  801645:	56                   	push   %esi
  801646:	53                   	push   %ebx
  801647:	51                   	push   %ecx
  801648:	52                   	push   %edx
  801649:	50                   	push   %eax
  80164a:	6a 09                	push   $0x9
  80164c:	e8 22 ff ff ff       	call   801573 <syscall>
  801651:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  801654:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801657:	5b                   	pop    %ebx
  801658:	5e                   	pop    %esi
  801659:	5d                   	pop    %ebp
  80165a:	c3                   	ret    

0080165b <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  80165b:	55                   	push   %ebp
  80165c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80165e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801661:	8b 45 08             	mov    0x8(%ebp),%eax
  801664:	6a 00                	push   $0x0
  801666:	6a 00                	push   $0x0
  801668:	6a 00                	push   $0x0
  80166a:	52                   	push   %edx
  80166b:	50                   	push   %eax
  80166c:	6a 0a                	push   $0xa
  80166e:	e8 00 ff ff ff       	call   801573 <syscall>
  801673:	83 c4 18             	add    $0x18,%esp
}
  801676:	c9                   	leave  
  801677:	c3                   	ret    

00801678 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  801678:	55                   	push   %ebp
  801679:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  80167b:	6a 00                	push   $0x0
  80167d:	6a 00                	push   $0x0
  80167f:	6a 00                	push   $0x0
  801681:	ff 75 0c             	pushl  0xc(%ebp)
  801684:	ff 75 08             	pushl  0x8(%ebp)
  801687:	6a 0b                	push   $0xb
  801689:	e8 e5 fe ff ff       	call   801573 <syscall>
  80168e:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  801691:	c9                   	leave  
  801692:	c3                   	ret    

00801693 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  801693:	55                   	push   %ebp
  801694:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801696:	6a 00                	push   $0x0
  801698:	6a 00                	push   $0x0
  80169a:	6a 00                	push   $0x0
  80169c:	6a 00                	push   $0x0
  80169e:	6a 00                	push   $0x0
  8016a0:	6a 0c                	push   $0xc
  8016a2:	e8 cc fe ff ff       	call   801573 <syscall>
  8016a7:	83 c4 18             	add    $0x18,%esp
}
  8016aa:	c9                   	leave  
  8016ab:	c3                   	ret    

008016ac <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  8016ac:	55                   	push   %ebp
  8016ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8016af:	6a 00                	push   $0x0
  8016b1:	6a 00                	push   $0x0
  8016b3:	6a 00                	push   $0x0
  8016b5:	6a 00                	push   $0x0
  8016b7:	6a 00                	push   $0x0
  8016b9:	6a 0d                	push   $0xd
  8016bb:	e8 b3 fe ff ff       	call   801573 <syscall>
  8016c0:	83 c4 18             	add    $0x18,%esp
}
  8016c3:	c9                   	leave  
  8016c4:	c3                   	ret    

008016c5 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  8016c5:	55                   	push   %ebp
  8016c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8016c8:	6a 00                	push   $0x0
  8016ca:	6a 00                	push   $0x0
  8016cc:	6a 00                	push   $0x0
  8016ce:	6a 00                	push   $0x0
  8016d0:	6a 00                	push   $0x0
  8016d2:	6a 0e                	push   $0xe
  8016d4:	e8 9a fe ff ff       	call   801573 <syscall>
  8016d9:	83 c4 18             	add    $0x18,%esp
}
  8016dc:	c9                   	leave  
  8016dd:	c3                   	ret    

008016de <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  8016de:	55                   	push   %ebp
  8016df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  8016e1:	6a 00                	push   $0x0
  8016e3:	6a 00                	push   $0x0
  8016e5:	6a 00                	push   $0x0
  8016e7:	6a 00                	push   $0x0
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 0f                	push   $0xf
  8016ed:	e8 81 fe ff ff       	call   801573 <syscall>
  8016f2:	83 c4 18             	add    $0x18,%esp
}
  8016f5:	c9                   	leave  
  8016f6:	c3                   	ret    

008016f7 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  8016f7:	55                   	push   %ebp
  8016f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 00                	push   $0x0
  801700:	6a 00                	push   $0x0
  801702:	ff 75 08             	pushl  0x8(%ebp)
  801705:	6a 10                	push   $0x10
  801707:	e8 67 fe ff ff       	call   801573 <syscall>
  80170c:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  80170f:	c9                   	leave  
  801710:	c3                   	ret    

00801711 <sys_scarce_memory>:

void sys_scarce_memory() {
  801711:	55                   	push   %ebp
  801712:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  801714:	6a 00                	push   $0x0
  801716:	6a 00                	push   $0x0
  801718:	6a 00                	push   $0x0
  80171a:	6a 00                	push   $0x0
  80171c:	6a 00                	push   $0x0
  80171e:	6a 11                	push   $0x11
  801720:	e8 4e fe ff ff       	call   801573 <syscall>
  801725:	83 c4 18             	add    $0x18,%esp
}
  801728:	90                   	nop
  801729:	c9                   	leave  
  80172a:	c3                   	ret    

0080172b <sys_cputc>:

void sys_cputc(const char c) {
  80172b:	55                   	push   %ebp
  80172c:	89 e5                	mov    %esp,%ebp
  80172e:	83 ec 04             	sub    $0x4,%esp
  801731:	8b 45 08             	mov    0x8(%ebp),%eax
  801734:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801737:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80173b:	6a 00                	push   $0x0
  80173d:	6a 00                	push   $0x0
  80173f:	6a 00                	push   $0x0
  801741:	6a 00                	push   $0x0
  801743:	50                   	push   %eax
  801744:	6a 01                	push   $0x1
  801746:	e8 28 fe ff ff       	call   801573 <syscall>
  80174b:	83 c4 18             	add    $0x18,%esp
}
  80174e:	90                   	nop
  80174f:	c9                   	leave  
  801750:	c3                   	ret    

00801751 <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  801751:	55                   	push   %ebp
  801752:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  801754:	6a 00                	push   $0x0
  801756:	6a 00                	push   $0x0
  801758:	6a 00                	push   $0x0
  80175a:	6a 00                	push   $0x0
  80175c:	6a 00                	push   $0x0
  80175e:	6a 14                	push   $0x14
  801760:	e8 0e fe ff ff       	call   801573 <syscall>
  801765:	83 c4 18             	add    $0x18,%esp
}
  801768:	90                   	nop
  801769:	c9                   	leave  
  80176a:	c3                   	ret    

0080176b <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  80176b:	55                   	push   %ebp
  80176c:	89 e5                	mov    %esp,%ebp
  80176e:	83 ec 04             	sub    $0x4,%esp
  801771:	8b 45 10             	mov    0x10(%ebp),%eax
  801774:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  801777:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80177a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80177e:	8b 45 08             	mov    0x8(%ebp),%eax
  801781:	6a 00                	push   $0x0
  801783:	51                   	push   %ecx
  801784:	52                   	push   %edx
  801785:	ff 75 0c             	pushl  0xc(%ebp)
  801788:	50                   	push   %eax
  801789:	6a 15                	push   $0x15
  80178b:	e8 e3 fd ff ff       	call   801573 <syscall>
  801790:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  801793:	c9                   	leave  
  801794:	c3                   	ret    

00801795 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  801795:	55                   	push   %ebp
  801796:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  801798:	8b 55 0c             	mov    0xc(%ebp),%edx
  80179b:	8b 45 08             	mov    0x8(%ebp),%eax
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 00                	push   $0x0
  8017a2:	6a 00                	push   $0x0
  8017a4:	52                   	push   %edx
  8017a5:	50                   	push   %eax
  8017a6:	6a 16                	push   $0x16
  8017a8:	e8 c6 fd ff ff       	call   801573 <syscall>
  8017ad:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  8017b0:	c9                   	leave  
  8017b1:	c3                   	ret    

008017b2 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  8017b2:	55                   	push   %ebp
  8017b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  8017b5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017be:	6a 00                	push   $0x0
  8017c0:	6a 00                	push   $0x0
  8017c2:	51                   	push   %ecx
  8017c3:	52                   	push   %edx
  8017c4:	50                   	push   %eax
  8017c5:	6a 17                	push   $0x17
  8017c7:	e8 a7 fd ff ff       	call   801573 <syscall>
  8017cc:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  8017cf:	c9                   	leave  
  8017d0:	c3                   	ret    

008017d1 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  8017d1:	55                   	push   %ebp
  8017d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  8017d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017da:	6a 00                	push   $0x0
  8017dc:	6a 00                	push   $0x0
  8017de:	6a 00                	push   $0x0
  8017e0:	52                   	push   %edx
  8017e1:	50                   	push   %eax
  8017e2:	6a 18                	push   $0x18
  8017e4:	e8 8a fd ff ff       	call   801573 <syscall>
  8017e9:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  8017ec:	c9                   	leave  
  8017ed:	c3                   	ret    

008017ee <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  8017ee:	55                   	push   %ebp
  8017ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  8017f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f4:	6a 00                	push   $0x0
  8017f6:	ff 75 14             	pushl  0x14(%ebp)
  8017f9:	ff 75 10             	pushl  0x10(%ebp)
  8017fc:	ff 75 0c             	pushl  0xc(%ebp)
  8017ff:	50                   	push   %eax
  801800:	6a 19                	push   $0x19
  801802:	e8 6c fd ff ff       	call   801573 <syscall>
  801807:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  80180a:	c9                   	leave  
  80180b:	c3                   	ret    

0080180c <sys_run_env>:

void sys_run_env(int32 envId) {
  80180c:	55                   	push   %ebp
  80180d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  80180f:	8b 45 08             	mov    0x8(%ebp),%eax
  801812:	6a 00                	push   $0x0
  801814:	6a 00                	push   $0x0
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	50                   	push   %eax
  80181b:	6a 1a                	push   $0x1a
  80181d:	e8 51 fd ff ff       	call   801573 <syscall>
  801822:	83 c4 18             	add    $0x18,%esp
}
  801825:	90                   	nop
  801826:	c9                   	leave  
  801827:	c3                   	ret    

00801828 <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  801828:	55                   	push   %ebp
  801829:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80182b:	8b 45 08             	mov    0x8(%ebp),%eax
  80182e:	6a 00                	push   $0x0
  801830:	6a 00                	push   $0x0
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	50                   	push   %eax
  801837:	6a 1b                	push   $0x1b
  801839:	e8 35 fd ff ff       	call   801573 <syscall>
  80183e:	83 c4 18             	add    $0x18,%esp
}
  801841:	c9                   	leave  
  801842:	c3                   	ret    

00801843 <sys_getenvid>:

int32 sys_getenvid(void) {
  801843:	55                   	push   %ebp
  801844:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801846:	6a 00                	push   $0x0
  801848:	6a 00                	push   $0x0
  80184a:	6a 00                	push   $0x0
  80184c:	6a 00                	push   $0x0
  80184e:	6a 00                	push   $0x0
  801850:	6a 05                	push   $0x5
  801852:	e8 1c fd ff ff       	call   801573 <syscall>
  801857:	83 c4 18             	add    $0x18,%esp
}
  80185a:	c9                   	leave  
  80185b:	c3                   	ret    

0080185c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  80185c:	55                   	push   %ebp
  80185d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80185f:	6a 00                	push   $0x0
  801861:	6a 00                	push   $0x0
  801863:	6a 00                	push   $0x0
  801865:	6a 00                	push   $0x0
  801867:	6a 00                	push   $0x0
  801869:	6a 06                	push   $0x6
  80186b:	e8 03 fd ff ff       	call   801573 <syscall>
  801870:	83 c4 18             	add    $0x18,%esp
}
  801873:	c9                   	leave  
  801874:	c3                   	ret    

00801875 <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  801875:	55                   	push   %ebp
  801876:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801878:	6a 00                	push   $0x0
  80187a:	6a 00                	push   $0x0
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	6a 07                	push   $0x7
  801884:	e8 ea fc ff ff       	call   801573 <syscall>
  801889:	83 c4 18             	add    $0x18,%esp
}
  80188c:	c9                   	leave  
  80188d:	c3                   	ret    

0080188e <sys_exit_env>:

void sys_exit_env(void) {
  80188e:	55                   	push   %ebp
  80188f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	6a 1c                	push   $0x1c
  80189d:	e8 d1 fc ff ff       	call   801573 <syscall>
  8018a2:	83 c4 18             	add    $0x18,%esp
}
  8018a5:	90                   	nop
  8018a6:	c9                   	leave  
  8018a7:	c3                   	ret    

008018a8 <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  8018a8:	55                   	push   %ebp
  8018a9:	89 e5                	mov    %esp,%ebp
  8018ab:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  8018ae:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018b1:	8d 50 04             	lea    0x4(%eax),%edx
  8018b4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	52                   	push   %edx
  8018be:	50                   	push   %eax
  8018bf:	6a 1d                	push   $0x1d
  8018c1:	e8 ad fc ff ff       	call   801573 <syscall>
  8018c6:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  8018c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018cf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018d2:	89 01                	mov    %eax,(%ecx)
  8018d4:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8018d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018da:	c9                   	leave  
  8018db:	c2 04 00             	ret    $0x4

008018de <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  8018de:	55                   	push   %ebp
  8018df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 00                	push   $0x0
  8018e5:	ff 75 10             	pushl  0x10(%ebp)
  8018e8:	ff 75 0c             	pushl  0xc(%ebp)
  8018eb:	ff 75 08             	pushl  0x8(%ebp)
  8018ee:	6a 13                	push   $0x13
  8018f0:	e8 7e fc ff ff       	call   801573 <syscall>
  8018f5:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  8018f8:	90                   	nop
}
  8018f9:	c9                   	leave  
  8018fa:	c3                   	ret    

008018fb <sys_rcr2>:
uint32 sys_rcr2() {
  8018fb:	55                   	push   %ebp
  8018fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	6a 1e                	push   $0x1e
  80190a:	e8 64 fc ff ff       	call   801573 <syscall>
  80190f:	83 c4 18             	add    $0x18,%esp
}
  801912:	c9                   	leave  
  801913:	c3                   	ret    

00801914 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
  801917:	83 ec 04             	sub    $0x4,%esp
  80191a:	8b 45 08             	mov    0x8(%ebp),%eax
  80191d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801920:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	6a 00                	push   $0x0
  80192a:	6a 00                	push   $0x0
  80192c:	50                   	push   %eax
  80192d:	6a 1f                	push   $0x1f
  80192f:	e8 3f fc ff ff       	call   801573 <syscall>
  801934:	83 c4 18             	add    $0x18,%esp
	return;
  801937:	90                   	nop
}
  801938:	c9                   	leave  
  801939:	c3                   	ret    

0080193a <rsttst>:
void rsttst() {
  80193a:	55                   	push   %ebp
  80193b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 21                	push   $0x21
  801949:	e8 25 fc ff ff       	call   801573 <syscall>
  80194e:	83 c4 18             	add    $0x18,%esp
	return;
  801951:	90                   	nop
}
  801952:	c9                   	leave  
  801953:	c3                   	ret    

00801954 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  801954:	55                   	push   %ebp
  801955:	89 e5                	mov    %esp,%ebp
  801957:	83 ec 04             	sub    $0x4,%esp
  80195a:	8b 45 14             	mov    0x14(%ebp),%eax
  80195d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801960:	8b 55 18             	mov    0x18(%ebp),%edx
  801963:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801967:	52                   	push   %edx
  801968:	50                   	push   %eax
  801969:	ff 75 10             	pushl  0x10(%ebp)
  80196c:	ff 75 0c             	pushl  0xc(%ebp)
  80196f:	ff 75 08             	pushl  0x8(%ebp)
  801972:	6a 20                	push   $0x20
  801974:	e8 fa fb ff ff       	call   801573 <syscall>
  801979:	83 c4 18             	add    $0x18,%esp
	return;
  80197c:	90                   	nop
}
  80197d:	c9                   	leave  
  80197e:	c3                   	ret    

0080197f <chktst>:
void chktst(uint32 n) {
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	ff 75 08             	pushl  0x8(%ebp)
  80198d:	6a 22                	push   $0x22
  80198f:	e8 df fb ff ff       	call   801573 <syscall>
  801994:	83 c4 18             	add    $0x18,%esp
	return;
  801997:	90                   	nop
}
  801998:	c9                   	leave  
  801999:	c3                   	ret    

0080199a <inctst>:

void inctst() {
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 23                	push   $0x23
  8019a9:	e8 c5 fb ff ff       	call   801573 <syscall>
  8019ae:	83 c4 18             	add    $0x18,%esp
	return;
  8019b1:	90                   	nop
}
  8019b2:	c9                   	leave  
  8019b3:	c3                   	ret    

008019b4 <gettst>:
uint32 gettst() {
  8019b4:	55                   	push   %ebp
  8019b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 24                	push   $0x24
  8019c3:	e8 ab fb ff ff       	call   801573 <syscall>
  8019c8:	83 c4 18             	add    $0x18,%esp
}
  8019cb:	c9                   	leave  
  8019cc:	c3                   	ret    

008019cd <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  8019cd:	55                   	push   %ebp
  8019ce:	89 e5                	mov    %esp,%ebp
  8019d0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 25                	push   $0x25
  8019df:	e8 8f fb ff ff       	call   801573 <syscall>
  8019e4:	83 c4 18             	add    $0x18,%esp
  8019e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8019ea:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8019ee:	75 07                	jne    8019f7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8019f0:	b8 01 00 00 00       	mov    $0x1,%eax
  8019f5:	eb 05                	jmp    8019fc <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8019f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019fc:	c9                   	leave  
  8019fd:	c3                   	ret    

008019fe <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  8019fe:	55                   	push   %ebp
  8019ff:	89 e5                	mov    %esp,%ebp
  801a01:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 25                	push   $0x25
  801a10:	e8 5e fb ff ff       	call   801573 <syscall>
  801a15:	83 c4 18             	add    $0x18,%esp
  801a18:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801a1b:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801a1f:	75 07                	jne    801a28 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801a21:	b8 01 00 00 00       	mov    $0x1,%eax
  801a26:	eb 05                	jmp    801a2d <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801a28:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a2d:	c9                   	leave  
  801a2e:	c3                   	ret    

00801a2f <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  801a2f:	55                   	push   %ebp
  801a30:	89 e5                	mov    %esp,%ebp
  801a32:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 25                	push   $0x25
  801a41:	e8 2d fb ff ff       	call   801573 <syscall>
  801a46:	83 c4 18             	add    $0x18,%esp
  801a49:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801a4c:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801a50:	75 07                	jne    801a59 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801a52:	b8 01 00 00 00       	mov    $0x1,%eax
  801a57:	eb 05                	jmp    801a5e <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801a59:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a5e:	c9                   	leave  
  801a5f:	c3                   	ret    

00801a60 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  801a60:	55                   	push   %ebp
  801a61:	89 e5                	mov    %esp,%ebp
  801a63:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 25                	push   $0x25
  801a72:	e8 fc fa ff ff       	call   801573 <syscall>
  801a77:	83 c4 18             	add    $0x18,%esp
  801a7a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801a7d:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801a81:	75 07                	jne    801a8a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801a83:	b8 01 00 00 00       	mov    $0x1,%eax
  801a88:	eb 05                	jmp    801a8f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801a8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a8f:	c9                   	leave  
  801a90:	c3                   	ret    

00801a91 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  801a91:	55                   	push   %ebp
  801a92:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	ff 75 08             	pushl  0x8(%ebp)
  801a9f:	6a 26                	push   $0x26
  801aa1:	e8 cd fa ff ff       	call   801573 <syscall>
  801aa6:	83 c4 18             	add    $0x18,%esp
	return;
  801aa9:	90                   	nop
}
  801aaa:	c9                   	leave  
  801aab:	c3                   	ret    

00801aac <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  801aac:	55                   	push   %ebp
  801aad:	89 e5                	mov    %esp,%ebp
  801aaf:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  801ab0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ab3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ab6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  801abc:	6a 00                	push   $0x0
  801abe:	53                   	push   %ebx
  801abf:	51                   	push   %ecx
  801ac0:	52                   	push   %edx
  801ac1:	50                   	push   %eax
  801ac2:	6a 27                	push   $0x27
  801ac4:	e8 aa fa ff ff       	call   801573 <syscall>
  801ac9:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  801acc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801acf:	c9                   	leave  
  801ad0:	c3                   	ret    

00801ad1 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  801ad1:	55                   	push   %ebp
  801ad2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  801ad4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	52                   	push   %edx
  801ae1:	50                   	push   %eax
  801ae2:	6a 28                	push   $0x28
  801ae4:	e8 8a fa ff ff       	call   801573 <syscall>
  801ae9:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  801aec:	c9                   	leave  
  801aed:	c3                   	ret    

00801aee <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  801aee:	55                   	push   %ebp
  801aef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  801af1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801af4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af7:	8b 45 08             	mov    0x8(%ebp),%eax
  801afa:	6a 00                	push   $0x0
  801afc:	51                   	push   %ecx
  801afd:	ff 75 10             	pushl  0x10(%ebp)
  801b00:	52                   	push   %edx
  801b01:	50                   	push   %eax
  801b02:	6a 29                	push   $0x29
  801b04:	e8 6a fa ff ff       	call   801573 <syscall>
  801b09:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  801b0c:	c9                   	leave  
  801b0d:	c3                   	ret    

00801b0e <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  801b0e:	55                   	push   %ebp
  801b0f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	ff 75 10             	pushl  0x10(%ebp)
  801b18:	ff 75 0c             	pushl  0xc(%ebp)
  801b1b:	ff 75 08             	pushl  0x8(%ebp)
  801b1e:	6a 12                	push   $0x12
  801b20:	e8 4e fa ff ff       	call   801573 <syscall>
  801b25:	83 c4 18             	add    $0x18,%esp
	return;
  801b28:	90                   	nop
}
  801b29:	c9                   	leave  
  801b2a:	c3                   	ret    

00801b2b <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  801b2b:	55                   	push   %ebp
  801b2c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  801b2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b31:	8b 45 08             	mov    0x8(%ebp),%eax
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	52                   	push   %edx
  801b3b:	50                   	push   %eax
  801b3c:	6a 2a                	push   $0x2a
  801b3e:	e8 30 fa ff ff       	call   801573 <syscall>
  801b43:	83 c4 18             	add    $0x18,%esp
	return;
  801b46:	90                   	nop
}
  801b47:	c9                   	leave  
  801b48:	c3                   	ret    

00801b49 <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  801b49:	55                   	push   %ebp
  801b4a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  801b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	50                   	push   %eax
  801b58:	6a 2b                	push   $0x2b
  801b5a:	e8 14 fa ff ff       	call   801573 <syscall>
  801b5f:	83 c4 18             	add    $0x18,%esp
}
  801b62:	c9                   	leave  
  801b63:	c3                   	ret    

00801b64 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  801b64:	55                   	push   %ebp
  801b65:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	ff 75 0c             	pushl  0xc(%ebp)
  801b70:	ff 75 08             	pushl  0x8(%ebp)
  801b73:	6a 2c                	push   $0x2c
  801b75:	e8 f9 f9 ff ff       	call   801573 <syscall>
  801b7a:	83 c4 18             	add    $0x18,%esp
	return;
  801b7d:	90                   	nop
}
  801b7e:	c9                   	leave  
  801b7f:	c3                   	ret    

00801b80 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  801b80:	55                   	push   %ebp
  801b81:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	ff 75 0c             	pushl  0xc(%ebp)
  801b8c:	ff 75 08             	pushl  0x8(%ebp)
  801b8f:	6a 2d                	push   $0x2d
  801b91:	e8 dd f9 ff ff       	call   801573 <syscall>
  801b96:	83 c4 18             	add    $0x18,%esp
	return;
  801b99:	90                   	nop
}
  801b9a:	c9                   	leave  
  801b9b:	c3                   	ret    

00801b9c <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  801b9c:	55                   	push   %ebp
  801b9d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  801b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	50                   	push   %eax
  801bab:	6a 2f                	push   $0x2f
  801bad:	e8 c1 f9 ff ff       	call   801573 <syscall>
  801bb2:	83 c4 18             	add    $0x18,%esp
	return;
  801bb5:	90                   	nop
}
  801bb6:	c9                   	leave  
  801bb7:	c3                   	ret    

00801bb8 <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  801bb8:	55                   	push   %ebp
  801bb9:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  801bbb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	52                   	push   %edx
  801bc8:	50                   	push   %eax
  801bc9:	6a 30                	push   $0x30
  801bcb:	e8 a3 f9 ff ff       	call   801573 <syscall>
  801bd0:	83 c4 18             	add    $0x18,%esp
	return;
  801bd3:	90                   	nop
}
  801bd4:	c9                   	leave  
  801bd5:	c3                   	ret    

00801bd6 <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  801bd6:	55                   	push   %ebp
  801bd7:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  801bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	50                   	push   %eax
  801be5:	6a 31                	push   $0x31
  801be7:	e8 87 f9 ff ff       	call   801573 <syscall>
  801bec:	83 c4 18             	add    $0x18,%esp
	return;
  801bef:	90                   	nop
}
  801bf0:	c9                   	leave  
  801bf1:	c3                   	ret    

00801bf2 <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  801bf2:	55                   	push   %ebp
  801bf3:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801bf5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	52                   	push   %edx
  801c02:	50                   	push   %eax
  801c03:	6a 2e                	push   $0x2e
  801c05:	e8 69 f9 ff ff       	call   801573 <syscall>
  801c0a:	83 c4 18             	add    $0x18,%esp
    return;
  801c0d:	90                   	nop
}
  801c0e:	c9                   	leave  
  801c0f:	c3                   	ret    

00801c10 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801c10:	55                   	push   %ebp
  801c11:	89 e5                	mov    %esp,%ebp
  801c13:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801c16:	8b 55 08             	mov    0x8(%ebp),%edx
  801c19:	89 d0                	mov    %edx,%eax
  801c1b:	c1 e0 02             	shl    $0x2,%eax
  801c1e:	01 d0                	add    %edx,%eax
  801c20:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c27:	01 d0                	add    %edx,%eax
  801c29:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c30:	01 d0                	add    %edx,%eax
  801c32:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c39:	01 d0                	add    %edx,%eax
  801c3b:	c1 e0 04             	shl    $0x4,%eax
  801c3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801c41:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801c48:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801c4b:	83 ec 0c             	sub    $0xc,%esp
  801c4e:	50                   	push   %eax
  801c4f:	e8 54 fc ff ff       	call   8018a8 <sys_get_virtual_time>
  801c54:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801c57:	eb 41                	jmp    801c9a <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801c59:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801c5c:	83 ec 0c             	sub    $0xc,%esp
  801c5f:	50                   	push   %eax
  801c60:	e8 43 fc ff ff       	call   8018a8 <sys_get_virtual_time>
  801c65:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801c68:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c6b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c6e:	29 c2                	sub    %eax,%edx
  801c70:	89 d0                	mov    %edx,%eax
  801c72:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801c75:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801c78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c7b:	89 d1                	mov    %edx,%ecx
  801c7d:	29 c1                	sub    %eax,%ecx
  801c7f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801c82:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c85:	39 c2                	cmp    %eax,%edx
  801c87:	0f 97 c0             	seta   %al
  801c8a:	0f b6 c0             	movzbl %al,%eax
  801c8d:	29 c1                	sub    %eax,%ecx
  801c8f:	89 c8                	mov    %ecx,%eax
  801c91:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801c94:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c97:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c9d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801ca0:	72 b7                	jb     801c59 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801ca2:	90                   	nop
  801ca3:	c9                   	leave  
  801ca4:	c3                   	ret    

00801ca5 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801ca5:	55                   	push   %ebp
  801ca6:	89 e5                	mov    %esp,%ebp
  801ca8:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801cab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801cb2:	eb 03                	jmp    801cb7 <busy_wait+0x12>
  801cb4:	ff 45 fc             	incl   -0x4(%ebp)
  801cb7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801cba:	3b 45 08             	cmp    0x8(%ebp),%eax
  801cbd:	72 f5                	jb     801cb4 <busy_wait+0xf>
	return i;
  801cbf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801cc2:	c9                   	leave  
  801cc3:	c3                   	ret    

00801cc4 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  801cc4:	55                   	push   %ebp
  801cc5:	89 e5                	mov    %esp,%ebp
  801cc7:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  801cca:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccd:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  801cd0:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  801cd4:	83 ec 0c             	sub    $0xc,%esp
  801cd7:	50                   	push   %eax
  801cd8:	e8 4e fa ff ff       	call   80172b <sys_cputc>
  801cdd:	83 c4 10             	add    $0x10,%esp
}
  801ce0:	90                   	nop
  801ce1:	c9                   	leave  
  801ce2:	c3                   	ret    

00801ce3 <getchar>:


int
getchar(void)
{
  801ce3:	55                   	push   %ebp
  801ce4:	89 e5                	mov    %esp,%ebp
  801ce6:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  801ce9:	e8 d9 f8 ff ff       	call   8015c7 <sys_cgetc>
  801cee:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  801cf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801cf4:	c9                   	leave  
  801cf5:	c3                   	ret    

00801cf6 <iscons>:

int iscons(int fdnum)
{
  801cf6:	55                   	push   %ebp
  801cf7:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801cf9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801cfe:	5d                   	pop    %ebp
  801cff:	c3                   	ret    

00801d00 <__udivdi3>:
  801d00:	55                   	push   %ebp
  801d01:	57                   	push   %edi
  801d02:	56                   	push   %esi
  801d03:	53                   	push   %ebx
  801d04:	83 ec 1c             	sub    $0x1c,%esp
  801d07:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801d0b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801d0f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d13:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d17:	89 ca                	mov    %ecx,%edx
  801d19:	89 f8                	mov    %edi,%eax
  801d1b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801d1f:	85 f6                	test   %esi,%esi
  801d21:	75 2d                	jne    801d50 <__udivdi3+0x50>
  801d23:	39 cf                	cmp    %ecx,%edi
  801d25:	77 65                	ja     801d8c <__udivdi3+0x8c>
  801d27:	89 fd                	mov    %edi,%ebp
  801d29:	85 ff                	test   %edi,%edi
  801d2b:	75 0b                	jne    801d38 <__udivdi3+0x38>
  801d2d:	b8 01 00 00 00       	mov    $0x1,%eax
  801d32:	31 d2                	xor    %edx,%edx
  801d34:	f7 f7                	div    %edi
  801d36:	89 c5                	mov    %eax,%ebp
  801d38:	31 d2                	xor    %edx,%edx
  801d3a:	89 c8                	mov    %ecx,%eax
  801d3c:	f7 f5                	div    %ebp
  801d3e:	89 c1                	mov    %eax,%ecx
  801d40:	89 d8                	mov    %ebx,%eax
  801d42:	f7 f5                	div    %ebp
  801d44:	89 cf                	mov    %ecx,%edi
  801d46:	89 fa                	mov    %edi,%edx
  801d48:	83 c4 1c             	add    $0x1c,%esp
  801d4b:	5b                   	pop    %ebx
  801d4c:	5e                   	pop    %esi
  801d4d:	5f                   	pop    %edi
  801d4e:	5d                   	pop    %ebp
  801d4f:	c3                   	ret    
  801d50:	39 ce                	cmp    %ecx,%esi
  801d52:	77 28                	ja     801d7c <__udivdi3+0x7c>
  801d54:	0f bd fe             	bsr    %esi,%edi
  801d57:	83 f7 1f             	xor    $0x1f,%edi
  801d5a:	75 40                	jne    801d9c <__udivdi3+0x9c>
  801d5c:	39 ce                	cmp    %ecx,%esi
  801d5e:	72 0a                	jb     801d6a <__udivdi3+0x6a>
  801d60:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801d64:	0f 87 9e 00 00 00    	ja     801e08 <__udivdi3+0x108>
  801d6a:	b8 01 00 00 00       	mov    $0x1,%eax
  801d6f:	89 fa                	mov    %edi,%edx
  801d71:	83 c4 1c             	add    $0x1c,%esp
  801d74:	5b                   	pop    %ebx
  801d75:	5e                   	pop    %esi
  801d76:	5f                   	pop    %edi
  801d77:	5d                   	pop    %ebp
  801d78:	c3                   	ret    
  801d79:	8d 76 00             	lea    0x0(%esi),%esi
  801d7c:	31 ff                	xor    %edi,%edi
  801d7e:	31 c0                	xor    %eax,%eax
  801d80:	89 fa                	mov    %edi,%edx
  801d82:	83 c4 1c             	add    $0x1c,%esp
  801d85:	5b                   	pop    %ebx
  801d86:	5e                   	pop    %esi
  801d87:	5f                   	pop    %edi
  801d88:	5d                   	pop    %ebp
  801d89:	c3                   	ret    
  801d8a:	66 90                	xchg   %ax,%ax
  801d8c:	89 d8                	mov    %ebx,%eax
  801d8e:	f7 f7                	div    %edi
  801d90:	31 ff                	xor    %edi,%edi
  801d92:	89 fa                	mov    %edi,%edx
  801d94:	83 c4 1c             	add    $0x1c,%esp
  801d97:	5b                   	pop    %ebx
  801d98:	5e                   	pop    %esi
  801d99:	5f                   	pop    %edi
  801d9a:	5d                   	pop    %ebp
  801d9b:	c3                   	ret    
  801d9c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801da1:	89 eb                	mov    %ebp,%ebx
  801da3:	29 fb                	sub    %edi,%ebx
  801da5:	89 f9                	mov    %edi,%ecx
  801da7:	d3 e6                	shl    %cl,%esi
  801da9:	89 c5                	mov    %eax,%ebp
  801dab:	88 d9                	mov    %bl,%cl
  801dad:	d3 ed                	shr    %cl,%ebp
  801daf:	89 e9                	mov    %ebp,%ecx
  801db1:	09 f1                	or     %esi,%ecx
  801db3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801db7:	89 f9                	mov    %edi,%ecx
  801db9:	d3 e0                	shl    %cl,%eax
  801dbb:	89 c5                	mov    %eax,%ebp
  801dbd:	89 d6                	mov    %edx,%esi
  801dbf:	88 d9                	mov    %bl,%cl
  801dc1:	d3 ee                	shr    %cl,%esi
  801dc3:	89 f9                	mov    %edi,%ecx
  801dc5:	d3 e2                	shl    %cl,%edx
  801dc7:	8b 44 24 08          	mov    0x8(%esp),%eax
  801dcb:	88 d9                	mov    %bl,%cl
  801dcd:	d3 e8                	shr    %cl,%eax
  801dcf:	09 c2                	or     %eax,%edx
  801dd1:	89 d0                	mov    %edx,%eax
  801dd3:	89 f2                	mov    %esi,%edx
  801dd5:	f7 74 24 0c          	divl   0xc(%esp)
  801dd9:	89 d6                	mov    %edx,%esi
  801ddb:	89 c3                	mov    %eax,%ebx
  801ddd:	f7 e5                	mul    %ebp
  801ddf:	39 d6                	cmp    %edx,%esi
  801de1:	72 19                	jb     801dfc <__udivdi3+0xfc>
  801de3:	74 0b                	je     801df0 <__udivdi3+0xf0>
  801de5:	89 d8                	mov    %ebx,%eax
  801de7:	31 ff                	xor    %edi,%edi
  801de9:	e9 58 ff ff ff       	jmp    801d46 <__udivdi3+0x46>
  801dee:	66 90                	xchg   %ax,%ax
  801df0:	8b 54 24 08          	mov    0x8(%esp),%edx
  801df4:	89 f9                	mov    %edi,%ecx
  801df6:	d3 e2                	shl    %cl,%edx
  801df8:	39 c2                	cmp    %eax,%edx
  801dfa:	73 e9                	jae    801de5 <__udivdi3+0xe5>
  801dfc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801dff:	31 ff                	xor    %edi,%edi
  801e01:	e9 40 ff ff ff       	jmp    801d46 <__udivdi3+0x46>
  801e06:	66 90                	xchg   %ax,%ax
  801e08:	31 c0                	xor    %eax,%eax
  801e0a:	e9 37 ff ff ff       	jmp    801d46 <__udivdi3+0x46>
  801e0f:	90                   	nop

00801e10 <__umoddi3>:
  801e10:	55                   	push   %ebp
  801e11:	57                   	push   %edi
  801e12:	56                   	push   %esi
  801e13:	53                   	push   %ebx
  801e14:	83 ec 1c             	sub    $0x1c,%esp
  801e17:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801e1b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801e1f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e23:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801e27:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e2b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e2f:	89 f3                	mov    %esi,%ebx
  801e31:	89 fa                	mov    %edi,%edx
  801e33:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e37:	89 34 24             	mov    %esi,(%esp)
  801e3a:	85 c0                	test   %eax,%eax
  801e3c:	75 1a                	jne    801e58 <__umoddi3+0x48>
  801e3e:	39 f7                	cmp    %esi,%edi
  801e40:	0f 86 a2 00 00 00    	jbe    801ee8 <__umoddi3+0xd8>
  801e46:	89 c8                	mov    %ecx,%eax
  801e48:	89 f2                	mov    %esi,%edx
  801e4a:	f7 f7                	div    %edi
  801e4c:	89 d0                	mov    %edx,%eax
  801e4e:	31 d2                	xor    %edx,%edx
  801e50:	83 c4 1c             	add    $0x1c,%esp
  801e53:	5b                   	pop    %ebx
  801e54:	5e                   	pop    %esi
  801e55:	5f                   	pop    %edi
  801e56:	5d                   	pop    %ebp
  801e57:	c3                   	ret    
  801e58:	39 f0                	cmp    %esi,%eax
  801e5a:	0f 87 ac 00 00 00    	ja     801f0c <__umoddi3+0xfc>
  801e60:	0f bd e8             	bsr    %eax,%ebp
  801e63:	83 f5 1f             	xor    $0x1f,%ebp
  801e66:	0f 84 ac 00 00 00    	je     801f18 <__umoddi3+0x108>
  801e6c:	bf 20 00 00 00       	mov    $0x20,%edi
  801e71:	29 ef                	sub    %ebp,%edi
  801e73:	89 fe                	mov    %edi,%esi
  801e75:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801e79:	89 e9                	mov    %ebp,%ecx
  801e7b:	d3 e0                	shl    %cl,%eax
  801e7d:	89 d7                	mov    %edx,%edi
  801e7f:	89 f1                	mov    %esi,%ecx
  801e81:	d3 ef                	shr    %cl,%edi
  801e83:	09 c7                	or     %eax,%edi
  801e85:	89 e9                	mov    %ebp,%ecx
  801e87:	d3 e2                	shl    %cl,%edx
  801e89:	89 14 24             	mov    %edx,(%esp)
  801e8c:	89 d8                	mov    %ebx,%eax
  801e8e:	d3 e0                	shl    %cl,%eax
  801e90:	89 c2                	mov    %eax,%edx
  801e92:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e96:	d3 e0                	shl    %cl,%eax
  801e98:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e9c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ea0:	89 f1                	mov    %esi,%ecx
  801ea2:	d3 e8                	shr    %cl,%eax
  801ea4:	09 d0                	or     %edx,%eax
  801ea6:	d3 eb                	shr    %cl,%ebx
  801ea8:	89 da                	mov    %ebx,%edx
  801eaa:	f7 f7                	div    %edi
  801eac:	89 d3                	mov    %edx,%ebx
  801eae:	f7 24 24             	mull   (%esp)
  801eb1:	89 c6                	mov    %eax,%esi
  801eb3:	89 d1                	mov    %edx,%ecx
  801eb5:	39 d3                	cmp    %edx,%ebx
  801eb7:	0f 82 87 00 00 00    	jb     801f44 <__umoddi3+0x134>
  801ebd:	0f 84 91 00 00 00    	je     801f54 <__umoddi3+0x144>
  801ec3:	8b 54 24 04          	mov    0x4(%esp),%edx
  801ec7:	29 f2                	sub    %esi,%edx
  801ec9:	19 cb                	sbb    %ecx,%ebx
  801ecb:	89 d8                	mov    %ebx,%eax
  801ecd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801ed1:	d3 e0                	shl    %cl,%eax
  801ed3:	89 e9                	mov    %ebp,%ecx
  801ed5:	d3 ea                	shr    %cl,%edx
  801ed7:	09 d0                	or     %edx,%eax
  801ed9:	89 e9                	mov    %ebp,%ecx
  801edb:	d3 eb                	shr    %cl,%ebx
  801edd:	89 da                	mov    %ebx,%edx
  801edf:	83 c4 1c             	add    $0x1c,%esp
  801ee2:	5b                   	pop    %ebx
  801ee3:	5e                   	pop    %esi
  801ee4:	5f                   	pop    %edi
  801ee5:	5d                   	pop    %ebp
  801ee6:	c3                   	ret    
  801ee7:	90                   	nop
  801ee8:	89 fd                	mov    %edi,%ebp
  801eea:	85 ff                	test   %edi,%edi
  801eec:	75 0b                	jne    801ef9 <__umoddi3+0xe9>
  801eee:	b8 01 00 00 00       	mov    $0x1,%eax
  801ef3:	31 d2                	xor    %edx,%edx
  801ef5:	f7 f7                	div    %edi
  801ef7:	89 c5                	mov    %eax,%ebp
  801ef9:	89 f0                	mov    %esi,%eax
  801efb:	31 d2                	xor    %edx,%edx
  801efd:	f7 f5                	div    %ebp
  801eff:	89 c8                	mov    %ecx,%eax
  801f01:	f7 f5                	div    %ebp
  801f03:	89 d0                	mov    %edx,%eax
  801f05:	e9 44 ff ff ff       	jmp    801e4e <__umoddi3+0x3e>
  801f0a:	66 90                	xchg   %ax,%ax
  801f0c:	89 c8                	mov    %ecx,%eax
  801f0e:	89 f2                	mov    %esi,%edx
  801f10:	83 c4 1c             	add    $0x1c,%esp
  801f13:	5b                   	pop    %ebx
  801f14:	5e                   	pop    %esi
  801f15:	5f                   	pop    %edi
  801f16:	5d                   	pop    %ebp
  801f17:	c3                   	ret    
  801f18:	3b 04 24             	cmp    (%esp),%eax
  801f1b:	72 06                	jb     801f23 <__umoddi3+0x113>
  801f1d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801f21:	77 0f                	ja     801f32 <__umoddi3+0x122>
  801f23:	89 f2                	mov    %esi,%edx
  801f25:	29 f9                	sub    %edi,%ecx
  801f27:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801f2b:	89 14 24             	mov    %edx,(%esp)
  801f2e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f32:	8b 44 24 04          	mov    0x4(%esp),%eax
  801f36:	8b 14 24             	mov    (%esp),%edx
  801f39:	83 c4 1c             	add    $0x1c,%esp
  801f3c:	5b                   	pop    %ebx
  801f3d:	5e                   	pop    %esi
  801f3e:	5f                   	pop    %edi
  801f3f:	5d                   	pop    %ebp
  801f40:	c3                   	ret    
  801f41:	8d 76 00             	lea    0x0(%esi),%esi
  801f44:	2b 04 24             	sub    (%esp),%eax
  801f47:	19 fa                	sbb    %edi,%edx
  801f49:	89 d1                	mov    %edx,%ecx
  801f4b:	89 c6                	mov    %eax,%esi
  801f4d:	e9 71 ff ff ff       	jmp    801ec3 <__umoddi3+0xb3>
  801f52:	66 90                	xchg   %ax,%ax
  801f54:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801f58:	72 ea                	jb     801f44 <__umoddi3+0x134>
  801f5a:	89 d9                	mov    %ebx,%ecx
  801f5c:	e9 62 ff ff ff       	jmp    801ec3 <__umoddi3+0xb3>
