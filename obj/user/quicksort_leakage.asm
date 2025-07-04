
obj/user/quicksort_leakage:     file format elf32-i386


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
  800031:	e8 c8 05 00 00       	call   8005fe <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void QuickSort(int *Elements, int NumOfElements);
void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex);
uint32 CheckSorted(int *Elements, int NumOfElements);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp
		//2012: lock the interrupt
		//sys_lock_cons();
		//2024: lock the console only using a sleepLock
		int NumOfElements;
		int *Elements;
		sys_lock_cons();
  800041:	e8 94 20 00 00       	call   8020da <sys_lock_cons>
		{
			cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 00 3c 80 00       	push   $0x803c00
  80004e:	e8 ad 09 00 00       	call   800a00 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 02 3c 80 00       	push   $0x803c02
  80005e:	e8 9d 09 00 00       	call   800a00 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!   QUICK SORT    !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 1b 3c 80 00       	push   $0x803c1b
  80006e:	e8 8d 09 00 00       	call   800a00 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 02 3c 80 00       	push   $0x803c02
  80007e:	e8 7d 09 00 00       	call   800a00 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
			cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 00 3c 80 00       	push   $0x803c00
  80008e:	e8 6d 09 00 00       	call   800a00 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

			readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 34 3c 80 00       	push   $0x803c34
  8000a5:	e8 ea 0f 00 00       	call   801094 <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
			NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 3c 15 00 00       	call   8015fc <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			cprintf("Chose the initialization method:\n") ;
  8000c6:	83 ec 0c             	sub    $0xc,%esp
  8000c9:	68 54 3c 80 00       	push   $0x803c54
  8000ce:	e8 2d 09 00 00       	call   800a00 <cprintf>
  8000d3:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 76 3c 80 00       	push   $0x803c76
  8000de:	e8 1d 09 00 00       	call   800a00 <cprintf>
  8000e3:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	68 84 3c 80 00       	push   $0x803c84
  8000ee:	e8 0d 09 00 00       	call   800a00 <cprintf>
  8000f3:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  8000f6:	83 ec 0c             	sub    $0xc,%esp
  8000f9:	68 93 3c 80 00       	push   $0x803c93
  8000fe:	e8 fd 08 00 00       	call   800a00 <cprintf>
  800103:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  800106:	83 ec 0c             	sub    $0xc,%esp
  800109:	68 a3 3c 80 00       	push   $0x803ca3
  80010e:	e8 ed 08 00 00       	call   800a00 <cprintf>
  800113:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800116:	e8 c6 04 00 00       	call   8005e1 <getchar>
  80011b:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  80011e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800122:	83 ec 0c             	sub    $0xc,%esp
  800125:	50                   	push   %eax
  800126:	e8 97 04 00 00       	call   8005c2 <cputchar>
  80012b:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80012e:	83 ec 0c             	sub    $0xc,%esp
  800131:	6a 0a                	push   $0xa
  800133:	e8 8a 04 00 00       	call   8005c2 <cputchar>
  800138:	83 c4 10             	add    $0x10,%esp
			} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  80013b:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  80013f:	74 0c                	je     80014d <_main+0x115>
  800141:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  800145:	74 06                	je     80014d <_main+0x115>
  800147:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  80014b:	75 b9                	jne    800106 <_main+0xce>
		}
		//2012: unlock
		sys_unlock_cons();
  80014d:	e8 a2 1f 00 00       	call   8020f4 <sys_unlock_cons>
		//sys_unlock_cons();

		Elements = malloc(sizeof(int) * NumOfElements) ;
  800152:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800155:	c1 e0 02             	shl    $0x2,%eax
  800158:	83 ec 0c             	sub    $0xc,%esp
  80015b:	50                   	push   %eax
  80015c:	e8 57 18 00 00       	call   8019b8 <malloc>
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
  800183:	e8 f5 02 00 00       	call   80047d <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f0             	pushl  -0x10(%ebp)
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	e8 13 03 00 00       	call   8004ae <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a9:	e8 35 03 00 00       	call   8004e3 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 22 03 00 00       	call   8004e3 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  8001c4:	83 ec 08             	sub    $0x8,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cd:	e8 f0 00 00 00       	call   8002c2 <QuickSort>
  8001d2:	83 c4 10             	add    $0x10,%esp

		//sys_lock_cons();
		sys_lock_cons();
  8001d5:	e8 00 1f 00 00       	call   8020da <sys_lock_cons>
		{
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	68 ac 3c 80 00       	push   $0x803cac
  8001e2:	e8 19 08 00 00       	call   800a00 <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
			//		PrintElements(Elements, NumOfElements);
		}
		sys_unlock_cons();
  8001ea:	e8 05 1f 00 00       	call   8020f4 <sys_unlock_cons>
		//sys_unlock_cons();

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001ef:	83 ec 08             	sub    $0x8,%esp
  8001f2:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f5:	ff 75 ec             	pushl  -0x14(%ebp)
  8001f8:	e8 d6 01 00 00       	call   8003d3 <CheckSorted>
  8001fd:	83 c4 10             	add    $0x10,%esp
  800200:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800203:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800207:	75 14                	jne    80021d <_main+0x1e5>
  800209:	83 ec 04             	sub    $0x4,%esp
  80020c:	68 e0 3c 80 00       	push   $0x803ce0
  800211:	6a 54                	push   $0x54
  800213:	68 02 3d 80 00       	push   $0x803d02
  800218:	e8 26 05 00 00       	call   800743 <_panic>
		else
		{
			//			sys_lock_cons();
			sys_lock_cons();
  80021d:	e8 b8 1e 00 00       	call   8020da <sys_lock_cons>
			{
				cprintf("===============================================\n") ;
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	68 1c 3d 80 00       	push   $0x803d1c
  80022a:	e8 d1 07 00 00       	call   800a00 <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 50 3d 80 00       	push   $0x803d50
  80023a:	e8 c1 07 00 00       	call   800a00 <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	68 84 3d 80 00       	push   $0x803d84
  80024a:	e8 b1 07 00 00       	call   800a00 <cprintf>
  80024f:	83 c4 10             	add    $0x10,%esp
			}
			sys_unlock_cons();
  800252:	e8 9d 1e 00 00       	call   8020f4 <sys_unlock_cons>


		}

		//		sys_lock_cons();
		sys_lock_cons();
  800257:	e8 7e 1e 00 00       	call   8020da <sys_lock_cons>
		{
			Chose = 0 ;
  80025c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800260:	eb 42                	jmp    8002a4 <_main+0x26c>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800262:	83 ec 0c             	sub    $0xc,%esp
  800265:	68 b6 3d 80 00       	push   $0x803db6
  80026a:	e8 91 07 00 00       	call   800a00 <cprintf>
  80026f:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800272:	e8 6a 03 00 00       	call   8005e1 <getchar>
  800277:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  80027a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80027e:	83 ec 0c             	sub    $0xc,%esp
  800281:	50                   	push   %eax
  800282:	e8 3b 03 00 00       	call   8005c2 <cputchar>
  800287:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80028a:	83 ec 0c             	sub    $0xc,%esp
  80028d:	6a 0a                	push   $0xa
  80028f:	e8 2e 03 00 00       	call   8005c2 <cputchar>
  800294:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800297:	83 ec 0c             	sub    $0xc,%esp
  80029a:	6a 0a                	push   $0xa
  80029c:	e8 21 03 00 00       	call   8005c2 <cputchar>
  8002a1:	83 c4 10             	add    $0x10,%esp

		//		sys_lock_cons();
		sys_lock_cons();
		{
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002a4:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002a8:	74 06                	je     8002b0 <_main+0x278>
  8002aa:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002ae:	75 b2                	jne    800262 <_main+0x22a>
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		}
		sys_unlock_cons();
  8002b0:	e8 3f 1e 00 00       	call   8020f4 <sys_unlock_cons>
		//		sys_unlock_cons();

	} while (Chose == 'y');
  8002b5:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002b9:	0f 84 82 fd ff ff    	je     800041 <_main+0x9>

}
  8002bf:	90                   	nop
  8002c0:	c9                   	leave  
  8002c1:	c3                   	ret    

008002c2 <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  8002c2:	55                   	push   %ebp
  8002c3:	89 e5                	mov    %esp,%ebp
  8002c5:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  8002c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002cb:	48                   	dec    %eax
  8002cc:	50                   	push   %eax
  8002cd:	6a 00                	push   $0x0
  8002cf:	ff 75 0c             	pushl  0xc(%ebp)
  8002d2:	ff 75 08             	pushl  0x8(%ebp)
  8002d5:	e8 06 00 00 00       	call   8002e0 <QSort>
  8002da:	83 c4 10             	add    $0x10,%esp
}
  8002dd:	90                   	nop
  8002de:	c9                   	leave  
  8002df:	c3                   	ret    

008002e0 <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  8002e0:	55                   	push   %ebp
  8002e1:	89 e5                	mov    %esp,%ebp
  8002e3:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  8002e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002e9:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002ec:	0f 8d de 00 00 00    	jge    8003d0 <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  8002f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8002f5:	40                   	inc    %eax
  8002f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8002f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8002fc:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  8002ff:	e9 80 00 00 00       	jmp    800384 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800304:	ff 45 f4             	incl   -0xc(%ebp)
  800307:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80030a:	3b 45 14             	cmp    0x14(%ebp),%eax
  80030d:	7f 2b                	jg     80033a <QSort+0x5a>
  80030f:	8b 45 10             	mov    0x10(%ebp),%eax
  800312:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800319:	8b 45 08             	mov    0x8(%ebp),%eax
  80031c:	01 d0                	add    %edx,%eax
  80031e:	8b 10                	mov    (%eax),%edx
  800320:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800323:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80032a:	8b 45 08             	mov    0x8(%ebp),%eax
  80032d:	01 c8                	add    %ecx,%eax
  80032f:	8b 00                	mov    (%eax),%eax
  800331:	39 c2                	cmp    %eax,%edx
  800333:	7d cf                	jge    800304 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  800335:	eb 03                	jmp    80033a <QSort+0x5a>
  800337:	ff 4d f0             	decl   -0x10(%ebp)
  80033a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80033d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800340:	7e 26                	jle    800368 <QSort+0x88>
  800342:	8b 45 10             	mov    0x10(%ebp),%eax
  800345:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80034c:	8b 45 08             	mov    0x8(%ebp),%eax
  80034f:	01 d0                	add    %edx,%eax
  800351:	8b 10                	mov    (%eax),%edx
  800353:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800356:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80035d:	8b 45 08             	mov    0x8(%ebp),%eax
  800360:	01 c8                	add    %ecx,%eax
  800362:	8b 00                	mov    (%eax),%eax
  800364:	39 c2                	cmp    %eax,%edx
  800366:	7e cf                	jle    800337 <QSort+0x57>

		if (i <= j)
  800368:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80036b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80036e:	7f 14                	jg     800384 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  800370:	83 ec 04             	sub    $0x4,%esp
  800373:	ff 75 f0             	pushl  -0x10(%ebp)
  800376:	ff 75 f4             	pushl  -0xc(%ebp)
  800379:	ff 75 08             	pushl  0x8(%ebp)
  80037c:	e8 a9 00 00 00       	call   80042a <Swap>
  800381:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800384:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800387:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80038a:	0f 8e 77 ff ff ff    	jle    800307 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  800390:	83 ec 04             	sub    $0x4,%esp
  800393:	ff 75 f0             	pushl  -0x10(%ebp)
  800396:	ff 75 10             	pushl  0x10(%ebp)
  800399:	ff 75 08             	pushl  0x8(%ebp)
  80039c:	e8 89 00 00 00       	call   80042a <Swap>
  8003a1:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  8003a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003a7:	48                   	dec    %eax
  8003a8:	50                   	push   %eax
  8003a9:	ff 75 10             	pushl  0x10(%ebp)
  8003ac:	ff 75 0c             	pushl  0xc(%ebp)
  8003af:	ff 75 08             	pushl  0x8(%ebp)
  8003b2:	e8 29 ff ff ff       	call   8002e0 <QSort>
  8003b7:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  8003ba:	ff 75 14             	pushl  0x14(%ebp)
  8003bd:	ff 75 f4             	pushl  -0xc(%ebp)
  8003c0:	ff 75 0c             	pushl  0xc(%ebp)
  8003c3:	ff 75 08             	pushl  0x8(%ebp)
  8003c6:	e8 15 ff ff ff       	call   8002e0 <QSort>
  8003cb:	83 c4 10             	add    $0x10,%esp
  8003ce:	eb 01                	jmp    8003d1 <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  8003d0:	90                   	nop
	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);

	//cprintf("qs,after sorting: start = %d, end = %d\n", startIndex, finalIndex);

}
  8003d1:	c9                   	leave  
  8003d2:	c3                   	ret    

008003d3 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8003d3:	55                   	push   %ebp
  8003d4:	89 e5                	mov    %esp,%ebp
  8003d6:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8003d9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8003e0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8003e7:	eb 33                	jmp    80041c <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8003e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003ec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f6:	01 d0                	add    %edx,%eax
  8003f8:	8b 10                	mov    (%eax),%edx
  8003fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003fd:	40                   	inc    %eax
  8003fe:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800405:	8b 45 08             	mov    0x8(%ebp),%eax
  800408:	01 c8                	add    %ecx,%eax
  80040a:	8b 00                	mov    (%eax),%eax
  80040c:	39 c2                	cmp    %eax,%edx
  80040e:	7e 09                	jle    800419 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800410:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800417:	eb 0c                	jmp    800425 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800419:	ff 45 f8             	incl   -0x8(%ebp)
  80041c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80041f:	48                   	dec    %eax
  800420:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800423:	7f c4                	jg     8003e9 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800425:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800428:	c9                   	leave  
  800429:	c3                   	ret    

0080042a <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80042a:	55                   	push   %ebp
  80042b:	89 e5                	mov    %esp,%ebp
  80042d:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800430:	8b 45 0c             	mov    0xc(%ebp),%eax
  800433:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80043a:	8b 45 08             	mov    0x8(%ebp),%eax
  80043d:	01 d0                	add    %edx,%eax
  80043f:	8b 00                	mov    (%eax),%eax
  800441:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800444:	8b 45 0c             	mov    0xc(%ebp),%eax
  800447:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80044e:	8b 45 08             	mov    0x8(%ebp),%eax
  800451:	01 c2                	add    %eax,%edx
  800453:	8b 45 10             	mov    0x10(%ebp),%eax
  800456:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80045d:	8b 45 08             	mov    0x8(%ebp),%eax
  800460:	01 c8                	add    %ecx,%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800466:	8b 45 10             	mov    0x10(%ebp),%eax
  800469:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800470:	8b 45 08             	mov    0x8(%ebp),%eax
  800473:	01 c2                	add    %eax,%edx
  800475:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800478:	89 02                	mov    %eax,(%edx)
}
  80047a:	90                   	nop
  80047b:	c9                   	leave  
  80047c:	c3                   	ret    

0080047d <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80047d:	55                   	push   %ebp
  80047e:	89 e5                	mov    %esp,%ebp
  800480:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800483:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80048a:	eb 17                	jmp    8004a3 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80048c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80048f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800496:	8b 45 08             	mov    0x8(%ebp),%eax
  800499:	01 c2                	add    %eax,%edx
  80049b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80049e:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004a0:	ff 45 fc             	incl   -0x4(%ebp)
  8004a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004a6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004a9:	7c e1                	jl     80048c <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8004ab:	90                   	nop
  8004ac:	c9                   	leave  
  8004ad:	c3                   	ret    

008004ae <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8004ae:	55                   	push   %ebp
  8004af:	89 e5                	mov    %esp,%ebp
  8004b1:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004bb:	eb 1b                	jmp    8004d8 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8004bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004c0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ca:	01 c2                	add    %eax,%edx
  8004cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004cf:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8004d2:	48                   	dec    %eax
  8004d3:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004d5:	ff 45 fc             	incl   -0x4(%ebp)
  8004d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004db:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004de:	7c dd                	jl     8004bd <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8004e0:	90                   	nop
  8004e1:	c9                   	leave  
  8004e2:	c3                   	ret    

008004e3 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8004e3:	55                   	push   %ebp
  8004e4:	89 e5                	mov    %esp,%ebp
  8004e6:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8004e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004ec:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8004f1:	f7 e9                	imul   %ecx
  8004f3:	c1 f9 1f             	sar    $0x1f,%ecx
  8004f6:	89 d0                	mov    %edx,%eax
  8004f8:	29 c8                	sub    %ecx,%eax
  8004fa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (Repetition == 0)
  8004fd:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800501:	75 07                	jne    80050a <InitializeSemiRandom+0x27>
		Repetition = 3;
  800503:	c7 45 f8 03 00 00 00 	movl   $0x3,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  80050a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800511:	eb 1e                	jmp    800531 <InitializeSemiRandom+0x4e>
	{
		Elements[i] = i % Repetition ;
  800513:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800516:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80051d:	8b 45 08             	mov    0x8(%ebp),%eax
  800520:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800523:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800526:	99                   	cltd   
  800527:	f7 7d f8             	idivl  -0x8(%ebp)
  80052a:	89 d0                	mov    %edx,%eax
  80052c:	89 01                	mov    %eax,(%ecx)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	if (Repetition == 0)
		Repetition = 3;
	for (i = 0 ; i < NumOfElements ; i++)
  80052e:	ff 45 fc             	incl   -0x4(%ebp)
  800531:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800534:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800537:	7c da                	jl     800513 <InitializeSemiRandom+0x30>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  800539:	90                   	nop
  80053a:	c9                   	leave  
  80053b:	c3                   	ret    

0080053c <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  80053c:	55                   	push   %ebp
  80053d:	89 e5                	mov    %esp,%ebp
  80053f:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800542:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800549:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800550:	eb 42                	jmp    800594 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800552:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800555:	99                   	cltd   
  800556:	f7 7d f0             	idivl  -0x10(%ebp)
  800559:	89 d0                	mov    %edx,%eax
  80055b:	85 c0                	test   %eax,%eax
  80055d:	75 10                	jne    80056f <PrintElements+0x33>
			cprintf("\n");
  80055f:	83 ec 0c             	sub    $0xc,%esp
  800562:	68 00 3c 80 00       	push   $0x803c00
  800567:	e8 94 04 00 00       	call   800a00 <cprintf>
  80056c:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  80056f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800572:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800579:	8b 45 08             	mov    0x8(%ebp),%eax
  80057c:	01 d0                	add    %edx,%eax
  80057e:	8b 00                	mov    (%eax),%eax
  800580:	83 ec 08             	sub    $0x8,%esp
  800583:	50                   	push   %eax
  800584:	68 d4 3d 80 00       	push   $0x803dd4
  800589:	e8 72 04 00 00       	call   800a00 <cprintf>
  80058e:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800591:	ff 45 f4             	incl   -0xc(%ebp)
  800594:	8b 45 0c             	mov    0xc(%ebp),%eax
  800597:	48                   	dec    %eax
  800598:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80059b:	7f b5                	jg     800552 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  80059d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005a0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005aa:	01 d0                	add    %edx,%eax
  8005ac:	8b 00                	mov    (%eax),%eax
  8005ae:	83 ec 08             	sub    $0x8,%esp
  8005b1:	50                   	push   %eax
  8005b2:	68 d9 3d 80 00       	push   $0x803dd9
  8005b7:	e8 44 04 00 00       	call   800a00 <cprintf>
  8005bc:	83 c4 10             	add    $0x10,%esp

}
  8005bf:	90                   	nop
  8005c0:	c9                   	leave  
  8005c1:	c3                   	ret    

008005c2 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8005c2:	55                   	push   %ebp
  8005c3:	89 e5                	mov    %esp,%ebp
  8005c5:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8005c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cb:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8005ce:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8005d2:	83 ec 0c             	sub    $0xc,%esp
  8005d5:	50                   	push   %eax
  8005d6:	e8 4a 1c 00 00       	call   802225 <sys_cputc>
  8005db:	83 c4 10             	add    $0x10,%esp
}
  8005de:	90                   	nop
  8005df:	c9                   	leave  
  8005e0:	c3                   	ret    

008005e1 <getchar>:


int
getchar(void)
{
  8005e1:	55                   	push   %ebp
  8005e2:	89 e5                	mov    %esp,%ebp
  8005e4:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  8005e7:	e8 d5 1a 00 00       	call   8020c1 <sys_cgetc>
  8005ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  8005ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8005f2:	c9                   	leave  
  8005f3:	c3                   	ret    

008005f4 <iscons>:

int iscons(int fdnum)
{
  8005f4:	55                   	push   %ebp
  8005f5:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8005f7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8005fc:	5d                   	pop    %ebp
  8005fd:	c3                   	ret    

008005fe <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8005fe:	55                   	push   %ebp
  8005ff:	89 e5                	mov    %esp,%ebp
  800601:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800604:	e8 4d 1d 00 00       	call   802356 <sys_getenvindex>
  800609:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80060c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80060f:	89 d0                	mov    %edx,%eax
  800611:	c1 e0 02             	shl    $0x2,%eax
  800614:	01 d0                	add    %edx,%eax
  800616:	c1 e0 03             	shl    $0x3,%eax
  800619:	01 d0                	add    %edx,%eax
  80061b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800622:	01 d0                	add    %edx,%eax
  800624:	c1 e0 02             	shl    $0x2,%eax
  800627:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80062c:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800631:	a1 24 50 80 00       	mov    0x805024,%eax
  800636:	8a 40 20             	mov    0x20(%eax),%al
  800639:	84 c0                	test   %al,%al
  80063b:	74 0d                	je     80064a <libmain+0x4c>
		binaryname = myEnv->prog_name;
  80063d:	a1 24 50 80 00       	mov    0x805024,%eax
  800642:	83 c0 20             	add    $0x20,%eax
  800645:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80064a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80064e:	7e 0a                	jle    80065a <libmain+0x5c>
		binaryname = argv[0];
  800650:	8b 45 0c             	mov    0xc(%ebp),%eax
  800653:	8b 00                	mov    (%eax),%eax
  800655:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  80065a:	83 ec 08             	sub    $0x8,%esp
  80065d:	ff 75 0c             	pushl  0xc(%ebp)
  800660:	ff 75 08             	pushl  0x8(%ebp)
  800663:	e8 d0 f9 ff ff       	call   800038 <_main>
  800668:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80066b:	a1 00 50 80 00       	mov    0x805000,%eax
  800670:	85 c0                	test   %eax,%eax
  800672:	0f 84 9f 00 00 00    	je     800717 <libmain+0x119>
	{
		sys_lock_cons();
  800678:	e8 5d 1a 00 00       	call   8020da <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80067d:	83 ec 0c             	sub    $0xc,%esp
  800680:	68 f8 3d 80 00       	push   $0x803df8
  800685:	e8 76 03 00 00       	call   800a00 <cprintf>
  80068a:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80068d:	a1 24 50 80 00       	mov    0x805024,%eax
  800692:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800698:	a1 24 50 80 00       	mov    0x805024,%eax
  80069d:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8006a3:	83 ec 04             	sub    $0x4,%esp
  8006a6:	52                   	push   %edx
  8006a7:	50                   	push   %eax
  8006a8:	68 20 3e 80 00       	push   $0x803e20
  8006ad:	e8 4e 03 00 00       	call   800a00 <cprintf>
  8006b2:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8006b5:	a1 24 50 80 00       	mov    0x805024,%eax
  8006ba:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8006c0:	a1 24 50 80 00       	mov    0x805024,%eax
  8006c5:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8006cb:	a1 24 50 80 00       	mov    0x805024,%eax
  8006d0:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  8006d6:	51                   	push   %ecx
  8006d7:	52                   	push   %edx
  8006d8:	50                   	push   %eax
  8006d9:	68 48 3e 80 00       	push   $0x803e48
  8006de:	e8 1d 03 00 00       	call   800a00 <cprintf>
  8006e3:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006e6:	a1 24 50 80 00       	mov    0x805024,%eax
  8006eb:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8006f1:	83 ec 08             	sub    $0x8,%esp
  8006f4:	50                   	push   %eax
  8006f5:	68 a0 3e 80 00       	push   $0x803ea0
  8006fa:	e8 01 03 00 00       	call   800a00 <cprintf>
  8006ff:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800702:	83 ec 0c             	sub    $0xc,%esp
  800705:	68 f8 3d 80 00       	push   $0x803df8
  80070a:	e8 f1 02 00 00       	call   800a00 <cprintf>
  80070f:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800712:	e8 dd 19 00 00       	call   8020f4 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800717:	e8 19 00 00 00       	call   800735 <exit>
}
  80071c:	90                   	nop
  80071d:	c9                   	leave  
  80071e:	c3                   	ret    

0080071f <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80071f:	55                   	push   %ebp
  800720:	89 e5                	mov    %esp,%ebp
  800722:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800725:	83 ec 0c             	sub    $0xc,%esp
  800728:	6a 00                	push   $0x0
  80072a:	e8 f3 1b 00 00       	call   802322 <sys_destroy_env>
  80072f:	83 c4 10             	add    $0x10,%esp
}
  800732:	90                   	nop
  800733:	c9                   	leave  
  800734:	c3                   	ret    

00800735 <exit>:

void
exit(void)
{
  800735:	55                   	push   %ebp
  800736:	89 e5                	mov    %esp,%ebp
  800738:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80073b:	e8 48 1c 00 00       	call   802388 <sys_exit_env>
}
  800740:	90                   	nop
  800741:	c9                   	leave  
  800742:	c3                   	ret    

00800743 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800743:	55                   	push   %ebp
  800744:	89 e5                	mov    %esp,%ebp
  800746:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800749:	8d 45 10             	lea    0x10(%ebp),%eax
  80074c:	83 c0 04             	add    $0x4,%eax
  80074f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800752:	a1 60 50 98 00       	mov    0x985060,%eax
  800757:	85 c0                	test   %eax,%eax
  800759:	74 16                	je     800771 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80075b:	a1 60 50 98 00       	mov    0x985060,%eax
  800760:	83 ec 08             	sub    $0x8,%esp
  800763:	50                   	push   %eax
  800764:	68 b4 3e 80 00       	push   $0x803eb4
  800769:	e8 92 02 00 00       	call   800a00 <cprintf>
  80076e:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800771:	a1 04 50 80 00       	mov    0x805004,%eax
  800776:	ff 75 0c             	pushl  0xc(%ebp)
  800779:	ff 75 08             	pushl  0x8(%ebp)
  80077c:	50                   	push   %eax
  80077d:	68 b9 3e 80 00       	push   $0x803eb9
  800782:	e8 79 02 00 00       	call   800a00 <cprintf>
  800787:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80078a:	8b 45 10             	mov    0x10(%ebp),%eax
  80078d:	83 ec 08             	sub    $0x8,%esp
  800790:	ff 75 f4             	pushl  -0xc(%ebp)
  800793:	50                   	push   %eax
  800794:	e8 fc 01 00 00       	call   800995 <vcprintf>
  800799:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80079c:	83 ec 08             	sub    $0x8,%esp
  80079f:	6a 00                	push   $0x0
  8007a1:	68 d5 3e 80 00       	push   $0x803ed5
  8007a6:	e8 ea 01 00 00       	call   800995 <vcprintf>
  8007ab:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8007ae:	e8 82 ff ff ff       	call   800735 <exit>

	// should not return here
	while (1) ;
  8007b3:	eb fe                	jmp    8007b3 <_panic+0x70>

008007b5 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8007b5:	55                   	push   %ebp
  8007b6:	89 e5                	mov    %esp,%ebp
  8007b8:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8007bb:	a1 24 50 80 00       	mov    0x805024,%eax
  8007c0:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8007c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007c9:	39 c2                	cmp    %eax,%edx
  8007cb:	74 14                	je     8007e1 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8007cd:	83 ec 04             	sub    $0x4,%esp
  8007d0:	68 d8 3e 80 00       	push   $0x803ed8
  8007d5:	6a 26                	push   $0x26
  8007d7:	68 24 3f 80 00       	push   $0x803f24
  8007dc:	e8 62 ff ff ff       	call   800743 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8007e1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8007e8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8007ef:	e9 c5 00 00 00       	jmp    8008b9 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8007f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007f7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800801:	01 d0                	add    %edx,%eax
  800803:	8b 00                	mov    (%eax),%eax
  800805:	85 c0                	test   %eax,%eax
  800807:	75 08                	jne    800811 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800809:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80080c:	e9 a5 00 00 00       	jmp    8008b6 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800811:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800818:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80081f:	eb 69                	jmp    80088a <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800821:	a1 24 50 80 00       	mov    0x805024,%eax
  800826:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  80082c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80082f:	89 d0                	mov    %edx,%eax
  800831:	01 c0                	add    %eax,%eax
  800833:	01 d0                	add    %edx,%eax
  800835:	c1 e0 03             	shl    $0x3,%eax
  800838:	01 c8                	add    %ecx,%eax
  80083a:	8a 40 04             	mov    0x4(%eax),%al
  80083d:	84 c0                	test   %al,%al
  80083f:	75 46                	jne    800887 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800841:	a1 24 50 80 00       	mov    0x805024,%eax
  800846:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  80084c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80084f:	89 d0                	mov    %edx,%eax
  800851:	01 c0                	add    %eax,%eax
  800853:	01 d0                	add    %edx,%eax
  800855:	c1 e0 03             	shl    $0x3,%eax
  800858:	01 c8                	add    %ecx,%eax
  80085a:	8b 00                	mov    (%eax),%eax
  80085c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80085f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800862:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800867:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800869:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80086c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800873:	8b 45 08             	mov    0x8(%ebp),%eax
  800876:	01 c8                	add    %ecx,%eax
  800878:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80087a:	39 c2                	cmp    %eax,%edx
  80087c:	75 09                	jne    800887 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80087e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800885:	eb 15                	jmp    80089c <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800887:	ff 45 e8             	incl   -0x18(%ebp)
  80088a:	a1 24 50 80 00       	mov    0x805024,%eax
  80088f:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800895:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800898:	39 c2                	cmp    %eax,%edx
  80089a:	77 85                	ja     800821 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80089c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8008a0:	75 14                	jne    8008b6 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8008a2:	83 ec 04             	sub    $0x4,%esp
  8008a5:	68 30 3f 80 00       	push   $0x803f30
  8008aa:	6a 3a                	push   $0x3a
  8008ac:	68 24 3f 80 00       	push   $0x803f24
  8008b1:	e8 8d fe ff ff       	call   800743 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8008b6:	ff 45 f0             	incl   -0x10(%ebp)
  8008b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008bc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8008bf:	0f 8c 2f ff ff ff    	jl     8007f4 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8008c5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008cc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8008d3:	eb 26                	jmp    8008fb <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8008d5:	a1 24 50 80 00       	mov    0x805024,%eax
  8008da:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8008e0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008e3:	89 d0                	mov    %edx,%eax
  8008e5:	01 c0                	add    %eax,%eax
  8008e7:	01 d0                	add    %edx,%eax
  8008e9:	c1 e0 03             	shl    $0x3,%eax
  8008ec:	01 c8                	add    %ecx,%eax
  8008ee:	8a 40 04             	mov    0x4(%eax),%al
  8008f1:	3c 01                	cmp    $0x1,%al
  8008f3:	75 03                	jne    8008f8 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8008f5:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008f8:	ff 45 e0             	incl   -0x20(%ebp)
  8008fb:	a1 24 50 80 00       	mov    0x805024,%eax
  800900:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800906:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800909:	39 c2                	cmp    %eax,%edx
  80090b:	77 c8                	ja     8008d5 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80090d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800910:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800913:	74 14                	je     800929 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800915:	83 ec 04             	sub    $0x4,%esp
  800918:	68 84 3f 80 00       	push   $0x803f84
  80091d:	6a 44                	push   $0x44
  80091f:	68 24 3f 80 00       	push   $0x803f24
  800924:	e8 1a fe ff ff       	call   800743 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800929:	90                   	nop
  80092a:	c9                   	leave  
  80092b:	c3                   	ret    

0080092c <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80092c:	55                   	push   %ebp
  80092d:	89 e5                	mov    %esp,%ebp
  80092f:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800932:	8b 45 0c             	mov    0xc(%ebp),%eax
  800935:	8b 00                	mov    (%eax),%eax
  800937:	8d 48 01             	lea    0x1(%eax),%ecx
  80093a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80093d:	89 0a                	mov    %ecx,(%edx)
  80093f:	8b 55 08             	mov    0x8(%ebp),%edx
  800942:	88 d1                	mov    %dl,%cl
  800944:	8b 55 0c             	mov    0xc(%ebp),%edx
  800947:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80094b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80094e:	8b 00                	mov    (%eax),%eax
  800950:	3d ff 00 00 00       	cmp    $0xff,%eax
  800955:	75 2c                	jne    800983 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800957:	a0 44 50 98 00       	mov    0x985044,%al
  80095c:	0f b6 c0             	movzbl %al,%eax
  80095f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800962:	8b 12                	mov    (%edx),%edx
  800964:	89 d1                	mov    %edx,%ecx
  800966:	8b 55 0c             	mov    0xc(%ebp),%edx
  800969:	83 c2 08             	add    $0x8,%edx
  80096c:	83 ec 04             	sub    $0x4,%esp
  80096f:	50                   	push   %eax
  800970:	51                   	push   %ecx
  800971:	52                   	push   %edx
  800972:	e8 21 17 00 00       	call   802098 <sys_cputs>
  800977:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80097a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80097d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800983:	8b 45 0c             	mov    0xc(%ebp),%eax
  800986:	8b 40 04             	mov    0x4(%eax),%eax
  800989:	8d 50 01             	lea    0x1(%eax),%edx
  80098c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098f:	89 50 04             	mov    %edx,0x4(%eax)
}
  800992:	90                   	nop
  800993:	c9                   	leave  
  800994:	c3                   	ret    

00800995 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800995:	55                   	push   %ebp
  800996:	89 e5                	mov    %esp,%ebp
  800998:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80099e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009a5:	00 00 00 
	b.cnt = 0;
  8009a8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009af:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8009b2:	ff 75 0c             	pushl  0xc(%ebp)
  8009b5:	ff 75 08             	pushl  0x8(%ebp)
  8009b8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009be:	50                   	push   %eax
  8009bf:	68 2c 09 80 00       	push   $0x80092c
  8009c4:	e8 11 02 00 00       	call   800bda <vprintfmt>
  8009c9:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8009cc:	a0 44 50 98 00       	mov    0x985044,%al
  8009d1:	0f b6 c0             	movzbl %al,%eax
  8009d4:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8009da:	83 ec 04             	sub    $0x4,%esp
  8009dd:	50                   	push   %eax
  8009de:	52                   	push   %edx
  8009df:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009e5:	83 c0 08             	add    $0x8,%eax
  8009e8:	50                   	push   %eax
  8009e9:	e8 aa 16 00 00       	call   802098 <sys_cputs>
  8009ee:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8009f1:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
	return b.cnt;
  8009f8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8009fe:	c9                   	leave  
  8009ff:	c3                   	ret    

00800a00 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800a00:	55                   	push   %ebp
  800a01:	89 e5                	mov    %esp,%ebp
  800a03:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a06:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
	va_start(ap, fmt);
  800a0d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a10:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a13:	8b 45 08             	mov    0x8(%ebp),%eax
  800a16:	83 ec 08             	sub    $0x8,%esp
  800a19:	ff 75 f4             	pushl  -0xc(%ebp)
  800a1c:	50                   	push   %eax
  800a1d:	e8 73 ff ff ff       	call   800995 <vcprintf>
  800a22:	83 c4 10             	add    $0x10,%esp
  800a25:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a28:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a2b:	c9                   	leave  
  800a2c:	c3                   	ret    

00800a2d <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800a2d:	55                   	push   %ebp
  800a2e:	89 e5                	mov    %esp,%ebp
  800a30:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800a33:	e8 a2 16 00 00       	call   8020da <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800a38:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a41:	83 ec 08             	sub    $0x8,%esp
  800a44:	ff 75 f4             	pushl  -0xc(%ebp)
  800a47:	50                   	push   %eax
  800a48:	e8 48 ff ff ff       	call   800995 <vcprintf>
  800a4d:	83 c4 10             	add    $0x10,%esp
  800a50:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800a53:	e8 9c 16 00 00       	call   8020f4 <sys_unlock_cons>
	return cnt;
  800a58:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a5b:	c9                   	leave  
  800a5c:	c3                   	ret    

00800a5d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a5d:	55                   	push   %ebp
  800a5e:	89 e5                	mov    %esp,%ebp
  800a60:	53                   	push   %ebx
  800a61:	83 ec 14             	sub    $0x14,%esp
  800a64:	8b 45 10             	mov    0x10(%ebp),%eax
  800a67:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a6a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a70:	8b 45 18             	mov    0x18(%ebp),%eax
  800a73:	ba 00 00 00 00       	mov    $0x0,%edx
  800a78:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a7b:	77 55                	ja     800ad2 <printnum+0x75>
  800a7d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a80:	72 05                	jb     800a87 <printnum+0x2a>
  800a82:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a85:	77 4b                	ja     800ad2 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a87:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a8a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a8d:	8b 45 18             	mov    0x18(%ebp),%eax
  800a90:	ba 00 00 00 00       	mov    $0x0,%edx
  800a95:	52                   	push   %edx
  800a96:	50                   	push   %eax
  800a97:	ff 75 f4             	pushl  -0xc(%ebp)
  800a9a:	ff 75 f0             	pushl  -0x10(%ebp)
  800a9d:	e8 fa 2e 00 00       	call   80399c <__udivdi3>
  800aa2:	83 c4 10             	add    $0x10,%esp
  800aa5:	83 ec 04             	sub    $0x4,%esp
  800aa8:	ff 75 20             	pushl  0x20(%ebp)
  800aab:	53                   	push   %ebx
  800aac:	ff 75 18             	pushl  0x18(%ebp)
  800aaf:	52                   	push   %edx
  800ab0:	50                   	push   %eax
  800ab1:	ff 75 0c             	pushl  0xc(%ebp)
  800ab4:	ff 75 08             	pushl  0x8(%ebp)
  800ab7:	e8 a1 ff ff ff       	call   800a5d <printnum>
  800abc:	83 c4 20             	add    $0x20,%esp
  800abf:	eb 1a                	jmp    800adb <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800ac1:	83 ec 08             	sub    $0x8,%esp
  800ac4:	ff 75 0c             	pushl  0xc(%ebp)
  800ac7:	ff 75 20             	pushl  0x20(%ebp)
  800aca:	8b 45 08             	mov    0x8(%ebp),%eax
  800acd:	ff d0                	call   *%eax
  800acf:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800ad2:	ff 4d 1c             	decl   0x1c(%ebp)
  800ad5:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800ad9:	7f e6                	jg     800ac1 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800adb:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800ade:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ae3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ae6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ae9:	53                   	push   %ebx
  800aea:	51                   	push   %ecx
  800aeb:	52                   	push   %edx
  800aec:	50                   	push   %eax
  800aed:	e8 ba 2f 00 00       	call   803aac <__umoddi3>
  800af2:	83 c4 10             	add    $0x10,%esp
  800af5:	05 f4 41 80 00       	add    $0x8041f4,%eax
  800afa:	8a 00                	mov    (%eax),%al
  800afc:	0f be c0             	movsbl %al,%eax
  800aff:	83 ec 08             	sub    $0x8,%esp
  800b02:	ff 75 0c             	pushl  0xc(%ebp)
  800b05:	50                   	push   %eax
  800b06:	8b 45 08             	mov    0x8(%ebp),%eax
  800b09:	ff d0                	call   *%eax
  800b0b:	83 c4 10             	add    $0x10,%esp
}
  800b0e:	90                   	nop
  800b0f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b12:	c9                   	leave  
  800b13:	c3                   	ret    

00800b14 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b14:	55                   	push   %ebp
  800b15:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b17:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b1b:	7e 1c                	jle    800b39 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b20:	8b 00                	mov    (%eax),%eax
  800b22:	8d 50 08             	lea    0x8(%eax),%edx
  800b25:	8b 45 08             	mov    0x8(%ebp),%eax
  800b28:	89 10                	mov    %edx,(%eax)
  800b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2d:	8b 00                	mov    (%eax),%eax
  800b2f:	83 e8 08             	sub    $0x8,%eax
  800b32:	8b 50 04             	mov    0x4(%eax),%edx
  800b35:	8b 00                	mov    (%eax),%eax
  800b37:	eb 40                	jmp    800b79 <getuint+0x65>
	else if (lflag)
  800b39:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b3d:	74 1e                	je     800b5d <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b42:	8b 00                	mov    (%eax),%eax
  800b44:	8d 50 04             	lea    0x4(%eax),%edx
  800b47:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4a:	89 10                	mov    %edx,(%eax)
  800b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4f:	8b 00                	mov    (%eax),%eax
  800b51:	83 e8 04             	sub    $0x4,%eax
  800b54:	8b 00                	mov    (%eax),%eax
  800b56:	ba 00 00 00 00       	mov    $0x0,%edx
  800b5b:	eb 1c                	jmp    800b79 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b60:	8b 00                	mov    (%eax),%eax
  800b62:	8d 50 04             	lea    0x4(%eax),%edx
  800b65:	8b 45 08             	mov    0x8(%ebp),%eax
  800b68:	89 10                	mov    %edx,(%eax)
  800b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6d:	8b 00                	mov    (%eax),%eax
  800b6f:	83 e8 04             	sub    $0x4,%eax
  800b72:	8b 00                	mov    (%eax),%eax
  800b74:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b79:	5d                   	pop    %ebp
  800b7a:	c3                   	ret    

00800b7b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b7b:	55                   	push   %ebp
  800b7c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b7e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b82:	7e 1c                	jle    800ba0 <getint+0x25>
		return va_arg(*ap, long long);
  800b84:	8b 45 08             	mov    0x8(%ebp),%eax
  800b87:	8b 00                	mov    (%eax),%eax
  800b89:	8d 50 08             	lea    0x8(%eax),%edx
  800b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8f:	89 10                	mov    %edx,(%eax)
  800b91:	8b 45 08             	mov    0x8(%ebp),%eax
  800b94:	8b 00                	mov    (%eax),%eax
  800b96:	83 e8 08             	sub    $0x8,%eax
  800b99:	8b 50 04             	mov    0x4(%eax),%edx
  800b9c:	8b 00                	mov    (%eax),%eax
  800b9e:	eb 38                	jmp    800bd8 <getint+0x5d>
	else if (lflag)
  800ba0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ba4:	74 1a                	je     800bc0 <getint+0x45>
		return va_arg(*ap, long);
  800ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba9:	8b 00                	mov    (%eax),%eax
  800bab:	8d 50 04             	lea    0x4(%eax),%edx
  800bae:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb1:	89 10                	mov    %edx,(%eax)
  800bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb6:	8b 00                	mov    (%eax),%eax
  800bb8:	83 e8 04             	sub    $0x4,%eax
  800bbb:	8b 00                	mov    (%eax),%eax
  800bbd:	99                   	cltd   
  800bbe:	eb 18                	jmp    800bd8 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc3:	8b 00                	mov    (%eax),%eax
  800bc5:	8d 50 04             	lea    0x4(%eax),%edx
  800bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcb:	89 10                	mov    %edx,(%eax)
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	8b 00                	mov    (%eax),%eax
  800bd2:	83 e8 04             	sub    $0x4,%eax
  800bd5:	8b 00                	mov    (%eax),%eax
  800bd7:	99                   	cltd   
}
  800bd8:	5d                   	pop    %ebp
  800bd9:	c3                   	ret    

00800bda <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800bda:	55                   	push   %ebp
  800bdb:	89 e5                	mov    %esp,%ebp
  800bdd:	56                   	push   %esi
  800bde:	53                   	push   %ebx
  800bdf:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800be2:	eb 17                	jmp    800bfb <vprintfmt+0x21>
			if (ch == '\0')
  800be4:	85 db                	test   %ebx,%ebx
  800be6:	0f 84 c1 03 00 00    	je     800fad <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800bec:	83 ec 08             	sub    $0x8,%esp
  800bef:	ff 75 0c             	pushl  0xc(%ebp)
  800bf2:	53                   	push   %ebx
  800bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf6:	ff d0                	call   *%eax
  800bf8:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bfb:	8b 45 10             	mov    0x10(%ebp),%eax
  800bfe:	8d 50 01             	lea    0x1(%eax),%edx
  800c01:	89 55 10             	mov    %edx,0x10(%ebp)
  800c04:	8a 00                	mov    (%eax),%al
  800c06:	0f b6 d8             	movzbl %al,%ebx
  800c09:	83 fb 25             	cmp    $0x25,%ebx
  800c0c:	75 d6                	jne    800be4 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c0e:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c12:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c19:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c20:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c27:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c31:	8d 50 01             	lea    0x1(%eax),%edx
  800c34:	89 55 10             	mov    %edx,0x10(%ebp)
  800c37:	8a 00                	mov    (%eax),%al
  800c39:	0f b6 d8             	movzbl %al,%ebx
  800c3c:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c3f:	83 f8 5b             	cmp    $0x5b,%eax
  800c42:	0f 87 3d 03 00 00    	ja     800f85 <vprintfmt+0x3ab>
  800c48:	8b 04 85 18 42 80 00 	mov    0x804218(,%eax,4),%eax
  800c4f:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c51:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c55:	eb d7                	jmp    800c2e <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c57:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c5b:	eb d1                	jmp    800c2e <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c5d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c64:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c67:	89 d0                	mov    %edx,%eax
  800c69:	c1 e0 02             	shl    $0x2,%eax
  800c6c:	01 d0                	add    %edx,%eax
  800c6e:	01 c0                	add    %eax,%eax
  800c70:	01 d8                	add    %ebx,%eax
  800c72:	83 e8 30             	sub    $0x30,%eax
  800c75:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c78:	8b 45 10             	mov    0x10(%ebp),%eax
  800c7b:	8a 00                	mov    (%eax),%al
  800c7d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c80:	83 fb 2f             	cmp    $0x2f,%ebx
  800c83:	7e 3e                	jle    800cc3 <vprintfmt+0xe9>
  800c85:	83 fb 39             	cmp    $0x39,%ebx
  800c88:	7f 39                	jg     800cc3 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c8a:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c8d:	eb d5                	jmp    800c64 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c8f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c92:	83 c0 04             	add    $0x4,%eax
  800c95:	89 45 14             	mov    %eax,0x14(%ebp)
  800c98:	8b 45 14             	mov    0x14(%ebp),%eax
  800c9b:	83 e8 04             	sub    $0x4,%eax
  800c9e:	8b 00                	mov    (%eax),%eax
  800ca0:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800ca3:	eb 1f                	jmp    800cc4 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800ca5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ca9:	79 83                	jns    800c2e <vprintfmt+0x54>
				width = 0;
  800cab:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800cb2:	e9 77 ff ff ff       	jmp    800c2e <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800cb7:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800cbe:	e9 6b ff ff ff       	jmp    800c2e <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800cc3:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800cc4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cc8:	0f 89 60 ff ff ff    	jns    800c2e <vprintfmt+0x54>
				width = precision, precision = -1;
  800cce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cd1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800cd4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800cdb:	e9 4e ff ff ff       	jmp    800c2e <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ce0:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800ce3:	e9 46 ff ff ff       	jmp    800c2e <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800ce8:	8b 45 14             	mov    0x14(%ebp),%eax
  800ceb:	83 c0 04             	add    $0x4,%eax
  800cee:	89 45 14             	mov    %eax,0x14(%ebp)
  800cf1:	8b 45 14             	mov    0x14(%ebp),%eax
  800cf4:	83 e8 04             	sub    $0x4,%eax
  800cf7:	8b 00                	mov    (%eax),%eax
  800cf9:	83 ec 08             	sub    $0x8,%esp
  800cfc:	ff 75 0c             	pushl  0xc(%ebp)
  800cff:	50                   	push   %eax
  800d00:	8b 45 08             	mov    0x8(%ebp),%eax
  800d03:	ff d0                	call   *%eax
  800d05:	83 c4 10             	add    $0x10,%esp
			break;
  800d08:	e9 9b 02 00 00       	jmp    800fa8 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d0d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d10:	83 c0 04             	add    $0x4,%eax
  800d13:	89 45 14             	mov    %eax,0x14(%ebp)
  800d16:	8b 45 14             	mov    0x14(%ebp),%eax
  800d19:	83 e8 04             	sub    $0x4,%eax
  800d1c:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d1e:	85 db                	test   %ebx,%ebx
  800d20:	79 02                	jns    800d24 <vprintfmt+0x14a>
				err = -err;
  800d22:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d24:	83 fb 64             	cmp    $0x64,%ebx
  800d27:	7f 0b                	jg     800d34 <vprintfmt+0x15a>
  800d29:	8b 34 9d 60 40 80 00 	mov    0x804060(,%ebx,4),%esi
  800d30:	85 f6                	test   %esi,%esi
  800d32:	75 19                	jne    800d4d <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d34:	53                   	push   %ebx
  800d35:	68 05 42 80 00       	push   $0x804205
  800d3a:	ff 75 0c             	pushl  0xc(%ebp)
  800d3d:	ff 75 08             	pushl  0x8(%ebp)
  800d40:	e8 70 02 00 00       	call   800fb5 <printfmt>
  800d45:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d48:	e9 5b 02 00 00       	jmp    800fa8 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d4d:	56                   	push   %esi
  800d4e:	68 0e 42 80 00       	push   $0x80420e
  800d53:	ff 75 0c             	pushl  0xc(%ebp)
  800d56:	ff 75 08             	pushl  0x8(%ebp)
  800d59:	e8 57 02 00 00       	call   800fb5 <printfmt>
  800d5e:	83 c4 10             	add    $0x10,%esp
			break;
  800d61:	e9 42 02 00 00       	jmp    800fa8 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d66:	8b 45 14             	mov    0x14(%ebp),%eax
  800d69:	83 c0 04             	add    $0x4,%eax
  800d6c:	89 45 14             	mov    %eax,0x14(%ebp)
  800d6f:	8b 45 14             	mov    0x14(%ebp),%eax
  800d72:	83 e8 04             	sub    $0x4,%eax
  800d75:	8b 30                	mov    (%eax),%esi
  800d77:	85 f6                	test   %esi,%esi
  800d79:	75 05                	jne    800d80 <vprintfmt+0x1a6>
				p = "(null)";
  800d7b:	be 11 42 80 00       	mov    $0x804211,%esi
			if (width > 0 && padc != '-')
  800d80:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d84:	7e 6d                	jle    800df3 <vprintfmt+0x219>
  800d86:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d8a:	74 67                	je     800df3 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d8c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d8f:	83 ec 08             	sub    $0x8,%esp
  800d92:	50                   	push   %eax
  800d93:	56                   	push   %esi
  800d94:	e8 26 05 00 00       	call   8012bf <strnlen>
  800d99:	83 c4 10             	add    $0x10,%esp
  800d9c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d9f:	eb 16                	jmp    800db7 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800da1:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800da5:	83 ec 08             	sub    $0x8,%esp
  800da8:	ff 75 0c             	pushl  0xc(%ebp)
  800dab:	50                   	push   %eax
  800dac:	8b 45 08             	mov    0x8(%ebp),%eax
  800daf:	ff d0                	call   *%eax
  800db1:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800db4:	ff 4d e4             	decl   -0x1c(%ebp)
  800db7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dbb:	7f e4                	jg     800da1 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dbd:	eb 34                	jmp    800df3 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800dbf:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800dc3:	74 1c                	je     800de1 <vprintfmt+0x207>
  800dc5:	83 fb 1f             	cmp    $0x1f,%ebx
  800dc8:	7e 05                	jle    800dcf <vprintfmt+0x1f5>
  800dca:	83 fb 7e             	cmp    $0x7e,%ebx
  800dcd:	7e 12                	jle    800de1 <vprintfmt+0x207>
					putch('?', putdat);
  800dcf:	83 ec 08             	sub    $0x8,%esp
  800dd2:	ff 75 0c             	pushl  0xc(%ebp)
  800dd5:	6a 3f                	push   $0x3f
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dda:	ff d0                	call   *%eax
  800ddc:	83 c4 10             	add    $0x10,%esp
  800ddf:	eb 0f                	jmp    800df0 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800de1:	83 ec 08             	sub    $0x8,%esp
  800de4:	ff 75 0c             	pushl  0xc(%ebp)
  800de7:	53                   	push   %ebx
  800de8:	8b 45 08             	mov    0x8(%ebp),%eax
  800deb:	ff d0                	call   *%eax
  800ded:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800df0:	ff 4d e4             	decl   -0x1c(%ebp)
  800df3:	89 f0                	mov    %esi,%eax
  800df5:	8d 70 01             	lea    0x1(%eax),%esi
  800df8:	8a 00                	mov    (%eax),%al
  800dfa:	0f be d8             	movsbl %al,%ebx
  800dfd:	85 db                	test   %ebx,%ebx
  800dff:	74 24                	je     800e25 <vprintfmt+0x24b>
  800e01:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e05:	78 b8                	js     800dbf <vprintfmt+0x1e5>
  800e07:	ff 4d e0             	decl   -0x20(%ebp)
  800e0a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e0e:	79 af                	jns    800dbf <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e10:	eb 13                	jmp    800e25 <vprintfmt+0x24b>
				putch(' ', putdat);
  800e12:	83 ec 08             	sub    $0x8,%esp
  800e15:	ff 75 0c             	pushl  0xc(%ebp)
  800e18:	6a 20                	push   $0x20
  800e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1d:	ff d0                	call   *%eax
  800e1f:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e22:	ff 4d e4             	decl   -0x1c(%ebp)
  800e25:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e29:	7f e7                	jg     800e12 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e2b:	e9 78 01 00 00       	jmp    800fa8 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e30:	83 ec 08             	sub    $0x8,%esp
  800e33:	ff 75 e8             	pushl  -0x18(%ebp)
  800e36:	8d 45 14             	lea    0x14(%ebp),%eax
  800e39:	50                   	push   %eax
  800e3a:	e8 3c fd ff ff       	call   800b7b <getint>
  800e3f:	83 c4 10             	add    $0x10,%esp
  800e42:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e45:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e4b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e4e:	85 d2                	test   %edx,%edx
  800e50:	79 23                	jns    800e75 <vprintfmt+0x29b>
				putch('-', putdat);
  800e52:	83 ec 08             	sub    $0x8,%esp
  800e55:	ff 75 0c             	pushl  0xc(%ebp)
  800e58:	6a 2d                	push   $0x2d
  800e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5d:	ff d0                	call   *%eax
  800e5f:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e65:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e68:	f7 d8                	neg    %eax
  800e6a:	83 d2 00             	adc    $0x0,%edx
  800e6d:	f7 da                	neg    %edx
  800e6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e72:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e75:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e7c:	e9 bc 00 00 00       	jmp    800f3d <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e81:	83 ec 08             	sub    $0x8,%esp
  800e84:	ff 75 e8             	pushl  -0x18(%ebp)
  800e87:	8d 45 14             	lea    0x14(%ebp),%eax
  800e8a:	50                   	push   %eax
  800e8b:	e8 84 fc ff ff       	call   800b14 <getuint>
  800e90:	83 c4 10             	add    $0x10,%esp
  800e93:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e96:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e99:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ea0:	e9 98 00 00 00       	jmp    800f3d <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ea5:	83 ec 08             	sub    $0x8,%esp
  800ea8:	ff 75 0c             	pushl  0xc(%ebp)
  800eab:	6a 58                	push   $0x58
  800ead:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb0:	ff d0                	call   *%eax
  800eb2:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800eb5:	83 ec 08             	sub    $0x8,%esp
  800eb8:	ff 75 0c             	pushl  0xc(%ebp)
  800ebb:	6a 58                	push   $0x58
  800ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec0:	ff d0                	call   *%eax
  800ec2:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ec5:	83 ec 08             	sub    $0x8,%esp
  800ec8:	ff 75 0c             	pushl  0xc(%ebp)
  800ecb:	6a 58                	push   $0x58
  800ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed0:	ff d0                	call   *%eax
  800ed2:	83 c4 10             	add    $0x10,%esp
			break;
  800ed5:	e9 ce 00 00 00       	jmp    800fa8 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800eda:	83 ec 08             	sub    $0x8,%esp
  800edd:	ff 75 0c             	pushl  0xc(%ebp)
  800ee0:	6a 30                	push   $0x30
  800ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee5:	ff d0                	call   *%eax
  800ee7:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800eea:	83 ec 08             	sub    $0x8,%esp
  800eed:	ff 75 0c             	pushl  0xc(%ebp)
  800ef0:	6a 78                	push   $0x78
  800ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef5:	ff d0                	call   *%eax
  800ef7:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800efa:	8b 45 14             	mov    0x14(%ebp),%eax
  800efd:	83 c0 04             	add    $0x4,%eax
  800f00:	89 45 14             	mov    %eax,0x14(%ebp)
  800f03:	8b 45 14             	mov    0x14(%ebp),%eax
  800f06:	83 e8 04             	sub    $0x4,%eax
  800f09:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f0e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f15:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f1c:	eb 1f                	jmp    800f3d <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f1e:	83 ec 08             	sub    $0x8,%esp
  800f21:	ff 75 e8             	pushl  -0x18(%ebp)
  800f24:	8d 45 14             	lea    0x14(%ebp),%eax
  800f27:	50                   	push   %eax
  800f28:	e8 e7 fb ff ff       	call   800b14 <getuint>
  800f2d:	83 c4 10             	add    $0x10,%esp
  800f30:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f33:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f36:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f3d:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f44:	83 ec 04             	sub    $0x4,%esp
  800f47:	52                   	push   %edx
  800f48:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f4b:	50                   	push   %eax
  800f4c:	ff 75 f4             	pushl  -0xc(%ebp)
  800f4f:	ff 75 f0             	pushl  -0x10(%ebp)
  800f52:	ff 75 0c             	pushl  0xc(%ebp)
  800f55:	ff 75 08             	pushl  0x8(%ebp)
  800f58:	e8 00 fb ff ff       	call   800a5d <printnum>
  800f5d:	83 c4 20             	add    $0x20,%esp
			break;
  800f60:	eb 46                	jmp    800fa8 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f62:	83 ec 08             	sub    $0x8,%esp
  800f65:	ff 75 0c             	pushl  0xc(%ebp)
  800f68:	53                   	push   %ebx
  800f69:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6c:	ff d0                	call   *%eax
  800f6e:	83 c4 10             	add    $0x10,%esp
			break;
  800f71:	eb 35                	jmp    800fa8 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800f73:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
			break;
  800f7a:	eb 2c                	jmp    800fa8 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800f7c:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
			break;
  800f83:	eb 23                	jmp    800fa8 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f85:	83 ec 08             	sub    $0x8,%esp
  800f88:	ff 75 0c             	pushl  0xc(%ebp)
  800f8b:	6a 25                	push   $0x25
  800f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f90:	ff d0                	call   *%eax
  800f92:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f95:	ff 4d 10             	decl   0x10(%ebp)
  800f98:	eb 03                	jmp    800f9d <vprintfmt+0x3c3>
  800f9a:	ff 4d 10             	decl   0x10(%ebp)
  800f9d:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa0:	48                   	dec    %eax
  800fa1:	8a 00                	mov    (%eax),%al
  800fa3:	3c 25                	cmp    $0x25,%al
  800fa5:	75 f3                	jne    800f9a <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800fa7:	90                   	nop
		}
	}
  800fa8:	e9 35 fc ff ff       	jmp    800be2 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800fad:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800fae:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fb1:	5b                   	pop    %ebx
  800fb2:	5e                   	pop    %esi
  800fb3:	5d                   	pop    %ebp
  800fb4:	c3                   	ret    

00800fb5 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800fb5:	55                   	push   %ebp
  800fb6:	89 e5                	mov    %esp,%ebp
  800fb8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800fbb:	8d 45 10             	lea    0x10(%ebp),%eax
  800fbe:	83 c0 04             	add    $0x4,%eax
  800fc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800fc4:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc7:	ff 75 f4             	pushl  -0xc(%ebp)
  800fca:	50                   	push   %eax
  800fcb:	ff 75 0c             	pushl  0xc(%ebp)
  800fce:	ff 75 08             	pushl  0x8(%ebp)
  800fd1:	e8 04 fc ff ff       	call   800bda <vprintfmt>
  800fd6:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800fd9:	90                   	nop
  800fda:	c9                   	leave  
  800fdb:	c3                   	ret    

00800fdc <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fdc:	55                   	push   %ebp
  800fdd:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800fdf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe2:	8b 40 08             	mov    0x8(%eax),%eax
  800fe5:	8d 50 01             	lea    0x1(%eax),%edx
  800fe8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800feb:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800fee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff1:	8b 10                	mov    (%eax),%edx
  800ff3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff6:	8b 40 04             	mov    0x4(%eax),%eax
  800ff9:	39 c2                	cmp    %eax,%edx
  800ffb:	73 12                	jae    80100f <sprintputch+0x33>
		*b->buf++ = ch;
  800ffd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801000:	8b 00                	mov    (%eax),%eax
  801002:	8d 48 01             	lea    0x1(%eax),%ecx
  801005:	8b 55 0c             	mov    0xc(%ebp),%edx
  801008:	89 0a                	mov    %ecx,(%edx)
  80100a:	8b 55 08             	mov    0x8(%ebp),%edx
  80100d:	88 10                	mov    %dl,(%eax)
}
  80100f:	90                   	nop
  801010:	5d                   	pop    %ebp
  801011:	c3                   	ret    

00801012 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801012:	55                   	push   %ebp
  801013:	89 e5                	mov    %esp,%ebp
  801015:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801018:	8b 45 08             	mov    0x8(%ebp),%eax
  80101b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80101e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801021:	8d 50 ff             	lea    -0x1(%eax),%edx
  801024:	8b 45 08             	mov    0x8(%ebp),%eax
  801027:	01 d0                	add    %edx,%eax
  801029:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80102c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801033:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801037:	74 06                	je     80103f <vsnprintf+0x2d>
  801039:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80103d:	7f 07                	jg     801046 <vsnprintf+0x34>
		return -E_INVAL;
  80103f:	b8 03 00 00 00       	mov    $0x3,%eax
  801044:	eb 20                	jmp    801066 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801046:	ff 75 14             	pushl  0x14(%ebp)
  801049:	ff 75 10             	pushl  0x10(%ebp)
  80104c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80104f:	50                   	push   %eax
  801050:	68 dc 0f 80 00       	push   $0x800fdc
  801055:	e8 80 fb ff ff       	call   800bda <vprintfmt>
  80105a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80105d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801060:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801063:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801066:	c9                   	leave  
  801067:	c3                   	ret    

00801068 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801068:	55                   	push   %ebp
  801069:	89 e5                	mov    %esp,%ebp
  80106b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80106e:	8d 45 10             	lea    0x10(%ebp),%eax
  801071:	83 c0 04             	add    $0x4,%eax
  801074:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801077:	8b 45 10             	mov    0x10(%ebp),%eax
  80107a:	ff 75 f4             	pushl  -0xc(%ebp)
  80107d:	50                   	push   %eax
  80107e:	ff 75 0c             	pushl  0xc(%ebp)
  801081:	ff 75 08             	pushl  0x8(%ebp)
  801084:	e8 89 ff ff ff       	call   801012 <vsnprintf>
  801089:	83 c4 10             	add    $0x10,%esp
  80108c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80108f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801092:	c9                   	leave  
  801093:	c3                   	ret    

00801094 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  801094:	55                   	push   %ebp
  801095:	89 e5                	mov    %esp,%ebp
  801097:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  80109a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80109e:	74 13                	je     8010b3 <readline+0x1f>
		cprintf("%s", prompt);
  8010a0:	83 ec 08             	sub    $0x8,%esp
  8010a3:	ff 75 08             	pushl  0x8(%ebp)
  8010a6:	68 88 43 80 00       	push   $0x804388
  8010ab:	e8 50 f9 ff ff       	call   800a00 <cprintf>
  8010b0:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8010b3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8010ba:	83 ec 0c             	sub    $0xc,%esp
  8010bd:	6a 00                	push   $0x0
  8010bf:	e8 30 f5 ff ff       	call   8005f4 <iscons>
  8010c4:	83 c4 10             	add    $0x10,%esp
  8010c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8010ca:	e8 12 f5 ff ff       	call   8005e1 <getchar>
  8010cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8010d2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8010d6:	79 22                	jns    8010fa <readline+0x66>
			if (c != -E_EOF)
  8010d8:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8010dc:	0f 84 ad 00 00 00    	je     80118f <readline+0xfb>
				cprintf("read error: %e\n", c);
  8010e2:	83 ec 08             	sub    $0x8,%esp
  8010e5:	ff 75 ec             	pushl  -0x14(%ebp)
  8010e8:	68 8b 43 80 00       	push   $0x80438b
  8010ed:	e8 0e f9 ff ff       	call   800a00 <cprintf>
  8010f2:	83 c4 10             	add    $0x10,%esp
			break;
  8010f5:	e9 95 00 00 00       	jmp    80118f <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8010fa:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8010fe:	7e 34                	jle    801134 <readline+0xa0>
  801100:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801107:	7f 2b                	jg     801134 <readline+0xa0>
			if (echoing)
  801109:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80110d:	74 0e                	je     80111d <readline+0x89>
				cputchar(c);
  80110f:	83 ec 0c             	sub    $0xc,%esp
  801112:	ff 75 ec             	pushl  -0x14(%ebp)
  801115:	e8 a8 f4 ff ff       	call   8005c2 <cputchar>
  80111a:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  80111d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801120:	8d 50 01             	lea    0x1(%eax),%edx
  801123:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801126:	89 c2                	mov    %eax,%edx
  801128:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112b:	01 d0                	add    %edx,%eax
  80112d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801130:	88 10                	mov    %dl,(%eax)
  801132:	eb 56                	jmp    80118a <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801134:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801138:	75 1f                	jne    801159 <readline+0xc5>
  80113a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80113e:	7e 19                	jle    801159 <readline+0xc5>
			if (echoing)
  801140:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801144:	74 0e                	je     801154 <readline+0xc0>
				cputchar(c);
  801146:	83 ec 0c             	sub    $0xc,%esp
  801149:	ff 75 ec             	pushl  -0x14(%ebp)
  80114c:	e8 71 f4 ff ff       	call   8005c2 <cputchar>
  801151:	83 c4 10             	add    $0x10,%esp

			i--;
  801154:	ff 4d f4             	decl   -0xc(%ebp)
  801157:	eb 31                	jmp    80118a <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801159:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80115d:	74 0a                	je     801169 <readline+0xd5>
  80115f:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801163:	0f 85 61 ff ff ff    	jne    8010ca <readline+0x36>
			if (echoing)
  801169:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80116d:	74 0e                	je     80117d <readline+0xe9>
				cputchar(c);
  80116f:	83 ec 0c             	sub    $0xc,%esp
  801172:	ff 75 ec             	pushl  -0x14(%ebp)
  801175:	e8 48 f4 ff ff       	call   8005c2 <cputchar>
  80117a:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  80117d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801180:	8b 45 0c             	mov    0xc(%ebp),%eax
  801183:	01 d0                	add    %edx,%eax
  801185:	c6 00 00             	movb   $0x0,(%eax)
			break;
  801188:	eb 06                	jmp    801190 <readline+0xfc>
		}
	}
  80118a:	e9 3b ff ff ff       	jmp    8010ca <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  80118f:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  801190:	90                   	nop
  801191:	c9                   	leave  
  801192:	c3                   	ret    

00801193 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  801193:	55                   	push   %ebp
  801194:	89 e5                	mov    %esp,%ebp
  801196:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  801199:	e8 3c 0f 00 00       	call   8020da <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  80119e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011a2:	74 13                	je     8011b7 <atomic_readline+0x24>
			cprintf("%s", prompt);
  8011a4:	83 ec 08             	sub    $0x8,%esp
  8011a7:	ff 75 08             	pushl  0x8(%ebp)
  8011aa:	68 88 43 80 00       	push   $0x804388
  8011af:	e8 4c f8 ff ff       	call   800a00 <cprintf>
  8011b4:	83 c4 10             	add    $0x10,%esp

		i = 0;
  8011b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  8011be:	83 ec 0c             	sub    $0xc,%esp
  8011c1:	6a 00                	push   $0x0
  8011c3:	e8 2c f4 ff ff       	call   8005f4 <iscons>
  8011c8:	83 c4 10             	add    $0x10,%esp
  8011cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  8011ce:	e8 0e f4 ff ff       	call   8005e1 <getchar>
  8011d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  8011d6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8011da:	79 22                	jns    8011fe <atomic_readline+0x6b>
				if (c != -E_EOF)
  8011dc:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8011e0:	0f 84 ad 00 00 00    	je     801293 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  8011e6:	83 ec 08             	sub    $0x8,%esp
  8011e9:	ff 75 ec             	pushl  -0x14(%ebp)
  8011ec:	68 8b 43 80 00       	push   $0x80438b
  8011f1:	e8 0a f8 ff ff       	call   800a00 <cprintf>
  8011f6:	83 c4 10             	add    $0x10,%esp
				break;
  8011f9:	e9 95 00 00 00       	jmp    801293 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  8011fe:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801202:	7e 34                	jle    801238 <atomic_readline+0xa5>
  801204:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80120b:	7f 2b                	jg     801238 <atomic_readline+0xa5>
				if (echoing)
  80120d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801211:	74 0e                	je     801221 <atomic_readline+0x8e>
					cputchar(c);
  801213:	83 ec 0c             	sub    $0xc,%esp
  801216:	ff 75 ec             	pushl  -0x14(%ebp)
  801219:	e8 a4 f3 ff ff       	call   8005c2 <cputchar>
  80121e:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  801221:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801224:	8d 50 01             	lea    0x1(%eax),%edx
  801227:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80122a:	89 c2                	mov    %eax,%edx
  80122c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122f:	01 d0                	add    %edx,%eax
  801231:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801234:	88 10                	mov    %dl,(%eax)
  801236:	eb 56                	jmp    80128e <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  801238:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80123c:	75 1f                	jne    80125d <atomic_readline+0xca>
  80123e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801242:	7e 19                	jle    80125d <atomic_readline+0xca>
				if (echoing)
  801244:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801248:	74 0e                	je     801258 <atomic_readline+0xc5>
					cputchar(c);
  80124a:	83 ec 0c             	sub    $0xc,%esp
  80124d:	ff 75 ec             	pushl  -0x14(%ebp)
  801250:	e8 6d f3 ff ff       	call   8005c2 <cputchar>
  801255:	83 c4 10             	add    $0x10,%esp
				i--;
  801258:	ff 4d f4             	decl   -0xc(%ebp)
  80125b:	eb 31                	jmp    80128e <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  80125d:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801261:	74 0a                	je     80126d <atomic_readline+0xda>
  801263:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801267:	0f 85 61 ff ff ff    	jne    8011ce <atomic_readline+0x3b>
				if (echoing)
  80126d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801271:	74 0e                	je     801281 <atomic_readline+0xee>
					cputchar(c);
  801273:	83 ec 0c             	sub    $0xc,%esp
  801276:	ff 75 ec             	pushl  -0x14(%ebp)
  801279:	e8 44 f3 ff ff       	call   8005c2 <cputchar>
  80127e:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  801281:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801284:	8b 45 0c             	mov    0xc(%ebp),%eax
  801287:	01 d0                	add    %edx,%eax
  801289:	c6 00 00             	movb   $0x0,(%eax)
				break;
  80128c:	eb 06                	jmp    801294 <atomic_readline+0x101>
			}
		}
  80128e:	e9 3b ff ff ff       	jmp    8011ce <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  801293:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  801294:	e8 5b 0e 00 00       	call   8020f4 <sys_unlock_cons>
}
  801299:	90                   	nop
  80129a:	c9                   	leave  
  80129b:	c3                   	ret    

0080129c <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  80129c:	55                   	push   %ebp
  80129d:	89 e5                	mov    %esp,%ebp
  80129f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8012a2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012a9:	eb 06                	jmp    8012b1 <strlen+0x15>
		n++;
  8012ab:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012ae:	ff 45 08             	incl   0x8(%ebp)
  8012b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b4:	8a 00                	mov    (%eax),%al
  8012b6:	84 c0                	test   %al,%al
  8012b8:	75 f1                	jne    8012ab <strlen+0xf>
		n++;
	return n;
  8012ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012bd:	c9                   	leave  
  8012be:	c3                   	ret    

008012bf <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8012bf:	55                   	push   %ebp
  8012c0:	89 e5                	mov    %esp,%ebp
  8012c2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012cc:	eb 09                	jmp    8012d7 <strnlen+0x18>
		n++;
  8012ce:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012d1:	ff 45 08             	incl   0x8(%ebp)
  8012d4:	ff 4d 0c             	decl   0xc(%ebp)
  8012d7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012db:	74 09                	je     8012e6 <strnlen+0x27>
  8012dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e0:	8a 00                	mov    (%eax),%al
  8012e2:	84 c0                	test   %al,%al
  8012e4:	75 e8                	jne    8012ce <strnlen+0xf>
		n++;
	return n;
  8012e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012e9:	c9                   	leave  
  8012ea:	c3                   	ret    

008012eb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8012eb:	55                   	push   %ebp
  8012ec:	89 e5                	mov    %esp,%ebp
  8012ee:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8012f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8012f7:	90                   	nop
  8012f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fb:	8d 50 01             	lea    0x1(%eax),%edx
  8012fe:	89 55 08             	mov    %edx,0x8(%ebp)
  801301:	8b 55 0c             	mov    0xc(%ebp),%edx
  801304:	8d 4a 01             	lea    0x1(%edx),%ecx
  801307:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80130a:	8a 12                	mov    (%edx),%dl
  80130c:	88 10                	mov    %dl,(%eax)
  80130e:	8a 00                	mov    (%eax),%al
  801310:	84 c0                	test   %al,%al
  801312:	75 e4                	jne    8012f8 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801314:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801317:	c9                   	leave  
  801318:	c3                   	ret    

00801319 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801319:	55                   	push   %ebp
  80131a:	89 e5                	mov    %esp,%ebp
  80131c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80131f:	8b 45 08             	mov    0x8(%ebp),%eax
  801322:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801325:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80132c:	eb 1f                	jmp    80134d <strncpy+0x34>
		*dst++ = *src;
  80132e:	8b 45 08             	mov    0x8(%ebp),%eax
  801331:	8d 50 01             	lea    0x1(%eax),%edx
  801334:	89 55 08             	mov    %edx,0x8(%ebp)
  801337:	8b 55 0c             	mov    0xc(%ebp),%edx
  80133a:	8a 12                	mov    (%edx),%dl
  80133c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80133e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801341:	8a 00                	mov    (%eax),%al
  801343:	84 c0                	test   %al,%al
  801345:	74 03                	je     80134a <strncpy+0x31>
			src++;
  801347:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80134a:	ff 45 fc             	incl   -0x4(%ebp)
  80134d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801350:	3b 45 10             	cmp    0x10(%ebp),%eax
  801353:	72 d9                	jb     80132e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801355:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801358:	c9                   	leave  
  801359:	c3                   	ret    

0080135a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80135a:	55                   	push   %ebp
  80135b:	89 e5                	mov    %esp,%ebp
  80135d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801360:	8b 45 08             	mov    0x8(%ebp),%eax
  801363:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801366:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80136a:	74 30                	je     80139c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80136c:	eb 16                	jmp    801384 <strlcpy+0x2a>
			*dst++ = *src++;
  80136e:	8b 45 08             	mov    0x8(%ebp),%eax
  801371:	8d 50 01             	lea    0x1(%eax),%edx
  801374:	89 55 08             	mov    %edx,0x8(%ebp)
  801377:	8b 55 0c             	mov    0xc(%ebp),%edx
  80137a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80137d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801380:	8a 12                	mov    (%edx),%dl
  801382:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801384:	ff 4d 10             	decl   0x10(%ebp)
  801387:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80138b:	74 09                	je     801396 <strlcpy+0x3c>
  80138d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801390:	8a 00                	mov    (%eax),%al
  801392:	84 c0                	test   %al,%al
  801394:	75 d8                	jne    80136e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801396:	8b 45 08             	mov    0x8(%ebp),%eax
  801399:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80139c:	8b 55 08             	mov    0x8(%ebp),%edx
  80139f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013a2:	29 c2                	sub    %eax,%edx
  8013a4:	89 d0                	mov    %edx,%eax
}
  8013a6:	c9                   	leave  
  8013a7:	c3                   	ret    

008013a8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8013a8:	55                   	push   %ebp
  8013a9:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8013ab:	eb 06                	jmp    8013b3 <strcmp+0xb>
		p++, q++;
  8013ad:	ff 45 08             	incl   0x8(%ebp)
  8013b0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8013b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b6:	8a 00                	mov    (%eax),%al
  8013b8:	84 c0                	test   %al,%al
  8013ba:	74 0e                	je     8013ca <strcmp+0x22>
  8013bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bf:	8a 10                	mov    (%eax),%dl
  8013c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c4:	8a 00                	mov    (%eax),%al
  8013c6:	38 c2                	cmp    %al,%dl
  8013c8:	74 e3                	je     8013ad <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cd:	8a 00                	mov    (%eax),%al
  8013cf:	0f b6 d0             	movzbl %al,%edx
  8013d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d5:	8a 00                	mov    (%eax),%al
  8013d7:	0f b6 c0             	movzbl %al,%eax
  8013da:	29 c2                	sub    %eax,%edx
  8013dc:	89 d0                	mov    %edx,%eax
}
  8013de:	5d                   	pop    %ebp
  8013df:	c3                   	ret    

008013e0 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8013e0:	55                   	push   %ebp
  8013e1:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8013e3:	eb 09                	jmp    8013ee <strncmp+0xe>
		n--, p++, q++;
  8013e5:	ff 4d 10             	decl   0x10(%ebp)
  8013e8:	ff 45 08             	incl   0x8(%ebp)
  8013eb:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8013ee:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013f2:	74 17                	je     80140b <strncmp+0x2b>
  8013f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f7:	8a 00                	mov    (%eax),%al
  8013f9:	84 c0                	test   %al,%al
  8013fb:	74 0e                	je     80140b <strncmp+0x2b>
  8013fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801400:	8a 10                	mov    (%eax),%dl
  801402:	8b 45 0c             	mov    0xc(%ebp),%eax
  801405:	8a 00                	mov    (%eax),%al
  801407:	38 c2                	cmp    %al,%dl
  801409:	74 da                	je     8013e5 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80140b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80140f:	75 07                	jne    801418 <strncmp+0x38>
		return 0;
  801411:	b8 00 00 00 00       	mov    $0x0,%eax
  801416:	eb 14                	jmp    80142c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801418:	8b 45 08             	mov    0x8(%ebp),%eax
  80141b:	8a 00                	mov    (%eax),%al
  80141d:	0f b6 d0             	movzbl %al,%edx
  801420:	8b 45 0c             	mov    0xc(%ebp),%eax
  801423:	8a 00                	mov    (%eax),%al
  801425:	0f b6 c0             	movzbl %al,%eax
  801428:	29 c2                	sub    %eax,%edx
  80142a:	89 d0                	mov    %edx,%eax
}
  80142c:	5d                   	pop    %ebp
  80142d:	c3                   	ret    

0080142e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80142e:	55                   	push   %ebp
  80142f:	89 e5                	mov    %esp,%ebp
  801431:	83 ec 04             	sub    $0x4,%esp
  801434:	8b 45 0c             	mov    0xc(%ebp),%eax
  801437:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80143a:	eb 12                	jmp    80144e <strchr+0x20>
		if (*s == c)
  80143c:	8b 45 08             	mov    0x8(%ebp),%eax
  80143f:	8a 00                	mov    (%eax),%al
  801441:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801444:	75 05                	jne    80144b <strchr+0x1d>
			return (char *) s;
  801446:	8b 45 08             	mov    0x8(%ebp),%eax
  801449:	eb 11                	jmp    80145c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80144b:	ff 45 08             	incl   0x8(%ebp)
  80144e:	8b 45 08             	mov    0x8(%ebp),%eax
  801451:	8a 00                	mov    (%eax),%al
  801453:	84 c0                	test   %al,%al
  801455:	75 e5                	jne    80143c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801457:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80145c:	c9                   	leave  
  80145d:	c3                   	ret    

0080145e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80145e:	55                   	push   %ebp
  80145f:	89 e5                	mov    %esp,%ebp
  801461:	83 ec 04             	sub    $0x4,%esp
  801464:	8b 45 0c             	mov    0xc(%ebp),%eax
  801467:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80146a:	eb 0d                	jmp    801479 <strfind+0x1b>
		if (*s == c)
  80146c:	8b 45 08             	mov    0x8(%ebp),%eax
  80146f:	8a 00                	mov    (%eax),%al
  801471:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801474:	74 0e                	je     801484 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801476:	ff 45 08             	incl   0x8(%ebp)
  801479:	8b 45 08             	mov    0x8(%ebp),%eax
  80147c:	8a 00                	mov    (%eax),%al
  80147e:	84 c0                	test   %al,%al
  801480:	75 ea                	jne    80146c <strfind+0xe>
  801482:	eb 01                	jmp    801485 <strfind+0x27>
		if (*s == c)
			break;
  801484:	90                   	nop
	return (char *) s;
  801485:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801488:	c9                   	leave  
  801489:	c3                   	ret    

0080148a <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80148a:	55                   	push   %ebp
  80148b:	89 e5                	mov    %esp,%ebp
  80148d:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801490:	8b 45 08             	mov    0x8(%ebp),%eax
  801493:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801496:	8b 45 10             	mov    0x10(%ebp),%eax
  801499:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80149c:	eb 0e                	jmp    8014ac <memset+0x22>
		*p++ = c;
  80149e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014a1:	8d 50 01             	lea    0x1(%eax),%edx
  8014a4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014aa:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8014ac:	ff 4d f8             	decl   -0x8(%ebp)
  8014af:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8014b3:	79 e9                	jns    80149e <memset+0x14>
		*p++ = c;

	return v;
  8014b5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014b8:	c9                   	leave  
  8014b9:	c3                   	ret    

008014ba <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8014ba:	55                   	push   %ebp
  8014bb:	89 e5                	mov    %esp,%ebp
  8014bd:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8014c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8014cc:	eb 16                	jmp    8014e4 <memcpy+0x2a>
		*d++ = *s++;
  8014ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014d1:	8d 50 01             	lea    0x1(%eax),%edx
  8014d4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014d7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014da:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014dd:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8014e0:	8a 12                	mov    (%edx),%dl
  8014e2:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8014e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014ea:	89 55 10             	mov    %edx,0x10(%ebp)
  8014ed:	85 c0                	test   %eax,%eax
  8014ef:	75 dd                	jne    8014ce <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8014f1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014f4:	c9                   	leave  
  8014f5:	c3                   	ret    

008014f6 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8014f6:	55                   	push   %ebp
  8014f7:	89 e5                	mov    %esp,%ebp
  8014f9:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8014fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801502:	8b 45 08             	mov    0x8(%ebp),%eax
  801505:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801508:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80150b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80150e:	73 50                	jae    801560 <memmove+0x6a>
  801510:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801513:	8b 45 10             	mov    0x10(%ebp),%eax
  801516:	01 d0                	add    %edx,%eax
  801518:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80151b:	76 43                	jbe    801560 <memmove+0x6a>
		s += n;
  80151d:	8b 45 10             	mov    0x10(%ebp),%eax
  801520:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801523:	8b 45 10             	mov    0x10(%ebp),%eax
  801526:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801529:	eb 10                	jmp    80153b <memmove+0x45>
			*--d = *--s;
  80152b:	ff 4d f8             	decl   -0x8(%ebp)
  80152e:	ff 4d fc             	decl   -0x4(%ebp)
  801531:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801534:	8a 10                	mov    (%eax),%dl
  801536:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801539:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80153b:	8b 45 10             	mov    0x10(%ebp),%eax
  80153e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801541:	89 55 10             	mov    %edx,0x10(%ebp)
  801544:	85 c0                	test   %eax,%eax
  801546:	75 e3                	jne    80152b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801548:	eb 23                	jmp    80156d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80154a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80154d:	8d 50 01             	lea    0x1(%eax),%edx
  801550:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801553:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801556:	8d 4a 01             	lea    0x1(%edx),%ecx
  801559:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80155c:	8a 12                	mov    (%edx),%dl
  80155e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801560:	8b 45 10             	mov    0x10(%ebp),%eax
  801563:	8d 50 ff             	lea    -0x1(%eax),%edx
  801566:	89 55 10             	mov    %edx,0x10(%ebp)
  801569:	85 c0                	test   %eax,%eax
  80156b:	75 dd                	jne    80154a <memmove+0x54>
			*d++ = *s++;

	return dst;
  80156d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801570:	c9                   	leave  
  801571:	c3                   	ret    

00801572 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801572:	55                   	push   %ebp
  801573:	89 e5                	mov    %esp,%ebp
  801575:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801578:	8b 45 08             	mov    0x8(%ebp),%eax
  80157b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80157e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801581:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801584:	eb 2a                	jmp    8015b0 <memcmp+0x3e>
		if (*s1 != *s2)
  801586:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801589:	8a 10                	mov    (%eax),%dl
  80158b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80158e:	8a 00                	mov    (%eax),%al
  801590:	38 c2                	cmp    %al,%dl
  801592:	74 16                	je     8015aa <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801594:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801597:	8a 00                	mov    (%eax),%al
  801599:	0f b6 d0             	movzbl %al,%edx
  80159c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80159f:	8a 00                	mov    (%eax),%al
  8015a1:	0f b6 c0             	movzbl %al,%eax
  8015a4:	29 c2                	sub    %eax,%edx
  8015a6:	89 d0                	mov    %edx,%eax
  8015a8:	eb 18                	jmp    8015c2 <memcmp+0x50>
		s1++, s2++;
  8015aa:	ff 45 fc             	incl   -0x4(%ebp)
  8015ad:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8015b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015b6:	89 55 10             	mov    %edx,0x10(%ebp)
  8015b9:	85 c0                	test   %eax,%eax
  8015bb:	75 c9                	jne    801586 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015c2:	c9                   	leave  
  8015c3:	c3                   	ret    

008015c4 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8015c4:	55                   	push   %ebp
  8015c5:	89 e5                	mov    %esp,%ebp
  8015c7:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8015ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8015cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d0:	01 d0                	add    %edx,%eax
  8015d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8015d5:	eb 15                	jmp    8015ec <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8015d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015da:	8a 00                	mov    (%eax),%al
  8015dc:	0f b6 d0             	movzbl %al,%edx
  8015df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e2:	0f b6 c0             	movzbl %al,%eax
  8015e5:	39 c2                	cmp    %eax,%edx
  8015e7:	74 0d                	je     8015f6 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8015e9:	ff 45 08             	incl   0x8(%ebp)
  8015ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ef:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8015f2:	72 e3                	jb     8015d7 <memfind+0x13>
  8015f4:	eb 01                	jmp    8015f7 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8015f6:	90                   	nop
	return (void *) s;
  8015f7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015fa:	c9                   	leave  
  8015fb:	c3                   	ret    

008015fc <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015fc:	55                   	push   %ebp
  8015fd:	89 e5                	mov    %esp,%ebp
  8015ff:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801602:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801609:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801610:	eb 03                	jmp    801615 <strtol+0x19>
		s++;
  801612:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801615:	8b 45 08             	mov    0x8(%ebp),%eax
  801618:	8a 00                	mov    (%eax),%al
  80161a:	3c 20                	cmp    $0x20,%al
  80161c:	74 f4                	je     801612 <strtol+0x16>
  80161e:	8b 45 08             	mov    0x8(%ebp),%eax
  801621:	8a 00                	mov    (%eax),%al
  801623:	3c 09                	cmp    $0x9,%al
  801625:	74 eb                	je     801612 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801627:	8b 45 08             	mov    0x8(%ebp),%eax
  80162a:	8a 00                	mov    (%eax),%al
  80162c:	3c 2b                	cmp    $0x2b,%al
  80162e:	75 05                	jne    801635 <strtol+0x39>
		s++;
  801630:	ff 45 08             	incl   0x8(%ebp)
  801633:	eb 13                	jmp    801648 <strtol+0x4c>
	else if (*s == '-')
  801635:	8b 45 08             	mov    0x8(%ebp),%eax
  801638:	8a 00                	mov    (%eax),%al
  80163a:	3c 2d                	cmp    $0x2d,%al
  80163c:	75 0a                	jne    801648 <strtol+0x4c>
		s++, neg = 1;
  80163e:	ff 45 08             	incl   0x8(%ebp)
  801641:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801648:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80164c:	74 06                	je     801654 <strtol+0x58>
  80164e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801652:	75 20                	jne    801674 <strtol+0x78>
  801654:	8b 45 08             	mov    0x8(%ebp),%eax
  801657:	8a 00                	mov    (%eax),%al
  801659:	3c 30                	cmp    $0x30,%al
  80165b:	75 17                	jne    801674 <strtol+0x78>
  80165d:	8b 45 08             	mov    0x8(%ebp),%eax
  801660:	40                   	inc    %eax
  801661:	8a 00                	mov    (%eax),%al
  801663:	3c 78                	cmp    $0x78,%al
  801665:	75 0d                	jne    801674 <strtol+0x78>
		s += 2, base = 16;
  801667:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80166b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801672:	eb 28                	jmp    80169c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801674:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801678:	75 15                	jne    80168f <strtol+0x93>
  80167a:	8b 45 08             	mov    0x8(%ebp),%eax
  80167d:	8a 00                	mov    (%eax),%al
  80167f:	3c 30                	cmp    $0x30,%al
  801681:	75 0c                	jne    80168f <strtol+0x93>
		s++, base = 8;
  801683:	ff 45 08             	incl   0x8(%ebp)
  801686:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80168d:	eb 0d                	jmp    80169c <strtol+0xa0>
	else if (base == 0)
  80168f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801693:	75 07                	jne    80169c <strtol+0xa0>
		base = 10;
  801695:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80169c:	8b 45 08             	mov    0x8(%ebp),%eax
  80169f:	8a 00                	mov    (%eax),%al
  8016a1:	3c 2f                	cmp    $0x2f,%al
  8016a3:	7e 19                	jle    8016be <strtol+0xc2>
  8016a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a8:	8a 00                	mov    (%eax),%al
  8016aa:	3c 39                	cmp    $0x39,%al
  8016ac:	7f 10                	jg     8016be <strtol+0xc2>
			dig = *s - '0';
  8016ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b1:	8a 00                	mov    (%eax),%al
  8016b3:	0f be c0             	movsbl %al,%eax
  8016b6:	83 e8 30             	sub    $0x30,%eax
  8016b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016bc:	eb 42                	jmp    801700 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8016be:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c1:	8a 00                	mov    (%eax),%al
  8016c3:	3c 60                	cmp    $0x60,%al
  8016c5:	7e 19                	jle    8016e0 <strtol+0xe4>
  8016c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ca:	8a 00                	mov    (%eax),%al
  8016cc:	3c 7a                	cmp    $0x7a,%al
  8016ce:	7f 10                	jg     8016e0 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8016d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d3:	8a 00                	mov    (%eax),%al
  8016d5:	0f be c0             	movsbl %al,%eax
  8016d8:	83 e8 57             	sub    $0x57,%eax
  8016db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016de:	eb 20                	jmp    801700 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8016e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e3:	8a 00                	mov    (%eax),%al
  8016e5:	3c 40                	cmp    $0x40,%al
  8016e7:	7e 39                	jle    801722 <strtol+0x126>
  8016e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ec:	8a 00                	mov    (%eax),%al
  8016ee:	3c 5a                	cmp    $0x5a,%al
  8016f0:	7f 30                	jg     801722 <strtol+0x126>
			dig = *s - 'A' + 10;
  8016f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f5:	8a 00                	mov    (%eax),%al
  8016f7:	0f be c0             	movsbl %al,%eax
  8016fa:	83 e8 37             	sub    $0x37,%eax
  8016fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801700:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801703:	3b 45 10             	cmp    0x10(%ebp),%eax
  801706:	7d 19                	jge    801721 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801708:	ff 45 08             	incl   0x8(%ebp)
  80170b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80170e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801712:	89 c2                	mov    %eax,%edx
  801714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801717:	01 d0                	add    %edx,%eax
  801719:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80171c:	e9 7b ff ff ff       	jmp    80169c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801721:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801722:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801726:	74 08                	je     801730 <strtol+0x134>
		*endptr = (char *) s;
  801728:	8b 45 0c             	mov    0xc(%ebp),%eax
  80172b:	8b 55 08             	mov    0x8(%ebp),%edx
  80172e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801730:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801734:	74 07                	je     80173d <strtol+0x141>
  801736:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801739:	f7 d8                	neg    %eax
  80173b:	eb 03                	jmp    801740 <strtol+0x144>
  80173d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801740:	c9                   	leave  
  801741:	c3                   	ret    

00801742 <ltostr>:

void
ltostr(long value, char *str)
{
  801742:	55                   	push   %ebp
  801743:	89 e5                	mov    %esp,%ebp
  801745:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801748:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80174f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801756:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80175a:	79 13                	jns    80176f <ltostr+0x2d>
	{
		neg = 1;
  80175c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801763:	8b 45 0c             	mov    0xc(%ebp),%eax
  801766:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801769:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80176c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80176f:	8b 45 08             	mov    0x8(%ebp),%eax
  801772:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801777:	99                   	cltd   
  801778:	f7 f9                	idiv   %ecx
  80177a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80177d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801780:	8d 50 01             	lea    0x1(%eax),%edx
  801783:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801786:	89 c2                	mov    %eax,%edx
  801788:	8b 45 0c             	mov    0xc(%ebp),%eax
  80178b:	01 d0                	add    %edx,%eax
  80178d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801790:	83 c2 30             	add    $0x30,%edx
  801793:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801795:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801798:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80179d:	f7 e9                	imul   %ecx
  80179f:	c1 fa 02             	sar    $0x2,%edx
  8017a2:	89 c8                	mov    %ecx,%eax
  8017a4:	c1 f8 1f             	sar    $0x1f,%eax
  8017a7:	29 c2                	sub    %eax,%edx
  8017a9:	89 d0                	mov    %edx,%eax
  8017ab:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8017ae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8017b2:	75 bb                	jne    80176f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8017b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8017bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017be:	48                   	dec    %eax
  8017bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8017c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8017c6:	74 3d                	je     801805 <ltostr+0xc3>
		start = 1 ;
  8017c8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8017cf:	eb 34                	jmp    801805 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8017d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d7:	01 d0                	add    %edx,%eax
  8017d9:	8a 00                	mov    (%eax),%al
  8017db:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8017de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e4:	01 c2                	add    %eax,%edx
  8017e6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8017e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ec:	01 c8                	add    %ecx,%eax
  8017ee:	8a 00                	mov    (%eax),%al
  8017f0:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8017f2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f8:	01 c2                	add    %eax,%edx
  8017fa:	8a 45 eb             	mov    -0x15(%ebp),%al
  8017fd:	88 02                	mov    %al,(%edx)
		start++ ;
  8017ff:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801802:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801805:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801808:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80180b:	7c c4                	jl     8017d1 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80180d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801810:	8b 45 0c             	mov    0xc(%ebp),%eax
  801813:	01 d0                	add    %edx,%eax
  801815:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801818:	90                   	nop
  801819:	c9                   	leave  
  80181a:	c3                   	ret    

0080181b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80181b:	55                   	push   %ebp
  80181c:	89 e5                	mov    %esp,%ebp
  80181e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801821:	ff 75 08             	pushl  0x8(%ebp)
  801824:	e8 73 fa ff ff       	call   80129c <strlen>
  801829:	83 c4 04             	add    $0x4,%esp
  80182c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80182f:	ff 75 0c             	pushl  0xc(%ebp)
  801832:	e8 65 fa ff ff       	call   80129c <strlen>
  801837:	83 c4 04             	add    $0x4,%esp
  80183a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80183d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801844:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80184b:	eb 17                	jmp    801864 <strcconcat+0x49>
		final[s] = str1[s] ;
  80184d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801850:	8b 45 10             	mov    0x10(%ebp),%eax
  801853:	01 c2                	add    %eax,%edx
  801855:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801858:	8b 45 08             	mov    0x8(%ebp),%eax
  80185b:	01 c8                	add    %ecx,%eax
  80185d:	8a 00                	mov    (%eax),%al
  80185f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801861:	ff 45 fc             	incl   -0x4(%ebp)
  801864:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801867:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80186a:	7c e1                	jl     80184d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80186c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801873:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80187a:	eb 1f                	jmp    80189b <strcconcat+0x80>
		final[s++] = str2[i] ;
  80187c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80187f:	8d 50 01             	lea    0x1(%eax),%edx
  801882:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801885:	89 c2                	mov    %eax,%edx
  801887:	8b 45 10             	mov    0x10(%ebp),%eax
  80188a:	01 c2                	add    %eax,%edx
  80188c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80188f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801892:	01 c8                	add    %ecx,%eax
  801894:	8a 00                	mov    (%eax),%al
  801896:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801898:	ff 45 f8             	incl   -0x8(%ebp)
  80189b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80189e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018a1:	7c d9                	jl     80187c <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8018a3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8018a9:	01 d0                	add    %edx,%eax
  8018ab:	c6 00 00             	movb   $0x0,(%eax)
}
  8018ae:	90                   	nop
  8018af:	c9                   	leave  
  8018b0:	c3                   	ret    

008018b1 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8018b1:	55                   	push   %ebp
  8018b2:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8018b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8018b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8018bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8018c0:	8b 00                	mov    (%eax),%eax
  8018c2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8018cc:	01 d0                	add    %edx,%eax
  8018ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018d4:	eb 0c                	jmp    8018e2 <strsplit+0x31>
			*string++ = 0;
  8018d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d9:	8d 50 01             	lea    0x1(%eax),%edx
  8018dc:	89 55 08             	mov    %edx,0x8(%ebp)
  8018df:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e5:	8a 00                	mov    (%eax),%al
  8018e7:	84 c0                	test   %al,%al
  8018e9:	74 18                	je     801903 <strsplit+0x52>
  8018eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ee:	8a 00                	mov    (%eax),%al
  8018f0:	0f be c0             	movsbl %al,%eax
  8018f3:	50                   	push   %eax
  8018f4:	ff 75 0c             	pushl  0xc(%ebp)
  8018f7:	e8 32 fb ff ff       	call   80142e <strchr>
  8018fc:	83 c4 08             	add    $0x8,%esp
  8018ff:	85 c0                	test   %eax,%eax
  801901:	75 d3                	jne    8018d6 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801903:	8b 45 08             	mov    0x8(%ebp),%eax
  801906:	8a 00                	mov    (%eax),%al
  801908:	84 c0                	test   %al,%al
  80190a:	74 5a                	je     801966 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80190c:	8b 45 14             	mov    0x14(%ebp),%eax
  80190f:	8b 00                	mov    (%eax),%eax
  801911:	83 f8 0f             	cmp    $0xf,%eax
  801914:	75 07                	jne    80191d <strsplit+0x6c>
		{
			return 0;
  801916:	b8 00 00 00 00       	mov    $0x0,%eax
  80191b:	eb 66                	jmp    801983 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80191d:	8b 45 14             	mov    0x14(%ebp),%eax
  801920:	8b 00                	mov    (%eax),%eax
  801922:	8d 48 01             	lea    0x1(%eax),%ecx
  801925:	8b 55 14             	mov    0x14(%ebp),%edx
  801928:	89 0a                	mov    %ecx,(%edx)
  80192a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801931:	8b 45 10             	mov    0x10(%ebp),%eax
  801934:	01 c2                	add    %eax,%edx
  801936:	8b 45 08             	mov    0x8(%ebp),%eax
  801939:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80193b:	eb 03                	jmp    801940 <strsplit+0x8f>
			string++;
  80193d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801940:	8b 45 08             	mov    0x8(%ebp),%eax
  801943:	8a 00                	mov    (%eax),%al
  801945:	84 c0                	test   %al,%al
  801947:	74 8b                	je     8018d4 <strsplit+0x23>
  801949:	8b 45 08             	mov    0x8(%ebp),%eax
  80194c:	8a 00                	mov    (%eax),%al
  80194e:	0f be c0             	movsbl %al,%eax
  801951:	50                   	push   %eax
  801952:	ff 75 0c             	pushl  0xc(%ebp)
  801955:	e8 d4 fa ff ff       	call   80142e <strchr>
  80195a:	83 c4 08             	add    $0x8,%esp
  80195d:	85 c0                	test   %eax,%eax
  80195f:	74 dc                	je     80193d <strsplit+0x8c>
			string++;
	}
  801961:	e9 6e ff ff ff       	jmp    8018d4 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801966:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801967:	8b 45 14             	mov    0x14(%ebp),%eax
  80196a:	8b 00                	mov    (%eax),%eax
  80196c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801973:	8b 45 10             	mov    0x10(%ebp),%eax
  801976:	01 d0                	add    %edx,%eax
  801978:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80197e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801983:	c9                   	leave  
  801984:	c3                   	ret    

00801985 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801985:	55                   	push   %ebp
  801986:	89 e5                	mov    %esp,%ebp
  801988:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  80198b:	83 ec 04             	sub    $0x4,%esp
  80198e:	68 9c 43 80 00       	push   $0x80439c
  801993:	68 3f 01 00 00       	push   $0x13f
  801998:	68 be 43 80 00       	push   $0x8043be
  80199d:	e8 a1 ed ff ff       	call   800743 <_panic>

008019a2 <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  8019a2:	55                   	push   %ebp
  8019a3:	89 e5                	mov    %esp,%ebp
  8019a5:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  8019a8:	83 ec 0c             	sub    $0xc,%esp
  8019ab:	ff 75 08             	pushl  0x8(%ebp)
  8019ae:	e8 90 0c 00 00       	call   802643 <sys_sbrk>
  8019b3:	83 c4 10             	add    $0x10,%esp
}
  8019b6:	c9                   	leave  
  8019b7:	c3                   	ret    

008019b8 <malloc>:
#define num_of_page ((USER_HEAP_MAX - USER_HEAP_START) / PAGE_SIZE)

int pagesAllocated[num_of_page] = { 0 };
int shardIDs[num_of_page] = { 0 };
bool markedPages[num_of_page] = { 0 };
void* malloc(uint32 size) {
  8019b8:	55                   	push   %ebp
  8019b9:	89 e5                	mov    %esp,%ebp
  8019bb:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  8019be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8019c2:	75 0a                	jne    8019ce <malloc+0x16>
		return NULL;
  8019c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8019c9:	e9 9e 01 00 00       	jmp    801b6c <malloc+0x1b4>

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

	//  our new code
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  8019ce:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8019d5:	77 2c                	ja     801a03 <malloc+0x4b>
		if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  8019d7:	e8 eb 0a 00 00       	call   8024c7 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8019dc:	85 c0                	test   %eax,%eax
  8019de:	74 19                	je     8019f9 <malloc+0x41>

			void * block = alloc_block_FF(size);
  8019e0:	83 ec 0c             	sub    $0xc,%esp
  8019e3:	ff 75 08             	pushl  0x8(%ebp)
  8019e6:	e8 85 11 00 00       	call   802b70 <alloc_block_FF>
  8019eb:	83 c4 10             	add    $0x10,%esp
  8019ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			return block;
  8019f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019f4:	e9 73 01 00 00       	jmp    801b6c <malloc+0x1b4>
		} else {
			return NULL;
  8019f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8019fe:	e9 69 01 00 00       	jmp    801b6c <malloc+0x1b4>
		}
	}

	uint32 numOfPages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801a03:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801a0a:	8b 55 08             	mov    0x8(%ebp),%edx
  801a0d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a10:	01 d0                	add    %edx,%eax
  801a12:	48                   	dec    %eax
  801a13:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801a16:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a19:	ba 00 00 00 00       	mov    $0x0,%edx
  801a1e:	f7 75 e0             	divl   -0x20(%ebp)
  801a21:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a24:	29 d0                	sub    %edx,%eax
  801a26:	c1 e8 0c             	shr    $0xc,%eax
  801a29:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 freePagesCount = 0;
  801a2c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801a33:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  801a3a:	a1 24 50 80 00       	mov    0x805024,%eax
  801a3f:	8b 40 7c             	mov    0x7c(%eax),%eax
  801a42:	05 00 10 00 00       	add    $0x1000,%eax
  801a47:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  801a4a:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801a4f:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801a52:	89 45 d0             	mov    %eax,-0x30(%ebp)

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  801a55:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  801a5c:	8b 55 08             	mov    0x8(%ebp),%edx
  801a5f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801a62:	01 d0                	add    %edx,%eax
  801a64:	48                   	dec    %eax
  801a65:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801a68:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801a6b:	ba 00 00 00 00       	mov    $0x0,%edx
  801a70:	f7 75 cc             	divl   -0x34(%ebp)
  801a73:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801a76:	29 d0                	sub    %edx,%eax
  801a78:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801a7b:	76 0a                	jbe    801a87 <malloc+0xcf>
		return NULL;
  801a7d:	b8 00 00 00 00       	mov    $0x0,%eax
  801a82:	e9 e5 00 00 00       	jmp    801b6c <malloc+0x1b4>
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  801a87:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a8a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801a8d:	eb 48                	jmp    801ad7 <malloc+0x11f>
	{
		uint32 idx = (i - currentAddr) / PAGE_SIZE;
  801a8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a92:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801a95:	c1 e8 0c             	shr    $0xc,%eax
  801a98:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if (!markedPages[idx]) {
  801a9b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801a9e:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  801aa5:	85 c0                	test   %eax,%eax
  801aa7:	75 11                	jne    801aba <malloc+0x102>
			freePagesCount++;
  801aa9:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801aac:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801ab0:	75 16                	jne    801ac8 <malloc+0x110>
				start = i;
  801ab2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ab5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ab8:	eb 0e                	jmp    801ac8 <malloc+0x110>
			}
		} else {
			freePagesCount = 0;
  801aba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  801ac1:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == numOfPages) {
  801ac8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801acb:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801ace:	74 12                	je     801ae2 <malloc+0x12a>

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  801ad0:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801ad7:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801ade:	76 af                	jbe    801a8f <malloc+0xd7>
  801ae0:	eb 01                	jmp    801ae3 <malloc+0x12b>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == numOfPages) {
			break;
  801ae2:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
  801ae3:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801ae7:	74 08                	je     801af1 <malloc+0x139>
  801ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aec:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801aef:	74 07                	je     801af8 <malloc+0x140>
		return NULL;
  801af1:	b8 00 00 00 00       	mov    $0x0,%eax
  801af6:	eb 74                	jmp    801b6c <malloc+0x1b4>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  801af8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801afb:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801afe:	c1 e8 0c             	shr    $0xc,%eax
  801b01:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numOfPages;
  801b04:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801b07:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801b0a:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  801b11:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801b14:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801b17:	eb 11                	jmp    801b2a <malloc+0x172>
		markedPages[i] = 1;
  801b19:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b1c:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  801b23:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = numOfPages;
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  801b27:	ff 45 e8             	incl   -0x18(%ebp)
  801b2a:	8b 55 c0             	mov    -0x40(%ebp),%edx
  801b2d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b30:	01 d0                	add    %edx,%eax
  801b32:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801b35:	77 e2                	ja     801b19 <malloc+0x161>
		markedPages[i] = 1;
	}

	sys_allocate_user_mem(start, ROUNDUP(size, PAGE_SIZE));
  801b37:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801b3e:	8b 55 08             	mov    0x8(%ebp),%edx
  801b41:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801b44:	01 d0                	add    %edx,%eax
  801b46:	48                   	dec    %eax
  801b47:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801b4a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801b4d:	ba 00 00 00 00       	mov    $0x0,%edx
  801b52:	f7 75 bc             	divl   -0x44(%ebp)
  801b55:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801b58:	29 d0                	sub    %edx,%eax
  801b5a:	83 ec 08             	sub    $0x8,%esp
  801b5d:	50                   	push   %eax
  801b5e:	ff 75 f0             	pushl  -0x10(%ebp)
  801b61:	e8 14 0b 00 00       	call   80267a <sys_allocate_user_mem>
  801b66:	83 c4 10             	add    $0x10,%esp
	return (void*) start;
  801b69:	8b 45 f0             	mov    -0x10(%ebp),%eax

}
  801b6c:	c9                   	leave  
  801b6d:	c3                   	ret    

00801b6e <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address) {
  801b6e:	55                   	push   %ebp
  801b6f:	89 e5                	mov    %esp,%ebp
  801b71:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
  801b74:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b78:	0f 84 ee 00 00 00    	je     801c6c <free+0xfe>
		return;
	}

	if (virtual_address
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  801b7e:	a1 24 50 80 00       	mov    0x805024,%eax
  801b83:	8b 40 74             	mov    0x74(%eax),%eax

	if (virtual_address == NULL) {
		return;
	}

	if (virtual_address
  801b86:	3b 45 08             	cmp    0x8(%ebp),%eax
  801b89:	77 09                	ja     801b94 <free+0x26>
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  801b8b:	81 7d 08 00 00 00 a0 	cmpl   $0xa0000000,0x8(%ebp)
  801b92:	76 14                	jbe    801ba8 <free+0x3a>
		panic("INVALID VIRTUAL ADDRESS!!");
  801b94:	83 ec 04             	sub    $0x4,%esp
  801b97:	68 cc 43 80 00       	push   $0x8043cc
  801b9c:	6a 68                	push   $0x68
  801b9e:	68 e6 43 80 00       	push   $0x8043e6
  801ba3:	e8 9b eb ff ff       	call   800743 <_panic>
	}
	if (virtual_address >= (void *) (myEnv->uheapStart)
  801ba8:	a1 24 50 80 00       	mov    0x805024,%eax
  801bad:	8b 40 74             	mov    0x74(%eax),%eax
  801bb0:	3b 45 08             	cmp    0x8(%ebp),%eax
  801bb3:	77 20                	ja     801bd5 <free+0x67>
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
  801bb5:	a1 24 50 80 00       	mov    0x805024,%eax
  801bba:	8b 40 78             	mov    0x78(%eax),%eax
  801bbd:	3b 45 08             	cmp    0x8(%ebp),%eax
  801bc0:	76 13                	jbe    801bd5 <free+0x67>
		free_block(virtual_address);
  801bc2:	83 ec 0c             	sub    $0xc,%esp
  801bc5:	ff 75 08             	pushl  0x8(%ebp)
  801bc8:	e8 6c 16 00 00       	call   803239 <free_block>
  801bcd:	83 c4 10             	add    $0x10,%esp
		return;
  801bd0:	e9 98 00 00 00       	jmp    801c6d <free+0xff>
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  801bd5:	8b 55 08             	mov    0x8(%ebp),%edx
  801bd8:	a1 24 50 80 00       	mov    0x805024,%eax
  801bdd:	8b 40 7c             	mov    0x7c(%eax),%eax
  801be0:	29 c2                	sub    %eax,%edx
  801be2:	89 d0                	mov    %edx,%eax
  801be4:	2d 00 10 00 00       	sub    $0x1000,%eax
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
		free_block(virtual_address);
		return;
	}

	uint32 pageIdx = ((uint32) virtual_address
  801be9:	c1 e8 0c             	shr    $0xc,%eax
  801bec:	89 45 ec             	mov    %eax,-0x14(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  801bef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801bf6:	eb 16                	jmp    801c0e <free+0xa0>
		markedPages[idx + pageIdx] = 0;
  801bf8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bfb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bfe:	01 d0                	add    %edx,%eax
  801c00:	c7 04 85 40 50 90 00 	movl   $0x0,0x905040(,%eax,4)
  801c07:	00 00 00 00 
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  801c0b:	ff 45 f4             	incl   -0xc(%ebp)
  801c0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c11:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  801c18:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801c1b:	7f db                	jg     801bf8 <free+0x8a>
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;
  801c1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c20:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  801c27:	c1 e0 0c             	shl    $0xc,%eax
  801c2a:	89 45 e8             	mov    %eax,-0x18(%ebp)

	for (uint32 i = (uint32) virtual_address;
  801c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c30:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c33:	eb 1a                	jmp    801c4f <free+0xe1>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
  801c35:	83 ec 08             	sub    $0x8,%esp
  801c38:	68 00 10 00 00       	push   $0x1000
  801c3d:	ff 75 f0             	pushl  -0x10(%ebp)
  801c40:	e8 19 0a 00 00       	call   80265e <sys_free_user_mem>
  801c45:	83 c4 10             	add    $0x10,%esp
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
  801c48:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  801c4f:	8b 55 08             	mov    0x8(%ebp),%edx
  801c52:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c55:	01 d0                	add    %edx,%eax
	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
  801c57:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801c5a:	77 d9                	ja     801c35 <free+0xc7>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;
  801c5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c5f:	c7 04 85 40 50 80 00 	movl   $0x0,0x805040(,%eax,4)
  801c66:	00 00 00 00 
  801c6a:	eb 01                	jmp    801c6d <free+0xff>
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
		return;
  801c6c:	90                   	nop
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;

}
  801c6d:	c9                   	leave  
  801c6e:	c3                   	ret    

00801c6f <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  801c6f:	55                   	push   %ebp
  801c70:	89 e5                	mov    %esp,%ebp
  801c72:	83 ec 58             	sub    $0x58,%esp
  801c75:	8b 45 10             	mov    0x10(%ebp),%eax
  801c78:	88 45 b4             	mov    %al,-0x4c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  801c7b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c7f:	75 0a                	jne    801c8b <smalloc+0x1c>
		return NULL;
  801c81:	b8 00 00 00 00       	mov    $0x0,%eax
  801c86:	e9 7d 01 00 00       	jmp    801e08 <smalloc+0x199>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	uint32 num_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801c8b:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  801c92:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c98:	01 d0                	add    %edx,%eax
  801c9a:	48                   	dec    %eax
  801c9b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801c9e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ca1:	ba 00 00 00 00       	mov    $0x0,%edx
  801ca6:	f7 75 e4             	divl   -0x1c(%ebp)
  801ca9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cac:	29 d0                	sub    %edx,%eax
  801cae:	c1 e8 0c             	shr    $0xc,%eax
  801cb1:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 freePagesCount = 0;
  801cb4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801cbb:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  801cc2:	a1 24 50 80 00       	mov    0x805024,%eax
  801cc7:	8b 40 7c             	mov    0x7c(%eax),%eax
  801cca:	05 00 10 00 00       	add    $0x1000,%eax
  801ccf:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  801cd2:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801cd7:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801cda:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  801cdd:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801ce4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ce7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801cea:	01 d0                	add    %edx,%eax
  801cec:	48                   	dec    %eax
  801ced:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801cf0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801cf3:	ba 00 00 00 00       	mov    $0x0,%edx
  801cf8:	f7 75 d0             	divl   -0x30(%ebp)
  801cfb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801cfe:	29 d0                	sub    %edx,%eax
  801d00:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801d03:	76 0a                	jbe    801d0f <smalloc+0xa0>
		return NULL;
  801d05:	b8 00 00 00 00       	mov    $0x0,%eax
  801d0a:	e9 f9 00 00 00       	jmp    801e08 <smalloc+0x199>
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801d0f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d12:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801d15:	eb 48                	jmp    801d5f <smalloc+0xf0>
		uint32 idx = (s - currentAddr) / PAGE_SIZE;
  801d17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d1a:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801d1d:	c1 e8 0c             	shr    $0xc,%eax
  801d20:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (!markedPages[idx]) {
  801d23:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801d26:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  801d2d:	85 c0                	test   %eax,%eax
  801d2f:	75 11                	jne    801d42 <smalloc+0xd3>
			freePagesCount++;
  801d31:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801d34:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801d38:	75 16                	jne    801d50 <smalloc+0xe1>
				start = s;
  801d3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d40:	eb 0e                	jmp    801d50 <smalloc+0xe1>
			}
		} else {
			freePagesCount = 0;
  801d42:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  801d49:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == num_Of_Pages) {
  801d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d53:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801d56:	74 12                	je     801d6a <smalloc+0xfb>
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801d58:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801d5f:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801d66:	76 af                	jbe    801d17 <smalloc+0xa8>
  801d68:	eb 01                	jmp    801d6b <smalloc+0xfc>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == num_Of_Pages) {
			break;
  801d6a:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
  801d6b:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801d6f:	74 08                	je     801d79 <smalloc+0x10a>
  801d71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d74:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801d77:	74 0a                	je     801d83 <smalloc+0x114>
		return NULL;
  801d79:	b8 00 00 00 00       	mov    $0x0,%eax
  801d7e:	e9 85 00 00 00       	jmp    801e08 <smalloc+0x199>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  801d83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d86:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801d89:	c1 e8 0c             	shr    $0xc,%eax
  801d8c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	pagesAllocated[startPage] = num_Of_Pages;
  801d8f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801d92:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801d95:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  801d9c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801d9f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801da2:	eb 11                	jmp    801db5 <smalloc+0x146>
		markedPages[s] = 1;
  801da4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801da7:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  801dae:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = num_Of_Pages;
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  801db2:	ff 45 e8             	incl   -0x18(%ebp)
  801db5:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801db8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801dbb:	01 d0                	add    %edx,%eax
  801dbd:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801dc0:	77 e2                	ja     801da4 <smalloc+0x135>
		markedPages[s] = 1;
	}
	int sharedobjID = sys_createSharedObject(sharedVarName, size, isWritable,
  801dc2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801dc5:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
  801dc9:	52                   	push   %edx
  801dca:	50                   	push   %eax
  801dcb:	ff 75 0c             	pushl  0xc(%ebp)
  801dce:	ff 75 08             	pushl  0x8(%ebp)
  801dd1:	e8 8f 04 00 00       	call   802265 <sys_createSharedObject>
  801dd6:	83 c4 10             	add    $0x10,%esp
  801dd9:	89 45 c0             	mov    %eax,-0x40(%ebp)
			(void*) start);

	if (sharedobjID >= 0) {
  801ddc:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  801de0:	78 12                	js     801df4 <smalloc+0x185>
		shardIDs[startPage] = sharedobjID;
  801de2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801de5:	8b 55 c0             	mov    -0x40(%ebp),%edx
  801de8:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  801def:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801df2:	eb 14                	jmp    801e08 <smalloc+0x199>
	}
	free((void*) start);
  801df4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801df7:	83 ec 0c             	sub    $0xc,%esp
  801dfa:	50                   	push   %eax
  801dfb:	e8 6e fd ff ff       	call   801b6e <free>
  801e00:	83 c4 10             	add    $0x10,%esp
	return NULL;
  801e03:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e08:	c9                   	leave  
  801e09:	c3                   	ret    

00801e0a <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  801e0a:	55                   	push   %ebp
  801e0b:	89 e5                	mov    %esp,%ebp
  801e0d:	83 ec 48             	sub    $0x48,%esp
	//cprintf("SSSSSGEEETTT\n");
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID, sharedVarName);
  801e10:	83 ec 08             	sub    $0x8,%esp
  801e13:	ff 75 0c             	pushl  0xc(%ebp)
  801e16:	ff 75 08             	pushl  0x8(%ebp)
  801e19:	e8 71 04 00 00       	call   80228f <sys_getSizeOfSharedObject>
  801e1e:	83 c4 10             	add    $0x10,%esp
  801e21:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (size < 0)
		return NULL;
	uint32 numb_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801e24:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801e2b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801e2e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e31:	01 d0                	add    %edx,%eax
  801e33:	48                   	dec    %eax
  801e34:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801e37:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e3a:	ba 00 00 00 00       	mov    $0x0,%edx
  801e3f:	f7 75 e0             	divl   -0x20(%ebp)
  801e42:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e45:	29 d0                	sub    %edx,%eax
  801e47:	c1 e8 0c             	shr    $0xc,%eax
  801e4a:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 free_Pages_Count = 0;
  801e4d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801e54:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
  801e5b:	a1 24 50 80 00       	mov    0x805024,%eax
  801e60:	8b 40 7c             	mov    0x7c(%eax),%eax
  801e63:	05 00 10 00 00       	add    $0x1000,%eax
  801e68:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
  801e6b:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801e70:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801e73:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
  801e76:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  801e7d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801e80:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801e83:	01 d0                	add    %edx,%eax
  801e85:	48                   	dec    %eax
  801e86:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801e89:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801e8c:	ba 00 00 00 00       	mov    $0x0,%edx
  801e91:	f7 75 cc             	divl   -0x34(%ebp)
  801e94:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801e97:	29 d0                	sub    %edx,%eax
  801e99:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801e9c:	76 0a                	jbe    801ea8 <sget+0x9e>
		return NULL;
  801e9e:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea3:	e9 f7 00 00 00       	jmp    801f9f <sget+0x195>
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801ea8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801eab:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801eae:	eb 48                	jmp    801ef8 <sget+0xee>
		uint32 idx = (s - current_Addr) / PAGE_SIZE;
  801eb0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eb3:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801eb6:	c1 e8 0c             	shr    $0xc,%eax
  801eb9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if (!markedPages[idx]) {
  801ebc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801ebf:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  801ec6:	85 c0                	test   %eax,%eax
  801ec8:	75 11                	jne    801edb <sget+0xd1>
			free_Pages_Count++;
  801eca:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801ecd:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801ed1:	75 16                	jne    801ee9 <sget+0xdf>
				start = s;
  801ed3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ed6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ed9:	eb 0e                	jmp    801ee9 <sget+0xdf>
			}
		} else {
			free_Pages_Count = 0;
  801edb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  801ee2:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (free_Pages_Count == numb_Of_Pages) {
  801ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eec:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801eef:	74 12                	je     801f03 <sget+0xf9>
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
		return NULL;
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801ef1:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801ef8:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801eff:	76 af                	jbe    801eb0 <sget+0xa6>
  801f01:	eb 01                	jmp    801f04 <sget+0xfa>
		} else {
			free_Pages_Count = 0;
			start = (uint32) -1;
		}
		if (free_Pages_Count == numb_Of_Pages) {
			break;
  801f03:	90                   	nop
		}
	}
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
  801f04:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801f08:	74 08                	je     801f12 <sget+0x108>
  801f0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f0d:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801f10:	74 0a                	je     801f1c <sget+0x112>
		return NULL;
  801f12:	b8 00 00 00 00       	mov    $0x0,%eax
  801f17:	e9 83 00 00 00       	jmp    801f9f <sget+0x195>
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
  801f1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f1f:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801f22:	c1 e8 0c             	shr    $0xc,%eax
  801f25:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numb_Of_Pages;
  801f28:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801f2b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801f2e:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  801f35:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801f38:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801f3b:	eb 11                	jmp    801f4e <sget+0x144>
		markedPages[k] = 1;
  801f3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f40:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  801f47:	01 00 00 00 
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
	pagesAllocated[startPage] = numb_Of_Pages;
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  801f4b:	ff 45 e8             	incl   -0x18(%ebp)
  801f4e:	8b 55 c0             	mov    -0x40(%ebp),%edx
  801f51:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801f54:	01 d0                	add    %edx,%eax
  801f56:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801f59:	77 e2                	ja     801f3d <sget+0x133>
		markedPages[k] = 1;
	}
	int ss = sys_getSharedObject(ownerEnvID, sharedVarName, (void*) start);
  801f5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f5e:	83 ec 04             	sub    $0x4,%esp
  801f61:	50                   	push   %eax
  801f62:	ff 75 0c             	pushl  0xc(%ebp)
  801f65:	ff 75 08             	pushl  0x8(%ebp)
  801f68:	e8 3f 03 00 00       	call   8022ac <sys_getSharedObject>
  801f6d:	83 c4 10             	add    $0x10,%esp
  801f70:	89 45 bc             	mov    %eax,-0x44(%ebp)
	if (ss >= 0) {
  801f73:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  801f77:	78 12                	js     801f8b <sget+0x181>
		shardIDs[startPage] = ss;
  801f79:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801f7c:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801f7f:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  801f86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f89:	eb 14                	jmp    801f9f <sget+0x195>
	}
	free((void*) start);
  801f8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f8e:	83 ec 0c             	sub    $0xc,%esp
  801f91:	50                   	push   %eax
  801f92:	e8 d7 fb ff ff       	call   801b6e <free>
  801f97:	83 c4 10             	add    $0x10,%esp
	return NULL;
  801f9a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f9f:	c9                   	leave  
  801fa0:	c3                   	ret    

00801fa1 <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  801fa1:	55                   	push   %ebp
  801fa2:	89 e5                	mov    %esp,%ebp
  801fa4:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  801fa7:	8b 55 08             	mov    0x8(%ebp),%edx
  801faa:	a1 24 50 80 00       	mov    0x805024,%eax
  801faf:	8b 40 7c             	mov    0x7c(%eax),%eax
  801fb2:	29 c2                	sub    %eax,%edx
  801fb4:	89 d0                	mov    %edx,%eax
  801fb6:	2d 00 10 00 00       	sub    $0x1000,%eax

void sfree(void* virtual_address) {
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
  801fbb:	c1 e8 0c             	shr    $0xc,%eax
  801fbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
	int id = shardIDs[pageIdx];
  801fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc4:	8b 04 85 40 50 88 00 	mov    0x885040(,%eax,4),%eax
  801fcb:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int result = sys_freeSharedObject(id, virtual_address);
  801fce:	83 ec 08             	sub    $0x8,%esp
  801fd1:	ff 75 08             	pushl  0x8(%ebp)
  801fd4:	ff 75 f0             	pushl  -0x10(%ebp)
  801fd7:	e8 ef 02 00 00       	call   8022cb <sys_freeSharedObject>
  801fdc:	83 c4 10             	add    $0x10,%esp
  801fdf:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (result == 0) {
  801fe2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801fe6:	75 0e                	jne    801ff6 <sfree+0x55>
		shardIDs[pageIdx] = -1;  // Reset the ID after freeing
  801fe8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801feb:	c7 04 85 40 50 88 00 	movl   $0xffffffff,0x885040(,%eax,4)
  801ff2:	ff ff ff ff 
	}

}
  801ff6:	90                   	nop
  801ff7:	c9                   	leave  
  801ff8:	c3                   	ret    

00801ff9 <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  801ff9:	55                   	push   %ebp
  801ffa:	89 e5                	mov    %esp,%ebp
  801ffc:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801fff:	83 ec 04             	sub    $0x4,%esp
  802002:	68 f4 43 80 00       	push   $0x8043f4
  802007:	68 19 01 00 00       	push   $0x119
  80200c:	68 e6 43 80 00       	push   $0x8043e6
  802011:	e8 2d e7 ff ff       	call   800743 <_panic>

00802016 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  802016:	55                   	push   %ebp
  802017:	89 e5                	mov    %esp,%ebp
  802019:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80201c:	83 ec 04             	sub    $0x4,%esp
  80201f:	68 1a 44 80 00       	push   $0x80441a
  802024:	68 23 01 00 00       	push   $0x123
  802029:	68 e6 43 80 00       	push   $0x8043e6
  80202e:	e8 10 e7 ff ff       	call   800743 <_panic>

00802033 <shrink>:

}
void shrink(uint32 newSize) {
  802033:	55                   	push   %ebp
  802034:	89 e5                	mov    %esp,%ebp
  802036:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802039:	83 ec 04             	sub    $0x4,%esp
  80203c:	68 1a 44 80 00       	push   $0x80441a
  802041:	68 27 01 00 00       	push   $0x127
  802046:	68 e6 43 80 00       	push   $0x8043e6
  80204b:	e8 f3 e6 ff ff       	call   800743 <_panic>

00802050 <freeHeap>:

}
void freeHeap(void* virtual_address) {
  802050:	55                   	push   %ebp
  802051:	89 e5                	mov    %esp,%ebp
  802053:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802056:	83 ec 04             	sub    $0x4,%esp
  802059:	68 1a 44 80 00       	push   $0x80441a
  80205e:	68 2b 01 00 00       	push   $0x12b
  802063:	68 e6 43 80 00       	push   $0x8043e6
  802068:	e8 d6 e6 ff ff       	call   800743 <_panic>

0080206d <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  80206d:	55                   	push   %ebp
  80206e:	89 e5                	mov    %esp,%ebp
  802070:	57                   	push   %edi
  802071:	56                   	push   %esi
  802072:	53                   	push   %ebx
  802073:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802076:	8b 45 08             	mov    0x8(%ebp),%eax
  802079:	8b 55 0c             	mov    0xc(%ebp),%edx
  80207c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80207f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802082:	8b 7d 18             	mov    0x18(%ebp),%edi
  802085:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802088:	cd 30                	int    $0x30
  80208a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  80208d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802090:	83 c4 10             	add    $0x10,%esp
  802093:	5b                   	pop    %ebx
  802094:	5e                   	pop    %esi
  802095:	5f                   	pop    %edi
  802096:	5d                   	pop    %ebp
  802097:	c3                   	ret    

00802098 <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  802098:	55                   	push   %ebp
  802099:	89 e5                	mov    %esp,%ebp
  80209b:	83 ec 04             	sub    $0x4,%esp
  80209e:	8b 45 10             	mov    0x10(%ebp),%eax
  8020a1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  8020a4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8020a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ab:	6a 00                	push   $0x0
  8020ad:	6a 00                	push   $0x0
  8020af:	52                   	push   %edx
  8020b0:	ff 75 0c             	pushl  0xc(%ebp)
  8020b3:	50                   	push   %eax
  8020b4:	6a 00                	push   $0x0
  8020b6:	e8 b2 ff ff ff       	call   80206d <syscall>
  8020bb:	83 c4 18             	add    $0x18,%esp
}
  8020be:	90                   	nop
  8020bf:	c9                   	leave  
  8020c0:	c3                   	ret    

008020c1 <sys_cgetc>:

int sys_cgetc(void) {
  8020c1:	55                   	push   %ebp
  8020c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8020c4:	6a 00                	push   $0x0
  8020c6:	6a 00                	push   $0x0
  8020c8:	6a 00                	push   $0x0
  8020ca:	6a 00                	push   $0x0
  8020cc:	6a 00                	push   $0x0
  8020ce:	6a 02                	push   $0x2
  8020d0:	e8 98 ff ff ff       	call   80206d <syscall>
  8020d5:	83 c4 18             	add    $0x18,%esp
}
  8020d8:	c9                   	leave  
  8020d9:	c3                   	ret    

008020da <sys_lock_cons>:

void sys_lock_cons(void) {
  8020da:	55                   	push   %ebp
  8020db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8020dd:	6a 00                	push   $0x0
  8020df:	6a 00                	push   $0x0
  8020e1:	6a 00                	push   $0x0
  8020e3:	6a 00                	push   $0x0
  8020e5:	6a 00                	push   $0x0
  8020e7:	6a 03                	push   $0x3
  8020e9:	e8 7f ff ff ff       	call   80206d <syscall>
  8020ee:	83 c4 18             	add    $0x18,%esp
}
  8020f1:	90                   	nop
  8020f2:	c9                   	leave  
  8020f3:	c3                   	ret    

008020f4 <sys_unlock_cons>:
void sys_unlock_cons(void) {
  8020f4:	55                   	push   %ebp
  8020f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8020f7:	6a 00                	push   $0x0
  8020f9:	6a 00                	push   $0x0
  8020fb:	6a 00                	push   $0x0
  8020fd:	6a 00                	push   $0x0
  8020ff:	6a 00                	push   $0x0
  802101:	6a 04                	push   $0x4
  802103:	e8 65 ff ff ff       	call   80206d <syscall>
  802108:	83 c4 18             	add    $0x18,%esp
}
  80210b:	90                   	nop
  80210c:	c9                   	leave  
  80210d:	c3                   	ret    

0080210e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  80210e:	55                   	push   %ebp
  80210f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  802111:	8b 55 0c             	mov    0xc(%ebp),%edx
  802114:	8b 45 08             	mov    0x8(%ebp),%eax
  802117:	6a 00                	push   $0x0
  802119:	6a 00                	push   $0x0
  80211b:	6a 00                	push   $0x0
  80211d:	52                   	push   %edx
  80211e:	50                   	push   %eax
  80211f:	6a 08                	push   $0x8
  802121:	e8 47 ff ff ff       	call   80206d <syscall>
  802126:	83 c4 18             	add    $0x18,%esp
}
  802129:	c9                   	leave  
  80212a:	c3                   	ret    

0080212b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  80212b:	55                   	push   %ebp
  80212c:	89 e5                	mov    %esp,%ebp
  80212e:	56                   	push   %esi
  80212f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  802130:	8b 75 18             	mov    0x18(%ebp),%esi
  802133:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802136:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802139:	8b 55 0c             	mov    0xc(%ebp),%edx
  80213c:	8b 45 08             	mov    0x8(%ebp),%eax
  80213f:	56                   	push   %esi
  802140:	53                   	push   %ebx
  802141:	51                   	push   %ecx
  802142:	52                   	push   %edx
  802143:	50                   	push   %eax
  802144:	6a 09                	push   $0x9
  802146:	e8 22 ff ff ff       	call   80206d <syscall>
  80214b:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  80214e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802151:	5b                   	pop    %ebx
  802152:	5e                   	pop    %esi
  802153:	5d                   	pop    %ebp
  802154:	c3                   	ret    

00802155 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  802155:	55                   	push   %ebp
  802156:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802158:	8b 55 0c             	mov    0xc(%ebp),%edx
  80215b:	8b 45 08             	mov    0x8(%ebp),%eax
  80215e:	6a 00                	push   $0x0
  802160:	6a 00                	push   $0x0
  802162:	6a 00                	push   $0x0
  802164:	52                   	push   %edx
  802165:	50                   	push   %eax
  802166:	6a 0a                	push   $0xa
  802168:	e8 00 ff ff ff       	call   80206d <syscall>
  80216d:	83 c4 18             	add    $0x18,%esp
}
  802170:	c9                   	leave  
  802171:	c3                   	ret    

00802172 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  802172:	55                   	push   %ebp
  802173:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  802175:	6a 00                	push   $0x0
  802177:	6a 00                	push   $0x0
  802179:	6a 00                	push   $0x0
  80217b:	ff 75 0c             	pushl  0xc(%ebp)
  80217e:	ff 75 08             	pushl  0x8(%ebp)
  802181:	6a 0b                	push   $0xb
  802183:	e8 e5 fe ff ff       	call   80206d <syscall>
  802188:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  80218b:	c9                   	leave  
  80218c:	c3                   	ret    

0080218d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  80218d:	55                   	push   %ebp
  80218e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802190:	6a 00                	push   $0x0
  802192:	6a 00                	push   $0x0
  802194:	6a 00                	push   $0x0
  802196:	6a 00                	push   $0x0
  802198:	6a 00                	push   $0x0
  80219a:	6a 0c                	push   $0xc
  80219c:	e8 cc fe ff ff       	call   80206d <syscall>
  8021a1:	83 c4 18             	add    $0x18,%esp
}
  8021a4:	c9                   	leave  
  8021a5:	c3                   	ret    

008021a6 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  8021a6:	55                   	push   %ebp
  8021a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8021a9:	6a 00                	push   $0x0
  8021ab:	6a 00                	push   $0x0
  8021ad:	6a 00                	push   $0x0
  8021af:	6a 00                	push   $0x0
  8021b1:	6a 00                	push   $0x0
  8021b3:	6a 0d                	push   $0xd
  8021b5:	e8 b3 fe ff ff       	call   80206d <syscall>
  8021ba:	83 c4 18             	add    $0x18,%esp
}
  8021bd:	c9                   	leave  
  8021be:	c3                   	ret    

008021bf <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  8021bf:	55                   	push   %ebp
  8021c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8021c2:	6a 00                	push   $0x0
  8021c4:	6a 00                	push   $0x0
  8021c6:	6a 00                	push   $0x0
  8021c8:	6a 00                	push   $0x0
  8021ca:	6a 00                	push   $0x0
  8021cc:	6a 0e                	push   $0xe
  8021ce:	e8 9a fe ff ff       	call   80206d <syscall>
  8021d3:	83 c4 18             	add    $0x18,%esp
}
  8021d6:	c9                   	leave  
  8021d7:	c3                   	ret    

008021d8 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  8021d8:	55                   	push   %ebp
  8021d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  8021db:	6a 00                	push   $0x0
  8021dd:	6a 00                	push   $0x0
  8021df:	6a 00                	push   $0x0
  8021e1:	6a 00                	push   $0x0
  8021e3:	6a 00                	push   $0x0
  8021e5:	6a 0f                	push   $0xf
  8021e7:	e8 81 fe ff ff       	call   80206d <syscall>
  8021ec:	83 c4 18             	add    $0x18,%esp
}
  8021ef:	c9                   	leave  
  8021f0:	c3                   	ret    

008021f1 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  8021f1:	55                   	push   %ebp
  8021f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  8021f4:	6a 00                	push   $0x0
  8021f6:	6a 00                	push   $0x0
  8021f8:	6a 00                	push   $0x0
  8021fa:	6a 00                	push   $0x0
  8021fc:	ff 75 08             	pushl  0x8(%ebp)
  8021ff:	6a 10                	push   $0x10
  802201:	e8 67 fe ff ff       	call   80206d <syscall>
  802206:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  802209:	c9                   	leave  
  80220a:	c3                   	ret    

0080220b <sys_scarce_memory>:

void sys_scarce_memory() {
  80220b:	55                   	push   %ebp
  80220c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  80220e:	6a 00                	push   $0x0
  802210:	6a 00                	push   $0x0
  802212:	6a 00                	push   $0x0
  802214:	6a 00                	push   $0x0
  802216:	6a 00                	push   $0x0
  802218:	6a 11                	push   $0x11
  80221a:	e8 4e fe ff ff       	call   80206d <syscall>
  80221f:	83 c4 18             	add    $0x18,%esp
}
  802222:	90                   	nop
  802223:	c9                   	leave  
  802224:	c3                   	ret    

00802225 <sys_cputc>:

void sys_cputc(const char c) {
  802225:	55                   	push   %ebp
  802226:	89 e5                	mov    %esp,%ebp
  802228:	83 ec 04             	sub    $0x4,%esp
  80222b:	8b 45 08             	mov    0x8(%ebp),%eax
  80222e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802231:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802235:	6a 00                	push   $0x0
  802237:	6a 00                	push   $0x0
  802239:	6a 00                	push   $0x0
  80223b:	6a 00                	push   $0x0
  80223d:	50                   	push   %eax
  80223e:	6a 01                	push   $0x1
  802240:	e8 28 fe ff ff       	call   80206d <syscall>
  802245:	83 c4 18             	add    $0x18,%esp
}
  802248:	90                   	nop
  802249:	c9                   	leave  
  80224a:	c3                   	ret    

0080224b <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  80224b:	55                   	push   %ebp
  80224c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  80224e:	6a 00                	push   $0x0
  802250:	6a 00                	push   $0x0
  802252:	6a 00                	push   $0x0
  802254:	6a 00                	push   $0x0
  802256:	6a 00                	push   $0x0
  802258:	6a 14                	push   $0x14
  80225a:	e8 0e fe ff ff       	call   80206d <syscall>
  80225f:	83 c4 18             	add    $0x18,%esp
}
  802262:	90                   	nop
  802263:	c9                   	leave  
  802264:	c3                   	ret    

00802265 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  802265:	55                   	push   %ebp
  802266:	89 e5                	mov    %esp,%ebp
  802268:	83 ec 04             	sub    $0x4,%esp
  80226b:	8b 45 10             	mov    0x10(%ebp),%eax
  80226e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  802271:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802274:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802278:	8b 45 08             	mov    0x8(%ebp),%eax
  80227b:	6a 00                	push   $0x0
  80227d:	51                   	push   %ecx
  80227e:	52                   	push   %edx
  80227f:	ff 75 0c             	pushl  0xc(%ebp)
  802282:	50                   	push   %eax
  802283:	6a 15                	push   $0x15
  802285:	e8 e3 fd ff ff       	call   80206d <syscall>
  80228a:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  80228d:	c9                   	leave  
  80228e:	c3                   	ret    

0080228f <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  80228f:	55                   	push   %ebp
  802290:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  802292:	8b 55 0c             	mov    0xc(%ebp),%edx
  802295:	8b 45 08             	mov    0x8(%ebp),%eax
  802298:	6a 00                	push   $0x0
  80229a:	6a 00                	push   $0x0
  80229c:	6a 00                	push   $0x0
  80229e:	52                   	push   %edx
  80229f:	50                   	push   %eax
  8022a0:	6a 16                	push   $0x16
  8022a2:	e8 c6 fd ff ff       	call   80206d <syscall>
  8022a7:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  8022aa:	c9                   	leave  
  8022ab:	c3                   	ret    

008022ac <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  8022ac:	55                   	push   %ebp
  8022ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  8022af:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b8:	6a 00                	push   $0x0
  8022ba:	6a 00                	push   $0x0
  8022bc:	51                   	push   %ecx
  8022bd:	52                   	push   %edx
  8022be:	50                   	push   %eax
  8022bf:	6a 17                	push   $0x17
  8022c1:	e8 a7 fd ff ff       	call   80206d <syscall>
  8022c6:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  8022c9:	c9                   	leave  
  8022ca:	c3                   	ret    

008022cb <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  8022cb:	55                   	push   %ebp
  8022cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  8022ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d4:	6a 00                	push   $0x0
  8022d6:	6a 00                	push   $0x0
  8022d8:	6a 00                	push   $0x0
  8022da:	52                   	push   %edx
  8022db:	50                   	push   %eax
  8022dc:	6a 18                	push   $0x18
  8022de:	e8 8a fd ff ff       	call   80206d <syscall>
  8022e3:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  8022e6:	c9                   	leave  
  8022e7:	c3                   	ret    

008022e8 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  8022e8:	55                   	push   %ebp
  8022e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  8022eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ee:	6a 00                	push   $0x0
  8022f0:	ff 75 14             	pushl  0x14(%ebp)
  8022f3:	ff 75 10             	pushl  0x10(%ebp)
  8022f6:	ff 75 0c             	pushl  0xc(%ebp)
  8022f9:	50                   	push   %eax
  8022fa:	6a 19                	push   $0x19
  8022fc:	e8 6c fd ff ff       	call   80206d <syscall>
  802301:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  802304:	c9                   	leave  
  802305:	c3                   	ret    

00802306 <sys_run_env>:

void sys_run_env(int32 envId) {
  802306:	55                   	push   %ebp
  802307:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  802309:	8b 45 08             	mov    0x8(%ebp),%eax
  80230c:	6a 00                	push   $0x0
  80230e:	6a 00                	push   $0x0
  802310:	6a 00                	push   $0x0
  802312:	6a 00                	push   $0x0
  802314:	50                   	push   %eax
  802315:	6a 1a                	push   $0x1a
  802317:	e8 51 fd ff ff       	call   80206d <syscall>
  80231c:	83 c4 18             	add    $0x18,%esp
}
  80231f:	90                   	nop
  802320:	c9                   	leave  
  802321:	c3                   	ret    

00802322 <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  802322:	55                   	push   %ebp
  802323:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802325:	8b 45 08             	mov    0x8(%ebp),%eax
  802328:	6a 00                	push   $0x0
  80232a:	6a 00                	push   $0x0
  80232c:	6a 00                	push   $0x0
  80232e:	6a 00                	push   $0x0
  802330:	50                   	push   %eax
  802331:	6a 1b                	push   $0x1b
  802333:	e8 35 fd ff ff       	call   80206d <syscall>
  802338:	83 c4 18             	add    $0x18,%esp
}
  80233b:	c9                   	leave  
  80233c:	c3                   	ret    

0080233d <sys_getenvid>:

int32 sys_getenvid(void) {
  80233d:	55                   	push   %ebp
  80233e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802340:	6a 00                	push   $0x0
  802342:	6a 00                	push   $0x0
  802344:	6a 00                	push   $0x0
  802346:	6a 00                	push   $0x0
  802348:	6a 00                	push   $0x0
  80234a:	6a 05                	push   $0x5
  80234c:	e8 1c fd ff ff       	call   80206d <syscall>
  802351:	83 c4 18             	add    $0x18,%esp
}
  802354:	c9                   	leave  
  802355:	c3                   	ret    

00802356 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  802356:	55                   	push   %ebp
  802357:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802359:	6a 00                	push   $0x0
  80235b:	6a 00                	push   $0x0
  80235d:	6a 00                	push   $0x0
  80235f:	6a 00                	push   $0x0
  802361:	6a 00                	push   $0x0
  802363:	6a 06                	push   $0x6
  802365:	e8 03 fd ff ff       	call   80206d <syscall>
  80236a:	83 c4 18             	add    $0x18,%esp
}
  80236d:	c9                   	leave  
  80236e:	c3                   	ret    

0080236f <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  80236f:	55                   	push   %ebp
  802370:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802372:	6a 00                	push   $0x0
  802374:	6a 00                	push   $0x0
  802376:	6a 00                	push   $0x0
  802378:	6a 00                	push   $0x0
  80237a:	6a 00                	push   $0x0
  80237c:	6a 07                	push   $0x7
  80237e:	e8 ea fc ff ff       	call   80206d <syscall>
  802383:	83 c4 18             	add    $0x18,%esp
}
  802386:	c9                   	leave  
  802387:	c3                   	ret    

00802388 <sys_exit_env>:

void sys_exit_env(void) {
  802388:	55                   	push   %ebp
  802389:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80238b:	6a 00                	push   $0x0
  80238d:	6a 00                	push   $0x0
  80238f:	6a 00                	push   $0x0
  802391:	6a 00                	push   $0x0
  802393:	6a 00                	push   $0x0
  802395:	6a 1c                	push   $0x1c
  802397:	e8 d1 fc ff ff       	call   80206d <syscall>
  80239c:	83 c4 18             	add    $0x18,%esp
}
  80239f:	90                   	nop
  8023a0:	c9                   	leave  
  8023a1:	c3                   	ret    

008023a2 <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  8023a2:	55                   	push   %ebp
  8023a3:	89 e5                	mov    %esp,%ebp
  8023a5:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  8023a8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8023ab:	8d 50 04             	lea    0x4(%eax),%edx
  8023ae:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8023b1:	6a 00                	push   $0x0
  8023b3:	6a 00                	push   $0x0
  8023b5:	6a 00                	push   $0x0
  8023b7:	52                   	push   %edx
  8023b8:	50                   	push   %eax
  8023b9:	6a 1d                	push   $0x1d
  8023bb:	e8 ad fc ff ff       	call   80206d <syscall>
  8023c0:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  8023c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8023c9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8023cc:	89 01                	mov    %eax,(%ecx)
  8023ce:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8023d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d4:	c9                   	leave  
  8023d5:	c2 04 00             	ret    $0x4

008023d8 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  8023d8:	55                   	push   %ebp
  8023d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  8023db:	6a 00                	push   $0x0
  8023dd:	6a 00                	push   $0x0
  8023df:	ff 75 10             	pushl  0x10(%ebp)
  8023e2:	ff 75 0c             	pushl  0xc(%ebp)
  8023e5:	ff 75 08             	pushl  0x8(%ebp)
  8023e8:	6a 13                	push   $0x13
  8023ea:	e8 7e fc ff ff       	call   80206d <syscall>
  8023ef:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  8023f2:	90                   	nop
}
  8023f3:	c9                   	leave  
  8023f4:	c3                   	ret    

008023f5 <sys_rcr2>:
uint32 sys_rcr2() {
  8023f5:	55                   	push   %ebp
  8023f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8023f8:	6a 00                	push   $0x0
  8023fa:	6a 00                	push   $0x0
  8023fc:	6a 00                	push   $0x0
  8023fe:	6a 00                	push   $0x0
  802400:	6a 00                	push   $0x0
  802402:	6a 1e                	push   $0x1e
  802404:	e8 64 fc ff ff       	call   80206d <syscall>
  802409:	83 c4 18             	add    $0x18,%esp
}
  80240c:	c9                   	leave  
  80240d:	c3                   	ret    

0080240e <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  80240e:	55                   	push   %ebp
  80240f:	89 e5                	mov    %esp,%ebp
  802411:	83 ec 04             	sub    $0x4,%esp
  802414:	8b 45 08             	mov    0x8(%ebp),%eax
  802417:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80241a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80241e:	6a 00                	push   $0x0
  802420:	6a 00                	push   $0x0
  802422:	6a 00                	push   $0x0
  802424:	6a 00                	push   $0x0
  802426:	50                   	push   %eax
  802427:	6a 1f                	push   $0x1f
  802429:	e8 3f fc ff ff       	call   80206d <syscall>
  80242e:	83 c4 18             	add    $0x18,%esp
	return;
  802431:	90                   	nop
}
  802432:	c9                   	leave  
  802433:	c3                   	ret    

00802434 <rsttst>:
void rsttst() {
  802434:	55                   	push   %ebp
  802435:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802437:	6a 00                	push   $0x0
  802439:	6a 00                	push   $0x0
  80243b:	6a 00                	push   $0x0
  80243d:	6a 00                	push   $0x0
  80243f:	6a 00                	push   $0x0
  802441:	6a 21                	push   $0x21
  802443:	e8 25 fc ff ff       	call   80206d <syscall>
  802448:	83 c4 18             	add    $0x18,%esp
	return;
  80244b:	90                   	nop
}
  80244c:	c9                   	leave  
  80244d:	c3                   	ret    

0080244e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  80244e:	55                   	push   %ebp
  80244f:	89 e5                	mov    %esp,%ebp
  802451:	83 ec 04             	sub    $0x4,%esp
  802454:	8b 45 14             	mov    0x14(%ebp),%eax
  802457:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80245a:	8b 55 18             	mov    0x18(%ebp),%edx
  80245d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802461:	52                   	push   %edx
  802462:	50                   	push   %eax
  802463:	ff 75 10             	pushl  0x10(%ebp)
  802466:	ff 75 0c             	pushl  0xc(%ebp)
  802469:	ff 75 08             	pushl  0x8(%ebp)
  80246c:	6a 20                	push   $0x20
  80246e:	e8 fa fb ff ff       	call   80206d <syscall>
  802473:	83 c4 18             	add    $0x18,%esp
	return;
  802476:	90                   	nop
}
  802477:	c9                   	leave  
  802478:	c3                   	ret    

00802479 <chktst>:
void chktst(uint32 n) {
  802479:	55                   	push   %ebp
  80247a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80247c:	6a 00                	push   $0x0
  80247e:	6a 00                	push   $0x0
  802480:	6a 00                	push   $0x0
  802482:	6a 00                	push   $0x0
  802484:	ff 75 08             	pushl  0x8(%ebp)
  802487:	6a 22                	push   $0x22
  802489:	e8 df fb ff ff       	call   80206d <syscall>
  80248e:	83 c4 18             	add    $0x18,%esp
	return;
  802491:	90                   	nop
}
  802492:	c9                   	leave  
  802493:	c3                   	ret    

00802494 <inctst>:

void inctst() {
  802494:	55                   	push   %ebp
  802495:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802497:	6a 00                	push   $0x0
  802499:	6a 00                	push   $0x0
  80249b:	6a 00                	push   $0x0
  80249d:	6a 00                	push   $0x0
  80249f:	6a 00                	push   $0x0
  8024a1:	6a 23                	push   $0x23
  8024a3:	e8 c5 fb ff ff       	call   80206d <syscall>
  8024a8:	83 c4 18             	add    $0x18,%esp
	return;
  8024ab:	90                   	nop
}
  8024ac:	c9                   	leave  
  8024ad:	c3                   	ret    

008024ae <gettst>:
uint32 gettst() {
  8024ae:	55                   	push   %ebp
  8024af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8024b1:	6a 00                	push   $0x0
  8024b3:	6a 00                	push   $0x0
  8024b5:	6a 00                	push   $0x0
  8024b7:	6a 00                	push   $0x0
  8024b9:	6a 00                	push   $0x0
  8024bb:	6a 24                	push   $0x24
  8024bd:	e8 ab fb ff ff       	call   80206d <syscall>
  8024c2:	83 c4 18             	add    $0x18,%esp
}
  8024c5:	c9                   	leave  
  8024c6:	c3                   	ret    

008024c7 <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  8024c7:	55                   	push   %ebp
  8024c8:	89 e5                	mov    %esp,%ebp
  8024ca:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024cd:	6a 00                	push   $0x0
  8024cf:	6a 00                	push   $0x0
  8024d1:	6a 00                	push   $0x0
  8024d3:	6a 00                	push   $0x0
  8024d5:	6a 00                	push   $0x0
  8024d7:	6a 25                	push   $0x25
  8024d9:	e8 8f fb ff ff       	call   80206d <syscall>
  8024de:	83 c4 18             	add    $0x18,%esp
  8024e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8024e4:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8024e8:	75 07                	jne    8024f1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8024ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8024ef:	eb 05                	jmp    8024f6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8024f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024f6:	c9                   	leave  
  8024f7:	c3                   	ret    

008024f8 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  8024f8:	55                   	push   %ebp
  8024f9:	89 e5                	mov    %esp,%ebp
  8024fb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024fe:	6a 00                	push   $0x0
  802500:	6a 00                	push   $0x0
  802502:	6a 00                	push   $0x0
  802504:	6a 00                	push   $0x0
  802506:	6a 00                	push   $0x0
  802508:	6a 25                	push   $0x25
  80250a:	e8 5e fb ff ff       	call   80206d <syscall>
  80250f:	83 c4 18             	add    $0x18,%esp
  802512:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802515:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802519:	75 07                	jne    802522 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80251b:	b8 01 00 00 00       	mov    $0x1,%eax
  802520:	eb 05                	jmp    802527 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802522:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802527:	c9                   	leave  
  802528:	c3                   	ret    

00802529 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  802529:	55                   	push   %ebp
  80252a:	89 e5                	mov    %esp,%ebp
  80252c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80252f:	6a 00                	push   $0x0
  802531:	6a 00                	push   $0x0
  802533:	6a 00                	push   $0x0
  802535:	6a 00                	push   $0x0
  802537:	6a 00                	push   $0x0
  802539:	6a 25                	push   $0x25
  80253b:	e8 2d fb ff ff       	call   80206d <syscall>
  802540:	83 c4 18             	add    $0x18,%esp
  802543:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802546:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80254a:	75 07                	jne    802553 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80254c:	b8 01 00 00 00       	mov    $0x1,%eax
  802551:	eb 05                	jmp    802558 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802553:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802558:	c9                   	leave  
  802559:	c3                   	ret    

0080255a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  80255a:	55                   	push   %ebp
  80255b:	89 e5                	mov    %esp,%ebp
  80255d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802560:	6a 00                	push   $0x0
  802562:	6a 00                	push   $0x0
  802564:	6a 00                	push   $0x0
  802566:	6a 00                	push   $0x0
  802568:	6a 00                	push   $0x0
  80256a:	6a 25                	push   $0x25
  80256c:	e8 fc fa ff ff       	call   80206d <syscall>
  802571:	83 c4 18             	add    $0x18,%esp
  802574:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802577:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80257b:	75 07                	jne    802584 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80257d:	b8 01 00 00 00       	mov    $0x1,%eax
  802582:	eb 05                	jmp    802589 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802584:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802589:	c9                   	leave  
  80258a:	c3                   	ret    

0080258b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  80258b:	55                   	push   %ebp
  80258c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80258e:	6a 00                	push   $0x0
  802590:	6a 00                	push   $0x0
  802592:	6a 00                	push   $0x0
  802594:	6a 00                	push   $0x0
  802596:	ff 75 08             	pushl  0x8(%ebp)
  802599:	6a 26                	push   $0x26
  80259b:	e8 cd fa ff ff       	call   80206d <syscall>
  8025a0:	83 c4 18             	add    $0x18,%esp
	return;
  8025a3:	90                   	nop
}
  8025a4:	c9                   	leave  
  8025a5:	c3                   	ret    

008025a6 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  8025a6:	55                   	push   %ebp
  8025a7:	89 e5                	mov    %esp,%ebp
  8025a9:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  8025aa:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8025ad:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8025b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b6:	6a 00                	push   $0x0
  8025b8:	53                   	push   %ebx
  8025b9:	51                   	push   %ecx
  8025ba:	52                   	push   %edx
  8025bb:	50                   	push   %eax
  8025bc:	6a 27                	push   $0x27
  8025be:	e8 aa fa ff ff       	call   80206d <syscall>
  8025c3:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  8025c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8025c9:	c9                   	leave  
  8025ca:	c3                   	ret    

008025cb <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  8025cb:	55                   	push   %ebp
  8025cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  8025ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d4:	6a 00                	push   $0x0
  8025d6:	6a 00                	push   $0x0
  8025d8:	6a 00                	push   $0x0
  8025da:	52                   	push   %edx
  8025db:	50                   	push   %eax
  8025dc:	6a 28                	push   $0x28
  8025de:	e8 8a fa ff ff       	call   80206d <syscall>
  8025e3:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  8025e6:	c9                   	leave  
  8025e7:	c3                   	ret    

008025e8 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  8025e8:	55                   	push   %ebp
  8025e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  8025eb:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8025ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f4:	6a 00                	push   $0x0
  8025f6:	51                   	push   %ecx
  8025f7:	ff 75 10             	pushl  0x10(%ebp)
  8025fa:	52                   	push   %edx
  8025fb:	50                   	push   %eax
  8025fc:	6a 29                	push   $0x29
  8025fe:	e8 6a fa ff ff       	call   80206d <syscall>
  802603:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  802606:	c9                   	leave  
  802607:	c3                   	ret    

00802608 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  802608:	55                   	push   %ebp
  802609:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80260b:	6a 00                	push   $0x0
  80260d:	6a 00                	push   $0x0
  80260f:	ff 75 10             	pushl  0x10(%ebp)
  802612:	ff 75 0c             	pushl  0xc(%ebp)
  802615:	ff 75 08             	pushl  0x8(%ebp)
  802618:	6a 12                	push   $0x12
  80261a:	e8 4e fa ff ff       	call   80206d <syscall>
  80261f:	83 c4 18             	add    $0x18,%esp
	return;
  802622:	90                   	nop
}
  802623:	c9                   	leave  
  802624:	c3                   	ret    

00802625 <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  802625:	55                   	push   %ebp
  802626:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  802628:	8b 55 0c             	mov    0xc(%ebp),%edx
  80262b:	8b 45 08             	mov    0x8(%ebp),%eax
  80262e:	6a 00                	push   $0x0
  802630:	6a 00                	push   $0x0
  802632:	6a 00                	push   $0x0
  802634:	52                   	push   %edx
  802635:	50                   	push   %eax
  802636:	6a 2a                	push   $0x2a
  802638:	e8 30 fa ff ff       	call   80206d <syscall>
  80263d:	83 c4 18             	add    $0x18,%esp
	return;
  802640:	90                   	nop
}
  802641:	c9                   	leave  
  802642:	c3                   	ret    

00802643 <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  802643:	55                   	push   %ebp
  802644:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  802646:	8b 45 08             	mov    0x8(%ebp),%eax
  802649:	6a 00                	push   $0x0
  80264b:	6a 00                	push   $0x0
  80264d:	6a 00                	push   $0x0
  80264f:	6a 00                	push   $0x0
  802651:	50                   	push   %eax
  802652:	6a 2b                	push   $0x2b
  802654:	e8 14 fa ff ff       	call   80206d <syscall>
  802659:	83 c4 18             	add    $0x18,%esp
}
  80265c:	c9                   	leave  
  80265d:	c3                   	ret    

0080265e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  80265e:	55                   	push   %ebp
  80265f:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802661:	6a 00                	push   $0x0
  802663:	6a 00                	push   $0x0
  802665:	6a 00                	push   $0x0
  802667:	ff 75 0c             	pushl  0xc(%ebp)
  80266a:	ff 75 08             	pushl  0x8(%ebp)
  80266d:	6a 2c                	push   $0x2c
  80266f:	e8 f9 f9 ff ff       	call   80206d <syscall>
  802674:	83 c4 18             	add    $0x18,%esp
	return;
  802677:	90                   	nop
}
  802678:	c9                   	leave  
  802679:	c3                   	ret    

0080267a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  80267a:	55                   	push   %ebp
  80267b:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80267d:	6a 00                	push   $0x0
  80267f:	6a 00                	push   $0x0
  802681:	6a 00                	push   $0x0
  802683:	ff 75 0c             	pushl  0xc(%ebp)
  802686:	ff 75 08             	pushl  0x8(%ebp)
  802689:	6a 2d                	push   $0x2d
  80268b:	e8 dd f9 ff ff       	call   80206d <syscall>
  802690:	83 c4 18             	add    $0x18,%esp
	return;
  802693:	90                   	nop
}
  802694:	c9                   	leave  
  802695:	c3                   	ret    

00802696 <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  802696:	55                   	push   %ebp
  802697:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  802699:	8b 45 08             	mov    0x8(%ebp),%eax
  80269c:	6a 00                	push   $0x0
  80269e:	6a 00                	push   $0x0
  8026a0:	6a 00                	push   $0x0
  8026a2:	6a 00                	push   $0x0
  8026a4:	50                   	push   %eax
  8026a5:	6a 2f                	push   $0x2f
  8026a7:	e8 c1 f9 ff ff       	call   80206d <syscall>
  8026ac:	83 c4 18             	add    $0x18,%esp
	return;
  8026af:	90                   	nop
}
  8026b0:	c9                   	leave  
  8026b1:	c3                   	ret    

008026b2 <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  8026b2:	55                   	push   %ebp
  8026b3:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  8026b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026bb:	6a 00                	push   $0x0
  8026bd:	6a 00                	push   $0x0
  8026bf:	6a 00                	push   $0x0
  8026c1:	52                   	push   %edx
  8026c2:	50                   	push   %eax
  8026c3:	6a 30                	push   $0x30
  8026c5:	e8 a3 f9 ff ff       	call   80206d <syscall>
  8026ca:	83 c4 18             	add    $0x18,%esp
	return;
  8026cd:	90                   	nop
}
  8026ce:	c9                   	leave  
  8026cf:	c3                   	ret    

008026d0 <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  8026d0:	55                   	push   %ebp
  8026d1:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  8026d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d6:	6a 00                	push   $0x0
  8026d8:	6a 00                	push   $0x0
  8026da:	6a 00                	push   $0x0
  8026dc:	6a 00                	push   $0x0
  8026de:	50                   	push   %eax
  8026df:	6a 31                	push   $0x31
  8026e1:	e8 87 f9 ff ff       	call   80206d <syscall>
  8026e6:	83 c4 18             	add    $0x18,%esp
	return;
  8026e9:	90                   	nop
}
  8026ea:	c9                   	leave  
  8026eb:	c3                   	ret    

008026ec <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  8026ec:	55                   	push   %ebp
  8026ed:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8026ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f5:	6a 00                	push   $0x0
  8026f7:	6a 00                	push   $0x0
  8026f9:	6a 00                	push   $0x0
  8026fb:	52                   	push   %edx
  8026fc:	50                   	push   %eax
  8026fd:	6a 2e                	push   $0x2e
  8026ff:	e8 69 f9 ff ff       	call   80206d <syscall>
  802704:	83 c4 18             	add    $0x18,%esp
    return;
  802707:	90                   	nop
}
  802708:	c9                   	leave  
  802709:	c3                   	ret    

0080270a <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  80270a:	55                   	push   %ebp
  80270b:	89 e5                	mov    %esp,%ebp
  80270d:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802710:	8b 45 08             	mov    0x8(%ebp),%eax
  802713:	83 e8 04             	sub    $0x4,%eax
  802716:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802719:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80271c:	8b 00                	mov    (%eax),%eax
  80271e:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802721:	c9                   	leave  
  802722:	c3                   	ret    

00802723 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802723:	55                   	push   %ebp
  802724:	89 e5                	mov    %esp,%ebp
  802726:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802729:	8b 45 08             	mov    0x8(%ebp),%eax
  80272c:	83 e8 04             	sub    $0x4,%eax
  80272f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802732:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802735:	8b 00                	mov    (%eax),%eax
  802737:	83 e0 01             	and    $0x1,%eax
  80273a:	85 c0                	test   %eax,%eax
  80273c:	0f 94 c0             	sete   %al
}
  80273f:	c9                   	leave  
  802740:	c3                   	ret    

00802741 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802741:	55                   	push   %ebp
  802742:	89 e5                	mov    %esp,%ebp
  802744:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802747:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  80274e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802751:	83 f8 02             	cmp    $0x2,%eax
  802754:	74 2b                	je     802781 <alloc_block+0x40>
  802756:	83 f8 02             	cmp    $0x2,%eax
  802759:	7f 07                	jg     802762 <alloc_block+0x21>
  80275b:	83 f8 01             	cmp    $0x1,%eax
  80275e:	74 0e                	je     80276e <alloc_block+0x2d>
  802760:	eb 58                	jmp    8027ba <alloc_block+0x79>
  802762:	83 f8 03             	cmp    $0x3,%eax
  802765:	74 2d                	je     802794 <alloc_block+0x53>
  802767:	83 f8 04             	cmp    $0x4,%eax
  80276a:	74 3b                	je     8027a7 <alloc_block+0x66>
  80276c:	eb 4c                	jmp    8027ba <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  80276e:	83 ec 0c             	sub    $0xc,%esp
  802771:	ff 75 08             	pushl  0x8(%ebp)
  802774:	e8 f7 03 00 00       	call   802b70 <alloc_block_FF>
  802779:	83 c4 10             	add    $0x10,%esp
  80277c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80277f:	eb 4a                	jmp    8027cb <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802781:	83 ec 0c             	sub    $0xc,%esp
  802784:	ff 75 08             	pushl  0x8(%ebp)
  802787:	e8 f0 11 00 00       	call   80397c <alloc_block_NF>
  80278c:	83 c4 10             	add    $0x10,%esp
  80278f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802792:	eb 37                	jmp    8027cb <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802794:	83 ec 0c             	sub    $0xc,%esp
  802797:	ff 75 08             	pushl  0x8(%ebp)
  80279a:	e8 08 08 00 00       	call   802fa7 <alloc_block_BF>
  80279f:	83 c4 10             	add    $0x10,%esp
  8027a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8027a5:	eb 24                	jmp    8027cb <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8027a7:	83 ec 0c             	sub    $0xc,%esp
  8027aa:	ff 75 08             	pushl  0x8(%ebp)
  8027ad:	e8 ad 11 00 00       	call   80395f <alloc_block_WF>
  8027b2:	83 c4 10             	add    $0x10,%esp
  8027b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8027b8:	eb 11                	jmp    8027cb <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8027ba:	83 ec 0c             	sub    $0xc,%esp
  8027bd:	68 2c 44 80 00       	push   $0x80442c
  8027c2:	e8 39 e2 ff ff       	call   800a00 <cprintf>
  8027c7:	83 c4 10             	add    $0x10,%esp
		break;
  8027ca:	90                   	nop
	}
	return va;
  8027cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8027ce:	c9                   	leave  
  8027cf:	c3                   	ret    

008027d0 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8027d0:	55                   	push   %ebp
  8027d1:	89 e5                	mov    %esp,%ebp
  8027d3:	53                   	push   %ebx
  8027d4:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8027d7:	83 ec 0c             	sub    $0xc,%esp
  8027da:	68 4c 44 80 00       	push   $0x80444c
  8027df:	e8 1c e2 ff ff       	call   800a00 <cprintf>
  8027e4:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8027e7:	83 ec 0c             	sub    $0xc,%esp
  8027ea:	68 77 44 80 00       	push   $0x804477
  8027ef:	e8 0c e2 ff ff       	call   800a00 <cprintf>
  8027f4:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8027f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027fd:	eb 37                	jmp    802836 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8027ff:	83 ec 0c             	sub    $0xc,%esp
  802802:	ff 75 f4             	pushl  -0xc(%ebp)
  802805:	e8 19 ff ff ff       	call   802723 <is_free_block>
  80280a:	83 c4 10             	add    $0x10,%esp
  80280d:	0f be d8             	movsbl %al,%ebx
  802810:	83 ec 0c             	sub    $0xc,%esp
  802813:	ff 75 f4             	pushl  -0xc(%ebp)
  802816:	e8 ef fe ff ff       	call   80270a <get_block_size>
  80281b:	83 c4 10             	add    $0x10,%esp
  80281e:	83 ec 04             	sub    $0x4,%esp
  802821:	53                   	push   %ebx
  802822:	50                   	push   %eax
  802823:	68 8f 44 80 00       	push   $0x80448f
  802828:	e8 d3 e1 ff ff       	call   800a00 <cprintf>
  80282d:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802830:	8b 45 10             	mov    0x10(%ebp),%eax
  802833:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802836:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80283a:	74 07                	je     802843 <print_blocks_list+0x73>
  80283c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283f:	8b 00                	mov    (%eax),%eax
  802841:	eb 05                	jmp    802848 <print_blocks_list+0x78>
  802843:	b8 00 00 00 00       	mov    $0x0,%eax
  802848:	89 45 10             	mov    %eax,0x10(%ebp)
  80284b:	8b 45 10             	mov    0x10(%ebp),%eax
  80284e:	85 c0                	test   %eax,%eax
  802850:	75 ad                	jne    8027ff <print_blocks_list+0x2f>
  802852:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802856:	75 a7                	jne    8027ff <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802858:	83 ec 0c             	sub    $0xc,%esp
  80285b:	68 4c 44 80 00       	push   $0x80444c
  802860:	e8 9b e1 ff ff       	call   800a00 <cprintf>
  802865:	83 c4 10             	add    $0x10,%esp

}
  802868:	90                   	nop
  802869:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80286c:	c9                   	leave  
  80286d:	c3                   	ret    

0080286e <initialize_dynamic_allocator>:

//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  80286e:	55                   	push   %ebp
  80286f:	89 e5                	mov    %esp,%ebp
  802871:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802874:	8b 45 0c             	mov    0xc(%ebp),%eax
  802877:	83 e0 01             	and    $0x1,%eax
  80287a:	85 c0                	test   %eax,%eax
  80287c:	74 03                	je     802881 <initialize_dynamic_allocator+0x13>
  80287e:	ff 45 0c             	incl   0xc(%ebp)
		if (initSizeOfAllocatedSpace == 0)
  802881:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802885:	0f 84 f8 00 00 00    	je     802983 <initialize_dynamic_allocator+0x115>
			return ;
		is_initialized = 1;
  80288b:	c7 05 40 50 98 00 01 	movl   $0x1,0x985040
  802892:	00 00 00 
	//TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("initialize_dynamic_allocator is not implemented yet");
	//Your Code is Here...

	if(is_initialized){
  802895:	a1 40 50 98 00       	mov    0x985040,%eax
  80289a:	85 c0                	test   %eax,%eax
  80289c:	0f 84 e2 00 00 00    	je     802984 <initialize_dynamic_allocator+0x116>

		// begin block with size 0 and lsb = 1 (allocated)
		uint32* beginBlock = (uint32*)daStart;
  8028a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		*beginBlock = 0 | 1; // size = 0, LSB as a flag = 1
  8028a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ab:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		// end block with size 0 and lsb = 1 (allocated)
		uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);
  8028b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8028b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028b7:	01 d0                	add    %edx,%eax
  8028b9:	83 e8 04             	sub    $0x4,%eax
  8028bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
		*endBlock = 0 | 1; // size = 0, LSB as a flag = 1
  8028bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c2:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

		// the block that between begin and end blocks
		struct BlockElement* block = (struct BlockElement*)(daStart + 8);
  8028c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028cb:	83 c0 08             	add    $0x8,%eax
  8028ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 blockSize = initSizeOfAllocatedSpace - 8; // subtract size of begin and end blocks
  8028d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028d4:	83 e8 08             	sub    $0x8,%eax
  8028d7:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(block,blockSize,0);
  8028da:	83 ec 04             	sub    $0x4,%esp
  8028dd:	6a 00                	push   $0x0
  8028df:	ff 75 e8             	pushl  -0x18(%ebp)
  8028e2:	ff 75 ec             	pushl  -0x14(%ebp)
  8028e5:	e8 9c 00 00 00       	call   802986 <set_block_data>
  8028ea:	83 c4 10             	add    $0x10,%esp

		block->prev_next_info.le_next = NULL;
  8028ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block->prev_next_info.le_prev = NULL;
  8028f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028f9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

		LIST_INIT(&freeBlocksList);
  802900:	c7 05 48 50 98 00 00 	movl   $0x0,0x985048
  802907:	00 00 00 
  80290a:	c7 05 4c 50 98 00 00 	movl   $0x0,0x98504c
  802911:	00 00 00 
  802914:	c7 05 54 50 98 00 00 	movl   $0x0,0x985054
  80291b:	00 00 00 
		LIST_INSERT_HEAD(&freeBlocksList, block);
  80291e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802922:	75 17                	jne    80293b <initialize_dynamic_allocator+0xcd>
  802924:	83 ec 04             	sub    $0x4,%esp
  802927:	68 a8 44 80 00       	push   $0x8044a8
  80292c:	68 80 00 00 00       	push   $0x80
  802931:	68 cb 44 80 00       	push   $0x8044cb
  802936:	e8 08 de ff ff       	call   800743 <_panic>
  80293b:	8b 15 48 50 98 00    	mov    0x985048,%edx
  802941:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802944:	89 10                	mov    %edx,(%eax)
  802946:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802949:	8b 00                	mov    (%eax),%eax
  80294b:	85 c0                	test   %eax,%eax
  80294d:	74 0d                	je     80295c <initialize_dynamic_allocator+0xee>
  80294f:	a1 48 50 98 00       	mov    0x985048,%eax
  802954:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802957:	89 50 04             	mov    %edx,0x4(%eax)
  80295a:	eb 08                	jmp    802964 <initialize_dynamic_allocator+0xf6>
  80295c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80295f:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802964:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802967:	a3 48 50 98 00       	mov    %eax,0x985048
  80296c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80296f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802976:	a1 54 50 98 00       	mov    0x985054,%eax
  80297b:	40                   	inc    %eax
  80297c:	a3 54 50 98 00       	mov    %eax,0x985054
  802981:	eb 01                	jmp    802984 <initialize_dynamic_allocator+0x116>
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
		if (initSizeOfAllocatedSpace == 0)
			return ;
  802983:	90                   	nop
		block->prev_next_info.le_prev = NULL;

		LIST_INIT(&freeBlocksList);
		LIST_INSERT_HEAD(&freeBlocksList, block);
	}
}
  802984:	c9                   	leave  
  802985:	c3                   	ret    

00802986 <set_block_data>:
//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802986:	55                   	push   %ebp
  802987:	89 e5                	mov    %esp,%ebp
  802989:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("set_block_data is not implemented yet");
	//Your Code is Here...

	if(totalSize % 2 != 0)
  80298c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80298f:	83 e0 01             	and    $0x1,%eax
  802992:	85 c0                	test   %eax,%eax
  802994:	74 03                	je     802999 <set_block_data+0x13>
	{
		totalSize++;
  802996:	ff 45 0c             	incl   0xc(%ebp)
	}

	uint32* header = (uint32 *)((uint32*)va-1);
  802999:	8b 45 08             	mov    0x8(%ebp),%eax
  80299c:	83 e8 04             	sub    $0x4,%eax
  80299f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//	size => totalSize with LSB = 0		 set LSB = 1 if isAllocated
	*header = (totalSize & ~1) | (isAllocated & 1);
  8029a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029a5:	83 e0 fe             	and    $0xfffffffe,%eax
  8029a8:	89 c2                	mov    %eax,%edx
  8029aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8029ad:	83 e0 01             	and    $0x1,%eax
  8029b0:	09 c2                	or     %eax,%edx
  8029b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8029b5:	89 10                	mov    %edx,(%eax)
	uint32* footer = (uint32*) (va + totalSize - 8);
  8029b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029ba:	8d 50 f8             	lea    -0x8(%eax),%edx
  8029bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c0:	01 d0                	add    %edx,%eax
  8029c2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	*footer = (totalSize & ~1) | (isAllocated & 1);
  8029c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029c8:	83 e0 fe             	and    $0xfffffffe,%eax
  8029cb:	89 c2                	mov    %eax,%edx
  8029cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8029d0:	83 e0 01             	and    $0x1,%eax
  8029d3:	09 c2                	or     %eax,%edx
  8029d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8029d8:	89 10                	mov    %edx,(%eax)
}
  8029da:	90                   	nop
  8029db:	c9                   	leave  
  8029dc:	c3                   	ret    

008029dd <insert_sorted_in_freeList>:
//=========================================
void insert_sorted_in_freeList(struct BlockElement *newBlock)
{
  8029dd:	55                   	push   %ebp
  8029de:	89 e5                	mov    %esp,%ebp
  8029e0:	83 ec 18             	sub    $0x18,%esp
	if(LIST_EMPTY(&freeBlocksList))
  8029e3:	a1 48 50 98 00       	mov    0x985048,%eax
  8029e8:	85 c0                	test   %eax,%eax
  8029ea:	75 68                	jne    802a54 <insert_sorted_in_freeList+0x77>
	{
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
  8029ec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029f0:	75 17                	jne    802a09 <insert_sorted_in_freeList+0x2c>
  8029f2:	83 ec 04             	sub    $0x4,%esp
  8029f5:	68 a8 44 80 00       	push   $0x8044a8
  8029fa:	68 9d 00 00 00       	push   $0x9d
  8029ff:	68 cb 44 80 00       	push   $0x8044cb
  802a04:	e8 3a dd ff ff       	call   800743 <_panic>
  802a09:	8b 15 48 50 98 00    	mov    0x985048,%edx
  802a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a12:	89 10                	mov    %edx,(%eax)
  802a14:	8b 45 08             	mov    0x8(%ebp),%eax
  802a17:	8b 00                	mov    (%eax),%eax
  802a19:	85 c0                	test   %eax,%eax
  802a1b:	74 0d                	je     802a2a <insert_sorted_in_freeList+0x4d>
  802a1d:	a1 48 50 98 00       	mov    0x985048,%eax
  802a22:	8b 55 08             	mov    0x8(%ebp),%edx
  802a25:	89 50 04             	mov    %edx,0x4(%eax)
  802a28:	eb 08                	jmp    802a32 <insert_sorted_in_freeList+0x55>
  802a2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2d:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802a32:	8b 45 08             	mov    0x8(%ebp),%eax
  802a35:	a3 48 50 98 00       	mov    %eax,0x985048
  802a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a44:	a1 54 50 98 00       	mov    0x985054,%eax
  802a49:	40                   	inc    %eax
  802a4a:	a3 54 50 98 00       	mov    %eax,0x985054
		return;
  802a4f:	e9 1a 01 00 00       	jmp    802b6e <insert_sorted_in_freeList+0x191>
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  802a54:	a1 48 50 98 00       	mov    0x985048,%eax
  802a59:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a5c:	eb 7f                	jmp    802add <insert_sorted_in_freeList+0x100>
	{
		if(blk > newBlock) // if address of blk > address of newBlock => add newBlock before blk
  802a5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a61:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a64:	76 6f                	jbe    802ad5 <insert_sorted_in_freeList+0xf8>
		{
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
  802a66:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a6a:	74 06                	je     802a72 <insert_sorted_in_freeList+0x95>
  802a6c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a70:	75 17                	jne    802a89 <insert_sorted_in_freeList+0xac>
  802a72:	83 ec 04             	sub    $0x4,%esp
  802a75:	68 e4 44 80 00       	push   $0x8044e4
  802a7a:	68 a6 00 00 00       	push   $0xa6
  802a7f:	68 cb 44 80 00       	push   $0x8044cb
  802a84:	e8 ba dc ff ff       	call   800743 <_panic>
  802a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8c:	8b 50 04             	mov    0x4(%eax),%edx
  802a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a92:	89 50 04             	mov    %edx,0x4(%eax)
  802a95:	8b 45 08             	mov    0x8(%ebp),%eax
  802a98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a9b:	89 10                	mov    %edx,(%eax)
  802a9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa0:	8b 40 04             	mov    0x4(%eax),%eax
  802aa3:	85 c0                	test   %eax,%eax
  802aa5:	74 0d                	je     802ab4 <insert_sorted_in_freeList+0xd7>
  802aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aaa:	8b 40 04             	mov    0x4(%eax),%eax
  802aad:	8b 55 08             	mov    0x8(%ebp),%edx
  802ab0:	89 10                	mov    %edx,(%eax)
  802ab2:	eb 08                	jmp    802abc <insert_sorted_in_freeList+0xdf>
  802ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab7:	a3 48 50 98 00       	mov    %eax,0x985048
  802abc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abf:	8b 55 08             	mov    0x8(%ebp),%edx
  802ac2:	89 50 04             	mov    %edx,0x4(%eax)
  802ac5:	a1 54 50 98 00       	mov    0x985054,%eax
  802aca:	40                   	inc    %eax
  802acb:	a3 54 50 98 00       	mov    %eax,0x985054
			return;
  802ad0:	e9 99 00 00 00       	jmp    802b6e <insert_sorted_in_freeList+0x191>
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
		return;
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  802ad5:	a1 50 50 98 00       	mov    0x985050,%eax
  802ada:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802add:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ae1:	74 07                	je     802aea <insert_sorted_in_freeList+0x10d>
  802ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae6:	8b 00                	mov    (%eax),%eax
  802ae8:	eb 05                	jmp    802aef <insert_sorted_in_freeList+0x112>
  802aea:	b8 00 00 00 00       	mov    $0x0,%eax
  802aef:	a3 50 50 98 00       	mov    %eax,0x985050
  802af4:	a1 50 50 98 00       	mov    0x985050,%eax
  802af9:	85 c0                	test   %eax,%eax
  802afb:	0f 85 5d ff ff ff    	jne    802a5e <insert_sorted_in_freeList+0x81>
  802b01:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b05:	0f 85 53 ff ff ff    	jne    802a5e <insert_sorted_in_freeList+0x81>
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
			return;
		}
	}
	// if no blk its address > newBlock
	LIST_INSERT_TAIL(&freeBlocksList, newBlock);
  802b0b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b0f:	75 17                	jne    802b28 <insert_sorted_in_freeList+0x14b>
  802b11:	83 ec 04             	sub    $0x4,%esp
  802b14:	68 1c 45 80 00       	push   $0x80451c
  802b19:	68 ab 00 00 00       	push   $0xab
  802b1e:	68 cb 44 80 00       	push   $0x8044cb
  802b23:	e8 1b dc ff ff       	call   800743 <_panic>
  802b28:	8b 15 4c 50 98 00    	mov    0x98504c,%edx
  802b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b31:	89 50 04             	mov    %edx,0x4(%eax)
  802b34:	8b 45 08             	mov    0x8(%ebp),%eax
  802b37:	8b 40 04             	mov    0x4(%eax),%eax
  802b3a:	85 c0                	test   %eax,%eax
  802b3c:	74 0c                	je     802b4a <insert_sorted_in_freeList+0x16d>
  802b3e:	a1 4c 50 98 00       	mov    0x98504c,%eax
  802b43:	8b 55 08             	mov    0x8(%ebp),%edx
  802b46:	89 10                	mov    %edx,(%eax)
  802b48:	eb 08                	jmp    802b52 <insert_sorted_in_freeList+0x175>
  802b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4d:	a3 48 50 98 00       	mov    %eax,0x985048
  802b52:	8b 45 08             	mov    0x8(%ebp),%eax
  802b55:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b63:	a1 54 50 98 00       	mov    0x985054,%eax
  802b68:	40                   	inc    %eax
  802b69:	a3 54 50 98 00       	mov    %eax,0x985054
}
  802b6e:	c9                   	leave  
  802b6f:	c3                   	ret    

00802b70 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  802b70:	55                   	push   %ebp
  802b71:	89 e5                	mov    %esp,%ebp
  802b73:	83 ec 78             	sub    $0x78,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802b76:	8b 45 08             	mov    0x8(%ebp),%eax
  802b79:	83 e0 01             	and    $0x1,%eax
  802b7c:	85 c0                	test   %eax,%eax
  802b7e:	74 03                	je     802b83 <alloc_block_FF+0x13>
  802b80:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802b83:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802b87:	77 07                	ja     802b90 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802b89:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802b90:	a1 40 50 98 00       	mov    0x985040,%eax
  802b95:	85 c0                	test   %eax,%eax
  802b97:	75 63                	jne    802bfc <alloc_block_FF+0x8c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802b99:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9c:	83 c0 10             	add    $0x10,%eax
  802b9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802ba2:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802ba9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802baf:	01 d0                	add    %edx,%eax
  802bb1:	48                   	dec    %eax
  802bb2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802bb5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bb8:	ba 00 00 00 00       	mov    $0x0,%edx
  802bbd:	f7 75 ec             	divl   -0x14(%ebp)
  802bc0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bc3:	29 d0                	sub    %edx,%eax
  802bc5:	c1 e8 0c             	shr    $0xc,%eax
  802bc8:	83 ec 0c             	sub    $0xc,%esp
  802bcb:	50                   	push   %eax
  802bcc:	e8 d1 ed ff ff       	call   8019a2 <sbrk>
  802bd1:	83 c4 10             	add    $0x10,%esp
  802bd4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802bd7:	83 ec 0c             	sub    $0xc,%esp
  802bda:	6a 00                	push   $0x0
  802bdc:	e8 c1 ed ff ff       	call   8019a2 <sbrk>
  802be1:	83 c4 10             	add    $0x10,%esp
  802be4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802be7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bea:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802bed:	83 ec 08             	sub    $0x8,%esp
  802bf0:	50                   	push   %eax
  802bf1:	ff 75 e4             	pushl  -0x1c(%ebp)
  802bf4:	e8 75 fc ff ff       	call   80286e <initialize_dynamic_allocator>
  802bf9:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(size == 0)
  802bfc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c00:	75 0a                	jne    802c0c <alloc_block_FF+0x9c>
	{
		return NULL;
  802c02:	b8 00 00 00 00       	mov    $0x0,%eax
  802c07:	e9 99 03 00 00       	jmp    802fa5 <alloc_block_FF+0x435>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  802c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0f:	83 c0 08             	add    $0x8,%eax
  802c12:	89 45 dc             	mov    %eax,-0x24(%ebp)

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802c15:	a1 48 50 98 00       	mov    0x985048,%eax
  802c1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c1d:	e9 03 02 00 00       	jmp    802e25 <alloc_block_FF+0x2b5>
	{
		uint32 blockSize = get_block_size(block); // Get size without the (LSB) allocation flag
  802c22:	83 ec 0c             	sub    $0xc,%esp
  802c25:	ff 75 f4             	pushl  -0xc(%ebp)
  802c28:	e8 dd fa ff ff       	call   80270a <get_block_size>
  802c2d:	83 c4 10             	add    $0x10,%esp
  802c30:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if(blockSize >= totalSize)
  802c33:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802c36:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802c39:	0f 82 de 01 00 00    	jb     802e1d <alloc_block_FF+0x2ad>
		{	//if we can put another block with min size 16
			if(blockSize >= totalSize + 4*sizeof(uint32))
  802c3f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c42:	83 c0 10             	add    $0x10,%eax
  802c45:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  802c48:	0f 87 32 01 00 00    	ja     802d80 <alloc_block_FF+0x210>
			{
				// the size that will remain from the block that we will allocate a new block in it
				uint32 remainingSize = blockSize - totalSize;
  802c4e:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802c51:	2b 45 dc             	sub    -0x24(%ebp),%eax
  802c54:	89 45 98             	mov    %eax,-0x68(%ebp)

				// the remaining free space from the block that we use to allocate in it
				struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)block + totalSize);
  802c57:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c5a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c5d:	01 d0                	add    %edx,%eax
  802c5f:	89 45 94             	mov    %eax,-0x6c(%ebp)
				set_block_data(remainingFreeBlock, remainingSize, 0);
  802c62:	83 ec 04             	sub    $0x4,%esp
  802c65:	6a 00                	push   $0x0
  802c67:	ff 75 98             	pushl  -0x68(%ebp)
  802c6a:	ff 75 94             	pushl  -0x6c(%ebp)
  802c6d:	e8 14 fd ff ff       	call   802986 <set_block_data>
  802c72:	83 c4 10             	add    $0x10,%esp
				// add it after the block we allocated to be sorted by addresses
				LIST_INSERT_AFTER(&freeBlocksList, block,remainingFreeBlock);
  802c75:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c79:	74 06                	je     802c81 <alloc_block_FF+0x111>
  802c7b:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
  802c7f:	75 17                	jne    802c98 <alloc_block_FF+0x128>
  802c81:	83 ec 04             	sub    $0x4,%esp
  802c84:	68 40 45 80 00       	push   $0x804540
  802c89:	68 de 00 00 00       	push   $0xde
  802c8e:	68 cb 44 80 00       	push   $0x8044cb
  802c93:	e8 ab da ff ff       	call   800743 <_panic>
  802c98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9b:	8b 10                	mov    (%eax),%edx
  802c9d:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802ca0:	89 10                	mov    %edx,(%eax)
  802ca2:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802ca5:	8b 00                	mov    (%eax),%eax
  802ca7:	85 c0                	test   %eax,%eax
  802ca9:	74 0b                	je     802cb6 <alloc_block_FF+0x146>
  802cab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cae:	8b 00                	mov    (%eax),%eax
  802cb0:	8b 55 94             	mov    -0x6c(%ebp),%edx
  802cb3:	89 50 04             	mov    %edx,0x4(%eax)
  802cb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb9:	8b 55 94             	mov    -0x6c(%ebp),%edx
  802cbc:	89 10                	mov    %edx,(%eax)
  802cbe:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802cc1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cc4:	89 50 04             	mov    %edx,0x4(%eax)
  802cc7:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802cca:	8b 00                	mov    (%eax),%eax
  802ccc:	85 c0                	test   %eax,%eax
  802cce:	75 08                	jne    802cd8 <alloc_block_FF+0x168>
  802cd0:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802cd3:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802cd8:	a1 54 50 98 00       	mov    0x985054,%eax
  802cdd:	40                   	inc    %eax
  802cde:	a3 54 50 98 00       	mov    %eax,0x985054

				// update the allocated block and remove it from freeBlocksList
				set_block_data(block,totalSize,1);
  802ce3:	83 ec 04             	sub    $0x4,%esp
  802ce6:	6a 01                	push   $0x1
  802ce8:	ff 75 dc             	pushl  -0x24(%ebp)
  802ceb:	ff 75 f4             	pushl  -0xc(%ebp)
  802cee:	e8 93 fc ff ff       	call   802986 <set_block_data>
  802cf3:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  802cf6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cfa:	75 17                	jne    802d13 <alloc_block_FF+0x1a3>
  802cfc:	83 ec 04             	sub    $0x4,%esp
  802cff:	68 74 45 80 00       	push   $0x804574
  802d04:	68 e3 00 00 00       	push   $0xe3
  802d09:	68 cb 44 80 00       	push   $0x8044cb
  802d0e:	e8 30 da ff ff       	call   800743 <_panic>
  802d13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d16:	8b 00                	mov    (%eax),%eax
  802d18:	85 c0                	test   %eax,%eax
  802d1a:	74 10                	je     802d2c <alloc_block_FF+0x1bc>
  802d1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1f:	8b 00                	mov    (%eax),%eax
  802d21:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d24:	8b 52 04             	mov    0x4(%edx),%edx
  802d27:	89 50 04             	mov    %edx,0x4(%eax)
  802d2a:	eb 0b                	jmp    802d37 <alloc_block_FF+0x1c7>
  802d2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2f:	8b 40 04             	mov    0x4(%eax),%eax
  802d32:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802d37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3a:	8b 40 04             	mov    0x4(%eax),%eax
  802d3d:	85 c0                	test   %eax,%eax
  802d3f:	74 0f                	je     802d50 <alloc_block_FF+0x1e0>
  802d41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d44:	8b 40 04             	mov    0x4(%eax),%eax
  802d47:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d4a:	8b 12                	mov    (%edx),%edx
  802d4c:	89 10                	mov    %edx,(%eax)
  802d4e:	eb 0a                	jmp    802d5a <alloc_block_FF+0x1ea>
  802d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d53:	8b 00                	mov    (%eax),%eax
  802d55:	a3 48 50 98 00       	mov    %eax,0x985048
  802d5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d66:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d6d:	a1 54 50 98 00       	mov    0x985054,%eax
  802d72:	48                   	dec    %eax
  802d73:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  802d78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7b:	e9 25 02 00 00       	jmp    802fa5 <alloc_block_FF+0x435>
			}
			else // if set internal fragmentation
			{
				// add the remaining size to the block we allocate so it will be the same main block size
				set_block_data(block,blockSize,1);
  802d80:	83 ec 04             	sub    $0x4,%esp
  802d83:	6a 01                	push   $0x1
  802d85:	ff 75 9c             	pushl  -0x64(%ebp)
  802d88:	ff 75 f4             	pushl  -0xc(%ebp)
  802d8b:	e8 f6 fb ff ff       	call   802986 <set_block_data>
  802d90:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  802d93:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d97:	75 17                	jne    802db0 <alloc_block_FF+0x240>
  802d99:	83 ec 04             	sub    $0x4,%esp
  802d9c:	68 74 45 80 00       	push   $0x804574
  802da1:	68 eb 00 00 00       	push   $0xeb
  802da6:	68 cb 44 80 00       	push   $0x8044cb
  802dab:	e8 93 d9 ff ff       	call   800743 <_panic>
  802db0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db3:	8b 00                	mov    (%eax),%eax
  802db5:	85 c0                	test   %eax,%eax
  802db7:	74 10                	je     802dc9 <alloc_block_FF+0x259>
  802db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbc:	8b 00                	mov    (%eax),%eax
  802dbe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dc1:	8b 52 04             	mov    0x4(%edx),%edx
  802dc4:	89 50 04             	mov    %edx,0x4(%eax)
  802dc7:	eb 0b                	jmp    802dd4 <alloc_block_FF+0x264>
  802dc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcc:	8b 40 04             	mov    0x4(%eax),%eax
  802dcf:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802dd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd7:	8b 40 04             	mov    0x4(%eax),%eax
  802dda:	85 c0                	test   %eax,%eax
  802ddc:	74 0f                	je     802ded <alloc_block_FF+0x27d>
  802dde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de1:	8b 40 04             	mov    0x4(%eax),%eax
  802de4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802de7:	8b 12                	mov    (%edx),%edx
  802de9:	89 10                	mov    %edx,(%eax)
  802deb:	eb 0a                	jmp    802df7 <alloc_block_FF+0x287>
  802ded:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df0:	8b 00                	mov    (%eax),%eax
  802df2:	a3 48 50 98 00       	mov    %eax,0x985048
  802df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e03:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e0a:	a1 54 50 98 00       	mov    0x985054,%eax
  802e0f:	48                   	dec    %eax
  802e10:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  802e15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e18:	e9 88 01 00 00       	jmp    802fa5 <alloc_block_FF+0x435>
		return NULL;
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802e1d:	a1 50 50 98 00       	mov    0x985050,%eax
  802e22:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e25:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e29:	74 07                	je     802e32 <alloc_block_FF+0x2c2>
  802e2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2e:	8b 00                	mov    (%eax),%eax
  802e30:	eb 05                	jmp    802e37 <alloc_block_FF+0x2c7>
  802e32:	b8 00 00 00 00       	mov    $0x0,%eax
  802e37:	a3 50 50 98 00       	mov    %eax,0x985050
  802e3c:	a1 50 50 98 00       	mov    0x985050,%eax
  802e41:	85 c0                	test   %eax,%eax
  802e43:	0f 85 d9 fd ff ff    	jne    802c22 <alloc_block_FF+0xb2>
  802e49:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e4d:	0f 85 cf fd ff ff    	jne    802c22 <alloc_block_FF+0xb2>

//	uint32 *endBlock = &kheapBreak;

	// if we don't find any enough space to allocate the block

	void *oldBreak = sbrk(ROUNDUP(totalSize, PAGE_SIZE) / PAGE_SIZE);
  802e53:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802e5a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e5d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802e60:	01 d0                	add    %edx,%eax
  802e62:	48                   	dec    %eax
  802e63:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802e66:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e69:	ba 00 00 00 00       	mov    $0x0,%edx
  802e6e:	f7 75 d8             	divl   -0x28(%ebp)
  802e71:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e74:	29 d0                	sub    %edx,%eax
  802e76:	c1 e8 0c             	shr    $0xc,%eax
  802e79:	83 ec 0c             	sub    $0xc,%esp
  802e7c:	50                   	push   %eax
  802e7d:	e8 20 eb ff ff       	call   8019a2 <sbrk>
  802e82:	83 c4 10             	add    $0x10,%esp
  802e85:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (oldBreak == (void*)-1) {
  802e88:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802e8c:	75 0a                	jne    802e98 <alloc_block_FF+0x328>
		return NULL;
  802e8e:	b8 00 00 00 00       	mov    $0x0,%eax
  802e93:	e9 0d 01 00 00       	jmp    802fa5 <alloc_block_FF+0x435>
	}
	//uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);

	uint32* endBlk = (uint32 *)((char *)oldBreak - 4);
  802e98:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802e9b:	83 e8 04             	sub    $0x4,%eax
  802e9e:	89 45 cc             	mov    %eax,-0x34(%ebp)
	//endBlk = endBlk+(char *) ROUNDUP(totalSize, PAGE_SIZE);

	endBlk = endBlk + (ROUNDUP(totalSize, PAGE_SIZE) / sizeof(uint32));
  802ea1:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  802ea8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802eab:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802eae:	01 d0                	add    %edx,%eax
  802eb0:	48                   	dec    %eax
  802eb1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  802eb4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802eb7:	ba 00 00 00 00       	mov    $0x0,%edx
  802ebc:	f7 75 c8             	divl   -0x38(%ebp)
  802ebf:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802ec2:	29 d0                	sub    %edx,%eax
  802ec4:	c1 e8 02             	shr    $0x2,%eax
  802ec7:	c1 e0 02             	shl    $0x2,%eax
  802eca:	01 45 cc             	add    %eax,-0x34(%ebp)
	*endBlk = 0 | 1;
  802ecd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ed0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	uint32 *footerLast = ((uint32*)oldBreak - 2);
  802ed6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802ed9:	83 e8 08             	sub    $0x8,%eax
  802edc:	89 45 c0             	mov    %eax,-0x40(%ebp)
	uint32 lastSize = (*footerLast) & ~(0x1);
  802edf:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802ee2:	8b 00                	mov    (%eax),%eax
  802ee4:	83 e0 fe             	and    $0xfffffffe,%eax
  802ee7:	89 45 bc             	mov    %eax,-0x44(%ebp)
	// the last block for the block that we want to free it
	struct BlockElement *laskBlk = (struct BlockElement *)((char*)oldBreak - lastSize);
  802eea:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802eed:	f7 d8                	neg    %eax
  802eef:	89 c2                	mov    %eax,%edx
  802ef1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802ef4:	01 d0                	add    %edx,%eax
  802ef6:	89 45 b8             	mov    %eax,-0x48(%ebp)
	uint32 isLastFree = is_free_block(laskBlk);
  802ef9:	83 ec 0c             	sub    $0xc,%esp
  802efc:	ff 75 b8             	pushl  -0x48(%ebp)
  802eff:	e8 1f f8 ff ff       	call   802723 <is_free_block>
  802f04:	83 c4 10             	add    $0x10,%esp
  802f07:	0f be c0             	movsbl %al,%eax
  802f0a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(isLastFree)
  802f0d:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  802f11:	74 42                	je     802f55 <alloc_block_FF+0x3e5>
	{
		// merge the block will be free with its prev block
		uint32 newBlkSize = lastSize + ROUNDUP(totalSize, PAGE_SIZE); // size of main block and its prev block
  802f13:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802f1a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f1d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802f20:	01 d0                	add    %edx,%eax
  802f22:	48                   	dec    %eax
  802f23:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802f26:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802f29:	ba 00 00 00 00       	mov    $0x0,%edx
  802f2e:	f7 75 b0             	divl   -0x50(%ebp)
  802f31:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802f34:	29 d0                	sub    %edx,%eax
  802f36:	89 c2                	mov    %eax,%edx
  802f38:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802f3b:	01 d0                	add    %edx,%eax
  802f3d:	89 45 a8             	mov    %eax,-0x58(%ebp)
		// extends last block size to contain its size and the size of new space
		set_block_data(laskBlk,newBlkSize,0);
  802f40:	83 ec 04             	sub    $0x4,%esp
  802f43:	6a 00                	push   $0x0
  802f45:	ff 75 a8             	pushl  -0x58(%ebp)
  802f48:	ff 75 b8             	pushl  -0x48(%ebp)
  802f4b:	e8 36 fa ff ff       	call   802986 <set_block_data>
  802f50:	83 c4 10             	add    $0x10,%esp
  802f53:	eb 42                	jmp    802f97 <alloc_block_FF+0x427>
	}
	else
	{
		set_block_data(oldBreak,ROUNDUP(totalSize, PAGE_SIZE),0);
  802f55:	c7 45 a4 00 10 00 00 	movl   $0x1000,-0x5c(%ebp)
  802f5c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f5f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802f62:	01 d0                	add    %edx,%eax
  802f64:	48                   	dec    %eax
  802f65:	89 45 a0             	mov    %eax,-0x60(%ebp)
  802f68:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802f6b:	ba 00 00 00 00       	mov    $0x0,%edx
  802f70:	f7 75 a4             	divl   -0x5c(%ebp)
  802f73:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802f76:	29 d0                	sub    %edx,%eax
  802f78:	83 ec 04             	sub    $0x4,%esp
  802f7b:	6a 00                	push   $0x0
  802f7d:	50                   	push   %eax
  802f7e:	ff 75 d0             	pushl  -0x30(%ebp)
  802f81:	e8 00 fa ff ff       	call   802986 <set_block_data>
  802f86:	83 c4 10             	add    $0x10,%esp
		insert_sorted_in_freeList((struct BlockElement *)oldBreak);
  802f89:	83 ec 0c             	sub    $0xc,%esp
  802f8c:	ff 75 d0             	pushl  -0x30(%ebp)
  802f8f:	e8 49 fa ff ff       	call   8029dd <insert_sorted_in_freeList>
  802f94:	83 c4 10             	add    $0x10,%esp
//		LIST_INSERT_TAIL(&freeBlocksList,newBreak);
	}
//	set_block_data((struct BlockElement *)newBreak, totalSize, 1);
	return alloc_block_FF(size);
  802f97:	83 ec 0c             	sub    $0xc,%esp
  802f9a:	ff 75 08             	pushl  0x8(%ebp)
  802f9d:	e8 ce fb ff ff       	call   802b70 <alloc_block_FF>
  802fa2:	83 c4 10             	add    $0x10,%esp
}
  802fa5:	c9                   	leave  
  802fa6:	c3                   	ret    

00802fa7 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802fa7:	55                   	push   %ebp
  802fa8:	89 e5                	mov    %esp,%ebp
  802faa:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS1 - BONUS] [3] DYNAMIC ALLOCATOR - alloc_block_BF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_BF is not implemented yet");
	//Your Code is Here...
	if(size == 0)
  802fad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fb1:	75 0a                	jne    802fbd <alloc_block_BF+0x16>
	{
		return NULL;
  802fb3:	b8 00 00 00 00       	mov    $0x0,%eax
  802fb8:	e9 7a 02 00 00       	jmp    803237 <alloc_block_BF+0x290>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  802fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc0:	83 c0 08             	add    $0x8,%eax
  802fc3:	89 45 e8             	mov    %eax,-0x18(%ebp)

	struct BlockElement *minBlk= NULL;
  802fc6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 minSize = 0xfffffff; // a large number
  802fcd:	c7 45 f0 ff ff ff 0f 	movl   $0xfffffff,-0x10(%ebp)
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802fd4:	a1 48 50 98 00       	mov    0x985048,%eax
  802fd9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802fdc:	eb 32                	jmp    803010 <alloc_block_BF+0x69>
	{
		uint32 blockSize = get_block_size(block);
  802fde:	ff 75 ec             	pushl  -0x14(%ebp)
  802fe1:	e8 24 f7 ff ff       	call   80270a <get_block_size>
  802fe6:	83 c4 04             	add    $0x4,%esp
  802fe9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		// if this block can take the new block and its size < min size of all blocks
		if(blockSize >= totalSize && blockSize < minSize)
  802fec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fef:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802ff2:	72 14                	jb     803008 <alloc_block_BF+0x61>
  802ff4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ff7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802ffa:	73 0c                	jae    803008 <alloc_block_BF+0x61>
		{
			minBlk = block;
  802ffc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fff:	89 45 f4             	mov    %eax,-0xc(%ebp)
			minSize = blockSize;
  803002:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803005:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *minBlk= NULL;
	uint32 minSize = 0xfffffff; // a large number
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  803008:	a1 50 50 98 00       	mov    0x985050,%eax
  80300d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803010:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803014:	74 07                	je     80301d <alloc_block_BF+0x76>
  803016:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803019:	8b 00                	mov    (%eax),%eax
  80301b:	eb 05                	jmp    803022 <alloc_block_BF+0x7b>
  80301d:	b8 00 00 00 00       	mov    $0x0,%eax
  803022:	a3 50 50 98 00       	mov    %eax,0x985050
  803027:	a1 50 50 98 00       	mov    0x985050,%eax
  80302c:	85 c0                	test   %eax,%eax
  80302e:	75 ae                	jne    802fde <alloc_block_BF+0x37>
  803030:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803034:	75 a8                	jne    802fde <alloc_block_BF+0x37>
			minSize = blockSize;
		}
	}

	// if we don't find any enough space to allocate the block
	if(minBlk == NULL)
  803036:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80303a:	75 22                	jne    80305e <alloc_block_BF+0xb7>
	{
		void *newBlock = sbrk(totalSize);
  80303c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80303f:	83 ec 0c             	sub    $0xc,%esp
  803042:	50                   	push   %eax
  803043:	e8 5a e9 ff ff       	call   8019a2 <sbrk>
  803048:	83 c4 10             	add    $0x10,%esp
  80304b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (newBlock == (void*)-1) {
  80304e:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  803052:	75 0a                	jne    80305e <alloc_block_BF+0xb7>
			return NULL;
  803054:	b8 00 00 00 00       	mov    $0x0,%eax
  803059:	e9 d9 01 00 00       	jmp    803237 <alloc_block_BF+0x290>
		}
	}

	//if we can put another block with min size 16
	if(minSize >= totalSize + 4*sizeof(uint32))
  80305e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803061:	83 c0 10             	add    $0x10,%eax
  803064:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803067:	0f 87 32 01 00 00    	ja     80319f <alloc_block_BF+0x1f8>
	{
		// the size that will remain from the block that we will allocate a new block in it
		uint32 remainingSize= minSize - totalSize;
  80306d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803070:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803073:	89 45 dc             	mov    %eax,-0x24(%ebp)

		// the remaining free space from the block that we use to allocate in it
		struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)minBlk + totalSize);
  803076:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803079:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80307c:	01 d0                	add    %edx,%eax
  80307e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		set_block_data(remainingFreeBlock, remainingSize, 0);
  803081:	83 ec 04             	sub    $0x4,%esp
  803084:	6a 00                	push   $0x0
  803086:	ff 75 dc             	pushl  -0x24(%ebp)
  803089:	ff 75 d8             	pushl  -0x28(%ebp)
  80308c:	e8 f5 f8 ff ff       	call   802986 <set_block_data>
  803091:	83 c4 10             	add    $0x10,%esp
		// add it after the block we allocated to be sorted by addresses
		LIST_INSERT_AFTER(&freeBlocksList, minBlk,remainingFreeBlock);
  803094:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803098:	74 06                	je     8030a0 <alloc_block_BF+0xf9>
  80309a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80309e:	75 17                	jne    8030b7 <alloc_block_BF+0x110>
  8030a0:	83 ec 04             	sub    $0x4,%esp
  8030a3:	68 40 45 80 00       	push   $0x804540
  8030a8:	68 49 01 00 00       	push   $0x149
  8030ad:	68 cb 44 80 00       	push   $0x8044cb
  8030b2:	e8 8c d6 ff ff       	call   800743 <_panic>
  8030b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ba:	8b 10                	mov    (%eax),%edx
  8030bc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8030bf:	89 10                	mov    %edx,(%eax)
  8030c1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8030c4:	8b 00                	mov    (%eax),%eax
  8030c6:	85 c0                	test   %eax,%eax
  8030c8:	74 0b                	je     8030d5 <alloc_block_BF+0x12e>
  8030ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030cd:	8b 00                	mov    (%eax),%eax
  8030cf:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8030d2:	89 50 04             	mov    %edx,0x4(%eax)
  8030d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8030db:	89 10                	mov    %edx,(%eax)
  8030dd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8030e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030e3:	89 50 04             	mov    %edx,0x4(%eax)
  8030e6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8030e9:	8b 00                	mov    (%eax),%eax
  8030eb:	85 c0                	test   %eax,%eax
  8030ed:	75 08                	jne    8030f7 <alloc_block_BF+0x150>
  8030ef:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8030f2:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8030f7:	a1 54 50 98 00       	mov    0x985054,%eax
  8030fc:	40                   	inc    %eax
  8030fd:	a3 54 50 98 00       	mov    %eax,0x985054

		// update the allocated block and remove it from freeBlocksList
		set_block_data(minBlk,totalSize,1);
  803102:	83 ec 04             	sub    $0x4,%esp
  803105:	6a 01                	push   $0x1
  803107:	ff 75 e8             	pushl  -0x18(%ebp)
  80310a:	ff 75 f4             	pushl  -0xc(%ebp)
  80310d:	e8 74 f8 ff ff       	call   802986 <set_block_data>
  803112:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  803115:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803119:	75 17                	jne    803132 <alloc_block_BF+0x18b>
  80311b:	83 ec 04             	sub    $0x4,%esp
  80311e:	68 74 45 80 00       	push   $0x804574
  803123:	68 4e 01 00 00       	push   $0x14e
  803128:	68 cb 44 80 00       	push   $0x8044cb
  80312d:	e8 11 d6 ff ff       	call   800743 <_panic>
  803132:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803135:	8b 00                	mov    (%eax),%eax
  803137:	85 c0                	test   %eax,%eax
  803139:	74 10                	je     80314b <alloc_block_BF+0x1a4>
  80313b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313e:	8b 00                	mov    (%eax),%eax
  803140:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803143:	8b 52 04             	mov    0x4(%edx),%edx
  803146:	89 50 04             	mov    %edx,0x4(%eax)
  803149:	eb 0b                	jmp    803156 <alloc_block_BF+0x1af>
  80314b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314e:	8b 40 04             	mov    0x4(%eax),%eax
  803151:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803156:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803159:	8b 40 04             	mov    0x4(%eax),%eax
  80315c:	85 c0                	test   %eax,%eax
  80315e:	74 0f                	je     80316f <alloc_block_BF+0x1c8>
  803160:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803163:	8b 40 04             	mov    0x4(%eax),%eax
  803166:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803169:	8b 12                	mov    (%edx),%edx
  80316b:	89 10                	mov    %edx,(%eax)
  80316d:	eb 0a                	jmp    803179 <alloc_block_BF+0x1d2>
  80316f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803172:	8b 00                	mov    (%eax),%eax
  803174:	a3 48 50 98 00       	mov    %eax,0x985048
  803179:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803182:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803185:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80318c:	a1 54 50 98 00       	mov    0x985054,%eax
  803191:	48                   	dec    %eax
  803192:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  803197:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319a:	e9 98 00 00 00       	jmp    803237 <alloc_block_BF+0x290>
	}
	else // if set internal fragmentation
	{
		// add the remaining size to the block we allocate so it will be the same main block size
		set_block_data(minBlk,minSize,1);
  80319f:	83 ec 04             	sub    $0x4,%esp
  8031a2:	6a 01                	push   $0x1
  8031a4:	ff 75 f0             	pushl  -0x10(%ebp)
  8031a7:	ff 75 f4             	pushl  -0xc(%ebp)
  8031aa:	e8 d7 f7 ff ff       	call   802986 <set_block_data>
  8031af:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  8031b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031b6:	75 17                	jne    8031cf <alloc_block_BF+0x228>
  8031b8:	83 ec 04             	sub    $0x4,%esp
  8031bb:	68 74 45 80 00       	push   $0x804574
  8031c0:	68 56 01 00 00       	push   $0x156
  8031c5:	68 cb 44 80 00       	push   $0x8044cb
  8031ca:	e8 74 d5 ff ff       	call   800743 <_panic>
  8031cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d2:	8b 00                	mov    (%eax),%eax
  8031d4:	85 c0                	test   %eax,%eax
  8031d6:	74 10                	je     8031e8 <alloc_block_BF+0x241>
  8031d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031db:	8b 00                	mov    (%eax),%eax
  8031dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031e0:	8b 52 04             	mov    0x4(%edx),%edx
  8031e3:	89 50 04             	mov    %edx,0x4(%eax)
  8031e6:	eb 0b                	jmp    8031f3 <alloc_block_BF+0x24c>
  8031e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031eb:	8b 40 04             	mov    0x4(%eax),%eax
  8031ee:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8031f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f6:	8b 40 04             	mov    0x4(%eax),%eax
  8031f9:	85 c0                	test   %eax,%eax
  8031fb:	74 0f                	je     80320c <alloc_block_BF+0x265>
  8031fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803200:	8b 40 04             	mov    0x4(%eax),%eax
  803203:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803206:	8b 12                	mov    (%edx),%edx
  803208:	89 10                	mov    %edx,(%eax)
  80320a:	eb 0a                	jmp    803216 <alloc_block_BF+0x26f>
  80320c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320f:	8b 00                	mov    (%eax),%eax
  803211:	a3 48 50 98 00       	mov    %eax,0x985048
  803216:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803219:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80321f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803222:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803229:	a1 54 50 98 00       	mov    0x985054,%eax
  80322e:	48                   	dec    %eax
  80322f:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  803234:	8b 45 f4             	mov    -0xc(%ebp),%eax
	}
	return NULL;
}
  803237:	c9                   	leave  
  803238:	c3                   	ret    

00803239 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803239:	55                   	push   %ebp
  80323a:	89 e5                	mov    %esp,%ebp
  80323c:	83 ec 48             	sub    $0x48,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
  80323f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803243:	0f 84 6a 02 00 00    	je     8034b3 <free_block+0x27a>
	{
		return;
	}

	uint32 freeSize = get_block_size(va);
  803249:	ff 75 08             	pushl  0x8(%ebp)
  80324c:	e8 b9 f4 ff ff       	call   80270a <get_block_size>
  803251:	83 c4 04             	add    $0x4,%esp
  803254:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// footer for the prev block for the block that we want to free it
	uint32 *footerPrev = ((uint32*)va - 2 );
  803257:	8b 45 08             	mov    0x8(%ebp),%eax
  80325a:	83 e8 08             	sub    $0x8,%eax
  80325d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 pSize = (*footerPrev) & ~(0x1);
  803260:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803263:	8b 00                	mov    (%eax),%eax
  803265:	83 e0 fe             	and    $0xfffffffe,%eax
  803268:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// the prev block for the block that we want to free it
	struct BlockElement * prevBlk = (struct BlockElement *)((char*)va - pSize);
  80326b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80326e:	f7 d8                	neg    %eax
  803270:	89 c2                	mov    %eax,%edx
  803272:	8b 45 08             	mov    0x8(%ebp),%eax
  803275:	01 d0                	add    %edx,%eax
  803277:	89 45 e8             	mov    %eax,-0x18(%ebp)
	uint32 isPrevFree = is_free_block(prevBlk);
  80327a:	ff 75 e8             	pushl  -0x18(%ebp)
  80327d:	e8 a1 f4 ff ff       	call   802723 <is_free_block>
  803282:	83 c4 04             	add    $0x4,%esp
  803285:	0f be c0             	movsbl %al,%eax
  803288:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
  80328b:	8b 55 08             	mov    0x8(%ebp),%edx
  80328e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803291:	01 d0                	add    %edx,%eax
  803293:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  803296:	ff 75 e0             	pushl  -0x20(%ebp)
  803299:	e8 85 f4 ff ff       	call   802723 <is_free_block>
  80329e:	83 c4 04             	add    $0x4,%esp
  8032a1:	0f be c0             	movsbl %al,%eax
  8032a4:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if(isPrevFree == 1 && isNextFree == 0)
  8032a7:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  8032ab:	75 34                	jne    8032e1 <free_block+0xa8>
  8032ad:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8032b1:	75 2e                	jne    8032e1 <free_block+0xa8>
	{
		// merge the block will be free with its prev block
		uint32 prevSize = get_block_size(prevBlk);
  8032b3:	ff 75 e8             	pushl  -0x18(%ebp)
  8032b6:	e8 4f f4 ff ff       	call   80270a <get_block_size>
  8032bb:	83 c4 04             	add    $0x4,%esp
  8032be:	89 45 d8             	mov    %eax,-0x28(%ebp)
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
  8032c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032c4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8032c7:	01 d0                	add    %edx,%eax
  8032c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
  8032cc:	6a 00                	push   $0x0
  8032ce:	ff 75 d4             	pushl  -0x2c(%ebp)
  8032d1:	ff 75 e8             	pushl  -0x18(%ebp)
  8032d4:	e8 ad f6 ff ff       	call   802986 <set_block_data>
  8032d9:	83 c4 0c             	add    $0xc,%esp
	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
	uint32 isNextFree = is_free_block(nextBlk);

	if(isPrevFree == 1 && isNextFree == 0)
	{
  8032dc:	e9 d3 01 00 00       	jmp    8034b4 <free_block+0x27b>
		uint32 prevSize = get_block_size(prevBlk);
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
  8032e1:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  8032e5:	0f 85 c8 00 00 00    	jne    8033b3 <free_block+0x17a>
  8032eb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8032ef:	0f 85 be 00 00 00    	jne    8033b3 <free_block+0x17a>
	{
		// merge the block will be free with its next block
		uint32 nextSize = get_block_size(nextBlk);
  8032f5:	ff 75 e0             	pushl  -0x20(%ebp)
  8032f8:	e8 0d f4 ff ff       	call   80270a <get_block_size>
  8032fd:	83 c4 04             	add    $0x4,%esp
  803300:	89 45 d0             	mov    %eax,-0x30(%ebp)
		uint32 totalSize = freeSize + nextSize; // size of main block and its next block
  803303:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803306:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803309:	01 d0                	add    %edx,%eax
  80330b:	89 45 cc             	mov    %eax,-0x34(%ebp)
		// update the size of block to contain its size and the size of next block
		set_block_data(va,totalSize,0);
  80330e:	6a 00                	push   $0x0
  803310:	ff 75 cc             	pushl  -0x34(%ebp)
  803313:	ff 75 08             	pushl  0x8(%ebp)
  803316:	e8 6b f6 ff ff       	call   802986 <set_block_data>
  80331b:	83 c4 0c             	add    $0xc,%esp
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
  80331e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803322:	75 17                	jne    80333b <free_block+0x102>
  803324:	83 ec 04             	sub    $0x4,%esp
  803327:	68 74 45 80 00       	push   $0x804574
  80332c:	68 87 01 00 00       	push   $0x187
  803331:	68 cb 44 80 00       	push   $0x8044cb
  803336:	e8 08 d4 ff ff       	call   800743 <_panic>
  80333b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80333e:	8b 00                	mov    (%eax),%eax
  803340:	85 c0                	test   %eax,%eax
  803342:	74 10                	je     803354 <free_block+0x11b>
  803344:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803347:	8b 00                	mov    (%eax),%eax
  803349:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80334c:	8b 52 04             	mov    0x4(%edx),%edx
  80334f:	89 50 04             	mov    %edx,0x4(%eax)
  803352:	eb 0b                	jmp    80335f <free_block+0x126>
  803354:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803357:	8b 40 04             	mov    0x4(%eax),%eax
  80335a:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80335f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803362:	8b 40 04             	mov    0x4(%eax),%eax
  803365:	85 c0                	test   %eax,%eax
  803367:	74 0f                	je     803378 <free_block+0x13f>
  803369:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80336c:	8b 40 04             	mov    0x4(%eax),%eax
  80336f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803372:	8b 12                	mov    (%edx),%edx
  803374:	89 10                	mov    %edx,(%eax)
  803376:	eb 0a                	jmp    803382 <free_block+0x149>
  803378:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80337b:	8b 00                	mov    (%eax),%eax
  80337d:	a3 48 50 98 00       	mov    %eax,0x985048
  803382:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803385:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80338b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80338e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803395:	a1 54 50 98 00       	mov    0x985054,%eax
  80339a:	48                   	dec    %eax
  80339b:	a3 54 50 98 00       	mov    %eax,0x985054
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  8033a0:	83 ec 0c             	sub    $0xc,%esp
  8033a3:	ff 75 08             	pushl  0x8(%ebp)
  8033a6:	e8 32 f6 ff ff       	call   8029dd <insert_sorted_in_freeList>
  8033ab:	83 c4 10             	add    $0x10,%esp
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
	{
  8033ae:	e9 01 01 00 00       	jmp    8034b4 <free_block+0x27b>
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
  8033b3:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  8033b7:	0f 85 d3 00 00 00    	jne    803490 <free_block+0x257>
  8033bd:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  8033c1:	0f 85 c9 00 00 00    	jne    803490 <free_block+0x257>
	{
		// merge the block will be free with its prev and next blocks
		uint32 prevSize = get_block_size(prevBlk);
  8033c7:	83 ec 0c             	sub    $0xc,%esp
  8033ca:	ff 75 e8             	pushl  -0x18(%ebp)
  8033cd:	e8 38 f3 ff ff       	call   80270a <get_block_size>
  8033d2:	83 c4 10             	add    $0x10,%esp
  8033d5:	89 45 c8             	mov    %eax,-0x38(%ebp)
		uint32 nextSize = get_block_size(nextBlk);
  8033d8:	83 ec 0c             	sub    $0xc,%esp
  8033db:	ff 75 e0             	pushl  -0x20(%ebp)
  8033de:	e8 27 f3 ff ff       	call   80270a <get_block_size>
  8033e3:	83 c4 10             	add    $0x10,%esp
  8033e6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 totalSize = freeSize + prevSize + nextSize; // size of main block and its prev and next blocks
  8033e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033ec:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033ef:	01 c2                	add    %eax,%edx
  8033f1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8033f4:	01 d0                	add    %edx,%eax
  8033f6:	89 45 c0             	mov    %eax,-0x40(%ebp)
		// extends prev block size to contain its size and the size of main and next blocks
		set_block_data(prevBlk,totalSize,0);
  8033f9:	83 ec 04             	sub    $0x4,%esp
  8033fc:	6a 00                	push   $0x0
  8033fe:	ff 75 c0             	pushl  -0x40(%ebp)
  803401:	ff 75 e8             	pushl  -0x18(%ebp)
  803404:	e8 7d f5 ff ff       	call   802986 <set_block_data>
  803409:	83 c4 10             	add    $0x10,%esp
		// remove next block because we merge it with its prev blocks
		LIST_REMOVE(&freeBlocksList, nextBlk);
  80340c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803410:	75 17                	jne    803429 <free_block+0x1f0>
  803412:	83 ec 04             	sub    $0x4,%esp
  803415:	68 74 45 80 00       	push   $0x804574
  80341a:	68 94 01 00 00       	push   $0x194
  80341f:	68 cb 44 80 00       	push   $0x8044cb
  803424:	e8 1a d3 ff ff       	call   800743 <_panic>
  803429:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80342c:	8b 00                	mov    (%eax),%eax
  80342e:	85 c0                	test   %eax,%eax
  803430:	74 10                	je     803442 <free_block+0x209>
  803432:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803435:	8b 00                	mov    (%eax),%eax
  803437:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80343a:	8b 52 04             	mov    0x4(%edx),%edx
  80343d:	89 50 04             	mov    %edx,0x4(%eax)
  803440:	eb 0b                	jmp    80344d <free_block+0x214>
  803442:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803445:	8b 40 04             	mov    0x4(%eax),%eax
  803448:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80344d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803450:	8b 40 04             	mov    0x4(%eax),%eax
  803453:	85 c0                	test   %eax,%eax
  803455:	74 0f                	je     803466 <free_block+0x22d>
  803457:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80345a:	8b 40 04             	mov    0x4(%eax),%eax
  80345d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803460:	8b 12                	mov    (%edx),%edx
  803462:	89 10                	mov    %edx,(%eax)
  803464:	eb 0a                	jmp    803470 <free_block+0x237>
  803466:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803469:	8b 00                	mov    (%eax),%eax
  80346b:	a3 48 50 98 00       	mov    %eax,0x985048
  803470:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803473:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803479:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80347c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803483:	a1 54 50 98 00       	mov    0x985054,%eax
  803488:	48                   	dec    %eax
  803489:	a3 54 50 98 00       	mov    %eax,0x985054
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
	{
  80348e:	eb 24                	jmp    8034b4 <free_block+0x27b>
	}
	else
	{
		// free it without any merge
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
  803490:	83 ec 04             	sub    $0x4,%esp
  803493:	6a 00                	push   $0x0
  803495:	ff 75 f4             	pushl  -0xc(%ebp)
  803498:	ff 75 08             	pushl  0x8(%ebp)
  80349b:	e8 e6 f4 ff ff       	call   802986 <set_block_data>
  8034a0:	83 c4 10             	add    $0x10,%esp
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  8034a3:	83 ec 0c             	sub    $0xc,%esp
  8034a6:	ff 75 08             	pushl  0x8(%ebp)
  8034a9:	e8 2f f5 ff ff       	call   8029dd <insert_sorted_in_freeList>
  8034ae:	83 c4 10             	add    $0x10,%esp
  8034b1:	eb 01                	jmp    8034b4 <free_block+0x27b>
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
	{
		return;
  8034b3:	90                   	nop
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
}
  8034b4:	c9                   	leave  
  8034b5:	c3                   	ret    

008034b6 <realloc_block_FF>:
//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
  8034b6:	55                   	push   %ebp
  8034b7:	89 e5                	mov    %esp,%ebp
  8034b9:	83 ec 38             	sub    $0x38,%esp
	//TODO: [PROJECT'24.MS1 - #08] [3] DYNAMIC ALLOCATOR - realloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(va == NULL && new_size == 0)
  8034bc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034c0:	75 10                	jne    8034d2 <realloc_block_FF+0x1c>
  8034c2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8034c6:	75 0a                	jne    8034d2 <realloc_block_FF+0x1c>
	{
		return NULL;
  8034c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8034cd:	e9 8b 04 00 00       	jmp    80395d <realloc_block_FF+0x4a7>
	}

	if(new_size == 0)
  8034d2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8034d6:	75 18                	jne    8034f0 <realloc_block_FF+0x3a>
	{
		free_block(va);
  8034d8:	83 ec 0c             	sub    $0xc,%esp
  8034db:	ff 75 08             	pushl  0x8(%ebp)
  8034de:	e8 56 fd ff ff       	call   803239 <free_block>
  8034e3:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8034e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8034eb:	e9 6d 04 00 00       	jmp    80395d <realloc_block_FF+0x4a7>
	}

	if(va == NULL)
  8034f0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034f4:	75 13                	jne    803509 <realloc_block_FF+0x53>
	{
		return alloc_block_FF(new_size);
  8034f6:	83 ec 0c             	sub    $0xc,%esp
  8034f9:	ff 75 0c             	pushl  0xc(%ebp)
  8034fc:	e8 6f f6 ff ff       	call   802b70 <alloc_block_FF>
  803501:	83 c4 10             	add    $0x10,%esp
  803504:	e9 54 04 00 00       	jmp    80395d <realloc_block_FF+0x4a7>
	}

	// if size is odd must be increment it by one
	if (new_size % 2 != 0)
  803509:	8b 45 0c             	mov    0xc(%ebp),%eax
  80350c:	83 e0 01             	and    $0x1,%eax
  80350f:	85 c0                	test   %eax,%eax
  803511:	74 03                	je     803516 <realloc_block_FF+0x60>
	{
		new_size++;
  803513:	ff 45 0c             	incl   0xc(%ebp)
	}

	// if size < 8 must be equal it to 8 because min size 8 excluding metadata
	if(new_size < 8)
  803516:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80351a:	77 07                	ja     803523 <realloc_block_FF+0x6d>
	{
		new_size = 8;
  80351c:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	}

	new_size += 8; // adds its footer and header size
  803523:	83 45 0c 08          	addl   $0x8,0xc(%ebp)

	uint32 actualSize = get_block_size(va);
  803527:	83 ec 0c             	sub    $0xc,%esp
  80352a:	ff 75 08             	pushl  0x8(%ebp)
  80352d:	e8 d8 f1 ff ff       	call   80270a <get_block_size>
  803532:	83 c4 10             	add    $0x10,%esp
  803535:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(actualSize == new_size)
  803538:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80353b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80353e:	75 08                	jne    803548 <realloc_block_FF+0x92>
	{
		// don't change any thing
		return va;
  803540:	8b 45 08             	mov    0x8(%ebp),%eax
  803543:	e9 15 04 00 00       	jmp    80395d <realloc_block_FF+0x4a7>
	}

	// next block for the block we want to change its size
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + actualSize);
  803548:	8b 55 08             	mov    0x8(%ebp),%edx
  80354b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80354e:	01 d0                	add    %edx,%eax
  803550:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  803553:	83 ec 0c             	sub    $0xc,%esp
  803556:	ff 75 f0             	pushl  -0x10(%ebp)
  803559:	e8 c5 f1 ff ff       	call   802723 <is_free_block>
  80355e:	83 c4 10             	add    $0x10,%esp
  803561:	0f be c0             	movsbl %al,%eax
  803564:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 nextSize = get_block_size(nextBlk);
  803567:	83 ec 0c             	sub    $0xc,%esp
  80356a:	ff 75 f0             	pushl  -0x10(%ebp)
  80356d:	e8 98 f1 ff ff       	call   80270a <get_block_size>
  803572:	83 c4 10             	add    $0x10,%esp
  803575:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// increase the size of block
	if(new_size > actualSize)
  803578:	8b 45 0c             	mov    0xc(%ebp),%eax
  80357b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80357e:	0f 86 a7 02 00 00    	jbe    80382b <realloc_block_FF+0x375>
	{
		if(isNextFree)
  803584:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803588:	0f 84 86 02 00 00    	je     803814 <realloc_block_FF+0x35e>
		{
			if(nextSize + actualSize == new_size) // block and nextblock = newSizeBlock
  80358e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803591:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803594:	01 d0                	add    %edx,%eax
  803596:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803599:	0f 85 b2 00 00 00    	jne    803651 <realloc_block_FF+0x19b>
			{
				set_block_data(va,new_size,!(is_free_block(va)));// update size in block
  80359f:	83 ec 0c             	sub    $0xc,%esp
  8035a2:	ff 75 08             	pushl  0x8(%ebp)
  8035a5:	e8 79 f1 ff ff       	call   802723 <is_free_block>
  8035aa:	83 c4 10             	add    $0x10,%esp
  8035ad:	84 c0                	test   %al,%al
  8035af:	0f 94 c0             	sete   %al
  8035b2:	0f b6 c0             	movzbl %al,%eax
  8035b5:	83 ec 04             	sub    $0x4,%esp
  8035b8:	50                   	push   %eax
  8035b9:	ff 75 0c             	pushl  0xc(%ebp)
  8035bc:	ff 75 08             	pushl  0x8(%ebp)
  8035bf:	e8 c2 f3 ff ff       	call   802986 <set_block_data>
  8035c4:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);// remove next because it is = zero
  8035c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8035cb:	75 17                	jne    8035e4 <realloc_block_FF+0x12e>
  8035cd:	83 ec 04             	sub    $0x4,%esp
  8035d0:	68 74 45 80 00       	push   $0x804574
  8035d5:	68 db 01 00 00       	push   $0x1db
  8035da:	68 cb 44 80 00       	push   $0x8044cb
  8035df:	e8 5f d1 ff ff       	call   800743 <_panic>
  8035e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035e7:	8b 00                	mov    (%eax),%eax
  8035e9:	85 c0                	test   %eax,%eax
  8035eb:	74 10                	je     8035fd <realloc_block_FF+0x147>
  8035ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035f0:	8b 00                	mov    (%eax),%eax
  8035f2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035f5:	8b 52 04             	mov    0x4(%edx),%edx
  8035f8:	89 50 04             	mov    %edx,0x4(%eax)
  8035fb:	eb 0b                	jmp    803608 <realloc_block_FF+0x152>
  8035fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803600:	8b 40 04             	mov    0x4(%eax),%eax
  803603:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803608:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80360b:	8b 40 04             	mov    0x4(%eax),%eax
  80360e:	85 c0                	test   %eax,%eax
  803610:	74 0f                	je     803621 <realloc_block_FF+0x16b>
  803612:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803615:	8b 40 04             	mov    0x4(%eax),%eax
  803618:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80361b:	8b 12                	mov    (%edx),%edx
  80361d:	89 10                	mov    %edx,(%eax)
  80361f:	eb 0a                	jmp    80362b <realloc_block_FF+0x175>
  803621:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803624:	8b 00                	mov    (%eax),%eax
  803626:	a3 48 50 98 00       	mov    %eax,0x985048
  80362b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80362e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803634:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803637:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80363e:	a1 54 50 98 00       	mov    0x985054,%eax
  803643:	48                   	dec    %eax
  803644:	a3 54 50 98 00       	mov    %eax,0x985054
				return va;
  803649:	8b 45 08             	mov    0x8(%ebp),%eax
  80364c:	e9 0c 03 00 00       	jmp    80395d <realloc_block_FF+0x4a7>
			}
			else if(nextSize + actualSize > new_size) // new size is less than next and main blocks
  803651:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803654:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803657:	01 d0                	add    %edx,%eax
  803659:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80365c:	0f 86 b2 01 00 00    	jbe    803814 <realloc_block_FF+0x35e>
			{
				uint32 requiredSize = new_size - actualSize; // size that we need from the next block
  803662:	8b 45 0c             	mov    0xc(%ebp),%eax
  803665:	2b 45 f4             	sub    -0xc(%ebp),%eax
  803668:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				uint32 remainingNext = nextSize - requiredSize; // size that will remain from the next block after we split it
  80366b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80366e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  803671:	89 45 e0             	mov    %eax,-0x20(%ebp)

				// if next size will not fit another block (internal fragmentation)
				if(remainingNext < 16)
  803674:	83 7d e0 0f          	cmpl   $0xf,-0x20(%ebp)
  803678:	0f 87 b8 00 00 00    	ja     803736 <realloc_block_FF+0x280>
				{
					// we will take the main size of the block and its next size also
					set_block_data(va,actualSize + nextSize,!(is_free_block(va)));
  80367e:	83 ec 0c             	sub    $0xc,%esp
  803681:	ff 75 08             	pushl  0x8(%ebp)
  803684:	e8 9a f0 ff ff       	call   802723 <is_free_block>
  803689:	83 c4 10             	add    $0x10,%esp
  80368c:	84 c0                	test   %al,%al
  80368e:	0f 94 c0             	sete   %al
  803691:	0f b6 c0             	movzbl %al,%eax
  803694:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803697:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80369a:	01 ca                	add    %ecx,%edx
  80369c:	83 ec 04             	sub    $0x4,%esp
  80369f:	50                   	push   %eax
  8036a0:	52                   	push   %edx
  8036a1:	ff 75 08             	pushl  0x8(%ebp)
  8036a4:	e8 dd f2 ff ff       	call   802986 <set_block_data>
  8036a9:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,nextBlk);
  8036ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8036b0:	75 17                	jne    8036c9 <realloc_block_FF+0x213>
  8036b2:	83 ec 04             	sub    $0x4,%esp
  8036b5:	68 74 45 80 00       	push   $0x804574
  8036ba:	68 e8 01 00 00       	push   $0x1e8
  8036bf:	68 cb 44 80 00       	push   $0x8044cb
  8036c4:	e8 7a d0 ff ff       	call   800743 <_panic>
  8036c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036cc:	8b 00                	mov    (%eax),%eax
  8036ce:	85 c0                	test   %eax,%eax
  8036d0:	74 10                	je     8036e2 <realloc_block_FF+0x22c>
  8036d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036d5:	8b 00                	mov    (%eax),%eax
  8036d7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036da:	8b 52 04             	mov    0x4(%edx),%edx
  8036dd:	89 50 04             	mov    %edx,0x4(%eax)
  8036e0:	eb 0b                	jmp    8036ed <realloc_block_FF+0x237>
  8036e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036e5:	8b 40 04             	mov    0x4(%eax),%eax
  8036e8:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8036ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036f0:	8b 40 04             	mov    0x4(%eax),%eax
  8036f3:	85 c0                	test   %eax,%eax
  8036f5:	74 0f                	je     803706 <realloc_block_FF+0x250>
  8036f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036fa:	8b 40 04             	mov    0x4(%eax),%eax
  8036fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803700:	8b 12                	mov    (%edx),%edx
  803702:	89 10                	mov    %edx,(%eax)
  803704:	eb 0a                	jmp    803710 <realloc_block_FF+0x25a>
  803706:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803709:	8b 00                	mov    (%eax),%eax
  80370b:	a3 48 50 98 00       	mov    %eax,0x985048
  803710:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803713:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803719:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80371c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803723:	a1 54 50 98 00       	mov    0x985054,%eax
  803728:	48                   	dec    %eax
  803729:	a3 54 50 98 00       	mov    %eax,0x985054
					return va;
  80372e:	8b 45 08             	mov    0x8(%ebp),%eax
  803731:	e9 27 02 00 00       	jmp    80395d <realloc_block_FF+0x4a7>
				}
				else // if next size can be fit another block (split)
				{
					LIST_REMOVE(&freeBlocksList,nextBlk);
  803736:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80373a:	75 17                	jne    803753 <realloc_block_FF+0x29d>
  80373c:	83 ec 04             	sub    $0x4,%esp
  80373f:	68 74 45 80 00       	push   $0x804574
  803744:	68 ed 01 00 00       	push   $0x1ed
  803749:	68 cb 44 80 00       	push   $0x8044cb
  80374e:	e8 f0 cf ff ff       	call   800743 <_panic>
  803753:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803756:	8b 00                	mov    (%eax),%eax
  803758:	85 c0                	test   %eax,%eax
  80375a:	74 10                	je     80376c <realloc_block_FF+0x2b6>
  80375c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80375f:	8b 00                	mov    (%eax),%eax
  803761:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803764:	8b 52 04             	mov    0x4(%edx),%edx
  803767:	89 50 04             	mov    %edx,0x4(%eax)
  80376a:	eb 0b                	jmp    803777 <realloc_block_FF+0x2c1>
  80376c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80376f:	8b 40 04             	mov    0x4(%eax),%eax
  803772:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803777:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80377a:	8b 40 04             	mov    0x4(%eax),%eax
  80377d:	85 c0                	test   %eax,%eax
  80377f:	74 0f                	je     803790 <realloc_block_FF+0x2da>
  803781:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803784:	8b 40 04             	mov    0x4(%eax),%eax
  803787:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80378a:	8b 12                	mov    (%edx),%edx
  80378c:	89 10                	mov    %edx,(%eax)
  80378e:	eb 0a                	jmp    80379a <realloc_block_FF+0x2e4>
  803790:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803793:	8b 00                	mov    (%eax),%eax
  803795:	a3 48 50 98 00       	mov    %eax,0x985048
  80379a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80379d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037a6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037ad:	a1 54 50 98 00       	mov    0x985054,%eax
  8037b2:	48                   	dec    %eax
  8037b3:	a3 54 50 98 00       	mov    %eax,0x985054
					nextBlk = (struct BlockElement *)((char *)va + new_size); //update nextBlk address
  8037b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8037bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037be:	01 d0                	add    %edx,%eax
  8037c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
					set_block_data(nextBlk,remainingNext,0); // update nextBlkSize
  8037c3:	83 ec 04             	sub    $0x4,%esp
  8037c6:	6a 00                	push   $0x0
  8037c8:	ff 75 e0             	pushl  -0x20(%ebp)
  8037cb:	ff 75 f0             	pushl  -0x10(%ebp)
  8037ce:	e8 b3 f1 ff ff       	call   802986 <set_block_data>
  8037d3:	83 c4 10             	add    $0x10,%esp
					set_block_data(va,new_size,!(is_free_block(va))); // update size of newblock
  8037d6:	83 ec 0c             	sub    $0xc,%esp
  8037d9:	ff 75 08             	pushl  0x8(%ebp)
  8037dc:	e8 42 ef ff ff       	call   802723 <is_free_block>
  8037e1:	83 c4 10             	add    $0x10,%esp
  8037e4:	84 c0                	test   %al,%al
  8037e6:	0f 94 c0             	sete   %al
  8037e9:	0f b6 c0             	movzbl %al,%eax
  8037ec:	83 ec 04             	sub    $0x4,%esp
  8037ef:	50                   	push   %eax
  8037f0:	ff 75 0c             	pushl  0xc(%ebp)
  8037f3:	ff 75 08             	pushl  0x8(%ebp)
  8037f6:	e8 8b f1 ff ff       	call   802986 <set_block_data>
  8037fb:	83 c4 10             	add    $0x10,%esp
					insert_sorted_in_freeList(nextBlk);
  8037fe:	83 ec 0c             	sub    $0xc,%esp
  803801:	ff 75 f0             	pushl  -0x10(%ebp)
  803804:	e8 d4 f1 ff ff       	call   8029dd <insert_sorted_in_freeList>
  803809:	83 c4 10             	add    $0x10,%esp
					return va;
  80380c:	8b 45 08             	mov    0x8(%ebp),%eax
  80380f:	e9 49 01 00 00       	jmp    80395d <realloc_block_FF+0x4a7>
				}
			}
		}
		// if next block isn't free or not fit the new size
		return alloc_block_FF(new_size - 8);
  803814:	8b 45 0c             	mov    0xc(%ebp),%eax
  803817:	83 e8 08             	sub    $0x8,%eax
  80381a:	83 ec 0c             	sub    $0xc,%esp
  80381d:	50                   	push   %eax
  80381e:	e8 4d f3 ff ff       	call   802b70 <alloc_block_FF>
  803823:	83 c4 10             	add    $0x10,%esp
  803826:	e9 32 01 00 00       	jmp    80395d <realloc_block_FF+0x4a7>
	}
	else if(new_size < actualSize) // to shrink block
  80382b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80382e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803831:	0f 83 21 01 00 00    	jae    803958 <realloc_block_FF+0x4a2>
	{
		uint32 remainingSize = actualSize - new_size; // size that will remain from the main block after we shrink it
  803837:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80383a:	2b 45 0c             	sub    0xc(%ebp),%eax
  80383d:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(remainingSize < 16 && isNextFree == 0) // internal fragmentation
  803840:	83 7d dc 0f          	cmpl   $0xf,-0x24(%ebp)
  803844:	77 0e                	ja     803854 <realloc_block_FF+0x39e>
  803846:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80384a:	75 08                	jne    803854 <realloc_block_FF+0x39e>
		{
			// don't change its size
			return va;
  80384c:	8b 45 08             	mov    0x8(%ebp),%eax
  80384f:	e9 09 01 00 00       	jmp    80395d <realloc_block_FF+0x4a7>
		}
		else // remainingSize fit in a new block
		{
			struct BlockElement *mainBlk = (struct BlockElement *)va;
  803854:	8b 45 08             	mov    0x8(%ebp),%eax
  803857:	89 45 d8             	mov    %eax,-0x28(%ebp)
			// update main block with new size
			set_block_data(mainBlk,new_size,!(is_free_block(va)));
  80385a:	83 ec 0c             	sub    $0xc,%esp
  80385d:	ff 75 08             	pushl  0x8(%ebp)
  803860:	e8 be ee ff ff       	call   802723 <is_free_block>
  803865:	83 c4 10             	add    $0x10,%esp
  803868:	84 c0                	test   %al,%al
  80386a:	0f 94 c0             	sete   %al
  80386d:	0f b6 c0             	movzbl %al,%eax
  803870:	83 ec 04             	sub    $0x4,%esp
  803873:	50                   	push   %eax
  803874:	ff 75 0c             	pushl  0xc(%ebp)
  803877:	ff 75 d8             	pushl  -0x28(%ebp)
  80387a:	e8 07 f1 ff ff       	call   802986 <set_block_data>
  80387f:	83 c4 10             	add    $0x10,%esp

			// the blk with remaining size
			struct BlockElement *remainingBlk=(struct BlockElement *)((char*)mainBlk + new_size);
  803882:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803885:	8b 45 0c             	mov    0xc(%ebp),%eax
  803888:	01 d0                	add    %edx,%eax
  80388a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			set_block_data(remainingBlk,remainingSize,0);
  80388d:	83 ec 04             	sub    $0x4,%esp
  803890:	6a 00                	push   $0x0
  803892:	ff 75 dc             	pushl  -0x24(%ebp)
  803895:	ff 75 d4             	pushl  -0x2c(%ebp)
  803898:	e8 e9 f0 ff ff       	call   802986 <set_block_data>
  80389d:	83 c4 10             	add    $0x10,%esp

			if(isNextFree)
  8038a0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8038a4:	0f 84 9b 00 00 00    	je     803945 <realloc_block_FF+0x48f>
			{
				// merge splited block with its next block
				set_block_data(remainingBlk,(remainingSize + nextSize),0);//merge remaining with its next block
  8038aa:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8038ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038b0:	01 d0                	add    %edx,%eax
  8038b2:	83 ec 04             	sub    $0x4,%esp
  8038b5:	6a 00                	push   $0x0
  8038b7:	50                   	push   %eax
  8038b8:	ff 75 d4             	pushl  -0x2c(%ebp)
  8038bb:	e8 c6 f0 ff ff       	call   802986 <set_block_data>
  8038c0:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);
  8038c3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8038c7:	75 17                	jne    8038e0 <realloc_block_FF+0x42a>
  8038c9:	83 ec 04             	sub    $0x4,%esp
  8038cc:	68 74 45 80 00       	push   $0x804574
  8038d1:	68 10 02 00 00       	push   $0x210
  8038d6:	68 cb 44 80 00       	push   $0x8044cb
  8038db:	e8 63 ce ff ff       	call   800743 <_panic>
  8038e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038e3:	8b 00                	mov    (%eax),%eax
  8038e5:	85 c0                	test   %eax,%eax
  8038e7:	74 10                	je     8038f9 <realloc_block_FF+0x443>
  8038e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038ec:	8b 00                	mov    (%eax),%eax
  8038ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8038f1:	8b 52 04             	mov    0x4(%edx),%edx
  8038f4:	89 50 04             	mov    %edx,0x4(%eax)
  8038f7:	eb 0b                	jmp    803904 <realloc_block_FF+0x44e>
  8038f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038fc:	8b 40 04             	mov    0x4(%eax),%eax
  8038ff:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803904:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803907:	8b 40 04             	mov    0x4(%eax),%eax
  80390a:	85 c0                	test   %eax,%eax
  80390c:	74 0f                	je     80391d <realloc_block_FF+0x467>
  80390e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803911:	8b 40 04             	mov    0x4(%eax),%eax
  803914:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803917:	8b 12                	mov    (%edx),%edx
  803919:	89 10                	mov    %edx,(%eax)
  80391b:	eb 0a                	jmp    803927 <realloc_block_FF+0x471>
  80391d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803920:	8b 00                	mov    (%eax),%eax
  803922:	a3 48 50 98 00       	mov    %eax,0x985048
  803927:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80392a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803930:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803933:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80393a:	a1 54 50 98 00       	mov    0x985054,%eax
  80393f:	48                   	dec    %eax
  803940:	a3 54 50 98 00       	mov    %eax,0x985054
			}
			insert_sorted_in_freeList(remainingBlk);
  803945:	83 ec 0c             	sub    $0xc,%esp
  803948:	ff 75 d4             	pushl  -0x2c(%ebp)
  80394b:	e8 8d f0 ff ff       	call   8029dd <insert_sorted_in_freeList>
  803950:	83 c4 10             	add    $0x10,%esp
			return mainBlk;
  803953:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803956:	eb 05                	jmp    80395d <realloc_block_FF+0x4a7>
		}
	}
	return NULL;
  803958:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80395d:	c9                   	leave  
  80395e:	c3                   	ret    

0080395f <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  80395f:	55                   	push   %ebp
  803960:	89 e5                	mov    %esp,%ebp
  803962:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803965:	83 ec 04             	sub    $0x4,%esp
  803968:	68 94 45 80 00       	push   $0x804594
  80396d:	68 20 02 00 00       	push   $0x220
  803972:	68 cb 44 80 00       	push   $0x8044cb
  803977:	e8 c7 cd ff ff       	call   800743 <_panic>

0080397c <alloc_block_NF>:
}
//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  80397c:	55                   	push   %ebp
  80397d:	89 e5                	mov    %esp,%ebp
  80397f:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803982:	83 ec 04             	sub    $0x4,%esp
  803985:	68 bc 45 80 00       	push   $0x8045bc
  80398a:	68 28 02 00 00       	push   $0x228
  80398f:	68 cb 44 80 00       	push   $0x8044cb
  803994:	e8 aa cd ff ff       	call   800743 <_panic>
  803999:	66 90                	xchg   %ax,%ax
  80399b:	90                   	nop

0080399c <__udivdi3>:
  80399c:	55                   	push   %ebp
  80399d:	57                   	push   %edi
  80399e:	56                   	push   %esi
  80399f:	53                   	push   %ebx
  8039a0:	83 ec 1c             	sub    $0x1c,%esp
  8039a3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8039a7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8039ab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8039af:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8039b3:	89 ca                	mov    %ecx,%edx
  8039b5:	89 f8                	mov    %edi,%eax
  8039b7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8039bb:	85 f6                	test   %esi,%esi
  8039bd:	75 2d                	jne    8039ec <__udivdi3+0x50>
  8039bf:	39 cf                	cmp    %ecx,%edi
  8039c1:	77 65                	ja     803a28 <__udivdi3+0x8c>
  8039c3:	89 fd                	mov    %edi,%ebp
  8039c5:	85 ff                	test   %edi,%edi
  8039c7:	75 0b                	jne    8039d4 <__udivdi3+0x38>
  8039c9:	b8 01 00 00 00       	mov    $0x1,%eax
  8039ce:	31 d2                	xor    %edx,%edx
  8039d0:	f7 f7                	div    %edi
  8039d2:	89 c5                	mov    %eax,%ebp
  8039d4:	31 d2                	xor    %edx,%edx
  8039d6:	89 c8                	mov    %ecx,%eax
  8039d8:	f7 f5                	div    %ebp
  8039da:	89 c1                	mov    %eax,%ecx
  8039dc:	89 d8                	mov    %ebx,%eax
  8039de:	f7 f5                	div    %ebp
  8039e0:	89 cf                	mov    %ecx,%edi
  8039e2:	89 fa                	mov    %edi,%edx
  8039e4:	83 c4 1c             	add    $0x1c,%esp
  8039e7:	5b                   	pop    %ebx
  8039e8:	5e                   	pop    %esi
  8039e9:	5f                   	pop    %edi
  8039ea:	5d                   	pop    %ebp
  8039eb:	c3                   	ret    
  8039ec:	39 ce                	cmp    %ecx,%esi
  8039ee:	77 28                	ja     803a18 <__udivdi3+0x7c>
  8039f0:	0f bd fe             	bsr    %esi,%edi
  8039f3:	83 f7 1f             	xor    $0x1f,%edi
  8039f6:	75 40                	jne    803a38 <__udivdi3+0x9c>
  8039f8:	39 ce                	cmp    %ecx,%esi
  8039fa:	72 0a                	jb     803a06 <__udivdi3+0x6a>
  8039fc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803a00:	0f 87 9e 00 00 00    	ja     803aa4 <__udivdi3+0x108>
  803a06:	b8 01 00 00 00       	mov    $0x1,%eax
  803a0b:	89 fa                	mov    %edi,%edx
  803a0d:	83 c4 1c             	add    $0x1c,%esp
  803a10:	5b                   	pop    %ebx
  803a11:	5e                   	pop    %esi
  803a12:	5f                   	pop    %edi
  803a13:	5d                   	pop    %ebp
  803a14:	c3                   	ret    
  803a15:	8d 76 00             	lea    0x0(%esi),%esi
  803a18:	31 ff                	xor    %edi,%edi
  803a1a:	31 c0                	xor    %eax,%eax
  803a1c:	89 fa                	mov    %edi,%edx
  803a1e:	83 c4 1c             	add    $0x1c,%esp
  803a21:	5b                   	pop    %ebx
  803a22:	5e                   	pop    %esi
  803a23:	5f                   	pop    %edi
  803a24:	5d                   	pop    %ebp
  803a25:	c3                   	ret    
  803a26:	66 90                	xchg   %ax,%ax
  803a28:	89 d8                	mov    %ebx,%eax
  803a2a:	f7 f7                	div    %edi
  803a2c:	31 ff                	xor    %edi,%edi
  803a2e:	89 fa                	mov    %edi,%edx
  803a30:	83 c4 1c             	add    $0x1c,%esp
  803a33:	5b                   	pop    %ebx
  803a34:	5e                   	pop    %esi
  803a35:	5f                   	pop    %edi
  803a36:	5d                   	pop    %ebp
  803a37:	c3                   	ret    
  803a38:	bd 20 00 00 00       	mov    $0x20,%ebp
  803a3d:	89 eb                	mov    %ebp,%ebx
  803a3f:	29 fb                	sub    %edi,%ebx
  803a41:	89 f9                	mov    %edi,%ecx
  803a43:	d3 e6                	shl    %cl,%esi
  803a45:	89 c5                	mov    %eax,%ebp
  803a47:	88 d9                	mov    %bl,%cl
  803a49:	d3 ed                	shr    %cl,%ebp
  803a4b:	89 e9                	mov    %ebp,%ecx
  803a4d:	09 f1                	or     %esi,%ecx
  803a4f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803a53:	89 f9                	mov    %edi,%ecx
  803a55:	d3 e0                	shl    %cl,%eax
  803a57:	89 c5                	mov    %eax,%ebp
  803a59:	89 d6                	mov    %edx,%esi
  803a5b:	88 d9                	mov    %bl,%cl
  803a5d:	d3 ee                	shr    %cl,%esi
  803a5f:	89 f9                	mov    %edi,%ecx
  803a61:	d3 e2                	shl    %cl,%edx
  803a63:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a67:	88 d9                	mov    %bl,%cl
  803a69:	d3 e8                	shr    %cl,%eax
  803a6b:	09 c2                	or     %eax,%edx
  803a6d:	89 d0                	mov    %edx,%eax
  803a6f:	89 f2                	mov    %esi,%edx
  803a71:	f7 74 24 0c          	divl   0xc(%esp)
  803a75:	89 d6                	mov    %edx,%esi
  803a77:	89 c3                	mov    %eax,%ebx
  803a79:	f7 e5                	mul    %ebp
  803a7b:	39 d6                	cmp    %edx,%esi
  803a7d:	72 19                	jb     803a98 <__udivdi3+0xfc>
  803a7f:	74 0b                	je     803a8c <__udivdi3+0xf0>
  803a81:	89 d8                	mov    %ebx,%eax
  803a83:	31 ff                	xor    %edi,%edi
  803a85:	e9 58 ff ff ff       	jmp    8039e2 <__udivdi3+0x46>
  803a8a:	66 90                	xchg   %ax,%ax
  803a8c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803a90:	89 f9                	mov    %edi,%ecx
  803a92:	d3 e2                	shl    %cl,%edx
  803a94:	39 c2                	cmp    %eax,%edx
  803a96:	73 e9                	jae    803a81 <__udivdi3+0xe5>
  803a98:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803a9b:	31 ff                	xor    %edi,%edi
  803a9d:	e9 40 ff ff ff       	jmp    8039e2 <__udivdi3+0x46>
  803aa2:	66 90                	xchg   %ax,%ax
  803aa4:	31 c0                	xor    %eax,%eax
  803aa6:	e9 37 ff ff ff       	jmp    8039e2 <__udivdi3+0x46>
  803aab:	90                   	nop

00803aac <__umoddi3>:
  803aac:	55                   	push   %ebp
  803aad:	57                   	push   %edi
  803aae:	56                   	push   %esi
  803aaf:	53                   	push   %ebx
  803ab0:	83 ec 1c             	sub    $0x1c,%esp
  803ab3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803ab7:	8b 74 24 34          	mov    0x34(%esp),%esi
  803abb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803abf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803ac3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803ac7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803acb:	89 f3                	mov    %esi,%ebx
  803acd:	89 fa                	mov    %edi,%edx
  803acf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ad3:	89 34 24             	mov    %esi,(%esp)
  803ad6:	85 c0                	test   %eax,%eax
  803ad8:	75 1a                	jne    803af4 <__umoddi3+0x48>
  803ada:	39 f7                	cmp    %esi,%edi
  803adc:	0f 86 a2 00 00 00    	jbe    803b84 <__umoddi3+0xd8>
  803ae2:	89 c8                	mov    %ecx,%eax
  803ae4:	89 f2                	mov    %esi,%edx
  803ae6:	f7 f7                	div    %edi
  803ae8:	89 d0                	mov    %edx,%eax
  803aea:	31 d2                	xor    %edx,%edx
  803aec:	83 c4 1c             	add    $0x1c,%esp
  803aef:	5b                   	pop    %ebx
  803af0:	5e                   	pop    %esi
  803af1:	5f                   	pop    %edi
  803af2:	5d                   	pop    %ebp
  803af3:	c3                   	ret    
  803af4:	39 f0                	cmp    %esi,%eax
  803af6:	0f 87 ac 00 00 00    	ja     803ba8 <__umoddi3+0xfc>
  803afc:	0f bd e8             	bsr    %eax,%ebp
  803aff:	83 f5 1f             	xor    $0x1f,%ebp
  803b02:	0f 84 ac 00 00 00    	je     803bb4 <__umoddi3+0x108>
  803b08:	bf 20 00 00 00       	mov    $0x20,%edi
  803b0d:	29 ef                	sub    %ebp,%edi
  803b0f:	89 fe                	mov    %edi,%esi
  803b11:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803b15:	89 e9                	mov    %ebp,%ecx
  803b17:	d3 e0                	shl    %cl,%eax
  803b19:	89 d7                	mov    %edx,%edi
  803b1b:	89 f1                	mov    %esi,%ecx
  803b1d:	d3 ef                	shr    %cl,%edi
  803b1f:	09 c7                	or     %eax,%edi
  803b21:	89 e9                	mov    %ebp,%ecx
  803b23:	d3 e2                	shl    %cl,%edx
  803b25:	89 14 24             	mov    %edx,(%esp)
  803b28:	89 d8                	mov    %ebx,%eax
  803b2a:	d3 e0                	shl    %cl,%eax
  803b2c:	89 c2                	mov    %eax,%edx
  803b2e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b32:	d3 e0                	shl    %cl,%eax
  803b34:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b38:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b3c:	89 f1                	mov    %esi,%ecx
  803b3e:	d3 e8                	shr    %cl,%eax
  803b40:	09 d0                	or     %edx,%eax
  803b42:	d3 eb                	shr    %cl,%ebx
  803b44:	89 da                	mov    %ebx,%edx
  803b46:	f7 f7                	div    %edi
  803b48:	89 d3                	mov    %edx,%ebx
  803b4a:	f7 24 24             	mull   (%esp)
  803b4d:	89 c6                	mov    %eax,%esi
  803b4f:	89 d1                	mov    %edx,%ecx
  803b51:	39 d3                	cmp    %edx,%ebx
  803b53:	0f 82 87 00 00 00    	jb     803be0 <__umoddi3+0x134>
  803b59:	0f 84 91 00 00 00    	je     803bf0 <__umoddi3+0x144>
  803b5f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803b63:	29 f2                	sub    %esi,%edx
  803b65:	19 cb                	sbb    %ecx,%ebx
  803b67:	89 d8                	mov    %ebx,%eax
  803b69:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803b6d:	d3 e0                	shl    %cl,%eax
  803b6f:	89 e9                	mov    %ebp,%ecx
  803b71:	d3 ea                	shr    %cl,%edx
  803b73:	09 d0                	or     %edx,%eax
  803b75:	89 e9                	mov    %ebp,%ecx
  803b77:	d3 eb                	shr    %cl,%ebx
  803b79:	89 da                	mov    %ebx,%edx
  803b7b:	83 c4 1c             	add    $0x1c,%esp
  803b7e:	5b                   	pop    %ebx
  803b7f:	5e                   	pop    %esi
  803b80:	5f                   	pop    %edi
  803b81:	5d                   	pop    %ebp
  803b82:	c3                   	ret    
  803b83:	90                   	nop
  803b84:	89 fd                	mov    %edi,%ebp
  803b86:	85 ff                	test   %edi,%edi
  803b88:	75 0b                	jne    803b95 <__umoddi3+0xe9>
  803b8a:	b8 01 00 00 00       	mov    $0x1,%eax
  803b8f:	31 d2                	xor    %edx,%edx
  803b91:	f7 f7                	div    %edi
  803b93:	89 c5                	mov    %eax,%ebp
  803b95:	89 f0                	mov    %esi,%eax
  803b97:	31 d2                	xor    %edx,%edx
  803b99:	f7 f5                	div    %ebp
  803b9b:	89 c8                	mov    %ecx,%eax
  803b9d:	f7 f5                	div    %ebp
  803b9f:	89 d0                	mov    %edx,%eax
  803ba1:	e9 44 ff ff ff       	jmp    803aea <__umoddi3+0x3e>
  803ba6:	66 90                	xchg   %ax,%ax
  803ba8:	89 c8                	mov    %ecx,%eax
  803baa:	89 f2                	mov    %esi,%edx
  803bac:	83 c4 1c             	add    $0x1c,%esp
  803baf:	5b                   	pop    %ebx
  803bb0:	5e                   	pop    %esi
  803bb1:	5f                   	pop    %edi
  803bb2:	5d                   	pop    %ebp
  803bb3:	c3                   	ret    
  803bb4:	3b 04 24             	cmp    (%esp),%eax
  803bb7:	72 06                	jb     803bbf <__umoddi3+0x113>
  803bb9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803bbd:	77 0f                	ja     803bce <__umoddi3+0x122>
  803bbf:	89 f2                	mov    %esi,%edx
  803bc1:	29 f9                	sub    %edi,%ecx
  803bc3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803bc7:	89 14 24             	mov    %edx,(%esp)
  803bca:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803bce:	8b 44 24 04          	mov    0x4(%esp),%eax
  803bd2:	8b 14 24             	mov    (%esp),%edx
  803bd5:	83 c4 1c             	add    $0x1c,%esp
  803bd8:	5b                   	pop    %ebx
  803bd9:	5e                   	pop    %esi
  803bda:	5f                   	pop    %edi
  803bdb:	5d                   	pop    %ebp
  803bdc:	c3                   	ret    
  803bdd:	8d 76 00             	lea    0x0(%esi),%esi
  803be0:	2b 04 24             	sub    (%esp),%eax
  803be3:	19 fa                	sbb    %edi,%edx
  803be5:	89 d1                	mov    %edx,%ecx
  803be7:	89 c6                	mov    %eax,%esi
  803be9:	e9 71 ff ff ff       	jmp    803b5f <__umoddi3+0xb3>
  803bee:	66 90                	xchg   %ax,%ax
  803bf0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803bf4:	72 ea                	jb     803be0 <__umoddi3+0x134>
  803bf6:	89 d9                	mov    %ebx,%ecx
  803bf8:	e9 62 ff ff ff       	jmp    803b5f <__umoddi3+0xb3>
