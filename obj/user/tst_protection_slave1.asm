
obj/user/tst_protection_slave1:     file format elf32-i386


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
  800031:	e8 02 01 00 00       	call   800138 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 58 4e 00 00    	sub    $0x4e58,%esp

	/*=================================================*/
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  800041:	a1 20 40 80 00       	mov    0x804020,%eax
  800046:	8b 90 a0 00 00 00    	mov    0xa0(%eax),%edx
  80004c:	a1 20 40 80 00       	mov    0x804020,%eax
  800051:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  800057:	39 c2                	cmp    %eax,%edx
  800059:	72 14                	jb     80006f <_main+0x37>
			panic("Please increase the WS size");
  80005b:	83 ec 04             	sub    $0x4,%esp
  80005e:	68 40 35 80 00       	push   $0x803540
  800063:	6a 12                	push   $0x12
  800065:	68 5c 35 80 00       	push   $0x80355c
  80006a:	e8 0e 02 00 00       	call   80027d <_panic>
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	{
		char initname[10] = "x";
  80006f:	c7 45 e6 78 00 00 00 	movl   $0x78,-0x1a(%ebp)
  800076:	c7 45 ea 00 00 00 00 	movl   $0x0,-0x16(%ebp)
  80007d:	66 c7 45 ee 00 00    	movw   $0x0,-0x12(%ebp)
		char name[10] ;
#define NUM_OF_OBJS 5000
		uint32* vars[NUM_OF_OBJS];
		for (int s = 0; s < NUM_OF_OBJS; ++s)
  800083:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80008a:	eb 5d                	jmp    8000e9 <_main+0xb1>
		{

			char index[10];
			ltostr(s, index);
  80008c:	83 ec 08             	sub    $0x8,%esp
  80008f:	8d 45 d2             	lea    -0x2e(%ebp),%eax
  800092:	50                   	push   %eax
  800093:	ff 75 f4             	pushl  -0xc(%ebp)
  800096:	e8 d9 0f 00 00       	call   801074 <ltostr>
  80009b:	83 c4 10             	add    $0x10,%esp
			strcconcat(initname, index, name);
  80009e:	83 ec 04             	sub    $0x4,%esp
  8000a1:	8d 45 dc             	lea    -0x24(%ebp),%eax
  8000a4:	50                   	push   %eax
  8000a5:	8d 45 d2             	lea    -0x2e(%ebp),%eax
  8000a8:	50                   	push   %eax
  8000a9:	8d 45 e6             	lea    -0x1a(%ebp),%eax
  8000ac:	50                   	push   %eax
  8000ad:	e8 9b 10 00 00       	call   80114d <strcconcat>
  8000b2:	83 c4 10             	add    $0x10,%esp
			vars[s] = smalloc(name, PAGE_SIZE, 1);
  8000b5:	83 ec 04             	sub    $0x4,%esp
  8000b8:	6a 01                	push   $0x1
  8000ba:	68 00 10 00 00       	push   $0x1000
  8000bf:	8d 45 dc             	lea    -0x24(%ebp),%eax
  8000c2:	50                   	push   %eax
  8000c3:	e8 d9 14 00 00       	call   8015a1 <smalloc>
  8000c8:	83 c4 10             	add    $0x10,%esp
  8000cb:	89 c2                	mov    %eax,%edx
  8000cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000d0:	89 94 85 b0 b1 ff ff 	mov    %edx,-0x4e50(%ebp,%eax,4)
			*vars[s] = s;
  8000d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000da:	8b 84 85 b0 b1 ff ff 	mov    -0x4e50(%ebp,%eax,4),%eax
  8000e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000e4:	89 10                	mov    %edx,(%eax)
	{
		char initname[10] = "x";
		char name[10] ;
#define NUM_OF_OBJS 5000
		uint32* vars[NUM_OF_OBJS];
		for (int s = 0; s < NUM_OF_OBJS; ++s)
  8000e6:	ff 45 f4             	incl   -0xc(%ebp)
  8000e9:	81 7d f4 87 13 00 00 	cmpl   $0x1387,-0xc(%ebp)
  8000f0:	7e 9a                	jle    80008c <_main+0x54>
			strcconcat(initname, index, name);
			vars[s] = smalloc(name, PAGE_SIZE, 1);
			*vars[s] = s;
		}

		for (int s = 0; s < NUM_OF_OBJS; ++s)
  8000f2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8000f9:	eb 2c                	jmp    800127 <_main+0xef>
		{

			assert(*vars[s] == s);
  8000fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000fe:	8b 84 85 b0 b1 ff ff 	mov    -0x4e50(%ebp,%eax,4),%eax
  800105:	8b 10                	mov    (%eax),%edx
  800107:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80010a:	39 c2                	cmp    %eax,%edx
  80010c:	74 16                	je     800124 <_main+0xec>
  80010e:	68 79 35 80 00       	push   $0x803579
  800113:	68 87 35 80 00       	push   $0x803587
  800118:	6a 2b                	push   $0x2b
  80011a:	68 5c 35 80 00       	push   $0x80355c
  80011f:	e8 59 01 00 00       	call   80027d <_panic>
			strcconcat(initname, index, name);
			vars[s] = smalloc(name, PAGE_SIZE, 1);
			*vars[s] = s;
		}

		for (int s = 0; s < NUM_OF_OBJS; ++s)
  800124:	ff 45 f0             	incl   -0x10(%ebp)
  800127:	81 7d f0 87 13 00 00 	cmpl   $0x1387,-0x10(%ebp)
  80012e:	7e cb                	jle    8000fb <_main+0xc3>
			assert(*vars[s] == s);
		}

	}

	inctst();
  800130:	e8 91 1c 00 00       	call   801dc6 <inctst>
}
  800135:	90                   	nop
  800136:	c9                   	leave  
  800137:	c3                   	ret    

00800138 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800138:	55                   	push   %ebp
  800139:	89 e5                	mov    %esp,%ebp
  80013b:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80013e:	e8 45 1b 00 00       	call   801c88 <sys_getenvindex>
  800143:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800146:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800149:	89 d0                	mov    %edx,%eax
  80014b:	c1 e0 02             	shl    $0x2,%eax
  80014e:	01 d0                	add    %edx,%eax
  800150:	c1 e0 03             	shl    $0x3,%eax
  800153:	01 d0                	add    %edx,%eax
  800155:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80015c:	01 d0                	add    %edx,%eax
  80015e:	c1 e0 02             	shl    $0x2,%eax
  800161:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800166:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80016b:	a1 20 40 80 00       	mov    0x804020,%eax
  800170:	8a 40 20             	mov    0x20(%eax),%al
  800173:	84 c0                	test   %al,%al
  800175:	74 0d                	je     800184 <libmain+0x4c>
		binaryname = myEnv->prog_name;
  800177:	a1 20 40 80 00       	mov    0x804020,%eax
  80017c:	83 c0 20             	add    $0x20,%eax
  80017f:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800184:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800188:	7e 0a                	jle    800194 <libmain+0x5c>
		binaryname = argv[0];
  80018a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80018d:	8b 00                	mov    (%eax),%eax
  80018f:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  800194:	83 ec 08             	sub    $0x8,%esp
  800197:	ff 75 0c             	pushl  0xc(%ebp)
  80019a:	ff 75 08             	pushl  0x8(%ebp)
  80019d:	e8 96 fe ff ff       	call   800038 <_main>
  8001a2:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8001a5:	a1 00 40 80 00       	mov    0x804000,%eax
  8001aa:	85 c0                	test   %eax,%eax
  8001ac:	0f 84 9f 00 00 00    	je     800251 <libmain+0x119>
	{
		sys_lock_cons();
  8001b2:	e8 55 18 00 00       	call   801a0c <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8001b7:	83 ec 0c             	sub    $0xc,%esp
  8001ba:	68 b4 35 80 00       	push   $0x8035b4
  8001bf:	e8 76 03 00 00       	call   80053a <cprintf>
  8001c4:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001c7:	a1 20 40 80 00       	mov    0x804020,%eax
  8001cc:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8001d2:	a1 20 40 80 00       	mov    0x804020,%eax
  8001d7:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8001dd:	83 ec 04             	sub    $0x4,%esp
  8001e0:	52                   	push   %edx
  8001e1:	50                   	push   %eax
  8001e2:	68 dc 35 80 00       	push   $0x8035dc
  8001e7:	e8 4e 03 00 00       	call   80053a <cprintf>
  8001ec:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001ef:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f4:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8001fa:	a1 20 40 80 00       	mov    0x804020,%eax
  8001ff:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800205:	a1 20 40 80 00       	mov    0x804020,%eax
  80020a:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800210:	51                   	push   %ecx
  800211:	52                   	push   %edx
  800212:	50                   	push   %eax
  800213:	68 04 36 80 00       	push   $0x803604
  800218:	e8 1d 03 00 00       	call   80053a <cprintf>
  80021d:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800220:	a1 20 40 80 00       	mov    0x804020,%eax
  800225:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  80022b:	83 ec 08             	sub    $0x8,%esp
  80022e:	50                   	push   %eax
  80022f:	68 5c 36 80 00       	push   $0x80365c
  800234:	e8 01 03 00 00       	call   80053a <cprintf>
  800239:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80023c:	83 ec 0c             	sub    $0xc,%esp
  80023f:	68 b4 35 80 00       	push   $0x8035b4
  800244:	e8 f1 02 00 00       	call   80053a <cprintf>
  800249:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80024c:	e8 d5 17 00 00       	call   801a26 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800251:	e8 19 00 00 00       	call   80026f <exit>
}
  800256:	90                   	nop
  800257:	c9                   	leave  
  800258:	c3                   	ret    

00800259 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800259:	55                   	push   %ebp
  80025a:	89 e5                	mov    %esp,%ebp
  80025c:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80025f:	83 ec 0c             	sub    $0xc,%esp
  800262:	6a 00                	push   $0x0
  800264:	e8 eb 19 00 00       	call   801c54 <sys_destroy_env>
  800269:	83 c4 10             	add    $0x10,%esp
}
  80026c:	90                   	nop
  80026d:	c9                   	leave  
  80026e:	c3                   	ret    

0080026f <exit>:

void
exit(void)
{
  80026f:	55                   	push   %ebp
  800270:	89 e5                	mov    %esp,%ebp
  800272:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800275:	e8 40 1a 00 00       	call   801cba <sys_exit_env>
}
  80027a:	90                   	nop
  80027b:	c9                   	leave  
  80027c:	c3                   	ret    

0080027d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80027d:	55                   	push   %ebp
  80027e:	89 e5                	mov    %esp,%ebp
  800280:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800283:	8d 45 10             	lea    0x10(%ebp),%eax
  800286:	83 c0 04             	add    $0x4,%eax
  800289:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80028c:	a1 60 40 98 00       	mov    0x984060,%eax
  800291:	85 c0                	test   %eax,%eax
  800293:	74 16                	je     8002ab <_panic+0x2e>
		cprintf("%s: ", argv0);
  800295:	a1 60 40 98 00       	mov    0x984060,%eax
  80029a:	83 ec 08             	sub    $0x8,%esp
  80029d:	50                   	push   %eax
  80029e:	68 70 36 80 00       	push   $0x803670
  8002a3:	e8 92 02 00 00       	call   80053a <cprintf>
  8002a8:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002ab:	a1 04 40 80 00       	mov    0x804004,%eax
  8002b0:	ff 75 0c             	pushl  0xc(%ebp)
  8002b3:	ff 75 08             	pushl  0x8(%ebp)
  8002b6:	50                   	push   %eax
  8002b7:	68 75 36 80 00       	push   $0x803675
  8002bc:	e8 79 02 00 00       	call   80053a <cprintf>
  8002c1:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8002c7:	83 ec 08             	sub    $0x8,%esp
  8002ca:	ff 75 f4             	pushl  -0xc(%ebp)
  8002cd:	50                   	push   %eax
  8002ce:	e8 fc 01 00 00       	call   8004cf <vcprintf>
  8002d3:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002d6:	83 ec 08             	sub    $0x8,%esp
  8002d9:	6a 00                	push   $0x0
  8002db:	68 91 36 80 00       	push   $0x803691
  8002e0:	e8 ea 01 00 00       	call   8004cf <vcprintf>
  8002e5:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002e8:	e8 82 ff ff ff       	call   80026f <exit>

	// should not return here
	while (1) ;
  8002ed:	eb fe                	jmp    8002ed <_panic+0x70>

008002ef <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002ef:	55                   	push   %ebp
  8002f0:	89 e5                	mov    %esp,%ebp
  8002f2:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002f5:	a1 20 40 80 00       	mov    0x804020,%eax
  8002fa:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800300:	8b 45 0c             	mov    0xc(%ebp),%eax
  800303:	39 c2                	cmp    %eax,%edx
  800305:	74 14                	je     80031b <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800307:	83 ec 04             	sub    $0x4,%esp
  80030a:	68 94 36 80 00       	push   $0x803694
  80030f:	6a 26                	push   $0x26
  800311:	68 e0 36 80 00       	push   $0x8036e0
  800316:	e8 62 ff ff ff       	call   80027d <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80031b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800322:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800329:	e9 c5 00 00 00       	jmp    8003f3 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80032e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800331:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800338:	8b 45 08             	mov    0x8(%ebp),%eax
  80033b:	01 d0                	add    %edx,%eax
  80033d:	8b 00                	mov    (%eax),%eax
  80033f:	85 c0                	test   %eax,%eax
  800341:	75 08                	jne    80034b <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800343:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800346:	e9 a5 00 00 00       	jmp    8003f0 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80034b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800352:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800359:	eb 69                	jmp    8003c4 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80035b:	a1 20 40 80 00       	mov    0x804020,%eax
  800360:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800366:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800369:	89 d0                	mov    %edx,%eax
  80036b:	01 c0                	add    %eax,%eax
  80036d:	01 d0                	add    %edx,%eax
  80036f:	c1 e0 03             	shl    $0x3,%eax
  800372:	01 c8                	add    %ecx,%eax
  800374:	8a 40 04             	mov    0x4(%eax),%al
  800377:	84 c0                	test   %al,%al
  800379:	75 46                	jne    8003c1 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80037b:	a1 20 40 80 00       	mov    0x804020,%eax
  800380:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800386:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800389:	89 d0                	mov    %edx,%eax
  80038b:	01 c0                	add    %eax,%eax
  80038d:	01 d0                	add    %edx,%eax
  80038f:	c1 e0 03             	shl    $0x3,%eax
  800392:	01 c8                	add    %ecx,%eax
  800394:	8b 00                	mov    (%eax),%eax
  800396:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800399:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80039c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003a1:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003a6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b0:	01 c8                	add    %ecx,%eax
  8003b2:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003b4:	39 c2                	cmp    %eax,%edx
  8003b6:	75 09                	jne    8003c1 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8003b8:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003bf:	eb 15                	jmp    8003d6 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003c1:	ff 45 e8             	incl   -0x18(%ebp)
  8003c4:	a1 20 40 80 00       	mov    0x804020,%eax
  8003c9:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8003cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003d2:	39 c2                	cmp    %eax,%edx
  8003d4:	77 85                	ja     80035b <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003d6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003da:	75 14                	jne    8003f0 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8003dc:	83 ec 04             	sub    $0x4,%esp
  8003df:	68 ec 36 80 00       	push   $0x8036ec
  8003e4:	6a 3a                	push   $0x3a
  8003e6:	68 e0 36 80 00       	push   $0x8036e0
  8003eb:	e8 8d fe ff ff       	call   80027d <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003f0:	ff 45 f0             	incl   -0x10(%ebp)
  8003f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003f9:	0f 8c 2f ff ff ff    	jl     80032e <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003ff:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800406:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80040d:	eb 26                	jmp    800435 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80040f:	a1 20 40 80 00       	mov    0x804020,%eax
  800414:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  80041a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80041d:	89 d0                	mov    %edx,%eax
  80041f:	01 c0                	add    %eax,%eax
  800421:	01 d0                	add    %edx,%eax
  800423:	c1 e0 03             	shl    $0x3,%eax
  800426:	01 c8                	add    %ecx,%eax
  800428:	8a 40 04             	mov    0x4(%eax),%al
  80042b:	3c 01                	cmp    $0x1,%al
  80042d:	75 03                	jne    800432 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80042f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800432:	ff 45 e0             	incl   -0x20(%ebp)
  800435:	a1 20 40 80 00       	mov    0x804020,%eax
  80043a:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800440:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800443:	39 c2                	cmp    %eax,%edx
  800445:	77 c8                	ja     80040f <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800447:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80044a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80044d:	74 14                	je     800463 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80044f:	83 ec 04             	sub    $0x4,%esp
  800452:	68 40 37 80 00       	push   $0x803740
  800457:	6a 44                	push   $0x44
  800459:	68 e0 36 80 00       	push   $0x8036e0
  80045e:	e8 1a fe ff ff       	call   80027d <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800463:	90                   	nop
  800464:	c9                   	leave  
  800465:	c3                   	ret    

00800466 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800466:	55                   	push   %ebp
  800467:	89 e5                	mov    %esp,%ebp
  800469:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80046c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80046f:	8b 00                	mov    (%eax),%eax
  800471:	8d 48 01             	lea    0x1(%eax),%ecx
  800474:	8b 55 0c             	mov    0xc(%ebp),%edx
  800477:	89 0a                	mov    %ecx,(%edx)
  800479:	8b 55 08             	mov    0x8(%ebp),%edx
  80047c:	88 d1                	mov    %dl,%cl
  80047e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800481:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800485:	8b 45 0c             	mov    0xc(%ebp),%eax
  800488:	8b 00                	mov    (%eax),%eax
  80048a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80048f:	75 2c                	jne    8004bd <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800491:	a0 44 40 98 00       	mov    0x984044,%al
  800496:	0f b6 c0             	movzbl %al,%eax
  800499:	8b 55 0c             	mov    0xc(%ebp),%edx
  80049c:	8b 12                	mov    (%edx),%edx
  80049e:	89 d1                	mov    %edx,%ecx
  8004a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004a3:	83 c2 08             	add    $0x8,%edx
  8004a6:	83 ec 04             	sub    $0x4,%esp
  8004a9:	50                   	push   %eax
  8004aa:	51                   	push   %ecx
  8004ab:	52                   	push   %edx
  8004ac:	e8 19 15 00 00       	call   8019ca <sys_cputs>
  8004b1:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c0:	8b 40 04             	mov    0x4(%eax),%eax
  8004c3:	8d 50 01             	lea    0x1(%eax),%edx
  8004c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c9:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004cc:	90                   	nop
  8004cd:	c9                   	leave  
  8004ce:	c3                   	ret    

008004cf <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004cf:	55                   	push   %ebp
  8004d0:	89 e5                	mov    %esp,%ebp
  8004d2:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004d8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004df:	00 00 00 
	b.cnt = 0;
  8004e2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004e9:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004ec:	ff 75 0c             	pushl  0xc(%ebp)
  8004ef:	ff 75 08             	pushl  0x8(%ebp)
  8004f2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004f8:	50                   	push   %eax
  8004f9:	68 66 04 80 00       	push   $0x800466
  8004fe:	e8 11 02 00 00       	call   800714 <vprintfmt>
  800503:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800506:	a0 44 40 98 00       	mov    0x984044,%al
  80050b:	0f b6 c0             	movzbl %al,%eax
  80050e:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800514:	83 ec 04             	sub    $0x4,%esp
  800517:	50                   	push   %eax
  800518:	52                   	push   %edx
  800519:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80051f:	83 c0 08             	add    $0x8,%eax
  800522:	50                   	push   %eax
  800523:	e8 a2 14 00 00       	call   8019ca <sys_cputs>
  800528:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80052b:	c6 05 44 40 98 00 00 	movb   $0x0,0x984044
	return b.cnt;
  800532:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800538:	c9                   	leave  
  800539:	c3                   	ret    

0080053a <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80053a:	55                   	push   %ebp
  80053b:	89 e5                	mov    %esp,%ebp
  80053d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800540:	c6 05 44 40 98 00 01 	movb   $0x1,0x984044
	va_start(ap, fmt);
  800547:	8d 45 0c             	lea    0xc(%ebp),%eax
  80054a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80054d:	8b 45 08             	mov    0x8(%ebp),%eax
  800550:	83 ec 08             	sub    $0x8,%esp
  800553:	ff 75 f4             	pushl  -0xc(%ebp)
  800556:	50                   	push   %eax
  800557:	e8 73 ff ff ff       	call   8004cf <vcprintf>
  80055c:	83 c4 10             	add    $0x10,%esp
  80055f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800562:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800565:	c9                   	leave  
  800566:	c3                   	ret    

00800567 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800567:	55                   	push   %ebp
  800568:	89 e5                	mov    %esp,%ebp
  80056a:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80056d:	e8 9a 14 00 00       	call   801a0c <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800572:	8d 45 0c             	lea    0xc(%ebp),%eax
  800575:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800578:	8b 45 08             	mov    0x8(%ebp),%eax
  80057b:	83 ec 08             	sub    $0x8,%esp
  80057e:	ff 75 f4             	pushl  -0xc(%ebp)
  800581:	50                   	push   %eax
  800582:	e8 48 ff ff ff       	call   8004cf <vcprintf>
  800587:	83 c4 10             	add    $0x10,%esp
  80058a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80058d:	e8 94 14 00 00       	call   801a26 <sys_unlock_cons>
	return cnt;
  800592:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800595:	c9                   	leave  
  800596:	c3                   	ret    

00800597 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800597:	55                   	push   %ebp
  800598:	89 e5                	mov    %esp,%ebp
  80059a:	53                   	push   %ebx
  80059b:	83 ec 14             	sub    $0x14,%esp
  80059e:	8b 45 10             	mov    0x10(%ebp),%eax
  8005a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005aa:	8b 45 18             	mov    0x18(%ebp),%eax
  8005ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005b5:	77 55                	ja     80060c <printnum+0x75>
  8005b7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005ba:	72 05                	jb     8005c1 <printnum+0x2a>
  8005bc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005bf:	77 4b                	ja     80060c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005c1:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005c4:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005c7:	8b 45 18             	mov    0x18(%ebp),%eax
  8005ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8005cf:	52                   	push   %edx
  8005d0:	50                   	push   %eax
  8005d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8005d4:	ff 75 f0             	pushl  -0x10(%ebp)
  8005d7:	e8 f0 2c 00 00       	call   8032cc <__udivdi3>
  8005dc:	83 c4 10             	add    $0x10,%esp
  8005df:	83 ec 04             	sub    $0x4,%esp
  8005e2:	ff 75 20             	pushl  0x20(%ebp)
  8005e5:	53                   	push   %ebx
  8005e6:	ff 75 18             	pushl  0x18(%ebp)
  8005e9:	52                   	push   %edx
  8005ea:	50                   	push   %eax
  8005eb:	ff 75 0c             	pushl  0xc(%ebp)
  8005ee:	ff 75 08             	pushl  0x8(%ebp)
  8005f1:	e8 a1 ff ff ff       	call   800597 <printnum>
  8005f6:	83 c4 20             	add    $0x20,%esp
  8005f9:	eb 1a                	jmp    800615 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005fb:	83 ec 08             	sub    $0x8,%esp
  8005fe:	ff 75 0c             	pushl  0xc(%ebp)
  800601:	ff 75 20             	pushl  0x20(%ebp)
  800604:	8b 45 08             	mov    0x8(%ebp),%eax
  800607:	ff d0                	call   *%eax
  800609:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80060c:	ff 4d 1c             	decl   0x1c(%ebp)
  80060f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800613:	7f e6                	jg     8005fb <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800615:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800618:	bb 00 00 00 00       	mov    $0x0,%ebx
  80061d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800620:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800623:	53                   	push   %ebx
  800624:	51                   	push   %ecx
  800625:	52                   	push   %edx
  800626:	50                   	push   %eax
  800627:	e8 b0 2d 00 00       	call   8033dc <__umoddi3>
  80062c:	83 c4 10             	add    $0x10,%esp
  80062f:	05 b4 39 80 00       	add    $0x8039b4,%eax
  800634:	8a 00                	mov    (%eax),%al
  800636:	0f be c0             	movsbl %al,%eax
  800639:	83 ec 08             	sub    $0x8,%esp
  80063c:	ff 75 0c             	pushl  0xc(%ebp)
  80063f:	50                   	push   %eax
  800640:	8b 45 08             	mov    0x8(%ebp),%eax
  800643:	ff d0                	call   *%eax
  800645:	83 c4 10             	add    $0x10,%esp
}
  800648:	90                   	nop
  800649:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80064c:	c9                   	leave  
  80064d:	c3                   	ret    

0080064e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80064e:	55                   	push   %ebp
  80064f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800651:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800655:	7e 1c                	jle    800673 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800657:	8b 45 08             	mov    0x8(%ebp),%eax
  80065a:	8b 00                	mov    (%eax),%eax
  80065c:	8d 50 08             	lea    0x8(%eax),%edx
  80065f:	8b 45 08             	mov    0x8(%ebp),%eax
  800662:	89 10                	mov    %edx,(%eax)
  800664:	8b 45 08             	mov    0x8(%ebp),%eax
  800667:	8b 00                	mov    (%eax),%eax
  800669:	83 e8 08             	sub    $0x8,%eax
  80066c:	8b 50 04             	mov    0x4(%eax),%edx
  80066f:	8b 00                	mov    (%eax),%eax
  800671:	eb 40                	jmp    8006b3 <getuint+0x65>
	else if (lflag)
  800673:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800677:	74 1e                	je     800697 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800679:	8b 45 08             	mov    0x8(%ebp),%eax
  80067c:	8b 00                	mov    (%eax),%eax
  80067e:	8d 50 04             	lea    0x4(%eax),%edx
  800681:	8b 45 08             	mov    0x8(%ebp),%eax
  800684:	89 10                	mov    %edx,(%eax)
  800686:	8b 45 08             	mov    0x8(%ebp),%eax
  800689:	8b 00                	mov    (%eax),%eax
  80068b:	83 e8 04             	sub    $0x4,%eax
  80068e:	8b 00                	mov    (%eax),%eax
  800690:	ba 00 00 00 00       	mov    $0x0,%edx
  800695:	eb 1c                	jmp    8006b3 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800697:	8b 45 08             	mov    0x8(%ebp),%eax
  80069a:	8b 00                	mov    (%eax),%eax
  80069c:	8d 50 04             	lea    0x4(%eax),%edx
  80069f:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a2:	89 10                	mov    %edx,(%eax)
  8006a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a7:	8b 00                	mov    (%eax),%eax
  8006a9:	83 e8 04             	sub    $0x4,%eax
  8006ac:	8b 00                	mov    (%eax),%eax
  8006ae:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006b3:	5d                   	pop    %ebp
  8006b4:	c3                   	ret    

008006b5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006b5:	55                   	push   %ebp
  8006b6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006b8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006bc:	7e 1c                	jle    8006da <getint+0x25>
		return va_arg(*ap, long long);
  8006be:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c1:	8b 00                	mov    (%eax),%eax
  8006c3:	8d 50 08             	lea    0x8(%eax),%edx
  8006c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c9:	89 10                	mov    %edx,(%eax)
  8006cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ce:	8b 00                	mov    (%eax),%eax
  8006d0:	83 e8 08             	sub    $0x8,%eax
  8006d3:	8b 50 04             	mov    0x4(%eax),%edx
  8006d6:	8b 00                	mov    (%eax),%eax
  8006d8:	eb 38                	jmp    800712 <getint+0x5d>
	else if (lflag)
  8006da:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006de:	74 1a                	je     8006fa <getint+0x45>
		return va_arg(*ap, long);
  8006e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e3:	8b 00                	mov    (%eax),%eax
  8006e5:	8d 50 04             	lea    0x4(%eax),%edx
  8006e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006eb:	89 10                	mov    %edx,(%eax)
  8006ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f0:	8b 00                	mov    (%eax),%eax
  8006f2:	83 e8 04             	sub    $0x4,%eax
  8006f5:	8b 00                	mov    (%eax),%eax
  8006f7:	99                   	cltd   
  8006f8:	eb 18                	jmp    800712 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fd:	8b 00                	mov    (%eax),%eax
  8006ff:	8d 50 04             	lea    0x4(%eax),%edx
  800702:	8b 45 08             	mov    0x8(%ebp),%eax
  800705:	89 10                	mov    %edx,(%eax)
  800707:	8b 45 08             	mov    0x8(%ebp),%eax
  80070a:	8b 00                	mov    (%eax),%eax
  80070c:	83 e8 04             	sub    $0x4,%eax
  80070f:	8b 00                	mov    (%eax),%eax
  800711:	99                   	cltd   
}
  800712:	5d                   	pop    %ebp
  800713:	c3                   	ret    

00800714 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800714:	55                   	push   %ebp
  800715:	89 e5                	mov    %esp,%ebp
  800717:	56                   	push   %esi
  800718:	53                   	push   %ebx
  800719:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80071c:	eb 17                	jmp    800735 <vprintfmt+0x21>
			if (ch == '\0')
  80071e:	85 db                	test   %ebx,%ebx
  800720:	0f 84 c1 03 00 00    	je     800ae7 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800726:	83 ec 08             	sub    $0x8,%esp
  800729:	ff 75 0c             	pushl  0xc(%ebp)
  80072c:	53                   	push   %ebx
  80072d:	8b 45 08             	mov    0x8(%ebp),%eax
  800730:	ff d0                	call   *%eax
  800732:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800735:	8b 45 10             	mov    0x10(%ebp),%eax
  800738:	8d 50 01             	lea    0x1(%eax),%edx
  80073b:	89 55 10             	mov    %edx,0x10(%ebp)
  80073e:	8a 00                	mov    (%eax),%al
  800740:	0f b6 d8             	movzbl %al,%ebx
  800743:	83 fb 25             	cmp    $0x25,%ebx
  800746:	75 d6                	jne    80071e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800748:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80074c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800753:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80075a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800761:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800768:	8b 45 10             	mov    0x10(%ebp),%eax
  80076b:	8d 50 01             	lea    0x1(%eax),%edx
  80076e:	89 55 10             	mov    %edx,0x10(%ebp)
  800771:	8a 00                	mov    (%eax),%al
  800773:	0f b6 d8             	movzbl %al,%ebx
  800776:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800779:	83 f8 5b             	cmp    $0x5b,%eax
  80077c:	0f 87 3d 03 00 00    	ja     800abf <vprintfmt+0x3ab>
  800782:	8b 04 85 d8 39 80 00 	mov    0x8039d8(,%eax,4),%eax
  800789:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80078b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80078f:	eb d7                	jmp    800768 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800791:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800795:	eb d1                	jmp    800768 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800797:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80079e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007a1:	89 d0                	mov    %edx,%eax
  8007a3:	c1 e0 02             	shl    $0x2,%eax
  8007a6:	01 d0                	add    %edx,%eax
  8007a8:	01 c0                	add    %eax,%eax
  8007aa:	01 d8                	add    %ebx,%eax
  8007ac:	83 e8 30             	sub    $0x30,%eax
  8007af:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8007b5:	8a 00                	mov    (%eax),%al
  8007b7:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007ba:	83 fb 2f             	cmp    $0x2f,%ebx
  8007bd:	7e 3e                	jle    8007fd <vprintfmt+0xe9>
  8007bf:	83 fb 39             	cmp    $0x39,%ebx
  8007c2:	7f 39                	jg     8007fd <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007c4:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007c7:	eb d5                	jmp    80079e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cc:	83 c0 04             	add    $0x4,%eax
  8007cf:	89 45 14             	mov    %eax,0x14(%ebp)
  8007d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d5:	83 e8 04             	sub    $0x4,%eax
  8007d8:	8b 00                	mov    (%eax),%eax
  8007da:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007dd:	eb 1f                	jmp    8007fe <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007df:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007e3:	79 83                	jns    800768 <vprintfmt+0x54>
				width = 0;
  8007e5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007ec:	e9 77 ff ff ff       	jmp    800768 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007f1:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007f8:	e9 6b ff ff ff       	jmp    800768 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007fd:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007fe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800802:	0f 89 60 ff ff ff    	jns    800768 <vprintfmt+0x54>
				width = precision, precision = -1;
  800808:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80080b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80080e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800815:	e9 4e ff ff ff       	jmp    800768 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80081a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80081d:	e9 46 ff ff ff       	jmp    800768 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800822:	8b 45 14             	mov    0x14(%ebp),%eax
  800825:	83 c0 04             	add    $0x4,%eax
  800828:	89 45 14             	mov    %eax,0x14(%ebp)
  80082b:	8b 45 14             	mov    0x14(%ebp),%eax
  80082e:	83 e8 04             	sub    $0x4,%eax
  800831:	8b 00                	mov    (%eax),%eax
  800833:	83 ec 08             	sub    $0x8,%esp
  800836:	ff 75 0c             	pushl  0xc(%ebp)
  800839:	50                   	push   %eax
  80083a:	8b 45 08             	mov    0x8(%ebp),%eax
  80083d:	ff d0                	call   *%eax
  80083f:	83 c4 10             	add    $0x10,%esp
			break;
  800842:	e9 9b 02 00 00       	jmp    800ae2 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800847:	8b 45 14             	mov    0x14(%ebp),%eax
  80084a:	83 c0 04             	add    $0x4,%eax
  80084d:	89 45 14             	mov    %eax,0x14(%ebp)
  800850:	8b 45 14             	mov    0x14(%ebp),%eax
  800853:	83 e8 04             	sub    $0x4,%eax
  800856:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800858:	85 db                	test   %ebx,%ebx
  80085a:	79 02                	jns    80085e <vprintfmt+0x14a>
				err = -err;
  80085c:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80085e:	83 fb 64             	cmp    $0x64,%ebx
  800861:	7f 0b                	jg     80086e <vprintfmt+0x15a>
  800863:	8b 34 9d 20 38 80 00 	mov    0x803820(,%ebx,4),%esi
  80086a:	85 f6                	test   %esi,%esi
  80086c:	75 19                	jne    800887 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80086e:	53                   	push   %ebx
  80086f:	68 c5 39 80 00       	push   $0x8039c5
  800874:	ff 75 0c             	pushl  0xc(%ebp)
  800877:	ff 75 08             	pushl  0x8(%ebp)
  80087a:	e8 70 02 00 00       	call   800aef <printfmt>
  80087f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800882:	e9 5b 02 00 00       	jmp    800ae2 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800887:	56                   	push   %esi
  800888:	68 ce 39 80 00       	push   $0x8039ce
  80088d:	ff 75 0c             	pushl  0xc(%ebp)
  800890:	ff 75 08             	pushl  0x8(%ebp)
  800893:	e8 57 02 00 00       	call   800aef <printfmt>
  800898:	83 c4 10             	add    $0x10,%esp
			break;
  80089b:	e9 42 02 00 00       	jmp    800ae2 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a3:	83 c0 04             	add    $0x4,%eax
  8008a6:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ac:	83 e8 04             	sub    $0x4,%eax
  8008af:	8b 30                	mov    (%eax),%esi
  8008b1:	85 f6                	test   %esi,%esi
  8008b3:	75 05                	jne    8008ba <vprintfmt+0x1a6>
				p = "(null)";
  8008b5:	be d1 39 80 00       	mov    $0x8039d1,%esi
			if (width > 0 && padc != '-')
  8008ba:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008be:	7e 6d                	jle    80092d <vprintfmt+0x219>
  8008c0:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008c4:	74 67                	je     80092d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c9:	83 ec 08             	sub    $0x8,%esp
  8008cc:	50                   	push   %eax
  8008cd:	56                   	push   %esi
  8008ce:	e8 1e 03 00 00       	call   800bf1 <strnlen>
  8008d3:	83 c4 10             	add    $0x10,%esp
  8008d6:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008d9:	eb 16                	jmp    8008f1 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008db:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008df:	83 ec 08             	sub    $0x8,%esp
  8008e2:	ff 75 0c             	pushl  0xc(%ebp)
  8008e5:	50                   	push   %eax
  8008e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e9:	ff d0                	call   *%eax
  8008eb:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008ee:	ff 4d e4             	decl   -0x1c(%ebp)
  8008f1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008f5:	7f e4                	jg     8008db <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008f7:	eb 34                	jmp    80092d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008f9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008fd:	74 1c                	je     80091b <vprintfmt+0x207>
  8008ff:	83 fb 1f             	cmp    $0x1f,%ebx
  800902:	7e 05                	jle    800909 <vprintfmt+0x1f5>
  800904:	83 fb 7e             	cmp    $0x7e,%ebx
  800907:	7e 12                	jle    80091b <vprintfmt+0x207>
					putch('?', putdat);
  800909:	83 ec 08             	sub    $0x8,%esp
  80090c:	ff 75 0c             	pushl  0xc(%ebp)
  80090f:	6a 3f                	push   $0x3f
  800911:	8b 45 08             	mov    0x8(%ebp),%eax
  800914:	ff d0                	call   *%eax
  800916:	83 c4 10             	add    $0x10,%esp
  800919:	eb 0f                	jmp    80092a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80091b:	83 ec 08             	sub    $0x8,%esp
  80091e:	ff 75 0c             	pushl  0xc(%ebp)
  800921:	53                   	push   %ebx
  800922:	8b 45 08             	mov    0x8(%ebp),%eax
  800925:	ff d0                	call   *%eax
  800927:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80092a:	ff 4d e4             	decl   -0x1c(%ebp)
  80092d:	89 f0                	mov    %esi,%eax
  80092f:	8d 70 01             	lea    0x1(%eax),%esi
  800932:	8a 00                	mov    (%eax),%al
  800934:	0f be d8             	movsbl %al,%ebx
  800937:	85 db                	test   %ebx,%ebx
  800939:	74 24                	je     80095f <vprintfmt+0x24b>
  80093b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80093f:	78 b8                	js     8008f9 <vprintfmt+0x1e5>
  800941:	ff 4d e0             	decl   -0x20(%ebp)
  800944:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800948:	79 af                	jns    8008f9 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80094a:	eb 13                	jmp    80095f <vprintfmt+0x24b>
				putch(' ', putdat);
  80094c:	83 ec 08             	sub    $0x8,%esp
  80094f:	ff 75 0c             	pushl  0xc(%ebp)
  800952:	6a 20                	push   $0x20
  800954:	8b 45 08             	mov    0x8(%ebp),%eax
  800957:	ff d0                	call   *%eax
  800959:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80095c:	ff 4d e4             	decl   -0x1c(%ebp)
  80095f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800963:	7f e7                	jg     80094c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800965:	e9 78 01 00 00       	jmp    800ae2 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80096a:	83 ec 08             	sub    $0x8,%esp
  80096d:	ff 75 e8             	pushl  -0x18(%ebp)
  800970:	8d 45 14             	lea    0x14(%ebp),%eax
  800973:	50                   	push   %eax
  800974:	e8 3c fd ff ff       	call   8006b5 <getint>
  800979:	83 c4 10             	add    $0x10,%esp
  80097c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80097f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800982:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800985:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800988:	85 d2                	test   %edx,%edx
  80098a:	79 23                	jns    8009af <vprintfmt+0x29b>
				putch('-', putdat);
  80098c:	83 ec 08             	sub    $0x8,%esp
  80098f:	ff 75 0c             	pushl  0xc(%ebp)
  800992:	6a 2d                	push   $0x2d
  800994:	8b 45 08             	mov    0x8(%ebp),%eax
  800997:	ff d0                	call   *%eax
  800999:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80099c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80099f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009a2:	f7 d8                	neg    %eax
  8009a4:	83 d2 00             	adc    $0x0,%edx
  8009a7:	f7 da                	neg    %edx
  8009a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ac:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009af:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009b6:	e9 bc 00 00 00       	jmp    800a77 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009bb:	83 ec 08             	sub    $0x8,%esp
  8009be:	ff 75 e8             	pushl  -0x18(%ebp)
  8009c1:	8d 45 14             	lea    0x14(%ebp),%eax
  8009c4:	50                   	push   %eax
  8009c5:	e8 84 fc ff ff       	call   80064e <getuint>
  8009ca:	83 c4 10             	add    $0x10,%esp
  8009cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009d0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009d3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009da:	e9 98 00 00 00       	jmp    800a77 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009df:	83 ec 08             	sub    $0x8,%esp
  8009e2:	ff 75 0c             	pushl  0xc(%ebp)
  8009e5:	6a 58                	push   $0x58
  8009e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ea:	ff d0                	call   *%eax
  8009ec:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009ef:	83 ec 08             	sub    $0x8,%esp
  8009f2:	ff 75 0c             	pushl  0xc(%ebp)
  8009f5:	6a 58                	push   $0x58
  8009f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fa:	ff d0                	call   *%eax
  8009fc:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009ff:	83 ec 08             	sub    $0x8,%esp
  800a02:	ff 75 0c             	pushl  0xc(%ebp)
  800a05:	6a 58                	push   $0x58
  800a07:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0a:	ff d0                	call   *%eax
  800a0c:	83 c4 10             	add    $0x10,%esp
			break;
  800a0f:	e9 ce 00 00 00       	jmp    800ae2 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800a14:	83 ec 08             	sub    $0x8,%esp
  800a17:	ff 75 0c             	pushl  0xc(%ebp)
  800a1a:	6a 30                	push   $0x30
  800a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1f:	ff d0                	call   *%eax
  800a21:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a24:	83 ec 08             	sub    $0x8,%esp
  800a27:	ff 75 0c             	pushl  0xc(%ebp)
  800a2a:	6a 78                	push   $0x78
  800a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2f:	ff d0                	call   *%eax
  800a31:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a34:	8b 45 14             	mov    0x14(%ebp),%eax
  800a37:	83 c0 04             	add    $0x4,%eax
  800a3a:	89 45 14             	mov    %eax,0x14(%ebp)
  800a3d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a40:	83 e8 04             	sub    $0x4,%eax
  800a43:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a45:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a48:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a4f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a56:	eb 1f                	jmp    800a77 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a58:	83 ec 08             	sub    $0x8,%esp
  800a5b:	ff 75 e8             	pushl  -0x18(%ebp)
  800a5e:	8d 45 14             	lea    0x14(%ebp),%eax
  800a61:	50                   	push   %eax
  800a62:	e8 e7 fb ff ff       	call   80064e <getuint>
  800a67:	83 c4 10             	add    $0x10,%esp
  800a6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a6d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a70:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a77:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a7e:	83 ec 04             	sub    $0x4,%esp
  800a81:	52                   	push   %edx
  800a82:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a85:	50                   	push   %eax
  800a86:	ff 75 f4             	pushl  -0xc(%ebp)
  800a89:	ff 75 f0             	pushl  -0x10(%ebp)
  800a8c:	ff 75 0c             	pushl  0xc(%ebp)
  800a8f:	ff 75 08             	pushl  0x8(%ebp)
  800a92:	e8 00 fb ff ff       	call   800597 <printnum>
  800a97:	83 c4 20             	add    $0x20,%esp
			break;
  800a9a:	eb 46                	jmp    800ae2 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a9c:	83 ec 08             	sub    $0x8,%esp
  800a9f:	ff 75 0c             	pushl  0xc(%ebp)
  800aa2:	53                   	push   %ebx
  800aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa6:	ff d0                	call   *%eax
  800aa8:	83 c4 10             	add    $0x10,%esp
			break;
  800aab:	eb 35                	jmp    800ae2 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800aad:	c6 05 44 40 98 00 00 	movb   $0x0,0x984044
			break;
  800ab4:	eb 2c                	jmp    800ae2 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800ab6:	c6 05 44 40 98 00 01 	movb   $0x1,0x984044
			break;
  800abd:	eb 23                	jmp    800ae2 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800abf:	83 ec 08             	sub    $0x8,%esp
  800ac2:	ff 75 0c             	pushl  0xc(%ebp)
  800ac5:	6a 25                	push   $0x25
  800ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aca:	ff d0                	call   *%eax
  800acc:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800acf:	ff 4d 10             	decl   0x10(%ebp)
  800ad2:	eb 03                	jmp    800ad7 <vprintfmt+0x3c3>
  800ad4:	ff 4d 10             	decl   0x10(%ebp)
  800ad7:	8b 45 10             	mov    0x10(%ebp),%eax
  800ada:	48                   	dec    %eax
  800adb:	8a 00                	mov    (%eax),%al
  800add:	3c 25                	cmp    $0x25,%al
  800adf:	75 f3                	jne    800ad4 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800ae1:	90                   	nop
		}
	}
  800ae2:	e9 35 fc ff ff       	jmp    80071c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ae7:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ae8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800aeb:	5b                   	pop    %ebx
  800aec:	5e                   	pop    %esi
  800aed:	5d                   	pop    %ebp
  800aee:	c3                   	ret    

00800aef <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800aef:	55                   	push   %ebp
  800af0:	89 e5                	mov    %esp,%ebp
  800af2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800af5:	8d 45 10             	lea    0x10(%ebp),%eax
  800af8:	83 c0 04             	add    $0x4,%eax
  800afb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800afe:	8b 45 10             	mov    0x10(%ebp),%eax
  800b01:	ff 75 f4             	pushl  -0xc(%ebp)
  800b04:	50                   	push   %eax
  800b05:	ff 75 0c             	pushl  0xc(%ebp)
  800b08:	ff 75 08             	pushl  0x8(%ebp)
  800b0b:	e8 04 fc ff ff       	call   800714 <vprintfmt>
  800b10:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b13:	90                   	nop
  800b14:	c9                   	leave  
  800b15:	c3                   	ret    

00800b16 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b16:	55                   	push   %ebp
  800b17:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1c:	8b 40 08             	mov    0x8(%eax),%eax
  800b1f:	8d 50 01             	lea    0x1(%eax),%edx
  800b22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b25:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2b:	8b 10                	mov    (%eax),%edx
  800b2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b30:	8b 40 04             	mov    0x4(%eax),%eax
  800b33:	39 c2                	cmp    %eax,%edx
  800b35:	73 12                	jae    800b49 <sprintputch+0x33>
		*b->buf++ = ch;
  800b37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3a:	8b 00                	mov    (%eax),%eax
  800b3c:	8d 48 01             	lea    0x1(%eax),%ecx
  800b3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b42:	89 0a                	mov    %ecx,(%edx)
  800b44:	8b 55 08             	mov    0x8(%ebp),%edx
  800b47:	88 10                	mov    %dl,(%eax)
}
  800b49:	90                   	nop
  800b4a:	5d                   	pop    %ebp
  800b4b:	c3                   	ret    

00800b4c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b4c:	55                   	push   %ebp
  800b4d:	89 e5                	mov    %esp,%ebp
  800b4f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b52:	8b 45 08             	mov    0x8(%ebp),%eax
  800b55:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b61:	01 d0                	add    %edx,%eax
  800b63:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b66:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b6d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b71:	74 06                	je     800b79 <vsnprintf+0x2d>
  800b73:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b77:	7f 07                	jg     800b80 <vsnprintf+0x34>
		return -E_INVAL;
  800b79:	b8 03 00 00 00       	mov    $0x3,%eax
  800b7e:	eb 20                	jmp    800ba0 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b80:	ff 75 14             	pushl  0x14(%ebp)
  800b83:	ff 75 10             	pushl  0x10(%ebp)
  800b86:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b89:	50                   	push   %eax
  800b8a:	68 16 0b 80 00       	push   $0x800b16
  800b8f:	e8 80 fb ff ff       	call   800714 <vprintfmt>
  800b94:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b9a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ba0:	c9                   	leave  
  800ba1:	c3                   	ret    

00800ba2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ba2:	55                   	push   %ebp
  800ba3:	89 e5                	mov    %esp,%ebp
  800ba5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ba8:	8d 45 10             	lea    0x10(%ebp),%eax
  800bab:	83 c0 04             	add    $0x4,%eax
  800bae:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bb1:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb4:	ff 75 f4             	pushl  -0xc(%ebp)
  800bb7:	50                   	push   %eax
  800bb8:	ff 75 0c             	pushl  0xc(%ebp)
  800bbb:	ff 75 08             	pushl  0x8(%ebp)
  800bbe:	e8 89 ff ff ff       	call   800b4c <vsnprintf>
  800bc3:	83 c4 10             	add    $0x10,%esp
  800bc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bcc:	c9                   	leave  
  800bcd:	c3                   	ret    

00800bce <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800bce:	55                   	push   %ebp
  800bcf:	89 e5                	mov    %esp,%ebp
  800bd1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bd4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bdb:	eb 06                	jmp    800be3 <strlen+0x15>
		n++;
  800bdd:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800be0:	ff 45 08             	incl   0x8(%ebp)
  800be3:	8b 45 08             	mov    0x8(%ebp),%eax
  800be6:	8a 00                	mov    (%eax),%al
  800be8:	84 c0                	test   %al,%al
  800bea:	75 f1                	jne    800bdd <strlen+0xf>
		n++;
	return n;
  800bec:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bef:	c9                   	leave  
  800bf0:	c3                   	ret    

00800bf1 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bf1:	55                   	push   %ebp
  800bf2:	89 e5                	mov    %esp,%ebp
  800bf4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bf7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bfe:	eb 09                	jmp    800c09 <strnlen+0x18>
		n++;
  800c00:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c03:	ff 45 08             	incl   0x8(%ebp)
  800c06:	ff 4d 0c             	decl   0xc(%ebp)
  800c09:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c0d:	74 09                	je     800c18 <strnlen+0x27>
  800c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c12:	8a 00                	mov    (%eax),%al
  800c14:	84 c0                	test   %al,%al
  800c16:	75 e8                	jne    800c00 <strnlen+0xf>
		n++;
	return n;
  800c18:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c1b:	c9                   	leave  
  800c1c:	c3                   	ret    

00800c1d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c1d:	55                   	push   %ebp
  800c1e:	89 e5                	mov    %esp,%ebp
  800c20:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c23:	8b 45 08             	mov    0x8(%ebp),%eax
  800c26:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c29:	90                   	nop
  800c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2d:	8d 50 01             	lea    0x1(%eax),%edx
  800c30:	89 55 08             	mov    %edx,0x8(%ebp)
  800c33:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c36:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c39:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c3c:	8a 12                	mov    (%edx),%dl
  800c3e:	88 10                	mov    %dl,(%eax)
  800c40:	8a 00                	mov    (%eax),%al
  800c42:	84 c0                	test   %al,%al
  800c44:	75 e4                	jne    800c2a <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c46:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c49:	c9                   	leave  
  800c4a:	c3                   	ret    

00800c4b <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c4b:	55                   	push   %ebp
  800c4c:	89 e5                	mov    %esp,%ebp
  800c4e:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c51:	8b 45 08             	mov    0x8(%ebp),%eax
  800c54:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c57:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c5e:	eb 1f                	jmp    800c7f <strncpy+0x34>
		*dst++ = *src;
  800c60:	8b 45 08             	mov    0x8(%ebp),%eax
  800c63:	8d 50 01             	lea    0x1(%eax),%edx
  800c66:	89 55 08             	mov    %edx,0x8(%ebp)
  800c69:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c6c:	8a 12                	mov    (%edx),%dl
  800c6e:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c73:	8a 00                	mov    (%eax),%al
  800c75:	84 c0                	test   %al,%al
  800c77:	74 03                	je     800c7c <strncpy+0x31>
			src++;
  800c79:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c7c:	ff 45 fc             	incl   -0x4(%ebp)
  800c7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c82:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c85:	72 d9                	jb     800c60 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c87:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c8a:	c9                   	leave  
  800c8b:	c3                   	ret    

00800c8c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c8c:	55                   	push   %ebp
  800c8d:	89 e5                	mov    %esp,%ebp
  800c8f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c92:	8b 45 08             	mov    0x8(%ebp),%eax
  800c95:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c98:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c9c:	74 30                	je     800cce <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c9e:	eb 16                	jmp    800cb6 <strlcpy+0x2a>
			*dst++ = *src++;
  800ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca3:	8d 50 01             	lea    0x1(%eax),%edx
  800ca6:	89 55 08             	mov    %edx,0x8(%ebp)
  800ca9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cac:	8d 4a 01             	lea    0x1(%edx),%ecx
  800caf:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cb2:	8a 12                	mov    (%edx),%dl
  800cb4:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cb6:	ff 4d 10             	decl   0x10(%ebp)
  800cb9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cbd:	74 09                	je     800cc8 <strlcpy+0x3c>
  800cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc2:	8a 00                	mov    (%eax),%al
  800cc4:	84 c0                	test   %al,%al
  800cc6:	75 d8                	jne    800ca0 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cce:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cd4:	29 c2                	sub    %eax,%edx
  800cd6:	89 d0                	mov    %edx,%eax
}
  800cd8:	c9                   	leave  
  800cd9:	c3                   	ret    

00800cda <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cda:	55                   	push   %ebp
  800cdb:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cdd:	eb 06                	jmp    800ce5 <strcmp+0xb>
		p++, q++;
  800cdf:	ff 45 08             	incl   0x8(%ebp)
  800ce2:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce8:	8a 00                	mov    (%eax),%al
  800cea:	84 c0                	test   %al,%al
  800cec:	74 0e                	je     800cfc <strcmp+0x22>
  800cee:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf1:	8a 10                	mov    (%eax),%dl
  800cf3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf6:	8a 00                	mov    (%eax),%al
  800cf8:	38 c2                	cmp    %al,%dl
  800cfa:	74 e3                	je     800cdf <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cff:	8a 00                	mov    (%eax),%al
  800d01:	0f b6 d0             	movzbl %al,%edx
  800d04:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d07:	8a 00                	mov    (%eax),%al
  800d09:	0f b6 c0             	movzbl %al,%eax
  800d0c:	29 c2                	sub    %eax,%edx
  800d0e:	89 d0                	mov    %edx,%eax
}
  800d10:	5d                   	pop    %ebp
  800d11:	c3                   	ret    

00800d12 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d12:	55                   	push   %ebp
  800d13:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d15:	eb 09                	jmp    800d20 <strncmp+0xe>
		n--, p++, q++;
  800d17:	ff 4d 10             	decl   0x10(%ebp)
  800d1a:	ff 45 08             	incl   0x8(%ebp)
  800d1d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d20:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d24:	74 17                	je     800d3d <strncmp+0x2b>
  800d26:	8b 45 08             	mov    0x8(%ebp),%eax
  800d29:	8a 00                	mov    (%eax),%al
  800d2b:	84 c0                	test   %al,%al
  800d2d:	74 0e                	je     800d3d <strncmp+0x2b>
  800d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d32:	8a 10                	mov    (%eax),%dl
  800d34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d37:	8a 00                	mov    (%eax),%al
  800d39:	38 c2                	cmp    %al,%dl
  800d3b:	74 da                	je     800d17 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d3d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d41:	75 07                	jne    800d4a <strncmp+0x38>
		return 0;
  800d43:	b8 00 00 00 00       	mov    $0x0,%eax
  800d48:	eb 14                	jmp    800d5e <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4d:	8a 00                	mov    (%eax),%al
  800d4f:	0f b6 d0             	movzbl %al,%edx
  800d52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d55:	8a 00                	mov    (%eax),%al
  800d57:	0f b6 c0             	movzbl %al,%eax
  800d5a:	29 c2                	sub    %eax,%edx
  800d5c:	89 d0                	mov    %edx,%eax
}
  800d5e:	5d                   	pop    %ebp
  800d5f:	c3                   	ret    

00800d60 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d60:	55                   	push   %ebp
  800d61:	89 e5                	mov    %esp,%ebp
  800d63:	83 ec 04             	sub    $0x4,%esp
  800d66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d69:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d6c:	eb 12                	jmp    800d80 <strchr+0x20>
		if (*s == c)
  800d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d71:	8a 00                	mov    (%eax),%al
  800d73:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d76:	75 05                	jne    800d7d <strchr+0x1d>
			return (char *) s;
  800d78:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7b:	eb 11                	jmp    800d8e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d7d:	ff 45 08             	incl   0x8(%ebp)
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	8a 00                	mov    (%eax),%al
  800d85:	84 c0                	test   %al,%al
  800d87:	75 e5                	jne    800d6e <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d89:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d8e:	c9                   	leave  
  800d8f:	c3                   	ret    

00800d90 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d90:	55                   	push   %ebp
  800d91:	89 e5                	mov    %esp,%ebp
  800d93:	83 ec 04             	sub    $0x4,%esp
  800d96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d99:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d9c:	eb 0d                	jmp    800dab <strfind+0x1b>
		if (*s == c)
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800da1:	8a 00                	mov    (%eax),%al
  800da3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800da6:	74 0e                	je     800db6 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800da8:	ff 45 08             	incl   0x8(%ebp)
  800dab:	8b 45 08             	mov    0x8(%ebp),%eax
  800dae:	8a 00                	mov    (%eax),%al
  800db0:	84 c0                	test   %al,%al
  800db2:	75 ea                	jne    800d9e <strfind+0xe>
  800db4:	eb 01                	jmp    800db7 <strfind+0x27>
		if (*s == c)
			break;
  800db6:	90                   	nop
	return (char *) s;
  800db7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dba:	c9                   	leave  
  800dbb:	c3                   	ret    

00800dbc <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800dbc:	55                   	push   %ebp
  800dbd:	89 e5                	mov    %esp,%ebp
  800dbf:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800dc8:	8b 45 10             	mov    0x10(%ebp),%eax
  800dcb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800dce:	eb 0e                	jmp    800dde <memset+0x22>
		*p++ = c;
  800dd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dd3:	8d 50 01             	lea    0x1(%eax),%edx
  800dd6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dd9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ddc:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dde:	ff 4d f8             	decl   -0x8(%ebp)
  800de1:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800de5:	79 e9                	jns    800dd0 <memset+0x14>
		*p++ = c;

	return v;
  800de7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dea:	c9                   	leave  
  800deb:	c3                   	ret    

00800dec <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dec:	55                   	push   %ebp
  800ded:	89 e5                	mov    %esp,%ebp
  800def:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800df2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800df8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800dfe:	eb 16                	jmp    800e16 <memcpy+0x2a>
		*d++ = *s++;
  800e00:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e03:	8d 50 01             	lea    0x1(%eax),%edx
  800e06:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e09:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e0c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e0f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e12:	8a 12                	mov    (%edx),%dl
  800e14:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e16:	8b 45 10             	mov    0x10(%ebp),%eax
  800e19:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e1c:	89 55 10             	mov    %edx,0x10(%ebp)
  800e1f:	85 c0                	test   %eax,%eax
  800e21:	75 dd                	jne    800e00 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e23:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e26:	c9                   	leave  
  800e27:	c3                   	ret    

00800e28 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e28:	55                   	push   %ebp
  800e29:	89 e5                	mov    %esp,%ebp
  800e2b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e31:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e34:	8b 45 08             	mov    0x8(%ebp),%eax
  800e37:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e3d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e40:	73 50                	jae    800e92 <memmove+0x6a>
  800e42:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e45:	8b 45 10             	mov    0x10(%ebp),%eax
  800e48:	01 d0                	add    %edx,%eax
  800e4a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e4d:	76 43                	jbe    800e92 <memmove+0x6a>
		s += n;
  800e4f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e52:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e55:	8b 45 10             	mov    0x10(%ebp),%eax
  800e58:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e5b:	eb 10                	jmp    800e6d <memmove+0x45>
			*--d = *--s;
  800e5d:	ff 4d f8             	decl   -0x8(%ebp)
  800e60:	ff 4d fc             	decl   -0x4(%ebp)
  800e63:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e66:	8a 10                	mov    (%eax),%dl
  800e68:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e6b:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e6d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e70:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e73:	89 55 10             	mov    %edx,0x10(%ebp)
  800e76:	85 c0                	test   %eax,%eax
  800e78:	75 e3                	jne    800e5d <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e7a:	eb 23                	jmp    800e9f <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e7c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e7f:	8d 50 01             	lea    0x1(%eax),%edx
  800e82:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e85:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e88:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e8b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e8e:	8a 12                	mov    (%edx),%dl
  800e90:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e92:	8b 45 10             	mov    0x10(%ebp),%eax
  800e95:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e98:	89 55 10             	mov    %edx,0x10(%ebp)
  800e9b:	85 c0                	test   %eax,%eax
  800e9d:	75 dd                	jne    800e7c <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e9f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ea2:	c9                   	leave  
  800ea3:	c3                   	ret    

00800ea4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ea4:	55                   	push   %ebp
  800ea5:	89 e5                	mov    %esp,%ebp
  800ea7:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ead:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800eb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb3:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800eb6:	eb 2a                	jmp    800ee2 <memcmp+0x3e>
		if (*s1 != *s2)
  800eb8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ebb:	8a 10                	mov    (%eax),%dl
  800ebd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ec0:	8a 00                	mov    (%eax),%al
  800ec2:	38 c2                	cmp    %al,%dl
  800ec4:	74 16                	je     800edc <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ec6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec9:	8a 00                	mov    (%eax),%al
  800ecb:	0f b6 d0             	movzbl %al,%edx
  800ece:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ed1:	8a 00                	mov    (%eax),%al
  800ed3:	0f b6 c0             	movzbl %al,%eax
  800ed6:	29 c2                	sub    %eax,%edx
  800ed8:	89 d0                	mov    %edx,%eax
  800eda:	eb 18                	jmp    800ef4 <memcmp+0x50>
		s1++, s2++;
  800edc:	ff 45 fc             	incl   -0x4(%ebp)
  800edf:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ee2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ee8:	89 55 10             	mov    %edx,0x10(%ebp)
  800eeb:	85 c0                	test   %eax,%eax
  800eed:	75 c9                	jne    800eb8 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800eef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ef4:	c9                   	leave  
  800ef5:	c3                   	ret    

00800ef6 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ef6:	55                   	push   %ebp
  800ef7:	89 e5                	mov    %esp,%ebp
  800ef9:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800efc:	8b 55 08             	mov    0x8(%ebp),%edx
  800eff:	8b 45 10             	mov    0x10(%ebp),%eax
  800f02:	01 d0                	add    %edx,%eax
  800f04:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f07:	eb 15                	jmp    800f1e <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f09:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0c:	8a 00                	mov    (%eax),%al
  800f0e:	0f b6 d0             	movzbl %al,%edx
  800f11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f14:	0f b6 c0             	movzbl %al,%eax
  800f17:	39 c2                	cmp    %eax,%edx
  800f19:	74 0d                	je     800f28 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f1b:	ff 45 08             	incl   0x8(%ebp)
  800f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f21:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f24:	72 e3                	jb     800f09 <memfind+0x13>
  800f26:	eb 01                	jmp    800f29 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f28:	90                   	nop
	return (void *) s;
  800f29:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f2c:	c9                   	leave  
  800f2d:	c3                   	ret    

00800f2e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f2e:	55                   	push   %ebp
  800f2f:	89 e5                	mov    %esp,%ebp
  800f31:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f34:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f3b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f42:	eb 03                	jmp    800f47 <strtol+0x19>
		s++;
  800f44:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f47:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4a:	8a 00                	mov    (%eax),%al
  800f4c:	3c 20                	cmp    $0x20,%al
  800f4e:	74 f4                	je     800f44 <strtol+0x16>
  800f50:	8b 45 08             	mov    0x8(%ebp),%eax
  800f53:	8a 00                	mov    (%eax),%al
  800f55:	3c 09                	cmp    $0x9,%al
  800f57:	74 eb                	je     800f44 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f59:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5c:	8a 00                	mov    (%eax),%al
  800f5e:	3c 2b                	cmp    $0x2b,%al
  800f60:	75 05                	jne    800f67 <strtol+0x39>
		s++;
  800f62:	ff 45 08             	incl   0x8(%ebp)
  800f65:	eb 13                	jmp    800f7a <strtol+0x4c>
	else if (*s == '-')
  800f67:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6a:	8a 00                	mov    (%eax),%al
  800f6c:	3c 2d                	cmp    $0x2d,%al
  800f6e:	75 0a                	jne    800f7a <strtol+0x4c>
		s++, neg = 1;
  800f70:	ff 45 08             	incl   0x8(%ebp)
  800f73:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f7a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f7e:	74 06                	je     800f86 <strtol+0x58>
  800f80:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f84:	75 20                	jne    800fa6 <strtol+0x78>
  800f86:	8b 45 08             	mov    0x8(%ebp),%eax
  800f89:	8a 00                	mov    (%eax),%al
  800f8b:	3c 30                	cmp    $0x30,%al
  800f8d:	75 17                	jne    800fa6 <strtol+0x78>
  800f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f92:	40                   	inc    %eax
  800f93:	8a 00                	mov    (%eax),%al
  800f95:	3c 78                	cmp    $0x78,%al
  800f97:	75 0d                	jne    800fa6 <strtol+0x78>
		s += 2, base = 16;
  800f99:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f9d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fa4:	eb 28                	jmp    800fce <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fa6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800faa:	75 15                	jne    800fc1 <strtol+0x93>
  800fac:	8b 45 08             	mov    0x8(%ebp),%eax
  800faf:	8a 00                	mov    (%eax),%al
  800fb1:	3c 30                	cmp    $0x30,%al
  800fb3:	75 0c                	jne    800fc1 <strtol+0x93>
		s++, base = 8;
  800fb5:	ff 45 08             	incl   0x8(%ebp)
  800fb8:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fbf:	eb 0d                	jmp    800fce <strtol+0xa0>
	else if (base == 0)
  800fc1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fc5:	75 07                	jne    800fce <strtol+0xa0>
		base = 10;
  800fc7:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fce:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd1:	8a 00                	mov    (%eax),%al
  800fd3:	3c 2f                	cmp    $0x2f,%al
  800fd5:	7e 19                	jle    800ff0 <strtol+0xc2>
  800fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fda:	8a 00                	mov    (%eax),%al
  800fdc:	3c 39                	cmp    $0x39,%al
  800fde:	7f 10                	jg     800ff0 <strtol+0xc2>
			dig = *s - '0';
  800fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe3:	8a 00                	mov    (%eax),%al
  800fe5:	0f be c0             	movsbl %al,%eax
  800fe8:	83 e8 30             	sub    $0x30,%eax
  800feb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fee:	eb 42                	jmp    801032 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff3:	8a 00                	mov    (%eax),%al
  800ff5:	3c 60                	cmp    $0x60,%al
  800ff7:	7e 19                	jle    801012 <strtol+0xe4>
  800ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffc:	8a 00                	mov    (%eax),%al
  800ffe:	3c 7a                	cmp    $0x7a,%al
  801000:	7f 10                	jg     801012 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801002:	8b 45 08             	mov    0x8(%ebp),%eax
  801005:	8a 00                	mov    (%eax),%al
  801007:	0f be c0             	movsbl %al,%eax
  80100a:	83 e8 57             	sub    $0x57,%eax
  80100d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801010:	eb 20                	jmp    801032 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801012:	8b 45 08             	mov    0x8(%ebp),%eax
  801015:	8a 00                	mov    (%eax),%al
  801017:	3c 40                	cmp    $0x40,%al
  801019:	7e 39                	jle    801054 <strtol+0x126>
  80101b:	8b 45 08             	mov    0x8(%ebp),%eax
  80101e:	8a 00                	mov    (%eax),%al
  801020:	3c 5a                	cmp    $0x5a,%al
  801022:	7f 30                	jg     801054 <strtol+0x126>
			dig = *s - 'A' + 10;
  801024:	8b 45 08             	mov    0x8(%ebp),%eax
  801027:	8a 00                	mov    (%eax),%al
  801029:	0f be c0             	movsbl %al,%eax
  80102c:	83 e8 37             	sub    $0x37,%eax
  80102f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801032:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801035:	3b 45 10             	cmp    0x10(%ebp),%eax
  801038:	7d 19                	jge    801053 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80103a:	ff 45 08             	incl   0x8(%ebp)
  80103d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801040:	0f af 45 10          	imul   0x10(%ebp),%eax
  801044:	89 c2                	mov    %eax,%edx
  801046:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801049:	01 d0                	add    %edx,%eax
  80104b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80104e:	e9 7b ff ff ff       	jmp    800fce <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801053:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801054:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801058:	74 08                	je     801062 <strtol+0x134>
		*endptr = (char *) s;
  80105a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105d:	8b 55 08             	mov    0x8(%ebp),%edx
  801060:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801062:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801066:	74 07                	je     80106f <strtol+0x141>
  801068:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80106b:	f7 d8                	neg    %eax
  80106d:	eb 03                	jmp    801072 <strtol+0x144>
  80106f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801072:	c9                   	leave  
  801073:	c3                   	ret    

00801074 <ltostr>:

void
ltostr(long value, char *str)
{
  801074:	55                   	push   %ebp
  801075:	89 e5                	mov    %esp,%ebp
  801077:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80107a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801081:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801088:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80108c:	79 13                	jns    8010a1 <ltostr+0x2d>
	{
		neg = 1;
  80108e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801095:	8b 45 0c             	mov    0xc(%ebp),%eax
  801098:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80109b:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80109e:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a4:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010a9:	99                   	cltd   
  8010aa:	f7 f9                	idiv   %ecx
  8010ac:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010af:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010b2:	8d 50 01             	lea    0x1(%eax),%edx
  8010b5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010b8:	89 c2                	mov    %eax,%edx
  8010ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010bd:	01 d0                	add    %edx,%eax
  8010bf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010c2:	83 c2 30             	add    $0x30,%edx
  8010c5:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010ca:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010cf:	f7 e9                	imul   %ecx
  8010d1:	c1 fa 02             	sar    $0x2,%edx
  8010d4:	89 c8                	mov    %ecx,%eax
  8010d6:	c1 f8 1f             	sar    $0x1f,%eax
  8010d9:	29 c2                	sub    %eax,%edx
  8010db:	89 d0                	mov    %edx,%eax
  8010dd:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8010e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010e4:	75 bb                	jne    8010a1 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f0:	48                   	dec    %eax
  8010f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010f8:	74 3d                	je     801137 <ltostr+0xc3>
		start = 1 ;
  8010fa:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801101:	eb 34                	jmp    801137 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801103:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801106:	8b 45 0c             	mov    0xc(%ebp),%eax
  801109:	01 d0                	add    %edx,%eax
  80110b:	8a 00                	mov    (%eax),%al
  80110d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801110:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801113:	8b 45 0c             	mov    0xc(%ebp),%eax
  801116:	01 c2                	add    %eax,%edx
  801118:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80111b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111e:	01 c8                	add    %ecx,%eax
  801120:	8a 00                	mov    (%eax),%al
  801122:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801124:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801127:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112a:	01 c2                	add    %eax,%edx
  80112c:	8a 45 eb             	mov    -0x15(%ebp),%al
  80112f:	88 02                	mov    %al,(%edx)
		start++ ;
  801131:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801134:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801137:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80113a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80113d:	7c c4                	jl     801103 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80113f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801142:	8b 45 0c             	mov    0xc(%ebp),%eax
  801145:	01 d0                	add    %edx,%eax
  801147:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80114a:	90                   	nop
  80114b:	c9                   	leave  
  80114c:	c3                   	ret    

0080114d <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80114d:	55                   	push   %ebp
  80114e:	89 e5                	mov    %esp,%ebp
  801150:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801153:	ff 75 08             	pushl  0x8(%ebp)
  801156:	e8 73 fa ff ff       	call   800bce <strlen>
  80115b:	83 c4 04             	add    $0x4,%esp
  80115e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801161:	ff 75 0c             	pushl  0xc(%ebp)
  801164:	e8 65 fa ff ff       	call   800bce <strlen>
  801169:	83 c4 04             	add    $0x4,%esp
  80116c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80116f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801176:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80117d:	eb 17                	jmp    801196 <strcconcat+0x49>
		final[s] = str1[s] ;
  80117f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801182:	8b 45 10             	mov    0x10(%ebp),%eax
  801185:	01 c2                	add    %eax,%edx
  801187:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80118a:	8b 45 08             	mov    0x8(%ebp),%eax
  80118d:	01 c8                	add    %ecx,%eax
  80118f:	8a 00                	mov    (%eax),%al
  801191:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801193:	ff 45 fc             	incl   -0x4(%ebp)
  801196:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801199:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80119c:	7c e1                	jl     80117f <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80119e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011a5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011ac:	eb 1f                	jmp    8011cd <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011b1:	8d 50 01             	lea    0x1(%eax),%edx
  8011b4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011b7:	89 c2                	mov    %eax,%edx
  8011b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8011bc:	01 c2                	add    %eax,%edx
  8011be:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c4:	01 c8                	add    %ecx,%eax
  8011c6:	8a 00                	mov    (%eax),%al
  8011c8:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011ca:	ff 45 f8             	incl   -0x8(%ebp)
  8011cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011d3:	7c d9                	jl     8011ae <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011d5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8011db:	01 d0                	add    %edx,%eax
  8011dd:	c6 00 00             	movb   $0x0,(%eax)
}
  8011e0:	90                   	nop
  8011e1:	c9                   	leave  
  8011e2:	c3                   	ret    

008011e3 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011e3:	55                   	push   %ebp
  8011e4:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f2:	8b 00                	mov    (%eax),%eax
  8011f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8011fe:	01 d0                	add    %edx,%eax
  801200:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801206:	eb 0c                	jmp    801214 <strsplit+0x31>
			*string++ = 0;
  801208:	8b 45 08             	mov    0x8(%ebp),%eax
  80120b:	8d 50 01             	lea    0x1(%eax),%edx
  80120e:	89 55 08             	mov    %edx,0x8(%ebp)
  801211:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801214:	8b 45 08             	mov    0x8(%ebp),%eax
  801217:	8a 00                	mov    (%eax),%al
  801219:	84 c0                	test   %al,%al
  80121b:	74 18                	je     801235 <strsplit+0x52>
  80121d:	8b 45 08             	mov    0x8(%ebp),%eax
  801220:	8a 00                	mov    (%eax),%al
  801222:	0f be c0             	movsbl %al,%eax
  801225:	50                   	push   %eax
  801226:	ff 75 0c             	pushl  0xc(%ebp)
  801229:	e8 32 fb ff ff       	call   800d60 <strchr>
  80122e:	83 c4 08             	add    $0x8,%esp
  801231:	85 c0                	test   %eax,%eax
  801233:	75 d3                	jne    801208 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801235:	8b 45 08             	mov    0x8(%ebp),%eax
  801238:	8a 00                	mov    (%eax),%al
  80123a:	84 c0                	test   %al,%al
  80123c:	74 5a                	je     801298 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80123e:	8b 45 14             	mov    0x14(%ebp),%eax
  801241:	8b 00                	mov    (%eax),%eax
  801243:	83 f8 0f             	cmp    $0xf,%eax
  801246:	75 07                	jne    80124f <strsplit+0x6c>
		{
			return 0;
  801248:	b8 00 00 00 00       	mov    $0x0,%eax
  80124d:	eb 66                	jmp    8012b5 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80124f:	8b 45 14             	mov    0x14(%ebp),%eax
  801252:	8b 00                	mov    (%eax),%eax
  801254:	8d 48 01             	lea    0x1(%eax),%ecx
  801257:	8b 55 14             	mov    0x14(%ebp),%edx
  80125a:	89 0a                	mov    %ecx,(%edx)
  80125c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801263:	8b 45 10             	mov    0x10(%ebp),%eax
  801266:	01 c2                	add    %eax,%edx
  801268:	8b 45 08             	mov    0x8(%ebp),%eax
  80126b:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80126d:	eb 03                	jmp    801272 <strsplit+0x8f>
			string++;
  80126f:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801272:	8b 45 08             	mov    0x8(%ebp),%eax
  801275:	8a 00                	mov    (%eax),%al
  801277:	84 c0                	test   %al,%al
  801279:	74 8b                	je     801206 <strsplit+0x23>
  80127b:	8b 45 08             	mov    0x8(%ebp),%eax
  80127e:	8a 00                	mov    (%eax),%al
  801280:	0f be c0             	movsbl %al,%eax
  801283:	50                   	push   %eax
  801284:	ff 75 0c             	pushl  0xc(%ebp)
  801287:	e8 d4 fa ff ff       	call   800d60 <strchr>
  80128c:	83 c4 08             	add    $0x8,%esp
  80128f:	85 c0                	test   %eax,%eax
  801291:	74 dc                	je     80126f <strsplit+0x8c>
			string++;
	}
  801293:	e9 6e ff ff ff       	jmp    801206 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801298:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801299:	8b 45 14             	mov    0x14(%ebp),%eax
  80129c:	8b 00                	mov    (%eax),%eax
  80129e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a8:	01 d0                	add    %edx,%eax
  8012aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012b0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012b5:	c9                   	leave  
  8012b6:	c3                   	ret    

008012b7 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8012b7:	55                   	push   %ebp
  8012b8:	89 e5                	mov    %esp,%ebp
  8012ba:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8012bd:	83 ec 04             	sub    $0x4,%esp
  8012c0:	68 48 3b 80 00       	push   $0x803b48
  8012c5:	68 3f 01 00 00       	push   $0x13f
  8012ca:	68 6a 3b 80 00       	push   $0x803b6a
  8012cf:	e8 a9 ef ff ff       	call   80027d <_panic>

008012d4 <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  8012d4:	55                   	push   %ebp
  8012d5:	89 e5                	mov    %esp,%ebp
  8012d7:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  8012da:	83 ec 0c             	sub    $0xc,%esp
  8012dd:	ff 75 08             	pushl  0x8(%ebp)
  8012e0:	e8 90 0c 00 00       	call   801f75 <sys_sbrk>
  8012e5:	83 c4 10             	add    $0x10,%esp
}
  8012e8:	c9                   	leave  
  8012e9:	c3                   	ret    

008012ea <malloc>:
#define num_of_page ((USER_HEAP_MAX - USER_HEAP_START) / PAGE_SIZE)

int pagesAllocated[num_of_page] = { 0 };
int shardIDs[num_of_page] = { 0 };
bool markedPages[num_of_page] = { 0 };
void* malloc(uint32 size) {
  8012ea:	55                   	push   %ebp
  8012eb:	89 e5                	mov    %esp,%ebp
  8012ed:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  8012f0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012f4:	75 0a                	jne    801300 <malloc+0x16>
		return NULL;
  8012f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8012fb:	e9 9e 01 00 00       	jmp    80149e <malloc+0x1b4>

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

	//  our new code
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  801300:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801307:	77 2c                	ja     801335 <malloc+0x4b>
		if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  801309:	e8 eb 0a 00 00       	call   801df9 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80130e:	85 c0                	test   %eax,%eax
  801310:	74 19                	je     80132b <malloc+0x41>

			void * block = alloc_block_FF(size);
  801312:	83 ec 0c             	sub    $0xc,%esp
  801315:	ff 75 08             	pushl  0x8(%ebp)
  801318:	e8 85 11 00 00       	call   8024a2 <alloc_block_FF>
  80131d:	83 c4 10             	add    $0x10,%esp
  801320:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			return block;
  801323:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801326:	e9 73 01 00 00       	jmp    80149e <malloc+0x1b4>
		} else {
			return NULL;
  80132b:	b8 00 00 00 00       	mov    $0x0,%eax
  801330:	e9 69 01 00 00       	jmp    80149e <malloc+0x1b4>
		}
	}

	uint32 numOfPages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801335:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80133c:	8b 55 08             	mov    0x8(%ebp),%edx
  80133f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801342:	01 d0                	add    %edx,%eax
  801344:	48                   	dec    %eax
  801345:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801348:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80134b:	ba 00 00 00 00       	mov    $0x0,%edx
  801350:	f7 75 e0             	divl   -0x20(%ebp)
  801353:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801356:	29 d0                	sub    %edx,%eax
  801358:	c1 e8 0c             	shr    $0xc,%eax
  80135b:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 freePagesCount = 0;
  80135e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801365:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  80136c:	a1 20 40 80 00       	mov    0x804020,%eax
  801371:	8b 40 7c             	mov    0x7c(%eax),%eax
  801374:	05 00 10 00 00       	add    $0x1000,%eax
  801379:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  80137c:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801381:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801384:	89 45 d0             	mov    %eax,-0x30(%ebp)

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  801387:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80138e:	8b 55 08             	mov    0x8(%ebp),%edx
  801391:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801394:	01 d0                	add    %edx,%eax
  801396:	48                   	dec    %eax
  801397:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80139a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80139d:	ba 00 00 00 00       	mov    $0x0,%edx
  8013a2:	f7 75 cc             	divl   -0x34(%ebp)
  8013a5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8013a8:	29 d0                	sub    %edx,%eax
  8013aa:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8013ad:	76 0a                	jbe    8013b9 <malloc+0xcf>
		return NULL;
  8013af:	b8 00 00 00 00       	mov    $0x0,%eax
  8013b4:	e9 e5 00 00 00       	jmp    80149e <malloc+0x1b4>
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  8013b9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8013bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8013bf:	eb 48                	jmp    801409 <malloc+0x11f>
	{
		uint32 idx = (i - currentAddr) / PAGE_SIZE;
  8013c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013c4:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8013c7:	c1 e8 0c             	shr    $0xc,%eax
  8013ca:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if (!markedPages[idx]) {
  8013cd:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8013d0:	8b 04 85 40 40 90 00 	mov    0x904040(,%eax,4),%eax
  8013d7:	85 c0                	test   %eax,%eax
  8013d9:	75 11                	jne    8013ec <malloc+0x102>
			freePagesCount++;
  8013db:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  8013de:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8013e2:	75 16                	jne    8013fa <malloc+0x110>
				start = i;
  8013e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013ea:	eb 0e                	jmp    8013fa <malloc+0x110>
			}
		} else {
			freePagesCount = 0;
  8013ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  8013f3:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == numOfPages) {
  8013fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013fd:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801400:	74 12                	je     801414 <malloc+0x12a>

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  801402:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801409:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801410:	76 af                	jbe    8013c1 <malloc+0xd7>
  801412:	eb 01                	jmp    801415 <malloc+0x12b>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == numOfPages) {
			break;
  801414:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
  801415:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801419:	74 08                	je     801423 <malloc+0x139>
  80141b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80141e:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801421:	74 07                	je     80142a <malloc+0x140>
		return NULL;
  801423:	b8 00 00 00 00       	mov    $0x0,%eax
  801428:	eb 74                	jmp    80149e <malloc+0x1b4>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  80142a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80142d:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801430:	c1 e8 0c             	shr    $0xc,%eax
  801433:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numOfPages;
  801436:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801439:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80143c:	89 14 85 40 40 80 00 	mov    %edx,0x804040(,%eax,4)
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  801443:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801446:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801449:	eb 11                	jmp    80145c <malloc+0x172>
		markedPages[i] = 1;
  80144b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80144e:	c7 04 85 40 40 90 00 	movl   $0x1,0x904040(,%eax,4)
  801455:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = numOfPages;
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  801459:	ff 45 e8             	incl   -0x18(%ebp)
  80145c:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80145f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801462:	01 d0                	add    %edx,%eax
  801464:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801467:	77 e2                	ja     80144b <malloc+0x161>
		markedPages[i] = 1;
	}

	sys_allocate_user_mem(start, ROUNDUP(size, PAGE_SIZE));
  801469:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801470:	8b 55 08             	mov    0x8(%ebp),%edx
  801473:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801476:	01 d0                	add    %edx,%eax
  801478:	48                   	dec    %eax
  801479:	89 45 b8             	mov    %eax,-0x48(%ebp)
  80147c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80147f:	ba 00 00 00 00       	mov    $0x0,%edx
  801484:	f7 75 bc             	divl   -0x44(%ebp)
  801487:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80148a:	29 d0                	sub    %edx,%eax
  80148c:	83 ec 08             	sub    $0x8,%esp
  80148f:	50                   	push   %eax
  801490:	ff 75 f0             	pushl  -0x10(%ebp)
  801493:	e8 14 0b 00 00       	call   801fac <sys_allocate_user_mem>
  801498:	83 c4 10             	add    $0x10,%esp
	return (void*) start;
  80149b:	8b 45 f0             	mov    -0x10(%ebp),%eax

}
  80149e:	c9                   	leave  
  80149f:	c3                   	ret    

008014a0 <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address) {
  8014a0:	55                   	push   %ebp
  8014a1:	89 e5                	mov    %esp,%ebp
  8014a3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
  8014a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014aa:	0f 84 ee 00 00 00    	je     80159e <free+0xfe>
		return;
	}

	if (virtual_address
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  8014b0:	a1 20 40 80 00       	mov    0x804020,%eax
  8014b5:	8b 40 74             	mov    0x74(%eax),%eax

	if (virtual_address == NULL) {
		return;
	}

	if (virtual_address
  8014b8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8014bb:	77 09                	ja     8014c6 <free+0x26>
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  8014bd:	81 7d 08 00 00 00 a0 	cmpl   $0xa0000000,0x8(%ebp)
  8014c4:	76 14                	jbe    8014da <free+0x3a>
		panic("INVALID VIRTUAL ADDRESS!!");
  8014c6:	83 ec 04             	sub    $0x4,%esp
  8014c9:	68 78 3b 80 00       	push   $0x803b78
  8014ce:	6a 68                	push   $0x68
  8014d0:	68 92 3b 80 00       	push   $0x803b92
  8014d5:	e8 a3 ed ff ff       	call   80027d <_panic>
	}
	if (virtual_address >= (void *) (myEnv->uheapStart)
  8014da:	a1 20 40 80 00       	mov    0x804020,%eax
  8014df:	8b 40 74             	mov    0x74(%eax),%eax
  8014e2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8014e5:	77 20                	ja     801507 <free+0x67>
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
  8014e7:	a1 20 40 80 00       	mov    0x804020,%eax
  8014ec:	8b 40 78             	mov    0x78(%eax),%eax
  8014ef:	3b 45 08             	cmp    0x8(%ebp),%eax
  8014f2:	76 13                	jbe    801507 <free+0x67>
		free_block(virtual_address);
  8014f4:	83 ec 0c             	sub    $0xc,%esp
  8014f7:	ff 75 08             	pushl  0x8(%ebp)
  8014fa:	e8 6c 16 00 00       	call   802b6b <free_block>
  8014ff:	83 c4 10             	add    $0x10,%esp
		return;
  801502:	e9 98 00 00 00       	jmp    80159f <free+0xff>
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  801507:	8b 55 08             	mov    0x8(%ebp),%edx
  80150a:	a1 20 40 80 00       	mov    0x804020,%eax
  80150f:	8b 40 7c             	mov    0x7c(%eax),%eax
  801512:	29 c2                	sub    %eax,%edx
  801514:	89 d0                	mov    %edx,%eax
  801516:	2d 00 10 00 00       	sub    $0x1000,%eax
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
		free_block(virtual_address);
		return;
	}

	uint32 pageIdx = ((uint32) virtual_address
  80151b:	c1 e8 0c             	shr    $0xc,%eax
  80151e:	89 45 ec             	mov    %eax,-0x14(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  801521:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801528:	eb 16                	jmp    801540 <free+0xa0>
		markedPages[idx + pageIdx] = 0;
  80152a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80152d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801530:	01 d0                	add    %edx,%eax
  801532:	c7 04 85 40 40 90 00 	movl   $0x0,0x904040(,%eax,4)
  801539:	00 00 00 00 
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  80153d:	ff 45 f4             	incl   -0xc(%ebp)
  801540:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801543:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  80154a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80154d:	7f db                	jg     80152a <free+0x8a>
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;
  80154f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801552:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  801559:	c1 e0 0c             	shl    $0xc,%eax
  80155c:	89 45 e8             	mov    %eax,-0x18(%ebp)

	for (uint32 i = (uint32) virtual_address;
  80155f:	8b 45 08             	mov    0x8(%ebp),%eax
  801562:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801565:	eb 1a                	jmp    801581 <free+0xe1>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
  801567:	83 ec 08             	sub    $0x8,%esp
  80156a:	68 00 10 00 00       	push   $0x1000
  80156f:	ff 75 f0             	pushl  -0x10(%ebp)
  801572:	e8 19 0a 00 00       	call   801f90 <sys_free_user_mem>
  801577:	83 c4 10             	add    $0x10,%esp
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
  80157a:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  801581:	8b 55 08             	mov    0x8(%ebp),%edx
  801584:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801587:	01 d0                	add    %edx,%eax
	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
  801589:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80158c:	77 d9                	ja     801567 <free+0xc7>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;
  80158e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801591:	c7 04 85 40 40 80 00 	movl   $0x0,0x804040(,%eax,4)
  801598:	00 00 00 00 
  80159c:	eb 01                	jmp    80159f <free+0xff>
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
		return;
  80159e:	90                   	nop
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;

}
  80159f:	c9                   	leave  
  8015a0:	c3                   	ret    

008015a1 <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  8015a1:	55                   	push   %ebp
  8015a2:	89 e5                	mov    %esp,%ebp
  8015a4:	83 ec 58             	sub    $0x58,%esp
  8015a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8015aa:	88 45 b4             	mov    %al,-0x4c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  8015ad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015b1:	75 0a                	jne    8015bd <smalloc+0x1c>
		return NULL;
  8015b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8015b8:	e9 7d 01 00 00       	jmp    80173a <smalloc+0x199>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	uint32 num_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  8015bd:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  8015c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015ca:	01 d0                	add    %edx,%eax
  8015cc:	48                   	dec    %eax
  8015cd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8015d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8015d8:	f7 75 e4             	divl   -0x1c(%ebp)
  8015db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015de:	29 d0                	sub    %edx,%eax
  8015e0:	c1 e8 0c             	shr    $0xc,%eax
  8015e3:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 freePagesCount = 0;
  8015e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  8015ed:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  8015f4:	a1 20 40 80 00       	mov    0x804020,%eax
  8015f9:	8b 40 7c             	mov    0x7c(%eax),%eax
  8015fc:	05 00 10 00 00       	add    $0x1000,%eax
  801601:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  801604:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801609:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80160c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  80160f:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801616:	8b 55 0c             	mov    0xc(%ebp),%edx
  801619:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80161c:	01 d0                	add    %edx,%eax
  80161e:	48                   	dec    %eax
  80161f:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801622:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801625:	ba 00 00 00 00       	mov    $0x0,%edx
  80162a:	f7 75 d0             	divl   -0x30(%ebp)
  80162d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801630:	29 d0                	sub    %edx,%eax
  801632:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801635:	76 0a                	jbe    801641 <smalloc+0xa0>
		return NULL;
  801637:	b8 00 00 00 00       	mov    $0x0,%eax
  80163c:	e9 f9 00 00 00       	jmp    80173a <smalloc+0x199>
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801641:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801644:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801647:	eb 48                	jmp    801691 <smalloc+0xf0>
		uint32 idx = (s - currentAddr) / PAGE_SIZE;
  801649:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80164c:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80164f:	c1 e8 0c             	shr    $0xc,%eax
  801652:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (!markedPages[idx]) {
  801655:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801658:	8b 04 85 40 40 90 00 	mov    0x904040(,%eax,4),%eax
  80165f:	85 c0                	test   %eax,%eax
  801661:	75 11                	jne    801674 <smalloc+0xd3>
			freePagesCount++;
  801663:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801666:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80166a:	75 16                	jne    801682 <smalloc+0xe1>
				start = s;
  80166c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80166f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801672:	eb 0e                	jmp    801682 <smalloc+0xe1>
			}
		} else {
			freePagesCount = 0;
  801674:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  80167b:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == num_Of_Pages) {
  801682:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801685:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801688:	74 12                	je     80169c <smalloc+0xfb>
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  80168a:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801691:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801698:	76 af                	jbe    801649 <smalloc+0xa8>
  80169a:	eb 01                	jmp    80169d <smalloc+0xfc>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == num_Of_Pages) {
			break;
  80169c:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
  80169d:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8016a1:	74 08                	je     8016ab <smalloc+0x10a>
  8016a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a6:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8016a9:	74 0a                	je     8016b5 <smalloc+0x114>
		return NULL;
  8016ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b0:	e9 85 00 00 00       	jmp    80173a <smalloc+0x199>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  8016b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b8:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8016bb:	c1 e8 0c             	shr    $0xc,%eax
  8016be:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	pagesAllocated[startPage] = num_Of_Pages;
  8016c1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8016c4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8016c7:	89 14 85 40 40 80 00 	mov    %edx,0x804040(,%eax,4)
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  8016ce:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8016d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8016d4:	eb 11                	jmp    8016e7 <smalloc+0x146>
		markedPages[s] = 1;
  8016d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016d9:	c7 04 85 40 40 90 00 	movl   $0x1,0x904040(,%eax,4)
  8016e0:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = num_Of_Pages;
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  8016e4:	ff 45 e8             	incl   -0x18(%ebp)
  8016e7:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8016ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016ed:	01 d0                	add    %edx,%eax
  8016ef:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8016f2:	77 e2                	ja     8016d6 <smalloc+0x135>
		markedPages[s] = 1;
	}
	int sharedobjID = sys_createSharedObject(sharedVarName, size, isWritable,
  8016f4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016f7:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
  8016fb:	52                   	push   %edx
  8016fc:	50                   	push   %eax
  8016fd:	ff 75 0c             	pushl  0xc(%ebp)
  801700:	ff 75 08             	pushl  0x8(%ebp)
  801703:	e8 8f 04 00 00       	call   801b97 <sys_createSharedObject>
  801708:	83 c4 10             	add    $0x10,%esp
  80170b:	89 45 c0             	mov    %eax,-0x40(%ebp)
			(void*) start);

	if (sharedobjID >= 0) {
  80170e:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  801712:	78 12                	js     801726 <smalloc+0x185>
		shardIDs[startPage] = sharedobjID;
  801714:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801717:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80171a:	89 14 85 40 40 88 00 	mov    %edx,0x884040(,%eax,4)
		return (void*) start;
  801721:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801724:	eb 14                	jmp    80173a <smalloc+0x199>
	}
	free((void*) start);
  801726:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801729:	83 ec 0c             	sub    $0xc,%esp
  80172c:	50                   	push   %eax
  80172d:	e8 6e fd ff ff       	call   8014a0 <free>
  801732:	83 c4 10             	add    $0x10,%esp
	return NULL;
  801735:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80173a:	c9                   	leave  
  80173b:	c3                   	ret    

0080173c <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  80173c:	55                   	push   %ebp
  80173d:	89 e5                	mov    %esp,%ebp
  80173f:	83 ec 48             	sub    $0x48,%esp
	//cprintf("SSSSSGEEETTT\n");
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID, sharedVarName);
  801742:	83 ec 08             	sub    $0x8,%esp
  801745:	ff 75 0c             	pushl  0xc(%ebp)
  801748:	ff 75 08             	pushl  0x8(%ebp)
  80174b:	e8 71 04 00 00       	call   801bc1 <sys_getSizeOfSharedObject>
  801750:	83 c4 10             	add    $0x10,%esp
  801753:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (size < 0)
		return NULL;
	uint32 numb_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801756:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80175d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801760:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801763:	01 d0                	add    %edx,%eax
  801765:	48                   	dec    %eax
  801766:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801769:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80176c:	ba 00 00 00 00       	mov    $0x0,%edx
  801771:	f7 75 e0             	divl   -0x20(%ebp)
  801774:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801777:	29 d0                	sub    %edx,%eax
  801779:	c1 e8 0c             	shr    $0xc,%eax
  80177c:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 free_Pages_Count = 0;
  80177f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801786:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
  80178d:	a1 20 40 80 00       	mov    0x804020,%eax
  801792:	8b 40 7c             	mov    0x7c(%eax),%eax
  801795:	05 00 10 00 00       	add    $0x1000,%eax
  80179a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
  80179d:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8017a2:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8017a5:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
  8017a8:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8017af:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8017b2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8017b5:	01 d0                	add    %edx,%eax
  8017b7:	48                   	dec    %eax
  8017b8:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8017bb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8017be:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c3:	f7 75 cc             	divl   -0x34(%ebp)
  8017c6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8017c9:	29 d0                	sub    %edx,%eax
  8017cb:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8017ce:	76 0a                	jbe    8017da <sget+0x9e>
		return NULL;
  8017d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8017d5:	e9 f7 00 00 00       	jmp    8018d1 <sget+0x195>
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  8017da:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8017dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8017e0:	eb 48                	jmp    80182a <sget+0xee>
		uint32 idx = (s - current_Addr) / PAGE_SIZE;
  8017e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017e5:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8017e8:	c1 e8 0c             	shr    $0xc,%eax
  8017eb:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if (!markedPages[idx]) {
  8017ee:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8017f1:	8b 04 85 40 40 90 00 	mov    0x904040(,%eax,4),%eax
  8017f8:	85 c0                	test   %eax,%eax
  8017fa:	75 11                	jne    80180d <sget+0xd1>
			free_Pages_Count++;
  8017fc:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  8017ff:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801803:	75 16                	jne    80181b <sget+0xdf>
				start = s;
  801805:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801808:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80180b:	eb 0e                	jmp    80181b <sget+0xdf>
			}
		} else {
			free_Pages_Count = 0;
  80180d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  801814:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (free_Pages_Count == numb_Of_Pages) {
  80181b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80181e:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801821:	74 12                	je     801835 <sget+0xf9>
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
		return NULL;
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801823:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  80182a:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801831:	76 af                	jbe    8017e2 <sget+0xa6>
  801833:	eb 01                	jmp    801836 <sget+0xfa>
		} else {
			free_Pages_Count = 0;
			start = (uint32) -1;
		}
		if (free_Pages_Count == numb_Of_Pages) {
			break;
  801835:	90                   	nop
		}
	}
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
  801836:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80183a:	74 08                	je     801844 <sget+0x108>
  80183c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80183f:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801842:	74 0a                	je     80184e <sget+0x112>
		return NULL;
  801844:	b8 00 00 00 00       	mov    $0x0,%eax
  801849:	e9 83 00 00 00       	jmp    8018d1 <sget+0x195>
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
  80184e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801851:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801854:	c1 e8 0c             	shr    $0xc,%eax
  801857:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numb_Of_Pages;
  80185a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80185d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801860:	89 14 85 40 40 80 00 	mov    %edx,0x804040(,%eax,4)
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  801867:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80186a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80186d:	eb 11                	jmp    801880 <sget+0x144>
		markedPages[k] = 1;
  80186f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801872:	c7 04 85 40 40 90 00 	movl   $0x1,0x904040(,%eax,4)
  801879:	01 00 00 00 
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
	pagesAllocated[startPage] = numb_Of_Pages;
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  80187d:	ff 45 e8             	incl   -0x18(%ebp)
  801880:	8b 55 c0             	mov    -0x40(%ebp),%edx
  801883:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801886:	01 d0                	add    %edx,%eax
  801888:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80188b:	77 e2                	ja     80186f <sget+0x133>
		markedPages[k] = 1;
	}
	int ss = sys_getSharedObject(ownerEnvID, sharedVarName, (void*) start);
  80188d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801890:	83 ec 04             	sub    $0x4,%esp
  801893:	50                   	push   %eax
  801894:	ff 75 0c             	pushl  0xc(%ebp)
  801897:	ff 75 08             	pushl  0x8(%ebp)
  80189a:	e8 3f 03 00 00       	call   801bde <sys_getSharedObject>
  80189f:	83 c4 10             	add    $0x10,%esp
  8018a2:	89 45 bc             	mov    %eax,-0x44(%ebp)
	if (ss >= 0) {
  8018a5:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  8018a9:	78 12                	js     8018bd <sget+0x181>
		shardIDs[startPage] = ss;
  8018ab:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8018ae:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8018b1:	89 14 85 40 40 88 00 	mov    %edx,0x884040(,%eax,4)
		return (void*) start;
  8018b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018bb:	eb 14                	jmp    8018d1 <sget+0x195>
	}
	free((void*) start);
  8018bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018c0:	83 ec 0c             	sub    $0xc,%esp
  8018c3:	50                   	push   %eax
  8018c4:	e8 d7 fb ff ff       	call   8014a0 <free>
  8018c9:	83 c4 10             	add    $0x10,%esp
	return NULL;
  8018cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018d1:	c9                   	leave  
  8018d2:	c3                   	ret    

008018d3 <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  8018d3:	55                   	push   %ebp
  8018d4:	89 e5                	mov    %esp,%ebp
  8018d6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  8018d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8018dc:	a1 20 40 80 00       	mov    0x804020,%eax
  8018e1:	8b 40 7c             	mov    0x7c(%eax),%eax
  8018e4:	29 c2                	sub    %eax,%edx
  8018e6:	89 d0                	mov    %edx,%eax
  8018e8:	2d 00 10 00 00       	sub    $0x1000,%eax

void sfree(void* virtual_address) {
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
  8018ed:	c1 e8 0c             	shr    $0xc,%eax
  8018f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
	int id = shardIDs[pageIdx];
  8018f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018f6:	8b 04 85 40 40 88 00 	mov    0x884040(,%eax,4),%eax
  8018fd:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int result = sys_freeSharedObject(id, virtual_address);
  801900:	83 ec 08             	sub    $0x8,%esp
  801903:	ff 75 08             	pushl  0x8(%ebp)
  801906:	ff 75 f0             	pushl  -0x10(%ebp)
  801909:	e8 ef 02 00 00       	call   801bfd <sys_freeSharedObject>
  80190e:	83 c4 10             	add    $0x10,%esp
  801911:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (result == 0) {
  801914:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801918:	75 0e                	jne    801928 <sfree+0x55>
		shardIDs[pageIdx] = -1;  // Reset the ID after freeing
  80191a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80191d:	c7 04 85 40 40 88 00 	movl   $0xffffffff,0x884040(,%eax,4)
  801924:	ff ff ff ff 
	}

}
  801928:	90                   	nop
  801929:	c9                   	leave  
  80192a:	c3                   	ret    

0080192b <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  80192b:	55                   	push   %ebp
  80192c:	89 e5                	mov    %esp,%ebp
  80192e:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801931:	83 ec 04             	sub    $0x4,%esp
  801934:	68 a0 3b 80 00       	push   $0x803ba0
  801939:	68 19 01 00 00       	push   $0x119
  80193e:	68 92 3b 80 00       	push   $0x803b92
  801943:	e8 35 e9 ff ff       	call   80027d <_panic>

00801948 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  801948:	55                   	push   %ebp
  801949:	89 e5                	mov    %esp,%ebp
  80194b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80194e:	83 ec 04             	sub    $0x4,%esp
  801951:	68 c6 3b 80 00       	push   $0x803bc6
  801956:	68 23 01 00 00       	push   $0x123
  80195b:	68 92 3b 80 00       	push   $0x803b92
  801960:	e8 18 e9 ff ff       	call   80027d <_panic>

00801965 <shrink>:

}
void shrink(uint32 newSize) {
  801965:	55                   	push   %ebp
  801966:	89 e5                	mov    %esp,%ebp
  801968:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80196b:	83 ec 04             	sub    $0x4,%esp
  80196e:	68 c6 3b 80 00       	push   $0x803bc6
  801973:	68 27 01 00 00       	push   $0x127
  801978:	68 92 3b 80 00       	push   $0x803b92
  80197d:	e8 fb e8 ff ff       	call   80027d <_panic>

00801982 <freeHeap>:

}
void freeHeap(void* virtual_address) {
  801982:	55                   	push   %ebp
  801983:	89 e5                	mov    %esp,%ebp
  801985:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801988:	83 ec 04             	sub    $0x4,%esp
  80198b:	68 c6 3b 80 00       	push   $0x803bc6
  801990:	68 2b 01 00 00       	push   $0x12b
  801995:	68 92 3b 80 00       	push   $0x803b92
  80199a:	e8 de e8 ff ff       	call   80027d <_panic>

0080199f <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  80199f:	55                   	push   %ebp
  8019a0:	89 e5                	mov    %esp,%ebp
  8019a2:	57                   	push   %edi
  8019a3:	56                   	push   %esi
  8019a4:	53                   	push   %ebx
  8019a5:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ae:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019b1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019b4:	8b 7d 18             	mov    0x18(%ebp),%edi
  8019b7:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8019ba:	cd 30                	int    $0x30
  8019bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  8019bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8019c2:	83 c4 10             	add    $0x10,%esp
  8019c5:	5b                   	pop    %ebx
  8019c6:	5e                   	pop    %esi
  8019c7:	5f                   	pop    %edi
  8019c8:	5d                   	pop    %ebp
  8019c9:	c3                   	ret    

008019ca <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  8019ca:	55                   	push   %ebp
  8019cb:	89 e5                	mov    %esp,%ebp
  8019cd:	83 ec 04             	sub    $0x4,%esp
  8019d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8019d3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  8019d6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019da:	8b 45 08             	mov    0x8(%ebp),%eax
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	52                   	push   %edx
  8019e2:	ff 75 0c             	pushl  0xc(%ebp)
  8019e5:	50                   	push   %eax
  8019e6:	6a 00                	push   $0x0
  8019e8:	e8 b2 ff ff ff       	call   80199f <syscall>
  8019ed:	83 c4 18             	add    $0x18,%esp
}
  8019f0:	90                   	nop
  8019f1:	c9                   	leave  
  8019f2:	c3                   	ret    

008019f3 <sys_cgetc>:

int sys_cgetc(void) {
  8019f3:	55                   	push   %ebp
  8019f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 02                	push   $0x2
  801a02:	e8 98 ff ff ff       	call   80199f <syscall>
  801a07:	83 c4 18             	add    $0x18,%esp
}
  801a0a:	c9                   	leave  
  801a0b:	c3                   	ret    

00801a0c <sys_lock_cons>:

void sys_lock_cons(void) {
  801a0c:	55                   	push   %ebp
  801a0d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 03                	push   $0x3
  801a1b:	e8 7f ff ff ff       	call   80199f <syscall>
  801a20:	83 c4 18             	add    $0x18,%esp
}
  801a23:	90                   	nop
  801a24:	c9                   	leave  
  801a25:	c3                   	ret    

00801a26 <sys_unlock_cons>:
void sys_unlock_cons(void) {
  801a26:	55                   	push   %ebp
  801a27:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 04                	push   $0x4
  801a35:	e8 65 ff ff ff       	call   80199f <syscall>
  801a3a:	83 c4 18             	add    $0x18,%esp
}
  801a3d:	90                   	nop
  801a3e:	c9                   	leave  
  801a3f:	c3                   	ret    

00801a40 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  801a43:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a46:	8b 45 08             	mov    0x8(%ebp),%eax
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	52                   	push   %edx
  801a50:	50                   	push   %eax
  801a51:	6a 08                	push   $0x8
  801a53:	e8 47 ff ff ff       	call   80199f <syscall>
  801a58:	83 c4 18             	add    $0x18,%esp
}
  801a5b:	c9                   	leave  
  801a5c:	c3                   	ret    

00801a5d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  801a5d:	55                   	push   %ebp
  801a5e:	89 e5                	mov    %esp,%ebp
  801a60:	56                   	push   %esi
  801a61:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  801a62:	8b 75 18             	mov    0x18(%ebp),%esi
  801a65:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a68:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a71:	56                   	push   %esi
  801a72:	53                   	push   %ebx
  801a73:	51                   	push   %ecx
  801a74:	52                   	push   %edx
  801a75:	50                   	push   %eax
  801a76:	6a 09                	push   $0x9
  801a78:	e8 22 ff ff ff       	call   80199f <syscall>
  801a7d:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  801a80:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a83:	5b                   	pop    %ebx
  801a84:	5e                   	pop    %esi
  801a85:	5d                   	pop    %ebp
  801a86:	c3                   	ret    

00801a87 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  801a87:	55                   	push   %ebp
  801a88:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	52                   	push   %edx
  801a97:	50                   	push   %eax
  801a98:	6a 0a                	push   $0xa
  801a9a:	e8 00 ff ff ff       	call   80199f <syscall>
  801a9f:	83 c4 18             	add    $0x18,%esp
}
  801aa2:	c9                   	leave  
  801aa3:	c3                   	ret    

00801aa4 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  801aa4:	55                   	push   %ebp
  801aa5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	ff 75 0c             	pushl  0xc(%ebp)
  801ab0:	ff 75 08             	pushl  0x8(%ebp)
  801ab3:	6a 0b                	push   $0xb
  801ab5:	e8 e5 fe ff ff       	call   80199f <syscall>
  801aba:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  801abd:	c9                   	leave  
  801abe:	c3                   	ret    

00801abf <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  801abf:	55                   	push   %ebp
  801ac0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	6a 0c                	push   $0xc
  801ace:	e8 cc fe ff ff       	call   80199f <syscall>
  801ad3:	83 c4 18             	add    $0x18,%esp
}
  801ad6:	c9                   	leave  
  801ad7:	c3                   	ret    

00801ad8 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  801ad8:	55                   	push   %ebp
  801ad9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 0d                	push   $0xd
  801ae7:	e8 b3 fe ff ff       	call   80199f <syscall>
  801aec:	83 c4 18             	add    $0x18,%esp
}
  801aef:	c9                   	leave  
  801af0:	c3                   	ret    

00801af1 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  801af1:	55                   	push   %ebp
  801af2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	6a 0e                	push   $0xe
  801b00:	e8 9a fe ff ff       	call   80199f <syscall>
  801b05:	83 c4 18             	add    $0x18,%esp
}
  801b08:	c9                   	leave  
  801b09:	c3                   	ret    

00801b0a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  801b0a:	55                   	push   %ebp
  801b0b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 0f                	push   $0xf
  801b19:	e8 81 fe ff ff       	call   80199f <syscall>
  801b1e:	83 c4 18             	add    $0x18,%esp
}
  801b21:	c9                   	leave  
  801b22:	c3                   	ret    

00801b23 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  801b23:	55                   	push   %ebp
  801b24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	ff 75 08             	pushl  0x8(%ebp)
  801b31:	6a 10                	push   $0x10
  801b33:	e8 67 fe ff ff       	call   80199f <syscall>
  801b38:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  801b3b:	c9                   	leave  
  801b3c:	c3                   	ret    

00801b3d <sys_scarce_memory>:

void sys_scarce_memory() {
  801b3d:	55                   	push   %ebp
  801b3e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 11                	push   $0x11
  801b4c:	e8 4e fe ff ff       	call   80199f <syscall>
  801b51:	83 c4 18             	add    $0x18,%esp
}
  801b54:	90                   	nop
  801b55:	c9                   	leave  
  801b56:	c3                   	ret    

00801b57 <sys_cputc>:

void sys_cputc(const char c) {
  801b57:	55                   	push   %ebp
  801b58:	89 e5                	mov    %esp,%ebp
  801b5a:	83 ec 04             	sub    $0x4,%esp
  801b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b60:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b63:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	50                   	push   %eax
  801b70:	6a 01                	push   $0x1
  801b72:	e8 28 fe ff ff       	call   80199f <syscall>
  801b77:	83 c4 18             	add    $0x18,%esp
}
  801b7a:	90                   	nop
  801b7b:	c9                   	leave  
  801b7c:	c3                   	ret    

00801b7d <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  801b7d:	55                   	push   %ebp
  801b7e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 14                	push   $0x14
  801b8c:	e8 0e fe ff ff       	call   80199f <syscall>
  801b91:	83 c4 18             	add    $0x18,%esp
}
  801b94:	90                   	nop
  801b95:	c9                   	leave  
  801b96:	c3                   	ret    

00801b97 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  801b97:	55                   	push   %ebp
  801b98:	89 e5                	mov    %esp,%ebp
  801b9a:	83 ec 04             	sub    $0x4,%esp
  801b9d:	8b 45 10             	mov    0x10(%ebp),%eax
  801ba0:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  801ba3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ba6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801baa:	8b 45 08             	mov    0x8(%ebp),%eax
  801bad:	6a 00                	push   $0x0
  801baf:	51                   	push   %ecx
  801bb0:	52                   	push   %edx
  801bb1:	ff 75 0c             	pushl  0xc(%ebp)
  801bb4:	50                   	push   %eax
  801bb5:	6a 15                	push   $0x15
  801bb7:	e8 e3 fd ff ff       	call   80199f <syscall>
  801bbc:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  801bbf:	c9                   	leave  
  801bc0:	c3                   	ret    

00801bc1 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  801bc1:	55                   	push   %ebp
  801bc2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  801bc4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	52                   	push   %edx
  801bd1:	50                   	push   %eax
  801bd2:	6a 16                	push   $0x16
  801bd4:	e8 c6 fd ff ff       	call   80199f <syscall>
  801bd9:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  801bdc:	c9                   	leave  
  801bdd:	c3                   	ret    

00801bde <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  801bde:	55                   	push   %ebp
  801bdf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  801be1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801be4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	51                   	push   %ecx
  801bef:	52                   	push   %edx
  801bf0:	50                   	push   %eax
  801bf1:	6a 17                	push   $0x17
  801bf3:	e8 a7 fd ff ff       	call   80199f <syscall>
  801bf8:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  801bfb:	c9                   	leave  
  801bfc:	c3                   	ret    

00801bfd <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  801bfd:	55                   	push   %ebp
  801bfe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  801c00:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c03:	8b 45 08             	mov    0x8(%ebp),%eax
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	52                   	push   %edx
  801c0d:	50                   	push   %eax
  801c0e:	6a 18                	push   $0x18
  801c10:	e8 8a fd ff ff       	call   80199f <syscall>
  801c15:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  801c18:	c9                   	leave  
  801c19:	c3                   	ret    

00801c1a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  801c1a:	55                   	push   %ebp
  801c1b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  801c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c20:	6a 00                	push   $0x0
  801c22:	ff 75 14             	pushl  0x14(%ebp)
  801c25:	ff 75 10             	pushl  0x10(%ebp)
  801c28:	ff 75 0c             	pushl  0xc(%ebp)
  801c2b:	50                   	push   %eax
  801c2c:	6a 19                	push   $0x19
  801c2e:	e8 6c fd ff ff       	call   80199f <syscall>
  801c33:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  801c36:	c9                   	leave  
  801c37:	c3                   	ret    

00801c38 <sys_run_env>:

void sys_run_env(int32 envId) {
  801c38:	55                   	push   %ebp
  801c39:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  801c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	50                   	push   %eax
  801c47:	6a 1a                	push   $0x1a
  801c49:	e8 51 fd ff ff       	call   80199f <syscall>
  801c4e:	83 c4 18             	add    $0x18,%esp
}
  801c51:	90                   	nop
  801c52:	c9                   	leave  
  801c53:	c3                   	ret    

00801c54 <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  801c54:	55                   	push   %ebp
  801c55:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c57:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	50                   	push   %eax
  801c63:	6a 1b                	push   $0x1b
  801c65:	e8 35 fd ff ff       	call   80199f <syscall>
  801c6a:	83 c4 18             	add    $0x18,%esp
}
  801c6d:	c9                   	leave  
  801c6e:	c3                   	ret    

00801c6f <sys_getenvid>:

int32 sys_getenvid(void) {
  801c6f:	55                   	push   %ebp
  801c70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 05                	push   $0x5
  801c7e:	e8 1c fd ff ff       	call   80199f <syscall>
  801c83:	83 c4 18             	add    $0x18,%esp
}
  801c86:	c9                   	leave  
  801c87:	c3                   	ret    

00801c88 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  801c88:	55                   	push   %ebp
  801c89:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	6a 06                	push   $0x6
  801c97:	e8 03 fd ff ff       	call   80199f <syscall>
  801c9c:	83 c4 18             	add    $0x18,%esp
}
  801c9f:	c9                   	leave  
  801ca0:	c3                   	ret    

00801ca1 <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  801ca1:	55                   	push   %ebp
  801ca2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 07                	push   $0x7
  801cb0:	e8 ea fc ff ff       	call   80199f <syscall>
  801cb5:	83 c4 18             	add    $0x18,%esp
}
  801cb8:	c9                   	leave  
  801cb9:	c3                   	ret    

00801cba <sys_exit_env>:

void sys_exit_env(void) {
  801cba:	55                   	push   %ebp
  801cbb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 1c                	push   $0x1c
  801cc9:	e8 d1 fc ff ff       	call   80199f <syscall>
  801cce:	83 c4 18             	add    $0x18,%esp
}
  801cd1:	90                   	nop
  801cd2:	c9                   	leave  
  801cd3:	c3                   	ret    

00801cd4 <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  801cd4:	55                   	push   %ebp
  801cd5:	89 e5                	mov    %esp,%ebp
  801cd7:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  801cda:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cdd:	8d 50 04             	lea    0x4(%eax),%edx
  801ce0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	52                   	push   %edx
  801cea:	50                   	push   %eax
  801ceb:	6a 1d                	push   $0x1d
  801ced:	e8 ad fc ff ff       	call   80199f <syscall>
  801cf2:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  801cf5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cf8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cfb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cfe:	89 01                	mov    %eax,(%ecx)
  801d00:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d03:	8b 45 08             	mov    0x8(%ebp),%eax
  801d06:	c9                   	leave  
  801d07:	c2 04 00             	ret    $0x4

00801d0a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  801d0a:	55                   	push   %ebp
  801d0b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	ff 75 10             	pushl  0x10(%ebp)
  801d14:	ff 75 0c             	pushl  0xc(%ebp)
  801d17:	ff 75 08             	pushl  0x8(%ebp)
  801d1a:	6a 13                	push   $0x13
  801d1c:	e8 7e fc ff ff       	call   80199f <syscall>
  801d21:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  801d24:	90                   	nop
}
  801d25:	c9                   	leave  
  801d26:	c3                   	ret    

00801d27 <sys_rcr2>:
uint32 sys_rcr2() {
  801d27:	55                   	push   %ebp
  801d28:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	6a 1e                	push   $0x1e
  801d36:	e8 64 fc ff ff       	call   80199f <syscall>
  801d3b:	83 c4 18             	add    $0x18,%esp
}
  801d3e:	c9                   	leave  
  801d3f:	c3                   	ret    

00801d40 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  801d40:	55                   	push   %ebp
  801d41:	89 e5                	mov    %esp,%ebp
  801d43:	83 ec 04             	sub    $0x4,%esp
  801d46:	8b 45 08             	mov    0x8(%ebp),%eax
  801d49:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d4c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d50:	6a 00                	push   $0x0
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	50                   	push   %eax
  801d59:	6a 1f                	push   $0x1f
  801d5b:	e8 3f fc ff ff       	call   80199f <syscall>
  801d60:	83 c4 18             	add    $0x18,%esp
	return;
  801d63:	90                   	nop
}
  801d64:	c9                   	leave  
  801d65:	c3                   	ret    

00801d66 <rsttst>:
void rsttst() {
  801d66:	55                   	push   %ebp
  801d67:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	6a 21                	push   $0x21
  801d75:	e8 25 fc ff ff       	call   80199f <syscall>
  801d7a:	83 c4 18             	add    $0x18,%esp
	return;
  801d7d:	90                   	nop
}
  801d7e:	c9                   	leave  
  801d7f:	c3                   	ret    

00801d80 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  801d80:	55                   	push   %ebp
  801d81:	89 e5                	mov    %esp,%ebp
  801d83:	83 ec 04             	sub    $0x4,%esp
  801d86:	8b 45 14             	mov    0x14(%ebp),%eax
  801d89:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d8c:	8b 55 18             	mov    0x18(%ebp),%edx
  801d8f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d93:	52                   	push   %edx
  801d94:	50                   	push   %eax
  801d95:	ff 75 10             	pushl  0x10(%ebp)
  801d98:	ff 75 0c             	pushl  0xc(%ebp)
  801d9b:	ff 75 08             	pushl  0x8(%ebp)
  801d9e:	6a 20                	push   $0x20
  801da0:	e8 fa fb ff ff       	call   80199f <syscall>
  801da5:	83 c4 18             	add    $0x18,%esp
	return;
  801da8:	90                   	nop
}
  801da9:	c9                   	leave  
  801daa:	c3                   	ret    

00801dab <chktst>:
void chktst(uint32 n) {
  801dab:	55                   	push   %ebp
  801dac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 00                	push   $0x0
  801db4:	6a 00                	push   $0x0
  801db6:	ff 75 08             	pushl  0x8(%ebp)
  801db9:	6a 22                	push   $0x22
  801dbb:	e8 df fb ff ff       	call   80199f <syscall>
  801dc0:	83 c4 18             	add    $0x18,%esp
	return;
  801dc3:	90                   	nop
}
  801dc4:	c9                   	leave  
  801dc5:	c3                   	ret    

00801dc6 <inctst>:

void inctst() {
  801dc6:	55                   	push   %ebp
  801dc7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 23                	push   $0x23
  801dd5:	e8 c5 fb ff ff       	call   80199f <syscall>
  801dda:	83 c4 18             	add    $0x18,%esp
	return;
  801ddd:	90                   	nop
}
  801dde:	c9                   	leave  
  801ddf:	c3                   	ret    

00801de0 <gettst>:
uint32 gettst() {
  801de0:	55                   	push   %ebp
  801de1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801de3:	6a 00                	push   $0x0
  801de5:	6a 00                	push   $0x0
  801de7:	6a 00                	push   $0x0
  801de9:	6a 00                	push   $0x0
  801deb:	6a 00                	push   $0x0
  801ded:	6a 24                	push   $0x24
  801def:	e8 ab fb ff ff       	call   80199f <syscall>
  801df4:	83 c4 18             	add    $0x18,%esp
}
  801df7:	c9                   	leave  
  801df8:	c3                   	ret    

00801df9 <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  801df9:	55                   	push   %ebp
  801dfa:	89 e5                	mov    %esp,%ebp
  801dfc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dff:	6a 00                	push   $0x0
  801e01:	6a 00                	push   $0x0
  801e03:	6a 00                	push   $0x0
  801e05:	6a 00                	push   $0x0
  801e07:	6a 00                	push   $0x0
  801e09:	6a 25                	push   $0x25
  801e0b:	e8 8f fb ff ff       	call   80199f <syscall>
  801e10:	83 c4 18             	add    $0x18,%esp
  801e13:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e16:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e1a:	75 07                	jne    801e23 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e1c:	b8 01 00 00 00       	mov    $0x1,%eax
  801e21:	eb 05                	jmp    801e28 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e23:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e28:	c9                   	leave  
  801e29:	c3                   	ret    

00801e2a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  801e2a:	55                   	push   %ebp
  801e2b:	89 e5                	mov    %esp,%ebp
  801e2d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e30:	6a 00                	push   $0x0
  801e32:	6a 00                	push   $0x0
  801e34:	6a 00                	push   $0x0
  801e36:	6a 00                	push   $0x0
  801e38:	6a 00                	push   $0x0
  801e3a:	6a 25                	push   $0x25
  801e3c:	e8 5e fb ff ff       	call   80199f <syscall>
  801e41:	83 c4 18             	add    $0x18,%esp
  801e44:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e47:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e4b:	75 07                	jne    801e54 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e4d:	b8 01 00 00 00       	mov    $0x1,%eax
  801e52:	eb 05                	jmp    801e59 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e54:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e59:	c9                   	leave  
  801e5a:	c3                   	ret    

00801e5b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  801e5b:	55                   	push   %ebp
  801e5c:	89 e5                	mov    %esp,%ebp
  801e5e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e61:	6a 00                	push   $0x0
  801e63:	6a 00                	push   $0x0
  801e65:	6a 00                	push   $0x0
  801e67:	6a 00                	push   $0x0
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 25                	push   $0x25
  801e6d:	e8 2d fb ff ff       	call   80199f <syscall>
  801e72:	83 c4 18             	add    $0x18,%esp
  801e75:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e78:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e7c:	75 07                	jne    801e85 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e7e:	b8 01 00 00 00       	mov    $0x1,%eax
  801e83:	eb 05                	jmp    801e8a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e8a:	c9                   	leave  
  801e8b:	c3                   	ret    

00801e8c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  801e8c:	55                   	push   %ebp
  801e8d:	89 e5                	mov    %esp,%ebp
  801e8f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e92:	6a 00                	push   $0x0
  801e94:	6a 00                	push   $0x0
  801e96:	6a 00                	push   $0x0
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 25                	push   $0x25
  801e9e:	e8 fc fa ff ff       	call   80199f <syscall>
  801ea3:	83 c4 18             	add    $0x18,%esp
  801ea6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ea9:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ead:	75 07                	jne    801eb6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801eaf:	b8 01 00 00 00       	mov    $0x1,%eax
  801eb4:	eb 05                	jmp    801ebb <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801eb6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ebb:	c9                   	leave  
  801ebc:	c3                   	ret    

00801ebd <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  801ebd:	55                   	push   %ebp
  801ebe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 00                	push   $0x0
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 00                	push   $0x0
  801ec8:	ff 75 08             	pushl  0x8(%ebp)
  801ecb:	6a 26                	push   $0x26
  801ecd:	e8 cd fa ff ff       	call   80199f <syscall>
  801ed2:	83 c4 18             	add    $0x18,%esp
	return;
  801ed5:	90                   	nop
}
  801ed6:	c9                   	leave  
  801ed7:	c3                   	ret    

00801ed8 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  801ed8:	55                   	push   %ebp
  801ed9:	89 e5                	mov    %esp,%ebp
  801edb:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  801edc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801edf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ee2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee8:	6a 00                	push   $0x0
  801eea:	53                   	push   %ebx
  801eeb:	51                   	push   %ecx
  801eec:	52                   	push   %edx
  801eed:	50                   	push   %eax
  801eee:	6a 27                	push   $0x27
  801ef0:	e8 aa fa ff ff       	call   80199f <syscall>
  801ef5:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  801ef8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801efb:	c9                   	leave  
  801efc:	c3                   	ret    

00801efd <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  801efd:	55                   	push   %ebp
  801efe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  801f00:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f03:	8b 45 08             	mov    0x8(%ebp),%eax
  801f06:	6a 00                	push   $0x0
  801f08:	6a 00                	push   $0x0
  801f0a:	6a 00                	push   $0x0
  801f0c:	52                   	push   %edx
  801f0d:	50                   	push   %eax
  801f0e:	6a 28                	push   $0x28
  801f10:	e8 8a fa ff ff       	call   80199f <syscall>
  801f15:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  801f18:	c9                   	leave  
  801f19:	c3                   	ret    

00801f1a <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  801f1a:	55                   	push   %ebp
  801f1b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  801f1d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f20:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f23:	8b 45 08             	mov    0x8(%ebp),%eax
  801f26:	6a 00                	push   $0x0
  801f28:	51                   	push   %ecx
  801f29:	ff 75 10             	pushl  0x10(%ebp)
  801f2c:	52                   	push   %edx
  801f2d:	50                   	push   %eax
  801f2e:	6a 29                	push   $0x29
  801f30:	e8 6a fa ff ff       	call   80199f <syscall>
  801f35:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  801f38:	c9                   	leave  
  801f39:	c3                   	ret    

00801f3a <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  801f3a:	55                   	push   %ebp
  801f3b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801f3d:	6a 00                	push   $0x0
  801f3f:	6a 00                	push   $0x0
  801f41:	ff 75 10             	pushl  0x10(%ebp)
  801f44:	ff 75 0c             	pushl  0xc(%ebp)
  801f47:	ff 75 08             	pushl  0x8(%ebp)
  801f4a:	6a 12                	push   $0x12
  801f4c:	e8 4e fa ff ff       	call   80199f <syscall>
  801f51:	83 c4 18             	add    $0x18,%esp
	return;
  801f54:	90                   	nop
}
  801f55:	c9                   	leave  
  801f56:	c3                   	ret    

00801f57 <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  801f57:	55                   	push   %ebp
  801f58:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  801f5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f60:	6a 00                	push   $0x0
  801f62:	6a 00                	push   $0x0
  801f64:	6a 00                	push   $0x0
  801f66:	52                   	push   %edx
  801f67:	50                   	push   %eax
  801f68:	6a 2a                	push   $0x2a
  801f6a:	e8 30 fa ff ff       	call   80199f <syscall>
  801f6f:	83 c4 18             	add    $0x18,%esp
	return;
  801f72:	90                   	nop
}
  801f73:	c9                   	leave  
  801f74:	c3                   	ret    

00801f75 <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  801f75:	55                   	push   %ebp
  801f76:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  801f78:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7b:	6a 00                	push   $0x0
  801f7d:	6a 00                	push   $0x0
  801f7f:	6a 00                	push   $0x0
  801f81:	6a 00                	push   $0x0
  801f83:	50                   	push   %eax
  801f84:	6a 2b                	push   $0x2b
  801f86:	e8 14 fa ff ff       	call   80199f <syscall>
  801f8b:	83 c4 18             	add    $0x18,%esp
}
  801f8e:	c9                   	leave  
  801f8f:	c3                   	ret    

00801f90 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  801f90:	55                   	push   %ebp
  801f91:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801f93:	6a 00                	push   $0x0
  801f95:	6a 00                	push   $0x0
  801f97:	6a 00                	push   $0x0
  801f99:	ff 75 0c             	pushl  0xc(%ebp)
  801f9c:	ff 75 08             	pushl  0x8(%ebp)
  801f9f:	6a 2c                	push   $0x2c
  801fa1:	e8 f9 f9 ff ff       	call   80199f <syscall>
  801fa6:	83 c4 18             	add    $0x18,%esp
	return;
  801fa9:	90                   	nop
}
  801faa:	c9                   	leave  
  801fab:	c3                   	ret    

00801fac <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  801fac:	55                   	push   %ebp
  801fad:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801faf:	6a 00                	push   $0x0
  801fb1:	6a 00                	push   $0x0
  801fb3:	6a 00                	push   $0x0
  801fb5:	ff 75 0c             	pushl  0xc(%ebp)
  801fb8:	ff 75 08             	pushl  0x8(%ebp)
  801fbb:	6a 2d                	push   $0x2d
  801fbd:	e8 dd f9 ff ff       	call   80199f <syscall>
  801fc2:	83 c4 18             	add    $0x18,%esp
	return;
  801fc5:	90                   	nop
}
  801fc6:	c9                   	leave  
  801fc7:	c3                   	ret    

00801fc8 <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  801fc8:	55                   	push   %ebp
  801fc9:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  801fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fce:	6a 00                	push   $0x0
  801fd0:	6a 00                	push   $0x0
  801fd2:	6a 00                	push   $0x0
  801fd4:	6a 00                	push   $0x0
  801fd6:	50                   	push   %eax
  801fd7:	6a 2f                	push   $0x2f
  801fd9:	e8 c1 f9 ff ff       	call   80199f <syscall>
  801fde:	83 c4 18             	add    $0x18,%esp
	return;
  801fe1:	90                   	nop
}
  801fe2:	c9                   	leave  
  801fe3:	c3                   	ret    

00801fe4 <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  801fe4:	55                   	push   %ebp
  801fe5:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  801fe7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fea:	8b 45 08             	mov    0x8(%ebp),%eax
  801fed:	6a 00                	push   $0x0
  801fef:	6a 00                	push   $0x0
  801ff1:	6a 00                	push   $0x0
  801ff3:	52                   	push   %edx
  801ff4:	50                   	push   %eax
  801ff5:	6a 30                	push   $0x30
  801ff7:	e8 a3 f9 ff ff       	call   80199f <syscall>
  801ffc:	83 c4 18             	add    $0x18,%esp
	return;
  801fff:	90                   	nop
}
  802000:	c9                   	leave  
  802001:	c3                   	ret    

00802002 <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  802002:	55                   	push   %ebp
  802003:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  802005:	8b 45 08             	mov    0x8(%ebp),%eax
  802008:	6a 00                	push   $0x0
  80200a:	6a 00                	push   $0x0
  80200c:	6a 00                	push   $0x0
  80200e:	6a 00                	push   $0x0
  802010:	50                   	push   %eax
  802011:	6a 31                	push   $0x31
  802013:	e8 87 f9 ff ff       	call   80199f <syscall>
  802018:	83 c4 18             	add    $0x18,%esp
	return;
  80201b:	90                   	nop
}
  80201c:	c9                   	leave  
  80201d:	c3                   	ret    

0080201e <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  80201e:	55                   	push   %ebp
  80201f:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  802021:	8b 55 0c             	mov    0xc(%ebp),%edx
  802024:	8b 45 08             	mov    0x8(%ebp),%eax
  802027:	6a 00                	push   $0x0
  802029:	6a 00                	push   $0x0
  80202b:	6a 00                	push   $0x0
  80202d:	52                   	push   %edx
  80202e:	50                   	push   %eax
  80202f:	6a 2e                	push   $0x2e
  802031:	e8 69 f9 ff ff       	call   80199f <syscall>
  802036:	83 c4 18             	add    $0x18,%esp
    return;
  802039:	90                   	nop
}
  80203a:	c9                   	leave  
  80203b:	c3                   	ret    

0080203c <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  80203c:	55                   	push   %ebp
  80203d:	89 e5                	mov    %esp,%ebp
  80203f:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802042:	8b 45 08             	mov    0x8(%ebp),%eax
  802045:	83 e8 04             	sub    $0x4,%eax
  802048:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  80204b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80204e:	8b 00                	mov    (%eax),%eax
  802050:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802053:	c9                   	leave  
  802054:	c3                   	ret    

00802055 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802055:	55                   	push   %ebp
  802056:	89 e5                	mov    %esp,%ebp
  802058:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80205b:	8b 45 08             	mov    0x8(%ebp),%eax
  80205e:	83 e8 04             	sub    $0x4,%eax
  802061:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802064:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802067:	8b 00                	mov    (%eax),%eax
  802069:	83 e0 01             	and    $0x1,%eax
  80206c:	85 c0                	test   %eax,%eax
  80206e:	0f 94 c0             	sete   %al
}
  802071:	c9                   	leave  
  802072:	c3                   	ret    

00802073 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802073:	55                   	push   %ebp
  802074:	89 e5                	mov    %esp,%ebp
  802076:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802079:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802080:	8b 45 0c             	mov    0xc(%ebp),%eax
  802083:	83 f8 02             	cmp    $0x2,%eax
  802086:	74 2b                	je     8020b3 <alloc_block+0x40>
  802088:	83 f8 02             	cmp    $0x2,%eax
  80208b:	7f 07                	jg     802094 <alloc_block+0x21>
  80208d:	83 f8 01             	cmp    $0x1,%eax
  802090:	74 0e                	je     8020a0 <alloc_block+0x2d>
  802092:	eb 58                	jmp    8020ec <alloc_block+0x79>
  802094:	83 f8 03             	cmp    $0x3,%eax
  802097:	74 2d                	je     8020c6 <alloc_block+0x53>
  802099:	83 f8 04             	cmp    $0x4,%eax
  80209c:	74 3b                	je     8020d9 <alloc_block+0x66>
  80209e:	eb 4c                	jmp    8020ec <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8020a0:	83 ec 0c             	sub    $0xc,%esp
  8020a3:	ff 75 08             	pushl  0x8(%ebp)
  8020a6:	e8 f7 03 00 00       	call   8024a2 <alloc_block_FF>
  8020ab:	83 c4 10             	add    $0x10,%esp
  8020ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020b1:	eb 4a                	jmp    8020fd <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8020b3:	83 ec 0c             	sub    $0xc,%esp
  8020b6:	ff 75 08             	pushl  0x8(%ebp)
  8020b9:	e8 f0 11 00 00       	call   8032ae <alloc_block_NF>
  8020be:	83 c4 10             	add    $0x10,%esp
  8020c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020c4:	eb 37                	jmp    8020fd <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8020c6:	83 ec 0c             	sub    $0xc,%esp
  8020c9:	ff 75 08             	pushl  0x8(%ebp)
  8020cc:	e8 08 08 00 00       	call   8028d9 <alloc_block_BF>
  8020d1:	83 c4 10             	add    $0x10,%esp
  8020d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020d7:	eb 24                	jmp    8020fd <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8020d9:	83 ec 0c             	sub    $0xc,%esp
  8020dc:	ff 75 08             	pushl  0x8(%ebp)
  8020df:	e8 ad 11 00 00       	call   803291 <alloc_block_WF>
  8020e4:	83 c4 10             	add    $0x10,%esp
  8020e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020ea:	eb 11                	jmp    8020fd <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8020ec:	83 ec 0c             	sub    $0xc,%esp
  8020ef:	68 d8 3b 80 00       	push   $0x803bd8
  8020f4:	e8 41 e4 ff ff       	call   80053a <cprintf>
  8020f9:	83 c4 10             	add    $0x10,%esp
		break;
  8020fc:	90                   	nop
	}
	return va;
  8020fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802100:	c9                   	leave  
  802101:	c3                   	ret    

00802102 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802102:	55                   	push   %ebp
  802103:	89 e5                	mov    %esp,%ebp
  802105:	53                   	push   %ebx
  802106:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802109:	83 ec 0c             	sub    $0xc,%esp
  80210c:	68 f8 3b 80 00       	push   $0x803bf8
  802111:	e8 24 e4 ff ff       	call   80053a <cprintf>
  802116:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802119:	83 ec 0c             	sub    $0xc,%esp
  80211c:	68 23 3c 80 00       	push   $0x803c23
  802121:	e8 14 e4 ff ff       	call   80053a <cprintf>
  802126:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802129:	8b 45 08             	mov    0x8(%ebp),%eax
  80212c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80212f:	eb 37                	jmp    802168 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802131:	83 ec 0c             	sub    $0xc,%esp
  802134:	ff 75 f4             	pushl  -0xc(%ebp)
  802137:	e8 19 ff ff ff       	call   802055 <is_free_block>
  80213c:	83 c4 10             	add    $0x10,%esp
  80213f:	0f be d8             	movsbl %al,%ebx
  802142:	83 ec 0c             	sub    $0xc,%esp
  802145:	ff 75 f4             	pushl  -0xc(%ebp)
  802148:	e8 ef fe ff ff       	call   80203c <get_block_size>
  80214d:	83 c4 10             	add    $0x10,%esp
  802150:	83 ec 04             	sub    $0x4,%esp
  802153:	53                   	push   %ebx
  802154:	50                   	push   %eax
  802155:	68 3b 3c 80 00       	push   $0x803c3b
  80215a:	e8 db e3 ff ff       	call   80053a <cprintf>
  80215f:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802162:	8b 45 10             	mov    0x10(%ebp),%eax
  802165:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802168:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80216c:	74 07                	je     802175 <print_blocks_list+0x73>
  80216e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802171:	8b 00                	mov    (%eax),%eax
  802173:	eb 05                	jmp    80217a <print_blocks_list+0x78>
  802175:	b8 00 00 00 00       	mov    $0x0,%eax
  80217a:	89 45 10             	mov    %eax,0x10(%ebp)
  80217d:	8b 45 10             	mov    0x10(%ebp),%eax
  802180:	85 c0                	test   %eax,%eax
  802182:	75 ad                	jne    802131 <print_blocks_list+0x2f>
  802184:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802188:	75 a7                	jne    802131 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  80218a:	83 ec 0c             	sub    $0xc,%esp
  80218d:	68 f8 3b 80 00       	push   $0x803bf8
  802192:	e8 a3 e3 ff ff       	call   80053a <cprintf>
  802197:	83 c4 10             	add    $0x10,%esp

}
  80219a:	90                   	nop
  80219b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80219e:	c9                   	leave  
  80219f:	c3                   	ret    

008021a0 <initialize_dynamic_allocator>:

//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8021a0:	55                   	push   %ebp
  8021a1:	89 e5                	mov    %esp,%ebp
  8021a3:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8021a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021a9:	83 e0 01             	and    $0x1,%eax
  8021ac:	85 c0                	test   %eax,%eax
  8021ae:	74 03                	je     8021b3 <initialize_dynamic_allocator+0x13>
  8021b0:	ff 45 0c             	incl   0xc(%ebp)
		if (initSizeOfAllocatedSpace == 0)
  8021b3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8021b7:	0f 84 f8 00 00 00    	je     8022b5 <initialize_dynamic_allocator+0x115>
			return ;
		is_initialized = 1;
  8021bd:	c7 05 40 40 98 00 01 	movl   $0x1,0x984040
  8021c4:	00 00 00 
	//TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("initialize_dynamic_allocator is not implemented yet");
	//Your Code is Here...

	if(is_initialized){
  8021c7:	a1 40 40 98 00       	mov    0x984040,%eax
  8021cc:	85 c0                	test   %eax,%eax
  8021ce:	0f 84 e2 00 00 00    	je     8022b6 <initialize_dynamic_allocator+0x116>

		// begin block with size 0 and lsb = 1 (allocated)
		uint32* beginBlock = (uint32*)daStart;
  8021d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		*beginBlock = 0 | 1; // size = 0, LSB as a flag = 1
  8021da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021dd:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		// end block with size 0 and lsb = 1 (allocated)
		uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);
  8021e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8021e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021e9:	01 d0                	add    %edx,%eax
  8021eb:	83 e8 04             	sub    $0x4,%eax
  8021ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
		*endBlock = 0 | 1; // size = 0, LSB as a flag = 1
  8021f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021f4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

		// the block that between begin and end blocks
		struct BlockElement* block = (struct BlockElement*)(daStart + 8);
  8021fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fd:	83 c0 08             	add    $0x8,%eax
  802200:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 blockSize = initSizeOfAllocatedSpace - 8; // subtract size of begin and end blocks
  802203:	8b 45 0c             	mov    0xc(%ebp),%eax
  802206:	83 e8 08             	sub    $0x8,%eax
  802209:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(block,blockSize,0);
  80220c:	83 ec 04             	sub    $0x4,%esp
  80220f:	6a 00                	push   $0x0
  802211:	ff 75 e8             	pushl  -0x18(%ebp)
  802214:	ff 75 ec             	pushl  -0x14(%ebp)
  802217:	e8 9c 00 00 00       	call   8022b8 <set_block_data>
  80221c:	83 c4 10             	add    $0x10,%esp

		block->prev_next_info.le_next = NULL;
  80221f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802222:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block->prev_next_info.le_prev = NULL;
  802228:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80222b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

		LIST_INIT(&freeBlocksList);
  802232:	c7 05 48 40 98 00 00 	movl   $0x0,0x984048
  802239:	00 00 00 
  80223c:	c7 05 4c 40 98 00 00 	movl   $0x0,0x98404c
  802243:	00 00 00 
  802246:	c7 05 54 40 98 00 00 	movl   $0x0,0x984054
  80224d:	00 00 00 
		LIST_INSERT_HEAD(&freeBlocksList, block);
  802250:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802254:	75 17                	jne    80226d <initialize_dynamic_allocator+0xcd>
  802256:	83 ec 04             	sub    $0x4,%esp
  802259:	68 54 3c 80 00       	push   $0x803c54
  80225e:	68 80 00 00 00       	push   $0x80
  802263:	68 77 3c 80 00       	push   $0x803c77
  802268:	e8 10 e0 ff ff       	call   80027d <_panic>
  80226d:	8b 15 48 40 98 00    	mov    0x984048,%edx
  802273:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802276:	89 10                	mov    %edx,(%eax)
  802278:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80227b:	8b 00                	mov    (%eax),%eax
  80227d:	85 c0                	test   %eax,%eax
  80227f:	74 0d                	je     80228e <initialize_dynamic_allocator+0xee>
  802281:	a1 48 40 98 00       	mov    0x984048,%eax
  802286:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802289:	89 50 04             	mov    %edx,0x4(%eax)
  80228c:	eb 08                	jmp    802296 <initialize_dynamic_allocator+0xf6>
  80228e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802291:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802296:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802299:	a3 48 40 98 00       	mov    %eax,0x984048
  80229e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022a1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022a8:	a1 54 40 98 00       	mov    0x984054,%eax
  8022ad:	40                   	inc    %eax
  8022ae:	a3 54 40 98 00       	mov    %eax,0x984054
  8022b3:	eb 01                	jmp    8022b6 <initialize_dynamic_allocator+0x116>
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
		if (initSizeOfAllocatedSpace == 0)
			return ;
  8022b5:	90                   	nop
		block->prev_next_info.le_prev = NULL;

		LIST_INIT(&freeBlocksList);
		LIST_INSERT_HEAD(&freeBlocksList, block);
	}
}
  8022b6:	c9                   	leave  
  8022b7:	c3                   	ret    

008022b8 <set_block_data>:
//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8022b8:	55                   	push   %ebp
  8022b9:	89 e5                	mov    %esp,%ebp
  8022bb:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("set_block_data is not implemented yet");
	//Your Code is Here...

	if(totalSize % 2 != 0)
  8022be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022c1:	83 e0 01             	and    $0x1,%eax
  8022c4:	85 c0                	test   %eax,%eax
  8022c6:	74 03                	je     8022cb <set_block_data+0x13>
	{
		totalSize++;
  8022c8:	ff 45 0c             	incl   0xc(%ebp)
	}

	uint32* header = (uint32 *)((uint32*)va-1);
  8022cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ce:	83 e8 04             	sub    $0x4,%eax
  8022d1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//	size => totalSize with LSB = 0		 set LSB = 1 if isAllocated
	*header = (totalSize & ~1) | (isAllocated & 1);
  8022d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022d7:	83 e0 fe             	and    $0xfffffffe,%eax
  8022da:	89 c2                	mov    %eax,%edx
  8022dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8022df:	83 e0 01             	and    $0x1,%eax
  8022e2:	09 c2                	or     %eax,%edx
  8022e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022e7:	89 10                	mov    %edx,(%eax)
	uint32* footer = (uint32*) (va + totalSize - 8);
  8022e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ec:	8d 50 f8             	lea    -0x8(%eax),%edx
  8022ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f2:	01 d0                	add    %edx,%eax
  8022f4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	*footer = (totalSize & ~1) | (isAllocated & 1);
  8022f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022fa:	83 e0 fe             	and    $0xfffffffe,%eax
  8022fd:	89 c2                	mov    %eax,%edx
  8022ff:	8b 45 10             	mov    0x10(%ebp),%eax
  802302:	83 e0 01             	and    $0x1,%eax
  802305:	09 c2                	or     %eax,%edx
  802307:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80230a:	89 10                	mov    %edx,(%eax)
}
  80230c:	90                   	nop
  80230d:	c9                   	leave  
  80230e:	c3                   	ret    

0080230f <insert_sorted_in_freeList>:
//=========================================
void insert_sorted_in_freeList(struct BlockElement *newBlock)
{
  80230f:	55                   	push   %ebp
  802310:	89 e5                	mov    %esp,%ebp
  802312:	83 ec 18             	sub    $0x18,%esp
	if(LIST_EMPTY(&freeBlocksList))
  802315:	a1 48 40 98 00       	mov    0x984048,%eax
  80231a:	85 c0                	test   %eax,%eax
  80231c:	75 68                	jne    802386 <insert_sorted_in_freeList+0x77>
	{
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
  80231e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802322:	75 17                	jne    80233b <insert_sorted_in_freeList+0x2c>
  802324:	83 ec 04             	sub    $0x4,%esp
  802327:	68 54 3c 80 00       	push   $0x803c54
  80232c:	68 9d 00 00 00       	push   $0x9d
  802331:	68 77 3c 80 00       	push   $0x803c77
  802336:	e8 42 df ff ff       	call   80027d <_panic>
  80233b:	8b 15 48 40 98 00    	mov    0x984048,%edx
  802341:	8b 45 08             	mov    0x8(%ebp),%eax
  802344:	89 10                	mov    %edx,(%eax)
  802346:	8b 45 08             	mov    0x8(%ebp),%eax
  802349:	8b 00                	mov    (%eax),%eax
  80234b:	85 c0                	test   %eax,%eax
  80234d:	74 0d                	je     80235c <insert_sorted_in_freeList+0x4d>
  80234f:	a1 48 40 98 00       	mov    0x984048,%eax
  802354:	8b 55 08             	mov    0x8(%ebp),%edx
  802357:	89 50 04             	mov    %edx,0x4(%eax)
  80235a:	eb 08                	jmp    802364 <insert_sorted_in_freeList+0x55>
  80235c:	8b 45 08             	mov    0x8(%ebp),%eax
  80235f:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802364:	8b 45 08             	mov    0x8(%ebp),%eax
  802367:	a3 48 40 98 00       	mov    %eax,0x984048
  80236c:	8b 45 08             	mov    0x8(%ebp),%eax
  80236f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802376:	a1 54 40 98 00       	mov    0x984054,%eax
  80237b:	40                   	inc    %eax
  80237c:	a3 54 40 98 00       	mov    %eax,0x984054
		return;
  802381:	e9 1a 01 00 00       	jmp    8024a0 <insert_sorted_in_freeList+0x191>
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  802386:	a1 48 40 98 00       	mov    0x984048,%eax
  80238b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80238e:	eb 7f                	jmp    80240f <insert_sorted_in_freeList+0x100>
	{
		if(blk > newBlock) // if address of blk > address of newBlock => add newBlock before blk
  802390:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802393:	3b 45 08             	cmp    0x8(%ebp),%eax
  802396:	76 6f                	jbe    802407 <insert_sorted_in_freeList+0xf8>
		{
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
  802398:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80239c:	74 06                	je     8023a4 <insert_sorted_in_freeList+0x95>
  80239e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023a2:	75 17                	jne    8023bb <insert_sorted_in_freeList+0xac>
  8023a4:	83 ec 04             	sub    $0x4,%esp
  8023a7:	68 90 3c 80 00       	push   $0x803c90
  8023ac:	68 a6 00 00 00       	push   $0xa6
  8023b1:	68 77 3c 80 00       	push   $0x803c77
  8023b6:	e8 c2 de ff ff       	call   80027d <_panic>
  8023bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023be:	8b 50 04             	mov    0x4(%eax),%edx
  8023c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c4:	89 50 04             	mov    %edx,0x4(%eax)
  8023c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023cd:	89 10                	mov    %edx,(%eax)
  8023cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d2:	8b 40 04             	mov    0x4(%eax),%eax
  8023d5:	85 c0                	test   %eax,%eax
  8023d7:	74 0d                	je     8023e6 <insert_sorted_in_freeList+0xd7>
  8023d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023dc:	8b 40 04             	mov    0x4(%eax),%eax
  8023df:	8b 55 08             	mov    0x8(%ebp),%edx
  8023e2:	89 10                	mov    %edx,(%eax)
  8023e4:	eb 08                	jmp    8023ee <insert_sorted_in_freeList+0xdf>
  8023e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e9:	a3 48 40 98 00       	mov    %eax,0x984048
  8023ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8023f4:	89 50 04             	mov    %edx,0x4(%eax)
  8023f7:	a1 54 40 98 00       	mov    0x984054,%eax
  8023fc:	40                   	inc    %eax
  8023fd:	a3 54 40 98 00       	mov    %eax,0x984054
			return;
  802402:	e9 99 00 00 00       	jmp    8024a0 <insert_sorted_in_freeList+0x191>
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
		return;
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  802407:	a1 50 40 98 00       	mov    0x984050,%eax
  80240c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80240f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802413:	74 07                	je     80241c <insert_sorted_in_freeList+0x10d>
  802415:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802418:	8b 00                	mov    (%eax),%eax
  80241a:	eb 05                	jmp    802421 <insert_sorted_in_freeList+0x112>
  80241c:	b8 00 00 00 00       	mov    $0x0,%eax
  802421:	a3 50 40 98 00       	mov    %eax,0x984050
  802426:	a1 50 40 98 00       	mov    0x984050,%eax
  80242b:	85 c0                	test   %eax,%eax
  80242d:	0f 85 5d ff ff ff    	jne    802390 <insert_sorted_in_freeList+0x81>
  802433:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802437:	0f 85 53 ff ff ff    	jne    802390 <insert_sorted_in_freeList+0x81>
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
			return;
		}
	}
	// if no blk its address > newBlock
	LIST_INSERT_TAIL(&freeBlocksList, newBlock);
  80243d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802441:	75 17                	jne    80245a <insert_sorted_in_freeList+0x14b>
  802443:	83 ec 04             	sub    $0x4,%esp
  802446:	68 c8 3c 80 00       	push   $0x803cc8
  80244b:	68 ab 00 00 00       	push   $0xab
  802450:	68 77 3c 80 00       	push   $0x803c77
  802455:	e8 23 de ff ff       	call   80027d <_panic>
  80245a:	8b 15 4c 40 98 00    	mov    0x98404c,%edx
  802460:	8b 45 08             	mov    0x8(%ebp),%eax
  802463:	89 50 04             	mov    %edx,0x4(%eax)
  802466:	8b 45 08             	mov    0x8(%ebp),%eax
  802469:	8b 40 04             	mov    0x4(%eax),%eax
  80246c:	85 c0                	test   %eax,%eax
  80246e:	74 0c                	je     80247c <insert_sorted_in_freeList+0x16d>
  802470:	a1 4c 40 98 00       	mov    0x98404c,%eax
  802475:	8b 55 08             	mov    0x8(%ebp),%edx
  802478:	89 10                	mov    %edx,(%eax)
  80247a:	eb 08                	jmp    802484 <insert_sorted_in_freeList+0x175>
  80247c:	8b 45 08             	mov    0x8(%ebp),%eax
  80247f:	a3 48 40 98 00       	mov    %eax,0x984048
  802484:	8b 45 08             	mov    0x8(%ebp),%eax
  802487:	a3 4c 40 98 00       	mov    %eax,0x98404c
  80248c:	8b 45 08             	mov    0x8(%ebp),%eax
  80248f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802495:	a1 54 40 98 00       	mov    0x984054,%eax
  80249a:	40                   	inc    %eax
  80249b:	a3 54 40 98 00       	mov    %eax,0x984054
}
  8024a0:	c9                   	leave  
  8024a1:	c3                   	ret    

008024a2 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  8024a2:	55                   	push   %ebp
  8024a3:	89 e5                	mov    %esp,%ebp
  8024a5:	83 ec 78             	sub    $0x78,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8024a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ab:	83 e0 01             	and    $0x1,%eax
  8024ae:	85 c0                	test   %eax,%eax
  8024b0:	74 03                	je     8024b5 <alloc_block_FF+0x13>
  8024b2:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8024b5:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8024b9:	77 07                	ja     8024c2 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8024bb:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8024c2:	a1 40 40 98 00       	mov    0x984040,%eax
  8024c7:	85 c0                	test   %eax,%eax
  8024c9:	75 63                	jne    80252e <alloc_block_FF+0x8c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8024cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ce:	83 c0 10             	add    $0x10,%eax
  8024d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8024d4:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8024db:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024e1:	01 d0                	add    %edx,%eax
  8024e3:	48                   	dec    %eax
  8024e4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8024e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8024ef:	f7 75 ec             	divl   -0x14(%ebp)
  8024f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024f5:	29 d0                	sub    %edx,%eax
  8024f7:	c1 e8 0c             	shr    $0xc,%eax
  8024fa:	83 ec 0c             	sub    $0xc,%esp
  8024fd:	50                   	push   %eax
  8024fe:	e8 d1 ed ff ff       	call   8012d4 <sbrk>
  802503:	83 c4 10             	add    $0x10,%esp
  802506:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802509:	83 ec 0c             	sub    $0xc,%esp
  80250c:	6a 00                	push   $0x0
  80250e:	e8 c1 ed ff ff       	call   8012d4 <sbrk>
  802513:	83 c4 10             	add    $0x10,%esp
  802516:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802519:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80251c:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80251f:	83 ec 08             	sub    $0x8,%esp
  802522:	50                   	push   %eax
  802523:	ff 75 e4             	pushl  -0x1c(%ebp)
  802526:	e8 75 fc ff ff       	call   8021a0 <initialize_dynamic_allocator>
  80252b:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(size == 0)
  80252e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802532:	75 0a                	jne    80253e <alloc_block_FF+0x9c>
	{
		return NULL;
  802534:	b8 00 00 00 00       	mov    $0x0,%eax
  802539:	e9 99 03 00 00       	jmp    8028d7 <alloc_block_FF+0x435>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  80253e:	8b 45 08             	mov    0x8(%ebp),%eax
  802541:	83 c0 08             	add    $0x8,%eax
  802544:	89 45 dc             	mov    %eax,-0x24(%ebp)

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802547:	a1 48 40 98 00       	mov    0x984048,%eax
  80254c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80254f:	e9 03 02 00 00       	jmp    802757 <alloc_block_FF+0x2b5>
	{
		uint32 blockSize = get_block_size(block); // Get size without the (LSB) allocation flag
  802554:	83 ec 0c             	sub    $0xc,%esp
  802557:	ff 75 f4             	pushl  -0xc(%ebp)
  80255a:	e8 dd fa ff ff       	call   80203c <get_block_size>
  80255f:	83 c4 10             	add    $0x10,%esp
  802562:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if(blockSize >= totalSize)
  802565:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802568:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80256b:	0f 82 de 01 00 00    	jb     80274f <alloc_block_FF+0x2ad>
		{	//if we can put another block with min size 16
			if(blockSize >= totalSize + 4*sizeof(uint32))
  802571:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802574:	83 c0 10             	add    $0x10,%eax
  802577:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  80257a:	0f 87 32 01 00 00    	ja     8026b2 <alloc_block_FF+0x210>
			{
				// the size that will remain from the block that we will allocate a new block in it
				uint32 remainingSize = blockSize - totalSize;
  802580:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802583:	2b 45 dc             	sub    -0x24(%ebp),%eax
  802586:	89 45 98             	mov    %eax,-0x68(%ebp)

				// the remaining free space from the block that we use to allocate in it
				struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)block + totalSize);
  802589:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80258c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80258f:	01 d0                	add    %edx,%eax
  802591:	89 45 94             	mov    %eax,-0x6c(%ebp)
				set_block_data(remainingFreeBlock, remainingSize, 0);
  802594:	83 ec 04             	sub    $0x4,%esp
  802597:	6a 00                	push   $0x0
  802599:	ff 75 98             	pushl  -0x68(%ebp)
  80259c:	ff 75 94             	pushl  -0x6c(%ebp)
  80259f:	e8 14 fd ff ff       	call   8022b8 <set_block_data>
  8025a4:	83 c4 10             	add    $0x10,%esp
				// add it after the block we allocated to be sorted by addresses
				LIST_INSERT_AFTER(&freeBlocksList, block,remainingFreeBlock);
  8025a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ab:	74 06                	je     8025b3 <alloc_block_FF+0x111>
  8025ad:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
  8025b1:	75 17                	jne    8025ca <alloc_block_FF+0x128>
  8025b3:	83 ec 04             	sub    $0x4,%esp
  8025b6:	68 ec 3c 80 00       	push   $0x803cec
  8025bb:	68 de 00 00 00       	push   $0xde
  8025c0:	68 77 3c 80 00       	push   $0x803c77
  8025c5:	e8 b3 dc ff ff       	call   80027d <_panic>
  8025ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cd:	8b 10                	mov    (%eax),%edx
  8025cf:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8025d2:	89 10                	mov    %edx,(%eax)
  8025d4:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8025d7:	8b 00                	mov    (%eax),%eax
  8025d9:	85 c0                	test   %eax,%eax
  8025db:	74 0b                	je     8025e8 <alloc_block_FF+0x146>
  8025dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e0:	8b 00                	mov    (%eax),%eax
  8025e2:	8b 55 94             	mov    -0x6c(%ebp),%edx
  8025e5:	89 50 04             	mov    %edx,0x4(%eax)
  8025e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025eb:	8b 55 94             	mov    -0x6c(%ebp),%edx
  8025ee:	89 10                	mov    %edx,(%eax)
  8025f0:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8025f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025f6:	89 50 04             	mov    %edx,0x4(%eax)
  8025f9:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8025fc:	8b 00                	mov    (%eax),%eax
  8025fe:	85 c0                	test   %eax,%eax
  802600:	75 08                	jne    80260a <alloc_block_FF+0x168>
  802602:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802605:	a3 4c 40 98 00       	mov    %eax,0x98404c
  80260a:	a1 54 40 98 00       	mov    0x984054,%eax
  80260f:	40                   	inc    %eax
  802610:	a3 54 40 98 00       	mov    %eax,0x984054

				// update the allocated block and remove it from freeBlocksList
				set_block_data(block,totalSize,1);
  802615:	83 ec 04             	sub    $0x4,%esp
  802618:	6a 01                	push   $0x1
  80261a:	ff 75 dc             	pushl  -0x24(%ebp)
  80261d:	ff 75 f4             	pushl  -0xc(%ebp)
  802620:	e8 93 fc ff ff       	call   8022b8 <set_block_data>
  802625:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  802628:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80262c:	75 17                	jne    802645 <alloc_block_FF+0x1a3>
  80262e:	83 ec 04             	sub    $0x4,%esp
  802631:	68 20 3d 80 00       	push   $0x803d20
  802636:	68 e3 00 00 00       	push   $0xe3
  80263b:	68 77 3c 80 00       	push   $0x803c77
  802640:	e8 38 dc ff ff       	call   80027d <_panic>
  802645:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802648:	8b 00                	mov    (%eax),%eax
  80264a:	85 c0                	test   %eax,%eax
  80264c:	74 10                	je     80265e <alloc_block_FF+0x1bc>
  80264e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802651:	8b 00                	mov    (%eax),%eax
  802653:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802656:	8b 52 04             	mov    0x4(%edx),%edx
  802659:	89 50 04             	mov    %edx,0x4(%eax)
  80265c:	eb 0b                	jmp    802669 <alloc_block_FF+0x1c7>
  80265e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802661:	8b 40 04             	mov    0x4(%eax),%eax
  802664:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802669:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266c:	8b 40 04             	mov    0x4(%eax),%eax
  80266f:	85 c0                	test   %eax,%eax
  802671:	74 0f                	je     802682 <alloc_block_FF+0x1e0>
  802673:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802676:	8b 40 04             	mov    0x4(%eax),%eax
  802679:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80267c:	8b 12                	mov    (%edx),%edx
  80267e:	89 10                	mov    %edx,(%eax)
  802680:	eb 0a                	jmp    80268c <alloc_block_FF+0x1ea>
  802682:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802685:	8b 00                	mov    (%eax),%eax
  802687:	a3 48 40 98 00       	mov    %eax,0x984048
  80268c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802695:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802698:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80269f:	a1 54 40 98 00       	mov    0x984054,%eax
  8026a4:	48                   	dec    %eax
  8026a5:	a3 54 40 98 00       	mov    %eax,0x984054
				return (void*)((uint32*)block);
  8026aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ad:	e9 25 02 00 00       	jmp    8028d7 <alloc_block_FF+0x435>
			}
			else // if set internal fragmentation
			{
				// add the remaining size to the block we allocate so it will be the same main block size
				set_block_data(block,blockSize,1);
  8026b2:	83 ec 04             	sub    $0x4,%esp
  8026b5:	6a 01                	push   $0x1
  8026b7:	ff 75 9c             	pushl  -0x64(%ebp)
  8026ba:	ff 75 f4             	pushl  -0xc(%ebp)
  8026bd:	e8 f6 fb ff ff       	call   8022b8 <set_block_data>
  8026c2:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  8026c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026c9:	75 17                	jne    8026e2 <alloc_block_FF+0x240>
  8026cb:	83 ec 04             	sub    $0x4,%esp
  8026ce:	68 20 3d 80 00       	push   $0x803d20
  8026d3:	68 eb 00 00 00       	push   $0xeb
  8026d8:	68 77 3c 80 00       	push   $0x803c77
  8026dd:	e8 9b db ff ff       	call   80027d <_panic>
  8026e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e5:	8b 00                	mov    (%eax),%eax
  8026e7:	85 c0                	test   %eax,%eax
  8026e9:	74 10                	je     8026fb <alloc_block_FF+0x259>
  8026eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ee:	8b 00                	mov    (%eax),%eax
  8026f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026f3:	8b 52 04             	mov    0x4(%edx),%edx
  8026f6:	89 50 04             	mov    %edx,0x4(%eax)
  8026f9:	eb 0b                	jmp    802706 <alloc_block_FF+0x264>
  8026fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fe:	8b 40 04             	mov    0x4(%eax),%eax
  802701:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802706:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802709:	8b 40 04             	mov    0x4(%eax),%eax
  80270c:	85 c0                	test   %eax,%eax
  80270e:	74 0f                	je     80271f <alloc_block_FF+0x27d>
  802710:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802713:	8b 40 04             	mov    0x4(%eax),%eax
  802716:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802719:	8b 12                	mov    (%edx),%edx
  80271b:	89 10                	mov    %edx,(%eax)
  80271d:	eb 0a                	jmp    802729 <alloc_block_FF+0x287>
  80271f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802722:	8b 00                	mov    (%eax),%eax
  802724:	a3 48 40 98 00       	mov    %eax,0x984048
  802729:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802732:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802735:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80273c:	a1 54 40 98 00       	mov    0x984054,%eax
  802741:	48                   	dec    %eax
  802742:	a3 54 40 98 00       	mov    %eax,0x984054
				return (void*)((uint32*)block);
  802747:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274a:	e9 88 01 00 00       	jmp    8028d7 <alloc_block_FF+0x435>
		return NULL;
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  80274f:	a1 50 40 98 00       	mov    0x984050,%eax
  802754:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802757:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80275b:	74 07                	je     802764 <alloc_block_FF+0x2c2>
  80275d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802760:	8b 00                	mov    (%eax),%eax
  802762:	eb 05                	jmp    802769 <alloc_block_FF+0x2c7>
  802764:	b8 00 00 00 00       	mov    $0x0,%eax
  802769:	a3 50 40 98 00       	mov    %eax,0x984050
  80276e:	a1 50 40 98 00       	mov    0x984050,%eax
  802773:	85 c0                	test   %eax,%eax
  802775:	0f 85 d9 fd ff ff    	jne    802554 <alloc_block_FF+0xb2>
  80277b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80277f:	0f 85 cf fd ff ff    	jne    802554 <alloc_block_FF+0xb2>

//	uint32 *endBlock = &kheapBreak;

	// if we don't find any enough space to allocate the block

	void *oldBreak = sbrk(ROUNDUP(totalSize, PAGE_SIZE) / PAGE_SIZE);
  802785:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80278c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80278f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802792:	01 d0                	add    %edx,%eax
  802794:	48                   	dec    %eax
  802795:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802798:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80279b:	ba 00 00 00 00       	mov    $0x0,%edx
  8027a0:	f7 75 d8             	divl   -0x28(%ebp)
  8027a3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027a6:	29 d0                	sub    %edx,%eax
  8027a8:	c1 e8 0c             	shr    $0xc,%eax
  8027ab:	83 ec 0c             	sub    $0xc,%esp
  8027ae:	50                   	push   %eax
  8027af:	e8 20 eb ff ff       	call   8012d4 <sbrk>
  8027b4:	83 c4 10             	add    $0x10,%esp
  8027b7:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (oldBreak == (void*)-1) {
  8027ba:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8027be:	75 0a                	jne    8027ca <alloc_block_FF+0x328>
		return NULL;
  8027c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8027c5:	e9 0d 01 00 00       	jmp    8028d7 <alloc_block_FF+0x435>
	}
	//uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);

	uint32* endBlk = (uint32 *)((char *)oldBreak - 4);
  8027ca:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8027cd:	83 e8 04             	sub    $0x4,%eax
  8027d0:	89 45 cc             	mov    %eax,-0x34(%ebp)
	//endBlk = endBlk+(char *) ROUNDUP(totalSize, PAGE_SIZE);

	endBlk = endBlk + (ROUNDUP(totalSize, PAGE_SIZE) / sizeof(uint32));
  8027d3:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  8027da:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8027dd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8027e0:	01 d0                	add    %edx,%eax
  8027e2:	48                   	dec    %eax
  8027e3:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8027e6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8027e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8027ee:	f7 75 c8             	divl   -0x38(%ebp)
  8027f1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8027f4:	29 d0                	sub    %edx,%eax
  8027f6:	c1 e8 02             	shr    $0x2,%eax
  8027f9:	c1 e0 02             	shl    $0x2,%eax
  8027fc:	01 45 cc             	add    %eax,-0x34(%ebp)
	*endBlk = 0 | 1;
  8027ff:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802802:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	uint32 *footerLast = ((uint32*)oldBreak - 2);
  802808:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80280b:	83 e8 08             	sub    $0x8,%eax
  80280e:	89 45 c0             	mov    %eax,-0x40(%ebp)
	uint32 lastSize = (*footerLast) & ~(0x1);
  802811:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802814:	8b 00                	mov    (%eax),%eax
  802816:	83 e0 fe             	and    $0xfffffffe,%eax
  802819:	89 45 bc             	mov    %eax,-0x44(%ebp)
	// the last block for the block that we want to free it
	struct BlockElement *laskBlk = (struct BlockElement *)((char*)oldBreak - lastSize);
  80281c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80281f:	f7 d8                	neg    %eax
  802821:	89 c2                	mov    %eax,%edx
  802823:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802826:	01 d0                	add    %edx,%eax
  802828:	89 45 b8             	mov    %eax,-0x48(%ebp)
	uint32 isLastFree = is_free_block(laskBlk);
  80282b:	83 ec 0c             	sub    $0xc,%esp
  80282e:	ff 75 b8             	pushl  -0x48(%ebp)
  802831:	e8 1f f8 ff ff       	call   802055 <is_free_block>
  802836:	83 c4 10             	add    $0x10,%esp
  802839:	0f be c0             	movsbl %al,%eax
  80283c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(isLastFree)
  80283f:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  802843:	74 42                	je     802887 <alloc_block_FF+0x3e5>
	{
		// merge the block will be free with its prev block
		uint32 newBlkSize = lastSize + ROUNDUP(totalSize, PAGE_SIZE); // size of main block and its prev block
  802845:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  80284c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80284f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802852:	01 d0                	add    %edx,%eax
  802854:	48                   	dec    %eax
  802855:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802858:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80285b:	ba 00 00 00 00       	mov    $0x0,%edx
  802860:	f7 75 b0             	divl   -0x50(%ebp)
  802863:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802866:	29 d0                	sub    %edx,%eax
  802868:	89 c2                	mov    %eax,%edx
  80286a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80286d:	01 d0                	add    %edx,%eax
  80286f:	89 45 a8             	mov    %eax,-0x58(%ebp)
		// extends last block size to contain its size and the size of new space
		set_block_data(laskBlk,newBlkSize,0);
  802872:	83 ec 04             	sub    $0x4,%esp
  802875:	6a 00                	push   $0x0
  802877:	ff 75 a8             	pushl  -0x58(%ebp)
  80287a:	ff 75 b8             	pushl  -0x48(%ebp)
  80287d:	e8 36 fa ff ff       	call   8022b8 <set_block_data>
  802882:	83 c4 10             	add    $0x10,%esp
  802885:	eb 42                	jmp    8028c9 <alloc_block_FF+0x427>
	}
	else
	{
		set_block_data(oldBreak,ROUNDUP(totalSize, PAGE_SIZE),0);
  802887:	c7 45 a4 00 10 00 00 	movl   $0x1000,-0x5c(%ebp)
  80288e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802891:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802894:	01 d0                	add    %edx,%eax
  802896:	48                   	dec    %eax
  802897:	89 45 a0             	mov    %eax,-0x60(%ebp)
  80289a:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80289d:	ba 00 00 00 00       	mov    $0x0,%edx
  8028a2:	f7 75 a4             	divl   -0x5c(%ebp)
  8028a5:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8028a8:	29 d0                	sub    %edx,%eax
  8028aa:	83 ec 04             	sub    $0x4,%esp
  8028ad:	6a 00                	push   $0x0
  8028af:	50                   	push   %eax
  8028b0:	ff 75 d0             	pushl  -0x30(%ebp)
  8028b3:	e8 00 fa ff ff       	call   8022b8 <set_block_data>
  8028b8:	83 c4 10             	add    $0x10,%esp
		insert_sorted_in_freeList((struct BlockElement *)oldBreak);
  8028bb:	83 ec 0c             	sub    $0xc,%esp
  8028be:	ff 75 d0             	pushl  -0x30(%ebp)
  8028c1:	e8 49 fa ff ff       	call   80230f <insert_sorted_in_freeList>
  8028c6:	83 c4 10             	add    $0x10,%esp
//		LIST_INSERT_TAIL(&freeBlocksList,newBreak);
	}
//	set_block_data((struct BlockElement *)newBreak, totalSize, 1);
	return alloc_block_FF(size);
  8028c9:	83 ec 0c             	sub    $0xc,%esp
  8028cc:	ff 75 08             	pushl  0x8(%ebp)
  8028cf:	e8 ce fb ff ff       	call   8024a2 <alloc_block_FF>
  8028d4:	83 c4 10             	add    $0x10,%esp
}
  8028d7:	c9                   	leave  
  8028d8:	c3                   	ret    

008028d9 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8028d9:	55                   	push   %ebp
  8028da:	89 e5                	mov    %esp,%ebp
  8028dc:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS1 - BONUS] [3] DYNAMIC ALLOCATOR - alloc_block_BF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_BF is not implemented yet");
	//Your Code is Here...
	if(size == 0)
  8028df:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028e3:	75 0a                	jne    8028ef <alloc_block_BF+0x16>
	{
		return NULL;
  8028e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8028ea:	e9 7a 02 00 00       	jmp    802b69 <alloc_block_BF+0x290>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  8028ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f2:	83 c0 08             	add    $0x8,%eax
  8028f5:	89 45 e8             	mov    %eax,-0x18(%ebp)

	struct BlockElement *minBlk= NULL;
  8028f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 minSize = 0xfffffff; // a large number
  8028ff:	c7 45 f0 ff ff ff 0f 	movl   $0xfffffff,-0x10(%ebp)
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802906:	a1 48 40 98 00       	mov    0x984048,%eax
  80290b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80290e:	eb 32                	jmp    802942 <alloc_block_BF+0x69>
	{
		uint32 blockSize = get_block_size(block);
  802910:	ff 75 ec             	pushl  -0x14(%ebp)
  802913:	e8 24 f7 ff ff       	call   80203c <get_block_size>
  802918:	83 c4 04             	add    $0x4,%esp
  80291b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		// if this block can take the new block and its size < min size of all blocks
		if(blockSize >= totalSize && blockSize < minSize)
  80291e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802921:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802924:	72 14                	jb     80293a <alloc_block_BF+0x61>
  802926:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802929:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80292c:	73 0c                	jae    80293a <alloc_block_BF+0x61>
		{
			minBlk = block;
  80292e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802931:	89 45 f4             	mov    %eax,-0xc(%ebp)
			minSize = blockSize;
  802934:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802937:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *minBlk= NULL;
	uint32 minSize = 0xfffffff; // a large number
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  80293a:	a1 50 40 98 00       	mov    0x984050,%eax
  80293f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802942:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802946:	74 07                	je     80294f <alloc_block_BF+0x76>
  802948:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80294b:	8b 00                	mov    (%eax),%eax
  80294d:	eb 05                	jmp    802954 <alloc_block_BF+0x7b>
  80294f:	b8 00 00 00 00       	mov    $0x0,%eax
  802954:	a3 50 40 98 00       	mov    %eax,0x984050
  802959:	a1 50 40 98 00       	mov    0x984050,%eax
  80295e:	85 c0                	test   %eax,%eax
  802960:	75 ae                	jne    802910 <alloc_block_BF+0x37>
  802962:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802966:	75 a8                	jne    802910 <alloc_block_BF+0x37>
			minSize = blockSize;
		}
	}

	// if we don't find any enough space to allocate the block
	if(minBlk == NULL)
  802968:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80296c:	75 22                	jne    802990 <alloc_block_BF+0xb7>
	{
		void *newBlock = sbrk(totalSize);
  80296e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802971:	83 ec 0c             	sub    $0xc,%esp
  802974:	50                   	push   %eax
  802975:	e8 5a e9 ff ff       	call   8012d4 <sbrk>
  80297a:	83 c4 10             	add    $0x10,%esp
  80297d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (newBlock == (void*)-1) {
  802980:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  802984:	75 0a                	jne    802990 <alloc_block_BF+0xb7>
			return NULL;
  802986:	b8 00 00 00 00       	mov    $0x0,%eax
  80298b:	e9 d9 01 00 00       	jmp    802b69 <alloc_block_BF+0x290>
		}
	}

	//if we can put another block with min size 16
	if(minSize >= totalSize + 4*sizeof(uint32))
  802990:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802993:	83 c0 10             	add    $0x10,%eax
  802996:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802999:	0f 87 32 01 00 00    	ja     802ad1 <alloc_block_BF+0x1f8>
	{
		// the size that will remain from the block that we will allocate a new block in it
		uint32 remainingSize= minSize - totalSize;
  80299f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a2:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8029a5:	89 45 dc             	mov    %eax,-0x24(%ebp)

		// the remaining free space from the block that we use to allocate in it
		struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)minBlk + totalSize);
  8029a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029ae:	01 d0                	add    %edx,%eax
  8029b0:	89 45 d8             	mov    %eax,-0x28(%ebp)
		set_block_data(remainingFreeBlock, remainingSize, 0);
  8029b3:	83 ec 04             	sub    $0x4,%esp
  8029b6:	6a 00                	push   $0x0
  8029b8:	ff 75 dc             	pushl  -0x24(%ebp)
  8029bb:	ff 75 d8             	pushl  -0x28(%ebp)
  8029be:	e8 f5 f8 ff ff       	call   8022b8 <set_block_data>
  8029c3:	83 c4 10             	add    $0x10,%esp
		// add it after the block we allocated to be sorted by addresses
		LIST_INSERT_AFTER(&freeBlocksList, minBlk,remainingFreeBlock);
  8029c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029ca:	74 06                	je     8029d2 <alloc_block_BF+0xf9>
  8029cc:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8029d0:	75 17                	jne    8029e9 <alloc_block_BF+0x110>
  8029d2:	83 ec 04             	sub    $0x4,%esp
  8029d5:	68 ec 3c 80 00       	push   $0x803cec
  8029da:	68 49 01 00 00       	push   $0x149
  8029df:	68 77 3c 80 00       	push   $0x803c77
  8029e4:	e8 94 d8 ff ff       	call   80027d <_panic>
  8029e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ec:	8b 10                	mov    (%eax),%edx
  8029ee:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029f1:	89 10                	mov    %edx,(%eax)
  8029f3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029f6:	8b 00                	mov    (%eax),%eax
  8029f8:	85 c0                	test   %eax,%eax
  8029fa:	74 0b                	je     802a07 <alloc_block_BF+0x12e>
  8029fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ff:	8b 00                	mov    (%eax),%eax
  802a01:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802a04:	89 50 04             	mov    %edx,0x4(%eax)
  802a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802a0d:	89 10                	mov    %edx,(%eax)
  802a0f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a12:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a15:	89 50 04             	mov    %edx,0x4(%eax)
  802a18:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a1b:	8b 00                	mov    (%eax),%eax
  802a1d:	85 c0                	test   %eax,%eax
  802a1f:	75 08                	jne    802a29 <alloc_block_BF+0x150>
  802a21:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a24:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802a29:	a1 54 40 98 00       	mov    0x984054,%eax
  802a2e:	40                   	inc    %eax
  802a2f:	a3 54 40 98 00       	mov    %eax,0x984054

		// update the allocated block and remove it from freeBlocksList
		set_block_data(minBlk,totalSize,1);
  802a34:	83 ec 04             	sub    $0x4,%esp
  802a37:	6a 01                	push   $0x1
  802a39:	ff 75 e8             	pushl  -0x18(%ebp)
  802a3c:	ff 75 f4             	pushl  -0xc(%ebp)
  802a3f:	e8 74 f8 ff ff       	call   8022b8 <set_block_data>
  802a44:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  802a47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a4b:	75 17                	jne    802a64 <alloc_block_BF+0x18b>
  802a4d:	83 ec 04             	sub    $0x4,%esp
  802a50:	68 20 3d 80 00       	push   $0x803d20
  802a55:	68 4e 01 00 00       	push   $0x14e
  802a5a:	68 77 3c 80 00       	push   $0x803c77
  802a5f:	e8 19 d8 ff ff       	call   80027d <_panic>
  802a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a67:	8b 00                	mov    (%eax),%eax
  802a69:	85 c0                	test   %eax,%eax
  802a6b:	74 10                	je     802a7d <alloc_block_BF+0x1a4>
  802a6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a70:	8b 00                	mov    (%eax),%eax
  802a72:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a75:	8b 52 04             	mov    0x4(%edx),%edx
  802a78:	89 50 04             	mov    %edx,0x4(%eax)
  802a7b:	eb 0b                	jmp    802a88 <alloc_block_BF+0x1af>
  802a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a80:	8b 40 04             	mov    0x4(%eax),%eax
  802a83:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8b:	8b 40 04             	mov    0x4(%eax),%eax
  802a8e:	85 c0                	test   %eax,%eax
  802a90:	74 0f                	je     802aa1 <alloc_block_BF+0x1c8>
  802a92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a95:	8b 40 04             	mov    0x4(%eax),%eax
  802a98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a9b:	8b 12                	mov    (%edx),%edx
  802a9d:	89 10                	mov    %edx,(%eax)
  802a9f:	eb 0a                	jmp    802aab <alloc_block_BF+0x1d2>
  802aa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa4:	8b 00                	mov    (%eax),%eax
  802aa6:	a3 48 40 98 00       	mov    %eax,0x984048
  802aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802abe:	a1 54 40 98 00       	mov    0x984054,%eax
  802ac3:	48                   	dec    %eax
  802ac4:	a3 54 40 98 00       	mov    %eax,0x984054
		return (void*)((uint32*)minBlk);
  802ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acc:	e9 98 00 00 00       	jmp    802b69 <alloc_block_BF+0x290>
	}
	else // if set internal fragmentation
	{
		// add the remaining size to the block we allocate so it will be the same main block size
		set_block_data(minBlk,minSize,1);
  802ad1:	83 ec 04             	sub    $0x4,%esp
  802ad4:	6a 01                	push   $0x1
  802ad6:	ff 75 f0             	pushl  -0x10(%ebp)
  802ad9:	ff 75 f4             	pushl  -0xc(%ebp)
  802adc:	e8 d7 f7 ff ff       	call   8022b8 <set_block_data>
  802ae1:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  802ae4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ae8:	75 17                	jne    802b01 <alloc_block_BF+0x228>
  802aea:	83 ec 04             	sub    $0x4,%esp
  802aed:	68 20 3d 80 00       	push   $0x803d20
  802af2:	68 56 01 00 00       	push   $0x156
  802af7:	68 77 3c 80 00       	push   $0x803c77
  802afc:	e8 7c d7 ff ff       	call   80027d <_panic>
  802b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b04:	8b 00                	mov    (%eax),%eax
  802b06:	85 c0                	test   %eax,%eax
  802b08:	74 10                	je     802b1a <alloc_block_BF+0x241>
  802b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0d:	8b 00                	mov    (%eax),%eax
  802b0f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b12:	8b 52 04             	mov    0x4(%edx),%edx
  802b15:	89 50 04             	mov    %edx,0x4(%eax)
  802b18:	eb 0b                	jmp    802b25 <alloc_block_BF+0x24c>
  802b1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1d:	8b 40 04             	mov    0x4(%eax),%eax
  802b20:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802b25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b28:	8b 40 04             	mov    0x4(%eax),%eax
  802b2b:	85 c0                	test   %eax,%eax
  802b2d:	74 0f                	je     802b3e <alloc_block_BF+0x265>
  802b2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b32:	8b 40 04             	mov    0x4(%eax),%eax
  802b35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b38:	8b 12                	mov    (%edx),%edx
  802b3a:	89 10                	mov    %edx,(%eax)
  802b3c:	eb 0a                	jmp    802b48 <alloc_block_BF+0x26f>
  802b3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b41:	8b 00                	mov    (%eax),%eax
  802b43:	a3 48 40 98 00       	mov    %eax,0x984048
  802b48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b54:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b5b:	a1 54 40 98 00       	mov    0x984054,%eax
  802b60:	48                   	dec    %eax
  802b61:	a3 54 40 98 00       	mov    %eax,0x984054
		return (void*)((uint32*)minBlk);
  802b66:	8b 45 f4             	mov    -0xc(%ebp),%eax
	}
	return NULL;
}
  802b69:	c9                   	leave  
  802b6a:	c3                   	ret    

00802b6b <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802b6b:	55                   	push   %ebp
  802b6c:	89 e5                	mov    %esp,%ebp
  802b6e:	83 ec 48             	sub    $0x48,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
  802b71:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b75:	0f 84 6a 02 00 00    	je     802de5 <free_block+0x27a>
	{
		return;
	}

	uint32 freeSize = get_block_size(va);
  802b7b:	ff 75 08             	pushl  0x8(%ebp)
  802b7e:	e8 b9 f4 ff ff       	call   80203c <get_block_size>
  802b83:	83 c4 04             	add    $0x4,%esp
  802b86:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// footer for the prev block for the block that we want to free it
	uint32 *footerPrev = ((uint32*)va - 2 );
  802b89:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8c:	83 e8 08             	sub    $0x8,%eax
  802b8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 pSize = (*footerPrev) & ~(0x1);
  802b92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b95:	8b 00                	mov    (%eax),%eax
  802b97:	83 e0 fe             	and    $0xfffffffe,%eax
  802b9a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// the prev block for the block that we want to free it
	struct BlockElement * prevBlk = (struct BlockElement *)((char*)va - pSize);
  802b9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba0:	f7 d8                	neg    %eax
  802ba2:	89 c2                	mov    %eax,%edx
  802ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba7:	01 d0                	add    %edx,%eax
  802ba9:	89 45 e8             	mov    %eax,-0x18(%ebp)
	uint32 isPrevFree = is_free_block(prevBlk);
  802bac:	ff 75 e8             	pushl  -0x18(%ebp)
  802baf:	e8 a1 f4 ff ff       	call   802055 <is_free_block>
  802bb4:	83 c4 04             	add    $0x4,%esp
  802bb7:	0f be c0             	movsbl %al,%eax
  802bba:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
  802bbd:	8b 55 08             	mov    0x8(%ebp),%edx
  802bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc3:	01 d0                	add    %edx,%eax
  802bc5:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  802bc8:	ff 75 e0             	pushl  -0x20(%ebp)
  802bcb:	e8 85 f4 ff ff       	call   802055 <is_free_block>
  802bd0:	83 c4 04             	add    $0x4,%esp
  802bd3:	0f be c0             	movsbl %al,%eax
  802bd6:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if(isPrevFree == 1 && isNextFree == 0)
  802bd9:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  802bdd:	75 34                	jne    802c13 <free_block+0xa8>
  802bdf:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802be3:	75 2e                	jne    802c13 <free_block+0xa8>
	{
		// merge the block will be free with its prev block
		uint32 prevSize = get_block_size(prevBlk);
  802be5:	ff 75 e8             	pushl  -0x18(%ebp)
  802be8:	e8 4f f4 ff ff       	call   80203c <get_block_size>
  802bed:	83 c4 04             	add    $0x4,%esp
  802bf0:	89 45 d8             	mov    %eax,-0x28(%ebp)
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
  802bf3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bf6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802bf9:	01 d0                	add    %edx,%eax
  802bfb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
  802bfe:	6a 00                	push   $0x0
  802c00:	ff 75 d4             	pushl  -0x2c(%ebp)
  802c03:	ff 75 e8             	pushl  -0x18(%ebp)
  802c06:	e8 ad f6 ff ff       	call   8022b8 <set_block_data>
  802c0b:	83 c4 0c             	add    $0xc,%esp
	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
	uint32 isNextFree = is_free_block(nextBlk);

	if(isPrevFree == 1 && isNextFree == 0)
	{
  802c0e:	e9 d3 01 00 00       	jmp    802de6 <free_block+0x27b>
		uint32 prevSize = get_block_size(prevBlk);
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
  802c13:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  802c17:	0f 85 c8 00 00 00    	jne    802ce5 <free_block+0x17a>
  802c1d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802c21:	0f 85 be 00 00 00    	jne    802ce5 <free_block+0x17a>
	{
		// merge the block will be free with its next block
		uint32 nextSize = get_block_size(nextBlk);
  802c27:	ff 75 e0             	pushl  -0x20(%ebp)
  802c2a:	e8 0d f4 ff ff       	call   80203c <get_block_size>
  802c2f:	83 c4 04             	add    $0x4,%esp
  802c32:	89 45 d0             	mov    %eax,-0x30(%ebp)
		uint32 totalSize = freeSize + nextSize; // size of main block and its next block
  802c35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c38:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802c3b:	01 d0                	add    %edx,%eax
  802c3d:	89 45 cc             	mov    %eax,-0x34(%ebp)
		// update the size of block to contain its size and the size of next block
		set_block_data(va,totalSize,0);
  802c40:	6a 00                	push   $0x0
  802c42:	ff 75 cc             	pushl  -0x34(%ebp)
  802c45:	ff 75 08             	pushl  0x8(%ebp)
  802c48:	e8 6b f6 ff ff       	call   8022b8 <set_block_data>
  802c4d:	83 c4 0c             	add    $0xc,%esp
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
  802c50:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802c54:	75 17                	jne    802c6d <free_block+0x102>
  802c56:	83 ec 04             	sub    $0x4,%esp
  802c59:	68 20 3d 80 00       	push   $0x803d20
  802c5e:	68 87 01 00 00       	push   $0x187
  802c63:	68 77 3c 80 00       	push   $0x803c77
  802c68:	e8 10 d6 ff ff       	call   80027d <_panic>
  802c6d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c70:	8b 00                	mov    (%eax),%eax
  802c72:	85 c0                	test   %eax,%eax
  802c74:	74 10                	je     802c86 <free_block+0x11b>
  802c76:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c79:	8b 00                	mov    (%eax),%eax
  802c7b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c7e:	8b 52 04             	mov    0x4(%edx),%edx
  802c81:	89 50 04             	mov    %edx,0x4(%eax)
  802c84:	eb 0b                	jmp    802c91 <free_block+0x126>
  802c86:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c89:	8b 40 04             	mov    0x4(%eax),%eax
  802c8c:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802c91:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c94:	8b 40 04             	mov    0x4(%eax),%eax
  802c97:	85 c0                	test   %eax,%eax
  802c99:	74 0f                	je     802caa <free_block+0x13f>
  802c9b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c9e:	8b 40 04             	mov    0x4(%eax),%eax
  802ca1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ca4:	8b 12                	mov    (%edx),%edx
  802ca6:	89 10                	mov    %edx,(%eax)
  802ca8:	eb 0a                	jmp    802cb4 <free_block+0x149>
  802caa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cad:	8b 00                	mov    (%eax),%eax
  802caf:	a3 48 40 98 00       	mov    %eax,0x984048
  802cb4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cb7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cbd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cc0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cc7:	a1 54 40 98 00       	mov    0x984054,%eax
  802ccc:	48                   	dec    %eax
  802ccd:	a3 54 40 98 00       	mov    %eax,0x984054
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  802cd2:	83 ec 0c             	sub    $0xc,%esp
  802cd5:	ff 75 08             	pushl  0x8(%ebp)
  802cd8:	e8 32 f6 ff ff       	call   80230f <insert_sorted_in_freeList>
  802cdd:	83 c4 10             	add    $0x10,%esp
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
	{
  802ce0:	e9 01 01 00 00       	jmp    802de6 <free_block+0x27b>
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
  802ce5:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  802ce9:	0f 85 d3 00 00 00    	jne    802dc2 <free_block+0x257>
  802cef:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  802cf3:	0f 85 c9 00 00 00    	jne    802dc2 <free_block+0x257>
	{
		// merge the block will be free with its prev and next blocks
		uint32 prevSize = get_block_size(prevBlk);
  802cf9:	83 ec 0c             	sub    $0xc,%esp
  802cfc:	ff 75 e8             	pushl  -0x18(%ebp)
  802cff:	e8 38 f3 ff ff       	call   80203c <get_block_size>
  802d04:	83 c4 10             	add    $0x10,%esp
  802d07:	89 45 c8             	mov    %eax,-0x38(%ebp)
		uint32 nextSize = get_block_size(nextBlk);
  802d0a:	83 ec 0c             	sub    $0xc,%esp
  802d0d:	ff 75 e0             	pushl  -0x20(%ebp)
  802d10:	e8 27 f3 ff ff       	call   80203c <get_block_size>
  802d15:	83 c4 10             	add    $0x10,%esp
  802d18:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 totalSize = freeSize + prevSize + nextSize; // size of main block and its prev and next blocks
  802d1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d1e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802d21:	01 c2                	add    %eax,%edx
  802d23:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802d26:	01 d0                	add    %edx,%eax
  802d28:	89 45 c0             	mov    %eax,-0x40(%ebp)
		// extends prev block size to contain its size and the size of main and next blocks
		set_block_data(prevBlk,totalSize,0);
  802d2b:	83 ec 04             	sub    $0x4,%esp
  802d2e:	6a 00                	push   $0x0
  802d30:	ff 75 c0             	pushl  -0x40(%ebp)
  802d33:	ff 75 e8             	pushl  -0x18(%ebp)
  802d36:	e8 7d f5 ff ff       	call   8022b8 <set_block_data>
  802d3b:	83 c4 10             	add    $0x10,%esp
		// remove next block because we merge it with its prev blocks
		LIST_REMOVE(&freeBlocksList, nextBlk);
  802d3e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802d42:	75 17                	jne    802d5b <free_block+0x1f0>
  802d44:	83 ec 04             	sub    $0x4,%esp
  802d47:	68 20 3d 80 00       	push   $0x803d20
  802d4c:	68 94 01 00 00       	push   $0x194
  802d51:	68 77 3c 80 00       	push   $0x803c77
  802d56:	e8 22 d5 ff ff       	call   80027d <_panic>
  802d5b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d5e:	8b 00                	mov    (%eax),%eax
  802d60:	85 c0                	test   %eax,%eax
  802d62:	74 10                	je     802d74 <free_block+0x209>
  802d64:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d67:	8b 00                	mov    (%eax),%eax
  802d69:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d6c:	8b 52 04             	mov    0x4(%edx),%edx
  802d6f:	89 50 04             	mov    %edx,0x4(%eax)
  802d72:	eb 0b                	jmp    802d7f <free_block+0x214>
  802d74:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d77:	8b 40 04             	mov    0x4(%eax),%eax
  802d7a:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802d7f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d82:	8b 40 04             	mov    0x4(%eax),%eax
  802d85:	85 c0                	test   %eax,%eax
  802d87:	74 0f                	je     802d98 <free_block+0x22d>
  802d89:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d8c:	8b 40 04             	mov    0x4(%eax),%eax
  802d8f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d92:	8b 12                	mov    (%edx),%edx
  802d94:	89 10                	mov    %edx,(%eax)
  802d96:	eb 0a                	jmp    802da2 <free_block+0x237>
  802d98:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d9b:	8b 00                	mov    (%eax),%eax
  802d9d:	a3 48 40 98 00       	mov    %eax,0x984048
  802da2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802da5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802db5:	a1 54 40 98 00       	mov    0x984054,%eax
  802dba:	48                   	dec    %eax
  802dbb:	a3 54 40 98 00       	mov    %eax,0x984054
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
	{
  802dc0:	eb 24                	jmp    802de6 <free_block+0x27b>
	}
	else
	{
		// free it without any merge
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
  802dc2:	83 ec 04             	sub    $0x4,%esp
  802dc5:	6a 00                	push   $0x0
  802dc7:	ff 75 f4             	pushl  -0xc(%ebp)
  802dca:	ff 75 08             	pushl  0x8(%ebp)
  802dcd:	e8 e6 f4 ff ff       	call   8022b8 <set_block_data>
  802dd2:	83 c4 10             	add    $0x10,%esp
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  802dd5:	83 ec 0c             	sub    $0xc,%esp
  802dd8:	ff 75 08             	pushl  0x8(%ebp)
  802ddb:	e8 2f f5 ff ff       	call   80230f <insert_sorted_in_freeList>
  802de0:	83 c4 10             	add    $0x10,%esp
  802de3:	eb 01                	jmp    802de6 <free_block+0x27b>
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
	{
		return;
  802de5:	90                   	nop
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
}
  802de6:	c9                   	leave  
  802de7:	c3                   	ret    

00802de8 <realloc_block_FF>:
//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
  802de8:	55                   	push   %ebp
  802de9:	89 e5                	mov    %esp,%ebp
  802deb:	83 ec 38             	sub    $0x38,%esp
	//TODO: [PROJECT'24.MS1 - #08] [3] DYNAMIC ALLOCATOR - realloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(va == NULL && new_size == 0)
  802dee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802df2:	75 10                	jne    802e04 <realloc_block_FF+0x1c>
  802df4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802df8:	75 0a                	jne    802e04 <realloc_block_FF+0x1c>
	{
		return NULL;
  802dfa:	b8 00 00 00 00       	mov    $0x0,%eax
  802dff:	e9 8b 04 00 00       	jmp    80328f <realloc_block_FF+0x4a7>
	}

	if(new_size == 0)
  802e04:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e08:	75 18                	jne    802e22 <realloc_block_FF+0x3a>
	{
		free_block(va);
  802e0a:	83 ec 0c             	sub    $0xc,%esp
  802e0d:	ff 75 08             	pushl  0x8(%ebp)
  802e10:	e8 56 fd ff ff       	call   802b6b <free_block>
  802e15:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802e18:	b8 00 00 00 00       	mov    $0x0,%eax
  802e1d:	e9 6d 04 00 00       	jmp    80328f <realloc_block_FF+0x4a7>
	}

	if(va == NULL)
  802e22:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e26:	75 13                	jne    802e3b <realloc_block_FF+0x53>
	{
		return alloc_block_FF(new_size);
  802e28:	83 ec 0c             	sub    $0xc,%esp
  802e2b:	ff 75 0c             	pushl  0xc(%ebp)
  802e2e:	e8 6f f6 ff ff       	call   8024a2 <alloc_block_FF>
  802e33:	83 c4 10             	add    $0x10,%esp
  802e36:	e9 54 04 00 00       	jmp    80328f <realloc_block_FF+0x4a7>
	}

	// if size is odd must be increment it by one
	if (new_size % 2 != 0)
  802e3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e3e:	83 e0 01             	and    $0x1,%eax
  802e41:	85 c0                	test   %eax,%eax
  802e43:	74 03                	je     802e48 <realloc_block_FF+0x60>
	{
		new_size++;
  802e45:	ff 45 0c             	incl   0xc(%ebp)
	}

	// if size < 8 must be equal it to 8 because min size 8 excluding metadata
	if(new_size < 8)
  802e48:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  802e4c:	77 07                	ja     802e55 <realloc_block_FF+0x6d>
	{
		new_size = 8;
  802e4e:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	}

	new_size += 8; // adds its footer and header size
  802e55:	83 45 0c 08          	addl   $0x8,0xc(%ebp)

	uint32 actualSize = get_block_size(va);
  802e59:	83 ec 0c             	sub    $0xc,%esp
  802e5c:	ff 75 08             	pushl  0x8(%ebp)
  802e5f:	e8 d8 f1 ff ff       	call   80203c <get_block_size>
  802e64:	83 c4 10             	add    $0x10,%esp
  802e67:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(actualSize == new_size)
  802e6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802e70:	75 08                	jne    802e7a <realloc_block_FF+0x92>
	{
		// don't change any thing
		return va;
  802e72:	8b 45 08             	mov    0x8(%ebp),%eax
  802e75:	e9 15 04 00 00       	jmp    80328f <realloc_block_FF+0x4a7>
	}

	// next block for the block we want to change its size
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + actualSize);
  802e7a:	8b 55 08             	mov    0x8(%ebp),%edx
  802e7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e80:	01 d0                	add    %edx,%eax
  802e82:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  802e85:	83 ec 0c             	sub    $0xc,%esp
  802e88:	ff 75 f0             	pushl  -0x10(%ebp)
  802e8b:	e8 c5 f1 ff ff       	call   802055 <is_free_block>
  802e90:	83 c4 10             	add    $0x10,%esp
  802e93:	0f be c0             	movsbl %al,%eax
  802e96:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 nextSize = get_block_size(nextBlk);
  802e99:	83 ec 0c             	sub    $0xc,%esp
  802e9c:	ff 75 f0             	pushl  -0x10(%ebp)
  802e9f:	e8 98 f1 ff ff       	call   80203c <get_block_size>
  802ea4:	83 c4 10             	add    $0x10,%esp
  802ea7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// increase the size of block
	if(new_size > actualSize)
  802eaa:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ead:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802eb0:	0f 86 a7 02 00 00    	jbe    80315d <realloc_block_FF+0x375>
	{
		if(isNextFree)
  802eb6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802eba:	0f 84 86 02 00 00    	je     803146 <realloc_block_FF+0x35e>
		{
			if(nextSize + actualSize == new_size) // block and nextblock = newSizeBlock
  802ec0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ec3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec6:	01 d0                	add    %edx,%eax
  802ec8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802ecb:	0f 85 b2 00 00 00    	jne    802f83 <realloc_block_FF+0x19b>
			{
				set_block_data(va,new_size,!(is_free_block(va)));// update size in block
  802ed1:	83 ec 0c             	sub    $0xc,%esp
  802ed4:	ff 75 08             	pushl  0x8(%ebp)
  802ed7:	e8 79 f1 ff ff       	call   802055 <is_free_block>
  802edc:	83 c4 10             	add    $0x10,%esp
  802edf:	84 c0                	test   %al,%al
  802ee1:	0f 94 c0             	sete   %al
  802ee4:	0f b6 c0             	movzbl %al,%eax
  802ee7:	83 ec 04             	sub    $0x4,%esp
  802eea:	50                   	push   %eax
  802eeb:	ff 75 0c             	pushl  0xc(%ebp)
  802eee:	ff 75 08             	pushl  0x8(%ebp)
  802ef1:	e8 c2 f3 ff ff       	call   8022b8 <set_block_data>
  802ef6:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);// remove next because it is = zero
  802ef9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802efd:	75 17                	jne    802f16 <realloc_block_FF+0x12e>
  802eff:	83 ec 04             	sub    $0x4,%esp
  802f02:	68 20 3d 80 00       	push   $0x803d20
  802f07:	68 db 01 00 00       	push   $0x1db
  802f0c:	68 77 3c 80 00       	push   $0x803c77
  802f11:	e8 67 d3 ff ff       	call   80027d <_panic>
  802f16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f19:	8b 00                	mov    (%eax),%eax
  802f1b:	85 c0                	test   %eax,%eax
  802f1d:	74 10                	je     802f2f <realloc_block_FF+0x147>
  802f1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f22:	8b 00                	mov    (%eax),%eax
  802f24:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f27:	8b 52 04             	mov    0x4(%edx),%edx
  802f2a:	89 50 04             	mov    %edx,0x4(%eax)
  802f2d:	eb 0b                	jmp    802f3a <realloc_block_FF+0x152>
  802f2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f32:	8b 40 04             	mov    0x4(%eax),%eax
  802f35:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802f3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f3d:	8b 40 04             	mov    0x4(%eax),%eax
  802f40:	85 c0                	test   %eax,%eax
  802f42:	74 0f                	je     802f53 <realloc_block_FF+0x16b>
  802f44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f47:	8b 40 04             	mov    0x4(%eax),%eax
  802f4a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f4d:	8b 12                	mov    (%edx),%edx
  802f4f:	89 10                	mov    %edx,(%eax)
  802f51:	eb 0a                	jmp    802f5d <realloc_block_FF+0x175>
  802f53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f56:	8b 00                	mov    (%eax),%eax
  802f58:	a3 48 40 98 00       	mov    %eax,0x984048
  802f5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f60:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f69:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f70:	a1 54 40 98 00       	mov    0x984054,%eax
  802f75:	48                   	dec    %eax
  802f76:	a3 54 40 98 00       	mov    %eax,0x984054
				return va;
  802f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7e:	e9 0c 03 00 00       	jmp    80328f <realloc_block_FF+0x4a7>
			}
			else if(nextSize + actualSize > new_size) // new size is less than next and main blocks
  802f83:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f89:	01 d0                	add    %edx,%eax
  802f8b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802f8e:	0f 86 b2 01 00 00    	jbe    803146 <realloc_block_FF+0x35e>
			{
				uint32 requiredSize = new_size - actualSize; // size that we need from the next block
  802f94:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f97:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802f9a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				uint32 remainingNext = nextSize - requiredSize; // size that will remain from the next block after we split it
  802f9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fa0:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802fa3:	89 45 e0             	mov    %eax,-0x20(%ebp)

				// if next size will not fit another block (internal fragmentation)
				if(remainingNext < 16)
  802fa6:	83 7d e0 0f          	cmpl   $0xf,-0x20(%ebp)
  802faa:	0f 87 b8 00 00 00    	ja     803068 <realloc_block_FF+0x280>
				{
					// we will take the main size of the block and its next size also
					set_block_data(va,actualSize + nextSize,!(is_free_block(va)));
  802fb0:	83 ec 0c             	sub    $0xc,%esp
  802fb3:	ff 75 08             	pushl  0x8(%ebp)
  802fb6:	e8 9a f0 ff ff       	call   802055 <is_free_block>
  802fbb:	83 c4 10             	add    $0x10,%esp
  802fbe:	84 c0                	test   %al,%al
  802fc0:	0f 94 c0             	sete   %al
  802fc3:	0f b6 c0             	movzbl %al,%eax
  802fc6:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802fc9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fcc:	01 ca                	add    %ecx,%edx
  802fce:	83 ec 04             	sub    $0x4,%esp
  802fd1:	50                   	push   %eax
  802fd2:	52                   	push   %edx
  802fd3:	ff 75 08             	pushl  0x8(%ebp)
  802fd6:	e8 dd f2 ff ff       	call   8022b8 <set_block_data>
  802fdb:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,nextBlk);
  802fde:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fe2:	75 17                	jne    802ffb <realloc_block_FF+0x213>
  802fe4:	83 ec 04             	sub    $0x4,%esp
  802fe7:	68 20 3d 80 00       	push   $0x803d20
  802fec:	68 e8 01 00 00       	push   $0x1e8
  802ff1:	68 77 3c 80 00       	push   $0x803c77
  802ff6:	e8 82 d2 ff ff       	call   80027d <_panic>
  802ffb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ffe:	8b 00                	mov    (%eax),%eax
  803000:	85 c0                	test   %eax,%eax
  803002:	74 10                	je     803014 <realloc_block_FF+0x22c>
  803004:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803007:	8b 00                	mov    (%eax),%eax
  803009:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80300c:	8b 52 04             	mov    0x4(%edx),%edx
  80300f:	89 50 04             	mov    %edx,0x4(%eax)
  803012:	eb 0b                	jmp    80301f <realloc_block_FF+0x237>
  803014:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803017:	8b 40 04             	mov    0x4(%eax),%eax
  80301a:	a3 4c 40 98 00       	mov    %eax,0x98404c
  80301f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803022:	8b 40 04             	mov    0x4(%eax),%eax
  803025:	85 c0                	test   %eax,%eax
  803027:	74 0f                	je     803038 <realloc_block_FF+0x250>
  803029:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80302c:	8b 40 04             	mov    0x4(%eax),%eax
  80302f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803032:	8b 12                	mov    (%edx),%edx
  803034:	89 10                	mov    %edx,(%eax)
  803036:	eb 0a                	jmp    803042 <realloc_block_FF+0x25a>
  803038:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80303b:	8b 00                	mov    (%eax),%eax
  80303d:	a3 48 40 98 00       	mov    %eax,0x984048
  803042:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803045:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80304b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80304e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803055:	a1 54 40 98 00       	mov    0x984054,%eax
  80305a:	48                   	dec    %eax
  80305b:	a3 54 40 98 00       	mov    %eax,0x984054
					return va;
  803060:	8b 45 08             	mov    0x8(%ebp),%eax
  803063:	e9 27 02 00 00       	jmp    80328f <realloc_block_FF+0x4a7>
				}
				else // if next size can be fit another block (split)
				{
					LIST_REMOVE(&freeBlocksList,nextBlk);
  803068:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80306c:	75 17                	jne    803085 <realloc_block_FF+0x29d>
  80306e:	83 ec 04             	sub    $0x4,%esp
  803071:	68 20 3d 80 00       	push   $0x803d20
  803076:	68 ed 01 00 00       	push   $0x1ed
  80307b:	68 77 3c 80 00       	push   $0x803c77
  803080:	e8 f8 d1 ff ff       	call   80027d <_panic>
  803085:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803088:	8b 00                	mov    (%eax),%eax
  80308a:	85 c0                	test   %eax,%eax
  80308c:	74 10                	je     80309e <realloc_block_FF+0x2b6>
  80308e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803091:	8b 00                	mov    (%eax),%eax
  803093:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803096:	8b 52 04             	mov    0x4(%edx),%edx
  803099:	89 50 04             	mov    %edx,0x4(%eax)
  80309c:	eb 0b                	jmp    8030a9 <realloc_block_FF+0x2c1>
  80309e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030a1:	8b 40 04             	mov    0x4(%eax),%eax
  8030a4:	a3 4c 40 98 00       	mov    %eax,0x98404c
  8030a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ac:	8b 40 04             	mov    0x4(%eax),%eax
  8030af:	85 c0                	test   %eax,%eax
  8030b1:	74 0f                	je     8030c2 <realloc_block_FF+0x2da>
  8030b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030b6:	8b 40 04             	mov    0x4(%eax),%eax
  8030b9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030bc:	8b 12                	mov    (%edx),%edx
  8030be:	89 10                	mov    %edx,(%eax)
  8030c0:	eb 0a                	jmp    8030cc <realloc_block_FF+0x2e4>
  8030c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030c5:	8b 00                	mov    (%eax),%eax
  8030c7:	a3 48 40 98 00       	mov    %eax,0x984048
  8030cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030d8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030df:	a1 54 40 98 00       	mov    0x984054,%eax
  8030e4:	48                   	dec    %eax
  8030e5:	a3 54 40 98 00       	mov    %eax,0x984054
					nextBlk = (struct BlockElement *)((char *)va + new_size); //update nextBlk address
  8030ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8030ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030f0:	01 d0                	add    %edx,%eax
  8030f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
					set_block_data(nextBlk,remainingNext,0); // update nextBlkSize
  8030f5:	83 ec 04             	sub    $0x4,%esp
  8030f8:	6a 00                	push   $0x0
  8030fa:	ff 75 e0             	pushl  -0x20(%ebp)
  8030fd:	ff 75 f0             	pushl  -0x10(%ebp)
  803100:	e8 b3 f1 ff ff       	call   8022b8 <set_block_data>
  803105:	83 c4 10             	add    $0x10,%esp
					set_block_data(va,new_size,!(is_free_block(va))); // update size of newblock
  803108:	83 ec 0c             	sub    $0xc,%esp
  80310b:	ff 75 08             	pushl  0x8(%ebp)
  80310e:	e8 42 ef ff ff       	call   802055 <is_free_block>
  803113:	83 c4 10             	add    $0x10,%esp
  803116:	84 c0                	test   %al,%al
  803118:	0f 94 c0             	sete   %al
  80311b:	0f b6 c0             	movzbl %al,%eax
  80311e:	83 ec 04             	sub    $0x4,%esp
  803121:	50                   	push   %eax
  803122:	ff 75 0c             	pushl  0xc(%ebp)
  803125:	ff 75 08             	pushl  0x8(%ebp)
  803128:	e8 8b f1 ff ff       	call   8022b8 <set_block_data>
  80312d:	83 c4 10             	add    $0x10,%esp
					insert_sorted_in_freeList(nextBlk);
  803130:	83 ec 0c             	sub    $0xc,%esp
  803133:	ff 75 f0             	pushl  -0x10(%ebp)
  803136:	e8 d4 f1 ff ff       	call   80230f <insert_sorted_in_freeList>
  80313b:	83 c4 10             	add    $0x10,%esp
					return va;
  80313e:	8b 45 08             	mov    0x8(%ebp),%eax
  803141:	e9 49 01 00 00       	jmp    80328f <realloc_block_FF+0x4a7>
				}
			}
		}
		// if next block isn't free or not fit the new size
		return alloc_block_FF(new_size - 8);
  803146:	8b 45 0c             	mov    0xc(%ebp),%eax
  803149:	83 e8 08             	sub    $0x8,%eax
  80314c:	83 ec 0c             	sub    $0xc,%esp
  80314f:	50                   	push   %eax
  803150:	e8 4d f3 ff ff       	call   8024a2 <alloc_block_FF>
  803155:	83 c4 10             	add    $0x10,%esp
  803158:	e9 32 01 00 00       	jmp    80328f <realloc_block_FF+0x4a7>
	}
	else if(new_size < actualSize) // to shrink block
  80315d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803160:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803163:	0f 83 21 01 00 00    	jae    80328a <realloc_block_FF+0x4a2>
	{
		uint32 remainingSize = actualSize - new_size; // size that will remain from the main block after we shrink it
  803169:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316c:	2b 45 0c             	sub    0xc(%ebp),%eax
  80316f:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(remainingSize < 16 && isNextFree == 0) // internal fragmentation
  803172:	83 7d dc 0f          	cmpl   $0xf,-0x24(%ebp)
  803176:	77 0e                	ja     803186 <realloc_block_FF+0x39e>
  803178:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80317c:	75 08                	jne    803186 <realloc_block_FF+0x39e>
		{
			// don't change its size
			return va;
  80317e:	8b 45 08             	mov    0x8(%ebp),%eax
  803181:	e9 09 01 00 00       	jmp    80328f <realloc_block_FF+0x4a7>
		}
		else // remainingSize fit in a new block
		{
			struct BlockElement *mainBlk = (struct BlockElement *)va;
  803186:	8b 45 08             	mov    0x8(%ebp),%eax
  803189:	89 45 d8             	mov    %eax,-0x28(%ebp)
			// update main block with new size
			set_block_data(mainBlk,new_size,!(is_free_block(va)));
  80318c:	83 ec 0c             	sub    $0xc,%esp
  80318f:	ff 75 08             	pushl  0x8(%ebp)
  803192:	e8 be ee ff ff       	call   802055 <is_free_block>
  803197:	83 c4 10             	add    $0x10,%esp
  80319a:	84 c0                	test   %al,%al
  80319c:	0f 94 c0             	sete   %al
  80319f:	0f b6 c0             	movzbl %al,%eax
  8031a2:	83 ec 04             	sub    $0x4,%esp
  8031a5:	50                   	push   %eax
  8031a6:	ff 75 0c             	pushl  0xc(%ebp)
  8031a9:	ff 75 d8             	pushl  -0x28(%ebp)
  8031ac:	e8 07 f1 ff ff       	call   8022b8 <set_block_data>
  8031b1:	83 c4 10             	add    $0x10,%esp

			// the blk with remaining size
			struct BlockElement *remainingBlk=(struct BlockElement *)((char*)mainBlk + new_size);
  8031b4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8031b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031ba:	01 d0                	add    %edx,%eax
  8031bc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			set_block_data(remainingBlk,remainingSize,0);
  8031bf:	83 ec 04             	sub    $0x4,%esp
  8031c2:	6a 00                	push   $0x0
  8031c4:	ff 75 dc             	pushl  -0x24(%ebp)
  8031c7:	ff 75 d4             	pushl  -0x2c(%ebp)
  8031ca:	e8 e9 f0 ff ff       	call   8022b8 <set_block_data>
  8031cf:	83 c4 10             	add    $0x10,%esp

			if(isNextFree)
  8031d2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8031d6:	0f 84 9b 00 00 00    	je     803277 <realloc_block_FF+0x48f>
			{
				// merge splited block with its next block
				set_block_data(remainingBlk,(remainingSize + nextSize),0);//merge remaining with its next block
  8031dc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e2:	01 d0                	add    %edx,%eax
  8031e4:	83 ec 04             	sub    $0x4,%esp
  8031e7:	6a 00                	push   $0x0
  8031e9:	50                   	push   %eax
  8031ea:	ff 75 d4             	pushl  -0x2c(%ebp)
  8031ed:	e8 c6 f0 ff ff       	call   8022b8 <set_block_data>
  8031f2:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);
  8031f5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031f9:	75 17                	jne    803212 <realloc_block_FF+0x42a>
  8031fb:	83 ec 04             	sub    $0x4,%esp
  8031fe:	68 20 3d 80 00       	push   $0x803d20
  803203:	68 10 02 00 00       	push   $0x210
  803208:	68 77 3c 80 00       	push   $0x803c77
  80320d:	e8 6b d0 ff ff       	call   80027d <_panic>
  803212:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803215:	8b 00                	mov    (%eax),%eax
  803217:	85 c0                	test   %eax,%eax
  803219:	74 10                	je     80322b <realloc_block_FF+0x443>
  80321b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80321e:	8b 00                	mov    (%eax),%eax
  803220:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803223:	8b 52 04             	mov    0x4(%edx),%edx
  803226:	89 50 04             	mov    %edx,0x4(%eax)
  803229:	eb 0b                	jmp    803236 <realloc_block_FF+0x44e>
  80322b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80322e:	8b 40 04             	mov    0x4(%eax),%eax
  803231:	a3 4c 40 98 00       	mov    %eax,0x98404c
  803236:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803239:	8b 40 04             	mov    0x4(%eax),%eax
  80323c:	85 c0                	test   %eax,%eax
  80323e:	74 0f                	je     80324f <realloc_block_FF+0x467>
  803240:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803243:	8b 40 04             	mov    0x4(%eax),%eax
  803246:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803249:	8b 12                	mov    (%edx),%edx
  80324b:	89 10                	mov    %edx,(%eax)
  80324d:	eb 0a                	jmp    803259 <realloc_block_FF+0x471>
  80324f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803252:	8b 00                	mov    (%eax),%eax
  803254:	a3 48 40 98 00       	mov    %eax,0x984048
  803259:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80325c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803262:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803265:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80326c:	a1 54 40 98 00       	mov    0x984054,%eax
  803271:	48                   	dec    %eax
  803272:	a3 54 40 98 00       	mov    %eax,0x984054
			}
			insert_sorted_in_freeList(remainingBlk);
  803277:	83 ec 0c             	sub    $0xc,%esp
  80327a:	ff 75 d4             	pushl  -0x2c(%ebp)
  80327d:	e8 8d f0 ff ff       	call   80230f <insert_sorted_in_freeList>
  803282:	83 c4 10             	add    $0x10,%esp
			return mainBlk;
  803285:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803288:	eb 05                	jmp    80328f <realloc_block_FF+0x4a7>
		}
	}
	return NULL;
  80328a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80328f:	c9                   	leave  
  803290:	c3                   	ret    

00803291 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803291:	55                   	push   %ebp
  803292:	89 e5                	mov    %esp,%ebp
  803294:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803297:	83 ec 04             	sub    $0x4,%esp
  80329a:	68 40 3d 80 00       	push   $0x803d40
  80329f:	68 20 02 00 00       	push   $0x220
  8032a4:	68 77 3c 80 00       	push   $0x803c77
  8032a9:	e8 cf cf ff ff       	call   80027d <_panic>

008032ae <alloc_block_NF>:
}
//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8032ae:	55                   	push   %ebp
  8032af:	89 e5                	mov    %esp,%ebp
  8032b1:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8032b4:	83 ec 04             	sub    $0x4,%esp
  8032b7:	68 68 3d 80 00       	push   $0x803d68
  8032bc:	68 28 02 00 00       	push   $0x228
  8032c1:	68 77 3c 80 00       	push   $0x803c77
  8032c6:	e8 b2 cf ff ff       	call   80027d <_panic>
  8032cb:	90                   	nop

008032cc <__udivdi3>:
  8032cc:	55                   	push   %ebp
  8032cd:	57                   	push   %edi
  8032ce:	56                   	push   %esi
  8032cf:	53                   	push   %ebx
  8032d0:	83 ec 1c             	sub    $0x1c,%esp
  8032d3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8032d7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8032db:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8032df:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8032e3:	89 ca                	mov    %ecx,%edx
  8032e5:	89 f8                	mov    %edi,%eax
  8032e7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8032eb:	85 f6                	test   %esi,%esi
  8032ed:	75 2d                	jne    80331c <__udivdi3+0x50>
  8032ef:	39 cf                	cmp    %ecx,%edi
  8032f1:	77 65                	ja     803358 <__udivdi3+0x8c>
  8032f3:	89 fd                	mov    %edi,%ebp
  8032f5:	85 ff                	test   %edi,%edi
  8032f7:	75 0b                	jne    803304 <__udivdi3+0x38>
  8032f9:	b8 01 00 00 00       	mov    $0x1,%eax
  8032fe:	31 d2                	xor    %edx,%edx
  803300:	f7 f7                	div    %edi
  803302:	89 c5                	mov    %eax,%ebp
  803304:	31 d2                	xor    %edx,%edx
  803306:	89 c8                	mov    %ecx,%eax
  803308:	f7 f5                	div    %ebp
  80330a:	89 c1                	mov    %eax,%ecx
  80330c:	89 d8                	mov    %ebx,%eax
  80330e:	f7 f5                	div    %ebp
  803310:	89 cf                	mov    %ecx,%edi
  803312:	89 fa                	mov    %edi,%edx
  803314:	83 c4 1c             	add    $0x1c,%esp
  803317:	5b                   	pop    %ebx
  803318:	5e                   	pop    %esi
  803319:	5f                   	pop    %edi
  80331a:	5d                   	pop    %ebp
  80331b:	c3                   	ret    
  80331c:	39 ce                	cmp    %ecx,%esi
  80331e:	77 28                	ja     803348 <__udivdi3+0x7c>
  803320:	0f bd fe             	bsr    %esi,%edi
  803323:	83 f7 1f             	xor    $0x1f,%edi
  803326:	75 40                	jne    803368 <__udivdi3+0x9c>
  803328:	39 ce                	cmp    %ecx,%esi
  80332a:	72 0a                	jb     803336 <__udivdi3+0x6a>
  80332c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803330:	0f 87 9e 00 00 00    	ja     8033d4 <__udivdi3+0x108>
  803336:	b8 01 00 00 00       	mov    $0x1,%eax
  80333b:	89 fa                	mov    %edi,%edx
  80333d:	83 c4 1c             	add    $0x1c,%esp
  803340:	5b                   	pop    %ebx
  803341:	5e                   	pop    %esi
  803342:	5f                   	pop    %edi
  803343:	5d                   	pop    %ebp
  803344:	c3                   	ret    
  803345:	8d 76 00             	lea    0x0(%esi),%esi
  803348:	31 ff                	xor    %edi,%edi
  80334a:	31 c0                	xor    %eax,%eax
  80334c:	89 fa                	mov    %edi,%edx
  80334e:	83 c4 1c             	add    $0x1c,%esp
  803351:	5b                   	pop    %ebx
  803352:	5e                   	pop    %esi
  803353:	5f                   	pop    %edi
  803354:	5d                   	pop    %ebp
  803355:	c3                   	ret    
  803356:	66 90                	xchg   %ax,%ax
  803358:	89 d8                	mov    %ebx,%eax
  80335a:	f7 f7                	div    %edi
  80335c:	31 ff                	xor    %edi,%edi
  80335e:	89 fa                	mov    %edi,%edx
  803360:	83 c4 1c             	add    $0x1c,%esp
  803363:	5b                   	pop    %ebx
  803364:	5e                   	pop    %esi
  803365:	5f                   	pop    %edi
  803366:	5d                   	pop    %ebp
  803367:	c3                   	ret    
  803368:	bd 20 00 00 00       	mov    $0x20,%ebp
  80336d:	89 eb                	mov    %ebp,%ebx
  80336f:	29 fb                	sub    %edi,%ebx
  803371:	89 f9                	mov    %edi,%ecx
  803373:	d3 e6                	shl    %cl,%esi
  803375:	89 c5                	mov    %eax,%ebp
  803377:	88 d9                	mov    %bl,%cl
  803379:	d3 ed                	shr    %cl,%ebp
  80337b:	89 e9                	mov    %ebp,%ecx
  80337d:	09 f1                	or     %esi,%ecx
  80337f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803383:	89 f9                	mov    %edi,%ecx
  803385:	d3 e0                	shl    %cl,%eax
  803387:	89 c5                	mov    %eax,%ebp
  803389:	89 d6                	mov    %edx,%esi
  80338b:	88 d9                	mov    %bl,%cl
  80338d:	d3 ee                	shr    %cl,%esi
  80338f:	89 f9                	mov    %edi,%ecx
  803391:	d3 e2                	shl    %cl,%edx
  803393:	8b 44 24 08          	mov    0x8(%esp),%eax
  803397:	88 d9                	mov    %bl,%cl
  803399:	d3 e8                	shr    %cl,%eax
  80339b:	09 c2                	or     %eax,%edx
  80339d:	89 d0                	mov    %edx,%eax
  80339f:	89 f2                	mov    %esi,%edx
  8033a1:	f7 74 24 0c          	divl   0xc(%esp)
  8033a5:	89 d6                	mov    %edx,%esi
  8033a7:	89 c3                	mov    %eax,%ebx
  8033a9:	f7 e5                	mul    %ebp
  8033ab:	39 d6                	cmp    %edx,%esi
  8033ad:	72 19                	jb     8033c8 <__udivdi3+0xfc>
  8033af:	74 0b                	je     8033bc <__udivdi3+0xf0>
  8033b1:	89 d8                	mov    %ebx,%eax
  8033b3:	31 ff                	xor    %edi,%edi
  8033b5:	e9 58 ff ff ff       	jmp    803312 <__udivdi3+0x46>
  8033ba:	66 90                	xchg   %ax,%ax
  8033bc:	8b 54 24 08          	mov    0x8(%esp),%edx
  8033c0:	89 f9                	mov    %edi,%ecx
  8033c2:	d3 e2                	shl    %cl,%edx
  8033c4:	39 c2                	cmp    %eax,%edx
  8033c6:	73 e9                	jae    8033b1 <__udivdi3+0xe5>
  8033c8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8033cb:	31 ff                	xor    %edi,%edi
  8033cd:	e9 40 ff ff ff       	jmp    803312 <__udivdi3+0x46>
  8033d2:	66 90                	xchg   %ax,%ax
  8033d4:	31 c0                	xor    %eax,%eax
  8033d6:	e9 37 ff ff ff       	jmp    803312 <__udivdi3+0x46>
  8033db:	90                   	nop

008033dc <__umoddi3>:
  8033dc:	55                   	push   %ebp
  8033dd:	57                   	push   %edi
  8033de:	56                   	push   %esi
  8033df:	53                   	push   %ebx
  8033e0:	83 ec 1c             	sub    $0x1c,%esp
  8033e3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8033e7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8033eb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8033ef:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8033f3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8033f7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8033fb:	89 f3                	mov    %esi,%ebx
  8033fd:	89 fa                	mov    %edi,%edx
  8033ff:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803403:	89 34 24             	mov    %esi,(%esp)
  803406:	85 c0                	test   %eax,%eax
  803408:	75 1a                	jne    803424 <__umoddi3+0x48>
  80340a:	39 f7                	cmp    %esi,%edi
  80340c:	0f 86 a2 00 00 00    	jbe    8034b4 <__umoddi3+0xd8>
  803412:	89 c8                	mov    %ecx,%eax
  803414:	89 f2                	mov    %esi,%edx
  803416:	f7 f7                	div    %edi
  803418:	89 d0                	mov    %edx,%eax
  80341a:	31 d2                	xor    %edx,%edx
  80341c:	83 c4 1c             	add    $0x1c,%esp
  80341f:	5b                   	pop    %ebx
  803420:	5e                   	pop    %esi
  803421:	5f                   	pop    %edi
  803422:	5d                   	pop    %ebp
  803423:	c3                   	ret    
  803424:	39 f0                	cmp    %esi,%eax
  803426:	0f 87 ac 00 00 00    	ja     8034d8 <__umoddi3+0xfc>
  80342c:	0f bd e8             	bsr    %eax,%ebp
  80342f:	83 f5 1f             	xor    $0x1f,%ebp
  803432:	0f 84 ac 00 00 00    	je     8034e4 <__umoddi3+0x108>
  803438:	bf 20 00 00 00       	mov    $0x20,%edi
  80343d:	29 ef                	sub    %ebp,%edi
  80343f:	89 fe                	mov    %edi,%esi
  803441:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803445:	89 e9                	mov    %ebp,%ecx
  803447:	d3 e0                	shl    %cl,%eax
  803449:	89 d7                	mov    %edx,%edi
  80344b:	89 f1                	mov    %esi,%ecx
  80344d:	d3 ef                	shr    %cl,%edi
  80344f:	09 c7                	or     %eax,%edi
  803451:	89 e9                	mov    %ebp,%ecx
  803453:	d3 e2                	shl    %cl,%edx
  803455:	89 14 24             	mov    %edx,(%esp)
  803458:	89 d8                	mov    %ebx,%eax
  80345a:	d3 e0                	shl    %cl,%eax
  80345c:	89 c2                	mov    %eax,%edx
  80345e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803462:	d3 e0                	shl    %cl,%eax
  803464:	89 44 24 04          	mov    %eax,0x4(%esp)
  803468:	8b 44 24 08          	mov    0x8(%esp),%eax
  80346c:	89 f1                	mov    %esi,%ecx
  80346e:	d3 e8                	shr    %cl,%eax
  803470:	09 d0                	or     %edx,%eax
  803472:	d3 eb                	shr    %cl,%ebx
  803474:	89 da                	mov    %ebx,%edx
  803476:	f7 f7                	div    %edi
  803478:	89 d3                	mov    %edx,%ebx
  80347a:	f7 24 24             	mull   (%esp)
  80347d:	89 c6                	mov    %eax,%esi
  80347f:	89 d1                	mov    %edx,%ecx
  803481:	39 d3                	cmp    %edx,%ebx
  803483:	0f 82 87 00 00 00    	jb     803510 <__umoddi3+0x134>
  803489:	0f 84 91 00 00 00    	je     803520 <__umoddi3+0x144>
  80348f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803493:	29 f2                	sub    %esi,%edx
  803495:	19 cb                	sbb    %ecx,%ebx
  803497:	89 d8                	mov    %ebx,%eax
  803499:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80349d:	d3 e0                	shl    %cl,%eax
  80349f:	89 e9                	mov    %ebp,%ecx
  8034a1:	d3 ea                	shr    %cl,%edx
  8034a3:	09 d0                	or     %edx,%eax
  8034a5:	89 e9                	mov    %ebp,%ecx
  8034a7:	d3 eb                	shr    %cl,%ebx
  8034a9:	89 da                	mov    %ebx,%edx
  8034ab:	83 c4 1c             	add    $0x1c,%esp
  8034ae:	5b                   	pop    %ebx
  8034af:	5e                   	pop    %esi
  8034b0:	5f                   	pop    %edi
  8034b1:	5d                   	pop    %ebp
  8034b2:	c3                   	ret    
  8034b3:	90                   	nop
  8034b4:	89 fd                	mov    %edi,%ebp
  8034b6:	85 ff                	test   %edi,%edi
  8034b8:	75 0b                	jne    8034c5 <__umoddi3+0xe9>
  8034ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8034bf:	31 d2                	xor    %edx,%edx
  8034c1:	f7 f7                	div    %edi
  8034c3:	89 c5                	mov    %eax,%ebp
  8034c5:	89 f0                	mov    %esi,%eax
  8034c7:	31 d2                	xor    %edx,%edx
  8034c9:	f7 f5                	div    %ebp
  8034cb:	89 c8                	mov    %ecx,%eax
  8034cd:	f7 f5                	div    %ebp
  8034cf:	89 d0                	mov    %edx,%eax
  8034d1:	e9 44 ff ff ff       	jmp    80341a <__umoddi3+0x3e>
  8034d6:	66 90                	xchg   %ax,%ax
  8034d8:	89 c8                	mov    %ecx,%eax
  8034da:	89 f2                	mov    %esi,%edx
  8034dc:	83 c4 1c             	add    $0x1c,%esp
  8034df:	5b                   	pop    %ebx
  8034e0:	5e                   	pop    %esi
  8034e1:	5f                   	pop    %edi
  8034e2:	5d                   	pop    %ebp
  8034e3:	c3                   	ret    
  8034e4:	3b 04 24             	cmp    (%esp),%eax
  8034e7:	72 06                	jb     8034ef <__umoddi3+0x113>
  8034e9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8034ed:	77 0f                	ja     8034fe <__umoddi3+0x122>
  8034ef:	89 f2                	mov    %esi,%edx
  8034f1:	29 f9                	sub    %edi,%ecx
  8034f3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8034f7:	89 14 24             	mov    %edx,(%esp)
  8034fa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8034fe:	8b 44 24 04          	mov    0x4(%esp),%eax
  803502:	8b 14 24             	mov    (%esp),%edx
  803505:	83 c4 1c             	add    $0x1c,%esp
  803508:	5b                   	pop    %ebx
  803509:	5e                   	pop    %esi
  80350a:	5f                   	pop    %edi
  80350b:	5d                   	pop    %ebp
  80350c:	c3                   	ret    
  80350d:	8d 76 00             	lea    0x0(%esi),%esi
  803510:	2b 04 24             	sub    (%esp),%eax
  803513:	19 fa                	sbb    %edi,%edx
  803515:	89 d1                	mov    %edx,%ecx
  803517:	89 c6                	mov    %eax,%esi
  803519:	e9 71 ff ff ff       	jmp    80348f <__umoddi3+0xb3>
  80351e:	66 90                	xchg   %ax,%ax
  803520:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803524:	72 ea                	jb     803510 <__umoddi3+0x134>
  803526:	89 d9                	mov    %ebx,%ecx
  803528:	e9 62 ff ff ff       	jmp    80348f <__umoddi3+0xb3>
