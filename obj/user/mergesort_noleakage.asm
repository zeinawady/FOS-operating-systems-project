
obj/user/mergesort_noleakage:     file format elf32-i386


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
  800031:	e8 21 07 00 00       	call   800757 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void Merge(int* A, int p, int q, int r);

uint32 CheckSorted(int *Elements, int NumOfElements);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp

	do
	{
		//2012: lock the interrupt
		//sys_lock_cons();
		sys_lock_cons();
  800041:	e8 ed 21 00 00       	call   802233 <sys_lock_cons>
		{
			cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 60 3d 80 00       	push   $0x803d60
  80004e:	e8 06 0b 00 00       	call   800b59 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 62 3d 80 00       	push   $0x803d62
  80005e:	e8 f6 0a 00 00       	call   800b59 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 78 3d 80 00       	push   $0x803d78
  80006e:	e8 e6 0a 00 00       	call   800b59 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 62 3d 80 00       	push   $0x803d62
  80007e:	e8 d6 0a 00 00       	call   800b59 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
			cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 60 3d 80 00       	push   $0x803d60
  80008e:	e8 c6 0a 00 00       	call   800b59 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
			readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 90 3d 80 00       	push   $0x803d90
  8000a5:	e8 43 11 00 00       	call   8011ed <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
			cprintf("Chose the initialization method:\n") ;
  8000ad:	83 ec 0c             	sub    $0xc,%esp
  8000b0:	68 b0 3d 80 00       	push   $0x803db0
  8000b5:	e8 9f 0a 00 00       	call   800b59 <cprintf>
  8000ba:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000bd:	83 ec 0c             	sub    $0xc,%esp
  8000c0:	68 d2 3d 80 00       	push   $0x803dd2
  8000c5:	e8 8f 0a 00 00       	call   800b59 <cprintf>
  8000ca:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000cd:	83 ec 0c             	sub    $0xc,%esp
  8000d0:	68 e0 3d 80 00       	push   $0x803de0
  8000d5:	e8 7f 0a 00 00       	call   800b59 <cprintf>
  8000da:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  8000dd:	83 ec 0c             	sub    $0xc,%esp
  8000e0:	68 ef 3d 80 00       	push   $0x803def
  8000e5:	e8 6f 0a 00 00       	call   800b59 <cprintf>
  8000ea:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  8000ed:	83 ec 0c             	sub    $0xc,%esp
  8000f0:	68 ff 3d 80 00       	push   $0x803dff
  8000f5:	e8 5f 0a 00 00       	call   800b59 <cprintf>
  8000fa:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  8000fd:	e8 38 06 00 00       	call   80073a <getchar>
  800102:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  800105:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800109:	83 ec 0c             	sub    $0xc,%esp
  80010c:	50                   	push   %eax
  80010d:	e8 09 06 00 00       	call   80071b <cputchar>
  800112:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800115:	83 ec 0c             	sub    $0xc,%esp
  800118:	6a 0a                	push   $0xa
  80011a:	e8 fc 05 00 00       	call   80071b <cputchar>
  80011f:	83 c4 10             	add    $0x10,%esp
			} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800122:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  800126:	74 0c                	je     800134 <_main+0xfc>
  800128:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  80012c:	74 06                	je     800134 <_main+0xfc>
  80012e:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800132:	75 b9                	jne    8000ed <_main+0xb5>
		}
		sys_unlock_cons();
  800134:	e8 14 21 00 00       	call   80224d <sys_unlock_cons>
		//sys_unlock_cons();

		NumOfElements = strtol(Line, NULL, 10) ;
  800139:	83 ec 04             	sub    $0x4,%esp
  80013c:	6a 0a                	push   $0xa
  80013e:	6a 00                	push   $0x0
  800140:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800146:	50                   	push   %eax
  800147:	e8 09 16 00 00       	call   801755 <strtol>
  80014c:	83 c4 10             	add    $0x10,%esp
  80014f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		Elements = malloc(sizeof(int) * NumOfElements) ;
  800152:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800155:	c1 e0 02             	shl    $0x2,%eax
  800158:	83 ec 0c             	sub    $0xc,%esp
  80015b:	50                   	push   %eax
  80015c:	e8 b0 19 00 00       	call   801b11 <malloc>
  800161:	83 c4 10             	add    $0x10,%esp
  800164:	89 45 ec             	mov    %eax,-0x14(%ebp)

		int  i ;
		switch (Chose)
  800167:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80016b:	83 f8 62             	cmp    $0x62,%eax
  80016e:	74 1d                	je     80018d <_main+0x155>
  800170:	83 f8 63             	cmp    $0x63,%eax
  800173:	74 2b                	je     8001a0 <_main+0x168>
  800175:	83 f8 61             	cmp    $0x61,%eax
  800178:	75 39                	jne    8001b3 <_main+0x17b>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  80017a:	83 ec 08             	sub    $0x8,%esp
  80017d:	ff 75 f0             	pushl  -0x10(%ebp)
  800180:	ff 75 ec             	pushl  -0x14(%ebp)
  800183:	e8 ea 01 00 00       	call   800372 <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f0             	pushl  -0x10(%ebp)
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	e8 08 02 00 00       	call   8003a3 <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a9:	e8 2a 02 00 00       	call   8003d8 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 17 02 00 00       	call   8003d8 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001c4:	83 ec 04             	sub    $0x4,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	6a 01                	push   $0x1
  8001cc:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cf:	e8 d6 02 00 00       	call   8004aa <MSort>
  8001d4:	83 c4 10             	add    $0x10,%esp

		atomic_cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001d7:	83 ec 0c             	sub    $0xc,%esp
  8001da:	68 08 3e 80 00       	push   $0x803e08
  8001df:	e8 a2 09 00 00       	call   800b86 <atomic_cprintf>
  8001e4:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001e7:	83 ec 08             	sub    $0x8,%esp
  8001ea:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ed:	ff 75 ec             	pushl  -0x14(%ebp)
  8001f0:	e8 d3 00 00 00       	call   8002c8 <CheckSorted>
  8001f5:	83 c4 10             	add    $0x10,%esp
  8001f8:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001fb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8001ff:	75 14                	jne    800215 <_main+0x1dd>
  800201:	83 ec 04             	sub    $0x4,%esp
  800204:	68 3c 3e 80 00       	push   $0x803e3c
  800209:	6a 4d                	push   $0x4d
  80020b:	68 5e 3e 80 00       	push   $0x803e5e
  800210:	e8 87 06 00 00       	call   80089c <_panic>
		else
		{
			//sys_lock_cons();
			sys_lock_cons();
  800215:	e8 19 20 00 00       	call   802233 <sys_lock_cons>
			{
				cprintf("===============================================\n") ;
  80021a:	83 ec 0c             	sub    $0xc,%esp
  80021d:	68 7c 3e 80 00       	push   $0x803e7c
  800222:	e8 32 09 00 00       	call   800b59 <cprintf>
  800227:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  80022a:	83 ec 0c             	sub    $0xc,%esp
  80022d:	68 b0 3e 80 00       	push   $0x803eb0
  800232:	e8 22 09 00 00       	call   800b59 <cprintf>
  800237:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  80023a:	83 ec 0c             	sub    $0xc,%esp
  80023d:	68 e4 3e 80 00       	push   $0x803ee4
  800242:	e8 12 09 00 00       	call   800b59 <cprintf>
  800247:	83 c4 10             	add    $0x10,%esp
			}
			sys_unlock_cons();
  80024a:	e8 fe 1f 00 00       	call   80224d <sys_unlock_cons>
			//sys_unlock_cons();
		}

		free(Elements) ;
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	ff 75 ec             	pushl  -0x14(%ebp)
  800255:	e8 6d 1a 00 00       	call   801cc7 <free>
  80025a:	83 c4 10             	add    $0x10,%esp

		//sys_lock_cons();
		sys_lock_cons();
  80025d:	e8 d1 1f 00 00       	call   802233 <sys_lock_cons>
		{
			Chose = 0 ;
  800262:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800266:	eb 42                	jmp    8002aa <_main+0x272>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800268:	83 ec 0c             	sub    $0xc,%esp
  80026b:	68 16 3f 80 00       	push   $0x803f16
  800270:	e8 e4 08 00 00       	call   800b59 <cprintf>
  800275:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800278:	e8 bd 04 00 00       	call   80073a <getchar>
  80027d:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  800280:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800284:	83 ec 0c             	sub    $0xc,%esp
  800287:	50                   	push   %eax
  800288:	e8 8e 04 00 00       	call   80071b <cputchar>
  80028d:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800290:	83 ec 0c             	sub    $0xc,%esp
  800293:	6a 0a                	push   $0xa
  800295:	e8 81 04 00 00       	call   80071b <cputchar>
  80029a:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80029d:	83 ec 0c             	sub    $0xc,%esp
  8002a0:	6a 0a                	push   $0xa
  8002a2:	e8 74 04 00 00       	call   80071b <cputchar>
  8002a7:	83 c4 10             	add    $0x10,%esp

		//sys_lock_cons();
		sys_lock_cons();
		{
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002aa:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002ae:	74 06                	je     8002b6 <_main+0x27e>
  8002b0:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002b4:	75 b2                	jne    800268 <_main+0x230>
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		}
		sys_unlock_cons();
  8002b6:	e8 92 1f 00 00       	call   80224d <sys_unlock_cons>
		//sys_unlock_cons();

	} while (Chose == 'y');
  8002bb:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002bf:	0f 84 7c fd ff ff    	je     800041 <_main+0x9>

}
  8002c5:	90                   	nop
  8002c6:	c9                   	leave  
  8002c7:	c3                   	ret    

008002c8 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8002c8:	55                   	push   %ebp
  8002c9:	89 e5                	mov    %esp,%ebp
  8002cb:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8002ce:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8002d5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8002dc:	eb 33                	jmp    800311 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8002de:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8002eb:	01 d0                	add    %edx,%eax
  8002ed:	8b 10                	mov    (%eax),%edx
  8002ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002f2:	40                   	inc    %eax
  8002f3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8002fd:	01 c8                	add    %ecx,%eax
  8002ff:	8b 00                	mov    (%eax),%eax
  800301:	39 c2                	cmp    %eax,%edx
  800303:	7e 09                	jle    80030e <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800305:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  80030c:	eb 0c                	jmp    80031a <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80030e:	ff 45 f8             	incl   -0x8(%ebp)
  800311:	8b 45 0c             	mov    0xc(%ebp),%eax
  800314:	48                   	dec    %eax
  800315:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800318:	7f c4                	jg     8002de <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  80031a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80031d:	c9                   	leave  
  80031e:	c3                   	ret    

0080031f <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80031f:	55                   	push   %ebp
  800320:	89 e5                	mov    %esp,%ebp
  800322:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800325:	8b 45 0c             	mov    0xc(%ebp),%eax
  800328:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80032f:	8b 45 08             	mov    0x8(%ebp),%eax
  800332:	01 d0                	add    %edx,%eax
  800334:	8b 00                	mov    (%eax),%eax
  800336:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800339:	8b 45 0c             	mov    0xc(%ebp),%eax
  80033c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800343:	8b 45 08             	mov    0x8(%ebp),%eax
  800346:	01 c2                	add    %eax,%edx
  800348:	8b 45 10             	mov    0x10(%ebp),%eax
  80034b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800352:	8b 45 08             	mov    0x8(%ebp),%eax
  800355:	01 c8                	add    %ecx,%eax
  800357:	8b 00                	mov    (%eax),%eax
  800359:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  80035b:	8b 45 10             	mov    0x10(%ebp),%eax
  80035e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800365:	8b 45 08             	mov    0x8(%ebp),%eax
  800368:	01 c2                	add    %eax,%edx
  80036a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80036d:	89 02                	mov    %eax,(%edx)
}
  80036f:	90                   	nop
  800370:	c9                   	leave  
  800371:	c3                   	ret    

00800372 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  800372:	55                   	push   %ebp
  800373:	89 e5                	mov    %esp,%ebp
  800375:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800378:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80037f:	eb 17                	jmp    800398 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  800381:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800384:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80038b:	8b 45 08             	mov    0x8(%ebp),%eax
  80038e:	01 c2                	add    %eax,%edx
  800390:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800393:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800395:	ff 45 fc             	incl   -0x4(%ebp)
  800398:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80039b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80039e:	7c e1                	jl     800381 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8003a0:	90                   	nop
  8003a1:	c9                   	leave  
  8003a2:	c3                   	ret    

008003a3 <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8003a3:	55                   	push   %ebp
  8003a4:	89 e5                	mov    %esp,%ebp
  8003a6:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003b0:	eb 1b                	jmp    8003cd <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8003b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bf:	01 c2                	add    %eax,%edx
  8003c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c4:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8003c7:	48                   	dec    %eax
  8003c8:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003ca:	ff 45 fc             	incl   -0x4(%ebp)
  8003cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003d0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003d3:	7c dd                	jl     8003b2 <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8003d5:	90                   	nop
  8003d6:	c9                   	leave  
  8003d7:	c3                   	ret    

008003d8 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8003d8:	55                   	push   %ebp
  8003d9:	89 e5                	mov    %esp,%ebp
  8003db:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8003de:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003e1:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8003e6:	f7 e9                	imul   %ecx
  8003e8:	c1 f9 1f             	sar    $0x1f,%ecx
  8003eb:	89 d0                	mov    %edx,%eax
  8003ed:	29 c8                	sub    %ecx,%eax
  8003ef:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8003f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003f9:	eb 1e                	jmp    800419 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  8003fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003fe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800405:	8b 45 08             	mov    0x8(%ebp),%eax
  800408:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80040b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80040e:	99                   	cltd   
  80040f:	f7 7d f8             	idivl  -0x8(%ebp)
  800412:	89 d0                	mov    %edx,%eax
  800414:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800416:	ff 45 fc             	incl   -0x4(%ebp)
  800419:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80041c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80041f:	7c da                	jl     8003fb <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//cprintf("i=%d\n",i);
	}

}
  800421:	90                   	nop
  800422:	c9                   	leave  
  800423:	c3                   	ret    

00800424 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800424:	55                   	push   %ebp
  800425:	89 e5                	mov    %esp,%ebp
  800427:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  80042a:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800431:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800438:	eb 42                	jmp    80047c <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  80043a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80043d:	99                   	cltd   
  80043e:	f7 7d f0             	idivl  -0x10(%ebp)
  800441:	89 d0                	mov    %edx,%eax
  800443:	85 c0                	test   %eax,%eax
  800445:	75 10                	jne    800457 <PrintElements+0x33>
			cprintf("\n");
  800447:	83 ec 0c             	sub    $0xc,%esp
  80044a:	68 60 3d 80 00       	push   $0x803d60
  80044f:	e8 05 07 00 00       	call   800b59 <cprintf>
  800454:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800457:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80045a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800461:	8b 45 08             	mov    0x8(%ebp),%eax
  800464:	01 d0                	add    %edx,%eax
  800466:	8b 00                	mov    (%eax),%eax
  800468:	83 ec 08             	sub    $0x8,%esp
  80046b:	50                   	push   %eax
  80046c:	68 34 3f 80 00       	push   $0x803f34
  800471:	e8 e3 06 00 00       	call   800b59 <cprintf>
  800476:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800479:	ff 45 f4             	incl   -0xc(%ebp)
  80047c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047f:	48                   	dec    %eax
  800480:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800483:	7f b5                	jg     80043a <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800485:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800488:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80048f:	8b 45 08             	mov    0x8(%ebp),%eax
  800492:	01 d0                	add    %edx,%eax
  800494:	8b 00                	mov    (%eax),%eax
  800496:	83 ec 08             	sub    $0x8,%esp
  800499:	50                   	push   %eax
  80049a:	68 39 3f 80 00       	push   $0x803f39
  80049f:	e8 b5 06 00 00       	call   800b59 <cprintf>
  8004a4:	83 c4 10             	add    $0x10,%esp

}
  8004a7:	90                   	nop
  8004a8:	c9                   	leave  
  8004a9:	c3                   	ret    

008004aa <MSort>:


void MSort(int* A, int p, int r)
{
  8004aa:	55                   	push   %ebp
  8004ab:	89 e5                	mov    %esp,%ebp
  8004ad:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  8004b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b3:	3b 45 10             	cmp    0x10(%ebp),%eax
  8004b6:	7d 54                	jge    80050c <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  8004b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8004be:	01 d0                	add    %edx,%eax
  8004c0:	89 c2                	mov    %eax,%edx
  8004c2:	c1 ea 1f             	shr    $0x1f,%edx
  8004c5:	01 d0                	add    %edx,%eax
  8004c7:	d1 f8                	sar    %eax
  8004c9:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  8004cc:	83 ec 04             	sub    $0x4,%esp
  8004cf:	ff 75 f4             	pushl  -0xc(%ebp)
  8004d2:	ff 75 0c             	pushl  0xc(%ebp)
  8004d5:	ff 75 08             	pushl  0x8(%ebp)
  8004d8:	e8 cd ff ff ff       	call   8004aa <MSort>
  8004dd:	83 c4 10             	add    $0x10,%esp

	MSort(A, q + 1, r);
  8004e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004e3:	40                   	inc    %eax
  8004e4:	83 ec 04             	sub    $0x4,%esp
  8004e7:	ff 75 10             	pushl  0x10(%ebp)
  8004ea:	50                   	push   %eax
  8004eb:	ff 75 08             	pushl  0x8(%ebp)
  8004ee:	e8 b7 ff ff ff       	call   8004aa <MSort>
  8004f3:	83 c4 10             	add    $0x10,%esp

	Merge(A, p, q, r);
  8004f6:	ff 75 10             	pushl  0x10(%ebp)
  8004f9:	ff 75 f4             	pushl  -0xc(%ebp)
  8004fc:	ff 75 0c             	pushl  0xc(%ebp)
  8004ff:	ff 75 08             	pushl  0x8(%ebp)
  800502:	e8 08 00 00 00       	call   80050f <Merge>
  800507:	83 c4 10             	add    $0x10,%esp
  80050a:	eb 01                	jmp    80050d <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  80050c:	90                   	nop

	MSort(A, q + 1, r);

	Merge(A, p, q, r);

}
  80050d:	c9                   	leave  
  80050e:	c3                   	ret    

0080050f <Merge>:

void Merge(int* A, int p, int q, int r)
{
  80050f:	55                   	push   %ebp
  800510:	89 e5                	mov    %esp,%ebp
  800512:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  800515:	8b 45 10             	mov    0x10(%ebp),%eax
  800518:	2b 45 0c             	sub    0xc(%ebp),%eax
  80051b:	40                   	inc    %eax
  80051c:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  80051f:	8b 45 14             	mov    0x14(%ebp),%eax
  800522:	2b 45 10             	sub    0x10(%ebp),%eax
  800525:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  800528:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  80052f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	//cprintf("allocate LEFT\n");
	int* Left = malloc(sizeof(int) * leftCapacity);
  800536:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800539:	c1 e0 02             	shl    $0x2,%eax
  80053c:	83 ec 0c             	sub    $0xc,%esp
  80053f:	50                   	push   %eax
  800540:	e8 cc 15 00 00       	call   801b11 <malloc>
  800545:	83 c4 10             	add    $0x10,%esp
  800548:	89 45 d8             	mov    %eax,-0x28(%ebp)

	//cprintf("allocate RIGHT\n");
	int* Right = malloc(sizeof(int) * rightCapacity);
  80054b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80054e:	c1 e0 02             	shl    $0x2,%eax
  800551:	83 ec 0c             	sub    $0xc,%esp
  800554:	50                   	push   %eax
  800555:	e8 b7 15 00 00       	call   801b11 <malloc>
  80055a:	83 c4 10             	add    $0x10,%esp
  80055d:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  800560:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800567:	eb 2f                	jmp    800598 <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  800569:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80056c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800573:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800576:	01 c2                	add    %eax,%edx
  800578:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80057b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80057e:	01 c8                	add    %ecx,%eax
  800580:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800585:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80058c:	8b 45 08             	mov    0x8(%ebp),%eax
  80058f:	01 c8                	add    %ecx,%eax
  800591:	8b 00                	mov    (%eax),%eax
  800593:	89 02                	mov    %eax,(%edx)

	//cprintf("allocate RIGHT\n");
	int* Right = malloc(sizeof(int) * rightCapacity);

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  800595:	ff 45 ec             	incl   -0x14(%ebp)
  800598:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80059b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80059e:	7c c9                	jl     800569 <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005a0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005a7:	eb 2a                	jmp    8005d3 <Merge+0xc4>
	{
		Right[j] = A[q + j];
  8005a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005ac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005b3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005b6:	01 c2                	add    %eax,%edx
  8005b8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005be:	01 c8                	add    %ecx,%eax
  8005c0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ca:	01 c8                	add    %ecx,%eax
  8005cc:	8b 00                	mov    (%eax),%eax
  8005ce:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005d0:	ff 45 e8             	incl   -0x18(%ebp)
  8005d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005d6:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005d9:	7c ce                	jl     8005a9 <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8005db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005e1:	e9 0a 01 00 00       	jmp    8006f0 <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  8005e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005e9:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005ec:	0f 8d 95 00 00 00    	jge    800687 <Merge+0x178>
  8005f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005f5:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005f8:	0f 8d 89 00 00 00    	jge    800687 <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8005fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800601:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800608:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80060b:	01 d0                	add    %edx,%eax
  80060d:	8b 10                	mov    (%eax),%edx
  80060f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800612:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800619:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80061c:	01 c8                	add    %ecx,%eax
  80061e:	8b 00                	mov    (%eax),%eax
  800620:	39 c2                	cmp    %eax,%edx
  800622:	7d 33                	jge    800657 <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  800624:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800627:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80062c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800633:	8b 45 08             	mov    0x8(%ebp),%eax
  800636:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800639:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80063c:	8d 50 01             	lea    0x1(%eax),%edx
  80063f:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800642:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800649:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80064c:	01 d0                	add    %edx,%eax
  80064e:	8b 00                	mov    (%eax),%eax
  800650:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800652:	e9 96 00 00 00       	jmp    8006ed <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  800657:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80065a:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80065f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800666:	8b 45 08             	mov    0x8(%ebp),%eax
  800669:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80066c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80066f:	8d 50 01             	lea    0x1(%eax),%edx
  800672:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800675:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80067c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80067f:	01 d0                	add    %edx,%eax
  800681:	8b 00                	mov    (%eax),%eax
  800683:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800685:	eb 66                	jmp    8006ed <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  800687:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80068a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80068d:	7d 30                	jge    8006bf <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  80068f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800692:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800697:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80069e:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a1:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006a7:	8d 50 01             	lea    0x1(%eax),%edx
  8006aa:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8006ad:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006b4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006b7:	01 d0                	add    %edx,%eax
  8006b9:	8b 00                	mov    (%eax),%eax
  8006bb:	89 01                	mov    %eax,(%ecx)
  8006bd:	eb 2e                	jmp    8006ed <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  8006bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006c2:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006c7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d1:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006d7:	8d 50 01             	lea    0x1(%eax),%edx
  8006da:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8006dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006e7:	01 d0                	add    %edx,%eax
  8006e9:	8b 00                	mov    (%eax),%eax
  8006eb:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8006ed:	ff 45 e4             	incl   -0x1c(%ebp)
  8006f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006f3:	3b 45 14             	cmp    0x14(%ebp),%eax
  8006f6:	0f 8e ea fe ff ff    	jle    8005e6 <Merge+0xd7>
			A[k - 1] = Right[rightIndex++];
		}
	}

	//cprintf("free LEFT\n");
	free(Left);
  8006fc:	83 ec 0c             	sub    $0xc,%esp
  8006ff:	ff 75 d8             	pushl  -0x28(%ebp)
  800702:	e8 c0 15 00 00       	call   801cc7 <free>
  800707:	83 c4 10             	add    $0x10,%esp
	//cprintf("free RIGHT\n");
	free(Right);
  80070a:	83 ec 0c             	sub    $0xc,%esp
  80070d:	ff 75 d4             	pushl  -0x2c(%ebp)
  800710:	e8 b2 15 00 00       	call   801cc7 <free>
  800715:	83 c4 10             	add    $0x10,%esp

}
  800718:	90                   	nop
  800719:	c9                   	leave  
  80071a:	c3                   	ret    

0080071b <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  80071b:	55                   	push   %ebp
  80071c:	89 e5                	mov    %esp,%ebp
  80071e:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  800721:	8b 45 08             	mov    0x8(%ebp),%eax
  800724:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800727:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80072b:	83 ec 0c             	sub    $0xc,%esp
  80072e:	50                   	push   %eax
  80072f:	e8 4a 1c 00 00       	call   80237e <sys_cputc>
  800734:	83 c4 10             	add    $0x10,%esp
}
  800737:	90                   	nop
  800738:	c9                   	leave  
  800739:	c3                   	ret    

0080073a <getchar>:


int
getchar(void)
{
  80073a:	55                   	push   %ebp
  80073b:	89 e5                	mov    %esp,%ebp
  80073d:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  800740:	e8 d5 1a 00 00       	call   80221a <sys_cgetc>
  800745:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  800748:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80074b:	c9                   	leave  
  80074c:	c3                   	ret    

0080074d <iscons>:

int iscons(int fdnum)
{
  80074d:	55                   	push   %ebp
  80074e:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800750:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800755:	5d                   	pop    %ebp
  800756:	c3                   	ret    

00800757 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800757:	55                   	push   %ebp
  800758:	89 e5                	mov    %esp,%ebp
  80075a:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80075d:	e8 4d 1d 00 00       	call   8024af <sys_getenvindex>
  800762:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800765:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800768:	89 d0                	mov    %edx,%eax
  80076a:	c1 e0 02             	shl    $0x2,%eax
  80076d:	01 d0                	add    %edx,%eax
  80076f:	c1 e0 03             	shl    $0x3,%eax
  800772:	01 d0                	add    %edx,%eax
  800774:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80077b:	01 d0                	add    %edx,%eax
  80077d:	c1 e0 02             	shl    $0x2,%eax
  800780:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800785:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80078a:	a1 24 50 80 00       	mov    0x805024,%eax
  80078f:	8a 40 20             	mov    0x20(%eax),%al
  800792:	84 c0                	test   %al,%al
  800794:	74 0d                	je     8007a3 <libmain+0x4c>
		binaryname = myEnv->prog_name;
  800796:	a1 24 50 80 00       	mov    0x805024,%eax
  80079b:	83 c0 20             	add    $0x20,%eax
  80079e:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8007a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8007a7:	7e 0a                	jle    8007b3 <libmain+0x5c>
		binaryname = argv[0];
  8007a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007ac:	8b 00                	mov    (%eax),%eax
  8007ae:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  8007b3:	83 ec 08             	sub    $0x8,%esp
  8007b6:	ff 75 0c             	pushl  0xc(%ebp)
  8007b9:	ff 75 08             	pushl  0x8(%ebp)
  8007bc:	e8 77 f8 ff ff       	call   800038 <_main>
  8007c1:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8007c4:	a1 00 50 80 00       	mov    0x805000,%eax
  8007c9:	85 c0                	test   %eax,%eax
  8007cb:	0f 84 9f 00 00 00    	je     800870 <libmain+0x119>
	{
		sys_lock_cons();
  8007d1:	e8 5d 1a 00 00       	call   802233 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8007d6:	83 ec 0c             	sub    $0xc,%esp
  8007d9:	68 58 3f 80 00       	push   $0x803f58
  8007de:	e8 76 03 00 00       	call   800b59 <cprintf>
  8007e3:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8007e6:	a1 24 50 80 00       	mov    0x805024,%eax
  8007eb:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8007f1:	a1 24 50 80 00       	mov    0x805024,%eax
  8007f6:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8007fc:	83 ec 04             	sub    $0x4,%esp
  8007ff:	52                   	push   %edx
  800800:	50                   	push   %eax
  800801:	68 80 3f 80 00       	push   $0x803f80
  800806:	e8 4e 03 00 00       	call   800b59 <cprintf>
  80080b:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80080e:	a1 24 50 80 00       	mov    0x805024,%eax
  800813:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800819:	a1 24 50 80 00       	mov    0x805024,%eax
  80081e:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800824:	a1 24 50 80 00       	mov    0x805024,%eax
  800829:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  80082f:	51                   	push   %ecx
  800830:	52                   	push   %edx
  800831:	50                   	push   %eax
  800832:	68 a8 3f 80 00       	push   $0x803fa8
  800837:	e8 1d 03 00 00       	call   800b59 <cprintf>
  80083c:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80083f:	a1 24 50 80 00       	mov    0x805024,%eax
  800844:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  80084a:	83 ec 08             	sub    $0x8,%esp
  80084d:	50                   	push   %eax
  80084e:	68 00 40 80 00       	push   $0x804000
  800853:	e8 01 03 00 00       	call   800b59 <cprintf>
  800858:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80085b:	83 ec 0c             	sub    $0xc,%esp
  80085e:	68 58 3f 80 00       	push   $0x803f58
  800863:	e8 f1 02 00 00       	call   800b59 <cprintf>
  800868:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80086b:	e8 dd 19 00 00       	call   80224d <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800870:	e8 19 00 00 00       	call   80088e <exit>
}
  800875:	90                   	nop
  800876:	c9                   	leave  
  800877:	c3                   	ret    

00800878 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800878:	55                   	push   %ebp
  800879:	89 e5                	mov    %esp,%ebp
  80087b:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80087e:	83 ec 0c             	sub    $0xc,%esp
  800881:	6a 00                	push   $0x0
  800883:	e8 f3 1b 00 00       	call   80247b <sys_destroy_env>
  800888:	83 c4 10             	add    $0x10,%esp
}
  80088b:	90                   	nop
  80088c:	c9                   	leave  
  80088d:	c3                   	ret    

0080088e <exit>:

void
exit(void)
{
  80088e:	55                   	push   %ebp
  80088f:	89 e5                	mov    %esp,%ebp
  800891:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800894:	e8 48 1c 00 00       	call   8024e1 <sys_exit_env>
}
  800899:	90                   	nop
  80089a:	c9                   	leave  
  80089b:	c3                   	ret    

0080089c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80089c:	55                   	push   %ebp
  80089d:	89 e5                	mov    %esp,%ebp
  80089f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8008a2:	8d 45 10             	lea    0x10(%ebp),%eax
  8008a5:	83 c0 04             	add    $0x4,%eax
  8008a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8008ab:	a1 60 50 98 00       	mov    0x985060,%eax
  8008b0:	85 c0                	test   %eax,%eax
  8008b2:	74 16                	je     8008ca <_panic+0x2e>
		cprintf("%s: ", argv0);
  8008b4:	a1 60 50 98 00       	mov    0x985060,%eax
  8008b9:	83 ec 08             	sub    $0x8,%esp
  8008bc:	50                   	push   %eax
  8008bd:	68 14 40 80 00       	push   $0x804014
  8008c2:	e8 92 02 00 00       	call   800b59 <cprintf>
  8008c7:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8008ca:	a1 04 50 80 00       	mov    0x805004,%eax
  8008cf:	ff 75 0c             	pushl  0xc(%ebp)
  8008d2:	ff 75 08             	pushl  0x8(%ebp)
  8008d5:	50                   	push   %eax
  8008d6:	68 19 40 80 00       	push   $0x804019
  8008db:	e8 79 02 00 00       	call   800b59 <cprintf>
  8008e0:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8008e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8008e6:	83 ec 08             	sub    $0x8,%esp
  8008e9:	ff 75 f4             	pushl  -0xc(%ebp)
  8008ec:	50                   	push   %eax
  8008ed:	e8 fc 01 00 00       	call   800aee <vcprintf>
  8008f2:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8008f5:	83 ec 08             	sub    $0x8,%esp
  8008f8:	6a 00                	push   $0x0
  8008fa:	68 35 40 80 00       	push   $0x804035
  8008ff:	e8 ea 01 00 00       	call   800aee <vcprintf>
  800904:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800907:	e8 82 ff ff ff       	call   80088e <exit>

	// should not return here
	while (1) ;
  80090c:	eb fe                	jmp    80090c <_panic+0x70>

0080090e <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80090e:	55                   	push   %ebp
  80090f:	89 e5                	mov    %esp,%ebp
  800911:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800914:	a1 24 50 80 00       	mov    0x805024,%eax
  800919:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80091f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800922:	39 c2                	cmp    %eax,%edx
  800924:	74 14                	je     80093a <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800926:	83 ec 04             	sub    $0x4,%esp
  800929:	68 38 40 80 00       	push   $0x804038
  80092e:	6a 26                	push   $0x26
  800930:	68 84 40 80 00       	push   $0x804084
  800935:	e8 62 ff ff ff       	call   80089c <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80093a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800941:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800948:	e9 c5 00 00 00       	jmp    800a12 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80094d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800950:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800957:	8b 45 08             	mov    0x8(%ebp),%eax
  80095a:	01 d0                	add    %edx,%eax
  80095c:	8b 00                	mov    (%eax),%eax
  80095e:	85 c0                	test   %eax,%eax
  800960:	75 08                	jne    80096a <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800962:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800965:	e9 a5 00 00 00       	jmp    800a0f <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80096a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800971:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800978:	eb 69                	jmp    8009e3 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80097a:	a1 24 50 80 00       	mov    0x805024,%eax
  80097f:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800985:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800988:	89 d0                	mov    %edx,%eax
  80098a:	01 c0                	add    %eax,%eax
  80098c:	01 d0                	add    %edx,%eax
  80098e:	c1 e0 03             	shl    $0x3,%eax
  800991:	01 c8                	add    %ecx,%eax
  800993:	8a 40 04             	mov    0x4(%eax),%al
  800996:	84 c0                	test   %al,%al
  800998:	75 46                	jne    8009e0 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80099a:	a1 24 50 80 00       	mov    0x805024,%eax
  80099f:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8009a5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009a8:	89 d0                	mov    %edx,%eax
  8009aa:	01 c0                	add    %eax,%eax
  8009ac:	01 d0                	add    %edx,%eax
  8009ae:	c1 e0 03             	shl    $0x3,%eax
  8009b1:	01 c8                	add    %ecx,%eax
  8009b3:	8b 00                	mov    (%eax),%eax
  8009b5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8009b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8009bb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8009c0:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8009c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009c5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8009cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cf:	01 c8                	add    %ecx,%eax
  8009d1:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009d3:	39 c2                	cmp    %eax,%edx
  8009d5:	75 09                	jne    8009e0 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8009d7:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8009de:	eb 15                	jmp    8009f5 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009e0:	ff 45 e8             	incl   -0x18(%ebp)
  8009e3:	a1 24 50 80 00       	mov    0x805024,%eax
  8009e8:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8009ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8009f1:	39 c2                	cmp    %eax,%edx
  8009f3:	77 85                	ja     80097a <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8009f5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8009f9:	75 14                	jne    800a0f <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8009fb:	83 ec 04             	sub    $0x4,%esp
  8009fe:	68 90 40 80 00       	push   $0x804090
  800a03:	6a 3a                	push   $0x3a
  800a05:	68 84 40 80 00       	push   $0x804084
  800a0a:	e8 8d fe ff ff       	call   80089c <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a0f:	ff 45 f0             	incl   -0x10(%ebp)
  800a12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a15:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a18:	0f 8c 2f ff ff ff    	jl     80094d <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a1e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a25:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a2c:	eb 26                	jmp    800a54 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a2e:	a1 24 50 80 00       	mov    0x805024,%eax
  800a33:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800a39:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a3c:	89 d0                	mov    %edx,%eax
  800a3e:	01 c0                	add    %eax,%eax
  800a40:	01 d0                	add    %edx,%eax
  800a42:	c1 e0 03             	shl    $0x3,%eax
  800a45:	01 c8                	add    %ecx,%eax
  800a47:	8a 40 04             	mov    0x4(%eax),%al
  800a4a:	3c 01                	cmp    $0x1,%al
  800a4c:	75 03                	jne    800a51 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800a4e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a51:	ff 45 e0             	incl   -0x20(%ebp)
  800a54:	a1 24 50 80 00       	mov    0x805024,%eax
  800a59:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800a5f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a62:	39 c2                	cmp    %eax,%edx
  800a64:	77 c8                	ja     800a2e <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a69:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800a6c:	74 14                	je     800a82 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800a6e:	83 ec 04             	sub    $0x4,%esp
  800a71:	68 e4 40 80 00       	push   $0x8040e4
  800a76:	6a 44                	push   $0x44
  800a78:	68 84 40 80 00       	push   $0x804084
  800a7d:	e8 1a fe ff ff       	call   80089c <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800a82:	90                   	nop
  800a83:	c9                   	leave  
  800a84:	c3                   	ret    

00800a85 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800a85:	55                   	push   %ebp
  800a86:	89 e5                	mov    %esp,%ebp
  800a88:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800a8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8e:	8b 00                	mov    (%eax),%eax
  800a90:	8d 48 01             	lea    0x1(%eax),%ecx
  800a93:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a96:	89 0a                	mov    %ecx,(%edx)
  800a98:	8b 55 08             	mov    0x8(%ebp),%edx
  800a9b:	88 d1                	mov    %dl,%cl
  800a9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aa0:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800aa4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa7:	8b 00                	mov    (%eax),%eax
  800aa9:	3d ff 00 00 00       	cmp    $0xff,%eax
  800aae:	75 2c                	jne    800adc <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800ab0:	a0 44 50 98 00       	mov    0x985044,%al
  800ab5:	0f b6 c0             	movzbl %al,%eax
  800ab8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800abb:	8b 12                	mov    (%edx),%edx
  800abd:	89 d1                	mov    %edx,%ecx
  800abf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ac2:	83 c2 08             	add    $0x8,%edx
  800ac5:	83 ec 04             	sub    $0x4,%esp
  800ac8:	50                   	push   %eax
  800ac9:	51                   	push   %ecx
  800aca:	52                   	push   %edx
  800acb:	e8 21 17 00 00       	call   8021f1 <sys_cputs>
  800ad0:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800ad3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800adc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800adf:	8b 40 04             	mov    0x4(%eax),%eax
  800ae2:	8d 50 01             	lea    0x1(%eax),%edx
  800ae5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae8:	89 50 04             	mov    %edx,0x4(%eax)
}
  800aeb:	90                   	nop
  800aec:	c9                   	leave  
  800aed:	c3                   	ret    

00800aee <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800aee:	55                   	push   %ebp
  800aef:	89 e5                	mov    %esp,%ebp
  800af1:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800af7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800afe:	00 00 00 
	b.cnt = 0;
  800b01:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b08:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b0b:	ff 75 0c             	pushl  0xc(%ebp)
  800b0e:	ff 75 08             	pushl  0x8(%ebp)
  800b11:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b17:	50                   	push   %eax
  800b18:	68 85 0a 80 00       	push   $0x800a85
  800b1d:	e8 11 02 00 00       	call   800d33 <vprintfmt>
  800b22:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800b25:	a0 44 50 98 00       	mov    0x985044,%al
  800b2a:	0f b6 c0             	movzbl %al,%eax
  800b2d:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800b33:	83 ec 04             	sub    $0x4,%esp
  800b36:	50                   	push   %eax
  800b37:	52                   	push   %edx
  800b38:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b3e:	83 c0 08             	add    $0x8,%eax
  800b41:	50                   	push   %eax
  800b42:	e8 aa 16 00 00       	call   8021f1 <sys_cputs>
  800b47:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800b4a:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
	return b.cnt;
  800b51:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800b57:	c9                   	leave  
  800b58:	c3                   	ret    

00800b59 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800b59:	55                   	push   %ebp
  800b5a:	89 e5                	mov    %esp,%ebp
  800b5c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800b5f:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
	va_start(ap, fmt);
  800b66:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b69:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6f:	83 ec 08             	sub    $0x8,%esp
  800b72:	ff 75 f4             	pushl  -0xc(%ebp)
  800b75:	50                   	push   %eax
  800b76:	e8 73 ff ff ff       	call   800aee <vcprintf>
  800b7b:	83 c4 10             	add    $0x10,%esp
  800b7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800b81:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b84:	c9                   	leave  
  800b85:	c3                   	ret    

00800b86 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800b86:	55                   	push   %ebp
  800b87:	89 e5                	mov    %esp,%ebp
  800b89:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800b8c:	e8 a2 16 00 00       	call   802233 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800b91:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b94:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800b97:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9a:	83 ec 08             	sub    $0x8,%esp
  800b9d:	ff 75 f4             	pushl  -0xc(%ebp)
  800ba0:	50                   	push   %eax
  800ba1:	e8 48 ff ff ff       	call   800aee <vcprintf>
  800ba6:	83 c4 10             	add    $0x10,%esp
  800ba9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800bac:	e8 9c 16 00 00       	call   80224d <sys_unlock_cons>
	return cnt;
  800bb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bb4:	c9                   	leave  
  800bb5:	c3                   	ret    

00800bb6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800bb6:	55                   	push   %ebp
  800bb7:	89 e5                	mov    %esp,%ebp
  800bb9:	53                   	push   %ebx
  800bba:	83 ec 14             	sub    $0x14,%esp
  800bbd:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bc3:	8b 45 14             	mov    0x14(%ebp),%eax
  800bc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800bc9:	8b 45 18             	mov    0x18(%ebp),%eax
  800bcc:	ba 00 00 00 00       	mov    $0x0,%edx
  800bd1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800bd4:	77 55                	ja     800c2b <printnum+0x75>
  800bd6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800bd9:	72 05                	jb     800be0 <printnum+0x2a>
  800bdb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800bde:	77 4b                	ja     800c2b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800be0:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800be3:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800be6:	8b 45 18             	mov    0x18(%ebp),%eax
  800be9:	ba 00 00 00 00       	mov    $0x0,%edx
  800bee:	52                   	push   %edx
  800bef:	50                   	push   %eax
  800bf0:	ff 75 f4             	pushl  -0xc(%ebp)
  800bf3:	ff 75 f0             	pushl  -0x10(%ebp)
  800bf6:	e8 f9 2e 00 00       	call   803af4 <__udivdi3>
  800bfb:	83 c4 10             	add    $0x10,%esp
  800bfe:	83 ec 04             	sub    $0x4,%esp
  800c01:	ff 75 20             	pushl  0x20(%ebp)
  800c04:	53                   	push   %ebx
  800c05:	ff 75 18             	pushl  0x18(%ebp)
  800c08:	52                   	push   %edx
  800c09:	50                   	push   %eax
  800c0a:	ff 75 0c             	pushl  0xc(%ebp)
  800c0d:	ff 75 08             	pushl  0x8(%ebp)
  800c10:	e8 a1 ff ff ff       	call   800bb6 <printnum>
  800c15:	83 c4 20             	add    $0x20,%esp
  800c18:	eb 1a                	jmp    800c34 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c1a:	83 ec 08             	sub    $0x8,%esp
  800c1d:	ff 75 0c             	pushl  0xc(%ebp)
  800c20:	ff 75 20             	pushl  0x20(%ebp)
  800c23:	8b 45 08             	mov    0x8(%ebp),%eax
  800c26:	ff d0                	call   *%eax
  800c28:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c2b:	ff 4d 1c             	decl   0x1c(%ebp)
  800c2e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c32:	7f e6                	jg     800c1a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c34:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c37:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c42:	53                   	push   %ebx
  800c43:	51                   	push   %ecx
  800c44:	52                   	push   %edx
  800c45:	50                   	push   %eax
  800c46:	e8 b9 2f 00 00       	call   803c04 <__umoddi3>
  800c4b:	83 c4 10             	add    $0x10,%esp
  800c4e:	05 54 43 80 00       	add    $0x804354,%eax
  800c53:	8a 00                	mov    (%eax),%al
  800c55:	0f be c0             	movsbl %al,%eax
  800c58:	83 ec 08             	sub    $0x8,%esp
  800c5b:	ff 75 0c             	pushl  0xc(%ebp)
  800c5e:	50                   	push   %eax
  800c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c62:	ff d0                	call   *%eax
  800c64:	83 c4 10             	add    $0x10,%esp
}
  800c67:	90                   	nop
  800c68:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c6b:	c9                   	leave  
  800c6c:	c3                   	ret    

00800c6d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800c6d:	55                   	push   %ebp
  800c6e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c70:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c74:	7e 1c                	jle    800c92 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800c76:	8b 45 08             	mov    0x8(%ebp),%eax
  800c79:	8b 00                	mov    (%eax),%eax
  800c7b:	8d 50 08             	lea    0x8(%eax),%edx
  800c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c81:	89 10                	mov    %edx,(%eax)
  800c83:	8b 45 08             	mov    0x8(%ebp),%eax
  800c86:	8b 00                	mov    (%eax),%eax
  800c88:	83 e8 08             	sub    $0x8,%eax
  800c8b:	8b 50 04             	mov    0x4(%eax),%edx
  800c8e:	8b 00                	mov    (%eax),%eax
  800c90:	eb 40                	jmp    800cd2 <getuint+0x65>
	else if (lflag)
  800c92:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c96:	74 1e                	je     800cb6 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800c98:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9b:	8b 00                	mov    (%eax),%eax
  800c9d:	8d 50 04             	lea    0x4(%eax),%edx
  800ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca3:	89 10                	mov    %edx,(%eax)
  800ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca8:	8b 00                	mov    (%eax),%eax
  800caa:	83 e8 04             	sub    $0x4,%eax
  800cad:	8b 00                	mov    (%eax),%eax
  800caf:	ba 00 00 00 00       	mov    $0x0,%edx
  800cb4:	eb 1c                	jmp    800cd2 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb9:	8b 00                	mov    (%eax),%eax
  800cbb:	8d 50 04             	lea    0x4(%eax),%edx
  800cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc1:	89 10                	mov    %edx,(%eax)
  800cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc6:	8b 00                	mov    (%eax),%eax
  800cc8:	83 e8 04             	sub    $0x4,%eax
  800ccb:	8b 00                	mov    (%eax),%eax
  800ccd:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800cd2:	5d                   	pop    %ebp
  800cd3:	c3                   	ret    

00800cd4 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800cd4:	55                   	push   %ebp
  800cd5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800cd7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800cdb:	7e 1c                	jle    800cf9 <getint+0x25>
		return va_arg(*ap, long long);
  800cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce0:	8b 00                	mov    (%eax),%eax
  800ce2:	8d 50 08             	lea    0x8(%eax),%edx
  800ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce8:	89 10                	mov    %edx,(%eax)
  800cea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ced:	8b 00                	mov    (%eax),%eax
  800cef:	83 e8 08             	sub    $0x8,%eax
  800cf2:	8b 50 04             	mov    0x4(%eax),%edx
  800cf5:	8b 00                	mov    (%eax),%eax
  800cf7:	eb 38                	jmp    800d31 <getint+0x5d>
	else if (lflag)
  800cf9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cfd:	74 1a                	je     800d19 <getint+0x45>
		return va_arg(*ap, long);
  800cff:	8b 45 08             	mov    0x8(%ebp),%eax
  800d02:	8b 00                	mov    (%eax),%eax
  800d04:	8d 50 04             	lea    0x4(%eax),%edx
  800d07:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0a:	89 10                	mov    %edx,(%eax)
  800d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0f:	8b 00                	mov    (%eax),%eax
  800d11:	83 e8 04             	sub    $0x4,%eax
  800d14:	8b 00                	mov    (%eax),%eax
  800d16:	99                   	cltd   
  800d17:	eb 18                	jmp    800d31 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	8b 00                	mov    (%eax),%eax
  800d1e:	8d 50 04             	lea    0x4(%eax),%edx
  800d21:	8b 45 08             	mov    0x8(%ebp),%eax
  800d24:	89 10                	mov    %edx,(%eax)
  800d26:	8b 45 08             	mov    0x8(%ebp),%eax
  800d29:	8b 00                	mov    (%eax),%eax
  800d2b:	83 e8 04             	sub    $0x4,%eax
  800d2e:	8b 00                	mov    (%eax),%eax
  800d30:	99                   	cltd   
}
  800d31:	5d                   	pop    %ebp
  800d32:	c3                   	ret    

00800d33 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d33:	55                   	push   %ebp
  800d34:	89 e5                	mov    %esp,%ebp
  800d36:	56                   	push   %esi
  800d37:	53                   	push   %ebx
  800d38:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d3b:	eb 17                	jmp    800d54 <vprintfmt+0x21>
			if (ch == '\0')
  800d3d:	85 db                	test   %ebx,%ebx
  800d3f:	0f 84 c1 03 00 00    	je     801106 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800d45:	83 ec 08             	sub    $0x8,%esp
  800d48:	ff 75 0c             	pushl  0xc(%ebp)
  800d4b:	53                   	push   %ebx
  800d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4f:	ff d0                	call   *%eax
  800d51:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d54:	8b 45 10             	mov    0x10(%ebp),%eax
  800d57:	8d 50 01             	lea    0x1(%eax),%edx
  800d5a:	89 55 10             	mov    %edx,0x10(%ebp)
  800d5d:	8a 00                	mov    (%eax),%al
  800d5f:	0f b6 d8             	movzbl %al,%ebx
  800d62:	83 fb 25             	cmp    $0x25,%ebx
  800d65:	75 d6                	jne    800d3d <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800d67:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800d6b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800d72:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800d79:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800d80:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d87:	8b 45 10             	mov    0x10(%ebp),%eax
  800d8a:	8d 50 01             	lea    0x1(%eax),%edx
  800d8d:	89 55 10             	mov    %edx,0x10(%ebp)
  800d90:	8a 00                	mov    (%eax),%al
  800d92:	0f b6 d8             	movzbl %al,%ebx
  800d95:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800d98:	83 f8 5b             	cmp    $0x5b,%eax
  800d9b:	0f 87 3d 03 00 00    	ja     8010de <vprintfmt+0x3ab>
  800da1:	8b 04 85 78 43 80 00 	mov    0x804378(,%eax,4),%eax
  800da8:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800daa:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800dae:	eb d7                	jmp    800d87 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800db0:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800db4:	eb d1                	jmp    800d87 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800db6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800dbd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800dc0:	89 d0                	mov    %edx,%eax
  800dc2:	c1 e0 02             	shl    $0x2,%eax
  800dc5:	01 d0                	add    %edx,%eax
  800dc7:	01 c0                	add    %eax,%eax
  800dc9:	01 d8                	add    %ebx,%eax
  800dcb:	83 e8 30             	sub    $0x30,%eax
  800dce:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800dd1:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd4:	8a 00                	mov    (%eax),%al
  800dd6:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800dd9:	83 fb 2f             	cmp    $0x2f,%ebx
  800ddc:	7e 3e                	jle    800e1c <vprintfmt+0xe9>
  800dde:	83 fb 39             	cmp    $0x39,%ebx
  800de1:	7f 39                	jg     800e1c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800de3:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800de6:	eb d5                	jmp    800dbd <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800de8:	8b 45 14             	mov    0x14(%ebp),%eax
  800deb:	83 c0 04             	add    $0x4,%eax
  800dee:	89 45 14             	mov    %eax,0x14(%ebp)
  800df1:	8b 45 14             	mov    0x14(%ebp),%eax
  800df4:	83 e8 04             	sub    $0x4,%eax
  800df7:	8b 00                	mov    (%eax),%eax
  800df9:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800dfc:	eb 1f                	jmp    800e1d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800dfe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e02:	79 83                	jns    800d87 <vprintfmt+0x54>
				width = 0;
  800e04:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800e0b:	e9 77 ff ff ff       	jmp    800d87 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e10:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e17:	e9 6b ff ff ff       	jmp    800d87 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e1c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e1d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e21:	0f 89 60 ff ff ff    	jns    800d87 <vprintfmt+0x54>
				width = precision, precision = -1;
  800e27:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e2a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e2d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e34:	e9 4e ff ff ff       	jmp    800d87 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e39:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800e3c:	e9 46 ff ff ff       	jmp    800d87 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800e41:	8b 45 14             	mov    0x14(%ebp),%eax
  800e44:	83 c0 04             	add    $0x4,%eax
  800e47:	89 45 14             	mov    %eax,0x14(%ebp)
  800e4a:	8b 45 14             	mov    0x14(%ebp),%eax
  800e4d:	83 e8 04             	sub    $0x4,%eax
  800e50:	8b 00                	mov    (%eax),%eax
  800e52:	83 ec 08             	sub    $0x8,%esp
  800e55:	ff 75 0c             	pushl  0xc(%ebp)
  800e58:	50                   	push   %eax
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5c:	ff d0                	call   *%eax
  800e5e:	83 c4 10             	add    $0x10,%esp
			break;
  800e61:	e9 9b 02 00 00       	jmp    801101 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800e66:	8b 45 14             	mov    0x14(%ebp),%eax
  800e69:	83 c0 04             	add    $0x4,%eax
  800e6c:	89 45 14             	mov    %eax,0x14(%ebp)
  800e6f:	8b 45 14             	mov    0x14(%ebp),%eax
  800e72:	83 e8 04             	sub    $0x4,%eax
  800e75:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800e77:	85 db                	test   %ebx,%ebx
  800e79:	79 02                	jns    800e7d <vprintfmt+0x14a>
				err = -err;
  800e7b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800e7d:	83 fb 64             	cmp    $0x64,%ebx
  800e80:	7f 0b                	jg     800e8d <vprintfmt+0x15a>
  800e82:	8b 34 9d c0 41 80 00 	mov    0x8041c0(,%ebx,4),%esi
  800e89:	85 f6                	test   %esi,%esi
  800e8b:	75 19                	jne    800ea6 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e8d:	53                   	push   %ebx
  800e8e:	68 65 43 80 00       	push   $0x804365
  800e93:	ff 75 0c             	pushl  0xc(%ebp)
  800e96:	ff 75 08             	pushl  0x8(%ebp)
  800e99:	e8 70 02 00 00       	call   80110e <printfmt>
  800e9e:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ea1:	e9 5b 02 00 00       	jmp    801101 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ea6:	56                   	push   %esi
  800ea7:	68 6e 43 80 00       	push   $0x80436e
  800eac:	ff 75 0c             	pushl  0xc(%ebp)
  800eaf:	ff 75 08             	pushl  0x8(%ebp)
  800eb2:	e8 57 02 00 00       	call   80110e <printfmt>
  800eb7:	83 c4 10             	add    $0x10,%esp
			break;
  800eba:	e9 42 02 00 00       	jmp    801101 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ebf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec2:	83 c0 04             	add    $0x4,%eax
  800ec5:	89 45 14             	mov    %eax,0x14(%ebp)
  800ec8:	8b 45 14             	mov    0x14(%ebp),%eax
  800ecb:	83 e8 04             	sub    $0x4,%eax
  800ece:	8b 30                	mov    (%eax),%esi
  800ed0:	85 f6                	test   %esi,%esi
  800ed2:	75 05                	jne    800ed9 <vprintfmt+0x1a6>
				p = "(null)";
  800ed4:	be 71 43 80 00       	mov    $0x804371,%esi
			if (width > 0 && padc != '-')
  800ed9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800edd:	7e 6d                	jle    800f4c <vprintfmt+0x219>
  800edf:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ee3:	74 67                	je     800f4c <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ee5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ee8:	83 ec 08             	sub    $0x8,%esp
  800eeb:	50                   	push   %eax
  800eec:	56                   	push   %esi
  800eed:	e8 26 05 00 00       	call   801418 <strnlen>
  800ef2:	83 c4 10             	add    $0x10,%esp
  800ef5:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ef8:	eb 16                	jmp    800f10 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800efa:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800efe:	83 ec 08             	sub    $0x8,%esp
  800f01:	ff 75 0c             	pushl  0xc(%ebp)
  800f04:	50                   	push   %eax
  800f05:	8b 45 08             	mov    0x8(%ebp),%eax
  800f08:	ff d0                	call   *%eax
  800f0a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f0d:	ff 4d e4             	decl   -0x1c(%ebp)
  800f10:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f14:	7f e4                	jg     800efa <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f16:	eb 34                	jmp    800f4c <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f18:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f1c:	74 1c                	je     800f3a <vprintfmt+0x207>
  800f1e:	83 fb 1f             	cmp    $0x1f,%ebx
  800f21:	7e 05                	jle    800f28 <vprintfmt+0x1f5>
  800f23:	83 fb 7e             	cmp    $0x7e,%ebx
  800f26:	7e 12                	jle    800f3a <vprintfmt+0x207>
					putch('?', putdat);
  800f28:	83 ec 08             	sub    $0x8,%esp
  800f2b:	ff 75 0c             	pushl  0xc(%ebp)
  800f2e:	6a 3f                	push   $0x3f
  800f30:	8b 45 08             	mov    0x8(%ebp),%eax
  800f33:	ff d0                	call   *%eax
  800f35:	83 c4 10             	add    $0x10,%esp
  800f38:	eb 0f                	jmp    800f49 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800f3a:	83 ec 08             	sub    $0x8,%esp
  800f3d:	ff 75 0c             	pushl  0xc(%ebp)
  800f40:	53                   	push   %ebx
  800f41:	8b 45 08             	mov    0x8(%ebp),%eax
  800f44:	ff d0                	call   *%eax
  800f46:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f49:	ff 4d e4             	decl   -0x1c(%ebp)
  800f4c:	89 f0                	mov    %esi,%eax
  800f4e:	8d 70 01             	lea    0x1(%eax),%esi
  800f51:	8a 00                	mov    (%eax),%al
  800f53:	0f be d8             	movsbl %al,%ebx
  800f56:	85 db                	test   %ebx,%ebx
  800f58:	74 24                	je     800f7e <vprintfmt+0x24b>
  800f5a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f5e:	78 b8                	js     800f18 <vprintfmt+0x1e5>
  800f60:	ff 4d e0             	decl   -0x20(%ebp)
  800f63:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f67:	79 af                	jns    800f18 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f69:	eb 13                	jmp    800f7e <vprintfmt+0x24b>
				putch(' ', putdat);
  800f6b:	83 ec 08             	sub    $0x8,%esp
  800f6e:	ff 75 0c             	pushl  0xc(%ebp)
  800f71:	6a 20                	push   $0x20
  800f73:	8b 45 08             	mov    0x8(%ebp),%eax
  800f76:	ff d0                	call   *%eax
  800f78:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f7b:	ff 4d e4             	decl   -0x1c(%ebp)
  800f7e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f82:	7f e7                	jg     800f6b <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800f84:	e9 78 01 00 00       	jmp    801101 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800f89:	83 ec 08             	sub    $0x8,%esp
  800f8c:	ff 75 e8             	pushl  -0x18(%ebp)
  800f8f:	8d 45 14             	lea    0x14(%ebp),%eax
  800f92:	50                   	push   %eax
  800f93:	e8 3c fd ff ff       	call   800cd4 <getint>
  800f98:	83 c4 10             	add    $0x10,%esp
  800f9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f9e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800fa1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fa4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fa7:	85 d2                	test   %edx,%edx
  800fa9:	79 23                	jns    800fce <vprintfmt+0x29b>
				putch('-', putdat);
  800fab:	83 ec 08             	sub    $0x8,%esp
  800fae:	ff 75 0c             	pushl  0xc(%ebp)
  800fb1:	6a 2d                	push   $0x2d
  800fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb6:	ff d0                	call   *%eax
  800fb8:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800fbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fbe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fc1:	f7 d8                	neg    %eax
  800fc3:	83 d2 00             	adc    $0x0,%edx
  800fc6:	f7 da                	neg    %edx
  800fc8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fcb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800fce:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800fd5:	e9 bc 00 00 00       	jmp    801096 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800fda:	83 ec 08             	sub    $0x8,%esp
  800fdd:	ff 75 e8             	pushl  -0x18(%ebp)
  800fe0:	8d 45 14             	lea    0x14(%ebp),%eax
  800fe3:	50                   	push   %eax
  800fe4:	e8 84 fc ff ff       	call   800c6d <getuint>
  800fe9:	83 c4 10             	add    $0x10,%esp
  800fec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fef:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ff2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ff9:	e9 98 00 00 00       	jmp    801096 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ffe:	83 ec 08             	sub    $0x8,%esp
  801001:	ff 75 0c             	pushl  0xc(%ebp)
  801004:	6a 58                	push   $0x58
  801006:	8b 45 08             	mov    0x8(%ebp),%eax
  801009:	ff d0                	call   *%eax
  80100b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80100e:	83 ec 08             	sub    $0x8,%esp
  801011:	ff 75 0c             	pushl  0xc(%ebp)
  801014:	6a 58                	push   $0x58
  801016:	8b 45 08             	mov    0x8(%ebp),%eax
  801019:	ff d0                	call   *%eax
  80101b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80101e:	83 ec 08             	sub    $0x8,%esp
  801021:	ff 75 0c             	pushl  0xc(%ebp)
  801024:	6a 58                	push   $0x58
  801026:	8b 45 08             	mov    0x8(%ebp),%eax
  801029:	ff d0                	call   *%eax
  80102b:	83 c4 10             	add    $0x10,%esp
			break;
  80102e:	e9 ce 00 00 00       	jmp    801101 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801033:	83 ec 08             	sub    $0x8,%esp
  801036:	ff 75 0c             	pushl  0xc(%ebp)
  801039:	6a 30                	push   $0x30
  80103b:	8b 45 08             	mov    0x8(%ebp),%eax
  80103e:	ff d0                	call   *%eax
  801040:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801043:	83 ec 08             	sub    $0x8,%esp
  801046:	ff 75 0c             	pushl  0xc(%ebp)
  801049:	6a 78                	push   $0x78
  80104b:	8b 45 08             	mov    0x8(%ebp),%eax
  80104e:	ff d0                	call   *%eax
  801050:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801053:	8b 45 14             	mov    0x14(%ebp),%eax
  801056:	83 c0 04             	add    $0x4,%eax
  801059:	89 45 14             	mov    %eax,0x14(%ebp)
  80105c:	8b 45 14             	mov    0x14(%ebp),%eax
  80105f:	83 e8 04             	sub    $0x4,%eax
  801062:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801064:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801067:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80106e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801075:	eb 1f                	jmp    801096 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801077:	83 ec 08             	sub    $0x8,%esp
  80107a:	ff 75 e8             	pushl  -0x18(%ebp)
  80107d:	8d 45 14             	lea    0x14(%ebp),%eax
  801080:	50                   	push   %eax
  801081:	e8 e7 fb ff ff       	call   800c6d <getuint>
  801086:	83 c4 10             	add    $0x10,%esp
  801089:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80108c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80108f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801096:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80109a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80109d:	83 ec 04             	sub    $0x4,%esp
  8010a0:	52                   	push   %edx
  8010a1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010a4:	50                   	push   %eax
  8010a5:	ff 75 f4             	pushl  -0xc(%ebp)
  8010a8:	ff 75 f0             	pushl  -0x10(%ebp)
  8010ab:	ff 75 0c             	pushl  0xc(%ebp)
  8010ae:	ff 75 08             	pushl  0x8(%ebp)
  8010b1:	e8 00 fb ff ff       	call   800bb6 <printnum>
  8010b6:	83 c4 20             	add    $0x20,%esp
			break;
  8010b9:	eb 46                	jmp    801101 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8010bb:	83 ec 08             	sub    $0x8,%esp
  8010be:	ff 75 0c             	pushl  0xc(%ebp)
  8010c1:	53                   	push   %ebx
  8010c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c5:	ff d0                	call   *%eax
  8010c7:	83 c4 10             	add    $0x10,%esp
			break;
  8010ca:	eb 35                	jmp    801101 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8010cc:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
			break;
  8010d3:	eb 2c                	jmp    801101 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8010d5:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
			break;
  8010dc:	eb 23                	jmp    801101 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8010de:	83 ec 08             	sub    $0x8,%esp
  8010e1:	ff 75 0c             	pushl  0xc(%ebp)
  8010e4:	6a 25                	push   $0x25
  8010e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e9:	ff d0                	call   *%eax
  8010eb:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010ee:	ff 4d 10             	decl   0x10(%ebp)
  8010f1:	eb 03                	jmp    8010f6 <vprintfmt+0x3c3>
  8010f3:	ff 4d 10             	decl   0x10(%ebp)
  8010f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f9:	48                   	dec    %eax
  8010fa:	8a 00                	mov    (%eax),%al
  8010fc:	3c 25                	cmp    $0x25,%al
  8010fe:	75 f3                	jne    8010f3 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801100:	90                   	nop
		}
	}
  801101:	e9 35 fc ff ff       	jmp    800d3b <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801106:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801107:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80110a:	5b                   	pop    %ebx
  80110b:	5e                   	pop    %esi
  80110c:	5d                   	pop    %ebp
  80110d:	c3                   	ret    

0080110e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80110e:	55                   	push   %ebp
  80110f:	89 e5                	mov    %esp,%ebp
  801111:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801114:	8d 45 10             	lea    0x10(%ebp),%eax
  801117:	83 c0 04             	add    $0x4,%eax
  80111a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80111d:	8b 45 10             	mov    0x10(%ebp),%eax
  801120:	ff 75 f4             	pushl  -0xc(%ebp)
  801123:	50                   	push   %eax
  801124:	ff 75 0c             	pushl  0xc(%ebp)
  801127:	ff 75 08             	pushl  0x8(%ebp)
  80112a:	e8 04 fc ff ff       	call   800d33 <vprintfmt>
  80112f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801132:	90                   	nop
  801133:	c9                   	leave  
  801134:	c3                   	ret    

00801135 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801135:	55                   	push   %ebp
  801136:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801138:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113b:	8b 40 08             	mov    0x8(%eax),%eax
  80113e:	8d 50 01             	lea    0x1(%eax),%edx
  801141:	8b 45 0c             	mov    0xc(%ebp),%eax
  801144:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801147:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114a:	8b 10                	mov    (%eax),%edx
  80114c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114f:	8b 40 04             	mov    0x4(%eax),%eax
  801152:	39 c2                	cmp    %eax,%edx
  801154:	73 12                	jae    801168 <sprintputch+0x33>
		*b->buf++ = ch;
  801156:	8b 45 0c             	mov    0xc(%ebp),%eax
  801159:	8b 00                	mov    (%eax),%eax
  80115b:	8d 48 01             	lea    0x1(%eax),%ecx
  80115e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801161:	89 0a                	mov    %ecx,(%edx)
  801163:	8b 55 08             	mov    0x8(%ebp),%edx
  801166:	88 10                	mov    %dl,(%eax)
}
  801168:	90                   	nop
  801169:	5d                   	pop    %ebp
  80116a:	c3                   	ret    

0080116b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80116b:	55                   	push   %ebp
  80116c:	89 e5                	mov    %esp,%ebp
  80116e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801171:	8b 45 08             	mov    0x8(%ebp),%eax
  801174:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801177:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80117d:	8b 45 08             	mov    0x8(%ebp),%eax
  801180:	01 d0                	add    %edx,%eax
  801182:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801185:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80118c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801190:	74 06                	je     801198 <vsnprintf+0x2d>
  801192:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801196:	7f 07                	jg     80119f <vsnprintf+0x34>
		return -E_INVAL;
  801198:	b8 03 00 00 00       	mov    $0x3,%eax
  80119d:	eb 20                	jmp    8011bf <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80119f:	ff 75 14             	pushl  0x14(%ebp)
  8011a2:	ff 75 10             	pushl  0x10(%ebp)
  8011a5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8011a8:	50                   	push   %eax
  8011a9:	68 35 11 80 00       	push   $0x801135
  8011ae:	e8 80 fb ff ff       	call   800d33 <vprintfmt>
  8011b3:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8011b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011b9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8011bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8011bf:	c9                   	leave  
  8011c0:	c3                   	ret    

008011c1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011c1:	55                   	push   %ebp
  8011c2:	89 e5                	mov    %esp,%ebp
  8011c4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8011c7:	8d 45 10             	lea    0x10(%ebp),%eax
  8011ca:	83 c0 04             	add    $0x4,%eax
  8011cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8011d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d3:	ff 75 f4             	pushl  -0xc(%ebp)
  8011d6:	50                   	push   %eax
  8011d7:	ff 75 0c             	pushl  0xc(%ebp)
  8011da:	ff 75 08             	pushl  0x8(%ebp)
  8011dd:	e8 89 ff ff ff       	call   80116b <vsnprintf>
  8011e2:	83 c4 10             	add    $0x10,%esp
  8011e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8011e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8011eb:	c9                   	leave  
  8011ec:	c3                   	ret    

008011ed <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8011ed:	55                   	push   %ebp
  8011ee:	89 e5                	mov    %esp,%ebp
  8011f0:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  8011f3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011f7:	74 13                	je     80120c <readline+0x1f>
		cprintf("%s", prompt);
  8011f9:	83 ec 08             	sub    $0x8,%esp
  8011fc:	ff 75 08             	pushl  0x8(%ebp)
  8011ff:	68 e8 44 80 00       	push   $0x8044e8
  801204:	e8 50 f9 ff ff       	call   800b59 <cprintf>
  801209:	83 c4 10             	add    $0x10,%esp

	i = 0;
  80120c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801213:	83 ec 0c             	sub    $0xc,%esp
  801216:	6a 00                	push   $0x0
  801218:	e8 30 f5 ff ff       	call   80074d <iscons>
  80121d:	83 c4 10             	add    $0x10,%esp
  801220:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801223:	e8 12 f5 ff ff       	call   80073a <getchar>
  801228:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  80122b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80122f:	79 22                	jns    801253 <readline+0x66>
			if (c != -E_EOF)
  801231:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801235:	0f 84 ad 00 00 00    	je     8012e8 <readline+0xfb>
				cprintf("read error: %e\n", c);
  80123b:	83 ec 08             	sub    $0x8,%esp
  80123e:	ff 75 ec             	pushl  -0x14(%ebp)
  801241:	68 eb 44 80 00       	push   $0x8044eb
  801246:	e8 0e f9 ff ff       	call   800b59 <cprintf>
  80124b:	83 c4 10             	add    $0x10,%esp
			break;
  80124e:	e9 95 00 00 00       	jmp    8012e8 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801253:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801257:	7e 34                	jle    80128d <readline+0xa0>
  801259:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801260:	7f 2b                	jg     80128d <readline+0xa0>
			if (echoing)
  801262:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801266:	74 0e                	je     801276 <readline+0x89>
				cputchar(c);
  801268:	83 ec 0c             	sub    $0xc,%esp
  80126b:	ff 75 ec             	pushl  -0x14(%ebp)
  80126e:	e8 a8 f4 ff ff       	call   80071b <cputchar>
  801273:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801276:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801279:	8d 50 01             	lea    0x1(%eax),%edx
  80127c:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80127f:	89 c2                	mov    %eax,%edx
  801281:	8b 45 0c             	mov    0xc(%ebp),%eax
  801284:	01 d0                	add    %edx,%eax
  801286:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801289:	88 10                	mov    %dl,(%eax)
  80128b:	eb 56                	jmp    8012e3 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  80128d:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801291:	75 1f                	jne    8012b2 <readline+0xc5>
  801293:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801297:	7e 19                	jle    8012b2 <readline+0xc5>
			if (echoing)
  801299:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80129d:	74 0e                	je     8012ad <readline+0xc0>
				cputchar(c);
  80129f:	83 ec 0c             	sub    $0xc,%esp
  8012a2:	ff 75 ec             	pushl  -0x14(%ebp)
  8012a5:	e8 71 f4 ff ff       	call   80071b <cputchar>
  8012aa:	83 c4 10             	add    $0x10,%esp

			i--;
  8012ad:	ff 4d f4             	decl   -0xc(%ebp)
  8012b0:	eb 31                	jmp    8012e3 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  8012b2:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8012b6:	74 0a                	je     8012c2 <readline+0xd5>
  8012b8:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8012bc:	0f 85 61 ff ff ff    	jne    801223 <readline+0x36>
			if (echoing)
  8012c2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012c6:	74 0e                	je     8012d6 <readline+0xe9>
				cputchar(c);
  8012c8:	83 ec 0c             	sub    $0xc,%esp
  8012cb:	ff 75 ec             	pushl  -0x14(%ebp)
  8012ce:	e8 48 f4 ff ff       	call   80071b <cputchar>
  8012d3:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8012d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012dc:	01 d0                	add    %edx,%eax
  8012de:	c6 00 00             	movb   $0x0,(%eax)
			break;
  8012e1:	eb 06                	jmp    8012e9 <readline+0xfc>
		}
	}
  8012e3:	e9 3b ff ff ff       	jmp    801223 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  8012e8:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  8012e9:	90                   	nop
  8012ea:	c9                   	leave  
  8012eb:	c3                   	ret    

008012ec <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8012ec:	55                   	push   %ebp
  8012ed:	89 e5                	mov    %esp,%ebp
  8012ef:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  8012f2:	e8 3c 0f 00 00       	call   802233 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  8012f7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012fb:	74 13                	je     801310 <atomic_readline+0x24>
			cprintf("%s", prompt);
  8012fd:	83 ec 08             	sub    $0x8,%esp
  801300:	ff 75 08             	pushl  0x8(%ebp)
  801303:	68 e8 44 80 00       	push   $0x8044e8
  801308:	e8 4c f8 ff ff       	call   800b59 <cprintf>
  80130d:	83 c4 10             	add    $0x10,%esp

		i = 0;
  801310:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  801317:	83 ec 0c             	sub    $0xc,%esp
  80131a:	6a 00                	push   $0x0
  80131c:	e8 2c f4 ff ff       	call   80074d <iscons>
  801321:	83 c4 10             	add    $0x10,%esp
  801324:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  801327:	e8 0e f4 ff ff       	call   80073a <getchar>
  80132c:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  80132f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801333:	79 22                	jns    801357 <atomic_readline+0x6b>
				if (c != -E_EOF)
  801335:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801339:	0f 84 ad 00 00 00    	je     8013ec <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  80133f:	83 ec 08             	sub    $0x8,%esp
  801342:	ff 75 ec             	pushl  -0x14(%ebp)
  801345:	68 eb 44 80 00       	push   $0x8044eb
  80134a:	e8 0a f8 ff ff       	call   800b59 <cprintf>
  80134f:	83 c4 10             	add    $0x10,%esp
				break;
  801352:	e9 95 00 00 00       	jmp    8013ec <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  801357:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  80135b:	7e 34                	jle    801391 <atomic_readline+0xa5>
  80135d:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801364:	7f 2b                	jg     801391 <atomic_readline+0xa5>
				if (echoing)
  801366:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80136a:	74 0e                	je     80137a <atomic_readline+0x8e>
					cputchar(c);
  80136c:	83 ec 0c             	sub    $0xc,%esp
  80136f:	ff 75 ec             	pushl  -0x14(%ebp)
  801372:	e8 a4 f3 ff ff       	call   80071b <cputchar>
  801377:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  80137a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80137d:	8d 50 01             	lea    0x1(%eax),%edx
  801380:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801383:	89 c2                	mov    %eax,%edx
  801385:	8b 45 0c             	mov    0xc(%ebp),%eax
  801388:	01 d0                	add    %edx,%eax
  80138a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80138d:	88 10                	mov    %dl,(%eax)
  80138f:	eb 56                	jmp    8013e7 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  801391:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801395:	75 1f                	jne    8013b6 <atomic_readline+0xca>
  801397:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80139b:	7e 19                	jle    8013b6 <atomic_readline+0xca>
				if (echoing)
  80139d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013a1:	74 0e                	je     8013b1 <atomic_readline+0xc5>
					cputchar(c);
  8013a3:	83 ec 0c             	sub    $0xc,%esp
  8013a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8013a9:	e8 6d f3 ff ff       	call   80071b <cputchar>
  8013ae:	83 c4 10             	add    $0x10,%esp
				i--;
  8013b1:	ff 4d f4             	decl   -0xc(%ebp)
  8013b4:	eb 31                	jmp    8013e7 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  8013b6:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8013ba:	74 0a                	je     8013c6 <atomic_readline+0xda>
  8013bc:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8013c0:	0f 85 61 ff ff ff    	jne    801327 <atomic_readline+0x3b>
				if (echoing)
  8013c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013ca:	74 0e                	je     8013da <atomic_readline+0xee>
					cputchar(c);
  8013cc:	83 ec 0c             	sub    $0xc,%esp
  8013cf:	ff 75 ec             	pushl  -0x14(%ebp)
  8013d2:	e8 44 f3 ff ff       	call   80071b <cputchar>
  8013d7:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  8013da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e0:	01 d0                	add    %edx,%eax
  8013e2:	c6 00 00             	movb   $0x0,(%eax)
				break;
  8013e5:	eb 06                	jmp    8013ed <atomic_readline+0x101>
			}
		}
  8013e7:	e9 3b ff ff ff       	jmp    801327 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  8013ec:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  8013ed:	e8 5b 0e 00 00       	call   80224d <sys_unlock_cons>
}
  8013f2:	90                   	nop
  8013f3:	c9                   	leave  
  8013f4:	c3                   	ret    

008013f5 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  8013f5:	55                   	push   %ebp
  8013f6:	89 e5                	mov    %esp,%ebp
  8013f8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8013fb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801402:	eb 06                	jmp    80140a <strlen+0x15>
		n++;
  801404:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801407:	ff 45 08             	incl   0x8(%ebp)
  80140a:	8b 45 08             	mov    0x8(%ebp),%eax
  80140d:	8a 00                	mov    (%eax),%al
  80140f:	84 c0                	test   %al,%al
  801411:	75 f1                	jne    801404 <strlen+0xf>
		n++;
	return n;
  801413:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801416:	c9                   	leave  
  801417:	c3                   	ret    

00801418 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801418:	55                   	push   %ebp
  801419:	89 e5                	mov    %esp,%ebp
  80141b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80141e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801425:	eb 09                	jmp    801430 <strnlen+0x18>
		n++;
  801427:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80142a:	ff 45 08             	incl   0x8(%ebp)
  80142d:	ff 4d 0c             	decl   0xc(%ebp)
  801430:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801434:	74 09                	je     80143f <strnlen+0x27>
  801436:	8b 45 08             	mov    0x8(%ebp),%eax
  801439:	8a 00                	mov    (%eax),%al
  80143b:	84 c0                	test   %al,%al
  80143d:	75 e8                	jne    801427 <strnlen+0xf>
		n++;
	return n;
  80143f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801442:	c9                   	leave  
  801443:	c3                   	ret    

00801444 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801444:	55                   	push   %ebp
  801445:	89 e5                	mov    %esp,%ebp
  801447:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80144a:	8b 45 08             	mov    0x8(%ebp),%eax
  80144d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801450:	90                   	nop
  801451:	8b 45 08             	mov    0x8(%ebp),%eax
  801454:	8d 50 01             	lea    0x1(%eax),%edx
  801457:	89 55 08             	mov    %edx,0x8(%ebp)
  80145a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80145d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801460:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801463:	8a 12                	mov    (%edx),%dl
  801465:	88 10                	mov    %dl,(%eax)
  801467:	8a 00                	mov    (%eax),%al
  801469:	84 c0                	test   %al,%al
  80146b:	75 e4                	jne    801451 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80146d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801470:	c9                   	leave  
  801471:	c3                   	ret    

00801472 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801472:	55                   	push   %ebp
  801473:	89 e5                	mov    %esp,%ebp
  801475:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801478:	8b 45 08             	mov    0x8(%ebp),%eax
  80147b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80147e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801485:	eb 1f                	jmp    8014a6 <strncpy+0x34>
		*dst++ = *src;
  801487:	8b 45 08             	mov    0x8(%ebp),%eax
  80148a:	8d 50 01             	lea    0x1(%eax),%edx
  80148d:	89 55 08             	mov    %edx,0x8(%ebp)
  801490:	8b 55 0c             	mov    0xc(%ebp),%edx
  801493:	8a 12                	mov    (%edx),%dl
  801495:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801497:	8b 45 0c             	mov    0xc(%ebp),%eax
  80149a:	8a 00                	mov    (%eax),%al
  80149c:	84 c0                	test   %al,%al
  80149e:	74 03                	je     8014a3 <strncpy+0x31>
			src++;
  8014a0:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8014a3:	ff 45 fc             	incl   -0x4(%ebp)
  8014a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014a9:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014ac:	72 d9                	jb     801487 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8014ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014b1:	c9                   	leave  
  8014b2:	c3                   	ret    

008014b3 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8014b3:	55                   	push   %ebp
  8014b4:	89 e5                	mov    %esp,%ebp
  8014b6:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8014b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8014bf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014c3:	74 30                	je     8014f5 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8014c5:	eb 16                	jmp    8014dd <strlcpy+0x2a>
			*dst++ = *src++;
  8014c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ca:	8d 50 01             	lea    0x1(%eax),%edx
  8014cd:	89 55 08             	mov    %edx,0x8(%ebp)
  8014d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014d3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014d6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8014d9:	8a 12                	mov    (%edx),%dl
  8014db:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8014dd:	ff 4d 10             	decl   0x10(%ebp)
  8014e0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014e4:	74 09                	je     8014ef <strlcpy+0x3c>
  8014e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e9:	8a 00                	mov    (%eax),%al
  8014eb:	84 c0                	test   %al,%al
  8014ed:	75 d8                	jne    8014c7 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8014ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8014f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8014f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014fb:	29 c2                	sub    %eax,%edx
  8014fd:	89 d0                	mov    %edx,%eax
}
  8014ff:	c9                   	leave  
  801500:	c3                   	ret    

00801501 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801501:	55                   	push   %ebp
  801502:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801504:	eb 06                	jmp    80150c <strcmp+0xb>
		p++, q++;
  801506:	ff 45 08             	incl   0x8(%ebp)
  801509:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80150c:	8b 45 08             	mov    0x8(%ebp),%eax
  80150f:	8a 00                	mov    (%eax),%al
  801511:	84 c0                	test   %al,%al
  801513:	74 0e                	je     801523 <strcmp+0x22>
  801515:	8b 45 08             	mov    0x8(%ebp),%eax
  801518:	8a 10                	mov    (%eax),%dl
  80151a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151d:	8a 00                	mov    (%eax),%al
  80151f:	38 c2                	cmp    %al,%dl
  801521:	74 e3                	je     801506 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801523:	8b 45 08             	mov    0x8(%ebp),%eax
  801526:	8a 00                	mov    (%eax),%al
  801528:	0f b6 d0             	movzbl %al,%edx
  80152b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80152e:	8a 00                	mov    (%eax),%al
  801530:	0f b6 c0             	movzbl %al,%eax
  801533:	29 c2                	sub    %eax,%edx
  801535:	89 d0                	mov    %edx,%eax
}
  801537:	5d                   	pop    %ebp
  801538:	c3                   	ret    

00801539 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801539:	55                   	push   %ebp
  80153a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80153c:	eb 09                	jmp    801547 <strncmp+0xe>
		n--, p++, q++;
  80153e:	ff 4d 10             	decl   0x10(%ebp)
  801541:	ff 45 08             	incl   0x8(%ebp)
  801544:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801547:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80154b:	74 17                	je     801564 <strncmp+0x2b>
  80154d:	8b 45 08             	mov    0x8(%ebp),%eax
  801550:	8a 00                	mov    (%eax),%al
  801552:	84 c0                	test   %al,%al
  801554:	74 0e                	je     801564 <strncmp+0x2b>
  801556:	8b 45 08             	mov    0x8(%ebp),%eax
  801559:	8a 10                	mov    (%eax),%dl
  80155b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80155e:	8a 00                	mov    (%eax),%al
  801560:	38 c2                	cmp    %al,%dl
  801562:	74 da                	je     80153e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801564:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801568:	75 07                	jne    801571 <strncmp+0x38>
		return 0;
  80156a:	b8 00 00 00 00       	mov    $0x0,%eax
  80156f:	eb 14                	jmp    801585 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801571:	8b 45 08             	mov    0x8(%ebp),%eax
  801574:	8a 00                	mov    (%eax),%al
  801576:	0f b6 d0             	movzbl %al,%edx
  801579:	8b 45 0c             	mov    0xc(%ebp),%eax
  80157c:	8a 00                	mov    (%eax),%al
  80157e:	0f b6 c0             	movzbl %al,%eax
  801581:	29 c2                	sub    %eax,%edx
  801583:	89 d0                	mov    %edx,%eax
}
  801585:	5d                   	pop    %ebp
  801586:	c3                   	ret    

00801587 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801587:	55                   	push   %ebp
  801588:	89 e5                	mov    %esp,%ebp
  80158a:	83 ec 04             	sub    $0x4,%esp
  80158d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801590:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801593:	eb 12                	jmp    8015a7 <strchr+0x20>
		if (*s == c)
  801595:	8b 45 08             	mov    0x8(%ebp),%eax
  801598:	8a 00                	mov    (%eax),%al
  80159a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80159d:	75 05                	jne    8015a4 <strchr+0x1d>
			return (char *) s;
  80159f:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a2:	eb 11                	jmp    8015b5 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8015a4:	ff 45 08             	incl   0x8(%ebp)
  8015a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015aa:	8a 00                	mov    (%eax),%al
  8015ac:	84 c0                	test   %al,%al
  8015ae:	75 e5                	jne    801595 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8015b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015b5:	c9                   	leave  
  8015b6:	c3                   	ret    

008015b7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8015b7:	55                   	push   %ebp
  8015b8:	89 e5                	mov    %esp,%ebp
  8015ba:	83 ec 04             	sub    $0x4,%esp
  8015bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015c3:	eb 0d                	jmp    8015d2 <strfind+0x1b>
		if (*s == c)
  8015c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c8:	8a 00                	mov    (%eax),%al
  8015ca:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015cd:	74 0e                	je     8015dd <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8015cf:	ff 45 08             	incl   0x8(%ebp)
  8015d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d5:	8a 00                	mov    (%eax),%al
  8015d7:	84 c0                	test   %al,%al
  8015d9:	75 ea                	jne    8015c5 <strfind+0xe>
  8015db:	eb 01                	jmp    8015de <strfind+0x27>
		if (*s == c)
			break;
  8015dd:	90                   	nop
	return (char *) s;
  8015de:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015e1:	c9                   	leave  
  8015e2:	c3                   	ret    

008015e3 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8015e3:	55                   	push   %ebp
  8015e4:	89 e5                	mov    %esp,%ebp
  8015e6:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8015e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8015ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8015f5:	eb 0e                	jmp    801605 <memset+0x22>
		*p++ = c;
  8015f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015fa:	8d 50 01             	lea    0x1(%eax),%edx
  8015fd:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801600:	8b 55 0c             	mov    0xc(%ebp),%edx
  801603:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801605:	ff 4d f8             	decl   -0x8(%ebp)
  801608:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80160c:	79 e9                	jns    8015f7 <memset+0x14>
		*p++ = c;

	return v;
  80160e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801611:	c9                   	leave  
  801612:	c3                   	ret    

00801613 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801613:	55                   	push   %ebp
  801614:	89 e5                	mov    %esp,%ebp
  801616:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801619:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80161f:	8b 45 08             	mov    0x8(%ebp),%eax
  801622:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801625:	eb 16                	jmp    80163d <memcpy+0x2a>
		*d++ = *s++;
  801627:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80162a:	8d 50 01             	lea    0x1(%eax),%edx
  80162d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801630:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801633:	8d 4a 01             	lea    0x1(%edx),%ecx
  801636:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801639:	8a 12                	mov    (%edx),%dl
  80163b:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80163d:	8b 45 10             	mov    0x10(%ebp),%eax
  801640:	8d 50 ff             	lea    -0x1(%eax),%edx
  801643:	89 55 10             	mov    %edx,0x10(%ebp)
  801646:	85 c0                	test   %eax,%eax
  801648:	75 dd                	jne    801627 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80164a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80164d:	c9                   	leave  
  80164e:	c3                   	ret    

0080164f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80164f:	55                   	push   %ebp
  801650:	89 e5                	mov    %esp,%ebp
  801652:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801655:	8b 45 0c             	mov    0xc(%ebp),%eax
  801658:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80165b:	8b 45 08             	mov    0x8(%ebp),%eax
  80165e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801661:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801664:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801667:	73 50                	jae    8016b9 <memmove+0x6a>
  801669:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80166c:	8b 45 10             	mov    0x10(%ebp),%eax
  80166f:	01 d0                	add    %edx,%eax
  801671:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801674:	76 43                	jbe    8016b9 <memmove+0x6a>
		s += n;
  801676:	8b 45 10             	mov    0x10(%ebp),%eax
  801679:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80167c:	8b 45 10             	mov    0x10(%ebp),%eax
  80167f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801682:	eb 10                	jmp    801694 <memmove+0x45>
			*--d = *--s;
  801684:	ff 4d f8             	decl   -0x8(%ebp)
  801687:	ff 4d fc             	decl   -0x4(%ebp)
  80168a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80168d:	8a 10                	mov    (%eax),%dl
  80168f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801692:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801694:	8b 45 10             	mov    0x10(%ebp),%eax
  801697:	8d 50 ff             	lea    -0x1(%eax),%edx
  80169a:	89 55 10             	mov    %edx,0x10(%ebp)
  80169d:	85 c0                	test   %eax,%eax
  80169f:	75 e3                	jne    801684 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8016a1:	eb 23                	jmp    8016c6 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8016a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016a6:	8d 50 01             	lea    0x1(%eax),%edx
  8016a9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016ac:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016af:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016b2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8016b5:	8a 12                	mov    (%edx),%dl
  8016b7:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8016b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8016bc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016bf:	89 55 10             	mov    %edx,0x10(%ebp)
  8016c2:	85 c0                	test   %eax,%eax
  8016c4:	75 dd                	jne    8016a3 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8016c6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016c9:	c9                   	leave  
  8016ca:	c3                   	ret    

008016cb <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8016cb:	55                   	push   %ebp
  8016cc:	89 e5                	mov    %esp,%ebp
  8016ce:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8016d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8016d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016da:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8016dd:	eb 2a                	jmp    801709 <memcmp+0x3e>
		if (*s1 != *s2)
  8016df:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016e2:	8a 10                	mov    (%eax),%dl
  8016e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016e7:	8a 00                	mov    (%eax),%al
  8016e9:	38 c2                	cmp    %al,%dl
  8016eb:	74 16                	je     801703 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8016ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016f0:	8a 00                	mov    (%eax),%al
  8016f2:	0f b6 d0             	movzbl %al,%edx
  8016f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016f8:	8a 00                	mov    (%eax),%al
  8016fa:	0f b6 c0             	movzbl %al,%eax
  8016fd:	29 c2                	sub    %eax,%edx
  8016ff:	89 d0                	mov    %edx,%eax
  801701:	eb 18                	jmp    80171b <memcmp+0x50>
		s1++, s2++;
  801703:	ff 45 fc             	incl   -0x4(%ebp)
  801706:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801709:	8b 45 10             	mov    0x10(%ebp),%eax
  80170c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80170f:	89 55 10             	mov    %edx,0x10(%ebp)
  801712:	85 c0                	test   %eax,%eax
  801714:	75 c9                	jne    8016df <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801716:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80171b:	c9                   	leave  
  80171c:	c3                   	ret    

0080171d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80171d:	55                   	push   %ebp
  80171e:	89 e5                	mov    %esp,%ebp
  801720:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801723:	8b 55 08             	mov    0x8(%ebp),%edx
  801726:	8b 45 10             	mov    0x10(%ebp),%eax
  801729:	01 d0                	add    %edx,%eax
  80172b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80172e:	eb 15                	jmp    801745 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801730:	8b 45 08             	mov    0x8(%ebp),%eax
  801733:	8a 00                	mov    (%eax),%al
  801735:	0f b6 d0             	movzbl %al,%edx
  801738:	8b 45 0c             	mov    0xc(%ebp),%eax
  80173b:	0f b6 c0             	movzbl %al,%eax
  80173e:	39 c2                	cmp    %eax,%edx
  801740:	74 0d                	je     80174f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801742:	ff 45 08             	incl   0x8(%ebp)
  801745:	8b 45 08             	mov    0x8(%ebp),%eax
  801748:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80174b:	72 e3                	jb     801730 <memfind+0x13>
  80174d:	eb 01                	jmp    801750 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80174f:	90                   	nop
	return (void *) s;
  801750:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801753:	c9                   	leave  
  801754:	c3                   	ret    

00801755 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801755:	55                   	push   %ebp
  801756:	89 e5                	mov    %esp,%ebp
  801758:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80175b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801762:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801769:	eb 03                	jmp    80176e <strtol+0x19>
		s++;
  80176b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80176e:	8b 45 08             	mov    0x8(%ebp),%eax
  801771:	8a 00                	mov    (%eax),%al
  801773:	3c 20                	cmp    $0x20,%al
  801775:	74 f4                	je     80176b <strtol+0x16>
  801777:	8b 45 08             	mov    0x8(%ebp),%eax
  80177a:	8a 00                	mov    (%eax),%al
  80177c:	3c 09                	cmp    $0x9,%al
  80177e:	74 eb                	je     80176b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801780:	8b 45 08             	mov    0x8(%ebp),%eax
  801783:	8a 00                	mov    (%eax),%al
  801785:	3c 2b                	cmp    $0x2b,%al
  801787:	75 05                	jne    80178e <strtol+0x39>
		s++;
  801789:	ff 45 08             	incl   0x8(%ebp)
  80178c:	eb 13                	jmp    8017a1 <strtol+0x4c>
	else if (*s == '-')
  80178e:	8b 45 08             	mov    0x8(%ebp),%eax
  801791:	8a 00                	mov    (%eax),%al
  801793:	3c 2d                	cmp    $0x2d,%al
  801795:	75 0a                	jne    8017a1 <strtol+0x4c>
		s++, neg = 1;
  801797:	ff 45 08             	incl   0x8(%ebp)
  80179a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017a1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017a5:	74 06                	je     8017ad <strtol+0x58>
  8017a7:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8017ab:	75 20                	jne    8017cd <strtol+0x78>
  8017ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b0:	8a 00                	mov    (%eax),%al
  8017b2:	3c 30                	cmp    $0x30,%al
  8017b4:	75 17                	jne    8017cd <strtol+0x78>
  8017b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b9:	40                   	inc    %eax
  8017ba:	8a 00                	mov    (%eax),%al
  8017bc:	3c 78                	cmp    $0x78,%al
  8017be:	75 0d                	jne    8017cd <strtol+0x78>
		s += 2, base = 16;
  8017c0:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8017c4:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8017cb:	eb 28                	jmp    8017f5 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8017cd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017d1:	75 15                	jne    8017e8 <strtol+0x93>
  8017d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d6:	8a 00                	mov    (%eax),%al
  8017d8:	3c 30                	cmp    $0x30,%al
  8017da:	75 0c                	jne    8017e8 <strtol+0x93>
		s++, base = 8;
  8017dc:	ff 45 08             	incl   0x8(%ebp)
  8017df:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8017e6:	eb 0d                	jmp    8017f5 <strtol+0xa0>
	else if (base == 0)
  8017e8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017ec:	75 07                	jne    8017f5 <strtol+0xa0>
		base = 10;
  8017ee:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f8:	8a 00                	mov    (%eax),%al
  8017fa:	3c 2f                	cmp    $0x2f,%al
  8017fc:	7e 19                	jle    801817 <strtol+0xc2>
  8017fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801801:	8a 00                	mov    (%eax),%al
  801803:	3c 39                	cmp    $0x39,%al
  801805:	7f 10                	jg     801817 <strtol+0xc2>
			dig = *s - '0';
  801807:	8b 45 08             	mov    0x8(%ebp),%eax
  80180a:	8a 00                	mov    (%eax),%al
  80180c:	0f be c0             	movsbl %al,%eax
  80180f:	83 e8 30             	sub    $0x30,%eax
  801812:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801815:	eb 42                	jmp    801859 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801817:	8b 45 08             	mov    0x8(%ebp),%eax
  80181a:	8a 00                	mov    (%eax),%al
  80181c:	3c 60                	cmp    $0x60,%al
  80181e:	7e 19                	jle    801839 <strtol+0xe4>
  801820:	8b 45 08             	mov    0x8(%ebp),%eax
  801823:	8a 00                	mov    (%eax),%al
  801825:	3c 7a                	cmp    $0x7a,%al
  801827:	7f 10                	jg     801839 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801829:	8b 45 08             	mov    0x8(%ebp),%eax
  80182c:	8a 00                	mov    (%eax),%al
  80182e:	0f be c0             	movsbl %al,%eax
  801831:	83 e8 57             	sub    $0x57,%eax
  801834:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801837:	eb 20                	jmp    801859 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801839:	8b 45 08             	mov    0x8(%ebp),%eax
  80183c:	8a 00                	mov    (%eax),%al
  80183e:	3c 40                	cmp    $0x40,%al
  801840:	7e 39                	jle    80187b <strtol+0x126>
  801842:	8b 45 08             	mov    0x8(%ebp),%eax
  801845:	8a 00                	mov    (%eax),%al
  801847:	3c 5a                	cmp    $0x5a,%al
  801849:	7f 30                	jg     80187b <strtol+0x126>
			dig = *s - 'A' + 10;
  80184b:	8b 45 08             	mov    0x8(%ebp),%eax
  80184e:	8a 00                	mov    (%eax),%al
  801850:	0f be c0             	movsbl %al,%eax
  801853:	83 e8 37             	sub    $0x37,%eax
  801856:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801859:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80185c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80185f:	7d 19                	jge    80187a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801861:	ff 45 08             	incl   0x8(%ebp)
  801864:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801867:	0f af 45 10          	imul   0x10(%ebp),%eax
  80186b:	89 c2                	mov    %eax,%edx
  80186d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801870:	01 d0                	add    %edx,%eax
  801872:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801875:	e9 7b ff ff ff       	jmp    8017f5 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80187a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80187b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80187f:	74 08                	je     801889 <strtol+0x134>
		*endptr = (char *) s;
  801881:	8b 45 0c             	mov    0xc(%ebp),%eax
  801884:	8b 55 08             	mov    0x8(%ebp),%edx
  801887:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801889:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80188d:	74 07                	je     801896 <strtol+0x141>
  80188f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801892:	f7 d8                	neg    %eax
  801894:	eb 03                	jmp    801899 <strtol+0x144>
  801896:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801899:	c9                   	leave  
  80189a:	c3                   	ret    

0080189b <ltostr>:

void
ltostr(long value, char *str)
{
  80189b:	55                   	push   %ebp
  80189c:	89 e5                	mov    %esp,%ebp
  80189e:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8018a1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8018a8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8018af:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018b3:	79 13                	jns    8018c8 <ltostr+0x2d>
	{
		neg = 1;
  8018b5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8018bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018bf:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8018c2:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8018c5:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8018c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cb:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8018d0:	99                   	cltd   
  8018d1:	f7 f9                	idiv   %ecx
  8018d3:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8018d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018d9:	8d 50 01             	lea    0x1(%eax),%edx
  8018dc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018df:	89 c2                	mov    %eax,%edx
  8018e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018e4:	01 d0                	add    %edx,%eax
  8018e6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018e9:	83 c2 30             	add    $0x30,%edx
  8018ec:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8018ee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018f1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8018f6:	f7 e9                	imul   %ecx
  8018f8:	c1 fa 02             	sar    $0x2,%edx
  8018fb:	89 c8                	mov    %ecx,%eax
  8018fd:	c1 f8 1f             	sar    $0x1f,%eax
  801900:	29 c2                	sub    %eax,%edx
  801902:	89 d0                	mov    %edx,%eax
  801904:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801907:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80190b:	75 bb                	jne    8018c8 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80190d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801914:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801917:	48                   	dec    %eax
  801918:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80191b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80191f:	74 3d                	je     80195e <ltostr+0xc3>
		start = 1 ;
  801921:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801928:	eb 34                	jmp    80195e <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80192a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80192d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801930:	01 d0                	add    %edx,%eax
  801932:	8a 00                	mov    (%eax),%al
  801934:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801937:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80193a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80193d:	01 c2                	add    %eax,%edx
  80193f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801942:	8b 45 0c             	mov    0xc(%ebp),%eax
  801945:	01 c8                	add    %ecx,%eax
  801947:	8a 00                	mov    (%eax),%al
  801949:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80194b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80194e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801951:	01 c2                	add    %eax,%edx
  801953:	8a 45 eb             	mov    -0x15(%ebp),%al
  801956:	88 02                	mov    %al,(%edx)
		start++ ;
  801958:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80195b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80195e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801961:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801964:	7c c4                	jl     80192a <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801966:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801969:	8b 45 0c             	mov    0xc(%ebp),%eax
  80196c:	01 d0                	add    %edx,%eax
  80196e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801971:	90                   	nop
  801972:	c9                   	leave  
  801973:	c3                   	ret    

00801974 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801974:	55                   	push   %ebp
  801975:	89 e5                	mov    %esp,%ebp
  801977:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80197a:	ff 75 08             	pushl  0x8(%ebp)
  80197d:	e8 73 fa ff ff       	call   8013f5 <strlen>
  801982:	83 c4 04             	add    $0x4,%esp
  801985:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801988:	ff 75 0c             	pushl  0xc(%ebp)
  80198b:	e8 65 fa ff ff       	call   8013f5 <strlen>
  801990:	83 c4 04             	add    $0x4,%esp
  801993:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801996:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80199d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8019a4:	eb 17                	jmp    8019bd <strcconcat+0x49>
		final[s] = str1[s] ;
  8019a6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ac:	01 c2                	add    %eax,%edx
  8019ae:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8019b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b4:	01 c8                	add    %ecx,%eax
  8019b6:	8a 00                	mov    (%eax),%al
  8019b8:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8019ba:	ff 45 fc             	incl   -0x4(%ebp)
  8019bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019c0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8019c3:	7c e1                	jl     8019a6 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8019c5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8019cc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8019d3:	eb 1f                	jmp    8019f4 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8019d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019d8:	8d 50 01             	lea    0x1(%eax),%edx
  8019db:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8019de:	89 c2                	mov    %eax,%edx
  8019e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8019e3:	01 c2                	add    %eax,%edx
  8019e5:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8019e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019eb:	01 c8                	add    %ecx,%eax
  8019ed:	8a 00                	mov    (%eax),%al
  8019ef:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8019f1:	ff 45 f8             	incl   -0x8(%ebp)
  8019f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019f7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019fa:	7c d9                	jl     8019d5 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8019fc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801a02:	01 d0                	add    %edx,%eax
  801a04:	c6 00 00             	movb   $0x0,(%eax)
}
  801a07:	90                   	nop
  801a08:	c9                   	leave  
  801a09:	c3                   	ret    

00801a0a <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801a0a:	55                   	push   %ebp
  801a0b:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801a0d:	8b 45 14             	mov    0x14(%ebp),%eax
  801a10:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801a16:	8b 45 14             	mov    0x14(%ebp),%eax
  801a19:	8b 00                	mov    (%eax),%eax
  801a1b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a22:	8b 45 10             	mov    0x10(%ebp),%eax
  801a25:	01 d0                	add    %edx,%eax
  801a27:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a2d:	eb 0c                	jmp    801a3b <strsplit+0x31>
			*string++ = 0;
  801a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a32:	8d 50 01             	lea    0x1(%eax),%edx
  801a35:	89 55 08             	mov    %edx,0x8(%ebp)
  801a38:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3e:	8a 00                	mov    (%eax),%al
  801a40:	84 c0                	test   %al,%al
  801a42:	74 18                	je     801a5c <strsplit+0x52>
  801a44:	8b 45 08             	mov    0x8(%ebp),%eax
  801a47:	8a 00                	mov    (%eax),%al
  801a49:	0f be c0             	movsbl %al,%eax
  801a4c:	50                   	push   %eax
  801a4d:	ff 75 0c             	pushl  0xc(%ebp)
  801a50:	e8 32 fb ff ff       	call   801587 <strchr>
  801a55:	83 c4 08             	add    $0x8,%esp
  801a58:	85 c0                	test   %eax,%eax
  801a5a:	75 d3                	jne    801a2f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5f:	8a 00                	mov    (%eax),%al
  801a61:	84 c0                	test   %al,%al
  801a63:	74 5a                	je     801abf <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a65:	8b 45 14             	mov    0x14(%ebp),%eax
  801a68:	8b 00                	mov    (%eax),%eax
  801a6a:	83 f8 0f             	cmp    $0xf,%eax
  801a6d:	75 07                	jne    801a76 <strsplit+0x6c>
		{
			return 0;
  801a6f:	b8 00 00 00 00       	mov    $0x0,%eax
  801a74:	eb 66                	jmp    801adc <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a76:	8b 45 14             	mov    0x14(%ebp),%eax
  801a79:	8b 00                	mov    (%eax),%eax
  801a7b:	8d 48 01             	lea    0x1(%eax),%ecx
  801a7e:	8b 55 14             	mov    0x14(%ebp),%edx
  801a81:	89 0a                	mov    %ecx,(%edx)
  801a83:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a8a:	8b 45 10             	mov    0x10(%ebp),%eax
  801a8d:	01 c2                	add    %eax,%edx
  801a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a92:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a94:	eb 03                	jmp    801a99 <strsplit+0x8f>
			string++;
  801a96:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a99:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9c:	8a 00                	mov    (%eax),%al
  801a9e:	84 c0                	test   %al,%al
  801aa0:	74 8b                	je     801a2d <strsplit+0x23>
  801aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa5:	8a 00                	mov    (%eax),%al
  801aa7:	0f be c0             	movsbl %al,%eax
  801aaa:	50                   	push   %eax
  801aab:	ff 75 0c             	pushl  0xc(%ebp)
  801aae:	e8 d4 fa ff ff       	call   801587 <strchr>
  801ab3:	83 c4 08             	add    $0x8,%esp
  801ab6:	85 c0                	test   %eax,%eax
  801ab8:	74 dc                	je     801a96 <strsplit+0x8c>
			string++;
	}
  801aba:	e9 6e ff ff ff       	jmp    801a2d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801abf:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801ac0:	8b 45 14             	mov    0x14(%ebp),%eax
  801ac3:	8b 00                	mov    (%eax),%eax
  801ac5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801acc:	8b 45 10             	mov    0x10(%ebp),%eax
  801acf:	01 d0                	add    %edx,%eax
  801ad1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801ad7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801adc:	c9                   	leave  
  801add:	c3                   	ret    

00801ade <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801ade:	55                   	push   %ebp
  801adf:	89 e5                	mov    %esp,%ebp
  801ae1:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801ae4:	83 ec 04             	sub    $0x4,%esp
  801ae7:	68 fc 44 80 00       	push   $0x8044fc
  801aec:	68 3f 01 00 00       	push   $0x13f
  801af1:	68 1e 45 80 00       	push   $0x80451e
  801af6:	e8 a1 ed ff ff       	call   80089c <_panic>

00801afb <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  801afb:	55                   	push   %ebp
  801afc:	89 e5                	mov    %esp,%ebp
  801afe:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801b01:	83 ec 0c             	sub    $0xc,%esp
  801b04:	ff 75 08             	pushl  0x8(%ebp)
  801b07:	e8 90 0c 00 00       	call   80279c <sys_sbrk>
  801b0c:	83 c4 10             	add    $0x10,%esp
}
  801b0f:	c9                   	leave  
  801b10:	c3                   	ret    

00801b11 <malloc>:
#define num_of_page ((USER_HEAP_MAX - USER_HEAP_START) / PAGE_SIZE)

int pagesAllocated[num_of_page] = { 0 };
int shardIDs[num_of_page] = { 0 };
bool markedPages[num_of_page] = { 0 };
void* malloc(uint32 size) {
  801b11:	55                   	push   %ebp
  801b12:	89 e5                	mov    %esp,%ebp
  801b14:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  801b17:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b1b:	75 0a                	jne    801b27 <malloc+0x16>
		return NULL;
  801b1d:	b8 00 00 00 00       	mov    $0x0,%eax
  801b22:	e9 9e 01 00 00       	jmp    801cc5 <malloc+0x1b4>

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

	//  our new code
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  801b27:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801b2e:	77 2c                	ja     801b5c <malloc+0x4b>
		if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  801b30:	e8 eb 0a 00 00       	call   802620 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b35:	85 c0                	test   %eax,%eax
  801b37:	74 19                	je     801b52 <malloc+0x41>

			void * block = alloc_block_FF(size);
  801b39:	83 ec 0c             	sub    $0xc,%esp
  801b3c:	ff 75 08             	pushl  0x8(%ebp)
  801b3f:	e8 85 11 00 00       	call   802cc9 <alloc_block_FF>
  801b44:	83 c4 10             	add    $0x10,%esp
  801b47:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			return block;
  801b4a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b4d:	e9 73 01 00 00       	jmp    801cc5 <malloc+0x1b4>
		} else {
			return NULL;
  801b52:	b8 00 00 00 00       	mov    $0x0,%eax
  801b57:	e9 69 01 00 00       	jmp    801cc5 <malloc+0x1b4>
		}
	}

	uint32 numOfPages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801b5c:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801b63:	8b 55 08             	mov    0x8(%ebp),%edx
  801b66:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b69:	01 d0                	add    %edx,%eax
  801b6b:	48                   	dec    %eax
  801b6c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801b6f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b72:	ba 00 00 00 00       	mov    $0x0,%edx
  801b77:	f7 75 e0             	divl   -0x20(%ebp)
  801b7a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b7d:	29 d0                	sub    %edx,%eax
  801b7f:	c1 e8 0c             	shr    $0xc,%eax
  801b82:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 freePagesCount = 0;
  801b85:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801b8c:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  801b93:	a1 24 50 80 00       	mov    0x805024,%eax
  801b98:	8b 40 7c             	mov    0x7c(%eax),%eax
  801b9b:	05 00 10 00 00       	add    $0x1000,%eax
  801ba0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  801ba3:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801ba8:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801bab:	89 45 d0             	mov    %eax,-0x30(%ebp)

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  801bae:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  801bb5:	8b 55 08             	mov    0x8(%ebp),%edx
  801bb8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801bbb:	01 d0                	add    %edx,%eax
  801bbd:	48                   	dec    %eax
  801bbe:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801bc1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801bc4:	ba 00 00 00 00       	mov    $0x0,%edx
  801bc9:	f7 75 cc             	divl   -0x34(%ebp)
  801bcc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801bcf:	29 d0                	sub    %edx,%eax
  801bd1:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801bd4:	76 0a                	jbe    801be0 <malloc+0xcf>
		return NULL;
  801bd6:	b8 00 00 00 00       	mov    $0x0,%eax
  801bdb:	e9 e5 00 00 00       	jmp    801cc5 <malloc+0x1b4>
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  801be0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801be3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801be6:	eb 48                	jmp    801c30 <malloc+0x11f>
	{
		uint32 idx = (i - currentAddr) / PAGE_SIZE;
  801be8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801beb:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801bee:	c1 e8 0c             	shr    $0xc,%eax
  801bf1:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if (!markedPages[idx]) {
  801bf4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801bf7:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  801bfe:	85 c0                	test   %eax,%eax
  801c00:	75 11                	jne    801c13 <malloc+0x102>
			freePagesCount++;
  801c02:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801c05:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801c09:	75 16                	jne    801c21 <malloc+0x110>
				start = i;
  801c0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c11:	eb 0e                	jmp    801c21 <malloc+0x110>
			}
		} else {
			freePagesCount = 0;
  801c13:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  801c1a:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == numOfPages) {
  801c21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c24:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801c27:	74 12                	je     801c3b <malloc+0x12a>

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  801c29:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801c30:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801c37:	76 af                	jbe    801be8 <malloc+0xd7>
  801c39:	eb 01                	jmp    801c3c <malloc+0x12b>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == numOfPages) {
			break;
  801c3b:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
  801c3c:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801c40:	74 08                	je     801c4a <malloc+0x139>
  801c42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c45:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801c48:	74 07                	je     801c51 <malloc+0x140>
		return NULL;
  801c4a:	b8 00 00 00 00       	mov    $0x0,%eax
  801c4f:	eb 74                	jmp    801cc5 <malloc+0x1b4>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  801c51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c54:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801c57:	c1 e8 0c             	shr    $0xc,%eax
  801c5a:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numOfPages;
  801c5d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801c60:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801c63:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  801c6a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801c6d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801c70:	eb 11                	jmp    801c83 <malloc+0x172>
		markedPages[i] = 1;
  801c72:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c75:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  801c7c:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = numOfPages;
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  801c80:	ff 45 e8             	incl   -0x18(%ebp)
  801c83:	8b 55 c0             	mov    -0x40(%ebp),%edx
  801c86:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c89:	01 d0                	add    %edx,%eax
  801c8b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801c8e:	77 e2                	ja     801c72 <malloc+0x161>
		markedPages[i] = 1;
	}

	sys_allocate_user_mem(start, ROUNDUP(size, PAGE_SIZE));
  801c90:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801c97:	8b 55 08             	mov    0x8(%ebp),%edx
  801c9a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801c9d:	01 d0                	add    %edx,%eax
  801c9f:	48                   	dec    %eax
  801ca0:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801ca3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801ca6:	ba 00 00 00 00       	mov    $0x0,%edx
  801cab:	f7 75 bc             	divl   -0x44(%ebp)
  801cae:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801cb1:	29 d0                	sub    %edx,%eax
  801cb3:	83 ec 08             	sub    $0x8,%esp
  801cb6:	50                   	push   %eax
  801cb7:	ff 75 f0             	pushl  -0x10(%ebp)
  801cba:	e8 14 0b 00 00       	call   8027d3 <sys_allocate_user_mem>
  801cbf:	83 c4 10             	add    $0x10,%esp
	return (void*) start;
  801cc2:	8b 45 f0             	mov    -0x10(%ebp),%eax

}
  801cc5:	c9                   	leave  
  801cc6:	c3                   	ret    

00801cc7 <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address) {
  801cc7:	55                   	push   %ebp
  801cc8:	89 e5                	mov    %esp,%ebp
  801cca:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
  801ccd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801cd1:	0f 84 ee 00 00 00    	je     801dc5 <free+0xfe>
		return;
	}

	if (virtual_address
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  801cd7:	a1 24 50 80 00       	mov    0x805024,%eax
  801cdc:	8b 40 74             	mov    0x74(%eax),%eax

	if (virtual_address == NULL) {
		return;
	}

	if (virtual_address
  801cdf:	3b 45 08             	cmp    0x8(%ebp),%eax
  801ce2:	77 09                	ja     801ced <free+0x26>
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  801ce4:	81 7d 08 00 00 00 a0 	cmpl   $0xa0000000,0x8(%ebp)
  801ceb:	76 14                	jbe    801d01 <free+0x3a>
		panic("INVALID VIRTUAL ADDRESS!!");
  801ced:	83 ec 04             	sub    $0x4,%esp
  801cf0:	68 2c 45 80 00       	push   $0x80452c
  801cf5:	6a 68                	push   $0x68
  801cf7:	68 46 45 80 00       	push   $0x804546
  801cfc:	e8 9b eb ff ff       	call   80089c <_panic>
	}
	if (virtual_address >= (void *) (myEnv->uheapStart)
  801d01:	a1 24 50 80 00       	mov    0x805024,%eax
  801d06:	8b 40 74             	mov    0x74(%eax),%eax
  801d09:	3b 45 08             	cmp    0x8(%ebp),%eax
  801d0c:	77 20                	ja     801d2e <free+0x67>
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
  801d0e:	a1 24 50 80 00       	mov    0x805024,%eax
  801d13:	8b 40 78             	mov    0x78(%eax),%eax
  801d16:	3b 45 08             	cmp    0x8(%ebp),%eax
  801d19:	76 13                	jbe    801d2e <free+0x67>
		free_block(virtual_address);
  801d1b:	83 ec 0c             	sub    $0xc,%esp
  801d1e:	ff 75 08             	pushl  0x8(%ebp)
  801d21:	e8 6c 16 00 00       	call   803392 <free_block>
  801d26:	83 c4 10             	add    $0x10,%esp
		return;
  801d29:	e9 98 00 00 00       	jmp    801dc6 <free+0xff>
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  801d2e:	8b 55 08             	mov    0x8(%ebp),%edx
  801d31:	a1 24 50 80 00       	mov    0x805024,%eax
  801d36:	8b 40 7c             	mov    0x7c(%eax),%eax
  801d39:	29 c2                	sub    %eax,%edx
  801d3b:	89 d0                	mov    %edx,%eax
  801d3d:	2d 00 10 00 00       	sub    $0x1000,%eax
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
		free_block(virtual_address);
		return;
	}

	uint32 pageIdx = ((uint32) virtual_address
  801d42:	c1 e8 0c             	shr    $0xc,%eax
  801d45:	89 45 ec             	mov    %eax,-0x14(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  801d48:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801d4f:	eb 16                	jmp    801d67 <free+0xa0>
		markedPages[idx + pageIdx] = 0;
  801d51:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d54:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d57:	01 d0                	add    %edx,%eax
  801d59:	c7 04 85 40 50 90 00 	movl   $0x0,0x905040(,%eax,4)
  801d60:	00 00 00 00 
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  801d64:	ff 45 f4             	incl   -0xc(%ebp)
  801d67:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d6a:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  801d71:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801d74:	7f db                	jg     801d51 <free+0x8a>
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;
  801d76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d79:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  801d80:	c1 e0 0c             	shl    $0xc,%eax
  801d83:	89 45 e8             	mov    %eax,-0x18(%ebp)

	for (uint32 i = (uint32) virtual_address;
  801d86:	8b 45 08             	mov    0x8(%ebp),%eax
  801d89:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d8c:	eb 1a                	jmp    801da8 <free+0xe1>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
  801d8e:	83 ec 08             	sub    $0x8,%esp
  801d91:	68 00 10 00 00       	push   $0x1000
  801d96:	ff 75 f0             	pushl  -0x10(%ebp)
  801d99:	e8 19 0a 00 00       	call   8027b7 <sys_free_user_mem>
  801d9e:	83 c4 10             	add    $0x10,%esp
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
  801da1:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  801da8:	8b 55 08             	mov    0x8(%ebp),%edx
  801dab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801dae:	01 d0                	add    %edx,%eax
	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
  801db0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801db3:	77 d9                	ja     801d8e <free+0xc7>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;
  801db5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801db8:	c7 04 85 40 50 80 00 	movl   $0x0,0x805040(,%eax,4)
  801dbf:	00 00 00 00 
  801dc3:	eb 01                	jmp    801dc6 <free+0xff>
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
		return;
  801dc5:	90                   	nop
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;

}
  801dc6:	c9                   	leave  
  801dc7:	c3                   	ret    

00801dc8 <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  801dc8:	55                   	push   %ebp
  801dc9:	89 e5                	mov    %esp,%ebp
  801dcb:	83 ec 58             	sub    $0x58,%esp
  801dce:	8b 45 10             	mov    0x10(%ebp),%eax
  801dd1:	88 45 b4             	mov    %al,-0x4c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  801dd4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801dd8:	75 0a                	jne    801de4 <smalloc+0x1c>
		return NULL;
  801dda:	b8 00 00 00 00       	mov    $0x0,%eax
  801ddf:	e9 7d 01 00 00       	jmp    801f61 <smalloc+0x199>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	uint32 num_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801de4:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  801deb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801df1:	01 d0                	add    %edx,%eax
  801df3:	48                   	dec    %eax
  801df4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801df7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801dfa:	ba 00 00 00 00       	mov    $0x0,%edx
  801dff:	f7 75 e4             	divl   -0x1c(%ebp)
  801e02:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e05:	29 d0                	sub    %edx,%eax
  801e07:	c1 e8 0c             	shr    $0xc,%eax
  801e0a:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 freePagesCount = 0;
  801e0d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801e14:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  801e1b:	a1 24 50 80 00       	mov    0x805024,%eax
  801e20:	8b 40 7c             	mov    0x7c(%eax),%eax
  801e23:	05 00 10 00 00       	add    $0x1000,%eax
  801e28:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  801e2b:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801e30:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801e33:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  801e36:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801e3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e40:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e43:	01 d0                	add    %edx,%eax
  801e45:	48                   	dec    %eax
  801e46:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801e49:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801e4c:	ba 00 00 00 00       	mov    $0x0,%edx
  801e51:	f7 75 d0             	divl   -0x30(%ebp)
  801e54:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801e57:	29 d0                	sub    %edx,%eax
  801e59:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801e5c:	76 0a                	jbe    801e68 <smalloc+0xa0>
		return NULL;
  801e5e:	b8 00 00 00 00       	mov    $0x0,%eax
  801e63:	e9 f9 00 00 00       	jmp    801f61 <smalloc+0x199>
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801e68:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e6b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801e6e:	eb 48                	jmp    801eb8 <smalloc+0xf0>
		uint32 idx = (s - currentAddr) / PAGE_SIZE;
  801e70:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e73:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801e76:	c1 e8 0c             	shr    $0xc,%eax
  801e79:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (!markedPages[idx]) {
  801e7c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801e7f:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  801e86:	85 c0                	test   %eax,%eax
  801e88:	75 11                	jne    801e9b <smalloc+0xd3>
			freePagesCount++;
  801e8a:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801e8d:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801e91:	75 16                	jne    801ea9 <smalloc+0xe1>
				start = s;
  801e93:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e96:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e99:	eb 0e                	jmp    801ea9 <smalloc+0xe1>
			}
		} else {
			freePagesCount = 0;
  801e9b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  801ea2:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == num_Of_Pages) {
  801ea9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eac:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801eaf:	74 12                	je     801ec3 <smalloc+0xfb>
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801eb1:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801eb8:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801ebf:	76 af                	jbe    801e70 <smalloc+0xa8>
  801ec1:	eb 01                	jmp    801ec4 <smalloc+0xfc>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == num_Of_Pages) {
			break;
  801ec3:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
  801ec4:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801ec8:	74 08                	je     801ed2 <smalloc+0x10a>
  801eca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ecd:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801ed0:	74 0a                	je     801edc <smalloc+0x114>
		return NULL;
  801ed2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed7:	e9 85 00 00 00       	jmp    801f61 <smalloc+0x199>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  801edc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801edf:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801ee2:	c1 e8 0c             	shr    $0xc,%eax
  801ee5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	pagesAllocated[startPage] = num_Of_Pages;
  801ee8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801eeb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801eee:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  801ef5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801ef8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801efb:	eb 11                	jmp    801f0e <smalloc+0x146>
		markedPages[s] = 1;
  801efd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f00:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  801f07:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = num_Of_Pages;
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  801f0b:	ff 45 e8             	incl   -0x18(%ebp)
  801f0e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801f11:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801f14:	01 d0                	add    %edx,%eax
  801f16:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801f19:	77 e2                	ja     801efd <smalloc+0x135>
		markedPages[s] = 1;
	}
	int sharedobjID = sys_createSharedObject(sharedVarName, size, isWritable,
  801f1b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f1e:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
  801f22:	52                   	push   %edx
  801f23:	50                   	push   %eax
  801f24:	ff 75 0c             	pushl  0xc(%ebp)
  801f27:	ff 75 08             	pushl  0x8(%ebp)
  801f2a:	e8 8f 04 00 00       	call   8023be <sys_createSharedObject>
  801f2f:	83 c4 10             	add    $0x10,%esp
  801f32:	89 45 c0             	mov    %eax,-0x40(%ebp)
			(void*) start);

	if (sharedobjID >= 0) {
  801f35:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  801f39:	78 12                	js     801f4d <smalloc+0x185>
		shardIDs[startPage] = sharedobjID;
  801f3b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801f3e:	8b 55 c0             	mov    -0x40(%ebp),%edx
  801f41:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  801f48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f4b:	eb 14                	jmp    801f61 <smalloc+0x199>
	}
	free((void*) start);
  801f4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f50:	83 ec 0c             	sub    $0xc,%esp
  801f53:	50                   	push   %eax
  801f54:	e8 6e fd ff ff       	call   801cc7 <free>
  801f59:	83 c4 10             	add    $0x10,%esp
	return NULL;
  801f5c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f61:	c9                   	leave  
  801f62:	c3                   	ret    

00801f63 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  801f63:	55                   	push   %ebp
  801f64:	89 e5                	mov    %esp,%ebp
  801f66:	83 ec 48             	sub    $0x48,%esp
	//cprintf("SSSSSGEEETTT\n");
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID, sharedVarName);
  801f69:	83 ec 08             	sub    $0x8,%esp
  801f6c:	ff 75 0c             	pushl  0xc(%ebp)
  801f6f:	ff 75 08             	pushl  0x8(%ebp)
  801f72:	e8 71 04 00 00       	call   8023e8 <sys_getSizeOfSharedObject>
  801f77:	83 c4 10             	add    $0x10,%esp
  801f7a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (size < 0)
		return NULL;
	uint32 numb_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801f7d:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801f84:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801f87:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f8a:	01 d0                	add    %edx,%eax
  801f8c:	48                   	dec    %eax
  801f8d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801f90:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801f93:	ba 00 00 00 00       	mov    $0x0,%edx
  801f98:	f7 75 e0             	divl   -0x20(%ebp)
  801f9b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801f9e:	29 d0                	sub    %edx,%eax
  801fa0:	c1 e8 0c             	shr    $0xc,%eax
  801fa3:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 free_Pages_Count = 0;
  801fa6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801fad:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
  801fb4:	a1 24 50 80 00       	mov    0x805024,%eax
  801fb9:	8b 40 7c             	mov    0x7c(%eax),%eax
  801fbc:	05 00 10 00 00       	add    $0x1000,%eax
  801fc1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
  801fc4:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801fc9:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801fcc:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
  801fcf:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  801fd6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801fd9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801fdc:	01 d0                	add    %edx,%eax
  801fde:	48                   	dec    %eax
  801fdf:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801fe2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801fe5:	ba 00 00 00 00       	mov    $0x0,%edx
  801fea:	f7 75 cc             	divl   -0x34(%ebp)
  801fed:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801ff0:	29 d0                	sub    %edx,%eax
  801ff2:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801ff5:	76 0a                	jbe    802001 <sget+0x9e>
		return NULL;
  801ff7:	b8 00 00 00 00       	mov    $0x0,%eax
  801ffc:	e9 f7 00 00 00       	jmp    8020f8 <sget+0x195>
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  802001:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802004:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802007:	eb 48                	jmp    802051 <sget+0xee>
		uint32 idx = (s - current_Addr) / PAGE_SIZE;
  802009:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80200c:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80200f:	c1 e8 0c             	shr    $0xc,%eax
  802012:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if (!markedPages[idx]) {
  802015:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802018:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  80201f:	85 c0                	test   %eax,%eax
  802021:	75 11                	jne    802034 <sget+0xd1>
			free_Pages_Count++;
  802023:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  802026:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80202a:	75 16                	jne    802042 <sget+0xdf>
				start = s;
  80202c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80202f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802032:	eb 0e                	jmp    802042 <sget+0xdf>
			}
		} else {
			free_Pages_Count = 0;
  802034:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  80203b:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (free_Pages_Count == numb_Of_Pages) {
  802042:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802045:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  802048:	74 12                	je     80205c <sget+0xf9>
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
		return NULL;
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  80204a:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  802051:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  802058:	76 af                	jbe    802009 <sget+0xa6>
  80205a:	eb 01                	jmp    80205d <sget+0xfa>
		} else {
			free_Pages_Count = 0;
			start = (uint32) -1;
		}
		if (free_Pages_Count == numb_Of_Pages) {
			break;
  80205c:	90                   	nop
		}
	}
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
  80205d:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802061:	74 08                	je     80206b <sget+0x108>
  802063:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802066:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  802069:	74 0a                	je     802075 <sget+0x112>
		return NULL;
  80206b:	b8 00 00 00 00       	mov    $0x0,%eax
  802070:	e9 83 00 00 00       	jmp    8020f8 <sget+0x195>
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
  802075:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802078:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80207b:	c1 e8 0c             	shr    $0xc,%eax
  80207e:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numb_Of_Pages;
  802081:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802084:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802087:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  80208e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802091:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802094:	eb 11                	jmp    8020a7 <sget+0x144>
		markedPages[k] = 1;
  802096:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802099:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  8020a0:	01 00 00 00 
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
	pagesAllocated[startPage] = numb_Of_Pages;
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  8020a4:	ff 45 e8             	incl   -0x18(%ebp)
  8020a7:	8b 55 c0             	mov    -0x40(%ebp),%edx
  8020aa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8020ad:	01 d0                	add    %edx,%eax
  8020af:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8020b2:	77 e2                	ja     802096 <sget+0x133>
		markedPages[k] = 1;
	}
	int ss = sys_getSharedObject(ownerEnvID, sharedVarName, (void*) start);
  8020b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020b7:	83 ec 04             	sub    $0x4,%esp
  8020ba:	50                   	push   %eax
  8020bb:	ff 75 0c             	pushl  0xc(%ebp)
  8020be:	ff 75 08             	pushl  0x8(%ebp)
  8020c1:	e8 3f 03 00 00       	call   802405 <sys_getSharedObject>
  8020c6:	83 c4 10             	add    $0x10,%esp
  8020c9:	89 45 bc             	mov    %eax,-0x44(%ebp)
	if (ss >= 0) {
  8020cc:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  8020d0:	78 12                	js     8020e4 <sget+0x181>
		shardIDs[startPage] = ss;
  8020d2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8020d5:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8020d8:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  8020df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020e2:	eb 14                	jmp    8020f8 <sget+0x195>
	}
	free((void*) start);
  8020e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020e7:	83 ec 0c             	sub    $0xc,%esp
  8020ea:	50                   	push   %eax
  8020eb:	e8 d7 fb ff ff       	call   801cc7 <free>
  8020f0:	83 c4 10             	add    $0x10,%esp
	return NULL;
  8020f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020f8:	c9                   	leave  
  8020f9:	c3                   	ret    

008020fa <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  8020fa:	55                   	push   %ebp
  8020fb:	89 e5                	mov    %esp,%ebp
  8020fd:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  802100:	8b 55 08             	mov    0x8(%ebp),%edx
  802103:	a1 24 50 80 00       	mov    0x805024,%eax
  802108:	8b 40 7c             	mov    0x7c(%eax),%eax
  80210b:	29 c2                	sub    %eax,%edx
  80210d:	89 d0                	mov    %edx,%eax
  80210f:	2d 00 10 00 00       	sub    $0x1000,%eax

void sfree(void* virtual_address) {
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
  802114:	c1 e8 0c             	shr    $0xc,%eax
  802117:	89 45 f4             	mov    %eax,-0xc(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
	int id = shardIDs[pageIdx];
  80211a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211d:	8b 04 85 40 50 88 00 	mov    0x885040(,%eax,4),%eax
  802124:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int result = sys_freeSharedObject(id, virtual_address);
  802127:	83 ec 08             	sub    $0x8,%esp
  80212a:	ff 75 08             	pushl  0x8(%ebp)
  80212d:	ff 75 f0             	pushl  -0x10(%ebp)
  802130:	e8 ef 02 00 00       	call   802424 <sys_freeSharedObject>
  802135:	83 c4 10             	add    $0x10,%esp
  802138:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (result == 0) {
  80213b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80213f:	75 0e                	jne    80214f <sfree+0x55>
		shardIDs[pageIdx] = -1;  // Reset the ID after freeing
  802141:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802144:	c7 04 85 40 50 88 00 	movl   $0xffffffff,0x885040(,%eax,4)
  80214b:	ff ff ff ff 
	}

}
  80214f:	90                   	nop
  802150:	c9                   	leave  
  802151:	c3                   	ret    

00802152 <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  802152:	55                   	push   %ebp
  802153:	89 e5                	mov    %esp,%ebp
  802155:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802158:	83 ec 04             	sub    $0x4,%esp
  80215b:	68 54 45 80 00       	push   $0x804554
  802160:	68 19 01 00 00       	push   $0x119
  802165:	68 46 45 80 00       	push   $0x804546
  80216a:	e8 2d e7 ff ff       	call   80089c <_panic>

0080216f <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  80216f:	55                   	push   %ebp
  802170:	89 e5                	mov    %esp,%ebp
  802172:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802175:	83 ec 04             	sub    $0x4,%esp
  802178:	68 7a 45 80 00       	push   $0x80457a
  80217d:	68 23 01 00 00       	push   $0x123
  802182:	68 46 45 80 00       	push   $0x804546
  802187:	e8 10 e7 ff ff       	call   80089c <_panic>

0080218c <shrink>:

}
void shrink(uint32 newSize) {
  80218c:	55                   	push   %ebp
  80218d:	89 e5                	mov    %esp,%ebp
  80218f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802192:	83 ec 04             	sub    $0x4,%esp
  802195:	68 7a 45 80 00       	push   $0x80457a
  80219a:	68 27 01 00 00       	push   $0x127
  80219f:	68 46 45 80 00       	push   $0x804546
  8021a4:	e8 f3 e6 ff ff       	call   80089c <_panic>

008021a9 <freeHeap>:

}
void freeHeap(void* virtual_address) {
  8021a9:	55                   	push   %ebp
  8021aa:	89 e5                	mov    %esp,%ebp
  8021ac:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8021af:	83 ec 04             	sub    $0x4,%esp
  8021b2:	68 7a 45 80 00       	push   $0x80457a
  8021b7:	68 2b 01 00 00       	push   $0x12b
  8021bc:	68 46 45 80 00       	push   $0x804546
  8021c1:	e8 d6 e6 ff ff       	call   80089c <_panic>

008021c6 <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  8021c6:	55                   	push   %ebp
  8021c7:	89 e5                	mov    %esp,%ebp
  8021c9:	57                   	push   %edi
  8021ca:	56                   	push   %esi
  8021cb:	53                   	push   %ebx
  8021cc:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8021cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021d5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021d8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021db:	8b 7d 18             	mov    0x18(%ebp),%edi
  8021de:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8021e1:	cd 30                	int    $0x30
  8021e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  8021e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8021e9:	83 c4 10             	add    $0x10,%esp
  8021ec:	5b                   	pop    %ebx
  8021ed:	5e                   	pop    %esi
  8021ee:	5f                   	pop    %edi
  8021ef:	5d                   	pop    %ebp
  8021f0:	c3                   	ret    

008021f1 <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  8021f1:	55                   	push   %ebp
  8021f2:	89 e5                	mov    %esp,%ebp
  8021f4:	83 ec 04             	sub    $0x4,%esp
  8021f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8021fa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  8021fd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802201:	8b 45 08             	mov    0x8(%ebp),%eax
  802204:	6a 00                	push   $0x0
  802206:	6a 00                	push   $0x0
  802208:	52                   	push   %edx
  802209:	ff 75 0c             	pushl  0xc(%ebp)
  80220c:	50                   	push   %eax
  80220d:	6a 00                	push   $0x0
  80220f:	e8 b2 ff ff ff       	call   8021c6 <syscall>
  802214:	83 c4 18             	add    $0x18,%esp
}
  802217:	90                   	nop
  802218:	c9                   	leave  
  802219:	c3                   	ret    

0080221a <sys_cgetc>:

int sys_cgetc(void) {
  80221a:	55                   	push   %ebp
  80221b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80221d:	6a 00                	push   $0x0
  80221f:	6a 00                	push   $0x0
  802221:	6a 00                	push   $0x0
  802223:	6a 00                	push   $0x0
  802225:	6a 00                	push   $0x0
  802227:	6a 02                	push   $0x2
  802229:	e8 98 ff ff ff       	call   8021c6 <syscall>
  80222e:	83 c4 18             	add    $0x18,%esp
}
  802231:	c9                   	leave  
  802232:	c3                   	ret    

00802233 <sys_lock_cons>:

void sys_lock_cons(void) {
  802233:	55                   	push   %ebp
  802234:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802236:	6a 00                	push   $0x0
  802238:	6a 00                	push   $0x0
  80223a:	6a 00                	push   $0x0
  80223c:	6a 00                	push   $0x0
  80223e:	6a 00                	push   $0x0
  802240:	6a 03                	push   $0x3
  802242:	e8 7f ff ff ff       	call   8021c6 <syscall>
  802247:	83 c4 18             	add    $0x18,%esp
}
  80224a:	90                   	nop
  80224b:	c9                   	leave  
  80224c:	c3                   	ret    

0080224d <sys_unlock_cons>:
void sys_unlock_cons(void) {
  80224d:	55                   	push   %ebp
  80224e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802250:	6a 00                	push   $0x0
  802252:	6a 00                	push   $0x0
  802254:	6a 00                	push   $0x0
  802256:	6a 00                	push   $0x0
  802258:	6a 00                	push   $0x0
  80225a:	6a 04                	push   $0x4
  80225c:	e8 65 ff ff ff       	call   8021c6 <syscall>
  802261:	83 c4 18             	add    $0x18,%esp
}
  802264:	90                   	nop
  802265:	c9                   	leave  
  802266:	c3                   	ret    

00802267 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  802267:	55                   	push   %ebp
  802268:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  80226a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80226d:	8b 45 08             	mov    0x8(%ebp),%eax
  802270:	6a 00                	push   $0x0
  802272:	6a 00                	push   $0x0
  802274:	6a 00                	push   $0x0
  802276:	52                   	push   %edx
  802277:	50                   	push   %eax
  802278:	6a 08                	push   $0x8
  80227a:	e8 47 ff ff ff       	call   8021c6 <syscall>
  80227f:	83 c4 18             	add    $0x18,%esp
}
  802282:	c9                   	leave  
  802283:	c3                   	ret    

00802284 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  802284:	55                   	push   %ebp
  802285:	89 e5                	mov    %esp,%ebp
  802287:	56                   	push   %esi
  802288:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  802289:	8b 75 18             	mov    0x18(%ebp),%esi
  80228c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80228f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802292:	8b 55 0c             	mov    0xc(%ebp),%edx
  802295:	8b 45 08             	mov    0x8(%ebp),%eax
  802298:	56                   	push   %esi
  802299:	53                   	push   %ebx
  80229a:	51                   	push   %ecx
  80229b:	52                   	push   %edx
  80229c:	50                   	push   %eax
  80229d:	6a 09                	push   $0x9
  80229f:	e8 22 ff ff ff       	call   8021c6 <syscall>
  8022a4:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  8022a7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022aa:	5b                   	pop    %ebx
  8022ab:	5e                   	pop    %esi
  8022ac:	5d                   	pop    %ebp
  8022ad:	c3                   	ret    

008022ae <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  8022ae:	55                   	push   %ebp
  8022af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8022b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b7:	6a 00                	push   $0x0
  8022b9:	6a 00                	push   $0x0
  8022bb:	6a 00                	push   $0x0
  8022bd:	52                   	push   %edx
  8022be:	50                   	push   %eax
  8022bf:	6a 0a                	push   $0xa
  8022c1:	e8 00 ff ff ff       	call   8021c6 <syscall>
  8022c6:	83 c4 18             	add    $0x18,%esp
}
  8022c9:	c9                   	leave  
  8022ca:	c3                   	ret    

008022cb <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  8022cb:	55                   	push   %ebp
  8022cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  8022ce:	6a 00                	push   $0x0
  8022d0:	6a 00                	push   $0x0
  8022d2:	6a 00                	push   $0x0
  8022d4:	ff 75 0c             	pushl  0xc(%ebp)
  8022d7:	ff 75 08             	pushl  0x8(%ebp)
  8022da:	6a 0b                	push   $0xb
  8022dc:	e8 e5 fe ff ff       	call   8021c6 <syscall>
  8022e1:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  8022e4:	c9                   	leave  
  8022e5:	c3                   	ret    

008022e6 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  8022e6:	55                   	push   %ebp
  8022e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8022e9:	6a 00                	push   $0x0
  8022eb:	6a 00                	push   $0x0
  8022ed:	6a 00                	push   $0x0
  8022ef:	6a 00                	push   $0x0
  8022f1:	6a 00                	push   $0x0
  8022f3:	6a 0c                	push   $0xc
  8022f5:	e8 cc fe ff ff       	call   8021c6 <syscall>
  8022fa:	83 c4 18             	add    $0x18,%esp
}
  8022fd:	c9                   	leave  
  8022fe:	c3                   	ret    

008022ff <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  8022ff:	55                   	push   %ebp
  802300:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802302:	6a 00                	push   $0x0
  802304:	6a 00                	push   $0x0
  802306:	6a 00                	push   $0x0
  802308:	6a 00                	push   $0x0
  80230a:	6a 00                	push   $0x0
  80230c:	6a 0d                	push   $0xd
  80230e:	e8 b3 fe ff ff       	call   8021c6 <syscall>
  802313:	83 c4 18             	add    $0x18,%esp
}
  802316:	c9                   	leave  
  802317:	c3                   	ret    

00802318 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  802318:	55                   	push   %ebp
  802319:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80231b:	6a 00                	push   $0x0
  80231d:	6a 00                	push   $0x0
  80231f:	6a 00                	push   $0x0
  802321:	6a 00                	push   $0x0
  802323:	6a 00                	push   $0x0
  802325:	6a 0e                	push   $0xe
  802327:	e8 9a fe ff ff       	call   8021c6 <syscall>
  80232c:	83 c4 18             	add    $0x18,%esp
}
  80232f:	c9                   	leave  
  802330:	c3                   	ret    

00802331 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  802331:	55                   	push   %ebp
  802332:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  802334:	6a 00                	push   $0x0
  802336:	6a 00                	push   $0x0
  802338:	6a 00                	push   $0x0
  80233a:	6a 00                	push   $0x0
  80233c:	6a 00                	push   $0x0
  80233e:	6a 0f                	push   $0xf
  802340:	e8 81 fe ff ff       	call   8021c6 <syscall>
  802345:	83 c4 18             	add    $0x18,%esp
}
  802348:	c9                   	leave  
  802349:	c3                   	ret    

0080234a <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  80234a:	55                   	push   %ebp
  80234b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  80234d:	6a 00                	push   $0x0
  80234f:	6a 00                	push   $0x0
  802351:	6a 00                	push   $0x0
  802353:	6a 00                	push   $0x0
  802355:	ff 75 08             	pushl  0x8(%ebp)
  802358:	6a 10                	push   $0x10
  80235a:	e8 67 fe ff ff       	call   8021c6 <syscall>
  80235f:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  802362:	c9                   	leave  
  802363:	c3                   	ret    

00802364 <sys_scarce_memory>:

void sys_scarce_memory() {
  802364:	55                   	push   %ebp
  802365:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  802367:	6a 00                	push   $0x0
  802369:	6a 00                	push   $0x0
  80236b:	6a 00                	push   $0x0
  80236d:	6a 00                	push   $0x0
  80236f:	6a 00                	push   $0x0
  802371:	6a 11                	push   $0x11
  802373:	e8 4e fe ff ff       	call   8021c6 <syscall>
  802378:	83 c4 18             	add    $0x18,%esp
}
  80237b:	90                   	nop
  80237c:	c9                   	leave  
  80237d:	c3                   	ret    

0080237e <sys_cputc>:

void sys_cputc(const char c) {
  80237e:	55                   	push   %ebp
  80237f:	89 e5                	mov    %esp,%ebp
  802381:	83 ec 04             	sub    $0x4,%esp
  802384:	8b 45 08             	mov    0x8(%ebp),%eax
  802387:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80238a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80238e:	6a 00                	push   $0x0
  802390:	6a 00                	push   $0x0
  802392:	6a 00                	push   $0x0
  802394:	6a 00                	push   $0x0
  802396:	50                   	push   %eax
  802397:	6a 01                	push   $0x1
  802399:	e8 28 fe ff ff       	call   8021c6 <syscall>
  80239e:	83 c4 18             	add    $0x18,%esp
}
  8023a1:	90                   	nop
  8023a2:	c9                   	leave  
  8023a3:	c3                   	ret    

008023a4 <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  8023a4:	55                   	push   %ebp
  8023a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  8023a7:	6a 00                	push   $0x0
  8023a9:	6a 00                	push   $0x0
  8023ab:	6a 00                	push   $0x0
  8023ad:	6a 00                	push   $0x0
  8023af:	6a 00                	push   $0x0
  8023b1:	6a 14                	push   $0x14
  8023b3:	e8 0e fe ff ff       	call   8021c6 <syscall>
  8023b8:	83 c4 18             	add    $0x18,%esp
}
  8023bb:	90                   	nop
  8023bc:	c9                   	leave  
  8023bd:	c3                   	ret    

008023be <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  8023be:	55                   	push   %ebp
  8023bf:	89 e5                	mov    %esp,%ebp
  8023c1:	83 ec 04             	sub    $0x4,%esp
  8023c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8023c7:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  8023ca:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8023cd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8023d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d4:	6a 00                	push   $0x0
  8023d6:	51                   	push   %ecx
  8023d7:	52                   	push   %edx
  8023d8:	ff 75 0c             	pushl  0xc(%ebp)
  8023db:	50                   	push   %eax
  8023dc:	6a 15                	push   $0x15
  8023de:	e8 e3 fd ff ff       	call   8021c6 <syscall>
  8023e3:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  8023e6:	c9                   	leave  
  8023e7:	c3                   	ret    

008023e8 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  8023e8:	55                   	push   %ebp
  8023e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  8023eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f1:	6a 00                	push   $0x0
  8023f3:	6a 00                	push   $0x0
  8023f5:	6a 00                	push   $0x0
  8023f7:	52                   	push   %edx
  8023f8:	50                   	push   %eax
  8023f9:	6a 16                	push   $0x16
  8023fb:	e8 c6 fd ff ff       	call   8021c6 <syscall>
  802400:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  802403:	c9                   	leave  
  802404:	c3                   	ret    

00802405 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  802405:	55                   	push   %ebp
  802406:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  802408:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80240b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80240e:	8b 45 08             	mov    0x8(%ebp),%eax
  802411:	6a 00                	push   $0x0
  802413:	6a 00                	push   $0x0
  802415:	51                   	push   %ecx
  802416:	52                   	push   %edx
  802417:	50                   	push   %eax
  802418:	6a 17                	push   $0x17
  80241a:	e8 a7 fd ff ff       	call   8021c6 <syscall>
  80241f:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  802422:	c9                   	leave  
  802423:	c3                   	ret    

00802424 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  802424:	55                   	push   %ebp
  802425:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  802427:	8b 55 0c             	mov    0xc(%ebp),%edx
  80242a:	8b 45 08             	mov    0x8(%ebp),%eax
  80242d:	6a 00                	push   $0x0
  80242f:	6a 00                	push   $0x0
  802431:	6a 00                	push   $0x0
  802433:	52                   	push   %edx
  802434:	50                   	push   %eax
  802435:	6a 18                	push   $0x18
  802437:	e8 8a fd ff ff       	call   8021c6 <syscall>
  80243c:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  80243f:	c9                   	leave  
  802440:	c3                   	ret    

00802441 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  802441:	55                   	push   %ebp
  802442:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  802444:	8b 45 08             	mov    0x8(%ebp),%eax
  802447:	6a 00                	push   $0x0
  802449:	ff 75 14             	pushl  0x14(%ebp)
  80244c:	ff 75 10             	pushl  0x10(%ebp)
  80244f:	ff 75 0c             	pushl  0xc(%ebp)
  802452:	50                   	push   %eax
  802453:	6a 19                	push   $0x19
  802455:	e8 6c fd ff ff       	call   8021c6 <syscall>
  80245a:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  80245d:	c9                   	leave  
  80245e:	c3                   	ret    

0080245f <sys_run_env>:

void sys_run_env(int32 envId) {
  80245f:	55                   	push   %ebp
  802460:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  802462:	8b 45 08             	mov    0x8(%ebp),%eax
  802465:	6a 00                	push   $0x0
  802467:	6a 00                	push   $0x0
  802469:	6a 00                	push   $0x0
  80246b:	6a 00                	push   $0x0
  80246d:	50                   	push   %eax
  80246e:	6a 1a                	push   $0x1a
  802470:	e8 51 fd ff ff       	call   8021c6 <syscall>
  802475:	83 c4 18             	add    $0x18,%esp
}
  802478:	90                   	nop
  802479:	c9                   	leave  
  80247a:	c3                   	ret    

0080247b <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  80247b:	55                   	push   %ebp
  80247c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80247e:	8b 45 08             	mov    0x8(%ebp),%eax
  802481:	6a 00                	push   $0x0
  802483:	6a 00                	push   $0x0
  802485:	6a 00                	push   $0x0
  802487:	6a 00                	push   $0x0
  802489:	50                   	push   %eax
  80248a:	6a 1b                	push   $0x1b
  80248c:	e8 35 fd ff ff       	call   8021c6 <syscall>
  802491:	83 c4 18             	add    $0x18,%esp
}
  802494:	c9                   	leave  
  802495:	c3                   	ret    

00802496 <sys_getenvid>:

int32 sys_getenvid(void) {
  802496:	55                   	push   %ebp
  802497:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802499:	6a 00                	push   $0x0
  80249b:	6a 00                	push   $0x0
  80249d:	6a 00                	push   $0x0
  80249f:	6a 00                	push   $0x0
  8024a1:	6a 00                	push   $0x0
  8024a3:	6a 05                	push   $0x5
  8024a5:	e8 1c fd ff ff       	call   8021c6 <syscall>
  8024aa:	83 c4 18             	add    $0x18,%esp
}
  8024ad:	c9                   	leave  
  8024ae:	c3                   	ret    

008024af <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  8024af:	55                   	push   %ebp
  8024b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8024b2:	6a 00                	push   $0x0
  8024b4:	6a 00                	push   $0x0
  8024b6:	6a 00                	push   $0x0
  8024b8:	6a 00                	push   $0x0
  8024ba:	6a 00                	push   $0x0
  8024bc:	6a 06                	push   $0x6
  8024be:	e8 03 fd ff ff       	call   8021c6 <syscall>
  8024c3:	83 c4 18             	add    $0x18,%esp
}
  8024c6:	c9                   	leave  
  8024c7:	c3                   	ret    

008024c8 <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  8024c8:	55                   	push   %ebp
  8024c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8024cb:	6a 00                	push   $0x0
  8024cd:	6a 00                	push   $0x0
  8024cf:	6a 00                	push   $0x0
  8024d1:	6a 00                	push   $0x0
  8024d3:	6a 00                	push   $0x0
  8024d5:	6a 07                	push   $0x7
  8024d7:	e8 ea fc ff ff       	call   8021c6 <syscall>
  8024dc:	83 c4 18             	add    $0x18,%esp
}
  8024df:	c9                   	leave  
  8024e0:	c3                   	ret    

008024e1 <sys_exit_env>:

void sys_exit_env(void) {
  8024e1:	55                   	push   %ebp
  8024e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8024e4:	6a 00                	push   $0x0
  8024e6:	6a 00                	push   $0x0
  8024e8:	6a 00                	push   $0x0
  8024ea:	6a 00                	push   $0x0
  8024ec:	6a 00                	push   $0x0
  8024ee:	6a 1c                	push   $0x1c
  8024f0:	e8 d1 fc ff ff       	call   8021c6 <syscall>
  8024f5:	83 c4 18             	add    $0x18,%esp
}
  8024f8:	90                   	nop
  8024f9:	c9                   	leave  
  8024fa:	c3                   	ret    

008024fb <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  8024fb:	55                   	push   %ebp
  8024fc:	89 e5                	mov    %esp,%ebp
  8024fe:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  802501:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802504:	8d 50 04             	lea    0x4(%eax),%edx
  802507:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80250a:	6a 00                	push   $0x0
  80250c:	6a 00                	push   $0x0
  80250e:	6a 00                	push   $0x0
  802510:	52                   	push   %edx
  802511:	50                   	push   %eax
  802512:	6a 1d                	push   $0x1d
  802514:	e8 ad fc ff ff       	call   8021c6 <syscall>
  802519:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  80251c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80251f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802522:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802525:	89 01                	mov    %eax,(%ecx)
  802527:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80252a:	8b 45 08             	mov    0x8(%ebp),%eax
  80252d:	c9                   	leave  
  80252e:	c2 04 00             	ret    $0x4

00802531 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  802531:	55                   	push   %ebp
  802532:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  802534:	6a 00                	push   $0x0
  802536:	6a 00                	push   $0x0
  802538:	ff 75 10             	pushl  0x10(%ebp)
  80253b:	ff 75 0c             	pushl  0xc(%ebp)
  80253e:	ff 75 08             	pushl  0x8(%ebp)
  802541:	6a 13                	push   $0x13
  802543:	e8 7e fc ff ff       	call   8021c6 <syscall>
  802548:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  80254b:	90                   	nop
}
  80254c:	c9                   	leave  
  80254d:	c3                   	ret    

0080254e <sys_rcr2>:
uint32 sys_rcr2() {
  80254e:	55                   	push   %ebp
  80254f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802551:	6a 00                	push   $0x0
  802553:	6a 00                	push   $0x0
  802555:	6a 00                	push   $0x0
  802557:	6a 00                	push   $0x0
  802559:	6a 00                	push   $0x0
  80255b:	6a 1e                	push   $0x1e
  80255d:	e8 64 fc ff ff       	call   8021c6 <syscall>
  802562:	83 c4 18             	add    $0x18,%esp
}
  802565:	c9                   	leave  
  802566:	c3                   	ret    

00802567 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  802567:	55                   	push   %ebp
  802568:	89 e5                	mov    %esp,%ebp
  80256a:	83 ec 04             	sub    $0x4,%esp
  80256d:	8b 45 08             	mov    0x8(%ebp),%eax
  802570:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802573:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802577:	6a 00                	push   $0x0
  802579:	6a 00                	push   $0x0
  80257b:	6a 00                	push   $0x0
  80257d:	6a 00                	push   $0x0
  80257f:	50                   	push   %eax
  802580:	6a 1f                	push   $0x1f
  802582:	e8 3f fc ff ff       	call   8021c6 <syscall>
  802587:	83 c4 18             	add    $0x18,%esp
	return;
  80258a:	90                   	nop
}
  80258b:	c9                   	leave  
  80258c:	c3                   	ret    

0080258d <rsttst>:
void rsttst() {
  80258d:	55                   	push   %ebp
  80258e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802590:	6a 00                	push   $0x0
  802592:	6a 00                	push   $0x0
  802594:	6a 00                	push   $0x0
  802596:	6a 00                	push   $0x0
  802598:	6a 00                	push   $0x0
  80259a:	6a 21                	push   $0x21
  80259c:	e8 25 fc ff ff       	call   8021c6 <syscall>
  8025a1:	83 c4 18             	add    $0x18,%esp
	return;
  8025a4:	90                   	nop
}
  8025a5:	c9                   	leave  
  8025a6:	c3                   	ret    

008025a7 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  8025a7:	55                   	push   %ebp
  8025a8:	89 e5                	mov    %esp,%ebp
  8025aa:	83 ec 04             	sub    $0x4,%esp
  8025ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8025b0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8025b3:	8b 55 18             	mov    0x18(%ebp),%edx
  8025b6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8025ba:	52                   	push   %edx
  8025bb:	50                   	push   %eax
  8025bc:	ff 75 10             	pushl  0x10(%ebp)
  8025bf:	ff 75 0c             	pushl  0xc(%ebp)
  8025c2:	ff 75 08             	pushl  0x8(%ebp)
  8025c5:	6a 20                	push   $0x20
  8025c7:	e8 fa fb ff ff       	call   8021c6 <syscall>
  8025cc:	83 c4 18             	add    $0x18,%esp
	return;
  8025cf:	90                   	nop
}
  8025d0:	c9                   	leave  
  8025d1:	c3                   	ret    

008025d2 <chktst>:
void chktst(uint32 n) {
  8025d2:	55                   	push   %ebp
  8025d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8025d5:	6a 00                	push   $0x0
  8025d7:	6a 00                	push   $0x0
  8025d9:	6a 00                	push   $0x0
  8025db:	6a 00                	push   $0x0
  8025dd:	ff 75 08             	pushl  0x8(%ebp)
  8025e0:	6a 22                	push   $0x22
  8025e2:	e8 df fb ff ff       	call   8021c6 <syscall>
  8025e7:	83 c4 18             	add    $0x18,%esp
	return;
  8025ea:	90                   	nop
}
  8025eb:	c9                   	leave  
  8025ec:	c3                   	ret    

008025ed <inctst>:

void inctst() {
  8025ed:	55                   	push   %ebp
  8025ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8025f0:	6a 00                	push   $0x0
  8025f2:	6a 00                	push   $0x0
  8025f4:	6a 00                	push   $0x0
  8025f6:	6a 00                	push   $0x0
  8025f8:	6a 00                	push   $0x0
  8025fa:	6a 23                	push   $0x23
  8025fc:	e8 c5 fb ff ff       	call   8021c6 <syscall>
  802601:	83 c4 18             	add    $0x18,%esp
	return;
  802604:	90                   	nop
}
  802605:	c9                   	leave  
  802606:	c3                   	ret    

00802607 <gettst>:
uint32 gettst() {
  802607:	55                   	push   %ebp
  802608:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80260a:	6a 00                	push   $0x0
  80260c:	6a 00                	push   $0x0
  80260e:	6a 00                	push   $0x0
  802610:	6a 00                	push   $0x0
  802612:	6a 00                	push   $0x0
  802614:	6a 24                	push   $0x24
  802616:	e8 ab fb ff ff       	call   8021c6 <syscall>
  80261b:	83 c4 18             	add    $0x18,%esp
}
  80261e:	c9                   	leave  
  80261f:	c3                   	ret    

00802620 <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  802620:	55                   	push   %ebp
  802621:	89 e5                	mov    %esp,%ebp
  802623:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802626:	6a 00                	push   $0x0
  802628:	6a 00                	push   $0x0
  80262a:	6a 00                	push   $0x0
  80262c:	6a 00                	push   $0x0
  80262e:	6a 00                	push   $0x0
  802630:	6a 25                	push   $0x25
  802632:	e8 8f fb ff ff       	call   8021c6 <syscall>
  802637:	83 c4 18             	add    $0x18,%esp
  80263a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80263d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802641:	75 07                	jne    80264a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802643:	b8 01 00 00 00       	mov    $0x1,%eax
  802648:	eb 05                	jmp    80264f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80264a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80264f:	c9                   	leave  
  802650:	c3                   	ret    

00802651 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  802651:	55                   	push   %ebp
  802652:	89 e5                	mov    %esp,%ebp
  802654:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802657:	6a 00                	push   $0x0
  802659:	6a 00                	push   $0x0
  80265b:	6a 00                	push   $0x0
  80265d:	6a 00                	push   $0x0
  80265f:	6a 00                	push   $0x0
  802661:	6a 25                	push   $0x25
  802663:	e8 5e fb ff ff       	call   8021c6 <syscall>
  802668:	83 c4 18             	add    $0x18,%esp
  80266b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80266e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802672:	75 07                	jne    80267b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802674:	b8 01 00 00 00       	mov    $0x1,%eax
  802679:	eb 05                	jmp    802680 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80267b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802680:	c9                   	leave  
  802681:	c3                   	ret    

00802682 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  802682:	55                   	push   %ebp
  802683:	89 e5                	mov    %esp,%ebp
  802685:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802688:	6a 00                	push   $0x0
  80268a:	6a 00                	push   $0x0
  80268c:	6a 00                	push   $0x0
  80268e:	6a 00                	push   $0x0
  802690:	6a 00                	push   $0x0
  802692:	6a 25                	push   $0x25
  802694:	e8 2d fb ff ff       	call   8021c6 <syscall>
  802699:	83 c4 18             	add    $0x18,%esp
  80269c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80269f:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8026a3:	75 07                	jne    8026ac <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8026a5:	b8 01 00 00 00       	mov    $0x1,%eax
  8026aa:	eb 05                	jmp    8026b1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8026ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026b1:	c9                   	leave  
  8026b2:	c3                   	ret    

008026b3 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  8026b3:	55                   	push   %ebp
  8026b4:	89 e5                	mov    %esp,%ebp
  8026b6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8026b9:	6a 00                	push   $0x0
  8026bb:	6a 00                	push   $0x0
  8026bd:	6a 00                	push   $0x0
  8026bf:	6a 00                	push   $0x0
  8026c1:	6a 00                	push   $0x0
  8026c3:	6a 25                	push   $0x25
  8026c5:	e8 fc fa ff ff       	call   8021c6 <syscall>
  8026ca:	83 c4 18             	add    $0x18,%esp
  8026cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8026d0:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8026d4:	75 07                	jne    8026dd <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8026d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8026db:	eb 05                	jmp    8026e2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8026dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026e2:	c9                   	leave  
  8026e3:	c3                   	ret    

008026e4 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  8026e4:	55                   	push   %ebp
  8026e5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8026e7:	6a 00                	push   $0x0
  8026e9:	6a 00                	push   $0x0
  8026eb:	6a 00                	push   $0x0
  8026ed:	6a 00                	push   $0x0
  8026ef:	ff 75 08             	pushl  0x8(%ebp)
  8026f2:	6a 26                	push   $0x26
  8026f4:	e8 cd fa ff ff       	call   8021c6 <syscall>
  8026f9:	83 c4 18             	add    $0x18,%esp
	return;
  8026fc:	90                   	nop
}
  8026fd:	c9                   	leave  
  8026fe:	c3                   	ret    

008026ff <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  8026ff:	55                   	push   %ebp
  802700:	89 e5                	mov    %esp,%ebp
  802702:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  802703:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802706:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802709:	8b 55 0c             	mov    0xc(%ebp),%edx
  80270c:	8b 45 08             	mov    0x8(%ebp),%eax
  80270f:	6a 00                	push   $0x0
  802711:	53                   	push   %ebx
  802712:	51                   	push   %ecx
  802713:	52                   	push   %edx
  802714:	50                   	push   %eax
  802715:	6a 27                	push   $0x27
  802717:	e8 aa fa ff ff       	call   8021c6 <syscall>
  80271c:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  80271f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802722:	c9                   	leave  
  802723:	c3                   	ret    

00802724 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  802724:	55                   	push   %ebp
  802725:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  802727:	8b 55 0c             	mov    0xc(%ebp),%edx
  80272a:	8b 45 08             	mov    0x8(%ebp),%eax
  80272d:	6a 00                	push   $0x0
  80272f:	6a 00                	push   $0x0
  802731:	6a 00                	push   $0x0
  802733:	52                   	push   %edx
  802734:	50                   	push   %eax
  802735:	6a 28                	push   $0x28
  802737:	e8 8a fa ff ff       	call   8021c6 <syscall>
  80273c:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  80273f:	c9                   	leave  
  802740:	c3                   	ret    

00802741 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  802741:	55                   	push   %ebp
  802742:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  802744:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802747:	8b 55 0c             	mov    0xc(%ebp),%edx
  80274a:	8b 45 08             	mov    0x8(%ebp),%eax
  80274d:	6a 00                	push   $0x0
  80274f:	51                   	push   %ecx
  802750:	ff 75 10             	pushl  0x10(%ebp)
  802753:	52                   	push   %edx
  802754:	50                   	push   %eax
  802755:	6a 29                	push   $0x29
  802757:	e8 6a fa ff ff       	call   8021c6 <syscall>
  80275c:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  80275f:	c9                   	leave  
  802760:	c3                   	ret    

00802761 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  802761:	55                   	push   %ebp
  802762:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802764:	6a 00                	push   $0x0
  802766:	6a 00                	push   $0x0
  802768:	ff 75 10             	pushl  0x10(%ebp)
  80276b:	ff 75 0c             	pushl  0xc(%ebp)
  80276e:	ff 75 08             	pushl  0x8(%ebp)
  802771:	6a 12                	push   $0x12
  802773:	e8 4e fa ff ff       	call   8021c6 <syscall>
  802778:	83 c4 18             	add    $0x18,%esp
	return;
  80277b:	90                   	nop
}
  80277c:	c9                   	leave  
  80277d:	c3                   	ret    

0080277e <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  80277e:	55                   	push   %ebp
  80277f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  802781:	8b 55 0c             	mov    0xc(%ebp),%edx
  802784:	8b 45 08             	mov    0x8(%ebp),%eax
  802787:	6a 00                	push   $0x0
  802789:	6a 00                	push   $0x0
  80278b:	6a 00                	push   $0x0
  80278d:	52                   	push   %edx
  80278e:	50                   	push   %eax
  80278f:	6a 2a                	push   $0x2a
  802791:	e8 30 fa ff ff       	call   8021c6 <syscall>
  802796:	83 c4 18             	add    $0x18,%esp
	return;
  802799:	90                   	nop
}
  80279a:	c9                   	leave  
  80279b:	c3                   	ret    

0080279c <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  80279c:	55                   	push   %ebp
  80279d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  80279f:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a2:	6a 00                	push   $0x0
  8027a4:	6a 00                	push   $0x0
  8027a6:	6a 00                	push   $0x0
  8027a8:	6a 00                	push   $0x0
  8027aa:	50                   	push   %eax
  8027ab:	6a 2b                	push   $0x2b
  8027ad:	e8 14 fa ff ff       	call   8021c6 <syscall>
  8027b2:	83 c4 18             	add    $0x18,%esp
}
  8027b5:	c9                   	leave  
  8027b6:	c3                   	ret    

008027b7 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  8027b7:	55                   	push   %ebp
  8027b8:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8027ba:	6a 00                	push   $0x0
  8027bc:	6a 00                	push   $0x0
  8027be:	6a 00                	push   $0x0
  8027c0:	ff 75 0c             	pushl  0xc(%ebp)
  8027c3:	ff 75 08             	pushl  0x8(%ebp)
  8027c6:	6a 2c                	push   $0x2c
  8027c8:	e8 f9 f9 ff ff       	call   8021c6 <syscall>
  8027cd:	83 c4 18             	add    $0x18,%esp
	return;
  8027d0:	90                   	nop
}
  8027d1:	c9                   	leave  
  8027d2:	c3                   	ret    

008027d3 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  8027d3:	55                   	push   %ebp
  8027d4:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8027d6:	6a 00                	push   $0x0
  8027d8:	6a 00                	push   $0x0
  8027da:	6a 00                	push   $0x0
  8027dc:	ff 75 0c             	pushl  0xc(%ebp)
  8027df:	ff 75 08             	pushl  0x8(%ebp)
  8027e2:	6a 2d                	push   $0x2d
  8027e4:	e8 dd f9 ff ff       	call   8021c6 <syscall>
  8027e9:	83 c4 18             	add    $0x18,%esp
	return;
  8027ec:	90                   	nop
}
  8027ed:	c9                   	leave  
  8027ee:	c3                   	ret    

008027ef <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  8027ef:	55                   	push   %ebp
  8027f0:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  8027f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f5:	6a 00                	push   $0x0
  8027f7:	6a 00                	push   $0x0
  8027f9:	6a 00                	push   $0x0
  8027fb:	6a 00                	push   $0x0
  8027fd:	50                   	push   %eax
  8027fe:	6a 2f                	push   $0x2f
  802800:	e8 c1 f9 ff ff       	call   8021c6 <syscall>
  802805:	83 c4 18             	add    $0x18,%esp
	return;
  802808:	90                   	nop
}
  802809:	c9                   	leave  
  80280a:	c3                   	ret    

0080280b <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  80280b:	55                   	push   %ebp
  80280c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  80280e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802811:	8b 45 08             	mov    0x8(%ebp),%eax
  802814:	6a 00                	push   $0x0
  802816:	6a 00                	push   $0x0
  802818:	6a 00                	push   $0x0
  80281a:	52                   	push   %edx
  80281b:	50                   	push   %eax
  80281c:	6a 30                	push   $0x30
  80281e:	e8 a3 f9 ff ff       	call   8021c6 <syscall>
  802823:	83 c4 18             	add    $0x18,%esp
	return;
  802826:	90                   	nop
}
  802827:	c9                   	leave  
  802828:	c3                   	ret    

00802829 <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  802829:	55                   	push   %ebp
  80282a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  80282c:	8b 45 08             	mov    0x8(%ebp),%eax
  80282f:	6a 00                	push   $0x0
  802831:	6a 00                	push   $0x0
  802833:	6a 00                	push   $0x0
  802835:	6a 00                	push   $0x0
  802837:	50                   	push   %eax
  802838:	6a 31                	push   $0x31
  80283a:	e8 87 f9 ff ff       	call   8021c6 <syscall>
  80283f:	83 c4 18             	add    $0x18,%esp
	return;
  802842:	90                   	nop
}
  802843:	c9                   	leave  
  802844:	c3                   	ret    

00802845 <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  802845:	55                   	push   %ebp
  802846:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  802848:	8b 55 0c             	mov    0xc(%ebp),%edx
  80284b:	8b 45 08             	mov    0x8(%ebp),%eax
  80284e:	6a 00                	push   $0x0
  802850:	6a 00                	push   $0x0
  802852:	6a 00                	push   $0x0
  802854:	52                   	push   %edx
  802855:	50                   	push   %eax
  802856:	6a 2e                	push   $0x2e
  802858:	e8 69 f9 ff ff       	call   8021c6 <syscall>
  80285d:	83 c4 18             	add    $0x18,%esp
    return;
  802860:	90                   	nop
}
  802861:	c9                   	leave  
  802862:	c3                   	ret    

00802863 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802863:	55                   	push   %ebp
  802864:	89 e5                	mov    %esp,%ebp
  802866:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802869:	8b 45 08             	mov    0x8(%ebp),%eax
  80286c:	83 e8 04             	sub    $0x4,%eax
  80286f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802872:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802875:	8b 00                	mov    (%eax),%eax
  802877:	83 e0 fe             	and    $0xfffffffe,%eax
}
  80287a:	c9                   	leave  
  80287b:	c3                   	ret    

0080287c <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  80287c:	55                   	push   %ebp
  80287d:	89 e5                	mov    %esp,%ebp
  80287f:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802882:	8b 45 08             	mov    0x8(%ebp),%eax
  802885:	83 e8 04             	sub    $0x4,%eax
  802888:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  80288b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80288e:	8b 00                	mov    (%eax),%eax
  802890:	83 e0 01             	and    $0x1,%eax
  802893:	85 c0                	test   %eax,%eax
  802895:	0f 94 c0             	sete   %al
}
  802898:	c9                   	leave  
  802899:	c3                   	ret    

0080289a <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  80289a:	55                   	push   %ebp
  80289b:	89 e5                	mov    %esp,%ebp
  80289d:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8028a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8028a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028aa:	83 f8 02             	cmp    $0x2,%eax
  8028ad:	74 2b                	je     8028da <alloc_block+0x40>
  8028af:	83 f8 02             	cmp    $0x2,%eax
  8028b2:	7f 07                	jg     8028bb <alloc_block+0x21>
  8028b4:	83 f8 01             	cmp    $0x1,%eax
  8028b7:	74 0e                	je     8028c7 <alloc_block+0x2d>
  8028b9:	eb 58                	jmp    802913 <alloc_block+0x79>
  8028bb:	83 f8 03             	cmp    $0x3,%eax
  8028be:	74 2d                	je     8028ed <alloc_block+0x53>
  8028c0:	83 f8 04             	cmp    $0x4,%eax
  8028c3:	74 3b                	je     802900 <alloc_block+0x66>
  8028c5:	eb 4c                	jmp    802913 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8028c7:	83 ec 0c             	sub    $0xc,%esp
  8028ca:	ff 75 08             	pushl  0x8(%ebp)
  8028cd:	e8 f7 03 00 00       	call   802cc9 <alloc_block_FF>
  8028d2:	83 c4 10             	add    $0x10,%esp
  8028d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8028d8:	eb 4a                	jmp    802924 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8028da:	83 ec 0c             	sub    $0xc,%esp
  8028dd:	ff 75 08             	pushl  0x8(%ebp)
  8028e0:	e8 f0 11 00 00       	call   803ad5 <alloc_block_NF>
  8028e5:	83 c4 10             	add    $0x10,%esp
  8028e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8028eb:	eb 37                	jmp    802924 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8028ed:	83 ec 0c             	sub    $0xc,%esp
  8028f0:	ff 75 08             	pushl  0x8(%ebp)
  8028f3:	e8 08 08 00 00       	call   803100 <alloc_block_BF>
  8028f8:	83 c4 10             	add    $0x10,%esp
  8028fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8028fe:	eb 24                	jmp    802924 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802900:	83 ec 0c             	sub    $0xc,%esp
  802903:	ff 75 08             	pushl  0x8(%ebp)
  802906:	e8 ad 11 00 00       	call   803ab8 <alloc_block_WF>
  80290b:	83 c4 10             	add    $0x10,%esp
  80290e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802911:	eb 11                	jmp    802924 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802913:	83 ec 0c             	sub    $0xc,%esp
  802916:	68 8c 45 80 00       	push   $0x80458c
  80291b:	e8 39 e2 ff ff       	call   800b59 <cprintf>
  802920:	83 c4 10             	add    $0x10,%esp
		break;
  802923:	90                   	nop
	}
	return va;
  802924:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802927:	c9                   	leave  
  802928:	c3                   	ret    

00802929 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802929:	55                   	push   %ebp
  80292a:	89 e5                	mov    %esp,%ebp
  80292c:	53                   	push   %ebx
  80292d:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802930:	83 ec 0c             	sub    $0xc,%esp
  802933:	68 ac 45 80 00       	push   $0x8045ac
  802938:	e8 1c e2 ff ff       	call   800b59 <cprintf>
  80293d:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802940:	83 ec 0c             	sub    $0xc,%esp
  802943:	68 d7 45 80 00       	push   $0x8045d7
  802948:	e8 0c e2 ff ff       	call   800b59 <cprintf>
  80294d:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802950:	8b 45 08             	mov    0x8(%ebp),%eax
  802953:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802956:	eb 37                	jmp    80298f <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802958:	83 ec 0c             	sub    $0xc,%esp
  80295b:	ff 75 f4             	pushl  -0xc(%ebp)
  80295e:	e8 19 ff ff ff       	call   80287c <is_free_block>
  802963:	83 c4 10             	add    $0x10,%esp
  802966:	0f be d8             	movsbl %al,%ebx
  802969:	83 ec 0c             	sub    $0xc,%esp
  80296c:	ff 75 f4             	pushl  -0xc(%ebp)
  80296f:	e8 ef fe ff ff       	call   802863 <get_block_size>
  802974:	83 c4 10             	add    $0x10,%esp
  802977:	83 ec 04             	sub    $0x4,%esp
  80297a:	53                   	push   %ebx
  80297b:	50                   	push   %eax
  80297c:	68 ef 45 80 00       	push   $0x8045ef
  802981:	e8 d3 e1 ff ff       	call   800b59 <cprintf>
  802986:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802989:	8b 45 10             	mov    0x10(%ebp),%eax
  80298c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80298f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802993:	74 07                	je     80299c <print_blocks_list+0x73>
  802995:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802998:	8b 00                	mov    (%eax),%eax
  80299a:	eb 05                	jmp    8029a1 <print_blocks_list+0x78>
  80299c:	b8 00 00 00 00       	mov    $0x0,%eax
  8029a1:	89 45 10             	mov    %eax,0x10(%ebp)
  8029a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8029a7:	85 c0                	test   %eax,%eax
  8029a9:	75 ad                	jne    802958 <print_blocks_list+0x2f>
  8029ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029af:	75 a7                	jne    802958 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8029b1:	83 ec 0c             	sub    $0xc,%esp
  8029b4:	68 ac 45 80 00       	push   $0x8045ac
  8029b9:	e8 9b e1 ff ff       	call   800b59 <cprintf>
  8029be:	83 c4 10             	add    $0x10,%esp

}
  8029c1:	90                   	nop
  8029c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8029c5:	c9                   	leave  
  8029c6:	c3                   	ret    

008029c7 <initialize_dynamic_allocator>:

//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8029c7:	55                   	push   %ebp
  8029c8:	89 e5                	mov    %esp,%ebp
  8029ca:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8029cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029d0:	83 e0 01             	and    $0x1,%eax
  8029d3:	85 c0                	test   %eax,%eax
  8029d5:	74 03                	je     8029da <initialize_dynamic_allocator+0x13>
  8029d7:	ff 45 0c             	incl   0xc(%ebp)
		if (initSizeOfAllocatedSpace == 0)
  8029da:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8029de:	0f 84 f8 00 00 00    	je     802adc <initialize_dynamic_allocator+0x115>
			return ;
		is_initialized = 1;
  8029e4:	c7 05 40 50 98 00 01 	movl   $0x1,0x985040
  8029eb:	00 00 00 
	//TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("initialize_dynamic_allocator is not implemented yet");
	//Your Code is Here...

	if(is_initialized){
  8029ee:	a1 40 50 98 00       	mov    0x985040,%eax
  8029f3:	85 c0                	test   %eax,%eax
  8029f5:	0f 84 e2 00 00 00    	je     802add <initialize_dynamic_allocator+0x116>

		// begin block with size 0 and lsb = 1 (allocated)
		uint32* beginBlock = (uint32*)daStart;
  8029fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
		*beginBlock = 0 | 1; // size = 0, LSB as a flag = 1
  802a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a04:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		// end block with size 0 and lsb = 1 (allocated)
		uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);
  802a0a:	8b 55 08             	mov    0x8(%ebp),%edx
  802a0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a10:	01 d0                	add    %edx,%eax
  802a12:	83 e8 04             	sub    $0x4,%eax
  802a15:	89 45 f0             	mov    %eax,-0x10(%ebp)
		*endBlock = 0 | 1; // size = 0, LSB as a flag = 1
  802a18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a1b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

		// the block that between begin and end blocks
		struct BlockElement* block = (struct BlockElement*)(daStart + 8);
  802a21:	8b 45 08             	mov    0x8(%ebp),%eax
  802a24:	83 c0 08             	add    $0x8,%eax
  802a27:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 blockSize = initSizeOfAllocatedSpace - 8; // subtract size of begin and end blocks
  802a2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a2d:	83 e8 08             	sub    $0x8,%eax
  802a30:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(block,blockSize,0);
  802a33:	83 ec 04             	sub    $0x4,%esp
  802a36:	6a 00                	push   $0x0
  802a38:	ff 75 e8             	pushl  -0x18(%ebp)
  802a3b:	ff 75 ec             	pushl  -0x14(%ebp)
  802a3e:	e8 9c 00 00 00       	call   802adf <set_block_data>
  802a43:	83 c4 10             	add    $0x10,%esp

		block->prev_next_info.le_next = NULL;
  802a46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a49:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block->prev_next_info.le_prev = NULL;
  802a4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a52:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

		LIST_INIT(&freeBlocksList);
  802a59:	c7 05 48 50 98 00 00 	movl   $0x0,0x985048
  802a60:	00 00 00 
  802a63:	c7 05 4c 50 98 00 00 	movl   $0x0,0x98504c
  802a6a:	00 00 00 
  802a6d:	c7 05 54 50 98 00 00 	movl   $0x0,0x985054
  802a74:	00 00 00 
		LIST_INSERT_HEAD(&freeBlocksList, block);
  802a77:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a7b:	75 17                	jne    802a94 <initialize_dynamic_allocator+0xcd>
  802a7d:	83 ec 04             	sub    $0x4,%esp
  802a80:	68 08 46 80 00       	push   $0x804608
  802a85:	68 80 00 00 00       	push   $0x80
  802a8a:	68 2b 46 80 00       	push   $0x80462b
  802a8f:	e8 08 de ff ff       	call   80089c <_panic>
  802a94:	8b 15 48 50 98 00    	mov    0x985048,%edx
  802a9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a9d:	89 10                	mov    %edx,(%eax)
  802a9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aa2:	8b 00                	mov    (%eax),%eax
  802aa4:	85 c0                	test   %eax,%eax
  802aa6:	74 0d                	je     802ab5 <initialize_dynamic_allocator+0xee>
  802aa8:	a1 48 50 98 00       	mov    0x985048,%eax
  802aad:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ab0:	89 50 04             	mov    %edx,0x4(%eax)
  802ab3:	eb 08                	jmp    802abd <initialize_dynamic_allocator+0xf6>
  802ab5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ab8:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802abd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac0:	a3 48 50 98 00       	mov    %eax,0x985048
  802ac5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802acf:	a1 54 50 98 00       	mov    0x985054,%eax
  802ad4:	40                   	inc    %eax
  802ad5:	a3 54 50 98 00       	mov    %eax,0x985054
  802ada:	eb 01                	jmp    802add <initialize_dynamic_allocator+0x116>
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
		if (initSizeOfAllocatedSpace == 0)
			return ;
  802adc:	90                   	nop
		block->prev_next_info.le_prev = NULL;

		LIST_INIT(&freeBlocksList);
		LIST_INSERT_HEAD(&freeBlocksList, block);
	}
}
  802add:	c9                   	leave  
  802ade:	c3                   	ret    

00802adf <set_block_data>:
//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802adf:	55                   	push   %ebp
  802ae0:	89 e5                	mov    %esp,%ebp
  802ae2:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("set_block_data is not implemented yet");
	//Your Code is Here...

	if(totalSize % 2 != 0)
  802ae5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ae8:	83 e0 01             	and    $0x1,%eax
  802aeb:	85 c0                	test   %eax,%eax
  802aed:	74 03                	je     802af2 <set_block_data+0x13>
	{
		totalSize++;
  802aef:	ff 45 0c             	incl   0xc(%ebp)
	}

	uint32* header = (uint32 *)((uint32*)va-1);
  802af2:	8b 45 08             	mov    0x8(%ebp),%eax
  802af5:	83 e8 04             	sub    $0x4,%eax
  802af8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//	size => totalSize with LSB = 0		 set LSB = 1 if isAllocated
	*header = (totalSize & ~1) | (isAllocated & 1);
  802afb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802afe:	83 e0 fe             	and    $0xfffffffe,%eax
  802b01:	89 c2                	mov    %eax,%edx
  802b03:	8b 45 10             	mov    0x10(%ebp),%eax
  802b06:	83 e0 01             	and    $0x1,%eax
  802b09:	09 c2                	or     %eax,%edx
  802b0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b0e:	89 10                	mov    %edx,(%eax)
	uint32* footer = (uint32*) (va + totalSize - 8);
  802b10:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b13:	8d 50 f8             	lea    -0x8(%eax),%edx
  802b16:	8b 45 08             	mov    0x8(%ebp),%eax
  802b19:	01 d0                	add    %edx,%eax
  802b1b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	*footer = (totalSize & ~1) | (isAllocated & 1);
  802b1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b21:	83 e0 fe             	and    $0xfffffffe,%eax
  802b24:	89 c2                	mov    %eax,%edx
  802b26:	8b 45 10             	mov    0x10(%ebp),%eax
  802b29:	83 e0 01             	and    $0x1,%eax
  802b2c:	09 c2                	or     %eax,%edx
  802b2e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802b31:	89 10                	mov    %edx,(%eax)
}
  802b33:	90                   	nop
  802b34:	c9                   	leave  
  802b35:	c3                   	ret    

00802b36 <insert_sorted_in_freeList>:
//=========================================
void insert_sorted_in_freeList(struct BlockElement *newBlock)
{
  802b36:	55                   	push   %ebp
  802b37:	89 e5                	mov    %esp,%ebp
  802b39:	83 ec 18             	sub    $0x18,%esp
	if(LIST_EMPTY(&freeBlocksList))
  802b3c:	a1 48 50 98 00       	mov    0x985048,%eax
  802b41:	85 c0                	test   %eax,%eax
  802b43:	75 68                	jne    802bad <insert_sorted_in_freeList+0x77>
	{
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
  802b45:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b49:	75 17                	jne    802b62 <insert_sorted_in_freeList+0x2c>
  802b4b:	83 ec 04             	sub    $0x4,%esp
  802b4e:	68 08 46 80 00       	push   $0x804608
  802b53:	68 9d 00 00 00       	push   $0x9d
  802b58:	68 2b 46 80 00       	push   $0x80462b
  802b5d:	e8 3a dd ff ff       	call   80089c <_panic>
  802b62:	8b 15 48 50 98 00    	mov    0x985048,%edx
  802b68:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6b:	89 10                	mov    %edx,(%eax)
  802b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b70:	8b 00                	mov    (%eax),%eax
  802b72:	85 c0                	test   %eax,%eax
  802b74:	74 0d                	je     802b83 <insert_sorted_in_freeList+0x4d>
  802b76:	a1 48 50 98 00       	mov    0x985048,%eax
  802b7b:	8b 55 08             	mov    0x8(%ebp),%edx
  802b7e:	89 50 04             	mov    %edx,0x4(%eax)
  802b81:	eb 08                	jmp    802b8b <insert_sorted_in_freeList+0x55>
  802b83:	8b 45 08             	mov    0x8(%ebp),%eax
  802b86:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8e:	a3 48 50 98 00       	mov    %eax,0x985048
  802b93:	8b 45 08             	mov    0x8(%ebp),%eax
  802b96:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b9d:	a1 54 50 98 00       	mov    0x985054,%eax
  802ba2:	40                   	inc    %eax
  802ba3:	a3 54 50 98 00       	mov    %eax,0x985054
		return;
  802ba8:	e9 1a 01 00 00       	jmp    802cc7 <insert_sorted_in_freeList+0x191>
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  802bad:	a1 48 50 98 00       	mov    0x985048,%eax
  802bb2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bb5:	eb 7f                	jmp    802c36 <insert_sorted_in_freeList+0x100>
	{
		if(blk > newBlock) // if address of blk > address of newBlock => add newBlock before blk
  802bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bba:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bbd:	76 6f                	jbe    802c2e <insert_sorted_in_freeList+0xf8>
		{
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
  802bbf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bc3:	74 06                	je     802bcb <insert_sorted_in_freeList+0x95>
  802bc5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bc9:	75 17                	jne    802be2 <insert_sorted_in_freeList+0xac>
  802bcb:	83 ec 04             	sub    $0x4,%esp
  802bce:	68 44 46 80 00       	push   $0x804644
  802bd3:	68 a6 00 00 00       	push   $0xa6
  802bd8:	68 2b 46 80 00       	push   $0x80462b
  802bdd:	e8 ba dc ff ff       	call   80089c <_panic>
  802be2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be5:	8b 50 04             	mov    0x4(%eax),%edx
  802be8:	8b 45 08             	mov    0x8(%ebp),%eax
  802beb:	89 50 04             	mov    %edx,0x4(%eax)
  802bee:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bf4:	89 10                	mov    %edx,(%eax)
  802bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf9:	8b 40 04             	mov    0x4(%eax),%eax
  802bfc:	85 c0                	test   %eax,%eax
  802bfe:	74 0d                	je     802c0d <insert_sorted_in_freeList+0xd7>
  802c00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c03:	8b 40 04             	mov    0x4(%eax),%eax
  802c06:	8b 55 08             	mov    0x8(%ebp),%edx
  802c09:	89 10                	mov    %edx,(%eax)
  802c0b:	eb 08                	jmp    802c15 <insert_sorted_in_freeList+0xdf>
  802c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c10:	a3 48 50 98 00       	mov    %eax,0x985048
  802c15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c18:	8b 55 08             	mov    0x8(%ebp),%edx
  802c1b:	89 50 04             	mov    %edx,0x4(%eax)
  802c1e:	a1 54 50 98 00       	mov    0x985054,%eax
  802c23:	40                   	inc    %eax
  802c24:	a3 54 50 98 00       	mov    %eax,0x985054
			return;
  802c29:	e9 99 00 00 00       	jmp    802cc7 <insert_sorted_in_freeList+0x191>
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
		return;
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  802c2e:	a1 50 50 98 00       	mov    0x985050,%eax
  802c33:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c36:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c3a:	74 07                	je     802c43 <insert_sorted_in_freeList+0x10d>
  802c3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3f:	8b 00                	mov    (%eax),%eax
  802c41:	eb 05                	jmp    802c48 <insert_sorted_in_freeList+0x112>
  802c43:	b8 00 00 00 00       	mov    $0x0,%eax
  802c48:	a3 50 50 98 00       	mov    %eax,0x985050
  802c4d:	a1 50 50 98 00       	mov    0x985050,%eax
  802c52:	85 c0                	test   %eax,%eax
  802c54:	0f 85 5d ff ff ff    	jne    802bb7 <insert_sorted_in_freeList+0x81>
  802c5a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c5e:	0f 85 53 ff ff ff    	jne    802bb7 <insert_sorted_in_freeList+0x81>
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
			return;
		}
	}
	// if no blk its address > newBlock
	LIST_INSERT_TAIL(&freeBlocksList, newBlock);
  802c64:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c68:	75 17                	jne    802c81 <insert_sorted_in_freeList+0x14b>
  802c6a:	83 ec 04             	sub    $0x4,%esp
  802c6d:	68 7c 46 80 00       	push   $0x80467c
  802c72:	68 ab 00 00 00       	push   $0xab
  802c77:	68 2b 46 80 00       	push   $0x80462b
  802c7c:	e8 1b dc ff ff       	call   80089c <_panic>
  802c81:	8b 15 4c 50 98 00    	mov    0x98504c,%edx
  802c87:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8a:	89 50 04             	mov    %edx,0x4(%eax)
  802c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c90:	8b 40 04             	mov    0x4(%eax),%eax
  802c93:	85 c0                	test   %eax,%eax
  802c95:	74 0c                	je     802ca3 <insert_sorted_in_freeList+0x16d>
  802c97:	a1 4c 50 98 00       	mov    0x98504c,%eax
  802c9c:	8b 55 08             	mov    0x8(%ebp),%edx
  802c9f:	89 10                	mov    %edx,(%eax)
  802ca1:	eb 08                	jmp    802cab <insert_sorted_in_freeList+0x175>
  802ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca6:	a3 48 50 98 00       	mov    %eax,0x985048
  802cab:	8b 45 08             	mov    0x8(%ebp),%eax
  802cae:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cbc:	a1 54 50 98 00       	mov    0x985054,%eax
  802cc1:	40                   	inc    %eax
  802cc2:	a3 54 50 98 00       	mov    %eax,0x985054
}
  802cc7:	c9                   	leave  
  802cc8:	c3                   	ret    

00802cc9 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  802cc9:	55                   	push   %ebp
  802cca:	89 e5                	mov    %esp,%ebp
  802ccc:	83 ec 78             	sub    $0x78,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd2:	83 e0 01             	and    $0x1,%eax
  802cd5:	85 c0                	test   %eax,%eax
  802cd7:	74 03                	je     802cdc <alloc_block_FF+0x13>
  802cd9:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802cdc:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802ce0:	77 07                	ja     802ce9 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802ce2:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802ce9:	a1 40 50 98 00       	mov    0x985040,%eax
  802cee:	85 c0                	test   %eax,%eax
  802cf0:	75 63                	jne    802d55 <alloc_block_FF+0x8c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf5:	83 c0 10             	add    $0x10,%eax
  802cf8:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802cfb:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802d02:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d08:	01 d0                	add    %edx,%eax
  802d0a:	48                   	dec    %eax
  802d0b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802d0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d11:	ba 00 00 00 00       	mov    $0x0,%edx
  802d16:	f7 75 ec             	divl   -0x14(%ebp)
  802d19:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d1c:	29 d0                	sub    %edx,%eax
  802d1e:	c1 e8 0c             	shr    $0xc,%eax
  802d21:	83 ec 0c             	sub    $0xc,%esp
  802d24:	50                   	push   %eax
  802d25:	e8 d1 ed ff ff       	call   801afb <sbrk>
  802d2a:	83 c4 10             	add    $0x10,%esp
  802d2d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802d30:	83 ec 0c             	sub    $0xc,%esp
  802d33:	6a 00                	push   $0x0
  802d35:	e8 c1 ed ff ff       	call   801afb <sbrk>
  802d3a:	83 c4 10             	add    $0x10,%esp
  802d3d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802d40:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d43:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802d46:	83 ec 08             	sub    $0x8,%esp
  802d49:	50                   	push   %eax
  802d4a:	ff 75 e4             	pushl  -0x1c(%ebp)
  802d4d:	e8 75 fc ff ff       	call   8029c7 <initialize_dynamic_allocator>
  802d52:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(size == 0)
  802d55:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d59:	75 0a                	jne    802d65 <alloc_block_FF+0x9c>
	{
		return NULL;
  802d5b:	b8 00 00 00 00       	mov    $0x0,%eax
  802d60:	e9 99 03 00 00       	jmp    8030fe <alloc_block_FF+0x435>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  802d65:	8b 45 08             	mov    0x8(%ebp),%eax
  802d68:	83 c0 08             	add    $0x8,%eax
  802d6b:	89 45 dc             	mov    %eax,-0x24(%ebp)

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802d6e:	a1 48 50 98 00       	mov    0x985048,%eax
  802d73:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d76:	e9 03 02 00 00       	jmp    802f7e <alloc_block_FF+0x2b5>
	{
		uint32 blockSize = get_block_size(block); // Get size without the (LSB) allocation flag
  802d7b:	83 ec 0c             	sub    $0xc,%esp
  802d7e:	ff 75 f4             	pushl  -0xc(%ebp)
  802d81:	e8 dd fa ff ff       	call   802863 <get_block_size>
  802d86:	83 c4 10             	add    $0x10,%esp
  802d89:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if(blockSize >= totalSize)
  802d8c:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802d8f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802d92:	0f 82 de 01 00 00    	jb     802f76 <alloc_block_FF+0x2ad>
		{	//if we can put another block with min size 16
			if(blockSize >= totalSize + 4*sizeof(uint32))
  802d98:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d9b:	83 c0 10             	add    $0x10,%eax
  802d9e:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  802da1:	0f 87 32 01 00 00    	ja     802ed9 <alloc_block_FF+0x210>
			{
				// the size that will remain from the block that we will allocate a new block in it
				uint32 remainingSize = blockSize - totalSize;
  802da7:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802daa:	2b 45 dc             	sub    -0x24(%ebp),%eax
  802dad:	89 45 98             	mov    %eax,-0x68(%ebp)

				// the remaining free space from the block that we use to allocate in it
				struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)block + totalSize);
  802db0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802db3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802db6:	01 d0                	add    %edx,%eax
  802db8:	89 45 94             	mov    %eax,-0x6c(%ebp)
				set_block_data(remainingFreeBlock, remainingSize, 0);
  802dbb:	83 ec 04             	sub    $0x4,%esp
  802dbe:	6a 00                	push   $0x0
  802dc0:	ff 75 98             	pushl  -0x68(%ebp)
  802dc3:	ff 75 94             	pushl  -0x6c(%ebp)
  802dc6:	e8 14 fd ff ff       	call   802adf <set_block_data>
  802dcb:	83 c4 10             	add    $0x10,%esp
				// add it after the block we allocated to be sorted by addresses
				LIST_INSERT_AFTER(&freeBlocksList, block,remainingFreeBlock);
  802dce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dd2:	74 06                	je     802dda <alloc_block_FF+0x111>
  802dd4:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
  802dd8:	75 17                	jne    802df1 <alloc_block_FF+0x128>
  802dda:	83 ec 04             	sub    $0x4,%esp
  802ddd:	68 a0 46 80 00       	push   $0x8046a0
  802de2:	68 de 00 00 00       	push   $0xde
  802de7:	68 2b 46 80 00       	push   $0x80462b
  802dec:	e8 ab da ff ff       	call   80089c <_panic>
  802df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df4:	8b 10                	mov    (%eax),%edx
  802df6:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802df9:	89 10                	mov    %edx,(%eax)
  802dfb:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802dfe:	8b 00                	mov    (%eax),%eax
  802e00:	85 c0                	test   %eax,%eax
  802e02:	74 0b                	je     802e0f <alloc_block_FF+0x146>
  802e04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e07:	8b 00                	mov    (%eax),%eax
  802e09:	8b 55 94             	mov    -0x6c(%ebp),%edx
  802e0c:	89 50 04             	mov    %edx,0x4(%eax)
  802e0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e12:	8b 55 94             	mov    -0x6c(%ebp),%edx
  802e15:	89 10                	mov    %edx,(%eax)
  802e17:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802e1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e1d:	89 50 04             	mov    %edx,0x4(%eax)
  802e20:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802e23:	8b 00                	mov    (%eax),%eax
  802e25:	85 c0                	test   %eax,%eax
  802e27:	75 08                	jne    802e31 <alloc_block_FF+0x168>
  802e29:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802e2c:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802e31:	a1 54 50 98 00       	mov    0x985054,%eax
  802e36:	40                   	inc    %eax
  802e37:	a3 54 50 98 00       	mov    %eax,0x985054

				// update the allocated block and remove it from freeBlocksList
				set_block_data(block,totalSize,1);
  802e3c:	83 ec 04             	sub    $0x4,%esp
  802e3f:	6a 01                	push   $0x1
  802e41:	ff 75 dc             	pushl  -0x24(%ebp)
  802e44:	ff 75 f4             	pushl  -0xc(%ebp)
  802e47:	e8 93 fc ff ff       	call   802adf <set_block_data>
  802e4c:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  802e4f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e53:	75 17                	jne    802e6c <alloc_block_FF+0x1a3>
  802e55:	83 ec 04             	sub    $0x4,%esp
  802e58:	68 d4 46 80 00       	push   $0x8046d4
  802e5d:	68 e3 00 00 00       	push   $0xe3
  802e62:	68 2b 46 80 00       	push   $0x80462b
  802e67:	e8 30 da ff ff       	call   80089c <_panic>
  802e6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6f:	8b 00                	mov    (%eax),%eax
  802e71:	85 c0                	test   %eax,%eax
  802e73:	74 10                	je     802e85 <alloc_block_FF+0x1bc>
  802e75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e78:	8b 00                	mov    (%eax),%eax
  802e7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e7d:	8b 52 04             	mov    0x4(%edx),%edx
  802e80:	89 50 04             	mov    %edx,0x4(%eax)
  802e83:	eb 0b                	jmp    802e90 <alloc_block_FF+0x1c7>
  802e85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e88:	8b 40 04             	mov    0x4(%eax),%eax
  802e8b:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802e90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e93:	8b 40 04             	mov    0x4(%eax),%eax
  802e96:	85 c0                	test   %eax,%eax
  802e98:	74 0f                	je     802ea9 <alloc_block_FF+0x1e0>
  802e9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9d:	8b 40 04             	mov    0x4(%eax),%eax
  802ea0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ea3:	8b 12                	mov    (%edx),%edx
  802ea5:	89 10                	mov    %edx,(%eax)
  802ea7:	eb 0a                	jmp    802eb3 <alloc_block_FF+0x1ea>
  802ea9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eac:	8b 00                	mov    (%eax),%eax
  802eae:	a3 48 50 98 00       	mov    %eax,0x985048
  802eb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ebc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ec6:	a1 54 50 98 00       	mov    0x985054,%eax
  802ecb:	48                   	dec    %eax
  802ecc:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  802ed1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed4:	e9 25 02 00 00       	jmp    8030fe <alloc_block_FF+0x435>
			}
			else // if set internal fragmentation
			{
				// add the remaining size to the block we allocate so it will be the same main block size
				set_block_data(block,blockSize,1);
  802ed9:	83 ec 04             	sub    $0x4,%esp
  802edc:	6a 01                	push   $0x1
  802ede:	ff 75 9c             	pushl  -0x64(%ebp)
  802ee1:	ff 75 f4             	pushl  -0xc(%ebp)
  802ee4:	e8 f6 fb ff ff       	call   802adf <set_block_data>
  802ee9:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  802eec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ef0:	75 17                	jne    802f09 <alloc_block_FF+0x240>
  802ef2:	83 ec 04             	sub    $0x4,%esp
  802ef5:	68 d4 46 80 00       	push   $0x8046d4
  802efa:	68 eb 00 00 00       	push   $0xeb
  802eff:	68 2b 46 80 00       	push   $0x80462b
  802f04:	e8 93 d9 ff ff       	call   80089c <_panic>
  802f09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0c:	8b 00                	mov    (%eax),%eax
  802f0e:	85 c0                	test   %eax,%eax
  802f10:	74 10                	je     802f22 <alloc_block_FF+0x259>
  802f12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f15:	8b 00                	mov    (%eax),%eax
  802f17:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f1a:	8b 52 04             	mov    0x4(%edx),%edx
  802f1d:	89 50 04             	mov    %edx,0x4(%eax)
  802f20:	eb 0b                	jmp    802f2d <alloc_block_FF+0x264>
  802f22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f25:	8b 40 04             	mov    0x4(%eax),%eax
  802f28:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802f2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f30:	8b 40 04             	mov    0x4(%eax),%eax
  802f33:	85 c0                	test   %eax,%eax
  802f35:	74 0f                	je     802f46 <alloc_block_FF+0x27d>
  802f37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3a:	8b 40 04             	mov    0x4(%eax),%eax
  802f3d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f40:	8b 12                	mov    (%edx),%edx
  802f42:	89 10                	mov    %edx,(%eax)
  802f44:	eb 0a                	jmp    802f50 <alloc_block_FF+0x287>
  802f46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f49:	8b 00                	mov    (%eax),%eax
  802f4b:	a3 48 50 98 00       	mov    %eax,0x985048
  802f50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f53:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f63:	a1 54 50 98 00       	mov    0x985054,%eax
  802f68:	48                   	dec    %eax
  802f69:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  802f6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f71:	e9 88 01 00 00       	jmp    8030fe <alloc_block_FF+0x435>
		return NULL;
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802f76:	a1 50 50 98 00       	mov    0x985050,%eax
  802f7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f7e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f82:	74 07                	je     802f8b <alloc_block_FF+0x2c2>
  802f84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f87:	8b 00                	mov    (%eax),%eax
  802f89:	eb 05                	jmp    802f90 <alloc_block_FF+0x2c7>
  802f8b:	b8 00 00 00 00       	mov    $0x0,%eax
  802f90:	a3 50 50 98 00       	mov    %eax,0x985050
  802f95:	a1 50 50 98 00       	mov    0x985050,%eax
  802f9a:	85 c0                	test   %eax,%eax
  802f9c:	0f 85 d9 fd ff ff    	jne    802d7b <alloc_block_FF+0xb2>
  802fa2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fa6:	0f 85 cf fd ff ff    	jne    802d7b <alloc_block_FF+0xb2>

//	uint32 *endBlock = &kheapBreak;

	// if we don't find any enough space to allocate the block

	void *oldBreak = sbrk(ROUNDUP(totalSize, PAGE_SIZE) / PAGE_SIZE);
  802fac:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802fb3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802fb6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802fb9:	01 d0                	add    %edx,%eax
  802fbb:	48                   	dec    %eax
  802fbc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802fbf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802fc2:	ba 00 00 00 00       	mov    $0x0,%edx
  802fc7:	f7 75 d8             	divl   -0x28(%ebp)
  802fca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802fcd:	29 d0                	sub    %edx,%eax
  802fcf:	c1 e8 0c             	shr    $0xc,%eax
  802fd2:	83 ec 0c             	sub    $0xc,%esp
  802fd5:	50                   	push   %eax
  802fd6:	e8 20 eb ff ff       	call   801afb <sbrk>
  802fdb:	83 c4 10             	add    $0x10,%esp
  802fde:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (oldBreak == (void*)-1) {
  802fe1:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802fe5:	75 0a                	jne    802ff1 <alloc_block_FF+0x328>
		return NULL;
  802fe7:	b8 00 00 00 00       	mov    $0x0,%eax
  802fec:	e9 0d 01 00 00       	jmp    8030fe <alloc_block_FF+0x435>
	}
	//uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);

	uint32* endBlk = (uint32 *)((char *)oldBreak - 4);
  802ff1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802ff4:	83 e8 04             	sub    $0x4,%eax
  802ff7:	89 45 cc             	mov    %eax,-0x34(%ebp)
	//endBlk = endBlk+(char *) ROUNDUP(totalSize, PAGE_SIZE);

	endBlk = endBlk + (ROUNDUP(totalSize, PAGE_SIZE) / sizeof(uint32));
  802ffa:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  803001:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803004:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803007:	01 d0                	add    %edx,%eax
  803009:	48                   	dec    %eax
  80300a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80300d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803010:	ba 00 00 00 00       	mov    $0x0,%edx
  803015:	f7 75 c8             	divl   -0x38(%ebp)
  803018:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80301b:	29 d0                	sub    %edx,%eax
  80301d:	c1 e8 02             	shr    $0x2,%eax
  803020:	c1 e0 02             	shl    $0x2,%eax
  803023:	01 45 cc             	add    %eax,-0x34(%ebp)
	*endBlk = 0 | 1;
  803026:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803029:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	uint32 *footerLast = ((uint32*)oldBreak - 2);
  80302f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803032:	83 e8 08             	sub    $0x8,%eax
  803035:	89 45 c0             	mov    %eax,-0x40(%ebp)
	uint32 lastSize = (*footerLast) & ~(0x1);
  803038:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80303b:	8b 00                	mov    (%eax),%eax
  80303d:	83 e0 fe             	and    $0xfffffffe,%eax
  803040:	89 45 bc             	mov    %eax,-0x44(%ebp)
	// the last block for the block that we want to free it
	struct BlockElement *laskBlk = (struct BlockElement *)((char*)oldBreak - lastSize);
  803043:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803046:	f7 d8                	neg    %eax
  803048:	89 c2                	mov    %eax,%edx
  80304a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80304d:	01 d0                	add    %edx,%eax
  80304f:	89 45 b8             	mov    %eax,-0x48(%ebp)
	uint32 isLastFree = is_free_block(laskBlk);
  803052:	83 ec 0c             	sub    $0xc,%esp
  803055:	ff 75 b8             	pushl  -0x48(%ebp)
  803058:	e8 1f f8 ff ff       	call   80287c <is_free_block>
  80305d:	83 c4 10             	add    $0x10,%esp
  803060:	0f be c0             	movsbl %al,%eax
  803063:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(isLastFree)
  803066:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  80306a:	74 42                	je     8030ae <alloc_block_FF+0x3e5>
	{
		// merge the block will be free with its prev block
		uint32 newBlkSize = lastSize + ROUNDUP(totalSize, PAGE_SIZE); // size of main block and its prev block
  80306c:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  803073:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803076:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803079:	01 d0                	add    %edx,%eax
  80307b:	48                   	dec    %eax
  80307c:	89 45 ac             	mov    %eax,-0x54(%ebp)
  80307f:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803082:	ba 00 00 00 00       	mov    $0x0,%edx
  803087:	f7 75 b0             	divl   -0x50(%ebp)
  80308a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80308d:	29 d0                	sub    %edx,%eax
  80308f:	89 c2                	mov    %eax,%edx
  803091:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803094:	01 d0                	add    %edx,%eax
  803096:	89 45 a8             	mov    %eax,-0x58(%ebp)
		// extends last block size to contain its size and the size of new space
		set_block_data(laskBlk,newBlkSize,0);
  803099:	83 ec 04             	sub    $0x4,%esp
  80309c:	6a 00                	push   $0x0
  80309e:	ff 75 a8             	pushl  -0x58(%ebp)
  8030a1:	ff 75 b8             	pushl  -0x48(%ebp)
  8030a4:	e8 36 fa ff ff       	call   802adf <set_block_data>
  8030a9:	83 c4 10             	add    $0x10,%esp
  8030ac:	eb 42                	jmp    8030f0 <alloc_block_FF+0x427>
	}
	else
	{
		set_block_data(oldBreak,ROUNDUP(totalSize, PAGE_SIZE),0);
  8030ae:	c7 45 a4 00 10 00 00 	movl   $0x1000,-0x5c(%ebp)
  8030b5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030b8:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8030bb:	01 d0                	add    %edx,%eax
  8030bd:	48                   	dec    %eax
  8030be:	89 45 a0             	mov    %eax,-0x60(%ebp)
  8030c1:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8030c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8030c9:	f7 75 a4             	divl   -0x5c(%ebp)
  8030cc:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8030cf:	29 d0                	sub    %edx,%eax
  8030d1:	83 ec 04             	sub    $0x4,%esp
  8030d4:	6a 00                	push   $0x0
  8030d6:	50                   	push   %eax
  8030d7:	ff 75 d0             	pushl  -0x30(%ebp)
  8030da:	e8 00 fa ff ff       	call   802adf <set_block_data>
  8030df:	83 c4 10             	add    $0x10,%esp
		insert_sorted_in_freeList((struct BlockElement *)oldBreak);
  8030e2:	83 ec 0c             	sub    $0xc,%esp
  8030e5:	ff 75 d0             	pushl  -0x30(%ebp)
  8030e8:	e8 49 fa ff ff       	call   802b36 <insert_sorted_in_freeList>
  8030ed:	83 c4 10             	add    $0x10,%esp
//		LIST_INSERT_TAIL(&freeBlocksList,newBreak);
	}
//	set_block_data((struct BlockElement *)newBreak, totalSize, 1);
	return alloc_block_FF(size);
  8030f0:	83 ec 0c             	sub    $0xc,%esp
  8030f3:	ff 75 08             	pushl  0x8(%ebp)
  8030f6:	e8 ce fb ff ff       	call   802cc9 <alloc_block_FF>
  8030fb:	83 c4 10             	add    $0x10,%esp
}
  8030fe:	c9                   	leave  
  8030ff:	c3                   	ret    

00803100 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  803100:	55                   	push   %ebp
  803101:	89 e5                	mov    %esp,%ebp
  803103:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS1 - BONUS] [3] DYNAMIC ALLOCATOR - alloc_block_BF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_BF is not implemented yet");
	//Your Code is Here...
	if(size == 0)
  803106:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80310a:	75 0a                	jne    803116 <alloc_block_BF+0x16>
	{
		return NULL;
  80310c:	b8 00 00 00 00       	mov    $0x0,%eax
  803111:	e9 7a 02 00 00       	jmp    803390 <alloc_block_BF+0x290>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  803116:	8b 45 08             	mov    0x8(%ebp),%eax
  803119:	83 c0 08             	add    $0x8,%eax
  80311c:	89 45 e8             	mov    %eax,-0x18(%ebp)

	struct BlockElement *minBlk= NULL;
  80311f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 minSize = 0xfffffff; // a large number
  803126:	c7 45 f0 ff ff ff 0f 	movl   $0xfffffff,-0x10(%ebp)
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  80312d:	a1 48 50 98 00       	mov    0x985048,%eax
  803132:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803135:	eb 32                	jmp    803169 <alloc_block_BF+0x69>
	{
		uint32 blockSize = get_block_size(block);
  803137:	ff 75 ec             	pushl  -0x14(%ebp)
  80313a:	e8 24 f7 ff ff       	call   802863 <get_block_size>
  80313f:	83 c4 04             	add    $0x4,%esp
  803142:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		// if this block can take the new block and its size < min size of all blocks
		if(blockSize >= totalSize && blockSize < minSize)
  803145:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803148:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80314b:	72 14                	jb     803161 <alloc_block_BF+0x61>
  80314d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803150:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803153:	73 0c                	jae    803161 <alloc_block_BF+0x61>
		{
			minBlk = block;
  803155:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803158:	89 45 f4             	mov    %eax,-0xc(%ebp)
			minSize = blockSize;
  80315b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80315e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *minBlk= NULL;
	uint32 minSize = 0xfffffff; // a large number
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  803161:	a1 50 50 98 00       	mov    0x985050,%eax
  803166:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803169:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80316d:	74 07                	je     803176 <alloc_block_BF+0x76>
  80316f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803172:	8b 00                	mov    (%eax),%eax
  803174:	eb 05                	jmp    80317b <alloc_block_BF+0x7b>
  803176:	b8 00 00 00 00       	mov    $0x0,%eax
  80317b:	a3 50 50 98 00       	mov    %eax,0x985050
  803180:	a1 50 50 98 00       	mov    0x985050,%eax
  803185:	85 c0                	test   %eax,%eax
  803187:	75 ae                	jne    803137 <alloc_block_BF+0x37>
  803189:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80318d:	75 a8                	jne    803137 <alloc_block_BF+0x37>
			minSize = blockSize;
		}
	}

	// if we don't find any enough space to allocate the block
	if(minBlk == NULL)
  80318f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803193:	75 22                	jne    8031b7 <alloc_block_BF+0xb7>
	{
		void *newBlock = sbrk(totalSize);
  803195:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803198:	83 ec 0c             	sub    $0xc,%esp
  80319b:	50                   	push   %eax
  80319c:	e8 5a e9 ff ff       	call   801afb <sbrk>
  8031a1:	83 c4 10             	add    $0x10,%esp
  8031a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (newBlock == (void*)-1) {
  8031a7:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8031ab:	75 0a                	jne    8031b7 <alloc_block_BF+0xb7>
			return NULL;
  8031ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8031b2:	e9 d9 01 00 00       	jmp    803390 <alloc_block_BF+0x290>
		}
	}

	//if we can put another block with min size 16
	if(minSize >= totalSize + 4*sizeof(uint32))
  8031b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ba:	83 c0 10             	add    $0x10,%eax
  8031bd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8031c0:	0f 87 32 01 00 00    	ja     8032f8 <alloc_block_BF+0x1f8>
	{
		// the size that will remain from the block that we will allocate a new block in it
		uint32 remainingSize= minSize - totalSize;
  8031c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c9:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8031cc:	89 45 dc             	mov    %eax,-0x24(%ebp)

		// the remaining free space from the block that we use to allocate in it
		struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)minBlk + totalSize);
  8031cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d5:	01 d0                	add    %edx,%eax
  8031d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
		set_block_data(remainingFreeBlock, remainingSize, 0);
  8031da:	83 ec 04             	sub    $0x4,%esp
  8031dd:	6a 00                	push   $0x0
  8031df:	ff 75 dc             	pushl  -0x24(%ebp)
  8031e2:	ff 75 d8             	pushl  -0x28(%ebp)
  8031e5:	e8 f5 f8 ff ff       	call   802adf <set_block_data>
  8031ea:	83 c4 10             	add    $0x10,%esp
		// add it after the block we allocated to be sorted by addresses
		LIST_INSERT_AFTER(&freeBlocksList, minBlk,remainingFreeBlock);
  8031ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031f1:	74 06                	je     8031f9 <alloc_block_BF+0xf9>
  8031f3:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8031f7:	75 17                	jne    803210 <alloc_block_BF+0x110>
  8031f9:	83 ec 04             	sub    $0x4,%esp
  8031fc:	68 a0 46 80 00       	push   $0x8046a0
  803201:	68 49 01 00 00       	push   $0x149
  803206:	68 2b 46 80 00       	push   $0x80462b
  80320b:	e8 8c d6 ff ff       	call   80089c <_panic>
  803210:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803213:	8b 10                	mov    (%eax),%edx
  803215:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803218:	89 10                	mov    %edx,(%eax)
  80321a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80321d:	8b 00                	mov    (%eax),%eax
  80321f:	85 c0                	test   %eax,%eax
  803221:	74 0b                	je     80322e <alloc_block_BF+0x12e>
  803223:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803226:	8b 00                	mov    (%eax),%eax
  803228:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80322b:	89 50 04             	mov    %edx,0x4(%eax)
  80322e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803231:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803234:	89 10                	mov    %edx,(%eax)
  803236:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803239:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80323c:	89 50 04             	mov    %edx,0x4(%eax)
  80323f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803242:	8b 00                	mov    (%eax),%eax
  803244:	85 c0                	test   %eax,%eax
  803246:	75 08                	jne    803250 <alloc_block_BF+0x150>
  803248:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80324b:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803250:	a1 54 50 98 00       	mov    0x985054,%eax
  803255:	40                   	inc    %eax
  803256:	a3 54 50 98 00       	mov    %eax,0x985054

		// update the allocated block and remove it from freeBlocksList
		set_block_data(minBlk,totalSize,1);
  80325b:	83 ec 04             	sub    $0x4,%esp
  80325e:	6a 01                	push   $0x1
  803260:	ff 75 e8             	pushl  -0x18(%ebp)
  803263:	ff 75 f4             	pushl  -0xc(%ebp)
  803266:	e8 74 f8 ff ff       	call   802adf <set_block_data>
  80326b:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  80326e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803272:	75 17                	jne    80328b <alloc_block_BF+0x18b>
  803274:	83 ec 04             	sub    $0x4,%esp
  803277:	68 d4 46 80 00       	push   $0x8046d4
  80327c:	68 4e 01 00 00       	push   $0x14e
  803281:	68 2b 46 80 00       	push   $0x80462b
  803286:	e8 11 d6 ff ff       	call   80089c <_panic>
  80328b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328e:	8b 00                	mov    (%eax),%eax
  803290:	85 c0                	test   %eax,%eax
  803292:	74 10                	je     8032a4 <alloc_block_BF+0x1a4>
  803294:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803297:	8b 00                	mov    (%eax),%eax
  803299:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80329c:	8b 52 04             	mov    0x4(%edx),%edx
  80329f:	89 50 04             	mov    %edx,0x4(%eax)
  8032a2:	eb 0b                	jmp    8032af <alloc_block_BF+0x1af>
  8032a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a7:	8b 40 04             	mov    0x4(%eax),%eax
  8032aa:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8032af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b2:	8b 40 04             	mov    0x4(%eax),%eax
  8032b5:	85 c0                	test   %eax,%eax
  8032b7:	74 0f                	je     8032c8 <alloc_block_BF+0x1c8>
  8032b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032bc:	8b 40 04             	mov    0x4(%eax),%eax
  8032bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032c2:	8b 12                	mov    (%edx),%edx
  8032c4:	89 10                	mov    %edx,(%eax)
  8032c6:	eb 0a                	jmp    8032d2 <alloc_block_BF+0x1d2>
  8032c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032cb:	8b 00                	mov    (%eax),%eax
  8032cd:	a3 48 50 98 00       	mov    %eax,0x985048
  8032d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032de:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032e5:	a1 54 50 98 00       	mov    0x985054,%eax
  8032ea:	48                   	dec    %eax
  8032eb:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  8032f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f3:	e9 98 00 00 00       	jmp    803390 <alloc_block_BF+0x290>
	}
	else // if set internal fragmentation
	{
		// add the remaining size to the block we allocate so it will be the same main block size
		set_block_data(minBlk,minSize,1);
  8032f8:	83 ec 04             	sub    $0x4,%esp
  8032fb:	6a 01                	push   $0x1
  8032fd:	ff 75 f0             	pushl  -0x10(%ebp)
  803300:	ff 75 f4             	pushl  -0xc(%ebp)
  803303:	e8 d7 f7 ff ff       	call   802adf <set_block_data>
  803308:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  80330b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80330f:	75 17                	jne    803328 <alloc_block_BF+0x228>
  803311:	83 ec 04             	sub    $0x4,%esp
  803314:	68 d4 46 80 00       	push   $0x8046d4
  803319:	68 56 01 00 00       	push   $0x156
  80331e:	68 2b 46 80 00       	push   $0x80462b
  803323:	e8 74 d5 ff ff       	call   80089c <_panic>
  803328:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80332b:	8b 00                	mov    (%eax),%eax
  80332d:	85 c0                	test   %eax,%eax
  80332f:	74 10                	je     803341 <alloc_block_BF+0x241>
  803331:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803334:	8b 00                	mov    (%eax),%eax
  803336:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803339:	8b 52 04             	mov    0x4(%edx),%edx
  80333c:	89 50 04             	mov    %edx,0x4(%eax)
  80333f:	eb 0b                	jmp    80334c <alloc_block_BF+0x24c>
  803341:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803344:	8b 40 04             	mov    0x4(%eax),%eax
  803347:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80334c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80334f:	8b 40 04             	mov    0x4(%eax),%eax
  803352:	85 c0                	test   %eax,%eax
  803354:	74 0f                	je     803365 <alloc_block_BF+0x265>
  803356:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803359:	8b 40 04             	mov    0x4(%eax),%eax
  80335c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80335f:	8b 12                	mov    (%edx),%edx
  803361:	89 10                	mov    %edx,(%eax)
  803363:	eb 0a                	jmp    80336f <alloc_block_BF+0x26f>
  803365:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803368:	8b 00                	mov    (%eax),%eax
  80336a:	a3 48 50 98 00       	mov    %eax,0x985048
  80336f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803372:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803378:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80337b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803382:	a1 54 50 98 00       	mov    0x985054,%eax
  803387:	48                   	dec    %eax
  803388:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  80338d:	8b 45 f4             	mov    -0xc(%ebp),%eax
	}
	return NULL;
}
  803390:	c9                   	leave  
  803391:	c3                   	ret    

00803392 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803392:	55                   	push   %ebp
  803393:	89 e5                	mov    %esp,%ebp
  803395:	83 ec 48             	sub    $0x48,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
  803398:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80339c:	0f 84 6a 02 00 00    	je     80360c <free_block+0x27a>
	{
		return;
	}

	uint32 freeSize = get_block_size(va);
  8033a2:	ff 75 08             	pushl  0x8(%ebp)
  8033a5:	e8 b9 f4 ff ff       	call   802863 <get_block_size>
  8033aa:	83 c4 04             	add    $0x4,%esp
  8033ad:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// footer for the prev block for the block that we want to free it
	uint32 *footerPrev = ((uint32*)va - 2 );
  8033b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b3:	83 e8 08             	sub    $0x8,%eax
  8033b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 pSize = (*footerPrev) & ~(0x1);
  8033b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033bc:	8b 00                	mov    (%eax),%eax
  8033be:	83 e0 fe             	and    $0xfffffffe,%eax
  8033c1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// the prev block for the block that we want to free it
	struct BlockElement * prevBlk = (struct BlockElement *)((char*)va - pSize);
  8033c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033c7:	f7 d8                	neg    %eax
  8033c9:	89 c2                	mov    %eax,%edx
  8033cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ce:	01 d0                	add    %edx,%eax
  8033d0:	89 45 e8             	mov    %eax,-0x18(%ebp)
	uint32 isPrevFree = is_free_block(prevBlk);
  8033d3:	ff 75 e8             	pushl  -0x18(%ebp)
  8033d6:	e8 a1 f4 ff ff       	call   80287c <is_free_block>
  8033db:	83 c4 04             	add    $0x4,%esp
  8033de:	0f be c0             	movsbl %al,%eax
  8033e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
  8033e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8033e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ea:	01 d0                	add    %edx,%eax
  8033ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  8033ef:	ff 75 e0             	pushl  -0x20(%ebp)
  8033f2:	e8 85 f4 ff ff       	call   80287c <is_free_block>
  8033f7:	83 c4 04             	add    $0x4,%esp
  8033fa:	0f be c0             	movsbl %al,%eax
  8033fd:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if(isPrevFree == 1 && isNextFree == 0)
  803400:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  803404:	75 34                	jne    80343a <free_block+0xa8>
  803406:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80340a:	75 2e                	jne    80343a <free_block+0xa8>
	{
		// merge the block will be free with its prev block
		uint32 prevSize = get_block_size(prevBlk);
  80340c:	ff 75 e8             	pushl  -0x18(%ebp)
  80340f:	e8 4f f4 ff ff       	call   802863 <get_block_size>
  803414:	83 c4 04             	add    $0x4,%esp
  803417:	89 45 d8             	mov    %eax,-0x28(%ebp)
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
  80341a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80341d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803420:	01 d0                	add    %edx,%eax
  803422:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
  803425:	6a 00                	push   $0x0
  803427:	ff 75 d4             	pushl  -0x2c(%ebp)
  80342a:	ff 75 e8             	pushl  -0x18(%ebp)
  80342d:	e8 ad f6 ff ff       	call   802adf <set_block_data>
  803432:	83 c4 0c             	add    $0xc,%esp
	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
	uint32 isNextFree = is_free_block(nextBlk);

	if(isPrevFree == 1 && isNextFree == 0)
	{
  803435:	e9 d3 01 00 00       	jmp    80360d <free_block+0x27b>
		uint32 prevSize = get_block_size(prevBlk);
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
  80343a:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  80343e:	0f 85 c8 00 00 00    	jne    80350c <free_block+0x17a>
  803444:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803448:	0f 85 be 00 00 00    	jne    80350c <free_block+0x17a>
	{
		// merge the block will be free with its next block
		uint32 nextSize = get_block_size(nextBlk);
  80344e:	ff 75 e0             	pushl  -0x20(%ebp)
  803451:	e8 0d f4 ff ff       	call   802863 <get_block_size>
  803456:	83 c4 04             	add    $0x4,%esp
  803459:	89 45 d0             	mov    %eax,-0x30(%ebp)
		uint32 totalSize = freeSize + nextSize; // size of main block and its next block
  80345c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80345f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803462:	01 d0                	add    %edx,%eax
  803464:	89 45 cc             	mov    %eax,-0x34(%ebp)
		// update the size of block to contain its size and the size of next block
		set_block_data(va,totalSize,0);
  803467:	6a 00                	push   $0x0
  803469:	ff 75 cc             	pushl  -0x34(%ebp)
  80346c:	ff 75 08             	pushl  0x8(%ebp)
  80346f:	e8 6b f6 ff ff       	call   802adf <set_block_data>
  803474:	83 c4 0c             	add    $0xc,%esp
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
  803477:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80347b:	75 17                	jne    803494 <free_block+0x102>
  80347d:	83 ec 04             	sub    $0x4,%esp
  803480:	68 d4 46 80 00       	push   $0x8046d4
  803485:	68 87 01 00 00       	push   $0x187
  80348a:	68 2b 46 80 00       	push   $0x80462b
  80348f:	e8 08 d4 ff ff       	call   80089c <_panic>
  803494:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803497:	8b 00                	mov    (%eax),%eax
  803499:	85 c0                	test   %eax,%eax
  80349b:	74 10                	je     8034ad <free_block+0x11b>
  80349d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034a0:	8b 00                	mov    (%eax),%eax
  8034a2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8034a5:	8b 52 04             	mov    0x4(%edx),%edx
  8034a8:	89 50 04             	mov    %edx,0x4(%eax)
  8034ab:	eb 0b                	jmp    8034b8 <free_block+0x126>
  8034ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034b0:	8b 40 04             	mov    0x4(%eax),%eax
  8034b3:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8034b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034bb:	8b 40 04             	mov    0x4(%eax),%eax
  8034be:	85 c0                	test   %eax,%eax
  8034c0:	74 0f                	je     8034d1 <free_block+0x13f>
  8034c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034c5:	8b 40 04             	mov    0x4(%eax),%eax
  8034c8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8034cb:	8b 12                	mov    (%edx),%edx
  8034cd:	89 10                	mov    %edx,(%eax)
  8034cf:	eb 0a                	jmp    8034db <free_block+0x149>
  8034d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034d4:	8b 00                	mov    (%eax),%eax
  8034d6:	a3 48 50 98 00       	mov    %eax,0x985048
  8034db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034ee:	a1 54 50 98 00       	mov    0x985054,%eax
  8034f3:	48                   	dec    %eax
  8034f4:	a3 54 50 98 00       	mov    %eax,0x985054
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  8034f9:	83 ec 0c             	sub    $0xc,%esp
  8034fc:	ff 75 08             	pushl  0x8(%ebp)
  8034ff:	e8 32 f6 ff ff       	call   802b36 <insert_sorted_in_freeList>
  803504:	83 c4 10             	add    $0x10,%esp
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
	{
  803507:	e9 01 01 00 00       	jmp    80360d <free_block+0x27b>
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
  80350c:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  803510:	0f 85 d3 00 00 00    	jne    8035e9 <free_block+0x257>
  803516:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  80351a:	0f 85 c9 00 00 00    	jne    8035e9 <free_block+0x257>
	{
		// merge the block will be free with its prev and next blocks
		uint32 prevSize = get_block_size(prevBlk);
  803520:	83 ec 0c             	sub    $0xc,%esp
  803523:	ff 75 e8             	pushl  -0x18(%ebp)
  803526:	e8 38 f3 ff ff       	call   802863 <get_block_size>
  80352b:	83 c4 10             	add    $0x10,%esp
  80352e:	89 45 c8             	mov    %eax,-0x38(%ebp)
		uint32 nextSize = get_block_size(nextBlk);
  803531:	83 ec 0c             	sub    $0xc,%esp
  803534:	ff 75 e0             	pushl  -0x20(%ebp)
  803537:	e8 27 f3 ff ff       	call   802863 <get_block_size>
  80353c:	83 c4 10             	add    $0x10,%esp
  80353f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 totalSize = freeSize + prevSize + nextSize; // size of main block and its prev and next blocks
  803542:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803545:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803548:	01 c2                	add    %eax,%edx
  80354a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80354d:	01 d0                	add    %edx,%eax
  80354f:	89 45 c0             	mov    %eax,-0x40(%ebp)
		// extends prev block size to contain its size and the size of main and next blocks
		set_block_data(prevBlk,totalSize,0);
  803552:	83 ec 04             	sub    $0x4,%esp
  803555:	6a 00                	push   $0x0
  803557:	ff 75 c0             	pushl  -0x40(%ebp)
  80355a:	ff 75 e8             	pushl  -0x18(%ebp)
  80355d:	e8 7d f5 ff ff       	call   802adf <set_block_data>
  803562:	83 c4 10             	add    $0x10,%esp
		// remove next block because we merge it with its prev blocks
		LIST_REMOVE(&freeBlocksList, nextBlk);
  803565:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803569:	75 17                	jne    803582 <free_block+0x1f0>
  80356b:	83 ec 04             	sub    $0x4,%esp
  80356e:	68 d4 46 80 00       	push   $0x8046d4
  803573:	68 94 01 00 00       	push   $0x194
  803578:	68 2b 46 80 00       	push   $0x80462b
  80357d:	e8 1a d3 ff ff       	call   80089c <_panic>
  803582:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803585:	8b 00                	mov    (%eax),%eax
  803587:	85 c0                	test   %eax,%eax
  803589:	74 10                	je     80359b <free_block+0x209>
  80358b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80358e:	8b 00                	mov    (%eax),%eax
  803590:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803593:	8b 52 04             	mov    0x4(%edx),%edx
  803596:	89 50 04             	mov    %edx,0x4(%eax)
  803599:	eb 0b                	jmp    8035a6 <free_block+0x214>
  80359b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80359e:	8b 40 04             	mov    0x4(%eax),%eax
  8035a1:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8035a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035a9:	8b 40 04             	mov    0x4(%eax),%eax
  8035ac:	85 c0                	test   %eax,%eax
  8035ae:	74 0f                	je     8035bf <free_block+0x22d>
  8035b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035b3:	8b 40 04             	mov    0x4(%eax),%eax
  8035b6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8035b9:	8b 12                	mov    (%edx),%edx
  8035bb:	89 10                	mov    %edx,(%eax)
  8035bd:	eb 0a                	jmp    8035c9 <free_block+0x237>
  8035bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035c2:	8b 00                	mov    (%eax),%eax
  8035c4:	a3 48 50 98 00       	mov    %eax,0x985048
  8035c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035d5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035dc:	a1 54 50 98 00       	mov    0x985054,%eax
  8035e1:	48                   	dec    %eax
  8035e2:	a3 54 50 98 00       	mov    %eax,0x985054
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
	{
  8035e7:	eb 24                	jmp    80360d <free_block+0x27b>
	}
	else
	{
		// free it without any merge
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
  8035e9:	83 ec 04             	sub    $0x4,%esp
  8035ec:	6a 00                	push   $0x0
  8035ee:	ff 75 f4             	pushl  -0xc(%ebp)
  8035f1:	ff 75 08             	pushl  0x8(%ebp)
  8035f4:	e8 e6 f4 ff ff       	call   802adf <set_block_data>
  8035f9:	83 c4 10             	add    $0x10,%esp
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  8035fc:	83 ec 0c             	sub    $0xc,%esp
  8035ff:	ff 75 08             	pushl  0x8(%ebp)
  803602:	e8 2f f5 ff ff       	call   802b36 <insert_sorted_in_freeList>
  803607:	83 c4 10             	add    $0x10,%esp
  80360a:	eb 01                	jmp    80360d <free_block+0x27b>
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
	{
		return;
  80360c:	90                   	nop
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
}
  80360d:	c9                   	leave  
  80360e:	c3                   	ret    

0080360f <realloc_block_FF>:
//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
  80360f:	55                   	push   %ebp
  803610:	89 e5                	mov    %esp,%ebp
  803612:	83 ec 38             	sub    $0x38,%esp
	//TODO: [PROJECT'24.MS1 - #08] [3] DYNAMIC ALLOCATOR - realloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(va == NULL && new_size == 0)
  803615:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803619:	75 10                	jne    80362b <realloc_block_FF+0x1c>
  80361b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80361f:	75 0a                	jne    80362b <realloc_block_FF+0x1c>
	{
		return NULL;
  803621:	b8 00 00 00 00       	mov    $0x0,%eax
  803626:	e9 8b 04 00 00       	jmp    803ab6 <realloc_block_FF+0x4a7>
	}

	if(new_size == 0)
  80362b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80362f:	75 18                	jne    803649 <realloc_block_FF+0x3a>
	{
		free_block(va);
  803631:	83 ec 0c             	sub    $0xc,%esp
  803634:	ff 75 08             	pushl  0x8(%ebp)
  803637:	e8 56 fd ff ff       	call   803392 <free_block>
  80363c:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80363f:	b8 00 00 00 00       	mov    $0x0,%eax
  803644:	e9 6d 04 00 00       	jmp    803ab6 <realloc_block_FF+0x4a7>
	}

	if(va == NULL)
  803649:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80364d:	75 13                	jne    803662 <realloc_block_FF+0x53>
	{
		return alloc_block_FF(new_size);
  80364f:	83 ec 0c             	sub    $0xc,%esp
  803652:	ff 75 0c             	pushl  0xc(%ebp)
  803655:	e8 6f f6 ff ff       	call   802cc9 <alloc_block_FF>
  80365a:	83 c4 10             	add    $0x10,%esp
  80365d:	e9 54 04 00 00       	jmp    803ab6 <realloc_block_FF+0x4a7>
	}

	// if size is odd must be increment it by one
	if (new_size % 2 != 0)
  803662:	8b 45 0c             	mov    0xc(%ebp),%eax
  803665:	83 e0 01             	and    $0x1,%eax
  803668:	85 c0                	test   %eax,%eax
  80366a:	74 03                	je     80366f <realloc_block_FF+0x60>
	{
		new_size++;
  80366c:	ff 45 0c             	incl   0xc(%ebp)
	}

	// if size < 8 must be equal it to 8 because min size 8 excluding metadata
	if(new_size < 8)
  80366f:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803673:	77 07                	ja     80367c <realloc_block_FF+0x6d>
	{
		new_size = 8;
  803675:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	}

	new_size += 8; // adds its footer and header size
  80367c:	83 45 0c 08          	addl   $0x8,0xc(%ebp)

	uint32 actualSize = get_block_size(va);
  803680:	83 ec 0c             	sub    $0xc,%esp
  803683:	ff 75 08             	pushl  0x8(%ebp)
  803686:	e8 d8 f1 ff ff       	call   802863 <get_block_size>
  80368b:	83 c4 10             	add    $0x10,%esp
  80368e:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(actualSize == new_size)
  803691:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803694:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803697:	75 08                	jne    8036a1 <realloc_block_FF+0x92>
	{
		// don't change any thing
		return va;
  803699:	8b 45 08             	mov    0x8(%ebp),%eax
  80369c:	e9 15 04 00 00       	jmp    803ab6 <realloc_block_FF+0x4a7>
	}

	// next block for the block we want to change its size
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + actualSize);
  8036a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8036a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a7:	01 d0                	add    %edx,%eax
  8036a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  8036ac:	83 ec 0c             	sub    $0xc,%esp
  8036af:	ff 75 f0             	pushl  -0x10(%ebp)
  8036b2:	e8 c5 f1 ff ff       	call   80287c <is_free_block>
  8036b7:	83 c4 10             	add    $0x10,%esp
  8036ba:	0f be c0             	movsbl %al,%eax
  8036bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 nextSize = get_block_size(nextBlk);
  8036c0:	83 ec 0c             	sub    $0xc,%esp
  8036c3:	ff 75 f0             	pushl  -0x10(%ebp)
  8036c6:	e8 98 f1 ff ff       	call   802863 <get_block_size>
  8036cb:	83 c4 10             	add    $0x10,%esp
  8036ce:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// increase the size of block
	if(new_size > actualSize)
  8036d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036d4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8036d7:	0f 86 a7 02 00 00    	jbe    803984 <realloc_block_FF+0x375>
	{
		if(isNextFree)
  8036dd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8036e1:	0f 84 86 02 00 00    	je     80396d <realloc_block_FF+0x35e>
		{
			if(nextSize + actualSize == new_size) // block and nextblock = newSizeBlock
  8036e7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ed:	01 d0                	add    %edx,%eax
  8036ef:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8036f2:	0f 85 b2 00 00 00    	jne    8037aa <realloc_block_FF+0x19b>
			{
				set_block_data(va,new_size,!(is_free_block(va)));// update size in block
  8036f8:	83 ec 0c             	sub    $0xc,%esp
  8036fb:	ff 75 08             	pushl  0x8(%ebp)
  8036fe:	e8 79 f1 ff ff       	call   80287c <is_free_block>
  803703:	83 c4 10             	add    $0x10,%esp
  803706:	84 c0                	test   %al,%al
  803708:	0f 94 c0             	sete   %al
  80370b:	0f b6 c0             	movzbl %al,%eax
  80370e:	83 ec 04             	sub    $0x4,%esp
  803711:	50                   	push   %eax
  803712:	ff 75 0c             	pushl  0xc(%ebp)
  803715:	ff 75 08             	pushl  0x8(%ebp)
  803718:	e8 c2 f3 ff ff       	call   802adf <set_block_data>
  80371d:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);// remove next because it is = zero
  803720:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803724:	75 17                	jne    80373d <realloc_block_FF+0x12e>
  803726:	83 ec 04             	sub    $0x4,%esp
  803729:	68 d4 46 80 00       	push   $0x8046d4
  80372e:	68 db 01 00 00       	push   $0x1db
  803733:	68 2b 46 80 00       	push   $0x80462b
  803738:	e8 5f d1 ff ff       	call   80089c <_panic>
  80373d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803740:	8b 00                	mov    (%eax),%eax
  803742:	85 c0                	test   %eax,%eax
  803744:	74 10                	je     803756 <realloc_block_FF+0x147>
  803746:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803749:	8b 00                	mov    (%eax),%eax
  80374b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80374e:	8b 52 04             	mov    0x4(%edx),%edx
  803751:	89 50 04             	mov    %edx,0x4(%eax)
  803754:	eb 0b                	jmp    803761 <realloc_block_FF+0x152>
  803756:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803759:	8b 40 04             	mov    0x4(%eax),%eax
  80375c:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803761:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803764:	8b 40 04             	mov    0x4(%eax),%eax
  803767:	85 c0                	test   %eax,%eax
  803769:	74 0f                	je     80377a <realloc_block_FF+0x16b>
  80376b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80376e:	8b 40 04             	mov    0x4(%eax),%eax
  803771:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803774:	8b 12                	mov    (%edx),%edx
  803776:	89 10                	mov    %edx,(%eax)
  803778:	eb 0a                	jmp    803784 <realloc_block_FF+0x175>
  80377a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80377d:	8b 00                	mov    (%eax),%eax
  80377f:	a3 48 50 98 00       	mov    %eax,0x985048
  803784:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803787:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80378d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803790:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803797:	a1 54 50 98 00       	mov    0x985054,%eax
  80379c:	48                   	dec    %eax
  80379d:	a3 54 50 98 00       	mov    %eax,0x985054
				return va;
  8037a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a5:	e9 0c 03 00 00       	jmp    803ab6 <realloc_block_FF+0x4a7>
			}
			else if(nextSize + actualSize > new_size) // new size is less than next and main blocks
  8037aa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b0:	01 d0                	add    %edx,%eax
  8037b2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8037b5:	0f 86 b2 01 00 00    	jbe    80396d <realloc_block_FF+0x35e>
			{
				uint32 requiredSize = new_size - actualSize; // size that we need from the next block
  8037bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037be:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8037c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				uint32 remainingNext = nextSize - requiredSize; // size that will remain from the next block after we split it
  8037c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037c7:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8037ca:	89 45 e0             	mov    %eax,-0x20(%ebp)

				// if next size will not fit another block (internal fragmentation)
				if(remainingNext < 16)
  8037cd:	83 7d e0 0f          	cmpl   $0xf,-0x20(%ebp)
  8037d1:	0f 87 b8 00 00 00    	ja     80388f <realloc_block_FF+0x280>
				{
					// we will take the main size of the block and its next size also
					set_block_data(va,actualSize + nextSize,!(is_free_block(va)));
  8037d7:	83 ec 0c             	sub    $0xc,%esp
  8037da:	ff 75 08             	pushl  0x8(%ebp)
  8037dd:	e8 9a f0 ff ff       	call   80287c <is_free_block>
  8037e2:	83 c4 10             	add    $0x10,%esp
  8037e5:	84 c0                	test   %al,%al
  8037e7:	0f 94 c0             	sete   %al
  8037ea:	0f b6 c0             	movzbl %al,%eax
  8037ed:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8037f0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037f3:	01 ca                	add    %ecx,%edx
  8037f5:	83 ec 04             	sub    $0x4,%esp
  8037f8:	50                   	push   %eax
  8037f9:	52                   	push   %edx
  8037fa:	ff 75 08             	pushl  0x8(%ebp)
  8037fd:	e8 dd f2 ff ff       	call   802adf <set_block_data>
  803802:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,nextBlk);
  803805:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803809:	75 17                	jne    803822 <realloc_block_FF+0x213>
  80380b:	83 ec 04             	sub    $0x4,%esp
  80380e:	68 d4 46 80 00       	push   $0x8046d4
  803813:	68 e8 01 00 00       	push   $0x1e8
  803818:	68 2b 46 80 00       	push   $0x80462b
  80381d:	e8 7a d0 ff ff       	call   80089c <_panic>
  803822:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803825:	8b 00                	mov    (%eax),%eax
  803827:	85 c0                	test   %eax,%eax
  803829:	74 10                	je     80383b <realloc_block_FF+0x22c>
  80382b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80382e:	8b 00                	mov    (%eax),%eax
  803830:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803833:	8b 52 04             	mov    0x4(%edx),%edx
  803836:	89 50 04             	mov    %edx,0x4(%eax)
  803839:	eb 0b                	jmp    803846 <realloc_block_FF+0x237>
  80383b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80383e:	8b 40 04             	mov    0x4(%eax),%eax
  803841:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803846:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803849:	8b 40 04             	mov    0x4(%eax),%eax
  80384c:	85 c0                	test   %eax,%eax
  80384e:	74 0f                	je     80385f <realloc_block_FF+0x250>
  803850:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803853:	8b 40 04             	mov    0x4(%eax),%eax
  803856:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803859:	8b 12                	mov    (%edx),%edx
  80385b:	89 10                	mov    %edx,(%eax)
  80385d:	eb 0a                	jmp    803869 <realloc_block_FF+0x25a>
  80385f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803862:	8b 00                	mov    (%eax),%eax
  803864:	a3 48 50 98 00       	mov    %eax,0x985048
  803869:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80386c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803872:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803875:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80387c:	a1 54 50 98 00       	mov    0x985054,%eax
  803881:	48                   	dec    %eax
  803882:	a3 54 50 98 00       	mov    %eax,0x985054
					return va;
  803887:	8b 45 08             	mov    0x8(%ebp),%eax
  80388a:	e9 27 02 00 00       	jmp    803ab6 <realloc_block_FF+0x4a7>
				}
				else // if next size can be fit another block (split)
				{
					LIST_REMOVE(&freeBlocksList,nextBlk);
  80388f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803893:	75 17                	jne    8038ac <realloc_block_FF+0x29d>
  803895:	83 ec 04             	sub    $0x4,%esp
  803898:	68 d4 46 80 00       	push   $0x8046d4
  80389d:	68 ed 01 00 00       	push   $0x1ed
  8038a2:	68 2b 46 80 00       	push   $0x80462b
  8038a7:	e8 f0 cf ff ff       	call   80089c <_panic>
  8038ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038af:	8b 00                	mov    (%eax),%eax
  8038b1:	85 c0                	test   %eax,%eax
  8038b3:	74 10                	je     8038c5 <realloc_block_FF+0x2b6>
  8038b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038b8:	8b 00                	mov    (%eax),%eax
  8038ba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8038bd:	8b 52 04             	mov    0x4(%edx),%edx
  8038c0:	89 50 04             	mov    %edx,0x4(%eax)
  8038c3:	eb 0b                	jmp    8038d0 <realloc_block_FF+0x2c1>
  8038c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038c8:	8b 40 04             	mov    0x4(%eax),%eax
  8038cb:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8038d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038d3:	8b 40 04             	mov    0x4(%eax),%eax
  8038d6:	85 c0                	test   %eax,%eax
  8038d8:	74 0f                	je     8038e9 <realloc_block_FF+0x2da>
  8038da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038dd:	8b 40 04             	mov    0x4(%eax),%eax
  8038e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8038e3:	8b 12                	mov    (%edx),%edx
  8038e5:	89 10                	mov    %edx,(%eax)
  8038e7:	eb 0a                	jmp    8038f3 <realloc_block_FF+0x2e4>
  8038e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038ec:	8b 00                	mov    (%eax),%eax
  8038ee:	a3 48 50 98 00       	mov    %eax,0x985048
  8038f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803906:	a1 54 50 98 00       	mov    0x985054,%eax
  80390b:	48                   	dec    %eax
  80390c:	a3 54 50 98 00       	mov    %eax,0x985054
					nextBlk = (struct BlockElement *)((char *)va + new_size); //update nextBlk address
  803911:	8b 55 08             	mov    0x8(%ebp),%edx
  803914:	8b 45 0c             	mov    0xc(%ebp),%eax
  803917:	01 d0                	add    %edx,%eax
  803919:	89 45 f0             	mov    %eax,-0x10(%ebp)
					set_block_data(nextBlk,remainingNext,0); // update nextBlkSize
  80391c:	83 ec 04             	sub    $0x4,%esp
  80391f:	6a 00                	push   $0x0
  803921:	ff 75 e0             	pushl  -0x20(%ebp)
  803924:	ff 75 f0             	pushl  -0x10(%ebp)
  803927:	e8 b3 f1 ff ff       	call   802adf <set_block_data>
  80392c:	83 c4 10             	add    $0x10,%esp
					set_block_data(va,new_size,!(is_free_block(va))); // update size of newblock
  80392f:	83 ec 0c             	sub    $0xc,%esp
  803932:	ff 75 08             	pushl  0x8(%ebp)
  803935:	e8 42 ef ff ff       	call   80287c <is_free_block>
  80393a:	83 c4 10             	add    $0x10,%esp
  80393d:	84 c0                	test   %al,%al
  80393f:	0f 94 c0             	sete   %al
  803942:	0f b6 c0             	movzbl %al,%eax
  803945:	83 ec 04             	sub    $0x4,%esp
  803948:	50                   	push   %eax
  803949:	ff 75 0c             	pushl  0xc(%ebp)
  80394c:	ff 75 08             	pushl  0x8(%ebp)
  80394f:	e8 8b f1 ff ff       	call   802adf <set_block_data>
  803954:	83 c4 10             	add    $0x10,%esp
					insert_sorted_in_freeList(nextBlk);
  803957:	83 ec 0c             	sub    $0xc,%esp
  80395a:	ff 75 f0             	pushl  -0x10(%ebp)
  80395d:	e8 d4 f1 ff ff       	call   802b36 <insert_sorted_in_freeList>
  803962:	83 c4 10             	add    $0x10,%esp
					return va;
  803965:	8b 45 08             	mov    0x8(%ebp),%eax
  803968:	e9 49 01 00 00       	jmp    803ab6 <realloc_block_FF+0x4a7>
				}
			}
		}
		// if next block isn't free or not fit the new size
		return alloc_block_FF(new_size - 8);
  80396d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803970:	83 e8 08             	sub    $0x8,%eax
  803973:	83 ec 0c             	sub    $0xc,%esp
  803976:	50                   	push   %eax
  803977:	e8 4d f3 ff ff       	call   802cc9 <alloc_block_FF>
  80397c:	83 c4 10             	add    $0x10,%esp
  80397f:	e9 32 01 00 00       	jmp    803ab6 <realloc_block_FF+0x4a7>
	}
	else if(new_size < actualSize) // to shrink block
  803984:	8b 45 0c             	mov    0xc(%ebp),%eax
  803987:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80398a:	0f 83 21 01 00 00    	jae    803ab1 <realloc_block_FF+0x4a2>
	{
		uint32 remainingSize = actualSize - new_size; // size that will remain from the main block after we shrink it
  803990:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803993:	2b 45 0c             	sub    0xc(%ebp),%eax
  803996:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(remainingSize < 16 && isNextFree == 0) // internal fragmentation
  803999:	83 7d dc 0f          	cmpl   $0xf,-0x24(%ebp)
  80399d:	77 0e                	ja     8039ad <realloc_block_FF+0x39e>
  80399f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8039a3:	75 08                	jne    8039ad <realloc_block_FF+0x39e>
		{
			// don't change its size
			return va;
  8039a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8039a8:	e9 09 01 00 00       	jmp    803ab6 <realloc_block_FF+0x4a7>
		}
		else // remainingSize fit in a new block
		{
			struct BlockElement *mainBlk = (struct BlockElement *)va;
  8039ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8039b0:	89 45 d8             	mov    %eax,-0x28(%ebp)
			// update main block with new size
			set_block_data(mainBlk,new_size,!(is_free_block(va)));
  8039b3:	83 ec 0c             	sub    $0xc,%esp
  8039b6:	ff 75 08             	pushl  0x8(%ebp)
  8039b9:	e8 be ee ff ff       	call   80287c <is_free_block>
  8039be:	83 c4 10             	add    $0x10,%esp
  8039c1:	84 c0                	test   %al,%al
  8039c3:	0f 94 c0             	sete   %al
  8039c6:	0f b6 c0             	movzbl %al,%eax
  8039c9:	83 ec 04             	sub    $0x4,%esp
  8039cc:	50                   	push   %eax
  8039cd:	ff 75 0c             	pushl  0xc(%ebp)
  8039d0:	ff 75 d8             	pushl  -0x28(%ebp)
  8039d3:	e8 07 f1 ff ff       	call   802adf <set_block_data>
  8039d8:	83 c4 10             	add    $0x10,%esp

			// the blk with remaining size
			struct BlockElement *remainingBlk=(struct BlockElement *)((char*)mainBlk + new_size);
  8039db:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8039de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039e1:	01 d0                	add    %edx,%eax
  8039e3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			set_block_data(remainingBlk,remainingSize,0);
  8039e6:	83 ec 04             	sub    $0x4,%esp
  8039e9:	6a 00                	push   $0x0
  8039eb:	ff 75 dc             	pushl  -0x24(%ebp)
  8039ee:	ff 75 d4             	pushl  -0x2c(%ebp)
  8039f1:	e8 e9 f0 ff ff       	call   802adf <set_block_data>
  8039f6:	83 c4 10             	add    $0x10,%esp

			if(isNextFree)
  8039f9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8039fd:	0f 84 9b 00 00 00    	je     803a9e <realloc_block_FF+0x48f>
			{
				// merge splited block with its next block
				set_block_data(remainingBlk,(remainingSize + nextSize),0);//merge remaining with its next block
  803a03:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803a06:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a09:	01 d0                	add    %edx,%eax
  803a0b:	83 ec 04             	sub    $0x4,%esp
  803a0e:	6a 00                	push   $0x0
  803a10:	50                   	push   %eax
  803a11:	ff 75 d4             	pushl  -0x2c(%ebp)
  803a14:	e8 c6 f0 ff ff       	call   802adf <set_block_data>
  803a19:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);
  803a1c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803a20:	75 17                	jne    803a39 <realloc_block_FF+0x42a>
  803a22:	83 ec 04             	sub    $0x4,%esp
  803a25:	68 d4 46 80 00       	push   $0x8046d4
  803a2a:	68 10 02 00 00       	push   $0x210
  803a2f:	68 2b 46 80 00       	push   $0x80462b
  803a34:	e8 63 ce ff ff       	call   80089c <_panic>
  803a39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a3c:	8b 00                	mov    (%eax),%eax
  803a3e:	85 c0                	test   %eax,%eax
  803a40:	74 10                	je     803a52 <realloc_block_FF+0x443>
  803a42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a45:	8b 00                	mov    (%eax),%eax
  803a47:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a4a:	8b 52 04             	mov    0x4(%edx),%edx
  803a4d:	89 50 04             	mov    %edx,0x4(%eax)
  803a50:	eb 0b                	jmp    803a5d <realloc_block_FF+0x44e>
  803a52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a55:	8b 40 04             	mov    0x4(%eax),%eax
  803a58:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803a5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a60:	8b 40 04             	mov    0x4(%eax),%eax
  803a63:	85 c0                	test   %eax,%eax
  803a65:	74 0f                	je     803a76 <realloc_block_FF+0x467>
  803a67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a6a:	8b 40 04             	mov    0x4(%eax),%eax
  803a6d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a70:	8b 12                	mov    (%edx),%edx
  803a72:	89 10                	mov    %edx,(%eax)
  803a74:	eb 0a                	jmp    803a80 <realloc_block_FF+0x471>
  803a76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a79:	8b 00                	mov    (%eax),%eax
  803a7b:	a3 48 50 98 00       	mov    %eax,0x985048
  803a80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a83:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a8c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a93:	a1 54 50 98 00       	mov    0x985054,%eax
  803a98:	48                   	dec    %eax
  803a99:	a3 54 50 98 00       	mov    %eax,0x985054
			}
			insert_sorted_in_freeList(remainingBlk);
  803a9e:	83 ec 0c             	sub    $0xc,%esp
  803aa1:	ff 75 d4             	pushl  -0x2c(%ebp)
  803aa4:	e8 8d f0 ff ff       	call   802b36 <insert_sorted_in_freeList>
  803aa9:	83 c4 10             	add    $0x10,%esp
			return mainBlk;
  803aac:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803aaf:	eb 05                	jmp    803ab6 <realloc_block_FF+0x4a7>
		}
	}
	return NULL;
  803ab1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ab6:	c9                   	leave  
  803ab7:	c3                   	ret    

00803ab8 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803ab8:	55                   	push   %ebp
  803ab9:	89 e5                	mov    %esp,%ebp
  803abb:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803abe:	83 ec 04             	sub    $0x4,%esp
  803ac1:	68 f4 46 80 00       	push   $0x8046f4
  803ac6:	68 20 02 00 00       	push   $0x220
  803acb:	68 2b 46 80 00       	push   $0x80462b
  803ad0:	e8 c7 cd ff ff       	call   80089c <_panic>

00803ad5 <alloc_block_NF>:
}
//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803ad5:	55                   	push   %ebp
  803ad6:	89 e5                	mov    %esp,%ebp
  803ad8:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803adb:	83 ec 04             	sub    $0x4,%esp
  803ade:	68 1c 47 80 00       	push   $0x80471c
  803ae3:	68 28 02 00 00       	push   $0x228
  803ae8:	68 2b 46 80 00       	push   $0x80462b
  803aed:	e8 aa cd ff ff       	call   80089c <_panic>
  803af2:	66 90                	xchg   %ax,%ax

00803af4 <__udivdi3>:
  803af4:	55                   	push   %ebp
  803af5:	57                   	push   %edi
  803af6:	56                   	push   %esi
  803af7:	53                   	push   %ebx
  803af8:	83 ec 1c             	sub    $0x1c,%esp
  803afb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803aff:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b03:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b07:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b0b:	89 ca                	mov    %ecx,%edx
  803b0d:	89 f8                	mov    %edi,%eax
  803b0f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803b13:	85 f6                	test   %esi,%esi
  803b15:	75 2d                	jne    803b44 <__udivdi3+0x50>
  803b17:	39 cf                	cmp    %ecx,%edi
  803b19:	77 65                	ja     803b80 <__udivdi3+0x8c>
  803b1b:	89 fd                	mov    %edi,%ebp
  803b1d:	85 ff                	test   %edi,%edi
  803b1f:	75 0b                	jne    803b2c <__udivdi3+0x38>
  803b21:	b8 01 00 00 00       	mov    $0x1,%eax
  803b26:	31 d2                	xor    %edx,%edx
  803b28:	f7 f7                	div    %edi
  803b2a:	89 c5                	mov    %eax,%ebp
  803b2c:	31 d2                	xor    %edx,%edx
  803b2e:	89 c8                	mov    %ecx,%eax
  803b30:	f7 f5                	div    %ebp
  803b32:	89 c1                	mov    %eax,%ecx
  803b34:	89 d8                	mov    %ebx,%eax
  803b36:	f7 f5                	div    %ebp
  803b38:	89 cf                	mov    %ecx,%edi
  803b3a:	89 fa                	mov    %edi,%edx
  803b3c:	83 c4 1c             	add    $0x1c,%esp
  803b3f:	5b                   	pop    %ebx
  803b40:	5e                   	pop    %esi
  803b41:	5f                   	pop    %edi
  803b42:	5d                   	pop    %ebp
  803b43:	c3                   	ret    
  803b44:	39 ce                	cmp    %ecx,%esi
  803b46:	77 28                	ja     803b70 <__udivdi3+0x7c>
  803b48:	0f bd fe             	bsr    %esi,%edi
  803b4b:	83 f7 1f             	xor    $0x1f,%edi
  803b4e:	75 40                	jne    803b90 <__udivdi3+0x9c>
  803b50:	39 ce                	cmp    %ecx,%esi
  803b52:	72 0a                	jb     803b5e <__udivdi3+0x6a>
  803b54:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803b58:	0f 87 9e 00 00 00    	ja     803bfc <__udivdi3+0x108>
  803b5e:	b8 01 00 00 00       	mov    $0x1,%eax
  803b63:	89 fa                	mov    %edi,%edx
  803b65:	83 c4 1c             	add    $0x1c,%esp
  803b68:	5b                   	pop    %ebx
  803b69:	5e                   	pop    %esi
  803b6a:	5f                   	pop    %edi
  803b6b:	5d                   	pop    %ebp
  803b6c:	c3                   	ret    
  803b6d:	8d 76 00             	lea    0x0(%esi),%esi
  803b70:	31 ff                	xor    %edi,%edi
  803b72:	31 c0                	xor    %eax,%eax
  803b74:	89 fa                	mov    %edi,%edx
  803b76:	83 c4 1c             	add    $0x1c,%esp
  803b79:	5b                   	pop    %ebx
  803b7a:	5e                   	pop    %esi
  803b7b:	5f                   	pop    %edi
  803b7c:	5d                   	pop    %ebp
  803b7d:	c3                   	ret    
  803b7e:	66 90                	xchg   %ax,%ax
  803b80:	89 d8                	mov    %ebx,%eax
  803b82:	f7 f7                	div    %edi
  803b84:	31 ff                	xor    %edi,%edi
  803b86:	89 fa                	mov    %edi,%edx
  803b88:	83 c4 1c             	add    $0x1c,%esp
  803b8b:	5b                   	pop    %ebx
  803b8c:	5e                   	pop    %esi
  803b8d:	5f                   	pop    %edi
  803b8e:	5d                   	pop    %ebp
  803b8f:	c3                   	ret    
  803b90:	bd 20 00 00 00       	mov    $0x20,%ebp
  803b95:	89 eb                	mov    %ebp,%ebx
  803b97:	29 fb                	sub    %edi,%ebx
  803b99:	89 f9                	mov    %edi,%ecx
  803b9b:	d3 e6                	shl    %cl,%esi
  803b9d:	89 c5                	mov    %eax,%ebp
  803b9f:	88 d9                	mov    %bl,%cl
  803ba1:	d3 ed                	shr    %cl,%ebp
  803ba3:	89 e9                	mov    %ebp,%ecx
  803ba5:	09 f1                	or     %esi,%ecx
  803ba7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803bab:	89 f9                	mov    %edi,%ecx
  803bad:	d3 e0                	shl    %cl,%eax
  803baf:	89 c5                	mov    %eax,%ebp
  803bb1:	89 d6                	mov    %edx,%esi
  803bb3:	88 d9                	mov    %bl,%cl
  803bb5:	d3 ee                	shr    %cl,%esi
  803bb7:	89 f9                	mov    %edi,%ecx
  803bb9:	d3 e2                	shl    %cl,%edx
  803bbb:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bbf:	88 d9                	mov    %bl,%cl
  803bc1:	d3 e8                	shr    %cl,%eax
  803bc3:	09 c2                	or     %eax,%edx
  803bc5:	89 d0                	mov    %edx,%eax
  803bc7:	89 f2                	mov    %esi,%edx
  803bc9:	f7 74 24 0c          	divl   0xc(%esp)
  803bcd:	89 d6                	mov    %edx,%esi
  803bcf:	89 c3                	mov    %eax,%ebx
  803bd1:	f7 e5                	mul    %ebp
  803bd3:	39 d6                	cmp    %edx,%esi
  803bd5:	72 19                	jb     803bf0 <__udivdi3+0xfc>
  803bd7:	74 0b                	je     803be4 <__udivdi3+0xf0>
  803bd9:	89 d8                	mov    %ebx,%eax
  803bdb:	31 ff                	xor    %edi,%edi
  803bdd:	e9 58 ff ff ff       	jmp    803b3a <__udivdi3+0x46>
  803be2:	66 90                	xchg   %ax,%ax
  803be4:	8b 54 24 08          	mov    0x8(%esp),%edx
  803be8:	89 f9                	mov    %edi,%ecx
  803bea:	d3 e2                	shl    %cl,%edx
  803bec:	39 c2                	cmp    %eax,%edx
  803bee:	73 e9                	jae    803bd9 <__udivdi3+0xe5>
  803bf0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803bf3:	31 ff                	xor    %edi,%edi
  803bf5:	e9 40 ff ff ff       	jmp    803b3a <__udivdi3+0x46>
  803bfa:	66 90                	xchg   %ax,%ax
  803bfc:	31 c0                	xor    %eax,%eax
  803bfe:	e9 37 ff ff ff       	jmp    803b3a <__udivdi3+0x46>
  803c03:	90                   	nop

00803c04 <__umoddi3>:
  803c04:	55                   	push   %ebp
  803c05:	57                   	push   %edi
  803c06:	56                   	push   %esi
  803c07:	53                   	push   %ebx
  803c08:	83 ec 1c             	sub    $0x1c,%esp
  803c0b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803c0f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803c13:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c17:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c1b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c1f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c23:	89 f3                	mov    %esi,%ebx
  803c25:	89 fa                	mov    %edi,%edx
  803c27:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c2b:	89 34 24             	mov    %esi,(%esp)
  803c2e:	85 c0                	test   %eax,%eax
  803c30:	75 1a                	jne    803c4c <__umoddi3+0x48>
  803c32:	39 f7                	cmp    %esi,%edi
  803c34:	0f 86 a2 00 00 00    	jbe    803cdc <__umoddi3+0xd8>
  803c3a:	89 c8                	mov    %ecx,%eax
  803c3c:	89 f2                	mov    %esi,%edx
  803c3e:	f7 f7                	div    %edi
  803c40:	89 d0                	mov    %edx,%eax
  803c42:	31 d2                	xor    %edx,%edx
  803c44:	83 c4 1c             	add    $0x1c,%esp
  803c47:	5b                   	pop    %ebx
  803c48:	5e                   	pop    %esi
  803c49:	5f                   	pop    %edi
  803c4a:	5d                   	pop    %ebp
  803c4b:	c3                   	ret    
  803c4c:	39 f0                	cmp    %esi,%eax
  803c4e:	0f 87 ac 00 00 00    	ja     803d00 <__umoddi3+0xfc>
  803c54:	0f bd e8             	bsr    %eax,%ebp
  803c57:	83 f5 1f             	xor    $0x1f,%ebp
  803c5a:	0f 84 ac 00 00 00    	je     803d0c <__umoddi3+0x108>
  803c60:	bf 20 00 00 00       	mov    $0x20,%edi
  803c65:	29 ef                	sub    %ebp,%edi
  803c67:	89 fe                	mov    %edi,%esi
  803c69:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803c6d:	89 e9                	mov    %ebp,%ecx
  803c6f:	d3 e0                	shl    %cl,%eax
  803c71:	89 d7                	mov    %edx,%edi
  803c73:	89 f1                	mov    %esi,%ecx
  803c75:	d3 ef                	shr    %cl,%edi
  803c77:	09 c7                	or     %eax,%edi
  803c79:	89 e9                	mov    %ebp,%ecx
  803c7b:	d3 e2                	shl    %cl,%edx
  803c7d:	89 14 24             	mov    %edx,(%esp)
  803c80:	89 d8                	mov    %ebx,%eax
  803c82:	d3 e0                	shl    %cl,%eax
  803c84:	89 c2                	mov    %eax,%edx
  803c86:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c8a:	d3 e0                	shl    %cl,%eax
  803c8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c90:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c94:	89 f1                	mov    %esi,%ecx
  803c96:	d3 e8                	shr    %cl,%eax
  803c98:	09 d0                	or     %edx,%eax
  803c9a:	d3 eb                	shr    %cl,%ebx
  803c9c:	89 da                	mov    %ebx,%edx
  803c9e:	f7 f7                	div    %edi
  803ca0:	89 d3                	mov    %edx,%ebx
  803ca2:	f7 24 24             	mull   (%esp)
  803ca5:	89 c6                	mov    %eax,%esi
  803ca7:	89 d1                	mov    %edx,%ecx
  803ca9:	39 d3                	cmp    %edx,%ebx
  803cab:	0f 82 87 00 00 00    	jb     803d38 <__umoddi3+0x134>
  803cb1:	0f 84 91 00 00 00    	je     803d48 <__umoddi3+0x144>
  803cb7:	8b 54 24 04          	mov    0x4(%esp),%edx
  803cbb:	29 f2                	sub    %esi,%edx
  803cbd:	19 cb                	sbb    %ecx,%ebx
  803cbf:	89 d8                	mov    %ebx,%eax
  803cc1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803cc5:	d3 e0                	shl    %cl,%eax
  803cc7:	89 e9                	mov    %ebp,%ecx
  803cc9:	d3 ea                	shr    %cl,%edx
  803ccb:	09 d0                	or     %edx,%eax
  803ccd:	89 e9                	mov    %ebp,%ecx
  803ccf:	d3 eb                	shr    %cl,%ebx
  803cd1:	89 da                	mov    %ebx,%edx
  803cd3:	83 c4 1c             	add    $0x1c,%esp
  803cd6:	5b                   	pop    %ebx
  803cd7:	5e                   	pop    %esi
  803cd8:	5f                   	pop    %edi
  803cd9:	5d                   	pop    %ebp
  803cda:	c3                   	ret    
  803cdb:	90                   	nop
  803cdc:	89 fd                	mov    %edi,%ebp
  803cde:	85 ff                	test   %edi,%edi
  803ce0:	75 0b                	jne    803ced <__umoddi3+0xe9>
  803ce2:	b8 01 00 00 00       	mov    $0x1,%eax
  803ce7:	31 d2                	xor    %edx,%edx
  803ce9:	f7 f7                	div    %edi
  803ceb:	89 c5                	mov    %eax,%ebp
  803ced:	89 f0                	mov    %esi,%eax
  803cef:	31 d2                	xor    %edx,%edx
  803cf1:	f7 f5                	div    %ebp
  803cf3:	89 c8                	mov    %ecx,%eax
  803cf5:	f7 f5                	div    %ebp
  803cf7:	89 d0                	mov    %edx,%eax
  803cf9:	e9 44 ff ff ff       	jmp    803c42 <__umoddi3+0x3e>
  803cfe:	66 90                	xchg   %ax,%ax
  803d00:	89 c8                	mov    %ecx,%eax
  803d02:	89 f2                	mov    %esi,%edx
  803d04:	83 c4 1c             	add    $0x1c,%esp
  803d07:	5b                   	pop    %ebx
  803d08:	5e                   	pop    %esi
  803d09:	5f                   	pop    %edi
  803d0a:	5d                   	pop    %ebp
  803d0b:	c3                   	ret    
  803d0c:	3b 04 24             	cmp    (%esp),%eax
  803d0f:	72 06                	jb     803d17 <__umoddi3+0x113>
  803d11:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803d15:	77 0f                	ja     803d26 <__umoddi3+0x122>
  803d17:	89 f2                	mov    %esi,%edx
  803d19:	29 f9                	sub    %edi,%ecx
  803d1b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d1f:	89 14 24             	mov    %edx,(%esp)
  803d22:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d26:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d2a:	8b 14 24             	mov    (%esp),%edx
  803d2d:	83 c4 1c             	add    $0x1c,%esp
  803d30:	5b                   	pop    %ebx
  803d31:	5e                   	pop    %esi
  803d32:	5f                   	pop    %edi
  803d33:	5d                   	pop    %ebp
  803d34:	c3                   	ret    
  803d35:	8d 76 00             	lea    0x0(%esi),%esi
  803d38:	2b 04 24             	sub    (%esp),%eax
  803d3b:	19 fa                	sbb    %edi,%edx
  803d3d:	89 d1                	mov    %edx,%ecx
  803d3f:	89 c6                	mov    %eax,%esi
  803d41:	e9 71 ff ff ff       	jmp    803cb7 <__umoddi3+0xb3>
  803d46:	66 90                	xchg   %ax,%ax
  803d48:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803d4c:	72 ea                	jb     803d38 <__umoddi3+0x134>
  803d4e:	89 d9                	mov    %ebx,%ecx
  803d50:	e9 62 ff ff ff       	jmp    803cb7 <__umoddi3+0xb3>
