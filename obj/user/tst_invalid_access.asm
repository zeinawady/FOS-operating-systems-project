
obj/user/tst_invalid_access:     file format elf32-i386


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
  800031:	e8 fd 01 00 00       	call   800233 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/************************************************************/

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	int eval = 0;
  80003e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	cprintf("PART I: Test the Pointer Validation inside fault_handler(): [70%]\n");
  800045:	83 ec 0c             	sub    $0xc,%esp
  800048:	68 a0 1d 80 00       	push   $0x801da0
  80004d:	e8 fa 03 00 00       	call   80044c <cprintf>
  800052:	83 c4 10             	add    $0x10,%esp
	cprintf("=================================================================\n");
  800055:	83 ec 0c             	sub    $0xc,%esp
  800058:	68 e4 1d 80 00       	push   $0x801de4
  80005d:	e8 ea 03 00 00       	call   80044c <cprintf>
  800062:	83 c4 10             	add    $0x10,%esp
	rsttst();
  800065:	e8 43 15 00 00       	call   8015ad <rsttst>
	int ID1 = sys_create_env("tia_slave1", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  80006a:	a1 08 30 80 00       	mov    0x803008,%eax
  80006f:	8b 90 90 05 00 00    	mov    0x590(%eax),%edx
  800075:	a1 08 30 80 00       	mov    0x803008,%eax
  80007a:	8b 80 88 05 00 00    	mov    0x588(%eax),%eax
  800080:	89 c1                	mov    %eax,%ecx
  800082:	a1 08 30 80 00       	mov    0x803008,%eax
  800087:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  80008d:	52                   	push   %edx
  80008e:	51                   	push   %ecx
  80008f:	50                   	push   %eax
  800090:	68 27 1e 80 00       	push   $0x801e27
  800095:	e8 c7 13 00 00       	call   801461 <sys_create_env>
  80009a:	83 c4 10             	add    $0x10,%esp
  80009d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	sys_run_env(ID1);
  8000a0:	83 ec 0c             	sub    $0xc,%esp
  8000a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8000a6:	e8 d4 13 00 00       	call   80147f <sys_run_env>
  8000ab:	83 c4 10             	add    $0x10,%esp

	int ID2 = sys_create_env("tia_slave2", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8000ae:	a1 08 30 80 00       	mov    0x803008,%eax
  8000b3:	8b 90 90 05 00 00    	mov    0x590(%eax),%edx
  8000b9:	a1 08 30 80 00       	mov    0x803008,%eax
  8000be:	8b 80 88 05 00 00    	mov    0x588(%eax),%eax
  8000c4:	89 c1                	mov    %eax,%ecx
  8000c6:	a1 08 30 80 00       	mov    0x803008,%eax
  8000cb:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  8000d1:	52                   	push   %edx
  8000d2:	51                   	push   %ecx
  8000d3:	50                   	push   %eax
  8000d4:	68 32 1e 80 00       	push   $0x801e32
  8000d9:	e8 83 13 00 00       	call   801461 <sys_create_env>
  8000de:	83 c4 10             	add    $0x10,%esp
  8000e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_run_env(ID2);
  8000e4:	83 ec 0c             	sub    $0xc,%esp
  8000e7:	ff 75 ec             	pushl  -0x14(%ebp)
  8000ea:	e8 90 13 00 00       	call   80147f <sys_run_env>
  8000ef:	83 c4 10             	add    $0x10,%esp

	int ID3 = sys_create_env("tia_slave3", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8000f2:	a1 08 30 80 00       	mov    0x803008,%eax
  8000f7:	8b 90 90 05 00 00    	mov    0x590(%eax),%edx
  8000fd:	a1 08 30 80 00       	mov    0x803008,%eax
  800102:	8b 80 88 05 00 00    	mov    0x588(%eax),%eax
  800108:	89 c1                	mov    %eax,%ecx
  80010a:	a1 08 30 80 00       	mov    0x803008,%eax
  80010f:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  800115:	52                   	push   %edx
  800116:	51                   	push   %ecx
  800117:	50                   	push   %eax
  800118:	68 3d 1e 80 00       	push   $0x801e3d
  80011d:	e8 3f 13 00 00       	call   801461 <sys_create_env>
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_run_env(ID3);
  800128:	83 ec 0c             	sub    $0xc,%esp
  80012b:	ff 75 e8             	pushl  -0x18(%ebp)
  80012e:	e8 4c 13 00 00       	call   80147f <sys_run_env>
  800133:	83 c4 10             	add    $0x10,%esp
	env_sleep(10000);
  800136:	83 ec 0c             	sub    $0xc,%esp
  800139:	68 10 27 00 00       	push   $0x2710
  80013e:	e8 40 17 00 00       	call   801883 <env_sleep>
  800143:	83 c4 10             	add    $0x10,%esp

	if (gettst() != 0)
  800146:	e8 dc 14 00 00       	call   801627 <gettst>
  80014b:	85 c0                	test   %eax,%eax
  80014d:	74 12                	je     800161 <_main+0x129>
		cprintf("\nPART I... Failed.\n");
  80014f:	83 ec 0c             	sub    $0xc,%esp
  800152:	68 48 1e 80 00       	push   $0x801e48
  800157:	e8 f0 02 00 00       	call   80044c <cprintf>
  80015c:	83 c4 10             	add    $0x10,%esp
  80015f:	eb 14                	jmp    800175 <_main+0x13d>
	else
	{
		cprintf("\nPART I... completed successfully\n\n");
  800161:	83 ec 0c             	sub    $0xc,%esp
  800164:	68 5c 1e 80 00       	push   $0x801e5c
  800169:	e8 de 02 00 00       	call   80044c <cprintf>
  80016e:	83 c4 10             	add    $0x10,%esp
		eval += 70;
  800171:	83 45 f4 46          	addl   $0x46,-0xc(%ebp)
	}

	cprintf("PART II: PLACEMENT: Test the Invalid Access to a NON-EXIST page in Page File, Stack & Heap: [30%]\n");
  800175:	83 ec 0c             	sub    $0xc,%esp
  800178:	68 80 1e 80 00       	push   $0x801e80
  80017d:	e8 ca 02 00 00       	call   80044c <cprintf>
  800182:	83 c4 10             	add    $0x10,%esp
	cprintf("=================================================================================================\n");
  800185:	83 ec 0c             	sub    $0xc,%esp
  800188:	68 e4 1e 80 00       	push   $0x801ee4
  80018d:	e8 ba 02 00 00       	call   80044c <cprintf>
  800192:	83 c4 10             	add    $0x10,%esp

	rsttst();
  800195:	e8 13 14 00 00       	call   8015ad <rsttst>
	int ID4 = sys_create_env("tia_slave4", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  80019a:	a1 08 30 80 00       	mov    0x803008,%eax
  80019f:	8b 90 90 05 00 00    	mov    0x590(%eax),%edx
  8001a5:	a1 08 30 80 00       	mov    0x803008,%eax
  8001aa:	8b 80 88 05 00 00    	mov    0x588(%eax),%eax
  8001b0:	89 c1                	mov    %eax,%ecx
  8001b2:	a1 08 30 80 00       	mov    0x803008,%eax
  8001b7:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  8001bd:	52                   	push   %edx
  8001be:	51                   	push   %ecx
  8001bf:	50                   	push   %eax
  8001c0:	68 47 1f 80 00       	push   $0x801f47
  8001c5:	e8 97 12 00 00       	call   801461 <sys_create_env>
  8001ca:	83 c4 10             	add    $0x10,%esp
  8001cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	sys_run_env(ID4);
  8001d0:	83 ec 0c             	sub    $0xc,%esp
  8001d3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001d6:	e8 a4 12 00 00       	call   80147f <sys_run_env>
  8001db:	83 c4 10             	add    $0x10,%esp

	env_sleep(10000);
  8001de:	83 ec 0c             	sub    $0xc,%esp
  8001e1:	68 10 27 00 00       	push   $0x2710
  8001e6:	e8 98 16 00 00       	call   801883 <env_sleep>
  8001eb:	83 c4 10             	add    $0x10,%esp

	if (gettst() != 0)
  8001ee:	e8 34 14 00 00       	call   801627 <gettst>
  8001f3:	85 c0                	test   %eax,%eax
  8001f5:	74 12                	je     800209 <_main+0x1d1>
		cprintf("\nPART II... Failed.\n");
  8001f7:	83 ec 0c             	sub    $0xc,%esp
  8001fa:	68 52 1f 80 00       	push   $0x801f52
  8001ff:	e8 48 02 00 00       	call   80044c <cprintf>
  800204:	83 c4 10             	add    $0x10,%esp
  800207:	eb 14                	jmp    80021d <_main+0x1e5>
	else
	{
		cprintf("\nPART II... completed successfully\n\n");
  800209:	83 ec 0c             	sub    $0xc,%esp
  80020c:	68 68 1f 80 00       	push   $0x801f68
  800211:	e8 36 02 00 00       	call   80044c <cprintf>
  800216:	83 c4 10             	add    $0x10,%esp
		eval += 30;
  800219:	83 45 f4 1e          	addl   $0x1e,-0xc(%ebp)
	}
	cprintf("%~\ntest invalid access completed. Eval = %d\n\n", eval);
  80021d:	83 ec 08             	sub    $0x8,%esp
  800220:	ff 75 f4             	pushl  -0xc(%ebp)
  800223:	68 90 1f 80 00       	push   $0x801f90
  800228:	e8 1f 02 00 00       	call   80044c <cprintf>
  80022d:	83 c4 10             	add    $0x10,%esp

}
  800230:	90                   	nop
  800231:	c9                   	leave  
  800232:	c3                   	ret    

00800233 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800233:	55                   	push   %ebp
  800234:	89 e5                	mov    %esp,%ebp
  800236:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800239:	e8 91 12 00 00       	call   8014cf <sys_getenvindex>
  80023e:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800241:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800244:	89 d0                	mov    %edx,%eax
  800246:	c1 e0 02             	shl    $0x2,%eax
  800249:	01 d0                	add    %edx,%eax
  80024b:	c1 e0 03             	shl    $0x3,%eax
  80024e:	01 d0                	add    %edx,%eax
  800250:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800257:	01 d0                	add    %edx,%eax
  800259:	c1 e0 02             	shl    $0x2,%eax
  80025c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800261:	a3 08 30 80 00       	mov    %eax,0x803008

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800266:	a1 08 30 80 00       	mov    0x803008,%eax
  80026b:	8a 40 20             	mov    0x20(%eax),%al
  80026e:	84 c0                	test   %al,%al
  800270:	74 0d                	je     80027f <libmain+0x4c>
		binaryname = myEnv->prog_name;
  800272:	a1 08 30 80 00       	mov    0x803008,%eax
  800277:	83 c0 20             	add    $0x20,%eax
  80027a:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80027f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800283:	7e 0a                	jle    80028f <libmain+0x5c>
		binaryname = argv[0];
  800285:	8b 45 0c             	mov    0xc(%ebp),%eax
  800288:	8b 00                	mov    (%eax),%eax
  80028a:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  80028f:	83 ec 08             	sub    $0x8,%esp
  800292:	ff 75 0c             	pushl  0xc(%ebp)
  800295:	ff 75 08             	pushl  0x8(%ebp)
  800298:	e8 9b fd ff ff       	call   800038 <_main>
  80029d:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8002a0:	a1 00 30 80 00       	mov    0x803000,%eax
  8002a5:	85 c0                	test   %eax,%eax
  8002a7:	0f 84 9f 00 00 00    	je     80034c <libmain+0x119>
	{
		sys_lock_cons();
  8002ad:	e8 a1 0f 00 00       	call   801253 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8002b2:	83 ec 0c             	sub    $0xc,%esp
  8002b5:	68 d8 1f 80 00       	push   $0x801fd8
  8002ba:	e8 8d 01 00 00       	call   80044c <cprintf>
  8002bf:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002c2:	a1 08 30 80 00       	mov    0x803008,%eax
  8002c7:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8002cd:	a1 08 30 80 00       	mov    0x803008,%eax
  8002d2:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8002d8:	83 ec 04             	sub    $0x4,%esp
  8002db:	52                   	push   %edx
  8002dc:	50                   	push   %eax
  8002dd:	68 00 20 80 00       	push   $0x802000
  8002e2:	e8 65 01 00 00       	call   80044c <cprintf>
  8002e7:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002ea:	a1 08 30 80 00       	mov    0x803008,%eax
  8002ef:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8002f5:	a1 08 30 80 00       	mov    0x803008,%eax
  8002fa:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800300:	a1 08 30 80 00       	mov    0x803008,%eax
  800305:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  80030b:	51                   	push   %ecx
  80030c:	52                   	push   %edx
  80030d:	50                   	push   %eax
  80030e:	68 28 20 80 00       	push   $0x802028
  800313:	e8 34 01 00 00       	call   80044c <cprintf>
  800318:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80031b:	a1 08 30 80 00       	mov    0x803008,%eax
  800320:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800326:	83 ec 08             	sub    $0x8,%esp
  800329:	50                   	push   %eax
  80032a:	68 80 20 80 00       	push   $0x802080
  80032f:	e8 18 01 00 00       	call   80044c <cprintf>
  800334:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800337:	83 ec 0c             	sub    $0xc,%esp
  80033a:	68 d8 1f 80 00       	push   $0x801fd8
  80033f:	e8 08 01 00 00       	call   80044c <cprintf>
  800344:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800347:	e8 21 0f 00 00       	call   80126d <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80034c:	e8 19 00 00 00       	call   80036a <exit>
}
  800351:	90                   	nop
  800352:	c9                   	leave  
  800353:	c3                   	ret    

00800354 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800354:	55                   	push   %ebp
  800355:	89 e5                	mov    %esp,%ebp
  800357:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80035a:	83 ec 0c             	sub    $0xc,%esp
  80035d:	6a 00                	push   $0x0
  80035f:	e8 37 11 00 00       	call   80149b <sys_destroy_env>
  800364:	83 c4 10             	add    $0x10,%esp
}
  800367:	90                   	nop
  800368:	c9                   	leave  
  800369:	c3                   	ret    

0080036a <exit>:

void
exit(void)
{
  80036a:	55                   	push   %ebp
  80036b:	89 e5                	mov    %esp,%ebp
  80036d:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800370:	e8 8c 11 00 00       	call   801501 <sys_exit_env>
}
  800375:	90                   	nop
  800376:	c9                   	leave  
  800377:	c3                   	ret    

00800378 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800378:	55                   	push   %ebp
  800379:	89 e5                	mov    %esp,%ebp
  80037b:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80037e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800381:	8b 00                	mov    (%eax),%eax
  800383:	8d 48 01             	lea    0x1(%eax),%ecx
  800386:	8b 55 0c             	mov    0xc(%ebp),%edx
  800389:	89 0a                	mov    %ecx,(%edx)
  80038b:	8b 55 08             	mov    0x8(%ebp),%edx
  80038e:	88 d1                	mov    %dl,%cl
  800390:	8b 55 0c             	mov    0xc(%ebp),%edx
  800393:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800397:	8b 45 0c             	mov    0xc(%ebp),%eax
  80039a:	8b 00                	mov    (%eax),%eax
  80039c:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003a1:	75 2c                	jne    8003cf <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8003a3:	a0 0c 30 80 00       	mov    0x80300c,%al
  8003a8:	0f b6 c0             	movzbl %al,%eax
  8003ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003ae:	8b 12                	mov    (%edx),%edx
  8003b0:	89 d1                	mov    %edx,%ecx
  8003b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003b5:	83 c2 08             	add    $0x8,%edx
  8003b8:	83 ec 04             	sub    $0x4,%esp
  8003bb:	50                   	push   %eax
  8003bc:	51                   	push   %ecx
  8003bd:	52                   	push   %edx
  8003be:	e8 4e 0e 00 00       	call   801211 <sys_cputs>
  8003c3:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8003c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8003cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003d2:	8b 40 04             	mov    0x4(%eax),%eax
  8003d5:	8d 50 01             	lea    0x1(%eax),%edx
  8003d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003db:	89 50 04             	mov    %edx,0x4(%eax)
}
  8003de:	90                   	nop
  8003df:	c9                   	leave  
  8003e0:	c3                   	ret    

008003e1 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8003e1:	55                   	push   %ebp
  8003e2:	89 e5                	mov    %esp,%ebp
  8003e4:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003ea:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003f1:	00 00 00 
	b.cnt = 0;
  8003f4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003fb:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8003fe:	ff 75 0c             	pushl  0xc(%ebp)
  800401:	ff 75 08             	pushl  0x8(%ebp)
  800404:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80040a:	50                   	push   %eax
  80040b:	68 78 03 80 00       	push   $0x800378
  800410:	e8 11 02 00 00       	call   800626 <vprintfmt>
  800415:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800418:	a0 0c 30 80 00       	mov    0x80300c,%al
  80041d:	0f b6 c0             	movzbl %al,%eax
  800420:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800426:	83 ec 04             	sub    $0x4,%esp
  800429:	50                   	push   %eax
  80042a:	52                   	push   %edx
  80042b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800431:	83 c0 08             	add    $0x8,%eax
  800434:	50                   	push   %eax
  800435:	e8 d7 0d 00 00       	call   801211 <sys_cputs>
  80043a:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80043d:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
	return b.cnt;
  800444:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80044a:	c9                   	leave  
  80044b:	c3                   	ret    

0080044c <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80044c:	55                   	push   %ebp
  80044d:	89 e5                	mov    %esp,%ebp
  80044f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800452:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
	va_start(ap, fmt);
  800459:	8d 45 0c             	lea    0xc(%ebp),%eax
  80045c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80045f:	8b 45 08             	mov    0x8(%ebp),%eax
  800462:	83 ec 08             	sub    $0x8,%esp
  800465:	ff 75 f4             	pushl  -0xc(%ebp)
  800468:	50                   	push   %eax
  800469:	e8 73 ff ff ff       	call   8003e1 <vcprintf>
  80046e:	83 c4 10             	add    $0x10,%esp
  800471:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800474:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800477:	c9                   	leave  
  800478:	c3                   	ret    

00800479 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800479:	55                   	push   %ebp
  80047a:	89 e5                	mov    %esp,%ebp
  80047c:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80047f:	e8 cf 0d 00 00       	call   801253 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800484:	8d 45 0c             	lea    0xc(%ebp),%eax
  800487:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80048a:	8b 45 08             	mov    0x8(%ebp),%eax
  80048d:	83 ec 08             	sub    $0x8,%esp
  800490:	ff 75 f4             	pushl  -0xc(%ebp)
  800493:	50                   	push   %eax
  800494:	e8 48 ff ff ff       	call   8003e1 <vcprintf>
  800499:	83 c4 10             	add    $0x10,%esp
  80049c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80049f:	e8 c9 0d 00 00       	call   80126d <sys_unlock_cons>
	return cnt;
  8004a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004a7:	c9                   	leave  
  8004a8:	c3                   	ret    

008004a9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004a9:	55                   	push   %ebp
  8004aa:	89 e5                	mov    %esp,%ebp
  8004ac:	53                   	push   %ebx
  8004ad:	83 ec 14             	sub    $0x14,%esp
  8004b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8004b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8004b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004bc:	8b 45 18             	mov    0x18(%ebp),%eax
  8004bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8004c4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004c7:	77 55                	ja     80051e <printnum+0x75>
  8004c9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004cc:	72 05                	jb     8004d3 <printnum+0x2a>
  8004ce:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8004d1:	77 4b                	ja     80051e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004d3:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004d6:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8004d9:	8b 45 18             	mov    0x18(%ebp),%eax
  8004dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8004e1:	52                   	push   %edx
  8004e2:	50                   	push   %eax
  8004e3:	ff 75 f4             	pushl  -0xc(%ebp)
  8004e6:	ff 75 f0             	pushl  -0x10(%ebp)
  8004e9:	e8 32 16 00 00       	call   801b20 <__udivdi3>
  8004ee:	83 c4 10             	add    $0x10,%esp
  8004f1:	83 ec 04             	sub    $0x4,%esp
  8004f4:	ff 75 20             	pushl  0x20(%ebp)
  8004f7:	53                   	push   %ebx
  8004f8:	ff 75 18             	pushl  0x18(%ebp)
  8004fb:	52                   	push   %edx
  8004fc:	50                   	push   %eax
  8004fd:	ff 75 0c             	pushl  0xc(%ebp)
  800500:	ff 75 08             	pushl  0x8(%ebp)
  800503:	e8 a1 ff ff ff       	call   8004a9 <printnum>
  800508:	83 c4 20             	add    $0x20,%esp
  80050b:	eb 1a                	jmp    800527 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80050d:	83 ec 08             	sub    $0x8,%esp
  800510:	ff 75 0c             	pushl  0xc(%ebp)
  800513:	ff 75 20             	pushl  0x20(%ebp)
  800516:	8b 45 08             	mov    0x8(%ebp),%eax
  800519:	ff d0                	call   *%eax
  80051b:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80051e:	ff 4d 1c             	decl   0x1c(%ebp)
  800521:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800525:	7f e6                	jg     80050d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800527:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80052a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80052f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800532:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800535:	53                   	push   %ebx
  800536:	51                   	push   %ecx
  800537:	52                   	push   %edx
  800538:	50                   	push   %eax
  800539:	e8 f2 16 00 00       	call   801c30 <__umoddi3>
  80053e:	83 c4 10             	add    $0x10,%esp
  800541:	05 b4 22 80 00       	add    $0x8022b4,%eax
  800546:	8a 00                	mov    (%eax),%al
  800548:	0f be c0             	movsbl %al,%eax
  80054b:	83 ec 08             	sub    $0x8,%esp
  80054e:	ff 75 0c             	pushl  0xc(%ebp)
  800551:	50                   	push   %eax
  800552:	8b 45 08             	mov    0x8(%ebp),%eax
  800555:	ff d0                	call   *%eax
  800557:	83 c4 10             	add    $0x10,%esp
}
  80055a:	90                   	nop
  80055b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80055e:	c9                   	leave  
  80055f:	c3                   	ret    

00800560 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800560:	55                   	push   %ebp
  800561:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800563:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800567:	7e 1c                	jle    800585 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800569:	8b 45 08             	mov    0x8(%ebp),%eax
  80056c:	8b 00                	mov    (%eax),%eax
  80056e:	8d 50 08             	lea    0x8(%eax),%edx
  800571:	8b 45 08             	mov    0x8(%ebp),%eax
  800574:	89 10                	mov    %edx,(%eax)
  800576:	8b 45 08             	mov    0x8(%ebp),%eax
  800579:	8b 00                	mov    (%eax),%eax
  80057b:	83 e8 08             	sub    $0x8,%eax
  80057e:	8b 50 04             	mov    0x4(%eax),%edx
  800581:	8b 00                	mov    (%eax),%eax
  800583:	eb 40                	jmp    8005c5 <getuint+0x65>
	else if (lflag)
  800585:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800589:	74 1e                	je     8005a9 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80058b:	8b 45 08             	mov    0x8(%ebp),%eax
  80058e:	8b 00                	mov    (%eax),%eax
  800590:	8d 50 04             	lea    0x4(%eax),%edx
  800593:	8b 45 08             	mov    0x8(%ebp),%eax
  800596:	89 10                	mov    %edx,(%eax)
  800598:	8b 45 08             	mov    0x8(%ebp),%eax
  80059b:	8b 00                	mov    (%eax),%eax
  80059d:	83 e8 04             	sub    $0x4,%eax
  8005a0:	8b 00                	mov    (%eax),%eax
  8005a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8005a7:	eb 1c                	jmp    8005c5 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8005a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ac:	8b 00                	mov    (%eax),%eax
  8005ae:	8d 50 04             	lea    0x4(%eax),%edx
  8005b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b4:	89 10                	mov    %edx,(%eax)
  8005b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b9:	8b 00                	mov    (%eax),%eax
  8005bb:	83 e8 04             	sub    $0x4,%eax
  8005be:	8b 00                	mov    (%eax),%eax
  8005c0:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005c5:	5d                   	pop    %ebp
  8005c6:	c3                   	ret    

008005c7 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005c7:	55                   	push   %ebp
  8005c8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005ca:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005ce:	7e 1c                	jle    8005ec <getint+0x25>
		return va_arg(*ap, long long);
  8005d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d3:	8b 00                	mov    (%eax),%eax
  8005d5:	8d 50 08             	lea    0x8(%eax),%edx
  8005d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005db:	89 10                	mov    %edx,(%eax)
  8005dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e0:	8b 00                	mov    (%eax),%eax
  8005e2:	83 e8 08             	sub    $0x8,%eax
  8005e5:	8b 50 04             	mov    0x4(%eax),%edx
  8005e8:	8b 00                	mov    (%eax),%eax
  8005ea:	eb 38                	jmp    800624 <getint+0x5d>
	else if (lflag)
  8005ec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005f0:	74 1a                	je     80060c <getint+0x45>
		return va_arg(*ap, long);
  8005f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f5:	8b 00                	mov    (%eax),%eax
  8005f7:	8d 50 04             	lea    0x4(%eax),%edx
  8005fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fd:	89 10                	mov    %edx,(%eax)
  8005ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800602:	8b 00                	mov    (%eax),%eax
  800604:	83 e8 04             	sub    $0x4,%eax
  800607:	8b 00                	mov    (%eax),%eax
  800609:	99                   	cltd   
  80060a:	eb 18                	jmp    800624 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80060c:	8b 45 08             	mov    0x8(%ebp),%eax
  80060f:	8b 00                	mov    (%eax),%eax
  800611:	8d 50 04             	lea    0x4(%eax),%edx
  800614:	8b 45 08             	mov    0x8(%ebp),%eax
  800617:	89 10                	mov    %edx,(%eax)
  800619:	8b 45 08             	mov    0x8(%ebp),%eax
  80061c:	8b 00                	mov    (%eax),%eax
  80061e:	83 e8 04             	sub    $0x4,%eax
  800621:	8b 00                	mov    (%eax),%eax
  800623:	99                   	cltd   
}
  800624:	5d                   	pop    %ebp
  800625:	c3                   	ret    

00800626 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800626:	55                   	push   %ebp
  800627:	89 e5                	mov    %esp,%ebp
  800629:	56                   	push   %esi
  80062a:	53                   	push   %ebx
  80062b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80062e:	eb 17                	jmp    800647 <vprintfmt+0x21>
			if (ch == '\0')
  800630:	85 db                	test   %ebx,%ebx
  800632:	0f 84 c1 03 00 00    	je     8009f9 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800638:	83 ec 08             	sub    $0x8,%esp
  80063b:	ff 75 0c             	pushl  0xc(%ebp)
  80063e:	53                   	push   %ebx
  80063f:	8b 45 08             	mov    0x8(%ebp),%eax
  800642:	ff d0                	call   *%eax
  800644:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800647:	8b 45 10             	mov    0x10(%ebp),%eax
  80064a:	8d 50 01             	lea    0x1(%eax),%edx
  80064d:	89 55 10             	mov    %edx,0x10(%ebp)
  800650:	8a 00                	mov    (%eax),%al
  800652:	0f b6 d8             	movzbl %al,%ebx
  800655:	83 fb 25             	cmp    $0x25,%ebx
  800658:	75 d6                	jne    800630 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80065a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80065e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800665:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80066c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800673:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80067a:	8b 45 10             	mov    0x10(%ebp),%eax
  80067d:	8d 50 01             	lea    0x1(%eax),%edx
  800680:	89 55 10             	mov    %edx,0x10(%ebp)
  800683:	8a 00                	mov    (%eax),%al
  800685:	0f b6 d8             	movzbl %al,%ebx
  800688:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80068b:	83 f8 5b             	cmp    $0x5b,%eax
  80068e:	0f 87 3d 03 00 00    	ja     8009d1 <vprintfmt+0x3ab>
  800694:	8b 04 85 d8 22 80 00 	mov    0x8022d8(,%eax,4),%eax
  80069b:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80069d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8006a1:	eb d7                	jmp    80067a <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006a3:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8006a7:	eb d1                	jmp    80067a <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006a9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8006b0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006b3:	89 d0                	mov    %edx,%eax
  8006b5:	c1 e0 02             	shl    $0x2,%eax
  8006b8:	01 d0                	add    %edx,%eax
  8006ba:	01 c0                	add    %eax,%eax
  8006bc:	01 d8                	add    %ebx,%eax
  8006be:	83 e8 30             	sub    $0x30,%eax
  8006c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8006c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8006c7:	8a 00                	mov    (%eax),%al
  8006c9:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006cc:	83 fb 2f             	cmp    $0x2f,%ebx
  8006cf:	7e 3e                	jle    80070f <vprintfmt+0xe9>
  8006d1:	83 fb 39             	cmp    $0x39,%ebx
  8006d4:	7f 39                	jg     80070f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006d6:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006d9:	eb d5                	jmp    8006b0 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006db:	8b 45 14             	mov    0x14(%ebp),%eax
  8006de:	83 c0 04             	add    $0x4,%eax
  8006e1:	89 45 14             	mov    %eax,0x14(%ebp)
  8006e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e7:	83 e8 04             	sub    $0x4,%eax
  8006ea:	8b 00                	mov    (%eax),%eax
  8006ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8006ef:	eb 1f                	jmp    800710 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8006f1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006f5:	79 83                	jns    80067a <vprintfmt+0x54>
				width = 0;
  8006f7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8006fe:	e9 77 ff ff ff       	jmp    80067a <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800703:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80070a:	e9 6b ff ff ff       	jmp    80067a <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80070f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800710:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800714:	0f 89 60 ff ff ff    	jns    80067a <vprintfmt+0x54>
				width = precision, precision = -1;
  80071a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80071d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800720:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800727:	e9 4e ff ff ff       	jmp    80067a <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80072c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80072f:	e9 46 ff ff ff       	jmp    80067a <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800734:	8b 45 14             	mov    0x14(%ebp),%eax
  800737:	83 c0 04             	add    $0x4,%eax
  80073a:	89 45 14             	mov    %eax,0x14(%ebp)
  80073d:	8b 45 14             	mov    0x14(%ebp),%eax
  800740:	83 e8 04             	sub    $0x4,%eax
  800743:	8b 00                	mov    (%eax),%eax
  800745:	83 ec 08             	sub    $0x8,%esp
  800748:	ff 75 0c             	pushl  0xc(%ebp)
  80074b:	50                   	push   %eax
  80074c:	8b 45 08             	mov    0x8(%ebp),%eax
  80074f:	ff d0                	call   *%eax
  800751:	83 c4 10             	add    $0x10,%esp
			break;
  800754:	e9 9b 02 00 00       	jmp    8009f4 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800759:	8b 45 14             	mov    0x14(%ebp),%eax
  80075c:	83 c0 04             	add    $0x4,%eax
  80075f:	89 45 14             	mov    %eax,0x14(%ebp)
  800762:	8b 45 14             	mov    0x14(%ebp),%eax
  800765:	83 e8 04             	sub    $0x4,%eax
  800768:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80076a:	85 db                	test   %ebx,%ebx
  80076c:	79 02                	jns    800770 <vprintfmt+0x14a>
				err = -err;
  80076e:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800770:	83 fb 64             	cmp    $0x64,%ebx
  800773:	7f 0b                	jg     800780 <vprintfmt+0x15a>
  800775:	8b 34 9d 20 21 80 00 	mov    0x802120(,%ebx,4),%esi
  80077c:	85 f6                	test   %esi,%esi
  80077e:	75 19                	jne    800799 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800780:	53                   	push   %ebx
  800781:	68 c5 22 80 00       	push   $0x8022c5
  800786:	ff 75 0c             	pushl  0xc(%ebp)
  800789:	ff 75 08             	pushl  0x8(%ebp)
  80078c:	e8 70 02 00 00       	call   800a01 <printfmt>
  800791:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800794:	e9 5b 02 00 00       	jmp    8009f4 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800799:	56                   	push   %esi
  80079a:	68 ce 22 80 00       	push   $0x8022ce
  80079f:	ff 75 0c             	pushl  0xc(%ebp)
  8007a2:	ff 75 08             	pushl  0x8(%ebp)
  8007a5:	e8 57 02 00 00       	call   800a01 <printfmt>
  8007aa:	83 c4 10             	add    $0x10,%esp
			break;
  8007ad:	e9 42 02 00 00       	jmp    8009f4 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b5:	83 c0 04             	add    $0x4,%eax
  8007b8:	89 45 14             	mov    %eax,0x14(%ebp)
  8007bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007be:	83 e8 04             	sub    $0x4,%eax
  8007c1:	8b 30                	mov    (%eax),%esi
  8007c3:	85 f6                	test   %esi,%esi
  8007c5:	75 05                	jne    8007cc <vprintfmt+0x1a6>
				p = "(null)";
  8007c7:	be d1 22 80 00       	mov    $0x8022d1,%esi
			if (width > 0 && padc != '-')
  8007cc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007d0:	7e 6d                	jle    80083f <vprintfmt+0x219>
  8007d2:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8007d6:	74 67                	je     80083f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007db:	83 ec 08             	sub    $0x8,%esp
  8007de:	50                   	push   %eax
  8007df:	56                   	push   %esi
  8007e0:	e8 1e 03 00 00       	call   800b03 <strnlen>
  8007e5:	83 c4 10             	add    $0x10,%esp
  8007e8:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8007eb:	eb 16                	jmp    800803 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8007ed:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8007f1:	83 ec 08             	sub    $0x8,%esp
  8007f4:	ff 75 0c             	pushl  0xc(%ebp)
  8007f7:	50                   	push   %eax
  8007f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fb:	ff d0                	call   *%eax
  8007fd:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800800:	ff 4d e4             	decl   -0x1c(%ebp)
  800803:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800807:	7f e4                	jg     8007ed <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800809:	eb 34                	jmp    80083f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80080b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80080f:	74 1c                	je     80082d <vprintfmt+0x207>
  800811:	83 fb 1f             	cmp    $0x1f,%ebx
  800814:	7e 05                	jle    80081b <vprintfmt+0x1f5>
  800816:	83 fb 7e             	cmp    $0x7e,%ebx
  800819:	7e 12                	jle    80082d <vprintfmt+0x207>
					putch('?', putdat);
  80081b:	83 ec 08             	sub    $0x8,%esp
  80081e:	ff 75 0c             	pushl  0xc(%ebp)
  800821:	6a 3f                	push   $0x3f
  800823:	8b 45 08             	mov    0x8(%ebp),%eax
  800826:	ff d0                	call   *%eax
  800828:	83 c4 10             	add    $0x10,%esp
  80082b:	eb 0f                	jmp    80083c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80082d:	83 ec 08             	sub    $0x8,%esp
  800830:	ff 75 0c             	pushl  0xc(%ebp)
  800833:	53                   	push   %ebx
  800834:	8b 45 08             	mov    0x8(%ebp),%eax
  800837:	ff d0                	call   *%eax
  800839:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80083c:	ff 4d e4             	decl   -0x1c(%ebp)
  80083f:	89 f0                	mov    %esi,%eax
  800841:	8d 70 01             	lea    0x1(%eax),%esi
  800844:	8a 00                	mov    (%eax),%al
  800846:	0f be d8             	movsbl %al,%ebx
  800849:	85 db                	test   %ebx,%ebx
  80084b:	74 24                	je     800871 <vprintfmt+0x24b>
  80084d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800851:	78 b8                	js     80080b <vprintfmt+0x1e5>
  800853:	ff 4d e0             	decl   -0x20(%ebp)
  800856:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80085a:	79 af                	jns    80080b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80085c:	eb 13                	jmp    800871 <vprintfmt+0x24b>
				putch(' ', putdat);
  80085e:	83 ec 08             	sub    $0x8,%esp
  800861:	ff 75 0c             	pushl  0xc(%ebp)
  800864:	6a 20                	push   $0x20
  800866:	8b 45 08             	mov    0x8(%ebp),%eax
  800869:	ff d0                	call   *%eax
  80086b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80086e:	ff 4d e4             	decl   -0x1c(%ebp)
  800871:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800875:	7f e7                	jg     80085e <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800877:	e9 78 01 00 00       	jmp    8009f4 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80087c:	83 ec 08             	sub    $0x8,%esp
  80087f:	ff 75 e8             	pushl  -0x18(%ebp)
  800882:	8d 45 14             	lea    0x14(%ebp),%eax
  800885:	50                   	push   %eax
  800886:	e8 3c fd ff ff       	call   8005c7 <getint>
  80088b:	83 c4 10             	add    $0x10,%esp
  80088e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800891:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800894:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800897:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80089a:	85 d2                	test   %edx,%edx
  80089c:	79 23                	jns    8008c1 <vprintfmt+0x29b>
				putch('-', putdat);
  80089e:	83 ec 08             	sub    $0x8,%esp
  8008a1:	ff 75 0c             	pushl  0xc(%ebp)
  8008a4:	6a 2d                	push   $0x2d
  8008a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a9:	ff d0                	call   *%eax
  8008ab:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8008ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008b4:	f7 d8                	neg    %eax
  8008b6:	83 d2 00             	adc    $0x0,%edx
  8008b9:	f7 da                	neg    %edx
  8008bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008be:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8008c1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008c8:	e9 bc 00 00 00       	jmp    800989 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008cd:	83 ec 08             	sub    $0x8,%esp
  8008d0:	ff 75 e8             	pushl  -0x18(%ebp)
  8008d3:	8d 45 14             	lea    0x14(%ebp),%eax
  8008d6:	50                   	push   %eax
  8008d7:	e8 84 fc ff ff       	call   800560 <getuint>
  8008dc:	83 c4 10             	add    $0x10,%esp
  8008df:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008e2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8008e5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008ec:	e9 98 00 00 00       	jmp    800989 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8008f1:	83 ec 08             	sub    $0x8,%esp
  8008f4:	ff 75 0c             	pushl  0xc(%ebp)
  8008f7:	6a 58                	push   $0x58
  8008f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fc:	ff d0                	call   *%eax
  8008fe:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800901:	83 ec 08             	sub    $0x8,%esp
  800904:	ff 75 0c             	pushl  0xc(%ebp)
  800907:	6a 58                	push   $0x58
  800909:	8b 45 08             	mov    0x8(%ebp),%eax
  80090c:	ff d0                	call   *%eax
  80090e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800911:	83 ec 08             	sub    $0x8,%esp
  800914:	ff 75 0c             	pushl  0xc(%ebp)
  800917:	6a 58                	push   $0x58
  800919:	8b 45 08             	mov    0x8(%ebp),%eax
  80091c:	ff d0                	call   *%eax
  80091e:	83 c4 10             	add    $0x10,%esp
			break;
  800921:	e9 ce 00 00 00       	jmp    8009f4 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800926:	83 ec 08             	sub    $0x8,%esp
  800929:	ff 75 0c             	pushl  0xc(%ebp)
  80092c:	6a 30                	push   $0x30
  80092e:	8b 45 08             	mov    0x8(%ebp),%eax
  800931:	ff d0                	call   *%eax
  800933:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800936:	83 ec 08             	sub    $0x8,%esp
  800939:	ff 75 0c             	pushl  0xc(%ebp)
  80093c:	6a 78                	push   $0x78
  80093e:	8b 45 08             	mov    0x8(%ebp),%eax
  800941:	ff d0                	call   *%eax
  800943:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800946:	8b 45 14             	mov    0x14(%ebp),%eax
  800949:	83 c0 04             	add    $0x4,%eax
  80094c:	89 45 14             	mov    %eax,0x14(%ebp)
  80094f:	8b 45 14             	mov    0x14(%ebp),%eax
  800952:	83 e8 04             	sub    $0x4,%eax
  800955:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800957:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80095a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800961:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800968:	eb 1f                	jmp    800989 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80096a:	83 ec 08             	sub    $0x8,%esp
  80096d:	ff 75 e8             	pushl  -0x18(%ebp)
  800970:	8d 45 14             	lea    0x14(%ebp),%eax
  800973:	50                   	push   %eax
  800974:	e8 e7 fb ff ff       	call   800560 <getuint>
  800979:	83 c4 10             	add    $0x10,%esp
  80097c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80097f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800982:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800989:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80098d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800990:	83 ec 04             	sub    $0x4,%esp
  800993:	52                   	push   %edx
  800994:	ff 75 e4             	pushl  -0x1c(%ebp)
  800997:	50                   	push   %eax
  800998:	ff 75 f4             	pushl  -0xc(%ebp)
  80099b:	ff 75 f0             	pushl  -0x10(%ebp)
  80099e:	ff 75 0c             	pushl  0xc(%ebp)
  8009a1:	ff 75 08             	pushl  0x8(%ebp)
  8009a4:	e8 00 fb ff ff       	call   8004a9 <printnum>
  8009a9:	83 c4 20             	add    $0x20,%esp
			break;
  8009ac:	eb 46                	jmp    8009f4 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009ae:	83 ec 08             	sub    $0x8,%esp
  8009b1:	ff 75 0c             	pushl  0xc(%ebp)
  8009b4:	53                   	push   %ebx
  8009b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b8:	ff d0                	call   *%eax
  8009ba:	83 c4 10             	add    $0x10,%esp
			break;
  8009bd:	eb 35                	jmp    8009f4 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8009bf:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
			break;
  8009c6:	eb 2c                	jmp    8009f4 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8009c8:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
			break;
  8009cf:	eb 23                	jmp    8009f4 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009d1:	83 ec 08             	sub    $0x8,%esp
  8009d4:	ff 75 0c             	pushl  0xc(%ebp)
  8009d7:	6a 25                	push   $0x25
  8009d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009dc:	ff d0                	call   *%eax
  8009de:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009e1:	ff 4d 10             	decl   0x10(%ebp)
  8009e4:	eb 03                	jmp    8009e9 <vprintfmt+0x3c3>
  8009e6:	ff 4d 10             	decl   0x10(%ebp)
  8009e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ec:	48                   	dec    %eax
  8009ed:	8a 00                	mov    (%eax),%al
  8009ef:	3c 25                	cmp    $0x25,%al
  8009f1:	75 f3                	jne    8009e6 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8009f3:	90                   	nop
		}
	}
  8009f4:	e9 35 fc ff ff       	jmp    80062e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8009f9:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8009fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009fd:	5b                   	pop    %ebx
  8009fe:	5e                   	pop    %esi
  8009ff:	5d                   	pop    %ebp
  800a00:	c3                   	ret    

00800a01 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a01:	55                   	push   %ebp
  800a02:	89 e5                	mov    %esp,%ebp
  800a04:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a07:	8d 45 10             	lea    0x10(%ebp),%eax
  800a0a:	83 c0 04             	add    $0x4,%eax
  800a0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a10:	8b 45 10             	mov    0x10(%ebp),%eax
  800a13:	ff 75 f4             	pushl  -0xc(%ebp)
  800a16:	50                   	push   %eax
  800a17:	ff 75 0c             	pushl  0xc(%ebp)
  800a1a:	ff 75 08             	pushl  0x8(%ebp)
  800a1d:	e8 04 fc ff ff       	call   800626 <vprintfmt>
  800a22:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a25:	90                   	nop
  800a26:	c9                   	leave  
  800a27:	c3                   	ret    

00800a28 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a28:	55                   	push   %ebp
  800a29:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2e:	8b 40 08             	mov    0x8(%eax),%eax
  800a31:	8d 50 01             	lea    0x1(%eax),%edx
  800a34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a37:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3d:	8b 10                	mov    (%eax),%edx
  800a3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a42:	8b 40 04             	mov    0x4(%eax),%eax
  800a45:	39 c2                	cmp    %eax,%edx
  800a47:	73 12                	jae    800a5b <sprintputch+0x33>
		*b->buf++ = ch;
  800a49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a4c:	8b 00                	mov    (%eax),%eax
  800a4e:	8d 48 01             	lea    0x1(%eax),%ecx
  800a51:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a54:	89 0a                	mov    %ecx,(%edx)
  800a56:	8b 55 08             	mov    0x8(%ebp),%edx
  800a59:	88 10                	mov    %dl,(%eax)
}
  800a5b:	90                   	nop
  800a5c:	5d                   	pop    %ebp
  800a5d:	c3                   	ret    

00800a5e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a5e:	55                   	push   %ebp
  800a5f:	89 e5                	mov    %esp,%ebp
  800a61:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a64:	8b 45 08             	mov    0x8(%ebp),%eax
  800a67:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a70:	8b 45 08             	mov    0x8(%ebp),%eax
  800a73:	01 d0                	add    %edx,%eax
  800a75:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a78:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a7f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a83:	74 06                	je     800a8b <vsnprintf+0x2d>
  800a85:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a89:	7f 07                	jg     800a92 <vsnprintf+0x34>
		return -E_INVAL;
  800a8b:	b8 03 00 00 00       	mov    $0x3,%eax
  800a90:	eb 20                	jmp    800ab2 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a92:	ff 75 14             	pushl  0x14(%ebp)
  800a95:	ff 75 10             	pushl  0x10(%ebp)
  800a98:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a9b:	50                   	push   %eax
  800a9c:	68 28 0a 80 00       	push   $0x800a28
  800aa1:	e8 80 fb ff ff       	call   800626 <vprintfmt>
  800aa6:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800aa9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aac:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ab2:	c9                   	leave  
  800ab3:	c3                   	ret    

00800ab4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ab4:	55                   	push   %ebp
  800ab5:	89 e5                	mov    %esp,%ebp
  800ab7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800aba:	8d 45 10             	lea    0x10(%ebp),%eax
  800abd:	83 c0 04             	add    $0x4,%eax
  800ac0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ac3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ac6:	ff 75 f4             	pushl  -0xc(%ebp)
  800ac9:	50                   	push   %eax
  800aca:	ff 75 0c             	pushl  0xc(%ebp)
  800acd:	ff 75 08             	pushl  0x8(%ebp)
  800ad0:	e8 89 ff ff ff       	call   800a5e <vsnprintf>
  800ad5:	83 c4 10             	add    $0x10,%esp
  800ad8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800adb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ade:	c9                   	leave  
  800adf:	c3                   	ret    

00800ae0 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800ae0:	55                   	push   %ebp
  800ae1:	89 e5                	mov    %esp,%ebp
  800ae3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ae6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800aed:	eb 06                	jmp    800af5 <strlen+0x15>
		n++;
  800aef:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800af2:	ff 45 08             	incl   0x8(%ebp)
  800af5:	8b 45 08             	mov    0x8(%ebp),%eax
  800af8:	8a 00                	mov    (%eax),%al
  800afa:	84 c0                	test   %al,%al
  800afc:	75 f1                	jne    800aef <strlen+0xf>
		n++;
	return n;
  800afe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b01:	c9                   	leave  
  800b02:	c3                   	ret    

00800b03 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800b03:	55                   	push   %ebp
  800b04:	89 e5                	mov    %esp,%ebp
  800b06:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b09:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b10:	eb 09                	jmp    800b1b <strnlen+0x18>
		n++;
  800b12:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b15:	ff 45 08             	incl   0x8(%ebp)
  800b18:	ff 4d 0c             	decl   0xc(%ebp)
  800b1b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b1f:	74 09                	je     800b2a <strnlen+0x27>
  800b21:	8b 45 08             	mov    0x8(%ebp),%eax
  800b24:	8a 00                	mov    (%eax),%al
  800b26:	84 c0                	test   %al,%al
  800b28:	75 e8                	jne    800b12 <strnlen+0xf>
		n++;
	return n;
  800b2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b2d:	c9                   	leave  
  800b2e:	c3                   	ret    

00800b2f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b2f:	55                   	push   %ebp
  800b30:	89 e5                	mov    %esp,%ebp
  800b32:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b35:	8b 45 08             	mov    0x8(%ebp),%eax
  800b38:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b3b:	90                   	nop
  800b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3f:	8d 50 01             	lea    0x1(%eax),%edx
  800b42:	89 55 08             	mov    %edx,0x8(%ebp)
  800b45:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b48:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b4b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b4e:	8a 12                	mov    (%edx),%dl
  800b50:	88 10                	mov    %dl,(%eax)
  800b52:	8a 00                	mov    (%eax),%al
  800b54:	84 c0                	test   %al,%al
  800b56:	75 e4                	jne    800b3c <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b58:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b5b:	c9                   	leave  
  800b5c:	c3                   	ret    

00800b5d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b5d:	55                   	push   %ebp
  800b5e:	89 e5                	mov    %esp,%ebp
  800b60:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b63:	8b 45 08             	mov    0x8(%ebp),%eax
  800b66:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b69:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b70:	eb 1f                	jmp    800b91 <strncpy+0x34>
		*dst++ = *src;
  800b72:	8b 45 08             	mov    0x8(%ebp),%eax
  800b75:	8d 50 01             	lea    0x1(%eax),%edx
  800b78:	89 55 08             	mov    %edx,0x8(%ebp)
  800b7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b7e:	8a 12                	mov    (%edx),%dl
  800b80:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b85:	8a 00                	mov    (%eax),%al
  800b87:	84 c0                	test   %al,%al
  800b89:	74 03                	je     800b8e <strncpy+0x31>
			src++;
  800b8b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b8e:	ff 45 fc             	incl   -0x4(%ebp)
  800b91:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b94:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b97:	72 d9                	jb     800b72 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800b99:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800b9c:	c9                   	leave  
  800b9d:	c3                   	ret    

00800b9e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800b9e:	55                   	push   %ebp
  800b9f:	89 e5                	mov    %esp,%ebp
  800ba1:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800baa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bae:	74 30                	je     800be0 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800bb0:	eb 16                	jmp    800bc8 <strlcpy+0x2a>
			*dst++ = *src++;
  800bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb5:	8d 50 01             	lea    0x1(%eax),%edx
  800bb8:	89 55 08             	mov    %edx,0x8(%ebp)
  800bbb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bbe:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bc1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bc4:	8a 12                	mov    (%edx),%dl
  800bc6:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800bc8:	ff 4d 10             	decl   0x10(%ebp)
  800bcb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bcf:	74 09                	je     800bda <strlcpy+0x3c>
  800bd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd4:	8a 00                	mov    (%eax),%al
  800bd6:	84 c0                	test   %al,%al
  800bd8:	75 d8                	jne    800bb2 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800bda:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdd:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800be0:	8b 55 08             	mov    0x8(%ebp),%edx
  800be3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800be6:	29 c2                	sub    %eax,%edx
  800be8:	89 d0                	mov    %edx,%eax
}
  800bea:	c9                   	leave  
  800beb:	c3                   	ret    

00800bec <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800bec:	55                   	push   %ebp
  800bed:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800bef:	eb 06                	jmp    800bf7 <strcmp+0xb>
		p++, q++;
  800bf1:	ff 45 08             	incl   0x8(%ebp)
  800bf4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfa:	8a 00                	mov    (%eax),%al
  800bfc:	84 c0                	test   %al,%al
  800bfe:	74 0e                	je     800c0e <strcmp+0x22>
  800c00:	8b 45 08             	mov    0x8(%ebp),%eax
  800c03:	8a 10                	mov    (%eax),%dl
  800c05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c08:	8a 00                	mov    (%eax),%al
  800c0a:	38 c2                	cmp    %al,%dl
  800c0c:	74 e3                	je     800bf1 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c11:	8a 00                	mov    (%eax),%al
  800c13:	0f b6 d0             	movzbl %al,%edx
  800c16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c19:	8a 00                	mov    (%eax),%al
  800c1b:	0f b6 c0             	movzbl %al,%eax
  800c1e:	29 c2                	sub    %eax,%edx
  800c20:	89 d0                	mov    %edx,%eax
}
  800c22:	5d                   	pop    %ebp
  800c23:	c3                   	ret    

00800c24 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c24:	55                   	push   %ebp
  800c25:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c27:	eb 09                	jmp    800c32 <strncmp+0xe>
		n--, p++, q++;
  800c29:	ff 4d 10             	decl   0x10(%ebp)
  800c2c:	ff 45 08             	incl   0x8(%ebp)
  800c2f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c32:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c36:	74 17                	je     800c4f <strncmp+0x2b>
  800c38:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3b:	8a 00                	mov    (%eax),%al
  800c3d:	84 c0                	test   %al,%al
  800c3f:	74 0e                	je     800c4f <strncmp+0x2b>
  800c41:	8b 45 08             	mov    0x8(%ebp),%eax
  800c44:	8a 10                	mov    (%eax),%dl
  800c46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c49:	8a 00                	mov    (%eax),%al
  800c4b:	38 c2                	cmp    %al,%dl
  800c4d:	74 da                	je     800c29 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c4f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c53:	75 07                	jne    800c5c <strncmp+0x38>
		return 0;
  800c55:	b8 00 00 00 00       	mov    $0x0,%eax
  800c5a:	eb 14                	jmp    800c70 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5f:	8a 00                	mov    (%eax),%al
  800c61:	0f b6 d0             	movzbl %al,%edx
  800c64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c67:	8a 00                	mov    (%eax),%al
  800c69:	0f b6 c0             	movzbl %al,%eax
  800c6c:	29 c2                	sub    %eax,%edx
  800c6e:	89 d0                	mov    %edx,%eax
}
  800c70:	5d                   	pop    %ebp
  800c71:	c3                   	ret    

00800c72 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c72:	55                   	push   %ebp
  800c73:	89 e5                	mov    %esp,%ebp
  800c75:	83 ec 04             	sub    $0x4,%esp
  800c78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c7e:	eb 12                	jmp    800c92 <strchr+0x20>
		if (*s == c)
  800c80:	8b 45 08             	mov    0x8(%ebp),%eax
  800c83:	8a 00                	mov    (%eax),%al
  800c85:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c88:	75 05                	jne    800c8f <strchr+0x1d>
			return (char *) s;
  800c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8d:	eb 11                	jmp    800ca0 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c8f:	ff 45 08             	incl   0x8(%ebp)
  800c92:	8b 45 08             	mov    0x8(%ebp),%eax
  800c95:	8a 00                	mov    (%eax),%al
  800c97:	84 c0                	test   %al,%al
  800c99:	75 e5                	jne    800c80 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800c9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ca0:	c9                   	leave  
  800ca1:	c3                   	ret    

00800ca2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ca2:	55                   	push   %ebp
  800ca3:	89 e5                	mov    %esp,%ebp
  800ca5:	83 ec 04             	sub    $0x4,%esp
  800ca8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cab:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800cae:	eb 0d                	jmp    800cbd <strfind+0x1b>
		if (*s == c)
  800cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb3:	8a 00                	mov    (%eax),%al
  800cb5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cb8:	74 0e                	je     800cc8 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800cba:	ff 45 08             	incl   0x8(%ebp)
  800cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc0:	8a 00                	mov    (%eax),%al
  800cc2:	84 c0                	test   %al,%al
  800cc4:	75 ea                	jne    800cb0 <strfind+0xe>
  800cc6:	eb 01                	jmp    800cc9 <strfind+0x27>
		if (*s == c)
			break;
  800cc8:	90                   	nop
	return (char *) s;
  800cc9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ccc:	c9                   	leave  
  800ccd:	c3                   	ret    

00800cce <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800cce:	55                   	push   %ebp
  800ccf:	89 e5                	mov    %esp,%ebp
  800cd1:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800cda:	8b 45 10             	mov    0x10(%ebp),%eax
  800cdd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ce0:	eb 0e                	jmp    800cf0 <memset+0x22>
		*p++ = c;
  800ce2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ce5:	8d 50 01             	lea    0x1(%eax),%edx
  800ce8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ceb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cee:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800cf0:	ff 4d f8             	decl   -0x8(%ebp)
  800cf3:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800cf7:	79 e9                	jns    800ce2 <memset+0x14>
		*p++ = c;

	return v;
  800cf9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cfc:	c9                   	leave  
  800cfd:	c3                   	ret    

00800cfe <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800cfe:	55                   	push   %ebp
  800cff:	89 e5                	mov    %esp,%ebp
  800d01:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d04:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d07:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d10:	eb 16                	jmp    800d28 <memcpy+0x2a>
		*d++ = *s++;
  800d12:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d15:	8d 50 01             	lea    0x1(%eax),%edx
  800d18:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d1b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d1e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d21:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d24:	8a 12                	mov    (%edx),%dl
  800d26:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800d28:	8b 45 10             	mov    0x10(%ebp),%eax
  800d2b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d2e:	89 55 10             	mov    %edx,0x10(%ebp)
  800d31:	85 c0                	test   %eax,%eax
  800d33:	75 dd                	jne    800d12 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800d35:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d38:	c9                   	leave  
  800d39:	c3                   	ret    

00800d3a <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d3a:	55                   	push   %ebp
  800d3b:	89 e5                	mov    %esp,%ebp
  800d3d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d43:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d46:	8b 45 08             	mov    0x8(%ebp),%eax
  800d49:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d4f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d52:	73 50                	jae    800da4 <memmove+0x6a>
  800d54:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d57:	8b 45 10             	mov    0x10(%ebp),%eax
  800d5a:	01 d0                	add    %edx,%eax
  800d5c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d5f:	76 43                	jbe    800da4 <memmove+0x6a>
		s += n;
  800d61:	8b 45 10             	mov    0x10(%ebp),%eax
  800d64:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d67:	8b 45 10             	mov    0x10(%ebp),%eax
  800d6a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d6d:	eb 10                	jmp    800d7f <memmove+0x45>
			*--d = *--s;
  800d6f:	ff 4d f8             	decl   -0x8(%ebp)
  800d72:	ff 4d fc             	decl   -0x4(%ebp)
  800d75:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d78:	8a 10                	mov    (%eax),%dl
  800d7a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d7d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d7f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d82:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d85:	89 55 10             	mov    %edx,0x10(%ebp)
  800d88:	85 c0                	test   %eax,%eax
  800d8a:	75 e3                	jne    800d6f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d8c:	eb 23                	jmp    800db1 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800d8e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d91:	8d 50 01             	lea    0x1(%eax),%edx
  800d94:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d97:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d9a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d9d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800da0:	8a 12                	mov    (%edx),%dl
  800da2:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800da4:	8b 45 10             	mov    0x10(%ebp),%eax
  800da7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800daa:	89 55 10             	mov    %edx,0x10(%ebp)
  800dad:	85 c0                	test   %eax,%eax
  800daf:	75 dd                	jne    800d8e <memmove+0x54>
			*d++ = *s++;

	return dst;
  800db1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800db4:	c9                   	leave  
  800db5:	c3                   	ret    

00800db6 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800db6:	55                   	push   %ebp
  800db7:	89 e5                	mov    %esp,%ebp
  800db9:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800dc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc5:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800dc8:	eb 2a                	jmp    800df4 <memcmp+0x3e>
		if (*s1 != *s2)
  800dca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dcd:	8a 10                	mov    (%eax),%dl
  800dcf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dd2:	8a 00                	mov    (%eax),%al
  800dd4:	38 c2                	cmp    %al,%dl
  800dd6:	74 16                	je     800dee <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800dd8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ddb:	8a 00                	mov    (%eax),%al
  800ddd:	0f b6 d0             	movzbl %al,%edx
  800de0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800de3:	8a 00                	mov    (%eax),%al
  800de5:	0f b6 c0             	movzbl %al,%eax
  800de8:	29 c2                	sub    %eax,%edx
  800dea:	89 d0                	mov    %edx,%eax
  800dec:	eb 18                	jmp    800e06 <memcmp+0x50>
		s1++, s2++;
  800dee:	ff 45 fc             	incl   -0x4(%ebp)
  800df1:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800df4:	8b 45 10             	mov    0x10(%ebp),%eax
  800df7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dfa:	89 55 10             	mov    %edx,0x10(%ebp)
  800dfd:	85 c0                	test   %eax,%eax
  800dff:	75 c9                	jne    800dca <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e01:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e06:	c9                   	leave  
  800e07:	c3                   	ret    

00800e08 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e08:	55                   	push   %ebp
  800e09:	89 e5                	mov    %esp,%ebp
  800e0b:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e0e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e11:	8b 45 10             	mov    0x10(%ebp),%eax
  800e14:	01 d0                	add    %edx,%eax
  800e16:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e19:	eb 15                	jmp    800e30 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1e:	8a 00                	mov    (%eax),%al
  800e20:	0f b6 d0             	movzbl %al,%edx
  800e23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e26:	0f b6 c0             	movzbl %al,%eax
  800e29:	39 c2                	cmp    %eax,%edx
  800e2b:	74 0d                	je     800e3a <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e2d:	ff 45 08             	incl   0x8(%ebp)
  800e30:	8b 45 08             	mov    0x8(%ebp),%eax
  800e33:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e36:	72 e3                	jb     800e1b <memfind+0x13>
  800e38:	eb 01                	jmp    800e3b <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e3a:	90                   	nop
	return (void *) s;
  800e3b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e3e:	c9                   	leave  
  800e3f:	c3                   	ret    

00800e40 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e40:	55                   	push   %ebp
  800e41:	89 e5                	mov    %esp,%ebp
  800e43:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e46:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e4d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e54:	eb 03                	jmp    800e59 <strtol+0x19>
		s++;
  800e56:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5c:	8a 00                	mov    (%eax),%al
  800e5e:	3c 20                	cmp    $0x20,%al
  800e60:	74 f4                	je     800e56 <strtol+0x16>
  800e62:	8b 45 08             	mov    0x8(%ebp),%eax
  800e65:	8a 00                	mov    (%eax),%al
  800e67:	3c 09                	cmp    $0x9,%al
  800e69:	74 eb                	je     800e56 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6e:	8a 00                	mov    (%eax),%al
  800e70:	3c 2b                	cmp    $0x2b,%al
  800e72:	75 05                	jne    800e79 <strtol+0x39>
		s++;
  800e74:	ff 45 08             	incl   0x8(%ebp)
  800e77:	eb 13                	jmp    800e8c <strtol+0x4c>
	else if (*s == '-')
  800e79:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7c:	8a 00                	mov    (%eax),%al
  800e7e:	3c 2d                	cmp    $0x2d,%al
  800e80:	75 0a                	jne    800e8c <strtol+0x4c>
		s++, neg = 1;
  800e82:	ff 45 08             	incl   0x8(%ebp)
  800e85:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e8c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e90:	74 06                	je     800e98 <strtol+0x58>
  800e92:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800e96:	75 20                	jne    800eb8 <strtol+0x78>
  800e98:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9b:	8a 00                	mov    (%eax),%al
  800e9d:	3c 30                	cmp    $0x30,%al
  800e9f:	75 17                	jne    800eb8 <strtol+0x78>
  800ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea4:	40                   	inc    %eax
  800ea5:	8a 00                	mov    (%eax),%al
  800ea7:	3c 78                	cmp    $0x78,%al
  800ea9:	75 0d                	jne    800eb8 <strtol+0x78>
		s += 2, base = 16;
  800eab:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800eaf:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800eb6:	eb 28                	jmp    800ee0 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800eb8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ebc:	75 15                	jne    800ed3 <strtol+0x93>
  800ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec1:	8a 00                	mov    (%eax),%al
  800ec3:	3c 30                	cmp    $0x30,%al
  800ec5:	75 0c                	jne    800ed3 <strtol+0x93>
		s++, base = 8;
  800ec7:	ff 45 08             	incl   0x8(%ebp)
  800eca:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ed1:	eb 0d                	jmp    800ee0 <strtol+0xa0>
	else if (base == 0)
  800ed3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ed7:	75 07                	jne    800ee0 <strtol+0xa0>
		base = 10;
  800ed9:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee3:	8a 00                	mov    (%eax),%al
  800ee5:	3c 2f                	cmp    $0x2f,%al
  800ee7:	7e 19                	jle    800f02 <strtol+0xc2>
  800ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eec:	8a 00                	mov    (%eax),%al
  800eee:	3c 39                	cmp    $0x39,%al
  800ef0:	7f 10                	jg     800f02 <strtol+0xc2>
			dig = *s - '0';
  800ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef5:	8a 00                	mov    (%eax),%al
  800ef7:	0f be c0             	movsbl %al,%eax
  800efa:	83 e8 30             	sub    $0x30,%eax
  800efd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f00:	eb 42                	jmp    800f44 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f02:	8b 45 08             	mov    0x8(%ebp),%eax
  800f05:	8a 00                	mov    (%eax),%al
  800f07:	3c 60                	cmp    $0x60,%al
  800f09:	7e 19                	jle    800f24 <strtol+0xe4>
  800f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0e:	8a 00                	mov    (%eax),%al
  800f10:	3c 7a                	cmp    $0x7a,%al
  800f12:	7f 10                	jg     800f24 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f14:	8b 45 08             	mov    0x8(%ebp),%eax
  800f17:	8a 00                	mov    (%eax),%al
  800f19:	0f be c0             	movsbl %al,%eax
  800f1c:	83 e8 57             	sub    $0x57,%eax
  800f1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f22:	eb 20                	jmp    800f44 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f24:	8b 45 08             	mov    0x8(%ebp),%eax
  800f27:	8a 00                	mov    (%eax),%al
  800f29:	3c 40                	cmp    $0x40,%al
  800f2b:	7e 39                	jle    800f66 <strtol+0x126>
  800f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f30:	8a 00                	mov    (%eax),%al
  800f32:	3c 5a                	cmp    $0x5a,%al
  800f34:	7f 30                	jg     800f66 <strtol+0x126>
			dig = *s - 'A' + 10;
  800f36:	8b 45 08             	mov    0x8(%ebp),%eax
  800f39:	8a 00                	mov    (%eax),%al
  800f3b:	0f be c0             	movsbl %al,%eax
  800f3e:	83 e8 37             	sub    $0x37,%eax
  800f41:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f47:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f4a:	7d 19                	jge    800f65 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f4c:	ff 45 08             	incl   0x8(%ebp)
  800f4f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f52:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f56:	89 c2                	mov    %eax,%edx
  800f58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f5b:	01 d0                	add    %edx,%eax
  800f5d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f60:	e9 7b ff ff ff       	jmp    800ee0 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f65:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f66:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f6a:	74 08                	je     800f74 <strtol+0x134>
		*endptr = (char *) s;
  800f6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f72:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f74:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f78:	74 07                	je     800f81 <strtol+0x141>
  800f7a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f7d:	f7 d8                	neg    %eax
  800f7f:	eb 03                	jmp    800f84 <strtol+0x144>
  800f81:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f84:	c9                   	leave  
  800f85:	c3                   	ret    

00800f86 <ltostr>:

void
ltostr(long value, char *str)
{
  800f86:	55                   	push   %ebp
  800f87:	89 e5                	mov    %esp,%ebp
  800f89:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800f8c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800f93:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800f9a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f9e:	79 13                	jns    800fb3 <ltostr+0x2d>
	{
		neg = 1;
  800fa0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800fa7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800faa:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800fad:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800fb0:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb6:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800fbb:	99                   	cltd   
  800fbc:	f7 f9                	idiv   %ecx
  800fbe:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800fc1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc4:	8d 50 01             	lea    0x1(%eax),%edx
  800fc7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fca:	89 c2                	mov    %eax,%edx
  800fcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fcf:	01 d0                	add    %edx,%eax
  800fd1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800fd4:	83 c2 30             	add    $0x30,%edx
  800fd7:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800fd9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fdc:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800fe1:	f7 e9                	imul   %ecx
  800fe3:	c1 fa 02             	sar    $0x2,%edx
  800fe6:	89 c8                	mov    %ecx,%eax
  800fe8:	c1 f8 1f             	sar    $0x1f,%eax
  800feb:	29 c2                	sub    %eax,%edx
  800fed:	89 d0                	mov    %edx,%eax
  800fef:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800ff2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ff6:	75 bb                	jne    800fb3 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800ff8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800fff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801002:	48                   	dec    %eax
  801003:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801006:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80100a:	74 3d                	je     801049 <ltostr+0xc3>
		start = 1 ;
  80100c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801013:	eb 34                	jmp    801049 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801015:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801018:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101b:	01 d0                	add    %edx,%eax
  80101d:	8a 00                	mov    (%eax),%al
  80101f:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801022:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801025:	8b 45 0c             	mov    0xc(%ebp),%eax
  801028:	01 c2                	add    %eax,%edx
  80102a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80102d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801030:	01 c8                	add    %ecx,%eax
  801032:	8a 00                	mov    (%eax),%al
  801034:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801036:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801039:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103c:	01 c2                	add    %eax,%edx
  80103e:	8a 45 eb             	mov    -0x15(%ebp),%al
  801041:	88 02                	mov    %al,(%edx)
		start++ ;
  801043:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801046:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801049:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80104c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80104f:	7c c4                	jl     801015 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801051:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801054:	8b 45 0c             	mov    0xc(%ebp),%eax
  801057:	01 d0                	add    %edx,%eax
  801059:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80105c:	90                   	nop
  80105d:	c9                   	leave  
  80105e:	c3                   	ret    

0080105f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80105f:	55                   	push   %ebp
  801060:	89 e5                	mov    %esp,%ebp
  801062:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801065:	ff 75 08             	pushl  0x8(%ebp)
  801068:	e8 73 fa ff ff       	call   800ae0 <strlen>
  80106d:	83 c4 04             	add    $0x4,%esp
  801070:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801073:	ff 75 0c             	pushl  0xc(%ebp)
  801076:	e8 65 fa ff ff       	call   800ae0 <strlen>
  80107b:	83 c4 04             	add    $0x4,%esp
  80107e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801081:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801088:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80108f:	eb 17                	jmp    8010a8 <strcconcat+0x49>
		final[s] = str1[s] ;
  801091:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801094:	8b 45 10             	mov    0x10(%ebp),%eax
  801097:	01 c2                	add    %eax,%edx
  801099:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80109c:	8b 45 08             	mov    0x8(%ebp),%eax
  80109f:	01 c8                	add    %ecx,%eax
  8010a1:	8a 00                	mov    (%eax),%al
  8010a3:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8010a5:	ff 45 fc             	incl   -0x4(%ebp)
  8010a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ab:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010ae:	7c e1                	jl     801091 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8010b0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8010b7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8010be:	eb 1f                	jmp    8010df <strcconcat+0x80>
		final[s++] = str2[i] ;
  8010c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c3:	8d 50 01             	lea    0x1(%eax),%edx
  8010c6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010c9:	89 c2                	mov    %eax,%edx
  8010cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ce:	01 c2                	add    %eax,%edx
  8010d0:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d6:	01 c8                	add    %ecx,%eax
  8010d8:	8a 00                	mov    (%eax),%al
  8010da:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8010dc:	ff 45 f8             	incl   -0x8(%ebp)
  8010df:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010e5:	7c d9                	jl     8010c0 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8010e7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ed:	01 d0                	add    %edx,%eax
  8010ef:	c6 00 00             	movb   $0x0,(%eax)
}
  8010f2:	90                   	nop
  8010f3:	c9                   	leave  
  8010f4:	c3                   	ret    

008010f5 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8010f5:	55                   	push   %ebp
  8010f6:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8010f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8010fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801101:	8b 45 14             	mov    0x14(%ebp),%eax
  801104:	8b 00                	mov    (%eax),%eax
  801106:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80110d:	8b 45 10             	mov    0x10(%ebp),%eax
  801110:	01 d0                	add    %edx,%eax
  801112:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801118:	eb 0c                	jmp    801126 <strsplit+0x31>
			*string++ = 0;
  80111a:	8b 45 08             	mov    0x8(%ebp),%eax
  80111d:	8d 50 01             	lea    0x1(%eax),%edx
  801120:	89 55 08             	mov    %edx,0x8(%ebp)
  801123:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801126:	8b 45 08             	mov    0x8(%ebp),%eax
  801129:	8a 00                	mov    (%eax),%al
  80112b:	84 c0                	test   %al,%al
  80112d:	74 18                	je     801147 <strsplit+0x52>
  80112f:	8b 45 08             	mov    0x8(%ebp),%eax
  801132:	8a 00                	mov    (%eax),%al
  801134:	0f be c0             	movsbl %al,%eax
  801137:	50                   	push   %eax
  801138:	ff 75 0c             	pushl  0xc(%ebp)
  80113b:	e8 32 fb ff ff       	call   800c72 <strchr>
  801140:	83 c4 08             	add    $0x8,%esp
  801143:	85 c0                	test   %eax,%eax
  801145:	75 d3                	jne    80111a <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801147:	8b 45 08             	mov    0x8(%ebp),%eax
  80114a:	8a 00                	mov    (%eax),%al
  80114c:	84 c0                	test   %al,%al
  80114e:	74 5a                	je     8011aa <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801150:	8b 45 14             	mov    0x14(%ebp),%eax
  801153:	8b 00                	mov    (%eax),%eax
  801155:	83 f8 0f             	cmp    $0xf,%eax
  801158:	75 07                	jne    801161 <strsplit+0x6c>
		{
			return 0;
  80115a:	b8 00 00 00 00       	mov    $0x0,%eax
  80115f:	eb 66                	jmp    8011c7 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801161:	8b 45 14             	mov    0x14(%ebp),%eax
  801164:	8b 00                	mov    (%eax),%eax
  801166:	8d 48 01             	lea    0x1(%eax),%ecx
  801169:	8b 55 14             	mov    0x14(%ebp),%edx
  80116c:	89 0a                	mov    %ecx,(%edx)
  80116e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801175:	8b 45 10             	mov    0x10(%ebp),%eax
  801178:	01 c2                	add    %eax,%edx
  80117a:	8b 45 08             	mov    0x8(%ebp),%eax
  80117d:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80117f:	eb 03                	jmp    801184 <strsplit+0x8f>
			string++;
  801181:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801184:	8b 45 08             	mov    0x8(%ebp),%eax
  801187:	8a 00                	mov    (%eax),%al
  801189:	84 c0                	test   %al,%al
  80118b:	74 8b                	je     801118 <strsplit+0x23>
  80118d:	8b 45 08             	mov    0x8(%ebp),%eax
  801190:	8a 00                	mov    (%eax),%al
  801192:	0f be c0             	movsbl %al,%eax
  801195:	50                   	push   %eax
  801196:	ff 75 0c             	pushl  0xc(%ebp)
  801199:	e8 d4 fa ff ff       	call   800c72 <strchr>
  80119e:	83 c4 08             	add    $0x8,%esp
  8011a1:	85 c0                	test   %eax,%eax
  8011a3:	74 dc                	je     801181 <strsplit+0x8c>
			string++;
	}
  8011a5:	e9 6e ff ff ff       	jmp    801118 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8011aa:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8011ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8011ae:	8b 00                	mov    (%eax),%eax
  8011b0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ba:	01 d0                	add    %edx,%eax
  8011bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8011c2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8011c7:	c9                   	leave  
  8011c8:	c3                   	ret    

008011c9 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8011c9:	55                   	push   %ebp
  8011ca:	89 e5                	mov    %esp,%ebp
  8011cc:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8011cf:	83 ec 04             	sub    $0x4,%esp
  8011d2:	68 48 24 80 00       	push   $0x802448
  8011d7:	68 3f 01 00 00       	push   $0x13f
  8011dc:	68 6a 24 80 00       	push   $0x80246a
  8011e1:	e8 51 07 00 00       	call   801937 <_panic>

008011e6 <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  8011e6:	55                   	push   %ebp
  8011e7:	89 e5                	mov    %esp,%ebp
  8011e9:	57                   	push   %edi
  8011ea:	56                   	push   %esi
  8011eb:	53                   	push   %ebx
  8011ec:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011f5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8011f8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8011fb:	8b 7d 18             	mov    0x18(%ebp),%edi
  8011fe:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801201:	cd 30                	int    $0x30
  801203:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  801206:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801209:	83 c4 10             	add    $0x10,%esp
  80120c:	5b                   	pop    %ebx
  80120d:	5e                   	pop    %esi
  80120e:	5f                   	pop    %edi
  80120f:	5d                   	pop    %ebp
  801210:	c3                   	ret    

00801211 <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  801211:	55                   	push   %ebp
  801212:	89 e5                	mov    %esp,%ebp
  801214:	83 ec 04             	sub    $0x4,%esp
  801217:	8b 45 10             	mov    0x10(%ebp),%eax
  80121a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  80121d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801221:	8b 45 08             	mov    0x8(%ebp),%eax
  801224:	6a 00                	push   $0x0
  801226:	6a 00                	push   $0x0
  801228:	52                   	push   %edx
  801229:	ff 75 0c             	pushl  0xc(%ebp)
  80122c:	50                   	push   %eax
  80122d:	6a 00                	push   $0x0
  80122f:	e8 b2 ff ff ff       	call   8011e6 <syscall>
  801234:	83 c4 18             	add    $0x18,%esp
}
  801237:	90                   	nop
  801238:	c9                   	leave  
  801239:	c3                   	ret    

0080123a <sys_cgetc>:

int sys_cgetc(void) {
  80123a:	55                   	push   %ebp
  80123b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80123d:	6a 00                	push   $0x0
  80123f:	6a 00                	push   $0x0
  801241:	6a 00                	push   $0x0
  801243:	6a 00                	push   $0x0
  801245:	6a 00                	push   $0x0
  801247:	6a 02                	push   $0x2
  801249:	e8 98 ff ff ff       	call   8011e6 <syscall>
  80124e:	83 c4 18             	add    $0x18,%esp
}
  801251:	c9                   	leave  
  801252:	c3                   	ret    

00801253 <sys_lock_cons>:

void sys_lock_cons(void) {
  801253:	55                   	push   %ebp
  801254:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801256:	6a 00                	push   $0x0
  801258:	6a 00                	push   $0x0
  80125a:	6a 00                	push   $0x0
  80125c:	6a 00                	push   $0x0
  80125e:	6a 00                	push   $0x0
  801260:	6a 03                	push   $0x3
  801262:	e8 7f ff ff ff       	call   8011e6 <syscall>
  801267:	83 c4 18             	add    $0x18,%esp
}
  80126a:	90                   	nop
  80126b:	c9                   	leave  
  80126c:	c3                   	ret    

0080126d <sys_unlock_cons>:
void sys_unlock_cons(void) {
  80126d:	55                   	push   %ebp
  80126e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801270:	6a 00                	push   $0x0
  801272:	6a 00                	push   $0x0
  801274:	6a 00                	push   $0x0
  801276:	6a 00                	push   $0x0
  801278:	6a 00                	push   $0x0
  80127a:	6a 04                	push   $0x4
  80127c:	e8 65 ff ff ff       	call   8011e6 <syscall>
  801281:	83 c4 18             	add    $0x18,%esp
}
  801284:	90                   	nop
  801285:	c9                   	leave  
  801286:	c3                   	ret    

00801287 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  801287:	55                   	push   %ebp
  801288:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  80128a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80128d:	8b 45 08             	mov    0x8(%ebp),%eax
  801290:	6a 00                	push   $0x0
  801292:	6a 00                	push   $0x0
  801294:	6a 00                	push   $0x0
  801296:	52                   	push   %edx
  801297:	50                   	push   %eax
  801298:	6a 08                	push   $0x8
  80129a:	e8 47 ff ff ff       	call   8011e6 <syscall>
  80129f:	83 c4 18             	add    $0x18,%esp
}
  8012a2:	c9                   	leave  
  8012a3:	c3                   	ret    

008012a4 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  8012a4:	55                   	push   %ebp
  8012a5:	89 e5                	mov    %esp,%ebp
  8012a7:	56                   	push   %esi
  8012a8:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  8012a9:	8b 75 18             	mov    0x18(%ebp),%esi
  8012ac:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012af:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b8:	56                   	push   %esi
  8012b9:	53                   	push   %ebx
  8012ba:	51                   	push   %ecx
  8012bb:	52                   	push   %edx
  8012bc:	50                   	push   %eax
  8012bd:	6a 09                	push   $0x9
  8012bf:	e8 22 ff ff ff       	call   8011e6 <syscall>
  8012c4:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  8012c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012ca:	5b                   	pop    %ebx
  8012cb:	5e                   	pop    %esi
  8012cc:	5d                   	pop    %ebp
  8012cd:	c3                   	ret    

008012ce <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  8012ce:	55                   	push   %ebp
  8012cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8012d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d7:	6a 00                	push   $0x0
  8012d9:	6a 00                	push   $0x0
  8012db:	6a 00                	push   $0x0
  8012dd:	52                   	push   %edx
  8012de:	50                   	push   %eax
  8012df:	6a 0a                	push   $0xa
  8012e1:	e8 00 ff ff ff       	call   8011e6 <syscall>
  8012e6:	83 c4 18             	add    $0x18,%esp
}
  8012e9:	c9                   	leave  
  8012ea:	c3                   	ret    

008012eb <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  8012eb:	55                   	push   %ebp
  8012ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  8012ee:	6a 00                	push   $0x0
  8012f0:	6a 00                	push   $0x0
  8012f2:	6a 00                	push   $0x0
  8012f4:	ff 75 0c             	pushl  0xc(%ebp)
  8012f7:	ff 75 08             	pushl  0x8(%ebp)
  8012fa:	6a 0b                	push   $0xb
  8012fc:	e8 e5 fe ff ff       	call   8011e6 <syscall>
  801301:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  801304:	c9                   	leave  
  801305:	c3                   	ret    

00801306 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  801306:	55                   	push   %ebp
  801307:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801309:	6a 00                	push   $0x0
  80130b:	6a 00                	push   $0x0
  80130d:	6a 00                	push   $0x0
  80130f:	6a 00                	push   $0x0
  801311:	6a 00                	push   $0x0
  801313:	6a 0c                	push   $0xc
  801315:	e8 cc fe ff ff       	call   8011e6 <syscall>
  80131a:	83 c4 18             	add    $0x18,%esp
}
  80131d:	c9                   	leave  
  80131e:	c3                   	ret    

0080131f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  80131f:	55                   	push   %ebp
  801320:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801322:	6a 00                	push   $0x0
  801324:	6a 00                	push   $0x0
  801326:	6a 00                	push   $0x0
  801328:	6a 00                	push   $0x0
  80132a:	6a 00                	push   $0x0
  80132c:	6a 0d                	push   $0xd
  80132e:	e8 b3 fe ff ff       	call   8011e6 <syscall>
  801333:	83 c4 18             	add    $0x18,%esp
}
  801336:	c9                   	leave  
  801337:	c3                   	ret    

00801338 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  801338:	55                   	push   %ebp
  801339:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80133b:	6a 00                	push   $0x0
  80133d:	6a 00                	push   $0x0
  80133f:	6a 00                	push   $0x0
  801341:	6a 00                	push   $0x0
  801343:	6a 00                	push   $0x0
  801345:	6a 0e                	push   $0xe
  801347:	e8 9a fe ff ff       	call   8011e6 <syscall>
  80134c:	83 c4 18             	add    $0x18,%esp
}
  80134f:	c9                   	leave  
  801350:	c3                   	ret    

00801351 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  801351:	55                   	push   %ebp
  801352:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  801354:	6a 00                	push   $0x0
  801356:	6a 00                	push   $0x0
  801358:	6a 00                	push   $0x0
  80135a:	6a 00                	push   $0x0
  80135c:	6a 00                	push   $0x0
  80135e:	6a 0f                	push   $0xf
  801360:	e8 81 fe ff ff       	call   8011e6 <syscall>
  801365:	83 c4 18             	add    $0x18,%esp
}
  801368:	c9                   	leave  
  801369:	c3                   	ret    

0080136a <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  80136a:	55                   	push   %ebp
  80136b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  80136d:	6a 00                	push   $0x0
  80136f:	6a 00                	push   $0x0
  801371:	6a 00                	push   $0x0
  801373:	6a 00                	push   $0x0
  801375:	ff 75 08             	pushl  0x8(%ebp)
  801378:	6a 10                	push   $0x10
  80137a:	e8 67 fe ff ff       	call   8011e6 <syscall>
  80137f:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  801382:	c9                   	leave  
  801383:	c3                   	ret    

00801384 <sys_scarce_memory>:

void sys_scarce_memory() {
  801384:	55                   	push   %ebp
  801385:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  801387:	6a 00                	push   $0x0
  801389:	6a 00                	push   $0x0
  80138b:	6a 00                	push   $0x0
  80138d:	6a 00                	push   $0x0
  80138f:	6a 00                	push   $0x0
  801391:	6a 11                	push   $0x11
  801393:	e8 4e fe ff ff       	call   8011e6 <syscall>
  801398:	83 c4 18             	add    $0x18,%esp
}
  80139b:	90                   	nop
  80139c:	c9                   	leave  
  80139d:	c3                   	ret    

0080139e <sys_cputc>:

void sys_cputc(const char c) {
  80139e:	55                   	push   %ebp
  80139f:	89 e5                	mov    %esp,%ebp
  8013a1:	83 ec 04             	sub    $0x4,%esp
  8013a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8013aa:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8013ae:	6a 00                	push   $0x0
  8013b0:	6a 00                	push   $0x0
  8013b2:	6a 00                	push   $0x0
  8013b4:	6a 00                	push   $0x0
  8013b6:	50                   	push   %eax
  8013b7:	6a 01                	push   $0x1
  8013b9:	e8 28 fe ff ff       	call   8011e6 <syscall>
  8013be:	83 c4 18             	add    $0x18,%esp
}
  8013c1:	90                   	nop
  8013c2:	c9                   	leave  
  8013c3:	c3                   	ret    

008013c4 <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  8013c4:	55                   	push   %ebp
  8013c5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  8013c7:	6a 00                	push   $0x0
  8013c9:	6a 00                	push   $0x0
  8013cb:	6a 00                	push   $0x0
  8013cd:	6a 00                	push   $0x0
  8013cf:	6a 00                	push   $0x0
  8013d1:	6a 14                	push   $0x14
  8013d3:	e8 0e fe ff ff       	call   8011e6 <syscall>
  8013d8:	83 c4 18             	add    $0x18,%esp
}
  8013db:	90                   	nop
  8013dc:	c9                   	leave  
  8013dd:	c3                   	ret    

008013de <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  8013de:	55                   	push   %ebp
  8013df:	89 e5                	mov    %esp,%ebp
  8013e1:	83 ec 04             	sub    $0x4,%esp
  8013e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e7:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  8013ea:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8013ed:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8013f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f4:	6a 00                	push   $0x0
  8013f6:	51                   	push   %ecx
  8013f7:	52                   	push   %edx
  8013f8:	ff 75 0c             	pushl  0xc(%ebp)
  8013fb:	50                   	push   %eax
  8013fc:	6a 15                	push   $0x15
  8013fe:	e8 e3 fd ff ff       	call   8011e6 <syscall>
  801403:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  801406:	c9                   	leave  
  801407:	c3                   	ret    

00801408 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  801408:	55                   	push   %ebp
  801409:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  80140b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80140e:	8b 45 08             	mov    0x8(%ebp),%eax
  801411:	6a 00                	push   $0x0
  801413:	6a 00                	push   $0x0
  801415:	6a 00                	push   $0x0
  801417:	52                   	push   %edx
  801418:	50                   	push   %eax
  801419:	6a 16                	push   $0x16
  80141b:	e8 c6 fd ff ff       	call   8011e6 <syscall>
  801420:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  801423:	c9                   	leave  
  801424:	c3                   	ret    

00801425 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  801425:	55                   	push   %ebp
  801426:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  801428:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80142b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80142e:	8b 45 08             	mov    0x8(%ebp),%eax
  801431:	6a 00                	push   $0x0
  801433:	6a 00                	push   $0x0
  801435:	51                   	push   %ecx
  801436:	52                   	push   %edx
  801437:	50                   	push   %eax
  801438:	6a 17                	push   $0x17
  80143a:	e8 a7 fd ff ff       	call   8011e6 <syscall>
  80143f:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  801442:	c9                   	leave  
  801443:	c3                   	ret    

00801444 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  801444:	55                   	push   %ebp
  801445:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  801447:	8b 55 0c             	mov    0xc(%ebp),%edx
  80144a:	8b 45 08             	mov    0x8(%ebp),%eax
  80144d:	6a 00                	push   $0x0
  80144f:	6a 00                	push   $0x0
  801451:	6a 00                	push   $0x0
  801453:	52                   	push   %edx
  801454:	50                   	push   %eax
  801455:	6a 18                	push   $0x18
  801457:	e8 8a fd ff ff       	call   8011e6 <syscall>
  80145c:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  80145f:	c9                   	leave  
  801460:	c3                   	ret    

00801461 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  801461:	55                   	push   %ebp
  801462:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  801464:	8b 45 08             	mov    0x8(%ebp),%eax
  801467:	6a 00                	push   $0x0
  801469:	ff 75 14             	pushl  0x14(%ebp)
  80146c:	ff 75 10             	pushl  0x10(%ebp)
  80146f:	ff 75 0c             	pushl  0xc(%ebp)
  801472:	50                   	push   %eax
  801473:	6a 19                	push   $0x19
  801475:	e8 6c fd ff ff       	call   8011e6 <syscall>
  80147a:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  80147d:	c9                   	leave  
  80147e:	c3                   	ret    

0080147f <sys_run_env>:

void sys_run_env(int32 envId) {
  80147f:	55                   	push   %ebp
  801480:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  801482:	8b 45 08             	mov    0x8(%ebp),%eax
  801485:	6a 00                	push   $0x0
  801487:	6a 00                	push   $0x0
  801489:	6a 00                	push   $0x0
  80148b:	6a 00                	push   $0x0
  80148d:	50                   	push   %eax
  80148e:	6a 1a                	push   $0x1a
  801490:	e8 51 fd ff ff       	call   8011e6 <syscall>
  801495:	83 c4 18             	add    $0x18,%esp
}
  801498:	90                   	nop
  801499:	c9                   	leave  
  80149a:	c3                   	ret    

0080149b <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  80149b:	55                   	push   %ebp
  80149c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80149e:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a1:	6a 00                	push   $0x0
  8014a3:	6a 00                	push   $0x0
  8014a5:	6a 00                	push   $0x0
  8014a7:	6a 00                	push   $0x0
  8014a9:	50                   	push   %eax
  8014aa:	6a 1b                	push   $0x1b
  8014ac:	e8 35 fd ff ff       	call   8011e6 <syscall>
  8014b1:	83 c4 18             	add    $0x18,%esp
}
  8014b4:	c9                   	leave  
  8014b5:	c3                   	ret    

008014b6 <sys_getenvid>:

int32 sys_getenvid(void) {
  8014b6:	55                   	push   %ebp
  8014b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8014b9:	6a 00                	push   $0x0
  8014bb:	6a 00                	push   $0x0
  8014bd:	6a 00                	push   $0x0
  8014bf:	6a 00                	push   $0x0
  8014c1:	6a 00                	push   $0x0
  8014c3:	6a 05                	push   $0x5
  8014c5:	e8 1c fd ff ff       	call   8011e6 <syscall>
  8014ca:	83 c4 18             	add    $0x18,%esp
}
  8014cd:	c9                   	leave  
  8014ce:	c3                   	ret    

008014cf <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  8014cf:	55                   	push   %ebp
  8014d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8014d2:	6a 00                	push   $0x0
  8014d4:	6a 00                	push   $0x0
  8014d6:	6a 00                	push   $0x0
  8014d8:	6a 00                	push   $0x0
  8014da:	6a 00                	push   $0x0
  8014dc:	6a 06                	push   $0x6
  8014de:	e8 03 fd ff ff       	call   8011e6 <syscall>
  8014e3:	83 c4 18             	add    $0x18,%esp
}
  8014e6:	c9                   	leave  
  8014e7:	c3                   	ret    

008014e8 <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  8014e8:	55                   	push   %ebp
  8014e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8014eb:	6a 00                	push   $0x0
  8014ed:	6a 00                	push   $0x0
  8014ef:	6a 00                	push   $0x0
  8014f1:	6a 00                	push   $0x0
  8014f3:	6a 00                	push   $0x0
  8014f5:	6a 07                	push   $0x7
  8014f7:	e8 ea fc ff ff       	call   8011e6 <syscall>
  8014fc:	83 c4 18             	add    $0x18,%esp
}
  8014ff:	c9                   	leave  
  801500:	c3                   	ret    

00801501 <sys_exit_env>:

void sys_exit_env(void) {
  801501:	55                   	push   %ebp
  801502:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801504:	6a 00                	push   $0x0
  801506:	6a 00                	push   $0x0
  801508:	6a 00                	push   $0x0
  80150a:	6a 00                	push   $0x0
  80150c:	6a 00                	push   $0x0
  80150e:	6a 1c                	push   $0x1c
  801510:	e8 d1 fc ff ff       	call   8011e6 <syscall>
  801515:	83 c4 18             	add    $0x18,%esp
}
  801518:	90                   	nop
  801519:	c9                   	leave  
  80151a:	c3                   	ret    

0080151b <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  80151b:	55                   	push   %ebp
  80151c:	89 e5                	mov    %esp,%ebp
  80151e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  801521:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801524:	8d 50 04             	lea    0x4(%eax),%edx
  801527:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80152a:	6a 00                	push   $0x0
  80152c:	6a 00                	push   $0x0
  80152e:	6a 00                	push   $0x0
  801530:	52                   	push   %edx
  801531:	50                   	push   %eax
  801532:	6a 1d                	push   $0x1d
  801534:	e8 ad fc ff ff       	call   8011e6 <syscall>
  801539:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  80153c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80153f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801542:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801545:	89 01                	mov    %eax,(%ecx)
  801547:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80154a:	8b 45 08             	mov    0x8(%ebp),%eax
  80154d:	c9                   	leave  
  80154e:	c2 04 00             	ret    $0x4

00801551 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  801551:	55                   	push   %ebp
  801552:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  801554:	6a 00                	push   $0x0
  801556:	6a 00                	push   $0x0
  801558:	ff 75 10             	pushl  0x10(%ebp)
  80155b:	ff 75 0c             	pushl  0xc(%ebp)
  80155e:	ff 75 08             	pushl  0x8(%ebp)
  801561:	6a 13                	push   $0x13
  801563:	e8 7e fc ff ff       	call   8011e6 <syscall>
  801568:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  80156b:	90                   	nop
}
  80156c:	c9                   	leave  
  80156d:	c3                   	ret    

0080156e <sys_rcr2>:
uint32 sys_rcr2() {
  80156e:	55                   	push   %ebp
  80156f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801571:	6a 00                	push   $0x0
  801573:	6a 00                	push   $0x0
  801575:	6a 00                	push   $0x0
  801577:	6a 00                	push   $0x0
  801579:	6a 00                	push   $0x0
  80157b:	6a 1e                	push   $0x1e
  80157d:	e8 64 fc ff ff       	call   8011e6 <syscall>
  801582:	83 c4 18             	add    $0x18,%esp
}
  801585:	c9                   	leave  
  801586:	c3                   	ret    

00801587 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  801587:	55                   	push   %ebp
  801588:	89 e5                	mov    %esp,%ebp
  80158a:	83 ec 04             	sub    $0x4,%esp
  80158d:	8b 45 08             	mov    0x8(%ebp),%eax
  801590:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801593:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801597:	6a 00                	push   $0x0
  801599:	6a 00                	push   $0x0
  80159b:	6a 00                	push   $0x0
  80159d:	6a 00                	push   $0x0
  80159f:	50                   	push   %eax
  8015a0:	6a 1f                	push   $0x1f
  8015a2:	e8 3f fc ff ff       	call   8011e6 <syscall>
  8015a7:	83 c4 18             	add    $0x18,%esp
	return;
  8015aa:	90                   	nop
}
  8015ab:	c9                   	leave  
  8015ac:	c3                   	ret    

008015ad <rsttst>:
void rsttst() {
  8015ad:	55                   	push   %ebp
  8015ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8015b0:	6a 00                	push   $0x0
  8015b2:	6a 00                	push   $0x0
  8015b4:	6a 00                	push   $0x0
  8015b6:	6a 00                	push   $0x0
  8015b8:	6a 00                	push   $0x0
  8015ba:	6a 21                	push   $0x21
  8015bc:	e8 25 fc ff ff       	call   8011e6 <syscall>
  8015c1:	83 c4 18             	add    $0x18,%esp
	return;
  8015c4:	90                   	nop
}
  8015c5:	c9                   	leave  
  8015c6:	c3                   	ret    

008015c7 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  8015c7:	55                   	push   %ebp
  8015c8:	89 e5                	mov    %esp,%ebp
  8015ca:	83 ec 04             	sub    $0x4,%esp
  8015cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8015d0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8015d3:	8b 55 18             	mov    0x18(%ebp),%edx
  8015d6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8015da:	52                   	push   %edx
  8015db:	50                   	push   %eax
  8015dc:	ff 75 10             	pushl  0x10(%ebp)
  8015df:	ff 75 0c             	pushl  0xc(%ebp)
  8015e2:	ff 75 08             	pushl  0x8(%ebp)
  8015e5:	6a 20                	push   $0x20
  8015e7:	e8 fa fb ff ff       	call   8011e6 <syscall>
  8015ec:	83 c4 18             	add    $0x18,%esp
	return;
  8015ef:	90                   	nop
}
  8015f0:	c9                   	leave  
  8015f1:	c3                   	ret    

008015f2 <chktst>:
void chktst(uint32 n) {
  8015f2:	55                   	push   %ebp
  8015f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8015f5:	6a 00                	push   $0x0
  8015f7:	6a 00                	push   $0x0
  8015f9:	6a 00                	push   $0x0
  8015fb:	6a 00                	push   $0x0
  8015fd:	ff 75 08             	pushl  0x8(%ebp)
  801600:	6a 22                	push   $0x22
  801602:	e8 df fb ff ff       	call   8011e6 <syscall>
  801607:	83 c4 18             	add    $0x18,%esp
	return;
  80160a:	90                   	nop
}
  80160b:	c9                   	leave  
  80160c:	c3                   	ret    

0080160d <inctst>:

void inctst() {
  80160d:	55                   	push   %ebp
  80160e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801610:	6a 00                	push   $0x0
  801612:	6a 00                	push   $0x0
  801614:	6a 00                	push   $0x0
  801616:	6a 00                	push   $0x0
  801618:	6a 00                	push   $0x0
  80161a:	6a 23                	push   $0x23
  80161c:	e8 c5 fb ff ff       	call   8011e6 <syscall>
  801621:	83 c4 18             	add    $0x18,%esp
	return;
  801624:	90                   	nop
}
  801625:	c9                   	leave  
  801626:	c3                   	ret    

00801627 <gettst>:
uint32 gettst() {
  801627:	55                   	push   %ebp
  801628:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80162a:	6a 00                	push   $0x0
  80162c:	6a 00                	push   $0x0
  80162e:	6a 00                	push   $0x0
  801630:	6a 00                	push   $0x0
  801632:	6a 00                	push   $0x0
  801634:	6a 24                	push   $0x24
  801636:	e8 ab fb ff ff       	call   8011e6 <syscall>
  80163b:	83 c4 18             	add    $0x18,%esp
}
  80163e:	c9                   	leave  
  80163f:	c3                   	ret    

00801640 <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  801640:	55                   	push   %ebp
  801641:	89 e5                	mov    %esp,%ebp
  801643:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801646:	6a 00                	push   $0x0
  801648:	6a 00                	push   $0x0
  80164a:	6a 00                	push   $0x0
  80164c:	6a 00                	push   $0x0
  80164e:	6a 00                	push   $0x0
  801650:	6a 25                	push   $0x25
  801652:	e8 8f fb ff ff       	call   8011e6 <syscall>
  801657:	83 c4 18             	add    $0x18,%esp
  80165a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80165d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801661:	75 07                	jne    80166a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801663:	b8 01 00 00 00       	mov    $0x1,%eax
  801668:	eb 05                	jmp    80166f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80166a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80166f:	c9                   	leave  
  801670:	c3                   	ret    

00801671 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  801671:	55                   	push   %ebp
  801672:	89 e5                	mov    %esp,%ebp
  801674:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801677:	6a 00                	push   $0x0
  801679:	6a 00                	push   $0x0
  80167b:	6a 00                	push   $0x0
  80167d:	6a 00                	push   $0x0
  80167f:	6a 00                	push   $0x0
  801681:	6a 25                	push   $0x25
  801683:	e8 5e fb ff ff       	call   8011e6 <syscall>
  801688:	83 c4 18             	add    $0x18,%esp
  80168b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80168e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801692:	75 07                	jne    80169b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801694:	b8 01 00 00 00       	mov    $0x1,%eax
  801699:	eb 05                	jmp    8016a0 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80169b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016a0:	c9                   	leave  
  8016a1:	c3                   	ret    

008016a2 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  8016a2:	55                   	push   %ebp
  8016a3:	89 e5                	mov    %esp,%ebp
  8016a5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016a8:	6a 00                	push   $0x0
  8016aa:	6a 00                	push   $0x0
  8016ac:	6a 00                	push   $0x0
  8016ae:	6a 00                	push   $0x0
  8016b0:	6a 00                	push   $0x0
  8016b2:	6a 25                	push   $0x25
  8016b4:	e8 2d fb ff ff       	call   8011e6 <syscall>
  8016b9:	83 c4 18             	add    $0x18,%esp
  8016bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8016bf:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8016c3:	75 07                	jne    8016cc <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8016c5:	b8 01 00 00 00       	mov    $0x1,%eax
  8016ca:	eb 05                	jmp    8016d1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8016cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016d1:	c9                   	leave  
  8016d2:	c3                   	ret    

008016d3 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  8016d3:	55                   	push   %ebp
  8016d4:	89 e5                	mov    %esp,%ebp
  8016d6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016d9:	6a 00                	push   $0x0
  8016db:	6a 00                	push   $0x0
  8016dd:	6a 00                	push   $0x0
  8016df:	6a 00                	push   $0x0
  8016e1:	6a 00                	push   $0x0
  8016e3:	6a 25                	push   $0x25
  8016e5:	e8 fc fa ff ff       	call   8011e6 <syscall>
  8016ea:	83 c4 18             	add    $0x18,%esp
  8016ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8016f0:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8016f4:	75 07                	jne    8016fd <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8016f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8016fb:	eb 05                	jmp    801702 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8016fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801702:	c9                   	leave  
  801703:	c3                   	ret    

00801704 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  801704:	55                   	push   %ebp
  801705:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801707:	6a 00                	push   $0x0
  801709:	6a 00                	push   $0x0
  80170b:	6a 00                	push   $0x0
  80170d:	6a 00                	push   $0x0
  80170f:	ff 75 08             	pushl  0x8(%ebp)
  801712:	6a 26                	push   $0x26
  801714:	e8 cd fa ff ff       	call   8011e6 <syscall>
  801719:	83 c4 18             	add    $0x18,%esp
	return;
  80171c:	90                   	nop
}
  80171d:	c9                   	leave  
  80171e:	c3                   	ret    

0080171f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  80171f:	55                   	push   %ebp
  801720:	89 e5                	mov    %esp,%ebp
  801722:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  801723:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801726:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801729:	8b 55 0c             	mov    0xc(%ebp),%edx
  80172c:	8b 45 08             	mov    0x8(%ebp),%eax
  80172f:	6a 00                	push   $0x0
  801731:	53                   	push   %ebx
  801732:	51                   	push   %ecx
  801733:	52                   	push   %edx
  801734:	50                   	push   %eax
  801735:	6a 27                	push   $0x27
  801737:	e8 aa fa ff ff       	call   8011e6 <syscall>
  80173c:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  80173f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801742:	c9                   	leave  
  801743:	c3                   	ret    

00801744 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  801744:	55                   	push   %ebp
  801745:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  801747:	8b 55 0c             	mov    0xc(%ebp),%edx
  80174a:	8b 45 08             	mov    0x8(%ebp),%eax
  80174d:	6a 00                	push   $0x0
  80174f:	6a 00                	push   $0x0
  801751:	6a 00                	push   $0x0
  801753:	52                   	push   %edx
  801754:	50                   	push   %eax
  801755:	6a 28                	push   $0x28
  801757:	e8 8a fa ff ff       	call   8011e6 <syscall>
  80175c:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  80175f:	c9                   	leave  
  801760:	c3                   	ret    

00801761 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  801761:	55                   	push   %ebp
  801762:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  801764:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801767:	8b 55 0c             	mov    0xc(%ebp),%edx
  80176a:	8b 45 08             	mov    0x8(%ebp),%eax
  80176d:	6a 00                	push   $0x0
  80176f:	51                   	push   %ecx
  801770:	ff 75 10             	pushl  0x10(%ebp)
  801773:	52                   	push   %edx
  801774:	50                   	push   %eax
  801775:	6a 29                	push   $0x29
  801777:	e8 6a fa ff ff       	call   8011e6 <syscall>
  80177c:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  80177f:	c9                   	leave  
  801780:	c3                   	ret    

00801781 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  801781:	55                   	push   %ebp
  801782:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801784:	6a 00                	push   $0x0
  801786:	6a 00                	push   $0x0
  801788:	ff 75 10             	pushl  0x10(%ebp)
  80178b:	ff 75 0c             	pushl  0xc(%ebp)
  80178e:	ff 75 08             	pushl  0x8(%ebp)
  801791:	6a 12                	push   $0x12
  801793:	e8 4e fa ff ff       	call   8011e6 <syscall>
  801798:	83 c4 18             	add    $0x18,%esp
	return;
  80179b:	90                   	nop
}
  80179c:	c9                   	leave  
  80179d:	c3                   	ret    

0080179e <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  80179e:	55                   	push   %ebp
  80179f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  8017a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a7:	6a 00                	push   $0x0
  8017a9:	6a 00                	push   $0x0
  8017ab:	6a 00                	push   $0x0
  8017ad:	52                   	push   %edx
  8017ae:	50                   	push   %eax
  8017af:	6a 2a                	push   $0x2a
  8017b1:	e8 30 fa ff ff       	call   8011e6 <syscall>
  8017b6:	83 c4 18             	add    $0x18,%esp
	return;
  8017b9:	90                   	nop
}
  8017ba:	c9                   	leave  
  8017bb:	c3                   	ret    

008017bc <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  8017bc:	55                   	push   %ebp
  8017bd:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  8017bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c2:	6a 00                	push   $0x0
  8017c4:	6a 00                	push   $0x0
  8017c6:	6a 00                	push   $0x0
  8017c8:	6a 00                	push   $0x0
  8017ca:	50                   	push   %eax
  8017cb:	6a 2b                	push   $0x2b
  8017cd:	e8 14 fa ff ff       	call   8011e6 <syscall>
  8017d2:	83 c4 18             	add    $0x18,%esp
}
  8017d5:	c9                   	leave  
  8017d6:	c3                   	ret    

008017d7 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  8017d7:	55                   	push   %ebp
  8017d8:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8017da:	6a 00                	push   $0x0
  8017dc:	6a 00                	push   $0x0
  8017de:	6a 00                	push   $0x0
  8017e0:	ff 75 0c             	pushl  0xc(%ebp)
  8017e3:	ff 75 08             	pushl  0x8(%ebp)
  8017e6:	6a 2c                	push   $0x2c
  8017e8:	e8 f9 f9 ff ff       	call   8011e6 <syscall>
  8017ed:	83 c4 18             	add    $0x18,%esp
	return;
  8017f0:	90                   	nop
}
  8017f1:	c9                   	leave  
  8017f2:	c3                   	ret    

008017f3 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  8017f3:	55                   	push   %ebp
  8017f4:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8017f6:	6a 00                	push   $0x0
  8017f8:	6a 00                	push   $0x0
  8017fa:	6a 00                	push   $0x0
  8017fc:	ff 75 0c             	pushl  0xc(%ebp)
  8017ff:	ff 75 08             	pushl  0x8(%ebp)
  801802:	6a 2d                	push   $0x2d
  801804:	e8 dd f9 ff ff       	call   8011e6 <syscall>
  801809:	83 c4 18             	add    $0x18,%esp
	return;
  80180c:	90                   	nop
}
  80180d:	c9                   	leave  
  80180e:	c3                   	ret    

0080180f <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  80180f:	55                   	push   %ebp
  801810:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  801812:	8b 45 08             	mov    0x8(%ebp),%eax
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	6a 00                	push   $0x0
  80181d:	50                   	push   %eax
  80181e:	6a 2f                	push   $0x2f
  801820:	e8 c1 f9 ff ff       	call   8011e6 <syscall>
  801825:	83 c4 18             	add    $0x18,%esp
	return;
  801828:	90                   	nop
}
  801829:	c9                   	leave  
  80182a:	c3                   	ret    

0080182b <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  80182b:	55                   	push   %ebp
  80182c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  80182e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801831:	8b 45 08             	mov    0x8(%ebp),%eax
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	6a 00                	push   $0x0
  80183a:	52                   	push   %edx
  80183b:	50                   	push   %eax
  80183c:	6a 30                	push   $0x30
  80183e:	e8 a3 f9 ff ff       	call   8011e6 <syscall>
  801843:	83 c4 18             	add    $0x18,%esp
	return;
  801846:	90                   	nop
}
  801847:	c9                   	leave  
  801848:	c3                   	ret    

00801849 <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  801849:	55                   	push   %ebp
  80184a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  80184c:	8b 45 08             	mov    0x8(%ebp),%eax
  80184f:	6a 00                	push   $0x0
  801851:	6a 00                	push   $0x0
  801853:	6a 00                	push   $0x0
  801855:	6a 00                	push   $0x0
  801857:	50                   	push   %eax
  801858:	6a 31                	push   $0x31
  80185a:	e8 87 f9 ff ff       	call   8011e6 <syscall>
  80185f:	83 c4 18             	add    $0x18,%esp
	return;
  801862:	90                   	nop
}
  801863:	c9                   	leave  
  801864:	c3                   	ret    

00801865 <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  801865:	55                   	push   %ebp
  801866:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801868:	8b 55 0c             	mov    0xc(%ebp),%edx
  80186b:	8b 45 08             	mov    0x8(%ebp),%eax
  80186e:	6a 00                	push   $0x0
  801870:	6a 00                	push   $0x0
  801872:	6a 00                	push   $0x0
  801874:	52                   	push   %edx
  801875:	50                   	push   %eax
  801876:	6a 2e                	push   $0x2e
  801878:	e8 69 f9 ff ff       	call   8011e6 <syscall>
  80187d:	83 c4 18             	add    $0x18,%esp
    return;
  801880:	90                   	nop
}
  801881:	c9                   	leave  
  801882:	c3                   	ret    

00801883 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801883:	55                   	push   %ebp
  801884:	89 e5                	mov    %esp,%ebp
  801886:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801889:	8b 55 08             	mov    0x8(%ebp),%edx
  80188c:	89 d0                	mov    %edx,%eax
  80188e:	c1 e0 02             	shl    $0x2,%eax
  801891:	01 d0                	add    %edx,%eax
  801893:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80189a:	01 d0                	add    %edx,%eax
  80189c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018a3:	01 d0                	add    %edx,%eax
  8018a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018ac:	01 d0                	add    %edx,%eax
  8018ae:	c1 e0 04             	shl    $0x4,%eax
  8018b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8018b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8018bb:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8018be:	83 ec 0c             	sub    $0xc,%esp
  8018c1:	50                   	push   %eax
  8018c2:	e8 54 fc ff ff       	call   80151b <sys_get_virtual_time>
  8018c7:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8018ca:	eb 41                	jmp    80190d <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8018cc:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8018cf:	83 ec 0c             	sub    $0xc,%esp
  8018d2:	50                   	push   %eax
  8018d3:	e8 43 fc ff ff       	call   80151b <sys_get_virtual_time>
  8018d8:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8018db:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8018de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018e1:	29 c2                	sub    %eax,%edx
  8018e3:	89 d0                	mov    %edx,%eax
  8018e5:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8018e8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8018eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018ee:	89 d1                	mov    %edx,%ecx
  8018f0:	29 c1                	sub    %eax,%ecx
  8018f2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8018f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018f8:	39 c2                	cmp    %eax,%edx
  8018fa:	0f 97 c0             	seta   %al
  8018fd:	0f b6 c0             	movzbl %al,%eax
  801900:	29 c1                	sub    %eax,%ecx
  801902:	89 c8                	mov    %ecx,%eax
  801904:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801907:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80190a:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80190d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801910:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801913:	72 b7                	jb     8018cc <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801915:	90                   	nop
  801916:	c9                   	leave  
  801917:	c3                   	ret    

00801918 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801918:	55                   	push   %ebp
  801919:	89 e5                	mov    %esp,%ebp
  80191b:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80191e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801925:	eb 03                	jmp    80192a <busy_wait+0x12>
  801927:	ff 45 fc             	incl   -0x4(%ebp)
  80192a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80192d:	3b 45 08             	cmp    0x8(%ebp),%eax
  801930:	72 f5                	jb     801927 <busy_wait+0xf>
	return i;
  801932:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801935:	c9                   	leave  
  801936:	c3                   	ret    

00801937 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801937:	55                   	push   %ebp
  801938:	89 e5                	mov    %esp,%ebp
  80193a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80193d:	8d 45 10             	lea    0x10(%ebp),%eax
  801940:	83 c0 04             	add    $0x4,%eax
  801943:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801946:	a1 28 30 80 00       	mov    0x803028,%eax
  80194b:	85 c0                	test   %eax,%eax
  80194d:	74 16                	je     801965 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80194f:	a1 28 30 80 00       	mov    0x803028,%eax
  801954:	83 ec 08             	sub    $0x8,%esp
  801957:	50                   	push   %eax
  801958:	68 78 24 80 00       	push   $0x802478
  80195d:	e8 ea ea ff ff       	call   80044c <cprintf>
  801962:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801965:	a1 04 30 80 00       	mov    0x803004,%eax
  80196a:	ff 75 0c             	pushl  0xc(%ebp)
  80196d:	ff 75 08             	pushl  0x8(%ebp)
  801970:	50                   	push   %eax
  801971:	68 7d 24 80 00       	push   $0x80247d
  801976:	e8 d1 ea ff ff       	call   80044c <cprintf>
  80197b:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80197e:	8b 45 10             	mov    0x10(%ebp),%eax
  801981:	83 ec 08             	sub    $0x8,%esp
  801984:	ff 75 f4             	pushl  -0xc(%ebp)
  801987:	50                   	push   %eax
  801988:	e8 54 ea ff ff       	call   8003e1 <vcprintf>
  80198d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801990:	83 ec 08             	sub    $0x8,%esp
  801993:	6a 00                	push   $0x0
  801995:	68 99 24 80 00       	push   $0x802499
  80199a:	e8 42 ea ff ff       	call   8003e1 <vcprintf>
  80199f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8019a2:	e8 c3 e9 ff ff       	call   80036a <exit>

	// should not return here
	while (1) ;
  8019a7:	eb fe                	jmp    8019a7 <_panic+0x70>

008019a9 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8019a9:	55                   	push   %ebp
  8019aa:	89 e5                	mov    %esp,%ebp
  8019ac:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8019af:	a1 08 30 80 00       	mov    0x803008,%eax
  8019b4:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8019ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019bd:	39 c2                	cmp    %eax,%edx
  8019bf:	74 14                	je     8019d5 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8019c1:	83 ec 04             	sub    $0x4,%esp
  8019c4:	68 9c 24 80 00       	push   $0x80249c
  8019c9:	6a 26                	push   $0x26
  8019cb:	68 e8 24 80 00       	push   $0x8024e8
  8019d0:	e8 62 ff ff ff       	call   801937 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8019d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8019dc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8019e3:	e9 c5 00 00 00       	jmp    801aad <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8019e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f5:	01 d0                	add    %edx,%eax
  8019f7:	8b 00                	mov    (%eax),%eax
  8019f9:	85 c0                	test   %eax,%eax
  8019fb:	75 08                	jne    801a05 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8019fd:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801a00:	e9 a5 00 00 00       	jmp    801aaa <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801a05:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a0c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801a13:	eb 69                	jmp    801a7e <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801a15:	a1 08 30 80 00       	mov    0x803008,%eax
  801a1a:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  801a20:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a23:	89 d0                	mov    %edx,%eax
  801a25:	01 c0                	add    %eax,%eax
  801a27:	01 d0                	add    %edx,%eax
  801a29:	c1 e0 03             	shl    $0x3,%eax
  801a2c:	01 c8                	add    %ecx,%eax
  801a2e:	8a 40 04             	mov    0x4(%eax),%al
  801a31:	84 c0                	test   %al,%al
  801a33:	75 46                	jne    801a7b <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801a35:	a1 08 30 80 00       	mov    0x803008,%eax
  801a3a:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  801a40:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a43:	89 d0                	mov    %edx,%eax
  801a45:	01 c0                	add    %eax,%eax
  801a47:	01 d0                	add    %edx,%eax
  801a49:	c1 e0 03             	shl    $0x3,%eax
  801a4c:	01 c8                	add    %ecx,%eax
  801a4e:	8b 00                	mov    (%eax),%eax
  801a50:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801a53:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a56:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a5b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801a5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a60:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801a67:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6a:	01 c8                	add    %ecx,%eax
  801a6c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801a6e:	39 c2                	cmp    %eax,%edx
  801a70:	75 09                	jne    801a7b <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801a72:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801a79:	eb 15                	jmp    801a90 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a7b:	ff 45 e8             	incl   -0x18(%ebp)
  801a7e:	a1 08 30 80 00       	mov    0x803008,%eax
  801a83:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801a89:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a8c:	39 c2                	cmp    %eax,%edx
  801a8e:	77 85                	ja     801a15 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801a90:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a94:	75 14                	jne    801aaa <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801a96:	83 ec 04             	sub    $0x4,%esp
  801a99:	68 f4 24 80 00       	push   $0x8024f4
  801a9e:	6a 3a                	push   $0x3a
  801aa0:	68 e8 24 80 00       	push   $0x8024e8
  801aa5:	e8 8d fe ff ff       	call   801937 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801aaa:	ff 45 f0             	incl   -0x10(%ebp)
  801aad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ab0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801ab3:	0f 8c 2f ff ff ff    	jl     8019e8 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801ab9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801ac0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801ac7:	eb 26                	jmp    801aef <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801ac9:	a1 08 30 80 00       	mov    0x803008,%eax
  801ace:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  801ad4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ad7:	89 d0                	mov    %edx,%eax
  801ad9:	01 c0                	add    %eax,%eax
  801adb:	01 d0                	add    %edx,%eax
  801add:	c1 e0 03             	shl    $0x3,%eax
  801ae0:	01 c8                	add    %ecx,%eax
  801ae2:	8a 40 04             	mov    0x4(%eax),%al
  801ae5:	3c 01                	cmp    $0x1,%al
  801ae7:	75 03                	jne    801aec <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801ae9:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801aec:	ff 45 e0             	incl   -0x20(%ebp)
  801aef:	a1 08 30 80 00       	mov    0x803008,%eax
  801af4:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801afa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801afd:	39 c2                	cmp    %eax,%edx
  801aff:	77 c8                	ja     801ac9 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b04:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801b07:	74 14                	je     801b1d <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801b09:	83 ec 04             	sub    $0x4,%esp
  801b0c:	68 48 25 80 00       	push   $0x802548
  801b11:	6a 44                	push   $0x44
  801b13:	68 e8 24 80 00       	push   $0x8024e8
  801b18:	e8 1a fe ff ff       	call   801937 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801b1d:	90                   	nop
  801b1e:	c9                   	leave  
  801b1f:	c3                   	ret    

00801b20 <__udivdi3>:
  801b20:	55                   	push   %ebp
  801b21:	57                   	push   %edi
  801b22:	56                   	push   %esi
  801b23:	53                   	push   %ebx
  801b24:	83 ec 1c             	sub    $0x1c,%esp
  801b27:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b2b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801b2f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b33:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b37:	89 ca                	mov    %ecx,%edx
  801b39:	89 f8                	mov    %edi,%eax
  801b3b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801b3f:	85 f6                	test   %esi,%esi
  801b41:	75 2d                	jne    801b70 <__udivdi3+0x50>
  801b43:	39 cf                	cmp    %ecx,%edi
  801b45:	77 65                	ja     801bac <__udivdi3+0x8c>
  801b47:	89 fd                	mov    %edi,%ebp
  801b49:	85 ff                	test   %edi,%edi
  801b4b:	75 0b                	jne    801b58 <__udivdi3+0x38>
  801b4d:	b8 01 00 00 00       	mov    $0x1,%eax
  801b52:	31 d2                	xor    %edx,%edx
  801b54:	f7 f7                	div    %edi
  801b56:	89 c5                	mov    %eax,%ebp
  801b58:	31 d2                	xor    %edx,%edx
  801b5a:	89 c8                	mov    %ecx,%eax
  801b5c:	f7 f5                	div    %ebp
  801b5e:	89 c1                	mov    %eax,%ecx
  801b60:	89 d8                	mov    %ebx,%eax
  801b62:	f7 f5                	div    %ebp
  801b64:	89 cf                	mov    %ecx,%edi
  801b66:	89 fa                	mov    %edi,%edx
  801b68:	83 c4 1c             	add    $0x1c,%esp
  801b6b:	5b                   	pop    %ebx
  801b6c:	5e                   	pop    %esi
  801b6d:	5f                   	pop    %edi
  801b6e:	5d                   	pop    %ebp
  801b6f:	c3                   	ret    
  801b70:	39 ce                	cmp    %ecx,%esi
  801b72:	77 28                	ja     801b9c <__udivdi3+0x7c>
  801b74:	0f bd fe             	bsr    %esi,%edi
  801b77:	83 f7 1f             	xor    $0x1f,%edi
  801b7a:	75 40                	jne    801bbc <__udivdi3+0x9c>
  801b7c:	39 ce                	cmp    %ecx,%esi
  801b7e:	72 0a                	jb     801b8a <__udivdi3+0x6a>
  801b80:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801b84:	0f 87 9e 00 00 00    	ja     801c28 <__udivdi3+0x108>
  801b8a:	b8 01 00 00 00       	mov    $0x1,%eax
  801b8f:	89 fa                	mov    %edi,%edx
  801b91:	83 c4 1c             	add    $0x1c,%esp
  801b94:	5b                   	pop    %ebx
  801b95:	5e                   	pop    %esi
  801b96:	5f                   	pop    %edi
  801b97:	5d                   	pop    %ebp
  801b98:	c3                   	ret    
  801b99:	8d 76 00             	lea    0x0(%esi),%esi
  801b9c:	31 ff                	xor    %edi,%edi
  801b9e:	31 c0                	xor    %eax,%eax
  801ba0:	89 fa                	mov    %edi,%edx
  801ba2:	83 c4 1c             	add    $0x1c,%esp
  801ba5:	5b                   	pop    %ebx
  801ba6:	5e                   	pop    %esi
  801ba7:	5f                   	pop    %edi
  801ba8:	5d                   	pop    %ebp
  801ba9:	c3                   	ret    
  801baa:	66 90                	xchg   %ax,%ax
  801bac:	89 d8                	mov    %ebx,%eax
  801bae:	f7 f7                	div    %edi
  801bb0:	31 ff                	xor    %edi,%edi
  801bb2:	89 fa                	mov    %edi,%edx
  801bb4:	83 c4 1c             	add    $0x1c,%esp
  801bb7:	5b                   	pop    %ebx
  801bb8:	5e                   	pop    %esi
  801bb9:	5f                   	pop    %edi
  801bba:	5d                   	pop    %ebp
  801bbb:	c3                   	ret    
  801bbc:	bd 20 00 00 00       	mov    $0x20,%ebp
  801bc1:	89 eb                	mov    %ebp,%ebx
  801bc3:	29 fb                	sub    %edi,%ebx
  801bc5:	89 f9                	mov    %edi,%ecx
  801bc7:	d3 e6                	shl    %cl,%esi
  801bc9:	89 c5                	mov    %eax,%ebp
  801bcb:	88 d9                	mov    %bl,%cl
  801bcd:	d3 ed                	shr    %cl,%ebp
  801bcf:	89 e9                	mov    %ebp,%ecx
  801bd1:	09 f1                	or     %esi,%ecx
  801bd3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801bd7:	89 f9                	mov    %edi,%ecx
  801bd9:	d3 e0                	shl    %cl,%eax
  801bdb:	89 c5                	mov    %eax,%ebp
  801bdd:	89 d6                	mov    %edx,%esi
  801bdf:	88 d9                	mov    %bl,%cl
  801be1:	d3 ee                	shr    %cl,%esi
  801be3:	89 f9                	mov    %edi,%ecx
  801be5:	d3 e2                	shl    %cl,%edx
  801be7:	8b 44 24 08          	mov    0x8(%esp),%eax
  801beb:	88 d9                	mov    %bl,%cl
  801bed:	d3 e8                	shr    %cl,%eax
  801bef:	09 c2                	or     %eax,%edx
  801bf1:	89 d0                	mov    %edx,%eax
  801bf3:	89 f2                	mov    %esi,%edx
  801bf5:	f7 74 24 0c          	divl   0xc(%esp)
  801bf9:	89 d6                	mov    %edx,%esi
  801bfb:	89 c3                	mov    %eax,%ebx
  801bfd:	f7 e5                	mul    %ebp
  801bff:	39 d6                	cmp    %edx,%esi
  801c01:	72 19                	jb     801c1c <__udivdi3+0xfc>
  801c03:	74 0b                	je     801c10 <__udivdi3+0xf0>
  801c05:	89 d8                	mov    %ebx,%eax
  801c07:	31 ff                	xor    %edi,%edi
  801c09:	e9 58 ff ff ff       	jmp    801b66 <__udivdi3+0x46>
  801c0e:	66 90                	xchg   %ax,%ax
  801c10:	8b 54 24 08          	mov    0x8(%esp),%edx
  801c14:	89 f9                	mov    %edi,%ecx
  801c16:	d3 e2                	shl    %cl,%edx
  801c18:	39 c2                	cmp    %eax,%edx
  801c1a:	73 e9                	jae    801c05 <__udivdi3+0xe5>
  801c1c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c1f:	31 ff                	xor    %edi,%edi
  801c21:	e9 40 ff ff ff       	jmp    801b66 <__udivdi3+0x46>
  801c26:	66 90                	xchg   %ax,%ax
  801c28:	31 c0                	xor    %eax,%eax
  801c2a:	e9 37 ff ff ff       	jmp    801b66 <__udivdi3+0x46>
  801c2f:	90                   	nop

00801c30 <__umoddi3>:
  801c30:	55                   	push   %ebp
  801c31:	57                   	push   %edi
  801c32:	56                   	push   %esi
  801c33:	53                   	push   %ebx
  801c34:	83 ec 1c             	sub    $0x1c,%esp
  801c37:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801c3b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c3f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c43:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801c47:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c4b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c4f:	89 f3                	mov    %esi,%ebx
  801c51:	89 fa                	mov    %edi,%edx
  801c53:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c57:	89 34 24             	mov    %esi,(%esp)
  801c5a:	85 c0                	test   %eax,%eax
  801c5c:	75 1a                	jne    801c78 <__umoddi3+0x48>
  801c5e:	39 f7                	cmp    %esi,%edi
  801c60:	0f 86 a2 00 00 00    	jbe    801d08 <__umoddi3+0xd8>
  801c66:	89 c8                	mov    %ecx,%eax
  801c68:	89 f2                	mov    %esi,%edx
  801c6a:	f7 f7                	div    %edi
  801c6c:	89 d0                	mov    %edx,%eax
  801c6e:	31 d2                	xor    %edx,%edx
  801c70:	83 c4 1c             	add    $0x1c,%esp
  801c73:	5b                   	pop    %ebx
  801c74:	5e                   	pop    %esi
  801c75:	5f                   	pop    %edi
  801c76:	5d                   	pop    %ebp
  801c77:	c3                   	ret    
  801c78:	39 f0                	cmp    %esi,%eax
  801c7a:	0f 87 ac 00 00 00    	ja     801d2c <__umoddi3+0xfc>
  801c80:	0f bd e8             	bsr    %eax,%ebp
  801c83:	83 f5 1f             	xor    $0x1f,%ebp
  801c86:	0f 84 ac 00 00 00    	je     801d38 <__umoddi3+0x108>
  801c8c:	bf 20 00 00 00       	mov    $0x20,%edi
  801c91:	29 ef                	sub    %ebp,%edi
  801c93:	89 fe                	mov    %edi,%esi
  801c95:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801c99:	89 e9                	mov    %ebp,%ecx
  801c9b:	d3 e0                	shl    %cl,%eax
  801c9d:	89 d7                	mov    %edx,%edi
  801c9f:	89 f1                	mov    %esi,%ecx
  801ca1:	d3 ef                	shr    %cl,%edi
  801ca3:	09 c7                	or     %eax,%edi
  801ca5:	89 e9                	mov    %ebp,%ecx
  801ca7:	d3 e2                	shl    %cl,%edx
  801ca9:	89 14 24             	mov    %edx,(%esp)
  801cac:	89 d8                	mov    %ebx,%eax
  801cae:	d3 e0                	shl    %cl,%eax
  801cb0:	89 c2                	mov    %eax,%edx
  801cb2:	8b 44 24 08          	mov    0x8(%esp),%eax
  801cb6:	d3 e0                	shl    %cl,%eax
  801cb8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cbc:	8b 44 24 08          	mov    0x8(%esp),%eax
  801cc0:	89 f1                	mov    %esi,%ecx
  801cc2:	d3 e8                	shr    %cl,%eax
  801cc4:	09 d0                	or     %edx,%eax
  801cc6:	d3 eb                	shr    %cl,%ebx
  801cc8:	89 da                	mov    %ebx,%edx
  801cca:	f7 f7                	div    %edi
  801ccc:	89 d3                	mov    %edx,%ebx
  801cce:	f7 24 24             	mull   (%esp)
  801cd1:	89 c6                	mov    %eax,%esi
  801cd3:	89 d1                	mov    %edx,%ecx
  801cd5:	39 d3                	cmp    %edx,%ebx
  801cd7:	0f 82 87 00 00 00    	jb     801d64 <__umoddi3+0x134>
  801cdd:	0f 84 91 00 00 00    	je     801d74 <__umoddi3+0x144>
  801ce3:	8b 54 24 04          	mov    0x4(%esp),%edx
  801ce7:	29 f2                	sub    %esi,%edx
  801ce9:	19 cb                	sbb    %ecx,%ebx
  801ceb:	89 d8                	mov    %ebx,%eax
  801ced:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801cf1:	d3 e0                	shl    %cl,%eax
  801cf3:	89 e9                	mov    %ebp,%ecx
  801cf5:	d3 ea                	shr    %cl,%edx
  801cf7:	09 d0                	or     %edx,%eax
  801cf9:	89 e9                	mov    %ebp,%ecx
  801cfb:	d3 eb                	shr    %cl,%ebx
  801cfd:	89 da                	mov    %ebx,%edx
  801cff:	83 c4 1c             	add    $0x1c,%esp
  801d02:	5b                   	pop    %ebx
  801d03:	5e                   	pop    %esi
  801d04:	5f                   	pop    %edi
  801d05:	5d                   	pop    %ebp
  801d06:	c3                   	ret    
  801d07:	90                   	nop
  801d08:	89 fd                	mov    %edi,%ebp
  801d0a:	85 ff                	test   %edi,%edi
  801d0c:	75 0b                	jne    801d19 <__umoddi3+0xe9>
  801d0e:	b8 01 00 00 00       	mov    $0x1,%eax
  801d13:	31 d2                	xor    %edx,%edx
  801d15:	f7 f7                	div    %edi
  801d17:	89 c5                	mov    %eax,%ebp
  801d19:	89 f0                	mov    %esi,%eax
  801d1b:	31 d2                	xor    %edx,%edx
  801d1d:	f7 f5                	div    %ebp
  801d1f:	89 c8                	mov    %ecx,%eax
  801d21:	f7 f5                	div    %ebp
  801d23:	89 d0                	mov    %edx,%eax
  801d25:	e9 44 ff ff ff       	jmp    801c6e <__umoddi3+0x3e>
  801d2a:	66 90                	xchg   %ax,%ax
  801d2c:	89 c8                	mov    %ecx,%eax
  801d2e:	89 f2                	mov    %esi,%edx
  801d30:	83 c4 1c             	add    $0x1c,%esp
  801d33:	5b                   	pop    %ebx
  801d34:	5e                   	pop    %esi
  801d35:	5f                   	pop    %edi
  801d36:	5d                   	pop    %ebp
  801d37:	c3                   	ret    
  801d38:	3b 04 24             	cmp    (%esp),%eax
  801d3b:	72 06                	jb     801d43 <__umoddi3+0x113>
  801d3d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801d41:	77 0f                	ja     801d52 <__umoddi3+0x122>
  801d43:	89 f2                	mov    %esi,%edx
  801d45:	29 f9                	sub    %edi,%ecx
  801d47:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801d4b:	89 14 24             	mov    %edx,(%esp)
  801d4e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d52:	8b 44 24 04          	mov    0x4(%esp),%eax
  801d56:	8b 14 24             	mov    (%esp),%edx
  801d59:	83 c4 1c             	add    $0x1c,%esp
  801d5c:	5b                   	pop    %ebx
  801d5d:	5e                   	pop    %esi
  801d5e:	5f                   	pop    %edi
  801d5f:	5d                   	pop    %ebp
  801d60:	c3                   	ret    
  801d61:	8d 76 00             	lea    0x0(%esi),%esi
  801d64:	2b 04 24             	sub    (%esp),%eax
  801d67:	19 fa                	sbb    %edi,%edx
  801d69:	89 d1                	mov    %edx,%ecx
  801d6b:	89 c6                	mov    %eax,%esi
  801d6d:	e9 71 ff ff ff       	jmp    801ce3 <__umoddi3+0xb3>
  801d72:	66 90                	xchg   %ax,%ax
  801d74:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801d78:	72 ea                	jb     801d64 <__umoddi3+0x134>
  801d7a:	89 d9                	mov    %ebx,%ecx
  801d7c:	e9 62 ff ff ff       	jmp    801ce3 <__umoddi3+0xb3>
