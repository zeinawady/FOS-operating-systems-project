
obj/user/matrix_operations:     file format elf32-i386


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
  800031:	e8 d8 09 00 00       	call   800a0e <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
int64** MatrixMultiply(int **M1, int **M2, int NumOfElements);
int64** MatrixAddition(int **M1, int **M2, int NumOfElements);
int64** MatrixSubtraction(int **M1, int **M2, int NumOfElements);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	81 ec 24 01 00 00    	sub    $0x124,%esp
	char Line[255] ;
	char Chose ;
	int val =0 ;
  800042:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int NumOfElements = 3;
  800049:	c7 45 e4 03 00 00 00 	movl   $0x3,-0x1c(%ebp)
	do
	{
		val = 0;
  800050:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		NumOfElements = 3;
  800057:	c7 45 e4 03 00 00 00 	movl   $0x3,-0x1c(%ebp)
		//2012: lock the interrupt
		sys_lock_cons();
  80005e:	e8 9e 22 00 00       	call   802301 <sys_lock_cons>
		cprintf("\n");
  800063:	83 ec 0c             	sub    $0xc,%esp
  800066:	68 20 40 80 00       	push   $0x804020
  80006b:	e8 b7 0b 00 00       	call   800c27 <cprintf>
  800070:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800073:	83 ec 0c             	sub    $0xc,%esp
  800076:	68 24 40 80 00       	push   $0x804024
  80007b:	e8 a7 0b 00 00       	call   800c27 <cprintf>
  800080:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   MATRIX MULTIPLICATION    !!!\n");
  800083:	83 ec 0c             	sub    $0xc,%esp
  800086:	68 48 40 80 00       	push   $0x804048
  80008b:	e8 97 0b 00 00       	call   800c27 <cprintf>
  800090:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800093:	83 ec 0c             	sub    $0xc,%esp
  800096:	68 24 40 80 00       	push   $0x804024
  80009b:	e8 87 0b 00 00       	call   800c27 <cprintf>
  8000a0:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  8000a3:	83 ec 0c             	sub    $0xc,%esp
  8000a6:	68 20 40 80 00       	push   $0x804020
  8000ab:	e8 77 0b 00 00       	call   800c27 <cprintf>
  8000b0:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  8000b3:	83 ec 08             	sub    $0x8,%esp
  8000b6:	8d 85 d9 fe ff ff    	lea    -0x127(%ebp),%eax
  8000bc:	50                   	push   %eax
  8000bd:	68 6c 40 80 00       	push   $0x80406c
  8000c2:	e8 f4 11 00 00       	call   8012bb <readline>
  8000c7:	83 c4 10             	add    $0x10,%esp
		NumOfElements = strtol(Line, NULL, 10) ;
  8000ca:	83 ec 04             	sub    $0x4,%esp
  8000cd:	6a 0a                	push   $0xa
  8000cf:	6a 00                	push   $0x0
  8000d1:	8d 85 d9 fe ff ff    	lea    -0x127(%ebp),%eax
  8000d7:	50                   	push   %eax
  8000d8:	e8 46 17 00 00       	call   801823 <strtol>
  8000dd:	83 c4 10             	add    $0x10,%esp
  8000e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		cprintf("Chose the initialization method:\n") ;
  8000e3:	83 ec 0c             	sub    $0xc,%esp
  8000e6:	68 8c 40 80 00       	push   $0x80408c
  8000eb:	e8 37 0b 00 00       	call   800c27 <cprintf>
  8000f0:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000f3:	83 ec 0c             	sub    $0xc,%esp
  8000f6:	68 ae 40 80 00       	push   $0x8040ae
  8000fb:	e8 27 0b 00 00       	call   800c27 <cprintf>
  800100:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Identical\n") ;
  800103:	83 ec 0c             	sub    $0xc,%esp
  800106:	68 bc 40 80 00       	push   $0x8040bc
  80010b:	e8 17 0b 00 00       	call   800c27 <cprintf>
  800110:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  800113:	83 ec 0c             	sub    $0xc,%esp
  800116:	68 ca 40 80 00       	push   $0x8040ca
  80011b:	e8 07 0b 00 00       	call   800c27 <cprintf>
  800120:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800123:	83 ec 0c             	sub    $0xc,%esp
  800126:	68 da 40 80 00       	push   $0x8040da
  80012b:	e8 f7 0a 00 00       	call   800c27 <cprintf>
  800130:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  800133:	e8 b9 08 00 00       	call   8009f1 <getchar>
  800138:	88 45 e3             	mov    %al,-0x1d(%ebp)
			cputchar(Chose);
  80013b:	0f be 45 e3          	movsbl -0x1d(%ebp),%eax
  80013f:	83 ec 0c             	sub    $0xc,%esp
  800142:	50                   	push   %eax
  800143:	e8 8a 08 00 00       	call   8009d2 <cputchar>
  800148:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  80014b:	83 ec 0c             	sub    $0xc,%esp
  80014e:	6a 0a                	push   $0xa
  800150:	e8 7d 08 00 00       	call   8009d2 <cputchar>
  800155:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800158:	80 7d e3 61          	cmpb   $0x61,-0x1d(%ebp)
  80015c:	74 0c                	je     80016a <_main+0x132>
  80015e:	80 7d e3 62          	cmpb   $0x62,-0x1d(%ebp)
  800162:	74 06                	je     80016a <_main+0x132>
  800164:	80 7d e3 63          	cmpb   $0x63,-0x1d(%ebp)
  800168:	75 b9                	jne    800123 <_main+0xeb>

		if (Chose == 'b')
  80016a:	80 7d e3 62          	cmpb   $0x62,-0x1d(%ebp)
  80016e:	75 30                	jne    8001a0 <_main+0x168>
		{
			readline("Enter the value to be initialized: ", Line);
  800170:	83 ec 08             	sub    $0x8,%esp
  800173:	8d 85 d9 fe ff ff    	lea    -0x127(%ebp),%eax
  800179:	50                   	push   %eax
  80017a:	68 e4 40 80 00       	push   $0x8040e4
  80017f:	e8 37 11 00 00       	call   8012bb <readline>
  800184:	83 c4 10             	add    $0x10,%esp
			val = strtol(Line, NULL, 10) ;
  800187:	83 ec 04             	sub    $0x4,%esp
  80018a:	6a 0a                	push   $0xa
  80018c:	6a 00                	push   $0x0
  80018e:	8d 85 d9 fe ff ff    	lea    -0x127(%ebp),%eax
  800194:	50                   	push   %eax
  800195:	e8 89 16 00 00       	call   801823 <strtol>
  80019a:	83 c4 10             	add    $0x10,%esp
  80019d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
		//2012: lock the interrupt
		sys_unlock_cons();
  8001a0:	e8 76 21 00 00       	call   80231b <sys_unlock_cons>

		int **M1 = malloc(sizeof(int) * NumOfElements) ;
  8001a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001a8:	c1 e0 02             	shl    $0x2,%eax
  8001ab:	83 ec 0c             	sub    $0xc,%esp
  8001ae:	50                   	push   %eax
  8001af:	e8 2b 1a 00 00       	call   801bdf <malloc>
  8001b4:	83 c4 10             	add    $0x10,%esp
  8001b7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		int **M2 = malloc(sizeof(int) * NumOfElements) ;
  8001ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001bd:	c1 e0 02             	shl    $0x2,%eax
  8001c0:	83 ec 0c             	sub    $0xc,%esp
  8001c3:	50                   	push   %eax
  8001c4:	e8 16 1a 00 00       	call   801bdf <malloc>
  8001c9:	83 c4 10             	add    $0x10,%esp
  8001cc:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (int i = 0; i < NumOfElements; ++i)
  8001cf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001d6:	eb 4b                	jmp    800223 <_main+0x1eb>
		{
			M1[i] = malloc(sizeof(int) * NumOfElements) ;
  8001d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001db:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001e2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001e5:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
  8001e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001eb:	c1 e0 02             	shl    $0x2,%eax
  8001ee:	83 ec 0c             	sub    $0xc,%esp
  8001f1:	50                   	push   %eax
  8001f2:	e8 e8 19 00 00       	call   801bdf <malloc>
  8001f7:	83 c4 10             	add    $0x10,%esp
  8001fa:	89 03                	mov    %eax,(%ebx)
			M2[i] = malloc(sizeof(int) * NumOfElements) ;
  8001fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001ff:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800206:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800209:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
  80020c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80020f:	c1 e0 02             	shl    $0x2,%eax
  800212:	83 ec 0c             	sub    $0xc,%esp
  800215:	50                   	push   %eax
  800216:	e8 c4 19 00 00       	call   801bdf <malloc>
  80021b:	83 c4 10             	add    $0x10,%esp
  80021e:	89 03                	mov    %eax,(%ebx)
		sys_unlock_cons();

		int **M1 = malloc(sizeof(int) * NumOfElements) ;
		int **M2 = malloc(sizeof(int) * NumOfElements) ;

		for (int i = 0; i < NumOfElements; ++i)
  800220:	ff 45 f0             	incl   -0x10(%ebp)
  800223:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800226:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800229:	7c ad                	jl     8001d8 <_main+0x1a0>
			M1[i] = malloc(sizeof(int) * NumOfElements) ;
			M2[i] = malloc(sizeof(int) * NumOfElements) ;
		}

		int  i ;
		switch (Chose)
  80022b:	0f be 45 e3          	movsbl -0x1d(%ebp),%eax
  80022f:	83 f8 62             	cmp    $0x62,%eax
  800232:	74 2e                	je     800262 <_main+0x22a>
  800234:	83 f8 63             	cmp    $0x63,%eax
  800237:	74 53                	je     80028c <_main+0x254>
  800239:	83 f8 61             	cmp    $0x61,%eax
  80023c:	75 72                	jne    8002b0 <_main+0x278>
		{
		case 'a':
			InitializeAscending(M1, NumOfElements);
  80023e:	83 ec 08             	sub    $0x8,%esp
  800241:	ff 75 e4             	pushl  -0x1c(%ebp)
  800244:	ff 75 dc             	pushl  -0x24(%ebp)
  800247:	e8 9b 05 00 00       	call   8007e7 <InitializeAscending>
  80024c:	83 c4 10             	add    $0x10,%esp
			InitializeAscending(M2, NumOfElements);
  80024f:	83 ec 08             	sub    $0x8,%esp
  800252:	ff 75 e4             	pushl  -0x1c(%ebp)
  800255:	ff 75 d8             	pushl  -0x28(%ebp)
  800258:	e8 8a 05 00 00       	call   8007e7 <InitializeAscending>
  80025d:	83 c4 10             	add    $0x10,%esp
			break ;
  800260:	eb 70                	jmp    8002d2 <_main+0x29a>
		case 'b':
			InitializeIdentical(M1, NumOfElements, val);
  800262:	83 ec 04             	sub    $0x4,%esp
  800265:	ff 75 f4             	pushl  -0xc(%ebp)
  800268:	ff 75 e4             	pushl  -0x1c(%ebp)
  80026b:	ff 75 dc             	pushl  -0x24(%ebp)
  80026e:	e8 c3 05 00 00       	call   800836 <InitializeIdentical>
  800273:	83 c4 10             	add    $0x10,%esp
			InitializeIdentical(M2, NumOfElements, val);
  800276:	83 ec 04             	sub    $0x4,%esp
  800279:	ff 75 f4             	pushl  -0xc(%ebp)
  80027c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80027f:	ff 75 d8             	pushl  -0x28(%ebp)
  800282:	e8 af 05 00 00       	call   800836 <InitializeIdentical>
  800287:	83 c4 10             	add    $0x10,%esp
			break ;
  80028a:	eb 46                	jmp    8002d2 <_main+0x29a>
		case 'c':
			InitializeSemiRandom(M1, NumOfElements);
  80028c:	83 ec 08             	sub    $0x8,%esp
  80028f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800292:	ff 75 dc             	pushl  -0x24(%ebp)
  800295:	e8 eb 05 00 00       	call   800885 <InitializeSemiRandom>
  80029a:	83 c4 10             	add    $0x10,%esp
			InitializeSemiRandom(M2, NumOfElements);
  80029d:	83 ec 08             	sub    $0x8,%esp
  8002a0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a3:	ff 75 d8             	pushl  -0x28(%ebp)
  8002a6:	e8 da 05 00 00       	call   800885 <InitializeSemiRandom>
  8002ab:	83 c4 10             	add    $0x10,%esp
			//PrintElements(M1, NumOfElements);
			break ;
  8002ae:	eb 22                	jmp    8002d2 <_main+0x29a>
		default:
			InitializeSemiRandom(M1, NumOfElements);
  8002b0:	83 ec 08             	sub    $0x8,%esp
  8002b3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002b6:	ff 75 dc             	pushl  -0x24(%ebp)
  8002b9:	e8 c7 05 00 00       	call   800885 <InitializeSemiRandom>
  8002be:	83 c4 10             	add    $0x10,%esp
			InitializeSemiRandom(M2, NumOfElements);
  8002c1:	83 ec 08             	sub    $0x8,%esp
  8002c4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002c7:	ff 75 d8             	pushl  -0x28(%ebp)
  8002ca:	e8 b6 05 00 00       	call   800885 <InitializeSemiRandom>
  8002cf:	83 c4 10             	add    $0x10,%esp
		}

		sys_lock_cons();
  8002d2:	e8 2a 20 00 00       	call   802301 <sys_lock_cons>
		cprintf("Chose the desired operation:\n") ;
  8002d7:	83 ec 0c             	sub    $0xc,%esp
  8002da:	68 08 41 80 00       	push   $0x804108
  8002df:	e8 43 09 00 00       	call   800c27 <cprintf>
  8002e4:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Addition       (+)\n") ;
  8002e7:	83 ec 0c             	sub    $0xc,%esp
  8002ea:	68 26 41 80 00       	push   $0x804126
  8002ef:	e8 33 09 00 00       	call   800c27 <cprintf>
  8002f4:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Subtraction    (-)\n") ;
  8002f7:	83 ec 0c             	sub    $0xc,%esp
  8002fa:	68 3d 41 80 00       	push   $0x80413d
  8002ff:	e8 23 09 00 00       	call   800c27 <cprintf>
  800304:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Multiplication (x)\n");
  800307:	83 ec 0c             	sub    $0xc,%esp
  80030a:	68 54 41 80 00       	push   $0x804154
  80030f:	e8 13 09 00 00       	call   800c27 <cprintf>
  800314:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800317:	83 ec 0c             	sub    $0xc,%esp
  80031a:	68 da 40 80 00       	push   $0x8040da
  80031f:	e8 03 09 00 00       	call   800c27 <cprintf>
  800324:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  800327:	e8 c5 06 00 00       	call   8009f1 <getchar>
  80032c:	88 45 e3             	mov    %al,-0x1d(%ebp)
			cputchar(Chose);
  80032f:	0f be 45 e3          	movsbl -0x1d(%ebp),%eax
  800333:	83 ec 0c             	sub    $0xc,%esp
  800336:	50                   	push   %eax
  800337:	e8 96 06 00 00       	call   8009d2 <cputchar>
  80033c:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  80033f:	83 ec 0c             	sub    $0xc,%esp
  800342:	6a 0a                	push   $0xa
  800344:	e8 89 06 00 00       	call   8009d2 <cputchar>
  800349:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  80034c:	80 7d e3 61          	cmpb   $0x61,-0x1d(%ebp)
  800350:	74 0c                	je     80035e <_main+0x326>
  800352:	80 7d e3 62          	cmpb   $0x62,-0x1d(%ebp)
  800356:	74 06                	je     80035e <_main+0x326>
  800358:	80 7d e3 63          	cmpb   $0x63,-0x1d(%ebp)
  80035c:	75 b9                	jne    800317 <_main+0x2df>
		sys_unlock_cons();
  80035e:	e8 b8 1f 00 00       	call   80231b <sys_unlock_cons>


		int64** Res = NULL ;
  800363:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		switch (Chose)
  80036a:	0f be 45 e3          	movsbl -0x1d(%ebp),%eax
  80036e:	83 f8 62             	cmp    $0x62,%eax
  800371:	74 23                	je     800396 <_main+0x35e>
  800373:	83 f8 63             	cmp    $0x63,%eax
  800376:	74 37                	je     8003af <_main+0x377>
  800378:	83 f8 61             	cmp    $0x61,%eax
  80037b:	75 4b                	jne    8003c8 <_main+0x390>
		{
		case 'a':
			Res = MatrixAddition(M1, M2, NumOfElements);
  80037d:	83 ec 04             	sub    $0x4,%esp
  800380:	ff 75 e4             	pushl  -0x1c(%ebp)
  800383:	ff 75 d8             	pushl  -0x28(%ebp)
  800386:	ff 75 dc             	pushl  -0x24(%ebp)
  800389:	e8 9f 02 00 00       	call   80062d <MatrixAddition>
  80038e:	83 c4 10             	add    $0x10,%esp
  800391:	89 45 ec             	mov    %eax,-0x14(%ebp)
			//PrintElements64(Res, NumOfElements);
			break ;
  800394:	eb 49                	jmp    8003df <_main+0x3a7>
		case 'b':
			Res = MatrixSubtraction(M1, M2, NumOfElements);
  800396:	83 ec 04             	sub    $0x4,%esp
  800399:	ff 75 e4             	pushl  -0x1c(%ebp)
  80039c:	ff 75 d8             	pushl  -0x28(%ebp)
  80039f:	ff 75 dc             	pushl  -0x24(%ebp)
  8003a2:	e8 62 03 00 00       	call   800709 <MatrixSubtraction>
  8003a7:	83 c4 10             	add    $0x10,%esp
  8003aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
			//PrintElements64(Res, NumOfElements);
			break ;
  8003ad:	eb 30                	jmp    8003df <_main+0x3a7>
		case 'c':
			Res = MatrixMultiply(M1, M2, NumOfElements);
  8003af:	83 ec 04             	sub    $0x4,%esp
  8003b2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003b5:	ff 75 d8             	pushl  -0x28(%ebp)
  8003b8:	ff 75 dc             	pushl  -0x24(%ebp)
  8003bb:	e8 1d 01 00 00       	call   8004dd <MatrixMultiply>
  8003c0:	83 c4 10             	add    $0x10,%esp
  8003c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
			//PrintElements64(Res, NumOfElements);
			break ;
  8003c6:	eb 17                	jmp    8003df <_main+0x3a7>
		default:
			Res = MatrixAddition(M1, M2, NumOfElements);
  8003c8:	83 ec 04             	sub    $0x4,%esp
  8003cb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003ce:	ff 75 d8             	pushl  -0x28(%ebp)
  8003d1:	ff 75 dc             	pushl  -0x24(%ebp)
  8003d4:	e8 54 02 00 00       	call   80062d <MatrixAddition>
  8003d9:	83 c4 10             	add    $0x10,%esp
  8003dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
			//PrintElements64(Res, NumOfElements);
		}


		sys_lock_cons();
  8003df:	e8 1d 1f 00 00       	call   802301 <sys_lock_cons>
		cprintf("Operation is COMPLETED.\n");
  8003e4:	83 ec 0c             	sub    $0xc,%esp
  8003e7:	68 6b 41 80 00       	push   $0x80416b
  8003ec:	e8 36 08 00 00       	call   800c27 <cprintf>
  8003f1:	83 c4 10             	add    $0x10,%esp
		sys_unlock_cons();
  8003f4:	e8 22 1f 00 00       	call   80231b <sys_unlock_cons>

		for (int i = 0; i < NumOfElements; ++i)
  8003f9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800400:	eb 5a                	jmp    80045c <_main+0x424>
		{
			free(M1[i]);
  800402:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800405:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80040c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80040f:	01 d0                	add    %edx,%eax
  800411:	8b 00                	mov    (%eax),%eax
  800413:	83 ec 0c             	sub    $0xc,%esp
  800416:	50                   	push   %eax
  800417:	e8 79 19 00 00       	call   801d95 <free>
  80041c:	83 c4 10             	add    $0x10,%esp
			free(M2[i]);
  80041f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800422:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800429:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80042c:	01 d0                	add    %edx,%eax
  80042e:	8b 00                	mov    (%eax),%eax
  800430:	83 ec 0c             	sub    $0xc,%esp
  800433:	50                   	push   %eax
  800434:	e8 5c 19 00 00       	call   801d95 <free>
  800439:	83 c4 10             	add    $0x10,%esp
			free(Res[i]);
  80043c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80043f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800446:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800449:	01 d0                	add    %edx,%eax
  80044b:	8b 00                	mov    (%eax),%eax
  80044d:	83 ec 0c             	sub    $0xc,%esp
  800450:	50                   	push   %eax
  800451:	e8 3f 19 00 00       	call   801d95 <free>
  800456:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
		cprintf("Operation is COMPLETED.\n");
		sys_unlock_cons();

		for (int i = 0; i < NumOfElements; ++i)
  800459:	ff 45 e8             	incl   -0x18(%ebp)
  80045c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80045f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800462:	7c 9e                	jl     800402 <_main+0x3ca>
		{
			free(M1[i]);
			free(M2[i]);
			free(Res[i]);
		}
		free(M1) ;
  800464:	83 ec 0c             	sub    $0xc,%esp
  800467:	ff 75 dc             	pushl  -0x24(%ebp)
  80046a:	e8 26 19 00 00       	call   801d95 <free>
  80046f:	83 c4 10             	add    $0x10,%esp
		free(M2) ;
  800472:	83 ec 0c             	sub    $0xc,%esp
  800475:	ff 75 d8             	pushl  -0x28(%ebp)
  800478:	e8 18 19 00 00       	call   801d95 <free>
  80047d:	83 c4 10             	add    $0x10,%esp
		free(Res) ;
  800480:	83 ec 0c             	sub    $0xc,%esp
  800483:	ff 75 ec             	pushl  -0x14(%ebp)
  800486:	e8 0a 19 00 00       	call   801d95 <free>
  80048b:	83 c4 10             	add    $0x10,%esp


		sys_lock_cons();
  80048e:	e8 6e 1e 00 00       	call   802301 <sys_lock_cons>
		cprintf("Do you want to repeat (y/n): ") ;
  800493:	83 ec 0c             	sub    $0xc,%esp
  800496:	68 84 41 80 00       	push   $0x804184
  80049b:	e8 87 07 00 00       	call   800c27 <cprintf>
  8004a0:	83 c4 10             	add    $0x10,%esp
		Chose = getchar() ;
  8004a3:	e8 49 05 00 00       	call   8009f1 <getchar>
  8004a8:	88 45 e3             	mov    %al,-0x1d(%ebp)
		cputchar(Chose);
  8004ab:	0f be 45 e3          	movsbl -0x1d(%ebp),%eax
  8004af:	83 ec 0c             	sub    $0xc,%esp
  8004b2:	50                   	push   %eax
  8004b3:	e8 1a 05 00 00       	call   8009d2 <cputchar>
  8004b8:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  8004bb:	83 ec 0c             	sub    $0xc,%esp
  8004be:	6a 0a                	push   $0xa
  8004c0:	e8 0d 05 00 00       	call   8009d2 <cputchar>
  8004c5:	83 c4 10             	add    $0x10,%esp
		sys_unlock_cons();
  8004c8:	e8 4e 1e 00 00       	call   80231b <sys_unlock_cons>

	} while (Chose == 'y');
  8004cd:	80 7d e3 79          	cmpb   $0x79,-0x1d(%ebp)
  8004d1:	0f 84 79 fb ff ff    	je     800050 <_main+0x18>

}
  8004d7:	90                   	nop
  8004d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004db:	c9                   	leave  
  8004dc:	c3                   	ret    

008004dd <MatrixMultiply>:

///MATRIX MULTIPLICATION
int64** MatrixMultiply(int **M1, int **M2, int NumOfElements)
{
  8004dd:	55                   	push   %ebp
  8004de:	89 e5                	mov    %esp,%ebp
  8004e0:	57                   	push   %edi
  8004e1:	56                   	push   %esi
  8004e2:	53                   	push   %ebx
  8004e3:	83 ec 2c             	sub    $0x2c,%esp
	int64 **Res = malloc(sizeof(int64) * NumOfElements) ;
  8004e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8004e9:	c1 e0 03             	shl    $0x3,%eax
  8004ec:	83 ec 0c             	sub    $0xc,%esp
  8004ef:	50                   	push   %eax
  8004f0:	e8 ea 16 00 00       	call   801bdf <malloc>
  8004f5:	83 c4 10             	add    $0x10,%esp
  8004f8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	for (int i = 0; i < NumOfElements; ++i)
  8004fb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800502:	eb 27                	jmp    80052b <MatrixMultiply+0x4e>
	{
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
  800504:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800507:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80050e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800511:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
  800514:	8b 45 10             	mov    0x10(%ebp),%eax
  800517:	c1 e0 03             	shl    $0x3,%eax
  80051a:	83 ec 0c             	sub    $0xc,%esp
  80051d:	50                   	push   %eax
  80051e:	e8 bc 16 00 00       	call   801bdf <malloc>
  800523:	83 c4 10             	add    $0x10,%esp
  800526:	89 03                	mov    %eax,(%ebx)

///MATRIX MULTIPLICATION
int64** MatrixMultiply(int **M1, int **M2, int NumOfElements)
{
	int64 **Res = malloc(sizeof(int64) * NumOfElements) ;
	for (int i = 0; i < NumOfElements; ++i)
  800528:	ff 45 e4             	incl   -0x1c(%ebp)
  80052b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80052e:	3b 45 10             	cmp    0x10(%ebp),%eax
  800531:	7c d1                	jl     800504 <MatrixMultiply+0x27>
	{
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
	}

	for (int i = 0; i < NumOfElements; ++i)
  800533:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80053a:	e9 d7 00 00 00       	jmp    800616 <MatrixMultiply+0x139>
	{
		for (int j = 0; j < NumOfElements; ++j)
  80053f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800546:	e9 bc 00 00 00       	jmp    800607 <MatrixMultiply+0x12a>
		{
			Res[i][j] = 0 ;
  80054b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80054e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800555:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800558:	01 d0                	add    %edx,%eax
  80055a:	8b 00                	mov    (%eax),%eax
  80055c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80055f:	c1 e2 03             	shl    $0x3,%edx
  800562:	01 d0                	add    %edx,%eax
  800564:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80056a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
			for (int k = 0; k < NumOfElements; ++k)
  800571:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800578:	eb 7e                	jmp    8005f8 <MatrixMultiply+0x11b>
			{
				Res[i][j] += M1[i][k] * M2[k][j] ;
  80057a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80057d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800584:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800587:	01 d0                	add    %edx,%eax
  800589:	8b 00                	mov    (%eax),%eax
  80058b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80058e:	c1 e2 03             	shl    $0x3,%edx
  800591:	8d 34 10             	lea    (%eax,%edx,1),%esi
  800594:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800597:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80059e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005a1:	01 d0                	add    %edx,%eax
  8005a3:	8b 00                	mov    (%eax),%eax
  8005a5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8005a8:	c1 e2 03             	shl    $0x3,%edx
  8005ab:	01 d0                	add    %edx,%eax
  8005ad:	8b 08                	mov    (%eax),%ecx
  8005af:	8b 58 04             	mov    0x4(%eax),%ebx
  8005b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bf:	01 d0                	add    %edx,%eax
  8005c1:	8b 00                	mov    (%eax),%eax
  8005c3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005c6:	c1 e2 02             	shl    $0x2,%edx
  8005c9:	01 d0                	add    %edx,%eax
  8005cb:	8b 10                	mov    (%eax),%edx
  8005cd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005d0:	8d 3c 85 00 00 00 00 	lea    0x0(,%eax,4),%edi
  8005d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005da:	01 f8                	add    %edi,%eax
  8005dc:	8b 00                	mov    (%eax),%eax
  8005de:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8005e1:	c1 e7 02             	shl    $0x2,%edi
  8005e4:	01 f8                	add    %edi,%eax
  8005e6:	8b 00                	mov    (%eax),%eax
  8005e8:	0f af c2             	imul   %edx,%eax
  8005eb:	99                   	cltd   
  8005ec:	01 c8                	add    %ecx,%eax
  8005ee:	11 da                	adc    %ebx,%edx
  8005f0:	89 06                	mov    %eax,(%esi)
  8005f2:	89 56 04             	mov    %edx,0x4(%esi)
	for (int i = 0; i < NumOfElements; ++i)
	{
		for (int j = 0; j < NumOfElements; ++j)
		{
			Res[i][j] = 0 ;
			for (int k = 0; k < NumOfElements; ++k)
  8005f5:	ff 45 d8             	incl   -0x28(%ebp)
  8005f8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005fb:	3b 45 10             	cmp    0x10(%ebp),%eax
  8005fe:	0f 8c 76 ff ff ff    	jl     80057a <MatrixMultiply+0x9d>
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
	}

	for (int i = 0; i < NumOfElements; ++i)
	{
		for (int j = 0; j < NumOfElements; ++j)
  800604:	ff 45 dc             	incl   -0x24(%ebp)
  800607:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80060a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80060d:	0f 8c 38 ff ff ff    	jl     80054b <MatrixMultiply+0x6e>
	for (int i = 0; i < NumOfElements; ++i)
	{
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
	}

	for (int i = 0; i < NumOfElements; ++i)
  800613:	ff 45 e0             	incl   -0x20(%ebp)
  800616:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800619:	3b 45 10             	cmp    0x10(%ebp),%eax
  80061c:	0f 8c 1d ff ff ff    	jl     80053f <MatrixMultiply+0x62>
			{
				Res[i][j] += M1[i][k] * M2[k][j] ;
			}
		}
	}
	return Res;
  800622:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
  800625:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800628:	5b                   	pop    %ebx
  800629:	5e                   	pop    %esi
  80062a:	5f                   	pop    %edi
  80062b:	5d                   	pop    %ebp
  80062c:	c3                   	ret    

0080062d <MatrixAddition>:

///MATRIX ADDITION
int64** MatrixAddition(int **M1, int **M2, int NumOfElements)
{
  80062d:	55                   	push   %ebp
  80062e:	89 e5                	mov    %esp,%ebp
  800630:	53                   	push   %ebx
  800631:	83 ec 14             	sub    $0x14,%esp
	int64 **Res = malloc(sizeof(int64) * NumOfElements) ;
  800634:	8b 45 10             	mov    0x10(%ebp),%eax
  800637:	c1 e0 03             	shl    $0x3,%eax
  80063a:	83 ec 0c             	sub    $0xc,%esp
  80063d:	50                   	push   %eax
  80063e:	e8 9c 15 00 00       	call   801bdf <malloc>
  800643:	83 c4 10             	add    $0x10,%esp
  800646:	89 45 e8             	mov    %eax,-0x18(%ebp)
	for (int i = 0; i < NumOfElements; ++i)
  800649:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800650:	eb 27                	jmp    800679 <MatrixAddition+0x4c>
	{
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
  800652:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800655:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80065c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80065f:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
  800662:	8b 45 10             	mov    0x10(%ebp),%eax
  800665:	c1 e0 03             	shl    $0x3,%eax
  800668:	83 ec 0c             	sub    $0xc,%esp
  80066b:	50                   	push   %eax
  80066c:	e8 6e 15 00 00       	call   801bdf <malloc>
  800671:	83 c4 10             	add    $0x10,%esp
  800674:	89 03                	mov    %eax,(%ebx)

///MATRIX ADDITION
int64** MatrixAddition(int **M1, int **M2, int NumOfElements)
{
	int64 **Res = malloc(sizeof(int64) * NumOfElements) ;
	for (int i = 0; i < NumOfElements; ++i)
  800676:	ff 45 f4             	incl   -0xc(%ebp)
  800679:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80067c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80067f:	7c d1                	jl     800652 <MatrixAddition+0x25>
	{
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
	}

	for (int i = 0; i < NumOfElements; ++i)
  800681:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800688:	eb 6f                	jmp    8006f9 <MatrixAddition+0xcc>
	{
		for (int j = 0; j < NumOfElements; ++j)
  80068a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800691:	eb 5b                	jmp    8006ee <MatrixAddition+0xc1>
		{
			Res[i][j] = M1[i][j] + M2[i][j] ;
  800693:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800696:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80069d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006a0:	01 d0                	add    %edx,%eax
  8006a2:	8b 00                	mov    (%eax),%eax
  8006a4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8006a7:	c1 e2 03             	shl    $0x3,%edx
  8006aa:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8006ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006b0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ba:	01 d0                	add    %edx,%eax
  8006bc:	8b 00                	mov    (%eax),%eax
  8006be:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8006c1:	c1 e2 02             	shl    $0x2,%edx
  8006c4:	01 d0                	add    %edx,%eax
  8006c6:	8b 10                	mov    (%eax),%edx
  8006c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006cb:	8d 1c 85 00 00 00 00 	lea    0x0(,%eax,4),%ebx
  8006d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d5:	01 d8                	add    %ebx,%eax
  8006d7:	8b 00                	mov    (%eax),%eax
  8006d9:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8006dc:	c1 e3 02             	shl    $0x2,%ebx
  8006df:	01 d8                	add    %ebx,%eax
  8006e1:	8b 00                	mov    (%eax),%eax
  8006e3:	01 d0                	add    %edx,%eax
  8006e5:	99                   	cltd   
  8006e6:	89 01                	mov    %eax,(%ecx)
  8006e8:	89 51 04             	mov    %edx,0x4(%ecx)
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
	}

	for (int i = 0; i < NumOfElements; ++i)
	{
		for (int j = 0; j < NumOfElements; ++j)
  8006eb:	ff 45 ec             	incl   -0x14(%ebp)
  8006ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006f1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8006f4:	7c 9d                	jl     800693 <MatrixAddition+0x66>
	for (int i = 0; i < NumOfElements; ++i)
	{
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
	}

	for (int i = 0; i < NumOfElements; ++i)
  8006f6:	ff 45 f0             	incl   -0x10(%ebp)
  8006f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006fc:	3b 45 10             	cmp    0x10(%ebp),%eax
  8006ff:	7c 89                	jl     80068a <MatrixAddition+0x5d>
		for (int j = 0; j < NumOfElements; ++j)
		{
			Res[i][j] = M1[i][j] + M2[i][j] ;
		}
	}
	return Res;
  800701:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  800704:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800707:	c9                   	leave  
  800708:	c3                   	ret    

00800709 <MatrixSubtraction>:

///MATRIX SUBTRACTION
int64** MatrixSubtraction(int **M1, int **M2, int NumOfElements)
{
  800709:	55                   	push   %ebp
  80070a:	89 e5                	mov    %esp,%ebp
  80070c:	53                   	push   %ebx
  80070d:	83 ec 14             	sub    $0x14,%esp
	int64 **Res = malloc(sizeof(int64) * NumOfElements) ;
  800710:	8b 45 10             	mov    0x10(%ebp),%eax
  800713:	c1 e0 03             	shl    $0x3,%eax
  800716:	83 ec 0c             	sub    $0xc,%esp
  800719:	50                   	push   %eax
  80071a:	e8 c0 14 00 00       	call   801bdf <malloc>
  80071f:	83 c4 10             	add    $0x10,%esp
  800722:	89 45 e8             	mov    %eax,-0x18(%ebp)
	for (int i = 0; i < NumOfElements; ++i)
  800725:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80072c:	eb 27                	jmp    800755 <MatrixSubtraction+0x4c>
	{
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
  80072e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800731:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800738:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80073b:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
  80073e:	8b 45 10             	mov    0x10(%ebp),%eax
  800741:	c1 e0 03             	shl    $0x3,%eax
  800744:	83 ec 0c             	sub    $0xc,%esp
  800747:	50                   	push   %eax
  800748:	e8 92 14 00 00       	call   801bdf <malloc>
  80074d:	83 c4 10             	add    $0x10,%esp
  800750:	89 03                	mov    %eax,(%ebx)

///MATRIX SUBTRACTION
int64** MatrixSubtraction(int **M1, int **M2, int NumOfElements)
{
	int64 **Res = malloc(sizeof(int64) * NumOfElements) ;
	for (int i = 0; i < NumOfElements; ++i)
  800752:	ff 45 f4             	incl   -0xc(%ebp)
  800755:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800758:	3b 45 10             	cmp    0x10(%ebp),%eax
  80075b:	7c d1                	jl     80072e <MatrixSubtraction+0x25>
	{
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
	}

	for (int i = 0; i < NumOfElements; ++i)
  80075d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800764:	eb 71                	jmp    8007d7 <MatrixSubtraction+0xce>
	{
		for (int j = 0; j < NumOfElements; ++j)
  800766:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80076d:	eb 5d                	jmp    8007cc <MatrixSubtraction+0xc3>
		{
			Res[i][j] = M1[i][j] - M2[i][j] ;
  80076f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800772:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800779:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80077c:	01 d0                	add    %edx,%eax
  80077e:	8b 00                	mov    (%eax),%eax
  800780:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800783:	c1 e2 03             	shl    $0x3,%edx
  800786:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  800789:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80078c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800793:	8b 45 08             	mov    0x8(%ebp),%eax
  800796:	01 d0                	add    %edx,%eax
  800798:	8b 00                	mov    (%eax),%eax
  80079a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80079d:	c1 e2 02             	shl    $0x2,%edx
  8007a0:	01 d0                	add    %edx,%eax
  8007a2:	8b 10                	mov    (%eax),%edx
  8007a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007a7:	8d 1c 85 00 00 00 00 	lea    0x0(,%eax,4),%ebx
  8007ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007b1:	01 d8                	add    %ebx,%eax
  8007b3:	8b 00                	mov    (%eax),%eax
  8007b5:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8007b8:	c1 e3 02             	shl    $0x2,%ebx
  8007bb:	01 d8                	add    %ebx,%eax
  8007bd:	8b 00                	mov    (%eax),%eax
  8007bf:	29 c2                	sub    %eax,%edx
  8007c1:	89 d0                	mov    %edx,%eax
  8007c3:	99                   	cltd   
  8007c4:	89 01                	mov    %eax,(%ecx)
  8007c6:	89 51 04             	mov    %edx,0x4(%ecx)
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
	}

	for (int i = 0; i < NumOfElements; ++i)
	{
		for (int j = 0; j < NumOfElements; ++j)
  8007c9:	ff 45 ec             	incl   -0x14(%ebp)
  8007cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007cf:	3b 45 10             	cmp    0x10(%ebp),%eax
  8007d2:	7c 9b                	jl     80076f <MatrixSubtraction+0x66>
	for (int i = 0; i < NumOfElements; ++i)
	{
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
	}

	for (int i = 0; i < NumOfElements; ++i)
  8007d4:	ff 45 f0             	incl   -0x10(%ebp)
  8007d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007da:	3b 45 10             	cmp    0x10(%ebp),%eax
  8007dd:	7c 87                	jl     800766 <MatrixSubtraction+0x5d>
		for (int j = 0; j < NumOfElements; ++j)
		{
			Res[i][j] = M1[i][j] - M2[i][j] ;
		}
	}
	return Res;
  8007df:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  8007e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007e5:	c9                   	leave  
  8007e6:	c3                   	ret    

008007e7 <InitializeAscending>:

///Private Functions

void InitializeAscending(int **Elements, int NumOfElements)
{
  8007e7:	55                   	push   %ebp
  8007e8:	89 e5                	mov    %esp,%ebp
  8007ea:	83 ec 10             	sub    $0x10,%esp
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
  8007ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8007f4:	eb 35                	jmp    80082b <InitializeAscending+0x44>
	{
		for (j = 0 ; j < NumOfElements ; j++)
  8007f6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8007fd:	eb 21                	jmp    800820 <InitializeAscending+0x39>
		{
			(Elements)[i][j] = j ;
  8007ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800802:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800809:	8b 45 08             	mov    0x8(%ebp),%eax
  80080c:	01 d0                	add    %edx,%eax
  80080e:	8b 00                	mov    (%eax),%eax
  800810:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800813:	c1 e2 02             	shl    $0x2,%edx
  800816:	01 c2                	add    %eax,%edx
  800818:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80081b:	89 02                	mov    %eax,(%edx)
void InitializeAscending(int **Elements, int NumOfElements)
{
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
	{
		for (j = 0 ; j < NumOfElements ; j++)
  80081d:	ff 45 f8             	incl   -0x8(%ebp)
  800820:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800823:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800826:	7c d7                	jl     8007ff <InitializeAscending+0x18>
///Private Functions

void InitializeAscending(int **Elements, int NumOfElements)
{
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
  800828:	ff 45 fc             	incl   -0x4(%ebp)
  80082b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80082e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800831:	7c c3                	jl     8007f6 <InitializeAscending+0xf>
		for (j = 0 ; j < NumOfElements ; j++)
		{
			(Elements)[i][j] = j ;
		}
	}
}
  800833:	90                   	nop
  800834:	c9                   	leave  
  800835:	c3                   	ret    

00800836 <InitializeIdentical>:

void InitializeIdentical(int **Elements, int NumOfElements, int value)
{
  800836:	55                   	push   %ebp
  800837:	89 e5                	mov    %esp,%ebp
  800839:	83 ec 10             	sub    $0x10,%esp
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
  80083c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800843:	eb 35                	jmp    80087a <InitializeIdentical+0x44>
	{
		for (j = 0 ; j < NumOfElements ; j++)
  800845:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80084c:	eb 21                	jmp    80086f <InitializeIdentical+0x39>
		{
			(Elements)[i][j] = value ;
  80084e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800851:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800858:	8b 45 08             	mov    0x8(%ebp),%eax
  80085b:	01 d0                	add    %edx,%eax
  80085d:	8b 00                	mov    (%eax),%eax
  80085f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800862:	c1 e2 02             	shl    $0x2,%edx
  800865:	01 c2                	add    %eax,%edx
  800867:	8b 45 10             	mov    0x10(%ebp),%eax
  80086a:	89 02                	mov    %eax,(%edx)
void InitializeIdentical(int **Elements, int NumOfElements, int value)
{
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
	{
		for (j = 0 ; j < NumOfElements ; j++)
  80086c:	ff 45 f8             	incl   -0x8(%ebp)
  80086f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800872:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800875:	7c d7                	jl     80084e <InitializeIdentical+0x18>
}

void InitializeIdentical(int **Elements, int NumOfElements, int value)
{
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
  800877:	ff 45 fc             	incl   -0x4(%ebp)
  80087a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80087d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800880:	7c c3                	jl     800845 <InitializeIdentical+0xf>
		for (j = 0 ; j < NumOfElements ; j++)
		{
			(Elements)[i][j] = value ;
		}
	}
}
  800882:	90                   	nop
  800883:	c9                   	leave  
  800884:	c3                   	ret    

00800885 <InitializeSemiRandom>:

void InitializeSemiRandom(int **Elements, int NumOfElements)
{
  800885:	55                   	push   %ebp
  800886:	89 e5                	mov    %esp,%ebp
  800888:	53                   	push   %ebx
  800889:	83 ec 14             	sub    $0x14,%esp
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
  80088c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800893:	eb 51                	jmp    8008e6 <InitializeSemiRandom+0x61>
	{
		for (j = 0 ; j < NumOfElements ; j++)
  800895:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80089c:	eb 3d                	jmp    8008db <InitializeSemiRandom+0x56>
		{
			(Elements)[i][j] =  RAND(0, NumOfElements) ;
  80089e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008a1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8008a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ab:	01 d0                	add    %edx,%eax
  8008ad:	8b 00                	mov    (%eax),%eax
  8008af:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8008b2:	c1 e2 02             	shl    $0x2,%edx
  8008b5:	8d 1c 10             	lea    (%eax,%edx,1),%ebx
  8008b8:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8008bb:	83 ec 0c             	sub    $0xc,%esp
  8008be:	50                   	push   %eax
  8008bf:	e8 05 1d 00 00       	call   8025c9 <sys_get_virtual_time>
  8008c4:	83 c4 0c             	add    $0xc,%esp
  8008c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008ca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8008d2:	f7 f1                	div    %ecx
  8008d4:	89 d0                	mov    %edx,%eax
  8008d6:	89 03                	mov    %eax,(%ebx)
void InitializeSemiRandom(int **Elements, int NumOfElements)
{
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
	{
		for (j = 0 ; j < NumOfElements ; j++)
  8008d8:	ff 45 f0             	incl   -0x10(%ebp)
  8008db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008de:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8008e1:	7c bb                	jl     80089e <InitializeSemiRandom+0x19>
}

void InitializeSemiRandom(int **Elements, int NumOfElements)
{
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
  8008e3:	ff 45 f4             	incl   -0xc(%ebp)
  8008e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008e9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8008ec:	7c a7                	jl     800895 <InitializeSemiRandom+0x10>
		{
			(Elements)[i][j] =  RAND(0, NumOfElements) ;
			//	cprintf("i=%d\n",i);
		}
	}
}
  8008ee:	90                   	nop
  8008ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008f2:	c9                   	leave  
  8008f3:	c3                   	ret    

008008f4 <PrintElements>:

void PrintElements(int **Elements, int NumOfElements)
{
  8008f4:	55                   	push   %ebp
  8008f5:	89 e5                	mov    %esp,%ebp
  8008f7:	83 ec 18             	sub    $0x18,%esp
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
  8008fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800901:	eb 53                	jmp    800956 <PrintElements+0x62>
	{
		for (j = 0 ; j < NumOfElements ; j++)
  800903:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80090a:	eb 2f                	jmp    80093b <PrintElements+0x47>
		{
			cprintf("%~%d, ",Elements[i][j]);
  80090c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80090f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800916:	8b 45 08             	mov    0x8(%ebp),%eax
  800919:	01 d0                	add    %edx,%eax
  80091b:	8b 00                	mov    (%eax),%eax
  80091d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800920:	c1 e2 02             	shl    $0x2,%edx
  800923:	01 d0                	add    %edx,%eax
  800925:	8b 00                	mov    (%eax),%eax
  800927:	83 ec 08             	sub    $0x8,%esp
  80092a:	50                   	push   %eax
  80092b:	68 a2 41 80 00       	push   $0x8041a2
  800930:	e8 f2 02 00 00       	call   800c27 <cprintf>
  800935:	83 c4 10             	add    $0x10,%esp
void PrintElements(int **Elements, int NumOfElements)
{
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
	{
		for (j = 0 ; j < NumOfElements ; j++)
  800938:	ff 45 f0             	incl   -0x10(%ebp)
  80093b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80093e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800941:	7c c9                	jl     80090c <PrintElements+0x18>
		{
			cprintf("%~%d, ",Elements[i][j]);
		}
		cprintf("%~\n");
  800943:	83 ec 0c             	sub    $0xc,%esp
  800946:	68 a9 41 80 00       	push   $0x8041a9
  80094b:	e8 d7 02 00 00       	call   800c27 <cprintf>
  800950:	83 c4 10             	add    $0x10,%esp
}

void PrintElements(int **Elements, int NumOfElements)
{
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
  800953:	ff 45 f4             	incl   -0xc(%ebp)
  800956:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800959:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80095c:	7c a5                	jl     800903 <PrintElements+0xf>
		{
			cprintf("%~%d, ",Elements[i][j]);
		}
		cprintf("%~\n");
	}
}
  80095e:	90                   	nop
  80095f:	c9                   	leave  
  800960:	c3                   	ret    

00800961 <PrintElements64>:

void PrintElements64(int64 **Elements, int NumOfElements)
{
  800961:	55                   	push   %ebp
  800962:	89 e5                	mov    %esp,%ebp
  800964:	83 ec 18             	sub    $0x18,%esp
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
  800967:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80096e:	eb 57                	jmp    8009c7 <PrintElements64+0x66>
	{
		for (j = 0 ; j < NumOfElements ; j++)
  800970:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800977:	eb 33                	jmp    8009ac <PrintElements64+0x4b>
		{
			cprintf("%~%lld, ",Elements[i][j]);
  800979:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80097c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800983:	8b 45 08             	mov    0x8(%ebp),%eax
  800986:	01 d0                	add    %edx,%eax
  800988:	8b 00                	mov    (%eax),%eax
  80098a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80098d:	c1 e2 03             	shl    $0x3,%edx
  800990:	01 d0                	add    %edx,%eax
  800992:	8b 50 04             	mov    0x4(%eax),%edx
  800995:	8b 00                	mov    (%eax),%eax
  800997:	83 ec 04             	sub    $0x4,%esp
  80099a:	52                   	push   %edx
  80099b:	50                   	push   %eax
  80099c:	68 ad 41 80 00       	push   $0x8041ad
  8009a1:	e8 81 02 00 00       	call   800c27 <cprintf>
  8009a6:	83 c4 10             	add    $0x10,%esp
void PrintElements64(int64 **Elements, int NumOfElements)
{
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
	{
		for (j = 0 ; j < NumOfElements ; j++)
  8009a9:	ff 45 f0             	incl   -0x10(%ebp)
  8009ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009af:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8009b2:	7c c5                	jl     800979 <PrintElements64+0x18>
		{
			cprintf("%~%lld, ",Elements[i][j]);
		}
		cprintf("%~\n");
  8009b4:	83 ec 0c             	sub    $0xc,%esp
  8009b7:	68 a9 41 80 00       	push   $0x8041a9
  8009bc:	e8 66 02 00 00       	call   800c27 <cprintf>
  8009c1:	83 c4 10             	add    $0x10,%esp
}

void PrintElements64(int64 **Elements, int NumOfElements)
{
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
  8009c4:	ff 45 f4             	incl   -0xc(%ebp)
  8009c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009ca:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8009cd:	7c a1                	jl     800970 <PrintElements64+0xf>
		{
			cprintf("%~%lld, ",Elements[i][j]);
		}
		cprintf("%~\n");
	}
}
  8009cf:	90                   	nop
  8009d0:	c9                   	leave  
  8009d1:	c3                   	ret    

008009d2 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8009d2:	55                   	push   %ebp
  8009d3:	89 e5                	mov    %esp,%ebp
  8009d5:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8009d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009db:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8009de:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8009e2:	83 ec 0c             	sub    $0xc,%esp
  8009e5:	50                   	push   %eax
  8009e6:	e8 61 1a 00 00       	call   80244c <sys_cputc>
  8009eb:	83 c4 10             	add    $0x10,%esp
}
  8009ee:	90                   	nop
  8009ef:	c9                   	leave  
  8009f0:	c3                   	ret    

008009f1 <getchar>:


int
getchar(void)
{
  8009f1:	55                   	push   %ebp
  8009f2:	89 e5                	mov    %esp,%ebp
  8009f4:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  8009f7:	e8 ec 18 00 00       	call   8022e8 <sys_cgetc>
  8009fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  8009ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a02:	c9                   	leave  
  800a03:	c3                   	ret    

00800a04 <iscons>:

int iscons(int fdnum)
{
  800a04:	55                   	push   %ebp
  800a05:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800a07:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800a0c:	5d                   	pop    %ebp
  800a0d:	c3                   	ret    

00800a0e <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800a0e:	55                   	push   %ebp
  800a0f:	89 e5                	mov    %esp,%ebp
  800a11:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800a14:	e8 64 1b 00 00       	call   80257d <sys_getenvindex>
  800a19:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800a1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a1f:	89 d0                	mov    %edx,%eax
  800a21:	c1 e0 02             	shl    $0x2,%eax
  800a24:	01 d0                	add    %edx,%eax
  800a26:	c1 e0 03             	shl    $0x3,%eax
  800a29:	01 d0                	add    %edx,%eax
  800a2b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800a32:	01 d0                	add    %edx,%eax
  800a34:	c1 e0 02             	shl    $0x2,%eax
  800a37:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800a3c:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800a41:	a1 20 50 80 00       	mov    0x805020,%eax
  800a46:	8a 40 20             	mov    0x20(%eax),%al
  800a49:	84 c0                	test   %al,%al
  800a4b:	74 0d                	je     800a5a <libmain+0x4c>
		binaryname = myEnv->prog_name;
  800a4d:	a1 20 50 80 00       	mov    0x805020,%eax
  800a52:	83 c0 20             	add    $0x20,%eax
  800a55:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800a5a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a5e:	7e 0a                	jle    800a6a <libmain+0x5c>
		binaryname = argv[0];
  800a60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a63:	8b 00                	mov    (%eax),%eax
  800a65:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  800a6a:	83 ec 08             	sub    $0x8,%esp
  800a6d:	ff 75 0c             	pushl  0xc(%ebp)
  800a70:	ff 75 08             	pushl  0x8(%ebp)
  800a73:	e8 c0 f5 ff ff       	call   800038 <_main>
  800a78:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800a7b:	a1 00 50 80 00       	mov    0x805000,%eax
  800a80:	85 c0                	test   %eax,%eax
  800a82:	0f 84 9f 00 00 00    	je     800b27 <libmain+0x119>
	{
		sys_lock_cons();
  800a88:	e8 74 18 00 00       	call   802301 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800a8d:	83 ec 0c             	sub    $0xc,%esp
  800a90:	68 d0 41 80 00       	push   $0x8041d0
  800a95:	e8 8d 01 00 00       	call   800c27 <cprintf>
  800a9a:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800a9d:	a1 20 50 80 00       	mov    0x805020,%eax
  800aa2:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800aa8:	a1 20 50 80 00       	mov    0x805020,%eax
  800aad:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800ab3:	83 ec 04             	sub    $0x4,%esp
  800ab6:	52                   	push   %edx
  800ab7:	50                   	push   %eax
  800ab8:	68 f8 41 80 00       	push   $0x8041f8
  800abd:	e8 65 01 00 00       	call   800c27 <cprintf>
  800ac2:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800ac5:	a1 20 50 80 00       	mov    0x805020,%eax
  800aca:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800ad0:	a1 20 50 80 00       	mov    0x805020,%eax
  800ad5:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800adb:	a1 20 50 80 00       	mov    0x805020,%eax
  800ae0:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800ae6:	51                   	push   %ecx
  800ae7:	52                   	push   %edx
  800ae8:	50                   	push   %eax
  800ae9:	68 20 42 80 00       	push   $0x804220
  800aee:	e8 34 01 00 00       	call   800c27 <cprintf>
  800af3:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800af6:	a1 20 50 80 00       	mov    0x805020,%eax
  800afb:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800b01:	83 ec 08             	sub    $0x8,%esp
  800b04:	50                   	push   %eax
  800b05:	68 78 42 80 00       	push   $0x804278
  800b0a:	e8 18 01 00 00       	call   800c27 <cprintf>
  800b0f:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800b12:	83 ec 0c             	sub    $0xc,%esp
  800b15:	68 d0 41 80 00       	push   $0x8041d0
  800b1a:	e8 08 01 00 00       	call   800c27 <cprintf>
  800b1f:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800b22:	e8 f4 17 00 00       	call   80231b <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800b27:	e8 19 00 00 00       	call   800b45 <exit>
}
  800b2c:	90                   	nop
  800b2d:	c9                   	leave  
  800b2e:	c3                   	ret    

00800b2f <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800b2f:	55                   	push   %ebp
  800b30:	89 e5                	mov    %esp,%ebp
  800b32:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800b35:	83 ec 0c             	sub    $0xc,%esp
  800b38:	6a 00                	push   $0x0
  800b3a:	e8 0a 1a 00 00       	call   802549 <sys_destroy_env>
  800b3f:	83 c4 10             	add    $0x10,%esp
}
  800b42:	90                   	nop
  800b43:	c9                   	leave  
  800b44:	c3                   	ret    

00800b45 <exit>:

void
exit(void)
{
  800b45:	55                   	push   %ebp
  800b46:	89 e5                	mov    %esp,%ebp
  800b48:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800b4b:	e8 5f 1a 00 00       	call   8025af <sys_exit_env>
}
  800b50:	90                   	nop
  800b51:	c9                   	leave  
  800b52:	c3                   	ret    

00800b53 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800b53:	55                   	push   %ebp
  800b54:	89 e5                	mov    %esp,%ebp
  800b56:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800b59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5c:	8b 00                	mov    (%eax),%eax
  800b5e:	8d 48 01             	lea    0x1(%eax),%ecx
  800b61:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b64:	89 0a                	mov    %ecx,(%edx)
  800b66:	8b 55 08             	mov    0x8(%ebp),%edx
  800b69:	88 d1                	mov    %dl,%cl
  800b6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b6e:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800b72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b75:	8b 00                	mov    (%eax),%eax
  800b77:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b7c:	75 2c                	jne    800baa <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800b7e:	a0 44 50 98 00       	mov    0x985044,%al
  800b83:	0f b6 c0             	movzbl %al,%eax
  800b86:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b89:	8b 12                	mov    (%edx),%edx
  800b8b:	89 d1                	mov    %edx,%ecx
  800b8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b90:	83 c2 08             	add    $0x8,%edx
  800b93:	83 ec 04             	sub    $0x4,%esp
  800b96:	50                   	push   %eax
  800b97:	51                   	push   %ecx
  800b98:	52                   	push   %edx
  800b99:	e8 21 17 00 00       	call   8022bf <sys_cputs>
  800b9e:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800ba1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800baa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bad:	8b 40 04             	mov    0x4(%eax),%eax
  800bb0:	8d 50 01             	lea    0x1(%eax),%edx
  800bb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb6:	89 50 04             	mov    %edx,0x4(%eax)
}
  800bb9:	90                   	nop
  800bba:	c9                   	leave  
  800bbb:	c3                   	ret    

00800bbc <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800bbc:	55                   	push   %ebp
  800bbd:	89 e5                	mov    %esp,%ebp
  800bbf:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800bc5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800bcc:	00 00 00 
	b.cnt = 0;
  800bcf:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800bd6:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800bd9:	ff 75 0c             	pushl  0xc(%ebp)
  800bdc:	ff 75 08             	pushl  0x8(%ebp)
  800bdf:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800be5:	50                   	push   %eax
  800be6:	68 53 0b 80 00       	push   $0x800b53
  800beb:	e8 11 02 00 00       	call   800e01 <vprintfmt>
  800bf0:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800bf3:	a0 44 50 98 00       	mov    0x985044,%al
  800bf8:	0f b6 c0             	movzbl %al,%eax
  800bfb:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800c01:	83 ec 04             	sub    $0x4,%esp
  800c04:	50                   	push   %eax
  800c05:	52                   	push   %edx
  800c06:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c0c:	83 c0 08             	add    $0x8,%eax
  800c0f:	50                   	push   %eax
  800c10:	e8 aa 16 00 00       	call   8022bf <sys_cputs>
  800c15:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800c18:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
	return b.cnt;
  800c1f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800c25:	c9                   	leave  
  800c26:	c3                   	ret    

00800c27 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800c27:	55                   	push   %ebp
  800c28:	89 e5                	mov    %esp,%ebp
  800c2a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800c2d:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
	va_start(ap, fmt);
  800c34:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c37:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3d:	83 ec 08             	sub    $0x8,%esp
  800c40:	ff 75 f4             	pushl  -0xc(%ebp)
  800c43:	50                   	push   %eax
  800c44:	e8 73 ff ff ff       	call   800bbc <vcprintf>
  800c49:	83 c4 10             	add    $0x10,%esp
  800c4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800c4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c52:	c9                   	leave  
  800c53:	c3                   	ret    

00800c54 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800c54:	55                   	push   %ebp
  800c55:	89 e5                	mov    %esp,%ebp
  800c57:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800c5a:	e8 a2 16 00 00       	call   802301 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800c5f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c62:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800c65:	8b 45 08             	mov    0x8(%ebp),%eax
  800c68:	83 ec 08             	sub    $0x8,%esp
  800c6b:	ff 75 f4             	pushl  -0xc(%ebp)
  800c6e:	50                   	push   %eax
  800c6f:	e8 48 ff ff ff       	call   800bbc <vcprintf>
  800c74:	83 c4 10             	add    $0x10,%esp
  800c77:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800c7a:	e8 9c 16 00 00       	call   80231b <sys_unlock_cons>
	return cnt;
  800c7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c82:	c9                   	leave  
  800c83:	c3                   	ret    

00800c84 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c84:	55                   	push   %ebp
  800c85:	89 e5                	mov    %esp,%ebp
  800c87:	53                   	push   %ebx
  800c88:	83 ec 14             	sub    $0x14,%esp
  800c8b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c91:	8b 45 14             	mov    0x14(%ebp),%eax
  800c94:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c97:	8b 45 18             	mov    0x18(%ebp),%eax
  800c9a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c9f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ca2:	77 55                	ja     800cf9 <printnum+0x75>
  800ca4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ca7:	72 05                	jb     800cae <printnum+0x2a>
  800ca9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800cac:	77 4b                	ja     800cf9 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800cae:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800cb1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800cb4:	8b 45 18             	mov    0x18(%ebp),%eax
  800cb7:	ba 00 00 00 00       	mov    $0x0,%edx
  800cbc:	52                   	push   %edx
  800cbd:	50                   	push   %eax
  800cbe:	ff 75 f4             	pushl  -0xc(%ebp)
  800cc1:	ff 75 f0             	pushl  -0x10(%ebp)
  800cc4:	e8 e3 30 00 00       	call   803dac <__udivdi3>
  800cc9:	83 c4 10             	add    $0x10,%esp
  800ccc:	83 ec 04             	sub    $0x4,%esp
  800ccf:	ff 75 20             	pushl  0x20(%ebp)
  800cd2:	53                   	push   %ebx
  800cd3:	ff 75 18             	pushl  0x18(%ebp)
  800cd6:	52                   	push   %edx
  800cd7:	50                   	push   %eax
  800cd8:	ff 75 0c             	pushl  0xc(%ebp)
  800cdb:	ff 75 08             	pushl  0x8(%ebp)
  800cde:	e8 a1 ff ff ff       	call   800c84 <printnum>
  800ce3:	83 c4 20             	add    $0x20,%esp
  800ce6:	eb 1a                	jmp    800d02 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800ce8:	83 ec 08             	sub    $0x8,%esp
  800ceb:	ff 75 0c             	pushl  0xc(%ebp)
  800cee:	ff 75 20             	pushl  0x20(%ebp)
  800cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf4:	ff d0                	call   *%eax
  800cf6:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800cf9:	ff 4d 1c             	decl   0x1c(%ebp)
  800cfc:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800d00:	7f e6                	jg     800ce8 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800d02:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800d05:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d10:	53                   	push   %ebx
  800d11:	51                   	push   %ecx
  800d12:	52                   	push   %edx
  800d13:	50                   	push   %eax
  800d14:	e8 a3 31 00 00       	call   803ebc <__umoddi3>
  800d19:	83 c4 10             	add    $0x10,%esp
  800d1c:	05 b4 44 80 00       	add    $0x8044b4,%eax
  800d21:	8a 00                	mov    (%eax),%al
  800d23:	0f be c0             	movsbl %al,%eax
  800d26:	83 ec 08             	sub    $0x8,%esp
  800d29:	ff 75 0c             	pushl  0xc(%ebp)
  800d2c:	50                   	push   %eax
  800d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d30:	ff d0                	call   *%eax
  800d32:	83 c4 10             	add    $0x10,%esp
}
  800d35:	90                   	nop
  800d36:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d39:	c9                   	leave  
  800d3a:	c3                   	ret    

00800d3b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800d3b:	55                   	push   %ebp
  800d3c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d3e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d42:	7e 1c                	jle    800d60 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800d44:	8b 45 08             	mov    0x8(%ebp),%eax
  800d47:	8b 00                	mov    (%eax),%eax
  800d49:	8d 50 08             	lea    0x8(%eax),%edx
  800d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4f:	89 10                	mov    %edx,(%eax)
  800d51:	8b 45 08             	mov    0x8(%ebp),%eax
  800d54:	8b 00                	mov    (%eax),%eax
  800d56:	83 e8 08             	sub    $0x8,%eax
  800d59:	8b 50 04             	mov    0x4(%eax),%edx
  800d5c:	8b 00                	mov    (%eax),%eax
  800d5e:	eb 40                	jmp    800da0 <getuint+0x65>
	else if (lflag)
  800d60:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d64:	74 1e                	je     800d84 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800d66:	8b 45 08             	mov    0x8(%ebp),%eax
  800d69:	8b 00                	mov    (%eax),%eax
  800d6b:	8d 50 04             	lea    0x4(%eax),%edx
  800d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d71:	89 10                	mov    %edx,(%eax)
  800d73:	8b 45 08             	mov    0x8(%ebp),%eax
  800d76:	8b 00                	mov    (%eax),%eax
  800d78:	83 e8 04             	sub    $0x4,%eax
  800d7b:	8b 00                	mov    (%eax),%eax
  800d7d:	ba 00 00 00 00       	mov    $0x0,%edx
  800d82:	eb 1c                	jmp    800da0 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800d84:	8b 45 08             	mov    0x8(%ebp),%eax
  800d87:	8b 00                	mov    (%eax),%eax
  800d89:	8d 50 04             	lea    0x4(%eax),%edx
  800d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8f:	89 10                	mov    %edx,(%eax)
  800d91:	8b 45 08             	mov    0x8(%ebp),%eax
  800d94:	8b 00                	mov    (%eax),%eax
  800d96:	83 e8 04             	sub    $0x4,%eax
  800d99:	8b 00                	mov    (%eax),%eax
  800d9b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800da0:	5d                   	pop    %ebp
  800da1:	c3                   	ret    

00800da2 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800da2:	55                   	push   %ebp
  800da3:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800da5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800da9:	7e 1c                	jle    800dc7 <getint+0x25>
		return va_arg(*ap, long long);
  800dab:	8b 45 08             	mov    0x8(%ebp),%eax
  800dae:	8b 00                	mov    (%eax),%eax
  800db0:	8d 50 08             	lea    0x8(%eax),%edx
  800db3:	8b 45 08             	mov    0x8(%ebp),%eax
  800db6:	89 10                	mov    %edx,(%eax)
  800db8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbb:	8b 00                	mov    (%eax),%eax
  800dbd:	83 e8 08             	sub    $0x8,%eax
  800dc0:	8b 50 04             	mov    0x4(%eax),%edx
  800dc3:	8b 00                	mov    (%eax),%eax
  800dc5:	eb 38                	jmp    800dff <getint+0x5d>
	else if (lflag)
  800dc7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dcb:	74 1a                	je     800de7 <getint+0x45>
		return va_arg(*ap, long);
  800dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd0:	8b 00                	mov    (%eax),%eax
  800dd2:	8d 50 04             	lea    0x4(%eax),%edx
  800dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd8:	89 10                	mov    %edx,(%eax)
  800dda:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddd:	8b 00                	mov    (%eax),%eax
  800ddf:	83 e8 04             	sub    $0x4,%eax
  800de2:	8b 00                	mov    (%eax),%eax
  800de4:	99                   	cltd   
  800de5:	eb 18                	jmp    800dff <getint+0x5d>
	else
		return va_arg(*ap, int);
  800de7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dea:	8b 00                	mov    (%eax),%eax
  800dec:	8d 50 04             	lea    0x4(%eax),%edx
  800def:	8b 45 08             	mov    0x8(%ebp),%eax
  800df2:	89 10                	mov    %edx,(%eax)
  800df4:	8b 45 08             	mov    0x8(%ebp),%eax
  800df7:	8b 00                	mov    (%eax),%eax
  800df9:	83 e8 04             	sub    $0x4,%eax
  800dfc:	8b 00                	mov    (%eax),%eax
  800dfe:	99                   	cltd   
}
  800dff:	5d                   	pop    %ebp
  800e00:	c3                   	ret    

00800e01 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800e01:	55                   	push   %ebp
  800e02:	89 e5                	mov    %esp,%ebp
  800e04:	56                   	push   %esi
  800e05:	53                   	push   %ebx
  800e06:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e09:	eb 17                	jmp    800e22 <vprintfmt+0x21>
			if (ch == '\0')
  800e0b:	85 db                	test   %ebx,%ebx
  800e0d:	0f 84 c1 03 00 00    	je     8011d4 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800e13:	83 ec 08             	sub    $0x8,%esp
  800e16:	ff 75 0c             	pushl  0xc(%ebp)
  800e19:	53                   	push   %ebx
  800e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1d:	ff d0                	call   *%eax
  800e1f:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e22:	8b 45 10             	mov    0x10(%ebp),%eax
  800e25:	8d 50 01             	lea    0x1(%eax),%edx
  800e28:	89 55 10             	mov    %edx,0x10(%ebp)
  800e2b:	8a 00                	mov    (%eax),%al
  800e2d:	0f b6 d8             	movzbl %al,%ebx
  800e30:	83 fb 25             	cmp    $0x25,%ebx
  800e33:	75 d6                	jne    800e0b <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800e35:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800e39:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800e40:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800e47:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800e4e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e55:	8b 45 10             	mov    0x10(%ebp),%eax
  800e58:	8d 50 01             	lea    0x1(%eax),%edx
  800e5b:	89 55 10             	mov    %edx,0x10(%ebp)
  800e5e:	8a 00                	mov    (%eax),%al
  800e60:	0f b6 d8             	movzbl %al,%ebx
  800e63:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800e66:	83 f8 5b             	cmp    $0x5b,%eax
  800e69:	0f 87 3d 03 00 00    	ja     8011ac <vprintfmt+0x3ab>
  800e6f:	8b 04 85 d8 44 80 00 	mov    0x8044d8(,%eax,4),%eax
  800e76:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800e78:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800e7c:	eb d7                	jmp    800e55 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800e7e:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800e82:	eb d1                	jmp    800e55 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e84:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800e8b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e8e:	89 d0                	mov    %edx,%eax
  800e90:	c1 e0 02             	shl    $0x2,%eax
  800e93:	01 d0                	add    %edx,%eax
  800e95:	01 c0                	add    %eax,%eax
  800e97:	01 d8                	add    %ebx,%eax
  800e99:	83 e8 30             	sub    $0x30,%eax
  800e9c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800e9f:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea2:	8a 00                	mov    (%eax),%al
  800ea4:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ea7:	83 fb 2f             	cmp    $0x2f,%ebx
  800eaa:	7e 3e                	jle    800eea <vprintfmt+0xe9>
  800eac:	83 fb 39             	cmp    $0x39,%ebx
  800eaf:	7f 39                	jg     800eea <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800eb1:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800eb4:	eb d5                	jmp    800e8b <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800eb6:	8b 45 14             	mov    0x14(%ebp),%eax
  800eb9:	83 c0 04             	add    $0x4,%eax
  800ebc:	89 45 14             	mov    %eax,0x14(%ebp)
  800ebf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec2:	83 e8 04             	sub    $0x4,%eax
  800ec5:	8b 00                	mov    (%eax),%eax
  800ec7:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800eca:	eb 1f                	jmp    800eeb <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800ecc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ed0:	79 83                	jns    800e55 <vprintfmt+0x54>
				width = 0;
  800ed2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800ed9:	e9 77 ff ff ff       	jmp    800e55 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800ede:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800ee5:	e9 6b ff ff ff       	jmp    800e55 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800eea:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800eeb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800eef:	0f 89 60 ff ff ff    	jns    800e55 <vprintfmt+0x54>
				width = precision, precision = -1;
  800ef5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ef8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800efb:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800f02:	e9 4e ff ff ff       	jmp    800e55 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800f07:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800f0a:	e9 46 ff ff ff       	jmp    800e55 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800f0f:	8b 45 14             	mov    0x14(%ebp),%eax
  800f12:	83 c0 04             	add    $0x4,%eax
  800f15:	89 45 14             	mov    %eax,0x14(%ebp)
  800f18:	8b 45 14             	mov    0x14(%ebp),%eax
  800f1b:	83 e8 04             	sub    $0x4,%eax
  800f1e:	8b 00                	mov    (%eax),%eax
  800f20:	83 ec 08             	sub    $0x8,%esp
  800f23:	ff 75 0c             	pushl  0xc(%ebp)
  800f26:	50                   	push   %eax
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	ff d0                	call   *%eax
  800f2c:	83 c4 10             	add    $0x10,%esp
			break;
  800f2f:	e9 9b 02 00 00       	jmp    8011cf <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800f34:	8b 45 14             	mov    0x14(%ebp),%eax
  800f37:	83 c0 04             	add    $0x4,%eax
  800f3a:	89 45 14             	mov    %eax,0x14(%ebp)
  800f3d:	8b 45 14             	mov    0x14(%ebp),%eax
  800f40:	83 e8 04             	sub    $0x4,%eax
  800f43:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800f45:	85 db                	test   %ebx,%ebx
  800f47:	79 02                	jns    800f4b <vprintfmt+0x14a>
				err = -err;
  800f49:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800f4b:	83 fb 64             	cmp    $0x64,%ebx
  800f4e:	7f 0b                	jg     800f5b <vprintfmt+0x15a>
  800f50:	8b 34 9d 20 43 80 00 	mov    0x804320(,%ebx,4),%esi
  800f57:	85 f6                	test   %esi,%esi
  800f59:	75 19                	jne    800f74 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800f5b:	53                   	push   %ebx
  800f5c:	68 c5 44 80 00       	push   $0x8044c5
  800f61:	ff 75 0c             	pushl  0xc(%ebp)
  800f64:	ff 75 08             	pushl  0x8(%ebp)
  800f67:	e8 70 02 00 00       	call   8011dc <printfmt>
  800f6c:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f6f:	e9 5b 02 00 00       	jmp    8011cf <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800f74:	56                   	push   %esi
  800f75:	68 ce 44 80 00       	push   $0x8044ce
  800f7a:	ff 75 0c             	pushl  0xc(%ebp)
  800f7d:	ff 75 08             	pushl  0x8(%ebp)
  800f80:	e8 57 02 00 00       	call   8011dc <printfmt>
  800f85:	83 c4 10             	add    $0x10,%esp
			break;
  800f88:	e9 42 02 00 00       	jmp    8011cf <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800f8d:	8b 45 14             	mov    0x14(%ebp),%eax
  800f90:	83 c0 04             	add    $0x4,%eax
  800f93:	89 45 14             	mov    %eax,0x14(%ebp)
  800f96:	8b 45 14             	mov    0x14(%ebp),%eax
  800f99:	83 e8 04             	sub    $0x4,%eax
  800f9c:	8b 30                	mov    (%eax),%esi
  800f9e:	85 f6                	test   %esi,%esi
  800fa0:	75 05                	jne    800fa7 <vprintfmt+0x1a6>
				p = "(null)";
  800fa2:	be d1 44 80 00       	mov    $0x8044d1,%esi
			if (width > 0 && padc != '-')
  800fa7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fab:	7e 6d                	jle    80101a <vprintfmt+0x219>
  800fad:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800fb1:	74 67                	je     80101a <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800fb3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fb6:	83 ec 08             	sub    $0x8,%esp
  800fb9:	50                   	push   %eax
  800fba:	56                   	push   %esi
  800fbb:	e8 26 05 00 00       	call   8014e6 <strnlen>
  800fc0:	83 c4 10             	add    $0x10,%esp
  800fc3:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800fc6:	eb 16                	jmp    800fde <vprintfmt+0x1dd>
					putch(padc, putdat);
  800fc8:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800fcc:	83 ec 08             	sub    $0x8,%esp
  800fcf:	ff 75 0c             	pushl  0xc(%ebp)
  800fd2:	50                   	push   %eax
  800fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd6:	ff d0                	call   *%eax
  800fd8:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800fdb:	ff 4d e4             	decl   -0x1c(%ebp)
  800fde:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fe2:	7f e4                	jg     800fc8 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800fe4:	eb 34                	jmp    80101a <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800fe6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800fea:	74 1c                	je     801008 <vprintfmt+0x207>
  800fec:	83 fb 1f             	cmp    $0x1f,%ebx
  800fef:	7e 05                	jle    800ff6 <vprintfmt+0x1f5>
  800ff1:	83 fb 7e             	cmp    $0x7e,%ebx
  800ff4:	7e 12                	jle    801008 <vprintfmt+0x207>
					putch('?', putdat);
  800ff6:	83 ec 08             	sub    $0x8,%esp
  800ff9:	ff 75 0c             	pushl  0xc(%ebp)
  800ffc:	6a 3f                	push   $0x3f
  800ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  801001:	ff d0                	call   *%eax
  801003:	83 c4 10             	add    $0x10,%esp
  801006:	eb 0f                	jmp    801017 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801008:	83 ec 08             	sub    $0x8,%esp
  80100b:	ff 75 0c             	pushl  0xc(%ebp)
  80100e:	53                   	push   %ebx
  80100f:	8b 45 08             	mov    0x8(%ebp),%eax
  801012:	ff d0                	call   *%eax
  801014:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801017:	ff 4d e4             	decl   -0x1c(%ebp)
  80101a:	89 f0                	mov    %esi,%eax
  80101c:	8d 70 01             	lea    0x1(%eax),%esi
  80101f:	8a 00                	mov    (%eax),%al
  801021:	0f be d8             	movsbl %al,%ebx
  801024:	85 db                	test   %ebx,%ebx
  801026:	74 24                	je     80104c <vprintfmt+0x24b>
  801028:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80102c:	78 b8                	js     800fe6 <vprintfmt+0x1e5>
  80102e:	ff 4d e0             	decl   -0x20(%ebp)
  801031:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801035:	79 af                	jns    800fe6 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801037:	eb 13                	jmp    80104c <vprintfmt+0x24b>
				putch(' ', putdat);
  801039:	83 ec 08             	sub    $0x8,%esp
  80103c:	ff 75 0c             	pushl  0xc(%ebp)
  80103f:	6a 20                	push   $0x20
  801041:	8b 45 08             	mov    0x8(%ebp),%eax
  801044:	ff d0                	call   *%eax
  801046:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801049:	ff 4d e4             	decl   -0x1c(%ebp)
  80104c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801050:	7f e7                	jg     801039 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801052:	e9 78 01 00 00       	jmp    8011cf <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801057:	83 ec 08             	sub    $0x8,%esp
  80105a:	ff 75 e8             	pushl  -0x18(%ebp)
  80105d:	8d 45 14             	lea    0x14(%ebp),%eax
  801060:	50                   	push   %eax
  801061:	e8 3c fd ff ff       	call   800da2 <getint>
  801066:	83 c4 10             	add    $0x10,%esp
  801069:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80106c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80106f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801072:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801075:	85 d2                	test   %edx,%edx
  801077:	79 23                	jns    80109c <vprintfmt+0x29b>
				putch('-', putdat);
  801079:	83 ec 08             	sub    $0x8,%esp
  80107c:	ff 75 0c             	pushl  0xc(%ebp)
  80107f:	6a 2d                	push   $0x2d
  801081:	8b 45 08             	mov    0x8(%ebp),%eax
  801084:	ff d0                	call   *%eax
  801086:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801089:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80108c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80108f:	f7 d8                	neg    %eax
  801091:	83 d2 00             	adc    $0x0,%edx
  801094:	f7 da                	neg    %edx
  801096:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801099:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80109c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010a3:	e9 bc 00 00 00       	jmp    801164 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8010a8:	83 ec 08             	sub    $0x8,%esp
  8010ab:	ff 75 e8             	pushl  -0x18(%ebp)
  8010ae:	8d 45 14             	lea    0x14(%ebp),%eax
  8010b1:	50                   	push   %eax
  8010b2:	e8 84 fc ff ff       	call   800d3b <getuint>
  8010b7:	83 c4 10             	add    $0x10,%esp
  8010ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010bd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8010c0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010c7:	e9 98 00 00 00       	jmp    801164 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8010cc:	83 ec 08             	sub    $0x8,%esp
  8010cf:	ff 75 0c             	pushl  0xc(%ebp)
  8010d2:	6a 58                	push   $0x58
  8010d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d7:	ff d0                	call   *%eax
  8010d9:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8010dc:	83 ec 08             	sub    $0x8,%esp
  8010df:	ff 75 0c             	pushl  0xc(%ebp)
  8010e2:	6a 58                	push   $0x58
  8010e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e7:	ff d0                	call   *%eax
  8010e9:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8010ec:	83 ec 08             	sub    $0x8,%esp
  8010ef:	ff 75 0c             	pushl  0xc(%ebp)
  8010f2:	6a 58                	push   $0x58
  8010f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f7:	ff d0                	call   *%eax
  8010f9:	83 c4 10             	add    $0x10,%esp
			break;
  8010fc:	e9 ce 00 00 00       	jmp    8011cf <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801101:	83 ec 08             	sub    $0x8,%esp
  801104:	ff 75 0c             	pushl  0xc(%ebp)
  801107:	6a 30                	push   $0x30
  801109:	8b 45 08             	mov    0x8(%ebp),%eax
  80110c:	ff d0                	call   *%eax
  80110e:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801111:	83 ec 08             	sub    $0x8,%esp
  801114:	ff 75 0c             	pushl  0xc(%ebp)
  801117:	6a 78                	push   $0x78
  801119:	8b 45 08             	mov    0x8(%ebp),%eax
  80111c:	ff d0                	call   *%eax
  80111e:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801121:	8b 45 14             	mov    0x14(%ebp),%eax
  801124:	83 c0 04             	add    $0x4,%eax
  801127:	89 45 14             	mov    %eax,0x14(%ebp)
  80112a:	8b 45 14             	mov    0x14(%ebp),%eax
  80112d:	83 e8 04             	sub    $0x4,%eax
  801130:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801132:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801135:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80113c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801143:	eb 1f                	jmp    801164 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801145:	83 ec 08             	sub    $0x8,%esp
  801148:	ff 75 e8             	pushl  -0x18(%ebp)
  80114b:	8d 45 14             	lea    0x14(%ebp),%eax
  80114e:	50                   	push   %eax
  80114f:	e8 e7 fb ff ff       	call   800d3b <getuint>
  801154:	83 c4 10             	add    $0x10,%esp
  801157:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80115a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80115d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801164:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801168:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80116b:	83 ec 04             	sub    $0x4,%esp
  80116e:	52                   	push   %edx
  80116f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801172:	50                   	push   %eax
  801173:	ff 75 f4             	pushl  -0xc(%ebp)
  801176:	ff 75 f0             	pushl  -0x10(%ebp)
  801179:	ff 75 0c             	pushl  0xc(%ebp)
  80117c:	ff 75 08             	pushl  0x8(%ebp)
  80117f:	e8 00 fb ff ff       	call   800c84 <printnum>
  801184:	83 c4 20             	add    $0x20,%esp
			break;
  801187:	eb 46                	jmp    8011cf <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801189:	83 ec 08             	sub    $0x8,%esp
  80118c:	ff 75 0c             	pushl  0xc(%ebp)
  80118f:	53                   	push   %ebx
  801190:	8b 45 08             	mov    0x8(%ebp),%eax
  801193:	ff d0                	call   *%eax
  801195:	83 c4 10             	add    $0x10,%esp
			break;
  801198:	eb 35                	jmp    8011cf <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  80119a:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
			break;
  8011a1:	eb 2c                	jmp    8011cf <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8011a3:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
			break;
  8011aa:	eb 23                	jmp    8011cf <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8011ac:	83 ec 08             	sub    $0x8,%esp
  8011af:	ff 75 0c             	pushl  0xc(%ebp)
  8011b2:	6a 25                	push   $0x25
  8011b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b7:	ff d0                	call   *%eax
  8011b9:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8011bc:	ff 4d 10             	decl   0x10(%ebp)
  8011bf:	eb 03                	jmp    8011c4 <vprintfmt+0x3c3>
  8011c1:	ff 4d 10             	decl   0x10(%ebp)
  8011c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c7:	48                   	dec    %eax
  8011c8:	8a 00                	mov    (%eax),%al
  8011ca:	3c 25                	cmp    $0x25,%al
  8011cc:	75 f3                	jne    8011c1 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8011ce:	90                   	nop
		}
	}
  8011cf:	e9 35 fc ff ff       	jmp    800e09 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8011d4:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8011d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011d8:	5b                   	pop    %ebx
  8011d9:	5e                   	pop    %esi
  8011da:	5d                   	pop    %ebp
  8011db:	c3                   	ret    

008011dc <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8011dc:	55                   	push   %ebp
  8011dd:	89 e5                	mov    %esp,%ebp
  8011df:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8011e2:	8d 45 10             	lea    0x10(%ebp),%eax
  8011e5:	83 c0 04             	add    $0x4,%eax
  8011e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8011eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ee:	ff 75 f4             	pushl  -0xc(%ebp)
  8011f1:	50                   	push   %eax
  8011f2:	ff 75 0c             	pushl  0xc(%ebp)
  8011f5:	ff 75 08             	pushl  0x8(%ebp)
  8011f8:	e8 04 fc ff ff       	call   800e01 <vprintfmt>
  8011fd:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801200:	90                   	nop
  801201:	c9                   	leave  
  801202:	c3                   	ret    

00801203 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801203:	55                   	push   %ebp
  801204:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801206:	8b 45 0c             	mov    0xc(%ebp),%eax
  801209:	8b 40 08             	mov    0x8(%eax),%eax
  80120c:	8d 50 01             	lea    0x1(%eax),%edx
  80120f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801212:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801215:	8b 45 0c             	mov    0xc(%ebp),%eax
  801218:	8b 10                	mov    (%eax),%edx
  80121a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121d:	8b 40 04             	mov    0x4(%eax),%eax
  801220:	39 c2                	cmp    %eax,%edx
  801222:	73 12                	jae    801236 <sprintputch+0x33>
		*b->buf++ = ch;
  801224:	8b 45 0c             	mov    0xc(%ebp),%eax
  801227:	8b 00                	mov    (%eax),%eax
  801229:	8d 48 01             	lea    0x1(%eax),%ecx
  80122c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80122f:	89 0a                	mov    %ecx,(%edx)
  801231:	8b 55 08             	mov    0x8(%ebp),%edx
  801234:	88 10                	mov    %dl,(%eax)
}
  801236:	90                   	nop
  801237:	5d                   	pop    %ebp
  801238:	c3                   	ret    

00801239 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801239:	55                   	push   %ebp
  80123a:	89 e5                	mov    %esp,%ebp
  80123c:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80123f:	8b 45 08             	mov    0x8(%ebp),%eax
  801242:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801245:	8b 45 0c             	mov    0xc(%ebp),%eax
  801248:	8d 50 ff             	lea    -0x1(%eax),%edx
  80124b:	8b 45 08             	mov    0x8(%ebp),%eax
  80124e:	01 d0                	add    %edx,%eax
  801250:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801253:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80125a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80125e:	74 06                	je     801266 <vsnprintf+0x2d>
  801260:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801264:	7f 07                	jg     80126d <vsnprintf+0x34>
		return -E_INVAL;
  801266:	b8 03 00 00 00       	mov    $0x3,%eax
  80126b:	eb 20                	jmp    80128d <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80126d:	ff 75 14             	pushl  0x14(%ebp)
  801270:	ff 75 10             	pushl  0x10(%ebp)
  801273:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801276:	50                   	push   %eax
  801277:	68 03 12 80 00       	push   $0x801203
  80127c:	e8 80 fb ff ff       	call   800e01 <vprintfmt>
  801281:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801284:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801287:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80128a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80128d:	c9                   	leave  
  80128e:	c3                   	ret    

0080128f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80128f:	55                   	push   %ebp
  801290:	89 e5                	mov    %esp,%ebp
  801292:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801295:	8d 45 10             	lea    0x10(%ebp),%eax
  801298:	83 c0 04             	add    $0x4,%eax
  80129b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80129e:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a1:	ff 75 f4             	pushl  -0xc(%ebp)
  8012a4:	50                   	push   %eax
  8012a5:	ff 75 0c             	pushl  0xc(%ebp)
  8012a8:	ff 75 08             	pushl  0x8(%ebp)
  8012ab:	e8 89 ff ff ff       	call   801239 <vsnprintf>
  8012b0:	83 c4 10             	add    $0x10,%esp
  8012b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8012b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012b9:	c9                   	leave  
  8012ba:	c3                   	ret    

008012bb <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8012bb:	55                   	push   %ebp
  8012bc:	89 e5                	mov    %esp,%ebp
  8012be:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  8012c1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012c5:	74 13                	je     8012da <readline+0x1f>
		cprintf("%s", prompt);
  8012c7:	83 ec 08             	sub    $0x8,%esp
  8012ca:	ff 75 08             	pushl  0x8(%ebp)
  8012cd:	68 48 46 80 00       	push   $0x804648
  8012d2:	e8 50 f9 ff ff       	call   800c27 <cprintf>
  8012d7:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8012da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8012e1:	83 ec 0c             	sub    $0xc,%esp
  8012e4:	6a 00                	push   $0x0
  8012e6:	e8 19 f7 ff ff       	call   800a04 <iscons>
  8012eb:	83 c4 10             	add    $0x10,%esp
  8012ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8012f1:	e8 fb f6 ff ff       	call   8009f1 <getchar>
  8012f6:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8012f9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8012fd:	79 22                	jns    801321 <readline+0x66>
			if (c != -E_EOF)
  8012ff:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801303:	0f 84 ad 00 00 00    	je     8013b6 <readline+0xfb>
				cprintf("read error: %e\n", c);
  801309:	83 ec 08             	sub    $0x8,%esp
  80130c:	ff 75 ec             	pushl  -0x14(%ebp)
  80130f:	68 4b 46 80 00       	push   $0x80464b
  801314:	e8 0e f9 ff ff       	call   800c27 <cprintf>
  801319:	83 c4 10             	add    $0x10,%esp
			break;
  80131c:	e9 95 00 00 00       	jmp    8013b6 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801321:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801325:	7e 34                	jle    80135b <readline+0xa0>
  801327:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80132e:	7f 2b                	jg     80135b <readline+0xa0>
			if (echoing)
  801330:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801334:	74 0e                	je     801344 <readline+0x89>
				cputchar(c);
  801336:	83 ec 0c             	sub    $0xc,%esp
  801339:	ff 75 ec             	pushl  -0x14(%ebp)
  80133c:	e8 91 f6 ff ff       	call   8009d2 <cputchar>
  801341:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801344:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801347:	8d 50 01             	lea    0x1(%eax),%edx
  80134a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80134d:	89 c2                	mov    %eax,%edx
  80134f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801352:	01 d0                	add    %edx,%eax
  801354:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801357:	88 10                	mov    %dl,(%eax)
  801359:	eb 56                	jmp    8013b1 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  80135b:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80135f:	75 1f                	jne    801380 <readline+0xc5>
  801361:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801365:	7e 19                	jle    801380 <readline+0xc5>
			if (echoing)
  801367:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80136b:	74 0e                	je     80137b <readline+0xc0>
				cputchar(c);
  80136d:	83 ec 0c             	sub    $0xc,%esp
  801370:	ff 75 ec             	pushl  -0x14(%ebp)
  801373:	e8 5a f6 ff ff       	call   8009d2 <cputchar>
  801378:	83 c4 10             	add    $0x10,%esp

			i--;
  80137b:	ff 4d f4             	decl   -0xc(%ebp)
  80137e:	eb 31                	jmp    8013b1 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801380:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801384:	74 0a                	je     801390 <readline+0xd5>
  801386:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80138a:	0f 85 61 ff ff ff    	jne    8012f1 <readline+0x36>
			if (echoing)
  801390:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801394:	74 0e                	je     8013a4 <readline+0xe9>
				cputchar(c);
  801396:	83 ec 0c             	sub    $0xc,%esp
  801399:	ff 75 ec             	pushl  -0x14(%ebp)
  80139c:	e8 31 f6 ff ff       	call   8009d2 <cputchar>
  8013a1:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8013a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013aa:	01 d0                	add    %edx,%eax
  8013ac:	c6 00 00             	movb   $0x0,(%eax)
			break;
  8013af:	eb 06                	jmp    8013b7 <readline+0xfc>
		}
	}
  8013b1:	e9 3b ff ff ff       	jmp    8012f1 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  8013b6:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  8013b7:	90                   	nop
  8013b8:	c9                   	leave  
  8013b9:	c3                   	ret    

008013ba <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8013ba:	55                   	push   %ebp
  8013bb:	89 e5                	mov    %esp,%ebp
  8013bd:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  8013c0:	e8 3c 0f 00 00       	call   802301 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  8013c5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013c9:	74 13                	je     8013de <atomic_readline+0x24>
			cprintf("%s", prompt);
  8013cb:	83 ec 08             	sub    $0x8,%esp
  8013ce:	ff 75 08             	pushl  0x8(%ebp)
  8013d1:	68 48 46 80 00       	push   $0x804648
  8013d6:	e8 4c f8 ff ff       	call   800c27 <cprintf>
  8013db:	83 c4 10             	add    $0x10,%esp

		i = 0;
  8013de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  8013e5:	83 ec 0c             	sub    $0xc,%esp
  8013e8:	6a 00                	push   $0x0
  8013ea:	e8 15 f6 ff ff       	call   800a04 <iscons>
  8013ef:	83 c4 10             	add    $0x10,%esp
  8013f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  8013f5:	e8 f7 f5 ff ff       	call   8009f1 <getchar>
  8013fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  8013fd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801401:	79 22                	jns    801425 <atomic_readline+0x6b>
				if (c != -E_EOF)
  801403:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801407:	0f 84 ad 00 00 00    	je     8014ba <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  80140d:	83 ec 08             	sub    $0x8,%esp
  801410:	ff 75 ec             	pushl  -0x14(%ebp)
  801413:	68 4b 46 80 00       	push   $0x80464b
  801418:	e8 0a f8 ff ff       	call   800c27 <cprintf>
  80141d:	83 c4 10             	add    $0x10,%esp
				break;
  801420:	e9 95 00 00 00       	jmp    8014ba <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  801425:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801429:	7e 34                	jle    80145f <atomic_readline+0xa5>
  80142b:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801432:	7f 2b                	jg     80145f <atomic_readline+0xa5>
				if (echoing)
  801434:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801438:	74 0e                	je     801448 <atomic_readline+0x8e>
					cputchar(c);
  80143a:	83 ec 0c             	sub    $0xc,%esp
  80143d:	ff 75 ec             	pushl  -0x14(%ebp)
  801440:	e8 8d f5 ff ff       	call   8009d2 <cputchar>
  801445:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  801448:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80144b:	8d 50 01             	lea    0x1(%eax),%edx
  80144e:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801451:	89 c2                	mov    %eax,%edx
  801453:	8b 45 0c             	mov    0xc(%ebp),%eax
  801456:	01 d0                	add    %edx,%eax
  801458:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80145b:	88 10                	mov    %dl,(%eax)
  80145d:	eb 56                	jmp    8014b5 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  80145f:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801463:	75 1f                	jne    801484 <atomic_readline+0xca>
  801465:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801469:	7e 19                	jle    801484 <atomic_readline+0xca>
				if (echoing)
  80146b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80146f:	74 0e                	je     80147f <atomic_readline+0xc5>
					cputchar(c);
  801471:	83 ec 0c             	sub    $0xc,%esp
  801474:	ff 75 ec             	pushl  -0x14(%ebp)
  801477:	e8 56 f5 ff ff       	call   8009d2 <cputchar>
  80147c:	83 c4 10             	add    $0x10,%esp
				i--;
  80147f:	ff 4d f4             	decl   -0xc(%ebp)
  801482:	eb 31                	jmp    8014b5 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  801484:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801488:	74 0a                	je     801494 <atomic_readline+0xda>
  80148a:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80148e:	0f 85 61 ff ff ff    	jne    8013f5 <atomic_readline+0x3b>
				if (echoing)
  801494:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801498:	74 0e                	je     8014a8 <atomic_readline+0xee>
					cputchar(c);
  80149a:	83 ec 0c             	sub    $0xc,%esp
  80149d:	ff 75 ec             	pushl  -0x14(%ebp)
  8014a0:	e8 2d f5 ff ff       	call   8009d2 <cputchar>
  8014a5:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  8014a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ae:	01 d0                	add    %edx,%eax
  8014b0:	c6 00 00             	movb   $0x0,(%eax)
				break;
  8014b3:	eb 06                	jmp    8014bb <atomic_readline+0x101>
			}
		}
  8014b5:	e9 3b ff ff ff       	jmp    8013f5 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  8014ba:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  8014bb:	e8 5b 0e 00 00       	call   80231b <sys_unlock_cons>
}
  8014c0:	90                   	nop
  8014c1:	c9                   	leave  
  8014c2:	c3                   	ret    

008014c3 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  8014c3:	55                   	push   %ebp
  8014c4:	89 e5                	mov    %esp,%ebp
  8014c6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8014c9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014d0:	eb 06                	jmp    8014d8 <strlen+0x15>
		n++;
  8014d2:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8014d5:	ff 45 08             	incl   0x8(%ebp)
  8014d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014db:	8a 00                	mov    (%eax),%al
  8014dd:	84 c0                	test   %al,%al
  8014df:	75 f1                	jne    8014d2 <strlen+0xf>
		n++;
	return n;
  8014e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8014e4:	c9                   	leave  
  8014e5:	c3                   	ret    

008014e6 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8014e6:	55                   	push   %ebp
  8014e7:	89 e5                	mov    %esp,%ebp
  8014e9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8014ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014f3:	eb 09                	jmp    8014fe <strnlen+0x18>
		n++;
  8014f5:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8014f8:	ff 45 08             	incl   0x8(%ebp)
  8014fb:	ff 4d 0c             	decl   0xc(%ebp)
  8014fe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801502:	74 09                	je     80150d <strnlen+0x27>
  801504:	8b 45 08             	mov    0x8(%ebp),%eax
  801507:	8a 00                	mov    (%eax),%al
  801509:	84 c0                	test   %al,%al
  80150b:	75 e8                	jne    8014f5 <strnlen+0xf>
		n++;
	return n;
  80150d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801510:	c9                   	leave  
  801511:	c3                   	ret    

00801512 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801512:	55                   	push   %ebp
  801513:	89 e5                	mov    %esp,%ebp
  801515:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801518:	8b 45 08             	mov    0x8(%ebp),%eax
  80151b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80151e:	90                   	nop
  80151f:	8b 45 08             	mov    0x8(%ebp),%eax
  801522:	8d 50 01             	lea    0x1(%eax),%edx
  801525:	89 55 08             	mov    %edx,0x8(%ebp)
  801528:	8b 55 0c             	mov    0xc(%ebp),%edx
  80152b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80152e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801531:	8a 12                	mov    (%edx),%dl
  801533:	88 10                	mov    %dl,(%eax)
  801535:	8a 00                	mov    (%eax),%al
  801537:	84 c0                	test   %al,%al
  801539:	75 e4                	jne    80151f <strcpy+0xd>
		/* do nothing */;
	return ret;
  80153b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80153e:	c9                   	leave  
  80153f:	c3                   	ret    

00801540 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801540:	55                   	push   %ebp
  801541:	89 e5                	mov    %esp,%ebp
  801543:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801546:	8b 45 08             	mov    0x8(%ebp),%eax
  801549:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80154c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801553:	eb 1f                	jmp    801574 <strncpy+0x34>
		*dst++ = *src;
  801555:	8b 45 08             	mov    0x8(%ebp),%eax
  801558:	8d 50 01             	lea    0x1(%eax),%edx
  80155b:	89 55 08             	mov    %edx,0x8(%ebp)
  80155e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801561:	8a 12                	mov    (%edx),%dl
  801563:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801565:	8b 45 0c             	mov    0xc(%ebp),%eax
  801568:	8a 00                	mov    (%eax),%al
  80156a:	84 c0                	test   %al,%al
  80156c:	74 03                	je     801571 <strncpy+0x31>
			src++;
  80156e:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801571:	ff 45 fc             	incl   -0x4(%ebp)
  801574:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801577:	3b 45 10             	cmp    0x10(%ebp),%eax
  80157a:	72 d9                	jb     801555 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80157c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80157f:	c9                   	leave  
  801580:	c3                   	ret    

00801581 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801581:	55                   	push   %ebp
  801582:	89 e5                	mov    %esp,%ebp
  801584:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801587:	8b 45 08             	mov    0x8(%ebp),%eax
  80158a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80158d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801591:	74 30                	je     8015c3 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801593:	eb 16                	jmp    8015ab <strlcpy+0x2a>
			*dst++ = *src++;
  801595:	8b 45 08             	mov    0x8(%ebp),%eax
  801598:	8d 50 01             	lea    0x1(%eax),%edx
  80159b:	89 55 08             	mov    %edx,0x8(%ebp)
  80159e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015a1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015a4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8015a7:	8a 12                	mov    (%edx),%dl
  8015a9:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8015ab:	ff 4d 10             	decl   0x10(%ebp)
  8015ae:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015b2:	74 09                	je     8015bd <strlcpy+0x3c>
  8015b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b7:	8a 00                	mov    (%eax),%al
  8015b9:	84 c0                	test   %al,%al
  8015bb:	75 d8                	jne    801595 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8015bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8015c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8015c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015c9:	29 c2                	sub    %eax,%edx
  8015cb:	89 d0                	mov    %edx,%eax
}
  8015cd:	c9                   	leave  
  8015ce:	c3                   	ret    

008015cf <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8015cf:	55                   	push   %ebp
  8015d0:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8015d2:	eb 06                	jmp    8015da <strcmp+0xb>
		p++, q++;
  8015d4:	ff 45 08             	incl   0x8(%ebp)
  8015d7:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8015da:	8b 45 08             	mov    0x8(%ebp),%eax
  8015dd:	8a 00                	mov    (%eax),%al
  8015df:	84 c0                	test   %al,%al
  8015e1:	74 0e                	je     8015f1 <strcmp+0x22>
  8015e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e6:	8a 10                	mov    (%eax),%dl
  8015e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015eb:	8a 00                	mov    (%eax),%al
  8015ed:	38 c2                	cmp    %al,%dl
  8015ef:	74 e3                	je     8015d4 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8015f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f4:	8a 00                	mov    (%eax),%al
  8015f6:	0f b6 d0             	movzbl %al,%edx
  8015f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015fc:	8a 00                	mov    (%eax),%al
  8015fe:	0f b6 c0             	movzbl %al,%eax
  801601:	29 c2                	sub    %eax,%edx
  801603:	89 d0                	mov    %edx,%eax
}
  801605:	5d                   	pop    %ebp
  801606:	c3                   	ret    

00801607 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801607:	55                   	push   %ebp
  801608:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80160a:	eb 09                	jmp    801615 <strncmp+0xe>
		n--, p++, q++;
  80160c:	ff 4d 10             	decl   0x10(%ebp)
  80160f:	ff 45 08             	incl   0x8(%ebp)
  801612:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801615:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801619:	74 17                	je     801632 <strncmp+0x2b>
  80161b:	8b 45 08             	mov    0x8(%ebp),%eax
  80161e:	8a 00                	mov    (%eax),%al
  801620:	84 c0                	test   %al,%al
  801622:	74 0e                	je     801632 <strncmp+0x2b>
  801624:	8b 45 08             	mov    0x8(%ebp),%eax
  801627:	8a 10                	mov    (%eax),%dl
  801629:	8b 45 0c             	mov    0xc(%ebp),%eax
  80162c:	8a 00                	mov    (%eax),%al
  80162e:	38 c2                	cmp    %al,%dl
  801630:	74 da                	je     80160c <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801632:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801636:	75 07                	jne    80163f <strncmp+0x38>
		return 0;
  801638:	b8 00 00 00 00       	mov    $0x0,%eax
  80163d:	eb 14                	jmp    801653 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80163f:	8b 45 08             	mov    0x8(%ebp),%eax
  801642:	8a 00                	mov    (%eax),%al
  801644:	0f b6 d0             	movzbl %al,%edx
  801647:	8b 45 0c             	mov    0xc(%ebp),%eax
  80164a:	8a 00                	mov    (%eax),%al
  80164c:	0f b6 c0             	movzbl %al,%eax
  80164f:	29 c2                	sub    %eax,%edx
  801651:	89 d0                	mov    %edx,%eax
}
  801653:	5d                   	pop    %ebp
  801654:	c3                   	ret    

00801655 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801655:	55                   	push   %ebp
  801656:	89 e5                	mov    %esp,%ebp
  801658:	83 ec 04             	sub    $0x4,%esp
  80165b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80165e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801661:	eb 12                	jmp    801675 <strchr+0x20>
		if (*s == c)
  801663:	8b 45 08             	mov    0x8(%ebp),%eax
  801666:	8a 00                	mov    (%eax),%al
  801668:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80166b:	75 05                	jne    801672 <strchr+0x1d>
			return (char *) s;
  80166d:	8b 45 08             	mov    0x8(%ebp),%eax
  801670:	eb 11                	jmp    801683 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801672:	ff 45 08             	incl   0x8(%ebp)
  801675:	8b 45 08             	mov    0x8(%ebp),%eax
  801678:	8a 00                	mov    (%eax),%al
  80167a:	84 c0                	test   %al,%al
  80167c:	75 e5                	jne    801663 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80167e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801683:	c9                   	leave  
  801684:	c3                   	ret    

00801685 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801685:	55                   	push   %ebp
  801686:	89 e5                	mov    %esp,%ebp
  801688:	83 ec 04             	sub    $0x4,%esp
  80168b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80168e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801691:	eb 0d                	jmp    8016a0 <strfind+0x1b>
		if (*s == c)
  801693:	8b 45 08             	mov    0x8(%ebp),%eax
  801696:	8a 00                	mov    (%eax),%al
  801698:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80169b:	74 0e                	je     8016ab <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80169d:	ff 45 08             	incl   0x8(%ebp)
  8016a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a3:	8a 00                	mov    (%eax),%al
  8016a5:	84 c0                	test   %al,%al
  8016a7:	75 ea                	jne    801693 <strfind+0xe>
  8016a9:	eb 01                	jmp    8016ac <strfind+0x27>
		if (*s == c)
			break;
  8016ab:	90                   	nop
	return (char *) s;
  8016ac:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016af:	c9                   	leave  
  8016b0:	c3                   	ret    

008016b1 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8016b1:	55                   	push   %ebp
  8016b2:	89 e5                	mov    %esp,%ebp
  8016b4:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8016b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8016bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8016c3:	eb 0e                	jmp    8016d3 <memset+0x22>
		*p++ = c;
  8016c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016c8:	8d 50 01             	lea    0x1(%eax),%edx
  8016cb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8016ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016d1:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8016d3:	ff 4d f8             	decl   -0x8(%ebp)
  8016d6:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8016da:	79 e9                	jns    8016c5 <memset+0x14>
		*p++ = c;

	return v;
  8016dc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016df:	c9                   	leave  
  8016e0:	c3                   	ret    

008016e1 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8016e1:	55                   	push   %ebp
  8016e2:	89 e5                	mov    %esp,%ebp
  8016e4:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8016e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8016ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8016f3:	eb 16                	jmp    80170b <memcpy+0x2a>
		*d++ = *s++;
  8016f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016f8:	8d 50 01             	lea    0x1(%eax),%edx
  8016fb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016fe:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801701:	8d 4a 01             	lea    0x1(%edx),%ecx
  801704:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801707:	8a 12                	mov    (%edx),%dl
  801709:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80170b:	8b 45 10             	mov    0x10(%ebp),%eax
  80170e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801711:	89 55 10             	mov    %edx,0x10(%ebp)
  801714:	85 c0                	test   %eax,%eax
  801716:	75 dd                	jne    8016f5 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801718:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80171b:	c9                   	leave  
  80171c:	c3                   	ret    

0080171d <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80171d:	55                   	push   %ebp
  80171e:	89 e5                	mov    %esp,%ebp
  801720:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801723:	8b 45 0c             	mov    0xc(%ebp),%eax
  801726:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801729:	8b 45 08             	mov    0x8(%ebp),%eax
  80172c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80172f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801732:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801735:	73 50                	jae    801787 <memmove+0x6a>
  801737:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80173a:	8b 45 10             	mov    0x10(%ebp),%eax
  80173d:	01 d0                	add    %edx,%eax
  80173f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801742:	76 43                	jbe    801787 <memmove+0x6a>
		s += n;
  801744:	8b 45 10             	mov    0x10(%ebp),%eax
  801747:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80174a:	8b 45 10             	mov    0x10(%ebp),%eax
  80174d:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801750:	eb 10                	jmp    801762 <memmove+0x45>
			*--d = *--s;
  801752:	ff 4d f8             	decl   -0x8(%ebp)
  801755:	ff 4d fc             	decl   -0x4(%ebp)
  801758:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80175b:	8a 10                	mov    (%eax),%dl
  80175d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801760:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801762:	8b 45 10             	mov    0x10(%ebp),%eax
  801765:	8d 50 ff             	lea    -0x1(%eax),%edx
  801768:	89 55 10             	mov    %edx,0x10(%ebp)
  80176b:	85 c0                	test   %eax,%eax
  80176d:	75 e3                	jne    801752 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80176f:	eb 23                	jmp    801794 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801771:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801774:	8d 50 01             	lea    0x1(%eax),%edx
  801777:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80177a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80177d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801780:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801783:	8a 12                	mov    (%edx),%dl
  801785:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801787:	8b 45 10             	mov    0x10(%ebp),%eax
  80178a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80178d:	89 55 10             	mov    %edx,0x10(%ebp)
  801790:	85 c0                	test   %eax,%eax
  801792:	75 dd                	jne    801771 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801794:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801797:	c9                   	leave  
  801798:	c3                   	ret    

00801799 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801799:	55                   	push   %ebp
  80179a:	89 e5                	mov    %esp,%ebp
  80179c:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80179f:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8017a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a8:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8017ab:	eb 2a                	jmp    8017d7 <memcmp+0x3e>
		if (*s1 != *s2)
  8017ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017b0:	8a 10                	mov    (%eax),%dl
  8017b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017b5:	8a 00                	mov    (%eax),%al
  8017b7:	38 c2                	cmp    %al,%dl
  8017b9:	74 16                	je     8017d1 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8017bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017be:	8a 00                	mov    (%eax),%al
  8017c0:	0f b6 d0             	movzbl %al,%edx
  8017c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017c6:	8a 00                	mov    (%eax),%al
  8017c8:	0f b6 c0             	movzbl %al,%eax
  8017cb:	29 c2                	sub    %eax,%edx
  8017cd:	89 d0                	mov    %edx,%eax
  8017cf:	eb 18                	jmp    8017e9 <memcmp+0x50>
		s1++, s2++;
  8017d1:	ff 45 fc             	incl   -0x4(%ebp)
  8017d4:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8017d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8017da:	8d 50 ff             	lea    -0x1(%eax),%edx
  8017dd:	89 55 10             	mov    %edx,0x10(%ebp)
  8017e0:	85 c0                	test   %eax,%eax
  8017e2:	75 c9                	jne    8017ad <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8017e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017e9:	c9                   	leave  
  8017ea:	c3                   	ret    

008017eb <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8017eb:	55                   	push   %ebp
  8017ec:	89 e5                	mov    %esp,%ebp
  8017ee:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8017f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8017f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8017f7:	01 d0                	add    %edx,%eax
  8017f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8017fc:	eb 15                	jmp    801813 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8017fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801801:	8a 00                	mov    (%eax),%al
  801803:	0f b6 d0             	movzbl %al,%edx
  801806:	8b 45 0c             	mov    0xc(%ebp),%eax
  801809:	0f b6 c0             	movzbl %al,%eax
  80180c:	39 c2                	cmp    %eax,%edx
  80180e:	74 0d                	je     80181d <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801810:	ff 45 08             	incl   0x8(%ebp)
  801813:	8b 45 08             	mov    0x8(%ebp),%eax
  801816:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801819:	72 e3                	jb     8017fe <memfind+0x13>
  80181b:	eb 01                	jmp    80181e <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80181d:	90                   	nop
	return (void *) s;
  80181e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801821:	c9                   	leave  
  801822:	c3                   	ret    

00801823 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801823:	55                   	push   %ebp
  801824:	89 e5                	mov    %esp,%ebp
  801826:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801829:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801830:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801837:	eb 03                	jmp    80183c <strtol+0x19>
		s++;
  801839:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80183c:	8b 45 08             	mov    0x8(%ebp),%eax
  80183f:	8a 00                	mov    (%eax),%al
  801841:	3c 20                	cmp    $0x20,%al
  801843:	74 f4                	je     801839 <strtol+0x16>
  801845:	8b 45 08             	mov    0x8(%ebp),%eax
  801848:	8a 00                	mov    (%eax),%al
  80184a:	3c 09                	cmp    $0x9,%al
  80184c:	74 eb                	je     801839 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80184e:	8b 45 08             	mov    0x8(%ebp),%eax
  801851:	8a 00                	mov    (%eax),%al
  801853:	3c 2b                	cmp    $0x2b,%al
  801855:	75 05                	jne    80185c <strtol+0x39>
		s++;
  801857:	ff 45 08             	incl   0x8(%ebp)
  80185a:	eb 13                	jmp    80186f <strtol+0x4c>
	else if (*s == '-')
  80185c:	8b 45 08             	mov    0x8(%ebp),%eax
  80185f:	8a 00                	mov    (%eax),%al
  801861:	3c 2d                	cmp    $0x2d,%al
  801863:	75 0a                	jne    80186f <strtol+0x4c>
		s++, neg = 1;
  801865:	ff 45 08             	incl   0x8(%ebp)
  801868:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80186f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801873:	74 06                	je     80187b <strtol+0x58>
  801875:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801879:	75 20                	jne    80189b <strtol+0x78>
  80187b:	8b 45 08             	mov    0x8(%ebp),%eax
  80187e:	8a 00                	mov    (%eax),%al
  801880:	3c 30                	cmp    $0x30,%al
  801882:	75 17                	jne    80189b <strtol+0x78>
  801884:	8b 45 08             	mov    0x8(%ebp),%eax
  801887:	40                   	inc    %eax
  801888:	8a 00                	mov    (%eax),%al
  80188a:	3c 78                	cmp    $0x78,%al
  80188c:	75 0d                	jne    80189b <strtol+0x78>
		s += 2, base = 16;
  80188e:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801892:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801899:	eb 28                	jmp    8018c3 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80189b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80189f:	75 15                	jne    8018b6 <strtol+0x93>
  8018a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a4:	8a 00                	mov    (%eax),%al
  8018a6:	3c 30                	cmp    $0x30,%al
  8018a8:	75 0c                	jne    8018b6 <strtol+0x93>
		s++, base = 8;
  8018aa:	ff 45 08             	incl   0x8(%ebp)
  8018ad:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8018b4:	eb 0d                	jmp    8018c3 <strtol+0xa0>
	else if (base == 0)
  8018b6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8018ba:	75 07                	jne    8018c3 <strtol+0xa0>
		base = 10;
  8018bc:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8018c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c6:	8a 00                	mov    (%eax),%al
  8018c8:	3c 2f                	cmp    $0x2f,%al
  8018ca:	7e 19                	jle    8018e5 <strtol+0xc2>
  8018cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cf:	8a 00                	mov    (%eax),%al
  8018d1:	3c 39                	cmp    $0x39,%al
  8018d3:	7f 10                	jg     8018e5 <strtol+0xc2>
			dig = *s - '0';
  8018d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d8:	8a 00                	mov    (%eax),%al
  8018da:	0f be c0             	movsbl %al,%eax
  8018dd:	83 e8 30             	sub    $0x30,%eax
  8018e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018e3:	eb 42                	jmp    801927 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8018e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e8:	8a 00                	mov    (%eax),%al
  8018ea:	3c 60                	cmp    $0x60,%al
  8018ec:	7e 19                	jle    801907 <strtol+0xe4>
  8018ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f1:	8a 00                	mov    (%eax),%al
  8018f3:	3c 7a                	cmp    $0x7a,%al
  8018f5:	7f 10                	jg     801907 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8018f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fa:	8a 00                	mov    (%eax),%al
  8018fc:	0f be c0             	movsbl %al,%eax
  8018ff:	83 e8 57             	sub    $0x57,%eax
  801902:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801905:	eb 20                	jmp    801927 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801907:	8b 45 08             	mov    0x8(%ebp),%eax
  80190a:	8a 00                	mov    (%eax),%al
  80190c:	3c 40                	cmp    $0x40,%al
  80190e:	7e 39                	jle    801949 <strtol+0x126>
  801910:	8b 45 08             	mov    0x8(%ebp),%eax
  801913:	8a 00                	mov    (%eax),%al
  801915:	3c 5a                	cmp    $0x5a,%al
  801917:	7f 30                	jg     801949 <strtol+0x126>
			dig = *s - 'A' + 10;
  801919:	8b 45 08             	mov    0x8(%ebp),%eax
  80191c:	8a 00                	mov    (%eax),%al
  80191e:	0f be c0             	movsbl %al,%eax
  801921:	83 e8 37             	sub    $0x37,%eax
  801924:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801927:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80192a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80192d:	7d 19                	jge    801948 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80192f:	ff 45 08             	incl   0x8(%ebp)
  801932:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801935:	0f af 45 10          	imul   0x10(%ebp),%eax
  801939:	89 c2                	mov    %eax,%edx
  80193b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80193e:	01 d0                	add    %edx,%eax
  801940:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801943:	e9 7b ff ff ff       	jmp    8018c3 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801948:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801949:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80194d:	74 08                	je     801957 <strtol+0x134>
		*endptr = (char *) s;
  80194f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801952:	8b 55 08             	mov    0x8(%ebp),%edx
  801955:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801957:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80195b:	74 07                	je     801964 <strtol+0x141>
  80195d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801960:	f7 d8                	neg    %eax
  801962:	eb 03                	jmp    801967 <strtol+0x144>
  801964:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801967:	c9                   	leave  
  801968:	c3                   	ret    

00801969 <ltostr>:

void
ltostr(long value, char *str)
{
  801969:	55                   	push   %ebp
  80196a:	89 e5                	mov    %esp,%ebp
  80196c:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80196f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801976:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80197d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801981:	79 13                	jns    801996 <ltostr+0x2d>
	{
		neg = 1;
  801983:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80198a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80198d:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801990:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801993:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801996:	8b 45 08             	mov    0x8(%ebp),%eax
  801999:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80199e:	99                   	cltd   
  80199f:	f7 f9                	idiv   %ecx
  8019a1:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8019a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019a7:	8d 50 01             	lea    0x1(%eax),%edx
  8019aa:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8019ad:	89 c2                	mov    %eax,%edx
  8019af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019b2:	01 d0                	add    %edx,%eax
  8019b4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8019b7:	83 c2 30             	add    $0x30,%edx
  8019ba:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8019bc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019bf:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8019c4:	f7 e9                	imul   %ecx
  8019c6:	c1 fa 02             	sar    $0x2,%edx
  8019c9:	89 c8                	mov    %ecx,%eax
  8019cb:	c1 f8 1f             	sar    $0x1f,%eax
  8019ce:	29 c2                	sub    %eax,%edx
  8019d0:	89 d0                	mov    %edx,%eax
  8019d2:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8019d5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8019d9:	75 bb                	jne    801996 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8019db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8019e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019e5:	48                   	dec    %eax
  8019e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8019e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8019ed:	74 3d                	je     801a2c <ltostr+0xc3>
		start = 1 ;
  8019ef:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8019f6:	eb 34                	jmp    801a2c <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8019f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019fe:	01 d0                	add    %edx,%eax
  801a00:	8a 00                	mov    (%eax),%al
  801a02:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801a05:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a08:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a0b:	01 c2                	add    %eax,%edx
  801a0d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801a10:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a13:	01 c8                	add    %ecx,%eax
  801a15:	8a 00                	mov    (%eax),%al
  801a17:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801a19:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a1f:	01 c2                	add    %eax,%edx
  801a21:	8a 45 eb             	mov    -0x15(%ebp),%al
  801a24:	88 02                	mov    %al,(%edx)
		start++ ;
  801a26:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801a29:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801a2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a2f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a32:	7c c4                	jl     8019f8 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801a34:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801a37:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a3a:	01 d0                	add    %edx,%eax
  801a3c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801a3f:	90                   	nop
  801a40:	c9                   	leave  
  801a41:	c3                   	ret    

00801a42 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801a42:	55                   	push   %ebp
  801a43:	89 e5                	mov    %esp,%ebp
  801a45:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801a48:	ff 75 08             	pushl  0x8(%ebp)
  801a4b:	e8 73 fa ff ff       	call   8014c3 <strlen>
  801a50:	83 c4 04             	add    $0x4,%esp
  801a53:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801a56:	ff 75 0c             	pushl  0xc(%ebp)
  801a59:	e8 65 fa ff ff       	call   8014c3 <strlen>
  801a5e:	83 c4 04             	add    $0x4,%esp
  801a61:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801a64:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801a6b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801a72:	eb 17                	jmp    801a8b <strcconcat+0x49>
		final[s] = str1[s] ;
  801a74:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a77:	8b 45 10             	mov    0x10(%ebp),%eax
  801a7a:	01 c2                	add    %eax,%edx
  801a7c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a82:	01 c8                	add    %ecx,%eax
  801a84:	8a 00                	mov    (%eax),%al
  801a86:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801a88:	ff 45 fc             	incl   -0x4(%ebp)
  801a8b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a8e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801a91:	7c e1                	jl     801a74 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801a93:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801a9a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801aa1:	eb 1f                	jmp    801ac2 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801aa3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801aa6:	8d 50 01             	lea    0x1(%eax),%edx
  801aa9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801aac:	89 c2                	mov    %eax,%edx
  801aae:	8b 45 10             	mov    0x10(%ebp),%eax
  801ab1:	01 c2                	add    %eax,%edx
  801ab3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801ab6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ab9:	01 c8                	add    %ecx,%eax
  801abb:	8a 00                	mov    (%eax),%al
  801abd:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801abf:	ff 45 f8             	incl   -0x8(%ebp)
  801ac2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ac5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801ac8:	7c d9                	jl     801aa3 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801aca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801acd:	8b 45 10             	mov    0x10(%ebp),%eax
  801ad0:	01 d0                	add    %edx,%eax
  801ad2:	c6 00 00             	movb   $0x0,(%eax)
}
  801ad5:	90                   	nop
  801ad6:	c9                   	leave  
  801ad7:	c3                   	ret    

00801ad8 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801ad8:	55                   	push   %ebp
  801ad9:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801adb:	8b 45 14             	mov    0x14(%ebp),%eax
  801ade:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801ae4:	8b 45 14             	mov    0x14(%ebp),%eax
  801ae7:	8b 00                	mov    (%eax),%eax
  801ae9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801af0:	8b 45 10             	mov    0x10(%ebp),%eax
  801af3:	01 d0                	add    %edx,%eax
  801af5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801afb:	eb 0c                	jmp    801b09 <strsplit+0x31>
			*string++ = 0;
  801afd:	8b 45 08             	mov    0x8(%ebp),%eax
  801b00:	8d 50 01             	lea    0x1(%eax),%edx
  801b03:	89 55 08             	mov    %edx,0x8(%ebp)
  801b06:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801b09:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0c:	8a 00                	mov    (%eax),%al
  801b0e:	84 c0                	test   %al,%al
  801b10:	74 18                	je     801b2a <strsplit+0x52>
  801b12:	8b 45 08             	mov    0x8(%ebp),%eax
  801b15:	8a 00                	mov    (%eax),%al
  801b17:	0f be c0             	movsbl %al,%eax
  801b1a:	50                   	push   %eax
  801b1b:	ff 75 0c             	pushl  0xc(%ebp)
  801b1e:	e8 32 fb ff ff       	call   801655 <strchr>
  801b23:	83 c4 08             	add    $0x8,%esp
  801b26:	85 c0                	test   %eax,%eax
  801b28:	75 d3                	jne    801afd <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2d:	8a 00                	mov    (%eax),%al
  801b2f:	84 c0                	test   %al,%al
  801b31:	74 5a                	je     801b8d <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801b33:	8b 45 14             	mov    0x14(%ebp),%eax
  801b36:	8b 00                	mov    (%eax),%eax
  801b38:	83 f8 0f             	cmp    $0xf,%eax
  801b3b:	75 07                	jne    801b44 <strsplit+0x6c>
		{
			return 0;
  801b3d:	b8 00 00 00 00       	mov    $0x0,%eax
  801b42:	eb 66                	jmp    801baa <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801b44:	8b 45 14             	mov    0x14(%ebp),%eax
  801b47:	8b 00                	mov    (%eax),%eax
  801b49:	8d 48 01             	lea    0x1(%eax),%ecx
  801b4c:	8b 55 14             	mov    0x14(%ebp),%edx
  801b4f:	89 0a                	mov    %ecx,(%edx)
  801b51:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b58:	8b 45 10             	mov    0x10(%ebp),%eax
  801b5b:	01 c2                	add    %eax,%edx
  801b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b60:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801b62:	eb 03                	jmp    801b67 <strsplit+0x8f>
			string++;
  801b64:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801b67:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6a:	8a 00                	mov    (%eax),%al
  801b6c:	84 c0                	test   %al,%al
  801b6e:	74 8b                	je     801afb <strsplit+0x23>
  801b70:	8b 45 08             	mov    0x8(%ebp),%eax
  801b73:	8a 00                	mov    (%eax),%al
  801b75:	0f be c0             	movsbl %al,%eax
  801b78:	50                   	push   %eax
  801b79:	ff 75 0c             	pushl  0xc(%ebp)
  801b7c:	e8 d4 fa ff ff       	call   801655 <strchr>
  801b81:	83 c4 08             	add    $0x8,%esp
  801b84:	85 c0                	test   %eax,%eax
  801b86:	74 dc                	je     801b64 <strsplit+0x8c>
			string++;
	}
  801b88:	e9 6e ff ff ff       	jmp    801afb <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801b8d:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801b8e:	8b 45 14             	mov    0x14(%ebp),%eax
  801b91:	8b 00                	mov    (%eax),%eax
  801b93:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b9a:	8b 45 10             	mov    0x10(%ebp),%eax
  801b9d:	01 d0                	add    %edx,%eax
  801b9f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801ba5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801baa:	c9                   	leave  
  801bab:	c3                   	ret    

00801bac <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801bac:	55                   	push   %ebp
  801bad:	89 e5                	mov    %esp,%ebp
  801baf:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801bb2:	83 ec 04             	sub    $0x4,%esp
  801bb5:	68 5c 46 80 00       	push   $0x80465c
  801bba:	68 3f 01 00 00       	push   $0x13f
  801bbf:	68 7e 46 80 00       	push   $0x80467e
  801bc4:	e8 f7 1f 00 00       	call   803bc0 <_panic>

00801bc9 <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  801bc9:	55                   	push   %ebp
  801bca:	89 e5                	mov    %esp,%ebp
  801bcc:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801bcf:	83 ec 0c             	sub    $0xc,%esp
  801bd2:	ff 75 08             	pushl  0x8(%ebp)
  801bd5:	e8 90 0c 00 00       	call   80286a <sys_sbrk>
  801bda:	83 c4 10             	add    $0x10,%esp
}
  801bdd:	c9                   	leave  
  801bde:	c3                   	ret    

00801bdf <malloc>:
#define num_of_page ((USER_HEAP_MAX - USER_HEAP_START) / PAGE_SIZE)

int pagesAllocated[num_of_page] = { 0 };
int shardIDs[num_of_page] = { 0 };
bool markedPages[num_of_page] = { 0 };
void* malloc(uint32 size) {
  801bdf:	55                   	push   %ebp
  801be0:	89 e5                	mov    %esp,%ebp
  801be2:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  801be5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801be9:	75 0a                	jne    801bf5 <malloc+0x16>
		return NULL;
  801beb:	b8 00 00 00 00       	mov    $0x0,%eax
  801bf0:	e9 9e 01 00 00       	jmp    801d93 <malloc+0x1b4>

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

	//  our new code
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  801bf5:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801bfc:	77 2c                	ja     801c2a <malloc+0x4b>
		if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  801bfe:	e8 eb 0a 00 00       	call   8026ee <sys_isUHeapPlacementStrategyFIRSTFIT>
  801c03:	85 c0                	test   %eax,%eax
  801c05:	74 19                	je     801c20 <malloc+0x41>

			void * block = alloc_block_FF(size);
  801c07:	83 ec 0c             	sub    $0xc,%esp
  801c0a:	ff 75 08             	pushl  0x8(%ebp)
  801c0d:	e8 85 11 00 00       	call   802d97 <alloc_block_FF>
  801c12:	83 c4 10             	add    $0x10,%esp
  801c15:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			return block;
  801c18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c1b:	e9 73 01 00 00       	jmp    801d93 <malloc+0x1b4>
		} else {
			return NULL;
  801c20:	b8 00 00 00 00       	mov    $0x0,%eax
  801c25:	e9 69 01 00 00       	jmp    801d93 <malloc+0x1b4>
		}
	}

	uint32 numOfPages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801c2a:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801c31:	8b 55 08             	mov    0x8(%ebp),%edx
  801c34:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c37:	01 d0                	add    %edx,%eax
  801c39:	48                   	dec    %eax
  801c3a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801c3d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c40:	ba 00 00 00 00       	mov    $0x0,%edx
  801c45:	f7 75 e0             	divl   -0x20(%ebp)
  801c48:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c4b:	29 d0                	sub    %edx,%eax
  801c4d:	c1 e8 0c             	shr    $0xc,%eax
  801c50:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 freePagesCount = 0;
  801c53:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801c5a:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  801c61:	a1 20 50 80 00       	mov    0x805020,%eax
  801c66:	8b 40 7c             	mov    0x7c(%eax),%eax
  801c69:	05 00 10 00 00       	add    $0x1000,%eax
  801c6e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  801c71:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801c76:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801c79:	89 45 d0             	mov    %eax,-0x30(%ebp)

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  801c7c:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  801c83:	8b 55 08             	mov    0x8(%ebp),%edx
  801c86:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801c89:	01 d0                	add    %edx,%eax
  801c8b:	48                   	dec    %eax
  801c8c:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801c8f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801c92:	ba 00 00 00 00       	mov    $0x0,%edx
  801c97:	f7 75 cc             	divl   -0x34(%ebp)
  801c9a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801c9d:	29 d0                	sub    %edx,%eax
  801c9f:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801ca2:	76 0a                	jbe    801cae <malloc+0xcf>
		return NULL;
  801ca4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ca9:	e9 e5 00 00 00       	jmp    801d93 <malloc+0x1b4>
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  801cae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801cb1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801cb4:	eb 48                	jmp    801cfe <malloc+0x11f>
	{
		uint32 idx = (i - currentAddr) / PAGE_SIZE;
  801cb6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cb9:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801cbc:	c1 e8 0c             	shr    $0xc,%eax
  801cbf:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if (!markedPages[idx]) {
  801cc2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801cc5:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  801ccc:	85 c0                	test   %eax,%eax
  801cce:	75 11                	jne    801ce1 <malloc+0x102>
			freePagesCount++;
  801cd0:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801cd3:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801cd7:	75 16                	jne    801cef <malloc+0x110>
				start = i;
  801cd9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cdc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801cdf:	eb 0e                	jmp    801cef <malloc+0x110>
			}
		} else {
			freePagesCount = 0;
  801ce1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  801ce8:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == numOfPages) {
  801cef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cf2:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801cf5:	74 12                	je     801d09 <malloc+0x12a>

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  801cf7:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801cfe:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801d05:	76 af                	jbe    801cb6 <malloc+0xd7>
  801d07:	eb 01                	jmp    801d0a <malloc+0x12b>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == numOfPages) {
			break;
  801d09:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
  801d0a:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801d0e:	74 08                	je     801d18 <malloc+0x139>
  801d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d13:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801d16:	74 07                	je     801d1f <malloc+0x140>
		return NULL;
  801d18:	b8 00 00 00 00       	mov    $0x0,%eax
  801d1d:	eb 74                	jmp    801d93 <malloc+0x1b4>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  801d1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d22:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801d25:	c1 e8 0c             	shr    $0xc,%eax
  801d28:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numOfPages;
  801d2b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801d2e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801d31:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  801d38:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801d3b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801d3e:	eb 11                	jmp    801d51 <malloc+0x172>
		markedPages[i] = 1;
  801d40:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d43:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  801d4a:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = numOfPages;
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  801d4e:	ff 45 e8             	incl   -0x18(%ebp)
  801d51:	8b 55 c0             	mov    -0x40(%ebp),%edx
  801d54:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d57:	01 d0                	add    %edx,%eax
  801d59:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801d5c:	77 e2                	ja     801d40 <malloc+0x161>
		markedPages[i] = 1;
	}

	sys_allocate_user_mem(start, ROUNDUP(size, PAGE_SIZE));
  801d5e:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801d65:	8b 55 08             	mov    0x8(%ebp),%edx
  801d68:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801d6b:	01 d0                	add    %edx,%eax
  801d6d:	48                   	dec    %eax
  801d6e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801d71:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801d74:	ba 00 00 00 00       	mov    $0x0,%edx
  801d79:	f7 75 bc             	divl   -0x44(%ebp)
  801d7c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801d7f:	29 d0                	sub    %edx,%eax
  801d81:	83 ec 08             	sub    $0x8,%esp
  801d84:	50                   	push   %eax
  801d85:	ff 75 f0             	pushl  -0x10(%ebp)
  801d88:	e8 14 0b 00 00       	call   8028a1 <sys_allocate_user_mem>
  801d8d:	83 c4 10             	add    $0x10,%esp
	return (void*) start;
  801d90:	8b 45 f0             	mov    -0x10(%ebp),%eax

}
  801d93:	c9                   	leave  
  801d94:	c3                   	ret    

00801d95 <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address) {
  801d95:	55                   	push   %ebp
  801d96:	89 e5                	mov    %esp,%ebp
  801d98:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
  801d9b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d9f:	0f 84 ee 00 00 00    	je     801e93 <free+0xfe>
		return;
	}

	if (virtual_address
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  801da5:	a1 20 50 80 00       	mov    0x805020,%eax
  801daa:	8b 40 74             	mov    0x74(%eax),%eax

	if (virtual_address == NULL) {
		return;
	}

	if (virtual_address
  801dad:	3b 45 08             	cmp    0x8(%ebp),%eax
  801db0:	77 09                	ja     801dbb <free+0x26>
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  801db2:	81 7d 08 00 00 00 a0 	cmpl   $0xa0000000,0x8(%ebp)
  801db9:	76 14                	jbe    801dcf <free+0x3a>
		panic("INVALID VIRTUAL ADDRESS!!");
  801dbb:	83 ec 04             	sub    $0x4,%esp
  801dbe:	68 8c 46 80 00       	push   $0x80468c
  801dc3:	6a 68                	push   $0x68
  801dc5:	68 a6 46 80 00       	push   $0x8046a6
  801dca:	e8 f1 1d 00 00       	call   803bc0 <_panic>
	}
	if (virtual_address >= (void *) (myEnv->uheapStart)
  801dcf:	a1 20 50 80 00       	mov    0x805020,%eax
  801dd4:	8b 40 74             	mov    0x74(%eax),%eax
  801dd7:	3b 45 08             	cmp    0x8(%ebp),%eax
  801dda:	77 20                	ja     801dfc <free+0x67>
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
  801ddc:	a1 20 50 80 00       	mov    0x805020,%eax
  801de1:	8b 40 78             	mov    0x78(%eax),%eax
  801de4:	3b 45 08             	cmp    0x8(%ebp),%eax
  801de7:	76 13                	jbe    801dfc <free+0x67>
		free_block(virtual_address);
  801de9:	83 ec 0c             	sub    $0xc,%esp
  801dec:	ff 75 08             	pushl  0x8(%ebp)
  801def:	e8 6c 16 00 00       	call   803460 <free_block>
  801df4:	83 c4 10             	add    $0x10,%esp
		return;
  801df7:	e9 98 00 00 00       	jmp    801e94 <free+0xff>
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  801dfc:	8b 55 08             	mov    0x8(%ebp),%edx
  801dff:	a1 20 50 80 00       	mov    0x805020,%eax
  801e04:	8b 40 7c             	mov    0x7c(%eax),%eax
  801e07:	29 c2                	sub    %eax,%edx
  801e09:	89 d0                	mov    %edx,%eax
  801e0b:	2d 00 10 00 00       	sub    $0x1000,%eax
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
		free_block(virtual_address);
		return;
	}

	uint32 pageIdx = ((uint32) virtual_address
  801e10:	c1 e8 0c             	shr    $0xc,%eax
  801e13:	89 45 ec             	mov    %eax,-0x14(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  801e16:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801e1d:	eb 16                	jmp    801e35 <free+0xa0>
		markedPages[idx + pageIdx] = 0;
  801e1f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e25:	01 d0                	add    %edx,%eax
  801e27:	c7 04 85 40 50 90 00 	movl   $0x0,0x905040(,%eax,4)
  801e2e:	00 00 00 00 
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  801e32:	ff 45 f4             	incl   -0xc(%ebp)
  801e35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e38:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  801e3f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801e42:	7f db                	jg     801e1f <free+0x8a>
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;
  801e44:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e47:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  801e4e:	c1 e0 0c             	shl    $0xc,%eax
  801e51:	89 45 e8             	mov    %eax,-0x18(%ebp)

	for (uint32 i = (uint32) virtual_address;
  801e54:	8b 45 08             	mov    0x8(%ebp),%eax
  801e57:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e5a:	eb 1a                	jmp    801e76 <free+0xe1>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
  801e5c:	83 ec 08             	sub    $0x8,%esp
  801e5f:	68 00 10 00 00       	push   $0x1000
  801e64:	ff 75 f0             	pushl  -0x10(%ebp)
  801e67:	e8 19 0a 00 00       	call   802885 <sys_free_user_mem>
  801e6c:	83 c4 10             	add    $0x10,%esp
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
  801e6f:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  801e76:	8b 55 08             	mov    0x8(%ebp),%edx
  801e79:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e7c:	01 d0                	add    %edx,%eax
	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
  801e7e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801e81:	77 d9                	ja     801e5c <free+0xc7>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;
  801e83:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e86:	c7 04 85 40 50 80 00 	movl   $0x0,0x805040(,%eax,4)
  801e8d:	00 00 00 00 
  801e91:	eb 01                	jmp    801e94 <free+0xff>
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
		return;
  801e93:	90                   	nop
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;

}
  801e94:	c9                   	leave  
  801e95:	c3                   	ret    

00801e96 <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  801e96:	55                   	push   %ebp
  801e97:	89 e5                	mov    %esp,%ebp
  801e99:	83 ec 58             	sub    $0x58,%esp
  801e9c:	8b 45 10             	mov    0x10(%ebp),%eax
  801e9f:	88 45 b4             	mov    %al,-0x4c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  801ea2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ea6:	75 0a                	jne    801eb2 <smalloc+0x1c>
		return NULL;
  801ea8:	b8 00 00 00 00       	mov    $0x0,%eax
  801ead:	e9 7d 01 00 00       	jmp    80202f <smalloc+0x199>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	uint32 num_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801eb2:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  801eb9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ebc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ebf:	01 d0                	add    %edx,%eax
  801ec1:	48                   	dec    %eax
  801ec2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801ec5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ec8:	ba 00 00 00 00       	mov    $0x0,%edx
  801ecd:	f7 75 e4             	divl   -0x1c(%ebp)
  801ed0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ed3:	29 d0                	sub    %edx,%eax
  801ed5:	c1 e8 0c             	shr    $0xc,%eax
  801ed8:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 freePagesCount = 0;
  801edb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801ee2:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  801ee9:	a1 20 50 80 00       	mov    0x805020,%eax
  801eee:	8b 40 7c             	mov    0x7c(%eax),%eax
  801ef1:	05 00 10 00 00       	add    $0x1000,%eax
  801ef6:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  801ef9:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801efe:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801f01:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  801f04:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801f0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f0e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801f11:	01 d0                	add    %edx,%eax
  801f13:	48                   	dec    %eax
  801f14:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801f17:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801f1a:	ba 00 00 00 00       	mov    $0x0,%edx
  801f1f:	f7 75 d0             	divl   -0x30(%ebp)
  801f22:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801f25:	29 d0                	sub    %edx,%eax
  801f27:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801f2a:	76 0a                	jbe    801f36 <smalloc+0xa0>
		return NULL;
  801f2c:	b8 00 00 00 00       	mov    $0x0,%eax
  801f31:	e9 f9 00 00 00       	jmp    80202f <smalloc+0x199>
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801f36:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801f39:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801f3c:	eb 48                	jmp    801f86 <smalloc+0xf0>
		uint32 idx = (s - currentAddr) / PAGE_SIZE;
  801f3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f41:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801f44:	c1 e8 0c             	shr    $0xc,%eax
  801f47:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (!markedPages[idx]) {
  801f4a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801f4d:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  801f54:	85 c0                	test   %eax,%eax
  801f56:	75 11                	jne    801f69 <smalloc+0xd3>
			freePagesCount++;
  801f58:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801f5b:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801f5f:	75 16                	jne    801f77 <smalloc+0xe1>
				start = s;
  801f61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f64:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f67:	eb 0e                	jmp    801f77 <smalloc+0xe1>
			}
		} else {
			freePagesCount = 0;
  801f69:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  801f70:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == num_Of_Pages) {
  801f77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7a:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801f7d:	74 12                	je     801f91 <smalloc+0xfb>
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801f7f:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801f86:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801f8d:	76 af                	jbe    801f3e <smalloc+0xa8>
  801f8f:	eb 01                	jmp    801f92 <smalloc+0xfc>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == num_Of_Pages) {
			break;
  801f91:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
  801f92:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801f96:	74 08                	je     801fa0 <smalloc+0x10a>
  801f98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9b:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801f9e:	74 0a                	je     801faa <smalloc+0x114>
		return NULL;
  801fa0:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa5:	e9 85 00 00 00       	jmp    80202f <smalloc+0x199>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  801faa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fad:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801fb0:	c1 e8 0c             	shr    $0xc,%eax
  801fb3:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	pagesAllocated[startPage] = num_Of_Pages;
  801fb6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801fb9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801fbc:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  801fc3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801fc6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801fc9:	eb 11                	jmp    801fdc <smalloc+0x146>
		markedPages[s] = 1;
  801fcb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fce:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  801fd5:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = num_Of_Pages;
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  801fd9:	ff 45 e8             	incl   -0x18(%ebp)
  801fdc:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801fdf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801fe2:	01 d0                	add    %edx,%eax
  801fe4:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801fe7:	77 e2                	ja     801fcb <smalloc+0x135>
		markedPages[s] = 1;
	}
	int sharedobjID = sys_createSharedObject(sharedVarName, size, isWritable,
  801fe9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fec:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
  801ff0:	52                   	push   %edx
  801ff1:	50                   	push   %eax
  801ff2:	ff 75 0c             	pushl  0xc(%ebp)
  801ff5:	ff 75 08             	pushl  0x8(%ebp)
  801ff8:	e8 8f 04 00 00       	call   80248c <sys_createSharedObject>
  801ffd:	83 c4 10             	add    $0x10,%esp
  802000:	89 45 c0             	mov    %eax,-0x40(%ebp)
			(void*) start);

	if (sharedobjID >= 0) {
  802003:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  802007:	78 12                	js     80201b <smalloc+0x185>
		shardIDs[startPage] = sharedobjID;
  802009:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80200c:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80200f:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  802016:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802019:	eb 14                	jmp    80202f <smalloc+0x199>
	}
	free((void*) start);
  80201b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80201e:	83 ec 0c             	sub    $0xc,%esp
  802021:	50                   	push   %eax
  802022:	e8 6e fd ff ff       	call   801d95 <free>
  802027:	83 c4 10             	add    $0x10,%esp
	return NULL;
  80202a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80202f:	c9                   	leave  
  802030:	c3                   	ret    

00802031 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  802031:	55                   	push   %ebp
  802032:	89 e5                	mov    %esp,%ebp
  802034:	83 ec 48             	sub    $0x48,%esp
	//cprintf("SSSSSGEEETTT\n");
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID, sharedVarName);
  802037:	83 ec 08             	sub    $0x8,%esp
  80203a:	ff 75 0c             	pushl  0xc(%ebp)
  80203d:	ff 75 08             	pushl  0x8(%ebp)
  802040:	e8 71 04 00 00       	call   8024b6 <sys_getSizeOfSharedObject>
  802045:	83 c4 10             	add    $0x10,%esp
  802048:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (size < 0)
		return NULL;
	uint32 numb_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  80204b:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802052:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802055:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802058:	01 d0                	add    %edx,%eax
  80205a:	48                   	dec    %eax
  80205b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80205e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802061:	ba 00 00 00 00       	mov    $0x0,%edx
  802066:	f7 75 e0             	divl   -0x20(%ebp)
  802069:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80206c:	29 d0                	sub    %edx,%eax
  80206e:	c1 e8 0c             	shr    $0xc,%eax
  802071:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 free_Pages_Count = 0;
  802074:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  80207b:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
  802082:	a1 20 50 80 00       	mov    0x805020,%eax
  802087:	8b 40 7c             	mov    0x7c(%eax),%eax
  80208a:	05 00 10 00 00       	add    $0x1000,%eax
  80208f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
  802092:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  802097:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80209a:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
  80209d:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8020a4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8020a7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8020aa:	01 d0                	add    %edx,%eax
  8020ac:	48                   	dec    %eax
  8020ad:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8020b0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8020b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8020b8:	f7 75 cc             	divl   -0x34(%ebp)
  8020bb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8020be:	29 d0                	sub    %edx,%eax
  8020c0:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8020c3:	76 0a                	jbe    8020cf <sget+0x9e>
		return NULL;
  8020c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ca:	e9 f7 00 00 00       	jmp    8021c6 <sget+0x195>
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  8020cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8020d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8020d5:	eb 48                	jmp    80211f <sget+0xee>
		uint32 idx = (s - current_Addr) / PAGE_SIZE;
  8020d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020da:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8020dd:	c1 e8 0c             	shr    $0xc,%eax
  8020e0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if (!markedPages[idx]) {
  8020e3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8020e6:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  8020ed:	85 c0                	test   %eax,%eax
  8020ef:	75 11                	jne    802102 <sget+0xd1>
			free_Pages_Count++;
  8020f1:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  8020f4:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8020f8:	75 16                	jne    802110 <sget+0xdf>
				start = s;
  8020fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802100:	eb 0e                	jmp    802110 <sget+0xdf>
			}
		} else {
			free_Pages_Count = 0;
  802102:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  802109:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (free_Pages_Count == numb_Of_Pages) {
  802110:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802113:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  802116:	74 12                	je     80212a <sget+0xf9>
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
		return NULL;
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  802118:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  80211f:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  802126:	76 af                	jbe    8020d7 <sget+0xa6>
  802128:	eb 01                	jmp    80212b <sget+0xfa>
		} else {
			free_Pages_Count = 0;
			start = (uint32) -1;
		}
		if (free_Pages_Count == numb_Of_Pages) {
			break;
  80212a:	90                   	nop
		}
	}
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
  80212b:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80212f:	74 08                	je     802139 <sget+0x108>
  802131:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802134:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  802137:	74 0a                	je     802143 <sget+0x112>
		return NULL;
  802139:	b8 00 00 00 00       	mov    $0x0,%eax
  80213e:	e9 83 00 00 00       	jmp    8021c6 <sget+0x195>
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
  802143:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802146:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  802149:	c1 e8 0c             	shr    $0xc,%eax
  80214c:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numb_Of_Pages;
  80214f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802152:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802155:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  80215c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80215f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802162:	eb 11                	jmp    802175 <sget+0x144>
		markedPages[k] = 1;
  802164:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802167:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  80216e:	01 00 00 00 
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
	pagesAllocated[startPage] = numb_Of_Pages;
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  802172:	ff 45 e8             	incl   -0x18(%ebp)
  802175:	8b 55 c0             	mov    -0x40(%ebp),%edx
  802178:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80217b:	01 d0                	add    %edx,%eax
  80217d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802180:	77 e2                	ja     802164 <sget+0x133>
		markedPages[k] = 1;
	}
	int ss = sys_getSharedObject(ownerEnvID, sharedVarName, (void*) start);
  802182:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802185:	83 ec 04             	sub    $0x4,%esp
  802188:	50                   	push   %eax
  802189:	ff 75 0c             	pushl  0xc(%ebp)
  80218c:	ff 75 08             	pushl  0x8(%ebp)
  80218f:	e8 3f 03 00 00       	call   8024d3 <sys_getSharedObject>
  802194:	83 c4 10             	add    $0x10,%esp
  802197:	89 45 bc             	mov    %eax,-0x44(%ebp)
	if (ss >= 0) {
  80219a:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  80219e:	78 12                	js     8021b2 <sget+0x181>
		shardIDs[startPage] = ss;
  8021a0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8021a3:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8021a6:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  8021ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021b0:	eb 14                	jmp    8021c6 <sget+0x195>
	}
	free((void*) start);
  8021b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021b5:	83 ec 0c             	sub    $0xc,%esp
  8021b8:	50                   	push   %eax
  8021b9:	e8 d7 fb ff ff       	call   801d95 <free>
  8021be:	83 c4 10             	add    $0x10,%esp
	return NULL;
  8021c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021c6:	c9                   	leave  
  8021c7:	c3                   	ret    

008021c8 <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  8021c8:	55                   	push   %ebp
  8021c9:	89 e5                	mov    %esp,%ebp
  8021cb:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  8021ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8021d1:	a1 20 50 80 00       	mov    0x805020,%eax
  8021d6:	8b 40 7c             	mov    0x7c(%eax),%eax
  8021d9:	29 c2                	sub    %eax,%edx
  8021db:	89 d0                	mov    %edx,%eax
  8021dd:	2d 00 10 00 00       	sub    $0x1000,%eax

void sfree(void* virtual_address) {
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
  8021e2:	c1 e8 0c             	shr    $0xc,%eax
  8021e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
	int id = shardIDs[pageIdx];
  8021e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021eb:	8b 04 85 40 50 88 00 	mov    0x885040(,%eax,4),%eax
  8021f2:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int result = sys_freeSharedObject(id, virtual_address);
  8021f5:	83 ec 08             	sub    $0x8,%esp
  8021f8:	ff 75 08             	pushl  0x8(%ebp)
  8021fb:	ff 75 f0             	pushl  -0x10(%ebp)
  8021fe:	e8 ef 02 00 00       	call   8024f2 <sys_freeSharedObject>
  802203:	83 c4 10             	add    $0x10,%esp
  802206:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (result == 0) {
  802209:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80220d:	75 0e                	jne    80221d <sfree+0x55>
		shardIDs[pageIdx] = -1;  // Reset the ID after freeing
  80220f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802212:	c7 04 85 40 50 88 00 	movl   $0xffffffff,0x885040(,%eax,4)
  802219:	ff ff ff ff 
	}

}
  80221d:	90                   	nop
  80221e:	c9                   	leave  
  80221f:	c3                   	ret    

00802220 <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  802220:	55                   	push   %ebp
  802221:	89 e5                	mov    %esp,%ebp
  802223:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802226:	83 ec 04             	sub    $0x4,%esp
  802229:	68 b4 46 80 00       	push   $0x8046b4
  80222e:	68 19 01 00 00       	push   $0x119
  802233:	68 a6 46 80 00       	push   $0x8046a6
  802238:	e8 83 19 00 00       	call   803bc0 <_panic>

0080223d <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  80223d:	55                   	push   %ebp
  80223e:	89 e5                	mov    %esp,%ebp
  802240:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802243:	83 ec 04             	sub    $0x4,%esp
  802246:	68 da 46 80 00       	push   $0x8046da
  80224b:	68 23 01 00 00       	push   $0x123
  802250:	68 a6 46 80 00       	push   $0x8046a6
  802255:	e8 66 19 00 00       	call   803bc0 <_panic>

0080225a <shrink>:

}
void shrink(uint32 newSize) {
  80225a:	55                   	push   %ebp
  80225b:	89 e5                	mov    %esp,%ebp
  80225d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802260:	83 ec 04             	sub    $0x4,%esp
  802263:	68 da 46 80 00       	push   $0x8046da
  802268:	68 27 01 00 00       	push   $0x127
  80226d:	68 a6 46 80 00       	push   $0x8046a6
  802272:	e8 49 19 00 00       	call   803bc0 <_panic>

00802277 <freeHeap>:

}
void freeHeap(void* virtual_address) {
  802277:	55                   	push   %ebp
  802278:	89 e5                	mov    %esp,%ebp
  80227a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80227d:	83 ec 04             	sub    $0x4,%esp
  802280:	68 da 46 80 00       	push   $0x8046da
  802285:	68 2b 01 00 00       	push   $0x12b
  80228a:	68 a6 46 80 00       	push   $0x8046a6
  80228f:	e8 2c 19 00 00       	call   803bc0 <_panic>

00802294 <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  802294:	55                   	push   %ebp
  802295:	89 e5                	mov    %esp,%ebp
  802297:	57                   	push   %edi
  802298:	56                   	push   %esi
  802299:	53                   	push   %ebx
  80229a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80229d:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022a3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022a6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022a9:	8b 7d 18             	mov    0x18(%ebp),%edi
  8022ac:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8022af:	cd 30                	int    $0x30
  8022b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  8022b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8022b7:	83 c4 10             	add    $0x10,%esp
  8022ba:	5b                   	pop    %ebx
  8022bb:	5e                   	pop    %esi
  8022bc:	5f                   	pop    %edi
  8022bd:	5d                   	pop    %ebp
  8022be:	c3                   	ret    

008022bf <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  8022bf:	55                   	push   %ebp
  8022c0:	89 e5                	mov    %esp,%ebp
  8022c2:	83 ec 04             	sub    $0x4,%esp
  8022c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8022c8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  8022cb:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8022cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d2:	6a 00                	push   $0x0
  8022d4:	6a 00                	push   $0x0
  8022d6:	52                   	push   %edx
  8022d7:	ff 75 0c             	pushl  0xc(%ebp)
  8022da:	50                   	push   %eax
  8022db:	6a 00                	push   $0x0
  8022dd:	e8 b2 ff ff ff       	call   802294 <syscall>
  8022e2:	83 c4 18             	add    $0x18,%esp
}
  8022e5:	90                   	nop
  8022e6:	c9                   	leave  
  8022e7:	c3                   	ret    

008022e8 <sys_cgetc>:

int sys_cgetc(void) {
  8022e8:	55                   	push   %ebp
  8022e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8022eb:	6a 00                	push   $0x0
  8022ed:	6a 00                	push   $0x0
  8022ef:	6a 00                	push   $0x0
  8022f1:	6a 00                	push   $0x0
  8022f3:	6a 00                	push   $0x0
  8022f5:	6a 02                	push   $0x2
  8022f7:	e8 98 ff ff ff       	call   802294 <syscall>
  8022fc:	83 c4 18             	add    $0x18,%esp
}
  8022ff:	c9                   	leave  
  802300:	c3                   	ret    

00802301 <sys_lock_cons>:

void sys_lock_cons(void) {
  802301:	55                   	push   %ebp
  802302:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802304:	6a 00                	push   $0x0
  802306:	6a 00                	push   $0x0
  802308:	6a 00                	push   $0x0
  80230a:	6a 00                	push   $0x0
  80230c:	6a 00                	push   $0x0
  80230e:	6a 03                	push   $0x3
  802310:	e8 7f ff ff ff       	call   802294 <syscall>
  802315:	83 c4 18             	add    $0x18,%esp
}
  802318:	90                   	nop
  802319:	c9                   	leave  
  80231a:	c3                   	ret    

0080231b <sys_unlock_cons>:
void sys_unlock_cons(void) {
  80231b:	55                   	push   %ebp
  80231c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80231e:	6a 00                	push   $0x0
  802320:	6a 00                	push   $0x0
  802322:	6a 00                	push   $0x0
  802324:	6a 00                	push   $0x0
  802326:	6a 00                	push   $0x0
  802328:	6a 04                	push   $0x4
  80232a:	e8 65 ff ff ff       	call   802294 <syscall>
  80232f:	83 c4 18             	add    $0x18,%esp
}
  802332:	90                   	nop
  802333:	c9                   	leave  
  802334:	c3                   	ret    

00802335 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  802335:	55                   	push   %ebp
  802336:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  802338:	8b 55 0c             	mov    0xc(%ebp),%edx
  80233b:	8b 45 08             	mov    0x8(%ebp),%eax
  80233e:	6a 00                	push   $0x0
  802340:	6a 00                	push   $0x0
  802342:	6a 00                	push   $0x0
  802344:	52                   	push   %edx
  802345:	50                   	push   %eax
  802346:	6a 08                	push   $0x8
  802348:	e8 47 ff ff ff       	call   802294 <syscall>
  80234d:	83 c4 18             	add    $0x18,%esp
}
  802350:	c9                   	leave  
  802351:	c3                   	ret    

00802352 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  802352:	55                   	push   %ebp
  802353:	89 e5                	mov    %esp,%ebp
  802355:	56                   	push   %esi
  802356:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  802357:	8b 75 18             	mov    0x18(%ebp),%esi
  80235a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80235d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802360:	8b 55 0c             	mov    0xc(%ebp),%edx
  802363:	8b 45 08             	mov    0x8(%ebp),%eax
  802366:	56                   	push   %esi
  802367:	53                   	push   %ebx
  802368:	51                   	push   %ecx
  802369:	52                   	push   %edx
  80236a:	50                   	push   %eax
  80236b:	6a 09                	push   $0x9
  80236d:	e8 22 ff ff ff       	call   802294 <syscall>
  802372:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  802375:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802378:	5b                   	pop    %ebx
  802379:	5e                   	pop    %esi
  80237a:	5d                   	pop    %ebp
  80237b:	c3                   	ret    

0080237c <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  80237c:	55                   	push   %ebp
  80237d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80237f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802382:	8b 45 08             	mov    0x8(%ebp),%eax
  802385:	6a 00                	push   $0x0
  802387:	6a 00                	push   $0x0
  802389:	6a 00                	push   $0x0
  80238b:	52                   	push   %edx
  80238c:	50                   	push   %eax
  80238d:	6a 0a                	push   $0xa
  80238f:	e8 00 ff ff ff       	call   802294 <syscall>
  802394:	83 c4 18             	add    $0x18,%esp
}
  802397:	c9                   	leave  
  802398:	c3                   	ret    

00802399 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  802399:	55                   	push   %ebp
  80239a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  80239c:	6a 00                	push   $0x0
  80239e:	6a 00                	push   $0x0
  8023a0:	6a 00                	push   $0x0
  8023a2:	ff 75 0c             	pushl  0xc(%ebp)
  8023a5:	ff 75 08             	pushl  0x8(%ebp)
  8023a8:	6a 0b                	push   $0xb
  8023aa:	e8 e5 fe ff ff       	call   802294 <syscall>
  8023af:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  8023b2:	c9                   	leave  
  8023b3:	c3                   	ret    

008023b4 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  8023b4:	55                   	push   %ebp
  8023b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8023b7:	6a 00                	push   $0x0
  8023b9:	6a 00                	push   $0x0
  8023bb:	6a 00                	push   $0x0
  8023bd:	6a 00                	push   $0x0
  8023bf:	6a 00                	push   $0x0
  8023c1:	6a 0c                	push   $0xc
  8023c3:	e8 cc fe ff ff       	call   802294 <syscall>
  8023c8:	83 c4 18             	add    $0x18,%esp
}
  8023cb:	c9                   	leave  
  8023cc:	c3                   	ret    

008023cd <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  8023cd:	55                   	push   %ebp
  8023ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8023d0:	6a 00                	push   $0x0
  8023d2:	6a 00                	push   $0x0
  8023d4:	6a 00                	push   $0x0
  8023d6:	6a 00                	push   $0x0
  8023d8:	6a 00                	push   $0x0
  8023da:	6a 0d                	push   $0xd
  8023dc:	e8 b3 fe ff ff       	call   802294 <syscall>
  8023e1:	83 c4 18             	add    $0x18,%esp
}
  8023e4:	c9                   	leave  
  8023e5:	c3                   	ret    

008023e6 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  8023e6:	55                   	push   %ebp
  8023e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8023e9:	6a 00                	push   $0x0
  8023eb:	6a 00                	push   $0x0
  8023ed:	6a 00                	push   $0x0
  8023ef:	6a 00                	push   $0x0
  8023f1:	6a 00                	push   $0x0
  8023f3:	6a 0e                	push   $0xe
  8023f5:	e8 9a fe ff ff       	call   802294 <syscall>
  8023fa:	83 c4 18             	add    $0x18,%esp
}
  8023fd:	c9                   	leave  
  8023fe:	c3                   	ret    

008023ff <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  8023ff:	55                   	push   %ebp
  802400:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  802402:	6a 00                	push   $0x0
  802404:	6a 00                	push   $0x0
  802406:	6a 00                	push   $0x0
  802408:	6a 00                	push   $0x0
  80240a:	6a 00                	push   $0x0
  80240c:	6a 0f                	push   $0xf
  80240e:	e8 81 fe ff ff       	call   802294 <syscall>
  802413:	83 c4 18             	add    $0x18,%esp
}
  802416:	c9                   	leave  
  802417:	c3                   	ret    

00802418 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  802418:	55                   	push   %ebp
  802419:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  80241b:	6a 00                	push   $0x0
  80241d:	6a 00                	push   $0x0
  80241f:	6a 00                	push   $0x0
  802421:	6a 00                	push   $0x0
  802423:	ff 75 08             	pushl  0x8(%ebp)
  802426:	6a 10                	push   $0x10
  802428:	e8 67 fe ff ff       	call   802294 <syscall>
  80242d:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  802430:	c9                   	leave  
  802431:	c3                   	ret    

00802432 <sys_scarce_memory>:

void sys_scarce_memory() {
  802432:	55                   	push   %ebp
  802433:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  802435:	6a 00                	push   $0x0
  802437:	6a 00                	push   $0x0
  802439:	6a 00                	push   $0x0
  80243b:	6a 00                	push   $0x0
  80243d:	6a 00                	push   $0x0
  80243f:	6a 11                	push   $0x11
  802441:	e8 4e fe ff ff       	call   802294 <syscall>
  802446:	83 c4 18             	add    $0x18,%esp
}
  802449:	90                   	nop
  80244a:	c9                   	leave  
  80244b:	c3                   	ret    

0080244c <sys_cputc>:

void sys_cputc(const char c) {
  80244c:	55                   	push   %ebp
  80244d:	89 e5                	mov    %esp,%ebp
  80244f:	83 ec 04             	sub    $0x4,%esp
  802452:	8b 45 08             	mov    0x8(%ebp),%eax
  802455:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802458:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80245c:	6a 00                	push   $0x0
  80245e:	6a 00                	push   $0x0
  802460:	6a 00                	push   $0x0
  802462:	6a 00                	push   $0x0
  802464:	50                   	push   %eax
  802465:	6a 01                	push   $0x1
  802467:	e8 28 fe ff ff       	call   802294 <syscall>
  80246c:	83 c4 18             	add    $0x18,%esp
}
  80246f:	90                   	nop
  802470:	c9                   	leave  
  802471:	c3                   	ret    

00802472 <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  802472:	55                   	push   %ebp
  802473:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  802475:	6a 00                	push   $0x0
  802477:	6a 00                	push   $0x0
  802479:	6a 00                	push   $0x0
  80247b:	6a 00                	push   $0x0
  80247d:	6a 00                	push   $0x0
  80247f:	6a 14                	push   $0x14
  802481:	e8 0e fe ff ff       	call   802294 <syscall>
  802486:	83 c4 18             	add    $0x18,%esp
}
  802489:	90                   	nop
  80248a:	c9                   	leave  
  80248b:	c3                   	ret    

0080248c <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  80248c:	55                   	push   %ebp
  80248d:	89 e5                	mov    %esp,%ebp
  80248f:	83 ec 04             	sub    $0x4,%esp
  802492:	8b 45 10             	mov    0x10(%ebp),%eax
  802495:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  802498:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80249b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80249f:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a2:	6a 00                	push   $0x0
  8024a4:	51                   	push   %ecx
  8024a5:	52                   	push   %edx
  8024a6:	ff 75 0c             	pushl  0xc(%ebp)
  8024a9:	50                   	push   %eax
  8024aa:	6a 15                	push   $0x15
  8024ac:	e8 e3 fd ff ff       	call   802294 <syscall>
  8024b1:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  8024b4:	c9                   	leave  
  8024b5:	c3                   	ret    

008024b6 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  8024b6:	55                   	push   %ebp
  8024b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  8024b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bf:	6a 00                	push   $0x0
  8024c1:	6a 00                	push   $0x0
  8024c3:	6a 00                	push   $0x0
  8024c5:	52                   	push   %edx
  8024c6:	50                   	push   %eax
  8024c7:	6a 16                	push   $0x16
  8024c9:	e8 c6 fd ff ff       	call   802294 <syscall>
  8024ce:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  8024d1:	c9                   	leave  
  8024d2:	c3                   	ret    

008024d3 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  8024d3:	55                   	push   %ebp
  8024d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  8024d6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8024df:	6a 00                	push   $0x0
  8024e1:	6a 00                	push   $0x0
  8024e3:	51                   	push   %ecx
  8024e4:	52                   	push   %edx
  8024e5:	50                   	push   %eax
  8024e6:	6a 17                	push   $0x17
  8024e8:	e8 a7 fd ff ff       	call   802294 <syscall>
  8024ed:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  8024f0:	c9                   	leave  
  8024f1:	c3                   	ret    

008024f2 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  8024f2:	55                   	push   %ebp
  8024f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  8024f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fb:	6a 00                	push   $0x0
  8024fd:	6a 00                	push   $0x0
  8024ff:	6a 00                	push   $0x0
  802501:	52                   	push   %edx
  802502:	50                   	push   %eax
  802503:	6a 18                	push   $0x18
  802505:	e8 8a fd ff ff       	call   802294 <syscall>
  80250a:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  80250d:	c9                   	leave  
  80250e:	c3                   	ret    

0080250f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  80250f:	55                   	push   %ebp
  802510:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  802512:	8b 45 08             	mov    0x8(%ebp),%eax
  802515:	6a 00                	push   $0x0
  802517:	ff 75 14             	pushl  0x14(%ebp)
  80251a:	ff 75 10             	pushl  0x10(%ebp)
  80251d:	ff 75 0c             	pushl  0xc(%ebp)
  802520:	50                   	push   %eax
  802521:	6a 19                	push   $0x19
  802523:	e8 6c fd ff ff       	call   802294 <syscall>
  802528:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  80252b:	c9                   	leave  
  80252c:	c3                   	ret    

0080252d <sys_run_env>:

void sys_run_env(int32 envId) {
  80252d:	55                   	push   %ebp
  80252e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  802530:	8b 45 08             	mov    0x8(%ebp),%eax
  802533:	6a 00                	push   $0x0
  802535:	6a 00                	push   $0x0
  802537:	6a 00                	push   $0x0
  802539:	6a 00                	push   $0x0
  80253b:	50                   	push   %eax
  80253c:	6a 1a                	push   $0x1a
  80253e:	e8 51 fd ff ff       	call   802294 <syscall>
  802543:	83 c4 18             	add    $0x18,%esp
}
  802546:	90                   	nop
  802547:	c9                   	leave  
  802548:	c3                   	ret    

00802549 <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  802549:	55                   	push   %ebp
  80254a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80254c:	8b 45 08             	mov    0x8(%ebp),%eax
  80254f:	6a 00                	push   $0x0
  802551:	6a 00                	push   $0x0
  802553:	6a 00                	push   $0x0
  802555:	6a 00                	push   $0x0
  802557:	50                   	push   %eax
  802558:	6a 1b                	push   $0x1b
  80255a:	e8 35 fd ff ff       	call   802294 <syscall>
  80255f:	83 c4 18             	add    $0x18,%esp
}
  802562:	c9                   	leave  
  802563:	c3                   	ret    

00802564 <sys_getenvid>:

int32 sys_getenvid(void) {
  802564:	55                   	push   %ebp
  802565:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802567:	6a 00                	push   $0x0
  802569:	6a 00                	push   $0x0
  80256b:	6a 00                	push   $0x0
  80256d:	6a 00                	push   $0x0
  80256f:	6a 00                	push   $0x0
  802571:	6a 05                	push   $0x5
  802573:	e8 1c fd ff ff       	call   802294 <syscall>
  802578:	83 c4 18             	add    $0x18,%esp
}
  80257b:	c9                   	leave  
  80257c:	c3                   	ret    

0080257d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  80257d:	55                   	push   %ebp
  80257e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802580:	6a 00                	push   $0x0
  802582:	6a 00                	push   $0x0
  802584:	6a 00                	push   $0x0
  802586:	6a 00                	push   $0x0
  802588:	6a 00                	push   $0x0
  80258a:	6a 06                	push   $0x6
  80258c:	e8 03 fd ff ff       	call   802294 <syscall>
  802591:	83 c4 18             	add    $0x18,%esp
}
  802594:	c9                   	leave  
  802595:	c3                   	ret    

00802596 <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  802596:	55                   	push   %ebp
  802597:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802599:	6a 00                	push   $0x0
  80259b:	6a 00                	push   $0x0
  80259d:	6a 00                	push   $0x0
  80259f:	6a 00                	push   $0x0
  8025a1:	6a 00                	push   $0x0
  8025a3:	6a 07                	push   $0x7
  8025a5:	e8 ea fc ff ff       	call   802294 <syscall>
  8025aa:	83 c4 18             	add    $0x18,%esp
}
  8025ad:	c9                   	leave  
  8025ae:	c3                   	ret    

008025af <sys_exit_env>:

void sys_exit_env(void) {
  8025af:	55                   	push   %ebp
  8025b0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8025b2:	6a 00                	push   $0x0
  8025b4:	6a 00                	push   $0x0
  8025b6:	6a 00                	push   $0x0
  8025b8:	6a 00                	push   $0x0
  8025ba:	6a 00                	push   $0x0
  8025bc:	6a 1c                	push   $0x1c
  8025be:	e8 d1 fc ff ff       	call   802294 <syscall>
  8025c3:	83 c4 18             	add    $0x18,%esp
}
  8025c6:	90                   	nop
  8025c7:	c9                   	leave  
  8025c8:	c3                   	ret    

008025c9 <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  8025c9:	55                   	push   %ebp
  8025ca:	89 e5                	mov    %esp,%ebp
  8025cc:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  8025cf:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8025d2:	8d 50 04             	lea    0x4(%eax),%edx
  8025d5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8025d8:	6a 00                	push   $0x0
  8025da:	6a 00                	push   $0x0
  8025dc:	6a 00                	push   $0x0
  8025de:	52                   	push   %edx
  8025df:	50                   	push   %eax
  8025e0:	6a 1d                	push   $0x1d
  8025e2:	e8 ad fc ff ff       	call   802294 <syscall>
  8025e7:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  8025ea:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8025f0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8025f3:	89 01                	mov    %eax,(%ecx)
  8025f5:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8025f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fb:	c9                   	leave  
  8025fc:	c2 04 00             	ret    $0x4

008025ff <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  8025ff:	55                   	push   %ebp
  802600:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  802602:	6a 00                	push   $0x0
  802604:	6a 00                	push   $0x0
  802606:	ff 75 10             	pushl  0x10(%ebp)
  802609:	ff 75 0c             	pushl  0xc(%ebp)
  80260c:	ff 75 08             	pushl  0x8(%ebp)
  80260f:	6a 13                	push   $0x13
  802611:	e8 7e fc ff ff       	call   802294 <syscall>
  802616:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  802619:	90                   	nop
}
  80261a:	c9                   	leave  
  80261b:	c3                   	ret    

0080261c <sys_rcr2>:
uint32 sys_rcr2() {
  80261c:	55                   	push   %ebp
  80261d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80261f:	6a 00                	push   $0x0
  802621:	6a 00                	push   $0x0
  802623:	6a 00                	push   $0x0
  802625:	6a 00                	push   $0x0
  802627:	6a 00                	push   $0x0
  802629:	6a 1e                	push   $0x1e
  80262b:	e8 64 fc ff ff       	call   802294 <syscall>
  802630:	83 c4 18             	add    $0x18,%esp
}
  802633:	c9                   	leave  
  802634:	c3                   	ret    

00802635 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  802635:	55                   	push   %ebp
  802636:	89 e5                	mov    %esp,%ebp
  802638:	83 ec 04             	sub    $0x4,%esp
  80263b:	8b 45 08             	mov    0x8(%ebp),%eax
  80263e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802641:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802645:	6a 00                	push   $0x0
  802647:	6a 00                	push   $0x0
  802649:	6a 00                	push   $0x0
  80264b:	6a 00                	push   $0x0
  80264d:	50                   	push   %eax
  80264e:	6a 1f                	push   $0x1f
  802650:	e8 3f fc ff ff       	call   802294 <syscall>
  802655:	83 c4 18             	add    $0x18,%esp
	return;
  802658:	90                   	nop
}
  802659:	c9                   	leave  
  80265a:	c3                   	ret    

0080265b <rsttst>:
void rsttst() {
  80265b:	55                   	push   %ebp
  80265c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80265e:	6a 00                	push   $0x0
  802660:	6a 00                	push   $0x0
  802662:	6a 00                	push   $0x0
  802664:	6a 00                	push   $0x0
  802666:	6a 00                	push   $0x0
  802668:	6a 21                	push   $0x21
  80266a:	e8 25 fc ff ff       	call   802294 <syscall>
  80266f:	83 c4 18             	add    $0x18,%esp
	return;
  802672:	90                   	nop
}
  802673:	c9                   	leave  
  802674:	c3                   	ret    

00802675 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  802675:	55                   	push   %ebp
  802676:	89 e5                	mov    %esp,%ebp
  802678:	83 ec 04             	sub    $0x4,%esp
  80267b:	8b 45 14             	mov    0x14(%ebp),%eax
  80267e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802681:	8b 55 18             	mov    0x18(%ebp),%edx
  802684:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802688:	52                   	push   %edx
  802689:	50                   	push   %eax
  80268a:	ff 75 10             	pushl  0x10(%ebp)
  80268d:	ff 75 0c             	pushl  0xc(%ebp)
  802690:	ff 75 08             	pushl  0x8(%ebp)
  802693:	6a 20                	push   $0x20
  802695:	e8 fa fb ff ff       	call   802294 <syscall>
  80269a:	83 c4 18             	add    $0x18,%esp
	return;
  80269d:	90                   	nop
}
  80269e:	c9                   	leave  
  80269f:	c3                   	ret    

008026a0 <chktst>:
void chktst(uint32 n) {
  8026a0:	55                   	push   %ebp
  8026a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8026a3:	6a 00                	push   $0x0
  8026a5:	6a 00                	push   $0x0
  8026a7:	6a 00                	push   $0x0
  8026a9:	6a 00                	push   $0x0
  8026ab:	ff 75 08             	pushl  0x8(%ebp)
  8026ae:	6a 22                	push   $0x22
  8026b0:	e8 df fb ff ff       	call   802294 <syscall>
  8026b5:	83 c4 18             	add    $0x18,%esp
	return;
  8026b8:	90                   	nop
}
  8026b9:	c9                   	leave  
  8026ba:	c3                   	ret    

008026bb <inctst>:

void inctst() {
  8026bb:	55                   	push   %ebp
  8026bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8026be:	6a 00                	push   $0x0
  8026c0:	6a 00                	push   $0x0
  8026c2:	6a 00                	push   $0x0
  8026c4:	6a 00                	push   $0x0
  8026c6:	6a 00                	push   $0x0
  8026c8:	6a 23                	push   $0x23
  8026ca:	e8 c5 fb ff ff       	call   802294 <syscall>
  8026cf:	83 c4 18             	add    $0x18,%esp
	return;
  8026d2:	90                   	nop
}
  8026d3:	c9                   	leave  
  8026d4:	c3                   	ret    

008026d5 <gettst>:
uint32 gettst() {
  8026d5:	55                   	push   %ebp
  8026d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8026d8:	6a 00                	push   $0x0
  8026da:	6a 00                	push   $0x0
  8026dc:	6a 00                	push   $0x0
  8026de:	6a 00                	push   $0x0
  8026e0:	6a 00                	push   $0x0
  8026e2:	6a 24                	push   $0x24
  8026e4:	e8 ab fb ff ff       	call   802294 <syscall>
  8026e9:	83 c4 18             	add    $0x18,%esp
}
  8026ec:	c9                   	leave  
  8026ed:	c3                   	ret    

008026ee <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  8026ee:	55                   	push   %ebp
  8026ef:	89 e5                	mov    %esp,%ebp
  8026f1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8026f4:	6a 00                	push   $0x0
  8026f6:	6a 00                	push   $0x0
  8026f8:	6a 00                	push   $0x0
  8026fa:	6a 00                	push   $0x0
  8026fc:	6a 00                	push   $0x0
  8026fe:	6a 25                	push   $0x25
  802700:	e8 8f fb ff ff       	call   802294 <syscall>
  802705:	83 c4 18             	add    $0x18,%esp
  802708:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80270b:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80270f:	75 07                	jne    802718 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802711:	b8 01 00 00 00       	mov    $0x1,%eax
  802716:	eb 05                	jmp    80271d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802718:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80271d:	c9                   	leave  
  80271e:	c3                   	ret    

0080271f <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  80271f:	55                   	push   %ebp
  802720:	89 e5                	mov    %esp,%ebp
  802722:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802725:	6a 00                	push   $0x0
  802727:	6a 00                	push   $0x0
  802729:	6a 00                	push   $0x0
  80272b:	6a 00                	push   $0x0
  80272d:	6a 00                	push   $0x0
  80272f:	6a 25                	push   $0x25
  802731:	e8 5e fb ff ff       	call   802294 <syscall>
  802736:	83 c4 18             	add    $0x18,%esp
  802739:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80273c:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802740:	75 07                	jne    802749 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802742:	b8 01 00 00 00       	mov    $0x1,%eax
  802747:	eb 05                	jmp    80274e <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802749:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80274e:	c9                   	leave  
  80274f:	c3                   	ret    

00802750 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  802750:	55                   	push   %ebp
  802751:	89 e5                	mov    %esp,%ebp
  802753:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802756:	6a 00                	push   $0x0
  802758:	6a 00                	push   $0x0
  80275a:	6a 00                	push   $0x0
  80275c:	6a 00                	push   $0x0
  80275e:	6a 00                	push   $0x0
  802760:	6a 25                	push   $0x25
  802762:	e8 2d fb ff ff       	call   802294 <syscall>
  802767:	83 c4 18             	add    $0x18,%esp
  80276a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80276d:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802771:	75 07                	jne    80277a <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802773:	b8 01 00 00 00       	mov    $0x1,%eax
  802778:	eb 05                	jmp    80277f <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80277a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80277f:	c9                   	leave  
  802780:	c3                   	ret    

00802781 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  802781:	55                   	push   %ebp
  802782:	89 e5                	mov    %esp,%ebp
  802784:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802787:	6a 00                	push   $0x0
  802789:	6a 00                	push   $0x0
  80278b:	6a 00                	push   $0x0
  80278d:	6a 00                	push   $0x0
  80278f:	6a 00                	push   $0x0
  802791:	6a 25                	push   $0x25
  802793:	e8 fc fa ff ff       	call   802294 <syscall>
  802798:	83 c4 18             	add    $0x18,%esp
  80279b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80279e:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8027a2:	75 07                	jne    8027ab <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8027a4:	b8 01 00 00 00       	mov    $0x1,%eax
  8027a9:	eb 05                	jmp    8027b0 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8027ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027b0:	c9                   	leave  
  8027b1:	c3                   	ret    

008027b2 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  8027b2:	55                   	push   %ebp
  8027b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8027b5:	6a 00                	push   $0x0
  8027b7:	6a 00                	push   $0x0
  8027b9:	6a 00                	push   $0x0
  8027bb:	6a 00                	push   $0x0
  8027bd:	ff 75 08             	pushl  0x8(%ebp)
  8027c0:	6a 26                	push   $0x26
  8027c2:	e8 cd fa ff ff       	call   802294 <syscall>
  8027c7:	83 c4 18             	add    $0x18,%esp
	return;
  8027ca:	90                   	nop
}
  8027cb:	c9                   	leave  
  8027cc:	c3                   	ret    

008027cd <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  8027cd:	55                   	push   %ebp
  8027ce:	89 e5                	mov    %esp,%ebp
  8027d0:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  8027d1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8027d4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8027d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027da:	8b 45 08             	mov    0x8(%ebp),%eax
  8027dd:	6a 00                	push   $0x0
  8027df:	53                   	push   %ebx
  8027e0:	51                   	push   %ecx
  8027e1:	52                   	push   %edx
  8027e2:	50                   	push   %eax
  8027e3:	6a 27                	push   $0x27
  8027e5:	e8 aa fa ff ff       	call   802294 <syscall>
  8027ea:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  8027ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8027f0:	c9                   	leave  
  8027f1:	c3                   	ret    

008027f2 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  8027f2:	55                   	push   %ebp
  8027f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  8027f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fb:	6a 00                	push   $0x0
  8027fd:	6a 00                	push   $0x0
  8027ff:	6a 00                	push   $0x0
  802801:	52                   	push   %edx
  802802:	50                   	push   %eax
  802803:	6a 28                	push   $0x28
  802805:	e8 8a fa ff ff       	call   802294 <syscall>
  80280a:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  80280d:	c9                   	leave  
  80280e:	c3                   	ret    

0080280f <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  80280f:	55                   	push   %ebp
  802810:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  802812:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802815:	8b 55 0c             	mov    0xc(%ebp),%edx
  802818:	8b 45 08             	mov    0x8(%ebp),%eax
  80281b:	6a 00                	push   $0x0
  80281d:	51                   	push   %ecx
  80281e:	ff 75 10             	pushl  0x10(%ebp)
  802821:	52                   	push   %edx
  802822:	50                   	push   %eax
  802823:	6a 29                	push   $0x29
  802825:	e8 6a fa ff ff       	call   802294 <syscall>
  80282a:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  80282d:	c9                   	leave  
  80282e:	c3                   	ret    

0080282f <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  80282f:	55                   	push   %ebp
  802830:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802832:	6a 00                	push   $0x0
  802834:	6a 00                	push   $0x0
  802836:	ff 75 10             	pushl  0x10(%ebp)
  802839:	ff 75 0c             	pushl  0xc(%ebp)
  80283c:	ff 75 08             	pushl  0x8(%ebp)
  80283f:	6a 12                	push   $0x12
  802841:	e8 4e fa ff ff       	call   802294 <syscall>
  802846:	83 c4 18             	add    $0x18,%esp
	return;
  802849:	90                   	nop
}
  80284a:	c9                   	leave  
  80284b:	c3                   	ret    

0080284c <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  80284c:	55                   	push   %ebp
  80284d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  80284f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802852:	8b 45 08             	mov    0x8(%ebp),%eax
  802855:	6a 00                	push   $0x0
  802857:	6a 00                	push   $0x0
  802859:	6a 00                	push   $0x0
  80285b:	52                   	push   %edx
  80285c:	50                   	push   %eax
  80285d:	6a 2a                	push   $0x2a
  80285f:	e8 30 fa ff ff       	call   802294 <syscall>
  802864:	83 c4 18             	add    $0x18,%esp
	return;
  802867:	90                   	nop
}
  802868:	c9                   	leave  
  802869:	c3                   	ret    

0080286a <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  80286a:	55                   	push   %ebp
  80286b:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  80286d:	8b 45 08             	mov    0x8(%ebp),%eax
  802870:	6a 00                	push   $0x0
  802872:	6a 00                	push   $0x0
  802874:	6a 00                	push   $0x0
  802876:	6a 00                	push   $0x0
  802878:	50                   	push   %eax
  802879:	6a 2b                	push   $0x2b
  80287b:	e8 14 fa ff ff       	call   802294 <syscall>
  802880:	83 c4 18             	add    $0x18,%esp
}
  802883:	c9                   	leave  
  802884:	c3                   	ret    

00802885 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  802885:	55                   	push   %ebp
  802886:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802888:	6a 00                	push   $0x0
  80288a:	6a 00                	push   $0x0
  80288c:	6a 00                	push   $0x0
  80288e:	ff 75 0c             	pushl  0xc(%ebp)
  802891:	ff 75 08             	pushl  0x8(%ebp)
  802894:	6a 2c                	push   $0x2c
  802896:	e8 f9 f9 ff ff       	call   802294 <syscall>
  80289b:	83 c4 18             	add    $0x18,%esp
	return;
  80289e:	90                   	nop
}
  80289f:	c9                   	leave  
  8028a0:	c3                   	ret    

008028a1 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  8028a1:	55                   	push   %ebp
  8028a2:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8028a4:	6a 00                	push   $0x0
  8028a6:	6a 00                	push   $0x0
  8028a8:	6a 00                	push   $0x0
  8028aa:	ff 75 0c             	pushl  0xc(%ebp)
  8028ad:	ff 75 08             	pushl  0x8(%ebp)
  8028b0:	6a 2d                	push   $0x2d
  8028b2:	e8 dd f9 ff ff       	call   802294 <syscall>
  8028b7:	83 c4 18             	add    $0x18,%esp
	return;
  8028ba:	90                   	nop
}
  8028bb:	c9                   	leave  
  8028bc:	c3                   	ret    

008028bd <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  8028bd:	55                   	push   %ebp
  8028be:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  8028c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c3:	6a 00                	push   $0x0
  8028c5:	6a 00                	push   $0x0
  8028c7:	6a 00                	push   $0x0
  8028c9:	6a 00                	push   $0x0
  8028cb:	50                   	push   %eax
  8028cc:	6a 2f                	push   $0x2f
  8028ce:	e8 c1 f9 ff ff       	call   802294 <syscall>
  8028d3:	83 c4 18             	add    $0x18,%esp
	return;
  8028d6:	90                   	nop
}
  8028d7:	c9                   	leave  
  8028d8:	c3                   	ret    

008028d9 <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  8028d9:	55                   	push   %ebp
  8028da:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  8028dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028df:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e2:	6a 00                	push   $0x0
  8028e4:	6a 00                	push   $0x0
  8028e6:	6a 00                	push   $0x0
  8028e8:	52                   	push   %edx
  8028e9:	50                   	push   %eax
  8028ea:	6a 30                	push   $0x30
  8028ec:	e8 a3 f9 ff ff       	call   802294 <syscall>
  8028f1:	83 c4 18             	add    $0x18,%esp
	return;
  8028f4:	90                   	nop
}
  8028f5:	c9                   	leave  
  8028f6:	c3                   	ret    

008028f7 <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  8028f7:	55                   	push   %ebp
  8028f8:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  8028fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fd:	6a 00                	push   $0x0
  8028ff:	6a 00                	push   $0x0
  802901:	6a 00                	push   $0x0
  802903:	6a 00                	push   $0x0
  802905:	50                   	push   %eax
  802906:	6a 31                	push   $0x31
  802908:	e8 87 f9 ff ff       	call   802294 <syscall>
  80290d:	83 c4 18             	add    $0x18,%esp
	return;
  802910:	90                   	nop
}
  802911:	c9                   	leave  
  802912:	c3                   	ret    

00802913 <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  802913:	55                   	push   %ebp
  802914:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  802916:	8b 55 0c             	mov    0xc(%ebp),%edx
  802919:	8b 45 08             	mov    0x8(%ebp),%eax
  80291c:	6a 00                	push   $0x0
  80291e:	6a 00                	push   $0x0
  802920:	6a 00                	push   $0x0
  802922:	52                   	push   %edx
  802923:	50                   	push   %eax
  802924:	6a 2e                	push   $0x2e
  802926:	e8 69 f9 ff ff       	call   802294 <syscall>
  80292b:	83 c4 18             	add    $0x18,%esp
    return;
  80292e:	90                   	nop
}
  80292f:	c9                   	leave  
  802930:	c3                   	ret    

00802931 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802931:	55                   	push   %ebp
  802932:	89 e5                	mov    %esp,%ebp
  802934:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802937:	8b 45 08             	mov    0x8(%ebp),%eax
  80293a:	83 e8 04             	sub    $0x4,%eax
  80293d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802940:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802943:	8b 00                	mov    (%eax),%eax
  802945:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802948:	c9                   	leave  
  802949:	c3                   	ret    

0080294a <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  80294a:	55                   	push   %ebp
  80294b:	89 e5                	mov    %esp,%ebp
  80294d:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802950:	8b 45 08             	mov    0x8(%ebp),%eax
  802953:	83 e8 04             	sub    $0x4,%eax
  802956:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802959:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80295c:	8b 00                	mov    (%eax),%eax
  80295e:	83 e0 01             	and    $0x1,%eax
  802961:	85 c0                	test   %eax,%eax
  802963:	0f 94 c0             	sete   %al
}
  802966:	c9                   	leave  
  802967:	c3                   	ret    

00802968 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802968:	55                   	push   %ebp
  802969:	89 e5                	mov    %esp,%ebp
  80296b:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  80296e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802975:	8b 45 0c             	mov    0xc(%ebp),%eax
  802978:	83 f8 02             	cmp    $0x2,%eax
  80297b:	74 2b                	je     8029a8 <alloc_block+0x40>
  80297d:	83 f8 02             	cmp    $0x2,%eax
  802980:	7f 07                	jg     802989 <alloc_block+0x21>
  802982:	83 f8 01             	cmp    $0x1,%eax
  802985:	74 0e                	je     802995 <alloc_block+0x2d>
  802987:	eb 58                	jmp    8029e1 <alloc_block+0x79>
  802989:	83 f8 03             	cmp    $0x3,%eax
  80298c:	74 2d                	je     8029bb <alloc_block+0x53>
  80298e:	83 f8 04             	cmp    $0x4,%eax
  802991:	74 3b                	je     8029ce <alloc_block+0x66>
  802993:	eb 4c                	jmp    8029e1 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802995:	83 ec 0c             	sub    $0xc,%esp
  802998:	ff 75 08             	pushl  0x8(%ebp)
  80299b:	e8 f7 03 00 00       	call   802d97 <alloc_block_FF>
  8029a0:	83 c4 10             	add    $0x10,%esp
  8029a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8029a6:	eb 4a                	jmp    8029f2 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8029a8:	83 ec 0c             	sub    $0xc,%esp
  8029ab:	ff 75 08             	pushl  0x8(%ebp)
  8029ae:	e8 f0 11 00 00       	call   803ba3 <alloc_block_NF>
  8029b3:	83 c4 10             	add    $0x10,%esp
  8029b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8029b9:	eb 37                	jmp    8029f2 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8029bb:	83 ec 0c             	sub    $0xc,%esp
  8029be:	ff 75 08             	pushl  0x8(%ebp)
  8029c1:	e8 08 08 00 00       	call   8031ce <alloc_block_BF>
  8029c6:	83 c4 10             	add    $0x10,%esp
  8029c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8029cc:	eb 24                	jmp    8029f2 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8029ce:	83 ec 0c             	sub    $0xc,%esp
  8029d1:	ff 75 08             	pushl  0x8(%ebp)
  8029d4:	e8 ad 11 00 00       	call   803b86 <alloc_block_WF>
  8029d9:	83 c4 10             	add    $0x10,%esp
  8029dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8029df:	eb 11                	jmp    8029f2 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8029e1:	83 ec 0c             	sub    $0xc,%esp
  8029e4:	68 ec 46 80 00       	push   $0x8046ec
  8029e9:	e8 39 e2 ff ff       	call   800c27 <cprintf>
  8029ee:	83 c4 10             	add    $0x10,%esp
		break;
  8029f1:	90                   	nop
	}
	return va;
  8029f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8029f5:	c9                   	leave  
  8029f6:	c3                   	ret    

008029f7 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8029f7:	55                   	push   %ebp
  8029f8:	89 e5                	mov    %esp,%ebp
  8029fa:	53                   	push   %ebx
  8029fb:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8029fe:	83 ec 0c             	sub    $0xc,%esp
  802a01:	68 0c 47 80 00       	push   $0x80470c
  802a06:	e8 1c e2 ff ff       	call   800c27 <cprintf>
  802a0b:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802a0e:	83 ec 0c             	sub    $0xc,%esp
  802a11:	68 37 47 80 00       	push   $0x804737
  802a16:	e8 0c e2 ff ff       	call   800c27 <cprintf>
  802a1b:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a21:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a24:	eb 37                	jmp    802a5d <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802a26:	83 ec 0c             	sub    $0xc,%esp
  802a29:	ff 75 f4             	pushl  -0xc(%ebp)
  802a2c:	e8 19 ff ff ff       	call   80294a <is_free_block>
  802a31:	83 c4 10             	add    $0x10,%esp
  802a34:	0f be d8             	movsbl %al,%ebx
  802a37:	83 ec 0c             	sub    $0xc,%esp
  802a3a:	ff 75 f4             	pushl  -0xc(%ebp)
  802a3d:	e8 ef fe ff ff       	call   802931 <get_block_size>
  802a42:	83 c4 10             	add    $0x10,%esp
  802a45:	83 ec 04             	sub    $0x4,%esp
  802a48:	53                   	push   %ebx
  802a49:	50                   	push   %eax
  802a4a:	68 4f 47 80 00       	push   $0x80474f
  802a4f:	e8 d3 e1 ff ff       	call   800c27 <cprintf>
  802a54:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802a57:	8b 45 10             	mov    0x10(%ebp),%eax
  802a5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a5d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a61:	74 07                	je     802a6a <print_blocks_list+0x73>
  802a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a66:	8b 00                	mov    (%eax),%eax
  802a68:	eb 05                	jmp    802a6f <print_blocks_list+0x78>
  802a6a:	b8 00 00 00 00       	mov    $0x0,%eax
  802a6f:	89 45 10             	mov    %eax,0x10(%ebp)
  802a72:	8b 45 10             	mov    0x10(%ebp),%eax
  802a75:	85 c0                	test   %eax,%eax
  802a77:	75 ad                	jne    802a26 <print_blocks_list+0x2f>
  802a79:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a7d:	75 a7                	jne    802a26 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802a7f:	83 ec 0c             	sub    $0xc,%esp
  802a82:	68 0c 47 80 00       	push   $0x80470c
  802a87:	e8 9b e1 ff ff       	call   800c27 <cprintf>
  802a8c:	83 c4 10             	add    $0x10,%esp

}
  802a8f:	90                   	nop
  802a90:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802a93:	c9                   	leave  
  802a94:	c3                   	ret    

00802a95 <initialize_dynamic_allocator>:

//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802a95:	55                   	push   %ebp
  802a96:	89 e5                	mov    %esp,%ebp
  802a98:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802a9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a9e:	83 e0 01             	and    $0x1,%eax
  802aa1:	85 c0                	test   %eax,%eax
  802aa3:	74 03                	je     802aa8 <initialize_dynamic_allocator+0x13>
  802aa5:	ff 45 0c             	incl   0xc(%ebp)
		if (initSizeOfAllocatedSpace == 0)
  802aa8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802aac:	0f 84 f8 00 00 00    	je     802baa <initialize_dynamic_allocator+0x115>
			return ;
		is_initialized = 1;
  802ab2:	c7 05 40 50 98 00 01 	movl   $0x1,0x985040
  802ab9:	00 00 00 
	//TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("initialize_dynamic_allocator is not implemented yet");
	//Your Code is Here...

	if(is_initialized){
  802abc:	a1 40 50 98 00       	mov    0x985040,%eax
  802ac1:	85 c0                	test   %eax,%eax
  802ac3:	0f 84 e2 00 00 00    	je     802bab <initialize_dynamic_allocator+0x116>

		// begin block with size 0 and lsb = 1 (allocated)
		uint32* beginBlock = (uint32*)daStart;
  802ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  802acc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		*beginBlock = 0 | 1; // size = 0, LSB as a flag = 1
  802acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad2:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		// end block with size 0 and lsb = 1 (allocated)
		uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);
  802ad8:	8b 55 08             	mov    0x8(%ebp),%edx
  802adb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ade:	01 d0                	add    %edx,%eax
  802ae0:	83 e8 04             	sub    $0x4,%eax
  802ae3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		*endBlock = 0 | 1; // size = 0, LSB as a flag = 1
  802ae6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae9:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

		// the block that between begin and end blocks
		struct BlockElement* block = (struct BlockElement*)(daStart + 8);
  802aef:	8b 45 08             	mov    0x8(%ebp),%eax
  802af2:	83 c0 08             	add    $0x8,%eax
  802af5:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 blockSize = initSizeOfAllocatedSpace - 8; // subtract size of begin and end blocks
  802af8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802afb:	83 e8 08             	sub    $0x8,%eax
  802afe:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(block,blockSize,0);
  802b01:	83 ec 04             	sub    $0x4,%esp
  802b04:	6a 00                	push   $0x0
  802b06:	ff 75 e8             	pushl  -0x18(%ebp)
  802b09:	ff 75 ec             	pushl  -0x14(%ebp)
  802b0c:	e8 9c 00 00 00       	call   802bad <set_block_data>
  802b11:	83 c4 10             	add    $0x10,%esp

		block->prev_next_info.le_next = NULL;
  802b14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b17:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block->prev_next_info.le_prev = NULL;
  802b1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b20:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

		LIST_INIT(&freeBlocksList);
  802b27:	c7 05 48 50 98 00 00 	movl   $0x0,0x985048
  802b2e:	00 00 00 
  802b31:	c7 05 4c 50 98 00 00 	movl   $0x0,0x98504c
  802b38:	00 00 00 
  802b3b:	c7 05 54 50 98 00 00 	movl   $0x0,0x985054
  802b42:	00 00 00 
		LIST_INSERT_HEAD(&freeBlocksList, block);
  802b45:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b49:	75 17                	jne    802b62 <initialize_dynamic_allocator+0xcd>
  802b4b:	83 ec 04             	sub    $0x4,%esp
  802b4e:	68 68 47 80 00       	push   $0x804768
  802b53:	68 80 00 00 00       	push   $0x80
  802b58:	68 8b 47 80 00       	push   $0x80478b
  802b5d:	e8 5e 10 00 00       	call   803bc0 <_panic>
  802b62:	8b 15 48 50 98 00    	mov    0x985048,%edx
  802b68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b6b:	89 10                	mov    %edx,(%eax)
  802b6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b70:	8b 00                	mov    (%eax),%eax
  802b72:	85 c0                	test   %eax,%eax
  802b74:	74 0d                	je     802b83 <initialize_dynamic_allocator+0xee>
  802b76:	a1 48 50 98 00       	mov    0x985048,%eax
  802b7b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b7e:	89 50 04             	mov    %edx,0x4(%eax)
  802b81:	eb 08                	jmp    802b8b <initialize_dynamic_allocator+0xf6>
  802b83:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b86:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802b8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b8e:	a3 48 50 98 00       	mov    %eax,0x985048
  802b93:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b96:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b9d:	a1 54 50 98 00       	mov    0x985054,%eax
  802ba2:	40                   	inc    %eax
  802ba3:	a3 54 50 98 00       	mov    %eax,0x985054
  802ba8:	eb 01                	jmp    802bab <initialize_dynamic_allocator+0x116>
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
		if (initSizeOfAllocatedSpace == 0)
			return ;
  802baa:	90                   	nop
		block->prev_next_info.le_prev = NULL;

		LIST_INIT(&freeBlocksList);
		LIST_INSERT_HEAD(&freeBlocksList, block);
	}
}
  802bab:	c9                   	leave  
  802bac:	c3                   	ret    

00802bad <set_block_data>:
//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802bad:	55                   	push   %ebp
  802bae:	89 e5                	mov    %esp,%ebp
  802bb0:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("set_block_data is not implemented yet");
	//Your Code is Here...

	if(totalSize % 2 != 0)
  802bb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bb6:	83 e0 01             	and    $0x1,%eax
  802bb9:	85 c0                	test   %eax,%eax
  802bbb:	74 03                	je     802bc0 <set_block_data+0x13>
	{
		totalSize++;
  802bbd:	ff 45 0c             	incl   0xc(%ebp)
	}

	uint32* header = (uint32 *)((uint32*)va-1);
  802bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc3:	83 e8 04             	sub    $0x4,%eax
  802bc6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//	size => totalSize with LSB = 0		 set LSB = 1 if isAllocated
	*header = (totalSize & ~1) | (isAllocated & 1);
  802bc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bcc:	83 e0 fe             	and    $0xfffffffe,%eax
  802bcf:	89 c2                	mov    %eax,%edx
  802bd1:	8b 45 10             	mov    0x10(%ebp),%eax
  802bd4:	83 e0 01             	and    $0x1,%eax
  802bd7:	09 c2                	or     %eax,%edx
  802bd9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802bdc:	89 10                	mov    %edx,(%eax)
	uint32* footer = (uint32*) (va + totalSize - 8);
  802bde:	8b 45 0c             	mov    0xc(%ebp),%eax
  802be1:	8d 50 f8             	lea    -0x8(%eax),%edx
  802be4:	8b 45 08             	mov    0x8(%ebp),%eax
  802be7:	01 d0                	add    %edx,%eax
  802be9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	*footer = (totalSize & ~1) | (isAllocated & 1);
  802bec:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bef:	83 e0 fe             	and    $0xfffffffe,%eax
  802bf2:	89 c2                	mov    %eax,%edx
  802bf4:	8b 45 10             	mov    0x10(%ebp),%eax
  802bf7:	83 e0 01             	and    $0x1,%eax
  802bfa:	09 c2                	or     %eax,%edx
  802bfc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802bff:	89 10                	mov    %edx,(%eax)
}
  802c01:	90                   	nop
  802c02:	c9                   	leave  
  802c03:	c3                   	ret    

00802c04 <insert_sorted_in_freeList>:
//=========================================
void insert_sorted_in_freeList(struct BlockElement *newBlock)
{
  802c04:	55                   	push   %ebp
  802c05:	89 e5                	mov    %esp,%ebp
  802c07:	83 ec 18             	sub    $0x18,%esp
	if(LIST_EMPTY(&freeBlocksList))
  802c0a:	a1 48 50 98 00       	mov    0x985048,%eax
  802c0f:	85 c0                	test   %eax,%eax
  802c11:	75 68                	jne    802c7b <insert_sorted_in_freeList+0x77>
	{
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
  802c13:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c17:	75 17                	jne    802c30 <insert_sorted_in_freeList+0x2c>
  802c19:	83 ec 04             	sub    $0x4,%esp
  802c1c:	68 68 47 80 00       	push   $0x804768
  802c21:	68 9d 00 00 00       	push   $0x9d
  802c26:	68 8b 47 80 00       	push   $0x80478b
  802c2b:	e8 90 0f 00 00       	call   803bc0 <_panic>
  802c30:	8b 15 48 50 98 00    	mov    0x985048,%edx
  802c36:	8b 45 08             	mov    0x8(%ebp),%eax
  802c39:	89 10                	mov    %edx,(%eax)
  802c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3e:	8b 00                	mov    (%eax),%eax
  802c40:	85 c0                	test   %eax,%eax
  802c42:	74 0d                	je     802c51 <insert_sorted_in_freeList+0x4d>
  802c44:	a1 48 50 98 00       	mov    0x985048,%eax
  802c49:	8b 55 08             	mov    0x8(%ebp),%edx
  802c4c:	89 50 04             	mov    %edx,0x4(%eax)
  802c4f:	eb 08                	jmp    802c59 <insert_sorted_in_freeList+0x55>
  802c51:	8b 45 08             	mov    0x8(%ebp),%eax
  802c54:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802c59:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5c:	a3 48 50 98 00       	mov    %eax,0x985048
  802c61:	8b 45 08             	mov    0x8(%ebp),%eax
  802c64:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c6b:	a1 54 50 98 00       	mov    0x985054,%eax
  802c70:	40                   	inc    %eax
  802c71:	a3 54 50 98 00       	mov    %eax,0x985054
		return;
  802c76:	e9 1a 01 00 00       	jmp    802d95 <insert_sorted_in_freeList+0x191>
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  802c7b:	a1 48 50 98 00       	mov    0x985048,%eax
  802c80:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c83:	eb 7f                	jmp    802d04 <insert_sorted_in_freeList+0x100>
	{
		if(blk > newBlock) // if address of blk > address of newBlock => add newBlock before blk
  802c85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c88:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c8b:	76 6f                	jbe    802cfc <insert_sorted_in_freeList+0xf8>
		{
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
  802c8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c91:	74 06                	je     802c99 <insert_sorted_in_freeList+0x95>
  802c93:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c97:	75 17                	jne    802cb0 <insert_sorted_in_freeList+0xac>
  802c99:	83 ec 04             	sub    $0x4,%esp
  802c9c:	68 a4 47 80 00       	push   $0x8047a4
  802ca1:	68 a6 00 00 00       	push   $0xa6
  802ca6:	68 8b 47 80 00       	push   $0x80478b
  802cab:	e8 10 0f 00 00       	call   803bc0 <_panic>
  802cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb3:	8b 50 04             	mov    0x4(%eax),%edx
  802cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb9:	89 50 04             	mov    %edx,0x4(%eax)
  802cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cc2:	89 10                	mov    %edx,(%eax)
  802cc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc7:	8b 40 04             	mov    0x4(%eax),%eax
  802cca:	85 c0                	test   %eax,%eax
  802ccc:	74 0d                	je     802cdb <insert_sorted_in_freeList+0xd7>
  802cce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd1:	8b 40 04             	mov    0x4(%eax),%eax
  802cd4:	8b 55 08             	mov    0x8(%ebp),%edx
  802cd7:	89 10                	mov    %edx,(%eax)
  802cd9:	eb 08                	jmp    802ce3 <insert_sorted_in_freeList+0xdf>
  802cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cde:	a3 48 50 98 00       	mov    %eax,0x985048
  802ce3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce6:	8b 55 08             	mov    0x8(%ebp),%edx
  802ce9:	89 50 04             	mov    %edx,0x4(%eax)
  802cec:	a1 54 50 98 00       	mov    0x985054,%eax
  802cf1:	40                   	inc    %eax
  802cf2:	a3 54 50 98 00       	mov    %eax,0x985054
			return;
  802cf7:	e9 99 00 00 00       	jmp    802d95 <insert_sorted_in_freeList+0x191>
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
		return;
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  802cfc:	a1 50 50 98 00       	mov    0x985050,%eax
  802d01:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d04:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d08:	74 07                	je     802d11 <insert_sorted_in_freeList+0x10d>
  802d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0d:	8b 00                	mov    (%eax),%eax
  802d0f:	eb 05                	jmp    802d16 <insert_sorted_in_freeList+0x112>
  802d11:	b8 00 00 00 00       	mov    $0x0,%eax
  802d16:	a3 50 50 98 00       	mov    %eax,0x985050
  802d1b:	a1 50 50 98 00       	mov    0x985050,%eax
  802d20:	85 c0                	test   %eax,%eax
  802d22:	0f 85 5d ff ff ff    	jne    802c85 <insert_sorted_in_freeList+0x81>
  802d28:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d2c:	0f 85 53 ff ff ff    	jne    802c85 <insert_sorted_in_freeList+0x81>
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
			return;
		}
	}
	// if no blk its address > newBlock
	LIST_INSERT_TAIL(&freeBlocksList, newBlock);
  802d32:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d36:	75 17                	jne    802d4f <insert_sorted_in_freeList+0x14b>
  802d38:	83 ec 04             	sub    $0x4,%esp
  802d3b:	68 dc 47 80 00       	push   $0x8047dc
  802d40:	68 ab 00 00 00       	push   $0xab
  802d45:	68 8b 47 80 00       	push   $0x80478b
  802d4a:	e8 71 0e 00 00       	call   803bc0 <_panic>
  802d4f:	8b 15 4c 50 98 00    	mov    0x98504c,%edx
  802d55:	8b 45 08             	mov    0x8(%ebp),%eax
  802d58:	89 50 04             	mov    %edx,0x4(%eax)
  802d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5e:	8b 40 04             	mov    0x4(%eax),%eax
  802d61:	85 c0                	test   %eax,%eax
  802d63:	74 0c                	je     802d71 <insert_sorted_in_freeList+0x16d>
  802d65:	a1 4c 50 98 00       	mov    0x98504c,%eax
  802d6a:	8b 55 08             	mov    0x8(%ebp),%edx
  802d6d:	89 10                	mov    %edx,(%eax)
  802d6f:	eb 08                	jmp    802d79 <insert_sorted_in_freeList+0x175>
  802d71:	8b 45 08             	mov    0x8(%ebp),%eax
  802d74:	a3 48 50 98 00       	mov    %eax,0x985048
  802d79:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7c:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802d81:	8b 45 08             	mov    0x8(%ebp),%eax
  802d84:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d8a:	a1 54 50 98 00       	mov    0x985054,%eax
  802d8f:	40                   	inc    %eax
  802d90:	a3 54 50 98 00       	mov    %eax,0x985054
}
  802d95:	c9                   	leave  
  802d96:	c3                   	ret    

00802d97 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  802d97:	55                   	push   %ebp
  802d98:	89 e5                	mov    %esp,%ebp
  802d9a:	83 ec 78             	sub    $0x78,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802da0:	83 e0 01             	and    $0x1,%eax
  802da3:	85 c0                	test   %eax,%eax
  802da5:	74 03                	je     802daa <alloc_block_FF+0x13>
  802da7:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802daa:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802dae:	77 07                	ja     802db7 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802db0:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802db7:	a1 40 50 98 00       	mov    0x985040,%eax
  802dbc:	85 c0                	test   %eax,%eax
  802dbe:	75 63                	jne    802e23 <alloc_block_FF+0x8c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc3:	83 c0 10             	add    $0x10,%eax
  802dc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802dc9:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802dd0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dd3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd6:	01 d0                	add    %edx,%eax
  802dd8:	48                   	dec    %eax
  802dd9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802ddc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ddf:	ba 00 00 00 00       	mov    $0x0,%edx
  802de4:	f7 75 ec             	divl   -0x14(%ebp)
  802de7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dea:	29 d0                	sub    %edx,%eax
  802dec:	c1 e8 0c             	shr    $0xc,%eax
  802def:	83 ec 0c             	sub    $0xc,%esp
  802df2:	50                   	push   %eax
  802df3:	e8 d1 ed ff ff       	call   801bc9 <sbrk>
  802df8:	83 c4 10             	add    $0x10,%esp
  802dfb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802dfe:	83 ec 0c             	sub    $0xc,%esp
  802e01:	6a 00                	push   $0x0
  802e03:	e8 c1 ed ff ff       	call   801bc9 <sbrk>
  802e08:	83 c4 10             	add    $0x10,%esp
  802e0b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802e0e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e11:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802e14:	83 ec 08             	sub    $0x8,%esp
  802e17:	50                   	push   %eax
  802e18:	ff 75 e4             	pushl  -0x1c(%ebp)
  802e1b:	e8 75 fc ff ff       	call   802a95 <initialize_dynamic_allocator>
  802e20:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(size == 0)
  802e23:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e27:	75 0a                	jne    802e33 <alloc_block_FF+0x9c>
	{
		return NULL;
  802e29:	b8 00 00 00 00       	mov    $0x0,%eax
  802e2e:	e9 99 03 00 00       	jmp    8031cc <alloc_block_FF+0x435>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  802e33:	8b 45 08             	mov    0x8(%ebp),%eax
  802e36:	83 c0 08             	add    $0x8,%eax
  802e39:	89 45 dc             	mov    %eax,-0x24(%ebp)

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802e3c:	a1 48 50 98 00       	mov    0x985048,%eax
  802e41:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e44:	e9 03 02 00 00       	jmp    80304c <alloc_block_FF+0x2b5>
	{
		uint32 blockSize = get_block_size(block); // Get size without the (LSB) allocation flag
  802e49:	83 ec 0c             	sub    $0xc,%esp
  802e4c:	ff 75 f4             	pushl  -0xc(%ebp)
  802e4f:	e8 dd fa ff ff       	call   802931 <get_block_size>
  802e54:	83 c4 10             	add    $0x10,%esp
  802e57:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if(blockSize >= totalSize)
  802e5a:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802e5d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802e60:	0f 82 de 01 00 00    	jb     803044 <alloc_block_FF+0x2ad>
		{	//if we can put another block with min size 16
			if(blockSize >= totalSize + 4*sizeof(uint32))
  802e66:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e69:	83 c0 10             	add    $0x10,%eax
  802e6c:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  802e6f:	0f 87 32 01 00 00    	ja     802fa7 <alloc_block_FF+0x210>
			{
				// the size that will remain from the block that we will allocate a new block in it
				uint32 remainingSize = blockSize - totalSize;
  802e75:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802e78:	2b 45 dc             	sub    -0x24(%ebp),%eax
  802e7b:	89 45 98             	mov    %eax,-0x68(%ebp)

				// the remaining free space from the block that we use to allocate in it
				struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)block + totalSize);
  802e7e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e81:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e84:	01 d0                	add    %edx,%eax
  802e86:	89 45 94             	mov    %eax,-0x6c(%ebp)
				set_block_data(remainingFreeBlock, remainingSize, 0);
  802e89:	83 ec 04             	sub    $0x4,%esp
  802e8c:	6a 00                	push   $0x0
  802e8e:	ff 75 98             	pushl  -0x68(%ebp)
  802e91:	ff 75 94             	pushl  -0x6c(%ebp)
  802e94:	e8 14 fd ff ff       	call   802bad <set_block_data>
  802e99:	83 c4 10             	add    $0x10,%esp
				// add it after the block we allocated to be sorted by addresses
				LIST_INSERT_AFTER(&freeBlocksList, block,remainingFreeBlock);
  802e9c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ea0:	74 06                	je     802ea8 <alloc_block_FF+0x111>
  802ea2:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
  802ea6:	75 17                	jne    802ebf <alloc_block_FF+0x128>
  802ea8:	83 ec 04             	sub    $0x4,%esp
  802eab:	68 00 48 80 00       	push   $0x804800
  802eb0:	68 de 00 00 00       	push   $0xde
  802eb5:	68 8b 47 80 00       	push   $0x80478b
  802eba:	e8 01 0d 00 00       	call   803bc0 <_panic>
  802ebf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec2:	8b 10                	mov    (%eax),%edx
  802ec4:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802ec7:	89 10                	mov    %edx,(%eax)
  802ec9:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802ecc:	8b 00                	mov    (%eax),%eax
  802ece:	85 c0                	test   %eax,%eax
  802ed0:	74 0b                	je     802edd <alloc_block_FF+0x146>
  802ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed5:	8b 00                	mov    (%eax),%eax
  802ed7:	8b 55 94             	mov    -0x6c(%ebp),%edx
  802eda:	89 50 04             	mov    %edx,0x4(%eax)
  802edd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee0:	8b 55 94             	mov    -0x6c(%ebp),%edx
  802ee3:	89 10                	mov    %edx,(%eax)
  802ee5:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802ee8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802eeb:	89 50 04             	mov    %edx,0x4(%eax)
  802eee:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802ef1:	8b 00                	mov    (%eax),%eax
  802ef3:	85 c0                	test   %eax,%eax
  802ef5:	75 08                	jne    802eff <alloc_block_FF+0x168>
  802ef7:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802efa:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802eff:	a1 54 50 98 00       	mov    0x985054,%eax
  802f04:	40                   	inc    %eax
  802f05:	a3 54 50 98 00       	mov    %eax,0x985054

				// update the allocated block and remove it from freeBlocksList
				set_block_data(block,totalSize,1);
  802f0a:	83 ec 04             	sub    $0x4,%esp
  802f0d:	6a 01                	push   $0x1
  802f0f:	ff 75 dc             	pushl  -0x24(%ebp)
  802f12:	ff 75 f4             	pushl  -0xc(%ebp)
  802f15:	e8 93 fc ff ff       	call   802bad <set_block_data>
  802f1a:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  802f1d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f21:	75 17                	jne    802f3a <alloc_block_FF+0x1a3>
  802f23:	83 ec 04             	sub    $0x4,%esp
  802f26:	68 34 48 80 00       	push   $0x804834
  802f2b:	68 e3 00 00 00       	push   $0xe3
  802f30:	68 8b 47 80 00       	push   $0x80478b
  802f35:	e8 86 0c 00 00       	call   803bc0 <_panic>
  802f3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3d:	8b 00                	mov    (%eax),%eax
  802f3f:	85 c0                	test   %eax,%eax
  802f41:	74 10                	je     802f53 <alloc_block_FF+0x1bc>
  802f43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f46:	8b 00                	mov    (%eax),%eax
  802f48:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f4b:	8b 52 04             	mov    0x4(%edx),%edx
  802f4e:	89 50 04             	mov    %edx,0x4(%eax)
  802f51:	eb 0b                	jmp    802f5e <alloc_block_FF+0x1c7>
  802f53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f56:	8b 40 04             	mov    0x4(%eax),%eax
  802f59:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802f5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f61:	8b 40 04             	mov    0x4(%eax),%eax
  802f64:	85 c0                	test   %eax,%eax
  802f66:	74 0f                	je     802f77 <alloc_block_FF+0x1e0>
  802f68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6b:	8b 40 04             	mov    0x4(%eax),%eax
  802f6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f71:	8b 12                	mov    (%edx),%edx
  802f73:	89 10                	mov    %edx,(%eax)
  802f75:	eb 0a                	jmp    802f81 <alloc_block_FF+0x1ea>
  802f77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7a:	8b 00                	mov    (%eax),%eax
  802f7c:	a3 48 50 98 00       	mov    %eax,0x985048
  802f81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f84:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f94:	a1 54 50 98 00       	mov    0x985054,%eax
  802f99:	48                   	dec    %eax
  802f9a:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  802f9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa2:	e9 25 02 00 00       	jmp    8031cc <alloc_block_FF+0x435>
			}
			else // if set internal fragmentation
			{
				// add the remaining size to the block we allocate so it will be the same main block size
				set_block_data(block,blockSize,1);
  802fa7:	83 ec 04             	sub    $0x4,%esp
  802faa:	6a 01                	push   $0x1
  802fac:	ff 75 9c             	pushl  -0x64(%ebp)
  802faf:	ff 75 f4             	pushl  -0xc(%ebp)
  802fb2:	e8 f6 fb ff ff       	call   802bad <set_block_data>
  802fb7:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  802fba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fbe:	75 17                	jne    802fd7 <alloc_block_FF+0x240>
  802fc0:	83 ec 04             	sub    $0x4,%esp
  802fc3:	68 34 48 80 00       	push   $0x804834
  802fc8:	68 eb 00 00 00       	push   $0xeb
  802fcd:	68 8b 47 80 00       	push   $0x80478b
  802fd2:	e8 e9 0b 00 00       	call   803bc0 <_panic>
  802fd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fda:	8b 00                	mov    (%eax),%eax
  802fdc:	85 c0                	test   %eax,%eax
  802fde:	74 10                	je     802ff0 <alloc_block_FF+0x259>
  802fe0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe3:	8b 00                	mov    (%eax),%eax
  802fe5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fe8:	8b 52 04             	mov    0x4(%edx),%edx
  802feb:	89 50 04             	mov    %edx,0x4(%eax)
  802fee:	eb 0b                	jmp    802ffb <alloc_block_FF+0x264>
  802ff0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff3:	8b 40 04             	mov    0x4(%eax),%eax
  802ff6:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802ffb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffe:	8b 40 04             	mov    0x4(%eax),%eax
  803001:	85 c0                	test   %eax,%eax
  803003:	74 0f                	je     803014 <alloc_block_FF+0x27d>
  803005:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803008:	8b 40 04             	mov    0x4(%eax),%eax
  80300b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80300e:	8b 12                	mov    (%edx),%edx
  803010:	89 10                	mov    %edx,(%eax)
  803012:	eb 0a                	jmp    80301e <alloc_block_FF+0x287>
  803014:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803017:	8b 00                	mov    (%eax),%eax
  803019:	a3 48 50 98 00       	mov    %eax,0x985048
  80301e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803021:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803027:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803031:	a1 54 50 98 00       	mov    0x985054,%eax
  803036:	48                   	dec    %eax
  803037:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  80303c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303f:	e9 88 01 00 00       	jmp    8031cc <alloc_block_FF+0x435>
		return NULL;
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  803044:	a1 50 50 98 00       	mov    0x985050,%eax
  803049:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80304c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803050:	74 07                	je     803059 <alloc_block_FF+0x2c2>
  803052:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803055:	8b 00                	mov    (%eax),%eax
  803057:	eb 05                	jmp    80305e <alloc_block_FF+0x2c7>
  803059:	b8 00 00 00 00       	mov    $0x0,%eax
  80305e:	a3 50 50 98 00       	mov    %eax,0x985050
  803063:	a1 50 50 98 00       	mov    0x985050,%eax
  803068:	85 c0                	test   %eax,%eax
  80306a:	0f 85 d9 fd ff ff    	jne    802e49 <alloc_block_FF+0xb2>
  803070:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803074:	0f 85 cf fd ff ff    	jne    802e49 <alloc_block_FF+0xb2>

//	uint32 *endBlock = &kheapBreak;

	// if we don't find any enough space to allocate the block

	void *oldBreak = sbrk(ROUNDUP(totalSize, PAGE_SIZE) / PAGE_SIZE);
  80307a:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  803081:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803084:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803087:	01 d0                	add    %edx,%eax
  803089:	48                   	dec    %eax
  80308a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80308d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803090:	ba 00 00 00 00       	mov    $0x0,%edx
  803095:	f7 75 d8             	divl   -0x28(%ebp)
  803098:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80309b:	29 d0                	sub    %edx,%eax
  80309d:	c1 e8 0c             	shr    $0xc,%eax
  8030a0:	83 ec 0c             	sub    $0xc,%esp
  8030a3:	50                   	push   %eax
  8030a4:	e8 20 eb ff ff       	call   801bc9 <sbrk>
  8030a9:	83 c4 10             	add    $0x10,%esp
  8030ac:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (oldBreak == (void*)-1) {
  8030af:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8030b3:	75 0a                	jne    8030bf <alloc_block_FF+0x328>
		return NULL;
  8030b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8030ba:	e9 0d 01 00 00       	jmp    8031cc <alloc_block_FF+0x435>
	}
	//uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);

	uint32* endBlk = (uint32 *)((char *)oldBreak - 4);
  8030bf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8030c2:	83 e8 04             	sub    $0x4,%eax
  8030c5:	89 45 cc             	mov    %eax,-0x34(%ebp)
	//endBlk = endBlk+(char *) ROUNDUP(totalSize, PAGE_SIZE);

	endBlk = endBlk + (ROUNDUP(totalSize, PAGE_SIZE) / sizeof(uint32));
  8030c8:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  8030cf:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030d2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8030d5:	01 d0                	add    %edx,%eax
  8030d7:	48                   	dec    %eax
  8030d8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8030db:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8030de:	ba 00 00 00 00       	mov    $0x0,%edx
  8030e3:	f7 75 c8             	divl   -0x38(%ebp)
  8030e6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8030e9:	29 d0                	sub    %edx,%eax
  8030eb:	c1 e8 02             	shr    $0x2,%eax
  8030ee:	c1 e0 02             	shl    $0x2,%eax
  8030f1:	01 45 cc             	add    %eax,-0x34(%ebp)
	*endBlk = 0 | 1;
  8030f4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030f7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	uint32 *footerLast = ((uint32*)oldBreak - 2);
  8030fd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803100:	83 e8 08             	sub    $0x8,%eax
  803103:	89 45 c0             	mov    %eax,-0x40(%ebp)
	uint32 lastSize = (*footerLast) & ~(0x1);
  803106:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803109:	8b 00                	mov    (%eax),%eax
  80310b:	83 e0 fe             	and    $0xfffffffe,%eax
  80310e:	89 45 bc             	mov    %eax,-0x44(%ebp)
	// the last block for the block that we want to free it
	struct BlockElement *laskBlk = (struct BlockElement *)((char*)oldBreak - lastSize);
  803111:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803114:	f7 d8                	neg    %eax
  803116:	89 c2                	mov    %eax,%edx
  803118:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80311b:	01 d0                	add    %edx,%eax
  80311d:	89 45 b8             	mov    %eax,-0x48(%ebp)
	uint32 isLastFree = is_free_block(laskBlk);
  803120:	83 ec 0c             	sub    $0xc,%esp
  803123:	ff 75 b8             	pushl  -0x48(%ebp)
  803126:	e8 1f f8 ff ff       	call   80294a <is_free_block>
  80312b:	83 c4 10             	add    $0x10,%esp
  80312e:	0f be c0             	movsbl %al,%eax
  803131:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(isLastFree)
  803134:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  803138:	74 42                	je     80317c <alloc_block_FF+0x3e5>
	{
		// merge the block will be free with its prev block
		uint32 newBlkSize = lastSize + ROUNDUP(totalSize, PAGE_SIZE); // size of main block and its prev block
  80313a:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  803141:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803144:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803147:	01 d0                	add    %edx,%eax
  803149:	48                   	dec    %eax
  80314a:	89 45 ac             	mov    %eax,-0x54(%ebp)
  80314d:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803150:	ba 00 00 00 00       	mov    $0x0,%edx
  803155:	f7 75 b0             	divl   -0x50(%ebp)
  803158:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80315b:	29 d0                	sub    %edx,%eax
  80315d:	89 c2                	mov    %eax,%edx
  80315f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803162:	01 d0                	add    %edx,%eax
  803164:	89 45 a8             	mov    %eax,-0x58(%ebp)
		// extends last block size to contain its size and the size of new space
		set_block_data(laskBlk,newBlkSize,0);
  803167:	83 ec 04             	sub    $0x4,%esp
  80316a:	6a 00                	push   $0x0
  80316c:	ff 75 a8             	pushl  -0x58(%ebp)
  80316f:	ff 75 b8             	pushl  -0x48(%ebp)
  803172:	e8 36 fa ff ff       	call   802bad <set_block_data>
  803177:	83 c4 10             	add    $0x10,%esp
  80317a:	eb 42                	jmp    8031be <alloc_block_FF+0x427>
	}
	else
	{
		set_block_data(oldBreak,ROUNDUP(totalSize, PAGE_SIZE),0);
  80317c:	c7 45 a4 00 10 00 00 	movl   $0x1000,-0x5c(%ebp)
  803183:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803186:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803189:	01 d0                	add    %edx,%eax
  80318b:	48                   	dec    %eax
  80318c:	89 45 a0             	mov    %eax,-0x60(%ebp)
  80318f:	8b 45 a0             	mov    -0x60(%ebp),%eax
  803192:	ba 00 00 00 00       	mov    $0x0,%edx
  803197:	f7 75 a4             	divl   -0x5c(%ebp)
  80319a:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80319d:	29 d0                	sub    %edx,%eax
  80319f:	83 ec 04             	sub    $0x4,%esp
  8031a2:	6a 00                	push   $0x0
  8031a4:	50                   	push   %eax
  8031a5:	ff 75 d0             	pushl  -0x30(%ebp)
  8031a8:	e8 00 fa ff ff       	call   802bad <set_block_data>
  8031ad:	83 c4 10             	add    $0x10,%esp
		insert_sorted_in_freeList((struct BlockElement *)oldBreak);
  8031b0:	83 ec 0c             	sub    $0xc,%esp
  8031b3:	ff 75 d0             	pushl  -0x30(%ebp)
  8031b6:	e8 49 fa ff ff       	call   802c04 <insert_sorted_in_freeList>
  8031bb:	83 c4 10             	add    $0x10,%esp
//		LIST_INSERT_TAIL(&freeBlocksList,newBreak);
	}
//	set_block_data((struct BlockElement *)newBreak, totalSize, 1);
	return alloc_block_FF(size);
  8031be:	83 ec 0c             	sub    $0xc,%esp
  8031c1:	ff 75 08             	pushl  0x8(%ebp)
  8031c4:	e8 ce fb ff ff       	call   802d97 <alloc_block_FF>
  8031c9:	83 c4 10             	add    $0x10,%esp
}
  8031cc:	c9                   	leave  
  8031cd:	c3                   	ret    

008031ce <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8031ce:	55                   	push   %ebp
  8031cf:	89 e5                	mov    %esp,%ebp
  8031d1:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS1 - BONUS] [3] DYNAMIC ALLOCATOR - alloc_block_BF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_BF is not implemented yet");
	//Your Code is Here...
	if(size == 0)
  8031d4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031d8:	75 0a                	jne    8031e4 <alloc_block_BF+0x16>
	{
		return NULL;
  8031da:	b8 00 00 00 00       	mov    $0x0,%eax
  8031df:	e9 7a 02 00 00       	jmp    80345e <alloc_block_BF+0x290>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  8031e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e7:	83 c0 08             	add    $0x8,%eax
  8031ea:	89 45 e8             	mov    %eax,-0x18(%ebp)

	struct BlockElement *minBlk= NULL;
  8031ed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 minSize = 0xfffffff; // a large number
  8031f4:	c7 45 f0 ff ff ff 0f 	movl   $0xfffffff,-0x10(%ebp)
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  8031fb:	a1 48 50 98 00       	mov    0x985048,%eax
  803200:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803203:	eb 32                	jmp    803237 <alloc_block_BF+0x69>
	{
		uint32 blockSize = get_block_size(block);
  803205:	ff 75 ec             	pushl  -0x14(%ebp)
  803208:	e8 24 f7 ff ff       	call   802931 <get_block_size>
  80320d:	83 c4 04             	add    $0x4,%esp
  803210:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		// if this block can take the new block and its size < min size of all blocks
		if(blockSize >= totalSize && blockSize < minSize)
  803213:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803216:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803219:	72 14                	jb     80322f <alloc_block_BF+0x61>
  80321b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80321e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803221:	73 0c                	jae    80322f <alloc_block_BF+0x61>
		{
			minBlk = block;
  803223:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803226:	89 45 f4             	mov    %eax,-0xc(%ebp)
			minSize = blockSize;
  803229:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80322c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *minBlk= NULL;
	uint32 minSize = 0xfffffff; // a large number
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  80322f:	a1 50 50 98 00       	mov    0x985050,%eax
  803234:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803237:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80323b:	74 07                	je     803244 <alloc_block_BF+0x76>
  80323d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803240:	8b 00                	mov    (%eax),%eax
  803242:	eb 05                	jmp    803249 <alloc_block_BF+0x7b>
  803244:	b8 00 00 00 00       	mov    $0x0,%eax
  803249:	a3 50 50 98 00       	mov    %eax,0x985050
  80324e:	a1 50 50 98 00       	mov    0x985050,%eax
  803253:	85 c0                	test   %eax,%eax
  803255:	75 ae                	jne    803205 <alloc_block_BF+0x37>
  803257:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80325b:	75 a8                	jne    803205 <alloc_block_BF+0x37>
			minSize = blockSize;
		}
	}

	// if we don't find any enough space to allocate the block
	if(minBlk == NULL)
  80325d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803261:	75 22                	jne    803285 <alloc_block_BF+0xb7>
	{
		void *newBlock = sbrk(totalSize);
  803263:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803266:	83 ec 0c             	sub    $0xc,%esp
  803269:	50                   	push   %eax
  80326a:	e8 5a e9 ff ff       	call   801bc9 <sbrk>
  80326f:	83 c4 10             	add    $0x10,%esp
  803272:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (newBlock == (void*)-1) {
  803275:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  803279:	75 0a                	jne    803285 <alloc_block_BF+0xb7>
			return NULL;
  80327b:	b8 00 00 00 00       	mov    $0x0,%eax
  803280:	e9 d9 01 00 00       	jmp    80345e <alloc_block_BF+0x290>
		}
	}

	//if we can put another block with min size 16
	if(minSize >= totalSize + 4*sizeof(uint32))
  803285:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803288:	83 c0 10             	add    $0x10,%eax
  80328b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80328e:	0f 87 32 01 00 00    	ja     8033c6 <alloc_block_BF+0x1f8>
	{
		// the size that will remain from the block that we will allocate a new block in it
		uint32 remainingSize= minSize - totalSize;
  803294:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803297:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80329a:	89 45 dc             	mov    %eax,-0x24(%ebp)

		// the remaining free space from the block that we use to allocate in it
		struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)minBlk + totalSize);
  80329d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a3:	01 d0                	add    %edx,%eax
  8032a5:	89 45 d8             	mov    %eax,-0x28(%ebp)
		set_block_data(remainingFreeBlock, remainingSize, 0);
  8032a8:	83 ec 04             	sub    $0x4,%esp
  8032ab:	6a 00                	push   $0x0
  8032ad:	ff 75 dc             	pushl  -0x24(%ebp)
  8032b0:	ff 75 d8             	pushl  -0x28(%ebp)
  8032b3:	e8 f5 f8 ff ff       	call   802bad <set_block_data>
  8032b8:	83 c4 10             	add    $0x10,%esp
		// add it after the block we allocated to be sorted by addresses
		LIST_INSERT_AFTER(&freeBlocksList, minBlk,remainingFreeBlock);
  8032bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032bf:	74 06                	je     8032c7 <alloc_block_BF+0xf9>
  8032c1:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8032c5:	75 17                	jne    8032de <alloc_block_BF+0x110>
  8032c7:	83 ec 04             	sub    $0x4,%esp
  8032ca:	68 00 48 80 00       	push   $0x804800
  8032cf:	68 49 01 00 00       	push   $0x149
  8032d4:	68 8b 47 80 00       	push   $0x80478b
  8032d9:	e8 e2 08 00 00       	call   803bc0 <_panic>
  8032de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e1:	8b 10                	mov    (%eax),%edx
  8032e3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8032e6:	89 10                	mov    %edx,(%eax)
  8032e8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8032eb:	8b 00                	mov    (%eax),%eax
  8032ed:	85 c0                	test   %eax,%eax
  8032ef:	74 0b                	je     8032fc <alloc_block_BF+0x12e>
  8032f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f4:	8b 00                	mov    (%eax),%eax
  8032f6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8032f9:	89 50 04             	mov    %edx,0x4(%eax)
  8032fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ff:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803302:	89 10                	mov    %edx,(%eax)
  803304:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803307:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80330a:	89 50 04             	mov    %edx,0x4(%eax)
  80330d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803310:	8b 00                	mov    (%eax),%eax
  803312:	85 c0                	test   %eax,%eax
  803314:	75 08                	jne    80331e <alloc_block_BF+0x150>
  803316:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803319:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80331e:	a1 54 50 98 00       	mov    0x985054,%eax
  803323:	40                   	inc    %eax
  803324:	a3 54 50 98 00       	mov    %eax,0x985054

		// update the allocated block and remove it from freeBlocksList
		set_block_data(minBlk,totalSize,1);
  803329:	83 ec 04             	sub    $0x4,%esp
  80332c:	6a 01                	push   $0x1
  80332e:	ff 75 e8             	pushl  -0x18(%ebp)
  803331:	ff 75 f4             	pushl  -0xc(%ebp)
  803334:	e8 74 f8 ff ff       	call   802bad <set_block_data>
  803339:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  80333c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803340:	75 17                	jne    803359 <alloc_block_BF+0x18b>
  803342:	83 ec 04             	sub    $0x4,%esp
  803345:	68 34 48 80 00       	push   $0x804834
  80334a:	68 4e 01 00 00       	push   $0x14e
  80334f:	68 8b 47 80 00       	push   $0x80478b
  803354:	e8 67 08 00 00       	call   803bc0 <_panic>
  803359:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335c:	8b 00                	mov    (%eax),%eax
  80335e:	85 c0                	test   %eax,%eax
  803360:	74 10                	je     803372 <alloc_block_BF+0x1a4>
  803362:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803365:	8b 00                	mov    (%eax),%eax
  803367:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80336a:	8b 52 04             	mov    0x4(%edx),%edx
  80336d:	89 50 04             	mov    %edx,0x4(%eax)
  803370:	eb 0b                	jmp    80337d <alloc_block_BF+0x1af>
  803372:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803375:	8b 40 04             	mov    0x4(%eax),%eax
  803378:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80337d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803380:	8b 40 04             	mov    0x4(%eax),%eax
  803383:	85 c0                	test   %eax,%eax
  803385:	74 0f                	je     803396 <alloc_block_BF+0x1c8>
  803387:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80338a:	8b 40 04             	mov    0x4(%eax),%eax
  80338d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803390:	8b 12                	mov    (%edx),%edx
  803392:	89 10                	mov    %edx,(%eax)
  803394:	eb 0a                	jmp    8033a0 <alloc_block_BF+0x1d2>
  803396:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803399:	8b 00                	mov    (%eax),%eax
  80339b:	a3 48 50 98 00       	mov    %eax,0x985048
  8033a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033b3:	a1 54 50 98 00       	mov    0x985054,%eax
  8033b8:	48                   	dec    %eax
  8033b9:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  8033be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c1:	e9 98 00 00 00       	jmp    80345e <alloc_block_BF+0x290>
	}
	else // if set internal fragmentation
	{
		// add the remaining size to the block we allocate so it will be the same main block size
		set_block_data(minBlk,minSize,1);
  8033c6:	83 ec 04             	sub    $0x4,%esp
  8033c9:	6a 01                	push   $0x1
  8033cb:	ff 75 f0             	pushl  -0x10(%ebp)
  8033ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8033d1:	e8 d7 f7 ff ff       	call   802bad <set_block_data>
  8033d6:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  8033d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033dd:	75 17                	jne    8033f6 <alloc_block_BF+0x228>
  8033df:	83 ec 04             	sub    $0x4,%esp
  8033e2:	68 34 48 80 00       	push   $0x804834
  8033e7:	68 56 01 00 00       	push   $0x156
  8033ec:	68 8b 47 80 00       	push   $0x80478b
  8033f1:	e8 ca 07 00 00       	call   803bc0 <_panic>
  8033f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f9:	8b 00                	mov    (%eax),%eax
  8033fb:	85 c0                	test   %eax,%eax
  8033fd:	74 10                	je     80340f <alloc_block_BF+0x241>
  8033ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803402:	8b 00                	mov    (%eax),%eax
  803404:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803407:	8b 52 04             	mov    0x4(%edx),%edx
  80340a:	89 50 04             	mov    %edx,0x4(%eax)
  80340d:	eb 0b                	jmp    80341a <alloc_block_BF+0x24c>
  80340f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803412:	8b 40 04             	mov    0x4(%eax),%eax
  803415:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80341a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80341d:	8b 40 04             	mov    0x4(%eax),%eax
  803420:	85 c0                	test   %eax,%eax
  803422:	74 0f                	je     803433 <alloc_block_BF+0x265>
  803424:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803427:	8b 40 04             	mov    0x4(%eax),%eax
  80342a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80342d:	8b 12                	mov    (%edx),%edx
  80342f:	89 10                	mov    %edx,(%eax)
  803431:	eb 0a                	jmp    80343d <alloc_block_BF+0x26f>
  803433:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803436:	8b 00                	mov    (%eax),%eax
  803438:	a3 48 50 98 00       	mov    %eax,0x985048
  80343d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803440:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803446:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803449:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803450:	a1 54 50 98 00       	mov    0x985054,%eax
  803455:	48                   	dec    %eax
  803456:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  80345b:	8b 45 f4             	mov    -0xc(%ebp),%eax
	}
	return NULL;
}
  80345e:	c9                   	leave  
  80345f:	c3                   	ret    

00803460 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803460:	55                   	push   %ebp
  803461:	89 e5                	mov    %esp,%ebp
  803463:	83 ec 48             	sub    $0x48,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
  803466:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80346a:	0f 84 6a 02 00 00    	je     8036da <free_block+0x27a>
	{
		return;
	}

	uint32 freeSize = get_block_size(va);
  803470:	ff 75 08             	pushl  0x8(%ebp)
  803473:	e8 b9 f4 ff ff       	call   802931 <get_block_size>
  803478:	83 c4 04             	add    $0x4,%esp
  80347b:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// footer for the prev block for the block that we want to free it
	uint32 *footerPrev = ((uint32*)va - 2 );
  80347e:	8b 45 08             	mov    0x8(%ebp),%eax
  803481:	83 e8 08             	sub    $0x8,%eax
  803484:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 pSize = (*footerPrev) & ~(0x1);
  803487:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80348a:	8b 00                	mov    (%eax),%eax
  80348c:	83 e0 fe             	and    $0xfffffffe,%eax
  80348f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// the prev block for the block that we want to free it
	struct BlockElement * prevBlk = (struct BlockElement *)((char*)va - pSize);
  803492:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803495:	f7 d8                	neg    %eax
  803497:	89 c2                	mov    %eax,%edx
  803499:	8b 45 08             	mov    0x8(%ebp),%eax
  80349c:	01 d0                	add    %edx,%eax
  80349e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	uint32 isPrevFree = is_free_block(prevBlk);
  8034a1:	ff 75 e8             	pushl  -0x18(%ebp)
  8034a4:	e8 a1 f4 ff ff       	call   80294a <is_free_block>
  8034a9:	83 c4 04             	add    $0x4,%esp
  8034ac:	0f be c0             	movsbl %al,%eax
  8034af:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
  8034b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8034b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b8:	01 d0                	add    %edx,%eax
  8034ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  8034bd:	ff 75 e0             	pushl  -0x20(%ebp)
  8034c0:	e8 85 f4 ff ff       	call   80294a <is_free_block>
  8034c5:	83 c4 04             	add    $0x4,%esp
  8034c8:	0f be c0             	movsbl %al,%eax
  8034cb:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if(isPrevFree == 1 && isNextFree == 0)
  8034ce:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  8034d2:	75 34                	jne    803508 <free_block+0xa8>
  8034d4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8034d8:	75 2e                	jne    803508 <free_block+0xa8>
	{
		// merge the block will be free with its prev block
		uint32 prevSize = get_block_size(prevBlk);
  8034da:	ff 75 e8             	pushl  -0x18(%ebp)
  8034dd:	e8 4f f4 ff ff       	call   802931 <get_block_size>
  8034e2:	83 c4 04             	add    $0x4,%esp
  8034e5:	89 45 d8             	mov    %eax,-0x28(%ebp)
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
  8034e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034eb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8034ee:	01 d0                	add    %edx,%eax
  8034f0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
  8034f3:	6a 00                	push   $0x0
  8034f5:	ff 75 d4             	pushl  -0x2c(%ebp)
  8034f8:	ff 75 e8             	pushl  -0x18(%ebp)
  8034fb:	e8 ad f6 ff ff       	call   802bad <set_block_data>
  803500:	83 c4 0c             	add    $0xc,%esp
	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
	uint32 isNextFree = is_free_block(nextBlk);

	if(isPrevFree == 1 && isNextFree == 0)
	{
  803503:	e9 d3 01 00 00       	jmp    8036db <free_block+0x27b>
		uint32 prevSize = get_block_size(prevBlk);
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
  803508:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  80350c:	0f 85 c8 00 00 00    	jne    8035da <free_block+0x17a>
  803512:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803516:	0f 85 be 00 00 00    	jne    8035da <free_block+0x17a>
	{
		// merge the block will be free with its next block
		uint32 nextSize = get_block_size(nextBlk);
  80351c:	ff 75 e0             	pushl  -0x20(%ebp)
  80351f:	e8 0d f4 ff ff       	call   802931 <get_block_size>
  803524:	83 c4 04             	add    $0x4,%esp
  803527:	89 45 d0             	mov    %eax,-0x30(%ebp)
		uint32 totalSize = freeSize + nextSize; // size of main block and its next block
  80352a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80352d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803530:	01 d0                	add    %edx,%eax
  803532:	89 45 cc             	mov    %eax,-0x34(%ebp)
		// update the size of block to contain its size and the size of next block
		set_block_data(va,totalSize,0);
  803535:	6a 00                	push   $0x0
  803537:	ff 75 cc             	pushl  -0x34(%ebp)
  80353a:	ff 75 08             	pushl  0x8(%ebp)
  80353d:	e8 6b f6 ff ff       	call   802bad <set_block_data>
  803542:	83 c4 0c             	add    $0xc,%esp
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
  803545:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803549:	75 17                	jne    803562 <free_block+0x102>
  80354b:	83 ec 04             	sub    $0x4,%esp
  80354e:	68 34 48 80 00       	push   $0x804834
  803553:	68 87 01 00 00       	push   $0x187
  803558:	68 8b 47 80 00       	push   $0x80478b
  80355d:	e8 5e 06 00 00       	call   803bc0 <_panic>
  803562:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803565:	8b 00                	mov    (%eax),%eax
  803567:	85 c0                	test   %eax,%eax
  803569:	74 10                	je     80357b <free_block+0x11b>
  80356b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80356e:	8b 00                	mov    (%eax),%eax
  803570:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803573:	8b 52 04             	mov    0x4(%edx),%edx
  803576:	89 50 04             	mov    %edx,0x4(%eax)
  803579:	eb 0b                	jmp    803586 <free_block+0x126>
  80357b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80357e:	8b 40 04             	mov    0x4(%eax),%eax
  803581:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803586:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803589:	8b 40 04             	mov    0x4(%eax),%eax
  80358c:	85 c0                	test   %eax,%eax
  80358e:	74 0f                	je     80359f <free_block+0x13f>
  803590:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803593:	8b 40 04             	mov    0x4(%eax),%eax
  803596:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803599:	8b 12                	mov    (%edx),%edx
  80359b:	89 10                	mov    %edx,(%eax)
  80359d:	eb 0a                	jmp    8035a9 <free_block+0x149>
  80359f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035a2:	8b 00                	mov    (%eax),%eax
  8035a4:	a3 48 50 98 00       	mov    %eax,0x985048
  8035a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035ac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035b5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035bc:	a1 54 50 98 00       	mov    0x985054,%eax
  8035c1:	48                   	dec    %eax
  8035c2:	a3 54 50 98 00       	mov    %eax,0x985054
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  8035c7:	83 ec 0c             	sub    $0xc,%esp
  8035ca:	ff 75 08             	pushl  0x8(%ebp)
  8035cd:	e8 32 f6 ff ff       	call   802c04 <insert_sorted_in_freeList>
  8035d2:	83 c4 10             	add    $0x10,%esp
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
	{
  8035d5:	e9 01 01 00 00       	jmp    8036db <free_block+0x27b>
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
  8035da:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  8035de:	0f 85 d3 00 00 00    	jne    8036b7 <free_block+0x257>
  8035e4:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  8035e8:	0f 85 c9 00 00 00    	jne    8036b7 <free_block+0x257>
	{
		// merge the block will be free with its prev and next blocks
		uint32 prevSize = get_block_size(prevBlk);
  8035ee:	83 ec 0c             	sub    $0xc,%esp
  8035f1:	ff 75 e8             	pushl  -0x18(%ebp)
  8035f4:	e8 38 f3 ff ff       	call   802931 <get_block_size>
  8035f9:	83 c4 10             	add    $0x10,%esp
  8035fc:	89 45 c8             	mov    %eax,-0x38(%ebp)
		uint32 nextSize = get_block_size(nextBlk);
  8035ff:	83 ec 0c             	sub    $0xc,%esp
  803602:	ff 75 e0             	pushl  -0x20(%ebp)
  803605:	e8 27 f3 ff ff       	call   802931 <get_block_size>
  80360a:	83 c4 10             	add    $0x10,%esp
  80360d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 totalSize = freeSize + prevSize + nextSize; // size of main block and its prev and next blocks
  803610:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803613:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803616:	01 c2                	add    %eax,%edx
  803618:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80361b:	01 d0                	add    %edx,%eax
  80361d:	89 45 c0             	mov    %eax,-0x40(%ebp)
		// extends prev block size to contain its size and the size of main and next blocks
		set_block_data(prevBlk,totalSize,0);
  803620:	83 ec 04             	sub    $0x4,%esp
  803623:	6a 00                	push   $0x0
  803625:	ff 75 c0             	pushl  -0x40(%ebp)
  803628:	ff 75 e8             	pushl  -0x18(%ebp)
  80362b:	e8 7d f5 ff ff       	call   802bad <set_block_data>
  803630:	83 c4 10             	add    $0x10,%esp
		// remove next block because we merge it with its prev blocks
		LIST_REMOVE(&freeBlocksList, nextBlk);
  803633:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803637:	75 17                	jne    803650 <free_block+0x1f0>
  803639:	83 ec 04             	sub    $0x4,%esp
  80363c:	68 34 48 80 00       	push   $0x804834
  803641:	68 94 01 00 00       	push   $0x194
  803646:	68 8b 47 80 00       	push   $0x80478b
  80364b:	e8 70 05 00 00       	call   803bc0 <_panic>
  803650:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803653:	8b 00                	mov    (%eax),%eax
  803655:	85 c0                	test   %eax,%eax
  803657:	74 10                	je     803669 <free_block+0x209>
  803659:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80365c:	8b 00                	mov    (%eax),%eax
  80365e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803661:	8b 52 04             	mov    0x4(%edx),%edx
  803664:	89 50 04             	mov    %edx,0x4(%eax)
  803667:	eb 0b                	jmp    803674 <free_block+0x214>
  803669:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80366c:	8b 40 04             	mov    0x4(%eax),%eax
  80366f:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803674:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803677:	8b 40 04             	mov    0x4(%eax),%eax
  80367a:	85 c0                	test   %eax,%eax
  80367c:	74 0f                	je     80368d <free_block+0x22d>
  80367e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803681:	8b 40 04             	mov    0x4(%eax),%eax
  803684:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803687:	8b 12                	mov    (%edx),%edx
  803689:	89 10                	mov    %edx,(%eax)
  80368b:	eb 0a                	jmp    803697 <free_block+0x237>
  80368d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803690:	8b 00                	mov    (%eax),%eax
  803692:	a3 48 50 98 00       	mov    %eax,0x985048
  803697:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80369a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036a3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036aa:	a1 54 50 98 00       	mov    0x985054,%eax
  8036af:	48                   	dec    %eax
  8036b0:	a3 54 50 98 00       	mov    %eax,0x985054
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
	{
  8036b5:	eb 24                	jmp    8036db <free_block+0x27b>
	}
	else
	{
		// free it without any merge
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
  8036b7:	83 ec 04             	sub    $0x4,%esp
  8036ba:	6a 00                	push   $0x0
  8036bc:	ff 75 f4             	pushl  -0xc(%ebp)
  8036bf:	ff 75 08             	pushl  0x8(%ebp)
  8036c2:	e8 e6 f4 ff ff       	call   802bad <set_block_data>
  8036c7:	83 c4 10             	add    $0x10,%esp
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  8036ca:	83 ec 0c             	sub    $0xc,%esp
  8036cd:	ff 75 08             	pushl  0x8(%ebp)
  8036d0:	e8 2f f5 ff ff       	call   802c04 <insert_sorted_in_freeList>
  8036d5:	83 c4 10             	add    $0x10,%esp
  8036d8:	eb 01                	jmp    8036db <free_block+0x27b>
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
	{
		return;
  8036da:	90                   	nop
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
}
  8036db:	c9                   	leave  
  8036dc:	c3                   	ret    

008036dd <realloc_block_FF>:
//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
  8036dd:	55                   	push   %ebp
  8036de:	89 e5                	mov    %esp,%ebp
  8036e0:	83 ec 38             	sub    $0x38,%esp
	//TODO: [PROJECT'24.MS1 - #08] [3] DYNAMIC ALLOCATOR - realloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(va == NULL && new_size == 0)
  8036e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036e7:	75 10                	jne    8036f9 <realloc_block_FF+0x1c>
  8036e9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8036ed:	75 0a                	jne    8036f9 <realloc_block_FF+0x1c>
	{
		return NULL;
  8036ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8036f4:	e9 8b 04 00 00       	jmp    803b84 <realloc_block_FF+0x4a7>
	}

	if(new_size == 0)
  8036f9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8036fd:	75 18                	jne    803717 <realloc_block_FF+0x3a>
	{
		free_block(va);
  8036ff:	83 ec 0c             	sub    $0xc,%esp
  803702:	ff 75 08             	pushl  0x8(%ebp)
  803705:	e8 56 fd ff ff       	call   803460 <free_block>
  80370a:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80370d:	b8 00 00 00 00       	mov    $0x0,%eax
  803712:	e9 6d 04 00 00       	jmp    803b84 <realloc_block_FF+0x4a7>
	}

	if(va == NULL)
  803717:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80371b:	75 13                	jne    803730 <realloc_block_FF+0x53>
	{
		return alloc_block_FF(new_size);
  80371d:	83 ec 0c             	sub    $0xc,%esp
  803720:	ff 75 0c             	pushl  0xc(%ebp)
  803723:	e8 6f f6 ff ff       	call   802d97 <alloc_block_FF>
  803728:	83 c4 10             	add    $0x10,%esp
  80372b:	e9 54 04 00 00       	jmp    803b84 <realloc_block_FF+0x4a7>
	}

	// if size is odd must be increment it by one
	if (new_size % 2 != 0)
  803730:	8b 45 0c             	mov    0xc(%ebp),%eax
  803733:	83 e0 01             	and    $0x1,%eax
  803736:	85 c0                	test   %eax,%eax
  803738:	74 03                	je     80373d <realloc_block_FF+0x60>
	{
		new_size++;
  80373a:	ff 45 0c             	incl   0xc(%ebp)
	}

	// if size < 8 must be equal it to 8 because min size 8 excluding metadata
	if(new_size < 8)
  80373d:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803741:	77 07                	ja     80374a <realloc_block_FF+0x6d>
	{
		new_size = 8;
  803743:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	}

	new_size += 8; // adds its footer and header size
  80374a:	83 45 0c 08          	addl   $0x8,0xc(%ebp)

	uint32 actualSize = get_block_size(va);
  80374e:	83 ec 0c             	sub    $0xc,%esp
  803751:	ff 75 08             	pushl  0x8(%ebp)
  803754:	e8 d8 f1 ff ff       	call   802931 <get_block_size>
  803759:	83 c4 10             	add    $0x10,%esp
  80375c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(actualSize == new_size)
  80375f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803762:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803765:	75 08                	jne    80376f <realloc_block_FF+0x92>
	{
		// don't change any thing
		return va;
  803767:	8b 45 08             	mov    0x8(%ebp),%eax
  80376a:	e9 15 04 00 00       	jmp    803b84 <realloc_block_FF+0x4a7>
	}

	// next block for the block we want to change its size
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + actualSize);
  80376f:	8b 55 08             	mov    0x8(%ebp),%edx
  803772:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803775:	01 d0                	add    %edx,%eax
  803777:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  80377a:	83 ec 0c             	sub    $0xc,%esp
  80377d:	ff 75 f0             	pushl  -0x10(%ebp)
  803780:	e8 c5 f1 ff ff       	call   80294a <is_free_block>
  803785:	83 c4 10             	add    $0x10,%esp
  803788:	0f be c0             	movsbl %al,%eax
  80378b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 nextSize = get_block_size(nextBlk);
  80378e:	83 ec 0c             	sub    $0xc,%esp
  803791:	ff 75 f0             	pushl  -0x10(%ebp)
  803794:	e8 98 f1 ff ff       	call   802931 <get_block_size>
  803799:	83 c4 10             	add    $0x10,%esp
  80379c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// increase the size of block
	if(new_size > actualSize)
  80379f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037a2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8037a5:	0f 86 a7 02 00 00    	jbe    803a52 <realloc_block_FF+0x375>
	{
		if(isNextFree)
  8037ab:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8037af:	0f 84 86 02 00 00    	je     803a3b <realloc_block_FF+0x35e>
		{
			if(nextSize + actualSize == new_size) // block and nextblock = newSizeBlock
  8037b5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037bb:	01 d0                	add    %edx,%eax
  8037bd:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8037c0:	0f 85 b2 00 00 00    	jne    803878 <realloc_block_FF+0x19b>
			{
				set_block_data(va,new_size,!(is_free_block(va)));// update size in block
  8037c6:	83 ec 0c             	sub    $0xc,%esp
  8037c9:	ff 75 08             	pushl  0x8(%ebp)
  8037cc:	e8 79 f1 ff ff       	call   80294a <is_free_block>
  8037d1:	83 c4 10             	add    $0x10,%esp
  8037d4:	84 c0                	test   %al,%al
  8037d6:	0f 94 c0             	sete   %al
  8037d9:	0f b6 c0             	movzbl %al,%eax
  8037dc:	83 ec 04             	sub    $0x4,%esp
  8037df:	50                   	push   %eax
  8037e0:	ff 75 0c             	pushl  0xc(%ebp)
  8037e3:	ff 75 08             	pushl  0x8(%ebp)
  8037e6:	e8 c2 f3 ff ff       	call   802bad <set_block_data>
  8037eb:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);// remove next because it is = zero
  8037ee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8037f2:	75 17                	jne    80380b <realloc_block_FF+0x12e>
  8037f4:	83 ec 04             	sub    $0x4,%esp
  8037f7:	68 34 48 80 00       	push   $0x804834
  8037fc:	68 db 01 00 00       	push   $0x1db
  803801:	68 8b 47 80 00       	push   $0x80478b
  803806:	e8 b5 03 00 00       	call   803bc0 <_panic>
  80380b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80380e:	8b 00                	mov    (%eax),%eax
  803810:	85 c0                	test   %eax,%eax
  803812:	74 10                	je     803824 <realloc_block_FF+0x147>
  803814:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803817:	8b 00                	mov    (%eax),%eax
  803819:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80381c:	8b 52 04             	mov    0x4(%edx),%edx
  80381f:	89 50 04             	mov    %edx,0x4(%eax)
  803822:	eb 0b                	jmp    80382f <realloc_block_FF+0x152>
  803824:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803827:	8b 40 04             	mov    0x4(%eax),%eax
  80382a:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80382f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803832:	8b 40 04             	mov    0x4(%eax),%eax
  803835:	85 c0                	test   %eax,%eax
  803837:	74 0f                	je     803848 <realloc_block_FF+0x16b>
  803839:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80383c:	8b 40 04             	mov    0x4(%eax),%eax
  80383f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803842:	8b 12                	mov    (%edx),%edx
  803844:	89 10                	mov    %edx,(%eax)
  803846:	eb 0a                	jmp    803852 <realloc_block_FF+0x175>
  803848:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80384b:	8b 00                	mov    (%eax),%eax
  80384d:	a3 48 50 98 00       	mov    %eax,0x985048
  803852:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803855:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80385b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80385e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803865:	a1 54 50 98 00       	mov    0x985054,%eax
  80386a:	48                   	dec    %eax
  80386b:	a3 54 50 98 00       	mov    %eax,0x985054
				return va;
  803870:	8b 45 08             	mov    0x8(%ebp),%eax
  803873:	e9 0c 03 00 00       	jmp    803b84 <realloc_block_FF+0x4a7>
			}
			else if(nextSize + actualSize > new_size) // new size is less than next and main blocks
  803878:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80387b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80387e:	01 d0                	add    %edx,%eax
  803880:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803883:	0f 86 b2 01 00 00    	jbe    803a3b <realloc_block_FF+0x35e>
			{
				uint32 requiredSize = new_size - actualSize; // size that we need from the next block
  803889:	8b 45 0c             	mov    0xc(%ebp),%eax
  80388c:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80388f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				uint32 remainingNext = nextSize - requiredSize; // size that will remain from the next block after we split it
  803892:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803895:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  803898:	89 45 e0             	mov    %eax,-0x20(%ebp)

				// if next size will not fit another block (internal fragmentation)
				if(remainingNext < 16)
  80389b:	83 7d e0 0f          	cmpl   $0xf,-0x20(%ebp)
  80389f:	0f 87 b8 00 00 00    	ja     80395d <realloc_block_FF+0x280>
				{
					// we will take the main size of the block and its next size also
					set_block_data(va,actualSize + nextSize,!(is_free_block(va)));
  8038a5:	83 ec 0c             	sub    $0xc,%esp
  8038a8:	ff 75 08             	pushl  0x8(%ebp)
  8038ab:	e8 9a f0 ff ff       	call   80294a <is_free_block>
  8038b0:	83 c4 10             	add    $0x10,%esp
  8038b3:	84 c0                	test   %al,%al
  8038b5:	0f 94 c0             	sete   %al
  8038b8:	0f b6 c0             	movzbl %al,%eax
  8038bb:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8038be:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038c1:	01 ca                	add    %ecx,%edx
  8038c3:	83 ec 04             	sub    $0x4,%esp
  8038c6:	50                   	push   %eax
  8038c7:	52                   	push   %edx
  8038c8:	ff 75 08             	pushl  0x8(%ebp)
  8038cb:	e8 dd f2 ff ff       	call   802bad <set_block_data>
  8038d0:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,nextBlk);
  8038d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8038d7:	75 17                	jne    8038f0 <realloc_block_FF+0x213>
  8038d9:	83 ec 04             	sub    $0x4,%esp
  8038dc:	68 34 48 80 00       	push   $0x804834
  8038e1:	68 e8 01 00 00       	push   $0x1e8
  8038e6:	68 8b 47 80 00       	push   $0x80478b
  8038eb:	e8 d0 02 00 00       	call   803bc0 <_panic>
  8038f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038f3:	8b 00                	mov    (%eax),%eax
  8038f5:	85 c0                	test   %eax,%eax
  8038f7:	74 10                	je     803909 <realloc_block_FF+0x22c>
  8038f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038fc:	8b 00                	mov    (%eax),%eax
  8038fe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803901:	8b 52 04             	mov    0x4(%edx),%edx
  803904:	89 50 04             	mov    %edx,0x4(%eax)
  803907:	eb 0b                	jmp    803914 <realloc_block_FF+0x237>
  803909:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80390c:	8b 40 04             	mov    0x4(%eax),%eax
  80390f:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803914:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803917:	8b 40 04             	mov    0x4(%eax),%eax
  80391a:	85 c0                	test   %eax,%eax
  80391c:	74 0f                	je     80392d <realloc_block_FF+0x250>
  80391e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803921:	8b 40 04             	mov    0x4(%eax),%eax
  803924:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803927:	8b 12                	mov    (%edx),%edx
  803929:	89 10                	mov    %edx,(%eax)
  80392b:	eb 0a                	jmp    803937 <realloc_block_FF+0x25a>
  80392d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803930:	8b 00                	mov    (%eax),%eax
  803932:	a3 48 50 98 00       	mov    %eax,0x985048
  803937:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80393a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803940:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803943:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80394a:	a1 54 50 98 00       	mov    0x985054,%eax
  80394f:	48                   	dec    %eax
  803950:	a3 54 50 98 00       	mov    %eax,0x985054
					return va;
  803955:	8b 45 08             	mov    0x8(%ebp),%eax
  803958:	e9 27 02 00 00       	jmp    803b84 <realloc_block_FF+0x4a7>
				}
				else // if next size can be fit another block (split)
				{
					LIST_REMOVE(&freeBlocksList,nextBlk);
  80395d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803961:	75 17                	jne    80397a <realloc_block_FF+0x29d>
  803963:	83 ec 04             	sub    $0x4,%esp
  803966:	68 34 48 80 00       	push   $0x804834
  80396b:	68 ed 01 00 00       	push   $0x1ed
  803970:	68 8b 47 80 00       	push   $0x80478b
  803975:	e8 46 02 00 00       	call   803bc0 <_panic>
  80397a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80397d:	8b 00                	mov    (%eax),%eax
  80397f:	85 c0                	test   %eax,%eax
  803981:	74 10                	je     803993 <realloc_block_FF+0x2b6>
  803983:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803986:	8b 00                	mov    (%eax),%eax
  803988:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80398b:	8b 52 04             	mov    0x4(%edx),%edx
  80398e:	89 50 04             	mov    %edx,0x4(%eax)
  803991:	eb 0b                	jmp    80399e <realloc_block_FF+0x2c1>
  803993:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803996:	8b 40 04             	mov    0x4(%eax),%eax
  803999:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80399e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039a1:	8b 40 04             	mov    0x4(%eax),%eax
  8039a4:	85 c0                	test   %eax,%eax
  8039a6:	74 0f                	je     8039b7 <realloc_block_FF+0x2da>
  8039a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039ab:	8b 40 04             	mov    0x4(%eax),%eax
  8039ae:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8039b1:	8b 12                	mov    (%edx),%edx
  8039b3:	89 10                	mov    %edx,(%eax)
  8039b5:	eb 0a                	jmp    8039c1 <realloc_block_FF+0x2e4>
  8039b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039ba:	8b 00                	mov    (%eax),%eax
  8039bc:	a3 48 50 98 00       	mov    %eax,0x985048
  8039c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039c4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039cd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039d4:	a1 54 50 98 00       	mov    0x985054,%eax
  8039d9:	48                   	dec    %eax
  8039da:	a3 54 50 98 00       	mov    %eax,0x985054
					nextBlk = (struct BlockElement *)((char *)va + new_size); //update nextBlk address
  8039df:	8b 55 08             	mov    0x8(%ebp),%edx
  8039e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039e5:	01 d0                	add    %edx,%eax
  8039e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
					set_block_data(nextBlk,remainingNext,0); // update nextBlkSize
  8039ea:	83 ec 04             	sub    $0x4,%esp
  8039ed:	6a 00                	push   $0x0
  8039ef:	ff 75 e0             	pushl  -0x20(%ebp)
  8039f2:	ff 75 f0             	pushl  -0x10(%ebp)
  8039f5:	e8 b3 f1 ff ff       	call   802bad <set_block_data>
  8039fa:	83 c4 10             	add    $0x10,%esp
					set_block_data(va,new_size,!(is_free_block(va))); // update size of newblock
  8039fd:	83 ec 0c             	sub    $0xc,%esp
  803a00:	ff 75 08             	pushl  0x8(%ebp)
  803a03:	e8 42 ef ff ff       	call   80294a <is_free_block>
  803a08:	83 c4 10             	add    $0x10,%esp
  803a0b:	84 c0                	test   %al,%al
  803a0d:	0f 94 c0             	sete   %al
  803a10:	0f b6 c0             	movzbl %al,%eax
  803a13:	83 ec 04             	sub    $0x4,%esp
  803a16:	50                   	push   %eax
  803a17:	ff 75 0c             	pushl  0xc(%ebp)
  803a1a:	ff 75 08             	pushl  0x8(%ebp)
  803a1d:	e8 8b f1 ff ff       	call   802bad <set_block_data>
  803a22:	83 c4 10             	add    $0x10,%esp
					insert_sorted_in_freeList(nextBlk);
  803a25:	83 ec 0c             	sub    $0xc,%esp
  803a28:	ff 75 f0             	pushl  -0x10(%ebp)
  803a2b:	e8 d4 f1 ff ff       	call   802c04 <insert_sorted_in_freeList>
  803a30:	83 c4 10             	add    $0x10,%esp
					return va;
  803a33:	8b 45 08             	mov    0x8(%ebp),%eax
  803a36:	e9 49 01 00 00       	jmp    803b84 <realloc_block_FF+0x4a7>
				}
			}
		}
		// if next block isn't free or not fit the new size
		return alloc_block_FF(new_size - 8);
  803a3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a3e:	83 e8 08             	sub    $0x8,%eax
  803a41:	83 ec 0c             	sub    $0xc,%esp
  803a44:	50                   	push   %eax
  803a45:	e8 4d f3 ff ff       	call   802d97 <alloc_block_FF>
  803a4a:	83 c4 10             	add    $0x10,%esp
  803a4d:	e9 32 01 00 00       	jmp    803b84 <realloc_block_FF+0x4a7>
	}
	else if(new_size < actualSize) // to shrink block
  803a52:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a55:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803a58:	0f 83 21 01 00 00    	jae    803b7f <realloc_block_FF+0x4a2>
	{
		uint32 remainingSize = actualSize - new_size; // size that will remain from the main block after we shrink it
  803a5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a61:	2b 45 0c             	sub    0xc(%ebp),%eax
  803a64:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(remainingSize < 16 && isNextFree == 0) // internal fragmentation
  803a67:	83 7d dc 0f          	cmpl   $0xf,-0x24(%ebp)
  803a6b:	77 0e                	ja     803a7b <realloc_block_FF+0x39e>
  803a6d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803a71:	75 08                	jne    803a7b <realloc_block_FF+0x39e>
		{
			// don't change its size
			return va;
  803a73:	8b 45 08             	mov    0x8(%ebp),%eax
  803a76:	e9 09 01 00 00       	jmp    803b84 <realloc_block_FF+0x4a7>
		}
		else // remainingSize fit in a new block
		{
			struct BlockElement *mainBlk = (struct BlockElement *)va;
  803a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  803a7e:	89 45 d8             	mov    %eax,-0x28(%ebp)
			// update main block with new size
			set_block_data(mainBlk,new_size,!(is_free_block(va)));
  803a81:	83 ec 0c             	sub    $0xc,%esp
  803a84:	ff 75 08             	pushl  0x8(%ebp)
  803a87:	e8 be ee ff ff       	call   80294a <is_free_block>
  803a8c:	83 c4 10             	add    $0x10,%esp
  803a8f:	84 c0                	test   %al,%al
  803a91:	0f 94 c0             	sete   %al
  803a94:	0f b6 c0             	movzbl %al,%eax
  803a97:	83 ec 04             	sub    $0x4,%esp
  803a9a:	50                   	push   %eax
  803a9b:	ff 75 0c             	pushl  0xc(%ebp)
  803a9e:	ff 75 d8             	pushl  -0x28(%ebp)
  803aa1:	e8 07 f1 ff ff       	call   802bad <set_block_data>
  803aa6:	83 c4 10             	add    $0x10,%esp

			// the blk with remaining size
			struct BlockElement *remainingBlk=(struct BlockElement *)((char*)mainBlk + new_size);
  803aa9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803aac:	8b 45 0c             	mov    0xc(%ebp),%eax
  803aaf:	01 d0                	add    %edx,%eax
  803ab1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			set_block_data(remainingBlk,remainingSize,0);
  803ab4:	83 ec 04             	sub    $0x4,%esp
  803ab7:	6a 00                	push   $0x0
  803ab9:	ff 75 dc             	pushl  -0x24(%ebp)
  803abc:	ff 75 d4             	pushl  -0x2c(%ebp)
  803abf:	e8 e9 f0 ff ff       	call   802bad <set_block_data>
  803ac4:	83 c4 10             	add    $0x10,%esp

			if(isNextFree)
  803ac7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803acb:	0f 84 9b 00 00 00    	je     803b6c <realloc_block_FF+0x48f>
			{
				// merge splited block with its next block
				set_block_data(remainingBlk,(remainingSize + nextSize),0);//merge remaining with its next block
  803ad1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803ad4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ad7:	01 d0                	add    %edx,%eax
  803ad9:	83 ec 04             	sub    $0x4,%esp
  803adc:	6a 00                	push   $0x0
  803ade:	50                   	push   %eax
  803adf:	ff 75 d4             	pushl  -0x2c(%ebp)
  803ae2:	e8 c6 f0 ff ff       	call   802bad <set_block_data>
  803ae7:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);
  803aea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803aee:	75 17                	jne    803b07 <realloc_block_FF+0x42a>
  803af0:	83 ec 04             	sub    $0x4,%esp
  803af3:	68 34 48 80 00       	push   $0x804834
  803af8:	68 10 02 00 00       	push   $0x210
  803afd:	68 8b 47 80 00       	push   $0x80478b
  803b02:	e8 b9 00 00 00       	call   803bc0 <_panic>
  803b07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b0a:	8b 00                	mov    (%eax),%eax
  803b0c:	85 c0                	test   %eax,%eax
  803b0e:	74 10                	je     803b20 <realloc_block_FF+0x443>
  803b10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b13:	8b 00                	mov    (%eax),%eax
  803b15:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b18:	8b 52 04             	mov    0x4(%edx),%edx
  803b1b:	89 50 04             	mov    %edx,0x4(%eax)
  803b1e:	eb 0b                	jmp    803b2b <realloc_block_FF+0x44e>
  803b20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b23:	8b 40 04             	mov    0x4(%eax),%eax
  803b26:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803b2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b2e:	8b 40 04             	mov    0x4(%eax),%eax
  803b31:	85 c0                	test   %eax,%eax
  803b33:	74 0f                	je     803b44 <realloc_block_FF+0x467>
  803b35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b38:	8b 40 04             	mov    0x4(%eax),%eax
  803b3b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b3e:	8b 12                	mov    (%edx),%edx
  803b40:	89 10                	mov    %edx,(%eax)
  803b42:	eb 0a                	jmp    803b4e <realloc_block_FF+0x471>
  803b44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b47:	8b 00                	mov    (%eax),%eax
  803b49:	a3 48 50 98 00       	mov    %eax,0x985048
  803b4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b51:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b5a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b61:	a1 54 50 98 00       	mov    0x985054,%eax
  803b66:	48                   	dec    %eax
  803b67:	a3 54 50 98 00       	mov    %eax,0x985054
			}
			insert_sorted_in_freeList(remainingBlk);
  803b6c:	83 ec 0c             	sub    $0xc,%esp
  803b6f:	ff 75 d4             	pushl  -0x2c(%ebp)
  803b72:	e8 8d f0 ff ff       	call   802c04 <insert_sorted_in_freeList>
  803b77:	83 c4 10             	add    $0x10,%esp
			return mainBlk;
  803b7a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803b7d:	eb 05                	jmp    803b84 <realloc_block_FF+0x4a7>
		}
	}
	return NULL;
  803b7f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b84:	c9                   	leave  
  803b85:	c3                   	ret    

00803b86 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803b86:	55                   	push   %ebp
  803b87:	89 e5                	mov    %esp,%ebp
  803b89:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803b8c:	83 ec 04             	sub    $0x4,%esp
  803b8f:	68 54 48 80 00       	push   $0x804854
  803b94:	68 20 02 00 00       	push   $0x220
  803b99:	68 8b 47 80 00       	push   $0x80478b
  803b9e:	e8 1d 00 00 00       	call   803bc0 <_panic>

00803ba3 <alloc_block_NF>:
}
//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803ba3:	55                   	push   %ebp
  803ba4:	89 e5                	mov    %esp,%ebp
  803ba6:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803ba9:	83 ec 04             	sub    $0x4,%esp
  803bac:	68 7c 48 80 00       	push   $0x80487c
  803bb1:	68 28 02 00 00       	push   $0x228
  803bb6:	68 8b 47 80 00       	push   $0x80478b
  803bbb:	e8 00 00 00 00       	call   803bc0 <_panic>

00803bc0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803bc0:	55                   	push   %ebp
  803bc1:	89 e5                	mov    %esp,%ebp
  803bc3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803bc6:	8d 45 10             	lea    0x10(%ebp),%eax
  803bc9:	83 c0 04             	add    $0x4,%eax
  803bcc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803bcf:	a1 60 50 98 00       	mov    0x985060,%eax
  803bd4:	85 c0                	test   %eax,%eax
  803bd6:	74 16                	je     803bee <_panic+0x2e>
		cprintf("%s: ", argv0);
  803bd8:	a1 60 50 98 00       	mov    0x985060,%eax
  803bdd:	83 ec 08             	sub    $0x8,%esp
  803be0:	50                   	push   %eax
  803be1:	68 a4 48 80 00       	push   $0x8048a4
  803be6:	e8 3c d0 ff ff       	call   800c27 <cprintf>
  803beb:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803bee:	a1 04 50 80 00       	mov    0x805004,%eax
  803bf3:	ff 75 0c             	pushl  0xc(%ebp)
  803bf6:	ff 75 08             	pushl  0x8(%ebp)
  803bf9:	50                   	push   %eax
  803bfa:	68 a9 48 80 00       	push   $0x8048a9
  803bff:	e8 23 d0 ff ff       	call   800c27 <cprintf>
  803c04:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803c07:	8b 45 10             	mov    0x10(%ebp),%eax
  803c0a:	83 ec 08             	sub    $0x8,%esp
  803c0d:	ff 75 f4             	pushl  -0xc(%ebp)
  803c10:	50                   	push   %eax
  803c11:	e8 a6 cf ff ff       	call   800bbc <vcprintf>
  803c16:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803c19:	83 ec 08             	sub    $0x8,%esp
  803c1c:	6a 00                	push   $0x0
  803c1e:	68 c5 48 80 00       	push   $0x8048c5
  803c23:	e8 94 cf ff ff       	call   800bbc <vcprintf>
  803c28:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803c2b:	e8 15 cf ff ff       	call   800b45 <exit>

	// should not return here
	while (1) ;
  803c30:	eb fe                	jmp    803c30 <_panic+0x70>

00803c32 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803c32:	55                   	push   %ebp
  803c33:	89 e5                	mov    %esp,%ebp
  803c35:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803c38:	a1 20 50 80 00       	mov    0x805020,%eax
  803c3d:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803c43:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c46:	39 c2                	cmp    %eax,%edx
  803c48:	74 14                	je     803c5e <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803c4a:	83 ec 04             	sub    $0x4,%esp
  803c4d:	68 c8 48 80 00       	push   $0x8048c8
  803c52:	6a 26                	push   $0x26
  803c54:	68 14 49 80 00       	push   $0x804914
  803c59:	e8 62 ff ff ff       	call   803bc0 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803c5e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803c65:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803c6c:	e9 c5 00 00 00       	jmp    803d36 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803c71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c74:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  803c7e:	01 d0                	add    %edx,%eax
  803c80:	8b 00                	mov    (%eax),%eax
  803c82:	85 c0                	test   %eax,%eax
  803c84:	75 08                	jne    803c8e <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803c86:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803c89:	e9 a5 00 00 00       	jmp    803d33 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803c8e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803c95:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803c9c:	eb 69                	jmp    803d07 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803c9e:	a1 20 50 80 00       	mov    0x805020,%eax
  803ca3:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  803ca9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803cac:	89 d0                	mov    %edx,%eax
  803cae:	01 c0                	add    %eax,%eax
  803cb0:	01 d0                	add    %edx,%eax
  803cb2:	c1 e0 03             	shl    $0x3,%eax
  803cb5:	01 c8                	add    %ecx,%eax
  803cb7:	8a 40 04             	mov    0x4(%eax),%al
  803cba:	84 c0                	test   %al,%al
  803cbc:	75 46                	jne    803d04 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803cbe:	a1 20 50 80 00       	mov    0x805020,%eax
  803cc3:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  803cc9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803ccc:	89 d0                	mov    %edx,%eax
  803cce:	01 c0                	add    %eax,%eax
  803cd0:	01 d0                	add    %edx,%eax
  803cd2:	c1 e0 03             	shl    $0x3,%eax
  803cd5:	01 c8                	add    %ecx,%eax
  803cd7:	8b 00                	mov    (%eax),%eax
  803cd9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803cdc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803cdf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803ce4:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803ce6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ce9:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  803cf3:	01 c8                	add    %ecx,%eax
  803cf5:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803cf7:	39 c2                	cmp    %eax,%edx
  803cf9:	75 09                	jne    803d04 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803cfb:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803d02:	eb 15                	jmp    803d19 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803d04:	ff 45 e8             	incl   -0x18(%ebp)
  803d07:	a1 20 50 80 00       	mov    0x805020,%eax
  803d0c:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803d12:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d15:	39 c2                	cmp    %eax,%edx
  803d17:	77 85                	ja     803c9e <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803d19:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803d1d:	75 14                	jne    803d33 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803d1f:	83 ec 04             	sub    $0x4,%esp
  803d22:	68 20 49 80 00       	push   $0x804920
  803d27:	6a 3a                	push   $0x3a
  803d29:	68 14 49 80 00       	push   $0x804914
  803d2e:	e8 8d fe ff ff       	call   803bc0 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803d33:	ff 45 f0             	incl   -0x10(%ebp)
  803d36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d39:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803d3c:	0f 8c 2f ff ff ff    	jl     803c71 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803d42:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803d49:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803d50:	eb 26                	jmp    803d78 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803d52:	a1 20 50 80 00       	mov    0x805020,%eax
  803d57:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  803d5d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803d60:	89 d0                	mov    %edx,%eax
  803d62:	01 c0                	add    %eax,%eax
  803d64:	01 d0                	add    %edx,%eax
  803d66:	c1 e0 03             	shl    $0x3,%eax
  803d69:	01 c8                	add    %ecx,%eax
  803d6b:	8a 40 04             	mov    0x4(%eax),%al
  803d6e:	3c 01                	cmp    $0x1,%al
  803d70:	75 03                	jne    803d75 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803d72:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803d75:	ff 45 e0             	incl   -0x20(%ebp)
  803d78:	a1 20 50 80 00       	mov    0x805020,%eax
  803d7d:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803d83:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d86:	39 c2                	cmp    %eax,%edx
  803d88:	77 c8                	ja     803d52 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803d8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d8d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803d90:	74 14                	je     803da6 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803d92:	83 ec 04             	sub    $0x4,%esp
  803d95:	68 74 49 80 00       	push   $0x804974
  803d9a:	6a 44                	push   $0x44
  803d9c:	68 14 49 80 00       	push   $0x804914
  803da1:	e8 1a fe ff ff       	call   803bc0 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803da6:	90                   	nop
  803da7:	c9                   	leave  
  803da8:	c3                   	ret    
  803da9:	66 90                	xchg   %ax,%ax
  803dab:	90                   	nop

00803dac <__udivdi3>:
  803dac:	55                   	push   %ebp
  803dad:	57                   	push   %edi
  803dae:	56                   	push   %esi
  803daf:	53                   	push   %ebx
  803db0:	83 ec 1c             	sub    $0x1c,%esp
  803db3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803db7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803dbb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803dbf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803dc3:	89 ca                	mov    %ecx,%edx
  803dc5:	89 f8                	mov    %edi,%eax
  803dc7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803dcb:	85 f6                	test   %esi,%esi
  803dcd:	75 2d                	jne    803dfc <__udivdi3+0x50>
  803dcf:	39 cf                	cmp    %ecx,%edi
  803dd1:	77 65                	ja     803e38 <__udivdi3+0x8c>
  803dd3:	89 fd                	mov    %edi,%ebp
  803dd5:	85 ff                	test   %edi,%edi
  803dd7:	75 0b                	jne    803de4 <__udivdi3+0x38>
  803dd9:	b8 01 00 00 00       	mov    $0x1,%eax
  803dde:	31 d2                	xor    %edx,%edx
  803de0:	f7 f7                	div    %edi
  803de2:	89 c5                	mov    %eax,%ebp
  803de4:	31 d2                	xor    %edx,%edx
  803de6:	89 c8                	mov    %ecx,%eax
  803de8:	f7 f5                	div    %ebp
  803dea:	89 c1                	mov    %eax,%ecx
  803dec:	89 d8                	mov    %ebx,%eax
  803dee:	f7 f5                	div    %ebp
  803df0:	89 cf                	mov    %ecx,%edi
  803df2:	89 fa                	mov    %edi,%edx
  803df4:	83 c4 1c             	add    $0x1c,%esp
  803df7:	5b                   	pop    %ebx
  803df8:	5e                   	pop    %esi
  803df9:	5f                   	pop    %edi
  803dfa:	5d                   	pop    %ebp
  803dfb:	c3                   	ret    
  803dfc:	39 ce                	cmp    %ecx,%esi
  803dfe:	77 28                	ja     803e28 <__udivdi3+0x7c>
  803e00:	0f bd fe             	bsr    %esi,%edi
  803e03:	83 f7 1f             	xor    $0x1f,%edi
  803e06:	75 40                	jne    803e48 <__udivdi3+0x9c>
  803e08:	39 ce                	cmp    %ecx,%esi
  803e0a:	72 0a                	jb     803e16 <__udivdi3+0x6a>
  803e0c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803e10:	0f 87 9e 00 00 00    	ja     803eb4 <__udivdi3+0x108>
  803e16:	b8 01 00 00 00       	mov    $0x1,%eax
  803e1b:	89 fa                	mov    %edi,%edx
  803e1d:	83 c4 1c             	add    $0x1c,%esp
  803e20:	5b                   	pop    %ebx
  803e21:	5e                   	pop    %esi
  803e22:	5f                   	pop    %edi
  803e23:	5d                   	pop    %ebp
  803e24:	c3                   	ret    
  803e25:	8d 76 00             	lea    0x0(%esi),%esi
  803e28:	31 ff                	xor    %edi,%edi
  803e2a:	31 c0                	xor    %eax,%eax
  803e2c:	89 fa                	mov    %edi,%edx
  803e2e:	83 c4 1c             	add    $0x1c,%esp
  803e31:	5b                   	pop    %ebx
  803e32:	5e                   	pop    %esi
  803e33:	5f                   	pop    %edi
  803e34:	5d                   	pop    %ebp
  803e35:	c3                   	ret    
  803e36:	66 90                	xchg   %ax,%ax
  803e38:	89 d8                	mov    %ebx,%eax
  803e3a:	f7 f7                	div    %edi
  803e3c:	31 ff                	xor    %edi,%edi
  803e3e:	89 fa                	mov    %edi,%edx
  803e40:	83 c4 1c             	add    $0x1c,%esp
  803e43:	5b                   	pop    %ebx
  803e44:	5e                   	pop    %esi
  803e45:	5f                   	pop    %edi
  803e46:	5d                   	pop    %ebp
  803e47:	c3                   	ret    
  803e48:	bd 20 00 00 00       	mov    $0x20,%ebp
  803e4d:	89 eb                	mov    %ebp,%ebx
  803e4f:	29 fb                	sub    %edi,%ebx
  803e51:	89 f9                	mov    %edi,%ecx
  803e53:	d3 e6                	shl    %cl,%esi
  803e55:	89 c5                	mov    %eax,%ebp
  803e57:	88 d9                	mov    %bl,%cl
  803e59:	d3 ed                	shr    %cl,%ebp
  803e5b:	89 e9                	mov    %ebp,%ecx
  803e5d:	09 f1                	or     %esi,%ecx
  803e5f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803e63:	89 f9                	mov    %edi,%ecx
  803e65:	d3 e0                	shl    %cl,%eax
  803e67:	89 c5                	mov    %eax,%ebp
  803e69:	89 d6                	mov    %edx,%esi
  803e6b:	88 d9                	mov    %bl,%cl
  803e6d:	d3 ee                	shr    %cl,%esi
  803e6f:	89 f9                	mov    %edi,%ecx
  803e71:	d3 e2                	shl    %cl,%edx
  803e73:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e77:	88 d9                	mov    %bl,%cl
  803e79:	d3 e8                	shr    %cl,%eax
  803e7b:	09 c2                	or     %eax,%edx
  803e7d:	89 d0                	mov    %edx,%eax
  803e7f:	89 f2                	mov    %esi,%edx
  803e81:	f7 74 24 0c          	divl   0xc(%esp)
  803e85:	89 d6                	mov    %edx,%esi
  803e87:	89 c3                	mov    %eax,%ebx
  803e89:	f7 e5                	mul    %ebp
  803e8b:	39 d6                	cmp    %edx,%esi
  803e8d:	72 19                	jb     803ea8 <__udivdi3+0xfc>
  803e8f:	74 0b                	je     803e9c <__udivdi3+0xf0>
  803e91:	89 d8                	mov    %ebx,%eax
  803e93:	31 ff                	xor    %edi,%edi
  803e95:	e9 58 ff ff ff       	jmp    803df2 <__udivdi3+0x46>
  803e9a:	66 90                	xchg   %ax,%ax
  803e9c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803ea0:	89 f9                	mov    %edi,%ecx
  803ea2:	d3 e2                	shl    %cl,%edx
  803ea4:	39 c2                	cmp    %eax,%edx
  803ea6:	73 e9                	jae    803e91 <__udivdi3+0xe5>
  803ea8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803eab:	31 ff                	xor    %edi,%edi
  803ead:	e9 40 ff ff ff       	jmp    803df2 <__udivdi3+0x46>
  803eb2:	66 90                	xchg   %ax,%ax
  803eb4:	31 c0                	xor    %eax,%eax
  803eb6:	e9 37 ff ff ff       	jmp    803df2 <__udivdi3+0x46>
  803ebb:	90                   	nop

00803ebc <__umoddi3>:
  803ebc:	55                   	push   %ebp
  803ebd:	57                   	push   %edi
  803ebe:	56                   	push   %esi
  803ebf:	53                   	push   %ebx
  803ec0:	83 ec 1c             	sub    $0x1c,%esp
  803ec3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803ec7:	8b 74 24 34          	mov    0x34(%esp),%esi
  803ecb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803ecf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803ed3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803ed7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803edb:	89 f3                	mov    %esi,%ebx
  803edd:	89 fa                	mov    %edi,%edx
  803edf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ee3:	89 34 24             	mov    %esi,(%esp)
  803ee6:	85 c0                	test   %eax,%eax
  803ee8:	75 1a                	jne    803f04 <__umoddi3+0x48>
  803eea:	39 f7                	cmp    %esi,%edi
  803eec:	0f 86 a2 00 00 00    	jbe    803f94 <__umoddi3+0xd8>
  803ef2:	89 c8                	mov    %ecx,%eax
  803ef4:	89 f2                	mov    %esi,%edx
  803ef6:	f7 f7                	div    %edi
  803ef8:	89 d0                	mov    %edx,%eax
  803efa:	31 d2                	xor    %edx,%edx
  803efc:	83 c4 1c             	add    $0x1c,%esp
  803eff:	5b                   	pop    %ebx
  803f00:	5e                   	pop    %esi
  803f01:	5f                   	pop    %edi
  803f02:	5d                   	pop    %ebp
  803f03:	c3                   	ret    
  803f04:	39 f0                	cmp    %esi,%eax
  803f06:	0f 87 ac 00 00 00    	ja     803fb8 <__umoddi3+0xfc>
  803f0c:	0f bd e8             	bsr    %eax,%ebp
  803f0f:	83 f5 1f             	xor    $0x1f,%ebp
  803f12:	0f 84 ac 00 00 00    	je     803fc4 <__umoddi3+0x108>
  803f18:	bf 20 00 00 00       	mov    $0x20,%edi
  803f1d:	29 ef                	sub    %ebp,%edi
  803f1f:	89 fe                	mov    %edi,%esi
  803f21:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803f25:	89 e9                	mov    %ebp,%ecx
  803f27:	d3 e0                	shl    %cl,%eax
  803f29:	89 d7                	mov    %edx,%edi
  803f2b:	89 f1                	mov    %esi,%ecx
  803f2d:	d3 ef                	shr    %cl,%edi
  803f2f:	09 c7                	or     %eax,%edi
  803f31:	89 e9                	mov    %ebp,%ecx
  803f33:	d3 e2                	shl    %cl,%edx
  803f35:	89 14 24             	mov    %edx,(%esp)
  803f38:	89 d8                	mov    %ebx,%eax
  803f3a:	d3 e0                	shl    %cl,%eax
  803f3c:	89 c2                	mov    %eax,%edx
  803f3e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803f42:	d3 e0                	shl    %cl,%eax
  803f44:	89 44 24 04          	mov    %eax,0x4(%esp)
  803f48:	8b 44 24 08          	mov    0x8(%esp),%eax
  803f4c:	89 f1                	mov    %esi,%ecx
  803f4e:	d3 e8                	shr    %cl,%eax
  803f50:	09 d0                	or     %edx,%eax
  803f52:	d3 eb                	shr    %cl,%ebx
  803f54:	89 da                	mov    %ebx,%edx
  803f56:	f7 f7                	div    %edi
  803f58:	89 d3                	mov    %edx,%ebx
  803f5a:	f7 24 24             	mull   (%esp)
  803f5d:	89 c6                	mov    %eax,%esi
  803f5f:	89 d1                	mov    %edx,%ecx
  803f61:	39 d3                	cmp    %edx,%ebx
  803f63:	0f 82 87 00 00 00    	jb     803ff0 <__umoddi3+0x134>
  803f69:	0f 84 91 00 00 00    	je     804000 <__umoddi3+0x144>
  803f6f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803f73:	29 f2                	sub    %esi,%edx
  803f75:	19 cb                	sbb    %ecx,%ebx
  803f77:	89 d8                	mov    %ebx,%eax
  803f79:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803f7d:	d3 e0                	shl    %cl,%eax
  803f7f:	89 e9                	mov    %ebp,%ecx
  803f81:	d3 ea                	shr    %cl,%edx
  803f83:	09 d0                	or     %edx,%eax
  803f85:	89 e9                	mov    %ebp,%ecx
  803f87:	d3 eb                	shr    %cl,%ebx
  803f89:	89 da                	mov    %ebx,%edx
  803f8b:	83 c4 1c             	add    $0x1c,%esp
  803f8e:	5b                   	pop    %ebx
  803f8f:	5e                   	pop    %esi
  803f90:	5f                   	pop    %edi
  803f91:	5d                   	pop    %ebp
  803f92:	c3                   	ret    
  803f93:	90                   	nop
  803f94:	89 fd                	mov    %edi,%ebp
  803f96:	85 ff                	test   %edi,%edi
  803f98:	75 0b                	jne    803fa5 <__umoddi3+0xe9>
  803f9a:	b8 01 00 00 00       	mov    $0x1,%eax
  803f9f:	31 d2                	xor    %edx,%edx
  803fa1:	f7 f7                	div    %edi
  803fa3:	89 c5                	mov    %eax,%ebp
  803fa5:	89 f0                	mov    %esi,%eax
  803fa7:	31 d2                	xor    %edx,%edx
  803fa9:	f7 f5                	div    %ebp
  803fab:	89 c8                	mov    %ecx,%eax
  803fad:	f7 f5                	div    %ebp
  803faf:	89 d0                	mov    %edx,%eax
  803fb1:	e9 44 ff ff ff       	jmp    803efa <__umoddi3+0x3e>
  803fb6:	66 90                	xchg   %ax,%ax
  803fb8:	89 c8                	mov    %ecx,%eax
  803fba:	89 f2                	mov    %esi,%edx
  803fbc:	83 c4 1c             	add    $0x1c,%esp
  803fbf:	5b                   	pop    %ebx
  803fc0:	5e                   	pop    %esi
  803fc1:	5f                   	pop    %edi
  803fc2:	5d                   	pop    %ebp
  803fc3:	c3                   	ret    
  803fc4:	3b 04 24             	cmp    (%esp),%eax
  803fc7:	72 06                	jb     803fcf <__umoddi3+0x113>
  803fc9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803fcd:	77 0f                	ja     803fde <__umoddi3+0x122>
  803fcf:	89 f2                	mov    %esi,%edx
  803fd1:	29 f9                	sub    %edi,%ecx
  803fd3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803fd7:	89 14 24             	mov    %edx,(%esp)
  803fda:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803fde:	8b 44 24 04          	mov    0x4(%esp),%eax
  803fe2:	8b 14 24             	mov    (%esp),%edx
  803fe5:	83 c4 1c             	add    $0x1c,%esp
  803fe8:	5b                   	pop    %ebx
  803fe9:	5e                   	pop    %esi
  803fea:	5f                   	pop    %edi
  803feb:	5d                   	pop    %ebp
  803fec:	c3                   	ret    
  803fed:	8d 76 00             	lea    0x0(%esi),%esi
  803ff0:	2b 04 24             	sub    (%esp),%eax
  803ff3:	19 fa                	sbb    %edi,%edx
  803ff5:	89 d1                	mov    %edx,%ecx
  803ff7:	89 c6                	mov    %eax,%esi
  803ff9:	e9 71 ff ff ff       	jmp    803f6f <__umoddi3+0xb3>
  803ffe:	66 90                	xchg   %ax,%ax
  804000:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804004:	72 ea                	jb     803ff0 <__umoddi3+0x134>
  804006:	89 d9                	mov    %ebx,%ecx
  804008:	e9 62 ff ff ff       	jmp    803f6f <__umoddi3+0xb3>
