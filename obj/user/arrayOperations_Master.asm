
obj/user/arrayOperations_Master:     file format elf32-i386


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
  800031:	e8 b6 08 00 00       	call   8008ec <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
uint32 CheckSorted(int *Elements, int NumOfElements);
void ArrayStats(int *Elements, int NumOfElements, int64 *mean, int64 *var);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec bc 00 00 00    	sub    $0xbc,%esp
	/*[1] CREATE SEMAPHORES*/
	struct semaphore ready = create_semaphore("Ready", 0);
  800044:	8d 45 84             	lea    -0x7c(%ebp),%eax
  800047:	83 ec 04             	sub    $0x4,%esp
  80004a:	6a 00                	push   $0x0
  80004c:	68 00 42 80 00       	push   $0x804200
  800051:	50                   	push   %eax
  800052:	e8 30 3c 00 00       	call   803c87 <create_semaphore>
  800057:	83 c4 0c             	add    $0xc,%esp
	struct semaphore finished = create_semaphore("Finished", 0);
  80005a:	8d 45 80             	lea    -0x80(%ebp),%eax
  80005d:	83 ec 04             	sub    $0x4,%esp
  800060:	6a 00                	push   $0x0
  800062:	68 06 42 80 00       	push   $0x804206
  800067:	50                   	push   %eax
  800068:	e8 1a 3c 00 00       	call   803c87 <create_semaphore>
  80006d:	83 c4 0c             	add    $0xc,%esp
	struct semaphore cons_mutex = create_semaphore("Console Mutex", 1);
  800070:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800076:	83 ec 04             	sub    $0x4,%esp
  800079:	6a 01                	push   $0x1
  80007b:	68 0f 42 80 00       	push   $0x80420f
  800080:	50                   	push   %eax
  800081:	e8 01 3c 00 00       	call   803c87 <create_semaphore>
  800086:	83 c4 0c             	add    $0xc,%esp

	/*[2] RUN THE SLAVES PROGRAMS*/
	int numOfSlaveProgs = 3 ;
  800089:	c7 45 dc 03 00 00 00 	movl   $0x3,-0x24(%ebp)

	int32 envIdQuickSort = sys_create_env("slave_qs", (myEnv->page_WS_max_size),(myEnv->SecondListSize) ,(myEnv->percentage_of_WS_pages_to_be_removed));
  800090:	a1 20 50 80 00       	mov    0x805020,%eax
  800095:	8b 90 90 05 00 00    	mov    0x590(%eax),%edx
  80009b:	a1 20 50 80 00       	mov    0x805020,%eax
  8000a0:	8b 80 88 05 00 00    	mov    0x588(%eax),%eax
  8000a6:	89 c1                	mov    %eax,%ecx
  8000a8:	a1 20 50 80 00       	mov    0x805020,%eax
  8000ad:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  8000b3:	52                   	push   %edx
  8000b4:	51                   	push   %ecx
  8000b5:	50                   	push   %eax
  8000b6:	68 1d 42 80 00       	push   $0x80421d
  8000bb:	e8 16 25 00 00       	call   8025d6 <sys_create_env>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int32 envIdMergeSort = sys_create_env("slave_ms", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
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
  8000ec:	68 26 42 80 00       	push   $0x804226
  8000f1:	e8 e0 24 00 00       	call   8025d6 <sys_create_env>
  8000f6:	83 c4 10             	add    $0x10,%esp
  8000f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	int32 envIdStats = sys_create_env("slave_stats", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
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
  800122:	68 2f 42 80 00       	push   $0x80422f
  800127:	e8 aa 24 00 00       	call   8025d6 <sys_create_env>
  80012c:	83 c4 10             	add    $0x10,%esp
  80012f:	89 45 d0             	mov    %eax,-0x30(%ebp)

	if (envIdQuickSort == E_ENV_CREATION_ERROR || envIdMergeSort == E_ENV_CREATION_ERROR || envIdStats == E_ENV_CREATION_ERROR)
  800132:	83 7d d8 ef          	cmpl   $0xffffffef,-0x28(%ebp)
  800136:	74 0c                	je     800144 <_main+0x10c>
  800138:	83 7d d4 ef          	cmpl   $0xffffffef,-0x2c(%ebp)
  80013c:	74 06                	je     800144 <_main+0x10c>
  80013e:	83 7d d0 ef          	cmpl   $0xffffffef,-0x30(%ebp)
  800142:	75 14                	jne    800158 <_main+0x120>
		panic("NO AVAILABLE ENVs...");
  800144:	83 ec 04             	sub    $0x4,%esp
  800147:	68 3b 42 80 00       	push   $0x80423b
  80014c:	6a 1a                	push   $0x1a
  80014e:	68 50 42 80 00       	push   $0x804250
  800153:	e8 d9 08 00 00       	call   800a31 <_panic>

	sys_run_env(envIdQuickSort);
  800158:	83 ec 0c             	sub    $0xc,%esp
  80015b:	ff 75 d8             	pushl  -0x28(%ebp)
  80015e:	e8 91 24 00 00       	call   8025f4 <sys_run_env>
  800163:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdMergeSort);
  800166:	83 ec 0c             	sub    $0xc,%esp
  800169:	ff 75 d4             	pushl  -0x2c(%ebp)
  80016c:	e8 83 24 00 00       	call   8025f4 <sys_run_env>
  800171:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdStats);
  800174:	83 ec 0c             	sub    $0xc,%esp
  800177:	ff 75 d0             	pushl  -0x30(%ebp)
  80017a:	e8 75 24 00 00       	call   8025f4 <sys_run_env>
  80017f:	83 c4 10             	add    $0x10,%esp

	/*[3] CREATE SHARED VARIABLES*/
	//Share the cons_mutex owner ID
	int *mutexOwnerID = smalloc("cons_mutex ownerID", sizeof(int) , 0) ;
  800182:	83 ec 04             	sub    $0x4,%esp
  800185:	6a 00                	push   $0x0
  800187:	6a 04                	push   $0x4
  800189:	68 6e 42 80 00       	push   $0x80426e
  80018e:	e8 ca 1d 00 00       	call   801f5d <smalloc>
  800193:	83 c4 10             	add    $0x10,%esp
  800196:	89 45 cc             	mov    %eax,-0x34(%ebp)
	*mutexOwnerID = myEnv->env_id ;
  800199:	a1 20 50 80 00       	mov    0x805020,%eax
  80019e:	8b 50 10             	mov    0x10(%eax),%edx
  8001a1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001a4:	89 10                	mov    %edx,(%eax)

	int ret;
	char Chose;
	char Line[30];
	int NumOfElements;
	int *Elements = NULL;
  8001a6:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
	//lock the console
	wait_semaphore(cons_mutex);
  8001ad:	83 ec 0c             	sub    $0xc,%esp
  8001b0:	ff b5 7c ff ff ff    	pushl  -0x84(%ebp)
  8001b6:	e8 98 3b 00 00       	call   803d53 <wait_semaphore>
  8001bb:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("\n");
  8001be:	83 ec 0c             	sub    $0xc,%esp
  8001c1:	68 81 42 80 00       	push   $0x804281
  8001c6:	e8 23 0b 00 00       	call   800cee <cprintf>
  8001cb:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  8001ce:	83 ec 0c             	sub    $0xc,%esp
  8001d1:	68 83 42 80 00       	push   $0x804283
  8001d6:	e8 13 0b 00 00       	call   800cee <cprintf>
  8001db:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   ARRAY OOERATIONS   !!!\n");
  8001de:	83 ec 0c             	sub    $0xc,%esp
  8001e1:	68 a1 42 80 00       	push   $0x8042a1
  8001e6:	e8 03 0b 00 00       	call   800cee <cprintf>
  8001eb:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  8001ee:	83 ec 0c             	sub    $0xc,%esp
  8001f1:	68 83 42 80 00       	push   $0x804283
  8001f6:	e8 f3 0a 00 00       	call   800cee <cprintf>
  8001fb:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  8001fe:	83 ec 0c             	sub    $0xc,%esp
  800201:	68 81 42 80 00       	push   $0x804281
  800206:	e8 e3 0a 00 00       	call   800cee <cprintf>
  80020b:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  80020e:	83 ec 08             	sub    $0x8,%esp
  800211:	8d 85 5e ff ff ff    	lea    -0xa2(%ebp),%eax
  800217:	50                   	push   %eax
  800218:	68 c0 42 80 00       	push   $0x8042c0
  80021d:	e8 60 11 00 00       	call   801382 <readline>
  800222:	83 c4 10             	add    $0x10,%esp

		//Create the shared array & its size
		int *arrSize = smalloc("arrSize", sizeof(int) , 0) ;
  800225:	83 ec 04             	sub    $0x4,%esp
  800228:	6a 00                	push   $0x0
  80022a:	6a 04                	push   $0x4
  80022c:	68 df 42 80 00       	push   $0x8042df
  800231:	e8 27 1d 00 00       	call   801f5d <smalloc>
  800236:	83 c4 10             	add    $0x10,%esp
  800239:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		*arrSize = strtol(Line, NULL, 10) ;
  80023c:	83 ec 04             	sub    $0x4,%esp
  80023f:	6a 0a                	push   $0xa
  800241:	6a 00                	push   $0x0
  800243:	8d 85 5e ff ff ff    	lea    -0xa2(%ebp),%eax
  800249:	50                   	push   %eax
  80024a:	e8 9b 16 00 00       	call   8018ea <strtol>
  80024f:	83 c4 10             	add    $0x10,%esp
  800252:	89 c2                	mov    %eax,%edx
  800254:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800257:	89 10                	mov    %edx,(%eax)
		NumOfElements = *arrSize;
  800259:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80025c:	8b 00                	mov    (%eax),%eax
  80025e:	89 45 c0             	mov    %eax,-0x40(%ebp)
		Elements = smalloc("arr", sizeof(int) * NumOfElements , 0) ;
  800261:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800264:	c1 e0 02             	shl    $0x2,%eax
  800267:	83 ec 04             	sub    $0x4,%esp
  80026a:	6a 00                	push   $0x0
  80026c:	50                   	push   %eax
  80026d:	68 e7 42 80 00       	push   $0x8042e7
  800272:	e8 e6 1c 00 00       	call   801f5d <smalloc>
  800277:	83 c4 10             	add    $0x10,%esp
  80027a:	89 45 c8             	mov    %eax,-0x38(%ebp)

		cprintf("Chose the initialization method:\n") ;
  80027d:	83 ec 0c             	sub    $0xc,%esp
  800280:	68 ec 42 80 00       	push   $0x8042ec
  800285:	e8 64 0a 00 00       	call   800cee <cprintf>
  80028a:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  80028d:	83 ec 0c             	sub    $0xc,%esp
  800290:	68 0e 43 80 00       	push   $0x80430e
  800295:	e8 54 0a 00 00       	call   800cee <cprintf>
  80029a:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  80029d:	83 ec 0c             	sub    $0xc,%esp
  8002a0:	68 1c 43 80 00       	push   $0x80431c
  8002a5:	e8 44 0a 00 00       	call   800cee <cprintf>
  8002aa:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  8002ad:	83 ec 0c             	sub    $0xc,%esp
  8002b0:	68 2b 43 80 00       	push   $0x80432b
  8002b5:	e8 34 0a 00 00       	call   800cee <cprintf>
  8002ba:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  8002bd:	83 ec 0c             	sub    $0xc,%esp
  8002c0:	68 3b 43 80 00       	push   $0x80433b
  8002c5:	e8 24 0a 00 00       	call   800cee <cprintf>
  8002ca:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  8002cd:	e8 fd 05 00 00       	call   8008cf <getchar>
  8002d2:	88 45 bf             	mov    %al,-0x41(%ebp)
			cputchar(Chose);
  8002d5:	0f be 45 bf          	movsbl -0x41(%ebp),%eax
  8002d9:	83 ec 0c             	sub    $0xc,%esp
  8002dc:	50                   	push   %eax
  8002dd:	e8 ce 05 00 00       	call   8008b0 <cputchar>
  8002e2:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8002e5:	83 ec 0c             	sub    $0xc,%esp
  8002e8:	6a 0a                	push   $0xa
  8002ea:	e8 c1 05 00 00       	call   8008b0 <cputchar>
  8002ef:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  8002f2:	80 7d bf 61          	cmpb   $0x61,-0x41(%ebp)
  8002f6:	74 0c                	je     800304 <_main+0x2cc>
  8002f8:	80 7d bf 62          	cmpb   $0x62,-0x41(%ebp)
  8002fc:	74 06                	je     800304 <_main+0x2cc>
  8002fe:	80 7d bf 63          	cmpb   $0x63,-0x41(%ebp)
  800302:	75 b9                	jne    8002bd <_main+0x285>

	}
	signal_semaphore(cons_mutex);
  800304:	83 ec 0c             	sub    $0xc,%esp
  800307:	ff b5 7c ff ff ff    	pushl  -0x84(%ebp)
  80030d:	e8 ab 3a 00 00       	call   803dbd <signal_semaphore>
  800312:	83 c4 10             	add    $0x10,%esp
	//unlock the console

	int  i ;
	switch (Chose)
  800315:	0f be 45 bf          	movsbl -0x41(%ebp),%eax
  800319:	83 f8 62             	cmp    $0x62,%eax
  80031c:	74 1d                	je     80033b <_main+0x303>
  80031e:	83 f8 63             	cmp    $0x63,%eax
  800321:	74 2b                	je     80034e <_main+0x316>
  800323:	83 f8 61             	cmp    $0x61,%eax
  800326:	75 39                	jne    800361 <_main+0x329>
	{
	case 'a':
		InitializeAscending(Elements, NumOfElements);
  800328:	83 ec 08             	sub    $0x8,%esp
  80032b:	ff 75 c0             	pushl  -0x40(%ebp)
  80032e:	ff 75 c8             	pushl  -0x38(%ebp)
  800331:	e8 81 03 00 00       	call   8006b7 <InitializeAscending>
  800336:	83 c4 10             	add    $0x10,%esp
		break ;
  800339:	eb 37                	jmp    800372 <_main+0x33a>
	case 'b':
		InitializeDescending(Elements, NumOfElements);
  80033b:	83 ec 08             	sub    $0x8,%esp
  80033e:	ff 75 c0             	pushl  -0x40(%ebp)
  800341:	ff 75 c8             	pushl  -0x38(%ebp)
  800344:	e8 9f 03 00 00       	call   8006e8 <InitializeDescending>
  800349:	83 c4 10             	add    $0x10,%esp
		break ;
  80034c:	eb 24                	jmp    800372 <_main+0x33a>
	case 'c':
		InitializeSemiRandom(Elements, NumOfElements);
  80034e:	83 ec 08             	sub    $0x8,%esp
  800351:	ff 75 c0             	pushl  -0x40(%ebp)
  800354:	ff 75 c8             	pushl  -0x38(%ebp)
  800357:	e8 c1 03 00 00       	call   80071d <InitializeSemiRandom>
  80035c:	83 c4 10             	add    $0x10,%esp
		break ;
  80035f:	eb 11                	jmp    800372 <_main+0x33a>
	default:
		InitializeSemiRandom(Elements, NumOfElements);
  800361:	83 ec 08             	sub    $0x8,%esp
  800364:	ff 75 c0             	pushl  -0x40(%ebp)
  800367:	ff 75 c8             	pushl  -0x38(%ebp)
  80036a:	e8 ae 03 00 00       	call   80071d <InitializeSemiRandom>
  80036f:	83 c4 10             	add    $0x10,%esp
	}

	/*[4] SIGNAL READY TO THE SLAVES*/
	for (int i = 0; i < numOfSlaveProgs; ++i) {
  800372:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800379:	eb 11                	jmp    80038c <_main+0x354>
		signal_semaphore(ready);
  80037b:	83 ec 0c             	sub    $0xc,%esp
  80037e:	ff 75 84             	pushl  -0x7c(%ebp)
  800381:	e8 37 3a 00 00       	call   803dbd <signal_semaphore>
  800386:	83 c4 10             	add    $0x10,%esp
	default:
		InitializeSemiRandom(Elements, NumOfElements);
	}

	/*[4] SIGNAL READY TO THE SLAVES*/
	for (int i = 0; i < numOfSlaveProgs; ++i) {
  800389:	ff 45 e4             	incl   -0x1c(%ebp)
  80038c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80038f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800392:	7c e7                	jl     80037b <_main+0x343>
		signal_semaphore(ready);
	}

	/*[5] WAIT TILL ALL SLAVES FINISHED*/
	for (int i = 0; i < numOfSlaveProgs; ++i) {
  800394:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80039b:	eb 11                	jmp    8003ae <_main+0x376>
		wait_semaphore(finished);
  80039d:	83 ec 0c             	sub    $0xc,%esp
  8003a0:	ff 75 80             	pushl  -0x80(%ebp)
  8003a3:	e8 ab 39 00 00       	call   803d53 <wait_semaphore>
  8003a8:	83 c4 10             	add    $0x10,%esp
	for (int i = 0; i < numOfSlaveProgs; ++i) {
		signal_semaphore(ready);
	}

	/*[5] WAIT TILL ALL SLAVES FINISHED*/
	for (int i = 0; i < numOfSlaveProgs; ++i) {
  8003ab:	ff 45 e0             	incl   -0x20(%ebp)
  8003ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003b1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8003b4:	7c e7                	jl     80039d <_main+0x365>
		wait_semaphore(finished);
	}

	/*[6] GET THEIR RESULTS*/
	int *quicksortedArr = NULL;
  8003b6:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
	int *mergesortedArr = NULL;
  8003bd:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
	int64 *mean = NULL;
  8003c4:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
	int64 *var = NULL;
  8003cb:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
	int *min = NULL;
  8003d2:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
	int *max = NULL;
  8003d9:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
	int *med = NULL;
  8003e0:	c7 45 a0 00 00 00 00 	movl   $0x0,-0x60(%ebp)
	quicksortedArr = sget(envIdQuickSort, "quicksortedArr") ;
  8003e7:	83 ec 08             	sub    $0x8,%esp
  8003ea:	68 44 43 80 00       	push   $0x804344
  8003ef:	ff 75 d8             	pushl  -0x28(%ebp)
  8003f2:	e8 01 1d 00 00       	call   8020f8 <sget>
  8003f7:	83 c4 10             	add    $0x10,%esp
  8003fa:	89 45 b8             	mov    %eax,-0x48(%ebp)
	mergesortedArr = sget(envIdMergeSort, "mergesortedArr") ;
  8003fd:	83 ec 08             	sub    $0x8,%esp
  800400:	68 53 43 80 00       	push   $0x804353
  800405:	ff 75 d4             	pushl  -0x2c(%ebp)
  800408:	e8 eb 1c 00 00       	call   8020f8 <sget>
  80040d:	83 c4 10             	add    $0x10,%esp
  800410:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	mean = sget(envIdStats, "mean") ;
  800413:	83 ec 08             	sub    $0x8,%esp
  800416:	68 62 43 80 00       	push   $0x804362
  80041b:	ff 75 d0             	pushl  -0x30(%ebp)
  80041e:	e8 d5 1c 00 00       	call   8020f8 <sget>
  800423:	83 c4 10             	add    $0x10,%esp
  800426:	89 45 b0             	mov    %eax,-0x50(%ebp)
	var = sget(envIdStats,"var") ;
  800429:	83 ec 08             	sub    $0x8,%esp
  80042c:	68 67 43 80 00       	push   $0x804367
  800431:	ff 75 d0             	pushl  -0x30(%ebp)
  800434:	e8 bf 1c 00 00       	call   8020f8 <sget>
  800439:	83 c4 10             	add    $0x10,%esp
  80043c:	89 45 ac             	mov    %eax,-0x54(%ebp)
	min = sget(envIdStats,"min") ;
  80043f:	83 ec 08             	sub    $0x8,%esp
  800442:	68 6b 43 80 00       	push   $0x80436b
  800447:	ff 75 d0             	pushl  -0x30(%ebp)
  80044a:	e8 a9 1c 00 00       	call   8020f8 <sget>
  80044f:	83 c4 10             	add    $0x10,%esp
  800452:	89 45 a8             	mov    %eax,-0x58(%ebp)
	max = sget(envIdStats,"max") ;
  800455:	83 ec 08             	sub    $0x8,%esp
  800458:	68 6f 43 80 00       	push   $0x80436f
  80045d:	ff 75 d0             	pushl  -0x30(%ebp)
  800460:	e8 93 1c 00 00       	call   8020f8 <sget>
  800465:	83 c4 10             	add    $0x10,%esp
  800468:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	med = sget(envIdStats,"med") ;
  80046b:	83 ec 08             	sub    $0x8,%esp
  80046e:	68 73 43 80 00       	push   $0x804373
  800473:	ff 75 d0             	pushl  -0x30(%ebp)
  800476:	e8 7d 1c 00 00       	call   8020f8 <sget>
  80047b:	83 c4 10             	add    $0x10,%esp
  80047e:	89 45 a0             	mov    %eax,-0x60(%ebp)

	/*[7] VALIDATE THE RESULTS*/
	uint32 sorted = CheckSorted(quicksortedArr, NumOfElements);
  800481:	83 ec 08             	sub    $0x8,%esp
  800484:	ff 75 c0             	pushl  -0x40(%ebp)
  800487:	ff 75 b8             	pushl  -0x48(%ebp)
  80048a:	e8 d1 01 00 00       	call   800660 <CheckSorted>
  80048f:	83 c4 10             	add    $0x10,%esp
  800492:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if(sorted == 0) panic("The array is NOT quick-sorted correctly") ;
  800495:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  800499:	75 14                	jne    8004af <_main+0x477>
  80049b:	83 ec 04             	sub    $0x4,%esp
  80049e:	68 78 43 80 00       	push   $0x804378
  8004a3:	6a 77                	push   $0x77
  8004a5:	68 50 42 80 00       	push   $0x804250
  8004aa:	e8 82 05 00 00       	call   800a31 <_panic>
	sorted = CheckSorted(mergesortedArr, NumOfElements);
  8004af:	83 ec 08             	sub    $0x8,%esp
  8004b2:	ff 75 c0             	pushl  -0x40(%ebp)
  8004b5:	ff 75 b4             	pushl  -0x4c(%ebp)
  8004b8:	e8 a3 01 00 00       	call   800660 <CheckSorted>
  8004bd:	83 c4 10             	add    $0x10,%esp
  8004c0:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if(sorted == 0) panic("The array is NOT merge-sorted correctly") ;
  8004c3:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  8004c7:	75 14                	jne    8004dd <_main+0x4a5>
  8004c9:	83 ec 04             	sub    $0x4,%esp
  8004cc:	68 a0 43 80 00       	push   $0x8043a0
  8004d1:	6a 79                	push   $0x79
  8004d3:	68 50 42 80 00       	push   $0x804250
  8004d8:	e8 54 05 00 00       	call   800a31 <_panic>
	int64 correctMean, correctVar ;
	ArrayStats(Elements, NumOfElements, &correctMean , &correctVar);
  8004dd:	8d 85 48 ff ff ff    	lea    -0xb8(%ebp),%eax
  8004e3:	50                   	push   %eax
  8004e4:	8d 85 50 ff ff ff    	lea    -0xb0(%ebp),%eax
  8004ea:	50                   	push   %eax
  8004eb:	ff 75 c0             	pushl  -0x40(%ebp)
  8004ee:	ff 75 c8             	pushl  -0x38(%ebp)
  8004f1:	e8 73 02 00 00       	call   800769 <ArrayStats>
  8004f6:	83 c4 10             	add    $0x10,%esp
	int correctMin = quicksortedArr[0];
  8004f9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8004fc:	8b 00                	mov    (%eax),%eax
  8004fe:	89 45 98             	mov    %eax,-0x68(%ebp)
	int last = NumOfElements-1;
  800501:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800504:	48                   	dec    %eax
  800505:	89 45 94             	mov    %eax,-0x6c(%ebp)
//	int middle = (NumOfElements-1)/2;
//	if (NumOfElements % 2 != 0)
//		middle--;
	int middle = NumOfElements/2 - 1; /*-1 to make it ZERO-Based*/
  800508:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80050b:	89 c2                	mov    %eax,%edx
  80050d:	c1 ea 1f             	shr    $0x1f,%edx
  800510:	01 d0                	add    %edx,%eax
  800512:	d1 f8                	sar    %eax
  800514:	48                   	dec    %eax
  800515:	89 45 90             	mov    %eax,-0x70(%ebp)

	int correctMax = quicksortedArr[last];
  800518:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80051b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800522:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800525:	01 d0                	add    %edx,%eax
  800527:	8b 00                	mov    (%eax),%eax
  800529:	89 45 8c             	mov    %eax,-0x74(%ebp)
	int correctMed = quicksortedArr[middle];
  80052c:	8b 45 90             	mov    -0x70(%ebp),%eax
  80052f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800536:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800539:	01 d0                	add    %edx,%eax
  80053b:	8b 00                	mov    (%eax),%eax
  80053d:	89 45 88             	mov    %eax,-0x78(%ebp)
	wait_semaphore(cons_mutex);
  800540:	83 ec 0c             	sub    $0xc,%esp
  800543:	ff b5 7c ff ff ff    	pushl  -0x84(%ebp)
  800549:	e8 05 38 00 00       	call   803d53 <wait_semaphore>
  80054e:	83 c4 10             	add    $0x10,%esp
	{
		//cprintf("Array is correctly sorted\n");
		cprintf("mean = %lld, var = %lld, min = %d, max = %d, med = %d\n", *mean, *var, *min, *max, *med);
  800551:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800554:	8b 00                	mov    (%eax),%eax
  800556:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  80055c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80055f:	8b 38                	mov    (%eax),%edi
  800561:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800564:	8b 30                	mov    (%eax),%esi
  800566:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800569:	8b 08                	mov    (%eax),%ecx
  80056b:	8b 58 04             	mov    0x4(%eax),%ebx
  80056e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800571:	8b 50 04             	mov    0x4(%eax),%edx
  800574:	8b 00                	mov    (%eax),%eax
  800576:	ff b5 44 ff ff ff    	pushl  -0xbc(%ebp)
  80057c:	57                   	push   %edi
  80057d:	56                   	push   %esi
  80057e:	53                   	push   %ebx
  80057f:	51                   	push   %ecx
  800580:	52                   	push   %edx
  800581:	50                   	push   %eax
  800582:	68 c8 43 80 00       	push   $0x8043c8
  800587:	e8 62 07 00 00       	call   800cee <cprintf>
  80058c:	83 c4 20             	add    $0x20,%esp
		cprintf("mean = %lld, var = %lld, min = %d, max = %d, med = %d\n", correctMean, correctVar, correctMin, correctMax, correctMed);
  80058f:	8b 8d 48 ff ff ff    	mov    -0xb8(%ebp),%ecx
  800595:	8b 9d 4c ff ff ff    	mov    -0xb4(%ebp),%ebx
  80059b:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  8005a1:	8b 95 54 ff ff ff    	mov    -0xac(%ebp),%edx
  8005a7:	ff 75 88             	pushl  -0x78(%ebp)
  8005aa:	ff 75 8c             	pushl  -0x74(%ebp)
  8005ad:	ff 75 98             	pushl  -0x68(%ebp)
  8005b0:	53                   	push   %ebx
  8005b1:	51                   	push   %ecx
  8005b2:	52                   	push   %edx
  8005b3:	50                   	push   %eax
  8005b4:	68 c8 43 80 00       	push   $0x8043c8
  8005b9:	e8 30 07 00 00       	call   800cee <cprintf>
  8005be:	83 c4 20             	add    $0x20,%esp
	}
	signal_semaphore(cons_mutex);
  8005c1:	83 ec 0c             	sub    $0xc,%esp
  8005c4:	ff b5 7c ff ff ff    	pushl  -0x84(%ebp)
  8005ca:	e8 ee 37 00 00       	call   803dbd <signal_semaphore>
  8005cf:	83 c4 10             	add    $0x10,%esp
	if(*mean != correctMean || *var != correctVar|| *min != correctMin || *max != correctMax || *med != correctMed)
  8005d2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8005d5:	8b 08                	mov    (%eax),%ecx
  8005d7:	8b 58 04             	mov    0x4(%eax),%ebx
  8005da:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  8005e0:	8b 95 54 ff ff ff    	mov    -0xac(%ebp),%edx
  8005e6:	89 de                	mov    %ebx,%esi
  8005e8:	31 d6                	xor    %edx,%esi
  8005ea:	31 c8                	xor    %ecx,%eax
  8005ec:	09 f0                	or     %esi,%eax
  8005ee:	85 c0                	test   %eax,%eax
  8005f0:	75 3e                	jne    800630 <_main+0x5f8>
  8005f2:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8005f5:	8b 08                	mov    (%eax),%ecx
  8005f7:	8b 58 04             	mov    0x4(%eax),%ebx
  8005fa:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800600:	8b 95 4c ff ff ff    	mov    -0xb4(%ebp),%edx
  800606:	89 de                	mov    %ebx,%esi
  800608:	31 d6                	xor    %edx,%esi
  80060a:	31 c8                	xor    %ecx,%eax
  80060c:	09 f0                	or     %esi,%eax
  80060e:	85 c0                	test   %eax,%eax
  800610:	75 1e                	jne    800630 <_main+0x5f8>
  800612:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800615:	8b 00                	mov    (%eax),%eax
  800617:	3b 45 98             	cmp    -0x68(%ebp),%eax
  80061a:	75 14                	jne    800630 <_main+0x5f8>
  80061c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80061f:	8b 00                	mov    (%eax),%eax
  800621:	3b 45 8c             	cmp    -0x74(%ebp),%eax
  800624:	75 0a                	jne    800630 <_main+0x5f8>
  800626:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800629:	8b 00                	mov    (%eax),%eax
  80062b:	3b 45 88             	cmp    -0x78(%ebp),%eax
  80062e:	74 17                	je     800647 <_main+0x60f>
		panic("The array STATS are NOT calculated correctly") ;
  800630:	83 ec 04             	sub    $0x4,%esp
  800633:	68 00 44 80 00       	push   $0x804400
  800638:	68 8d 00 00 00       	push   $0x8d
  80063d:	68 50 42 80 00       	push   $0x804250
  800642:	e8 ea 03 00 00       	call   800a31 <_panic>

	cprintf("Congratulations!! Scenario of Using the Semaphores & Shared Variables completed successfully!!\n\n\n");
  800647:	83 ec 0c             	sub    $0xc,%esp
  80064a:	68 30 44 80 00       	push   $0x804430
  80064f:	e8 9a 06 00 00       	call   800cee <cprintf>
  800654:	83 c4 10             	add    $0x10,%esp

	return;
  800657:	90                   	nop
}
  800658:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80065b:	5b                   	pop    %ebx
  80065c:	5e                   	pop    %esi
  80065d:	5f                   	pop    %edi
  80065e:	5d                   	pop    %ebp
  80065f:	c3                   	ret    

00800660 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  800660:	55                   	push   %ebp
  800661:	89 e5                	mov    %esp,%ebp
  800663:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  800666:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80066d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800674:	eb 33                	jmp    8006a9 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  800676:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800679:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800680:	8b 45 08             	mov    0x8(%ebp),%eax
  800683:	01 d0                	add    %edx,%eax
  800685:	8b 10                	mov    (%eax),%edx
  800687:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80068a:	40                   	inc    %eax
  80068b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800692:	8b 45 08             	mov    0x8(%ebp),%eax
  800695:	01 c8                	add    %ecx,%eax
  800697:	8b 00                	mov    (%eax),%eax
  800699:	39 c2                	cmp    %eax,%edx
  80069b:	7e 09                	jle    8006a6 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  80069d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  8006a4:	eb 0c                	jmp    8006b2 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8006a6:	ff 45 f8             	incl   -0x8(%ebp)
  8006a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ac:	48                   	dec    %eax
  8006ad:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8006b0:	7f c4                	jg     800676 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  8006b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8006b5:	c9                   	leave  
  8006b6:	c3                   	ret    

008006b7 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  8006b7:	55                   	push   %ebp
  8006b8:	89 e5                	mov    %esp,%ebp
  8006ba:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8006bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8006c4:	eb 17                	jmp    8006dd <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  8006c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006c9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d3:	01 c2                	add    %eax,%edx
  8006d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006d8:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8006da:	ff 45 fc             	incl   -0x4(%ebp)
  8006dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006e0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006e3:	7c e1                	jl     8006c6 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8006e5:	90                   	nop
  8006e6:	c9                   	leave  
  8006e7:	c3                   	ret    

008006e8 <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8006e8:	55                   	push   %ebp
  8006e9:	89 e5                	mov    %esp,%ebp
  8006eb:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8006ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8006f5:	eb 1b                	jmp    800712 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8006f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800701:	8b 45 08             	mov    0x8(%ebp),%eax
  800704:	01 c2                	add    %eax,%edx
  800706:	8b 45 0c             	mov    0xc(%ebp),%eax
  800709:	2b 45 fc             	sub    -0x4(%ebp),%eax
  80070c:	48                   	dec    %eax
  80070d:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80070f:	ff 45 fc             	incl   -0x4(%ebp)
  800712:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800715:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800718:	7c dd                	jl     8006f7 <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  80071a:	90                   	nop
  80071b:	c9                   	leave  
  80071c:	c3                   	ret    

0080071d <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  80071d:	55                   	push   %ebp
  80071e:	89 e5                	mov    %esp,%ebp
  800720:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  800723:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800726:	b8 56 55 55 55       	mov    $0x55555556,%eax
  80072b:	f7 e9                	imul   %ecx
  80072d:	c1 f9 1f             	sar    $0x1f,%ecx
  800730:	89 d0                	mov    %edx,%eax
  800732:	29 c8                	sub    %ecx,%eax
  800734:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  800737:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80073e:	eb 1e                	jmp    80075e <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  800740:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800743:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80074a:	8b 45 08             	mov    0x8(%ebp),%eax
  80074d:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800750:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800753:	99                   	cltd   
  800754:	f7 7d f8             	idivl  -0x8(%ebp)
  800757:	89 d0                	mov    %edx,%eax
  800759:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  80075b:	ff 45 fc             	incl   -0x4(%ebp)
  80075e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800761:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800764:	7c da                	jl     800740 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//cprintf("Elements[%d] = %d\n",i, Elements[i]);
	}

}
  800766:	90                   	nop
  800767:	c9                   	leave  
  800768:	c3                   	ret    

00800769 <ArrayStats>:

void ArrayStats(int *Elements, int NumOfElements, int64 *mean, int64 *var)
{
  800769:	55                   	push   %ebp
  80076a:	89 e5                	mov    %esp,%ebp
  80076c:	57                   	push   %edi
  80076d:	56                   	push   %esi
  80076e:	53                   	push   %ebx
  80076f:	83 ec 2c             	sub    $0x2c,%esp
	int i ;
	*mean =0 ;
  800772:	8b 45 10             	mov    0x10(%ebp),%eax
  800775:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80077b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  800782:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800789:	eb 29                	jmp    8007b4 <ArrayStats+0x4b>
	{
		*mean += Elements[i];
  80078b:	8b 45 10             	mov    0x10(%ebp),%eax
  80078e:	8b 08                	mov    (%eax),%ecx
  800790:	8b 58 04             	mov    0x4(%eax),%ebx
  800793:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800796:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80079d:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a0:	01 d0                	add    %edx,%eax
  8007a2:	8b 00                	mov    (%eax),%eax
  8007a4:	99                   	cltd   
  8007a5:	01 c8                	add    %ecx,%eax
  8007a7:	11 da                	adc    %ebx,%edx
  8007a9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8007ac:	89 01                	mov    %eax,(%ecx)
  8007ae:	89 51 04             	mov    %edx,0x4(%ecx)

void ArrayStats(int *Elements, int NumOfElements, int64 *mean, int64 *var)
{
	int i ;
	*mean =0 ;
	for (i = 0 ; i < NumOfElements ; i++)
  8007b1:	ff 45 e4             	incl   -0x1c(%ebp)
  8007b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007b7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8007ba:	7c cf                	jl     80078b <ArrayStats+0x22>
	{
		*mean += Elements[i];
	}
	*mean /= NumOfElements;
  8007bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8007bf:	8b 50 04             	mov    0x4(%eax),%edx
  8007c2:	8b 00                	mov    (%eax),%eax
  8007c4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007c7:	89 cb                	mov    %ecx,%ebx
  8007c9:	c1 fb 1f             	sar    $0x1f,%ebx
  8007cc:	53                   	push   %ebx
  8007cd:	51                   	push   %ecx
  8007ce:	52                   	push   %edx
  8007cf:	50                   	push   %eax
  8007d0:	e8 57 36 00 00       	call   803e2c <__divdi3>
  8007d5:	83 c4 10             	add    $0x10,%esp
  8007d8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8007db:	89 01                	mov    %eax,(%ecx)
  8007dd:	89 51 04             	mov    %edx,0x4(%ecx)
	*var = 0;
  8007e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8007e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  8007f0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8007f7:	eb 7e                	jmp    800877 <ArrayStats+0x10e>
	{
		*var += (int64) ((Elements[i] - *mean)*(Elements[i] - *mean));
  8007f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fc:	8b 50 04             	mov    0x4(%eax),%edx
  8007ff:	8b 00                	mov    (%eax),%eax
  800801:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800804:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800807:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80080a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800811:	8b 45 08             	mov    0x8(%ebp),%eax
  800814:	01 d0                	add    %edx,%eax
  800816:	8b 00                	mov    (%eax),%eax
  800818:	89 c1                	mov    %eax,%ecx
  80081a:	89 c3                	mov    %eax,%ebx
  80081c:	c1 fb 1f             	sar    $0x1f,%ebx
  80081f:	8b 45 10             	mov    0x10(%ebp),%eax
  800822:	8b 50 04             	mov    0x4(%eax),%edx
  800825:	8b 00                	mov    (%eax),%eax
  800827:	29 c1                	sub    %eax,%ecx
  800829:	19 d3                	sbb    %edx,%ebx
  80082b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80082e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800835:	8b 45 08             	mov    0x8(%ebp),%eax
  800838:	01 d0                	add    %edx,%eax
  80083a:	8b 00                	mov    (%eax),%eax
  80083c:	89 c6                	mov    %eax,%esi
  80083e:	89 c7                	mov    %eax,%edi
  800840:	c1 ff 1f             	sar    $0x1f,%edi
  800843:	8b 45 10             	mov    0x10(%ebp),%eax
  800846:	8b 50 04             	mov    0x4(%eax),%edx
  800849:	8b 00                	mov    (%eax),%eax
  80084b:	29 c6                	sub    %eax,%esi
  80084d:	19 d7                	sbb    %edx,%edi
  80084f:	89 f0                	mov    %esi,%eax
  800851:	89 fa                	mov    %edi,%edx
  800853:	89 df                	mov    %ebx,%edi
  800855:	0f af f8             	imul   %eax,%edi
  800858:	89 d6                	mov    %edx,%esi
  80085a:	0f af f1             	imul   %ecx,%esi
  80085d:	01 fe                	add    %edi,%esi
  80085f:	f7 e1                	mul    %ecx
  800861:	8d 0c 16             	lea    (%esi,%edx,1),%ecx
  800864:	89 ca                	mov    %ecx,%edx
  800866:	03 45 d0             	add    -0x30(%ebp),%eax
  800869:	13 55 d4             	adc    -0x2c(%ebp),%edx
  80086c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80086f:	89 01                	mov    %eax,(%ecx)
  800871:	89 51 04             	mov    %edx,0x4(%ecx)
	{
		*mean += Elements[i];
	}
	*mean /= NumOfElements;
	*var = 0;
	for (i = 0 ; i < NumOfElements ; i++)
  800874:	ff 45 e4             	incl   -0x1c(%ebp)
  800877:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80087a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80087d:	0f 8c 76 ff ff ff    	jl     8007f9 <ArrayStats+0x90>
	{
		*var += (int64) ((Elements[i] - *mean)*(Elements[i] - *mean));
//		if (i%1000 == 0)
//			cprintf("current #elements = %d, current var = %lld\n", i , *var);
	}
	*var /= NumOfElements;
  800883:	8b 45 14             	mov    0x14(%ebp),%eax
  800886:	8b 50 04             	mov    0x4(%eax),%edx
  800889:	8b 00                	mov    (%eax),%eax
  80088b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80088e:	89 cb                	mov    %ecx,%ebx
  800890:	c1 fb 1f             	sar    $0x1f,%ebx
  800893:	53                   	push   %ebx
  800894:	51                   	push   %ecx
  800895:	52                   	push   %edx
  800896:	50                   	push   %eax
  800897:	e8 90 35 00 00       	call   803e2c <__divdi3>
  80089c:	83 c4 10             	add    $0x10,%esp
  80089f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8008a2:	89 01                	mov    %eax,(%ecx)
  8008a4:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8008a7:	90                   	nop
  8008a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008ab:	5b                   	pop    %ebx
  8008ac:	5e                   	pop    %esi
  8008ad:	5f                   	pop    %edi
  8008ae:	5d                   	pop    %ebp
  8008af:	c3                   	ret    

008008b0 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8008b0:	55                   	push   %ebp
  8008b1:	89 e5                	mov    %esp,%ebp
  8008b3:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8008b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b9:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8008bc:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8008c0:	83 ec 0c             	sub    $0xc,%esp
  8008c3:	50                   	push   %eax
  8008c4:	e8 4a 1c 00 00       	call   802513 <sys_cputc>
  8008c9:	83 c4 10             	add    $0x10,%esp
}
  8008cc:	90                   	nop
  8008cd:	c9                   	leave  
  8008ce:	c3                   	ret    

008008cf <getchar>:


int
getchar(void)
{
  8008cf:	55                   	push   %ebp
  8008d0:	89 e5                	mov    %esp,%ebp
  8008d2:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  8008d5:	e8 d5 1a 00 00       	call   8023af <sys_cgetc>
  8008da:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  8008dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8008e0:	c9                   	leave  
  8008e1:	c3                   	ret    

008008e2 <iscons>:

int iscons(int fdnum)
{
  8008e2:	55                   	push   %ebp
  8008e3:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8008e5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8008ea:	5d                   	pop    %ebp
  8008eb:	c3                   	ret    

008008ec <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8008ec:	55                   	push   %ebp
  8008ed:	89 e5                	mov    %esp,%ebp
  8008ef:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8008f2:	e8 4d 1d 00 00       	call   802644 <sys_getenvindex>
  8008f7:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8008fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008fd:	89 d0                	mov    %edx,%eax
  8008ff:	c1 e0 02             	shl    $0x2,%eax
  800902:	01 d0                	add    %edx,%eax
  800904:	c1 e0 03             	shl    $0x3,%eax
  800907:	01 d0                	add    %edx,%eax
  800909:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800910:	01 d0                	add    %edx,%eax
  800912:	c1 e0 02             	shl    $0x2,%eax
  800915:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80091a:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80091f:	a1 20 50 80 00       	mov    0x805020,%eax
  800924:	8a 40 20             	mov    0x20(%eax),%al
  800927:	84 c0                	test   %al,%al
  800929:	74 0d                	je     800938 <libmain+0x4c>
		binaryname = myEnv->prog_name;
  80092b:	a1 20 50 80 00       	mov    0x805020,%eax
  800930:	83 c0 20             	add    $0x20,%eax
  800933:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800938:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80093c:	7e 0a                	jle    800948 <libmain+0x5c>
		binaryname = argv[0];
  80093e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800941:	8b 00                	mov    (%eax),%eax
  800943:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  800948:	83 ec 08             	sub    $0x8,%esp
  80094b:	ff 75 0c             	pushl  0xc(%ebp)
  80094e:	ff 75 08             	pushl  0x8(%ebp)
  800951:	e8 e2 f6 ff ff       	call   800038 <_main>
  800956:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800959:	a1 00 50 80 00       	mov    0x805000,%eax
  80095e:	85 c0                	test   %eax,%eax
  800960:	0f 84 9f 00 00 00    	je     800a05 <libmain+0x119>
	{
		sys_lock_cons();
  800966:	e8 5d 1a 00 00       	call   8023c8 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80096b:	83 ec 0c             	sub    $0xc,%esp
  80096e:	68 ac 44 80 00       	push   $0x8044ac
  800973:	e8 76 03 00 00       	call   800cee <cprintf>
  800978:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80097b:	a1 20 50 80 00       	mov    0x805020,%eax
  800980:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800986:	a1 20 50 80 00       	mov    0x805020,%eax
  80098b:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800991:	83 ec 04             	sub    $0x4,%esp
  800994:	52                   	push   %edx
  800995:	50                   	push   %eax
  800996:	68 d4 44 80 00       	push   $0x8044d4
  80099b:	e8 4e 03 00 00       	call   800cee <cprintf>
  8009a0:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8009a3:	a1 20 50 80 00       	mov    0x805020,%eax
  8009a8:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8009ae:	a1 20 50 80 00       	mov    0x805020,%eax
  8009b3:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8009b9:	a1 20 50 80 00       	mov    0x805020,%eax
  8009be:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  8009c4:	51                   	push   %ecx
  8009c5:	52                   	push   %edx
  8009c6:	50                   	push   %eax
  8009c7:	68 fc 44 80 00       	push   $0x8044fc
  8009cc:	e8 1d 03 00 00       	call   800cee <cprintf>
  8009d1:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8009d4:	a1 20 50 80 00       	mov    0x805020,%eax
  8009d9:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8009df:	83 ec 08             	sub    $0x8,%esp
  8009e2:	50                   	push   %eax
  8009e3:	68 54 45 80 00       	push   $0x804554
  8009e8:	e8 01 03 00 00       	call   800cee <cprintf>
  8009ed:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8009f0:	83 ec 0c             	sub    $0xc,%esp
  8009f3:	68 ac 44 80 00       	push   $0x8044ac
  8009f8:	e8 f1 02 00 00       	call   800cee <cprintf>
  8009fd:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800a00:	e8 dd 19 00 00       	call   8023e2 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800a05:	e8 19 00 00 00       	call   800a23 <exit>
}
  800a0a:	90                   	nop
  800a0b:	c9                   	leave  
  800a0c:	c3                   	ret    

00800a0d <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800a0d:	55                   	push   %ebp
  800a0e:	89 e5                	mov    %esp,%ebp
  800a10:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800a13:	83 ec 0c             	sub    $0xc,%esp
  800a16:	6a 00                	push   $0x0
  800a18:	e8 f3 1b 00 00       	call   802610 <sys_destroy_env>
  800a1d:	83 c4 10             	add    $0x10,%esp
}
  800a20:	90                   	nop
  800a21:	c9                   	leave  
  800a22:	c3                   	ret    

00800a23 <exit>:

void
exit(void)
{
  800a23:	55                   	push   %ebp
  800a24:	89 e5                	mov    %esp,%ebp
  800a26:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800a29:	e8 48 1c 00 00       	call   802676 <sys_exit_env>
}
  800a2e:	90                   	nop
  800a2f:	c9                   	leave  
  800a30:	c3                   	ret    

00800a31 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800a31:	55                   	push   %ebp
  800a32:	89 e5                	mov    %esp,%ebp
  800a34:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800a37:	8d 45 10             	lea    0x10(%ebp),%eax
  800a3a:	83 c0 04             	add    $0x4,%eax
  800a3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800a40:	a1 60 50 98 00       	mov    0x985060,%eax
  800a45:	85 c0                	test   %eax,%eax
  800a47:	74 16                	je     800a5f <_panic+0x2e>
		cprintf("%s: ", argv0);
  800a49:	a1 60 50 98 00       	mov    0x985060,%eax
  800a4e:	83 ec 08             	sub    $0x8,%esp
  800a51:	50                   	push   %eax
  800a52:	68 68 45 80 00       	push   $0x804568
  800a57:	e8 92 02 00 00       	call   800cee <cprintf>
  800a5c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800a5f:	a1 04 50 80 00       	mov    0x805004,%eax
  800a64:	ff 75 0c             	pushl  0xc(%ebp)
  800a67:	ff 75 08             	pushl  0x8(%ebp)
  800a6a:	50                   	push   %eax
  800a6b:	68 6d 45 80 00       	push   $0x80456d
  800a70:	e8 79 02 00 00       	call   800cee <cprintf>
  800a75:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800a78:	8b 45 10             	mov    0x10(%ebp),%eax
  800a7b:	83 ec 08             	sub    $0x8,%esp
  800a7e:	ff 75 f4             	pushl  -0xc(%ebp)
  800a81:	50                   	push   %eax
  800a82:	e8 fc 01 00 00       	call   800c83 <vcprintf>
  800a87:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800a8a:	83 ec 08             	sub    $0x8,%esp
  800a8d:	6a 00                	push   $0x0
  800a8f:	68 89 45 80 00       	push   $0x804589
  800a94:	e8 ea 01 00 00       	call   800c83 <vcprintf>
  800a99:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800a9c:	e8 82 ff ff ff       	call   800a23 <exit>

	// should not return here
	while (1) ;
  800aa1:	eb fe                	jmp    800aa1 <_panic+0x70>

00800aa3 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800aa3:	55                   	push   %ebp
  800aa4:	89 e5                	mov    %esp,%ebp
  800aa6:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800aa9:	a1 20 50 80 00       	mov    0x805020,%eax
  800aae:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800ab4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab7:	39 c2                	cmp    %eax,%edx
  800ab9:	74 14                	je     800acf <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800abb:	83 ec 04             	sub    $0x4,%esp
  800abe:	68 8c 45 80 00       	push   $0x80458c
  800ac3:	6a 26                	push   $0x26
  800ac5:	68 d8 45 80 00       	push   $0x8045d8
  800aca:	e8 62 ff ff ff       	call   800a31 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800acf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800ad6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800add:	e9 c5 00 00 00       	jmp    800ba7 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800ae2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ae5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800aec:	8b 45 08             	mov    0x8(%ebp),%eax
  800aef:	01 d0                	add    %edx,%eax
  800af1:	8b 00                	mov    (%eax),%eax
  800af3:	85 c0                	test   %eax,%eax
  800af5:	75 08                	jne    800aff <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800af7:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800afa:	e9 a5 00 00 00       	jmp    800ba4 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800aff:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b06:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800b0d:	eb 69                	jmp    800b78 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800b0f:	a1 20 50 80 00       	mov    0x805020,%eax
  800b14:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800b1a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800b1d:	89 d0                	mov    %edx,%eax
  800b1f:	01 c0                	add    %eax,%eax
  800b21:	01 d0                	add    %edx,%eax
  800b23:	c1 e0 03             	shl    $0x3,%eax
  800b26:	01 c8                	add    %ecx,%eax
  800b28:	8a 40 04             	mov    0x4(%eax),%al
  800b2b:	84 c0                	test   %al,%al
  800b2d:	75 46                	jne    800b75 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800b2f:	a1 20 50 80 00       	mov    0x805020,%eax
  800b34:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800b3a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800b3d:	89 d0                	mov    %edx,%eax
  800b3f:	01 c0                	add    %eax,%eax
  800b41:	01 d0                	add    %edx,%eax
  800b43:	c1 e0 03             	shl    $0x3,%eax
  800b46:	01 c8                	add    %ecx,%eax
  800b48:	8b 00                	mov    (%eax),%eax
  800b4a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800b4d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800b50:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b55:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800b57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b5a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800b61:	8b 45 08             	mov    0x8(%ebp),%eax
  800b64:	01 c8                	add    %ecx,%eax
  800b66:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800b68:	39 c2                	cmp    %eax,%edx
  800b6a:	75 09                	jne    800b75 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800b6c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800b73:	eb 15                	jmp    800b8a <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b75:	ff 45 e8             	incl   -0x18(%ebp)
  800b78:	a1 20 50 80 00       	mov    0x805020,%eax
  800b7d:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800b83:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b86:	39 c2                	cmp    %eax,%edx
  800b88:	77 85                	ja     800b0f <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800b8a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800b8e:	75 14                	jne    800ba4 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800b90:	83 ec 04             	sub    $0x4,%esp
  800b93:	68 e4 45 80 00       	push   $0x8045e4
  800b98:	6a 3a                	push   $0x3a
  800b9a:	68 d8 45 80 00       	push   $0x8045d8
  800b9f:	e8 8d fe ff ff       	call   800a31 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800ba4:	ff 45 f0             	incl   -0x10(%ebp)
  800ba7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800baa:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800bad:	0f 8c 2f ff ff ff    	jl     800ae2 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800bb3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800bba:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800bc1:	eb 26                	jmp    800be9 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800bc3:	a1 20 50 80 00       	mov    0x805020,%eax
  800bc8:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800bce:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800bd1:	89 d0                	mov    %edx,%eax
  800bd3:	01 c0                	add    %eax,%eax
  800bd5:	01 d0                	add    %edx,%eax
  800bd7:	c1 e0 03             	shl    $0x3,%eax
  800bda:	01 c8                	add    %ecx,%eax
  800bdc:	8a 40 04             	mov    0x4(%eax),%al
  800bdf:	3c 01                	cmp    $0x1,%al
  800be1:	75 03                	jne    800be6 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800be3:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800be6:	ff 45 e0             	incl   -0x20(%ebp)
  800be9:	a1 20 50 80 00       	mov    0x805020,%eax
  800bee:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800bf4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800bf7:	39 c2                	cmp    %eax,%edx
  800bf9:	77 c8                	ja     800bc3 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800bfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bfe:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800c01:	74 14                	je     800c17 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800c03:	83 ec 04             	sub    $0x4,%esp
  800c06:	68 38 46 80 00       	push   $0x804638
  800c0b:	6a 44                	push   $0x44
  800c0d:	68 d8 45 80 00       	push   $0x8045d8
  800c12:	e8 1a fe ff ff       	call   800a31 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800c17:	90                   	nop
  800c18:	c9                   	leave  
  800c19:	c3                   	ret    

00800c1a <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800c1a:	55                   	push   %ebp
  800c1b:	89 e5                	mov    %esp,%ebp
  800c1d:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800c20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c23:	8b 00                	mov    (%eax),%eax
  800c25:	8d 48 01             	lea    0x1(%eax),%ecx
  800c28:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c2b:	89 0a                	mov    %ecx,(%edx)
  800c2d:	8b 55 08             	mov    0x8(%ebp),%edx
  800c30:	88 d1                	mov    %dl,%cl
  800c32:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c35:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800c39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3c:	8b 00                	mov    (%eax),%eax
  800c3e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800c43:	75 2c                	jne    800c71 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800c45:	a0 44 50 98 00       	mov    0x985044,%al
  800c4a:	0f b6 c0             	movzbl %al,%eax
  800c4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c50:	8b 12                	mov    (%edx),%edx
  800c52:	89 d1                	mov    %edx,%ecx
  800c54:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c57:	83 c2 08             	add    $0x8,%edx
  800c5a:	83 ec 04             	sub    $0x4,%esp
  800c5d:	50                   	push   %eax
  800c5e:	51                   	push   %ecx
  800c5f:	52                   	push   %edx
  800c60:	e8 21 17 00 00       	call   802386 <sys_cputs>
  800c65:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800c68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800c71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c74:	8b 40 04             	mov    0x4(%eax),%eax
  800c77:	8d 50 01             	lea    0x1(%eax),%edx
  800c7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7d:	89 50 04             	mov    %edx,0x4(%eax)
}
  800c80:	90                   	nop
  800c81:	c9                   	leave  
  800c82:	c3                   	ret    

00800c83 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800c83:	55                   	push   %ebp
  800c84:	89 e5                	mov    %esp,%ebp
  800c86:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800c8c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800c93:	00 00 00 
	b.cnt = 0;
  800c96:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800c9d:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800ca0:	ff 75 0c             	pushl  0xc(%ebp)
  800ca3:	ff 75 08             	pushl  0x8(%ebp)
  800ca6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800cac:	50                   	push   %eax
  800cad:	68 1a 0c 80 00       	push   $0x800c1a
  800cb2:	e8 11 02 00 00       	call   800ec8 <vprintfmt>
  800cb7:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800cba:	a0 44 50 98 00       	mov    0x985044,%al
  800cbf:	0f b6 c0             	movzbl %al,%eax
  800cc2:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800cc8:	83 ec 04             	sub    $0x4,%esp
  800ccb:	50                   	push   %eax
  800ccc:	52                   	push   %edx
  800ccd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800cd3:	83 c0 08             	add    $0x8,%eax
  800cd6:	50                   	push   %eax
  800cd7:	e8 aa 16 00 00       	call   802386 <sys_cputs>
  800cdc:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800cdf:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
	return b.cnt;
  800ce6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800cec:	c9                   	leave  
  800ced:	c3                   	ret    

00800cee <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800cee:	55                   	push   %ebp
  800cef:	89 e5                	mov    %esp,%ebp
  800cf1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800cf4:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
	va_start(ap, fmt);
  800cfb:	8d 45 0c             	lea    0xc(%ebp),%eax
  800cfe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800d01:	8b 45 08             	mov    0x8(%ebp),%eax
  800d04:	83 ec 08             	sub    $0x8,%esp
  800d07:	ff 75 f4             	pushl  -0xc(%ebp)
  800d0a:	50                   	push   %eax
  800d0b:	e8 73 ff ff ff       	call   800c83 <vcprintf>
  800d10:	83 c4 10             	add    $0x10,%esp
  800d13:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800d16:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d19:	c9                   	leave  
  800d1a:	c3                   	ret    

00800d1b <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800d1b:	55                   	push   %ebp
  800d1c:	89 e5                	mov    %esp,%ebp
  800d1e:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800d21:	e8 a2 16 00 00       	call   8023c8 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800d26:	8d 45 0c             	lea    0xc(%ebp),%eax
  800d29:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2f:	83 ec 08             	sub    $0x8,%esp
  800d32:	ff 75 f4             	pushl  -0xc(%ebp)
  800d35:	50                   	push   %eax
  800d36:	e8 48 ff ff ff       	call   800c83 <vcprintf>
  800d3b:	83 c4 10             	add    $0x10,%esp
  800d3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800d41:	e8 9c 16 00 00       	call   8023e2 <sys_unlock_cons>
	return cnt;
  800d46:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d49:	c9                   	leave  
  800d4a:	c3                   	ret    

00800d4b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800d4b:	55                   	push   %ebp
  800d4c:	89 e5                	mov    %esp,%ebp
  800d4e:	53                   	push   %ebx
  800d4f:	83 ec 14             	sub    $0x14,%esp
  800d52:	8b 45 10             	mov    0x10(%ebp),%eax
  800d55:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d58:	8b 45 14             	mov    0x14(%ebp),%eax
  800d5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800d5e:	8b 45 18             	mov    0x18(%ebp),%eax
  800d61:	ba 00 00 00 00       	mov    $0x0,%edx
  800d66:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800d69:	77 55                	ja     800dc0 <printnum+0x75>
  800d6b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800d6e:	72 05                	jb     800d75 <printnum+0x2a>
  800d70:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800d73:	77 4b                	ja     800dc0 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800d75:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800d78:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800d7b:	8b 45 18             	mov    0x18(%ebp),%eax
  800d7e:	ba 00 00 00 00       	mov    $0x0,%edx
  800d83:	52                   	push   %edx
  800d84:	50                   	push   %eax
  800d85:	ff 75 f4             	pushl  -0xc(%ebp)
  800d88:	ff 75 f0             	pushl  -0x10(%ebp)
  800d8b:	e8 04 32 00 00       	call   803f94 <__udivdi3>
  800d90:	83 c4 10             	add    $0x10,%esp
  800d93:	83 ec 04             	sub    $0x4,%esp
  800d96:	ff 75 20             	pushl  0x20(%ebp)
  800d99:	53                   	push   %ebx
  800d9a:	ff 75 18             	pushl  0x18(%ebp)
  800d9d:	52                   	push   %edx
  800d9e:	50                   	push   %eax
  800d9f:	ff 75 0c             	pushl  0xc(%ebp)
  800da2:	ff 75 08             	pushl  0x8(%ebp)
  800da5:	e8 a1 ff ff ff       	call   800d4b <printnum>
  800daa:	83 c4 20             	add    $0x20,%esp
  800dad:	eb 1a                	jmp    800dc9 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800daf:	83 ec 08             	sub    $0x8,%esp
  800db2:	ff 75 0c             	pushl  0xc(%ebp)
  800db5:	ff 75 20             	pushl  0x20(%ebp)
  800db8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbb:	ff d0                	call   *%eax
  800dbd:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800dc0:	ff 4d 1c             	decl   0x1c(%ebp)
  800dc3:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800dc7:	7f e6                	jg     800daf <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800dc9:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800dcc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dd4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dd7:	53                   	push   %ebx
  800dd8:	51                   	push   %ecx
  800dd9:	52                   	push   %edx
  800dda:	50                   	push   %eax
  800ddb:	e8 c4 32 00 00       	call   8040a4 <__umoddi3>
  800de0:	83 c4 10             	add    $0x10,%esp
  800de3:	05 b4 48 80 00       	add    $0x8048b4,%eax
  800de8:	8a 00                	mov    (%eax),%al
  800dea:	0f be c0             	movsbl %al,%eax
  800ded:	83 ec 08             	sub    $0x8,%esp
  800df0:	ff 75 0c             	pushl  0xc(%ebp)
  800df3:	50                   	push   %eax
  800df4:	8b 45 08             	mov    0x8(%ebp),%eax
  800df7:	ff d0                	call   *%eax
  800df9:	83 c4 10             	add    $0x10,%esp
}
  800dfc:	90                   	nop
  800dfd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e00:	c9                   	leave  
  800e01:	c3                   	ret    

00800e02 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800e02:	55                   	push   %ebp
  800e03:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800e05:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800e09:	7e 1c                	jle    800e27 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0e:	8b 00                	mov    (%eax),%eax
  800e10:	8d 50 08             	lea    0x8(%eax),%edx
  800e13:	8b 45 08             	mov    0x8(%ebp),%eax
  800e16:	89 10                	mov    %edx,(%eax)
  800e18:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1b:	8b 00                	mov    (%eax),%eax
  800e1d:	83 e8 08             	sub    $0x8,%eax
  800e20:	8b 50 04             	mov    0x4(%eax),%edx
  800e23:	8b 00                	mov    (%eax),%eax
  800e25:	eb 40                	jmp    800e67 <getuint+0x65>
	else if (lflag)
  800e27:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e2b:	74 1e                	je     800e4b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e30:	8b 00                	mov    (%eax),%eax
  800e32:	8d 50 04             	lea    0x4(%eax),%edx
  800e35:	8b 45 08             	mov    0x8(%ebp),%eax
  800e38:	89 10                	mov    %edx,(%eax)
  800e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3d:	8b 00                	mov    (%eax),%eax
  800e3f:	83 e8 04             	sub    $0x4,%eax
  800e42:	8b 00                	mov    (%eax),%eax
  800e44:	ba 00 00 00 00       	mov    $0x0,%edx
  800e49:	eb 1c                	jmp    800e67 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4e:	8b 00                	mov    (%eax),%eax
  800e50:	8d 50 04             	lea    0x4(%eax),%edx
  800e53:	8b 45 08             	mov    0x8(%ebp),%eax
  800e56:	89 10                	mov    %edx,(%eax)
  800e58:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5b:	8b 00                	mov    (%eax),%eax
  800e5d:	83 e8 04             	sub    $0x4,%eax
  800e60:	8b 00                	mov    (%eax),%eax
  800e62:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800e67:	5d                   	pop    %ebp
  800e68:	c3                   	ret    

00800e69 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800e69:	55                   	push   %ebp
  800e6a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800e6c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800e70:	7e 1c                	jle    800e8e <getint+0x25>
		return va_arg(*ap, long long);
  800e72:	8b 45 08             	mov    0x8(%ebp),%eax
  800e75:	8b 00                	mov    (%eax),%eax
  800e77:	8d 50 08             	lea    0x8(%eax),%edx
  800e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7d:	89 10                	mov    %edx,(%eax)
  800e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e82:	8b 00                	mov    (%eax),%eax
  800e84:	83 e8 08             	sub    $0x8,%eax
  800e87:	8b 50 04             	mov    0x4(%eax),%edx
  800e8a:	8b 00                	mov    (%eax),%eax
  800e8c:	eb 38                	jmp    800ec6 <getint+0x5d>
	else if (lflag)
  800e8e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e92:	74 1a                	je     800eae <getint+0x45>
		return va_arg(*ap, long);
  800e94:	8b 45 08             	mov    0x8(%ebp),%eax
  800e97:	8b 00                	mov    (%eax),%eax
  800e99:	8d 50 04             	lea    0x4(%eax),%edx
  800e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9f:	89 10                	mov    %edx,(%eax)
  800ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea4:	8b 00                	mov    (%eax),%eax
  800ea6:	83 e8 04             	sub    $0x4,%eax
  800ea9:	8b 00                	mov    (%eax),%eax
  800eab:	99                   	cltd   
  800eac:	eb 18                	jmp    800ec6 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800eae:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb1:	8b 00                	mov    (%eax),%eax
  800eb3:	8d 50 04             	lea    0x4(%eax),%edx
  800eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb9:	89 10                	mov    %edx,(%eax)
  800ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebe:	8b 00                	mov    (%eax),%eax
  800ec0:	83 e8 04             	sub    $0x4,%eax
  800ec3:	8b 00                	mov    (%eax),%eax
  800ec5:	99                   	cltd   
}
  800ec6:	5d                   	pop    %ebp
  800ec7:	c3                   	ret    

00800ec8 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800ec8:	55                   	push   %ebp
  800ec9:	89 e5                	mov    %esp,%ebp
  800ecb:	56                   	push   %esi
  800ecc:	53                   	push   %ebx
  800ecd:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ed0:	eb 17                	jmp    800ee9 <vprintfmt+0x21>
			if (ch == '\0')
  800ed2:	85 db                	test   %ebx,%ebx
  800ed4:	0f 84 c1 03 00 00    	je     80129b <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800eda:	83 ec 08             	sub    $0x8,%esp
  800edd:	ff 75 0c             	pushl  0xc(%ebp)
  800ee0:	53                   	push   %ebx
  800ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee4:	ff d0                	call   *%eax
  800ee6:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ee9:	8b 45 10             	mov    0x10(%ebp),%eax
  800eec:	8d 50 01             	lea    0x1(%eax),%edx
  800eef:	89 55 10             	mov    %edx,0x10(%ebp)
  800ef2:	8a 00                	mov    (%eax),%al
  800ef4:	0f b6 d8             	movzbl %al,%ebx
  800ef7:	83 fb 25             	cmp    $0x25,%ebx
  800efa:	75 d6                	jne    800ed2 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800efc:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800f00:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800f07:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800f0e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800f15:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800f1c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1f:	8d 50 01             	lea    0x1(%eax),%edx
  800f22:	89 55 10             	mov    %edx,0x10(%ebp)
  800f25:	8a 00                	mov    (%eax),%al
  800f27:	0f b6 d8             	movzbl %al,%ebx
  800f2a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800f2d:	83 f8 5b             	cmp    $0x5b,%eax
  800f30:	0f 87 3d 03 00 00    	ja     801273 <vprintfmt+0x3ab>
  800f36:	8b 04 85 d8 48 80 00 	mov    0x8048d8(,%eax,4),%eax
  800f3d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800f3f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800f43:	eb d7                	jmp    800f1c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800f45:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800f49:	eb d1                	jmp    800f1c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800f4b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800f52:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800f55:	89 d0                	mov    %edx,%eax
  800f57:	c1 e0 02             	shl    $0x2,%eax
  800f5a:	01 d0                	add    %edx,%eax
  800f5c:	01 c0                	add    %eax,%eax
  800f5e:	01 d8                	add    %ebx,%eax
  800f60:	83 e8 30             	sub    $0x30,%eax
  800f63:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800f66:	8b 45 10             	mov    0x10(%ebp),%eax
  800f69:	8a 00                	mov    (%eax),%al
  800f6b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800f6e:	83 fb 2f             	cmp    $0x2f,%ebx
  800f71:	7e 3e                	jle    800fb1 <vprintfmt+0xe9>
  800f73:	83 fb 39             	cmp    $0x39,%ebx
  800f76:	7f 39                	jg     800fb1 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800f78:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800f7b:	eb d5                	jmp    800f52 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800f7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800f80:	83 c0 04             	add    $0x4,%eax
  800f83:	89 45 14             	mov    %eax,0x14(%ebp)
  800f86:	8b 45 14             	mov    0x14(%ebp),%eax
  800f89:	83 e8 04             	sub    $0x4,%eax
  800f8c:	8b 00                	mov    (%eax),%eax
  800f8e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800f91:	eb 1f                	jmp    800fb2 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800f93:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f97:	79 83                	jns    800f1c <vprintfmt+0x54>
				width = 0;
  800f99:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800fa0:	e9 77 ff ff ff       	jmp    800f1c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800fa5:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800fac:	e9 6b ff ff ff       	jmp    800f1c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800fb1:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800fb2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fb6:	0f 89 60 ff ff ff    	jns    800f1c <vprintfmt+0x54>
				width = precision, precision = -1;
  800fbc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fbf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800fc2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800fc9:	e9 4e ff ff ff       	jmp    800f1c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800fce:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800fd1:	e9 46 ff ff ff       	jmp    800f1c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800fd6:	8b 45 14             	mov    0x14(%ebp),%eax
  800fd9:	83 c0 04             	add    $0x4,%eax
  800fdc:	89 45 14             	mov    %eax,0x14(%ebp)
  800fdf:	8b 45 14             	mov    0x14(%ebp),%eax
  800fe2:	83 e8 04             	sub    $0x4,%eax
  800fe5:	8b 00                	mov    (%eax),%eax
  800fe7:	83 ec 08             	sub    $0x8,%esp
  800fea:	ff 75 0c             	pushl  0xc(%ebp)
  800fed:	50                   	push   %eax
  800fee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff1:	ff d0                	call   *%eax
  800ff3:	83 c4 10             	add    $0x10,%esp
			break;
  800ff6:	e9 9b 02 00 00       	jmp    801296 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ffb:	8b 45 14             	mov    0x14(%ebp),%eax
  800ffe:	83 c0 04             	add    $0x4,%eax
  801001:	89 45 14             	mov    %eax,0x14(%ebp)
  801004:	8b 45 14             	mov    0x14(%ebp),%eax
  801007:	83 e8 04             	sub    $0x4,%eax
  80100a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80100c:	85 db                	test   %ebx,%ebx
  80100e:	79 02                	jns    801012 <vprintfmt+0x14a>
				err = -err;
  801010:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801012:	83 fb 64             	cmp    $0x64,%ebx
  801015:	7f 0b                	jg     801022 <vprintfmt+0x15a>
  801017:	8b 34 9d 20 47 80 00 	mov    0x804720(,%ebx,4),%esi
  80101e:	85 f6                	test   %esi,%esi
  801020:	75 19                	jne    80103b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801022:	53                   	push   %ebx
  801023:	68 c5 48 80 00       	push   $0x8048c5
  801028:	ff 75 0c             	pushl  0xc(%ebp)
  80102b:	ff 75 08             	pushl  0x8(%ebp)
  80102e:	e8 70 02 00 00       	call   8012a3 <printfmt>
  801033:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801036:	e9 5b 02 00 00       	jmp    801296 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80103b:	56                   	push   %esi
  80103c:	68 ce 48 80 00       	push   $0x8048ce
  801041:	ff 75 0c             	pushl  0xc(%ebp)
  801044:	ff 75 08             	pushl  0x8(%ebp)
  801047:	e8 57 02 00 00       	call   8012a3 <printfmt>
  80104c:	83 c4 10             	add    $0x10,%esp
			break;
  80104f:	e9 42 02 00 00       	jmp    801296 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801054:	8b 45 14             	mov    0x14(%ebp),%eax
  801057:	83 c0 04             	add    $0x4,%eax
  80105a:	89 45 14             	mov    %eax,0x14(%ebp)
  80105d:	8b 45 14             	mov    0x14(%ebp),%eax
  801060:	83 e8 04             	sub    $0x4,%eax
  801063:	8b 30                	mov    (%eax),%esi
  801065:	85 f6                	test   %esi,%esi
  801067:	75 05                	jne    80106e <vprintfmt+0x1a6>
				p = "(null)";
  801069:	be d1 48 80 00       	mov    $0x8048d1,%esi
			if (width > 0 && padc != '-')
  80106e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801072:	7e 6d                	jle    8010e1 <vprintfmt+0x219>
  801074:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801078:	74 67                	je     8010e1 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80107a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80107d:	83 ec 08             	sub    $0x8,%esp
  801080:	50                   	push   %eax
  801081:	56                   	push   %esi
  801082:	e8 26 05 00 00       	call   8015ad <strnlen>
  801087:	83 c4 10             	add    $0x10,%esp
  80108a:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80108d:	eb 16                	jmp    8010a5 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80108f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801093:	83 ec 08             	sub    $0x8,%esp
  801096:	ff 75 0c             	pushl  0xc(%ebp)
  801099:	50                   	push   %eax
  80109a:	8b 45 08             	mov    0x8(%ebp),%eax
  80109d:	ff d0                	call   *%eax
  80109f:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8010a2:	ff 4d e4             	decl   -0x1c(%ebp)
  8010a5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8010a9:	7f e4                	jg     80108f <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8010ab:	eb 34                	jmp    8010e1 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8010ad:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8010b1:	74 1c                	je     8010cf <vprintfmt+0x207>
  8010b3:	83 fb 1f             	cmp    $0x1f,%ebx
  8010b6:	7e 05                	jle    8010bd <vprintfmt+0x1f5>
  8010b8:	83 fb 7e             	cmp    $0x7e,%ebx
  8010bb:	7e 12                	jle    8010cf <vprintfmt+0x207>
					putch('?', putdat);
  8010bd:	83 ec 08             	sub    $0x8,%esp
  8010c0:	ff 75 0c             	pushl  0xc(%ebp)
  8010c3:	6a 3f                	push   $0x3f
  8010c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c8:	ff d0                	call   *%eax
  8010ca:	83 c4 10             	add    $0x10,%esp
  8010cd:	eb 0f                	jmp    8010de <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8010cf:	83 ec 08             	sub    $0x8,%esp
  8010d2:	ff 75 0c             	pushl  0xc(%ebp)
  8010d5:	53                   	push   %ebx
  8010d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d9:	ff d0                	call   *%eax
  8010db:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8010de:	ff 4d e4             	decl   -0x1c(%ebp)
  8010e1:	89 f0                	mov    %esi,%eax
  8010e3:	8d 70 01             	lea    0x1(%eax),%esi
  8010e6:	8a 00                	mov    (%eax),%al
  8010e8:	0f be d8             	movsbl %al,%ebx
  8010eb:	85 db                	test   %ebx,%ebx
  8010ed:	74 24                	je     801113 <vprintfmt+0x24b>
  8010ef:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8010f3:	78 b8                	js     8010ad <vprintfmt+0x1e5>
  8010f5:	ff 4d e0             	decl   -0x20(%ebp)
  8010f8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8010fc:	79 af                	jns    8010ad <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8010fe:	eb 13                	jmp    801113 <vprintfmt+0x24b>
				putch(' ', putdat);
  801100:	83 ec 08             	sub    $0x8,%esp
  801103:	ff 75 0c             	pushl  0xc(%ebp)
  801106:	6a 20                	push   $0x20
  801108:	8b 45 08             	mov    0x8(%ebp),%eax
  80110b:	ff d0                	call   *%eax
  80110d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801110:	ff 4d e4             	decl   -0x1c(%ebp)
  801113:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801117:	7f e7                	jg     801100 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801119:	e9 78 01 00 00       	jmp    801296 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80111e:	83 ec 08             	sub    $0x8,%esp
  801121:	ff 75 e8             	pushl  -0x18(%ebp)
  801124:	8d 45 14             	lea    0x14(%ebp),%eax
  801127:	50                   	push   %eax
  801128:	e8 3c fd ff ff       	call   800e69 <getint>
  80112d:	83 c4 10             	add    $0x10,%esp
  801130:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801133:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801136:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801139:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80113c:	85 d2                	test   %edx,%edx
  80113e:	79 23                	jns    801163 <vprintfmt+0x29b>
				putch('-', putdat);
  801140:	83 ec 08             	sub    $0x8,%esp
  801143:	ff 75 0c             	pushl  0xc(%ebp)
  801146:	6a 2d                	push   $0x2d
  801148:	8b 45 08             	mov    0x8(%ebp),%eax
  80114b:	ff d0                	call   *%eax
  80114d:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801150:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801153:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801156:	f7 d8                	neg    %eax
  801158:	83 d2 00             	adc    $0x0,%edx
  80115b:	f7 da                	neg    %edx
  80115d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801160:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801163:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80116a:	e9 bc 00 00 00       	jmp    80122b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80116f:	83 ec 08             	sub    $0x8,%esp
  801172:	ff 75 e8             	pushl  -0x18(%ebp)
  801175:	8d 45 14             	lea    0x14(%ebp),%eax
  801178:	50                   	push   %eax
  801179:	e8 84 fc ff ff       	call   800e02 <getuint>
  80117e:	83 c4 10             	add    $0x10,%esp
  801181:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801184:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801187:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80118e:	e9 98 00 00 00       	jmp    80122b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801193:	83 ec 08             	sub    $0x8,%esp
  801196:	ff 75 0c             	pushl  0xc(%ebp)
  801199:	6a 58                	push   $0x58
  80119b:	8b 45 08             	mov    0x8(%ebp),%eax
  80119e:	ff d0                	call   *%eax
  8011a0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8011a3:	83 ec 08             	sub    $0x8,%esp
  8011a6:	ff 75 0c             	pushl  0xc(%ebp)
  8011a9:	6a 58                	push   $0x58
  8011ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ae:	ff d0                	call   *%eax
  8011b0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8011b3:	83 ec 08             	sub    $0x8,%esp
  8011b6:	ff 75 0c             	pushl  0xc(%ebp)
  8011b9:	6a 58                	push   $0x58
  8011bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011be:	ff d0                	call   *%eax
  8011c0:	83 c4 10             	add    $0x10,%esp
			break;
  8011c3:	e9 ce 00 00 00       	jmp    801296 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8011c8:	83 ec 08             	sub    $0x8,%esp
  8011cb:	ff 75 0c             	pushl  0xc(%ebp)
  8011ce:	6a 30                	push   $0x30
  8011d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d3:	ff d0                	call   *%eax
  8011d5:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8011d8:	83 ec 08             	sub    $0x8,%esp
  8011db:	ff 75 0c             	pushl  0xc(%ebp)
  8011de:	6a 78                	push   $0x78
  8011e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e3:	ff d0                	call   *%eax
  8011e5:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8011e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8011eb:	83 c0 04             	add    $0x4,%eax
  8011ee:	89 45 14             	mov    %eax,0x14(%ebp)
  8011f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f4:	83 e8 04             	sub    $0x4,%eax
  8011f7:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8011f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011fc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801203:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80120a:	eb 1f                	jmp    80122b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80120c:	83 ec 08             	sub    $0x8,%esp
  80120f:	ff 75 e8             	pushl  -0x18(%ebp)
  801212:	8d 45 14             	lea    0x14(%ebp),%eax
  801215:	50                   	push   %eax
  801216:	e8 e7 fb ff ff       	call   800e02 <getuint>
  80121b:	83 c4 10             	add    $0x10,%esp
  80121e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801221:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801224:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80122b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80122f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801232:	83 ec 04             	sub    $0x4,%esp
  801235:	52                   	push   %edx
  801236:	ff 75 e4             	pushl  -0x1c(%ebp)
  801239:	50                   	push   %eax
  80123a:	ff 75 f4             	pushl  -0xc(%ebp)
  80123d:	ff 75 f0             	pushl  -0x10(%ebp)
  801240:	ff 75 0c             	pushl  0xc(%ebp)
  801243:	ff 75 08             	pushl  0x8(%ebp)
  801246:	e8 00 fb ff ff       	call   800d4b <printnum>
  80124b:	83 c4 20             	add    $0x20,%esp
			break;
  80124e:	eb 46                	jmp    801296 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801250:	83 ec 08             	sub    $0x8,%esp
  801253:	ff 75 0c             	pushl  0xc(%ebp)
  801256:	53                   	push   %ebx
  801257:	8b 45 08             	mov    0x8(%ebp),%eax
  80125a:	ff d0                	call   *%eax
  80125c:	83 c4 10             	add    $0x10,%esp
			break;
  80125f:	eb 35                	jmp    801296 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801261:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
			break;
  801268:	eb 2c                	jmp    801296 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80126a:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
			break;
  801271:	eb 23                	jmp    801296 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801273:	83 ec 08             	sub    $0x8,%esp
  801276:	ff 75 0c             	pushl  0xc(%ebp)
  801279:	6a 25                	push   $0x25
  80127b:	8b 45 08             	mov    0x8(%ebp),%eax
  80127e:	ff d0                	call   *%eax
  801280:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801283:	ff 4d 10             	decl   0x10(%ebp)
  801286:	eb 03                	jmp    80128b <vprintfmt+0x3c3>
  801288:	ff 4d 10             	decl   0x10(%ebp)
  80128b:	8b 45 10             	mov    0x10(%ebp),%eax
  80128e:	48                   	dec    %eax
  80128f:	8a 00                	mov    (%eax),%al
  801291:	3c 25                	cmp    $0x25,%al
  801293:	75 f3                	jne    801288 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801295:	90                   	nop
		}
	}
  801296:	e9 35 fc ff ff       	jmp    800ed0 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80129b:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80129c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80129f:	5b                   	pop    %ebx
  8012a0:	5e                   	pop    %esi
  8012a1:	5d                   	pop    %ebp
  8012a2:	c3                   	ret    

008012a3 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8012a3:	55                   	push   %ebp
  8012a4:	89 e5                	mov    %esp,%ebp
  8012a6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8012a9:	8d 45 10             	lea    0x10(%ebp),%eax
  8012ac:	83 c0 04             	add    $0x4,%eax
  8012af:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8012b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8012b8:	50                   	push   %eax
  8012b9:	ff 75 0c             	pushl  0xc(%ebp)
  8012bc:	ff 75 08             	pushl  0x8(%ebp)
  8012bf:	e8 04 fc ff ff       	call   800ec8 <vprintfmt>
  8012c4:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8012c7:	90                   	nop
  8012c8:	c9                   	leave  
  8012c9:	c3                   	ret    

008012ca <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8012ca:	55                   	push   %ebp
  8012cb:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8012cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d0:	8b 40 08             	mov    0x8(%eax),%eax
  8012d3:	8d 50 01             	lea    0x1(%eax),%edx
  8012d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d9:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8012dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012df:	8b 10                	mov    (%eax),%edx
  8012e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e4:	8b 40 04             	mov    0x4(%eax),%eax
  8012e7:	39 c2                	cmp    %eax,%edx
  8012e9:	73 12                	jae    8012fd <sprintputch+0x33>
		*b->buf++ = ch;
  8012eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ee:	8b 00                	mov    (%eax),%eax
  8012f0:	8d 48 01             	lea    0x1(%eax),%ecx
  8012f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012f6:	89 0a                	mov    %ecx,(%edx)
  8012f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8012fb:	88 10                	mov    %dl,(%eax)
}
  8012fd:	90                   	nop
  8012fe:	5d                   	pop    %ebp
  8012ff:	c3                   	ret    

00801300 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801300:	55                   	push   %ebp
  801301:	89 e5                	mov    %esp,%ebp
  801303:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801306:	8b 45 08             	mov    0x8(%ebp),%eax
  801309:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80130c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80130f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801312:	8b 45 08             	mov    0x8(%ebp),%eax
  801315:	01 d0                	add    %edx,%eax
  801317:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80131a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801321:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801325:	74 06                	je     80132d <vsnprintf+0x2d>
  801327:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80132b:	7f 07                	jg     801334 <vsnprintf+0x34>
		return -E_INVAL;
  80132d:	b8 03 00 00 00       	mov    $0x3,%eax
  801332:	eb 20                	jmp    801354 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801334:	ff 75 14             	pushl  0x14(%ebp)
  801337:	ff 75 10             	pushl  0x10(%ebp)
  80133a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80133d:	50                   	push   %eax
  80133e:	68 ca 12 80 00       	push   $0x8012ca
  801343:	e8 80 fb ff ff       	call   800ec8 <vprintfmt>
  801348:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80134b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80134e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801351:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801354:	c9                   	leave  
  801355:	c3                   	ret    

00801356 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801356:	55                   	push   %ebp
  801357:	89 e5                	mov    %esp,%ebp
  801359:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80135c:	8d 45 10             	lea    0x10(%ebp),%eax
  80135f:	83 c0 04             	add    $0x4,%eax
  801362:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801365:	8b 45 10             	mov    0x10(%ebp),%eax
  801368:	ff 75 f4             	pushl  -0xc(%ebp)
  80136b:	50                   	push   %eax
  80136c:	ff 75 0c             	pushl  0xc(%ebp)
  80136f:	ff 75 08             	pushl  0x8(%ebp)
  801372:	e8 89 ff ff ff       	call   801300 <vsnprintf>
  801377:	83 c4 10             	add    $0x10,%esp
  80137a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80137d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801380:	c9                   	leave  
  801381:	c3                   	ret    

00801382 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  801382:	55                   	push   %ebp
  801383:	89 e5                	mov    %esp,%ebp
  801385:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  801388:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80138c:	74 13                	je     8013a1 <readline+0x1f>
		cprintf("%s", prompt);
  80138e:	83 ec 08             	sub    $0x8,%esp
  801391:	ff 75 08             	pushl  0x8(%ebp)
  801394:	68 48 4a 80 00       	push   $0x804a48
  801399:	e8 50 f9 ff ff       	call   800cee <cprintf>
  80139e:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8013a1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8013a8:	83 ec 0c             	sub    $0xc,%esp
  8013ab:	6a 00                	push   $0x0
  8013ad:	e8 30 f5 ff ff       	call   8008e2 <iscons>
  8013b2:	83 c4 10             	add    $0x10,%esp
  8013b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8013b8:	e8 12 f5 ff ff       	call   8008cf <getchar>
  8013bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8013c0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8013c4:	79 22                	jns    8013e8 <readline+0x66>
			if (c != -E_EOF)
  8013c6:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8013ca:	0f 84 ad 00 00 00    	je     80147d <readline+0xfb>
				cprintf("read error: %e\n", c);
  8013d0:	83 ec 08             	sub    $0x8,%esp
  8013d3:	ff 75 ec             	pushl  -0x14(%ebp)
  8013d6:	68 4b 4a 80 00       	push   $0x804a4b
  8013db:	e8 0e f9 ff ff       	call   800cee <cprintf>
  8013e0:	83 c4 10             	add    $0x10,%esp
			break;
  8013e3:	e9 95 00 00 00       	jmp    80147d <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8013e8:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8013ec:	7e 34                	jle    801422 <readline+0xa0>
  8013ee:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8013f5:	7f 2b                	jg     801422 <readline+0xa0>
			if (echoing)
  8013f7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013fb:	74 0e                	je     80140b <readline+0x89>
				cputchar(c);
  8013fd:	83 ec 0c             	sub    $0xc,%esp
  801400:	ff 75 ec             	pushl  -0x14(%ebp)
  801403:	e8 a8 f4 ff ff       	call   8008b0 <cputchar>
  801408:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  80140b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80140e:	8d 50 01             	lea    0x1(%eax),%edx
  801411:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801414:	89 c2                	mov    %eax,%edx
  801416:	8b 45 0c             	mov    0xc(%ebp),%eax
  801419:	01 d0                	add    %edx,%eax
  80141b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80141e:	88 10                	mov    %dl,(%eax)
  801420:	eb 56                	jmp    801478 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801422:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801426:	75 1f                	jne    801447 <readline+0xc5>
  801428:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80142c:	7e 19                	jle    801447 <readline+0xc5>
			if (echoing)
  80142e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801432:	74 0e                	je     801442 <readline+0xc0>
				cputchar(c);
  801434:	83 ec 0c             	sub    $0xc,%esp
  801437:	ff 75 ec             	pushl  -0x14(%ebp)
  80143a:	e8 71 f4 ff ff       	call   8008b0 <cputchar>
  80143f:	83 c4 10             	add    $0x10,%esp

			i--;
  801442:	ff 4d f4             	decl   -0xc(%ebp)
  801445:	eb 31                	jmp    801478 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801447:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80144b:	74 0a                	je     801457 <readline+0xd5>
  80144d:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801451:	0f 85 61 ff ff ff    	jne    8013b8 <readline+0x36>
			if (echoing)
  801457:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80145b:	74 0e                	je     80146b <readline+0xe9>
				cputchar(c);
  80145d:	83 ec 0c             	sub    $0xc,%esp
  801460:	ff 75 ec             	pushl  -0x14(%ebp)
  801463:	e8 48 f4 ff ff       	call   8008b0 <cputchar>
  801468:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  80146b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80146e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801471:	01 d0                	add    %edx,%eax
  801473:	c6 00 00             	movb   $0x0,(%eax)
			break;
  801476:	eb 06                	jmp    80147e <readline+0xfc>
		}
	}
  801478:	e9 3b ff ff ff       	jmp    8013b8 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  80147d:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  80147e:	90                   	nop
  80147f:	c9                   	leave  
  801480:	c3                   	ret    

00801481 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  801481:	55                   	push   %ebp
  801482:	89 e5                	mov    %esp,%ebp
  801484:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  801487:	e8 3c 0f 00 00       	call   8023c8 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  80148c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801490:	74 13                	je     8014a5 <atomic_readline+0x24>
			cprintf("%s", prompt);
  801492:	83 ec 08             	sub    $0x8,%esp
  801495:	ff 75 08             	pushl  0x8(%ebp)
  801498:	68 48 4a 80 00       	push   $0x804a48
  80149d:	e8 4c f8 ff ff       	call   800cee <cprintf>
  8014a2:	83 c4 10             	add    $0x10,%esp

		i = 0;
  8014a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  8014ac:	83 ec 0c             	sub    $0xc,%esp
  8014af:	6a 00                	push   $0x0
  8014b1:	e8 2c f4 ff ff       	call   8008e2 <iscons>
  8014b6:	83 c4 10             	add    $0x10,%esp
  8014b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  8014bc:	e8 0e f4 ff ff       	call   8008cf <getchar>
  8014c1:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  8014c4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8014c8:	79 22                	jns    8014ec <atomic_readline+0x6b>
				if (c != -E_EOF)
  8014ca:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8014ce:	0f 84 ad 00 00 00    	je     801581 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  8014d4:	83 ec 08             	sub    $0x8,%esp
  8014d7:	ff 75 ec             	pushl  -0x14(%ebp)
  8014da:	68 4b 4a 80 00       	push   $0x804a4b
  8014df:	e8 0a f8 ff ff       	call   800cee <cprintf>
  8014e4:	83 c4 10             	add    $0x10,%esp
				break;
  8014e7:	e9 95 00 00 00       	jmp    801581 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  8014ec:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8014f0:	7e 34                	jle    801526 <atomic_readline+0xa5>
  8014f2:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8014f9:	7f 2b                	jg     801526 <atomic_readline+0xa5>
				if (echoing)
  8014fb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8014ff:	74 0e                	je     80150f <atomic_readline+0x8e>
					cputchar(c);
  801501:	83 ec 0c             	sub    $0xc,%esp
  801504:	ff 75 ec             	pushl  -0x14(%ebp)
  801507:	e8 a4 f3 ff ff       	call   8008b0 <cputchar>
  80150c:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  80150f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801512:	8d 50 01             	lea    0x1(%eax),%edx
  801515:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801518:	89 c2                	mov    %eax,%edx
  80151a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151d:	01 d0                	add    %edx,%eax
  80151f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801522:	88 10                	mov    %dl,(%eax)
  801524:	eb 56                	jmp    80157c <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  801526:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80152a:	75 1f                	jne    80154b <atomic_readline+0xca>
  80152c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801530:	7e 19                	jle    80154b <atomic_readline+0xca>
				if (echoing)
  801532:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801536:	74 0e                	je     801546 <atomic_readline+0xc5>
					cputchar(c);
  801538:	83 ec 0c             	sub    $0xc,%esp
  80153b:	ff 75 ec             	pushl  -0x14(%ebp)
  80153e:	e8 6d f3 ff ff       	call   8008b0 <cputchar>
  801543:	83 c4 10             	add    $0x10,%esp
				i--;
  801546:	ff 4d f4             	decl   -0xc(%ebp)
  801549:	eb 31                	jmp    80157c <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  80154b:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80154f:	74 0a                	je     80155b <atomic_readline+0xda>
  801551:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801555:	0f 85 61 ff ff ff    	jne    8014bc <atomic_readline+0x3b>
				if (echoing)
  80155b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80155f:	74 0e                	je     80156f <atomic_readline+0xee>
					cputchar(c);
  801561:	83 ec 0c             	sub    $0xc,%esp
  801564:	ff 75 ec             	pushl  -0x14(%ebp)
  801567:	e8 44 f3 ff ff       	call   8008b0 <cputchar>
  80156c:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  80156f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801572:	8b 45 0c             	mov    0xc(%ebp),%eax
  801575:	01 d0                	add    %edx,%eax
  801577:	c6 00 00             	movb   $0x0,(%eax)
				break;
  80157a:	eb 06                	jmp    801582 <atomic_readline+0x101>
			}
		}
  80157c:	e9 3b ff ff ff       	jmp    8014bc <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  801581:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  801582:	e8 5b 0e 00 00       	call   8023e2 <sys_unlock_cons>
}
  801587:	90                   	nop
  801588:	c9                   	leave  
  801589:	c3                   	ret    

0080158a <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  80158a:	55                   	push   %ebp
  80158b:	89 e5                	mov    %esp,%ebp
  80158d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801590:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801597:	eb 06                	jmp    80159f <strlen+0x15>
		n++;
  801599:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80159c:	ff 45 08             	incl   0x8(%ebp)
  80159f:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a2:	8a 00                	mov    (%eax),%al
  8015a4:	84 c0                	test   %al,%al
  8015a6:	75 f1                	jne    801599 <strlen+0xf>
		n++;
	return n;
  8015a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8015ab:	c9                   	leave  
  8015ac:	c3                   	ret    

008015ad <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8015ad:	55                   	push   %ebp
  8015ae:	89 e5                	mov    %esp,%ebp
  8015b0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015ba:	eb 09                	jmp    8015c5 <strnlen+0x18>
		n++;
  8015bc:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015bf:	ff 45 08             	incl   0x8(%ebp)
  8015c2:	ff 4d 0c             	decl   0xc(%ebp)
  8015c5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015c9:	74 09                	je     8015d4 <strnlen+0x27>
  8015cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ce:	8a 00                	mov    (%eax),%al
  8015d0:	84 c0                	test   %al,%al
  8015d2:	75 e8                	jne    8015bc <strnlen+0xf>
		n++;
	return n;
  8015d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8015d7:	c9                   	leave  
  8015d8:	c3                   	ret    

008015d9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8015d9:	55                   	push   %ebp
  8015da:	89 e5                	mov    %esp,%ebp
  8015dc:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8015df:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8015e5:	90                   	nop
  8015e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e9:	8d 50 01             	lea    0x1(%eax),%edx
  8015ec:	89 55 08             	mov    %edx,0x8(%ebp)
  8015ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015f2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015f5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8015f8:	8a 12                	mov    (%edx),%dl
  8015fa:	88 10                	mov    %dl,(%eax)
  8015fc:	8a 00                	mov    (%eax),%al
  8015fe:	84 c0                	test   %al,%al
  801600:	75 e4                	jne    8015e6 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801602:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801605:	c9                   	leave  
  801606:	c3                   	ret    

00801607 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801607:	55                   	push   %ebp
  801608:	89 e5                	mov    %esp,%ebp
  80160a:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80160d:	8b 45 08             	mov    0x8(%ebp),%eax
  801610:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801613:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80161a:	eb 1f                	jmp    80163b <strncpy+0x34>
		*dst++ = *src;
  80161c:	8b 45 08             	mov    0x8(%ebp),%eax
  80161f:	8d 50 01             	lea    0x1(%eax),%edx
  801622:	89 55 08             	mov    %edx,0x8(%ebp)
  801625:	8b 55 0c             	mov    0xc(%ebp),%edx
  801628:	8a 12                	mov    (%edx),%dl
  80162a:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80162c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80162f:	8a 00                	mov    (%eax),%al
  801631:	84 c0                	test   %al,%al
  801633:	74 03                	je     801638 <strncpy+0x31>
			src++;
  801635:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801638:	ff 45 fc             	incl   -0x4(%ebp)
  80163b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80163e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801641:	72 d9                	jb     80161c <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801643:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801646:	c9                   	leave  
  801647:	c3                   	ret    

00801648 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801648:	55                   	push   %ebp
  801649:	89 e5                	mov    %esp,%ebp
  80164b:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80164e:	8b 45 08             	mov    0x8(%ebp),%eax
  801651:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801654:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801658:	74 30                	je     80168a <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80165a:	eb 16                	jmp    801672 <strlcpy+0x2a>
			*dst++ = *src++;
  80165c:	8b 45 08             	mov    0x8(%ebp),%eax
  80165f:	8d 50 01             	lea    0x1(%eax),%edx
  801662:	89 55 08             	mov    %edx,0x8(%ebp)
  801665:	8b 55 0c             	mov    0xc(%ebp),%edx
  801668:	8d 4a 01             	lea    0x1(%edx),%ecx
  80166b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80166e:	8a 12                	mov    (%edx),%dl
  801670:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801672:	ff 4d 10             	decl   0x10(%ebp)
  801675:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801679:	74 09                	je     801684 <strlcpy+0x3c>
  80167b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80167e:	8a 00                	mov    (%eax),%al
  801680:	84 c0                	test   %al,%al
  801682:	75 d8                	jne    80165c <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801684:	8b 45 08             	mov    0x8(%ebp),%eax
  801687:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80168a:	8b 55 08             	mov    0x8(%ebp),%edx
  80168d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801690:	29 c2                	sub    %eax,%edx
  801692:	89 d0                	mov    %edx,%eax
}
  801694:	c9                   	leave  
  801695:	c3                   	ret    

00801696 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801696:	55                   	push   %ebp
  801697:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801699:	eb 06                	jmp    8016a1 <strcmp+0xb>
		p++, q++;
  80169b:	ff 45 08             	incl   0x8(%ebp)
  80169e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8016a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a4:	8a 00                	mov    (%eax),%al
  8016a6:	84 c0                	test   %al,%al
  8016a8:	74 0e                	je     8016b8 <strcmp+0x22>
  8016aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ad:	8a 10                	mov    (%eax),%dl
  8016af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b2:	8a 00                	mov    (%eax),%al
  8016b4:	38 c2                	cmp    %al,%dl
  8016b6:	74 e3                	je     80169b <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8016b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bb:	8a 00                	mov    (%eax),%al
  8016bd:	0f b6 d0             	movzbl %al,%edx
  8016c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016c3:	8a 00                	mov    (%eax),%al
  8016c5:	0f b6 c0             	movzbl %al,%eax
  8016c8:	29 c2                	sub    %eax,%edx
  8016ca:	89 d0                	mov    %edx,%eax
}
  8016cc:	5d                   	pop    %ebp
  8016cd:	c3                   	ret    

008016ce <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8016ce:	55                   	push   %ebp
  8016cf:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8016d1:	eb 09                	jmp    8016dc <strncmp+0xe>
		n--, p++, q++;
  8016d3:	ff 4d 10             	decl   0x10(%ebp)
  8016d6:	ff 45 08             	incl   0x8(%ebp)
  8016d9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8016dc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016e0:	74 17                	je     8016f9 <strncmp+0x2b>
  8016e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e5:	8a 00                	mov    (%eax),%al
  8016e7:	84 c0                	test   %al,%al
  8016e9:	74 0e                	je     8016f9 <strncmp+0x2b>
  8016eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ee:	8a 10                	mov    (%eax),%dl
  8016f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f3:	8a 00                	mov    (%eax),%al
  8016f5:	38 c2                	cmp    %al,%dl
  8016f7:	74 da                	je     8016d3 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8016f9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016fd:	75 07                	jne    801706 <strncmp+0x38>
		return 0;
  8016ff:	b8 00 00 00 00       	mov    $0x0,%eax
  801704:	eb 14                	jmp    80171a <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801706:	8b 45 08             	mov    0x8(%ebp),%eax
  801709:	8a 00                	mov    (%eax),%al
  80170b:	0f b6 d0             	movzbl %al,%edx
  80170e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801711:	8a 00                	mov    (%eax),%al
  801713:	0f b6 c0             	movzbl %al,%eax
  801716:	29 c2                	sub    %eax,%edx
  801718:	89 d0                	mov    %edx,%eax
}
  80171a:	5d                   	pop    %ebp
  80171b:	c3                   	ret    

0080171c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80171c:	55                   	push   %ebp
  80171d:	89 e5                	mov    %esp,%ebp
  80171f:	83 ec 04             	sub    $0x4,%esp
  801722:	8b 45 0c             	mov    0xc(%ebp),%eax
  801725:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801728:	eb 12                	jmp    80173c <strchr+0x20>
		if (*s == c)
  80172a:	8b 45 08             	mov    0x8(%ebp),%eax
  80172d:	8a 00                	mov    (%eax),%al
  80172f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801732:	75 05                	jne    801739 <strchr+0x1d>
			return (char *) s;
  801734:	8b 45 08             	mov    0x8(%ebp),%eax
  801737:	eb 11                	jmp    80174a <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801739:	ff 45 08             	incl   0x8(%ebp)
  80173c:	8b 45 08             	mov    0x8(%ebp),%eax
  80173f:	8a 00                	mov    (%eax),%al
  801741:	84 c0                	test   %al,%al
  801743:	75 e5                	jne    80172a <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801745:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80174a:	c9                   	leave  
  80174b:	c3                   	ret    

0080174c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80174c:	55                   	push   %ebp
  80174d:	89 e5                	mov    %esp,%ebp
  80174f:	83 ec 04             	sub    $0x4,%esp
  801752:	8b 45 0c             	mov    0xc(%ebp),%eax
  801755:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801758:	eb 0d                	jmp    801767 <strfind+0x1b>
		if (*s == c)
  80175a:	8b 45 08             	mov    0x8(%ebp),%eax
  80175d:	8a 00                	mov    (%eax),%al
  80175f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801762:	74 0e                	je     801772 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801764:	ff 45 08             	incl   0x8(%ebp)
  801767:	8b 45 08             	mov    0x8(%ebp),%eax
  80176a:	8a 00                	mov    (%eax),%al
  80176c:	84 c0                	test   %al,%al
  80176e:	75 ea                	jne    80175a <strfind+0xe>
  801770:	eb 01                	jmp    801773 <strfind+0x27>
		if (*s == c)
			break;
  801772:	90                   	nop
	return (char *) s;
  801773:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801776:	c9                   	leave  
  801777:	c3                   	ret    

00801778 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801778:	55                   	push   %ebp
  801779:	89 e5                	mov    %esp,%ebp
  80177b:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80177e:	8b 45 08             	mov    0x8(%ebp),%eax
  801781:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801784:	8b 45 10             	mov    0x10(%ebp),%eax
  801787:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80178a:	eb 0e                	jmp    80179a <memset+0x22>
		*p++ = c;
  80178c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80178f:	8d 50 01             	lea    0x1(%eax),%edx
  801792:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801795:	8b 55 0c             	mov    0xc(%ebp),%edx
  801798:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80179a:	ff 4d f8             	decl   -0x8(%ebp)
  80179d:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8017a1:	79 e9                	jns    80178c <memset+0x14>
		*p++ = c;

	return v;
  8017a3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017a6:	c9                   	leave  
  8017a7:	c3                   	ret    

008017a8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8017a8:	55                   	push   %ebp
  8017a9:	89 e5                	mov    %esp,%ebp
  8017ab:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8017ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8017b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8017ba:	eb 16                	jmp    8017d2 <memcpy+0x2a>
		*d++ = *s++;
  8017bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017bf:	8d 50 01             	lea    0x1(%eax),%edx
  8017c2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8017c5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017c8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8017cb:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8017ce:	8a 12                	mov    (%edx),%dl
  8017d0:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8017d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8017d5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8017d8:	89 55 10             	mov    %edx,0x10(%ebp)
  8017db:	85 c0                	test   %eax,%eax
  8017dd:	75 dd                	jne    8017bc <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8017df:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017e2:	c9                   	leave  
  8017e3:	c3                   	ret    

008017e4 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8017e4:	55                   	push   %ebp
  8017e5:	89 e5                	mov    %esp,%ebp
  8017e7:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8017ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8017f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8017f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017f9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8017fc:	73 50                	jae    80184e <memmove+0x6a>
  8017fe:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801801:	8b 45 10             	mov    0x10(%ebp),%eax
  801804:	01 d0                	add    %edx,%eax
  801806:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801809:	76 43                	jbe    80184e <memmove+0x6a>
		s += n;
  80180b:	8b 45 10             	mov    0x10(%ebp),%eax
  80180e:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801811:	8b 45 10             	mov    0x10(%ebp),%eax
  801814:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801817:	eb 10                	jmp    801829 <memmove+0x45>
			*--d = *--s;
  801819:	ff 4d f8             	decl   -0x8(%ebp)
  80181c:	ff 4d fc             	decl   -0x4(%ebp)
  80181f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801822:	8a 10                	mov    (%eax),%dl
  801824:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801827:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801829:	8b 45 10             	mov    0x10(%ebp),%eax
  80182c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80182f:	89 55 10             	mov    %edx,0x10(%ebp)
  801832:	85 c0                	test   %eax,%eax
  801834:	75 e3                	jne    801819 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801836:	eb 23                	jmp    80185b <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801838:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80183b:	8d 50 01             	lea    0x1(%eax),%edx
  80183e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801841:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801844:	8d 4a 01             	lea    0x1(%edx),%ecx
  801847:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80184a:	8a 12                	mov    (%edx),%dl
  80184c:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80184e:	8b 45 10             	mov    0x10(%ebp),%eax
  801851:	8d 50 ff             	lea    -0x1(%eax),%edx
  801854:	89 55 10             	mov    %edx,0x10(%ebp)
  801857:	85 c0                	test   %eax,%eax
  801859:	75 dd                	jne    801838 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80185b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80185e:	c9                   	leave  
  80185f:	c3                   	ret    

00801860 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801860:	55                   	push   %ebp
  801861:	89 e5                	mov    %esp,%ebp
  801863:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801866:	8b 45 08             	mov    0x8(%ebp),%eax
  801869:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80186c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80186f:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801872:	eb 2a                	jmp    80189e <memcmp+0x3e>
		if (*s1 != *s2)
  801874:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801877:	8a 10                	mov    (%eax),%dl
  801879:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80187c:	8a 00                	mov    (%eax),%al
  80187e:	38 c2                	cmp    %al,%dl
  801880:	74 16                	je     801898 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801882:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801885:	8a 00                	mov    (%eax),%al
  801887:	0f b6 d0             	movzbl %al,%edx
  80188a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80188d:	8a 00                	mov    (%eax),%al
  80188f:	0f b6 c0             	movzbl %al,%eax
  801892:	29 c2                	sub    %eax,%edx
  801894:	89 d0                	mov    %edx,%eax
  801896:	eb 18                	jmp    8018b0 <memcmp+0x50>
		s1++, s2++;
  801898:	ff 45 fc             	incl   -0x4(%ebp)
  80189b:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80189e:	8b 45 10             	mov    0x10(%ebp),%eax
  8018a1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018a4:	89 55 10             	mov    %edx,0x10(%ebp)
  8018a7:	85 c0                	test   %eax,%eax
  8018a9:	75 c9                	jne    801874 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8018ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018b0:	c9                   	leave  
  8018b1:	c3                   	ret    

008018b2 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8018b2:	55                   	push   %ebp
  8018b3:	89 e5                	mov    %esp,%ebp
  8018b5:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8018b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8018bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8018be:	01 d0                	add    %edx,%eax
  8018c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8018c3:	eb 15                	jmp    8018da <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8018c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c8:	8a 00                	mov    (%eax),%al
  8018ca:	0f b6 d0             	movzbl %al,%edx
  8018cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d0:	0f b6 c0             	movzbl %al,%eax
  8018d3:	39 c2                	cmp    %eax,%edx
  8018d5:	74 0d                	je     8018e4 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8018d7:	ff 45 08             	incl   0x8(%ebp)
  8018da:	8b 45 08             	mov    0x8(%ebp),%eax
  8018dd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8018e0:	72 e3                	jb     8018c5 <memfind+0x13>
  8018e2:	eb 01                	jmp    8018e5 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8018e4:	90                   	nop
	return (void *) s;
  8018e5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018e8:	c9                   	leave  
  8018e9:	c3                   	ret    

008018ea <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8018ea:	55                   	push   %ebp
  8018eb:	89 e5                	mov    %esp,%ebp
  8018ed:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8018f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8018f7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018fe:	eb 03                	jmp    801903 <strtol+0x19>
		s++;
  801900:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801903:	8b 45 08             	mov    0x8(%ebp),%eax
  801906:	8a 00                	mov    (%eax),%al
  801908:	3c 20                	cmp    $0x20,%al
  80190a:	74 f4                	je     801900 <strtol+0x16>
  80190c:	8b 45 08             	mov    0x8(%ebp),%eax
  80190f:	8a 00                	mov    (%eax),%al
  801911:	3c 09                	cmp    $0x9,%al
  801913:	74 eb                	je     801900 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801915:	8b 45 08             	mov    0x8(%ebp),%eax
  801918:	8a 00                	mov    (%eax),%al
  80191a:	3c 2b                	cmp    $0x2b,%al
  80191c:	75 05                	jne    801923 <strtol+0x39>
		s++;
  80191e:	ff 45 08             	incl   0x8(%ebp)
  801921:	eb 13                	jmp    801936 <strtol+0x4c>
	else if (*s == '-')
  801923:	8b 45 08             	mov    0x8(%ebp),%eax
  801926:	8a 00                	mov    (%eax),%al
  801928:	3c 2d                	cmp    $0x2d,%al
  80192a:	75 0a                	jne    801936 <strtol+0x4c>
		s++, neg = 1;
  80192c:	ff 45 08             	incl   0x8(%ebp)
  80192f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801936:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80193a:	74 06                	je     801942 <strtol+0x58>
  80193c:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801940:	75 20                	jne    801962 <strtol+0x78>
  801942:	8b 45 08             	mov    0x8(%ebp),%eax
  801945:	8a 00                	mov    (%eax),%al
  801947:	3c 30                	cmp    $0x30,%al
  801949:	75 17                	jne    801962 <strtol+0x78>
  80194b:	8b 45 08             	mov    0x8(%ebp),%eax
  80194e:	40                   	inc    %eax
  80194f:	8a 00                	mov    (%eax),%al
  801951:	3c 78                	cmp    $0x78,%al
  801953:	75 0d                	jne    801962 <strtol+0x78>
		s += 2, base = 16;
  801955:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801959:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801960:	eb 28                	jmp    80198a <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801962:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801966:	75 15                	jne    80197d <strtol+0x93>
  801968:	8b 45 08             	mov    0x8(%ebp),%eax
  80196b:	8a 00                	mov    (%eax),%al
  80196d:	3c 30                	cmp    $0x30,%al
  80196f:	75 0c                	jne    80197d <strtol+0x93>
		s++, base = 8;
  801971:	ff 45 08             	incl   0x8(%ebp)
  801974:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80197b:	eb 0d                	jmp    80198a <strtol+0xa0>
	else if (base == 0)
  80197d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801981:	75 07                	jne    80198a <strtol+0xa0>
		base = 10;
  801983:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80198a:	8b 45 08             	mov    0x8(%ebp),%eax
  80198d:	8a 00                	mov    (%eax),%al
  80198f:	3c 2f                	cmp    $0x2f,%al
  801991:	7e 19                	jle    8019ac <strtol+0xc2>
  801993:	8b 45 08             	mov    0x8(%ebp),%eax
  801996:	8a 00                	mov    (%eax),%al
  801998:	3c 39                	cmp    $0x39,%al
  80199a:	7f 10                	jg     8019ac <strtol+0xc2>
			dig = *s - '0';
  80199c:	8b 45 08             	mov    0x8(%ebp),%eax
  80199f:	8a 00                	mov    (%eax),%al
  8019a1:	0f be c0             	movsbl %al,%eax
  8019a4:	83 e8 30             	sub    $0x30,%eax
  8019a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019aa:	eb 42                	jmp    8019ee <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8019ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8019af:	8a 00                	mov    (%eax),%al
  8019b1:	3c 60                	cmp    $0x60,%al
  8019b3:	7e 19                	jle    8019ce <strtol+0xe4>
  8019b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b8:	8a 00                	mov    (%eax),%al
  8019ba:	3c 7a                	cmp    $0x7a,%al
  8019bc:	7f 10                	jg     8019ce <strtol+0xe4>
			dig = *s - 'a' + 10;
  8019be:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c1:	8a 00                	mov    (%eax),%al
  8019c3:	0f be c0             	movsbl %al,%eax
  8019c6:	83 e8 57             	sub    $0x57,%eax
  8019c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019cc:	eb 20                	jmp    8019ee <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8019ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d1:	8a 00                	mov    (%eax),%al
  8019d3:	3c 40                	cmp    $0x40,%al
  8019d5:	7e 39                	jle    801a10 <strtol+0x126>
  8019d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019da:	8a 00                	mov    (%eax),%al
  8019dc:	3c 5a                	cmp    $0x5a,%al
  8019de:	7f 30                	jg     801a10 <strtol+0x126>
			dig = *s - 'A' + 10;
  8019e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e3:	8a 00                	mov    (%eax),%al
  8019e5:	0f be c0             	movsbl %al,%eax
  8019e8:	83 e8 37             	sub    $0x37,%eax
  8019eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8019ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019f1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8019f4:	7d 19                	jge    801a0f <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8019f6:	ff 45 08             	incl   0x8(%ebp)
  8019f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019fc:	0f af 45 10          	imul   0x10(%ebp),%eax
  801a00:	89 c2                	mov    %eax,%edx
  801a02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a05:	01 d0                	add    %edx,%eax
  801a07:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801a0a:	e9 7b ff ff ff       	jmp    80198a <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801a0f:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801a10:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a14:	74 08                	je     801a1e <strtol+0x134>
		*endptr = (char *) s;
  801a16:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a19:	8b 55 08             	mov    0x8(%ebp),%edx
  801a1c:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801a1e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a22:	74 07                	je     801a2b <strtol+0x141>
  801a24:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a27:	f7 d8                	neg    %eax
  801a29:	eb 03                	jmp    801a2e <strtol+0x144>
  801a2b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801a2e:	c9                   	leave  
  801a2f:	c3                   	ret    

00801a30 <ltostr>:

void
ltostr(long value, char *str)
{
  801a30:	55                   	push   %ebp
  801a31:	89 e5                	mov    %esp,%ebp
  801a33:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801a36:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801a3d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801a44:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a48:	79 13                	jns    801a5d <ltostr+0x2d>
	{
		neg = 1;
  801a4a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801a51:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a54:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801a57:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801a5a:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a60:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801a65:	99                   	cltd   
  801a66:	f7 f9                	idiv   %ecx
  801a68:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801a6b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a6e:	8d 50 01             	lea    0x1(%eax),%edx
  801a71:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801a74:	89 c2                	mov    %eax,%edx
  801a76:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a79:	01 d0                	add    %edx,%eax
  801a7b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a7e:	83 c2 30             	add    $0x30,%edx
  801a81:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801a83:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a86:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801a8b:	f7 e9                	imul   %ecx
  801a8d:	c1 fa 02             	sar    $0x2,%edx
  801a90:	89 c8                	mov    %ecx,%eax
  801a92:	c1 f8 1f             	sar    $0x1f,%eax
  801a95:	29 c2                	sub    %eax,%edx
  801a97:	89 d0                	mov    %edx,%eax
  801a99:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801a9c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801aa0:	75 bb                	jne    801a5d <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801aa2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801aa9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801aac:	48                   	dec    %eax
  801aad:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801ab0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801ab4:	74 3d                	je     801af3 <ltostr+0xc3>
		start = 1 ;
  801ab6:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801abd:	eb 34                	jmp    801af3 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801abf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ac2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac5:	01 d0                	add    %edx,%eax
  801ac7:	8a 00                	mov    (%eax),%al
  801ac9:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801acc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801acf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ad2:	01 c2                	add    %eax,%edx
  801ad4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801ad7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ada:	01 c8                	add    %ecx,%eax
  801adc:	8a 00                	mov    (%eax),%al
  801ade:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801ae0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ae3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ae6:	01 c2                	add    %eax,%edx
  801ae8:	8a 45 eb             	mov    -0x15(%ebp),%al
  801aeb:	88 02                	mov    %al,(%edx)
		start++ ;
  801aed:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801af0:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801af3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801af6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801af9:	7c c4                	jl     801abf <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801afb:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801afe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b01:	01 d0                	add    %edx,%eax
  801b03:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801b06:	90                   	nop
  801b07:	c9                   	leave  
  801b08:	c3                   	ret    

00801b09 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801b09:	55                   	push   %ebp
  801b0a:	89 e5                	mov    %esp,%ebp
  801b0c:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801b0f:	ff 75 08             	pushl  0x8(%ebp)
  801b12:	e8 73 fa ff ff       	call   80158a <strlen>
  801b17:	83 c4 04             	add    $0x4,%esp
  801b1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801b1d:	ff 75 0c             	pushl  0xc(%ebp)
  801b20:	e8 65 fa ff ff       	call   80158a <strlen>
  801b25:	83 c4 04             	add    $0x4,%esp
  801b28:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801b2b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801b32:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b39:	eb 17                	jmp    801b52 <strcconcat+0x49>
		final[s] = str1[s] ;
  801b3b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b3e:	8b 45 10             	mov    0x10(%ebp),%eax
  801b41:	01 c2                	add    %eax,%edx
  801b43:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b46:	8b 45 08             	mov    0x8(%ebp),%eax
  801b49:	01 c8                	add    %ecx,%eax
  801b4b:	8a 00                	mov    (%eax),%al
  801b4d:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801b4f:	ff 45 fc             	incl   -0x4(%ebp)
  801b52:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b55:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801b58:	7c e1                	jl     801b3b <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801b5a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801b61:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801b68:	eb 1f                	jmp    801b89 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801b6a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b6d:	8d 50 01             	lea    0x1(%eax),%edx
  801b70:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801b73:	89 c2                	mov    %eax,%edx
  801b75:	8b 45 10             	mov    0x10(%ebp),%eax
  801b78:	01 c2                	add    %eax,%edx
  801b7a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801b7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b80:	01 c8                	add    %ecx,%eax
  801b82:	8a 00                	mov    (%eax),%al
  801b84:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801b86:	ff 45 f8             	incl   -0x8(%ebp)
  801b89:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b8c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b8f:	7c d9                	jl     801b6a <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801b91:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b94:	8b 45 10             	mov    0x10(%ebp),%eax
  801b97:	01 d0                	add    %edx,%eax
  801b99:	c6 00 00             	movb   $0x0,(%eax)
}
  801b9c:	90                   	nop
  801b9d:	c9                   	leave  
  801b9e:	c3                   	ret    

00801b9f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801b9f:	55                   	push   %ebp
  801ba0:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801ba2:	8b 45 14             	mov    0x14(%ebp),%eax
  801ba5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801bab:	8b 45 14             	mov    0x14(%ebp),%eax
  801bae:	8b 00                	mov    (%eax),%eax
  801bb0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801bb7:	8b 45 10             	mov    0x10(%ebp),%eax
  801bba:	01 d0                	add    %edx,%eax
  801bbc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801bc2:	eb 0c                	jmp    801bd0 <strsplit+0x31>
			*string++ = 0;
  801bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc7:	8d 50 01             	lea    0x1(%eax),%edx
  801bca:	89 55 08             	mov    %edx,0x8(%ebp)
  801bcd:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd3:	8a 00                	mov    (%eax),%al
  801bd5:	84 c0                	test   %al,%al
  801bd7:	74 18                	je     801bf1 <strsplit+0x52>
  801bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdc:	8a 00                	mov    (%eax),%al
  801bde:	0f be c0             	movsbl %al,%eax
  801be1:	50                   	push   %eax
  801be2:	ff 75 0c             	pushl  0xc(%ebp)
  801be5:	e8 32 fb ff ff       	call   80171c <strchr>
  801bea:	83 c4 08             	add    $0x8,%esp
  801bed:	85 c0                	test   %eax,%eax
  801bef:	75 d3                	jne    801bc4 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf4:	8a 00                	mov    (%eax),%al
  801bf6:	84 c0                	test   %al,%al
  801bf8:	74 5a                	je     801c54 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801bfa:	8b 45 14             	mov    0x14(%ebp),%eax
  801bfd:	8b 00                	mov    (%eax),%eax
  801bff:	83 f8 0f             	cmp    $0xf,%eax
  801c02:	75 07                	jne    801c0b <strsplit+0x6c>
		{
			return 0;
  801c04:	b8 00 00 00 00       	mov    $0x0,%eax
  801c09:	eb 66                	jmp    801c71 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801c0b:	8b 45 14             	mov    0x14(%ebp),%eax
  801c0e:	8b 00                	mov    (%eax),%eax
  801c10:	8d 48 01             	lea    0x1(%eax),%ecx
  801c13:	8b 55 14             	mov    0x14(%ebp),%edx
  801c16:	89 0a                	mov    %ecx,(%edx)
  801c18:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c1f:	8b 45 10             	mov    0x10(%ebp),%eax
  801c22:	01 c2                	add    %eax,%edx
  801c24:	8b 45 08             	mov    0x8(%ebp),%eax
  801c27:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c29:	eb 03                	jmp    801c2e <strsplit+0x8f>
			string++;
  801c2b:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c31:	8a 00                	mov    (%eax),%al
  801c33:	84 c0                	test   %al,%al
  801c35:	74 8b                	je     801bc2 <strsplit+0x23>
  801c37:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3a:	8a 00                	mov    (%eax),%al
  801c3c:	0f be c0             	movsbl %al,%eax
  801c3f:	50                   	push   %eax
  801c40:	ff 75 0c             	pushl  0xc(%ebp)
  801c43:	e8 d4 fa ff ff       	call   80171c <strchr>
  801c48:	83 c4 08             	add    $0x8,%esp
  801c4b:	85 c0                	test   %eax,%eax
  801c4d:	74 dc                	je     801c2b <strsplit+0x8c>
			string++;
	}
  801c4f:	e9 6e ff ff ff       	jmp    801bc2 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801c54:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801c55:	8b 45 14             	mov    0x14(%ebp),%eax
  801c58:	8b 00                	mov    (%eax),%eax
  801c5a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c61:	8b 45 10             	mov    0x10(%ebp),%eax
  801c64:	01 d0                	add    %edx,%eax
  801c66:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801c6c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801c71:	c9                   	leave  
  801c72:	c3                   	ret    

00801c73 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801c73:	55                   	push   %ebp
  801c74:	89 e5                	mov    %esp,%ebp
  801c76:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801c79:	83 ec 04             	sub    $0x4,%esp
  801c7c:	68 5c 4a 80 00       	push   $0x804a5c
  801c81:	68 3f 01 00 00       	push   $0x13f
  801c86:	68 7e 4a 80 00       	push   $0x804a7e
  801c8b:	e8 a1 ed ff ff       	call   800a31 <_panic>

00801c90 <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
  801c93:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801c96:	83 ec 0c             	sub    $0xc,%esp
  801c99:	ff 75 08             	pushl  0x8(%ebp)
  801c9c:	e8 90 0c 00 00       	call   802931 <sys_sbrk>
  801ca1:	83 c4 10             	add    $0x10,%esp
}
  801ca4:	c9                   	leave  
  801ca5:	c3                   	ret    

00801ca6 <malloc>:
#define num_of_page ((USER_HEAP_MAX - USER_HEAP_START) / PAGE_SIZE)

int pagesAllocated[num_of_page] = { 0 };
int shardIDs[num_of_page] = { 0 };
bool markedPages[num_of_page] = { 0 };
void* malloc(uint32 size) {
  801ca6:	55                   	push   %ebp
  801ca7:	89 e5                	mov    %esp,%ebp
  801ca9:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  801cac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801cb0:	75 0a                	jne    801cbc <malloc+0x16>
		return NULL;
  801cb2:	b8 00 00 00 00       	mov    $0x0,%eax
  801cb7:	e9 9e 01 00 00       	jmp    801e5a <malloc+0x1b4>

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

	//  our new code
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  801cbc:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801cc3:	77 2c                	ja     801cf1 <malloc+0x4b>
		if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  801cc5:	e8 eb 0a 00 00       	call   8027b5 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801cca:	85 c0                	test   %eax,%eax
  801ccc:	74 19                	je     801ce7 <malloc+0x41>

			void * block = alloc_block_FF(size);
  801cce:	83 ec 0c             	sub    $0xc,%esp
  801cd1:	ff 75 08             	pushl  0x8(%ebp)
  801cd4:	e8 85 11 00 00       	call   802e5e <alloc_block_FF>
  801cd9:	83 c4 10             	add    $0x10,%esp
  801cdc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			return block;
  801cdf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ce2:	e9 73 01 00 00       	jmp    801e5a <malloc+0x1b4>
		} else {
			return NULL;
  801ce7:	b8 00 00 00 00       	mov    $0x0,%eax
  801cec:	e9 69 01 00 00       	jmp    801e5a <malloc+0x1b4>
		}
	}

	uint32 numOfPages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801cf1:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801cf8:	8b 55 08             	mov    0x8(%ebp),%edx
  801cfb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cfe:	01 d0                	add    %edx,%eax
  801d00:	48                   	dec    %eax
  801d01:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801d04:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d07:	ba 00 00 00 00       	mov    $0x0,%edx
  801d0c:	f7 75 e0             	divl   -0x20(%ebp)
  801d0f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d12:	29 d0                	sub    %edx,%eax
  801d14:	c1 e8 0c             	shr    $0xc,%eax
  801d17:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 freePagesCount = 0;
  801d1a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801d21:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  801d28:	a1 20 50 80 00       	mov    0x805020,%eax
  801d2d:	8b 40 7c             	mov    0x7c(%eax),%eax
  801d30:	05 00 10 00 00       	add    $0x1000,%eax
  801d35:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  801d38:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801d3d:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801d40:	89 45 d0             	mov    %eax,-0x30(%ebp)

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  801d43:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  801d4a:	8b 55 08             	mov    0x8(%ebp),%edx
  801d4d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801d50:	01 d0                	add    %edx,%eax
  801d52:	48                   	dec    %eax
  801d53:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801d56:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801d59:	ba 00 00 00 00       	mov    $0x0,%edx
  801d5e:	f7 75 cc             	divl   -0x34(%ebp)
  801d61:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801d64:	29 d0                	sub    %edx,%eax
  801d66:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801d69:	76 0a                	jbe    801d75 <malloc+0xcf>
		return NULL;
  801d6b:	b8 00 00 00 00       	mov    $0x0,%eax
  801d70:	e9 e5 00 00 00       	jmp    801e5a <malloc+0x1b4>
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  801d75:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d78:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801d7b:	eb 48                	jmp    801dc5 <malloc+0x11f>
	{
		uint32 idx = (i - currentAddr) / PAGE_SIZE;
  801d7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d80:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801d83:	c1 e8 0c             	shr    $0xc,%eax
  801d86:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if (!markedPages[idx]) {
  801d89:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801d8c:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  801d93:	85 c0                	test   %eax,%eax
  801d95:	75 11                	jne    801da8 <malloc+0x102>
			freePagesCount++;
  801d97:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801d9a:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801d9e:	75 16                	jne    801db6 <malloc+0x110>
				start = i;
  801da0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801da3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801da6:	eb 0e                	jmp    801db6 <malloc+0x110>
			}
		} else {
			freePagesCount = 0;
  801da8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  801daf:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == numOfPages) {
  801db6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db9:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801dbc:	74 12                	je     801dd0 <malloc+0x12a>

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  801dbe:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801dc5:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801dcc:	76 af                	jbe    801d7d <malloc+0xd7>
  801dce:	eb 01                	jmp    801dd1 <malloc+0x12b>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == numOfPages) {
			break;
  801dd0:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
  801dd1:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801dd5:	74 08                	je     801ddf <malloc+0x139>
  801dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dda:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801ddd:	74 07                	je     801de6 <malloc+0x140>
		return NULL;
  801ddf:	b8 00 00 00 00       	mov    $0x0,%eax
  801de4:	eb 74                	jmp    801e5a <malloc+0x1b4>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  801de6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801de9:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801dec:	c1 e8 0c             	shr    $0xc,%eax
  801def:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numOfPages;
  801df2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801df5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801df8:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  801dff:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801e02:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801e05:	eb 11                	jmp    801e18 <malloc+0x172>
		markedPages[i] = 1;
  801e07:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e0a:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  801e11:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = numOfPages;
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  801e15:	ff 45 e8             	incl   -0x18(%ebp)
  801e18:	8b 55 c0             	mov    -0x40(%ebp),%edx
  801e1b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e1e:	01 d0                	add    %edx,%eax
  801e20:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801e23:	77 e2                	ja     801e07 <malloc+0x161>
		markedPages[i] = 1;
	}

	sys_allocate_user_mem(start, ROUNDUP(size, PAGE_SIZE));
  801e25:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801e2c:	8b 55 08             	mov    0x8(%ebp),%edx
  801e2f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801e32:	01 d0                	add    %edx,%eax
  801e34:	48                   	dec    %eax
  801e35:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801e38:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801e3b:	ba 00 00 00 00       	mov    $0x0,%edx
  801e40:	f7 75 bc             	divl   -0x44(%ebp)
  801e43:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801e46:	29 d0                	sub    %edx,%eax
  801e48:	83 ec 08             	sub    $0x8,%esp
  801e4b:	50                   	push   %eax
  801e4c:	ff 75 f0             	pushl  -0x10(%ebp)
  801e4f:	e8 14 0b 00 00       	call   802968 <sys_allocate_user_mem>
  801e54:	83 c4 10             	add    $0x10,%esp
	return (void*) start;
  801e57:	8b 45 f0             	mov    -0x10(%ebp),%eax

}
  801e5a:	c9                   	leave  
  801e5b:	c3                   	ret    

00801e5c <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address) {
  801e5c:	55                   	push   %ebp
  801e5d:	89 e5                	mov    %esp,%ebp
  801e5f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
  801e62:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e66:	0f 84 ee 00 00 00    	je     801f5a <free+0xfe>
		return;
	}

	if (virtual_address
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  801e6c:	a1 20 50 80 00       	mov    0x805020,%eax
  801e71:	8b 40 74             	mov    0x74(%eax),%eax

	if (virtual_address == NULL) {
		return;
	}

	if (virtual_address
  801e74:	3b 45 08             	cmp    0x8(%ebp),%eax
  801e77:	77 09                	ja     801e82 <free+0x26>
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  801e79:	81 7d 08 00 00 00 a0 	cmpl   $0xa0000000,0x8(%ebp)
  801e80:	76 14                	jbe    801e96 <free+0x3a>
		panic("INVALID VIRTUAL ADDRESS!!");
  801e82:	83 ec 04             	sub    $0x4,%esp
  801e85:	68 8c 4a 80 00       	push   $0x804a8c
  801e8a:	6a 68                	push   $0x68
  801e8c:	68 a6 4a 80 00       	push   $0x804aa6
  801e91:	e8 9b eb ff ff       	call   800a31 <_panic>
	}
	if (virtual_address >= (void *) (myEnv->uheapStart)
  801e96:	a1 20 50 80 00       	mov    0x805020,%eax
  801e9b:	8b 40 74             	mov    0x74(%eax),%eax
  801e9e:	3b 45 08             	cmp    0x8(%ebp),%eax
  801ea1:	77 20                	ja     801ec3 <free+0x67>
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
  801ea3:	a1 20 50 80 00       	mov    0x805020,%eax
  801ea8:	8b 40 78             	mov    0x78(%eax),%eax
  801eab:	3b 45 08             	cmp    0x8(%ebp),%eax
  801eae:	76 13                	jbe    801ec3 <free+0x67>
		free_block(virtual_address);
  801eb0:	83 ec 0c             	sub    $0xc,%esp
  801eb3:	ff 75 08             	pushl  0x8(%ebp)
  801eb6:	e8 6c 16 00 00       	call   803527 <free_block>
  801ebb:	83 c4 10             	add    $0x10,%esp
		return;
  801ebe:	e9 98 00 00 00       	jmp    801f5b <free+0xff>
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  801ec3:	8b 55 08             	mov    0x8(%ebp),%edx
  801ec6:	a1 20 50 80 00       	mov    0x805020,%eax
  801ecb:	8b 40 7c             	mov    0x7c(%eax),%eax
  801ece:	29 c2                	sub    %eax,%edx
  801ed0:	89 d0                	mov    %edx,%eax
  801ed2:	2d 00 10 00 00       	sub    $0x1000,%eax
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
		free_block(virtual_address);
		return;
	}

	uint32 pageIdx = ((uint32) virtual_address
  801ed7:	c1 e8 0c             	shr    $0xc,%eax
  801eda:	89 45 ec             	mov    %eax,-0x14(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  801edd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801ee4:	eb 16                	jmp    801efc <free+0xa0>
		markedPages[idx + pageIdx] = 0;
  801ee6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ee9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eec:	01 d0                	add    %edx,%eax
  801eee:	c7 04 85 40 50 90 00 	movl   $0x0,0x905040(,%eax,4)
  801ef5:	00 00 00 00 
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  801ef9:	ff 45 f4             	incl   -0xc(%ebp)
  801efc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eff:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  801f06:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801f09:	7f db                	jg     801ee6 <free+0x8a>
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;
  801f0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f0e:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  801f15:	c1 e0 0c             	shl    $0xc,%eax
  801f18:	89 45 e8             	mov    %eax,-0x18(%ebp)

	for (uint32 i = (uint32) virtual_address;
  801f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f21:	eb 1a                	jmp    801f3d <free+0xe1>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
  801f23:	83 ec 08             	sub    $0x8,%esp
  801f26:	68 00 10 00 00       	push   $0x1000
  801f2b:	ff 75 f0             	pushl  -0x10(%ebp)
  801f2e:	e8 19 0a 00 00       	call   80294c <sys_free_user_mem>
  801f33:	83 c4 10             	add    $0x10,%esp
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
  801f36:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  801f3d:	8b 55 08             	mov    0x8(%ebp),%edx
  801f40:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f43:	01 d0                	add    %edx,%eax
	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
  801f45:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801f48:	77 d9                	ja     801f23 <free+0xc7>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;
  801f4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f4d:	c7 04 85 40 50 80 00 	movl   $0x0,0x805040(,%eax,4)
  801f54:	00 00 00 00 
  801f58:	eb 01                	jmp    801f5b <free+0xff>
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
		return;
  801f5a:	90                   	nop
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;

}
  801f5b:	c9                   	leave  
  801f5c:	c3                   	ret    

00801f5d <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  801f5d:	55                   	push   %ebp
  801f5e:	89 e5                	mov    %esp,%ebp
  801f60:	83 ec 58             	sub    $0x58,%esp
  801f63:	8b 45 10             	mov    0x10(%ebp),%eax
  801f66:	88 45 b4             	mov    %al,-0x4c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  801f69:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f6d:	75 0a                	jne    801f79 <smalloc+0x1c>
		return NULL;
  801f6f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f74:	e9 7d 01 00 00       	jmp    8020f6 <smalloc+0x199>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	uint32 num_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801f79:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  801f80:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f86:	01 d0                	add    %edx,%eax
  801f88:	48                   	dec    %eax
  801f89:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801f8c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f8f:	ba 00 00 00 00       	mov    $0x0,%edx
  801f94:	f7 75 e4             	divl   -0x1c(%ebp)
  801f97:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f9a:	29 d0                	sub    %edx,%eax
  801f9c:	c1 e8 0c             	shr    $0xc,%eax
  801f9f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 freePagesCount = 0;
  801fa2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801fa9:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  801fb0:	a1 20 50 80 00       	mov    0x805020,%eax
  801fb5:	8b 40 7c             	mov    0x7c(%eax),%eax
  801fb8:	05 00 10 00 00       	add    $0x1000,%eax
  801fbd:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  801fc0:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801fc5:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801fc8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  801fcb:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801fd2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fd5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801fd8:	01 d0                	add    %edx,%eax
  801fda:	48                   	dec    %eax
  801fdb:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801fde:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801fe1:	ba 00 00 00 00       	mov    $0x0,%edx
  801fe6:	f7 75 d0             	divl   -0x30(%ebp)
  801fe9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801fec:	29 d0                	sub    %edx,%eax
  801fee:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801ff1:	76 0a                	jbe    801ffd <smalloc+0xa0>
		return NULL;
  801ff3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff8:	e9 f9 00 00 00       	jmp    8020f6 <smalloc+0x199>
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801ffd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802000:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802003:	eb 48                	jmp    80204d <smalloc+0xf0>
		uint32 idx = (s - currentAddr) / PAGE_SIZE;
  802005:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802008:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80200b:	c1 e8 0c             	shr    $0xc,%eax
  80200e:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (!markedPages[idx]) {
  802011:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802014:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  80201b:	85 c0                	test   %eax,%eax
  80201d:	75 11                	jne    802030 <smalloc+0xd3>
			freePagesCount++;
  80201f:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  802022:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802026:	75 16                	jne    80203e <smalloc+0xe1>
				start = s;
  802028:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80202b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80202e:	eb 0e                	jmp    80203e <smalloc+0xe1>
			}
		} else {
			freePagesCount = 0;
  802030:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  802037:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == num_Of_Pages) {
  80203e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802041:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802044:	74 12                	je     802058 <smalloc+0xfb>
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  802046:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  80204d:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  802054:	76 af                	jbe    802005 <smalloc+0xa8>
  802056:	eb 01                	jmp    802059 <smalloc+0xfc>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == num_Of_Pages) {
			break;
  802058:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
  802059:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80205d:	74 08                	je     802067 <smalloc+0x10a>
  80205f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802062:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802065:	74 0a                	je     802071 <smalloc+0x114>
		return NULL;
  802067:	b8 00 00 00 00       	mov    $0x0,%eax
  80206c:	e9 85 00 00 00       	jmp    8020f6 <smalloc+0x199>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  802071:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802074:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802077:	c1 e8 0c             	shr    $0xc,%eax
  80207a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	pagesAllocated[startPage] = num_Of_Pages;
  80207d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802080:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802083:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  80208a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80208d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802090:	eb 11                	jmp    8020a3 <smalloc+0x146>
		markedPages[s] = 1;
  802092:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802095:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  80209c:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = num_Of_Pages;
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  8020a0:	ff 45 e8             	incl   -0x18(%ebp)
  8020a3:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8020a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8020a9:	01 d0                	add    %edx,%eax
  8020ab:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8020ae:	77 e2                	ja     802092 <smalloc+0x135>
		markedPages[s] = 1;
	}
	int sharedobjID = sys_createSharedObject(sharedVarName, size, isWritable,
  8020b0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020b3:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
  8020b7:	52                   	push   %edx
  8020b8:	50                   	push   %eax
  8020b9:	ff 75 0c             	pushl  0xc(%ebp)
  8020bc:	ff 75 08             	pushl  0x8(%ebp)
  8020bf:	e8 8f 04 00 00       	call   802553 <sys_createSharedObject>
  8020c4:	83 c4 10             	add    $0x10,%esp
  8020c7:	89 45 c0             	mov    %eax,-0x40(%ebp)
			(void*) start);

	if (sharedobjID >= 0) {
  8020ca:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  8020ce:	78 12                	js     8020e2 <smalloc+0x185>
		shardIDs[startPage] = sharedobjID;
  8020d0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8020d3:	8b 55 c0             	mov    -0x40(%ebp),%edx
  8020d6:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  8020dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020e0:	eb 14                	jmp    8020f6 <smalloc+0x199>
	}
	free((void*) start);
  8020e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020e5:	83 ec 0c             	sub    $0xc,%esp
  8020e8:	50                   	push   %eax
  8020e9:	e8 6e fd ff ff       	call   801e5c <free>
  8020ee:	83 c4 10             	add    $0x10,%esp
	return NULL;
  8020f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020f6:	c9                   	leave  
  8020f7:	c3                   	ret    

008020f8 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  8020f8:	55                   	push   %ebp
  8020f9:	89 e5                	mov    %esp,%ebp
  8020fb:	83 ec 48             	sub    $0x48,%esp
	//cprintf("SSSSSGEEETTT\n");
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID, sharedVarName);
  8020fe:	83 ec 08             	sub    $0x8,%esp
  802101:	ff 75 0c             	pushl  0xc(%ebp)
  802104:	ff 75 08             	pushl  0x8(%ebp)
  802107:	e8 71 04 00 00       	call   80257d <sys_getSizeOfSharedObject>
  80210c:	83 c4 10             	add    $0x10,%esp
  80210f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (size < 0)
		return NULL;
	uint32 numb_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  802112:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802119:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80211c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80211f:	01 d0                	add    %edx,%eax
  802121:	48                   	dec    %eax
  802122:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802125:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802128:	ba 00 00 00 00       	mov    $0x0,%edx
  80212d:	f7 75 e0             	divl   -0x20(%ebp)
  802130:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802133:	29 d0                	sub    %edx,%eax
  802135:	c1 e8 0c             	shr    $0xc,%eax
  802138:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 free_Pages_Count = 0;
  80213b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  802142:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
  802149:	a1 20 50 80 00       	mov    0x805020,%eax
  80214e:	8b 40 7c             	mov    0x7c(%eax),%eax
  802151:	05 00 10 00 00       	add    $0x1000,%eax
  802156:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
  802159:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  80215e:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  802161:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
  802164:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80216b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80216e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802171:	01 d0                	add    %edx,%eax
  802173:	48                   	dec    %eax
  802174:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802177:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80217a:	ba 00 00 00 00       	mov    $0x0,%edx
  80217f:	f7 75 cc             	divl   -0x34(%ebp)
  802182:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802185:	29 d0                	sub    %edx,%eax
  802187:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80218a:	76 0a                	jbe    802196 <sget+0x9e>
		return NULL;
  80218c:	b8 00 00 00 00       	mov    $0x0,%eax
  802191:	e9 f7 00 00 00       	jmp    80228d <sget+0x195>
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  802196:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802199:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80219c:	eb 48                	jmp    8021e6 <sget+0xee>
		uint32 idx = (s - current_Addr) / PAGE_SIZE;
  80219e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021a1:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8021a4:	c1 e8 0c             	shr    $0xc,%eax
  8021a7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if (!markedPages[idx]) {
  8021aa:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8021ad:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  8021b4:	85 c0                	test   %eax,%eax
  8021b6:	75 11                	jne    8021c9 <sget+0xd1>
			free_Pages_Count++;
  8021b8:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  8021bb:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8021bf:	75 16                	jne    8021d7 <sget+0xdf>
				start = s;
  8021c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8021c7:	eb 0e                	jmp    8021d7 <sget+0xdf>
			}
		} else {
			free_Pages_Count = 0;
  8021c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  8021d0:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (free_Pages_Count == numb_Of_Pages) {
  8021d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021da:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8021dd:	74 12                	je     8021f1 <sget+0xf9>
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
		return NULL;
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  8021df:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  8021e6:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  8021ed:	76 af                	jbe    80219e <sget+0xa6>
  8021ef:	eb 01                	jmp    8021f2 <sget+0xfa>
		} else {
			free_Pages_Count = 0;
			start = (uint32) -1;
		}
		if (free_Pages_Count == numb_Of_Pages) {
			break;
  8021f1:	90                   	nop
		}
	}
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
  8021f2:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8021f6:	74 08                	je     802200 <sget+0x108>
  8021f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021fb:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8021fe:	74 0a                	je     80220a <sget+0x112>
		return NULL;
  802200:	b8 00 00 00 00       	mov    $0x0,%eax
  802205:	e9 83 00 00 00       	jmp    80228d <sget+0x195>
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
  80220a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80220d:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  802210:	c1 e8 0c             	shr    $0xc,%eax
  802213:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numb_Of_Pages;
  802216:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802219:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80221c:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  802223:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802226:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802229:	eb 11                	jmp    80223c <sget+0x144>
		markedPages[k] = 1;
  80222b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80222e:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  802235:	01 00 00 00 
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
	pagesAllocated[startPage] = numb_Of_Pages;
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  802239:	ff 45 e8             	incl   -0x18(%ebp)
  80223c:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80223f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802242:	01 d0                	add    %edx,%eax
  802244:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802247:	77 e2                	ja     80222b <sget+0x133>
		markedPages[k] = 1;
	}
	int ss = sys_getSharedObject(ownerEnvID, sharedVarName, (void*) start);
  802249:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80224c:	83 ec 04             	sub    $0x4,%esp
  80224f:	50                   	push   %eax
  802250:	ff 75 0c             	pushl  0xc(%ebp)
  802253:	ff 75 08             	pushl  0x8(%ebp)
  802256:	e8 3f 03 00 00       	call   80259a <sys_getSharedObject>
  80225b:	83 c4 10             	add    $0x10,%esp
  80225e:	89 45 bc             	mov    %eax,-0x44(%ebp)
	if (ss >= 0) {
  802261:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  802265:	78 12                	js     802279 <sget+0x181>
		shardIDs[startPage] = ss;
  802267:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80226a:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80226d:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  802274:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802277:	eb 14                	jmp    80228d <sget+0x195>
	}
	free((void*) start);
  802279:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80227c:	83 ec 0c             	sub    $0xc,%esp
  80227f:	50                   	push   %eax
  802280:	e8 d7 fb ff ff       	call   801e5c <free>
  802285:	83 c4 10             	add    $0x10,%esp
	return NULL;
  802288:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80228d:	c9                   	leave  
  80228e:	c3                   	ret    

0080228f <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  80228f:	55                   	push   %ebp
  802290:	89 e5                	mov    %esp,%ebp
  802292:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  802295:	8b 55 08             	mov    0x8(%ebp),%edx
  802298:	a1 20 50 80 00       	mov    0x805020,%eax
  80229d:	8b 40 7c             	mov    0x7c(%eax),%eax
  8022a0:	29 c2                	sub    %eax,%edx
  8022a2:	89 d0                	mov    %edx,%eax
  8022a4:	2d 00 10 00 00       	sub    $0x1000,%eax

void sfree(void* virtual_address) {
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
  8022a9:	c1 e8 0c             	shr    $0xc,%eax
  8022ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
	int id = shardIDs[pageIdx];
  8022af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b2:	8b 04 85 40 50 88 00 	mov    0x885040(,%eax,4),%eax
  8022b9:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int result = sys_freeSharedObject(id, virtual_address);
  8022bc:	83 ec 08             	sub    $0x8,%esp
  8022bf:	ff 75 08             	pushl  0x8(%ebp)
  8022c2:	ff 75 f0             	pushl  -0x10(%ebp)
  8022c5:	e8 ef 02 00 00       	call   8025b9 <sys_freeSharedObject>
  8022ca:	83 c4 10             	add    $0x10,%esp
  8022cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (result == 0) {
  8022d0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8022d4:	75 0e                	jne    8022e4 <sfree+0x55>
		shardIDs[pageIdx] = -1;  // Reset the ID after freeing
  8022d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d9:	c7 04 85 40 50 88 00 	movl   $0xffffffff,0x885040(,%eax,4)
  8022e0:	ff ff ff ff 
	}

}
  8022e4:	90                   	nop
  8022e5:	c9                   	leave  
  8022e6:	c3                   	ret    

008022e7 <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  8022e7:	55                   	push   %ebp
  8022e8:	89 e5                	mov    %esp,%ebp
  8022ea:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8022ed:	83 ec 04             	sub    $0x4,%esp
  8022f0:	68 b4 4a 80 00       	push   $0x804ab4
  8022f5:	68 19 01 00 00       	push   $0x119
  8022fa:	68 a6 4a 80 00       	push   $0x804aa6
  8022ff:	e8 2d e7 ff ff       	call   800a31 <_panic>

00802304 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  802304:	55                   	push   %ebp
  802305:	89 e5                	mov    %esp,%ebp
  802307:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80230a:	83 ec 04             	sub    $0x4,%esp
  80230d:	68 da 4a 80 00       	push   $0x804ada
  802312:	68 23 01 00 00       	push   $0x123
  802317:	68 a6 4a 80 00       	push   $0x804aa6
  80231c:	e8 10 e7 ff ff       	call   800a31 <_panic>

00802321 <shrink>:

}
void shrink(uint32 newSize) {
  802321:	55                   	push   %ebp
  802322:	89 e5                	mov    %esp,%ebp
  802324:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802327:	83 ec 04             	sub    $0x4,%esp
  80232a:	68 da 4a 80 00       	push   $0x804ada
  80232f:	68 27 01 00 00       	push   $0x127
  802334:	68 a6 4a 80 00       	push   $0x804aa6
  802339:	e8 f3 e6 ff ff       	call   800a31 <_panic>

0080233e <freeHeap>:

}
void freeHeap(void* virtual_address) {
  80233e:	55                   	push   %ebp
  80233f:	89 e5                	mov    %esp,%ebp
  802341:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802344:	83 ec 04             	sub    $0x4,%esp
  802347:	68 da 4a 80 00       	push   $0x804ada
  80234c:	68 2b 01 00 00       	push   $0x12b
  802351:	68 a6 4a 80 00       	push   $0x804aa6
  802356:	e8 d6 e6 ff ff       	call   800a31 <_panic>

0080235b <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  80235b:	55                   	push   %ebp
  80235c:	89 e5                	mov    %esp,%ebp
  80235e:	57                   	push   %edi
  80235f:	56                   	push   %esi
  802360:	53                   	push   %ebx
  802361:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802364:	8b 45 08             	mov    0x8(%ebp),%eax
  802367:	8b 55 0c             	mov    0xc(%ebp),%edx
  80236a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80236d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802370:	8b 7d 18             	mov    0x18(%ebp),%edi
  802373:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802376:	cd 30                	int    $0x30
  802378:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  80237b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80237e:	83 c4 10             	add    $0x10,%esp
  802381:	5b                   	pop    %ebx
  802382:	5e                   	pop    %esi
  802383:	5f                   	pop    %edi
  802384:	5d                   	pop    %ebp
  802385:	c3                   	ret    

00802386 <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  802386:	55                   	push   %ebp
  802387:	89 e5                	mov    %esp,%ebp
  802389:	83 ec 04             	sub    $0x4,%esp
  80238c:	8b 45 10             	mov    0x10(%ebp),%eax
  80238f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  802392:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802396:	8b 45 08             	mov    0x8(%ebp),%eax
  802399:	6a 00                	push   $0x0
  80239b:	6a 00                	push   $0x0
  80239d:	52                   	push   %edx
  80239e:	ff 75 0c             	pushl  0xc(%ebp)
  8023a1:	50                   	push   %eax
  8023a2:	6a 00                	push   $0x0
  8023a4:	e8 b2 ff ff ff       	call   80235b <syscall>
  8023a9:	83 c4 18             	add    $0x18,%esp
}
  8023ac:	90                   	nop
  8023ad:	c9                   	leave  
  8023ae:	c3                   	ret    

008023af <sys_cgetc>:

int sys_cgetc(void) {
  8023af:	55                   	push   %ebp
  8023b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8023b2:	6a 00                	push   $0x0
  8023b4:	6a 00                	push   $0x0
  8023b6:	6a 00                	push   $0x0
  8023b8:	6a 00                	push   $0x0
  8023ba:	6a 00                	push   $0x0
  8023bc:	6a 02                	push   $0x2
  8023be:	e8 98 ff ff ff       	call   80235b <syscall>
  8023c3:	83 c4 18             	add    $0x18,%esp
}
  8023c6:	c9                   	leave  
  8023c7:	c3                   	ret    

008023c8 <sys_lock_cons>:

void sys_lock_cons(void) {
  8023c8:	55                   	push   %ebp
  8023c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8023cb:	6a 00                	push   $0x0
  8023cd:	6a 00                	push   $0x0
  8023cf:	6a 00                	push   $0x0
  8023d1:	6a 00                	push   $0x0
  8023d3:	6a 00                	push   $0x0
  8023d5:	6a 03                	push   $0x3
  8023d7:	e8 7f ff ff ff       	call   80235b <syscall>
  8023dc:	83 c4 18             	add    $0x18,%esp
}
  8023df:	90                   	nop
  8023e0:	c9                   	leave  
  8023e1:	c3                   	ret    

008023e2 <sys_unlock_cons>:
void sys_unlock_cons(void) {
  8023e2:	55                   	push   %ebp
  8023e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8023e5:	6a 00                	push   $0x0
  8023e7:	6a 00                	push   $0x0
  8023e9:	6a 00                	push   $0x0
  8023eb:	6a 00                	push   $0x0
  8023ed:	6a 00                	push   $0x0
  8023ef:	6a 04                	push   $0x4
  8023f1:	e8 65 ff ff ff       	call   80235b <syscall>
  8023f6:	83 c4 18             	add    $0x18,%esp
}
  8023f9:	90                   	nop
  8023fa:	c9                   	leave  
  8023fb:	c3                   	ret    

008023fc <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  8023fc:	55                   	push   %ebp
  8023fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  8023ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  802402:	8b 45 08             	mov    0x8(%ebp),%eax
  802405:	6a 00                	push   $0x0
  802407:	6a 00                	push   $0x0
  802409:	6a 00                	push   $0x0
  80240b:	52                   	push   %edx
  80240c:	50                   	push   %eax
  80240d:	6a 08                	push   $0x8
  80240f:	e8 47 ff ff ff       	call   80235b <syscall>
  802414:	83 c4 18             	add    $0x18,%esp
}
  802417:	c9                   	leave  
  802418:	c3                   	ret    

00802419 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  802419:	55                   	push   %ebp
  80241a:	89 e5                	mov    %esp,%ebp
  80241c:	56                   	push   %esi
  80241d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  80241e:	8b 75 18             	mov    0x18(%ebp),%esi
  802421:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802424:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802427:	8b 55 0c             	mov    0xc(%ebp),%edx
  80242a:	8b 45 08             	mov    0x8(%ebp),%eax
  80242d:	56                   	push   %esi
  80242e:	53                   	push   %ebx
  80242f:	51                   	push   %ecx
  802430:	52                   	push   %edx
  802431:	50                   	push   %eax
  802432:	6a 09                	push   $0x9
  802434:	e8 22 ff ff ff       	call   80235b <syscall>
  802439:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  80243c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80243f:	5b                   	pop    %ebx
  802440:	5e                   	pop    %esi
  802441:	5d                   	pop    %ebp
  802442:	c3                   	ret    

00802443 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  802443:	55                   	push   %ebp
  802444:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802446:	8b 55 0c             	mov    0xc(%ebp),%edx
  802449:	8b 45 08             	mov    0x8(%ebp),%eax
  80244c:	6a 00                	push   $0x0
  80244e:	6a 00                	push   $0x0
  802450:	6a 00                	push   $0x0
  802452:	52                   	push   %edx
  802453:	50                   	push   %eax
  802454:	6a 0a                	push   $0xa
  802456:	e8 00 ff ff ff       	call   80235b <syscall>
  80245b:	83 c4 18             	add    $0x18,%esp
}
  80245e:	c9                   	leave  
  80245f:	c3                   	ret    

00802460 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  802460:	55                   	push   %ebp
  802461:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  802463:	6a 00                	push   $0x0
  802465:	6a 00                	push   $0x0
  802467:	6a 00                	push   $0x0
  802469:	ff 75 0c             	pushl  0xc(%ebp)
  80246c:	ff 75 08             	pushl  0x8(%ebp)
  80246f:	6a 0b                	push   $0xb
  802471:	e8 e5 fe ff ff       	call   80235b <syscall>
  802476:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  802479:	c9                   	leave  
  80247a:	c3                   	ret    

0080247b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  80247b:	55                   	push   %ebp
  80247c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80247e:	6a 00                	push   $0x0
  802480:	6a 00                	push   $0x0
  802482:	6a 00                	push   $0x0
  802484:	6a 00                	push   $0x0
  802486:	6a 00                	push   $0x0
  802488:	6a 0c                	push   $0xc
  80248a:	e8 cc fe ff ff       	call   80235b <syscall>
  80248f:	83 c4 18             	add    $0x18,%esp
}
  802492:	c9                   	leave  
  802493:	c3                   	ret    

00802494 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  802494:	55                   	push   %ebp
  802495:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802497:	6a 00                	push   $0x0
  802499:	6a 00                	push   $0x0
  80249b:	6a 00                	push   $0x0
  80249d:	6a 00                	push   $0x0
  80249f:	6a 00                	push   $0x0
  8024a1:	6a 0d                	push   $0xd
  8024a3:	e8 b3 fe ff ff       	call   80235b <syscall>
  8024a8:	83 c4 18             	add    $0x18,%esp
}
  8024ab:	c9                   	leave  
  8024ac:	c3                   	ret    

008024ad <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  8024ad:	55                   	push   %ebp
  8024ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8024b0:	6a 00                	push   $0x0
  8024b2:	6a 00                	push   $0x0
  8024b4:	6a 00                	push   $0x0
  8024b6:	6a 00                	push   $0x0
  8024b8:	6a 00                	push   $0x0
  8024ba:	6a 0e                	push   $0xe
  8024bc:	e8 9a fe ff ff       	call   80235b <syscall>
  8024c1:	83 c4 18             	add    $0x18,%esp
}
  8024c4:	c9                   	leave  
  8024c5:	c3                   	ret    

008024c6 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  8024c6:	55                   	push   %ebp
  8024c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  8024c9:	6a 00                	push   $0x0
  8024cb:	6a 00                	push   $0x0
  8024cd:	6a 00                	push   $0x0
  8024cf:	6a 00                	push   $0x0
  8024d1:	6a 00                	push   $0x0
  8024d3:	6a 0f                	push   $0xf
  8024d5:	e8 81 fe ff ff       	call   80235b <syscall>
  8024da:	83 c4 18             	add    $0x18,%esp
}
  8024dd:	c9                   	leave  
  8024de:	c3                   	ret    

008024df <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  8024df:	55                   	push   %ebp
  8024e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  8024e2:	6a 00                	push   $0x0
  8024e4:	6a 00                	push   $0x0
  8024e6:	6a 00                	push   $0x0
  8024e8:	6a 00                	push   $0x0
  8024ea:	ff 75 08             	pushl  0x8(%ebp)
  8024ed:	6a 10                	push   $0x10
  8024ef:	e8 67 fe ff ff       	call   80235b <syscall>
  8024f4:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  8024f7:	c9                   	leave  
  8024f8:	c3                   	ret    

008024f9 <sys_scarce_memory>:

void sys_scarce_memory() {
  8024f9:	55                   	push   %ebp
  8024fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  8024fc:	6a 00                	push   $0x0
  8024fe:	6a 00                	push   $0x0
  802500:	6a 00                	push   $0x0
  802502:	6a 00                	push   $0x0
  802504:	6a 00                	push   $0x0
  802506:	6a 11                	push   $0x11
  802508:	e8 4e fe ff ff       	call   80235b <syscall>
  80250d:	83 c4 18             	add    $0x18,%esp
}
  802510:	90                   	nop
  802511:	c9                   	leave  
  802512:	c3                   	ret    

00802513 <sys_cputc>:

void sys_cputc(const char c) {
  802513:	55                   	push   %ebp
  802514:	89 e5                	mov    %esp,%ebp
  802516:	83 ec 04             	sub    $0x4,%esp
  802519:	8b 45 08             	mov    0x8(%ebp),%eax
  80251c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80251f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802523:	6a 00                	push   $0x0
  802525:	6a 00                	push   $0x0
  802527:	6a 00                	push   $0x0
  802529:	6a 00                	push   $0x0
  80252b:	50                   	push   %eax
  80252c:	6a 01                	push   $0x1
  80252e:	e8 28 fe ff ff       	call   80235b <syscall>
  802533:	83 c4 18             	add    $0x18,%esp
}
  802536:	90                   	nop
  802537:	c9                   	leave  
  802538:	c3                   	ret    

00802539 <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  802539:	55                   	push   %ebp
  80253a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  80253c:	6a 00                	push   $0x0
  80253e:	6a 00                	push   $0x0
  802540:	6a 00                	push   $0x0
  802542:	6a 00                	push   $0x0
  802544:	6a 00                	push   $0x0
  802546:	6a 14                	push   $0x14
  802548:	e8 0e fe ff ff       	call   80235b <syscall>
  80254d:	83 c4 18             	add    $0x18,%esp
}
  802550:	90                   	nop
  802551:	c9                   	leave  
  802552:	c3                   	ret    

00802553 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  802553:	55                   	push   %ebp
  802554:	89 e5                	mov    %esp,%ebp
  802556:	83 ec 04             	sub    $0x4,%esp
  802559:	8b 45 10             	mov    0x10(%ebp),%eax
  80255c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  80255f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802562:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802566:	8b 45 08             	mov    0x8(%ebp),%eax
  802569:	6a 00                	push   $0x0
  80256b:	51                   	push   %ecx
  80256c:	52                   	push   %edx
  80256d:	ff 75 0c             	pushl  0xc(%ebp)
  802570:	50                   	push   %eax
  802571:	6a 15                	push   $0x15
  802573:	e8 e3 fd ff ff       	call   80235b <syscall>
  802578:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  80257b:	c9                   	leave  
  80257c:	c3                   	ret    

0080257d <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  80257d:	55                   	push   %ebp
  80257e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  802580:	8b 55 0c             	mov    0xc(%ebp),%edx
  802583:	8b 45 08             	mov    0x8(%ebp),%eax
  802586:	6a 00                	push   $0x0
  802588:	6a 00                	push   $0x0
  80258a:	6a 00                	push   $0x0
  80258c:	52                   	push   %edx
  80258d:	50                   	push   %eax
  80258e:	6a 16                	push   $0x16
  802590:	e8 c6 fd ff ff       	call   80235b <syscall>
  802595:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  802598:	c9                   	leave  
  802599:	c3                   	ret    

0080259a <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  80259a:	55                   	push   %ebp
  80259b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  80259d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8025a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a6:	6a 00                	push   $0x0
  8025a8:	6a 00                	push   $0x0
  8025aa:	51                   	push   %ecx
  8025ab:	52                   	push   %edx
  8025ac:	50                   	push   %eax
  8025ad:	6a 17                	push   $0x17
  8025af:	e8 a7 fd ff ff       	call   80235b <syscall>
  8025b4:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  8025b7:	c9                   	leave  
  8025b8:	c3                   	ret    

008025b9 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  8025b9:	55                   	push   %ebp
  8025ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  8025bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c2:	6a 00                	push   $0x0
  8025c4:	6a 00                	push   $0x0
  8025c6:	6a 00                	push   $0x0
  8025c8:	52                   	push   %edx
  8025c9:	50                   	push   %eax
  8025ca:	6a 18                	push   $0x18
  8025cc:	e8 8a fd ff ff       	call   80235b <syscall>
  8025d1:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  8025d4:	c9                   	leave  
  8025d5:	c3                   	ret    

008025d6 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  8025d6:	55                   	push   %ebp
  8025d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  8025d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025dc:	6a 00                	push   $0x0
  8025de:	ff 75 14             	pushl  0x14(%ebp)
  8025e1:	ff 75 10             	pushl  0x10(%ebp)
  8025e4:	ff 75 0c             	pushl  0xc(%ebp)
  8025e7:	50                   	push   %eax
  8025e8:	6a 19                	push   $0x19
  8025ea:	e8 6c fd ff ff       	call   80235b <syscall>
  8025ef:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  8025f2:	c9                   	leave  
  8025f3:	c3                   	ret    

008025f4 <sys_run_env>:

void sys_run_env(int32 envId) {
  8025f4:	55                   	push   %ebp
  8025f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  8025f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fa:	6a 00                	push   $0x0
  8025fc:	6a 00                	push   $0x0
  8025fe:	6a 00                	push   $0x0
  802600:	6a 00                	push   $0x0
  802602:	50                   	push   %eax
  802603:	6a 1a                	push   $0x1a
  802605:	e8 51 fd ff ff       	call   80235b <syscall>
  80260a:	83 c4 18             	add    $0x18,%esp
}
  80260d:	90                   	nop
  80260e:	c9                   	leave  
  80260f:	c3                   	ret    

00802610 <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  802610:	55                   	push   %ebp
  802611:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802613:	8b 45 08             	mov    0x8(%ebp),%eax
  802616:	6a 00                	push   $0x0
  802618:	6a 00                	push   $0x0
  80261a:	6a 00                	push   $0x0
  80261c:	6a 00                	push   $0x0
  80261e:	50                   	push   %eax
  80261f:	6a 1b                	push   $0x1b
  802621:	e8 35 fd ff ff       	call   80235b <syscall>
  802626:	83 c4 18             	add    $0x18,%esp
}
  802629:	c9                   	leave  
  80262a:	c3                   	ret    

0080262b <sys_getenvid>:

int32 sys_getenvid(void) {
  80262b:	55                   	push   %ebp
  80262c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80262e:	6a 00                	push   $0x0
  802630:	6a 00                	push   $0x0
  802632:	6a 00                	push   $0x0
  802634:	6a 00                	push   $0x0
  802636:	6a 00                	push   $0x0
  802638:	6a 05                	push   $0x5
  80263a:	e8 1c fd ff ff       	call   80235b <syscall>
  80263f:	83 c4 18             	add    $0x18,%esp
}
  802642:	c9                   	leave  
  802643:	c3                   	ret    

00802644 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  802644:	55                   	push   %ebp
  802645:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802647:	6a 00                	push   $0x0
  802649:	6a 00                	push   $0x0
  80264b:	6a 00                	push   $0x0
  80264d:	6a 00                	push   $0x0
  80264f:	6a 00                	push   $0x0
  802651:	6a 06                	push   $0x6
  802653:	e8 03 fd ff ff       	call   80235b <syscall>
  802658:	83 c4 18             	add    $0x18,%esp
}
  80265b:	c9                   	leave  
  80265c:	c3                   	ret    

0080265d <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  80265d:	55                   	push   %ebp
  80265e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802660:	6a 00                	push   $0x0
  802662:	6a 00                	push   $0x0
  802664:	6a 00                	push   $0x0
  802666:	6a 00                	push   $0x0
  802668:	6a 00                	push   $0x0
  80266a:	6a 07                	push   $0x7
  80266c:	e8 ea fc ff ff       	call   80235b <syscall>
  802671:	83 c4 18             	add    $0x18,%esp
}
  802674:	c9                   	leave  
  802675:	c3                   	ret    

00802676 <sys_exit_env>:

void sys_exit_env(void) {
  802676:	55                   	push   %ebp
  802677:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802679:	6a 00                	push   $0x0
  80267b:	6a 00                	push   $0x0
  80267d:	6a 00                	push   $0x0
  80267f:	6a 00                	push   $0x0
  802681:	6a 00                	push   $0x0
  802683:	6a 1c                	push   $0x1c
  802685:	e8 d1 fc ff ff       	call   80235b <syscall>
  80268a:	83 c4 18             	add    $0x18,%esp
}
  80268d:	90                   	nop
  80268e:	c9                   	leave  
  80268f:	c3                   	ret    

00802690 <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  802690:	55                   	push   %ebp
  802691:	89 e5                	mov    %esp,%ebp
  802693:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  802696:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802699:	8d 50 04             	lea    0x4(%eax),%edx
  80269c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80269f:	6a 00                	push   $0x0
  8026a1:	6a 00                	push   $0x0
  8026a3:	6a 00                	push   $0x0
  8026a5:	52                   	push   %edx
  8026a6:	50                   	push   %eax
  8026a7:	6a 1d                	push   $0x1d
  8026a9:	e8 ad fc ff ff       	call   80235b <syscall>
  8026ae:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  8026b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8026b7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8026ba:	89 01                	mov    %eax,(%ecx)
  8026bc:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8026bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c2:	c9                   	leave  
  8026c3:	c2 04 00             	ret    $0x4

008026c6 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  8026c6:	55                   	push   %ebp
  8026c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  8026c9:	6a 00                	push   $0x0
  8026cb:	6a 00                	push   $0x0
  8026cd:	ff 75 10             	pushl  0x10(%ebp)
  8026d0:	ff 75 0c             	pushl  0xc(%ebp)
  8026d3:	ff 75 08             	pushl  0x8(%ebp)
  8026d6:	6a 13                	push   $0x13
  8026d8:	e8 7e fc ff ff       	call   80235b <syscall>
  8026dd:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  8026e0:	90                   	nop
}
  8026e1:	c9                   	leave  
  8026e2:	c3                   	ret    

008026e3 <sys_rcr2>:
uint32 sys_rcr2() {
  8026e3:	55                   	push   %ebp
  8026e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8026e6:	6a 00                	push   $0x0
  8026e8:	6a 00                	push   $0x0
  8026ea:	6a 00                	push   $0x0
  8026ec:	6a 00                	push   $0x0
  8026ee:	6a 00                	push   $0x0
  8026f0:	6a 1e                	push   $0x1e
  8026f2:	e8 64 fc ff ff       	call   80235b <syscall>
  8026f7:	83 c4 18             	add    $0x18,%esp
}
  8026fa:	c9                   	leave  
  8026fb:	c3                   	ret    

008026fc <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  8026fc:	55                   	push   %ebp
  8026fd:	89 e5                	mov    %esp,%ebp
  8026ff:	83 ec 04             	sub    $0x4,%esp
  802702:	8b 45 08             	mov    0x8(%ebp),%eax
  802705:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802708:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80270c:	6a 00                	push   $0x0
  80270e:	6a 00                	push   $0x0
  802710:	6a 00                	push   $0x0
  802712:	6a 00                	push   $0x0
  802714:	50                   	push   %eax
  802715:	6a 1f                	push   $0x1f
  802717:	e8 3f fc ff ff       	call   80235b <syscall>
  80271c:	83 c4 18             	add    $0x18,%esp
	return;
  80271f:	90                   	nop
}
  802720:	c9                   	leave  
  802721:	c3                   	ret    

00802722 <rsttst>:
void rsttst() {
  802722:	55                   	push   %ebp
  802723:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802725:	6a 00                	push   $0x0
  802727:	6a 00                	push   $0x0
  802729:	6a 00                	push   $0x0
  80272b:	6a 00                	push   $0x0
  80272d:	6a 00                	push   $0x0
  80272f:	6a 21                	push   $0x21
  802731:	e8 25 fc ff ff       	call   80235b <syscall>
  802736:	83 c4 18             	add    $0x18,%esp
	return;
  802739:	90                   	nop
}
  80273a:	c9                   	leave  
  80273b:	c3                   	ret    

0080273c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  80273c:	55                   	push   %ebp
  80273d:	89 e5                	mov    %esp,%ebp
  80273f:	83 ec 04             	sub    $0x4,%esp
  802742:	8b 45 14             	mov    0x14(%ebp),%eax
  802745:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802748:	8b 55 18             	mov    0x18(%ebp),%edx
  80274b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80274f:	52                   	push   %edx
  802750:	50                   	push   %eax
  802751:	ff 75 10             	pushl  0x10(%ebp)
  802754:	ff 75 0c             	pushl  0xc(%ebp)
  802757:	ff 75 08             	pushl  0x8(%ebp)
  80275a:	6a 20                	push   $0x20
  80275c:	e8 fa fb ff ff       	call   80235b <syscall>
  802761:	83 c4 18             	add    $0x18,%esp
	return;
  802764:	90                   	nop
}
  802765:	c9                   	leave  
  802766:	c3                   	ret    

00802767 <chktst>:
void chktst(uint32 n) {
  802767:	55                   	push   %ebp
  802768:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80276a:	6a 00                	push   $0x0
  80276c:	6a 00                	push   $0x0
  80276e:	6a 00                	push   $0x0
  802770:	6a 00                	push   $0x0
  802772:	ff 75 08             	pushl  0x8(%ebp)
  802775:	6a 22                	push   $0x22
  802777:	e8 df fb ff ff       	call   80235b <syscall>
  80277c:	83 c4 18             	add    $0x18,%esp
	return;
  80277f:	90                   	nop
}
  802780:	c9                   	leave  
  802781:	c3                   	ret    

00802782 <inctst>:

void inctst() {
  802782:	55                   	push   %ebp
  802783:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802785:	6a 00                	push   $0x0
  802787:	6a 00                	push   $0x0
  802789:	6a 00                	push   $0x0
  80278b:	6a 00                	push   $0x0
  80278d:	6a 00                	push   $0x0
  80278f:	6a 23                	push   $0x23
  802791:	e8 c5 fb ff ff       	call   80235b <syscall>
  802796:	83 c4 18             	add    $0x18,%esp
	return;
  802799:	90                   	nop
}
  80279a:	c9                   	leave  
  80279b:	c3                   	ret    

0080279c <gettst>:
uint32 gettst() {
  80279c:	55                   	push   %ebp
  80279d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80279f:	6a 00                	push   $0x0
  8027a1:	6a 00                	push   $0x0
  8027a3:	6a 00                	push   $0x0
  8027a5:	6a 00                	push   $0x0
  8027a7:	6a 00                	push   $0x0
  8027a9:	6a 24                	push   $0x24
  8027ab:	e8 ab fb ff ff       	call   80235b <syscall>
  8027b0:	83 c4 18             	add    $0x18,%esp
}
  8027b3:	c9                   	leave  
  8027b4:	c3                   	ret    

008027b5 <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  8027b5:	55                   	push   %ebp
  8027b6:	89 e5                	mov    %esp,%ebp
  8027b8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8027bb:	6a 00                	push   $0x0
  8027bd:	6a 00                	push   $0x0
  8027bf:	6a 00                	push   $0x0
  8027c1:	6a 00                	push   $0x0
  8027c3:	6a 00                	push   $0x0
  8027c5:	6a 25                	push   $0x25
  8027c7:	e8 8f fb ff ff       	call   80235b <syscall>
  8027cc:	83 c4 18             	add    $0x18,%esp
  8027cf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8027d2:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8027d6:	75 07                	jne    8027df <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8027d8:	b8 01 00 00 00       	mov    $0x1,%eax
  8027dd:	eb 05                	jmp    8027e4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8027df:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027e4:	c9                   	leave  
  8027e5:	c3                   	ret    

008027e6 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  8027e6:	55                   	push   %ebp
  8027e7:	89 e5                	mov    %esp,%ebp
  8027e9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8027ec:	6a 00                	push   $0x0
  8027ee:	6a 00                	push   $0x0
  8027f0:	6a 00                	push   $0x0
  8027f2:	6a 00                	push   $0x0
  8027f4:	6a 00                	push   $0x0
  8027f6:	6a 25                	push   $0x25
  8027f8:	e8 5e fb ff ff       	call   80235b <syscall>
  8027fd:	83 c4 18             	add    $0x18,%esp
  802800:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802803:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802807:	75 07                	jne    802810 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802809:	b8 01 00 00 00       	mov    $0x1,%eax
  80280e:	eb 05                	jmp    802815 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802810:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802815:	c9                   	leave  
  802816:	c3                   	ret    

00802817 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  802817:	55                   	push   %ebp
  802818:	89 e5                	mov    %esp,%ebp
  80281a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80281d:	6a 00                	push   $0x0
  80281f:	6a 00                	push   $0x0
  802821:	6a 00                	push   $0x0
  802823:	6a 00                	push   $0x0
  802825:	6a 00                	push   $0x0
  802827:	6a 25                	push   $0x25
  802829:	e8 2d fb ff ff       	call   80235b <syscall>
  80282e:	83 c4 18             	add    $0x18,%esp
  802831:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802834:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802838:	75 07                	jne    802841 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80283a:	b8 01 00 00 00       	mov    $0x1,%eax
  80283f:	eb 05                	jmp    802846 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802841:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802846:	c9                   	leave  
  802847:	c3                   	ret    

00802848 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  802848:	55                   	push   %ebp
  802849:	89 e5                	mov    %esp,%ebp
  80284b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80284e:	6a 00                	push   $0x0
  802850:	6a 00                	push   $0x0
  802852:	6a 00                	push   $0x0
  802854:	6a 00                	push   $0x0
  802856:	6a 00                	push   $0x0
  802858:	6a 25                	push   $0x25
  80285a:	e8 fc fa ff ff       	call   80235b <syscall>
  80285f:	83 c4 18             	add    $0x18,%esp
  802862:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802865:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802869:	75 07                	jne    802872 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80286b:	b8 01 00 00 00       	mov    $0x1,%eax
  802870:	eb 05                	jmp    802877 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802872:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802877:	c9                   	leave  
  802878:	c3                   	ret    

00802879 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  802879:	55                   	push   %ebp
  80287a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80287c:	6a 00                	push   $0x0
  80287e:	6a 00                	push   $0x0
  802880:	6a 00                	push   $0x0
  802882:	6a 00                	push   $0x0
  802884:	ff 75 08             	pushl  0x8(%ebp)
  802887:	6a 26                	push   $0x26
  802889:	e8 cd fa ff ff       	call   80235b <syscall>
  80288e:	83 c4 18             	add    $0x18,%esp
	return;
  802891:	90                   	nop
}
  802892:	c9                   	leave  
  802893:	c3                   	ret    

00802894 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  802894:	55                   	push   %ebp
  802895:	89 e5                	mov    %esp,%ebp
  802897:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  802898:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80289b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80289e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a4:	6a 00                	push   $0x0
  8028a6:	53                   	push   %ebx
  8028a7:	51                   	push   %ecx
  8028a8:	52                   	push   %edx
  8028a9:	50                   	push   %eax
  8028aa:	6a 27                	push   $0x27
  8028ac:	e8 aa fa ff ff       	call   80235b <syscall>
  8028b1:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  8028b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8028b7:	c9                   	leave  
  8028b8:	c3                   	ret    

008028b9 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  8028b9:	55                   	push   %ebp
  8028ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  8028bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c2:	6a 00                	push   $0x0
  8028c4:	6a 00                	push   $0x0
  8028c6:	6a 00                	push   $0x0
  8028c8:	52                   	push   %edx
  8028c9:	50                   	push   %eax
  8028ca:	6a 28                	push   $0x28
  8028cc:	e8 8a fa ff ff       	call   80235b <syscall>
  8028d1:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  8028d4:	c9                   	leave  
  8028d5:	c3                   	ret    

008028d6 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  8028d6:	55                   	push   %ebp
  8028d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  8028d9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8028dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028df:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e2:	6a 00                	push   $0x0
  8028e4:	51                   	push   %ecx
  8028e5:	ff 75 10             	pushl  0x10(%ebp)
  8028e8:	52                   	push   %edx
  8028e9:	50                   	push   %eax
  8028ea:	6a 29                	push   $0x29
  8028ec:	e8 6a fa ff ff       	call   80235b <syscall>
  8028f1:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  8028f4:	c9                   	leave  
  8028f5:	c3                   	ret    

008028f6 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  8028f6:	55                   	push   %ebp
  8028f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8028f9:	6a 00                	push   $0x0
  8028fb:	6a 00                	push   $0x0
  8028fd:	ff 75 10             	pushl  0x10(%ebp)
  802900:	ff 75 0c             	pushl  0xc(%ebp)
  802903:	ff 75 08             	pushl  0x8(%ebp)
  802906:	6a 12                	push   $0x12
  802908:	e8 4e fa ff ff       	call   80235b <syscall>
  80290d:	83 c4 18             	add    $0x18,%esp
	return;
  802910:	90                   	nop
}
  802911:	c9                   	leave  
  802912:	c3                   	ret    

00802913 <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  802913:	55                   	push   %ebp
  802914:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  802916:	8b 55 0c             	mov    0xc(%ebp),%edx
  802919:	8b 45 08             	mov    0x8(%ebp),%eax
  80291c:	6a 00                	push   $0x0
  80291e:	6a 00                	push   $0x0
  802920:	6a 00                	push   $0x0
  802922:	52                   	push   %edx
  802923:	50                   	push   %eax
  802924:	6a 2a                	push   $0x2a
  802926:	e8 30 fa ff ff       	call   80235b <syscall>
  80292b:	83 c4 18             	add    $0x18,%esp
	return;
  80292e:	90                   	nop
}
  80292f:	c9                   	leave  
  802930:	c3                   	ret    

00802931 <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  802931:	55                   	push   %ebp
  802932:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  802934:	8b 45 08             	mov    0x8(%ebp),%eax
  802937:	6a 00                	push   $0x0
  802939:	6a 00                	push   $0x0
  80293b:	6a 00                	push   $0x0
  80293d:	6a 00                	push   $0x0
  80293f:	50                   	push   %eax
  802940:	6a 2b                	push   $0x2b
  802942:	e8 14 fa ff ff       	call   80235b <syscall>
  802947:	83 c4 18             	add    $0x18,%esp
}
  80294a:	c9                   	leave  
  80294b:	c3                   	ret    

0080294c <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  80294c:	55                   	push   %ebp
  80294d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80294f:	6a 00                	push   $0x0
  802951:	6a 00                	push   $0x0
  802953:	6a 00                	push   $0x0
  802955:	ff 75 0c             	pushl  0xc(%ebp)
  802958:	ff 75 08             	pushl  0x8(%ebp)
  80295b:	6a 2c                	push   $0x2c
  80295d:	e8 f9 f9 ff ff       	call   80235b <syscall>
  802962:	83 c4 18             	add    $0x18,%esp
	return;
  802965:	90                   	nop
}
  802966:	c9                   	leave  
  802967:	c3                   	ret    

00802968 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  802968:	55                   	push   %ebp
  802969:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80296b:	6a 00                	push   $0x0
  80296d:	6a 00                	push   $0x0
  80296f:	6a 00                	push   $0x0
  802971:	ff 75 0c             	pushl  0xc(%ebp)
  802974:	ff 75 08             	pushl  0x8(%ebp)
  802977:	6a 2d                	push   $0x2d
  802979:	e8 dd f9 ff ff       	call   80235b <syscall>
  80297e:	83 c4 18             	add    $0x18,%esp
	return;
  802981:	90                   	nop
}
  802982:	c9                   	leave  
  802983:	c3                   	ret    

00802984 <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  802984:	55                   	push   %ebp
  802985:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  802987:	8b 45 08             	mov    0x8(%ebp),%eax
  80298a:	6a 00                	push   $0x0
  80298c:	6a 00                	push   $0x0
  80298e:	6a 00                	push   $0x0
  802990:	6a 00                	push   $0x0
  802992:	50                   	push   %eax
  802993:	6a 2f                	push   $0x2f
  802995:	e8 c1 f9 ff ff       	call   80235b <syscall>
  80299a:	83 c4 18             	add    $0x18,%esp
	return;
  80299d:	90                   	nop
}
  80299e:	c9                   	leave  
  80299f:	c3                   	ret    

008029a0 <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  8029a0:	55                   	push   %ebp
  8029a1:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  8029a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a9:	6a 00                	push   $0x0
  8029ab:	6a 00                	push   $0x0
  8029ad:	6a 00                	push   $0x0
  8029af:	52                   	push   %edx
  8029b0:	50                   	push   %eax
  8029b1:	6a 30                	push   $0x30
  8029b3:	e8 a3 f9 ff ff       	call   80235b <syscall>
  8029b8:	83 c4 18             	add    $0x18,%esp
	return;
  8029bb:	90                   	nop
}
  8029bc:	c9                   	leave  
  8029bd:	c3                   	ret    

008029be <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  8029be:	55                   	push   %ebp
  8029bf:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  8029c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c4:	6a 00                	push   $0x0
  8029c6:	6a 00                	push   $0x0
  8029c8:	6a 00                	push   $0x0
  8029ca:	6a 00                	push   $0x0
  8029cc:	50                   	push   %eax
  8029cd:	6a 31                	push   $0x31
  8029cf:	e8 87 f9 ff ff       	call   80235b <syscall>
  8029d4:	83 c4 18             	add    $0x18,%esp
	return;
  8029d7:	90                   	nop
}
  8029d8:	c9                   	leave  
  8029d9:	c3                   	ret    

008029da <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  8029da:	55                   	push   %ebp
  8029db:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8029dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e3:	6a 00                	push   $0x0
  8029e5:	6a 00                	push   $0x0
  8029e7:	6a 00                	push   $0x0
  8029e9:	52                   	push   %edx
  8029ea:	50                   	push   %eax
  8029eb:	6a 2e                	push   $0x2e
  8029ed:	e8 69 f9 ff ff       	call   80235b <syscall>
  8029f2:	83 c4 18             	add    $0x18,%esp
    return;
  8029f5:	90                   	nop
}
  8029f6:	c9                   	leave  
  8029f7:	c3                   	ret    

008029f8 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  8029f8:	55                   	push   %ebp
  8029f9:	89 e5                	mov    %esp,%ebp
  8029fb:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8029fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802a01:	83 e8 04             	sub    $0x4,%eax
  802a04:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802a07:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a0a:	8b 00                	mov    (%eax),%eax
  802a0c:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802a0f:	c9                   	leave  
  802a10:	c3                   	ret    

00802a11 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802a11:	55                   	push   %ebp
  802a12:	89 e5                	mov    %esp,%ebp
  802a14:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802a17:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1a:	83 e8 04             	sub    $0x4,%eax
  802a1d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802a20:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a23:	8b 00                	mov    (%eax),%eax
  802a25:	83 e0 01             	and    $0x1,%eax
  802a28:	85 c0                	test   %eax,%eax
  802a2a:	0f 94 c0             	sete   %al
}
  802a2d:	c9                   	leave  
  802a2e:	c3                   	ret    

00802a2f <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802a2f:	55                   	push   %ebp
  802a30:	89 e5                	mov    %esp,%ebp
  802a32:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802a35:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802a3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a3f:	83 f8 02             	cmp    $0x2,%eax
  802a42:	74 2b                	je     802a6f <alloc_block+0x40>
  802a44:	83 f8 02             	cmp    $0x2,%eax
  802a47:	7f 07                	jg     802a50 <alloc_block+0x21>
  802a49:	83 f8 01             	cmp    $0x1,%eax
  802a4c:	74 0e                	je     802a5c <alloc_block+0x2d>
  802a4e:	eb 58                	jmp    802aa8 <alloc_block+0x79>
  802a50:	83 f8 03             	cmp    $0x3,%eax
  802a53:	74 2d                	je     802a82 <alloc_block+0x53>
  802a55:	83 f8 04             	cmp    $0x4,%eax
  802a58:	74 3b                	je     802a95 <alloc_block+0x66>
  802a5a:	eb 4c                	jmp    802aa8 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802a5c:	83 ec 0c             	sub    $0xc,%esp
  802a5f:	ff 75 08             	pushl  0x8(%ebp)
  802a62:	e8 f7 03 00 00       	call   802e5e <alloc_block_FF>
  802a67:	83 c4 10             	add    $0x10,%esp
  802a6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802a6d:	eb 4a                	jmp    802ab9 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802a6f:	83 ec 0c             	sub    $0xc,%esp
  802a72:	ff 75 08             	pushl  0x8(%ebp)
  802a75:	e8 f0 11 00 00       	call   803c6a <alloc_block_NF>
  802a7a:	83 c4 10             	add    $0x10,%esp
  802a7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802a80:	eb 37                	jmp    802ab9 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802a82:	83 ec 0c             	sub    $0xc,%esp
  802a85:	ff 75 08             	pushl  0x8(%ebp)
  802a88:	e8 08 08 00 00       	call   803295 <alloc_block_BF>
  802a8d:	83 c4 10             	add    $0x10,%esp
  802a90:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802a93:	eb 24                	jmp    802ab9 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802a95:	83 ec 0c             	sub    $0xc,%esp
  802a98:	ff 75 08             	pushl  0x8(%ebp)
  802a9b:	e8 ad 11 00 00       	call   803c4d <alloc_block_WF>
  802aa0:	83 c4 10             	add    $0x10,%esp
  802aa3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802aa6:	eb 11                	jmp    802ab9 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802aa8:	83 ec 0c             	sub    $0xc,%esp
  802aab:	68 ec 4a 80 00       	push   $0x804aec
  802ab0:	e8 39 e2 ff ff       	call   800cee <cprintf>
  802ab5:	83 c4 10             	add    $0x10,%esp
		break;
  802ab8:	90                   	nop
	}
	return va;
  802ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802abc:	c9                   	leave  
  802abd:	c3                   	ret    

00802abe <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802abe:	55                   	push   %ebp
  802abf:	89 e5                	mov    %esp,%ebp
  802ac1:	53                   	push   %ebx
  802ac2:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802ac5:	83 ec 0c             	sub    $0xc,%esp
  802ac8:	68 0c 4b 80 00       	push   $0x804b0c
  802acd:	e8 1c e2 ff ff       	call   800cee <cprintf>
  802ad2:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802ad5:	83 ec 0c             	sub    $0xc,%esp
  802ad8:	68 37 4b 80 00       	push   $0x804b37
  802add:	e8 0c e2 ff ff       	call   800cee <cprintf>
  802ae2:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aeb:	eb 37                	jmp    802b24 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802aed:	83 ec 0c             	sub    $0xc,%esp
  802af0:	ff 75 f4             	pushl  -0xc(%ebp)
  802af3:	e8 19 ff ff ff       	call   802a11 <is_free_block>
  802af8:	83 c4 10             	add    $0x10,%esp
  802afb:	0f be d8             	movsbl %al,%ebx
  802afe:	83 ec 0c             	sub    $0xc,%esp
  802b01:	ff 75 f4             	pushl  -0xc(%ebp)
  802b04:	e8 ef fe ff ff       	call   8029f8 <get_block_size>
  802b09:	83 c4 10             	add    $0x10,%esp
  802b0c:	83 ec 04             	sub    $0x4,%esp
  802b0f:	53                   	push   %ebx
  802b10:	50                   	push   %eax
  802b11:	68 4f 4b 80 00       	push   $0x804b4f
  802b16:	e8 d3 e1 ff ff       	call   800cee <cprintf>
  802b1b:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802b1e:	8b 45 10             	mov    0x10(%ebp),%eax
  802b21:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b24:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b28:	74 07                	je     802b31 <print_blocks_list+0x73>
  802b2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2d:	8b 00                	mov    (%eax),%eax
  802b2f:	eb 05                	jmp    802b36 <print_blocks_list+0x78>
  802b31:	b8 00 00 00 00       	mov    $0x0,%eax
  802b36:	89 45 10             	mov    %eax,0x10(%ebp)
  802b39:	8b 45 10             	mov    0x10(%ebp),%eax
  802b3c:	85 c0                	test   %eax,%eax
  802b3e:	75 ad                	jne    802aed <print_blocks_list+0x2f>
  802b40:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b44:	75 a7                	jne    802aed <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802b46:	83 ec 0c             	sub    $0xc,%esp
  802b49:	68 0c 4b 80 00       	push   $0x804b0c
  802b4e:	e8 9b e1 ff ff       	call   800cee <cprintf>
  802b53:	83 c4 10             	add    $0x10,%esp

}
  802b56:	90                   	nop
  802b57:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802b5a:	c9                   	leave  
  802b5b:	c3                   	ret    

00802b5c <initialize_dynamic_allocator>:

//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802b5c:	55                   	push   %ebp
  802b5d:	89 e5                	mov    %esp,%ebp
  802b5f:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802b62:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b65:	83 e0 01             	and    $0x1,%eax
  802b68:	85 c0                	test   %eax,%eax
  802b6a:	74 03                	je     802b6f <initialize_dynamic_allocator+0x13>
  802b6c:	ff 45 0c             	incl   0xc(%ebp)
		if (initSizeOfAllocatedSpace == 0)
  802b6f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802b73:	0f 84 f8 00 00 00    	je     802c71 <initialize_dynamic_allocator+0x115>
			return ;
		is_initialized = 1;
  802b79:	c7 05 40 50 98 00 01 	movl   $0x1,0x985040
  802b80:	00 00 00 
	//TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("initialize_dynamic_allocator is not implemented yet");
	//Your Code is Here...

	if(is_initialized){
  802b83:	a1 40 50 98 00       	mov    0x985040,%eax
  802b88:	85 c0                	test   %eax,%eax
  802b8a:	0f 84 e2 00 00 00    	je     802c72 <initialize_dynamic_allocator+0x116>

		// begin block with size 0 and lsb = 1 (allocated)
		uint32* beginBlock = (uint32*)daStart;
  802b90:	8b 45 08             	mov    0x8(%ebp),%eax
  802b93:	89 45 f4             	mov    %eax,-0xc(%ebp)
		*beginBlock = 0 | 1; // size = 0, LSB as a flag = 1
  802b96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b99:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		// end block with size 0 and lsb = 1 (allocated)
		uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);
  802b9f:	8b 55 08             	mov    0x8(%ebp),%edx
  802ba2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ba5:	01 d0                	add    %edx,%eax
  802ba7:	83 e8 04             	sub    $0x4,%eax
  802baa:	89 45 f0             	mov    %eax,-0x10(%ebp)
		*endBlock = 0 | 1; // size = 0, LSB as a flag = 1
  802bad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

		// the block that between begin and end blocks
		struct BlockElement* block = (struct BlockElement*)(daStart + 8);
  802bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb9:	83 c0 08             	add    $0x8,%eax
  802bbc:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 blockSize = initSizeOfAllocatedSpace - 8; // subtract size of begin and end blocks
  802bbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bc2:	83 e8 08             	sub    $0x8,%eax
  802bc5:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(block,blockSize,0);
  802bc8:	83 ec 04             	sub    $0x4,%esp
  802bcb:	6a 00                	push   $0x0
  802bcd:	ff 75 e8             	pushl  -0x18(%ebp)
  802bd0:	ff 75 ec             	pushl  -0x14(%ebp)
  802bd3:	e8 9c 00 00 00       	call   802c74 <set_block_data>
  802bd8:	83 c4 10             	add    $0x10,%esp

		block->prev_next_info.le_next = NULL;
  802bdb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bde:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block->prev_next_info.le_prev = NULL;
  802be4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802be7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

		LIST_INIT(&freeBlocksList);
  802bee:	c7 05 48 50 98 00 00 	movl   $0x0,0x985048
  802bf5:	00 00 00 
  802bf8:	c7 05 4c 50 98 00 00 	movl   $0x0,0x98504c
  802bff:	00 00 00 
  802c02:	c7 05 54 50 98 00 00 	movl   $0x0,0x985054
  802c09:	00 00 00 
		LIST_INSERT_HEAD(&freeBlocksList, block);
  802c0c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c10:	75 17                	jne    802c29 <initialize_dynamic_allocator+0xcd>
  802c12:	83 ec 04             	sub    $0x4,%esp
  802c15:	68 68 4b 80 00       	push   $0x804b68
  802c1a:	68 80 00 00 00       	push   $0x80
  802c1f:	68 8b 4b 80 00       	push   $0x804b8b
  802c24:	e8 08 de ff ff       	call   800a31 <_panic>
  802c29:	8b 15 48 50 98 00    	mov    0x985048,%edx
  802c2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c32:	89 10                	mov    %edx,(%eax)
  802c34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c37:	8b 00                	mov    (%eax),%eax
  802c39:	85 c0                	test   %eax,%eax
  802c3b:	74 0d                	je     802c4a <initialize_dynamic_allocator+0xee>
  802c3d:	a1 48 50 98 00       	mov    0x985048,%eax
  802c42:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c45:	89 50 04             	mov    %edx,0x4(%eax)
  802c48:	eb 08                	jmp    802c52 <initialize_dynamic_allocator+0xf6>
  802c4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c4d:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802c52:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c55:	a3 48 50 98 00       	mov    %eax,0x985048
  802c5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c5d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c64:	a1 54 50 98 00       	mov    0x985054,%eax
  802c69:	40                   	inc    %eax
  802c6a:	a3 54 50 98 00       	mov    %eax,0x985054
  802c6f:	eb 01                	jmp    802c72 <initialize_dynamic_allocator+0x116>
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
		if (initSizeOfAllocatedSpace == 0)
			return ;
  802c71:	90                   	nop
		block->prev_next_info.le_prev = NULL;

		LIST_INIT(&freeBlocksList);
		LIST_INSERT_HEAD(&freeBlocksList, block);
	}
}
  802c72:	c9                   	leave  
  802c73:	c3                   	ret    

00802c74 <set_block_data>:
//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802c74:	55                   	push   %ebp
  802c75:	89 e5                	mov    %esp,%ebp
  802c77:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("set_block_data is not implemented yet");
	//Your Code is Here...

	if(totalSize % 2 != 0)
  802c7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c7d:	83 e0 01             	and    $0x1,%eax
  802c80:	85 c0                	test   %eax,%eax
  802c82:	74 03                	je     802c87 <set_block_data+0x13>
	{
		totalSize++;
  802c84:	ff 45 0c             	incl   0xc(%ebp)
	}

	uint32* header = (uint32 *)((uint32*)va-1);
  802c87:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8a:	83 e8 04             	sub    $0x4,%eax
  802c8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//	size => totalSize with LSB = 0		 set LSB = 1 if isAllocated
	*header = (totalSize & ~1) | (isAllocated & 1);
  802c90:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c93:	83 e0 fe             	and    $0xfffffffe,%eax
  802c96:	89 c2                	mov    %eax,%edx
  802c98:	8b 45 10             	mov    0x10(%ebp),%eax
  802c9b:	83 e0 01             	and    $0x1,%eax
  802c9e:	09 c2                	or     %eax,%edx
  802ca0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802ca3:	89 10                	mov    %edx,(%eax)
	uint32* footer = (uint32*) (va + totalSize - 8);
  802ca5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ca8:	8d 50 f8             	lea    -0x8(%eax),%edx
  802cab:	8b 45 08             	mov    0x8(%ebp),%eax
  802cae:	01 d0                	add    %edx,%eax
  802cb0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	*footer = (totalSize & ~1) | (isAllocated & 1);
  802cb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cb6:	83 e0 fe             	and    $0xfffffffe,%eax
  802cb9:	89 c2                	mov    %eax,%edx
  802cbb:	8b 45 10             	mov    0x10(%ebp),%eax
  802cbe:	83 e0 01             	and    $0x1,%eax
  802cc1:	09 c2                	or     %eax,%edx
  802cc3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802cc6:	89 10                	mov    %edx,(%eax)
}
  802cc8:	90                   	nop
  802cc9:	c9                   	leave  
  802cca:	c3                   	ret    

00802ccb <insert_sorted_in_freeList>:
//=========================================
void insert_sorted_in_freeList(struct BlockElement *newBlock)
{
  802ccb:	55                   	push   %ebp
  802ccc:	89 e5                	mov    %esp,%ebp
  802cce:	83 ec 18             	sub    $0x18,%esp
	if(LIST_EMPTY(&freeBlocksList))
  802cd1:	a1 48 50 98 00       	mov    0x985048,%eax
  802cd6:	85 c0                	test   %eax,%eax
  802cd8:	75 68                	jne    802d42 <insert_sorted_in_freeList+0x77>
	{
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
  802cda:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cde:	75 17                	jne    802cf7 <insert_sorted_in_freeList+0x2c>
  802ce0:	83 ec 04             	sub    $0x4,%esp
  802ce3:	68 68 4b 80 00       	push   $0x804b68
  802ce8:	68 9d 00 00 00       	push   $0x9d
  802ced:	68 8b 4b 80 00       	push   $0x804b8b
  802cf2:	e8 3a dd ff ff       	call   800a31 <_panic>
  802cf7:	8b 15 48 50 98 00    	mov    0x985048,%edx
  802cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  802d00:	89 10                	mov    %edx,(%eax)
  802d02:	8b 45 08             	mov    0x8(%ebp),%eax
  802d05:	8b 00                	mov    (%eax),%eax
  802d07:	85 c0                	test   %eax,%eax
  802d09:	74 0d                	je     802d18 <insert_sorted_in_freeList+0x4d>
  802d0b:	a1 48 50 98 00       	mov    0x985048,%eax
  802d10:	8b 55 08             	mov    0x8(%ebp),%edx
  802d13:	89 50 04             	mov    %edx,0x4(%eax)
  802d16:	eb 08                	jmp    802d20 <insert_sorted_in_freeList+0x55>
  802d18:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1b:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802d20:	8b 45 08             	mov    0x8(%ebp),%eax
  802d23:	a3 48 50 98 00       	mov    %eax,0x985048
  802d28:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d32:	a1 54 50 98 00       	mov    0x985054,%eax
  802d37:	40                   	inc    %eax
  802d38:	a3 54 50 98 00       	mov    %eax,0x985054
		return;
  802d3d:	e9 1a 01 00 00       	jmp    802e5c <insert_sorted_in_freeList+0x191>
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  802d42:	a1 48 50 98 00       	mov    0x985048,%eax
  802d47:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d4a:	eb 7f                	jmp    802dcb <insert_sorted_in_freeList+0x100>
	{
		if(blk > newBlock) // if address of blk > address of newBlock => add newBlock before blk
  802d4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d52:	76 6f                	jbe    802dc3 <insert_sorted_in_freeList+0xf8>
		{
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
  802d54:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d58:	74 06                	je     802d60 <insert_sorted_in_freeList+0x95>
  802d5a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d5e:	75 17                	jne    802d77 <insert_sorted_in_freeList+0xac>
  802d60:	83 ec 04             	sub    $0x4,%esp
  802d63:	68 a4 4b 80 00       	push   $0x804ba4
  802d68:	68 a6 00 00 00       	push   $0xa6
  802d6d:	68 8b 4b 80 00       	push   $0x804b8b
  802d72:	e8 ba dc ff ff       	call   800a31 <_panic>
  802d77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7a:	8b 50 04             	mov    0x4(%eax),%edx
  802d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d80:	89 50 04             	mov    %edx,0x4(%eax)
  802d83:	8b 45 08             	mov    0x8(%ebp),%eax
  802d86:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d89:	89 10                	mov    %edx,(%eax)
  802d8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8e:	8b 40 04             	mov    0x4(%eax),%eax
  802d91:	85 c0                	test   %eax,%eax
  802d93:	74 0d                	je     802da2 <insert_sorted_in_freeList+0xd7>
  802d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d98:	8b 40 04             	mov    0x4(%eax),%eax
  802d9b:	8b 55 08             	mov    0x8(%ebp),%edx
  802d9e:	89 10                	mov    %edx,(%eax)
  802da0:	eb 08                	jmp    802daa <insert_sorted_in_freeList+0xdf>
  802da2:	8b 45 08             	mov    0x8(%ebp),%eax
  802da5:	a3 48 50 98 00       	mov    %eax,0x985048
  802daa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dad:	8b 55 08             	mov    0x8(%ebp),%edx
  802db0:	89 50 04             	mov    %edx,0x4(%eax)
  802db3:	a1 54 50 98 00       	mov    0x985054,%eax
  802db8:	40                   	inc    %eax
  802db9:	a3 54 50 98 00       	mov    %eax,0x985054
			return;
  802dbe:	e9 99 00 00 00       	jmp    802e5c <insert_sorted_in_freeList+0x191>
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
		return;
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  802dc3:	a1 50 50 98 00       	mov    0x985050,%eax
  802dc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dcb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dcf:	74 07                	je     802dd8 <insert_sorted_in_freeList+0x10d>
  802dd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd4:	8b 00                	mov    (%eax),%eax
  802dd6:	eb 05                	jmp    802ddd <insert_sorted_in_freeList+0x112>
  802dd8:	b8 00 00 00 00       	mov    $0x0,%eax
  802ddd:	a3 50 50 98 00       	mov    %eax,0x985050
  802de2:	a1 50 50 98 00       	mov    0x985050,%eax
  802de7:	85 c0                	test   %eax,%eax
  802de9:	0f 85 5d ff ff ff    	jne    802d4c <insert_sorted_in_freeList+0x81>
  802def:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802df3:	0f 85 53 ff ff ff    	jne    802d4c <insert_sorted_in_freeList+0x81>
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
			return;
		}
	}
	// if no blk its address > newBlock
	LIST_INSERT_TAIL(&freeBlocksList, newBlock);
  802df9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dfd:	75 17                	jne    802e16 <insert_sorted_in_freeList+0x14b>
  802dff:	83 ec 04             	sub    $0x4,%esp
  802e02:	68 dc 4b 80 00       	push   $0x804bdc
  802e07:	68 ab 00 00 00       	push   $0xab
  802e0c:	68 8b 4b 80 00       	push   $0x804b8b
  802e11:	e8 1b dc ff ff       	call   800a31 <_panic>
  802e16:	8b 15 4c 50 98 00    	mov    0x98504c,%edx
  802e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1f:	89 50 04             	mov    %edx,0x4(%eax)
  802e22:	8b 45 08             	mov    0x8(%ebp),%eax
  802e25:	8b 40 04             	mov    0x4(%eax),%eax
  802e28:	85 c0                	test   %eax,%eax
  802e2a:	74 0c                	je     802e38 <insert_sorted_in_freeList+0x16d>
  802e2c:	a1 4c 50 98 00       	mov    0x98504c,%eax
  802e31:	8b 55 08             	mov    0x8(%ebp),%edx
  802e34:	89 10                	mov    %edx,(%eax)
  802e36:	eb 08                	jmp    802e40 <insert_sorted_in_freeList+0x175>
  802e38:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3b:	a3 48 50 98 00       	mov    %eax,0x985048
  802e40:	8b 45 08             	mov    0x8(%ebp),%eax
  802e43:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802e48:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e51:	a1 54 50 98 00       	mov    0x985054,%eax
  802e56:	40                   	inc    %eax
  802e57:	a3 54 50 98 00       	mov    %eax,0x985054
}
  802e5c:	c9                   	leave  
  802e5d:	c3                   	ret    

00802e5e <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  802e5e:	55                   	push   %ebp
  802e5f:	89 e5                	mov    %esp,%ebp
  802e61:	83 ec 78             	sub    $0x78,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802e64:	8b 45 08             	mov    0x8(%ebp),%eax
  802e67:	83 e0 01             	and    $0x1,%eax
  802e6a:	85 c0                	test   %eax,%eax
  802e6c:	74 03                	je     802e71 <alloc_block_FF+0x13>
  802e6e:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802e71:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802e75:	77 07                	ja     802e7e <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802e77:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802e7e:	a1 40 50 98 00       	mov    0x985040,%eax
  802e83:	85 c0                	test   %eax,%eax
  802e85:	75 63                	jne    802eea <alloc_block_FF+0x8c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802e87:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8a:	83 c0 10             	add    $0x10,%eax
  802e8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802e90:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802e97:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e9d:	01 d0                	add    %edx,%eax
  802e9f:	48                   	dec    %eax
  802ea0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802ea3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ea6:	ba 00 00 00 00       	mov    $0x0,%edx
  802eab:	f7 75 ec             	divl   -0x14(%ebp)
  802eae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eb1:	29 d0                	sub    %edx,%eax
  802eb3:	c1 e8 0c             	shr    $0xc,%eax
  802eb6:	83 ec 0c             	sub    $0xc,%esp
  802eb9:	50                   	push   %eax
  802eba:	e8 d1 ed ff ff       	call   801c90 <sbrk>
  802ebf:	83 c4 10             	add    $0x10,%esp
  802ec2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802ec5:	83 ec 0c             	sub    $0xc,%esp
  802ec8:	6a 00                	push   $0x0
  802eca:	e8 c1 ed ff ff       	call   801c90 <sbrk>
  802ecf:	83 c4 10             	add    $0x10,%esp
  802ed2:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802ed5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ed8:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802edb:	83 ec 08             	sub    $0x8,%esp
  802ede:	50                   	push   %eax
  802edf:	ff 75 e4             	pushl  -0x1c(%ebp)
  802ee2:	e8 75 fc ff ff       	call   802b5c <initialize_dynamic_allocator>
  802ee7:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(size == 0)
  802eea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802eee:	75 0a                	jne    802efa <alloc_block_FF+0x9c>
	{
		return NULL;
  802ef0:	b8 00 00 00 00       	mov    $0x0,%eax
  802ef5:	e9 99 03 00 00       	jmp    803293 <alloc_block_FF+0x435>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  802efa:	8b 45 08             	mov    0x8(%ebp),%eax
  802efd:	83 c0 08             	add    $0x8,%eax
  802f00:	89 45 dc             	mov    %eax,-0x24(%ebp)

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802f03:	a1 48 50 98 00       	mov    0x985048,%eax
  802f08:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f0b:	e9 03 02 00 00       	jmp    803113 <alloc_block_FF+0x2b5>
	{
		uint32 blockSize = get_block_size(block); // Get size without the (LSB) allocation flag
  802f10:	83 ec 0c             	sub    $0xc,%esp
  802f13:	ff 75 f4             	pushl  -0xc(%ebp)
  802f16:	e8 dd fa ff ff       	call   8029f8 <get_block_size>
  802f1b:	83 c4 10             	add    $0x10,%esp
  802f1e:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if(blockSize >= totalSize)
  802f21:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802f24:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802f27:	0f 82 de 01 00 00    	jb     80310b <alloc_block_FF+0x2ad>
		{	//if we can put another block with min size 16
			if(blockSize >= totalSize + 4*sizeof(uint32))
  802f2d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f30:	83 c0 10             	add    $0x10,%eax
  802f33:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  802f36:	0f 87 32 01 00 00    	ja     80306e <alloc_block_FF+0x210>
			{
				// the size that will remain from the block that we will allocate a new block in it
				uint32 remainingSize = blockSize - totalSize;
  802f3c:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802f3f:	2b 45 dc             	sub    -0x24(%ebp),%eax
  802f42:	89 45 98             	mov    %eax,-0x68(%ebp)

				// the remaining free space from the block that we use to allocate in it
				struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)block + totalSize);
  802f45:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f48:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f4b:	01 d0                	add    %edx,%eax
  802f4d:	89 45 94             	mov    %eax,-0x6c(%ebp)
				set_block_data(remainingFreeBlock, remainingSize, 0);
  802f50:	83 ec 04             	sub    $0x4,%esp
  802f53:	6a 00                	push   $0x0
  802f55:	ff 75 98             	pushl  -0x68(%ebp)
  802f58:	ff 75 94             	pushl  -0x6c(%ebp)
  802f5b:	e8 14 fd ff ff       	call   802c74 <set_block_data>
  802f60:	83 c4 10             	add    $0x10,%esp
				// add it after the block we allocated to be sorted by addresses
				LIST_INSERT_AFTER(&freeBlocksList, block,remainingFreeBlock);
  802f63:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f67:	74 06                	je     802f6f <alloc_block_FF+0x111>
  802f69:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
  802f6d:	75 17                	jne    802f86 <alloc_block_FF+0x128>
  802f6f:	83 ec 04             	sub    $0x4,%esp
  802f72:	68 00 4c 80 00       	push   $0x804c00
  802f77:	68 de 00 00 00       	push   $0xde
  802f7c:	68 8b 4b 80 00       	push   $0x804b8b
  802f81:	e8 ab da ff ff       	call   800a31 <_panic>
  802f86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f89:	8b 10                	mov    (%eax),%edx
  802f8b:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802f8e:	89 10                	mov    %edx,(%eax)
  802f90:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802f93:	8b 00                	mov    (%eax),%eax
  802f95:	85 c0                	test   %eax,%eax
  802f97:	74 0b                	je     802fa4 <alloc_block_FF+0x146>
  802f99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9c:	8b 00                	mov    (%eax),%eax
  802f9e:	8b 55 94             	mov    -0x6c(%ebp),%edx
  802fa1:	89 50 04             	mov    %edx,0x4(%eax)
  802fa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa7:	8b 55 94             	mov    -0x6c(%ebp),%edx
  802faa:	89 10                	mov    %edx,(%eax)
  802fac:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802faf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fb2:	89 50 04             	mov    %edx,0x4(%eax)
  802fb5:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802fb8:	8b 00                	mov    (%eax),%eax
  802fba:	85 c0                	test   %eax,%eax
  802fbc:	75 08                	jne    802fc6 <alloc_block_FF+0x168>
  802fbe:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802fc1:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802fc6:	a1 54 50 98 00       	mov    0x985054,%eax
  802fcb:	40                   	inc    %eax
  802fcc:	a3 54 50 98 00       	mov    %eax,0x985054

				// update the allocated block and remove it from freeBlocksList
				set_block_data(block,totalSize,1);
  802fd1:	83 ec 04             	sub    $0x4,%esp
  802fd4:	6a 01                	push   $0x1
  802fd6:	ff 75 dc             	pushl  -0x24(%ebp)
  802fd9:	ff 75 f4             	pushl  -0xc(%ebp)
  802fdc:	e8 93 fc ff ff       	call   802c74 <set_block_data>
  802fe1:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  802fe4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fe8:	75 17                	jne    803001 <alloc_block_FF+0x1a3>
  802fea:	83 ec 04             	sub    $0x4,%esp
  802fed:	68 34 4c 80 00       	push   $0x804c34
  802ff2:	68 e3 00 00 00       	push   $0xe3
  802ff7:	68 8b 4b 80 00       	push   $0x804b8b
  802ffc:	e8 30 da ff ff       	call   800a31 <_panic>
  803001:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803004:	8b 00                	mov    (%eax),%eax
  803006:	85 c0                	test   %eax,%eax
  803008:	74 10                	je     80301a <alloc_block_FF+0x1bc>
  80300a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300d:	8b 00                	mov    (%eax),%eax
  80300f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803012:	8b 52 04             	mov    0x4(%edx),%edx
  803015:	89 50 04             	mov    %edx,0x4(%eax)
  803018:	eb 0b                	jmp    803025 <alloc_block_FF+0x1c7>
  80301a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301d:	8b 40 04             	mov    0x4(%eax),%eax
  803020:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803025:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803028:	8b 40 04             	mov    0x4(%eax),%eax
  80302b:	85 c0                	test   %eax,%eax
  80302d:	74 0f                	je     80303e <alloc_block_FF+0x1e0>
  80302f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803032:	8b 40 04             	mov    0x4(%eax),%eax
  803035:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803038:	8b 12                	mov    (%edx),%edx
  80303a:	89 10                	mov    %edx,(%eax)
  80303c:	eb 0a                	jmp    803048 <alloc_block_FF+0x1ea>
  80303e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803041:	8b 00                	mov    (%eax),%eax
  803043:	a3 48 50 98 00       	mov    %eax,0x985048
  803048:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803051:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803054:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80305b:	a1 54 50 98 00       	mov    0x985054,%eax
  803060:	48                   	dec    %eax
  803061:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  803066:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803069:	e9 25 02 00 00       	jmp    803293 <alloc_block_FF+0x435>
			}
			else // if set internal fragmentation
			{
				// add the remaining size to the block we allocate so it will be the same main block size
				set_block_data(block,blockSize,1);
  80306e:	83 ec 04             	sub    $0x4,%esp
  803071:	6a 01                	push   $0x1
  803073:	ff 75 9c             	pushl  -0x64(%ebp)
  803076:	ff 75 f4             	pushl  -0xc(%ebp)
  803079:	e8 f6 fb ff ff       	call   802c74 <set_block_data>
  80307e:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  803081:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803085:	75 17                	jne    80309e <alloc_block_FF+0x240>
  803087:	83 ec 04             	sub    $0x4,%esp
  80308a:	68 34 4c 80 00       	push   $0x804c34
  80308f:	68 eb 00 00 00       	push   $0xeb
  803094:	68 8b 4b 80 00       	push   $0x804b8b
  803099:	e8 93 d9 ff ff       	call   800a31 <_panic>
  80309e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a1:	8b 00                	mov    (%eax),%eax
  8030a3:	85 c0                	test   %eax,%eax
  8030a5:	74 10                	je     8030b7 <alloc_block_FF+0x259>
  8030a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030aa:	8b 00                	mov    (%eax),%eax
  8030ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030af:	8b 52 04             	mov    0x4(%edx),%edx
  8030b2:	89 50 04             	mov    %edx,0x4(%eax)
  8030b5:	eb 0b                	jmp    8030c2 <alloc_block_FF+0x264>
  8030b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ba:	8b 40 04             	mov    0x4(%eax),%eax
  8030bd:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8030c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c5:	8b 40 04             	mov    0x4(%eax),%eax
  8030c8:	85 c0                	test   %eax,%eax
  8030ca:	74 0f                	je     8030db <alloc_block_FF+0x27d>
  8030cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030cf:	8b 40 04             	mov    0x4(%eax),%eax
  8030d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030d5:	8b 12                	mov    (%edx),%edx
  8030d7:	89 10                	mov    %edx,(%eax)
  8030d9:	eb 0a                	jmp    8030e5 <alloc_block_FF+0x287>
  8030db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030de:	8b 00                	mov    (%eax),%eax
  8030e0:	a3 48 50 98 00       	mov    %eax,0x985048
  8030e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030f8:	a1 54 50 98 00       	mov    0x985054,%eax
  8030fd:	48                   	dec    %eax
  8030fe:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  803103:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803106:	e9 88 01 00 00       	jmp    803293 <alloc_block_FF+0x435>
		return NULL;
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  80310b:	a1 50 50 98 00       	mov    0x985050,%eax
  803110:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803113:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803117:	74 07                	je     803120 <alloc_block_FF+0x2c2>
  803119:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80311c:	8b 00                	mov    (%eax),%eax
  80311e:	eb 05                	jmp    803125 <alloc_block_FF+0x2c7>
  803120:	b8 00 00 00 00       	mov    $0x0,%eax
  803125:	a3 50 50 98 00       	mov    %eax,0x985050
  80312a:	a1 50 50 98 00       	mov    0x985050,%eax
  80312f:	85 c0                	test   %eax,%eax
  803131:	0f 85 d9 fd ff ff    	jne    802f10 <alloc_block_FF+0xb2>
  803137:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80313b:	0f 85 cf fd ff ff    	jne    802f10 <alloc_block_FF+0xb2>

//	uint32 *endBlock = &kheapBreak;

	// if we don't find any enough space to allocate the block

	void *oldBreak = sbrk(ROUNDUP(totalSize, PAGE_SIZE) / PAGE_SIZE);
  803141:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  803148:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80314b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80314e:	01 d0                	add    %edx,%eax
  803150:	48                   	dec    %eax
  803151:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  803154:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803157:	ba 00 00 00 00       	mov    $0x0,%edx
  80315c:	f7 75 d8             	divl   -0x28(%ebp)
  80315f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803162:	29 d0                	sub    %edx,%eax
  803164:	c1 e8 0c             	shr    $0xc,%eax
  803167:	83 ec 0c             	sub    $0xc,%esp
  80316a:	50                   	push   %eax
  80316b:	e8 20 eb ff ff       	call   801c90 <sbrk>
  803170:	83 c4 10             	add    $0x10,%esp
  803173:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (oldBreak == (void*)-1) {
  803176:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  80317a:	75 0a                	jne    803186 <alloc_block_FF+0x328>
		return NULL;
  80317c:	b8 00 00 00 00       	mov    $0x0,%eax
  803181:	e9 0d 01 00 00       	jmp    803293 <alloc_block_FF+0x435>
	}
	//uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);

	uint32* endBlk = (uint32 *)((char *)oldBreak - 4);
  803186:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803189:	83 e8 04             	sub    $0x4,%eax
  80318c:	89 45 cc             	mov    %eax,-0x34(%ebp)
	//endBlk = endBlk+(char *) ROUNDUP(totalSize, PAGE_SIZE);

	endBlk = endBlk + (ROUNDUP(totalSize, PAGE_SIZE) / sizeof(uint32));
  80318f:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  803196:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803199:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80319c:	01 d0                	add    %edx,%eax
  80319e:	48                   	dec    %eax
  80319f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8031a2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8031a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8031aa:	f7 75 c8             	divl   -0x38(%ebp)
  8031ad:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8031b0:	29 d0                	sub    %edx,%eax
  8031b2:	c1 e8 02             	shr    $0x2,%eax
  8031b5:	c1 e0 02             	shl    $0x2,%eax
  8031b8:	01 45 cc             	add    %eax,-0x34(%ebp)
	*endBlk = 0 | 1;
  8031bb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031be:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	uint32 *footerLast = ((uint32*)oldBreak - 2);
  8031c4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8031c7:	83 e8 08             	sub    $0x8,%eax
  8031ca:	89 45 c0             	mov    %eax,-0x40(%ebp)
	uint32 lastSize = (*footerLast) & ~(0x1);
  8031cd:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8031d0:	8b 00                	mov    (%eax),%eax
  8031d2:	83 e0 fe             	and    $0xfffffffe,%eax
  8031d5:	89 45 bc             	mov    %eax,-0x44(%ebp)
	// the last block for the block that we want to free it
	struct BlockElement *laskBlk = (struct BlockElement *)((char*)oldBreak - lastSize);
  8031d8:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8031db:	f7 d8                	neg    %eax
  8031dd:	89 c2                	mov    %eax,%edx
  8031df:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8031e2:	01 d0                	add    %edx,%eax
  8031e4:	89 45 b8             	mov    %eax,-0x48(%ebp)
	uint32 isLastFree = is_free_block(laskBlk);
  8031e7:	83 ec 0c             	sub    $0xc,%esp
  8031ea:	ff 75 b8             	pushl  -0x48(%ebp)
  8031ed:	e8 1f f8 ff ff       	call   802a11 <is_free_block>
  8031f2:	83 c4 10             	add    $0x10,%esp
  8031f5:	0f be c0             	movsbl %al,%eax
  8031f8:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(isLastFree)
  8031fb:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  8031ff:	74 42                	je     803243 <alloc_block_FF+0x3e5>
	{
		// merge the block will be free with its prev block
		uint32 newBlkSize = lastSize + ROUNDUP(totalSize, PAGE_SIZE); // size of main block and its prev block
  803201:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  803208:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80320b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80320e:	01 d0                	add    %edx,%eax
  803210:	48                   	dec    %eax
  803211:	89 45 ac             	mov    %eax,-0x54(%ebp)
  803214:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803217:	ba 00 00 00 00       	mov    $0x0,%edx
  80321c:	f7 75 b0             	divl   -0x50(%ebp)
  80321f:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803222:	29 d0                	sub    %edx,%eax
  803224:	89 c2                	mov    %eax,%edx
  803226:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803229:	01 d0                	add    %edx,%eax
  80322b:	89 45 a8             	mov    %eax,-0x58(%ebp)
		// extends last block size to contain its size and the size of new space
		set_block_data(laskBlk,newBlkSize,0);
  80322e:	83 ec 04             	sub    $0x4,%esp
  803231:	6a 00                	push   $0x0
  803233:	ff 75 a8             	pushl  -0x58(%ebp)
  803236:	ff 75 b8             	pushl  -0x48(%ebp)
  803239:	e8 36 fa ff ff       	call   802c74 <set_block_data>
  80323e:	83 c4 10             	add    $0x10,%esp
  803241:	eb 42                	jmp    803285 <alloc_block_FF+0x427>
	}
	else
	{
		set_block_data(oldBreak,ROUNDUP(totalSize, PAGE_SIZE),0);
  803243:	c7 45 a4 00 10 00 00 	movl   $0x1000,-0x5c(%ebp)
  80324a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80324d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803250:	01 d0                	add    %edx,%eax
  803252:	48                   	dec    %eax
  803253:	89 45 a0             	mov    %eax,-0x60(%ebp)
  803256:	8b 45 a0             	mov    -0x60(%ebp),%eax
  803259:	ba 00 00 00 00       	mov    $0x0,%edx
  80325e:	f7 75 a4             	divl   -0x5c(%ebp)
  803261:	8b 45 a0             	mov    -0x60(%ebp),%eax
  803264:	29 d0                	sub    %edx,%eax
  803266:	83 ec 04             	sub    $0x4,%esp
  803269:	6a 00                	push   $0x0
  80326b:	50                   	push   %eax
  80326c:	ff 75 d0             	pushl  -0x30(%ebp)
  80326f:	e8 00 fa ff ff       	call   802c74 <set_block_data>
  803274:	83 c4 10             	add    $0x10,%esp
		insert_sorted_in_freeList((struct BlockElement *)oldBreak);
  803277:	83 ec 0c             	sub    $0xc,%esp
  80327a:	ff 75 d0             	pushl  -0x30(%ebp)
  80327d:	e8 49 fa ff ff       	call   802ccb <insert_sorted_in_freeList>
  803282:	83 c4 10             	add    $0x10,%esp
//		LIST_INSERT_TAIL(&freeBlocksList,newBreak);
	}
//	set_block_data((struct BlockElement *)newBreak, totalSize, 1);
	return alloc_block_FF(size);
  803285:	83 ec 0c             	sub    $0xc,%esp
  803288:	ff 75 08             	pushl  0x8(%ebp)
  80328b:	e8 ce fb ff ff       	call   802e5e <alloc_block_FF>
  803290:	83 c4 10             	add    $0x10,%esp
}
  803293:	c9                   	leave  
  803294:	c3                   	ret    

00803295 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  803295:	55                   	push   %ebp
  803296:	89 e5                	mov    %esp,%ebp
  803298:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS1 - BONUS] [3] DYNAMIC ALLOCATOR - alloc_block_BF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_BF is not implemented yet");
	//Your Code is Here...
	if(size == 0)
  80329b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80329f:	75 0a                	jne    8032ab <alloc_block_BF+0x16>
	{
		return NULL;
  8032a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8032a6:	e9 7a 02 00 00       	jmp    803525 <alloc_block_BF+0x290>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  8032ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ae:	83 c0 08             	add    $0x8,%eax
  8032b1:	89 45 e8             	mov    %eax,-0x18(%ebp)

	struct BlockElement *minBlk= NULL;
  8032b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 minSize = 0xfffffff; // a large number
  8032bb:	c7 45 f0 ff ff ff 0f 	movl   $0xfffffff,-0x10(%ebp)
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  8032c2:	a1 48 50 98 00       	mov    0x985048,%eax
  8032c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8032ca:	eb 32                	jmp    8032fe <alloc_block_BF+0x69>
	{
		uint32 blockSize = get_block_size(block);
  8032cc:	ff 75 ec             	pushl  -0x14(%ebp)
  8032cf:	e8 24 f7 ff ff       	call   8029f8 <get_block_size>
  8032d4:	83 c4 04             	add    $0x4,%esp
  8032d7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		// if this block can take the new block and its size < min size of all blocks
		if(blockSize >= totalSize && blockSize < minSize)
  8032da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032dd:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8032e0:	72 14                	jb     8032f6 <alloc_block_BF+0x61>
  8032e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032e5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8032e8:	73 0c                	jae    8032f6 <alloc_block_BF+0x61>
		{
			minBlk = block;
  8032ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
			minSize = blockSize;
  8032f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *minBlk= NULL;
	uint32 minSize = 0xfffffff; // a large number
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  8032f6:	a1 50 50 98 00       	mov    0x985050,%eax
  8032fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8032fe:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803302:	74 07                	je     80330b <alloc_block_BF+0x76>
  803304:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803307:	8b 00                	mov    (%eax),%eax
  803309:	eb 05                	jmp    803310 <alloc_block_BF+0x7b>
  80330b:	b8 00 00 00 00       	mov    $0x0,%eax
  803310:	a3 50 50 98 00       	mov    %eax,0x985050
  803315:	a1 50 50 98 00       	mov    0x985050,%eax
  80331a:	85 c0                	test   %eax,%eax
  80331c:	75 ae                	jne    8032cc <alloc_block_BF+0x37>
  80331e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803322:	75 a8                	jne    8032cc <alloc_block_BF+0x37>
			minSize = blockSize;
		}
	}

	// if we don't find any enough space to allocate the block
	if(minBlk == NULL)
  803324:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803328:	75 22                	jne    80334c <alloc_block_BF+0xb7>
	{
		void *newBlock = sbrk(totalSize);
  80332a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80332d:	83 ec 0c             	sub    $0xc,%esp
  803330:	50                   	push   %eax
  803331:	e8 5a e9 ff ff       	call   801c90 <sbrk>
  803336:	83 c4 10             	add    $0x10,%esp
  803339:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (newBlock == (void*)-1) {
  80333c:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  803340:	75 0a                	jne    80334c <alloc_block_BF+0xb7>
			return NULL;
  803342:	b8 00 00 00 00       	mov    $0x0,%eax
  803347:	e9 d9 01 00 00       	jmp    803525 <alloc_block_BF+0x290>
		}
	}

	//if we can put another block with min size 16
	if(minSize >= totalSize + 4*sizeof(uint32))
  80334c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80334f:	83 c0 10             	add    $0x10,%eax
  803352:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803355:	0f 87 32 01 00 00    	ja     80348d <alloc_block_BF+0x1f8>
	{
		// the size that will remain from the block that we will allocate a new block in it
		uint32 remainingSize= minSize - totalSize;
  80335b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80335e:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803361:	89 45 dc             	mov    %eax,-0x24(%ebp)

		// the remaining free space from the block that we use to allocate in it
		struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)minBlk + totalSize);
  803364:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803367:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80336a:	01 d0                	add    %edx,%eax
  80336c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		set_block_data(remainingFreeBlock, remainingSize, 0);
  80336f:	83 ec 04             	sub    $0x4,%esp
  803372:	6a 00                	push   $0x0
  803374:	ff 75 dc             	pushl  -0x24(%ebp)
  803377:	ff 75 d8             	pushl  -0x28(%ebp)
  80337a:	e8 f5 f8 ff ff       	call   802c74 <set_block_data>
  80337f:	83 c4 10             	add    $0x10,%esp
		// add it after the block we allocated to be sorted by addresses
		LIST_INSERT_AFTER(&freeBlocksList, minBlk,remainingFreeBlock);
  803382:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803386:	74 06                	je     80338e <alloc_block_BF+0xf9>
  803388:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80338c:	75 17                	jne    8033a5 <alloc_block_BF+0x110>
  80338e:	83 ec 04             	sub    $0x4,%esp
  803391:	68 00 4c 80 00       	push   $0x804c00
  803396:	68 49 01 00 00       	push   $0x149
  80339b:	68 8b 4b 80 00       	push   $0x804b8b
  8033a0:	e8 8c d6 ff ff       	call   800a31 <_panic>
  8033a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a8:	8b 10                	mov    (%eax),%edx
  8033aa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033ad:	89 10                	mov    %edx,(%eax)
  8033af:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033b2:	8b 00                	mov    (%eax),%eax
  8033b4:	85 c0                	test   %eax,%eax
  8033b6:	74 0b                	je     8033c3 <alloc_block_BF+0x12e>
  8033b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033bb:	8b 00                	mov    (%eax),%eax
  8033bd:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8033c0:	89 50 04             	mov    %edx,0x4(%eax)
  8033c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8033c9:	89 10                	mov    %edx,(%eax)
  8033cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033d1:	89 50 04             	mov    %edx,0x4(%eax)
  8033d4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033d7:	8b 00                	mov    (%eax),%eax
  8033d9:	85 c0                	test   %eax,%eax
  8033db:	75 08                	jne    8033e5 <alloc_block_BF+0x150>
  8033dd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033e0:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8033e5:	a1 54 50 98 00       	mov    0x985054,%eax
  8033ea:	40                   	inc    %eax
  8033eb:	a3 54 50 98 00       	mov    %eax,0x985054

		// update the allocated block and remove it from freeBlocksList
		set_block_data(minBlk,totalSize,1);
  8033f0:	83 ec 04             	sub    $0x4,%esp
  8033f3:	6a 01                	push   $0x1
  8033f5:	ff 75 e8             	pushl  -0x18(%ebp)
  8033f8:	ff 75 f4             	pushl  -0xc(%ebp)
  8033fb:	e8 74 f8 ff ff       	call   802c74 <set_block_data>
  803400:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  803403:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803407:	75 17                	jne    803420 <alloc_block_BF+0x18b>
  803409:	83 ec 04             	sub    $0x4,%esp
  80340c:	68 34 4c 80 00       	push   $0x804c34
  803411:	68 4e 01 00 00       	push   $0x14e
  803416:	68 8b 4b 80 00       	push   $0x804b8b
  80341b:	e8 11 d6 ff ff       	call   800a31 <_panic>
  803420:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803423:	8b 00                	mov    (%eax),%eax
  803425:	85 c0                	test   %eax,%eax
  803427:	74 10                	je     803439 <alloc_block_BF+0x1a4>
  803429:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80342c:	8b 00                	mov    (%eax),%eax
  80342e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803431:	8b 52 04             	mov    0x4(%edx),%edx
  803434:	89 50 04             	mov    %edx,0x4(%eax)
  803437:	eb 0b                	jmp    803444 <alloc_block_BF+0x1af>
  803439:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343c:	8b 40 04             	mov    0x4(%eax),%eax
  80343f:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803444:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803447:	8b 40 04             	mov    0x4(%eax),%eax
  80344a:	85 c0                	test   %eax,%eax
  80344c:	74 0f                	je     80345d <alloc_block_BF+0x1c8>
  80344e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803451:	8b 40 04             	mov    0x4(%eax),%eax
  803454:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803457:	8b 12                	mov    (%edx),%edx
  803459:	89 10                	mov    %edx,(%eax)
  80345b:	eb 0a                	jmp    803467 <alloc_block_BF+0x1d2>
  80345d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803460:	8b 00                	mov    (%eax),%eax
  803462:	a3 48 50 98 00       	mov    %eax,0x985048
  803467:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80346a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803470:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803473:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80347a:	a1 54 50 98 00       	mov    0x985054,%eax
  80347f:	48                   	dec    %eax
  803480:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  803485:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803488:	e9 98 00 00 00       	jmp    803525 <alloc_block_BF+0x290>
	}
	else // if set internal fragmentation
	{
		// add the remaining size to the block we allocate so it will be the same main block size
		set_block_data(minBlk,minSize,1);
  80348d:	83 ec 04             	sub    $0x4,%esp
  803490:	6a 01                	push   $0x1
  803492:	ff 75 f0             	pushl  -0x10(%ebp)
  803495:	ff 75 f4             	pushl  -0xc(%ebp)
  803498:	e8 d7 f7 ff ff       	call   802c74 <set_block_data>
  80349d:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  8034a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034a4:	75 17                	jne    8034bd <alloc_block_BF+0x228>
  8034a6:	83 ec 04             	sub    $0x4,%esp
  8034a9:	68 34 4c 80 00       	push   $0x804c34
  8034ae:	68 56 01 00 00       	push   $0x156
  8034b3:	68 8b 4b 80 00       	push   $0x804b8b
  8034b8:	e8 74 d5 ff ff       	call   800a31 <_panic>
  8034bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c0:	8b 00                	mov    (%eax),%eax
  8034c2:	85 c0                	test   %eax,%eax
  8034c4:	74 10                	je     8034d6 <alloc_block_BF+0x241>
  8034c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c9:	8b 00                	mov    (%eax),%eax
  8034cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034ce:	8b 52 04             	mov    0x4(%edx),%edx
  8034d1:	89 50 04             	mov    %edx,0x4(%eax)
  8034d4:	eb 0b                	jmp    8034e1 <alloc_block_BF+0x24c>
  8034d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d9:	8b 40 04             	mov    0x4(%eax),%eax
  8034dc:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8034e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e4:	8b 40 04             	mov    0x4(%eax),%eax
  8034e7:	85 c0                	test   %eax,%eax
  8034e9:	74 0f                	je     8034fa <alloc_block_BF+0x265>
  8034eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ee:	8b 40 04             	mov    0x4(%eax),%eax
  8034f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034f4:	8b 12                	mov    (%edx),%edx
  8034f6:	89 10                	mov    %edx,(%eax)
  8034f8:	eb 0a                	jmp    803504 <alloc_block_BF+0x26f>
  8034fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034fd:	8b 00                	mov    (%eax),%eax
  8034ff:	a3 48 50 98 00       	mov    %eax,0x985048
  803504:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803507:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80350d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803510:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803517:	a1 54 50 98 00       	mov    0x985054,%eax
  80351c:	48                   	dec    %eax
  80351d:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  803522:	8b 45 f4             	mov    -0xc(%ebp),%eax
	}
	return NULL;
}
  803525:	c9                   	leave  
  803526:	c3                   	ret    

00803527 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803527:	55                   	push   %ebp
  803528:	89 e5                	mov    %esp,%ebp
  80352a:	83 ec 48             	sub    $0x48,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
  80352d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803531:	0f 84 6a 02 00 00    	je     8037a1 <free_block+0x27a>
	{
		return;
	}

	uint32 freeSize = get_block_size(va);
  803537:	ff 75 08             	pushl  0x8(%ebp)
  80353a:	e8 b9 f4 ff ff       	call   8029f8 <get_block_size>
  80353f:	83 c4 04             	add    $0x4,%esp
  803542:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// footer for the prev block for the block that we want to free it
	uint32 *footerPrev = ((uint32*)va - 2 );
  803545:	8b 45 08             	mov    0x8(%ebp),%eax
  803548:	83 e8 08             	sub    $0x8,%eax
  80354b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 pSize = (*footerPrev) & ~(0x1);
  80354e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803551:	8b 00                	mov    (%eax),%eax
  803553:	83 e0 fe             	and    $0xfffffffe,%eax
  803556:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// the prev block for the block that we want to free it
	struct BlockElement * prevBlk = (struct BlockElement *)((char*)va - pSize);
  803559:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80355c:	f7 d8                	neg    %eax
  80355e:	89 c2                	mov    %eax,%edx
  803560:	8b 45 08             	mov    0x8(%ebp),%eax
  803563:	01 d0                	add    %edx,%eax
  803565:	89 45 e8             	mov    %eax,-0x18(%ebp)
	uint32 isPrevFree = is_free_block(prevBlk);
  803568:	ff 75 e8             	pushl  -0x18(%ebp)
  80356b:	e8 a1 f4 ff ff       	call   802a11 <is_free_block>
  803570:	83 c4 04             	add    $0x4,%esp
  803573:	0f be c0             	movsbl %al,%eax
  803576:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
  803579:	8b 55 08             	mov    0x8(%ebp),%edx
  80357c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80357f:	01 d0                	add    %edx,%eax
  803581:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  803584:	ff 75 e0             	pushl  -0x20(%ebp)
  803587:	e8 85 f4 ff ff       	call   802a11 <is_free_block>
  80358c:	83 c4 04             	add    $0x4,%esp
  80358f:	0f be c0             	movsbl %al,%eax
  803592:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if(isPrevFree == 1 && isNextFree == 0)
  803595:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  803599:	75 34                	jne    8035cf <free_block+0xa8>
  80359b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80359f:	75 2e                	jne    8035cf <free_block+0xa8>
	{
		// merge the block will be free with its prev block
		uint32 prevSize = get_block_size(prevBlk);
  8035a1:	ff 75 e8             	pushl  -0x18(%ebp)
  8035a4:	e8 4f f4 ff ff       	call   8029f8 <get_block_size>
  8035a9:	83 c4 04             	add    $0x4,%esp
  8035ac:	89 45 d8             	mov    %eax,-0x28(%ebp)
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
  8035af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035b2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8035b5:	01 d0                	add    %edx,%eax
  8035b7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
  8035ba:	6a 00                	push   $0x0
  8035bc:	ff 75 d4             	pushl  -0x2c(%ebp)
  8035bf:	ff 75 e8             	pushl  -0x18(%ebp)
  8035c2:	e8 ad f6 ff ff       	call   802c74 <set_block_data>
  8035c7:	83 c4 0c             	add    $0xc,%esp
	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
	uint32 isNextFree = is_free_block(nextBlk);

	if(isPrevFree == 1 && isNextFree == 0)
	{
  8035ca:	e9 d3 01 00 00       	jmp    8037a2 <free_block+0x27b>
		uint32 prevSize = get_block_size(prevBlk);
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
  8035cf:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  8035d3:	0f 85 c8 00 00 00    	jne    8036a1 <free_block+0x17a>
  8035d9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8035dd:	0f 85 be 00 00 00    	jne    8036a1 <free_block+0x17a>
	{
		// merge the block will be free with its next block
		uint32 nextSize = get_block_size(nextBlk);
  8035e3:	ff 75 e0             	pushl  -0x20(%ebp)
  8035e6:	e8 0d f4 ff ff       	call   8029f8 <get_block_size>
  8035eb:	83 c4 04             	add    $0x4,%esp
  8035ee:	89 45 d0             	mov    %eax,-0x30(%ebp)
		uint32 totalSize = freeSize + nextSize; // size of main block and its next block
  8035f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035f4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8035f7:	01 d0                	add    %edx,%eax
  8035f9:	89 45 cc             	mov    %eax,-0x34(%ebp)
		// update the size of block to contain its size and the size of next block
		set_block_data(va,totalSize,0);
  8035fc:	6a 00                	push   $0x0
  8035fe:	ff 75 cc             	pushl  -0x34(%ebp)
  803601:	ff 75 08             	pushl  0x8(%ebp)
  803604:	e8 6b f6 ff ff       	call   802c74 <set_block_data>
  803609:	83 c4 0c             	add    $0xc,%esp
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
  80360c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803610:	75 17                	jne    803629 <free_block+0x102>
  803612:	83 ec 04             	sub    $0x4,%esp
  803615:	68 34 4c 80 00       	push   $0x804c34
  80361a:	68 87 01 00 00       	push   $0x187
  80361f:	68 8b 4b 80 00       	push   $0x804b8b
  803624:	e8 08 d4 ff ff       	call   800a31 <_panic>
  803629:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80362c:	8b 00                	mov    (%eax),%eax
  80362e:	85 c0                	test   %eax,%eax
  803630:	74 10                	je     803642 <free_block+0x11b>
  803632:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803635:	8b 00                	mov    (%eax),%eax
  803637:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80363a:	8b 52 04             	mov    0x4(%edx),%edx
  80363d:	89 50 04             	mov    %edx,0x4(%eax)
  803640:	eb 0b                	jmp    80364d <free_block+0x126>
  803642:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803645:	8b 40 04             	mov    0x4(%eax),%eax
  803648:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80364d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803650:	8b 40 04             	mov    0x4(%eax),%eax
  803653:	85 c0                	test   %eax,%eax
  803655:	74 0f                	je     803666 <free_block+0x13f>
  803657:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80365a:	8b 40 04             	mov    0x4(%eax),%eax
  80365d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803660:	8b 12                	mov    (%edx),%edx
  803662:	89 10                	mov    %edx,(%eax)
  803664:	eb 0a                	jmp    803670 <free_block+0x149>
  803666:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803669:	8b 00                	mov    (%eax),%eax
  80366b:	a3 48 50 98 00       	mov    %eax,0x985048
  803670:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803673:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803679:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80367c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803683:	a1 54 50 98 00       	mov    0x985054,%eax
  803688:	48                   	dec    %eax
  803689:	a3 54 50 98 00       	mov    %eax,0x985054
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  80368e:	83 ec 0c             	sub    $0xc,%esp
  803691:	ff 75 08             	pushl  0x8(%ebp)
  803694:	e8 32 f6 ff ff       	call   802ccb <insert_sorted_in_freeList>
  803699:	83 c4 10             	add    $0x10,%esp
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
	{
  80369c:	e9 01 01 00 00       	jmp    8037a2 <free_block+0x27b>
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
  8036a1:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  8036a5:	0f 85 d3 00 00 00    	jne    80377e <free_block+0x257>
  8036ab:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  8036af:	0f 85 c9 00 00 00    	jne    80377e <free_block+0x257>
	{
		// merge the block will be free with its prev and next blocks
		uint32 prevSize = get_block_size(prevBlk);
  8036b5:	83 ec 0c             	sub    $0xc,%esp
  8036b8:	ff 75 e8             	pushl  -0x18(%ebp)
  8036bb:	e8 38 f3 ff ff       	call   8029f8 <get_block_size>
  8036c0:	83 c4 10             	add    $0x10,%esp
  8036c3:	89 45 c8             	mov    %eax,-0x38(%ebp)
		uint32 nextSize = get_block_size(nextBlk);
  8036c6:	83 ec 0c             	sub    $0xc,%esp
  8036c9:	ff 75 e0             	pushl  -0x20(%ebp)
  8036cc:	e8 27 f3 ff ff       	call   8029f8 <get_block_size>
  8036d1:	83 c4 10             	add    $0x10,%esp
  8036d4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 totalSize = freeSize + prevSize + nextSize; // size of main block and its prev and next blocks
  8036d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036da:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8036dd:	01 c2                	add    %eax,%edx
  8036df:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8036e2:	01 d0                	add    %edx,%eax
  8036e4:	89 45 c0             	mov    %eax,-0x40(%ebp)
		// extends prev block size to contain its size and the size of main and next blocks
		set_block_data(prevBlk,totalSize,0);
  8036e7:	83 ec 04             	sub    $0x4,%esp
  8036ea:	6a 00                	push   $0x0
  8036ec:	ff 75 c0             	pushl  -0x40(%ebp)
  8036ef:	ff 75 e8             	pushl  -0x18(%ebp)
  8036f2:	e8 7d f5 ff ff       	call   802c74 <set_block_data>
  8036f7:	83 c4 10             	add    $0x10,%esp
		// remove next block because we merge it with its prev blocks
		LIST_REMOVE(&freeBlocksList, nextBlk);
  8036fa:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8036fe:	75 17                	jne    803717 <free_block+0x1f0>
  803700:	83 ec 04             	sub    $0x4,%esp
  803703:	68 34 4c 80 00       	push   $0x804c34
  803708:	68 94 01 00 00       	push   $0x194
  80370d:	68 8b 4b 80 00       	push   $0x804b8b
  803712:	e8 1a d3 ff ff       	call   800a31 <_panic>
  803717:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80371a:	8b 00                	mov    (%eax),%eax
  80371c:	85 c0                	test   %eax,%eax
  80371e:	74 10                	je     803730 <free_block+0x209>
  803720:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803723:	8b 00                	mov    (%eax),%eax
  803725:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803728:	8b 52 04             	mov    0x4(%edx),%edx
  80372b:	89 50 04             	mov    %edx,0x4(%eax)
  80372e:	eb 0b                	jmp    80373b <free_block+0x214>
  803730:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803733:	8b 40 04             	mov    0x4(%eax),%eax
  803736:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80373b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80373e:	8b 40 04             	mov    0x4(%eax),%eax
  803741:	85 c0                	test   %eax,%eax
  803743:	74 0f                	je     803754 <free_block+0x22d>
  803745:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803748:	8b 40 04             	mov    0x4(%eax),%eax
  80374b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80374e:	8b 12                	mov    (%edx),%edx
  803750:	89 10                	mov    %edx,(%eax)
  803752:	eb 0a                	jmp    80375e <free_block+0x237>
  803754:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803757:	8b 00                	mov    (%eax),%eax
  803759:	a3 48 50 98 00       	mov    %eax,0x985048
  80375e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803761:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803767:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80376a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803771:	a1 54 50 98 00       	mov    0x985054,%eax
  803776:	48                   	dec    %eax
  803777:	a3 54 50 98 00       	mov    %eax,0x985054
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
	{
  80377c:	eb 24                	jmp    8037a2 <free_block+0x27b>
	}
	else
	{
		// free it without any merge
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
  80377e:	83 ec 04             	sub    $0x4,%esp
  803781:	6a 00                	push   $0x0
  803783:	ff 75 f4             	pushl  -0xc(%ebp)
  803786:	ff 75 08             	pushl  0x8(%ebp)
  803789:	e8 e6 f4 ff ff       	call   802c74 <set_block_data>
  80378e:	83 c4 10             	add    $0x10,%esp
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  803791:	83 ec 0c             	sub    $0xc,%esp
  803794:	ff 75 08             	pushl  0x8(%ebp)
  803797:	e8 2f f5 ff ff       	call   802ccb <insert_sorted_in_freeList>
  80379c:	83 c4 10             	add    $0x10,%esp
  80379f:	eb 01                	jmp    8037a2 <free_block+0x27b>
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
	{
		return;
  8037a1:	90                   	nop
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
}
  8037a2:	c9                   	leave  
  8037a3:	c3                   	ret    

008037a4 <realloc_block_FF>:
//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
  8037a4:	55                   	push   %ebp
  8037a5:	89 e5                	mov    %esp,%ebp
  8037a7:	83 ec 38             	sub    $0x38,%esp
	//TODO: [PROJECT'24.MS1 - #08] [3] DYNAMIC ALLOCATOR - realloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(va == NULL && new_size == 0)
  8037aa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037ae:	75 10                	jne    8037c0 <realloc_block_FF+0x1c>
  8037b0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8037b4:	75 0a                	jne    8037c0 <realloc_block_FF+0x1c>
	{
		return NULL;
  8037b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8037bb:	e9 8b 04 00 00       	jmp    803c4b <realloc_block_FF+0x4a7>
	}

	if(new_size == 0)
  8037c0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8037c4:	75 18                	jne    8037de <realloc_block_FF+0x3a>
	{
		free_block(va);
  8037c6:	83 ec 0c             	sub    $0xc,%esp
  8037c9:	ff 75 08             	pushl  0x8(%ebp)
  8037cc:	e8 56 fd ff ff       	call   803527 <free_block>
  8037d1:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8037d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8037d9:	e9 6d 04 00 00       	jmp    803c4b <realloc_block_FF+0x4a7>
	}

	if(va == NULL)
  8037de:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037e2:	75 13                	jne    8037f7 <realloc_block_FF+0x53>
	{
		return alloc_block_FF(new_size);
  8037e4:	83 ec 0c             	sub    $0xc,%esp
  8037e7:	ff 75 0c             	pushl  0xc(%ebp)
  8037ea:	e8 6f f6 ff ff       	call   802e5e <alloc_block_FF>
  8037ef:	83 c4 10             	add    $0x10,%esp
  8037f2:	e9 54 04 00 00       	jmp    803c4b <realloc_block_FF+0x4a7>
	}

	// if size is odd must be increment it by one
	if (new_size % 2 != 0)
  8037f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037fa:	83 e0 01             	and    $0x1,%eax
  8037fd:	85 c0                	test   %eax,%eax
  8037ff:	74 03                	je     803804 <realloc_block_FF+0x60>
	{
		new_size++;
  803801:	ff 45 0c             	incl   0xc(%ebp)
	}

	// if size < 8 must be equal it to 8 because min size 8 excluding metadata
	if(new_size < 8)
  803804:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803808:	77 07                	ja     803811 <realloc_block_FF+0x6d>
	{
		new_size = 8;
  80380a:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	}

	new_size += 8; // adds its footer and header size
  803811:	83 45 0c 08          	addl   $0x8,0xc(%ebp)

	uint32 actualSize = get_block_size(va);
  803815:	83 ec 0c             	sub    $0xc,%esp
  803818:	ff 75 08             	pushl  0x8(%ebp)
  80381b:	e8 d8 f1 ff ff       	call   8029f8 <get_block_size>
  803820:	83 c4 10             	add    $0x10,%esp
  803823:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(actualSize == new_size)
  803826:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803829:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80382c:	75 08                	jne    803836 <realloc_block_FF+0x92>
	{
		// don't change any thing
		return va;
  80382e:	8b 45 08             	mov    0x8(%ebp),%eax
  803831:	e9 15 04 00 00       	jmp    803c4b <realloc_block_FF+0x4a7>
	}

	// next block for the block we want to change its size
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + actualSize);
  803836:	8b 55 08             	mov    0x8(%ebp),%edx
  803839:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80383c:	01 d0                	add    %edx,%eax
  80383e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  803841:	83 ec 0c             	sub    $0xc,%esp
  803844:	ff 75 f0             	pushl  -0x10(%ebp)
  803847:	e8 c5 f1 ff ff       	call   802a11 <is_free_block>
  80384c:	83 c4 10             	add    $0x10,%esp
  80384f:	0f be c0             	movsbl %al,%eax
  803852:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 nextSize = get_block_size(nextBlk);
  803855:	83 ec 0c             	sub    $0xc,%esp
  803858:	ff 75 f0             	pushl  -0x10(%ebp)
  80385b:	e8 98 f1 ff ff       	call   8029f8 <get_block_size>
  803860:	83 c4 10             	add    $0x10,%esp
  803863:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// increase the size of block
	if(new_size > actualSize)
  803866:	8b 45 0c             	mov    0xc(%ebp),%eax
  803869:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80386c:	0f 86 a7 02 00 00    	jbe    803b19 <realloc_block_FF+0x375>
	{
		if(isNextFree)
  803872:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803876:	0f 84 86 02 00 00    	je     803b02 <realloc_block_FF+0x35e>
		{
			if(nextSize + actualSize == new_size) // block and nextblock = newSizeBlock
  80387c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80387f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803882:	01 d0                	add    %edx,%eax
  803884:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803887:	0f 85 b2 00 00 00    	jne    80393f <realloc_block_FF+0x19b>
			{
				set_block_data(va,new_size,!(is_free_block(va)));// update size in block
  80388d:	83 ec 0c             	sub    $0xc,%esp
  803890:	ff 75 08             	pushl  0x8(%ebp)
  803893:	e8 79 f1 ff ff       	call   802a11 <is_free_block>
  803898:	83 c4 10             	add    $0x10,%esp
  80389b:	84 c0                	test   %al,%al
  80389d:	0f 94 c0             	sete   %al
  8038a0:	0f b6 c0             	movzbl %al,%eax
  8038a3:	83 ec 04             	sub    $0x4,%esp
  8038a6:	50                   	push   %eax
  8038a7:	ff 75 0c             	pushl  0xc(%ebp)
  8038aa:	ff 75 08             	pushl  0x8(%ebp)
  8038ad:	e8 c2 f3 ff ff       	call   802c74 <set_block_data>
  8038b2:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);// remove next because it is = zero
  8038b5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8038b9:	75 17                	jne    8038d2 <realloc_block_FF+0x12e>
  8038bb:	83 ec 04             	sub    $0x4,%esp
  8038be:	68 34 4c 80 00       	push   $0x804c34
  8038c3:	68 db 01 00 00       	push   $0x1db
  8038c8:	68 8b 4b 80 00       	push   $0x804b8b
  8038cd:	e8 5f d1 ff ff       	call   800a31 <_panic>
  8038d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038d5:	8b 00                	mov    (%eax),%eax
  8038d7:	85 c0                	test   %eax,%eax
  8038d9:	74 10                	je     8038eb <realloc_block_FF+0x147>
  8038db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038de:	8b 00                	mov    (%eax),%eax
  8038e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8038e3:	8b 52 04             	mov    0x4(%edx),%edx
  8038e6:	89 50 04             	mov    %edx,0x4(%eax)
  8038e9:	eb 0b                	jmp    8038f6 <realloc_block_FF+0x152>
  8038eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038ee:	8b 40 04             	mov    0x4(%eax),%eax
  8038f1:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8038f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038f9:	8b 40 04             	mov    0x4(%eax),%eax
  8038fc:	85 c0                	test   %eax,%eax
  8038fe:	74 0f                	je     80390f <realloc_block_FF+0x16b>
  803900:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803903:	8b 40 04             	mov    0x4(%eax),%eax
  803906:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803909:	8b 12                	mov    (%edx),%edx
  80390b:	89 10                	mov    %edx,(%eax)
  80390d:	eb 0a                	jmp    803919 <realloc_block_FF+0x175>
  80390f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803912:	8b 00                	mov    (%eax),%eax
  803914:	a3 48 50 98 00       	mov    %eax,0x985048
  803919:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80391c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803922:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803925:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80392c:	a1 54 50 98 00       	mov    0x985054,%eax
  803931:	48                   	dec    %eax
  803932:	a3 54 50 98 00       	mov    %eax,0x985054
				return va;
  803937:	8b 45 08             	mov    0x8(%ebp),%eax
  80393a:	e9 0c 03 00 00       	jmp    803c4b <realloc_block_FF+0x4a7>
			}
			else if(nextSize + actualSize > new_size) // new size is less than next and main blocks
  80393f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803942:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803945:	01 d0                	add    %edx,%eax
  803947:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80394a:	0f 86 b2 01 00 00    	jbe    803b02 <realloc_block_FF+0x35e>
			{
				uint32 requiredSize = new_size - actualSize; // size that we need from the next block
  803950:	8b 45 0c             	mov    0xc(%ebp),%eax
  803953:	2b 45 f4             	sub    -0xc(%ebp),%eax
  803956:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				uint32 remainingNext = nextSize - requiredSize; // size that will remain from the next block after we split it
  803959:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80395c:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80395f:	89 45 e0             	mov    %eax,-0x20(%ebp)

				// if next size will not fit another block (internal fragmentation)
				if(remainingNext < 16)
  803962:	83 7d e0 0f          	cmpl   $0xf,-0x20(%ebp)
  803966:	0f 87 b8 00 00 00    	ja     803a24 <realloc_block_FF+0x280>
				{
					// we will take the main size of the block and its next size also
					set_block_data(va,actualSize + nextSize,!(is_free_block(va)));
  80396c:	83 ec 0c             	sub    $0xc,%esp
  80396f:	ff 75 08             	pushl  0x8(%ebp)
  803972:	e8 9a f0 ff ff       	call   802a11 <is_free_block>
  803977:	83 c4 10             	add    $0x10,%esp
  80397a:	84 c0                	test   %al,%al
  80397c:	0f 94 c0             	sete   %al
  80397f:	0f b6 c0             	movzbl %al,%eax
  803982:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803985:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803988:	01 ca                	add    %ecx,%edx
  80398a:	83 ec 04             	sub    $0x4,%esp
  80398d:	50                   	push   %eax
  80398e:	52                   	push   %edx
  80398f:	ff 75 08             	pushl  0x8(%ebp)
  803992:	e8 dd f2 ff ff       	call   802c74 <set_block_data>
  803997:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,nextBlk);
  80399a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80399e:	75 17                	jne    8039b7 <realloc_block_FF+0x213>
  8039a0:	83 ec 04             	sub    $0x4,%esp
  8039a3:	68 34 4c 80 00       	push   $0x804c34
  8039a8:	68 e8 01 00 00       	push   $0x1e8
  8039ad:	68 8b 4b 80 00       	push   $0x804b8b
  8039b2:	e8 7a d0 ff ff       	call   800a31 <_panic>
  8039b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039ba:	8b 00                	mov    (%eax),%eax
  8039bc:	85 c0                	test   %eax,%eax
  8039be:	74 10                	je     8039d0 <realloc_block_FF+0x22c>
  8039c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039c3:	8b 00                	mov    (%eax),%eax
  8039c5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8039c8:	8b 52 04             	mov    0x4(%edx),%edx
  8039cb:	89 50 04             	mov    %edx,0x4(%eax)
  8039ce:	eb 0b                	jmp    8039db <realloc_block_FF+0x237>
  8039d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039d3:	8b 40 04             	mov    0x4(%eax),%eax
  8039d6:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8039db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039de:	8b 40 04             	mov    0x4(%eax),%eax
  8039e1:	85 c0                	test   %eax,%eax
  8039e3:	74 0f                	je     8039f4 <realloc_block_FF+0x250>
  8039e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039e8:	8b 40 04             	mov    0x4(%eax),%eax
  8039eb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8039ee:	8b 12                	mov    (%edx),%edx
  8039f0:	89 10                	mov    %edx,(%eax)
  8039f2:	eb 0a                	jmp    8039fe <realloc_block_FF+0x25a>
  8039f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039f7:	8b 00                	mov    (%eax),%eax
  8039f9:	a3 48 50 98 00       	mov    %eax,0x985048
  8039fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a01:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a0a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a11:	a1 54 50 98 00       	mov    0x985054,%eax
  803a16:	48                   	dec    %eax
  803a17:	a3 54 50 98 00       	mov    %eax,0x985054
					return va;
  803a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  803a1f:	e9 27 02 00 00       	jmp    803c4b <realloc_block_FF+0x4a7>
				}
				else // if next size can be fit another block (split)
				{
					LIST_REMOVE(&freeBlocksList,nextBlk);
  803a24:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803a28:	75 17                	jne    803a41 <realloc_block_FF+0x29d>
  803a2a:	83 ec 04             	sub    $0x4,%esp
  803a2d:	68 34 4c 80 00       	push   $0x804c34
  803a32:	68 ed 01 00 00       	push   $0x1ed
  803a37:	68 8b 4b 80 00       	push   $0x804b8b
  803a3c:	e8 f0 cf ff ff       	call   800a31 <_panic>
  803a41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a44:	8b 00                	mov    (%eax),%eax
  803a46:	85 c0                	test   %eax,%eax
  803a48:	74 10                	je     803a5a <realloc_block_FF+0x2b6>
  803a4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a4d:	8b 00                	mov    (%eax),%eax
  803a4f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a52:	8b 52 04             	mov    0x4(%edx),%edx
  803a55:	89 50 04             	mov    %edx,0x4(%eax)
  803a58:	eb 0b                	jmp    803a65 <realloc_block_FF+0x2c1>
  803a5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a5d:	8b 40 04             	mov    0x4(%eax),%eax
  803a60:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803a65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a68:	8b 40 04             	mov    0x4(%eax),%eax
  803a6b:	85 c0                	test   %eax,%eax
  803a6d:	74 0f                	je     803a7e <realloc_block_FF+0x2da>
  803a6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a72:	8b 40 04             	mov    0x4(%eax),%eax
  803a75:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a78:	8b 12                	mov    (%edx),%edx
  803a7a:	89 10                	mov    %edx,(%eax)
  803a7c:	eb 0a                	jmp    803a88 <realloc_block_FF+0x2e4>
  803a7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a81:	8b 00                	mov    (%eax),%eax
  803a83:	a3 48 50 98 00       	mov    %eax,0x985048
  803a88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a8b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a94:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a9b:	a1 54 50 98 00       	mov    0x985054,%eax
  803aa0:	48                   	dec    %eax
  803aa1:	a3 54 50 98 00       	mov    %eax,0x985054
					nextBlk = (struct BlockElement *)((char *)va + new_size); //update nextBlk address
  803aa6:	8b 55 08             	mov    0x8(%ebp),%edx
  803aa9:	8b 45 0c             	mov    0xc(%ebp),%eax
  803aac:	01 d0                	add    %edx,%eax
  803aae:	89 45 f0             	mov    %eax,-0x10(%ebp)
					set_block_data(nextBlk,remainingNext,0); // update nextBlkSize
  803ab1:	83 ec 04             	sub    $0x4,%esp
  803ab4:	6a 00                	push   $0x0
  803ab6:	ff 75 e0             	pushl  -0x20(%ebp)
  803ab9:	ff 75 f0             	pushl  -0x10(%ebp)
  803abc:	e8 b3 f1 ff ff       	call   802c74 <set_block_data>
  803ac1:	83 c4 10             	add    $0x10,%esp
					set_block_data(va,new_size,!(is_free_block(va))); // update size of newblock
  803ac4:	83 ec 0c             	sub    $0xc,%esp
  803ac7:	ff 75 08             	pushl  0x8(%ebp)
  803aca:	e8 42 ef ff ff       	call   802a11 <is_free_block>
  803acf:	83 c4 10             	add    $0x10,%esp
  803ad2:	84 c0                	test   %al,%al
  803ad4:	0f 94 c0             	sete   %al
  803ad7:	0f b6 c0             	movzbl %al,%eax
  803ada:	83 ec 04             	sub    $0x4,%esp
  803add:	50                   	push   %eax
  803ade:	ff 75 0c             	pushl  0xc(%ebp)
  803ae1:	ff 75 08             	pushl  0x8(%ebp)
  803ae4:	e8 8b f1 ff ff       	call   802c74 <set_block_data>
  803ae9:	83 c4 10             	add    $0x10,%esp
					insert_sorted_in_freeList(nextBlk);
  803aec:	83 ec 0c             	sub    $0xc,%esp
  803aef:	ff 75 f0             	pushl  -0x10(%ebp)
  803af2:	e8 d4 f1 ff ff       	call   802ccb <insert_sorted_in_freeList>
  803af7:	83 c4 10             	add    $0x10,%esp
					return va;
  803afa:	8b 45 08             	mov    0x8(%ebp),%eax
  803afd:	e9 49 01 00 00       	jmp    803c4b <realloc_block_FF+0x4a7>
				}
			}
		}
		// if next block isn't free or not fit the new size
		return alloc_block_FF(new_size - 8);
  803b02:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b05:	83 e8 08             	sub    $0x8,%eax
  803b08:	83 ec 0c             	sub    $0xc,%esp
  803b0b:	50                   	push   %eax
  803b0c:	e8 4d f3 ff ff       	call   802e5e <alloc_block_FF>
  803b11:	83 c4 10             	add    $0x10,%esp
  803b14:	e9 32 01 00 00       	jmp    803c4b <realloc_block_FF+0x4a7>
	}
	else if(new_size < actualSize) // to shrink block
  803b19:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b1c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803b1f:	0f 83 21 01 00 00    	jae    803c46 <realloc_block_FF+0x4a2>
	{
		uint32 remainingSize = actualSize - new_size; // size that will remain from the main block after we shrink it
  803b25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b28:	2b 45 0c             	sub    0xc(%ebp),%eax
  803b2b:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(remainingSize < 16 && isNextFree == 0) // internal fragmentation
  803b2e:	83 7d dc 0f          	cmpl   $0xf,-0x24(%ebp)
  803b32:	77 0e                	ja     803b42 <realloc_block_FF+0x39e>
  803b34:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803b38:	75 08                	jne    803b42 <realloc_block_FF+0x39e>
		{
			// don't change its size
			return va;
  803b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  803b3d:	e9 09 01 00 00       	jmp    803c4b <realloc_block_FF+0x4a7>
		}
		else // remainingSize fit in a new block
		{
			struct BlockElement *mainBlk = (struct BlockElement *)va;
  803b42:	8b 45 08             	mov    0x8(%ebp),%eax
  803b45:	89 45 d8             	mov    %eax,-0x28(%ebp)
			// update main block with new size
			set_block_data(mainBlk,new_size,!(is_free_block(va)));
  803b48:	83 ec 0c             	sub    $0xc,%esp
  803b4b:	ff 75 08             	pushl  0x8(%ebp)
  803b4e:	e8 be ee ff ff       	call   802a11 <is_free_block>
  803b53:	83 c4 10             	add    $0x10,%esp
  803b56:	84 c0                	test   %al,%al
  803b58:	0f 94 c0             	sete   %al
  803b5b:	0f b6 c0             	movzbl %al,%eax
  803b5e:	83 ec 04             	sub    $0x4,%esp
  803b61:	50                   	push   %eax
  803b62:	ff 75 0c             	pushl  0xc(%ebp)
  803b65:	ff 75 d8             	pushl  -0x28(%ebp)
  803b68:	e8 07 f1 ff ff       	call   802c74 <set_block_data>
  803b6d:	83 c4 10             	add    $0x10,%esp

			// the blk with remaining size
			struct BlockElement *remainingBlk=(struct BlockElement *)((char*)mainBlk + new_size);
  803b70:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803b73:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b76:	01 d0                	add    %edx,%eax
  803b78:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			set_block_data(remainingBlk,remainingSize,0);
  803b7b:	83 ec 04             	sub    $0x4,%esp
  803b7e:	6a 00                	push   $0x0
  803b80:	ff 75 dc             	pushl  -0x24(%ebp)
  803b83:	ff 75 d4             	pushl  -0x2c(%ebp)
  803b86:	e8 e9 f0 ff ff       	call   802c74 <set_block_data>
  803b8b:	83 c4 10             	add    $0x10,%esp

			if(isNextFree)
  803b8e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803b92:	0f 84 9b 00 00 00    	je     803c33 <realloc_block_FF+0x48f>
			{
				// merge splited block with its next block
				set_block_data(remainingBlk,(remainingSize + nextSize),0);//merge remaining with its next block
  803b98:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803b9b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b9e:	01 d0                	add    %edx,%eax
  803ba0:	83 ec 04             	sub    $0x4,%esp
  803ba3:	6a 00                	push   $0x0
  803ba5:	50                   	push   %eax
  803ba6:	ff 75 d4             	pushl  -0x2c(%ebp)
  803ba9:	e8 c6 f0 ff ff       	call   802c74 <set_block_data>
  803bae:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);
  803bb1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803bb5:	75 17                	jne    803bce <realloc_block_FF+0x42a>
  803bb7:	83 ec 04             	sub    $0x4,%esp
  803bba:	68 34 4c 80 00       	push   $0x804c34
  803bbf:	68 10 02 00 00       	push   $0x210
  803bc4:	68 8b 4b 80 00       	push   $0x804b8b
  803bc9:	e8 63 ce ff ff       	call   800a31 <_panic>
  803bce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bd1:	8b 00                	mov    (%eax),%eax
  803bd3:	85 c0                	test   %eax,%eax
  803bd5:	74 10                	je     803be7 <realloc_block_FF+0x443>
  803bd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bda:	8b 00                	mov    (%eax),%eax
  803bdc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803bdf:	8b 52 04             	mov    0x4(%edx),%edx
  803be2:	89 50 04             	mov    %edx,0x4(%eax)
  803be5:	eb 0b                	jmp    803bf2 <realloc_block_FF+0x44e>
  803be7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bea:	8b 40 04             	mov    0x4(%eax),%eax
  803bed:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803bf2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bf5:	8b 40 04             	mov    0x4(%eax),%eax
  803bf8:	85 c0                	test   %eax,%eax
  803bfa:	74 0f                	je     803c0b <realloc_block_FF+0x467>
  803bfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bff:	8b 40 04             	mov    0x4(%eax),%eax
  803c02:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c05:	8b 12                	mov    (%edx),%edx
  803c07:	89 10                	mov    %edx,(%eax)
  803c09:	eb 0a                	jmp    803c15 <realloc_block_FF+0x471>
  803c0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c0e:	8b 00                	mov    (%eax),%eax
  803c10:	a3 48 50 98 00       	mov    %eax,0x985048
  803c15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c18:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c21:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c28:	a1 54 50 98 00       	mov    0x985054,%eax
  803c2d:	48                   	dec    %eax
  803c2e:	a3 54 50 98 00       	mov    %eax,0x985054
			}
			insert_sorted_in_freeList(remainingBlk);
  803c33:	83 ec 0c             	sub    $0xc,%esp
  803c36:	ff 75 d4             	pushl  -0x2c(%ebp)
  803c39:	e8 8d f0 ff ff       	call   802ccb <insert_sorted_in_freeList>
  803c3e:	83 c4 10             	add    $0x10,%esp
			return mainBlk;
  803c41:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803c44:	eb 05                	jmp    803c4b <realloc_block_FF+0x4a7>
		}
	}
	return NULL;
  803c46:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c4b:	c9                   	leave  
  803c4c:	c3                   	ret    

00803c4d <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803c4d:	55                   	push   %ebp
  803c4e:	89 e5                	mov    %esp,%ebp
  803c50:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803c53:	83 ec 04             	sub    $0x4,%esp
  803c56:	68 54 4c 80 00       	push   $0x804c54
  803c5b:	68 20 02 00 00       	push   $0x220
  803c60:	68 8b 4b 80 00       	push   $0x804b8b
  803c65:	e8 c7 cd ff ff       	call   800a31 <_panic>

00803c6a <alloc_block_NF>:
}
//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803c6a:	55                   	push   %ebp
  803c6b:	89 e5                	mov    %esp,%ebp
  803c6d:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803c70:	83 ec 04             	sub    $0x4,%esp
  803c73:	68 7c 4c 80 00       	push   $0x804c7c
  803c78:	68 28 02 00 00       	push   $0x228
  803c7d:	68 8b 4b 80 00       	push   $0x804b8b
  803c82:	e8 aa cd ff ff       	call   800a31 <_panic>

00803c87 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  803c87:	55                   	push   %ebp
  803c88:	89 e5                	mov    %esp,%ebp
  803c8a:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("create_semaphore is not implemented yet");
	//Your Code is Here...

	//create object of __semdata struct and allocate it using smalloc with sizeof __semdata struct
	struct __semdata* semaphoryData = (struct __semdata *)smalloc(semaphoreName , sizeof(struct __semdata) ,1);
  803c8d:	83 ec 04             	sub    $0x4,%esp
  803c90:	6a 01                	push   $0x1
  803c92:	6a 58                	push   $0x58
  803c94:	ff 75 0c             	pushl  0xc(%ebp)
  803c97:	e8 c1 e2 ff ff       	call   801f5d <smalloc>
  803c9c:	83 c4 10             	add    $0x10,%esp
  803c9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(semaphoryData == NULL)
  803ca2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ca6:	75 14                	jne    803cbc <create_semaphore+0x35>
	{
		panic("Not Enough Space to allocate semdata object!!");
  803ca8:	83 ec 04             	sub    $0x4,%esp
  803cab:	68 a4 4c 80 00       	push   $0x804ca4
  803cb0:	6a 10                	push   $0x10
  803cb2:	68 d2 4c 80 00       	push   $0x804cd2
  803cb7:	e8 75 cd ff ff       	call   800a31 <_panic>
	}
	//aboveObject.queue pass it to init_queue() function
	sys_init_queue(&(semaphoryData->queue));
  803cbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cbf:	83 ec 0c             	sub    $0xc,%esp
  803cc2:	50                   	push   %eax
  803cc3:	e8 bc ec ff ff       	call   802984 <sys_init_queue>
  803cc8:	83 c4 10             	add    $0x10,%esp
	//lock variable initially with zero
	semaphoryData->lock = 0;
  803ccb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cce:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
	//initialize aboveObject with semaphore name and value
	strncpy(semaphoryData->name , semaphoreName , sizeof(semaphoryData->name));
  803cd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cd8:	83 c0 18             	add    $0x18,%eax
  803cdb:	83 ec 04             	sub    $0x4,%esp
  803cde:	6a 40                	push   $0x40
  803ce0:	ff 75 0c             	pushl  0xc(%ebp)
  803ce3:	50                   	push   %eax
  803ce4:	e8 1e d9 ff ff       	call   801607 <strncpy>
  803ce9:	83 c4 10             	add    $0x10,%esp
	semaphoryData->count = value;
  803cec:	8b 55 10             	mov    0x10(%ebp),%edx
  803cef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cf2:	89 50 10             	mov    %edx,0x10(%eax)

	//create object of semaphore struct
	struct semaphore semaphory;
	//add aboveObject to this semaphore object
	semaphory.semdata = semaphoryData;
  803cf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cf8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//return semaphore object
	return semaphory;
  803cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  803cfe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d01:	89 10                	mov    %edx,(%eax)
}
  803d03:	8b 45 08             	mov    0x8(%ebp),%eax
  803d06:	c9                   	leave  
  803d07:	c2 04 00             	ret    $0x4

00803d0a <get_semaphore>:
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  803d0a:	55                   	push   %ebp
  803d0b:	89 e5                	mov    %esp,%ebp
  803d0d:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("get_semaphore is not implemented yet");
	//Your Code is Here...

	// get the semdata object that is allocated, using sget
	struct __semdata* semaphoryData = sget(ownerEnvID, semaphoreName);
  803d10:	83 ec 08             	sub    $0x8,%esp
  803d13:	ff 75 10             	pushl  0x10(%ebp)
  803d16:	ff 75 0c             	pushl  0xc(%ebp)
  803d19:	e8 da e3 ff ff       	call   8020f8 <sget>
  803d1e:	83 c4 10             	add    $0x10,%esp
  803d21:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(semaphoryData == NULL)
  803d24:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d28:	75 14                	jne    803d3e <get_semaphore+0x34>
	{
		panic("semdatat object does not exist!!");
  803d2a:	83 ec 04             	sub    $0x4,%esp
  803d2d:	68 e4 4c 80 00       	push   $0x804ce4
  803d32:	6a 2c                	push   $0x2c
  803d34:	68 d2 4c 80 00       	push   $0x804cd2
  803d39:	e8 f3 cc ff ff       	call   800a31 <_panic>
	}
	//create object of semaphore struct
	struct semaphore semaphory;
	//add semdata object to this semaphore object
	semaphory.semdata = semaphoryData;
  803d3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d41:	89 45 f0             	mov    %eax,-0x10(%ebp)
	return semaphory;
  803d44:	8b 45 08             	mov    0x8(%ebp),%eax
  803d47:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d4a:	89 10                	mov    %edx,(%eax)
}
  803d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  803d4f:	c9                   	leave  
  803d50:	c2 04 00             	ret    $0x4

00803d53 <wait_semaphore>:

void wait_semaphore(struct semaphore sem)
{
  803d53:	55                   	push   %ebp
  803d54:	89 e5                	mov    %esp,%ebp
  803d56:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("wait_semaphore is not implemented yet");
	//Your Code is Here...

	//acquire semaphore lock
	uint32 myKey = 1;
  803d59:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	do
	{
		xchg(&myKey, sem.semdata->lock); // xchg atomically exchanges values
  803d60:	8b 45 08             	mov    0x8(%ebp),%eax
  803d63:	8b 40 14             	mov    0x14(%eax),%eax
  803d66:	8d 55 e8             	lea    -0x18(%ebp),%edx
  803d69:	89 55 f4             	mov    %edx,-0xc(%ebp)
  803d6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  803d6f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d75:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803d78:	f0 87 02             	lock xchg %eax,(%edx)
  803d7b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	} while (myKey != 0);
  803d7e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d81:	85 c0                	test   %eax,%eax
  803d83:	75 db                	jne    803d60 <wait_semaphore+0xd>

	//decrement the semaphore counter
	sem.semdata->count--;
  803d85:	8b 45 08             	mov    0x8(%ebp),%eax
  803d88:	8b 50 10             	mov    0x10(%eax),%edx
  803d8b:	4a                   	dec    %edx
  803d8c:	89 50 10             	mov    %edx,0x10(%eax)

	if (sem.semdata->count < 0)
  803d8f:	8b 45 08             	mov    0x8(%ebp),%eax
  803d92:	8b 40 10             	mov    0x10(%eax),%eax
  803d95:	85 c0                	test   %eax,%eax
  803d97:	79 18                	jns    803db1 <wait_semaphore+0x5e>
	{
		// block the current process
		sys_block_process(&(sem.semdata->queue),&(sem.semdata->lock));
  803d99:	8b 45 08             	mov    0x8(%ebp),%eax
  803d9c:	8d 50 14             	lea    0x14(%eax),%edx
  803d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  803da2:	83 ec 08             	sub    $0x8,%esp
  803da5:	52                   	push   %edx
  803da6:	50                   	push   %eax
  803da7:	e8 f4 eb ff ff       	call   8029a0 <sys_block_process>
  803dac:	83 c4 10             	add    $0x10,%esp
  803daf:	eb 0a                	jmp    803dbb <wait_semaphore+0x68>
		return;
	}
	//release semaphore lock
	sem.semdata->lock = 0;
  803db1:	8b 45 08             	mov    0x8(%ebp),%eax
  803db4:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
}
  803dbb:	c9                   	leave  
  803dbc:	c3                   	ret    

00803dbd <signal_semaphore>:

void signal_semaphore(struct semaphore sem)
{
  803dbd:	55                   	push   %ebp
  803dbe:	89 e5                	mov    %esp,%ebp
  803dc0:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("signal_semaphore is not implemented yet");
	//Your Code is Here...

	//acquire semaphore lock
	uint32 myKey = 1;
  803dc3:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	do
	{
		xchg(&myKey, sem.semdata->lock); // xchg atomically exchanges values
  803dca:	8b 45 08             	mov    0x8(%ebp),%eax
  803dcd:	8b 40 14             	mov    0x14(%eax),%eax
  803dd0:	8d 55 e8             	lea    -0x18(%ebp),%edx
  803dd3:	89 55 f4             	mov    %edx,-0xc(%ebp)
  803dd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803dd9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ddc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ddf:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803de2:	f0 87 02             	lock xchg %eax,(%edx)
  803de5:	89 45 ec             	mov    %eax,-0x14(%ebp)
	} while (myKey != 0);
  803de8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803deb:	85 c0                	test   %eax,%eax
  803ded:	75 db                	jne    803dca <signal_semaphore+0xd>

	// increment the semaphore counter
	sem.semdata->count++;
  803def:	8b 45 08             	mov    0x8(%ebp),%eax
  803df2:	8b 50 10             	mov    0x10(%eax),%edx
  803df5:	42                   	inc    %edx
  803df6:	89 50 10             	mov    %edx,0x10(%eax)

	if (sem.semdata->count <= 0) {
  803df9:	8b 45 08             	mov    0x8(%ebp),%eax
  803dfc:	8b 40 10             	mov    0x10(%eax),%eax
  803dff:	85 c0                	test   %eax,%eax
  803e01:	7f 0f                	jg     803e12 <signal_semaphore+0x55>
		// unblock the current process
		sys_unblock_process(&(sem.semdata->queue));
  803e03:	8b 45 08             	mov    0x8(%ebp),%eax
  803e06:	83 ec 0c             	sub    $0xc,%esp
  803e09:	50                   	push   %eax
  803e0a:	e8 af eb ff ff       	call   8029be <sys_unblock_process>
  803e0f:	83 c4 10             	add    $0x10,%esp
	}

	// release the lock
	sem.semdata->lock = 0;
  803e12:	8b 45 08             	mov    0x8(%ebp),%eax
  803e15:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
}
  803e1c:	90                   	nop
  803e1d:	c9                   	leave  
  803e1e:	c3                   	ret    

00803e1f <semaphore_count>:

int semaphore_count(struct semaphore sem)
{
  803e1f:	55                   	push   %ebp
  803e20:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  803e22:	8b 45 08             	mov    0x8(%ebp),%eax
  803e25:	8b 40 10             	mov    0x10(%eax),%eax
}
  803e28:	5d                   	pop    %ebp
  803e29:	c3                   	ret    
  803e2a:	66 90                	xchg   %ax,%ax

00803e2c <__divdi3>:
  803e2c:	55                   	push   %ebp
  803e2d:	57                   	push   %edi
  803e2e:	56                   	push   %esi
  803e2f:	53                   	push   %ebx
  803e30:	83 ec 1c             	sub    $0x1c,%esp
  803e33:	8b 44 24 30          	mov    0x30(%esp),%eax
  803e37:	8b 54 24 34          	mov    0x34(%esp),%edx
  803e3b:	8b 74 24 38          	mov    0x38(%esp),%esi
  803e3f:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  803e43:	89 f9                	mov    %edi,%ecx
  803e45:	85 d2                	test   %edx,%edx
  803e47:	0f 88 bb 00 00 00    	js     803f08 <__divdi3+0xdc>
  803e4d:	31 ed                	xor    %ebp,%ebp
  803e4f:	85 c9                	test   %ecx,%ecx
  803e51:	0f 88 99 00 00 00    	js     803ef0 <__divdi3+0xc4>
  803e57:	89 34 24             	mov    %esi,(%esp)
  803e5a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  803e5e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803e62:	89 d3                	mov    %edx,%ebx
  803e64:	8b 34 24             	mov    (%esp),%esi
  803e67:	8b 7c 24 04          	mov    0x4(%esp),%edi
  803e6b:	89 74 24 08          	mov    %esi,0x8(%esp)
  803e6f:	8b 34 24             	mov    (%esp),%esi
  803e72:	89 c1                	mov    %eax,%ecx
  803e74:	85 ff                	test   %edi,%edi
  803e76:	75 10                	jne    803e88 <__divdi3+0x5c>
  803e78:	8b 7c 24 08          	mov    0x8(%esp),%edi
  803e7c:	39 d7                	cmp    %edx,%edi
  803e7e:	76 4c                	jbe    803ecc <__divdi3+0xa0>
  803e80:	f7 f7                	div    %edi
  803e82:	89 c1                	mov    %eax,%ecx
  803e84:	31 f6                	xor    %esi,%esi
  803e86:	eb 08                	jmp    803e90 <__divdi3+0x64>
  803e88:	39 d7                	cmp    %edx,%edi
  803e8a:	76 1c                	jbe    803ea8 <__divdi3+0x7c>
  803e8c:	31 f6                	xor    %esi,%esi
  803e8e:	31 c9                	xor    %ecx,%ecx
  803e90:	89 c8                	mov    %ecx,%eax
  803e92:	89 f2                	mov    %esi,%edx
  803e94:	85 ed                	test   %ebp,%ebp
  803e96:	74 07                	je     803e9f <__divdi3+0x73>
  803e98:	f7 d8                	neg    %eax
  803e9a:	83 d2 00             	adc    $0x0,%edx
  803e9d:	f7 da                	neg    %edx
  803e9f:	83 c4 1c             	add    $0x1c,%esp
  803ea2:	5b                   	pop    %ebx
  803ea3:	5e                   	pop    %esi
  803ea4:	5f                   	pop    %edi
  803ea5:	5d                   	pop    %ebp
  803ea6:	c3                   	ret    
  803ea7:	90                   	nop
  803ea8:	0f bd f7             	bsr    %edi,%esi
  803eab:	83 f6 1f             	xor    $0x1f,%esi
  803eae:	75 6c                	jne    803f1c <__divdi3+0xf0>
  803eb0:	39 d7                	cmp    %edx,%edi
  803eb2:	72 0e                	jb     803ec2 <__divdi3+0x96>
  803eb4:	8b 7c 24 0c          	mov    0xc(%esp),%edi
  803eb8:	39 7c 24 08          	cmp    %edi,0x8(%esp)
  803ebc:	0f 87 ca 00 00 00    	ja     803f8c <__divdi3+0x160>
  803ec2:	b9 01 00 00 00       	mov    $0x1,%ecx
  803ec7:	eb c7                	jmp    803e90 <__divdi3+0x64>
  803ec9:	8d 76 00             	lea    0x0(%esi),%esi
  803ecc:	85 f6                	test   %esi,%esi
  803ece:	75 0b                	jne    803edb <__divdi3+0xaf>
  803ed0:	b8 01 00 00 00       	mov    $0x1,%eax
  803ed5:	31 d2                	xor    %edx,%edx
  803ed7:	f7 f6                	div    %esi
  803ed9:	89 c6                	mov    %eax,%esi
  803edb:	31 d2                	xor    %edx,%edx
  803edd:	89 d8                	mov    %ebx,%eax
  803edf:	f7 f6                	div    %esi
  803ee1:	89 c7                	mov    %eax,%edi
  803ee3:	89 c8                	mov    %ecx,%eax
  803ee5:	f7 f6                	div    %esi
  803ee7:	89 c1                	mov    %eax,%ecx
  803ee9:	89 fe                	mov    %edi,%esi
  803eeb:	eb a3                	jmp    803e90 <__divdi3+0x64>
  803eed:	8d 76 00             	lea    0x0(%esi),%esi
  803ef0:	f7 d5                	not    %ebp
  803ef2:	f7 de                	neg    %esi
  803ef4:	83 d7 00             	adc    $0x0,%edi
  803ef7:	f7 df                	neg    %edi
  803ef9:	89 34 24             	mov    %esi,(%esp)
  803efc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  803f00:	e9 59 ff ff ff       	jmp    803e5e <__divdi3+0x32>
  803f05:	8d 76 00             	lea    0x0(%esi),%esi
  803f08:	f7 d8                	neg    %eax
  803f0a:	83 d2 00             	adc    $0x0,%edx
  803f0d:	f7 da                	neg    %edx
  803f0f:	bd ff ff ff ff       	mov    $0xffffffff,%ebp
  803f14:	e9 36 ff ff ff       	jmp    803e4f <__divdi3+0x23>
  803f19:	8d 76 00             	lea    0x0(%esi),%esi
  803f1c:	b8 20 00 00 00       	mov    $0x20,%eax
  803f21:	29 f0                	sub    %esi,%eax
  803f23:	89 f1                	mov    %esi,%ecx
  803f25:	d3 e7                	shl    %cl,%edi
  803f27:	8b 54 24 08          	mov    0x8(%esp),%edx
  803f2b:	88 c1                	mov    %al,%cl
  803f2d:	d3 ea                	shr    %cl,%edx
  803f2f:	89 d1                	mov    %edx,%ecx
  803f31:	09 f9                	or     %edi,%ecx
  803f33:	89 0c 24             	mov    %ecx,(%esp)
  803f36:	8b 54 24 08          	mov    0x8(%esp),%edx
  803f3a:	89 f1                	mov    %esi,%ecx
  803f3c:	d3 e2                	shl    %cl,%edx
  803f3e:	89 54 24 08          	mov    %edx,0x8(%esp)
  803f42:	89 df                	mov    %ebx,%edi
  803f44:	88 c1                	mov    %al,%cl
  803f46:	d3 ef                	shr    %cl,%edi
  803f48:	89 f1                	mov    %esi,%ecx
  803f4a:	d3 e3                	shl    %cl,%ebx
  803f4c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  803f50:	88 c1                	mov    %al,%cl
  803f52:	d3 ea                	shr    %cl,%edx
  803f54:	09 d3                	or     %edx,%ebx
  803f56:	89 d8                	mov    %ebx,%eax
  803f58:	89 fa                	mov    %edi,%edx
  803f5a:	f7 34 24             	divl   (%esp)
  803f5d:	89 d1                	mov    %edx,%ecx
  803f5f:	89 c3                	mov    %eax,%ebx
  803f61:	f7 64 24 08          	mull   0x8(%esp)
  803f65:	39 d1                	cmp    %edx,%ecx
  803f67:	72 17                	jb     803f80 <__divdi3+0x154>
  803f69:	74 09                	je     803f74 <__divdi3+0x148>
  803f6b:	89 d9                	mov    %ebx,%ecx
  803f6d:	31 f6                	xor    %esi,%esi
  803f6f:	e9 1c ff ff ff       	jmp    803e90 <__divdi3+0x64>
  803f74:	8b 54 24 0c          	mov    0xc(%esp),%edx
  803f78:	89 f1                	mov    %esi,%ecx
  803f7a:	d3 e2                	shl    %cl,%edx
  803f7c:	39 c2                	cmp    %eax,%edx
  803f7e:	73 eb                	jae    803f6b <__divdi3+0x13f>
  803f80:	8d 4b ff             	lea    -0x1(%ebx),%ecx
  803f83:	31 f6                	xor    %esi,%esi
  803f85:	e9 06 ff ff ff       	jmp    803e90 <__divdi3+0x64>
  803f8a:	66 90                	xchg   %ax,%ax
  803f8c:	31 c9                	xor    %ecx,%ecx
  803f8e:	e9 fd fe ff ff       	jmp    803e90 <__divdi3+0x64>
  803f93:	90                   	nop

00803f94 <__udivdi3>:
  803f94:	55                   	push   %ebp
  803f95:	57                   	push   %edi
  803f96:	56                   	push   %esi
  803f97:	53                   	push   %ebx
  803f98:	83 ec 1c             	sub    $0x1c,%esp
  803f9b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803f9f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803fa3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803fa7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803fab:	89 ca                	mov    %ecx,%edx
  803fad:	89 f8                	mov    %edi,%eax
  803faf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803fb3:	85 f6                	test   %esi,%esi
  803fb5:	75 2d                	jne    803fe4 <__udivdi3+0x50>
  803fb7:	39 cf                	cmp    %ecx,%edi
  803fb9:	77 65                	ja     804020 <__udivdi3+0x8c>
  803fbb:	89 fd                	mov    %edi,%ebp
  803fbd:	85 ff                	test   %edi,%edi
  803fbf:	75 0b                	jne    803fcc <__udivdi3+0x38>
  803fc1:	b8 01 00 00 00       	mov    $0x1,%eax
  803fc6:	31 d2                	xor    %edx,%edx
  803fc8:	f7 f7                	div    %edi
  803fca:	89 c5                	mov    %eax,%ebp
  803fcc:	31 d2                	xor    %edx,%edx
  803fce:	89 c8                	mov    %ecx,%eax
  803fd0:	f7 f5                	div    %ebp
  803fd2:	89 c1                	mov    %eax,%ecx
  803fd4:	89 d8                	mov    %ebx,%eax
  803fd6:	f7 f5                	div    %ebp
  803fd8:	89 cf                	mov    %ecx,%edi
  803fda:	89 fa                	mov    %edi,%edx
  803fdc:	83 c4 1c             	add    $0x1c,%esp
  803fdf:	5b                   	pop    %ebx
  803fe0:	5e                   	pop    %esi
  803fe1:	5f                   	pop    %edi
  803fe2:	5d                   	pop    %ebp
  803fe3:	c3                   	ret    
  803fe4:	39 ce                	cmp    %ecx,%esi
  803fe6:	77 28                	ja     804010 <__udivdi3+0x7c>
  803fe8:	0f bd fe             	bsr    %esi,%edi
  803feb:	83 f7 1f             	xor    $0x1f,%edi
  803fee:	75 40                	jne    804030 <__udivdi3+0x9c>
  803ff0:	39 ce                	cmp    %ecx,%esi
  803ff2:	72 0a                	jb     803ffe <__udivdi3+0x6a>
  803ff4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803ff8:	0f 87 9e 00 00 00    	ja     80409c <__udivdi3+0x108>
  803ffe:	b8 01 00 00 00       	mov    $0x1,%eax
  804003:	89 fa                	mov    %edi,%edx
  804005:	83 c4 1c             	add    $0x1c,%esp
  804008:	5b                   	pop    %ebx
  804009:	5e                   	pop    %esi
  80400a:	5f                   	pop    %edi
  80400b:	5d                   	pop    %ebp
  80400c:	c3                   	ret    
  80400d:	8d 76 00             	lea    0x0(%esi),%esi
  804010:	31 ff                	xor    %edi,%edi
  804012:	31 c0                	xor    %eax,%eax
  804014:	89 fa                	mov    %edi,%edx
  804016:	83 c4 1c             	add    $0x1c,%esp
  804019:	5b                   	pop    %ebx
  80401a:	5e                   	pop    %esi
  80401b:	5f                   	pop    %edi
  80401c:	5d                   	pop    %ebp
  80401d:	c3                   	ret    
  80401e:	66 90                	xchg   %ax,%ax
  804020:	89 d8                	mov    %ebx,%eax
  804022:	f7 f7                	div    %edi
  804024:	31 ff                	xor    %edi,%edi
  804026:	89 fa                	mov    %edi,%edx
  804028:	83 c4 1c             	add    $0x1c,%esp
  80402b:	5b                   	pop    %ebx
  80402c:	5e                   	pop    %esi
  80402d:	5f                   	pop    %edi
  80402e:	5d                   	pop    %ebp
  80402f:	c3                   	ret    
  804030:	bd 20 00 00 00       	mov    $0x20,%ebp
  804035:	89 eb                	mov    %ebp,%ebx
  804037:	29 fb                	sub    %edi,%ebx
  804039:	89 f9                	mov    %edi,%ecx
  80403b:	d3 e6                	shl    %cl,%esi
  80403d:	89 c5                	mov    %eax,%ebp
  80403f:	88 d9                	mov    %bl,%cl
  804041:	d3 ed                	shr    %cl,%ebp
  804043:	89 e9                	mov    %ebp,%ecx
  804045:	09 f1                	or     %esi,%ecx
  804047:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80404b:	89 f9                	mov    %edi,%ecx
  80404d:	d3 e0                	shl    %cl,%eax
  80404f:	89 c5                	mov    %eax,%ebp
  804051:	89 d6                	mov    %edx,%esi
  804053:	88 d9                	mov    %bl,%cl
  804055:	d3 ee                	shr    %cl,%esi
  804057:	89 f9                	mov    %edi,%ecx
  804059:	d3 e2                	shl    %cl,%edx
  80405b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80405f:	88 d9                	mov    %bl,%cl
  804061:	d3 e8                	shr    %cl,%eax
  804063:	09 c2                	or     %eax,%edx
  804065:	89 d0                	mov    %edx,%eax
  804067:	89 f2                	mov    %esi,%edx
  804069:	f7 74 24 0c          	divl   0xc(%esp)
  80406d:	89 d6                	mov    %edx,%esi
  80406f:	89 c3                	mov    %eax,%ebx
  804071:	f7 e5                	mul    %ebp
  804073:	39 d6                	cmp    %edx,%esi
  804075:	72 19                	jb     804090 <__udivdi3+0xfc>
  804077:	74 0b                	je     804084 <__udivdi3+0xf0>
  804079:	89 d8                	mov    %ebx,%eax
  80407b:	31 ff                	xor    %edi,%edi
  80407d:	e9 58 ff ff ff       	jmp    803fda <__udivdi3+0x46>
  804082:	66 90                	xchg   %ax,%ax
  804084:	8b 54 24 08          	mov    0x8(%esp),%edx
  804088:	89 f9                	mov    %edi,%ecx
  80408a:	d3 e2                	shl    %cl,%edx
  80408c:	39 c2                	cmp    %eax,%edx
  80408e:	73 e9                	jae    804079 <__udivdi3+0xe5>
  804090:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804093:	31 ff                	xor    %edi,%edi
  804095:	e9 40 ff ff ff       	jmp    803fda <__udivdi3+0x46>
  80409a:	66 90                	xchg   %ax,%ax
  80409c:	31 c0                	xor    %eax,%eax
  80409e:	e9 37 ff ff ff       	jmp    803fda <__udivdi3+0x46>
  8040a3:	90                   	nop

008040a4 <__umoddi3>:
  8040a4:	55                   	push   %ebp
  8040a5:	57                   	push   %edi
  8040a6:	56                   	push   %esi
  8040a7:	53                   	push   %ebx
  8040a8:	83 ec 1c             	sub    $0x1c,%esp
  8040ab:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8040af:	8b 74 24 34          	mov    0x34(%esp),%esi
  8040b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8040b7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8040bb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8040bf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8040c3:	89 f3                	mov    %esi,%ebx
  8040c5:	89 fa                	mov    %edi,%edx
  8040c7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8040cb:	89 34 24             	mov    %esi,(%esp)
  8040ce:	85 c0                	test   %eax,%eax
  8040d0:	75 1a                	jne    8040ec <__umoddi3+0x48>
  8040d2:	39 f7                	cmp    %esi,%edi
  8040d4:	0f 86 a2 00 00 00    	jbe    80417c <__umoddi3+0xd8>
  8040da:	89 c8                	mov    %ecx,%eax
  8040dc:	89 f2                	mov    %esi,%edx
  8040de:	f7 f7                	div    %edi
  8040e0:	89 d0                	mov    %edx,%eax
  8040e2:	31 d2                	xor    %edx,%edx
  8040e4:	83 c4 1c             	add    $0x1c,%esp
  8040e7:	5b                   	pop    %ebx
  8040e8:	5e                   	pop    %esi
  8040e9:	5f                   	pop    %edi
  8040ea:	5d                   	pop    %ebp
  8040eb:	c3                   	ret    
  8040ec:	39 f0                	cmp    %esi,%eax
  8040ee:	0f 87 ac 00 00 00    	ja     8041a0 <__umoddi3+0xfc>
  8040f4:	0f bd e8             	bsr    %eax,%ebp
  8040f7:	83 f5 1f             	xor    $0x1f,%ebp
  8040fa:	0f 84 ac 00 00 00    	je     8041ac <__umoddi3+0x108>
  804100:	bf 20 00 00 00       	mov    $0x20,%edi
  804105:	29 ef                	sub    %ebp,%edi
  804107:	89 fe                	mov    %edi,%esi
  804109:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80410d:	89 e9                	mov    %ebp,%ecx
  80410f:	d3 e0                	shl    %cl,%eax
  804111:	89 d7                	mov    %edx,%edi
  804113:	89 f1                	mov    %esi,%ecx
  804115:	d3 ef                	shr    %cl,%edi
  804117:	09 c7                	or     %eax,%edi
  804119:	89 e9                	mov    %ebp,%ecx
  80411b:	d3 e2                	shl    %cl,%edx
  80411d:	89 14 24             	mov    %edx,(%esp)
  804120:	89 d8                	mov    %ebx,%eax
  804122:	d3 e0                	shl    %cl,%eax
  804124:	89 c2                	mov    %eax,%edx
  804126:	8b 44 24 08          	mov    0x8(%esp),%eax
  80412a:	d3 e0                	shl    %cl,%eax
  80412c:	89 44 24 04          	mov    %eax,0x4(%esp)
  804130:	8b 44 24 08          	mov    0x8(%esp),%eax
  804134:	89 f1                	mov    %esi,%ecx
  804136:	d3 e8                	shr    %cl,%eax
  804138:	09 d0                	or     %edx,%eax
  80413a:	d3 eb                	shr    %cl,%ebx
  80413c:	89 da                	mov    %ebx,%edx
  80413e:	f7 f7                	div    %edi
  804140:	89 d3                	mov    %edx,%ebx
  804142:	f7 24 24             	mull   (%esp)
  804145:	89 c6                	mov    %eax,%esi
  804147:	89 d1                	mov    %edx,%ecx
  804149:	39 d3                	cmp    %edx,%ebx
  80414b:	0f 82 87 00 00 00    	jb     8041d8 <__umoddi3+0x134>
  804151:	0f 84 91 00 00 00    	je     8041e8 <__umoddi3+0x144>
  804157:	8b 54 24 04          	mov    0x4(%esp),%edx
  80415b:	29 f2                	sub    %esi,%edx
  80415d:	19 cb                	sbb    %ecx,%ebx
  80415f:	89 d8                	mov    %ebx,%eax
  804161:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804165:	d3 e0                	shl    %cl,%eax
  804167:	89 e9                	mov    %ebp,%ecx
  804169:	d3 ea                	shr    %cl,%edx
  80416b:	09 d0                	or     %edx,%eax
  80416d:	89 e9                	mov    %ebp,%ecx
  80416f:	d3 eb                	shr    %cl,%ebx
  804171:	89 da                	mov    %ebx,%edx
  804173:	83 c4 1c             	add    $0x1c,%esp
  804176:	5b                   	pop    %ebx
  804177:	5e                   	pop    %esi
  804178:	5f                   	pop    %edi
  804179:	5d                   	pop    %ebp
  80417a:	c3                   	ret    
  80417b:	90                   	nop
  80417c:	89 fd                	mov    %edi,%ebp
  80417e:	85 ff                	test   %edi,%edi
  804180:	75 0b                	jne    80418d <__umoddi3+0xe9>
  804182:	b8 01 00 00 00       	mov    $0x1,%eax
  804187:	31 d2                	xor    %edx,%edx
  804189:	f7 f7                	div    %edi
  80418b:	89 c5                	mov    %eax,%ebp
  80418d:	89 f0                	mov    %esi,%eax
  80418f:	31 d2                	xor    %edx,%edx
  804191:	f7 f5                	div    %ebp
  804193:	89 c8                	mov    %ecx,%eax
  804195:	f7 f5                	div    %ebp
  804197:	89 d0                	mov    %edx,%eax
  804199:	e9 44 ff ff ff       	jmp    8040e2 <__umoddi3+0x3e>
  80419e:	66 90                	xchg   %ax,%ax
  8041a0:	89 c8                	mov    %ecx,%eax
  8041a2:	89 f2                	mov    %esi,%edx
  8041a4:	83 c4 1c             	add    $0x1c,%esp
  8041a7:	5b                   	pop    %ebx
  8041a8:	5e                   	pop    %esi
  8041a9:	5f                   	pop    %edi
  8041aa:	5d                   	pop    %ebp
  8041ab:	c3                   	ret    
  8041ac:	3b 04 24             	cmp    (%esp),%eax
  8041af:	72 06                	jb     8041b7 <__umoddi3+0x113>
  8041b1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8041b5:	77 0f                	ja     8041c6 <__umoddi3+0x122>
  8041b7:	89 f2                	mov    %esi,%edx
  8041b9:	29 f9                	sub    %edi,%ecx
  8041bb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8041bf:	89 14 24             	mov    %edx,(%esp)
  8041c2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8041c6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8041ca:	8b 14 24             	mov    (%esp),%edx
  8041cd:	83 c4 1c             	add    $0x1c,%esp
  8041d0:	5b                   	pop    %ebx
  8041d1:	5e                   	pop    %esi
  8041d2:	5f                   	pop    %edi
  8041d3:	5d                   	pop    %ebp
  8041d4:	c3                   	ret    
  8041d5:	8d 76 00             	lea    0x0(%esi),%esi
  8041d8:	2b 04 24             	sub    (%esp),%eax
  8041db:	19 fa                	sbb    %edi,%edx
  8041dd:	89 d1                	mov    %edx,%ecx
  8041df:	89 c6                	mov    %eax,%esi
  8041e1:	e9 71 ff ff ff       	jmp    804157 <__umoddi3+0xb3>
  8041e6:	66 90                	xchg   %ax,%ax
  8041e8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8041ec:	72 ea                	jb     8041d8 <__umoddi3+0x134>
  8041ee:	89 d9                	mov    %ebx,%ecx
  8041f0:	e9 62 ff ff ff       	jmp    804157 <__umoddi3+0xb3>
