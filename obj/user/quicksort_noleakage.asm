
obj/user/quicksort_noleakage:     file format elf32-i386


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
  800031:	e8 d6 05 00 00       	call   80060c <libmain>
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
  800041:	e8 a2 20 00 00       	call   8020e8 <sys_lock_cons>
		{
			cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 20 3c 80 00       	push   $0x803c20
  80004e:	e8 bb 09 00 00       	call   800a0e <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 22 3c 80 00       	push   $0x803c22
  80005e:	e8 ab 09 00 00       	call   800a0e <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!   QUICK SORT    !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 3b 3c 80 00       	push   $0x803c3b
  80006e:	e8 9b 09 00 00       	call   800a0e <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 22 3c 80 00       	push   $0x803c22
  80007e:	e8 8b 09 00 00       	call   800a0e <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
			cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 20 3c 80 00       	push   $0x803c20
  80008e:	e8 7b 09 00 00       	call   800a0e <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

			readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 54 3c 80 00       	push   $0x803c54
  8000a5:	e8 f8 0f 00 00       	call   8010a2 <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
			NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 4a 15 00 00       	call   80160a <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			cprintf("Chose the initialization method:\n") ;
  8000c6:	83 ec 0c             	sub    $0xc,%esp
  8000c9:	68 74 3c 80 00       	push   $0x803c74
  8000ce:	e8 3b 09 00 00       	call   800a0e <cprintf>
  8000d3:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 96 3c 80 00       	push   $0x803c96
  8000de:	e8 2b 09 00 00       	call   800a0e <cprintf>
  8000e3:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	68 a4 3c 80 00       	push   $0x803ca4
  8000ee:	e8 1b 09 00 00       	call   800a0e <cprintf>
  8000f3:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  8000f6:	83 ec 0c             	sub    $0xc,%esp
  8000f9:	68 b3 3c 80 00       	push   $0x803cb3
  8000fe:	e8 0b 09 00 00       	call   800a0e <cprintf>
  800103:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  800106:	83 ec 0c             	sub    $0xc,%esp
  800109:	68 c3 3c 80 00       	push   $0x803cc3
  80010e:	e8 fb 08 00 00       	call   800a0e <cprintf>
  800113:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800116:	e8 d4 04 00 00       	call   8005ef <getchar>
  80011b:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  80011e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800122:	83 ec 0c             	sub    $0xc,%esp
  800125:	50                   	push   %eax
  800126:	e8 a5 04 00 00       	call   8005d0 <cputchar>
  80012b:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80012e:	83 ec 0c             	sub    $0xc,%esp
  800131:	6a 0a                	push   $0xa
  800133:	e8 98 04 00 00       	call   8005d0 <cputchar>
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
  80014d:	e8 b0 1f 00 00       	call   802102 <sys_unlock_cons>
		//sys_unlock_cons();

		Elements = malloc(sizeof(int) * NumOfElements) ;
  800152:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800155:	c1 e0 02             	shl    $0x2,%eax
  800158:	83 ec 0c             	sub    $0xc,%esp
  80015b:	50                   	push   %eax
  80015c:	e8 65 18 00 00       	call   8019c6 <malloc>
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
  800183:	e8 03 03 00 00       	call   80048b <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f0             	pushl  -0x10(%ebp)
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	e8 21 03 00 00       	call   8004bc <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a9:	e8 43 03 00 00       	call   8004f1 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 30 03 00 00       	call   8004f1 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  8001c4:	83 ec 08             	sub    $0x8,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cd:	e8 fe 00 00 00       	call   8002d0 <QuickSort>
  8001d2:	83 c4 10             	add    $0x10,%esp

		//sys_lock_cons();
		sys_lock_cons();
  8001d5:	e8 0e 1f 00 00       	call   8020e8 <sys_lock_cons>
		{
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	68 cc 3c 80 00       	push   $0x803ccc
  8001e2:	e8 27 08 00 00       	call   800a0e <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
			//		PrintElements(Elements, NumOfElements);
		}
		sys_unlock_cons();
  8001ea:	e8 13 1f 00 00       	call   802102 <sys_unlock_cons>
		//sys_unlock_cons();

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001ef:	83 ec 08             	sub    $0x8,%esp
  8001f2:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f5:	ff 75 ec             	pushl  -0x14(%ebp)
  8001f8:	e8 e4 01 00 00       	call   8003e1 <CheckSorted>
  8001fd:	83 c4 10             	add    $0x10,%esp
  800200:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800203:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800207:	75 14                	jne    80021d <_main+0x1e5>
  800209:	83 ec 04             	sub    $0x4,%esp
  80020c:	68 00 3d 80 00       	push   $0x803d00
  800211:	6a 54                	push   $0x54
  800213:	68 22 3d 80 00       	push   $0x803d22
  800218:	e8 34 05 00 00       	call   800751 <_panic>
		else
		{
			//			sys_lock_cons();
			sys_lock_cons();
  80021d:	e8 c6 1e 00 00       	call   8020e8 <sys_lock_cons>
			{
				cprintf("===============================================\n") ;
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	68 40 3d 80 00       	push   $0x803d40
  80022a:	e8 df 07 00 00       	call   800a0e <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 74 3d 80 00       	push   $0x803d74
  80023a:	e8 cf 07 00 00       	call   800a0e <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	68 a8 3d 80 00       	push   $0x803da8
  80024a:	e8 bf 07 00 00       	call   800a0e <cprintf>
  80024f:	83 c4 10             	add    $0x10,%esp
			}
			sys_unlock_cons();
  800252:	e8 ab 1e 00 00       	call   802102 <sys_unlock_cons>
			//			sys_unlock_cons();


		}

		free(Elements) ;
  800257:	83 ec 0c             	sub    $0xc,%esp
  80025a:	ff 75 ec             	pushl  -0x14(%ebp)
  80025d:	e8 1a 19 00 00       	call   801b7c <free>
  800262:	83 c4 10             	add    $0x10,%esp

		//		sys_lock_cons();
		sys_lock_cons();
  800265:	e8 7e 1e 00 00       	call   8020e8 <sys_lock_cons>
		{
			Chose = 0 ;
  80026a:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  80026e:	eb 42                	jmp    8002b2 <_main+0x27a>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800270:	83 ec 0c             	sub    $0xc,%esp
  800273:	68 da 3d 80 00       	push   $0x803dda
  800278:	e8 91 07 00 00       	call   800a0e <cprintf>
  80027d:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800280:	e8 6a 03 00 00       	call   8005ef <getchar>
  800285:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  800288:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	50                   	push   %eax
  800290:	e8 3b 03 00 00       	call   8005d0 <cputchar>
  800295:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800298:	83 ec 0c             	sub    $0xc,%esp
  80029b:	6a 0a                	push   $0xa
  80029d:	e8 2e 03 00 00       	call   8005d0 <cputchar>
  8002a2:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  8002a5:	83 ec 0c             	sub    $0xc,%esp
  8002a8:	6a 0a                	push   $0xa
  8002aa:	e8 21 03 00 00       	call   8005d0 <cputchar>
  8002af:	83 c4 10             	add    $0x10,%esp

		//		sys_lock_cons();
		sys_lock_cons();
		{
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002b2:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002b6:	74 06                	je     8002be <_main+0x286>
  8002b8:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002bc:	75 b2                	jne    800270 <_main+0x238>
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		}
		sys_unlock_cons();
  8002be:	e8 3f 1e 00 00       	call   802102 <sys_unlock_cons>
		//		sys_unlock_cons();

	} while (Chose == 'y');
  8002c3:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002c7:	0f 84 74 fd ff ff    	je     800041 <_main+0x9>

}
  8002cd:	90                   	nop
  8002ce:	c9                   	leave  
  8002cf:	c3                   	ret    

008002d0 <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  8002d0:	55                   	push   %ebp
  8002d1:	89 e5                	mov    %esp,%ebp
  8002d3:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  8002d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d9:	48                   	dec    %eax
  8002da:	50                   	push   %eax
  8002db:	6a 00                	push   $0x0
  8002dd:	ff 75 0c             	pushl  0xc(%ebp)
  8002e0:	ff 75 08             	pushl  0x8(%ebp)
  8002e3:	e8 06 00 00 00       	call   8002ee <QSort>
  8002e8:	83 c4 10             	add    $0x10,%esp
}
  8002eb:	90                   	nop
  8002ec:	c9                   	leave  
  8002ed:	c3                   	ret    

008002ee <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  8002ee:	55                   	push   %ebp
  8002ef:	89 e5                	mov    %esp,%ebp
  8002f1:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  8002f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8002f7:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002fa:	0f 8d de 00 00 00    	jge    8003de <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  800300:	8b 45 10             	mov    0x10(%ebp),%eax
  800303:	40                   	inc    %eax
  800304:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800307:	8b 45 14             	mov    0x14(%ebp),%eax
  80030a:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  80030d:	e9 80 00 00 00       	jmp    800392 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800312:	ff 45 f4             	incl   -0xc(%ebp)
  800315:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800318:	3b 45 14             	cmp    0x14(%ebp),%eax
  80031b:	7f 2b                	jg     800348 <QSort+0x5a>
  80031d:	8b 45 10             	mov    0x10(%ebp),%eax
  800320:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800327:	8b 45 08             	mov    0x8(%ebp),%eax
  80032a:	01 d0                	add    %edx,%eax
  80032c:	8b 10                	mov    (%eax),%edx
  80032e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800331:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800338:	8b 45 08             	mov    0x8(%ebp),%eax
  80033b:	01 c8                	add    %ecx,%eax
  80033d:	8b 00                	mov    (%eax),%eax
  80033f:	39 c2                	cmp    %eax,%edx
  800341:	7d cf                	jge    800312 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  800343:	eb 03                	jmp    800348 <QSort+0x5a>
  800345:	ff 4d f0             	decl   -0x10(%ebp)
  800348:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80034b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80034e:	7e 26                	jle    800376 <QSort+0x88>
  800350:	8b 45 10             	mov    0x10(%ebp),%eax
  800353:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80035a:	8b 45 08             	mov    0x8(%ebp),%eax
  80035d:	01 d0                	add    %edx,%eax
  80035f:	8b 10                	mov    (%eax),%edx
  800361:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800364:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80036b:	8b 45 08             	mov    0x8(%ebp),%eax
  80036e:	01 c8                	add    %ecx,%eax
  800370:	8b 00                	mov    (%eax),%eax
  800372:	39 c2                	cmp    %eax,%edx
  800374:	7e cf                	jle    800345 <QSort+0x57>

		if (i <= j)
  800376:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800379:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80037c:	7f 14                	jg     800392 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  80037e:	83 ec 04             	sub    $0x4,%esp
  800381:	ff 75 f0             	pushl  -0x10(%ebp)
  800384:	ff 75 f4             	pushl  -0xc(%ebp)
  800387:	ff 75 08             	pushl  0x8(%ebp)
  80038a:	e8 a9 00 00 00       	call   800438 <Swap>
  80038f:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800392:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800395:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800398:	0f 8e 77 ff ff ff    	jle    800315 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  80039e:	83 ec 04             	sub    $0x4,%esp
  8003a1:	ff 75 f0             	pushl  -0x10(%ebp)
  8003a4:	ff 75 10             	pushl  0x10(%ebp)
  8003a7:	ff 75 08             	pushl  0x8(%ebp)
  8003aa:	e8 89 00 00 00       	call   800438 <Swap>
  8003af:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  8003b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003b5:	48                   	dec    %eax
  8003b6:	50                   	push   %eax
  8003b7:	ff 75 10             	pushl  0x10(%ebp)
  8003ba:	ff 75 0c             	pushl  0xc(%ebp)
  8003bd:	ff 75 08             	pushl  0x8(%ebp)
  8003c0:	e8 29 ff ff ff       	call   8002ee <QSort>
  8003c5:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  8003c8:	ff 75 14             	pushl  0x14(%ebp)
  8003cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8003ce:	ff 75 0c             	pushl  0xc(%ebp)
  8003d1:	ff 75 08             	pushl  0x8(%ebp)
  8003d4:	e8 15 ff ff ff       	call   8002ee <QSort>
  8003d9:	83 c4 10             	add    $0x10,%esp
  8003dc:	eb 01                	jmp    8003df <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  8003de:	90                   	nop
	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);

	//cprintf("qs,after sorting: start = %d, end = %d\n", startIndex, finalIndex);

}
  8003df:	c9                   	leave  
  8003e0:	c3                   	ret    

008003e1 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8003e1:	55                   	push   %ebp
  8003e2:	89 e5                	mov    %esp,%ebp
  8003e4:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8003e7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8003ee:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8003f5:	eb 33                	jmp    80042a <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8003f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800401:	8b 45 08             	mov    0x8(%ebp),%eax
  800404:	01 d0                	add    %edx,%eax
  800406:	8b 10                	mov    (%eax),%edx
  800408:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80040b:	40                   	inc    %eax
  80040c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800413:	8b 45 08             	mov    0x8(%ebp),%eax
  800416:	01 c8                	add    %ecx,%eax
  800418:	8b 00                	mov    (%eax),%eax
  80041a:	39 c2                	cmp    %eax,%edx
  80041c:	7e 09                	jle    800427 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  80041e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800425:	eb 0c                	jmp    800433 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800427:	ff 45 f8             	incl   -0x8(%ebp)
  80042a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80042d:	48                   	dec    %eax
  80042e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800431:	7f c4                	jg     8003f7 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800433:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800436:	c9                   	leave  
  800437:	c3                   	ret    

00800438 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  800438:	55                   	push   %ebp
  800439:	89 e5                	mov    %esp,%ebp
  80043b:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  80043e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800441:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800448:	8b 45 08             	mov    0x8(%ebp),%eax
  80044b:	01 d0                	add    %edx,%eax
  80044d:	8b 00                	mov    (%eax),%eax
  80044f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800452:	8b 45 0c             	mov    0xc(%ebp),%eax
  800455:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80045c:	8b 45 08             	mov    0x8(%ebp),%eax
  80045f:	01 c2                	add    %eax,%edx
  800461:	8b 45 10             	mov    0x10(%ebp),%eax
  800464:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80046b:	8b 45 08             	mov    0x8(%ebp),%eax
  80046e:	01 c8                	add    %ecx,%eax
  800470:	8b 00                	mov    (%eax),%eax
  800472:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800474:	8b 45 10             	mov    0x10(%ebp),%eax
  800477:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80047e:	8b 45 08             	mov    0x8(%ebp),%eax
  800481:	01 c2                	add    %eax,%edx
  800483:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800486:	89 02                	mov    %eax,(%edx)
}
  800488:	90                   	nop
  800489:	c9                   	leave  
  80048a:	c3                   	ret    

0080048b <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80048b:	55                   	push   %ebp
  80048c:	89 e5                	mov    %esp,%ebp
  80048e:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800491:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800498:	eb 17                	jmp    8004b1 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80049a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80049d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a7:	01 c2                	add    %eax,%edx
  8004a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004ac:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004ae:	ff 45 fc             	incl   -0x4(%ebp)
  8004b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004b4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004b7:	7c e1                	jl     80049a <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8004b9:	90                   	nop
  8004ba:	c9                   	leave  
  8004bb:	c3                   	ret    

008004bc <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8004bc:	55                   	push   %ebp
  8004bd:	89 e5                	mov    %esp,%ebp
  8004bf:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004c9:	eb 1b                	jmp    8004e6 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8004cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004ce:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d8:	01 c2                	add    %eax,%edx
  8004da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004dd:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8004e0:	48                   	dec    %eax
  8004e1:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004e3:	ff 45 fc             	incl   -0x4(%ebp)
  8004e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004e9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004ec:	7c dd                	jl     8004cb <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8004ee:	90                   	nop
  8004ef:	c9                   	leave  
  8004f0:	c3                   	ret    

008004f1 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8004f1:	55                   	push   %ebp
  8004f2:	89 e5                	mov    %esp,%ebp
  8004f4:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8004f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004fa:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8004ff:	f7 e9                	imul   %ecx
  800501:	c1 f9 1f             	sar    $0x1f,%ecx
  800504:	89 d0                	mov    %edx,%eax
  800506:	29 c8                	sub    %ecx,%eax
  800508:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (Repetition == 0)
  80050b:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80050f:	75 07                	jne    800518 <InitializeSemiRandom+0x27>
		Repetition = 3;
  800511:	c7 45 f8 03 00 00 00 	movl   $0x3,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  800518:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80051f:	eb 1e                	jmp    80053f <InitializeSemiRandom+0x4e>
	{
		Elements[i] = i % Repetition ;
  800521:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800524:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80052b:	8b 45 08             	mov    0x8(%ebp),%eax
  80052e:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800531:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800534:	99                   	cltd   
  800535:	f7 7d f8             	idivl  -0x8(%ebp)
  800538:	89 d0                	mov    %edx,%eax
  80053a:	89 01                	mov    %eax,(%ecx)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	if (Repetition == 0)
		Repetition = 3;
	for (i = 0 ; i < NumOfElements ; i++)
  80053c:	ff 45 fc             	incl   -0x4(%ebp)
  80053f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800542:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800545:	7c da                	jl     800521 <InitializeSemiRandom+0x30>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  800547:	90                   	nop
  800548:	c9                   	leave  
  800549:	c3                   	ret    

0080054a <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  80054a:	55                   	push   %ebp
  80054b:	89 e5                	mov    %esp,%ebp
  80054d:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800550:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800557:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80055e:	eb 42                	jmp    8005a2 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800560:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800563:	99                   	cltd   
  800564:	f7 7d f0             	idivl  -0x10(%ebp)
  800567:	89 d0                	mov    %edx,%eax
  800569:	85 c0                	test   %eax,%eax
  80056b:	75 10                	jne    80057d <PrintElements+0x33>
			cprintf("\n");
  80056d:	83 ec 0c             	sub    $0xc,%esp
  800570:	68 20 3c 80 00       	push   $0x803c20
  800575:	e8 94 04 00 00       	call   800a0e <cprintf>
  80057a:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  80057d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800580:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800587:	8b 45 08             	mov    0x8(%ebp),%eax
  80058a:	01 d0                	add    %edx,%eax
  80058c:	8b 00                	mov    (%eax),%eax
  80058e:	83 ec 08             	sub    $0x8,%esp
  800591:	50                   	push   %eax
  800592:	68 f8 3d 80 00       	push   $0x803df8
  800597:	e8 72 04 00 00       	call   800a0e <cprintf>
  80059c:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80059f:	ff 45 f4             	incl   -0xc(%ebp)
  8005a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005a5:	48                   	dec    %eax
  8005a6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8005a9:	7f b5                	jg     800560 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  8005ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005ae:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b8:	01 d0                	add    %edx,%eax
  8005ba:	8b 00                	mov    (%eax),%eax
  8005bc:	83 ec 08             	sub    $0x8,%esp
  8005bf:	50                   	push   %eax
  8005c0:	68 fd 3d 80 00       	push   $0x803dfd
  8005c5:	e8 44 04 00 00       	call   800a0e <cprintf>
  8005ca:	83 c4 10             	add    $0x10,%esp

}
  8005cd:	90                   	nop
  8005ce:	c9                   	leave  
  8005cf:	c3                   	ret    

008005d0 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8005d0:	55                   	push   %ebp
  8005d1:	89 e5                	mov    %esp,%ebp
  8005d3:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8005d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d9:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8005dc:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8005e0:	83 ec 0c             	sub    $0xc,%esp
  8005e3:	50                   	push   %eax
  8005e4:	e8 4a 1c 00 00       	call   802233 <sys_cputc>
  8005e9:	83 c4 10             	add    $0x10,%esp
}
  8005ec:	90                   	nop
  8005ed:	c9                   	leave  
  8005ee:	c3                   	ret    

008005ef <getchar>:


int
getchar(void)
{
  8005ef:	55                   	push   %ebp
  8005f0:	89 e5                	mov    %esp,%ebp
  8005f2:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  8005f5:	e8 d5 1a 00 00       	call   8020cf <sys_cgetc>
  8005fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  8005fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800600:	c9                   	leave  
  800601:	c3                   	ret    

00800602 <iscons>:

int iscons(int fdnum)
{
  800602:	55                   	push   %ebp
  800603:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800605:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80060a:	5d                   	pop    %ebp
  80060b:	c3                   	ret    

0080060c <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80060c:	55                   	push   %ebp
  80060d:	89 e5                	mov    %esp,%ebp
  80060f:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800612:	e8 4d 1d 00 00       	call   802364 <sys_getenvindex>
  800617:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80061a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80061d:	89 d0                	mov    %edx,%eax
  80061f:	c1 e0 02             	shl    $0x2,%eax
  800622:	01 d0                	add    %edx,%eax
  800624:	c1 e0 03             	shl    $0x3,%eax
  800627:	01 d0                	add    %edx,%eax
  800629:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800630:	01 d0                	add    %edx,%eax
  800632:	c1 e0 02             	shl    $0x2,%eax
  800635:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80063a:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80063f:	a1 24 50 80 00       	mov    0x805024,%eax
  800644:	8a 40 20             	mov    0x20(%eax),%al
  800647:	84 c0                	test   %al,%al
  800649:	74 0d                	je     800658 <libmain+0x4c>
		binaryname = myEnv->prog_name;
  80064b:	a1 24 50 80 00       	mov    0x805024,%eax
  800650:	83 c0 20             	add    $0x20,%eax
  800653:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800658:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80065c:	7e 0a                	jle    800668 <libmain+0x5c>
		binaryname = argv[0];
  80065e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800661:	8b 00                	mov    (%eax),%eax
  800663:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  800668:	83 ec 08             	sub    $0x8,%esp
  80066b:	ff 75 0c             	pushl  0xc(%ebp)
  80066e:	ff 75 08             	pushl  0x8(%ebp)
  800671:	e8 c2 f9 ff ff       	call   800038 <_main>
  800676:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800679:	a1 00 50 80 00       	mov    0x805000,%eax
  80067e:	85 c0                	test   %eax,%eax
  800680:	0f 84 9f 00 00 00    	je     800725 <libmain+0x119>
	{
		sys_lock_cons();
  800686:	e8 5d 1a 00 00       	call   8020e8 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80068b:	83 ec 0c             	sub    $0xc,%esp
  80068e:	68 1c 3e 80 00       	push   $0x803e1c
  800693:	e8 76 03 00 00       	call   800a0e <cprintf>
  800698:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80069b:	a1 24 50 80 00       	mov    0x805024,%eax
  8006a0:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8006a6:	a1 24 50 80 00       	mov    0x805024,%eax
  8006ab:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8006b1:	83 ec 04             	sub    $0x4,%esp
  8006b4:	52                   	push   %edx
  8006b5:	50                   	push   %eax
  8006b6:	68 44 3e 80 00       	push   $0x803e44
  8006bb:	e8 4e 03 00 00       	call   800a0e <cprintf>
  8006c0:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8006c3:	a1 24 50 80 00       	mov    0x805024,%eax
  8006c8:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8006ce:	a1 24 50 80 00       	mov    0x805024,%eax
  8006d3:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8006d9:	a1 24 50 80 00       	mov    0x805024,%eax
  8006de:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  8006e4:	51                   	push   %ecx
  8006e5:	52                   	push   %edx
  8006e6:	50                   	push   %eax
  8006e7:	68 6c 3e 80 00       	push   $0x803e6c
  8006ec:	e8 1d 03 00 00       	call   800a0e <cprintf>
  8006f1:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006f4:	a1 24 50 80 00       	mov    0x805024,%eax
  8006f9:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8006ff:	83 ec 08             	sub    $0x8,%esp
  800702:	50                   	push   %eax
  800703:	68 c4 3e 80 00       	push   $0x803ec4
  800708:	e8 01 03 00 00       	call   800a0e <cprintf>
  80070d:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800710:	83 ec 0c             	sub    $0xc,%esp
  800713:	68 1c 3e 80 00       	push   $0x803e1c
  800718:	e8 f1 02 00 00       	call   800a0e <cprintf>
  80071d:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800720:	e8 dd 19 00 00       	call   802102 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800725:	e8 19 00 00 00       	call   800743 <exit>
}
  80072a:	90                   	nop
  80072b:	c9                   	leave  
  80072c:	c3                   	ret    

0080072d <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80072d:	55                   	push   %ebp
  80072e:	89 e5                	mov    %esp,%ebp
  800730:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800733:	83 ec 0c             	sub    $0xc,%esp
  800736:	6a 00                	push   $0x0
  800738:	e8 f3 1b 00 00       	call   802330 <sys_destroy_env>
  80073d:	83 c4 10             	add    $0x10,%esp
}
  800740:	90                   	nop
  800741:	c9                   	leave  
  800742:	c3                   	ret    

00800743 <exit>:

void
exit(void)
{
  800743:	55                   	push   %ebp
  800744:	89 e5                	mov    %esp,%ebp
  800746:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800749:	e8 48 1c 00 00       	call   802396 <sys_exit_env>
}
  80074e:	90                   	nop
  80074f:	c9                   	leave  
  800750:	c3                   	ret    

00800751 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800751:	55                   	push   %ebp
  800752:	89 e5                	mov    %esp,%ebp
  800754:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800757:	8d 45 10             	lea    0x10(%ebp),%eax
  80075a:	83 c0 04             	add    $0x4,%eax
  80075d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800760:	a1 60 50 98 00       	mov    0x985060,%eax
  800765:	85 c0                	test   %eax,%eax
  800767:	74 16                	je     80077f <_panic+0x2e>
		cprintf("%s: ", argv0);
  800769:	a1 60 50 98 00       	mov    0x985060,%eax
  80076e:	83 ec 08             	sub    $0x8,%esp
  800771:	50                   	push   %eax
  800772:	68 d8 3e 80 00       	push   $0x803ed8
  800777:	e8 92 02 00 00       	call   800a0e <cprintf>
  80077c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80077f:	a1 04 50 80 00       	mov    0x805004,%eax
  800784:	ff 75 0c             	pushl  0xc(%ebp)
  800787:	ff 75 08             	pushl  0x8(%ebp)
  80078a:	50                   	push   %eax
  80078b:	68 dd 3e 80 00       	push   $0x803edd
  800790:	e8 79 02 00 00       	call   800a0e <cprintf>
  800795:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800798:	8b 45 10             	mov    0x10(%ebp),%eax
  80079b:	83 ec 08             	sub    $0x8,%esp
  80079e:	ff 75 f4             	pushl  -0xc(%ebp)
  8007a1:	50                   	push   %eax
  8007a2:	e8 fc 01 00 00       	call   8009a3 <vcprintf>
  8007a7:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8007aa:	83 ec 08             	sub    $0x8,%esp
  8007ad:	6a 00                	push   $0x0
  8007af:	68 f9 3e 80 00       	push   $0x803ef9
  8007b4:	e8 ea 01 00 00       	call   8009a3 <vcprintf>
  8007b9:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8007bc:	e8 82 ff ff ff       	call   800743 <exit>

	// should not return here
	while (1) ;
  8007c1:	eb fe                	jmp    8007c1 <_panic+0x70>

008007c3 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8007c3:	55                   	push   %ebp
  8007c4:	89 e5                	mov    %esp,%ebp
  8007c6:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8007c9:	a1 24 50 80 00       	mov    0x805024,%eax
  8007ce:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8007d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007d7:	39 c2                	cmp    %eax,%edx
  8007d9:	74 14                	je     8007ef <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8007db:	83 ec 04             	sub    $0x4,%esp
  8007de:	68 fc 3e 80 00       	push   $0x803efc
  8007e3:	6a 26                	push   $0x26
  8007e5:	68 48 3f 80 00       	push   $0x803f48
  8007ea:	e8 62 ff ff ff       	call   800751 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8007ef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8007f6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8007fd:	e9 c5 00 00 00       	jmp    8008c7 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800802:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800805:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80080c:	8b 45 08             	mov    0x8(%ebp),%eax
  80080f:	01 d0                	add    %edx,%eax
  800811:	8b 00                	mov    (%eax),%eax
  800813:	85 c0                	test   %eax,%eax
  800815:	75 08                	jne    80081f <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800817:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80081a:	e9 a5 00 00 00       	jmp    8008c4 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80081f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800826:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80082d:	eb 69                	jmp    800898 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80082f:	a1 24 50 80 00       	mov    0x805024,%eax
  800834:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  80083a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80083d:	89 d0                	mov    %edx,%eax
  80083f:	01 c0                	add    %eax,%eax
  800841:	01 d0                	add    %edx,%eax
  800843:	c1 e0 03             	shl    $0x3,%eax
  800846:	01 c8                	add    %ecx,%eax
  800848:	8a 40 04             	mov    0x4(%eax),%al
  80084b:	84 c0                	test   %al,%al
  80084d:	75 46                	jne    800895 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80084f:	a1 24 50 80 00       	mov    0x805024,%eax
  800854:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  80085a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80085d:	89 d0                	mov    %edx,%eax
  80085f:	01 c0                	add    %eax,%eax
  800861:	01 d0                	add    %edx,%eax
  800863:	c1 e0 03             	shl    $0x3,%eax
  800866:	01 c8                	add    %ecx,%eax
  800868:	8b 00                	mov    (%eax),%eax
  80086a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80086d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800870:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800875:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800877:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80087a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800881:	8b 45 08             	mov    0x8(%ebp),%eax
  800884:	01 c8                	add    %ecx,%eax
  800886:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800888:	39 c2                	cmp    %eax,%edx
  80088a:	75 09                	jne    800895 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80088c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800893:	eb 15                	jmp    8008aa <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800895:	ff 45 e8             	incl   -0x18(%ebp)
  800898:	a1 24 50 80 00       	mov    0x805024,%eax
  80089d:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8008a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008a6:	39 c2                	cmp    %eax,%edx
  8008a8:	77 85                	ja     80082f <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8008aa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8008ae:	75 14                	jne    8008c4 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8008b0:	83 ec 04             	sub    $0x4,%esp
  8008b3:	68 54 3f 80 00       	push   $0x803f54
  8008b8:	6a 3a                	push   $0x3a
  8008ba:	68 48 3f 80 00       	push   $0x803f48
  8008bf:	e8 8d fe ff ff       	call   800751 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8008c4:	ff 45 f0             	incl   -0x10(%ebp)
  8008c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008ca:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8008cd:	0f 8c 2f ff ff ff    	jl     800802 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8008d3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008da:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8008e1:	eb 26                	jmp    800909 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8008e3:	a1 24 50 80 00       	mov    0x805024,%eax
  8008e8:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8008ee:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008f1:	89 d0                	mov    %edx,%eax
  8008f3:	01 c0                	add    %eax,%eax
  8008f5:	01 d0                	add    %edx,%eax
  8008f7:	c1 e0 03             	shl    $0x3,%eax
  8008fa:	01 c8                	add    %ecx,%eax
  8008fc:	8a 40 04             	mov    0x4(%eax),%al
  8008ff:	3c 01                	cmp    $0x1,%al
  800901:	75 03                	jne    800906 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800903:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800906:	ff 45 e0             	incl   -0x20(%ebp)
  800909:	a1 24 50 80 00       	mov    0x805024,%eax
  80090e:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800914:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800917:	39 c2                	cmp    %eax,%edx
  800919:	77 c8                	ja     8008e3 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80091b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80091e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800921:	74 14                	je     800937 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800923:	83 ec 04             	sub    $0x4,%esp
  800926:	68 a8 3f 80 00       	push   $0x803fa8
  80092b:	6a 44                	push   $0x44
  80092d:	68 48 3f 80 00       	push   $0x803f48
  800932:	e8 1a fe ff ff       	call   800751 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800937:	90                   	nop
  800938:	c9                   	leave  
  800939:	c3                   	ret    

0080093a <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80093a:	55                   	push   %ebp
  80093b:	89 e5                	mov    %esp,%ebp
  80093d:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800940:	8b 45 0c             	mov    0xc(%ebp),%eax
  800943:	8b 00                	mov    (%eax),%eax
  800945:	8d 48 01             	lea    0x1(%eax),%ecx
  800948:	8b 55 0c             	mov    0xc(%ebp),%edx
  80094b:	89 0a                	mov    %ecx,(%edx)
  80094d:	8b 55 08             	mov    0x8(%ebp),%edx
  800950:	88 d1                	mov    %dl,%cl
  800952:	8b 55 0c             	mov    0xc(%ebp),%edx
  800955:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800959:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095c:	8b 00                	mov    (%eax),%eax
  80095e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800963:	75 2c                	jne    800991 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800965:	a0 44 50 98 00       	mov    0x985044,%al
  80096a:	0f b6 c0             	movzbl %al,%eax
  80096d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800970:	8b 12                	mov    (%edx),%edx
  800972:	89 d1                	mov    %edx,%ecx
  800974:	8b 55 0c             	mov    0xc(%ebp),%edx
  800977:	83 c2 08             	add    $0x8,%edx
  80097a:	83 ec 04             	sub    $0x4,%esp
  80097d:	50                   	push   %eax
  80097e:	51                   	push   %ecx
  80097f:	52                   	push   %edx
  800980:	e8 21 17 00 00       	call   8020a6 <sys_cputs>
  800985:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800988:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800991:	8b 45 0c             	mov    0xc(%ebp),%eax
  800994:	8b 40 04             	mov    0x4(%eax),%eax
  800997:	8d 50 01             	lea    0x1(%eax),%edx
  80099a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80099d:	89 50 04             	mov    %edx,0x4(%eax)
}
  8009a0:	90                   	nop
  8009a1:	c9                   	leave  
  8009a2:	c3                   	ret    

008009a3 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8009a3:	55                   	push   %ebp
  8009a4:	89 e5                	mov    %esp,%ebp
  8009a6:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8009ac:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009b3:	00 00 00 
	b.cnt = 0;
  8009b6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009bd:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8009c0:	ff 75 0c             	pushl  0xc(%ebp)
  8009c3:	ff 75 08             	pushl  0x8(%ebp)
  8009c6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009cc:	50                   	push   %eax
  8009cd:	68 3a 09 80 00       	push   $0x80093a
  8009d2:	e8 11 02 00 00       	call   800be8 <vprintfmt>
  8009d7:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8009da:	a0 44 50 98 00       	mov    0x985044,%al
  8009df:	0f b6 c0             	movzbl %al,%eax
  8009e2:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8009e8:	83 ec 04             	sub    $0x4,%esp
  8009eb:	50                   	push   %eax
  8009ec:	52                   	push   %edx
  8009ed:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009f3:	83 c0 08             	add    $0x8,%eax
  8009f6:	50                   	push   %eax
  8009f7:	e8 aa 16 00 00       	call   8020a6 <sys_cputs>
  8009fc:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8009ff:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
	return b.cnt;
  800a06:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a0c:	c9                   	leave  
  800a0d:	c3                   	ret    

00800a0e <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800a0e:	55                   	push   %ebp
  800a0f:	89 e5                	mov    %esp,%ebp
  800a11:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a14:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
	va_start(ap, fmt);
  800a1b:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a21:	8b 45 08             	mov    0x8(%ebp),%eax
  800a24:	83 ec 08             	sub    $0x8,%esp
  800a27:	ff 75 f4             	pushl  -0xc(%ebp)
  800a2a:	50                   	push   %eax
  800a2b:	e8 73 ff ff ff       	call   8009a3 <vcprintf>
  800a30:	83 c4 10             	add    $0x10,%esp
  800a33:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a36:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a39:	c9                   	leave  
  800a3a:	c3                   	ret    

00800a3b <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800a3b:	55                   	push   %ebp
  800a3c:	89 e5                	mov    %esp,%ebp
  800a3e:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800a41:	e8 a2 16 00 00       	call   8020e8 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800a46:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a49:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4f:	83 ec 08             	sub    $0x8,%esp
  800a52:	ff 75 f4             	pushl  -0xc(%ebp)
  800a55:	50                   	push   %eax
  800a56:	e8 48 ff ff ff       	call   8009a3 <vcprintf>
  800a5b:	83 c4 10             	add    $0x10,%esp
  800a5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800a61:	e8 9c 16 00 00       	call   802102 <sys_unlock_cons>
	return cnt;
  800a66:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a69:	c9                   	leave  
  800a6a:	c3                   	ret    

00800a6b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a6b:	55                   	push   %ebp
  800a6c:	89 e5                	mov    %esp,%ebp
  800a6e:	53                   	push   %ebx
  800a6f:	83 ec 14             	sub    $0x14,%esp
  800a72:	8b 45 10             	mov    0x10(%ebp),%eax
  800a75:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a78:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a7e:	8b 45 18             	mov    0x18(%ebp),%eax
  800a81:	ba 00 00 00 00       	mov    $0x0,%edx
  800a86:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a89:	77 55                	ja     800ae0 <printnum+0x75>
  800a8b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a8e:	72 05                	jb     800a95 <printnum+0x2a>
  800a90:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a93:	77 4b                	ja     800ae0 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a95:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a98:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a9b:	8b 45 18             	mov    0x18(%ebp),%eax
  800a9e:	ba 00 00 00 00       	mov    $0x0,%edx
  800aa3:	52                   	push   %edx
  800aa4:	50                   	push   %eax
  800aa5:	ff 75 f4             	pushl  -0xc(%ebp)
  800aa8:	ff 75 f0             	pushl  -0x10(%ebp)
  800aab:	e8 f8 2e 00 00       	call   8039a8 <__udivdi3>
  800ab0:	83 c4 10             	add    $0x10,%esp
  800ab3:	83 ec 04             	sub    $0x4,%esp
  800ab6:	ff 75 20             	pushl  0x20(%ebp)
  800ab9:	53                   	push   %ebx
  800aba:	ff 75 18             	pushl  0x18(%ebp)
  800abd:	52                   	push   %edx
  800abe:	50                   	push   %eax
  800abf:	ff 75 0c             	pushl  0xc(%ebp)
  800ac2:	ff 75 08             	pushl  0x8(%ebp)
  800ac5:	e8 a1 ff ff ff       	call   800a6b <printnum>
  800aca:	83 c4 20             	add    $0x20,%esp
  800acd:	eb 1a                	jmp    800ae9 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800acf:	83 ec 08             	sub    $0x8,%esp
  800ad2:	ff 75 0c             	pushl  0xc(%ebp)
  800ad5:	ff 75 20             	pushl  0x20(%ebp)
  800ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  800adb:	ff d0                	call   *%eax
  800add:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800ae0:	ff 4d 1c             	decl   0x1c(%ebp)
  800ae3:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800ae7:	7f e6                	jg     800acf <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800ae9:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800aec:	bb 00 00 00 00       	mov    $0x0,%ebx
  800af1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800af4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800af7:	53                   	push   %ebx
  800af8:	51                   	push   %ecx
  800af9:	52                   	push   %edx
  800afa:	50                   	push   %eax
  800afb:	e8 b8 2f 00 00       	call   803ab8 <__umoddi3>
  800b00:	83 c4 10             	add    $0x10,%esp
  800b03:	05 14 42 80 00       	add    $0x804214,%eax
  800b08:	8a 00                	mov    (%eax),%al
  800b0a:	0f be c0             	movsbl %al,%eax
  800b0d:	83 ec 08             	sub    $0x8,%esp
  800b10:	ff 75 0c             	pushl  0xc(%ebp)
  800b13:	50                   	push   %eax
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	ff d0                	call   *%eax
  800b19:	83 c4 10             	add    $0x10,%esp
}
  800b1c:	90                   	nop
  800b1d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b20:	c9                   	leave  
  800b21:	c3                   	ret    

00800b22 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b22:	55                   	push   %ebp
  800b23:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b25:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b29:	7e 1c                	jle    800b47 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2e:	8b 00                	mov    (%eax),%eax
  800b30:	8d 50 08             	lea    0x8(%eax),%edx
  800b33:	8b 45 08             	mov    0x8(%ebp),%eax
  800b36:	89 10                	mov    %edx,(%eax)
  800b38:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3b:	8b 00                	mov    (%eax),%eax
  800b3d:	83 e8 08             	sub    $0x8,%eax
  800b40:	8b 50 04             	mov    0x4(%eax),%edx
  800b43:	8b 00                	mov    (%eax),%eax
  800b45:	eb 40                	jmp    800b87 <getuint+0x65>
	else if (lflag)
  800b47:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b4b:	74 1e                	je     800b6b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b50:	8b 00                	mov    (%eax),%eax
  800b52:	8d 50 04             	lea    0x4(%eax),%edx
  800b55:	8b 45 08             	mov    0x8(%ebp),%eax
  800b58:	89 10                	mov    %edx,(%eax)
  800b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5d:	8b 00                	mov    (%eax),%eax
  800b5f:	83 e8 04             	sub    $0x4,%eax
  800b62:	8b 00                	mov    (%eax),%eax
  800b64:	ba 00 00 00 00       	mov    $0x0,%edx
  800b69:	eb 1c                	jmp    800b87 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6e:	8b 00                	mov    (%eax),%eax
  800b70:	8d 50 04             	lea    0x4(%eax),%edx
  800b73:	8b 45 08             	mov    0x8(%ebp),%eax
  800b76:	89 10                	mov    %edx,(%eax)
  800b78:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7b:	8b 00                	mov    (%eax),%eax
  800b7d:	83 e8 04             	sub    $0x4,%eax
  800b80:	8b 00                	mov    (%eax),%eax
  800b82:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b87:	5d                   	pop    %ebp
  800b88:	c3                   	ret    

00800b89 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b89:	55                   	push   %ebp
  800b8a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b8c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b90:	7e 1c                	jle    800bae <getint+0x25>
		return va_arg(*ap, long long);
  800b92:	8b 45 08             	mov    0x8(%ebp),%eax
  800b95:	8b 00                	mov    (%eax),%eax
  800b97:	8d 50 08             	lea    0x8(%eax),%edx
  800b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9d:	89 10                	mov    %edx,(%eax)
  800b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba2:	8b 00                	mov    (%eax),%eax
  800ba4:	83 e8 08             	sub    $0x8,%eax
  800ba7:	8b 50 04             	mov    0x4(%eax),%edx
  800baa:	8b 00                	mov    (%eax),%eax
  800bac:	eb 38                	jmp    800be6 <getint+0x5d>
	else if (lflag)
  800bae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bb2:	74 1a                	je     800bce <getint+0x45>
		return va_arg(*ap, long);
  800bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb7:	8b 00                	mov    (%eax),%eax
  800bb9:	8d 50 04             	lea    0x4(%eax),%edx
  800bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbf:	89 10                	mov    %edx,(%eax)
  800bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc4:	8b 00                	mov    (%eax),%eax
  800bc6:	83 e8 04             	sub    $0x4,%eax
  800bc9:	8b 00                	mov    (%eax),%eax
  800bcb:	99                   	cltd   
  800bcc:	eb 18                	jmp    800be6 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800bce:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd1:	8b 00                	mov    (%eax),%eax
  800bd3:	8d 50 04             	lea    0x4(%eax),%edx
  800bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd9:	89 10                	mov    %edx,(%eax)
  800bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bde:	8b 00                	mov    (%eax),%eax
  800be0:	83 e8 04             	sub    $0x4,%eax
  800be3:	8b 00                	mov    (%eax),%eax
  800be5:	99                   	cltd   
}
  800be6:	5d                   	pop    %ebp
  800be7:	c3                   	ret    

00800be8 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800be8:	55                   	push   %ebp
  800be9:	89 e5                	mov    %esp,%ebp
  800beb:	56                   	push   %esi
  800bec:	53                   	push   %ebx
  800bed:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bf0:	eb 17                	jmp    800c09 <vprintfmt+0x21>
			if (ch == '\0')
  800bf2:	85 db                	test   %ebx,%ebx
  800bf4:	0f 84 c1 03 00 00    	je     800fbb <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800bfa:	83 ec 08             	sub    $0x8,%esp
  800bfd:	ff 75 0c             	pushl  0xc(%ebp)
  800c00:	53                   	push   %ebx
  800c01:	8b 45 08             	mov    0x8(%ebp),%eax
  800c04:	ff d0                	call   *%eax
  800c06:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c09:	8b 45 10             	mov    0x10(%ebp),%eax
  800c0c:	8d 50 01             	lea    0x1(%eax),%edx
  800c0f:	89 55 10             	mov    %edx,0x10(%ebp)
  800c12:	8a 00                	mov    (%eax),%al
  800c14:	0f b6 d8             	movzbl %al,%ebx
  800c17:	83 fb 25             	cmp    $0x25,%ebx
  800c1a:	75 d6                	jne    800bf2 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c1c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c20:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c27:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c2e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c35:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c3c:	8b 45 10             	mov    0x10(%ebp),%eax
  800c3f:	8d 50 01             	lea    0x1(%eax),%edx
  800c42:	89 55 10             	mov    %edx,0x10(%ebp)
  800c45:	8a 00                	mov    (%eax),%al
  800c47:	0f b6 d8             	movzbl %al,%ebx
  800c4a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c4d:	83 f8 5b             	cmp    $0x5b,%eax
  800c50:	0f 87 3d 03 00 00    	ja     800f93 <vprintfmt+0x3ab>
  800c56:	8b 04 85 38 42 80 00 	mov    0x804238(,%eax,4),%eax
  800c5d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c5f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c63:	eb d7                	jmp    800c3c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c65:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c69:	eb d1                	jmp    800c3c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c6b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c72:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c75:	89 d0                	mov    %edx,%eax
  800c77:	c1 e0 02             	shl    $0x2,%eax
  800c7a:	01 d0                	add    %edx,%eax
  800c7c:	01 c0                	add    %eax,%eax
  800c7e:	01 d8                	add    %ebx,%eax
  800c80:	83 e8 30             	sub    $0x30,%eax
  800c83:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c86:	8b 45 10             	mov    0x10(%ebp),%eax
  800c89:	8a 00                	mov    (%eax),%al
  800c8b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c8e:	83 fb 2f             	cmp    $0x2f,%ebx
  800c91:	7e 3e                	jle    800cd1 <vprintfmt+0xe9>
  800c93:	83 fb 39             	cmp    $0x39,%ebx
  800c96:	7f 39                	jg     800cd1 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c98:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c9b:	eb d5                	jmp    800c72 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c9d:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca0:	83 c0 04             	add    $0x4,%eax
  800ca3:	89 45 14             	mov    %eax,0x14(%ebp)
  800ca6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca9:	83 e8 04             	sub    $0x4,%eax
  800cac:	8b 00                	mov    (%eax),%eax
  800cae:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800cb1:	eb 1f                	jmp    800cd2 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800cb3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cb7:	79 83                	jns    800c3c <vprintfmt+0x54>
				width = 0;
  800cb9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800cc0:	e9 77 ff ff ff       	jmp    800c3c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800cc5:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800ccc:	e9 6b ff ff ff       	jmp    800c3c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800cd1:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800cd2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cd6:	0f 89 60 ff ff ff    	jns    800c3c <vprintfmt+0x54>
				width = precision, precision = -1;
  800cdc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cdf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ce2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800ce9:	e9 4e ff ff ff       	jmp    800c3c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800cee:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800cf1:	e9 46 ff ff ff       	jmp    800c3c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800cf6:	8b 45 14             	mov    0x14(%ebp),%eax
  800cf9:	83 c0 04             	add    $0x4,%eax
  800cfc:	89 45 14             	mov    %eax,0x14(%ebp)
  800cff:	8b 45 14             	mov    0x14(%ebp),%eax
  800d02:	83 e8 04             	sub    $0x4,%eax
  800d05:	8b 00                	mov    (%eax),%eax
  800d07:	83 ec 08             	sub    $0x8,%esp
  800d0a:	ff 75 0c             	pushl  0xc(%ebp)
  800d0d:	50                   	push   %eax
  800d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d11:	ff d0                	call   *%eax
  800d13:	83 c4 10             	add    $0x10,%esp
			break;
  800d16:	e9 9b 02 00 00       	jmp    800fb6 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d1b:	8b 45 14             	mov    0x14(%ebp),%eax
  800d1e:	83 c0 04             	add    $0x4,%eax
  800d21:	89 45 14             	mov    %eax,0x14(%ebp)
  800d24:	8b 45 14             	mov    0x14(%ebp),%eax
  800d27:	83 e8 04             	sub    $0x4,%eax
  800d2a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d2c:	85 db                	test   %ebx,%ebx
  800d2e:	79 02                	jns    800d32 <vprintfmt+0x14a>
				err = -err;
  800d30:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d32:	83 fb 64             	cmp    $0x64,%ebx
  800d35:	7f 0b                	jg     800d42 <vprintfmt+0x15a>
  800d37:	8b 34 9d 80 40 80 00 	mov    0x804080(,%ebx,4),%esi
  800d3e:	85 f6                	test   %esi,%esi
  800d40:	75 19                	jne    800d5b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d42:	53                   	push   %ebx
  800d43:	68 25 42 80 00       	push   $0x804225
  800d48:	ff 75 0c             	pushl  0xc(%ebp)
  800d4b:	ff 75 08             	pushl  0x8(%ebp)
  800d4e:	e8 70 02 00 00       	call   800fc3 <printfmt>
  800d53:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d56:	e9 5b 02 00 00       	jmp    800fb6 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d5b:	56                   	push   %esi
  800d5c:	68 2e 42 80 00       	push   $0x80422e
  800d61:	ff 75 0c             	pushl  0xc(%ebp)
  800d64:	ff 75 08             	pushl  0x8(%ebp)
  800d67:	e8 57 02 00 00       	call   800fc3 <printfmt>
  800d6c:	83 c4 10             	add    $0x10,%esp
			break;
  800d6f:	e9 42 02 00 00       	jmp    800fb6 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d74:	8b 45 14             	mov    0x14(%ebp),%eax
  800d77:	83 c0 04             	add    $0x4,%eax
  800d7a:	89 45 14             	mov    %eax,0x14(%ebp)
  800d7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d80:	83 e8 04             	sub    $0x4,%eax
  800d83:	8b 30                	mov    (%eax),%esi
  800d85:	85 f6                	test   %esi,%esi
  800d87:	75 05                	jne    800d8e <vprintfmt+0x1a6>
				p = "(null)";
  800d89:	be 31 42 80 00       	mov    $0x804231,%esi
			if (width > 0 && padc != '-')
  800d8e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d92:	7e 6d                	jle    800e01 <vprintfmt+0x219>
  800d94:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d98:	74 67                	je     800e01 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d9a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d9d:	83 ec 08             	sub    $0x8,%esp
  800da0:	50                   	push   %eax
  800da1:	56                   	push   %esi
  800da2:	e8 26 05 00 00       	call   8012cd <strnlen>
  800da7:	83 c4 10             	add    $0x10,%esp
  800daa:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800dad:	eb 16                	jmp    800dc5 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800daf:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800db3:	83 ec 08             	sub    $0x8,%esp
  800db6:	ff 75 0c             	pushl  0xc(%ebp)
  800db9:	50                   	push   %eax
  800dba:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbd:	ff d0                	call   *%eax
  800dbf:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800dc2:	ff 4d e4             	decl   -0x1c(%ebp)
  800dc5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dc9:	7f e4                	jg     800daf <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dcb:	eb 34                	jmp    800e01 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800dcd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800dd1:	74 1c                	je     800def <vprintfmt+0x207>
  800dd3:	83 fb 1f             	cmp    $0x1f,%ebx
  800dd6:	7e 05                	jle    800ddd <vprintfmt+0x1f5>
  800dd8:	83 fb 7e             	cmp    $0x7e,%ebx
  800ddb:	7e 12                	jle    800def <vprintfmt+0x207>
					putch('?', putdat);
  800ddd:	83 ec 08             	sub    $0x8,%esp
  800de0:	ff 75 0c             	pushl  0xc(%ebp)
  800de3:	6a 3f                	push   $0x3f
  800de5:	8b 45 08             	mov    0x8(%ebp),%eax
  800de8:	ff d0                	call   *%eax
  800dea:	83 c4 10             	add    $0x10,%esp
  800ded:	eb 0f                	jmp    800dfe <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800def:	83 ec 08             	sub    $0x8,%esp
  800df2:	ff 75 0c             	pushl  0xc(%ebp)
  800df5:	53                   	push   %ebx
  800df6:	8b 45 08             	mov    0x8(%ebp),%eax
  800df9:	ff d0                	call   *%eax
  800dfb:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dfe:	ff 4d e4             	decl   -0x1c(%ebp)
  800e01:	89 f0                	mov    %esi,%eax
  800e03:	8d 70 01             	lea    0x1(%eax),%esi
  800e06:	8a 00                	mov    (%eax),%al
  800e08:	0f be d8             	movsbl %al,%ebx
  800e0b:	85 db                	test   %ebx,%ebx
  800e0d:	74 24                	je     800e33 <vprintfmt+0x24b>
  800e0f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e13:	78 b8                	js     800dcd <vprintfmt+0x1e5>
  800e15:	ff 4d e0             	decl   -0x20(%ebp)
  800e18:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e1c:	79 af                	jns    800dcd <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e1e:	eb 13                	jmp    800e33 <vprintfmt+0x24b>
				putch(' ', putdat);
  800e20:	83 ec 08             	sub    $0x8,%esp
  800e23:	ff 75 0c             	pushl  0xc(%ebp)
  800e26:	6a 20                	push   $0x20
  800e28:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2b:	ff d0                	call   *%eax
  800e2d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e30:	ff 4d e4             	decl   -0x1c(%ebp)
  800e33:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e37:	7f e7                	jg     800e20 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e39:	e9 78 01 00 00       	jmp    800fb6 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e3e:	83 ec 08             	sub    $0x8,%esp
  800e41:	ff 75 e8             	pushl  -0x18(%ebp)
  800e44:	8d 45 14             	lea    0x14(%ebp),%eax
  800e47:	50                   	push   %eax
  800e48:	e8 3c fd ff ff       	call   800b89 <getint>
  800e4d:	83 c4 10             	add    $0x10,%esp
  800e50:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e53:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e59:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e5c:	85 d2                	test   %edx,%edx
  800e5e:	79 23                	jns    800e83 <vprintfmt+0x29b>
				putch('-', putdat);
  800e60:	83 ec 08             	sub    $0x8,%esp
  800e63:	ff 75 0c             	pushl  0xc(%ebp)
  800e66:	6a 2d                	push   $0x2d
  800e68:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6b:	ff d0                	call   *%eax
  800e6d:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e73:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e76:	f7 d8                	neg    %eax
  800e78:	83 d2 00             	adc    $0x0,%edx
  800e7b:	f7 da                	neg    %edx
  800e7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e80:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e83:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e8a:	e9 bc 00 00 00       	jmp    800f4b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e8f:	83 ec 08             	sub    $0x8,%esp
  800e92:	ff 75 e8             	pushl  -0x18(%ebp)
  800e95:	8d 45 14             	lea    0x14(%ebp),%eax
  800e98:	50                   	push   %eax
  800e99:	e8 84 fc ff ff       	call   800b22 <getuint>
  800e9e:	83 c4 10             	add    $0x10,%esp
  800ea1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ea4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ea7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800eae:	e9 98 00 00 00       	jmp    800f4b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800eb3:	83 ec 08             	sub    $0x8,%esp
  800eb6:	ff 75 0c             	pushl  0xc(%ebp)
  800eb9:	6a 58                	push   $0x58
  800ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebe:	ff d0                	call   *%eax
  800ec0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ec3:	83 ec 08             	sub    $0x8,%esp
  800ec6:	ff 75 0c             	pushl  0xc(%ebp)
  800ec9:	6a 58                	push   $0x58
  800ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ece:	ff d0                	call   *%eax
  800ed0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ed3:	83 ec 08             	sub    $0x8,%esp
  800ed6:	ff 75 0c             	pushl  0xc(%ebp)
  800ed9:	6a 58                	push   $0x58
  800edb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ede:	ff d0                	call   *%eax
  800ee0:	83 c4 10             	add    $0x10,%esp
			break;
  800ee3:	e9 ce 00 00 00       	jmp    800fb6 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800ee8:	83 ec 08             	sub    $0x8,%esp
  800eeb:	ff 75 0c             	pushl  0xc(%ebp)
  800eee:	6a 30                	push   $0x30
  800ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef3:	ff d0                	call   *%eax
  800ef5:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ef8:	83 ec 08             	sub    $0x8,%esp
  800efb:	ff 75 0c             	pushl  0xc(%ebp)
  800efe:	6a 78                	push   $0x78
  800f00:	8b 45 08             	mov    0x8(%ebp),%eax
  800f03:	ff d0                	call   *%eax
  800f05:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f08:	8b 45 14             	mov    0x14(%ebp),%eax
  800f0b:	83 c0 04             	add    $0x4,%eax
  800f0e:	89 45 14             	mov    %eax,0x14(%ebp)
  800f11:	8b 45 14             	mov    0x14(%ebp),%eax
  800f14:	83 e8 04             	sub    $0x4,%eax
  800f17:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f19:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f1c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f23:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f2a:	eb 1f                	jmp    800f4b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f2c:	83 ec 08             	sub    $0x8,%esp
  800f2f:	ff 75 e8             	pushl  -0x18(%ebp)
  800f32:	8d 45 14             	lea    0x14(%ebp),%eax
  800f35:	50                   	push   %eax
  800f36:	e8 e7 fb ff ff       	call   800b22 <getuint>
  800f3b:	83 c4 10             	add    $0x10,%esp
  800f3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f41:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f44:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f4b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f52:	83 ec 04             	sub    $0x4,%esp
  800f55:	52                   	push   %edx
  800f56:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f59:	50                   	push   %eax
  800f5a:	ff 75 f4             	pushl  -0xc(%ebp)
  800f5d:	ff 75 f0             	pushl  -0x10(%ebp)
  800f60:	ff 75 0c             	pushl  0xc(%ebp)
  800f63:	ff 75 08             	pushl  0x8(%ebp)
  800f66:	e8 00 fb ff ff       	call   800a6b <printnum>
  800f6b:	83 c4 20             	add    $0x20,%esp
			break;
  800f6e:	eb 46                	jmp    800fb6 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f70:	83 ec 08             	sub    $0x8,%esp
  800f73:	ff 75 0c             	pushl  0xc(%ebp)
  800f76:	53                   	push   %ebx
  800f77:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7a:	ff d0                	call   *%eax
  800f7c:	83 c4 10             	add    $0x10,%esp
			break;
  800f7f:	eb 35                	jmp    800fb6 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800f81:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
			break;
  800f88:	eb 2c                	jmp    800fb6 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800f8a:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
			break;
  800f91:	eb 23                	jmp    800fb6 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f93:	83 ec 08             	sub    $0x8,%esp
  800f96:	ff 75 0c             	pushl  0xc(%ebp)
  800f99:	6a 25                	push   $0x25
  800f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9e:	ff d0                	call   *%eax
  800fa0:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800fa3:	ff 4d 10             	decl   0x10(%ebp)
  800fa6:	eb 03                	jmp    800fab <vprintfmt+0x3c3>
  800fa8:	ff 4d 10             	decl   0x10(%ebp)
  800fab:	8b 45 10             	mov    0x10(%ebp),%eax
  800fae:	48                   	dec    %eax
  800faf:	8a 00                	mov    (%eax),%al
  800fb1:	3c 25                	cmp    $0x25,%al
  800fb3:	75 f3                	jne    800fa8 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800fb5:	90                   	nop
		}
	}
  800fb6:	e9 35 fc ff ff       	jmp    800bf0 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800fbb:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800fbc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fbf:	5b                   	pop    %ebx
  800fc0:	5e                   	pop    %esi
  800fc1:	5d                   	pop    %ebp
  800fc2:	c3                   	ret    

00800fc3 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800fc3:	55                   	push   %ebp
  800fc4:	89 e5                	mov    %esp,%ebp
  800fc6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800fc9:	8d 45 10             	lea    0x10(%ebp),%eax
  800fcc:	83 c0 04             	add    $0x4,%eax
  800fcf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800fd2:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd5:	ff 75 f4             	pushl  -0xc(%ebp)
  800fd8:	50                   	push   %eax
  800fd9:	ff 75 0c             	pushl  0xc(%ebp)
  800fdc:	ff 75 08             	pushl  0x8(%ebp)
  800fdf:	e8 04 fc ff ff       	call   800be8 <vprintfmt>
  800fe4:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800fe7:	90                   	nop
  800fe8:	c9                   	leave  
  800fe9:	c3                   	ret    

00800fea <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fea:	55                   	push   %ebp
  800feb:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800fed:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff0:	8b 40 08             	mov    0x8(%eax),%eax
  800ff3:	8d 50 01             	lea    0x1(%eax),%edx
  800ff6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff9:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fff:	8b 10                	mov    (%eax),%edx
  801001:	8b 45 0c             	mov    0xc(%ebp),%eax
  801004:	8b 40 04             	mov    0x4(%eax),%eax
  801007:	39 c2                	cmp    %eax,%edx
  801009:	73 12                	jae    80101d <sprintputch+0x33>
		*b->buf++ = ch;
  80100b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100e:	8b 00                	mov    (%eax),%eax
  801010:	8d 48 01             	lea    0x1(%eax),%ecx
  801013:	8b 55 0c             	mov    0xc(%ebp),%edx
  801016:	89 0a                	mov    %ecx,(%edx)
  801018:	8b 55 08             	mov    0x8(%ebp),%edx
  80101b:	88 10                	mov    %dl,(%eax)
}
  80101d:	90                   	nop
  80101e:	5d                   	pop    %ebp
  80101f:	c3                   	ret    

00801020 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801020:	55                   	push   %ebp
  801021:	89 e5                	mov    %esp,%ebp
  801023:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801026:	8b 45 08             	mov    0x8(%ebp),%eax
  801029:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80102c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801032:	8b 45 08             	mov    0x8(%ebp),%eax
  801035:	01 d0                	add    %edx,%eax
  801037:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80103a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801041:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801045:	74 06                	je     80104d <vsnprintf+0x2d>
  801047:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80104b:	7f 07                	jg     801054 <vsnprintf+0x34>
		return -E_INVAL;
  80104d:	b8 03 00 00 00       	mov    $0x3,%eax
  801052:	eb 20                	jmp    801074 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801054:	ff 75 14             	pushl  0x14(%ebp)
  801057:	ff 75 10             	pushl  0x10(%ebp)
  80105a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80105d:	50                   	push   %eax
  80105e:	68 ea 0f 80 00       	push   $0x800fea
  801063:	e8 80 fb ff ff       	call   800be8 <vprintfmt>
  801068:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80106b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80106e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801071:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801074:	c9                   	leave  
  801075:	c3                   	ret    

00801076 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801076:	55                   	push   %ebp
  801077:	89 e5                	mov    %esp,%ebp
  801079:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80107c:	8d 45 10             	lea    0x10(%ebp),%eax
  80107f:	83 c0 04             	add    $0x4,%eax
  801082:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801085:	8b 45 10             	mov    0x10(%ebp),%eax
  801088:	ff 75 f4             	pushl  -0xc(%ebp)
  80108b:	50                   	push   %eax
  80108c:	ff 75 0c             	pushl  0xc(%ebp)
  80108f:	ff 75 08             	pushl  0x8(%ebp)
  801092:	e8 89 ff ff ff       	call   801020 <vsnprintf>
  801097:	83 c4 10             	add    $0x10,%esp
  80109a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80109d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010a0:	c9                   	leave  
  8010a1:	c3                   	ret    

008010a2 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8010a2:	55                   	push   %ebp
  8010a3:	89 e5                	mov    %esp,%ebp
  8010a5:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  8010a8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010ac:	74 13                	je     8010c1 <readline+0x1f>
		cprintf("%s", prompt);
  8010ae:	83 ec 08             	sub    $0x8,%esp
  8010b1:	ff 75 08             	pushl  0x8(%ebp)
  8010b4:	68 a8 43 80 00       	push   $0x8043a8
  8010b9:	e8 50 f9 ff ff       	call   800a0e <cprintf>
  8010be:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8010c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8010c8:	83 ec 0c             	sub    $0xc,%esp
  8010cb:	6a 00                	push   $0x0
  8010cd:	e8 30 f5 ff ff       	call   800602 <iscons>
  8010d2:	83 c4 10             	add    $0x10,%esp
  8010d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8010d8:	e8 12 f5 ff ff       	call   8005ef <getchar>
  8010dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8010e0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8010e4:	79 22                	jns    801108 <readline+0x66>
			if (c != -E_EOF)
  8010e6:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8010ea:	0f 84 ad 00 00 00    	je     80119d <readline+0xfb>
				cprintf("read error: %e\n", c);
  8010f0:	83 ec 08             	sub    $0x8,%esp
  8010f3:	ff 75 ec             	pushl  -0x14(%ebp)
  8010f6:	68 ab 43 80 00       	push   $0x8043ab
  8010fb:	e8 0e f9 ff ff       	call   800a0e <cprintf>
  801100:	83 c4 10             	add    $0x10,%esp
			break;
  801103:	e9 95 00 00 00       	jmp    80119d <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801108:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  80110c:	7e 34                	jle    801142 <readline+0xa0>
  80110e:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801115:	7f 2b                	jg     801142 <readline+0xa0>
			if (echoing)
  801117:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80111b:	74 0e                	je     80112b <readline+0x89>
				cputchar(c);
  80111d:	83 ec 0c             	sub    $0xc,%esp
  801120:	ff 75 ec             	pushl  -0x14(%ebp)
  801123:	e8 a8 f4 ff ff       	call   8005d0 <cputchar>
  801128:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  80112b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80112e:	8d 50 01             	lea    0x1(%eax),%edx
  801131:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801134:	89 c2                	mov    %eax,%edx
  801136:	8b 45 0c             	mov    0xc(%ebp),%eax
  801139:	01 d0                	add    %edx,%eax
  80113b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80113e:	88 10                	mov    %dl,(%eax)
  801140:	eb 56                	jmp    801198 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801142:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801146:	75 1f                	jne    801167 <readline+0xc5>
  801148:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80114c:	7e 19                	jle    801167 <readline+0xc5>
			if (echoing)
  80114e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801152:	74 0e                	je     801162 <readline+0xc0>
				cputchar(c);
  801154:	83 ec 0c             	sub    $0xc,%esp
  801157:	ff 75 ec             	pushl  -0x14(%ebp)
  80115a:	e8 71 f4 ff ff       	call   8005d0 <cputchar>
  80115f:	83 c4 10             	add    $0x10,%esp

			i--;
  801162:	ff 4d f4             	decl   -0xc(%ebp)
  801165:	eb 31                	jmp    801198 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801167:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80116b:	74 0a                	je     801177 <readline+0xd5>
  80116d:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801171:	0f 85 61 ff ff ff    	jne    8010d8 <readline+0x36>
			if (echoing)
  801177:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80117b:	74 0e                	je     80118b <readline+0xe9>
				cputchar(c);
  80117d:	83 ec 0c             	sub    $0xc,%esp
  801180:	ff 75 ec             	pushl  -0x14(%ebp)
  801183:	e8 48 f4 ff ff       	call   8005d0 <cputchar>
  801188:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  80118b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80118e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801191:	01 d0                	add    %edx,%eax
  801193:	c6 00 00             	movb   $0x0,(%eax)
			break;
  801196:	eb 06                	jmp    80119e <readline+0xfc>
		}
	}
  801198:	e9 3b ff ff ff       	jmp    8010d8 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  80119d:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  80119e:	90                   	nop
  80119f:	c9                   	leave  
  8011a0:	c3                   	ret    

008011a1 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8011a1:	55                   	push   %ebp
  8011a2:	89 e5                	mov    %esp,%ebp
  8011a4:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  8011a7:	e8 3c 0f 00 00       	call   8020e8 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  8011ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011b0:	74 13                	je     8011c5 <atomic_readline+0x24>
			cprintf("%s", prompt);
  8011b2:	83 ec 08             	sub    $0x8,%esp
  8011b5:	ff 75 08             	pushl  0x8(%ebp)
  8011b8:	68 a8 43 80 00       	push   $0x8043a8
  8011bd:	e8 4c f8 ff ff       	call   800a0e <cprintf>
  8011c2:	83 c4 10             	add    $0x10,%esp

		i = 0;
  8011c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  8011cc:	83 ec 0c             	sub    $0xc,%esp
  8011cf:	6a 00                	push   $0x0
  8011d1:	e8 2c f4 ff ff       	call   800602 <iscons>
  8011d6:	83 c4 10             	add    $0x10,%esp
  8011d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  8011dc:	e8 0e f4 ff ff       	call   8005ef <getchar>
  8011e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  8011e4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8011e8:	79 22                	jns    80120c <atomic_readline+0x6b>
				if (c != -E_EOF)
  8011ea:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8011ee:	0f 84 ad 00 00 00    	je     8012a1 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  8011f4:	83 ec 08             	sub    $0x8,%esp
  8011f7:	ff 75 ec             	pushl  -0x14(%ebp)
  8011fa:	68 ab 43 80 00       	push   $0x8043ab
  8011ff:	e8 0a f8 ff ff       	call   800a0e <cprintf>
  801204:	83 c4 10             	add    $0x10,%esp
				break;
  801207:	e9 95 00 00 00       	jmp    8012a1 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  80120c:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801210:	7e 34                	jle    801246 <atomic_readline+0xa5>
  801212:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801219:	7f 2b                	jg     801246 <atomic_readline+0xa5>
				if (echoing)
  80121b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80121f:	74 0e                	je     80122f <atomic_readline+0x8e>
					cputchar(c);
  801221:	83 ec 0c             	sub    $0xc,%esp
  801224:	ff 75 ec             	pushl  -0x14(%ebp)
  801227:	e8 a4 f3 ff ff       	call   8005d0 <cputchar>
  80122c:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  80122f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801232:	8d 50 01             	lea    0x1(%eax),%edx
  801235:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801238:	89 c2                	mov    %eax,%edx
  80123a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123d:	01 d0                	add    %edx,%eax
  80123f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801242:	88 10                	mov    %dl,(%eax)
  801244:	eb 56                	jmp    80129c <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  801246:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80124a:	75 1f                	jne    80126b <atomic_readline+0xca>
  80124c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801250:	7e 19                	jle    80126b <atomic_readline+0xca>
				if (echoing)
  801252:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801256:	74 0e                	je     801266 <atomic_readline+0xc5>
					cputchar(c);
  801258:	83 ec 0c             	sub    $0xc,%esp
  80125b:	ff 75 ec             	pushl  -0x14(%ebp)
  80125e:	e8 6d f3 ff ff       	call   8005d0 <cputchar>
  801263:	83 c4 10             	add    $0x10,%esp
				i--;
  801266:	ff 4d f4             	decl   -0xc(%ebp)
  801269:	eb 31                	jmp    80129c <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  80126b:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80126f:	74 0a                	je     80127b <atomic_readline+0xda>
  801271:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801275:	0f 85 61 ff ff ff    	jne    8011dc <atomic_readline+0x3b>
				if (echoing)
  80127b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80127f:	74 0e                	je     80128f <atomic_readline+0xee>
					cputchar(c);
  801281:	83 ec 0c             	sub    $0xc,%esp
  801284:	ff 75 ec             	pushl  -0x14(%ebp)
  801287:	e8 44 f3 ff ff       	call   8005d0 <cputchar>
  80128c:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  80128f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801292:	8b 45 0c             	mov    0xc(%ebp),%eax
  801295:	01 d0                	add    %edx,%eax
  801297:	c6 00 00             	movb   $0x0,(%eax)
				break;
  80129a:	eb 06                	jmp    8012a2 <atomic_readline+0x101>
			}
		}
  80129c:	e9 3b ff ff ff       	jmp    8011dc <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  8012a1:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  8012a2:	e8 5b 0e 00 00       	call   802102 <sys_unlock_cons>
}
  8012a7:	90                   	nop
  8012a8:	c9                   	leave  
  8012a9:	c3                   	ret    

008012aa <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  8012aa:	55                   	push   %ebp
  8012ab:	89 e5                	mov    %esp,%ebp
  8012ad:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8012b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012b7:	eb 06                	jmp    8012bf <strlen+0x15>
		n++;
  8012b9:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012bc:	ff 45 08             	incl   0x8(%ebp)
  8012bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c2:	8a 00                	mov    (%eax),%al
  8012c4:	84 c0                	test   %al,%al
  8012c6:	75 f1                	jne    8012b9 <strlen+0xf>
		n++;
	return n;
  8012c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012cb:	c9                   	leave  
  8012cc:	c3                   	ret    

008012cd <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8012cd:	55                   	push   %ebp
  8012ce:	89 e5                	mov    %esp,%ebp
  8012d0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012da:	eb 09                	jmp    8012e5 <strnlen+0x18>
		n++;
  8012dc:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012df:	ff 45 08             	incl   0x8(%ebp)
  8012e2:	ff 4d 0c             	decl   0xc(%ebp)
  8012e5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012e9:	74 09                	je     8012f4 <strnlen+0x27>
  8012eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ee:	8a 00                	mov    (%eax),%al
  8012f0:	84 c0                	test   %al,%al
  8012f2:	75 e8                	jne    8012dc <strnlen+0xf>
		n++;
	return n;
  8012f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012f7:	c9                   	leave  
  8012f8:	c3                   	ret    

008012f9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8012f9:	55                   	push   %ebp
  8012fa:	89 e5                	mov    %esp,%ebp
  8012fc:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8012ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801302:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801305:	90                   	nop
  801306:	8b 45 08             	mov    0x8(%ebp),%eax
  801309:	8d 50 01             	lea    0x1(%eax),%edx
  80130c:	89 55 08             	mov    %edx,0x8(%ebp)
  80130f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801312:	8d 4a 01             	lea    0x1(%edx),%ecx
  801315:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801318:	8a 12                	mov    (%edx),%dl
  80131a:	88 10                	mov    %dl,(%eax)
  80131c:	8a 00                	mov    (%eax),%al
  80131e:	84 c0                	test   %al,%al
  801320:	75 e4                	jne    801306 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801322:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801325:	c9                   	leave  
  801326:	c3                   	ret    

00801327 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801327:	55                   	push   %ebp
  801328:	89 e5                	mov    %esp,%ebp
  80132a:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80132d:	8b 45 08             	mov    0x8(%ebp),%eax
  801330:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801333:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80133a:	eb 1f                	jmp    80135b <strncpy+0x34>
		*dst++ = *src;
  80133c:	8b 45 08             	mov    0x8(%ebp),%eax
  80133f:	8d 50 01             	lea    0x1(%eax),%edx
  801342:	89 55 08             	mov    %edx,0x8(%ebp)
  801345:	8b 55 0c             	mov    0xc(%ebp),%edx
  801348:	8a 12                	mov    (%edx),%dl
  80134a:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80134c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134f:	8a 00                	mov    (%eax),%al
  801351:	84 c0                	test   %al,%al
  801353:	74 03                	je     801358 <strncpy+0x31>
			src++;
  801355:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801358:	ff 45 fc             	incl   -0x4(%ebp)
  80135b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80135e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801361:	72 d9                	jb     80133c <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801363:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801366:	c9                   	leave  
  801367:	c3                   	ret    

00801368 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801368:	55                   	push   %ebp
  801369:	89 e5                	mov    %esp,%ebp
  80136b:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80136e:	8b 45 08             	mov    0x8(%ebp),%eax
  801371:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801374:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801378:	74 30                	je     8013aa <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80137a:	eb 16                	jmp    801392 <strlcpy+0x2a>
			*dst++ = *src++;
  80137c:	8b 45 08             	mov    0x8(%ebp),%eax
  80137f:	8d 50 01             	lea    0x1(%eax),%edx
  801382:	89 55 08             	mov    %edx,0x8(%ebp)
  801385:	8b 55 0c             	mov    0xc(%ebp),%edx
  801388:	8d 4a 01             	lea    0x1(%edx),%ecx
  80138b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80138e:	8a 12                	mov    (%edx),%dl
  801390:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801392:	ff 4d 10             	decl   0x10(%ebp)
  801395:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801399:	74 09                	je     8013a4 <strlcpy+0x3c>
  80139b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139e:	8a 00                	mov    (%eax),%al
  8013a0:	84 c0                	test   %al,%al
  8013a2:	75 d8                	jne    80137c <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8013a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8013aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8013ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013b0:	29 c2                	sub    %eax,%edx
  8013b2:	89 d0                	mov    %edx,%eax
}
  8013b4:	c9                   	leave  
  8013b5:	c3                   	ret    

008013b6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8013b6:	55                   	push   %ebp
  8013b7:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8013b9:	eb 06                	jmp    8013c1 <strcmp+0xb>
		p++, q++;
  8013bb:	ff 45 08             	incl   0x8(%ebp)
  8013be:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8013c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c4:	8a 00                	mov    (%eax),%al
  8013c6:	84 c0                	test   %al,%al
  8013c8:	74 0e                	je     8013d8 <strcmp+0x22>
  8013ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cd:	8a 10                	mov    (%eax),%dl
  8013cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d2:	8a 00                	mov    (%eax),%al
  8013d4:	38 c2                	cmp    %al,%dl
  8013d6:	74 e3                	je     8013bb <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013db:	8a 00                	mov    (%eax),%al
  8013dd:	0f b6 d0             	movzbl %al,%edx
  8013e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e3:	8a 00                	mov    (%eax),%al
  8013e5:	0f b6 c0             	movzbl %al,%eax
  8013e8:	29 c2                	sub    %eax,%edx
  8013ea:	89 d0                	mov    %edx,%eax
}
  8013ec:	5d                   	pop    %ebp
  8013ed:	c3                   	ret    

008013ee <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8013ee:	55                   	push   %ebp
  8013ef:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8013f1:	eb 09                	jmp    8013fc <strncmp+0xe>
		n--, p++, q++;
  8013f3:	ff 4d 10             	decl   0x10(%ebp)
  8013f6:	ff 45 08             	incl   0x8(%ebp)
  8013f9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8013fc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801400:	74 17                	je     801419 <strncmp+0x2b>
  801402:	8b 45 08             	mov    0x8(%ebp),%eax
  801405:	8a 00                	mov    (%eax),%al
  801407:	84 c0                	test   %al,%al
  801409:	74 0e                	je     801419 <strncmp+0x2b>
  80140b:	8b 45 08             	mov    0x8(%ebp),%eax
  80140e:	8a 10                	mov    (%eax),%dl
  801410:	8b 45 0c             	mov    0xc(%ebp),%eax
  801413:	8a 00                	mov    (%eax),%al
  801415:	38 c2                	cmp    %al,%dl
  801417:	74 da                	je     8013f3 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801419:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80141d:	75 07                	jne    801426 <strncmp+0x38>
		return 0;
  80141f:	b8 00 00 00 00       	mov    $0x0,%eax
  801424:	eb 14                	jmp    80143a <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801426:	8b 45 08             	mov    0x8(%ebp),%eax
  801429:	8a 00                	mov    (%eax),%al
  80142b:	0f b6 d0             	movzbl %al,%edx
  80142e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801431:	8a 00                	mov    (%eax),%al
  801433:	0f b6 c0             	movzbl %al,%eax
  801436:	29 c2                	sub    %eax,%edx
  801438:	89 d0                	mov    %edx,%eax
}
  80143a:	5d                   	pop    %ebp
  80143b:	c3                   	ret    

0080143c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80143c:	55                   	push   %ebp
  80143d:	89 e5                	mov    %esp,%ebp
  80143f:	83 ec 04             	sub    $0x4,%esp
  801442:	8b 45 0c             	mov    0xc(%ebp),%eax
  801445:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801448:	eb 12                	jmp    80145c <strchr+0x20>
		if (*s == c)
  80144a:	8b 45 08             	mov    0x8(%ebp),%eax
  80144d:	8a 00                	mov    (%eax),%al
  80144f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801452:	75 05                	jne    801459 <strchr+0x1d>
			return (char *) s;
  801454:	8b 45 08             	mov    0x8(%ebp),%eax
  801457:	eb 11                	jmp    80146a <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801459:	ff 45 08             	incl   0x8(%ebp)
  80145c:	8b 45 08             	mov    0x8(%ebp),%eax
  80145f:	8a 00                	mov    (%eax),%al
  801461:	84 c0                	test   %al,%al
  801463:	75 e5                	jne    80144a <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801465:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80146a:	c9                   	leave  
  80146b:	c3                   	ret    

0080146c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80146c:	55                   	push   %ebp
  80146d:	89 e5                	mov    %esp,%ebp
  80146f:	83 ec 04             	sub    $0x4,%esp
  801472:	8b 45 0c             	mov    0xc(%ebp),%eax
  801475:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801478:	eb 0d                	jmp    801487 <strfind+0x1b>
		if (*s == c)
  80147a:	8b 45 08             	mov    0x8(%ebp),%eax
  80147d:	8a 00                	mov    (%eax),%al
  80147f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801482:	74 0e                	je     801492 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801484:	ff 45 08             	incl   0x8(%ebp)
  801487:	8b 45 08             	mov    0x8(%ebp),%eax
  80148a:	8a 00                	mov    (%eax),%al
  80148c:	84 c0                	test   %al,%al
  80148e:	75 ea                	jne    80147a <strfind+0xe>
  801490:	eb 01                	jmp    801493 <strfind+0x27>
		if (*s == c)
			break;
  801492:	90                   	nop
	return (char *) s;
  801493:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801496:	c9                   	leave  
  801497:	c3                   	ret    

00801498 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801498:	55                   	push   %ebp
  801499:	89 e5                	mov    %esp,%ebp
  80149b:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80149e:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8014a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8014aa:	eb 0e                	jmp    8014ba <memset+0x22>
		*p++ = c;
  8014ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014af:	8d 50 01             	lea    0x1(%eax),%edx
  8014b2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014b8:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8014ba:	ff 4d f8             	decl   -0x8(%ebp)
  8014bd:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8014c1:	79 e9                	jns    8014ac <memset+0x14>
		*p++ = c;

	return v;
  8014c3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014c6:	c9                   	leave  
  8014c7:	c3                   	ret    

008014c8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8014c8:	55                   	push   %ebp
  8014c9:	89 e5                	mov    %esp,%ebp
  8014cb:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8014ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8014da:	eb 16                	jmp    8014f2 <memcpy+0x2a>
		*d++ = *s++;
  8014dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014df:	8d 50 01             	lea    0x1(%eax),%edx
  8014e2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014e5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014e8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014eb:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8014ee:	8a 12                	mov    (%edx),%dl
  8014f0:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8014f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014f8:	89 55 10             	mov    %edx,0x10(%ebp)
  8014fb:	85 c0                	test   %eax,%eax
  8014fd:	75 dd                	jne    8014dc <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8014ff:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801502:	c9                   	leave  
  801503:	c3                   	ret    

00801504 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801504:	55                   	push   %ebp
  801505:	89 e5                	mov    %esp,%ebp
  801507:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80150a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801510:	8b 45 08             	mov    0x8(%ebp),%eax
  801513:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801516:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801519:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80151c:	73 50                	jae    80156e <memmove+0x6a>
  80151e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801521:	8b 45 10             	mov    0x10(%ebp),%eax
  801524:	01 d0                	add    %edx,%eax
  801526:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801529:	76 43                	jbe    80156e <memmove+0x6a>
		s += n;
  80152b:	8b 45 10             	mov    0x10(%ebp),%eax
  80152e:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801531:	8b 45 10             	mov    0x10(%ebp),%eax
  801534:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801537:	eb 10                	jmp    801549 <memmove+0x45>
			*--d = *--s;
  801539:	ff 4d f8             	decl   -0x8(%ebp)
  80153c:	ff 4d fc             	decl   -0x4(%ebp)
  80153f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801542:	8a 10                	mov    (%eax),%dl
  801544:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801547:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801549:	8b 45 10             	mov    0x10(%ebp),%eax
  80154c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80154f:	89 55 10             	mov    %edx,0x10(%ebp)
  801552:	85 c0                	test   %eax,%eax
  801554:	75 e3                	jne    801539 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801556:	eb 23                	jmp    80157b <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801558:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80155b:	8d 50 01             	lea    0x1(%eax),%edx
  80155e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801561:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801564:	8d 4a 01             	lea    0x1(%edx),%ecx
  801567:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80156a:	8a 12                	mov    (%edx),%dl
  80156c:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80156e:	8b 45 10             	mov    0x10(%ebp),%eax
  801571:	8d 50 ff             	lea    -0x1(%eax),%edx
  801574:	89 55 10             	mov    %edx,0x10(%ebp)
  801577:	85 c0                	test   %eax,%eax
  801579:	75 dd                	jne    801558 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80157b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80157e:	c9                   	leave  
  80157f:	c3                   	ret    

00801580 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801580:	55                   	push   %ebp
  801581:	89 e5                	mov    %esp,%ebp
  801583:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801586:	8b 45 08             	mov    0x8(%ebp),%eax
  801589:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80158c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80158f:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801592:	eb 2a                	jmp    8015be <memcmp+0x3e>
		if (*s1 != *s2)
  801594:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801597:	8a 10                	mov    (%eax),%dl
  801599:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80159c:	8a 00                	mov    (%eax),%al
  80159e:	38 c2                	cmp    %al,%dl
  8015a0:	74 16                	je     8015b8 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8015a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015a5:	8a 00                	mov    (%eax),%al
  8015a7:	0f b6 d0             	movzbl %al,%edx
  8015aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015ad:	8a 00                	mov    (%eax),%al
  8015af:	0f b6 c0             	movzbl %al,%eax
  8015b2:	29 c2                	sub    %eax,%edx
  8015b4:	89 d0                	mov    %edx,%eax
  8015b6:	eb 18                	jmp    8015d0 <memcmp+0x50>
		s1++, s2++;
  8015b8:	ff 45 fc             	incl   -0x4(%ebp)
  8015bb:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8015be:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015c4:	89 55 10             	mov    %edx,0x10(%ebp)
  8015c7:	85 c0                	test   %eax,%eax
  8015c9:	75 c9                	jne    801594 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015d0:	c9                   	leave  
  8015d1:	c3                   	ret    

008015d2 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8015d2:	55                   	push   %ebp
  8015d3:	89 e5                	mov    %esp,%ebp
  8015d5:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8015d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8015db:	8b 45 10             	mov    0x10(%ebp),%eax
  8015de:	01 d0                	add    %edx,%eax
  8015e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8015e3:	eb 15                	jmp    8015fa <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8015e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e8:	8a 00                	mov    (%eax),%al
  8015ea:	0f b6 d0             	movzbl %al,%edx
  8015ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f0:	0f b6 c0             	movzbl %al,%eax
  8015f3:	39 c2                	cmp    %eax,%edx
  8015f5:	74 0d                	je     801604 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8015f7:	ff 45 08             	incl   0x8(%ebp)
  8015fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801600:	72 e3                	jb     8015e5 <memfind+0x13>
  801602:	eb 01                	jmp    801605 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801604:	90                   	nop
	return (void *) s;
  801605:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801608:	c9                   	leave  
  801609:	c3                   	ret    

0080160a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80160a:	55                   	push   %ebp
  80160b:	89 e5                	mov    %esp,%ebp
  80160d:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801610:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801617:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80161e:	eb 03                	jmp    801623 <strtol+0x19>
		s++;
  801620:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801623:	8b 45 08             	mov    0x8(%ebp),%eax
  801626:	8a 00                	mov    (%eax),%al
  801628:	3c 20                	cmp    $0x20,%al
  80162a:	74 f4                	je     801620 <strtol+0x16>
  80162c:	8b 45 08             	mov    0x8(%ebp),%eax
  80162f:	8a 00                	mov    (%eax),%al
  801631:	3c 09                	cmp    $0x9,%al
  801633:	74 eb                	je     801620 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801635:	8b 45 08             	mov    0x8(%ebp),%eax
  801638:	8a 00                	mov    (%eax),%al
  80163a:	3c 2b                	cmp    $0x2b,%al
  80163c:	75 05                	jne    801643 <strtol+0x39>
		s++;
  80163e:	ff 45 08             	incl   0x8(%ebp)
  801641:	eb 13                	jmp    801656 <strtol+0x4c>
	else if (*s == '-')
  801643:	8b 45 08             	mov    0x8(%ebp),%eax
  801646:	8a 00                	mov    (%eax),%al
  801648:	3c 2d                	cmp    $0x2d,%al
  80164a:	75 0a                	jne    801656 <strtol+0x4c>
		s++, neg = 1;
  80164c:	ff 45 08             	incl   0x8(%ebp)
  80164f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801656:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80165a:	74 06                	je     801662 <strtol+0x58>
  80165c:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801660:	75 20                	jne    801682 <strtol+0x78>
  801662:	8b 45 08             	mov    0x8(%ebp),%eax
  801665:	8a 00                	mov    (%eax),%al
  801667:	3c 30                	cmp    $0x30,%al
  801669:	75 17                	jne    801682 <strtol+0x78>
  80166b:	8b 45 08             	mov    0x8(%ebp),%eax
  80166e:	40                   	inc    %eax
  80166f:	8a 00                	mov    (%eax),%al
  801671:	3c 78                	cmp    $0x78,%al
  801673:	75 0d                	jne    801682 <strtol+0x78>
		s += 2, base = 16;
  801675:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801679:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801680:	eb 28                	jmp    8016aa <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801682:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801686:	75 15                	jne    80169d <strtol+0x93>
  801688:	8b 45 08             	mov    0x8(%ebp),%eax
  80168b:	8a 00                	mov    (%eax),%al
  80168d:	3c 30                	cmp    $0x30,%al
  80168f:	75 0c                	jne    80169d <strtol+0x93>
		s++, base = 8;
  801691:	ff 45 08             	incl   0x8(%ebp)
  801694:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80169b:	eb 0d                	jmp    8016aa <strtol+0xa0>
	else if (base == 0)
  80169d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016a1:	75 07                	jne    8016aa <strtol+0xa0>
		base = 10;
  8016a3:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ad:	8a 00                	mov    (%eax),%al
  8016af:	3c 2f                	cmp    $0x2f,%al
  8016b1:	7e 19                	jle    8016cc <strtol+0xc2>
  8016b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b6:	8a 00                	mov    (%eax),%al
  8016b8:	3c 39                	cmp    $0x39,%al
  8016ba:	7f 10                	jg     8016cc <strtol+0xc2>
			dig = *s - '0';
  8016bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bf:	8a 00                	mov    (%eax),%al
  8016c1:	0f be c0             	movsbl %al,%eax
  8016c4:	83 e8 30             	sub    $0x30,%eax
  8016c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016ca:	eb 42                	jmp    80170e <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8016cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cf:	8a 00                	mov    (%eax),%al
  8016d1:	3c 60                	cmp    $0x60,%al
  8016d3:	7e 19                	jle    8016ee <strtol+0xe4>
  8016d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d8:	8a 00                	mov    (%eax),%al
  8016da:	3c 7a                	cmp    $0x7a,%al
  8016dc:	7f 10                	jg     8016ee <strtol+0xe4>
			dig = *s - 'a' + 10;
  8016de:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e1:	8a 00                	mov    (%eax),%al
  8016e3:	0f be c0             	movsbl %al,%eax
  8016e6:	83 e8 57             	sub    $0x57,%eax
  8016e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016ec:	eb 20                	jmp    80170e <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8016ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f1:	8a 00                	mov    (%eax),%al
  8016f3:	3c 40                	cmp    $0x40,%al
  8016f5:	7e 39                	jle    801730 <strtol+0x126>
  8016f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fa:	8a 00                	mov    (%eax),%al
  8016fc:	3c 5a                	cmp    $0x5a,%al
  8016fe:	7f 30                	jg     801730 <strtol+0x126>
			dig = *s - 'A' + 10;
  801700:	8b 45 08             	mov    0x8(%ebp),%eax
  801703:	8a 00                	mov    (%eax),%al
  801705:	0f be c0             	movsbl %al,%eax
  801708:	83 e8 37             	sub    $0x37,%eax
  80170b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80170e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801711:	3b 45 10             	cmp    0x10(%ebp),%eax
  801714:	7d 19                	jge    80172f <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801716:	ff 45 08             	incl   0x8(%ebp)
  801719:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80171c:	0f af 45 10          	imul   0x10(%ebp),%eax
  801720:	89 c2                	mov    %eax,%edx
  801722:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801725:	01 d0                	add    %edx,%eax
  801727:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80172a:	e9 7b ff ff ff       	jmp    8016aa <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80172f:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801730:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801734:	74 08                	je     80173e <strtol+0x134>
		*endptr = (char *) s;
  801736:	8b 45 0c             	mov    0xc(%ebp),%eax
  801739:	8b 55 08             	mov    0x8(%ebp),%edx
  80173c:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80173e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801742:	74 07                	je     80174b <strtol+0x141>
  801744:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801747:	f7 d8                	neg    %eax
  801749:	eb 03                	jmp    80174e <strtol+0x144>
  80174b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80174e:	c9                   	leave  
  80174f:	c3                   	ret    

00801750 <ltostr>:

void
ltostr(long value, char *str)
{
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
  801753:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801756:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80175d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801764:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801768:	79 13                	jns    80177d <ltostr+0x2d>
	{
		neg = 1;
  80176a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801771:	8b 45 0c             	mov    0xc(%ebp),%eax
  801774:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801777:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80177a:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80177d:	8b 45 08             	mov    0x8(%ebp),%eax
  801780:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801785:	99                   	cltd   
  801786:	f7 f9                	idiv   %ecx
  801788:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80178b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80178e:	8d 50 01             	lea    0x1(%eax),%edx
  801791:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801794:	89 c2                	mov    %eax,%edx
  801796:	8b 45 0c             	mov    0xc(%ebp),%eax
  801799:	01 d0                	add    %edx,%eax
  80179b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80179e:	83 c2 30             	add    $0x30,%edx
  8017a1:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8017a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017a6:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8017ab:	f7 e9                	imul   %ecx
  8017ad:	c1 fa 02             	sar    $0x2,%edx
  8017b0:	89 c8                	mov    %ecx,%eax
  8017b2:	c1 f8 1f             	sar    $0x1f,%eax
  8017b5:	29 c2                	sub    %eax,%edx
  8017b7:	89 d0                	mov    %edx,%eax
  8017b9:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8017bc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8017c0:	75 bb                	jne    80177d <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8017c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8017c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017cc:	48                   	dec    %eax
  8017cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8017d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8017d4:	74 3d                	je     801813 <ltostr+0xc3>
		start = 1 ;
  8017d6:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8017dd:	eb 34                	jmp    801813 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8017df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e5:	01 d0                	add    %edx,%eax
  8017e7:	8a 00                	mov    (%eax),%al
  8017e9:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8017ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f2:	01 c2                	add    %eax,%edx
  8017f4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8017f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017fa:	01 c8                	add    %ecx,%eax
  8017fc:	8a 00                	mov    (%eax),%al
  8017fe:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801800:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801803:	8b 45 0c             	mov    0xc(%ebp),%eax
  801806:	01 c2                	add    %eax,%edx
  801808:	8a 45 eb             	mov    -0x15(%ebp),%al
  80180b:	88 02                	mov    %al,(%edx)
		start++ ;
  80180d:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801810:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801813:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801816:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801819:	7c c4                	jl     8017df <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80181b:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80181e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801821:	01 d0                	add    %edx,%eax
  801823:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801826:	90                   	nop
  801827:	c9                   	leave  
  801828:	c3                   	ret    

00801829 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801829:	55                   	push   %ebp
  80182a:	89 e5                	mov    %esp,%ebp
  80182c:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80182f:	ff 75 08             	pushl  0x8(%ebp)
  801832:	e8 73 fa ff ff       	call   8012aa <strlen>
  801837:	83 c4 04             	add    $0x4,%esp
  80183a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80183d:	ff 75 0c             	pushl  0xc(%ebp)
  801840:	e8 65 fa ff ff       	call   8012aa <strlen>
  801845:	83 c4 04             	add    $0x4,%esp
  801848:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80184b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801852:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801859:	eb 17                	jmp    801872 <strcconcat+0x49>
		final[s] = str1[s] ;
  80185b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80185e:	8b 45 10             	mov    0x10(%ebp),%eax
  801861:	01 c2                	add    %eax,%edx
  801863:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801866:	8b 45 08             	mov    0x8(%ebp),%eax
  801869:	01 c8                	add    %ecx,%eax
  80186b:	8a 00                	mov    (%eax),%al
  80186d:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80186f:	ff 45 fc             	incl   -0x4(%ebp)
  801872:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801875:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801878:	7c e1                	jl     80185b <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80187a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801881:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801888:	eb 1f                	jmp    8018a9 <strcconcat+0x80>
		final[s++] = str2[i] ;
  80188a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80188d:	8d 50 01             	lea    0x1(%eax),%edx
  801890:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801893:	89 c2                	mov    %eax,%edx
  801895:	8b 45 10             	mov    0x10(%ebp),%eax
  801898:	01 c2                	add    %eax,%edx
  80189a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80189d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a0:	01 c8                	add    %ecx,%eax
  8018a2:	8a 00                	mov    (%eax),%al
  8018a4:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8018a6:	ff 45 f8             	incl   -0x8(%ebp)
  8018a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018ac:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018af:	7c d9                	jl     80188a <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8018b1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8018b7:	01 d0                	add    %edx,%eax
  8018b9:	c6 00 00             	movb   $0x0,(%eax)
}
  8018bc:	90                   	nop
  8018bd:	c9                   	leave  
  8018be:	c3                   	ret    

008018bf <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8018bf:	55                   	push   %ebp
  8018c0:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8018c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8018c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8018cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8018ce:	8b 00                	mov    (%eax),%eax
  8018d0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8018da:	01 d0                	add    %edx,%eax
  8018dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018e2:	eb 0c                	jmp    8018f0 <strsplit+0x31>
			*string++ = 0;
  8018e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e7:	8d 50 01             	lea    0x1(%eax),%edx
  8018ea:	89 55 08             	mov    %edx,0x8(%ebp)
  8018ed:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f3:	8a 00                	mov    (%eax),%al
  8018f5:	84 c0                	test   %al,%al
  8018f7:	74 18                	je     801911 <strsplit+0x52>
  8018f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fc:	8a 00                	mov    (%eax),%al
  8018fe:	0f be c0             	movsbl %al,%eax
  801901:	50                   	push   %eax
  801902:	ff 75 0c             	pushl  0xc(%ebp)
  801905:	e8 32 fb ff ff       	call   80143c <strchr>
  80190a:	83 c4 08             	add    $0x8,%esp
  80190d:	85 c0                	test   %eax,%eax
  80190f:	75 d3                	jne    8018e4 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801911:	8b 45 08             	mov    0x8(%ebp),%eax
  801914:	8a 00                	mov    (%eax),%al
  801916:	84 c0                	test   %al,%al
  801918:	74 5a                	je     801974 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80191a:	8b 45 14             	mov    0x14(%ebp),%eax
  80191d:	8b 00                	mov    (%eax),%eax
  80191f:	83 f8 0f             	cmp    $0xf,%eax
  801922:	75 07                	jne    80192b <strsplit+0x6c>
		{
			return 0;
  801924:	b8 00 00 00 00       	mov    $0x0,%eax
  801929:	eb 66                	jmp    801991 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80192b:	8b 45 14             	mov    0x14(%ebp),%eax
  80192e:	8b 00                	mov    (%eax),%eax
  801930:	8d 48 01             	lea    0x1(%eax),%ecx
  801933:	8b 55 14             	mov    0x14(%ebp),%edx
  801936:	89 0a                	mov    %ecx,(%edx)
  801938:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80193f:	8b 45 10             	mov    0x10(%ebp),%eax
  801942:	01 c2                	add    %eax,%edx
  801944:	8b 45 08             	mov    0x8(%ebp),%eax
  801947:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801949:	eb 03                	jmp    80194e <strsplit+0x8f>
			string++;
  80194b:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80194e:	8b 45 08             	mov    0x8(%ebp),%eax
  801951:	8a 00                	mov    (%eax),%al
  801953:	84 c0                	test   %al,%al
  801955:	74 8b                	je     8018e2 <strsplit+0x23>
  801957:	8b 45 08             	mov    0x8(%ebp),%eax
  80195a:	8a 00                	mov    (%eax),%al
  80195c:	0f be c0             	movsbl %al,%eax
  80195f:	50                   	push   %eax
  801960:	ff 75 0c             	pushl  0xc(%ebp)
  801963:	e8 d4 fa ff ff       	call   80143c <strchr>
  801968:	83 c4 08             	add    $0x8,%esp
  80196b:	85 c0                	test   %eax,%eax
  80196d:	74 dc                	je     80194b <strsplit+0x8c>
			string++;
	}
  80196f:	e9 6e ff ff ff       	jmp    8018e2 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801974:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801975:	8b 45 14             	mov    0x14(%ebp),%eax
  801978:	8b 00                	mov    (%eax),%eax
  80197a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801981:	8b 45 10             	mov    0x10(%ebp),%eax
  801984:	01 d0                	add    %edx,%eax
  801986:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80198c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801991:	c9                   	leave  
  801992:	c3                   	ret    

00801993 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801993:	55                   	push   %ebp
  801994:	89 e5                	mov    %esp,%ebp
  801996:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801999:	83 ec 04             	sub    $0x4,%esp
  80199c:	68 bc 43 80 00       	push   $0x8043bc
  8019a1:	68 3f 01 00 00       	push   $0x13f
  8019a6:	68 de 43 80 00       	push   $0x8043de
  8019ab:	e8 a1 ed ff ff       	call   800751 <_panic>

008019b0 <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  8019b0:	55                   	push   %ebp
  8019b1:	89 e5                	mov    %esp,%ebp
  8019b3:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  8019b6:	83 ec 0c             	sub    $0xc,%esp
  8019b9:	ff 75 08             	pushl  0x8(%ebp)
  8019bc:	e8 90 0c 00 00       	call   802651 <sys_sbrk>
  8019c1:	83 c4 10             	add    $0x10,%esp
}
  8019c4:	c9                   	leave  
  8019c5:	c3                   	ret    

008019c6 <malloc>:
#define num_of_page ((USER_HEAP_MAX - USER_HEAP_START) / PAGE_SIZE)

int pagesAllocated[num_of_page] = { 0 };
int shardIDs[num_of_page] = { 0 };
bool markedPages[num_of_page] = { 0 };
void* malloc(uint32 size) {
  8019c6:	55                   	push   %ebp
  8019c7:	89 e5                	mov    %esp,%ebp
  8019c9:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  8019cc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8019d0:	75 0a                	jne    8019dc <malloc+0x16>
		return NULL;
  8019d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8019d7:	e9 9e 01 00 00       	jmp    801b7a <malloc+0x1b4>

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

	//  our new code
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  8019dc:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8019e3:	77 2c                	ja     801a11 <malloc+0x4b>
		if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  8019e5:	e8 eb 0a 00 00       	call   8024d5 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8019ea:	85 c0                	test   %eax,%eax
  8019ec:	74 19                	je     801a07 <malloc+0x41>

			void * block = alloc_block_FF(size);
  8019ee:	83 ec 0c             	sub    $0xc,%esp
  8019f1:	ff 75 08             	pushl  0x8(%ebp)
  8019f4:	e8 85 11 00 00       	call   802b7e <alloc_block_FF>
  8019f9:	83 c4 10             	add    $0x10,%esp
  8019fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			return block;
  8019ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a02:	e9 73 01 00 00       	jmp    801b7a <malloc+0x1b4>
		} else {
			return NULL;
  801a07:	b8 00 00 00 00       	mov    $0x0,%eax
  801a0c:	e9 69 01 00 00       	jmp    801b7a <malloc+0x1b4>
		}
	}

	uint32 numOfPages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801a11:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801a18:	8b 55 08             	mov    0x8(%ebp),%edx
  801a1b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a1e:	01 d0                	add    %edx,%eax
  801a20:	48                   	dec    %eax
  801a21:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801a24:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a27:	ba 00 00 00 00       	mov    $0x0,%edx
  801a2c:	f7 75 e0             	divl   -0x20(%ebp)
  801a2f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a32:	29 d0                	sub    %edx,%eax
  801a34:	c1 e8 0c             	shr    $0xc,%eax
  801a37:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 freePagesCount = 0;
  801a3a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801a41:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  801a48:	a1 24 50 80 00       	mov    0x805024,%eax
  801a4d:	8b 40 7c             	mov    0x7c(%eax),%eax
  801a50:	05 00 10 00 00       	add    $0x1000,%eax
  801a55:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  801a58:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801a5d:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801a60:	89 45 d0             	mov    %eax,-0x30(%ebp)

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  801a63:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  801a6a:	8b 55 08             	mov    0x8(%ebp),%edx
  801a6d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801a70:	01 d0                	add    %edx,%eax
  801a72:	48                   	dec    %eax
  801a73:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801a76:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801a79:	ba 00 00 00 00       	mov    $0x0,%edx
  801a7e:	f7 75 cc             	divl   -0x34(%ebp)
  801a81:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801a84:	29 d0                	sub    %edx,%eax
  801a86:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801a89:	76 0a                	jbe    801a95 <malloc+0xcf>
		return NULL;
  801a8b:	b8 00 00 00 00       	mov    $0x0,%eax
  801a90:	e9 e5 00 00 00       	jmp    801b7a <malloc+0x1b4>
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  801a95:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a98:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801a9b:	eb 48                	jmp    801ae5 <malloc+0x11f>
	{
		uint32 idx = (i - currentAddr) / PAGE_SIZE;
  801a9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801aa0:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801aa3:	c1 e8 0c             	shr    $0xc,%eax
  801aa6:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if (!markedPages[idx]) {
  801aa9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801aac:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  801ab3:	85 c0                	test   %eax,%eax
  801ab5:	75 11                	jne    801ac8 <malloc+0x102>
			freePagesCount++;
  801ab7:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801aba:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801abe:	75 16                	jne    801ad6 <malloc+0x110>
				start = i;
  801ac0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ac3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ac6:	eb 0e                	jmp    801ad6 <malloc+0x110>
			}
		} else {
			freePagesCount = 0;
  801ac8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  801acf:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == numOfPages) {
  801ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ad9:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801adc:	74 12                	je     801af0 <malloc+0x12a>

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  801ade:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801ae5:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801aec:	76 af                	jbe    801a9d <malloc+0xd7>
  801aee:	eb 01                	jmp    801af1 <malloc+0x12b>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == numOfPages) {
			break;
  801af0:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
  801af1:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801af5:	74 08                	je     801aff <malloc+0x139>
  801af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801afa:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801afd:	74 07                	je     801b06 <malloc+0x140>
		return NULL;
  801aff:	b8 00 00 00 00       	mov    $0x0,%eax
  801b04:	eb 74                	jmp    801b7a <malloc+0x1b4>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  801b06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b09:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801b0c:	c1 e8 0c             	shr    $0xc,%eax
  801b0f:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numOfPages;
  801b12:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801b15:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801b18:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  801b1f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801b22:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801b25:	eb 11                	jmp    801b38 <malloc+0x172>
		markedPages[i] = 1;
  801b27:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b2a:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  801b31:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = numOfPages;
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  801b35:	ff 45 e8             	incl   -0x18(%ebp)
  801b38:	8b 55 c0             	mov    -0x40(%ebp),%edx
  801b3b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b3e:	01 d0                	add    %edx,%eax
  801b40:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801b43:	77 e2                	ja     801b27 <malloc+0x161>
		markedPages[i] = 1;
	}

	sys_allocate_user_mem(start, ROUNDUP(size, PAGE_SIZE));
  801b45:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801b4c:	8b 55 08             	mov    0x8(%ebp),%edx
  801b4f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801b52:	01 d0                	add    %edx,%eax
  801b54:	48                   	dec    %eax
  801b55:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801b58:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801b5b:	ba 00 00 00 00       	mov    $0x0,%edx
  801b60:	f7 75 bc             	divl   -0x44(%ebp)
  801b63:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801b66:	29 d0                	sub    %edx,%eax
  801b68:	83 ec 08             	sub    $0x8,%esp
  801b6b:	50                   	push   %eax
  801b6c:	ff 75 f0             	pushl  -0x10(%ebp)
  801b6f:	e8 14 0b 00 00       	call   802688 <sys_allocate_user_mem>
  801b74:	83 c4 10             	add    $0x10,%esp
	return (void*) start;
  801b77:	8b 45 f0             	mov    -0x10(%ebp),%eax

}
  801b7a:	c9                   	leave  
  801b7b:	c3                   	ret    

00801b7c <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address) {
  801b7c:	55                   	push   %ebp
  801b7d:	89 e5                	mov    %esp,%ebp
  801b7f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
  801b82:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b86:	0f 84 ee 00 00 00    	je     801c7a <free+0xfe>
		return;
	}

	if (virtual_address
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  801b8c:	a1 24 50 80 00       	mov    0x805024,%eax
  801b91:	8b 40 74             	mov    0x74(%eax),%eax

	if (virtual_address == NULL) {
		return;
	}

	if (virtual_address
  801b94:	3b 45 08             	cmp    0x8(%ebp),%eax
  801b97:	77 09                	ja     801ba2 <free+0x26>
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  801b99:	81 7d 08 00 00 00 a0 	cmpl   $0xa0000000,0x8(%ebp)
  801ba0:	76 14                	jbe    801bb6 <free+0x3a>
		panic("INVALID VIRTUAL ADDRESS!!");
  801ba2:	83 ec 04             	sub    $0x4,%esp
  801ba5:	68 ec 43 80 00       	push   $0x8043ec
  801baa:	6a 68                	push   $0x68
  801bac:	68 06 44 80 00       	push   $0x804406
  801bb1:	e8 9b eb ff ff       	call   800751 <_panic>
	}
	if (virtual_address >= (void *) (myEnv->uheapStart)
  801bb6:	a1 24 50 80 00       	mov    0x805024,%eax
  801bbb:	8b 40 74             	mov    0x74(%eax),%eax
  801bbe:	3b 45 08             	cmp    0x8(%ebp),%eax
  801bc1:	77 20                	ja     801be3 <free+0x67>
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
  801bc3:	a1 24 50 80 00       	mov    0x805024,%eax
  801bc8:	8b 40 78             	mov    0x78(%eax),%eax
  801bcb:	3b 45 08             	cmp    0x8(%ebp),%eax
  801bce:	76 13                	jbe    801be3 <free+0x67>
		free_block(virtual_address);
  801bd0:	83 ec 0c             	sub    $0xc,%esp
  801bd3:	ff 75 08             	pushl  0x8(%ebp)
  801bd6:	e8 6c 16 00 00       	call   803247 <free_block>
  801bdb:	83 c4 10             	add    $0x10,%esp
		return;
  801bde:	e9 98 00 00 00       	jmp    801c7b <free+0xff>
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  801be3:	8b 55 08             	mov    0x8(%ebp),%edx
  801be6:	a1 24 50 80 00       	mov    0x805024,%eax
  801beb:	8b 40 7c             	mov    0x7c(%eax),%eax
  801bee:	29 c2                	sub    %eax,%edx
  801bf0:	89 d0                	mov    %edx,%eax
  801bf2:	2d 00 10 00 00       	sub    $0x1000,%eax
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
		free_block(virtual_address);
		return;
	}

	uint32 pageIdx = ((uint32) virtual_address
  801bf7:	c1 e8 0c             	shr    $0xc,%eax
  801bfa:	89 45 ec             	mov    %eax,-0x14(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  801bfd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801c04:	eb 16                	jmp    801c1c <free+0xa0>
		markedPages[idx + pageIdx] = 0;
  801c06:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c0c:	01 d0                	add    %edx,%eax
  801c0e:	c7 04 85 40 50 90 00 	movl   $0x0,0x905040(,%eax,4)
  801c15:	00 00 00 00 
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  801c19:	ff 45 f4             	incl   -0xc(%ebp)
  801c1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c1f:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  801c26:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801c29:	7f db                	jg     801c06 <free+0x8a>
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;
  801c2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c2e:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  801c35:	c1 e0 0c             	shl    $0xc,%eax
  801c38:	89 45 e8             	mov    %eax,-0x18(%ebp)

	for (uint32 i = (uint32) virtual_address;
  801c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c41:	eb 1a                	jmp    801c5d <free+0xe1>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
  801c43:	83 ec 08             	sub    $0x8,%esp
  801c46:	68 00 10 00 00       	push   $0x1000
  801c4b:	ff 75 f0             	pushl  -0x10(%ebp)
  801c4e:	e8 19 0a 00 00       	call   80266c <sys_free_user_mem>
  801c53:	83 c4 10             	add    $0x10,%esp
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
  801c56:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  801c5d:	8b 55 08             	mov    0x8(%ebp),%edx
  801c60:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c63:	01 d0                	add    %edx,%eax
	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
  801c65:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801c68:	77 d9                	ja     801c43 <free+0xc7>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;
  801c6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c6d:	c7 04 85 40 50 80 00 	movl   $0x0,0x805040(,%eax,4)
  801c74:	00 00 00 00 
  801c78:	eb 01                	jmp    801c7b <free+0xff>
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
		return;
  801c7a:	90                   	nop
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;

}
  801c7b:	c9                   	leave  
  801c7c:	c3                   	ret    

00801c7d <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  801c7d:	55                   	push   %ebp
  801c7e:	89 e5                	mov    %esp,%ebp
  801c80:	83 ec 58             	sub    $0x58,%esp
  801c83:	8b 45 10             	mov    0x10(%ebp),%eax
  801c86:	88 45 b4             	mov    %al,-0x4c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  801c89:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c8d:	75 0a                	jne    801c99 <smalloc+0x1c>
		return NULL;
  801c8f:	b8 00 00 00 00       	mov    $0x0,%eax
  801c94:	e9 7d 01 00 00       	jmp    801e16 <smalloc+0x199>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	uint32 num_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801c99:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  801ca0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ca3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ca6:	01 d0                	add    %edx,%eax
  801ca8:	48                   	dec    %eax
  801ca9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801cac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801caf:	ba 00 00 00 00       	mov    $0x0,%edx
  801cb4:	f7 75 e4             	divl   -0x1c(%ebp)
  801cb7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cba:	29 d0                	sub    %edx,%eax
  801cbc:	c1 e8 0c             	shr    $0xc,%eax
  801cbf:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 freePagesCount = 0;
  801cc2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801cc9:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  801cd0:	a1 24 50 80 00       	mov    0x805024,%eax
  801cd5:	8b 40 7c             	mov    0x7c(%eax),%eax
  801cd8:	05 00 10 00 00       	add    $0x1000,%eax
  801cdd:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  801ce0:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801ce5:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801ce8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  801ceb:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801cf2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cf5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801cf8:	01 d0                	add    %edx,%eax
  801cfa:	48                   	dec    %eax
  801cfb:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801cfe:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801d01:	ba 00 00 00 00       	mov    $0x0,%edx
  801d06:	f7 75 d0             	divl   -0x30(%ebp)
  801d09:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801d0c:	29 d0                	sub    %edx,%eax
  801d0e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801d11:	76 0a                	jbe    801d1d <smalloc+0xa0>
		return NULL;
  801d13:	b8 00 00 00 00       	mov    $0x0,%eax
  801d18:	e9 f9 00 00 00       	jmp    801e16 <smalloc+0x199>
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801d1d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d20:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801d23:	eb 48                	jmp    801d6d <smalloc+0xf0>
		uint32 idx = (s - currentAddr) / PAGE_SIZE;
  801d25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d28:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801d2b:	c1 e8 0c             	shr    $0xc,%eax
  801d2e:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (!markedPages[idx]) {
  801d31:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801d34:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  801d3b:	85 c0                	test   %eax,%eax
  801d3d:	75 11                	jne    801d50 <smalloc+0xd3>
			freePagesCount++;
  801d3f:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801d42:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801d46:	75 16                	jne    801d5e <smalloc+0xe1>
				start = s;
  801d48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d4e:	eb 0e                	jmp    801d5e <smalloc+0xe1>
			}
		} else {
			freePagesCount = 0;
  801d50:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  801d57:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == num_Of_Pages) {
  801d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d61:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801d64:	74 12                	je     801d78 <smalloc+0xfb>
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801d66:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801d6d:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801d74:	76 af                	jbe    801d25 <smalloc+0xa8>
  801d76:	eb 01                	jmp    801d79 <smalloc+0xfc>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == num_Of_Pages) {
			break;
  801d78:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
  801d79:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801d7d:	74 08                	je     801d87 <smalloc+0x10a>
  801d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d82:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801d85:	74 0a                	je     801d91 <smalloc+0x114>
		return NULL;
  801d87:	b8 00 00 00 00       	mov    $0x0,%eax
  801d8c:	e9 85 00 00 00       	jmp    801e16 <smalloc+0x199>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  801d91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d94:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801d97:	c1 e8 0c             	shr    $0xc,%eax
  801d9a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	pagesAllocated[startPage] = num_Of_Pages;
  801d9d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801da0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801da3:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  801daa:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801dad:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801db0:	eb 11                	jmp    801dc3 <smalloc+0x146>
		markedPages[s] = 1;
  801db2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801db5:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  801dbc:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = num_Of_Pages;
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  801dc0:	ff 45 e8             	incl   -0x18(%ebp)
  801dc3:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801dc6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801dc9:	01 d0                	add    %edx,%eax
  801dcb:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801dce:	77 e2                	ja     801db2 <smalloc+0x135>
		markedPages[s] = 1;
	}
	int sharedobjID = sys_createSharedObject(sharedVarName, size, isWritable,
  801dd0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801dd3:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
  801dd7:	52                   	push   %edx
  801dd8:	50                   	push   %eax
  801dd9:	ff 75 0c             	pushl  0xc(%ebp)
  801ddc:	ff 75 08             	pushl  0x8(%ebp)
  801ddf:	e8 8f 04 00 00       	call   802273 <sys_createSharedObject>
  801de4:	83 c4 10             	add    $0x10,%esp
  801de7:	89 45 c0             	mov    %eax,-0x40(%ebp)
			(void*) start);

	if (sharedobjID >= 0) {
  801dea:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  801dee:	78 12                	js     801e02 <smalloc+0x185>
		shardIDs[startPage] = sharedobjID;
  801df0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801df3:	8b 55 c0             	mov    -0x40(%ebp),%edx
  801df6:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  801dfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e00:	eb 14                	jmp    801e16 <smalloc+0x199>
	}
	free((void*) start);
  801e02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e05:	83 ec 0c             	sub    $0xc,%esp
  801e08:	50                   	push   %eax
  801e09:	e8 6e fd ff ff       	call   801b7c <free>
  801e0e:	83 c4 10             	add    $0x10,%esp
	return NULL;
  801e11:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e16:	c9                   	leave  
  801e17:	c3                   	ret    

00801e18 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  801e18:	55                   	push   %ebp
  801e19:	89 e5                	mov    %esp,%ebp
  801e1b:	83 ec 48             	sub    $0x48,%esp
	//cprintf("SSSSSGEEETTT\n");
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID, sharedVarName);
  801e1e:	83 ec 08             	sub    $0x8,%esp
  801e21:	ff 75 0c             	pushl  0xc(%ebp)
  801e24:	ff 75 08             	pushl  0x8(%ebp)
  801e27:	e8 71 04 00 00       	call   80229d <sys_getSizeOfSharedObject>
  801e2c:	83 c4 10             	add    $0x10,%esp
  801e2f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (size < 0)
		return NULL;
	uint32 numb_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801e32:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801e39:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801e3c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e3f:	01 d0                	add    %edx,%eax
  801e41:	48                   	dec    %eax
  801e42:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801e45:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e48:	ba 00 00 00 00       	mov    $0x0,%edx
  801e4d:	f7 75 e0             	divl   -0x20(%ebp)
  801e50:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e53:	29 d0                	sub    %edx,%eax
  801e55:	c1 e8 0c             	shr    $0xc,%eax
  801e58:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 free_Pages_Count = 0;
  801e5b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801e62:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
  801e69:	a1 24 50 80 00       	mov    0x805024,%eax
  801e6e:	8b 40 7c             	mov    0x7c(%eax),%eax
  801e71:	05 00 10 00 00       	add    $0x1000,%eax
  801e76:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
  801e79:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801e7e:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801e81:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
  801e84:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  801e8b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801e8e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801e91:	01 d0                	add    %edx,%eax
  801e93:	48                   	dec    %eax
  801e94:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801e97:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801e9a:	ba 00 00 00 00       	mov    $0x0,%edx
  801e9f:	f7 75 cc             	divl   -0x34(%ebp)
  801ea2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801ea5:	29 d0                	sub    %edx,%eax
  801ea7:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801eaa:	76 0a                	jbe    801eb6 <sget+0x9e>
		return NULL;
  801eac:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb1:	e9 f7 00 00 00       	jmp    801fad <sget+0x195>
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801eb6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801eb9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ebc:	eb 48                	jmp    801f06 <sget+0xee>
		uint32 idx = (s - current_Addr) / PAGE_SIZE;
  801ebe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ec1:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801ec4:	c1 e8 0c             	shr    $0xc,%eax
  801ec7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if (!markedPages[idx]) {
  801eca:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801ecd:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  801ed4:	85 c0                	test   %eax,%eax
  801ed6:	75 11                	jne    801ee9 <sget+0xd1>
			free_Pages_Count++;
  801ed8:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801edb:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801edf:	75 16                	jne    801ef7 <sget+0xdf>
				start = s;
  801ee1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ee4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ee7:	eb 0e                	jmp    801ef7 <sget+0xdf>
			}
		} else {
			free_Pages_Count = 0;
  801ee9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  801ef0:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (free_Pages_Count == numb_Of_Pages) {
  801ef7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801efa:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801efd:	74 12                	je     801f11 <sget+0xf9>
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
		return NULL;
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801eff:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801f06:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801f0d:	76 af                	jbe    801ebe <sget+0xa6>
  801f0f:	eb 01                	jmp    801f12 <sget+0xfa>
		} else {
			free_Pages_Count = 0;
			start = (uint32) -1;
		}
		if (free_Pages_Count == numb_Of_Pages) {
			break;
  801f11:	90                   	nop
		}
	}
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
  801f12:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801f16:	74 08                	je     801f20 <sget+0x108>
  801f18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f1b:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801f1e:	74 0a                	je     801f2a <sget+0x112>
		return NULL;
  801f20:	b8 00 00 00 00       	mov    $0x0,%eax
  801f25:	e9 83 00 00 00       	jmp    801fad <sget+0x195>
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
  801f2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f2d:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801f30:	c1 e8 0c             	shr    $0xc,%eax
  801f33:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numb_Of_Pages;
  801f36:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801f39:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801f3c:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  801f43:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801f46:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801f49:	eb 11                	jmp    801f5c <sget+0x144>
		markedPages[k] = 1;
  801f4b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f4e:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  801f55:	01 00 00 00 
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
	pagesAllocated[startPage] = numb_Of_Pages;
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  801f59:	ff 45 e8             	incl   -0x18(%ebp)
  801f5c:	8b 55 c0             	mov    -0x40(%ebp),%edx
  801f5f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801f62:	01 d0                	add    %edx,%eax
  801f64:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801f67:	77 e2                	ja     801f4b <sget+0x133>
		markedPages[k] = 1;
	}
	int ss = sys_getSharedObject(ownerEnvID, sharedVarName, (void*) start);
  801f69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f6c:	83 ec 04             	sub    $0x4,%esp
  801f6f:	50                   	push   %eax
  801f70:	ff 75 0c             	pushl  0xc(%ebp)
  801f73:	ff 75 08             	pushl  0x8(%ebp)
  801f76:	e8 3f 03 00 00       	call   8022ba <sys_getSharedObject>
  801f7b:	83 c4 10             	add    $0x10,%esp
  801f7e:	89 45 bc             	mov    %eax,-0x44(%ebp)
	if (ss >= 0) {
  801f81:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  801f85:	78 12                	js     801f99 <sget+0x181>
		shardIDs[startPage] = ss;
  801f87:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801f8a:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801f8d:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  801f94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f97:	eb 14                	jmp    801fad <sget+0x195>
	}
	free((void*) start);
  801f99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f9c:	83 ec 0c             	sub    $0xc,%esp
  801f9f:	50                   	push   %eax
  801fa0:	e8 d7 fb ff ff       	call   801b7c <free>
  801fa5:	83 c4 10             	add    $0x10,%esp
	return NULL;
  801fa8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fad:	c9                   	leave  
  801fae:	c3                   	ret    

00801faf <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  801faf:	55                   	push   %ebp
  801fb0:	89 e5                	mov    %esp,%ebp
  801fb2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  801fb5:	8b 55 08             	mov    0x8(%ebp),%edx
  801fb8:	a1 24 50 80 00       	mov    0x805024,%eax
  801fbd:	8b 40 7c             	mov    0x7c(%eax),%eax
  801fc0:	29 c2                	sub    %eax,%edx
  801fc2:	89 d0                	mov    %edx,%eax
  801fc4:	2d 00 10 00 00       	sub    $0x1000,%eax

void sfree(void* virtual_address) {
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
  801fc9:	c1 e8 0c             	shr    $0xc,%eax
  801fcc:	89 45 f4             	mov    %eax,-0xc(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
	int id = shardIDs[pageIdx];
  801fcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd2:	8b 04 85 40 50 88 00 	mov    0x885040(,%eax,4),%eax
  801fd9:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int result = sys_freeSharedObject(id, virtual_address);
  801fdc:	83 ec 08             	sub    $0x8,%esp
  801fdf:	ff 75 08             	pushl  0x8(%ebp)
  801fe2:	ff 75 f0             	pushl  -0x10(%ebp)
  801fe5:	e8 ef 02 00 00       	call   8022d9 <sys_freeSharedObject>
  801fea:	83 c4 10             	add    $0x10,%esp
  801fed:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (result == 0) {
  801ff0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ff4:	75 0e                	jne    802004 <sfree+0x55>
		shardIDs[pageIdx] = -1;  // Reset the ID after freeing
  801ff6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff9:	c7 04 85 40 50 88 00 	movl   $0xffffffff,0x885040(,%eax,4)
  802000:	ff ff ff ff 
	}

}
  802004:	90                   	nop
  802005:	c9                   	leave  
  802006:	c3                   	ret    

00802007 <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  802007:	55                   	push   %ebp
  802008:	89 e5                	mov    %esp,%ebp
  80200a:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80200d:	83 ec 04             	sub    $0x4,%esp
  802010:	68 14 44 80 00       	push   $0x804414
  802015:	68 19 01 00 00       	push   $0x119
  80201a:	68 06 44 80 00       	push   $0x804406
  80201f:	e8 2d e7 ff ff       	call   800751 <_panic>

00802024 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  802024:	55                   	push   %ebp
  802025:	89 e5                	mov    %esp,%ebp
  802027:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80202a:	83 ec 04             	sub    $0x4,%esp
  80202d:	68 3a 44 80 00       	push   $0x80443a
  802032:	68 23 01 00 00       	push   $0x123
  802037:	68 06 44 80 00       	push   $0x804406
  80203c:	e8 10 e7 ff ff       	call   800751 <_panic>

00802041 <shrink>:

}
void shrink(uint32 newSize) {
  802041:	55                   	push   %ebp
  802042:	89 e5                	mov    %esp,%ebp
  802044:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802047:	83 ec 04             	sub    $0x4,%esp
  80204a:	68 3a 44 80 00       	push   $0x80443a
  80204f:	68 27 01 00 00       	push   $0x127
  802054:	68 06 44 80 00       	push   $0x804406
  802059:	e8 f3 e6 ff ff       	call   800751 <_panic>

0080205e <freeHeap>:

}
void freeHeap(void* virtual_address) {
  80205e:	55                   	push   %ebp
  80205f:	89 e5                	mov    %esp,%ebp
  802061:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802064:	83 ec 04             	sub    $0x4,%esp
  802067:	68 3a 44 80 00       	push   $0x80443a
  80206c:	68 2b 01 00 00       	push   $0x12b
  802071:	68 06 44 80 00       	push   $0x804406
  802076:	e8 d6 e6 ff ff       	call   800751 <_panic>

0080207b <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  80207b:	55                   	push   %ebp
  80207c:	89 e5                	mov    %esp,%ebp
  80207e:	57                   	push   %edi
  80207f:	56                   	push   %esi
  802080:	53                   	push   %ebx
  802081:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802084:	8b 45 08             	mov    0x8(%ebp),%eax
  802087:	8b 55 0c             	mov    0xc(%ebp),%edx
  80208a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80208d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802090:	8b 7d 18             	mov    0x18(%ebp),%edi
  802093:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802096:	cd 30                	int    $0x30
  802098:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  80209b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80209e:	83 c4 10             	add    $0x10,%esp
  8020a1:	5b                   	pop    %ebx
  8020a2:	5e                   	pop    %esi
  8020a3:	5f                   	pop    %edi
  8020a4:	5d                   	pop    %ebp
  8020a5:	c3                   	ret    

008020a6 <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  8020a6:	55                   	push   %ebp
  8020a7:	89 e5                	mov    %esp,%ebp
  8020a9:	83 ec 04             	sub    $0x4,%esp
  8020ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8020af:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  8020b2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8020b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b9:	6a 00                	push   $0x0
  8020bb:	6a 00                	push   $0x0
  8020bd:	52                   	push   %edx
  8020be:	ff 75 0c             	pushl  0xc(%ebp)
  8020c1:	50                   	push   %eax
  8020c2:	6a 00                	push   $0x0
  8020c4:	e8 b2 ff ff ff       	call   80207b <syscall>
  8020c9:	83 c4 18             	add    $0x18,%esp
}
  8020cc:	90                   	nop
  8020cd:	c9                   	leave  
  8020ce:	c3                   	ret    

008020cf <sys_cgetc>:

int sys_cgetc(void) {
  8020cf:	55                   	push   %ebp
  8020d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8020d2:	6a 00                	push   $0x0
  8020d4:	6a 00                	push   $0x0
  8020d6:	6a 00                	push   $0x0
  8020d8:	6a 00                	push   $0x0
  8020da:	6a 00                	push   $0x0
  8020dc:	6a 02                	push   $0x2
  8020de:	e8 98 ff ff ff       	call   80207b <syscall>
  8020e3:	83 c4 18             	add    $0x18,%esp
}
  8020e6:	c9                   	leave  
  8020e7:	c3                   	ret    

008020e8 <sys_lock_cons>:

void sys_lock_cons(void) {
  8020e8:	55                   	push   %ebp
  8020e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8020eb:	6a 00                	push   $0x0
  8020ed:	6a 00                	push   $0x0
  8020ef:	6a 00                	push   $0x0
  8020f1:	6a 00                	push   $0x0
  8020f3:	6a 00                	push   $0x0
  8020f5:	6a 03                	push   $0x3
  8020f7:	e8 7f ff ff ff       	call   80207b <syscall>
  8020fc:	83 c4 18             	add    $0x18,%esp
}
  8020ff:	90                   	nop
  802100:	c9                   	leave  
  802101:	c3                   	ret    

00802102 <sys_unlock_cons>:
void sys_unlock_cons(void) {
  802102:	55                   	push   %ebp
  802103:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802105:	6a 00                	push   $0x0
  802107:	6a 00                	push   $0x0
  802109:	6a 00                	push   $0x0
  80210b:	6a 00                	push   $0x0
  80210d:	6a 00                	push   $0x0
  80210f:	6a 04                	push   $0x4
  802111:	e8 65 ff ff ff       	call   80207b <syscall>
  802116:	83 c4 18             	add    $0x18,%esp
}
  802119:	90                   	nop
  80211a:	c9                   	leave  
  80211b:	c3                   	ret    

0080211c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  80211c:	55                   	push   %ebp
  80211d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  80211f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802122:	8b 45 08             	mov    0x8(%ebp),%eax
  802125:	6a 00                	push   $0x0
  802127:	6a 00                	push   $0x0
  802129:	6a 00                	push   $0x0
  80212b:	52                   	push   %edx
  80212c:	50                   	push   %eax
  80212d:	6a 08                	push   $0x8
  80212f:	e8 47 ff ff ff       	call   80207b <syscall>
  802134:	83 c4 18             	add    $0x18,%esp
}
  802137:	c9                   	leave  
  802138:	c3                   	ret    

00802139 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  802139:	55                   	push   %ebp
  80213a:	89 e5                	mov    %esp,%ebp
  80213c:	56                   	push   %esi
  80213d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  80213e:	8b 75 18             	mov    0x18(%ebp),%esi
  802141:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802144:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802147:	8b 55 0c             	mov    0xc(%ebp),%edx
  80214a:	8b 45 08             	mov    0x8(%ebp),%eax
  80214d:	56                   	push   %esi
  80214e:	53                   	push   %ebx
  80214f:	51                   	push   %ecx
  802150:	52                   	push   %edx
  802151:	50                   	push   %eax
  802152:	6a 09                	push   $0x9
  802154:	e8 22 ff ff ff       	call   80207b <syscall>
  802159:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  80215c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80215f:	5b                   	pop    %ebx
  802160:	5e                   	pop    %esi
  802161:	5d                   	pop    %ebp
  802162:	c3                   	ret    

00802163 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  802163:	55                   	push   %ebp
  802164:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802166:	8b 55 0c             	mov    0xc(%ebp),%edx
  802169:	8b 45 08             	mov    0x8(%ebp),%eax
  80216c:	6a 00                	push   $0x0
  80216e:	6a 00                	push   $0x0
  802170:	6a 00                	push   $0x0
  802172:	52                   	push   %edx
  802173:	50                   	push   %eax
  802174:	6a 0a                	push   $0xa
  802176:	e8 00 ff ff ff       	call   80207b <syscall>
  80217b:	83 c4 18             	add    $0x18,%esp
}
  80217e:	c9                   	leave  
  80217f:	c3                   	ret    

00802180 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  802180:	55                   	push   %ebp
  802181:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  802183:	6a 00                	push   $0x0
  802185:	6a 00                	push   $0x0
  802187:	6a 00                	push   $0x0
  802189:	ff 75 0c             	pushl  0xc(%ebp)
  80218c:	ff 75 08             	pushl  0x8(%ebp)
  80218f:	6a 0b                	push   $0xb
  802191:	e8 e5 fe ff ff       	call   80207b <syscall>
  802196:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  802199:	c9                   	leave  
  80219a:	c3                   	ret    

0080219b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  80219b:	55                   	push   %ebp
  80219c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80219e:	6a 00                	push   $0x0
  8021a0:	6a 00                	push   $0x0
  8021a2:	6a 00                	push   $0x0
  8021a4:	6a 00                	push   $0x0
  8021a6:	6a 00                	push   $0x0
  8021a8:	6a 0c                	push   $0xc
  8021aa:	e8 cc fe ff ff       	call   80207b <syscall>
  8021af:	83 c4 18             	add    $0x18,%esp
}
  8021b2:	c9                   	leave  
  8021b3:	c3                   	ret    

008021b4 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  8021b4:	55                   	push   %ebp
  8021b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8021b7:	6a 00                	push   $0x0
  8021b9:	6a 00                	push   $0x0
  8021bb:	6a 00                	push   $0x0
  8021bd:	6a 00                	push   $0x0
  8021bf:	6a 00                	push   $0x0
  8021c1:	6a 0d                	push   $0xd
  8021c3:	e8 b3 fe ff ff       	call   80207b <syscall>
  8021c8:	83 c4 18             	add    $0x18,%esp
}
  8021cb:	c9                   	leave  
  8021cc:	c3                   	ret    

008021cd <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  8021cd:	55                   	push   %ebp
  8021ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8021d0:	6a 00                	push   $0x0
  8021d2:	6a 00                	push   $0x0
  8021d4:	6a 00                	push   $0x0
  8021d6:	6a 00                	push   $0x0
  8021d8:	6a 00                	push   $0x0
  8021da:	6a 0e                	push   $0xe
  8021dc:	e8 9a fe ff ff       	call   80207b <syscall>
  8021e1:	83 c4 18             	add    $0x18,%esp
}
  8021e4:	c9                   	leave  
  8021e5:	c3                   	ret    

008021e6 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  8021e6:	55                   	push   %ebp
  8021e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  8021e9:	6a 00                	push   $0x0
  8021eb:	6a 00                	push   $0x0
  8021ed:	6a 00                	push   $0x0
  8021ef:	6a 00                	push   $0x0
  8021f1:	6a 00                	push   $0x0
  8021f3:	6a 0f                	push   $0xf
  8021f5:	e8 81 fe ff ff       	call   80207b <syscall>
  8021fa:	83 c4 18             	add    $0x18,%esp
}
  8021fd:	c9                   	leave  
  8021fe:	c3                   	ret    

008021ff <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  8021ff:	55                   	push   %ebp
  802200:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  802202:	6a 00                	push   $0x0
  802204:	6a 00                	push   $0x0
  802206:	6a 00                	push   $0x0
  802208:	6a 00                	push   $0x0
  80220a:	ff 75 08             	pushl  0x8(%ebp)
  80220d:	6a 10                	push   $0x10
  80220f:	e8 67 fe ff ff       	call   80207b <syscall>
  802214:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  802217:	c9                   	leave  
  802218:	c3                   	ret    

00802219 <sys_scarce_memory>:

void sys_scarce_memory() {
  802219:	55                   	push   %ebp
  80221a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  80221c:	6a 00                	push   $0x0
  80221e:	6a 00                	push   $0x0
  802220:	6a 00                	push   $0x0
  802222:	6a 00                	push   $0x0
  802224:	6a 00                	push   $0x0
  802226:	6a 11                	push   $0x11
  802228:	e8 4e fe ff ff       	call   80207b <syscall>
  80222d:	83 c4 18             	add    $0x18,%esp
}
  802230:	90                   	nop
  802231:	c9                   	leave  
  802232:	c3                   	ret    

00802233 <sys_cputc>:

void sys_cputc(const char c) {
  802233:	55                   	push   %ebp
  802234:	89 e5                	mov    %esp,%ebp
  802236:	83 ec 04             	sub    $0x4,%esp
  802239:	8b 45 08             	mov    0x8(%ebp),%eax
  80223c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80223f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802243:	6a 00                	push   $0x0
  802245:	6a 00                	push   $0x0
  802247:	6a 00                	push   $0x0
  802249:	6a 00                	push   $0x0
  80224b:	50                   	push   %eax
  80224c:	6a 01                	push   $0x1
  80224e:	e8 28 fe ff ff       	call   80207b <syscall>
  802253:	83 c4 18             	add    $0x18,%esp
}
  802256:	90                   	nop
  802257:	c9                   	leave  
  802258:	c3                   	ret    

00802259 <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  802259:	55                   	push   %ebp
  80225a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  80225c:	6a 00                	push   $0x0
  80225e:	6a 00                	push   $0x0
  802260:	6a 00                	push   $0x0
  802262:	6a 00                	push   $0x0
  802264:	6a 00                	push   $0x0
  802266:	6a 14                	push   $0x14
  802268:	e8 0e fe ff ff       	call   80207b <syscall>
  80226d:	83 c4 18             	add    $0x18,%esp
}
  802270:	90                   	nop
  802271:	c9                   	leave  
  802272:	c3                   	ret    

00802273 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  802273:	55                   	push   %ebp
  802274:	89 e5                	mov    %esp,%ebp
  802276:	83 ec 04             	sub    $0x4,%esp
  802279:	8b 45 10             	mov    0x10(%ebp),%eax
  80227c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  80227f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802282:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802286:	8b 45 08             	mov    0x8(%ebp),%eax
  802289:	6a 00                	push   $0x0
  80228b:	51                   	push   %ecx
  80228c:	52                   	push   %edx
  80228d:	ff 75 0c             	pushl  0xc(%ebp)
  802290:	50                   	push   %eax
  802291:	6a 15                	push   $0x15
  802293:	e8 e3 fd ff ff       	call   80207b <syscall>
  802298:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  80229b:	c9                   	leave  
  80229c:	c3                   	ret    

0080229d <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  80229d:	55                   	push   %ebp
  80229e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  8022a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a6:	6a 00                	push   $0x0
  8022a8:	6a 00                	push   $0x0
  8022aa:	6a 00                	push   $0x0
  8022ac:	52                   	push   %edx
  8022ad:	50                   	push   %eax
  8022ae:	6a 16                	push   $0x16
  8022b0:	e8 c6 fd ff ff       	call   80207b <syscall>
  8022b5:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  8022b8:	c9                   	leave  
  8022b9:	c3                   	ret    

008022ba <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  8022ba:	55                   	push   %ebp
  8022bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  8022bd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c6:	6a 00                	push   $0x0
  8022c8:	6a 00                	push   $0x0
  8022ca:	51                   	push   %ecx
  8022cb:	52                   	push   %edx
  8022cc:	50                   	push   %eax
  8022cd:	6a 17                	push   $0x17
  8022cf:	e8 a7 fd ff ff       	call   80207b <syscall>
  8022d4:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  8022d7:	c9                   	leave  
  8022d8:	c3                   	ret    

008022d9 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  8022d9:	55                   	push   %ebp
  8022da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  8022dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022df:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e2:	6a 00                	push   $0x0
  8022e4:	6a 00                	push   $0x0
  8022e6:	6a 00                	push   $0x0
  8022e8:	52                   	push   %edx
  8022e9:	50                   	push   %eax
  8022ea:	6a 18                	push   $0x18
  8022ec:	e8 8a fd ff ff       	call   80207b <syscall>
  8022f1:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  8022f4:	c9                   	leave  
  8022f5:	c3                   	ret    

008022f6 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  8022f6:	55                   	push   %ebp
  8022f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  8022f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fc:	6a 00                	push   $0x0
  8022fe:	ff 75 14             	pushl  0x14(%ebp)
  802301:	ff 75 10             	pushl  0x10(%ebp)
  802304:	ff 75 0c             	pushl  0xc(%ebp)
  802307:	50                   	push   %eax
  802308:	6a 19                	push   $0x19
  80230a:	e8 6c fd ff ff       	call   80207b <syscall>
  80230f:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  802312:	c9                   	leave  
  802313:	c3                   	ret    

00802314 <sys_run_env>:

void sys_run_env(int32 envId) {
  802314:	55                   	push   %ebp
  802315:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  802317:	8b 45 08             	mov    0x8(%ebp),%eax
  80231a:	6a 00                	push   $0x0
  80231c:	6a 00                	push   $0x0
  80231e:	6a 00                	push   $0x0
  802320:	6a 00                	push   $0x0
  802322:	50                   	push   %eax
  802323:	6a 1a                	push   $0x1a
  802325:	e8 51 fd ff ff       	call   80207b <syscall>
  80232a:	83 c4 18             	add    $0x18,%esp
}
  80232d:	90                   	nop
  80232e:	c9                   	leave  
  80232f:	c3                   	ret    

00802330 <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  802330:	55                   	push   %ebp
  802331:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802333:	8b 45 08             	mov    0x8(%ebp),%eax
  802336:	6a 00                	push   $0x0
  802338:	6a 00                	push   $0x0
  80233a:	6a 00                	push   $0x0
  80233c:	6a 00                	push   $0x0
  80233e:	50                   	push   %eax
  80233f:	6a 1b                	push   $0x1b
  802341:	e8 35 fd ff ff       	call   80207b <syscall>
  802346:	83 c4 18             	add    $0x18,%esp
}
  802349:	c9                   	leave  
  80234a:	c3                   	ret    

0080234b <sys_getenvid>:

int32 sys_getenvid(void) {
  80234b:	55                   	push   %ebp
  80234c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80234e:	6a 00                	push   $0x0
  802350:	6a 00                	push   $0x0
  802352:	6a 00                	push   $0x0
  802354:	6a 00                	push   $0x0
  802356:	6a 00                	push   $0x0
  802358:	6a 05                	push   $0x5
  80235a:	e8 1c fd ff ff       	call   80207b <syscall>
  80235f:	83 c4 18             	add    $0x18,%esp
}
  802362:	c9                   	leave  
  802363:	c3                   	ret    

00802364 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  802364:	55                   	push   %ebp
  802365:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802367:	6a 00                	push   $0x0
  802369:	6a 00                	push   $0x0
  80236b:	6a 00                	push   $0x0
  80236d:	6a 00                	push   $0x0
  80236f:	6a 00                	push   $0x0
  802371:	6a 06                	push   $0x6
  802373:	e8 03 fd ff ff       	call   80207b <syscall>
  802378:	83 c4 18             	add    $0x18,%esp
}
  80237b:	c9                   	leave  
  80237c:	c3                   	ret    

0080237d <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  80237d:	55                   	push   %ebp
  80237e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802380:	6a 00                	push   $0x0
  802382:	6a 00                	push   $0x0
  802384:	6a 00                	push   $0x0
  802386:	6a 00                	push   $0x0
  802388:	6a 00                	push   $0x0
  80238a:	6a 07                	push   $0x7
  80238c:	e8 ea fc ff ff       	call   80207b <syscall>
  802391:	83 c4 18             	add    $0x18,%esp
}
  802394:	c9                   	leave  
  802395:	c3                   	ret    

00802396 <sys_exit_env>:

void sys_exit_env(void) {
  802396:	55                   	push   %ebp
  802397:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802399:	6a 00                	push   $0x0
  80239b:	6a 00                	push   $0x0
  80239d:	6a 00                	push   $0x0
  80239f:	6a 00                	push   $0x0
  8023a1:	6a 00                	push   $0x0
  8023a3:	6a 1c                	push   $0x1c
  8023a5:	e8 d1 fc ff ff       	call   80207b <syscall>
  8023aa:	83 c4 18             	add    $0x18,%esp
}
  8023ad:	90                   	nop
  8023ae:	c9                   	leave  
  8023af:	c3                   	ret    

008023b0 <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  8023b0:	55                   	push   %ebp
  8023b1:	89 e5                	mov    %esp,%ebp
  8023b3:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  8023b6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8023b9:	8d 50 04             	lea    0x4(%eax),%edx
  8023bc:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8023bf:	6a 00                	push   $0x0
  8023c1:	6a 00                	push   $0x0
  8023c3:	6a 00                	push   $0x0
  8023c5:	52                   	push   %edx
  8023c6:	50                   	push   %eax
  8023c7:	6a 1d                	push   $0x1d
  8023c9:	e8 ad fc ff ff       	call   80207b <syscall>
  8023ce:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  8023d1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8023d7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8023da:	89 01                	mov    %eax,(%ecx)
  8023dc:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8023df:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e2:	c9                   	leave  
  8023e3:	c2 04 00             	ret    $0x4

008023e6 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  8023e6:	55                   	push   %ebp
  8023e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  8023e9:	6a 00                	push   $0x0
  8023eb:	6a 00                	push   $0x0
  8023ed:	ff 75 10             	pushl  0x10(%ebp)
  8023f0:	ff 75 0c             	pushl  0xc(%ebp)
  8023f3:	ff 75 08             	pushl  0x8(%ebp)
  8023f6:	6a 13                	push   $0x13
  8023f8:	e8 7e fc ff ff       	call   80207b <syscall>
  8023fd:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  802400:	90                   	nop
}
  802401:	c9                   	leave  
  802402:	c3                   	ret    

00802403 <sys_rcr2>:
uint32 sys_rcr2() {
  802403:	55                   	push   %ebp
  802404:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802406:	6a 00                	push   $0x0
  802408:	6a 00                	push   $0x0
  80240a:	6a 00                	push   $0x0
  80240c:	6a 00                	push   $0x0
  80240e:	6a 00                	push   $0x0
  802410:	6a 1e                	push   $0x1e
  802412:	e8 64 fc ff ff       	call   80207b <syscall>
  802417:	83 c4 18             	add    $0x18,%esp
}
  80241a:	c9                   	leave  
  80241b:	c3                   	ret    

0080241c <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  80241c:	55                   	push   %ebp
  80241d:	89 e5                	mov    %esp,%ebp
  80241f:	83 ec 04             	sub    $0x4,%esp
  802422:	8b 45 08             	mov    0x8(%ebp),%eax
  802425:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802428:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80242c:	6a 00                	push   $0x0
  80242e:	6a 00                	push   $0x0
  802430:	6a 00                	push   $0x0
  802432:	6a 00                	push   $0x0
  802434:	50                   	push   %eax
  802435:	6a 1f                	push   $0x1f
  802437:	e8 3f fc ff ff       	call   80207b <syscall>
  80243c:	83 c4 18             	add    $0x18,%esp
	return;
  80243f:	90                   	nop
}
  802440:	c9                   	leave  
  802441:	c3                   	ret    

00802442 <rsttst>:
void rsttst() {
  802442:	55                   	push   %ebp
  802443:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802445:	6a 00                	push   $0x0
  802447:	6a 00                	push   $0x0
  802449:	6a 00                	push   $0x0
  80244b:	6a 00                	push   $0x0
  80244d:	6a 00                	push   $0x0
  80244f:	6a 21                	push   $0x21
  802451:	e8 25 fc ff ff       	call   80207b <syscall>
  802456:	83 c4 18             	add    $0x18,%esp
	return;
  802459:	90                   	nop
}
  80245a:	c9                   	leave  
  80245b:	c3                   	ret    

0080245c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  80245c:	55                   	push   %ebp
  80245d:	89 e5                	mov    %esp,%ebp
  80245f:	83 ec 04             	sub    $0x4,%esp
  802462:	8b 45 14             	mov    0x14(%ebp),%eax
  802465:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802468:	8b 55 18             	mov    0x18(%ebp),%edx
  80246b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80246f:	52                   	push   %edx
  802470:	50                   	push   %eax
  802471:	ff 75 10             	pushl  0x10(%ebp)
  802474:	ff 75 0c             	pushl  0xc(%ebp)
  802477:	ff 75 08             	pushl  0x8(%ebp)
  80247a:	6a 20                	push   $0x20
  80247c:	e8 fa fb ff ff       	call   80207b <syscall>
  802481:	83 c4 18             	add    $0x18,%esp
	return;
  802484:	90                   	nop
}
  802485:	c9                   	leave  
  802486:	c3                   	ret    

00802487 <chktst>:
void chktst(uint32 n) {
  802487:	55                   	push   %ebp
  802488:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80248a:	6a 00                	push   $0x0
  80248c:	6a 00                	push   $0x0
  80248e:	6a 00                	push   $0x0
  802490:	6a 00                	push   $0x0
  802492:	ff 75 08             	pushl  0x8(%ebp)
  802495:	6a 22                	push   $0x22
  802497:	e8 df fb ff ff       	call   80207b <syscall>
  80249c:	83 c4 18             	add    $0x18,%esp
	return;
  80249f:	90                   	nop
}
  8024a0:	c9                   	leave  
  8024a1:	c3                   	ret    

008024a2 <inctst>:

void inctst() {
  8024a2:	55                   	push   %ebp
  8024a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8024a5:	6a 00                	push   $0x0
  8024a7:	6a 00                	push   $0x0
  8024a9:	6a 00                	push   $0x0
  8024ab:	6a 00                	push   $0x0
  8024ad:	6a 00                	push   $0x0
  8024af:	6a 23                	push   $0x23
  8024b1:	e8 c5 fb ff ff       	call   80207b <syscall>
  8024b6:	83 c4 18             	add    $0x18,%esp
	return;
  8024b9:	90                   	nop
}
  8024ba:	c9                   	leave  
  8024bb:	c3                   	ret    

008024bc <gettst>:
uint32 gettst() {
  8024bc:	55                   	push   %ebp
  8024bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8024bf:	6a 00                	push   $0x0
  8024c1:	6a 00                	push   $0x0
  8024c3:	6a 00                	push   $0x0
  8024c5:	6a 00                	push   $0x0
  8024c7:	6a 00                	push   $0x0
  8024c9:	6a 24                	push   $0x24
  8024cb:	e8 ab fb ff ff       	call   80207b <syscall>
  8024d0:	83 c4 18             	add    $0x18,%esp
}
  8024d3:	c9                   	leave  
  8024d4:	c3                   	ret    

008024d5 <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  8024d5:	55                   	push   %ebp
  8024d6:	89 e5                	mov    %esp,%ebp
  8024d8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024db:	6a 00                	push   $0x0
  8024dd:	6a 00                	push   $0x0
  8024df:	6a 00                	push   $0x0
  8024e1:	6a 00                	push   $0x0
  8024e3:	6a 00                	push   $0x0
  8024e5:	6a 25                	push   $0x25
  8024e7:	e8 8f fb ff ff       	call   80207b <syscall>
  8024ec:	83 c4 18             	add    $0x18,%esp
  8024ef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8024f2:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8024f6:	75 07                	jne    8024ff <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8024f8:	b8 01 00 00 00       	mov    $0x1,%eax
  8024fd:	eb 05                	jmp    802504 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8024ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802504:	c9                   	leave  
  802505:	c3                   	ret    

00802506 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  802506:	55                   	push   %ebp
  802507:	89 e5                	mov    %esp,%ebp
  802509:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80250c:	6a 00                	push   $0x0
  80250e:	6a 00                	push   $0x0
  802510:	6a 00                	push   $0x0
  802512:	6a 00                	push   $0x0
  802514:	6a 00                	push   $0x0
  802516:	6a 25                	push   $0x25
  802518:	e8 5e fb ff ff       	call   80207b <syscall>
  80251d:	83 c4 18             	add    $0x18,%esp
  802520:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802523:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802527:	75 07                	jne    802530 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802529:	b8 01 00 00 00       	mov    $0x1,%eax
  80252e:	eb 05                	jmp    802535 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802530:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802535:	c9                   	leave  
  802536:	c3                   	ret    

00802537 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  802537:	55                   	push   %ebp
  802538:	89 e5                	mov    %esp,%ebp
  80253a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80253d:	6a 00                	push   $0x0
  80253f:	6a 00                	push   $0x0
  802541:	6a 00                	push   $0x0
  802543:	6a 00                	push   $0x0
  802545:	6a 00                	push   $0x0
  802547:	6a 25                	push   $0x25
  802549:	e8 2d fb ff ff       	call   80207b <syscall>
  80254e:	83 c4 18             	add    $0x18,%esp
  802551:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802554:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802558:	75 07                	jne    802561 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80255a:	b8 01 00 00 00       	mov    $0x1,%eax
  80255f:	eb 05                	jmp    802566 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802561:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802566:	c9                   	leave  
  802567:	c3                   	ret    

00802568 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  802568:	55                   	push   %ebp
  802569:	89 e5                	mov    %esp,%ebp
  80256b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80256e:	6a 00                	push   $0x0
  802570:	6a 00                	push   $0x0
  802572:	6a 00                	push   $0x0
  802574:	6a 00                	push   $0x0
  802576:	6a 00                	push   $0x0
  802578:	6a 25                	push   $0x25
  80257a:	e8 fc fa ff ff       	call   80207b <syscall>
  80257f:	83 c4 18             	add    $0x18,%esp
  802582:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802585:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802589:	75 07                	jne    802592 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80258b:	b8 01 00 00 00       	mov    $0x1,%eax
  802590:	eb 05                	jmp    802597 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802592:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802597:	c9                   	leave  
  802598:	c3                   	ret    

00802599 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  802599:	55                   	push   %ebp
  80259a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80259c:	6a 00                	push   $0x0
  80259e:	6a 00                	push   $0x0
  8025a0:	6a 00                	push   $0x0
  8025a2:	6a 00                	push   $0x0
  8025a4:	ff 75 08             	pushl  0x8(%ebp)
  8025a7:	6a 26                	push   $0x26
  8025a9:	e8 cd fa ff ff       	call   80207b <syscall>
  8025ae:	83 c4 18             	add    $0x18,%esp
	return;
  8025b1:	90                   	nop
}
  8025b2:	c9                   	leave  
  8025b3:	c3                   	ret    

008025b4 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  8025b4:	55                   	push   %ebp
  8025b5:	89 e5                	mov    %esp,%ebp
  8025b7:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  8025b8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8025bb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8025be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c4:	6a 00                	push   $0x0
  8025c6:	53                   	push   %ebx
  8025c7:	51                   	push   %ecx
  8025c8:	52                   	push   %edx
  8025c9:	50                   	push   %eax
  8025ca:	6a 27                	push   $0x27
  8025cc:	e8 aa fa ff ff       	call   80207b <syscall>
  8025d1:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  8025d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8025d7:	c9                   	leave  
  8025d8:	c3                   	ret    

008025d9 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  8025d9:	55                   	push   %ebp
  8025da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  8025dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025df:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e2:	6a 00                	push   $0x0
  8025e4:	6a 00                	push   $0x0
  8025e6:	6a 00                	push   $0x0
  8025e8:	52                   	push   %edx
  8025e9:	50                   	push   %eax
  8025ea:	6a 28                	push   $0x28
  8025ec:	e8 8a fa ff ff       	call   80207b <syscall>
  8025f1:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  8025f4:	c9                   	leave  
  8025f5:	c3                   	ret    

008025f6 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  8025f6:	55                   	push   %ebp
  8025f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  8025f9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8025fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802602:	6a 00                	push   $0x0
  802604:	51                   	push   %ecx
  802605:	ff 75 10             	pushl  0x10(%ebp)
  802608:	52                   	push   %edx
  802609:	50                   	push   %eax
  80260a:	6a 29                	push   $0x29
  80260c:	e8 6a fa ff ff       	call   80207b <syscall>
  802611:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  802614:	c9                   	leave  
  802615:	c3                   	ret    

00802616 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  802616:	55                   	push   %ebp
  802617:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802619:	6a 00                	push   $0x0
  80261b:	6a 00                	push   $0x0
  80261d:	ff 75 10             	pushl  0x10(%ebp)
  802620:	ff 75 0c             	pushl  0xc(%ebp)
  802623:	ff 75 08             	pushl  0x8(%ebp)
  802626:	6a 12                	push   $0x12
  802628:	e8 4e fa ff ff       	call   80207b <syscall>
  80262d:	83 c4 18             	add    $0x18,%esp
	return;
  802630:	90                   	nop
}
  802631:	c9                   	leave  
  802632:	c3                   	ret    

00802633 <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  802633:	55                   	push   %ebp
  802634:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  802636:	8b 55 0c             	mov    0xc(%ebp),%edx
  802639:	8b 45 08             	mov    0x8(%ebp),%eax
  80263c:	6a 00                	push   $0x0
  80263e:	6a 00                	push   $0x0
  802640:	6a 00                	push   $0x0
  802642:	52                   	push   %edx
  802643:	50                   	push   %eax
  802644:	6a 2a                	push   $0x2a
  802646:	e8 30 fa ff ff       	call   80207b <syscall>
  80264b:	83 c4 18             	add    $0x18,%esp
	return;
  80264e:	90                   	nop
}
  80264f:	c9                   	leave  
  802650:	c3                   	ret    

00802651 <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  802651:	55                   	push   %ebp
  802652:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  802654:	8b 45 08             	mov    0x8(%ebp),%eax
  802657:	6a 00                	push   $0x0
  802659:	6a 00                	push   $0x0
  80265b:	6a 00                	push   $0x0
  80265d:	6a 00                	push   $0x0
  80265f:	50                   	push   %eax
  802660:	6a 2b                	push   $0x2b
  802662:	e8 14 fa ff ff       	call   80207b <syscall>
  802667:	83 c4 18             	add    $0x18,%esp
}
  80266a:	c9                   	leave  
  80266b:	c3                   	ret    

0080266c <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  80266c:	55                   	push   %ebp
  80266d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80266f:	6a 00                	push   $0x0
  802671:	6a 00                	push   $0x0
  802673:	6a 00                	push   $0x0
  802675:	ff 75 0c             	pushl  0xc(%ebp)
  802678:	ff 75 08             	pushl  0x8(%ebp)
  80267b:	6a 2c                	push   $0x2c
  80267d:	e8 f9 f9 ff ff       	call   80207b <syscall>
  802682:	83 c4 18             	add    $0x18,%esp
	return;
  802685:	90                   	nop
}
  802686:	c9                   	leave  
  802687:	c3                   	ret    

00802688 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  802688:	55                   	push   %ebp
  802689:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80268b:	6a 00                	push   $0x0
  80268d:	6a 00                	push   $0x0
  80268f:	6a 00                	push   $0x0
  802691:	ff 75 0c             	pushl  0xc(%ebp)
  802694:	ff 75 08             	pushl  0x8(%ebp)
  802697:	6a 2d                	push   $0x2d
  802699:	e8 dd f9 ff ff       	call   80207b <syscall>
  80269e:	83 c4 18             	add    $0x18,%esp
	return;
  8026a1:	90                   	nop
}
  8026a2:	c9                   	leave  
  8026a3:	c3                   	ret    

008026a4 <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  8026a4:	55                   	push   %ebp
  8026a5:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  8026a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026aa:	6a 00                	push   $0x0
  8026ac:	6a 00                	push   $0x0
  8026ae:	6a 00                	push   $0x0
  8026b0:	6a 00                	push   $0x0
  8026b2:	50                   	push   %eax
  8026b3:	6a 2f                	push   $0x2f
  8026b5:	e8 c1 f9 ff ff       	call   80207b <syscall>
  8026ba:	83 c4 18             	add    $0x18,%esp
	return;
  8026bd:	90                   	nop
}
  8026be:	c9                   	leave  
  8026bf:	c3                   	ret    

008026c0 <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  8026c0:	55                   	push   %ebp
  8026c1:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  8026c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c9:	6a 00                	push   $0x0
  8026cb:	6a 00                	push   $0x0
  8026cd:	6a 00                	push   $0x0
  8026cf:	52                   	push   %edx
  8026d0:	50                   	push   %eax
  8026d1:	6a 30                	push   $0x30
  8026d3:	e8 a3 f9 ff ff       	call   80207b <syscall>
  8026d8:	83 c4 18             	add    $0x18,%esp
	return;
  8026db:	90                   	nop
}
  8026dc:	c9                   	leave  
  8026dd:	c3                   	ret    

008026de <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  8026de:	55                   	push   %ebp
  8026df:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  8026e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e4:	6a 00                	push   $0x0
  8026e6:	6a 00                	push   $0x0
  8026e8:	6a 00                	push   $0x0
  8026ea:	6a 00                	push   $0x0
  8026ec:	50                   	push   %eax
  8026ed:	6a 31                	push   $0x31
  8026ef:	e8 87 f9 ff ff       	call   80207b <syscall>
  8026f4:	83 c4 18             	add    $0x18,%esp
	return;
  8026f7:	90                   	nop
}
  8026f8:	c9                   	leave  
  8026f9:	c3                   	ret    

008026fa <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  8026fa:	55                   	push   %ebp
  8026fb:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8026fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802700:	8b 45 08             	mov    0x8(%ebp),%eax
  802703:	6a 00                	push   $0x0
  802705:	6a 00                	push   $0x0
  802707:	6a 00                	push   $0x0
  802709:	52                   	push   %edx
  80270a:	50                   	push   %eax
  80270b:	6a 2e                	push   $0x2e
  80270d:	e8 69 f9 ff ff       	call   80207b <syscall>
  802712:	83 c4 18             	add    $0x18,%esp
    return;
  802715:	90                   	nop
}
  802716:	c9                   	leave  
  802717:	c3                   	ret    

00802718 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802718:	55                   	push   %ebp
  802719:	89 e5                	mov    %esp,%ebp
  80271b:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80271e:	8b 45 08             	mov    0x8(%ebp),%eax
  802721:	83 e8 04             	sub    $0x4,%eax
  802724:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802727:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80272a:	8b 00                	mov    (%eax),%eax
  80272c:	83 e0 fe             	and    $0xfffffffe,%eax
}
  80272f:	c9                   	leave  
  802730:	c3                   	ret    

00802731 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802731:	55                   	push   %ebp
  802732:	89 e5                	mov    %esp,%ebp
  802734:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802737:	8b 45 08             	mov    0x8(%ebp),%eax
  80273a:	83 e8 04             	sub    $0x4,%eax
  80273d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802740:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802743:	8b 00                	mov    (%eax),%eax
  802745:	83 e0 01             	and    $0x1,%eax
  802748:	85 c0                	test   %eax,%eax
  80274a:	0f 94 c0             	sete   %al
}
  80274d:	c9                   	leave  
  80274e:	c3                   	ret    

0080274f <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  80274f:	55                   	push   %ebp
  802750:	89 e5                	mov    %esp,%ebp
  802752:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802755:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  80275c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80275f:	83 f8 02             	cmp    $0x2,%eax
  802762:	74 2b                	je     80278f <alloc_block+0x40>
  802764:	83 f8 02             	cmp    $0x2,%eax
  802767:	7f 07                	jg     802770 <alloc_block+0x21>
  802769:	83 f8 01             	cmp    $0x1,%eax
  80276c:	74 0e                	je     80277c <alloc_block+0x2d>
  80276e:	eb 58                	jmp    8027c8 <alloc_block+0x79>
  802770:	83 f8 03             	cmp    $0x3,%eax
  802773:	74 2d                	je     8027a2 <alloc_block+0x53>
  802775:	83 f8 04             	cmp    $0x4,%eax
  802778:	74 3b                	je     8027b5 <alloc_block+0x66>
  80277a:	eb 4c                	jmp    8027c8 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  80277c:	83 ec 0c             	sub    $0xc,%esp
  80277f:	ff 75 08             	pushl  0x8(%ebp)
  802782:	e8 f7 03 00 00       	call   802b7e <alloc_block_FF>
  802787:	83 c4 10             	add    $0x10,%esp
  80278a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80278d:	eb 4a                	jmp    8027d9 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  80278f:	83 ec 0c             	sub    $0xc,%esp
  802792:	ff 75 08             	pushl  0x8(%ebp)
  802795:	e8 f0 11 00 00       	call   80398a <alloc_block_NF>
  80279a:	83 c4 10             	add    $0x10,%esp
  80279d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8027a0:	eb 37                	jmp    8027d9 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8027a2:	83 ec 0c             	sub    $0xc,%esp
  8027a5:	ff 75 08             	pushl  0x8(%ebp)
  8027a8:	e8 08 08 00 00       	call   802fb5 <alloc_block_BF>
  8027ad:	83 c4 10             	add    $0x10,%esp
  8027b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8027b3:	eb 24                	jmp    8027d9 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8027b5:	83 ec 0c             	sub    $0xc,%esp
  8027b8:	ff 75 08             	pushl  0x8(%ebp)
  8027bb:	e8 ad 11 00 00       	call   80396d <alloc_block_WF>
  8027c0:	83 c4 10             	add    $0x10,%esp
  8027c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8027c6:	eb 11                	jmp    8027d9 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8027c8:	83 ec 0c             	sub    $0xc,%esp
  8027cb:	68 4c 44 80 00       	push   $0x80444c
  8027d0:	e8 39 e2 ff ff       	call   800a0e <cprintf>
  8027d5:	83 c4 10             	add    $0x10,%esp
		break;
  8027d8:	90                   	nop
	}
	return va;
  8027d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8027dc:	c9                   	leave  
  8027dd:	c3                   	ret    

008027de <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8027de:	55                   	push   %ebp
  8027df:	89 e5                	mov    %esp,%ebp
  8027e1:	53                   	push   %ebx
  8027e2:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8027e5:	83 ec 0c             	sub    $0xc,%esp
  8027e8:	68 6c 44 80 00       	push   $0x80446c
  8027ed:	e8 1c e2 ff ff       	call   800a0e <cprintf>
  8027f2:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8027f5:	83 ec 0c             	sub    $0xc,%esp
  8027f8:	68 97 44 80 00       	push   $0x804497
  8027fd:	e8 0c e2 ff ff       	call   800a0e <cprintf>
  802802:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802805:	8b 45 08             	mov    0x8(%ebp),%eax
  802808:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80280b:	eb 37                	jmp    802844 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  80280d:	83 ec 0c             	sub    $0xc,%esp
  802810:	ff 75 f4             	pushl  -0xc(%ebp)
  802813:	e8 19 ff ff ff       	call   802731 <is_free_block>
  802818:	83 c4 10             	add    $0x10,%esp
  80281b:	0f be d8             	movsbl %al,%ebx
  80281e:	83 ec 0c             	sub    $0xc,%esp
  802821:	ff 75 f4             	pushl  -0xc(%ebp)
  802824:	e8 ef fe ff ff       	call   802718 <get_block_size>
  802829:	83 c4 10             	add    $0x10,%esp
  80282c:	83 ec 04             	sub    $0x4,%esp
  80282f:	53                   	push   %ebx
  802830:	50                   	push   %eax
  802831:	68 af 44 80 00       	push   $0x8044af
  802836:	e8 d3 e1 ff ff       	call   800a0e <cprintf>
  80283b:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  80283e:	8b 45 10             	mov    0x10(%ebp),%eax
  802841:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802844:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802848:	74 07                	je     802851 <print_blocks_list+0x73>
  80284a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284d:	8b 00                	mov    (%eax),%eax
  80284f:	eb 05                	jmp    802856 <print_blocks_list+0x78>
  802851:	b8 00 00 00 00       	mov    $0x0,%eax
  802856:	89 45 10             	mov    %eax,0x10(%ebp)
  802859:	8b 45 10             	mov    0x10(%ebp),%eax
  80285c:	85 c0                	test   %eax,%eax
  80285e:	75 ad                	jne    80280d <print_blocks_list+0x2f>
  802860:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802864:	75 a7                	jne    80280d <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802866:	83 ec 0c             	sub    $0xc,%esp
  802869:	68 6c 44 80 00       	push   $0x80446c
  80286e:	e8 9b e1 ff ff       	call   800a0e <cprintf>
  802873:	83 c4 10             	add    $0x10,%esp

}
  802876:	90                   	nop
  802877:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80287a:	c9                   	leave  
  80287b:	c3                   	ret    

0080287c <initialize_dynamic_allocator>:

//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  80287c:	55                   	push   %ebp
  80287d:	89 e5                	mov    %esp,%ebp
  80287f:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802882:	8b 45 0c             	mov    0xc(%ebp),%eax
  802885:	83 e0 01             	and    $0x1,%eax
  802888:	85 c0                	test   %eax,%eax
  80288a:	74 03                	je     80288f <initialize_dynamic_allocator+0x13>
  80288c:	ff 45 0c             	incl   0xc(%ebp)
		if (initSizeOfAllocatedSpace == 0)
  80288f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802893:	0f 84 f8 00 00 00    	je     802991 <initialize_dynamic_allocator+0x115>
			return ;
		is_initialized = 1;
  802899:	c7 05 40 50 98 00 01 	movl   $0x1,0x985040
  8028a0:	00 00 00 
	//TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("initialize_dynamic_allocator is not implemented yet");
	//Your Code is Here...

	if(is_initialized){
  8028a3:	a1 40 50 98 00       	mov    0x985040,%eax
  8028a8:	85 c0                	test   %eax,%eax
  8028aa:	0f 84 e2 00 00 00    	je     802992 <initialize_dynamic_allocator+0x116>

		// begin block with size 0 and lsb = 1 (allocated)
		uint32* beginBlock = (uint32*)daStart;
  8028b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		*beginBlock = 0 | 1; // size = 0, LSB as a flag = 1
  8028b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b9:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		// end block with size 0 and lsb = 1 (allocated)
		uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);
  8028bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8028c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028c5:	01 d0                	add    %edx,%eax
  8028c7:	83 e8 04             	sub    $0x4,%eax
  8028ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
		*endBlock = 0 | 1; // size = 0, LSB as a flag = 1
  8028cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

		// the block that between begin and end blocks
		struct BlockElement* block = (struct BlockElement*)(daStart + 8);
  8028d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d9:	83 c0 08             	add    $0x8,%eax
  8028dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 blockSize = initSizeOfAllocatedSpace - 8; // subtract size of begin and end blocks
  8028df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028e2:	83 e8 08             	sub    $0x8,%eax
  8028e5:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(block,blockSize,0);
  8028e8:	83 ec 04             	sub    $0x4,%esp
  8028eb:	6a 00                	push   $0x0
  8028ed:	ff 75 e8             	pushl  -0x18(%ebp)
  8028f0:	ff 75 ec             	pushl  -0x14(%ebp)
  8028f3:	e8 9c 00 00 00       	call   802994 <set_block_data>
  8028f8:	83 c4 10             	add    $0x10,%esp

		block->prev_next_info.le_next = NULL;
  8028fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block->prev_next_info.le_prev = NULL;
  802904:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802907:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

		LIST_INIT(&freeBlocksList);
  80290e:	c7 05 48 50 98 00 00 	movl   $0x0,0x985048
  802915:	00 00 00 
  802918:	c7 05 4c 50 98 00 00 	movl   $0x0,0x98504c
  80291f:	00 00 00 
  802922:	c7 05 54 50 98 00 00 	movl   $0x0,0x985054
  802929:	00 00 00 
		LIST_INSERT_HEAD(&freeBlocksList, block);
  80292c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802930:	75 17                	jne    802949 <initialize_dynamic_allocator+0xcd>
  802932:	83 ec 04             	sub    $0x4,%esp
  802935:	68 c8 44 80 00       	push   $0x8044c8
  80293a:	68 80 00 00 00       	push   $0x80
  80293f:	68 eb 44 80 00       	push   $0x8044eb
  802944:	e8 08 de ff ff       	call   800751 <_panic>
  802949:	8b 15 48 50 98 00    	mov    0x985048,%edx
  80294f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802952:	89 10                	mov    %edx,(%eax)
  802954:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802957:	8b 00                	mov    (%eax),%eax
  802959:	85 c0                	test   %eax,%eax
  80295b:	74 0d                	je     80296a <initialize_dynamic_allocator+0xee>
  80295d:	a1 48 50 98 00       	mov    0x985048,%eax
  802962:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802965:	89 50 04             	mov    %edx,0x4(%eax)
  802968:	eb 08                	jmp    802972 <initialize_dynamic_allocator+0xf6>
  80296a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80296d:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802972:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802975:	a3 48 50 98 00       	mov    %eax,0x985048
  80297a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80297d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802984:	a1 54 50 98 00       	mov    0x985054,%eax
  802989:	40                   	inc    %eax
  80298a:	a3 54 50 98 00       	mov    %eax,0x985054
  80298f:	eb 01                	jmp    802992 <initialize_dynamic_allocator+0x116>
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
		if (initSizeOfAllocatedSpace == 0)
			return ;
  802991:	90                   	nop
		block->prev_next_info.le_prev = NULL;

		LIST_INIT(&freeBlocksList);
		LIST_INSERT_HEAD(&freeBlocksList, block);
	}
}
  802992:	c9                   	leave  
  802993:	c3                   	ret    

00802994 <set_block_data>:
//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802994:	55                   	push   %ebp
  802995:	89 e5                	mov    %esp,%ebp
  802997:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("set_block_data is not implemented yet");
	//Your Code is Here...

	if(totalSize % 2 != 0)
  80299a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80299d:	83 e0 01             	and    $0x1,%eax
  8029a0:	85 c0                	test   %eax,%eax
  8029a2:	74 03                	je     8029a7 <set_block_data+0x13>
	{
		totalSize++;
  8029a4:	ff 45 0c             	incl   0xc(%ebp)
	}

	uint32* header = (uint32 *)((uint32*)va-1);
  8029a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029aa:	83 e8 04             	sub    $0x4,%eax
  8029ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//	size => totalSize with LSB = 0		 set LSB = 1 if isAllocated
	*header = (totalSize & ~1) | (isAllocated & 1);
  8029b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029b3:	83 e0 fe             	and    $0xfffffffe,%eax
  8029b6:	89 c2                	mov    %eax,%edx
  8029b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8029bb:	83 e0 01             	and    $0x1,%eax
  8029be:	09 c2                	or     %eax,%edx
  8029c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8029c3:	89 10                	mov    %edx,(%eax)
	uint32* footer = (uint32*) (va + totalSize - 8);
  8029c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029c8:	8d 50 f8             	lea    -0x8(%eax),%edx
  8029cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ce:	01 d0                	add    %edx,%eax
  8029d0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	*footer = (totalSize & ~1) | (isAllocated & 1);
  8029d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029d6:	83 e0 fe             	and    $0xfffffffe,%eax
  8029d9:	89 c2                	mov    %eax,%edx
  8029db:	8b 45 10             	mov    0x10(%ebp),%eax
  8029de:	83 e0 01             	and    $0x1,%eax
  8029e1:	09 c2                	or     %eax,%edx
  8029e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8029e6:	89 10                	mov    %edx,(%eax)
}
  8029e8:	90                   	nop
  8029e9:	c9                   	leave  
  8029ea:	c3                   	ret    

008029eb <insert_sorted_in_freeList>:
//=========================================
void insert_sorted_in_freeList(struct BlockElement *newBlock)
{
  8029eb:	55                   	push   %ebp
  8029ec:	89 e5                	mov    %esp,%ebp
  8029ee:	83 ec 18             	sub    $0x18,%esp
	if(LIST_EMPTY(&freeBlocksList))
  8029f1:	a1 48 50 98 00       	mov    0x985048,%eax
  8029f6:	85 c0                	test   %eax,%eax
  8029f8:	75 68                	jne    802a62 <insert_sorted_in_freeList+0x77>
	{
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
  8029fa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029fe:	75 17                	jne    802a17 <insert_sorted_in_freeList+0x2c>
  802a00:	83 ec 04             	sub    $0x4,%esp
  802a03:	68 c8 44 80 00       	push   $0x8044c8
  802a08:	68 9d 00 00 00       	push   $0x9d
  802a0d:	68 eb 44 80 00       	push   $0x8044eb
  802a12:	e8 3a dd ff ff       	call   800751 <_panic>
  802a17:	8b 15 48 50 98 00    	mov    0x985048,%edx
  802a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a20:	89 10                	mov    %edx,(%eax)
  802a22:	8b 45 08             	mov    0x8(%ebp),%eax
  802a25:	8b 00                	mov    (%eax),%eax
  802a27:	85 c0                	test   %eax,%eax
  802a29:	74 0d                	je     802a38 <insert_sorted_in_freeList+0x4d>
  802a2b:	a1 48 50 98 00       	mov    0x985048,%eax
  802a30:	8b 55 08             	mov    0x8(%ebp),%edx
  802a33:	89 50 04             	mov    %edx,0x4(%eax)
  802a36:	eb 08                	jmp    802a40 <insert_sorted_in_freeList+0x55>
  802a38:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3b:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802a40:	8b 45 08             	mov    0x8(%ebp),%eax
  802a43:	a3 48 50 98 00       	mov    %eax,0x985048
  802a48:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a52:	a1 54 50 98 00       	mov    0x985054,%eax
  802a57:	40                   	inc    %eax
  802a58:	a3 54 50 98 00       	mov    %eax,0x985054
		return;
  802a5d:	e9 1a 01 00 00       	jmp    802b7c <insert_sorted_in_freeList+0x191>
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  802a62:	a1 48 50 98 00       	mov    0x985048,%eax
  802a67:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a6a:	eb 7f                	jmp    802aeb <insert_sorted_in_freeList+0x100>
	{
		if(blk > newBlock) // if address of blk > address of newBlock => add newBlock before blk
  802a6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a72:	76 6f                	jbe    802ae3 <insert_sorted_in_freeList+0xf8>
		{
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
  802a74:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a78:	74 06                	je     802a80 <insert_sorted_in_freeList+0x95>
  802a7a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a7e:	75 17                	jne    802a97 <insert_sorted_in_freeList+0xac>
  802a80:	83 ec 04             	sub    $0x4,%esp
  802a83:	68 04 45 80 00       	push   $0x804504
  802a88:	68 a6 00 00 00       	push   $0xa6
  802a8d:	68 eb 44 80 00       	push   $0x8044eb
  802a92:	e8 ba dc ff ff       	call   800751 <_panic>
  802a97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9a:	8b 50 04             	mov    0x4(%eax),%edx
  802a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa0:	89 50 04             	mov    %edx,0x4(%eax)
  802aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aa9:	89 10                	mov    %edx,(%eax)
  802aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aae:	8b 40 04             	mov    0x4(%eax),%eax
  802ab1:	85 c0                	test   %eax,%eax
  802ab3:	74 0d                	je     802ac2 <insert_sorted_in_freeList+0xd7>
  802ab5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab8:	8b 40 04             	mov    0x4(%eax),%eax
  802abb:	8b 55 08             	mov    0x8(%ebp),%edx
  802abe:	89 10                	mov    %edx,(%eax)
  802ac0:	eb 08                	jmp    802aca <insert_sorted_in_freeList+0xdf>
  802ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac5:	a3 48 50 98 00       	mov    %eax,0x985048
  802aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acd:	8b 55 08             	mov    0x8(%ebp),%edx
  802ad0:	89 50 04             	mov    %edx,0x4(%eax)
  802ad3:	a1 54 50 98 00       	mov    0x985054,%eax
  802ad8:	40                   	inc    %eax
  802ad9:	a3 54 50 98 00       	mov    %eax,0x985054
			return;
  802ade:	e9 99 00 00 00       	jmp    802b7c <insert_sorted_in_freeList+0x191>
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
		return;
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  802ae3:	a1 50 50 98 00       	mov    0x985050,%eax
  802ae8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aeb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aef:	74 07                	je     802af8 <insert_sorted_in_freeList+0x10d>
  802af1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af4:	8b 00                	mov    (%eax),%eax
  802af6:	eb 05                	jmp    802afd <insert_sorted_in_freeList+0x112>
  802af8:	b8 00 00 00 00       	mov    $0x0,%eax
  802afd:	a3 50 50 98 00       	mov    %eax,0x985050
  802b02:	a1 50 50 98 00       	mov    0x985050,%eax
  802b07:	85 c0                	test   %eax,%eax
  802b09:	0f 85 5d ff ff ff    	jne    802a6c <insert_sorted_in_freeList+0x81>
  802b0f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b13:	0f 85 53 ff ff ff    	jne    802a6c <insert_sorted_in_freeList+0x81>
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
			return;
		}
	}
	// if no blk its address > newBlock
	LIST_INSERT_TAIL(&freeBlocksList, newBlock);
  802b19:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b1d:	75 17                	jne    802b36 <insert_sorted_in_freeList+0x14b>
  802b1f:	83 ec 04             	sub    $0x4,%esp
  802b22:	68 3c 45 80 00       	push   $0x80453c
  802b27:	68 ab 00 00 00       	push   $0xab
  802b2c:	68 eb 44 80 00       	push   $0x8044eb
  802b31:	e8 1b dc ff ff       	call   800751 <_panic>
  802b36:	8b 15 4c 50 98 00    	mov    0x98504c,%edx
  802b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3f:	89 50 04             	mov    %edx,0x4(%eax)
  802b42:	8b 45 08             	mov    0x8(%ebp),%eax
  802b45:	8b 40 04             	mov    0x4(%eax),%eax
  802b48:	85 c0                	test   %eax,%eax
  802b4a:	74 0c                	je     802b58 <insert_sorted_in_freeList+0x16d>
  802b4c:	a1 4c 50 98 00       	mov    0x98504c,%eax
  802b51:	8b 55 08             	mov    0x8(%ebp),%edx
  802b54:	89 10                	mov    %edx,(%eax)
  802b56:	eb 08                	jmp    802b60 <insert_sorted_in_freeList+0x175>
  802b58:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5b:	a3 48 50 98 00       	mov    %eax,0x985048
  802b60:	8b 45 08             	mov    0x8(%ebp),%eax
  802b63:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802b68:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b71:	a1 54 50 98 00       	mov    0x985054,%eax
  802b76:	40                   	inc    %eax
  802b77:	a3 54 50 98 00       	mov    %eax,0x985054
}
  802b7c:	c9                   	leave  
  802b7d:	c3                   	ret    

00802b7e <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  802b7e:	55                   	push   %ebp
  802b7f:	89 e5                	mov    %esp,%ebp
  802b81:	83 ec 78             	sub    $0x78,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802b84:	8b 45 08             	mov    0x8(%ebp),%eax
  802b87:	83 e0 01             	and    $0x1,%eax
  802b8a:	85 c0                	test   %eax,%eax
  802b8c:	74 03                	je     802b91 <alloc_block_FF+0x13>
  802b8e:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802b91:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802b95:	77 07                	ja     802b9e <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802b97:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802b9e:	a1 40 50 98 00       	mov    0x985040,%eax
  802ba3:	85 c0                	test   %eax,%eax
  802ba5:	75 63                	jne    802c0a <alloc_block_FF+0x8c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  802baa:	83 c0 10             	add    $0x10,%eax
  802bad:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802bb0:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802bb7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bbd:	01 d0                	add    %edx,%eax
  802bbf:	48                   	dec    %eax
  802bc0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802bc3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bc6:	ba 00 00 00 00       	mov    $0x0,%edx
  802bcb:	f7 75 ec             	divl   -0x14(%ebp)
  802bce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bd1:	29 d0                	sub    %edx,%eax
  802bd3:	c1 e8 0c             	shr    $0xc,%eax
  802bd6:	83 ec 0c             	sub    $0xc,%esp
  802bd9:	50                   	push   %eax
  802bda:	e8 d1 ed ff ff       	call   8019b0 <sbrk>
  802bdf:	83 c4 10             	add    $0x10,%esp
  802be2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802be5:	83 ec 0c             	sub    $0xc,%esp
  802be8:	6a 00                	push   $0x0
  802bea:	e8 c1 ed ff ff       	call   8019b0 <sbrk>
  802bef:	83 c4 10             	add    $0x10,%esp
  802bf2:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802bf5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bf8:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802bfb:	83 ec 08             	sub    $0x8,%esp
  802bfe:	50                   	push   %eax
  802bff:	ff 75 e4             	pushl  -0x1c(%ebp)
  802c02:	e8 75 fc ff ff       	call   80287c <initialize_dynamic_allocator>
  802c07:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(size == 0)
  802c0a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c0e:	75 0a                	jne    802c1a <alloc_block_FF+0x9c>
	{
		return NULL;
  802c10:	b8 00 00 00 00       	mov    $0x0,%eax
  802c15:	e9 99 03 00 00       	jmp    802fb3 <alloc_block_FF+0x435>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  802c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1d:	83 c0 08             	add    $0x8,%eax
  802c20:	89 45 dc             	mov    %eax,-0x24(%ebp)

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802c23:	a1 48 50 98 00       	mov    0x985048,%eax
  802c28:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c2b:	e9 03 02 00 00       	jmp    802e33 <alloc_block_FF+0x2b5>
	{
		uint32 blockSize = get_block_size(block); // Get size without the (LSB) allocation flag
  802c30:	83 ec 0c             	sub    $0xc,%esp
  802c33:	ff 75 f4             	pushl  -0xc(%ebp)
  802c36:	e8 dd fa ff ff       	call   802718 <get_block_size>
  802c3b:	83 c4 10             	add    $0x10,%esp
  802c3e:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if(blockSize >= totalSize)
  802c41:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802c44:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802c47:	0f 82 de 01 00 00    	jb     802e2b <alloc_block_FF+0x2ad>
		{	//if we can put another block with min size 16
			if(blockSize >= totalSize + 4*sizeof(uint32))
  802c4d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c50:	83 c0 10             	add    $0x10,%eax
  802c53:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  802c56:	0f 87 32 01 00 00    	ja     802d8e <alloc_block_FF+0x210>
			{
				// the size that will remain from the block that we will allocate a new block in it
				uint32 remainingSize = blockSize - totalSize;
  802c5c:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802c5f:	2b 45 dc             	sub    -0x24(%ebp),%eax
  802c62:	89 45 98             	mov    %eax,-0x68(%ebp)

				// the remaining free space from the block that we use to allocate in it
				struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)block + totalSize);
  802c65:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c68:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c6b:	01 d0                	add    %edx,%eax
  802c6d:	89 45 94             	mov    %eax,-0x6c(%ebp)
				set_block_data(remainingFreeBlock, remainingSize, 0);
  802c70:	83 ec 04             	sub    $0x4,%esp
  802c73:	6a 00                	push   $0x0
  802c75:	ff 75 98             	pushl  -0x68(%ebp)
  802c78:	ff 75 94             	pushl  -0x6c(%ebp)
  802c7b:	e8 14 fd ff ff       	call   802994 <set_block_data>
  802c80:	83 c4 10             	add    $0x10,%esp
				// add it after the block we allocated to be sorted by addresses
				LIST_INSERT_AFTER(&freeBlocksList, block,remainingFreeBlock);
  802c83:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c87:	74 06                	je     802c8f <alloc_block_FF+0x111>
  802c89:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
  802c8d:	75 17                	jne    802ca6 <alloc_block_FF+0x128>
  802c8f:	83 ec 04             	sub    $0x4,%esp
  802c92:	68 60 45 80 00       	push   $0x804560
  802c97:	68 de 00 00 00       	push   $0xde
  802c9c:	68 eb 44 80 00       	push   $0x8044eb
  802ca1:	e8 ab da ff ff       	call   800751 <_panic>
  802ca6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca9:	8b 10                	mov    (%eax),%edx
  802cab:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802cae:	89 10                	mov    %edx,(%eax)
  802cb0:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802cb3:	8b 00                	mov    (%eax),%eax
  802cb5:	85 c0                	test   %eax,%eax
  802cb7:	74 0b                	je     802cc4 <alloc_block_FF+0x146>
  802cb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbc:	8b 00                	mov    (%eax),%eax
  802cbe:	8b 55 94             	mov    -0x6c(%ebp),%edx
  802cc1:	89 50 04             	mov    %edx,0x4(%eax)
  802cc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc7:	8b 55 94             	mov    -0x6c(%ebp),%edx
  802cca:	89 10                	mov    %edx,(%eax)
  802ccc:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802ccf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cd2:	89 50 04             	mov    %edx,0x4(%eax)
  802cd5:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802cd8:	8b 00                	mov    (%eax),%eax
  802cda:	85 c0                	test   %eax,%eax
  802cdc:	75 08                	jne    802ce6 <alloc_block_FF+0x168>
  802cde:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802ce1:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802ce6:	a1 54 50 98 00       	mov    0x985054,%eax
  802ceb:	40                   	inc    %eax
  802cec:	a3 54 50 98 00       	mov    %eax,0x985054

				// update the allocated block and remove it from freeBlocksList
				set_block_data(block,totalSize,1);
  802cf1:	83 ec 04             	sub    $0x4,%esp
  802cf4:	6a 01                	push   $0x1
  802cf6:	ff 75 dc             	pushl  -0x24(%ebp)
  802cf9:	ff 75 f4             	pushl  -0xc(%ebp)
  802cfc:	e8 93 fc ff ff       	call   802994 <set_block_data>
  802d01:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  802d04:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d08:	75 17                	jne    802d21 <alloc_block_FF+0x1a3>
  802d0a:	83 ec 04             	sub    $0x4,%esp
  802d0d:	68 94 45 80 00       	push   $0x804594
  802d12:	68 e3 00 00 00       	push   $0xe3
  802d17:	68 eb 44 80 00       	push   $0x8044eb
  802d1c:	e8 30 da ff ff       	call   800751 <_panic>
  802d21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d24:	8b 00                	mov    (%eax),%eax
  802d26:	85 c0                	test   %eax,%eax
  802d28:	74 10                	je     802d3a <alloc_block_FF+0x1bc>
  802d2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2d:	8b 00                	mov    (%eax),%eax
  802d2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d32:	8b 52 04             	mov    0x4(%edx),%edx
  802d35:	89 50 04             	mov    %edx,0x4(%eax)
  802d38:	eb 0b                	jmp    802d45 <alloc_block_FF+0x1c7>
  802d3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3d:	8b 40 04             	mov    0x4(%eax),%eax
  802d40:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802d45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d48:	8b 40 04             	mov    0x4(%eax),%eax
  802d4b:	85 c0                	test   %eax,%eax
  802d4d:	74 0f                	je     802d5e <alloc_block_FF+0x1e0>
  802d4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d52:	8b 40 04             	mov    0x4(%eax),%eax
  802d55:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d58:	8b 12                	mov    (%edx),%edx
  802d5a:	89 10                	mov    %edx,(%eax)
  802d5c:	eb 0a                	jmp    802d68 <alloc_block_FF+0x1ea>
  802d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d61:	8b 00                	mov    (%eax),%eax
  802d63:	a3 48 50 98 00       	mov    %eax,0x985048
  802d68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d74:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d7b:	a1 54 50 98 00       	mov    0x985054,%eax
  802d80:	48                   	dec    %eax
  802d81:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  802d86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d89:	e9 25 02 00 00       	jmp    802fb3 <alloc_block_FF+0x435>
			}
			else // if set internal fragmentation
			{
				// add the remaining size to the block we allocate so it will be the same main block size
				set_block_data(block,blockSize,1);
  802d8e:	83 ec 04             	sub    $0x4,%esp
  802d91:	6a 01                	push   $0x1
  802d93:	ff 75 9c             	pushl  -0x64(%ebp)
  802d96:	ff 75 f4             	pushl  -0xc(%ebp)
  802d99:	e8 f6 fb ff ff       	call   802994 <set_block_data>
  802d9e:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  802da1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802da5:	75 17                	jne    802dbe <alloc_block_FF+0x240>
  802da7:	83 ec 04             	sub    $0x4,%esp
  802daa:	68 94 45 80 00       	push   $0x804594
  802daf:	68 eb 00 00 00       	push   $0xeb
  802db4:	68 eb 44 80 00       	push   $0x8044eb
  802db9:	e8 93 d9 ff ff       	call   800751 <_panic>
  802dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc1:	8b 00                	mov    (%eax),%eax
  802dc3:	85 c0                	test   %eax,%eax
  802dc5:	74 10                	je     802dd7 <alloc_block_FF+0x259>
  802dc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dca:	8b 00                	mov    (%eax),%eax
  802dcc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dcf:	8b 52 04             	mov    0x4(%edx),%edx
  802dd2:	89 50 04             	mov    %edx,0x4(%eax)
  802dd5:	eb 0b                	jmp    802de2 <alloc_block_FF+0x264>
  802dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dda:	8b 40 04             	mov    0x4(%eax),%eax
  802ddd:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802de2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de5:	8b 40 04             	mov    0x4(%eax),%eax
  802de8:	85 c0                	test   %eax,%eax
  802dea:	74 0f                	je     802dfb <alloc_block_FF+0x27d>
  802dec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802def:	8b 40 04             	mov    0x4(%eax),%eax
  802df2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802df5:	8b 12                	mov    (%edx),%edx
  802df7:	89 10                	mov    %edx,(%eax)
  802df9:	eb 0a                	jmp    802e05 <alloc_block_FF+0x287>
  802dfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfe:	8b 00                	mov    (%eax),%eax
  802e00:	a3 48 50 98 00       	mov    %eax,0x985048
  802e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e08:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e11:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e18:	a1 54 50 98 00       	mov    0x985054,%eax
  802e1d:	48                   	dec    %eax
  802e1e:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  802e23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e26:	e9 88 01 00 00       	jmp    802fb3 <alloc_block_FF+0x435>
		return NULL;
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802e2b:	a1 50 50 98 00       	mov    0x985050,%eax
  802e30:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e33:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e37:	74 07                	je     802e40 <alloc_block_FF+0x2c2>
  802e39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3c:	8b 00                	mov    (%eax),%eax
  802e3e:	eb 05                	jmp    802e45 <alloc_block_FF+0x2c7>
  802e40:	b8 00 00 00 00       	mov    $0x0,%eax
  802e45:	a3 50 50 98 00       	mov    %eax,0x985050
  802e4a:	a1 50 50 98 00       	mov    0x985050,%eax
  802e4f:	85 c0                	test   %eax,%eax
  802e51:	0f 85 d9 fd ff ff    	jne    802c30 <alloc_block_FF+0xb2>
  802e57:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e5b:	0f 85 cf fd ff ff    	jne    802c30 <alloc_block_FF+0xb2>

//	uint32 *endBlock = &kheapBreak;

	// if we don't find any enough space to allocate the block

	void *oldBreak = sbrk(ROUNDUP(totalSize, PAGE_SIZE) / PAGE_SIZE);
  802e61:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802e68:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e6b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802e6e:	01 d0                	add    %edx,%eax
  802e70:	48                   	dec    %eax
  802e71:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802e74:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e77:	ba 00 00 00 00       	mov    $0x0,%edx
  802e7c:	f7 75 d8             	divl   -0x28(%ebp)
  802e7f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e82:	29 d0                	sub    %edx,%eax
  802e84:	c1 e8 0c             	shr    $0xc,%eax
  802e87:	83 ec 0c             	sub    $0xc,%esp
  802e8a:	50                   	push   %eax
  802e8b:	e8 20 eb ff ff       	call   8019b0 <sbrk>
  802e90:	83 c4 10             	add    $0x10,%esp
  802e93:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (oldBreak == (void*)-1) {
  802e96:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802e9a:	75 0a                	jne    802ea6 <alloc_block_FF+0x328>
		return NULL;
  802e9c:	b8 00 00 00 00       	mov    $0x0,%eax
  802ea1:	e9 0d 01 00 00       	jmp    802fb3 <alloc_block_FF+0x435>
	}
	//uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);

	uint32* endBlk = (uint32 *)((char *)oldBreak - 4);
  802ea6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802ea9:	83 e8 04             	sub    $0x4,%eax
  802eac:	89 45 cc             	mov    %eax,-0x34(%ebp)
	//endBlk = endBlk+(char *) ROUNDUP(totalSize, PAGE_SIZE);

	endBlk = endBlk + (ROUNDUP(totalSize, PAGE_SIZE) / sizeof(uint32));
  802eaf:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  802eb6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802eb9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802ebc:	01 d0                	add    %edx,%eax
  802ebe:	48                   	dec    %eax
  802ebf:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  802ec2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802ec5:	ba 00 00 00 00       	mov    $0x0,%edx
  802eca:	f7 75 c8             	divl   -0x38(%ebp)
  802ecd:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802ed0:	29 d0                	sub    %edx,%eax
  802ed2:	c1 e8 02             	shr    $0x2,%eax
  802ed5:	c1 e0 02             	shl    $0x2,%eax
  802ed8:	01 45 cc             	add    %eax,-0x34(%ebp)
	*endBlk = 0 | 1;
  802edb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ede:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	uint32 *footerLast = ((uint32*)oldBreak - 2);
  802ee4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802ee7:	83 e8 08             	sub    $0x8,%eax
  802eea:	89 45 c0             	mov    %eax,-0x40(%ebp)
	uint32 lastSize = (*footerLast) & ~(0x1);
  802eed:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802ef0:	8b 00                	mov    (%eax),%eax
  802ef2:	83 e0 fe             	and    $0xfffffffe,%eax
  802ef5:	89 45 bc             	mov    %eax,-0x44(%ebp)
	// the last block for the block that we want to free it
	struct BlockElement *laskBlk = (struct BlockElement *)((char*)oldBreak - lastSize);
  802ef8:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802efb:	f7 d8                	neg    %eax
  802efd:	89 c2                	mov    %eax,%edx
  802eff:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f02:	01 d0                	add    %edx,%eax
  802f04:	89 45 b8             	mov    %eax,-0x48(%ebp)
	uint32 isLastFree = is_free_block(laskBlk);
  802f07:	83 ec 0c             	sub    $0xc,%esp
  802f0a:	ff 75 b8             	pushl  -0x48(%ebp)
  802f0d:	e8 1f f8 ff ff       	call   802731 <is_free_block>
  802f12:	83 c4 10             	add    $0x10,%esp
  802f15:	0f be c0             	movsbl %al,%eax
  802f18:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(isLastFree)
  802f1b:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  802f1f:	74 42                	je     802f63 <alloc_block_FF+0x3e5>
	{
		// merge the block will be free with its prev block
		uint32 newBlkSize = lastSize + ROUNDUP(totalSize, PAGE_SIZE); // size of main block and its prev block
  802f21:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802f28:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f2b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802f2e:	01 d0                	add    %edx,%eax
  802f30:	48                   	dec    %eax
  802f31:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802f34:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802f37:	ba 00 00 00 00       	mov    $0x0,%edx
  802f3c:	f7 75 b0             	divl   -0x50(%ebp)
  802f3f:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802f42:	29 d0                	sub    %edx,%eax
  802f44:	89 c2                	mov    %eax,%edx
  802f46:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802f49:	01 d0                	add    %edx,%eax
  802f4b:	89 45 a8             	mov    %eax,-0x58(%ebp)
		// extends last block size to contain its size and the size of new space
		set_block_data(laskBlk,newBlkSize,0);
  802f4e:	83 ec 04             	sub    $0x4,%esp
  802f51:	6a 00                	push   $0x0
  802f53:	ff 75 a8             	pushl  -0x58(%ebp)
  802f56:	ff 75 b8             	pushl  -0x48(%ebp)
  802f59:	e8 36 fa ff ff       	call   802994 <set_block_data>
  802f5e:	83 c4 10             	add    $0x10,%esp
  802f61:	eb 42                	jmp    802fa5 <alloc_block_FF+0x427>
	}
	else
	{
		set_block_data(oldBreak,ROUNDUP(totalSize, PAGE_SIZE),0);
  802f63:	c7 45 a4 00 10 00 00 	movl   $0x1000,-0x5c(%ebp)
  802f6a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f6d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802f70:	01 d0                	add    %edx,%eax
  802f72:	48                   	dec    %eax
  802f73:	89 45 a0             	mov    %eax,-0x60(%ebp)
  802f76:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802f79:	ba 00 00 00 00       	mov    $0x0,%edx
  802f7e:	f7 75 a4             	divl   -0x5c(%ebp)
  802f81:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802f84:	29 d0                	sub    %edx,%eax
  802f86:	83 ec 04             	sub    $0x4,%esp
  802f89:	6a 00                	push   $0x0
  802f8b:	50                   	push   %eax
  802f8c:	ff 75 d0             	pushl  -0x30(%ebp)
  802f8f:	e8 00 fa ff ff       	call   802994 <set_block_data>
  802f94:	83 c4 10             	add    $0x10,%esp
		insert_sorted_in_freeList((struct BlockElement *)oldBreak);
  802f97:	83 ec 0c             	sub    $0xc,%esp
  802f9a:	ff 75 d0             	pushl  -0x30(%ebp)
  802f9d:	e8 49 fa ff ff       	call   8029eb <insert_sorted_in_freeList>
  802fa2:	83 c4 10             	add    $0x10,%esp
//		LIST_INSERT_TAIL(&freeBlocksList,newBreak);
	}
//	set_block_data((struct BlockElement *)newBreak, totalSize, 1);
	return alloc_block_FF(size);
  802fa5:	83 ec 0c             	sub    $0xc,%esp
  802fa8:	ff 75 08             	pushl  0x8(%ebp)
  802fab:	e8 ce fb ff ff       	call   802b7e <alloc_block_FF>
  802fb0:	83 c4 10             	add    $0x10,%esp
}
  802fb3:	c9                   	leave  
  802fb4:	c3                   	ret    

00802fb5 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802fb5:	55                   	push   %ebp
  802fb6:	89 e5                	mov    %esp,%ebp
  802fb8:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS1 - BONUS] [3] DYNAMIC ALLOCATOR - alloc_block_BF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_BF is not implemented yet");
	//Your Code is Here...
	if(size == 0)
  802fbb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fbf:	75 0a                	jne    802fcb <alloc_block_BF+0x16>
	{
		return NULL;
  802fc1:	b8 00 00 00 00       	mov    $0x0,%eax
  802fc6:	e9 7a 02 00 00       	jmp    803245 <alloc_block_BF+0x290>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  802fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fce:	83 c0 08             	add    $0x8,%eax
  802fd1:	89 45 e8             	mov    %eax,-0x18(%ebp)

	struct BlockElement *minBlk= NULL;
  802fd4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 minSize = 0xfffffff; // a large number
  802fdb:	c7 45 f0 ff ff ff 0f 	movl   $0xfffffff,-0x10(%ebp)
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802fe2:	a1 48 50 98 00       	mov    0x985048,%eax
  802fe7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802fea:	eb 32                	jmp    80301e <alloc_block_BF+0x69>
	{
		uint32 blockSize = get_block_size(block);
  802fec:	ff 75 ec             	pushl  -0x14(%ebp)
  802fef:	e8 24 f7 ff ff       	call   802718 <get_block_size>
  802ff4:	83 c4 04             	add    $0x4,%esp
  802ff7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		// if this block can take the new block and its size < min size of all blocks
		if(blockSize >= totalSize && blockSize < minSize)
  802ffa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ffd:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803000:	72 14                	jb     803016 <alloc_block_BF+0x61>
  803002:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803005:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803008:	73 0c                	jae    803016 <alloc_block_BF+0x61>
		{
			minBlk = block;
  80300a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80300d:	89 45 f4             	mov    %eax,-0xc(%ebp)
			minSize = blockSize;
  803010:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803013:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *minBlk= NULL;
	uint32 minSize = 0xfffffff; // a large number
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  803016:	a1 50 50 98 00       	mov    0x985050,%eax
  80301b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80301e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803022:	74 07                	je     80302b <alloc_block_BF+0x76>
  803024:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803027:	8b 00                	mov    (%eax),%eax
  803029:	eb 05                	jmp    803030 <alloc_block_BF+0x7b>
  80302b:	b8 00 00 00 00       	mov    $0x0,%eax
  803030:	a3 50 50 98 00       	mov    %eax,0x985050
  803035:	a1 50 50 98 00       	mov    0x985050,%eax
  80303a:	85 c0                	test   %eax,%eax
  80303c:	75 ae                	jne    802fec <alloc_block_BF+0x37>
  80303e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803042:	75 a8                	jne    802fec <alloc_block_BF+0x37>
			minSize = blockSize;
		}
	}

	// if we don't find any enough space to allocate the block
	if(minBlk == NULL)
  803044:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803048:	75 22                	jne    80306c <alloc_block_BF+0xb7>
	{
		void *newBlock = sbrk(totalSize);
  80304a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80304d:	83 ec 0c             	sub    $0xc,%esp
  803050:	50                   	push   %eax
  803051:	e8 5a e9 ff ff       	call   8019b0 <sbrk>
  803056:	83 c4 10             	add    $0x10,%esp
  803059:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (newBlock == (void*)-1) {
  80305c:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  803060:	75 0a                	jne    80306c <alloc_block_BF+0xb7>
			return NULL;
  803062:	b8 00 00 00 00       	mov    $0x0,%eax
  803067:	e9 d9 01 00 00       	jmp    803245 <alloc_block_BF+0x290>
		}
	}

	//if we can put another block with min size 16
	if(minSize >= totalSize + 4*sizeof(uint32))
  80306c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80306f:	83 c0 10             	add    $0x10,%eax
  803072:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803075:	0f 87 32 01 00 00    	ja     8031ad <alloc_block_BF+0x1f8>
	{
		// the size that will remain from the block that we will allocate a new block in it
		uint32 remainingSize= minSize - totalSize;
  80307b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80307e:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803081:	89 45 dc             	mov    %eax,-0x24(%ebp)

		// the remaining free space from the block that we use to allocate in it
		struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)minBlk + totalSize);
  803084:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803087:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80308a:	01 d0                	add    %edx,%eax
  80308c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		set_block_data(remainingFreeBlock, remainingSize, 0);
  80308f:	83 ec 04             	sub    $0x4,%esp
  803092:	6a 00                	push   $0x0
  803094:	ff 75 dc             	pushl  -0x24(%ebp)
  803097:	ff 75 d8             	pushl  -0x28(%ebp)
  80309a:	e8 f5 f8 ff ff       	call   802994 <set_block_data>
  80309f:	83 c4 10             	add    $0x10,%esp
		// add it after the block we allocated to be sorted by addresses
		LIST_INSERT_AFTER(&freeBlocksList, minBlk,remainingFreeBlock);
  8030a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030a6:	74 06                	je     8030ae <alloc_block_BF+0xf9>
  8030a8:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8030ac:	75 17                	jne    8030c5 <alloc_block_BF+0x110>
  8030ae:	83 ec 04             	sub    $0x4,%esp
  8030b1:	68 60 45 80 00       	push   $0x804560
  8030b6:	68 49 01 00 00       	push   $0x149
  8030bb:	68 eb 44 80 00       	push   $0x8044eb
  8030c0:	e8 8c d6 ff ff       	call   800751 <_panic>
  8030c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c8:	8b 10                	mov    (%eax),%edx
  8030ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8030cd:	89 10                	mov    %edx,(%eax)
  8030cf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8030d2:	8b 00                	mov    (%eax),%eax
  8030d4:	85 c0                	test   %eax,%eax
  8030d6:	74 0b                	je     8030e3 <alloc_block_BF+0x12e>
  8030d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030db:	8b 00                	mov    (%eax),%eax
  8030dd:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8030e0:	89 50 04             	mov    %edx,0x4(%eax)
  8030e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8030e9:	89 10                	mov    %edx,(%eax)
  8030eb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8030ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030f1:	89 50 04             	mov    %edx,0x4(%eax)
  8030f4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8030f7:	8b 00                	mov    (%eax),%eax
  8030f9:	85 c0                	test   %eax,%eax
  8030fb:	75 08                	jne    803105 <alloc_block_BF+0x150>
  8030fd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803100:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803105:	a1 54 50 98 00       	mov    0x985054,%eax
  80310a:	40                   	inc    %eax
  80310b:	a3 54 50 98 00       	mov    %eax,0x985054

		// update the allocated block and remove it from freeBlocksList
		set_block_data(minBlk,totalSize,1);
  803110:	83 ec 04             	sub    $0x4,%esp
  803113:	6a 01                	push   $0x1
  803115:	ff 75 e8             	pushl  -0x18(%ebp)
  803118:	ff 75 f4             	pushl  -0xc(%ebp)
  80311b:	e8 74 f8 ff ff       	call   802994 <set_block_data>
  803120:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  803123:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803127:	75 17                	jne    803140 <alloc_block_BF+0x18b>
  803129:	83 ec 04             	sub    $0x4,%esp
  80312c:	68 94 45 80 00       	push   $0x804594
  803131:	68 4e 01 00 00       	push   $0x14e
  803136:	68 eb 44 80 00       	push   $0x8044eb
  80313b:	e8 11 d6 ff ff       	call   800751 <_panic>
  803140:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803143:	8b 00                	mov    (%eax),%eax
  803145:	85 c0                	test   %eax,%eax
  803147:	74 10                	je     803159 <alloc_block_BF+0x1a4>
  803149:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314c:	8b 00                	mov    (%eax),%eax
  80314e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803151:	8b 52 04             	mov    0x4(%edx),%edx
  803154:	89 50 04             	mov    %edx,0x4(%eax)
  803157:	eb 0b                	jmp    803164 <alloc_block_BF+0x1af>
  803159:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315c:	8b 40 04             	mov    0x4(%eax),%eax
  80315f:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803164:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803167:	8b 40 04             	mov    0x4(%eax),%eax
  80316a:	85 c0                	test   %eax,%eax
  80316c:	74 0f                	je     80317d <alloc_block_BF+0x1c8>
  80316e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803171:	8b 40 04             	mov    0x4(%eax),%eax
  803174:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803177:	8b 12                	mov    (%edx),%edx
  803179:	89 10                	mov    %edx,(%eax)
  80317b:	eb 0a                	jmp    803187 <alloc_block_BF+0x1d2>
  80317d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803180:	8b 00                	mov    (%eax),%eax
  803182:	a3 48 50 98 00       	mov    %eax,0x985048
  803187:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803190:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803193:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80319a:	a1 54 50 98 00       	mov    0x985054,%eax
  80319f:	48                   	dec    %eax
  8031a0:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  8031a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a8:	e9 98 00 00 00       	jmp    803245 <alloc_block_BF+0x290>
	}
	else // if set internal fragmentation
	{
		// add the remaining size to the block we allocate so it will be the same main block size
		set_block_data(minBlk,minSize,1);
  8031ad:	83 ec 04             	sub    $0x4,%esp
  8031b0:	6a 01                	push   $0x1
  8031b2:	ff 75 f0             	pushl  -0x10(%ebp)
  8031b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8031b8:	e8 d7 f7 ff ff       	call   802994 <set_block_data>
  8031bd:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  8031c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031c4:	75 17                	jne    8031dd <alloc_block_BF+0x228>
  8031c6:	83 ec 04             	sub    $0x4,%esp
  8031c9:	68 94 45 80 00       	push   $0x804594
  8031ce:	68 56 01 00 00       	push   $0x156
  8031d3:	68 eb 44 80 00       	push   $0x8044eb
  8031d8:	e8 74 d5 ff ff       	call   800751 <_panic>
  8031dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e0:	8b 00                	mov    (%eax),%eax
  8031e2:	85 c0                	test   %eax,%eax
  8031e4:	74 10                	je     8031f6 <alloc_block_BF+0x241>
  8031e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e9:	8b 00                	mov    (%eax),%eax
  8031eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031ee:	8b 52 04             	mov    0x4(%edx),%edx
  8031f1:	89 50 04             	mov    %edx,0x4(%eax)
  8031f4:	eb 0b                	jmp    803201 <alloc_block_BF+0x24c>
  8031f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f9:	8b 40 04             	mov    0x4(%eax),%eax
  8031fc:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803201:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803204:	8b 40 04             	mov    0x4(%eax),%eax
  803207:	85 c0                	test   %eax,%eax
  803209:	74 0f                	je     80321a <alloc_block_BF+0x265>
  80320b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320e:	8b 40 04             	mov    0x4(%eax),%eax
  803211:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803214:	8b 12                	mov    (%edx),%edx
  803216:	89 10                	mov    %edx,(%eax)
  803218:	eb 0a                	jmp    803224 <alloc_block_BF+0x26f>
  80321a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80321d:	8b 00                	mov    (%eax),%eax
  80321f:	a3 48 50 98 00       	mov    %eax,0x985048
  803224:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803227:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80322d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803230:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803237:	a1 54 50 98 00       	mov    0x985054,%eax
  80323c:	48                   	dec    %eax
  80323d:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  803242:	8b 45 f4             	mov    -0xc(%ebp),%eax
	}
	return NULL;
}
  803245:	c9                   	leave  
  803246:	c3                   	ret    

00803247 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803247:	55                   	push   %ebp
  803248:	89 e5                	mov    %esp,%ebp
  80324a:	83 ec 48             	sub    $0x48,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
  80324d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803251:	0f 84 6a 02 00 00    	je     8034c1 <free_block+0x27a>
	{
		return;
	}

	uint32 freeSize = get_block_size(va);
  803257:	ff 75 08             	pushl  0x8(%ebp)
  80325a:	e8 b9 f4 ff ff       	call   802718 <get_block_size>
  80325f:	83 c4 04             	add    $0x4,%esp
  803262:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// footer for the prev block for the block that we want to free it
	uint32 *footerPrev = ((uint32*)va - 2 );
  803265:	8b 45 08             	mov    0x8(%ebp),%eax
  803268:	83 e8 08             	sub    $0x8,%eax
  80326b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 pSize = (*footerPrev) & ~(0x1);
  80326e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803271:	8b 00                	mov    (%eax),%eax
  803273:	83 e0 fe             	and    $0xfffffffe,%eax
  803276:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// the prev block for the block that we want to free it
	struct BlockElement * prevBlk = (struct BlockElement *)((char*)va - pSize);
  803279:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80327c:	f7 d8                	neg    %eax
  80327e:	89 c2                	mov    %eax,%edx
  803280:	8b 45 08             	mov    0x8(%ebp),%eax
  803283:	01 d0                	add    %edx,%eax
  803285:	89 45 e8             	mov    %eax,-0x18(%ebp)
	uint32 isPrevFree = is_free_block(prevBlk);
  803288:	ff 75 e8             	pushl  -0x18(%ebp)
  80328b:	e8 a1 f4 ff ff       	call   802731 <is_free_block>
  803290:	83 c4 04             	add    $0x4,%esp
  803293:	0f be c0             	movsbl %al,%eax
  803296:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
  803299:	8b 55 08             	mov    0x8(%ebp),%edx
  80329c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80329f:	01 d0                	add    %edx,%eax
  8032a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  8032a4:	ff 75 e0             	pushl  -0x20(%ebp)
  8032a7:	e8 85 f4 ff ff       	call   802731 <is_free_block>
  8032ac:	83 c4 04             	add    $0x4,%esp
  8032af:	0f be c0             	movsbl %al,%eax
  8032b2:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if(isPrevFree == 1 && isNextFree == 0)
  8032b5:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  8032b9:	75 34                	jne    8032ef <free_block+0xa8>
  8032bb:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8032bf:	75 2e                	jne    8032ef <free_block+0xa8>
	{
		// merge the block will be free with its prev block
		uint32 prevSize = get_block_size(prevBlk);
  8032c1:	ff 75 e8             	pushl  -0x18(%ebp)
  8032c4:	e8 4f f4 ff ff       	call   802718 <get_block_size>
  8032c9:	83 c4 04             	add    $0x4,%esp
  8032cc:	89 45 d8             	mov    %eax,-0x28(%ebp)
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
  8032cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032d2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8032d5:	01 d0                	add    %edx,%eax
  8032d7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
  8032da:	6a 00                	push   $0x0
  8032dc:	ff 75 d4             	pushl  -0x2c(%ebp)
  8032df:	ff 75 e8             	pushl  -0x18(%ebp)
  8032e2:	e8 ad f6 ff ff       	call   802994 <set_block_data>
  8032e7:	83 c4 0c             	add    $0xc,%esp
	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
	uint32 isNextFree = is_free_block(nextBlk);

	if(isPrevFree == 1 && isNextFree == 0)
	{
  8032ea:	e9 d3 01 00 00       	jmp    8034c2 <free_block+0x27b>
		uint32 prevSize = get_block_size(prevBlk);
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
  8032ef:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  8032f3:	0f 85 c8 00 00 00    	jne    8033c1 <free_block+0x17a>
  8032f9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8032fd:	0f 85 be 00 00 00    	jne    8033c1 <free_block+0x17a>
	{
		// merge the block will be free with its next block
		uint32 nextSize = get_block_size(nextBlk);
  803303:	ff 75 e0             	pushl  -0x20(%ebp)
  803306:	e8 0d f4 ff ff       	call   802718 <get_block_size>
  80330b:	83 c4 04             	add    $0x4,%esp
  80330e:	89 45 d0             	mov    %eax,-0x30(%ebp)
		uint32 totalSize = freeSize + nextSize; // size of main block and its next block
  803311:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803314:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803317:	01 d0                	add    %edx,%eax
  803319:	89 45 cc             	mov    %eax,-0x34(%ebp)
		// update the size of block to contain its size and the size of next block
		set_block_data(va,totalSize,0);
  80331c:	6a 00                	push   $0x0
  80331e:	ff 75 cc             	pushl  -0x34(%ebp)
  803321:	ff 75 08             	pushl  0x8(%ebp)
  803324:	e8 6b f6 ff ff       	call   802994 <set_block_data>
  803329:	83 c4 0c             	add    $0xc,%esp
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
  80332c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803330:	75 17                	jne    803349 <free_block+0x102>
  803332:	83 ec 04             	sub    $0x4,%esp
  803335:	68 94 45 80 00       	push   $0x804594
  80333a:	68 87 01 00 00       	push   $0x187
  80333f:	68 eb 44 80 00       	push   $0x8044eb
  803344:	e8 08 d4 ff ff       	call   800751 <_panic>
  803349:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80334c:	8b 00                	mov    (%eax),%eax
  80334e:	85 c0                	test   %eax,%eax
  803350:	74 10                	je     803362 <free_block+0x11b>
  803352:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803355:	8b 00                	mov    (%eax),%eax
  803357:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80335a:	8b 52 04             	mov    0x4(%edx),%edx
  80335d:	89 50 04             	mov    %edx,0x4(%eax)
  803360:	eb 0b                	jmp    80336d <free_block+0x126>
  803362:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803365:	8b 40 04             	mov    0x4(%eax),%eax
  803368:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80336d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803370:	8b 40 04             	mov    0x4(%eax),%eax
  803373:	85 c0                	test   %eax,%eax
  803375:	74 0f                	je     803386 <free_block+0x13f>
  803377:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80337a:	8b 40 04             	mov    0x4(%eax),%eax
  80337d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803380:	8b 12                	mov    (%edx),%edx
  803382:	89 10                	mov    %edx,(%eax)
  803384:	eb 0a                	jmp    803390 <free_block+0x149>
  803386:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803389:	8b 00                	mov    (%eax),%eax
  80338b:	a3 48 50 98 00       	mov    %eax,0x985048
  803390:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803393:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803399:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80339c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033a3:	a1 54 50 98 00       	mov    0x985054,%eax
  8033a8:	48                   	dec    %eax
  8033a9:	a3 54 50 98 00       	mov    %eax,0x985054
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  8033ae:	83 ec 0c             	sub    $0xc,%esp
  8033b1:	ff 75 08             	pushl  0x8(%ebp)
  8033b4:	e8 32 f6 ff ff       	call   8029eb <insert_sorted_in_freeList>
  8033b9:	83 c4 10             	add    $0x10,%esp
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
	{
  8033bc:	e9 01 01 00 00       	jmp    8034c2 <free_block+0x27b>
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
  8033c1:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  8033c5:	0f 85 d3 00 00 00    	jne    80349e <free_block+0x257>
  8033cb:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  8033cf:	0f 85 c9 00 00 00    	jne    80349e <free_block+0x257>
	{
		// merge the block will be free with its prev and next blocks
		uint32 prevSize = get_block_size(prevBlk);
  8033d5:	83 ec 0c             	sub    $0xc,%esp
  8033d8:	ff 75 e8             	pushl  -0x18(%ebp)
  8033db:	e8 38 f3 ff ff       	call   802718 <get_block_size>
  8033e0:	83 c4 10             	add    $0x10,%esp
  8033e3:	89 45 c8             	mov    %eax,-0x38(%ebp)
		uint32 nextSize = get_block_size(nextBlk);
  8033e6:	83 ec 0c             	sub    $0xc,%esp
  8033e9:	ff 75 e0             	pushl  -0x20(%ebp)
  8033ec:	e8 27 f3 ff ff       	call   802718 <get_block_size>
  8033f1:	83 c4 10             	add    $0x10,%esp
  8033f4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 totalSize = freeSize + prevSize + nextSize; // size of main block and its prev and next blocks
  8033f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033fa:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033fd:	01 c2                	add    %eax,%edx
  8033ff:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803402:	01 d0                	add    %edx,%eax
  803404:	89 45 c0             	mov    %eax,-0x40(%ebp)
		// extends prev block size to contain its size and the size of main and next blocks
		set_block_data(prevBlk,totalSize,0);
  803407:	83 ec 04             	sub    $0x4,%esp
  80340a:	6a 00                	push   $0x0
  80340c:	ff 75 c0             	pushl  -0x40(%ebp)
  80340f:	ff 75 e8             	pushl  -0x18(%ebp)
  803412:	e8 7d f5 ff ff       	call   802994 <set_block_data>
  803417:	83 c4 10             	add    $0x10,%esp
		// remove next block because we merge it with its prev blocks
		LIST_REMOVE(&freeBlocksList, nextBlk);
  80341a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80341e:	75 17                	jne    803437 <free_block+0x1f0>
  803420:	83 ec 04             	sub    $0x4,%esp
  803423:	68 94 45 80 00       	push   $0x804594
  803428:	68 94 01 00 00       	push   $0x194
  80342d:	68 eb 44 80 00       	push   $0x8044eb
  803432:	e8 1a d3 ff ff       	call   800751 <_panic>
  803437:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80343a:	8b 00                	mov    (%eax),%eax
  80343c:	85 c0                	test   %eax,%eax
  80343e:	74 10                	je     803450 <free_block+0x209>
  803440:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803443:	8b 00                	mov    (%eax),%eax
  803445:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803448:	8b 52 04             	mov    0x4(%edx),%edx
  80344b:	89 50 04             	mov    %edx,0x4(%eax)
  80344e:	eb 0b                	jmp    80345b <free_block+0x214>
  803450:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803453:	8b 40 04             	mov    0x4(%eax),%eax
  803456:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80345b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80345e:	8b 40 04             	mov    0x4(%eax),%eax
  803461:	85 c0                	test   %eax,%eax
  803463:	74 0f                	je     803474 <free_block+0x22d>
  803465:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803468:	8b 40 04             	mov    0x4(%eax),%eax
  80346b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80346e:	8b 12                	mov    (%edx),%edx
  803470:	89 10                	mov    %edx,(%eax)
  803472:	eb 0a                	jmp    80347e <free_block+0x237>
  803474:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803477:	8b 00                	mov    (%eax),%eax
  803479:	a3 48 50 98 00       	mov    %eax,0x985048
  80347e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803481:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803487:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80348a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803491:	a1 54 50 98 00       	mov    0x985054,%eax
  803496:	48                   	dec    %eax
  803497:	a3 54 50 98 00       	mov    %eax,0x985054
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
	{
  80349c:	eb 24                	jmp    8034c2 <free_block+0x27b>
	}
	else
	{
		// free it without any merge
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
  80349e:	83 ec 04             	sub    $0x4,%esp
  8034a1:	6a 00                	push   $0x0
  8034a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8034a6:	ff 75 08             	pushl  0x8(%ebp)
  8034a9:	e8 e6 f4 ff ff       	call   802994 <set_block_data>
  8034ae:	83 c4 10             	add    $0x10,%esp
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  8034b1:	83 ec 0c             	sub    $0xc,%esp
  8034b4:	ff 75 08             	pushl  0x8(%ebp)
  8034b7:	e8 2f f5 ff ff       	call   8029eb <insert_sorted_in_freeList>
  8034bc:	83 c4 10             	add    $0x10,%esp
  8034bf:	eb 01                	jmp    8034c2 <free_block+0x27b>
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
	{
		return;
  8034c1:	90                   	nop
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
}
  8034c2:	c9                   	leave  
  8034c3:	c3                   	ret    

008034c4 <realloc_block_FF>:
//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
  8034c4:	55                   	push   %ebp
  8034c5:	89 e5                	mov    %esp,%ebp
  8034c7:	83 ec 38             	sub    $0x38,%esp
	//TODO: [PROJECT'24.MS1 - #08] [3] DYNAMIC ALLOCATOR - realloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(va == NULL && new_size == 0)
  8034ca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034ce:	75 10                	jne    8034e0 <realloc_block_FF+0x1c>
  8034d0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8034d4:	75 0a                	jne    8034e0 <realloc_block_FF+0x1c>
	{
		return NULL;
  8034d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8034db:	e9 8b 04 00 00       	jmp    80396b <realloc_block_FF+0x4a7>
	}

	if(new_size == 0)
  8034e0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8034e4:	75 18                	jne    8034fe <realloc_block_FF+0x3a>
	{
		free_block(va);
  8034e6:	83 ec 0c             	sub    $0xc,%esp
  8034e9:	ff 75 08             	pushl  0x8(%ebp)
  8034ec:	e8 56 fd ff ff       	call   803247 <free_block>
  8034f1:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8034f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8034f9:	e9 6d 04 00 00       	jmp    80396b <realloc_block_FF+0x4a7>
	}

	if(va == NULL)
  8034fe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803502:	75 13                	jne    803517 <realloc_block_FF+0x53>
	{
		return alloc_block_FF(new_size);
  803504:	83 ec 0c             	sub    $0xc,%esp
  803507:	ff 75 0c             	pushl  0xc(%ebp)
  80350a:	e8 6f f6 ff ff       	call   802b7e <alloc_block_FF>
  80350f:	83 c4 10             	add    $0x10,%esp
  803512:	e9 54 04 00 00       	jmp    80396b <realloc_block_FF+0x4a7>
	}

	// if size is odd must be increment it by one
	if (new_size % 2 != 0)
  803517:	8b 45 0c             	mov    0xc(%ebp),%eax
  80351a:	83 e0 01             	and    $0x1,%eax
  80351d:	85 c0                	test   %eax,%eax
  80351f:	74 03                	je     803524 <realloc_block_FF+0x60>
	{
		new_size++;
  803521:	ff 45 0c             	incl   0xc(%ebp)
	}

	// if size < 8 must be equal it to 8 because min size 8 excluding metadata
	if(new_size < 8)
  803524:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803528:	77 07                	ja     803531 <realloc_block_FF+0x6d>
	{
		new_size = 8;
  80352a:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	}

	new_size += 8; // adds its footer and header size
  803531:	83 45 0c 08          	addl   $0x8,0xc(%ebp)

	uint32 actualSize = get_block_size(va);
  803535:	83 ec 0c             	sub    $0xc,%esp
  803538:	ff 75 08             	pushl  0x8(%ebp)
  80353b:	e8 d8 f1 ff ff       	call   802718 <get_block_size>
  803540:	83 c4 10             	add    $0x10,%esp
  803543:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(actualSize == new_size)
  803546:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803549:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80354c:	75 08                	jne    803556 <realloc_block_FF+0x92>
	{
		// don't change any thing
		return va;
  80354e:	8b 45 08             	mov    0x8(%ebp),%eax
  803551:	e9 15 04 00 00       	jmp    80396b <realloc_block_FF+0x4a7>
	}

	// next block for the block we want to change its size
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + actualSize);
  803556:	8b 55 08             	mov    0x8(%ebp),%edx
  803559:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80355c:	01 d0                	add    %edx,%eax
  80355e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  803561:	83 ec 0c             	sub    $0xc,%esp
  803564:	ff 75 f0             	pushl  -0x10(%ebp)
  803567:	e8 c5 f1 ff ff       	call   802731 <is_free_block>
  80356c:	83 c4 10             	add    $0x10,%esp
  80356f:	0f be c0             	movsbl %al,%eax
  803572:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 nextSize = get_block_size(nextBlk);
  803575:	83 ec 0c             	sub    $0xc,%esp
  803578:	ff 75 f0             	pushl  -0x10(%ebp)
  80357b:	e8 98 f1 ff ff       	call   802718 <get_block_size>
  803580:	83 c4 10             	add    $0x10,%esp
  803583:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// increase the size of block
	if(new_size > actualSize)
  803586:	8b 45 0c             	mov    0xc(%ebp),%eax
  803589:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80358c:	0f 86 a7 02 00 00    	jbe    803839 <realloc_block_FF+0x375>
	{
		if(isNextFree)
  803592:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803596:	0f 84 86 02 00 00    	je     803822 <realloc_block_FF+0x35e>
		{
			if(nextSize + actualSize == new_size) // block and nextblock = newSizeBlock
  80359c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80359f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a2:	01 d0                	add    %edx,%eax
  8035a4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8035a7:	0f 85 b2 00 00 00    	jne    80365f <realloc_block_FF+0x19b>
			{
				set_block_data(va,new_size,!(is_free_block(va)));// update size in block
  8035ad:	83 ec 0c             	sub    $0xc,%esp
  8035b0:	ff 75 08             	pushl  0x8(%ebp)
  8035b3:	e8 79 f1 ff ff       	call   802731 <is_free_block>
  8035b8:	83 c4 10             	add    $0x10,%esp
  8035bb:	84 c0                	test   %al,%al
  8035bd:	0f 94 c0             	sete   %al
  8035c0:	0f b6 c0             	movzbl %al,%eax
  8035c3:	83 ec 04             	sub    $0x4,%esp
  8035c6:	50                   	push   %eax
  8035c7:	ff 75 0c             	pushl  0xc(%ebp)
  8035ca:	ff 75 08             	pushl  0x8(%ebp)
  8035cd:	e8 c2 f3 ff ff       	call   802994 <set_block_data>
  8035d2:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);// remove next because it is = zero
  8035d5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8035d9:	75 17                	jne    8035f2 <realloc_block_FF+0x12e>
  8035db:	83 ec 04             	sub    $0x4,%esp
  8035de:	68 94 45 80 00       	push   $0x804594
  8035e3:	68 db 01 00 00       	push   $0x1db
  8035e8:	68 eb 44 80 00       	push   $0x8044eb
  8035ed:	e8 5f d1 ff ff       	call   800751 <_panic>
  8035f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035f5:	8b 00                	mov    (%eax),%eax
  8035f7:	85 c0                	test   %eax,%eax
  8035f9:	74 10                	je     80360b <realloc_block_FF+0x147>
  8035fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035fe:	8b 00                	mov    (%eax),%eax
  803600:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803603:	8b 52 04             	mov    0x4(%edx),%edx
  803606:	89 50 04             	mov    %edx,0x4(%eax)
  803609:	eb 0b                	jmp    803616 <realloc_block_FF+0x152>
  80360b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80360e:	8b 40 04             	mov    0x4(%eax),%eax
  803611:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803616:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803619:	8b 40 04             	mov    0x4(%eax),%eax
  80361c:	85 c0                	test   %eax,%eax
  80361e:	74 0f                	je     80362f <realloc_block_FF+0x16b>
  803620:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803623:	8b 40 04             	mov    0x4(%eax),%eax
  803626:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803629:	8b 12                	mov    (%edx),%edx
  80362b:	89 10                	mov    %edx,(%eax)
  80362d:	eb 0a                	jmp    803639 <realloc_block_FF+0x175>
  80362f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803632:	8b 00                	mov    (%eax),%eax
  803634:	a3 48 50 98 00       	mov    %eax,0x985048
  803639:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80363c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803642:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803645:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80364c:	a1 54 50 98 00       	mov    0x985054,%eax
  803651:	48                   	dec    %eax
  803652:	a3 54 50 98 00       	mov    %eax,0x985054
				return va;
  803657:	8b 45 08             	mov    0x8(%ebp),%eax
  80365a:	e9 0c 03 00 00       	jmp    80396b <realloc_block_FF+0x4a7>
			}
			else if(nextSize + actualSize > new_size) // new size is less than next and main blocks
  80365f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803662:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803665:	01 d0                	add    %edx,%eax
  803667:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80366a:	0f 86 b2 01 00 00    	jbe    803822 <realloc_block_FF+0x35e>
			{
				uint32 requiredSize = new_size - actualSize; // size that we need from the next block
  803670:	8b 45 0c             	mov    0xc(%ebp),%eax
  803673:	2b 45 f4             	sub    -0xc(%ebp),%eax
  803676:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				uint32 remainingNext = nextSize - requiredSize; // size that will remain from the next block after we split it
  803679:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80367c:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80367f:	89 45 e0             	mov    %eax,-0x20(%ebp)

				// if next size will not fit another block (internal fragmentation)
				if(remainingNext < 16)
  803682:	83 7d e0 0f          	cmpl   $0xf,-0x20(%ebp)
  803686:	0f 87 b8 00 00 00    	ja     803744 <realloc_block_FF+0x280>
				{
					// we will take the main size of the block and its next size also
					set_block_data(va,actualSize + nextSize,!(is_free_block(va)));
  80368c:	83 ec 0c             	sub    $0xc,%esp
  80368f:	ff 75 08             	pushl  0x8(%ebp)
  803692:	e8 9a f0 ff ff       	call   802731 <is_free_block>
  803697:	83 c4 10             	add    $0x10,%esp
  80369a:	84 c0                	test   %al,%al
  80369c:	0f 94 c0             	sete   %al
  80369f:	0f b6 c0             	movzbl %al,%eax
  8036a2:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8036a5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036a8:	01 ca                	add    %ecx,%edx
  8036aa:	83 ec 04             	sub    $0x4,%esp
  8036ad:	50                   	push   %eax
  8036ae:	52                   	push   %edx
  8036af:	ff 75 08             	pushl  0x8(%ebp)
  8036b2:	e8 dd f2 ff ff       	call   802994 <set_block_data>
  8036b7:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,nextBlk);
  8036ba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8036be:	75 17                	jne    8036d7 <realloc_block_FF+0x213>
  8036c0:	83 ec 04             	sub    $0x4,%esp
  8036c3:	68 94 45 80 00       	push   $0x804594
  8036c8:	68 e8 01 00 00       	push   $0x1e8
  8036cd:	68 eb 44 80 00       	push   $0x8044eb
  8036d2:	e8 7a d0 ff ff       	call   800751 <_panic>
  8036d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036da:	8b 00                	mov    (%eax),%eax
  8036dc:	85 c0                	test   %eax,%eax
  8036de:	74 10                	je     8036f0 <realloc_block_FF+0x22c>
  8036e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036e3:	8b 00                	mov    (%eax),%eax
  8036e5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036e8:	8b 52 04             	mov    0x4(%edx),%edx
  8036eb:	89 50 04             	mov    %edx,0x4(%eax)
  8036ee:	eb 0b                	jmp    8036fb <realloc_block_FF+0x237>
  8036f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036f3:	8b 40 04             	mov    0x4(%eax),%eax
  8036f6:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8036fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036fe:	8b 40 04             	mov    0x4(%eax),%eax
  803701:	85 c0                	test   %eax,%eax
  803703:	74 0f                	je     803714 <realloc_block_FF+0x250>
  803705:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803708:	8b 40 04             	mov    0x4(%eax),%eax
  80370b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80370e:	8b 12                	mov    (%edx),%edx
  803710:	89 10                	mov    %edx,(%eax)
  803712:	eb 0a                	jmp    80371e <realloc_block_FF+0x25a>
  803714:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803717:	8b 00                	mov    (%eax),%eax
  803719:	a3 48 50 98 00       	mov    %eax,0x985048
  80371e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803721:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803727:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80372a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803731:	a1 54 50 98 00       	mov    0x985054,%eax
  803736:	48                   	dec    %eax
  803737:	a3 54 50 98 00       	mov    %eax,0x985054
					return va;
  80373c:	8b 45 08             	mov    0x8(%ebp),%eax
  80373f:	e9 27 02 00 00       	jmp    80396b <realloc_block_FF+0x4a7>
				}
				else // if next size can be fit another block (split)
				{
					LIST_REMOVE(&freeBlocksList,nextBlk);
  803744:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803748:	75 17                	jne    803761 <realloc_block_FF+0x29d>
  80374a:	83 ec 04             	sub    $0x4,%esp
  80374d:	68 94 45 80 00       	push   $0x804594
  803752:	68 ed 01 00 00       	push   $0x1ed
  803757:	68 eb 44 80 00       	push   $0x8044eb
  80375c:	e8 f0 cf ff ff       	call   800751 <_panic>
  803761:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803764:	8b 00                	mov    (%eax),%eax
  803766:	85 c0                	test   %eax,%eax
  803768:	74 10                	je     80377a <realloc_block_FF+0x2b6>
  80376a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80376d:	8b 00                	mov    (%eax),%eax
  80376f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803772:	8b 52 04             	mov    0x4(%edx),%edx
  803775:	89 50 04             	mov    %edx,0x4(%eax)
  803778:	eb 0b                	jmp    803785 <realloc_block_FF+0x2c1>
  80377a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80377d:	8b 40 04             	mov    0x4(%eax),%eax
  803780:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803785:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803788:	8b 40 04             	mov    0x4(%eax),%eax
  80378b:	85 c0                	test   %eax,%eax
  80378d:	74 0f                	je     80379e <realloc_block_FF+0x2da>
  80378f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803792:	8b 40 04             	mov    0x4(%eax),%eax
  803795:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803798:	8b 12                	mov    (%edx),%edx
  80379a:	89 10                	mov    %edx,(%eax)
  80379c:	eb 0a                	jmp    8037a8 <realloc_block_FF+0x2e4>
  80379e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037a1:	8b 00                	mov    (%eax),%eax
  8037a3:	a3 48 50 98 00       	mov    %eax,0x985048
  8037a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037b4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037bb:	a1 54 50 98 00       	mov    0x985054,%eax
  8037c0:	48                   	dec    %eax
  8037c1:	a3 54 50 98 00       	mov    %eax,0x985054
					nextBlk = (struct BlockElement *)((char *)va + new_size); //update nextBlk address
  8037c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8037c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037cc:	01 d0                	add    %edx,%eax
  8037ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
					set_block_data(nextBlk,remainingNext,0); // update nextBlkSize
  8037d1:	83 ec 04             	sub    $0x4,%esp
  8037d4:	6a 00                	push   $0x0
  8037d6:	ff 75 e0             	pushl  -0x20(%ebp)
  8037d9:	ff 75 f0             	pushl  -0x10(%ebp)
  8037dc:	e8 b3 f1 ff ff       	call   802994 <set_block_data>
  8037e1:	83 c4 10             	add    $0x10,%esp
					set_block_data(va,new_size,!(is_free_block(va))); // update size of newblock
  8037e4:	83 ec 0c             	sub    $0xc,%esp
  8037e7:	ff 75 08             	pushl  0x8(%ebp)
  8037ea:	e8 42 ef ff ff       	call   802731 <is_free_block>
  8037ef:	83 c4 10             	add    $0x10,%esp
  8037f2:	84 c0                	test   %al,%al
  8037f4:	0f 94 c0             	sete   %al
  8037f7:	0f b6 c0             	movzbl %al,%eax
  8037fa:	83 ec 04             	sub    $0x4,%esp
  8037fd:	50                   	push   %eax
  8037fe:	ff 75 0c             	pushl  0xc(%ebp)
  803801:	ff 75 08             	pushl  0x8(%ebp)
  803804:	e8 8b f1 ff ff       	call   802994 <set_block_data>
  803809:	83 c4 10             	add    $0x10,%esp
					insert_sorted_in_freeList(nextBlk);
  80380c:	83 ec 0c             	sub    $0xc,%esp
  80380f:	ff 75 f0             	pushl  -0x10(%ebp)
  803812:	e8 d4 f1 ff ff       	call   8029eb <insert_sorted_in_freeList>
  803817:	83 c4 10             	add    $0x10,%esp
					return va;
  80381a:	8b 45 08             	mov    0x8(%ebp),%eax
  80381d:	e9 49 01 00 00       	jmp    80396b <realloc_block_FF+0x4a7>
				}
			}
		}
		// if next block isn't free or not fit the new size
		return alloc_block_FF(new_size - 8);
  803822:	8b 45 0c             	mov    0xc(%ebp),%eax
  803825:	83 e8 08             	sub    $0x8,%eax
  803828:	83 ec 0c             	sub    $0xc,%esp
  80382b:	50                   	push   %eax
  80382c:	e8 4d f3 ff ff       	call   802b7e <alloc_block_FF>
  803831:	83 c4 10             	add    $0x10,%esp
  803834:	e9 32 01 00 00       	jmp    80396b <realloc_block_FF+0x4a7>
	}
	else if(new_size < actualSize) // to shrink block
  803839:	8b 45 0c             	mov    0xc(%ebp),%eax
  80383c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80383f:	0f 83 21 01 00 00    	jae    803966 <realloc_block_FF+0x4a2>
	{
		uint32 remainingSize = actualSize - new_size; // size that will remain from the main block after we shrink it
  803845:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803848:	2b 45 0c             	sub    0xc(%ebp),%eax
  80384b:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(remainingSize < 16 && isNextFree == 0) // internal fragmentation
  80384e:	83 7d dc 0f          	cmpl   $0xf,-0x24(%ebp)
  803852:	77 0e                	ja     803862 <realloc_block_FF+0x39e>
  803854:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803858:	75 08                	jne    803862 <realloc_block_FF+0x39e>
		{
			// don't change its size
			return va;
  80385a:	8b 45 08             	mov    0x8(%ebp),%eax
  80385d:	e9 09 01 00 00       	jmp    80396b <realloc_block_FF+0x4a7>
		}
		else // remainingSize fit in a new block
		{
			struct BlockElement *mainBlk = (struct BlockElement *)va;
  803862:	8b 45 08             	mov    0x8(%ebp),%eax
  803865:	89 45 d8             	mov    %eax,-0x28(%ebp)
			// update main block with new size
			set_block_data(mainBlk,new_size,!(is_free_block(va)));
  803868:	83 ec 0c             	sub    $0xc,%esp
  80386b:	ff 75 08             	pushl  0x8(%ebp)
  80386e:	e8 be ee ff ff       	call   802731 <is_free_block>
  803873:	83 c4 10             	add    $0x10,%esp
  803876:	84 c0                	test   %al,%al
  803878:	0f 94 c0             	sete   %al
  80387b:	0f b6 c0             	movzbl %al,%eax
  80387e:	83 ec 04             	sub    $0x4,%esp
  803881:	50                   	push   %eax
  803882:	ff 75 0c             	pushl  0xc(%ebp)
  803885:	ff 75 d8             	pushl  -0x28(%ebp)
  803888:	e8 07 f1 ff ff       	call   802994 <set_block_data>
  80388d:	83 c4 10             	add    $0x10,%esp

			// the blk with remaining size
			struct BlockElement *remainingBlk=(struct BlockElement *)((char*)mainBlk + new_size);
  803890:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803893:	8b 45 0c             	mov    0xc(%ebp),%eax
  803896:	01 d0                	add    %edx,%eax
  803898:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			set_block_data(remainingBlk,remainingSize,0);
  80389b:	83 ec 04             	sub    $0x4,%esp
  80389e:	6a 00                	push   $0x0
  8038a0:	ff 75 dc             	pushl  -0x24(%ebp)
  8038a3:	ff 75 d4             	pushl  -0x2c(%ebp)
  8038a6:	e8 e9 f0 ff ff       	call   802994 <set_block_data>
  8038ab:	83 c4 10             	add    $0x10,%esp

			if(isNextFree)
  8038ae:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8038b2:	0f 84 9b 00 00 00    	je     803953 <realloc_block_FF+0x48f>
			{
				// merge splited block with its next block
				set_block_data(remainingBlk,(remainingSize + nextSize),0);//merge remaining with its next block
  8038b8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8038bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038be:	01 d0                	add    %edx,%eax
  8038c0:	83 ec 04             	sub    $0x4,%esp
  8038c3:	6a 00                	push   $0x0
  8038c5:	50                   	push   %eax
  8038c6:	ff 75 d4             	pushl  -0x2c(%ebp)
  8038c9:	e8 c6 f0 ff ff       	call   802994 <set_block_data>
  8038ce:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);
  8038d1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8038d5:	75 17                	jne    8038ee <realloc_block_FF+0x42a>
  8038d7:	83 ec 04             	sub    $0x4,%esp
  8038da:	68 94 45 80 00       	push   $0x804594
  8038df:	68 10 02 00 00       	push   $0x210
  8038e4:	68 eb 44 80 00       	push   $0x8044eb
  8038e9:	e8 63 ce ff ff       	call   800751 <_panic>
  8038ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038f1:	8b 00                	mov    (%eax),%eax
  8038f3:	85 c0                	test   %eax,%eax
  8038f5:	74 10                	je     803907 <realloc_block_FF+0x443>
  8038f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038fa:	8b 00                	mov    (%eax),%eax
  8038fc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8038ff:	8b 52 04             	mov    0x4(%edx),%edx
  803902:	89 50 04             	mov    %edx,0x4(%eax)
  803905:	eb 0b                	jmp    803912 <realloc_block_FF+0x44e>
  803907:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80390a:	8b 40 04             	mov    0x4(%eax),%eax
  80390d:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803912:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803915:	8b 40 04             	mov    0x4(%eax),%eax
  803918:	85 c0                	test   %eax,%eax
  80391a:	74 0f                	je     80392b <realloc_block_FF+0x467>
  80391c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80391f:	8b 40 04             	mov    0x4(%eax),%eax
  803922:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803925:	8b 12                	mov    (%edx),%edx
  803927:	89 10                	mov    %edx,(%eax)
  803929:	eb 0a                	jmp    803935 <realloc_block_FF+0x471>
  80392b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80392e:	8b 00                	mov    (%eax),%eax
  803930:	a3 48 50 98 00       	mov    %eax,0x985048
  803935:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803938:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80393e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803941:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803948:	a1 54 50 98 00       	mov    0x985054,%eax
  80394d:	48                   	dec    %eax
  80394e:	a3 54 50 98 00       	mov    %eax,0x985054
			}
			insert_sorted_in_freeList(remainingBlk);
  803953:	83 ec 0c             	sub    $0xc,%esp
  803956:	ff 75 d4             	pushl  -0x2c(%ebp)
  803959:	e8 8d f0 ff ff       	call   8029eb <insert_sorted_in_freeList>
  80395e:	83 c4 10             	add    $0x10,%esp
			return mainBlk;
  803961:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803964:	eb 05                	jmp    80396b <realloc_block_FF+0x4a7>
		}
	}
	return NULL;
  803966:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80396b:	c9                   	leave  
  80396c:	c3                   	ret    

0080396d <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  80396d:	55                   	push   %ebp
  80396e:	89 e5                	mov    %esp,%ebp
  803970:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803973:	83 ec 04             	sub    $0x4,%esp
  803976:	68 b4 45 80 00       	push   $0x8045b4
  80397b:	68 20 02 00 00       	push   $0x220
  803980:	68 eb 44 80 00       	push   $0x8044eb
  803985:	e8 c7 cd ff ff       	call   800751 <_panic>

0080398a <alloc_block_NF>:
}
//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  80398a:	55                   	push   %ebp
  80398b:	89 e5                	mov    %esp,%ebp
  80398d:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803990:	83 ec 04             	sub    $0x4,%esp
  803993:	68 dc 45 80 00       	push   $0x8045dc
  803998:	68 28 02 00 00       	push   $0x228
  80399d:	68 eb 44 80 00       	push   $0x8044eb
  8039a2:	e8 aa cd ff ff       	call   800751 <_panic>
  8039a7:	90                   	nop

008039a8 <__udivdi3>:
  8039a8:	55                   	push   %ebp
  8039a9:	57                   	push   %edi
  8039aa:	56                   	push   %esi
  8039ab:	53                   	push   %ebx
  8039ac:	83 ec 1c             	sub    $0x1c,%esp
  8039af:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8039b3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8039b7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8039bb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8039bf:	89 ca                	mov    %ecx,%edx
  8039c1:	89 f8                	mov    %edi,%eax
  8039c3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8039c7:	85 f6                	test   %esi,%esi
  8039c9:	75 2d                	jne    8039f8 <__udivdi3+0x50>
  8039cb:	39 cf                	cmp    %ecx,%edi
  8039cd:	77 65                	ja     803a34 <__udivdi3+0x8c>
  8039cf:	89 fd                	mov    %edi,%ebp
  8039d1:	85 ff                	test   %edi,%edi
  8039d3:	75 0b                	jne    8039e0 <__udivdi3+0x38>
  8039d5:	b8 01 00 00 00       	mov    $0x1,%eax
  8039da:	31 d2                	xor    %edx,%edx
  8039dc:	f7 f7                	div    %edi
  8039de:	89 c5                	mov    %eax,%ebp
  8039e0:	31 d2                	xor    %edx,%edx
  8039e2:	89 c8                	mov    %ecx,%eax
  8039e4:	f7 f5                	div    %ebp
  8039e6:	89 c1                	mov    %eax,%ecx
  8039e8:	89 d8                	mov    %ebx,%eax
  8039ea:	f7 f5                	div    %ebp
  8039ec:	89 cf                	mov    %ecx,%edi
  8039ee:	89 fa                	mov    %edi,%edx
  8039f0:	83 c4 1c             	add    $0x1c,%esp
  8039f3:	5b                   	pop    %ebx
  8039f4:	5e                   	pop    %esi
  8039f5:	5f                   	pop    %edi
  8039f6:	5d                   	pop    %ebp
  8039f7:	c3                   	ret    
  8039f8:	39 ce                	cmp    %ecx,%esi
  8039fa:	77 28                	ja     803a24 <__udivdi3+0x7c>
  8039fc:	0f bd fe             	bsr    %esi,%edi
  8039ff:	83 f7 1f             	xor    $0x1f,%edi
  803a02:	75 40                	jne    803a44 <__udivdi3+0x9c>
  803a04:	39 ce                	cmp    %ecx,%esi
  803a06:	72 0a                	jb     803a12 <__udivdi3+0x6a>
  803a08:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803a0c:	0f 87 9e 00 00 00    	ja     803ab0 <__udivdi3+0x108>
  803a12:	b8 01 00 00 00       	mov    $0x1,%eax
  803a17:	89 fa                	mov    %edi,%edx
  803a19:	83 c4 1c             	add    $0x1c,%esp
  803a1c:	5b                   	pop    %ebx
  803a1d:	5e                   	pop    %esi
  803a1e:	5f                   	pop    %edi
  803a1f:	5d                   	pop    %ebp
  803a20:	c3                   	ret    
  803a21:	8d 76 00             	lea    0x0(%esi),%esi
  803a24:	31 ff                	xor    %edi,%edi
  803a26:	31 c0                	xor    %eax,%eax
  803a28:	89 fa                	mov    %edi,%edx
  803a2a:	83 c4 1c             	add    $0x1c,%esp
  803a2d:	5b                   	pop    %ebx
  803a2e:	5e                   	pop    %esi
  803a2f:	5f                   	pop    %edi
  803a30:	5d                   	pop    %ebp
  803a31:	c3                   	ret    
  803a32:	66 90                	xchg   %ax,%ax
  803a34:	89 d8                	mov    %ebx,%eax
  803a36:	f7 f7                	div    %edi
  803a38:	31 ff                	xor    %edi,%edi
  803a3a:	89 fa                	mov    %edi,%edx
  803a3c:	83 c4 1c             	add    $0x1c,%esp
  803a3f:	5b                   	pop    %ebx
  803a40:	5e                   	pop    %esi
  803a41:	5f                   	pop    %edi
  803a42:	5d                   	pop    %ebp
  803a43:	c3                   	ret    
  803a44:	bd 20 00 00 00       	mov    $0x20,%ebp
  803a49:	89 eb                	mov    %ebp,%ebx
  803a4b:	29 fb                	sub    %edi,%ebx
  803a4d:	89 f9                	mov    %edi,%ecx
  803a4f:	d3 e6                	shl    %cl,%esi
  803a51:	89 c5                	mov    %eax,%ebp
  803a53:	88 d9                	mov    %bl,%cl
  803a55:	d3 ed                	shr    %cl,%ebp
  803a57:	89 e9                	mov    %ebp,%ecx
  803a59:	09 f1                	or     %esi,%ecx
  803a5b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803a5f:	89 f9                	mov    %edi,%ecx
  803a61:	d3 e0                	shl    %cl,%eax
  803a63:	89 c5                	mov    %eax,%ebp
  803a65:	89 d6                	mov    %edx,%esi
  803a67:	88 d9                	mov    %bl,%cl
  803a69:	d3 ee                	shr    %cl,%esi
  803a6b:	89 f9                	mov    %edi,%ecx
  803a6d:	d3 e2                	shl    %cl,%edx
  803a6f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a73:	88 d9                	mov    %bl,%cl
  803a75:	d3 e8                	shr    %cl,%eax
  803a77:	09 c2                	or     %eax,%edx
  803a79:	89 d0                	mov    %edx,%eax
  803a7b:	89 f2                	mov    %esi,%edx
  803a7d:	f7 74 24 0c          	divl   0xc(%esp)
  803a81:	89 d6                	mov    %edx,%esi
  803a83:	89 c3                	mov    %eax,%ebx
  803a85:	f7 e5                	mul    %ebp
  803a87:	39 d6                	cmp    %edx,%esi
  803a89:	72 19                	jb     803aa4 <__udivdi3+0xfc>
  803a8b:	74 0b                	je     803a98 <__udivdi3+0xf0>
  803a8d:	89 d8                	mov    %ebx,%eax
  803a8f:	31 ff                	xor    %edi,%edi
  803a91:	e9 58 ff ff ff       	jmp    8039ee <__udivdi3+0x46>
  803a96:	66 90                	xchg   %ax,%ax
  803a98:	8b 54 24 08          	mov    0x8(%esp),%edx
  803a9c:	89 f9                	mov    %edi,%ecx
  803a9e:	d3 e2                	shl    %cl,%edx
  803aa0:	39 c2                	cmp    %eax,%edx
  803aa2:	73 e9                	jae    803a8d <__udivdi3+0xe5>
  803aa4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803aa7:	31 ff                	xor    %edi,%edi
  803aa9:	e9 40 ff ff ff       	jmp    8039ee <__udivdi3+0x46>
  803aae:	66 90                	xchg   %ax,%ax
  803ab0:	31 c0                	xor    %eax,%eax
  803ab2:	e9 37 ff ff ff       	jmp    8039ee <__udivdi3+0x46>
  803ab7:	90                   	nop

00803ab8 <__umoddi3>:
  803ab8:	55                   	push   %ebp
  803ab9:	57                   	push   %edi
  803aba:	56                   	push   %esi
  803abb:	53                   	push   %ebx
  803abc:	83 ec 1c             	sub    $0x1c,%esp
  803abf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803ac3:	8b 74 24 34          	mov    0x34(%esp),%esi
  803ac7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803acb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803acf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803ad3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803ad7:	89 f3                	mov    %esi,%ebx
  803ad9:	89 fa                	mov    %edi,%edx
  803adb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803adf:	89 34 24             	mov    %esi,(%esp)
  803ae2:	85 c0                	test   %eax,%eax
  803ae4:	75 1a                	jne    803b00 <__umoddi3+0x48>
  803ae6:	39 f7                	cmp    %esi,%edi
  803ae8:	0f 86 a2 00 00 00    	jbe    803b90 <__umoddi3+0xd8>
  803aee:	89 c8                	mov    %ecx,%eax
  803af0:	89 f2                	mov    %esi,%edx
  803af2:	f7 f7                	div    %edi
  803af4:	89 d0                	mov    %edx,%eax
  803af6:	31 d2                	xor    %edx,%edx
  803af8:	83 c4 1c             	add    $0x1c,%esp
  803afb:	5b                   	pop    %ebx
  803afc:	5e                   	pop    %esi
  803afd:	5f                   	pop    %edi
  803afe:	5d                   	pop    %ebp
  803aff:	c3                   	ret    
  803b00:	39 f0                	cmp    %esi,%eax
  803b02:	0f 87 ac 00 00 00    	ja     803bb4 <__umoddi3+0xfc>
  803b08:	0f bd e8             	bsr    %eax,%ebp
  803b0b:	83 f5 1f             	xor    $0x1f,%ebp
  803b0e:	0f 84 ac 00 00 00    	je     803bc0 <__umoddi3+0x108>
  803b14:	bf 20 00 00 00       	mov    $0x20,%edi
  803b19:	29 ef                	sub    %ebp,%edi
  803b1b:	89 fe                	mov    %edi,%esi
  803b1d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803b21:	89 e9                	mov    %ebp,%ecx
  803b23:	d3 e0                	shl    %cl,%eax
  803b25:	89 d7                	mov    %edx,%edi
  803b27:	89 f1                	mov    %esi,%ecx
  803b29:	d3 ef                	shr    %cl,%edi
  803b2b:	09 c7                	or     %eax,%edi
  803b2d:	89 e9                	mov    %ebp,%ecx
  803b2f:	d3 e2                	shl    %cl,%edx
  803b31:	89 14 24             	mov    %edx,(%esp)
  803b34:	89 d8                	mov    %ebx,%eax
  803b36:	d3 e0                	shl    %cl,%eax
  803b38:	89 c2                	mov    %eax,%edx
  803b3a:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b3e:	d3 e0                	shl    %cl,%eax
  803b40:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b44:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b48:	89 f1                	mov    %esi,%ecx
  803b4a:	d3 e8                	shr    %cl,%eax
  803b4c:	09 d0                	or     %edx,%eax
  803b4e:	d3 eb                	shr    %cl,%ebx
  803b50:	89 da                	mov    %ebx,%edx
  803b52:	f7 f7                	div    %edi
  803b54:	89 d3                	mov    %edx,%ebx
  803b56:	f7 24 24             	mull   (%esp)
  803b59:	89 c6                	mov    %eax,%esi
  803b5b:	89 d1                	mov    %edx,%ecx
  803b5d:	39 d3                	cmp    %edx,%ebx
  803b5f:	0f 82 87 00 00 00    	jb     803bec <__umoddi3+0x134>
  803b65:	0f 84 91 00 00 00    	je     803bfc <__umoddi3+0x144>
  803b6b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803b6f:	29 f2                	sub    %esi,%edx
  803b71:	19 cb                	sbb    %ecx,%ebx
  803b73:	89 d8                	mov    %ebx,%eax
  803b75:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803b79:	d3 e0                	shl    %cl,%eax
  803b7b:	89 e9                	mov    %ebp,%ecx
  803b7d:	d3 ea                	shr    %cl,%edx
  803b7f:	09 d0                	or     %edx,%eax
  803b81:	89 e9                	mov    %ebp,%ecx
  803b83:	d3 eb                	shr    %cl,%ebx
  803b85:	89 da                	mov    %ebx,%edx
  803b87:	83 c4 1c             	add    $0x1c,%esp
  803b8a:	5b                   	pop    %ebx
  803b8b:	5e                   	pop    %esi
  803b8c:	5f                   	pop    %edi
  803b8d:	5d                   	pop    %ebp
  803b8e:	c3                   	ret    
  803b8f:	90                   	nop
  803b90:	89 fd                	mov    %edi,%ebp
  803b92:	85 ff                	test   %edi,%edi
  803b94:	75 0b                	jne    803ba1 <__umoddi3+0xe9>
  803b96:	b8 01 00 00 00       	mov    $0x1,%eax
  803b9b:	31 d2                	xor    %edx,%edx
  803b9d:	f7 f7                	div    %edi
  803b9f:	89 c5                	mov    %eax,%ebp
  803ba1:	89 f0                	mov    %esi,%eax
  803ba3:	31 d2                	xor    %edx,%edx
  803ba5:	f7 f5                	div    %ebp
  803ba7:	89 c8                	mov    %ecx,%eax
  803ba9:	f7 f5                	div    %ebp
  803bab:	89 d0                	mov    %edx,%eax
  803bad:	e9 44 ff ff ff       	jmp    803af6 <__umoddi3+0x3e>
  803bb2:	66 90                	xchg   %ax,%ax
  803bb4:	89 c8                	mov    %ecx,%eax
  803bb6:	89 f2                	mov    %esi,%edx
  803bb8:	83 c4 1c             	add    $0x1c,%esp
  803bbb:	5b                   	pop    %ebx
  803bbc:	5e                   	pop    %esi
  803bbd:	5f                   	pop    %edi
  803bbe:	5d                   	pop    %ebp
  803bbf:	c3                   	ret    
  803bc0:	3b 04 24             	cmp    (%esp),%eax
  803bc3:	72 06                	jb     803bcb <__umoddi3+0x113>
  803bc5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803bc9:	77 0f                	ja     803bda <__umoddi3+0x122>
  803bcb:	89 f2                	mov    %esi,%edx
  803bcd:	29 f9                	sub    %edi,%ecx
  803bcf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803bd3:	89 14 24             	mov    %edx,(%esp)
  803bd6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803bda:	8b 44 24 04          	mov    0x4(%esp),%eax
  803bde:	8b 14 24             	mov    (%esp),%edx
  803be1:	83 c4 1c             	add    $0x1c,%esp
  803be4:	5b                   	pop    %ebx
  803be5:	5e                   	pop    %esi
  803be6:	5f                   	pop    %edi
  803be7:	5d                   	pop    %ebp
  803be8:	c3                   	ret    
  803be9:	8d 76 00             	lea    0x0(%esi),%esi
  803bec:	2b 04 24             	sub    (%esp),%eax
  803bef:	19 fa                	sbb    %edi,%edx
  803bf1:	89 d1                	mov    %edx,%ecx
  803bf3:	89 c6                	mov    %eax,%esi
  803bf5:	e9 71 ff ff ff       	jmp    803b6b <__umoddi3+0xb3>
  803bfa:	66 90                	xchg   %ax,%ax
  803bfc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803c00:	72 ea                	jb     803bec <__umoddi3+0x134>
  803c02:	89 d9                	mov    %ebx,%ecx
  803c04:	e9 62 ff ff ff       	jmp    803b6b <__umoddi3+0xb3>
