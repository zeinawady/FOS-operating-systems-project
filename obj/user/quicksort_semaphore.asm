
obj/user/quicksort_semaphore:     file format elf32-i386


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
  800031:	e8 3b 06 00 00       	call   800671 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void QuickSort(int *Elements, int NumOfElements);
void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex);
uint32 CheckSorted(int *Elements, int NumOfElements);
struct semaphore IO_CS ;
void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	81 ec 34 01 00 00    	sub    $0x134,%esp
	int envID = sys_getenvid();
  800042:	e8 69 23 00 00       	call   8023b0 <sys_getenvid>
  800047:	89 45 f0             	mov    %eax,-0x10(%ebp)
	char Chose ;
	char Line[255] ;
	int Iteration = 0 ;
  80004a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	IO_CS = create_semaphore("IO.CS", 1);
  800051:	8d 85 d4 fe ff ff    	lea    -0x12c(%ebp),%eax
  800057:	83 ec 04             	sub    $0x4,%esp
  80005a:	6a 01                	push   $0x1
  80005c:	68 20 3e 80 00       	push   $0x803e20
  800061:	50                   	push   %eax
  800062:	e8 a5 39 00 00       	call   803a0c <create_semaphore>
  800067:	83 c4 0c             	add    $0xc,%esp
  80006a:	8b 85 d4 fe ff ff    	mov    -0x12c(%ebp),%eax
  800070:	a3 5c 50 98 00       	mov    %eax,0x98505c
	do
	{
		int InitFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames();
  800075:	e8 86 21 00 00       	call   802200 <sys_calculate_free_frames>
  80007a:	89 c3                	mov    %eax,%ebx
  80007c:	e8 98 21 00 00       	call   802219 <sys_calculate_modified_frames>
  800081:	01 d8                	add    %ebx,%eax
  800083:	89 45 ec             	mov    %eax,-0x14(%ebp)

		Iteration++ ;
  800086:	ff 45 f4             	incl   -0xc(%ebp)
		//		cprintf("Free Frames Before Allocation = %d\n", sys_calculate_free_frames()) ;

//	sys_lock_cons();
		int NumOfElements, *Elements;
		wait_semaphore(IO_CS);
  800089:	83 ec 0c             	sub    $0xc,%esp
  80008c:	ff 35 5c 50 98 00    	pushl  0x98505c
  800092:	e8 41 3a 00 00       	call   803ad8 <wait_semaphore>
  800097:	83 c4 10             	add    $0x10,%esp
		{
			readline("Enter the number of elements: ", Line);
  80009a:	83 ec 08             	sub    $0x8,%esp
  80009d:	8d 85 dd fe ff ff    	lea    -0x123(%ebp),%eax
  8000a3:	50                   	push   %eax
  8000a4:	68 28 3e 80 00       	push   $0x803e28
  8000a9:	e8 59 10 00 00       	call   801107 <readline>
  8000ae:	83 c4 10             	add    $0x10,%esp
			NumOfElements = strtol(Line, NULL, 10) ;
  8000b1:	83 ec 04             	sub    $0x4,%esp
  8000b4:	6a 0a                	push   $0xa
  8000b6:	6a 00                	push   $0x0
  8000b8:	8d 85 dd fe ff ff    	lea    -0x123(%ebp),%eax
  8000be:	50                   	push   %eax
  8000bf:	e8 ab 15 00 00       	call   80166f <strtol>
  8000c4:	83 c4 10             	add    $0x10,%esp
  8000c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
			Elements = malloc(sizeof(int) * NumOfElements) ;
  8000ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000cd:	c1 e0 02             	shl    $0x2,%eax
  8000d0:	83 ec 0c             	sub    $0xc,%esp
  8000d3:	50                   	push   %eax
  8000d4:	e8 52 19 00 00       	call   801a2b <malloc>
  8000d9:	83 c4 10             	add    $0x10,%esp
  8000dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			cprintf("Choose the initialization method:\n") ;
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	68 48 3e 80 00       	push   $0x803e48
  8000e7:	e8 87 09 00 00       	call   800a73 <cprintf>
  8000ec:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000ef:	83 ec 0c             	sub    $0xc,%esp
  8000f2:	68 6b 3e 80 00       	push   $0x803e6b
  8000f7:	e8 77 09 00 00       	call   800a73 <cprintf>
  8000fc:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	68 79 3e 80 00       	push   $0x803e79
  800107:	e8 67 09 00 00       	call   800a73 <cprintf>
  80010c:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	68 88 3e 80 00       	push   $0x803e88
  800117:	e8 57 09 00 00       	call   800a73 <cprintf>
  80011c:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	68 98 3e 80 00       	push   $0x803e98
  800127:	e8 47 09 00 00       	call   800a73 <cprintf>
  80012c:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  80012f:	e8 20 05 00 00       	call   800654 <getchar>
  800134:	88 45 e3             	mov    %al,-0x1d(%ebp)
				cputchar(Chose);
  800137:	0f be 45 e3          	movsbl -0x1d(%ebp),%eax
  80013b:	83 ec 0c             	sub    $0xc,%esp
  80013e:	50                   	push   %eax
  80013f:	e8 f1 04 00 00       	call   800635 <cputchar>
  800144:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800147:	83 ec 0c             	sub    $0xc,%esp
  80014a:	6a 0a                	push   $0xa
  80014c:	e8 e4 04 00 00       	call   800635 <cputchar>
  800151:	83 c4 10             	add    $0x10,%esp
			} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800154:	80 7d e3 61          	cmpb   $0x61,-0x1d(%ebp)
  800158:	74 0c                	je     800166 <_main+0x12e>
  80015a:	80 7d e3 62          	cmpb   $0x62,-0x1d(%ebp)
  80015e:	74 06                	je     800166 <_main+0x12e>
  800160:	80 7d e3 63          	cmpb   $0x63,-0x1d(%ebp)
  800164:	75 b9                	jne    80011f <_main+0xe7>

		}
		signal_semaphore(IO_CS);
  800166:	83 ec 0c             	sub    $0xc,%esp
  800169:	ff 35 5c 50 98 00    	pushl  0x98505c
  80016f:	e8 ce 39 00 00       	call   803b42 <signal_semaphore>
  800174:	83 c4 10             	add    $0x10,%esp

		//sys_unlock_cons();
		int  i ;
		switch (Chose)
  800177:	0f be 45 e3          	movsbl -0x1d(%ebp),%eax
  80017b:	83 f8 62             	cmp    $0x62,%eax
  80017e:	74 1d                	je     80019d <_main+0x165>
  800180:	83 f8 63             	cmp    $0x63,%eax
  800183:	74 2b                	je     8001b0 <_main+0x178>
  800185:	83 f8 61             	cmp    $0x61,%eax
  800188:	75 39                	jne    8001c3 <_main+0x18b>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  80018a:	83 ec 08             	sub    $0x8,%esp
  80018d:	ff 75 e8             	pushl  -0x18(%ebp)
  800190:	ff 75 e4             	pushl  -0x1c(%ebp)
  800193:	e8 2e 03 00 00       	call   8004c6 <InitializeAscending>
  800198:	83 c4 10             	add    $0x10,%esp
			break ;
  80019b:	eb 37                	jmp    8001d4 <_main+0x19c>
		case 'b':
			InitializeIdentical(Elements, NumOfElements);
  80019d:	83 ec 08             	sub    $0x8,%esp
  8001a0:	ff 75 e8             	pushl  -0x18(%ebp)
  8001a3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001a6:	e8 4c 03 00 00       	call   8004f7 <InitializeIdentical>
  8001ab:	83 c4 10             	add    $0x10,%esp
			break ;
  8001ae:	eb 24                	jmp    8001d4 <_main+0x19c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001b0:	83 ec 08             	sub    $0x8,%esp
  8001b3:	ff 75 e8             	pushl  -0x18(%ebp)
  8001b6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001b9:	e8 6e 03 00 00       	call   80052c <InitializeSemiRandom>
  8001be:	83 c4 10             	add    $0x10,%esp
			break ;
  8001c1:	eb 11                	jmp    8001d4 <_main+0x19c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001c3:	83 ec 08             	sub    $0x8,%esp
  8001c6:	ff 75 e8             	pushl  -0x18(%ebp)
  8001c9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001cc:	e8 5b 03 00 00       	call   80052c <InitializeSemiRandom>
  8001d1:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  8001d4:	83 ec 08             	sub    $0x8,%esp
  8001d7:	ff 75 e8             	pushl  -0x18(%ebp)
  8001da:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001dd:	e8 29 01 00 00       	call   80030b <QuickSort>
  8001e2:	83 c4 10             	add    $0x10,%esp

		//		PrintElements(Elements, NumOfElements);

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001e5:	83 ec 08             	sub    $0x8,%esp
  8001e8:	ff 75 e8             	pushl  -0x18(%ebp)
  8001eb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001ee:	e8 29 02 00 00       	call   80041c <CheckSorted>
  8001f3:	83 c4 10             	add    $0x10,%esp
  8001f6:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001f9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8001fd:	75 14                	jne    800213 <_main+0x1db>
  8001ff:	83 ec 04             	sub    $0x4,%esp
  800202:	68 a4 3e 80 00       	push   $0x803ea4
  800207:	6a 4d                	push   $0x4d
  800209:	68 c6 3e 80 00       	push   $0x803ec6
  80020e:	e8 a3 05 00 00       	call   8007b6 <_panic>
		else
		{
			wait_semaphore(IO_CS);
  800213:	83 ec 0c             	sub    $0xc,%esp
  800216:	ff 35 5c 50 98 00    	pushl  0x98505c
  80021c:	e8 b7 38 00 00       	call   803ad8 <wait_semaphore>
  800221:	83 c4 10             	add    $0x10,%esp
				cprintf("\n===============================================\n") ;
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	68 e4 3e 80 00       	push   $0x803ee4
  80022c:	e8 42 08 00 00       	call   800a73 <cprintf>
  800231:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	68 18 3f 80 00       	push   $0x803f18
  80023c:	e8 32 08 00 00       	call   800a73 <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 4c 3f 80 00       	push   $0x803f4c
  80024c:	e8 22 08 00 00       	call   800a73 <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
			signal_semaphore(IO_CS);
  800254:	83 ec 0c             	sub    $0xc,%esp
  800257:	ff 35 5c 50 98 00    	pushl  0x98505c
  80025d:	e8 e0 38 00 00       	call   803b42 <signal_semaphore>
  800262:	83 c4 10             	add    $0x10,%esp
		}

		//		cprintf("Free Frames After Calculation = %d\n", sys_calculate_free_frames()) ;

		wait_semaphore(IO_CS);
  800265:	83 ec 0c             	sub    $0xc,%esp
  800268:	ff 35 5c 50 98 00    	pushl  0x98505c
  80026e:	e8 65 38 00 00       	call   803ad8 <wait_semaphore>
  800273:	83 c4 10             	add    $0x10,%esp
			cprintf("Freeing the Heap...\n\n") ;
  800276:	83 ec 0c             	sub    $0xc,%esp
  800279:	68 7e 3f 80 00       	push   $0x803f7e
  80027e:	e8 f0 07 00 00       	call   800a73 <cprintf>
  800283:	83 c4 10             	add    $0x10,%esp
		signal_semaphore(IO_CS);
  800286:	83 ec 0c             	sub    $0xc,%esp
  800289:	ff 35 5c 50 98 00    	pushl  0x98505c
  80028f:	e8 ae 38 00 00       	call   803b42 <signal_semaphore>
  800294:	83 c4 10             	add    $0x10,%esp

		//freeHeap() ;

		///========================================================================
	//sys_lock_cons();
		wait_semaphore(IO_CS);
  800297:	83 ec 0c             	sub    $0xc,%esp
  80029a:	ff 35 5c 50 98 00    	pushl  0x98505c
  8002a0:	e8 33 38 00 00       	call   803ad8 <wait_semaphore>
  8002a5:	83 c4 10             	add    $0x10,%esp
			cprintf("Do you want to repeat (y/n): ") ;
  8002a8:	83 ec 0c             	sub    $0xc,%esp
  8002ab:	68 94 3f 80 00       	push   $0x803f94
  8002b0:	e8 be 07 00 00       	call   800a73 <cprintf>
  8002b5:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  8002b8:	e8 97 03 00 00       	call   800654 <getchar>
  8002bd:	88 45 e3             	mov    %al,-0x1d(%ebp)
			cputchar(Chose);
  8002c0:	0f be 45 e3          	movsbl -0x1d(%ebp),%eax
  8002c4:	83 ec 0c             	sub    $0xc,%esp
  8002c7:	50                   	push   %eax
  8002c8:	e8 68 03 00 00       	call   800635 <cputchar>
  8002cd:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8002d0:	83 ec 0c             	sub    $0xc,%esp
  8002d3:	6a 0a                	push   $0xa
  8002d5:	e8 5b 03 00 00       	call   800635 <cputchar>
  8002da:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8002dd:	83 ec 0c             	sub    $0xc,%esp
  8002e0:	6a 0a                	push   $0xa
  8002e2:	e8 4e 03 00 00       	call   800635 <cputchar>
  8002e7:	83 c4 10             	add    $0x10,%esp
	//sys_unlock_cons();
		signal_semaphore(IO_CS);
  8002ea:	83 ec 0c             	sub    $0xc,%esp
  8002ed:	ff 35 5c 50 98 00    	pushl  0x98505c
  8002f3:	e8 4a 38 00 00       	call   803b42 <signal_semaphore>
  8002f8:	83 c4 10             	add    $0x10,%esp

	} while (Chose == 'y');
  8002fb:	80 7d e3 79          	cmpb   $0x79,-0x1d(%ebp)
  8002ff:	0f 84 70 fd ff ff    	je     800075 <_main+0x3d>

}
  800305:	90                   	nop
  800306:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800309:	c9                   	leave  
  80030a:	c3                   	ret    

0080030b <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  80030b:	55                   	push   %ebp
  80030c:	89 e5                	mov    %esp,%ebp
  80030e:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  800311:	8b 45 0c             	mov    0xc(%ebp),%eax
  800314:	48                   	dec    %eax
  800315:	50                   	push   %eax
  800316:	6a 00                	push   $0x0
  800318:	ff 75 0c             	pushl  0xc(%ebp)
  80031b:	ff 75 08             	pushl  0x8(%ebp)
  80031e:	e8 06 00 00 00       	call   800329 <QSort>
  800323:	83 c4 10             	add    $0x10,%esp
}
  800326:	90                   	nop
  800327:	c9                   	leave  
  800328:	c3                   	ret    

00800329 <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  800329:	55                   	push   %ebp
  80032a:	89 e5                	mov    %esp,%ebp
  80032c:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  80032f:	8b 45 10             	mov    0x10(%ebp),%eax
  800332:	3b 45 14             	cmp    0x14(%ebp),%eax
  800335:	0f 8d de 00 00 00    	jge    800419 <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  80033b:	8b 45 10             	mov    0x10(%ebp),%eax
  80033e:	40                   	inc    %eax
  80033f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800342:	8b 45 14             	mov    0x14(%ebp),%eax
  800345:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  800348:	e9 80 00 00 00       	jmp    8003cd <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  80034d:	ff 45 f4             	incl   -0xc(%ebp)
  800350:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800353:	3b 45 14             	cmp    0x14(%ebp),%eax
  800356:	7f 2b                	jg     800383 <QSort+0x5a>
  800358:	8b 45 10             	mov    0x10(%ebp),%eax
  80035b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800362:	8b 45 08             	mov    0x8(%ebp),%eax
  800365:	01 d0                	add    %edx,%eax
  800367:	8b 10                	mov    (%eax),%edx
  800369:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80036c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800373:	8b 45 08             	mov    0x8(%ebp),%eax
  800376:	01 c8                	add    %ecx,%eax
  800378:	8b 00                	mov    (%eax),%eax
  80037a:	39 c2                	cmp    %eax,%edx
  80037c:	7d cf                	jge    80034d <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  80037e:	eb 03                	jmp    800383 <QSort+0x5a>
  800380:	ff 4d f0             	decl   -0x10(%ebp)
  800383:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800386:	3b 45 10             	cmp    0x10(%ebp),%eax
  800389:	7e 26                	jle    8003b1 <QSort+0x88>
  80038b:	8b 45 10             	mov    0x10(%ebp),%eax
  80038e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800395:	8b 45 08             	mov    0x8(%ebp),%eax
  800398:	01 d0                	add    %edx,%eax
  80039a:	8b 10                	mov    (%eax),%edx
  80039c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80039f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a9:	01 c8                	add    %ecx,%eax
  8003ab:	8b 00                	mov    (%eax),%eax
  8003ad:	39 c2                	cmp    %eax,%edx
  8003af:	7e cf                	jle    800380 <QSort+0x57>

		if (i <= j)
  8003b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003b4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003b7:	7f 14                	jg     8003cd <QSort+0xa4>
		{
			Swap(Elements, i, j);
  8003b9:	83 ec 04             	sub    $0x4,%esp
  8003bc:	ff 75 f0             	pushl  -0x10(%ebp)
  8003bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8003c2:	ff 75 08             	pushl  0x8(%ebp)
  8003c5:	e8 a9 00 00 00       	call   800473 <Swap>
  8003ca:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  8003cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003d0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003d3:	0f 8e 77 ff ff ff    	jle    800350 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  8003d9:	83 ec 04             	sub    $0x4,%esp
  8003dc:	ff 75 f0             	pushl  -0x10(%ebp)
  8003df:	ff 75 10             	pushl  0x10(%ebp)
  8003e2:	ff 75 08             	pushl  0x8(%ebp)
  8003e5:	e8 89 00 00 00       	call   800473 <Swap>
  8003ea:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  8003ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f0:	48                   	dec    %eax
  8003f1:	50                   	push   %eax
  8003f2:	ff 75 10             	pushl  0x10(%ebp)
  8003f5:	ff 75 0c             	pushl  0xc(%ebp)
  8003f8:	ff 75 08             	pushl  0x8(%ebp)
  8003fb:	e8 29 ff ff ff       	call   800329 <QSort>
  800400:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  800403:	ff 75 14             	pushl  0x14(%ebp)
  800406:	ff 75 f4             	pushl  -0xc(%ebp)
  800409:	ff 75 0c             	pushl  0xc(%ebp)
  80040c:	ff 75 08             	pushl  0x8(%ebp)
  80040f:	e8 15 ff ff ff       	call   800329 <QSort>
  800414:	83 c4 10             	add    $0x10,%esp
  800417:	eb 01                	jmp    80041a <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  800419:	90                   	nop

	Swap( Elements, startIndex, j);

	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);
}
  80041a:	c9                   	leave  
  80041b:	c3                   	ret    

0080041c <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  80041c:	55                   	push   %ebp
  80041d:	89 e5                	mov    %esp,%ebp
  80041f:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  800422:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800429:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800430:	eb 33                	jmp    800465 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  800432:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800435:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80043c:	8b 45 08             	mov    0x8(%ebp),%eax
  80043f:	01 d0                	add    %edx,%eax
  800441:	8b 10                	mov    (%eax),%edx
  800443:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800446:	40                   	inc    %eax
  800447:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80044e:	8b 45 08             	mov    0x8(%ebp),%eax
  800451:	01 c8                	add    %ecx,%eax
  800453:	8b 00                	mov    (%eax),%eax
  800455:	39 c2                	cmp    %eax,%edx
  800457:	7e 09                	jle    800462 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800459:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800460:	eb 0c                	jmp    80046e <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800462:	ff 45 f8             	incl   -0x8(%ebp)
  800465:	8b 45 0c             	mov    0xc(%ebp),%eax
  800468:	48                   	dec    %eax
  800469:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80046c:	7f c4                	jg     800432 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  80046e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800471:	c9                   	leave  
  800472:	c3                   	ret    

00800473 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  800473:	55                   	push   %ebp
  800474:	89 e5                	mov    %esp,%ebp
  800476:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800479:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800483:	8b 45 08             	mov    0x8(%ebp),%eax
  800486:	01 d0                	add    %edx,%eax
  800488:	8b 00                	mov    (%eax),%eax
  80048a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  80048d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800490:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800497:	8b 45 08             	mov    0x8(%ebp),%eax
  80049a:	01 c2                	add    %eax,%edx
  80049c:	8b 45 10             	mov    0x10(%ebp),%eax
  80049f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a9:	01 c8                	add    %ecx,%eax
  8004ab:	8b 00                	mov    (%eax),%eax
  8004ad:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  8004af:	8b 45 10             	mov    0x10(%ebp),%eax
  8004b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bc:	01 c2                	add    %eax,%edx
  8004be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004c1:	89 02                	mov    %eax,(%edx)
}
  8004c3:	90                   	nop
  8004c4:	c9                   	leave  
  8004c5:	c3                   	ret    

008004c6 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  8004c6:	55                   	push   %ebp
  8004c7:	89 e5                	mov    %esp,%ebp
  8004c9:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004d3:	eb 17                	jmp    8004ec <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  8004d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004d8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004df:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e2:	01 c2                	add    %eax,%edx
  8004e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004e7:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004e9:	ff 45 fc             	incl   -0x4(%ebp)
  8004ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004ef:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004f2:	7c e1                	jl     8004d5 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8004f4:	90                   	nop
  8004f5:	c9                   	leave  
  8004f6:	c3                   	ret    

008004f7 <InitializeIdentical>:

void InitializeIdentical(int *Elements, int NumOfElements)
{
  8004f7:	55                   	push   %ebp
  8004f8:	89 e5                	mov    %esp,%ebp
  8004fa:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800504:	eb 1b                	jmp    800521 <InitializeIdentical+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  800506:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800509:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800510:	8b 45 08             	mov    0x8(%ebp),%eax
  800513:	01 c2                	add    %eax,%edx
  800515:	8b 45 0c             	mov    0xc(%ebp),%eax
  800518:	2b 45 fc             	sub    -0x4(%ebp),%eax
  80051b:	48                   	dec    %eax
  80051c:	89 02                	mov    %eax,(%edx)
}

void InitializeIdentical(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80051e:	ff 45 fc             	incl   -0x4(%ebp)
  800521:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800524:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800527:	7c dd                	jl     800506 <InitializeIdentical+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  800529:	90                   	nop
  80052a:	c9                   	leave  
  80052b:	c3                   	ret    

0080052c <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  80052c:	55                   	push   %ebp
  80052d:	89 e5                	mov    %esp,%ebp
  80052f:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  800532:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800535:	b8 56 55 55 55       	mov    $0x55555556,%eax
  80053a:	f7 e9                	imul   %ecx
  80053c:	c1 f9 1f             	sar    $0x1f,%ecx
  80053f:	89 d0                	mov    %edx,%eax
  800541:	29 c8                	sub    %ecx,%eax
  800543:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (Repetition == 0)
  800546:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80054a:	75 07                	jne    800553 <InitializeSemiRandom+0x27>
			Repetition = 3;
  80054c:	c7 45 f8 03 00 00 00 	movl   $0x3,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  800553:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80055a:	eb 1e                	jmp    80057a <InitializeSemiRandom+0x4e>
	{
		Elements[i] = i % Repetition ;
  80055c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80055f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800566:	8b 45 08             	mov    0x8(%ebp),%eax
  800569:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80056c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80056f:	99                   	cltd   
  800570:	f7 7d f8             	idivl  -0x8(%ebp)
  800573:	89 d0                	mov    %edx,%eax
  800575:	89 01                	mov    %eax,(%ecx)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	if (Repetition == 0)
			Repetition = 3;
	for (i = 0 ; i < NumOfElements ; i++)
  800577:	ff 45 fc             	incl   -0x4(%ebp)
  80057a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80057d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800580:	7c da                	jl     80055c <InitializeSemiRandom+0x30>
	{
		Elements[i] = i % Repetition ;
	}

}
  800582:	90                   	nop
  800583:	c9                   	leave  
  800584:	c3                   	ret    

00800585 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800585:	55                   	push   %ebp
  800586:	89 e5                	mov    %esp,%ebp
  800588:	83 ec 18             	sub    $0x18,%esp
	int envID = sys_getenvid();
  80058b:	e8 20 1e 00 00       	call   8023b0 <sys_getenvid>
  800590:	89 45 f0             	mov    %eax,-0x10(%ebp)
	wait_semaphore(IO_CS);
  800593:	83 ec 0c             	sub    $0xc,%esp
  800596:	ff 35 5c 50 98 00    	pushl  0x98505c
  80059c:	e8 37 35 00 00       	call   803ad8 <wait_semaphore>
  8005a1:	83 c4 10             	add    $0x10,%esp
		int i ;
		int NumsPerLine = 20 ;
  8005a4:	c7 45 ec 14 00 00 00 	movl   $0x14,-0x14(%ebp)
		for (i = 0 ; i < NumOfElements-1 ; i++)
  8005ab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8005b2:	eb 42                	jmp    8005f6 <PrintElements+0x71>
		{
			if (i%NumsPerLine == 0)
  8005b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005b7:	99                   	cltd   
  8005b8:	f7 7d ec             	idivl  -0x14(%ebp)
  8005bb:	89 d0                	mov    %edx,%eax
  8005bd:	85 c0                	test   %eax,%eax
  8005bf:	75 10                	jne    8005d1 <PrintElements+0x4c>
				cprintf("\n");
  8005c1:	83 ec 0c             	sub    $0xc,%esp
  8005c4:	68 b2 3f 80 00       	push   $0x803fb2
  8005c9:	e8 a5 04 00 00       	call   800a73 <cprintf>
  8005ce:	83 c4 10             	add    $0x10,%esp
			cprintf("%d, ",Elements[i]);
  8005d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005d4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005db:	8b 45 08             	mov    0x8(%ebp),%eax
  8005de:	01 d0                	add    %edx,%eax
  8005e0:	8b 00                	mov    (%eax),%eax
  8005e2:	83 ec 08             	sub    $0x8,%esp
  8005e5:	50                   	push   %eax
  8005e6:	68 b4 3f 80 00       	push   $0x803fb4
  8005eb:	e8 83 04 00 00       	call   800a73 <cprintf>
  8005f0:	83 c4 10             	add    $0x10,%esp
{
	int envID = sys_getenvid();
	wait_semaphore(IO_CS);
		int i ;
		int NumsPerLine = 20 ;
		for (i = 0 ; i < NumOfElements-1 ; i++)
  8005f3:	ff 45 f4             	incl   -0xc(%ebp)
  8005f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f9:	48                   	dec    %eax
  8005fa:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8005fd:	7f b5                	jg     8005b4 <PrintElements+0x2f>
		{
			if (i%NumsPerLine == 0)
				cprintf("\n");
			cprintf("%d, ",Elements[i]);
		}
		cprintf("%d\n",Elements[i]);
  8005ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800602:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800609:	8b 45 08             	mov    0x8(%ebp),%eax
  80060c:	01 d0                	add    %edx,%eax
  80060e:	8b 00                	mov    (%eax),%eax
  800610:	83 ec 08             	sub    $0x8,%esp
  800613:	50                   	push   %eax
  800614:	68 b9 3f 80 00       	push   $0x803fb9
  800619:	e8 55 04 00 00       	call   800a73 <cprintf>
  80061e:	83 c4 10             	add    $0x10,%esp
	signal_semaphore(IO_CS);
  800621:	83 ec 0c             	sub    $0xc,%esp
  800624:	ff 35 5c 50 98 00    	pushl  0x98505c
  80062a:	e8 13 35 00 00       	call   803b42 <signal_semaphore>
  80062f:	83 c4 10             	add    $0x10,%esp
}
  800632:	90                   	nop
  800633:	c9                   	leave  
  800634:	c3                   	ret    

00800635 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800635:	55                   	push   %ebp
  800636:	89 e5                	mov    %esp,%ebp
  800638:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  80063b:	8b 45 08             	mov    0x8(%ebp),%eax
  80063e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800641:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800645:	83 ec 0c             	sub    $0xc,%esp
  800648:	50                   	push   %eax
  800649:	e8 4a 1c 00 00       	call   802298 <sys_cputc>
  80064e:	83 c4 10             	add    $0x10,%esp
}
  800651:	90                   	nop
  800652:	c9                   	leave  
  800653:	c3                   	ret    

00800654 <getchar>:


int
getchar(void)
{
  800654:	55                   	push   %ebp
  800655:	89 e5                	mov    %esp,%ebp
  800657:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  80065a:	e8 d5 1a 00 00       	call   802134 <sys_cgetc>
  80065f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  800662:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800665:	c9                   	leave  
  800666:	c3                   	ret    

00800667 <iscons>:

int iscons(int fdnum)
{
  800667:	55                   	push   %ebp
  800668:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80066a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80066f:	5d                   	pop    %ebp
  800670:	c3                   	ret    

00800671 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800671:	55                   	push   %ebp
  800672:	89 e5                	mov    %esp,%ebp
  800674:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800677:	e8 4d 1d 00 00       	call   8023c9 <sys_getenvindex>
  80067c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80067f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800682:	89 d0                	mov    %edx,%eax
  800684:	c1 e0 02             	shl    $0x2,%eax
  800687:	01 d0                	add    %edx,%eax
  800689:	c1 e0 03             	shl    $0x3,%eax
  80068c:	01 d0                	add    %edx,%eax
  80068e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800695:	01 d0                	add    %edx,%eax
  800697:	c1 e0 02             	shl    $0x2,%eax
  80069a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80069f:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8006a4:	a1 24 50 80 00       	mov    0x805024,%eax
  8006a9:	8a 40 20             	mov    0x20(%eax),%al
  8006ac:	84 c0                	test   %al,%al
  8006ae:	74 0d                	je     8006bd <libmain+0x4c>
		binaryname = myEnv->prog_name;
  8006b0:	a1 24 50 80 00       	mov    0x805024,%eax
  8006b5:	83 c0 20             	add    $0x20,%eax
  8006b8:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006bd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8006c1:	7e 0a                	jle    8006cd <libmain+0x5c>
		binaryname = argv[0];
  8006c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006c6:	8b 00                	mov    (%eax),%eax
  8006c8:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  8006cd:	83 ec 08             	sub    $0x8,%esp
  8006d0:	ff 75 0c             	pushl  0xc(%ebp)
  8006d3:	ff 75 08             	pushl  0x8(%ebp)
  8006d6:	e8 5d f9 ff ff       	call   800038 <_main>
  8006db:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8006de:	a1 00 50 80 00       	mov    0x805000,%eax
  8006e3:	85 c0                	test   %eax,%eax
  8006e5:	0f 84 9f 00 00 00    	je     80078a <libmain+0x119>
	{
		sys_lock_cons();
  8006eb:	e8 5d 1a 00 00       	call   80214d <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8006f0:	83 ec 0c             	sub    $0xc,%esp
  8006f3:	68 d8 3f 80 00       	push   $0x803fd8
  8006f8:	e8 76 03 00 00       	call   800a73 <cprintf>
  8006fd:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800700:	a1 24 50 80 00       	mov    0x805024,%eax
  800705:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  80070b:	a1 24 50 80 00       	mov    0x805024,%eax
  800710:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800716:	83 ec 04             	sub    $0x4,%esp
  800719:	52                   	push   %edx
  80071a:	50                   	push   %eax
  80071b:	68 00 40 80 00       	push   $0x804000
  800720:	e8 4e 03 00 00       	call   800a73 <cprintf>
  800725:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800728:	a1 24 50 80 00       	mov    0x805024,%eax
  80072d:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800733:	a1 24 50 80 00       	mov    0x805024,%eax
  800738:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  80073e:	a1 24 50 80 00       	mov    0x805024,%eax
  800743:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800749:	51                   	push   %ecx
  80074a:	52                   	push   %edx
  80074b:	50                   	push   %eax
  80074c:	68 28 40 80 00       	push   $0x804028
  800751:	e8 1d 03 00 00       	call   800a73 <cprintf>
  800756:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800759:	a1 24 50 80 00       	mov    0x805024,%eax
  80075e:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800764:	83 ec 08             	sub    $0x8,%esp
  800767:	50                   	push   %eax
  800768:	68 80 40 80 00       	push   $0x804080
  80076d:	e8 01 03 00 00       	call   800a73 <cprintf>
  800772:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800775:	83 ec 0c             	sub    $0xc,%esp
  800778:	68 d8 3f 80 00       	push   $0x803fd8
  80077d:	e8 f1 02 00 00       	call   800a73 <cprintf>
  800782:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800785:	e8 dd 19 00 00       	call   802167 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80078a:	e8 19 00 00 00       	call   8007a8 <exit>
}
  80078f:	90                   	nop
  800790:	c9                   	leave  
  800791:	c3                   	ret    

00800792 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800792:	55                   	push   %ebp
  800793:	89 e5                	mov    %esp,%ebp
  800795:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800798:	83 ec 0c             	sub    $0xc,%esp
  80079b:	6a 00                	push   $0x0
  80079d:	e8 f3 1b 00 00       	call   802395 <sys_destroy_env>
  8007a2:	83 c4 10             	add    $0x10,%esp
}
  8007a5:	90                   	nop
  8007a6:	c9                   	leave  
  8007a7:	c3                   	ret    

008007a8 <exit>:

void
exit(void)
{
  8007a8:	55                   	push   %ebp
  8007a9:	89 e5                	mov    %esp,%ebp
  8007ab:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8007ae:	e8 48 1c 00 00       	call   8023fb <sys_exit_env>
}
  8007b3:	90                   	nop
  8007b4:	c9                   	leave  
  8007b5:	c3                   	ret    

008007b6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8007b6:	55                   	push   %ebp
  8007b7:	89 e5                	mov    %esp,%ebp
  8007b9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8007bc:	8d 45 10             	lea    0x10(%ebp),%eax
  8007bf:	83 c0 04             	add    $0x4,%eax
  8007c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8007c5:	a1 64 50 98 00       	mov    0x985064,%eax
  8007ca:	85 c0                	test   %eax,%eax
  8007cc:	74 16                	je     8007e4 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8007ce:	a1 64 50 98 00       	mov    0x985064,%eax
  8007d3:	83 ec 08             	sub    $0x8,%esp
  8007d6:	50                   	push   %eax
  8007d7:	68 94 40 80 00       	push   $0x804094
  8007dc:	e8 92 02 00 00       	call   800a73 <cprintf>
  8007e1:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007e4:	a1 04 50 80 00       	mov    0x805004,%eax
  8007e9:	ff 75 0c             	pushl  0xc(%ebp)
  8007ec:	ff 75 08             	pushl  0x8(%ebp)
  8007ef:	50                   	push   %eax
  8007f0:	68 99 40 80 00       	push   $0x804099
  8007f5:	e8 79 02 00 00       	call   800a73 <cprintf>
  8007fa:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8007fd:	8b 45 10             	mov    0x10(%ebp),%eax
  800800:	83 ec 08             	sub    $0x8,%esp
  800803:	ff 75 f4             	pushl  -0xc(%ebp)
  800806:	50                   	push   %eax
  800807:	e8 fc 01 00 00       	call   800a08 <vcprintf>
  80080c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80080f:	83 ec 08             	sub    $0x8,%esp
  800812:	6a 00                	push   $0x0
  800814:	68 b5 40 80 00       	push   $0x8040b5
  800819:	e8 ea 01 00 00       	call   800a08 <vcprintf>
  80081e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800821:	e8 82 ff ff ff       	call   8007a8 <exit>

	// should not return here
	while (1) ;
  800826:	eb fe                	jmp    800826 <_panic+0x70>

00800828 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800828:	55                   	push   %ebp
  800829:	89 e5                	mov    %esp,%ebp
  80082b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80082e:	a1 24 50 80 00       	mov    0x805024,%eax
  800833:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800839:	8b 45 0c             	mov    0xc(%ebp),%eax
  80083c:	39 c2                	cmp    %eax,%edx
  80083e:	74 14                	je     800854 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800840:	83 ec 04             	sub    $0x4,%esp
  800843:	68 b8 40 80 00       	push   $0x8040b8
  800848:	6a 26                	push   $0x26
  80084a:	68 04 41 80 00       	push   $0x804104
  80084f:	e8 62 ff ff ff       	call   8007b6 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800854:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80085b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800862:	e9 c5 00 00 00       	jmp    80092c <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800867:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80086a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800871:	8b 45 08             	mov    0x8(%ebp),%eax
  800874:	01 d0                	add    %edx,%eax
  800876:	8b 00                	mov    (%eax),%eax
  800878:	85 c0                	test   %eax,%eax
  80087a:	75 08                	jne    800884 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80087c:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80087f:	e9 a5 00 00 00       	jmp    800929 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800884:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80088b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800892:	eb 69                	jmp    8008fd <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800894:	a1 24 50 80 00       	mov    0x805024,%eax
  800899:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  80089f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008a2:	89 d0                	mov    %edx,%eax
  8008a4:	01 c0                	add    %eax,%eax
  8008a6:	01 d0                	add    %edx,%eax
  8008a8:	c1 e0 03             	shl    $0x3,%eax
  8008ab:	01 c8                	add    %ecx,%eax
  8008ad:	8a 40 04             	mov    0x4(%eax),%al
  8008b0:	84 c0                	test   %al,%al
  8008b2:	75 46                	jne    8008fa <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008b4:	a1 24 50 80 00       	mov    0x805024,%eax
  8008b9:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8008bf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008c2:	89 d0                	mov    %edx,%eax
  8008c4:	01 c0                	add    %eax,%eax
  8008c6:	01 d0                	add    %edx,%eax
  8008c8:	c1 e0 03             	shl    $0x3,%eax
  8008cb:	01 c8                	add    %ecx,%eax
  8008cd:	8b 00                	mov    (%eax),%eax
  8008cf:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008d2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008d5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008da:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008df:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8008e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e9:	01 c8                	add    %ecx,%eax
  8008eb:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008ed:	39 c2                	cmp    %eax,%edx
  8008ef:	75 09                	jne    8008fa <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8008f1:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8008f8:	eb 15                	jmp    80090f <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008fa:	ff 45 e8             	incl   -0x18(%ebp)
  8008fd:	a1 24 50 80 00       	mov    0x805024,%eax
  800902:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800908:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80090b:	39 c2                	cmp    %eax,%edx
  80090d:	77 85                	ja     800894 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80090f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800913:	75 14                	jne    800929 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800915:	83 ec 04             	sub    $0x4,%esp
  800918:	68 10 41 80 00       	push   $0x804110
  80091d:	6a 3a                	push   $0x3a
  80091f:	68 04 41 80 00       	push   $0x804104
  800924:	e8 8d fe ff ff       	call   8007b6 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800929:	ff 45 f0             	incl   -0x10(%ebp)
  80092c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80092f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800932:	0f 8c 2f ff ff ff    	jl     800867 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800938:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80093f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800946:	eb 26                	jmp    80096e <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800948:	a1 24 50 80 00       	mov    0x805024,%eax
  80094d:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800953:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800956:	89 d0                	mov    %edx,%eax
  800958:	01 c0                	add    %eax,%eax
  80095a:	01 d0                	add    %edx,%eax
  80095c:	c1 e0 03             	shl    $0x3,%eax
  80095f:	01 c8                	add    %ecx,%eax
  800961:	8a 40 04             	mov    0x4(%eax),%al
  800964:	3c 01                	cmp    $0x1,%al
  800966:	75 03                	jne    80096b <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800968:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80096b:	ff 45 e0             	incl   -0x20(%ebp)
  80096e:	a1 24 50 80 00       	mov    0x805024,%eax
  800973:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800979:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80097c:	39 c2                	cmp    %eax,%edx
  80097e:	77 c8                	ja     800948 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800980:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800983:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800986:	74 14                	je     80099c <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800988:	83 ec 04             	sub    $0x4,%esp
  80098b:	68 64 41 80 00       	push   $0x804164
  800990:	6a 44                	push   $0x44
  800992:	68 04 41 80 00       	push   $0x804104
  800997:	e8 1a fe ff ff       	call   8007b6 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80099c:	90                   	nop
  80099d:	c9                   	leave  
  80099e:	c3                   	ret    

0080099f <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80099f:	55                   	push   %ebp
  8009a0:	89 e5                	mov    %esp,%ebp
  8009a2:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8009a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a8:	8b 00                	mov    (%eax),%eax
  8009aa:	8d 48 01             	lea    0x1(%eax),%ecx
  8009ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b0:	89 0a                	mov    %ecx,(%edx)
  8009b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8009b5:	88 d1                	mov    %dl,%cl
  8009b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ba:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8009be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c1:	8b 00                	mov    (%eax),%eax
  8009c3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8009c8:	75 2c                	jne    8009f6 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8009ca:	a0 44 50 98 00       	mov    0x985044,%al
  8009cf:	0f b6 c0             	movzbl %al,%eax
  8009d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d5:	8b 12                	mov    (%edx),%edx
  8009d7:	89 d1                	mov    %edx,%ecx
  8009d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009dc:	83 c2 08             	add    $0x8,%edx
  8009df:	83 ec 04             	sub    $0x4,%esp
  8009e2:	50                   	push   %eax
  8009e3:	51                   	push   %ecx
  8009e4:	52                   	push   %edx
  8009e5:	e8 21 17 00 00       	call   80210b <sys_cputs>
  8009ea:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8009ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8009f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f9:	8b 40 04             	mov    0x4(%eax),%eax
  8009fc:	8d 50 01             	lea    0x1(%eax),%edx
  8009ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a02:	89 50 04             	mov    %edx,0x4(%eax)
}
  800a05:	90                   	nop
  800a06:	c9                   	leave  
  800a07:	c3                   	ret    

00800a08 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800a08:	55                   	push   %ebp
  800a09:	89 e5                	mov    %esp,%ebp
  800a0b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800a11:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800a18:	00 00 00 
	b.cnt = 0;
  800a1b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800a22:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800a25:	ff 75 0c             	pushl  0xc(%ebp)
  800a28:	ff 75 08             	pushl  0x8(%ebp)
  800a2b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a31:	50                   	push   %eax
  800a32:	68 9f 09 80 00       	push   $0x80099f
  800a37:	e8 11 02 00 00       	call   800c4d <vprintfmt>
  800a3c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800a3f:	a0 44 50 98 00       	mov    0x985044,%al
  800a44:	0f b6 c0             	movzbl %al,%eax
  800a47:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800a4d:	83 ec 04             	sub    $0x4,%esp
  800a50:	50                   	push   %eax
  800a51:	52                   	push   %edx
  800a52:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a58:	83 c0 08             	add    $0x8,%eax
  800a5b:	50                   	push   %eax
  800a5c:	e8 aa 16 00 00       	call   80210b <sys_cputs>
  800a61:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a64:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
	return b.cnt;
  800a6b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a71:	c9                   	leave  
  800a72:	c3                   	ret    

00800a73 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800a73:	55                   	push   %ebp
  800a74:	89 e5                	mov    %esp,%ebp
  800a76:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a79:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
	va_start(ap, fmt);
  800a80:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a83:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a86:	8b 45 08             	mov    0x8(%ebp),%eax
  800a89:	83 ec 08             	sub    $0x8,%esp
  800a8c:	ff 75 f4             	pushl  -0xc(%ebp)
  800a8f:	50                   	push   %eax
  800a90:	e8 73 ff ff ff       	call   800a08 <vcprintf>
  800a95:	83 c4 10             	add    $0x10,%esp
  800a98:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a9e:	c9                   	leave  
  800a9f:	c3                   	ret    

00800aa0 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800aa0:	55                   	push   %ebp
  800aa1:	89 e5                	mov    %esp,%ebp
  800aa3:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800aa6:	e8 a2 16 00 00       	call   80214d <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800aab:	8d 45 0c             	lea    0xc(%ebp),%eax
  800aae:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab4:	83 ec 08             	sub    $0x8,%esp
  800ab7:	ff 75 f4             	pushl  -0xc(%ebp)
  800aba:	50                   	push   %eax
  800abb:	e8 48 ff ff ff       	call   800a08 <vcprintf>
  800ac0:	83 c4 10             	add    $0x10,%esp
  800ac3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800ac6:	e8 9c 16 00 00       	call   802167 <sys_unlock_cons>
	return cnt;
  800acb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ace:	c9                   	leave  
  800acf:	c3                   	ret    

00800ad0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800ad0:	55                   	push   %ebp
  800ad1:	89 e5                	mov    %esp,%ebp
  800ad3:	53                   	push   %ebx
  800ad4:	83 ec 14             	sub    $0x14,%esp
  800ad7:	8b 45 10             	mov    0x10(%ebp),%eax
  800ada:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800add:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800ae3:	8b 45 18             	mov    0x18(%ebp),%eax
  800ae6:	ba 00 00 00 00       	mov    $0x0,%edx
  800aeb:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800aee:	77 55                	ja     800b45 <printnum+0x75>
  800af0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800af3:	72 05                	jb     800afa <printnum+0x2a>
  800af5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800af8:	77 4b                	ja     800b45 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800afa:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800afd:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800b00:	8b 45 18             	mov    0x18(%ebp),%eax
  800b03:	ba 00 00 00 00       	mov    $0x0,%edx
  800b08:	52                   	push   %edx
  800b09:	50                   	push   %eax
  800b0a:	ff 75 f4             	pushl  -0xc(%ebp)
  800b0d:	ff 75 f0             	pushl  -0x10(%ebp)
  800b10:	e8 9b 30 00 00       	call   803bb0 <__udivdi3>
  800b15:	83 c4 10             	add    $0x10,%esp
  800b18:	83 ec 04             	sub    $0x4,%esp
  800b1b:	ff 75 20             	pushl  0x20(%ebp)
  800b1e:	53                   	push   %ebx
  800b1f:	ff 75 18             	pushl  0x18(%ebp)
  800b22:	52                   	push   %edx
  800b23:	50                   	push   %eax
  800b24:	ff 75 0c             	pushl  0xc(%ebp)
  800b27:	ff 75 08             	pushl  0x8(%ebp)
  800b2a:	e8 a1 ff ff ff       	call   800ad0 <printnum>
  800b2f:	83 c4 20             	add    $0x20,%esp
  800b32:	eb 1a                	jmp    800b4e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b34:	83 ec 08             	sub    $0x8,%esp
  800b37:	ff 75 0c             	pushl  0xc(%ebp)
  800b3a:	ff 75 20             	pushl  0x20(%ebp)
  800b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b40:	ff d0                	call   *%eax
  800b42:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b45:	ff 4d 1c             	decl   0x1c(%ebp)
  800b48:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b4c:	7f e6                	jg     800b34 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b4e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b51:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b59:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b5c:	53                   	push   %ebx
  800b5d:	51                   	push   %ecx
  800b5e:	52                   	push   %edx
  800b5f:	50                   	push   %eax
  800b60:	e8 5b 31 00 00       	call   803cc0 <__umoddi3>
  800b65:	83 c4 10             	add    $0x10,%esp
  800b68:	05 d4 43 80 00       	add    $0x8043d4,%eax
  800b6d:	8a 00                	mov    (%eax),%al
  800b6f:	0f be c0             	movsbl %al,%eax
  800b72:	83 ec 08             	sub    $0x8,%esp
  800b75:	ff 75 0c             	pushl  0xc(%ebp)
  800b78:	50                   	push   %eax
  800b79:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7c:	ff d0                	call   *%eax
  800b7e:	83 c4 10             	add    $0x10,%esp
}
  800b81:	90                   	nop
  800b82:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b85:	c9                   	leave  
  800b86:	c3                   	ret    

00800b87 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b87:	55                   	push   %ebp
  800b88:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b8a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b8e:	7e 1c                	jle    800bac <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b90:	8b 45 08             	mov    0x8(%ebp),%eax
  800b93:	8b 00                	mov    (%eax),%eax
  800b95:	8d 50 08             	lea    0x8(%eax),%edx
  800b98:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9b:	89 10                	mov    %edx,(%eax)
  800b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba0:	8b 00                	mov    (%eax),%eax
  800ba2:	83 e8 08             	sub    $0x8,%eax
  800ba5:	8b 50 04             	mov    0x4(%eax),%edx
  800ba8:	8b 00                	mov    (%eax),%eax
  800baa:	eb 40                	jmp    800bec <getuint+0x65>
	else if (lflag)
  800bac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bb0:	74 1e                	je     800bd0 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb5:	8b 00                	mov    (%eax),%eax
  800bb7:	8d 50 04             	lea    0x4(%eax),%edx
  800bba:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbd:	89 10                	mov    %edx,(%eax)
  800bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc2:	8b 00                	mov    (%eax),%eax
  800bc4:	83 e8 04             	sub    $0x4,%eax
  800bc7:	8b 00                	mov    (%eax),%eax
  800bc9:	ba 00 00 00 00       	mov    $0x0,%edx
  800bce:	eb 1c                	jmp    800bec <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd3:	8b 00                	mov    (%eax),%eax
  800bd5:	8d 50 04             	lea    0x4(%eax),%edx
  800bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdb:	89 10                	mov    %edx,(%eax)
  800bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800be0:	8b 00                	mov    (%eax),%eax
  800be2:	83 e8 04             	sub    $0x4,%eax
  800be5:	8b 00                	mov    (%eax),%eax
  800be7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800bec:	5d                   	pop    %ebp
  800bed:	c3                   	ret    

00800bee <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800bee:	55                   	push   %ebp
  800bef:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bf1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bf5:	7e 1c                	jle    800c13 <getint+0x25>
		return va_arg(*ap, long long);
  800bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfa:	8b 00                	mov    (%eax),%eax
  800bfc:	8d 50 08             	lea    0x8(%eax),%edx
  800bff:	8b 45 08             	mov    0x8(%ebp),%eax
  800c02:	89 10                	mov    %edx,(%eax)
  800c04:	8b 45 08             	mov    0x8(%ebp),%eax
  800c07:	8b 00                	mov    (%eax),%eax
  800c09:	83 e8 08             	sub    $0x8,%eax
  800c0c:	8b 50 04             	mov    0x4(%eax),%edx
  800c0f:	8b 00                	mov    (%eax),%eax
  800c11:	eb 38                	jmp    800c4b <getint+0x5d>
	else if (lflag)
  800c13:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c17:	74 1a                	je     800c33 <getint+0x45>
		return va_arg(*ap, long);
  800c19:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1c:	8b 00                	mov    (%eax),%eax
  800c1e:	8d 50 04             	lea    0x4(%eax),%edx
  800c21:	8b 45 08             	mov    0x8(%ebp),%eax
  800c24:	89 10                	mov    %edx,(%eax)
  800c26:	8b 45 08             	mov    0x8(%ebp),%eax
  800c29:	8b 00                	mov    (%eax),%eax
  800c2b:	83 e8 04             	sub    $0x4,%eax
  800c2e:	8b 00                	mov    (%eax),%eax
  800c30:	99                   	cltd   
  800c31:	eb 18                	jmp    800c4b <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c33:	8b 45 08             	mov    0x8(%ebp),%eax
  800c36:	8b 00                	mov    (%eax),%eax
  800c38:	8d 50 04             	lea    0x4(%eax),%edx
  800c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3e:	89 10                	mov    %edx,(%eax)
  800c40:	8b 45 08             	mov    0x8(%ebp),%eax
  800c43:	8b 00                	mov    (%eax),%eax
  800c45:	83 e8 04             	sub    $0x4,%eax
  800c48:	8b 00                	mov    (%eax),%eax
  800c4a:	99                   	cltd   
}
  800c4b:	5d                   	pop    %ebp
  800c4c:	c3                   	ret    

00800c4d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c4d:	55                   	push   %ebp
  800c4e:	89 e5                	mov    %esp,%ebp
  800c50:	56                   	push   %esi
  800c51:	53                   	push   %ebx
  800c52:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c55:	eb 17                	jmp    800c6e <vprintfmt+0x21>
			if (ch == '\0')
  800c57:	85 db                	test   %ebx,%ebx
  800c59:	0f 84 c1 03 00 00    	je     801020 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800c5f:	83 ec 08             	sub    $0x8,%esp
  800c62:	ff 75 0c             	pushl  0xc(%ebp)
  800c65:	53                   	push   %ebx
  800c66:	8b 45 08             	mov    0x8(%ebp),%eax
  800c69:	ff d0                	call   *%eax
  800c6b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c6e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c71:	8d 50 01             	lea    0x1(%eax),%edx
  800c74:	89 55 10             	mov    %edx,0x10(%ebp)
  800c77:	8a 00                	mov    (%eax),%al
  800c79:	0f b6 d8             	movzbl %al,%ebx
  800c7c:	83 fb 25             	cmp    $0x25,%ebx
  800c7f:	75 d6                	jne    800c57 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c81:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c85:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c8c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c93:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c9a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800ca1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ca4:	8d 50 01             	lea    0x1(%eax),%edx
  800ca7:	89 55 10             	mov    %edx,0x10(%ebp)
  800caa:	8a 00                	mov    (%eax),%al
  800cac:	0f b6 d8             	movzbl %al,%ebx
  800caf:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800cb2:	83 f8 5b             	cmp    $0x5b,%eax
  800cb5:	0f 87 3d 03 00 00    	ja     800ff8 <vprintfmt+0x3ab>
  800cbb:	8b 04 85 f8 43 80 00 	mov    0x8043f8(,%eax,4),%eax
  800cc2:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800cc4:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800cc8:	eb d7                	jmp    800ca1 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800cca:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800cce:	eb d1                	jmp    800ca1 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cd0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800cd7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800cda:	89 d0                	mov    %edx,%eax
  800cdc:	c1 e0 02             	shl    $0x2,%eax
  800cdf:	01 d0                	add    %edx,%eax
  800ce1:	01 c0                	add    %eax,%eax
  800ce3:	01 d8                	add    %ebx,%eax
  800ce5:	83 e8 30             	sub    $0x30,%eax
  800ce8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800ceb:	8b 45 10             	mov    0x10(%ebp),%eax
  800cee:	8a 00                	mov    (%eax),%al
  800cf0:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800cf3:	83 fb 2f             	cmp    $0x2f,%ebx
  800cf6:	7e 3e                	jle    800d36 <vprintfmt+0xe9>
  800cf8:	83 fb 39             	cmp    $0x39,%ebx
  800cfb:	7f 39                	jg     800d36 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cfd:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d00:	eb d5                	jmp    800cd7 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800d02:	8b 45 14             	mov    0x14(%ebp),%eax
  800d05:	83 c0 04             	add    $0x4,%eax
  800d08:	89 45 14             	mov    %eax,0x14(%ebp)
  800d0b:	8b 45 14             	mov    0x14(%ebp),%eax
  800d0e:	83 e8 04             	sub    $0x4,%eax
  800d11:	8b 00                	mov    (%eax),%eax
  800d13:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800d16:	eb 1f                	jmp    800d37 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800d18:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d1c:	79 83                	jns    800ca1 <vprintfmt+0x54>
				width = 0;
  800d1e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800d25:	e9 77 ff ff ff       	jmp    800ca1 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800d2a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d31:	e9 6b ff ff ff       	jmp    800ca1 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d36:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d37:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d3b:	0f 89 60 ff ff ff    	jns    800ca1 <vprintfmt+0x54>
				width = precision, precision = -1;
  800d41:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d44:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d47:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d4e:	e9 4e ff ff ff       	jmp    800ca1 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d53:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d56:	e9 46 ff ff ff       	jmp    800ca1 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d5b:	8b 45 14             	mov    0x14(%ebp),%eax
  800d5e:	83 c0 04             	add    $0x4,%eax
  800d61:	89 45 14             	mov    %eax,0x14(%ebp)
  800d64:	8b 45 14             	mov    0x14(%ebp),%eax
  800d67:	83 e8 04             	sub    $0x4,%eax
  800d6a:	8b 00                	mov    (%eax),%eax
  800d6c:	83 ec 08             	sub    $0x8,%esp
  800d6f:	ff 75 0c             	pushl  0xc(%ebp)
  800d72:	50                   	push   %eax
  800d73:	8b 45 08             	mov    0x8(%ebp),%eax
  800d76:	ff d0                	call   *%eax
  800d78:	83 c4 10             	add    $0x10,%esp
			break;
  800d7b:	e9 9b 02 00 00       	jmp    80101b <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d80:	8b 45 14             	mov    0x14(%ebp),%eax
  800d83:	83 c0 04             	add    $0x4,%eax
  800d86:	89 45 14             	mov    %eax,0x14(%ebp)
  800d89:	8b 45 14             	mov    0x14(%ebp),%eax
  800d8c:	83 e8 04             	sub    $0x4,%eax
  800d8f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d91:	85 db                	test   %ebx,%ebx
  800d93:	79 02                	jns    800d97 <vprintfmt+0x14a>
				err = -err;
  800d95:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d97:	83 fb 64             	cmp    $0x64,%ebx
  800d9a:	7f 0b                	jg     800da7 <vprintfmt+0x15a>
  800d9c:	8b 34 9d 40 42 80 00 	mov    0x804240(,%ebx,4),%esi
  800da3:	85 f6                	test   %esi,%esi
  800da5:	75 19                	jne    800dc0 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800da7:	53                   	push   %ebx
  800da8:	68 e5 43 80 00       	push   $0x8043e5
  800dad:	ff 75 0c             	pushl  0xc(%ebp)
  800db0:	ff 75 08             	pushl  0x8(%ebp)
  800db3:	e8 70 02 00 00       	call   801028 <printfmt>
  800db8:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800dbb:	e9 5b 02 00 00       	jmp    80101b <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800dc0:	56                   	push   %esi
  800dc1:	68 ee 43 80 00       	push   $0x8043ee
  800dc6:	ff 75 0c             	pushl  0xc(%ebp)
  800dc9:	ff 75 08             	pushl  0x8(%ebp)
  800dcc:	e8 57 02 00 00       	call   801028 <printfmt>
  800dd1:	83 c4 10             	add    $0x10,%esp
			break;
  800dd4:	e9 42 02 00 00       	jmp    80101b <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800dd9:	8b 45 14             	mov    0x14(%ebp),%eax
  800ddc:	83 c0 04             	add    $0x4,%eax
  800ddf:	89 45 14             	mov    %eax,0x14(%ebp)
  800de2:	8b 45 14             	mov    0x14(%ebp),%eax
  800de5:	83 e8 04             	sub    $0x4,%eax
  800de8:	8b 30                	mov    (%eax),%esi
  800dea:	85 f6                	test   %esi,%esi
  800dec:	75 05                	jne    800df3 <vprintfmt+0x1a6>
				p = "(null)";
  800dee:	be f1 43 80 00       	mov    $0x8043f1,%esi
			if (width > 0 && padc != '-')
  800df3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800df7:	7e 6d                	jle    800e66 <vprintfmt+0x219>
  800df9:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800dfd:	74 67                	je     800e66 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800dff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e02:	83 ec 08             	sub    $0x8,%esp
  800e05:	50                   	push   %eax
  800e06:	56                   	push   %esi
  800e07:	e8 26 05 00 00       	call   801332 <strnlen>
  800e0c:	83 c4 10             	add    $0x10,%esp
  800e0f:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800e12:	eb 16                	jmp    800e2a <vprintfmt+0x1dd>
					putch(padc, putdat);
  800e14:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800e18:	83 ec 08             	sub    $0x8,%esp
  800e1b:	ff 75 0c             	pushl  0xc(%ebp)
  800e1e:	50                   	push   %eax
  800e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e22:	ff d0                	call   *%eax
  800e24:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e27:	ff 4d e4             	decl   -0x1c(%ebp)
  800e2a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e2e:	7f e4                	jg     800e14 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e30:	eb 34                	jmp    800e66 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e32:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e36:	74 1c                	je     800e54 <vprintfmt+0x207>
  800e38:	83 fb 1f             	cmp    $0x1f,%ebx
  800e3b:	7e 05                	jle    800e42 <vprintfmt+0x1f5>
  800e3d:	83 fb 7e             	cmp    $0x7e,%ebx
  800e40:	7e 12                	jle    800e54 <vprintfmt+0x207>
					putch('?', putdat);
  800e42:	83 ec 08             	sub    $0x8,%esp
  800e45:	ff 75 0c             	pushl  0xc(%ebp)
  800e48:	6a 3f                	push   $0x3f
  800e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4d:	ff d0                	call   *%eax
  800e4f:	83 c4 10             	add    $0x10,%esp
  800e52:	eb 0f                	jmp    800e63 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e54:	83 ec 08             	sub    $0x8,%esp
  800e57:	ff 75 0c             	pushl  0xc(%ebp)
  800e5a:	53                   	push   %ebx
  800e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5e:	ff d0                	call   *%eax
  800e60:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e63:	ff 4d e4             	decl   -0x1c(%ebp)
  800e66:	89 f0                	mov    %esi,%eax
  800e68:	8d 70 01             	lea    0x1(%eax),%esi
  800e6b:	8a 00                	mov    (%eax),%al
  800e6d:	0f be d8             	movsbl %al,%ebx
  800e70:	85 db                	test   %ebx,%ebx
  800e72:	74 24                	je     800e98 <vprintfmt+0x24b>
  800e74:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e78:	78 b8                	js     800e32 <vprintfmt+0x1e5>
  800e7a:	ff 4d e0             	decl   -0x20(%ebp)
  800e7d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e81:	79 af                	jns    800e32 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e83:	eb 13                	jmp    800e98 <vprintfmt+0x24b>
				putch(' ', putdat);
  800e85:	83 ec 08             	sub    $0x8,%esp
  800e88:	ff 75 0c             	pushl  0xc(%ebp)
  800e8b:	6a 20                	push   $0x20
  800e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e90:	ff d0                	call   *%eax
  800e92:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e95:	ff 4d e4             	decl   -0x1c(%ebp)
  800e98:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e9c:	7f e7                	jg     800e85 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e9e:	e9 78 01 00 00       	jmp    80101b <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ea3:	83 ec 08             	sub    $0x8,%esp
  800ea6:	ff 75 e8             	pushl  -0x18(%ebp)
  800ea9:	8d 45 14             	lea    0x14(%ebp),%eax
  800eac:	50                   	push   %eax
  800ead:	e8 3c fd ff ff       	call   800bee <getint>
  800eb2:	83 c4 10             	add    $0x10,%esp
  800eb5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eb8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ebb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ebe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ec1:	85 d2                	test   %edx,%edx
  800ec3:	79 23                	jns    800ee8 <vprintfmt+0x29b>
				putch('-', putdat);
  800ec5:	83 ec 08             	sub    $0x8,%esp
  800ec8:	ff 75 0c             	pushl  0xc(%ebp)
  800ecb:	6a 2d                	push   $0x2d
  800ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed0:	ff d0                	call   *%eax
  800ed2:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ed5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ed8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800edb:	f7 d8                	neg    %eax
  800edd:	83 d2 00             	adc    $0x0,%edx
  800ee0:	f7 da                	neg    %edx
  800ee2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ee5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ee8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800eef:	e9 bc 00 00 00       	jmp    800fb0 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ef4:	83 ec 08             	sub    $0x8,%esp
  800ef7:	ff 75 e8             	pushl  -0x18(%ebp)
  800efa:	8d 45 14             	lea    0x14(%ebp),%eax
  800efd:	50                   	push   %eax
  800efe:	e8 84 fc ff ff       	call   800b87 <getuint>
  800f03:	83 c4 10             	add    $0x10,%esp
  800f06:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f09:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800f0c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f13:	e9 98 00 00 00       	jmp    800fb0 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800f18:	83 ec 08             	sub    $0x8,%esp
  800f1b:	ff 75 0c             	pushl  0xc(%ebp)
  800f1e:	6a 58                	push   $0x58
  800f20:	8b 45 08             	mov    0x8(%ebp),%eax
  800f23:	ff d0                	call   *%eax
  800f25:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f28:	83 ec 08             	sub    $0x8,%esp
  800f2b:	ff 75 0c             	pushl  0xc(%ebp)
  800f2e:	6a 58                	push   $0x58
  800f30:	8b 45 08             	mov    0x8(%ebp),%eax
  800f33:	ff d0                	call   *%eax
  800f35:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f38:	83 ec 08             	sub    $0x8,%esp
  800f3b:	ff 75 0c             	pushl  0xc(%ebp)
  800f3e:	6a 58                	push   $0x58
  800f40:	8b 45 08             	mov    0x8(%ebp),%eax
  800f43:	ff d0                	call   *%eax
  800f45:	83 c4 10             	add    $0x10,%esp
			break;
  800f48:	e9 ce 00 00 00       	jmp    80101b <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800f4d:	83 ec 08             	sub    $0x8,%esp
  800f50:	ff 75 0c             	pushl  0xc(%ebp)
  800f53:	6a 30                	push   $0x30
  800f55:	8b 45 08             	mov    0x8(%ebp),%eax
  800f58:	ff d0                	call   *%eax
  800f5a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f5d:	83 ec 08             	sub    $0x8,%esp
  800f60:	ff 75 0c             	pushl  0xc(%ebp)
  800f63:	6a 78                	push   $0x78
  800f65:	8b 45 08             	mov    0x8(%ebp),%eax
  800f68:	ff d0                	call   *%eax
  800f6a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f6d:	8b 45 14             	mov    0x14(%ebp),%eax
  800f70:	83 c0 04             	add    $0x4,%eax
  800f73:	89 45 14             	mov    %eax,0x14(%ebp)
  800f76:	8b 45 14             	mov    0x14(%ebp),%eax
  800f79:	83 e8 04             	sub    $0x4,%eax
  800f7c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f81:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f88:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f8f:	eb 1f                	jmp    800fb0 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f91:	83 ec 08             	sub    $0x8,%esp
  800f94:	ff 75 e8             	pushl  -0x18(%ebp)
  800f97:	8d 45 14             	lea    0x14(%ebp),%eax
  800f9a:	50                   	push   %eax
  800f9b:	e8 e7 fb ff ff       	call   800b87 <getuint>
  800fa0:	83 c4 10             	add    $0x10,%esp
  800fa3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fa6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800fa9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800fb0:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800fb4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fb7:	83 ec 04             	sub    $0x4,%esp
  800fba:	52                   	push   %edx
  800fbb:	ff 75 e4             	pushl  -0x1c(%ebp)
  800fbe:	50                   	push   %eax
  800fbf:	ff 75 f4             	pushl  -0xc(%ebp)
  800fc2:	ff 75 f0             	pushl  -0x10(%ebp)
  800fc5:	ff 75 0c             	pushl  0xc(%ebp)
  800fc8:	ff 75 08             	pushl  0x8(%ebp)
  800fcb:	e8 00 fb ff ff       	call   800ad0 <printnum>
  800fd0:	83 c4 20             	add    $0x20,%esp
			break;
  800fd3:	eb 46                	jmp    80101b <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fd5:	83 ec 08             	sub    $0x8,%esp
  800fd8:	ff 75 0c             	pushl  0xc(%ebp)
  800fdb:	53                   	push   %ebx
  800fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdf:	ff d0                	call   *%eax
  800fe1:	83 c4 10             	add    $0x10,%esp
			break;
  800fe4:	eb 35                	jmp    80101b <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800fe6:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
			break;
  800fed:	eb 2c                	jmp    80101b <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800fef:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
			break;
  800ff6:	eb 23                	jmp    80101b <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ff8:	83 ec 08             	sub    $0x8,%esp
  800ffb:	ff 75 0c             	pushl  0xc(%ebp)
  800ffe:	6a 25                	push   $0x25
  801000:	8b 45 08             	mov    0x8(%ebp),%eax
  801003:	ff d0                	call   *%eax
  801005:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801008:	ff 4d 10             	decl   0x10(%ebp)
  80100b:	eb 03                	jmp    801010 <vprintfmt+0x3c3>
  80100d:	ff 4d 10             	decl   0x10(%ebp)
  801010:	8b 45 10             	mov    0x10(%ebp),%eax
  801013:	48                   	dec    %eax
  801014:	8a 00                	mov    (%eax),%al
  801016:	3c 25                	cmp    $0x25,%al
  801018:	75 f3                	jne    80100d <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  80101a:	90                   	nop
		}
	}
  80101b:	e9 35 fc ff ff       	jmp    800c55 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801020:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801021:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801024:	5b                   	pop    %ebx
  801025:	5e                   	pop    %esi
  801026:	5d                   	pop    %ebp
  801027:	c3                   	ret    

00801028 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801028:	55                   	push   %ebp
  801029:	89 e5                	mov    %esp,%ebp
  80102b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80102e:	8d 45 10             	lea    0x10(%ebp),%eax
  801031:	83 c0 04             	add    $0x4,%eax
  801034:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801037:	8b 45 10             	mov    0x10(%ebp),%eax
  80103a:	ff 75 f4             	pushl  -0xc(%ebp)
  80103d:	50                   	push   %eax
  80103e:	ff 75 0c             	pushl  0xc(%ebp)
  801041:	ff 75 08             	pushl  0x8(%ebp)
  801044:	e8 04 fc ff ff       	call   800c4d <vprintfmt>
  801049:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80104c:	90                   	nop
  80104d:	c9                   	leave  
  80104e:	c3                   	ret    

0080104f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80104f:	55                   	push   %ebp
  801050:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801052:	8b 45 0c             	mov    0xc(%ebp),%eax
  801055:	8b 40 08             	mov    0x8(%eax),%eax
  801058:	8d 50 01             	lea    0x1(%eax),%edx
  80105b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801061:	8b 45 0c             	mov    0xc(%ebp),%eax
  801064:	8b 10                	mov    (%eax),%edx
  801066:	8b 45 0c             	mov    0xc(%ebp),%eax
  801069:	8b 40 04             	mov    0x4(%eax),%eax
  80106c:	39 c2                	cmp    %eax,%edx
  80106e:	73 12                	jae    801082 <sprintputch+0x33>
		*b->buf++ = ch;
  801070:	8b 45 0c             	mov    0xc(%ebp),%eax
  801073:	8b 00                	mov    (%eax),%eax
  801075:	8d 48 01             	lea    0x1(%eax),%ecx
  801078:	8b 55 0c             	mov    0xc(%ebp),%edx
  80107b:	89 0a                	mov    %ecx,(%edx)
  80107d:	8b 55 08             	mov    0x8(%ebp),%edx
  801080:	88 10                	mov    %dl,(%eax)
}
  801082:	90                   	nop
  801083:	5d                   	pop    %ebp
  801084:	c3                   	ret    

00801085 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801085:	55                   	push   %ebp
  801086:	89 e5                	mov    %esp,%ebp
  801088:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80108b:	8b 45 08             	mov    0x8(%ebp),%eax
  80108e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801091:	8b 45 0c             	mov    0xc(%ebp),%eax
  801094:	8d 50 ff             	lea    -0x1(%eax),%edx
  801097:	8b 45 08             	mov    0x8(%ebp),%eax
  80109a:	01 d0                	add    %edx,%eax
  80109c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80109f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8010a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010aa:	74 06                	je     8010b2 <vsnprintf+0x2d>
  8010ac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010b0:	7f 07                	jg     8010b9 <vsnprintf+0x34>
		return -E_INVAL;
  8010b2:	b8 03 00 00 00       	mov    $0x3,%eax
  8010b7:	eb 20                	jmp    8010d9 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8010b9:	ff 75 14             	pushl  0x14(%ebp)
  8010bc:	ff 75 10             	pushl  0x10(%ebp)
  8010bf:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8010c2:	50                   	push   %eax
  8010c3:	68 4f 10 80 00       	push   $0x80104f
  8010c8:	e8 80 fb ff ff       	call   800c4d <vprintfmt>
  8010cd:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8010d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010d3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8010d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8010d9:	c9                   	leave  
  8010da:	c3                   	ret    

008010db <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010db:	55                   	push   %ebp
  8010dc:	89 e5                	mov    %esp,%ebp
  8010de:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8010e1:	8d 45 10             	lea    0x10(%ebp),%eax
  8010e4:	83 c0 04             	add    $0x4,%eax
  8010e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8010ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ed:	ff 75 f4             	pushl  -0xc(%ebp)
  8010f0:	50                   	push   %eax
  8010f1:	ff 75 0c             	pushl  0xc(%ebp)
  8010f4:	ff 75 08             	pushl  0x8(%ebp)
  8010f7:	e8 89 ff ff ff       	call   801085 <vsnprintf>
  8010fc:	83 c4 10             	add    $0x10,%esp
  8010ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801102:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801105:	c9                   	leave  
  801106:	c3                   	ret    

00801107 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  801107:	55                   	push   %ebp
  801108:	89 e5                	mov    %esp,%ebp
  80110a:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  80110d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801111:	74 13                	je     801126 <readline+0x1f>
		cprintf("%s", prompt);
  801113:	83 ec 08             	sub    $0x8,%esp
  801116:	ff 75 08             	pushl  0x8(%ebp)
  801119:	68 68 45 80 00       	push   $0x804568
  80111e:	e8 50 f9 ff ff       	call   800a73 <cprintf>
  801123:	83 c4 10             	add    $0x10,%esp

	i = 0;
  801126:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  80112d:	83 ec 0c             	sub    $0xc,%esp
  801130:	6a 00                	push   $0x0
  801132:	e8 30 f5 ff ff       	call   800667 <iscons>
  801137:	83 c4 10             	add    $0x10,%esp
  80113a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  80113d:	e8 12 f5 ff ff       	call   800654 <getchar>
  801142:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801145:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801149:	79 22                	jns    80116d <readline+0x66>
			if (c != -E_EOF)
  80114b:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80114f:	0f 84 ad 00 00 00    	je     801202 <readline+0xfb>
				cprintf("read error: %e\n", c);
  801155:	83 ec 08             	sub    $0x8,%esp
  801158:	ff 75 ec             	pushl  -0x14(%ebp)
  80115b:	68 6b 45 80 00       	push   $0x80456b
  801160:	e8 0e f9 ff ff       	call   800a73 <cprintf>
  801165:	83 c4 10             	add    $0x10,%esp
			break;
  801168:	e9 95 00 00 00       	jmp    801202 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80116d:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801171:	7e 34                	jle    8011a7 <readline+0xa0>
  801173:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80117a:	7f 2b                	jg     8011a7 <readline+0xa0>
			if (echoing)
  80117c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801180:	74 0e                	je     801190 <readline+0x89>
				cputchar(c);
  801182:	83 ec 0c             	sub    $0xc,%esp
  801185:	ff 75 ec             	pushl  -0x14(%ebp)
  801188:	e8 a8 f4 ff ff       	call   800635 <cputchar>
  80118d:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801190:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801193:	8d 50 01             	lea    0x1(%eax),%edx
  801196:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801199:	89 c2                	mov    %eax,%edx
  80119b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119e:	01 d0                	add    %edx,%eax
  8011a0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011a3:	88 10                	mov    %dl,(%eax)
  8011a5:	eb 56                	jmp    8011fd <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  8011a7:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8011ab:	75 1f                	jne    8011cc <readline+0xc5>
  8011ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8011b1:	7e 19                	jle    8011cc <readline+0xc5>
			if (echoing)
  8011b3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8011b7:	74 0e                	je     8011c7 <readline+0xc0>
				cputchar(c);
  8011b9:	83 ec 0c             	sub    $0xc,%esp
  8011bc:	ff 75 ec             	pushl  -0x14(%ebp)
  8011bf:	e8 71 f4 ff ff       	call   800635 <cputchar>
  8011c4:	83 c4 10             	add    $0x10,%esp

			i--;
  8011c7:	ff 4d f4             	decl   -0xc(%ebp)
  8011ca:	eb 31                	jmp    8011fd <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  8011cc:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8011d0:	74 0a                	je     8011dc <readline+0xd5>
  8011d2:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8011d6:	0f 85 61 ff ff ff    	jne    80113d <readline+0x36>
			if (echoing)
  8011dc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8011e0:	74 0e                	je     8011f0 <readline+0xe9>
				cputchar(c);
  8011e2:	83 ec 0c             	sub    $0xc,%esp
  8011e5:	ff 75 ec             	pushl  -0x14(%ebp)
  8011e8:	e8 48 f4 ff ff       	call   800635 <cputchar>
  8011ed:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8011f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f6:	01 d0                	add    %edx,%eax
  8011f8:	c6 00 00             	movb   $0x0,(%eax)
			break;
  8011fb:	eb 06                	jmp    801203 <readline+0xfc>
		}
	}
  8011fd:	e9 3b ff ff ff       	jmp    80113d <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  801202:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  801203:	90                   	nop
  801204:	c9                   	leave  
  801205:	c3                   	ret    

00801206 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  801206:	55                   	push   %ebp
  801207:	89 e5                	mov    %esp,%ebp
  801209:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  80120c:	e8 3c 0f 00 00       	call   80214d <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  801211:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801215:	74 13                	je     80122a <atomic_readline+0x24>
			cprintf("%s", prompt);
  801217:	83 ec 08             	sub    $0x8,%esp
  80121a:	ff 75 08             	pushl  0x8(%ebp)
  80121d:	68 68 45 80 00       	push   $0x804568
  801222:	e8 4c f8 ff ff       	call   800a73 <cprintf>
  801227:	83 c4 10             	add    $0x10,%esp

		i = 0;
  80122a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  801231:	83 ec 0c             	sub    $0xc,%esp
  801234:	6a 00                	push   $0x0
  801236:	e8 2c f4 ff ff       	call   800667 <iscons>
  80123b:	83 c4 10             	add    $0x10,%esp
  80123e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  801241:	e8 0e f4 ff ff       	call   800654 <getchar>
  801246:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  801249:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80124d:	79 22                	jns    801271 <atomic_readline+0x6b>
				if (c != -E_EOF)
  80124f:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801253:	0f 84 ad 00 00 00    	je     801306 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  801259:	83 ec 08             	sub    $0x8,%esp
  80125c:	ff 75 ec             	pushl  -0x14(%ebp)
  80125f:	68 6b 45 80 00       	push   $0x80456b
  801264:	e8 0a f8 ff ff       	call   800a73 <cprintf>
  801269:	83 c4 10             	add    $0x10,%esp
				break;
  80126c:	e9 95 00 00 00       	jmp    801306 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  801271:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801275:	7e 34                	jle    8012ab <atomic_readline+0xa5>
  801277:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80127e:	7f 2b                	jg     8012ab <atomic_readline+0xa5>
				if (echoing)
  801280:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801284:	74 0e                	je     801294 <atomic_readline+0x8e>
					cputchar(c);
  801286:	83 ec 0c             	sub    $0xc,%esp
  801289:	ff 75 ec             	pushl  -0x14(%ebp)
  80128c:	e8 a4 f3 ff ff       	call   800635 <cputchar>
  801291:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  801294:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801297:	8d 50 01             	lea    0x1(%eax),%edx
  80129a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80129d:	89 c2                	mov    %eax,%edx
  80129f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a2:	01 d0                	add    %edx,%eax
  8012a4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012a7:	88 10                	mov    %dl,(%eax)
  8012a9:	eb 56                	jmp    801301 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  8012ab:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8012af:	75 1f                	jne    8012d0 <atomic_readline+0xca>
  8012b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8012b5:	7e 19                	jle    8012d0 <atomic_readline+0xca>
				if (echoing)
  8012b7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012bb:	74 0e                	je     8012cb <atomic_readline+0xc5>
					cputchar(c);
  8012bd:	83 ec 0c             	sub    $0xc,%esp
  8012c0:	ff 75 ec             	pushl  -0x14(%ebp)
  8012c3:	e8 6d f3 ff ff       	call   800635 <cputchar>
  8012c8:	83 c4 10             	add    $0x10,%esp
				i--;
  8012cb:	ff 4d f4             	decl   -0xc(%ebp)
  8012ce:	eb 31                	jmp    801301 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  8012d0:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8012d4:	74 0a                	je     8012e0 <atomic_readline+0xda>
  8012d6:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8012da:	0f 85 61 ff ff ff    	jne    801241 <atomic_readline+0x3b>
				if (echoing)
  8012e0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012e4:	74 0e                	je     8012f4 <atomic_readline+0xee>
					cputchar(c);
  8012e6:	83 ec 0c             	sub    $0xc,%esp
  8012e9:	ff 75 ec             	pushl  -0x14(%ebp)
  8012ec:	e8 44 f3 ff ff       	call   800635 <cputchar>
  8012f1:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  8012f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fa:	01 d0                	add    %edx,%eax
  8012fc:	c6 00 00             	movb   $0x0,(%eax)
				break;
  8012ff:	eb 06                	jmp    801307 <atomic_readline+0x101>
			}
		}
  801301:	e9 3b ff ff ff       	jmp    801241 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  801306:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  801307:	e8 5b 0e 00 00       	call   802167 <sys_unlock_cons>
}
  80130c:	90                   	nop
  80130d:	c9                   	leave  
  80130e:	c3                   	ret    

0080130f <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  80130f:	55                   	push   %ebp
  801310:	89 e5                	mov    %esp,%ebp
  801312:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801315:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80131c:	eb 06                	jmp    801324 <strlen+0x15>
		n++;
  80131e:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801321:	ff 45 08             	incl   0x8(%ebp)
  801324:	8b 45 08             	mov    0x8(%ebp),%eax
  801327:	8a 00                	mov    (%eax),%al
  801329:	84 c0                	test   %al,%al
  80132b:	75 f1                	jne    80131e <strlen+0xf>
		n++;
	return n;
  80132d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801330:	c9                   	leave  
  801331:	c3                   	ret    

00801332 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801332:	55                   	push   %ebp
  801333:	89 e5                	mov    %esp,%ebp
  801335:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801338:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80133f:	eb 09                	jmp    80134a <strnlen+0x18>
		n++;
  801341:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801344:	ff 45 08             	incl   0x8(%ebp)
  801347:	ff 4d 0c             	decl   0xc(%ebp)
  80134a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80134e:	74 09                	je     801359 <strnlen+0x27>
  801350:	8b 45 08             	mov    0x8(%ebp),%eax
  801353:	8a 00                	mov    (%eax),%al
  801355:	84 c0                	test   %al,%al
  801357:	75 e8                	jne    801341 <strnlen+0xf>
		n++;
	return n;
  801359:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80135c:	c9                   	leave  
  80135d:	c3                   	ret    

0080135e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80135e:	55                   	push   %ebp
  80135f:	89 e5                	mov    %esp,%ebp
  801361:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801364:	8b 45 08             	mov    0x8(%ebp),%eax
  801367:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80136a:	90                   	nop
  80136b:	8b 45 08             	mov    0x8(%ebp),%eax
  80136e:	8d 50 01             	lea    0x1(%eax),%edx
  801371:	89 55 08             	mov    %edx,0x8(%ebp)
  801374:	8b 55 0c             	mov    0xc(%ebp),%edx
  801377:	8d 4a 01             	lea    0x1(%edx),%ecx
  80137a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80137d:	8a 12                	mov    (%edx),%dl
  80137f:	88 10                	mov    %dl,(%eax)
  801381:	8a 00                	mov    (%eax),%al
  801383:	84 c0                	test   %al,%al
  801385:	75 e4                	jne    80136b <strcpy+0xd>
		/* do nothing */;
	return ret;
  801387:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80138a:	c9                   	leave  
  80138b:	c3                   	ret    

0080138c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80138c:	55                   	push   %ebp
  80138d:	89 e5                	mov    %esp,%ebp
  80138f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801392:	8b 45 08             	mov    0x8(%ebp),%eax
  801395:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801398:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80139f:	eb 1f                	jmp    8013c0 <strncpy+0x34>
		*dst++ = *src;
  8013a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a4:	8d 50 01             	lea    0x1(%eax),%edx
  8013a7:	89 55 08             	mov    %edx,0x8(%ebp)
  8013aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013ad:	8a 12                	mov    (%edx),%dl
  8013af:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8013b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b4:	8a 00                	mov    (%eax),%al
  8013b6:	84 c0                	test   %al,%al
  8013b8:	74 03                	je     8013bd <strncpy+0x31>
			src++;
  8013ba:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8013bd:	ff 45 fc             	incl   -0x4(%ebp)
  8013c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013c3:	3b 45 10             	cmp    0x10(%ebp),%eax
  8013c6:	72 d9                	jb     8013a1 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8013c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8013cb:	c9                   	leave  
  8013cc:	c3                   	ret    

008013cd <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8013cd:	55                   	push   %ebp
  8013ce:	89 e5                	mov    %esp,%ebp
  8013d0:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8013d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8013d9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013dd:	74 30                	je     80140f <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8013df:	eb 16                	jmp    8013f7 <strlcpy+0x2a>
			*dst++ = *src++;
  8013e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e4:	8d 50 01             	lea    0x1(%eax),%edx
  8013e7:	89 55 08             	mov    %edx,0x8(%ebp)
  8013ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013ed:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013f0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013f3:	8a 12                	mov    (%edx),%dl
  8013f5:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8013f7:	ff 4d 10             	decl   0x10(%ebp)
  8013fa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013fe:	74 09                	je     801409 <strlcpy+0x3c>
  801400:	8b 45 0c             	mov    0xc(%ebp),%eax
  801403:	8a 00                	mov    (%eax),%al
  801405:	84 c0                	test   %al,%al
  801407:	75 d8                	jne    8013e1 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801409:	8b 45 08             	mov    0x8(%ebp),%eax
  80140c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80140f:	8b 55 08             	mov    0x8(%ebp),%edx
  801412:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801415:	29 c2                	sub    %eax,%edx
  801417:	89 d0                	mov    %edx,%eax
}
  801419:	c9                   	leave  
  80141a:	c3                   	ret    

0080141b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80141b:	55                   	push   %ebp
  80141c:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80141e:	eb 06                	jmp    801426 <strcmp+0xb>
		p++, q++;
  801420:	ff 45 08             	incl   0x8(%ebp)
  801423:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801426:	8b 45 08             	mov    0x8(%ebp),%eax
  801429:	8a 00                	mov    (%eax),%al
  80142b:	84 c0                	test   %al,%al
  80142d:	74 0e                	je     80143d <strcmp+0x22>
  80142f:	8b 45 08             	mov    0x8(%ebp),%eax
  801432:	8a 10                	mov    (%eax),%dl
  801434:	8b 45 0c             	mov    0xc(%ebp),%eax
  801437:	8a 00                	mov    (%eax),%al
  801439:	38 c2                	cmp    %al,%dl
  80143b:	74 e3                	je     801420 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80143d:	8b 45 08             	mov    0x8(%ebp),%eax
  801440:	8a 00                	mov    (%eax),%al
  801442:	0f b6 d0             	movzbl %al,%edx
  801445:	8b 45 0c             	mov    0xc(%ebp),%eax
  801448:	8a 00                	mov    (%eax),%al
  80144a:	0f b6 c0             	movzbl %al,%eax
  80144d:	29 c2                	sub    %eax,%edx
  80144f:	89 d0                	mov    %edx,%eax
}
  801451:	5d                   	pop    %ebp
  801452:	c3                   	ret    

00801453 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801453:	55                   	push   %ebp
  801454:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801456:	eb 09                	jmp    801461 <strncmp+0xe>
		n--, p++, q++;
  801458:	ff 4d 10             	decl   0x10(%ebp)
  80145b:	ff 45 08             	incl   0x8(%ebp)
  80145e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801461:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801465:	74 17                	je     80147e <strncmp+0x2b>
  801467:	8b 45 08             	mov    0x8(%ebp),%eax
  80146a:	8a 00                	mov    (%eax),%al
  80146c:	84 c0                	test   %al,%al
  80146e:	74 0e                	je     80147e <strncmp+0x2b>
  801470:	8b 45 08             	mov    0x8(%ebp),%eax
  801473:	8a 10                	mov    (%eax),%dl
  801475:	8b 45 0c             	mov    0xc(%ebp),%eax
  801478:	8a 00                	mov    (%eax),%al
  80147a:	38 c2                	cmp    %al,%dl
  80147c:	74 da                	je     801458 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80147e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801482:	75 07                	jne    80148b <strncmp+0x38>
		return 0;
  801484:	b8 00 00 00 00       	mov    $0x0,%eax
  801489:	eb 14                	jmp    80149f <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80148b:	8b 45 08             	mov    0x8(%ebp),%eax
  80148e:	8a 00                	mov    (%eax),%al
  801490:	0f b6 d0             	movzbl %al,%edx
  801493:	8b 45 0c             	mov    0xc(%ebp),%eax
  801496:	8a 00                	mov    (%eax),%al
  801498:	0f b6 c0             	movzbl %al,%eax
  80149b:	29 c2                	sub    %eax,%edx
  80149d:	89 d0                	mov    %edx,%eax
}
  80149f:	5d                   	pop    %ebp
  8014a0:	c3                   	ret    

008014a1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8014a1:	55                   	push   %ebp
  8014a2:	89 e5                	mov    %esp,%ebp
  8014a4:	83 ec 04             	sub    $0x4,%esp
  8014a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014aa:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8014ad:	eb 12                	jmp    8014c1 <strchr+0x20>
		if (*s == c)
  8014af:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b2:	8a 00                	mov    (%eax),%al
  8014b4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8014b7:	75 05                	jne    8014be <strchr+0x1d>
			return (char *) s;
  8014b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bc:	eb 11                	jmp    8014cf <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8014be:	ff 45 08             	incl   0x8(%ebp)
  8014c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c4:	8a 00                	mov    (%eax),%al
  8014c6:	84 c0                	test   %al,%al
  8014c8:	75 e5                	jne    8014af <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8014ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014cf:	c9                   	leave  
  8014d0:	c3                   	ret    

008014d1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8014d1:	55                   	push   %ebp
  8014d2:	89 e5                	mov    %esp,%ebp
  8014d4:	83 ec 04             	sub    $0x4,%esp
  8014d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014da:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8014dd:	eb 0d                	jmp    8014ec <strfind+0x1b>
		if (*s == c)
  8014df:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e2:	8a 00                	mov    (%eax),%al
  8014e4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8014e7:	74 0e                	je     8014f7 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8014e9:	ff 45 08             	incl   0x8(%ebp)
  8014ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ef:	8a 00                	mov    (%eax),%al
  8014f1:	84 c0                	test   %al,%al
  8014f3:	75 ea                	jne    8014df <strfind+0xe>
  8014f5:	eb 01                	jmp    8014f8 <strfind+0x27>
		if (*s == c)
			break;
  8014f7:	90                   	nop
	return (char *) s;
  8014f8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014fb:	c9                   	leave  
  8014fc:	c3                   	ret    

008014fd <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8014fd:	55                   	push   %ebp
  8014fe:	89 e5                	mov    %esp,%ebp
  801500:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801503:	8b 45 08             	mov    0x8(%ebp),%eax
  801506:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801509:	8b 45 10             	mov    0x10(%ebp),%eax
  80150c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80150f:	eb 0e                	jmp    80151f <memset+0x22>
		*p++ = c;
  801511:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801514:	8d 50 01             	lea    0x1(%eax),%edx
  801517:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80151a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80151d:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80151f:	ff 4d f8             	decl   -0x8(%ebp)
  801522:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801526:	79 e9                	jns    801511 <memset+0x14>
		*p++ = c;

	return v;
  801528:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80152b:	c9                   	leave  
  80152c:	c3                   	ret    

0080152d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80152d:	55                   	push   %ebp
  80152e:	89 e5                	mov    %esp,%ebp
  801530:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801533:	8b 45 0c             	mov    0xc(%ebp),%eax
  801536:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801539:	8b 45 08             	mov    0x8(%ebp),%eax
  80153c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80153f:	eb 16                	jmp    801557 <memcpy+0x2a>
		*d++ = *s++;
  801541:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801544:	8d 50 01             	lea    0x1(%eax),%edx
  801547:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80154a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80154d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801550:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801553:	8a 12                	mov    (%edx),%dl
  801555:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801557:	8b 45 10             	mov    0x10(%ebp),%eax
  80155a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80155d:	89 55 10             	mov    %edx,0x10(%ebp)
  801560:	85 c0                	test   %eax,%eax
  801562:	75 dd                	jne    801541 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801564:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801567:	c9                   	leave  
  801568:	c3                   	ret    

00801569 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801569:	55                   	push   %ebp
  80156a:	89 e5                	mov    %esp,%ebp
  80156c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80156f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801572:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801575:	8b 45 08             	mov    0x8(%ebp),%eax
  801578:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80157b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80157e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801581:	73 50                	jae    8015d3 <memmove+0x6a>
  801583:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801586:	8b 45 10             	mov    0x10(%ebp),%eax
  801589:	01 d0                	add    %edx,%eax
  80158b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80158e:	76 43                	jbe    8015d3 <memmove+0x6a>
		s += n;
  801590:	8b 45 10             	mov    0x10(%ebp),%eax
  801593:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801596:	8b 45 10             	mov    0x10(%ebp),%eax
  801599:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80159c:	eb 10                	jmp    8015ae <memmove+0x45>
			*--d = *--s;
  80159e:	ff 4d f8             	decl   -0x8(%ebp)
  8015a1:	ff 4d fc             	decl   -0x4(%ebp)
  8015a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015a7:	8a 10                	mov    (%eax),%dl
  8015a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015ac:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8015ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015b4:	89 55 10             	mov    %edx,0x10(%ebp)
  8015b7:	85 c0                	test   %eax,%eax
  8015b9:	75 e3                	jne    80159e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8015bb:	eb 23                	jmp    8015e0 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8015bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015c0:	8d 50 01             	lea    0x1(%eax),%edx
  8015c3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015c6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015c9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015cc:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8015cf:	8a 12                	mov    (%edx),%dl
  8015d1:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8015d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015d9:	89 55 10             	mov    %edx,0x10(%ebp)
  8015dc:	85 c0                	test   %eax,%eax
  8015de:	75 dd                	jne    8015bd <memmove+0x54>
			*d++ = *s++;

	return dst;
  8015e0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015e3:	c9                   	leave  
  8015e4:	c3                   	ret    

008015e5 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8015e5:	55                   	push   %ebp
  8015e6:	89 e5                	mov    %esp,%ebp
  8015e8:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8015eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8015f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f4:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8015f7:	eb 2a                	jmp    801623 <memcmp+0x3e>
		if (*s1 != *s2)
  8015f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015fc:	8a 10                	mov    (%eax),%dl
  8015fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801601:	8a 00                	mov    (%eax),%al
  801603:	38 c2                	cmp    %al,%dl
  801605:	74 16                	je     80161d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801607:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80160a:	8a 00                	mov    (%eax),%al
  80160c:	0f b6 d0             	movzbl %al,%edx
  80160f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801612:	8a 00                	mov    (%eax),%al
  801614:	0f b6 c0             	movzbl %al,%eax
  801617:	29 c2                	sub    %eax,%edx
  801619:	89 d0                	mov    %edx,%eax
  80161b:	eb 18                	jmp    801635 <memcmp+0x50>
		s1++, s2++;
  80161d:	ff 45 fc             	incl   -0x4(%ebp)
  801620:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801623:	8b 45 10             	mov    0x10(%ebp),%eax
  801626:	8d 50 ff             	lea    -0x1(%eax),%edx
  801629:	89 55 10             	mov    %edx,0x10(%ebp)
  80162c:	85 c0                	test   %eax,%eax
  80162e:	75 c9                	jne    8015f9 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801630:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801635:	c9                   	leave  
  801636:	c3                   	ret    

00801637 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801637:	55                   	push   %ebp
  801638:	89 e5                	mov    %esp,%ebp
  80163a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80163d:	8b 55 08             	mov    0x8(%ebp),%edx
  801640:	8b 45 10             	mov    0x10(%ebp),%eax
  801643:	01 d0                	add    %edx,%eax
  801645:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801648:	eb 15                	jmp    80165f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80164a:	8b 45 08             	mov    0x8(%ebp),%eax
  80164d:	8a 00                	mov    (%eax),%al
  80164f:	0f b6 d0             	movzbl %al,%edx
  801652:	8b 45 0c             	mov    0xc(%ebp),%eax
  801655:	0f b6 c0             	movzbl %al,%eax
  801658:	39 c2                	cmp    %eax,%edx
  80165a:	74 0d                	je     801669 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80165c:	ff 45 08             	incl   0x8(%ebp)
  80165f:	8b 45 08             	mov    0x8(%ebp),%eax
  801662:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801665:	72 e3                	jb     80164a <memfind+0x13>
  801667:	eb 01                	jmp    80166a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801669:	90                   	nop
	return (void *) s;
  80166a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80166d:	c9                   	leave  
  80166e:	c3                   	ret    

0080166f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80166f:	55                   	push   %ebp
  801670:	89 e5                	mov    %esp,%ebp
  801672:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801675:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80167c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801683:	eb 03                	jmp    801688 <strtol+0x19>
		s++;
  801685:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801688:	8b 45 08             	mov    0x8(%ebp),%eax
  80168b:	8a 00                	mov    (%eax),%al
  80168d:	3c 20                	cmp    $0x20,%al
  80168f:	74 f4                	je     801685 <strtol+0x16>
  801691:	8b 45 08             	mov    0x8(%ebp),%eax
  801694:	8a 00                	mov    (%eax),%al
  801696:	3c 09                	cmp    $0x9,%al
  801698:	74 eb                	je     801685 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80169a:	8b 45 08             	mov    0x8(%ebp),%eax
  80169d:	8a 00                	mov    (%eax),%al
  80169f:	3c 2b                	cmp    $0x2b,%al
  8016a1:	75 05                	jne    8016a8 <strtol+0x39>
		s++;
  8016a3:	ff 45 08             	incl   0x8(%ebp)
  8016a6:	eb 13                	jmp    8016bb <strtol+0x4c>
	else if (*s == '-')
  8016a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ab:	8a 00                	mov    (%eax),%al
  8016ad:	3c 2d                	cmp    $0x2d,%al
  8016af:	75 0a                	jne    8016bb <strtol+0x4c>
		s++, neg = 1;
  8016b1:	ff 45 08             	incl   0x8(%ebp)
  8016b4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8016bb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016bf:	74 06                	je     8016c7 <strtol+0x58>
  8016c1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8016c5:	75 20                	jne    8016e7 <strtol+0x78>
  8016c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ca:	8a 00                	mov    (%eax),%al
  8016cc:	3c 30                	cmp    $0x30,%al
  8016ce:	75 17                	jne    8016e7 <strtol+0x78>
  8016d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d3:	40                   	inc    %eax
  8016d4:	8a 00                	mov    (%eax),%al
  8016d6:	3c 78                	cmp    $0x78,%al
  8016d8:	75 0d                	jne    8016e7 <strtol+0x78>
		s += 2, base = 16;
  8016da:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8016de:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8016e5:	eb 28                	jmp    80170f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8016e7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016eb:	75 15                	jne    801702 <strtol+0x93>
  8016ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f0:	8a 00                	mov    (%eax),%al
  8016f2:	3c 30                	cmp    $0x30,%al
  8016f4:	75 0c                	jne    801702 <strtol+0x93>
		s++, base = 8;
  8016f6:	ff 45 08             	incl   0x8(%ebp)
  8016f9:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801700:	eb 0d                	jmp    80170f <strtol+0xa0>
	else if (base == 0)
  801702:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801706:	75 07                	jne    80170f <strtol+0xa0>
		base = 10;
  801708:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80170f:	8b 45 08             	mov    0x8(%ebp),%eax
  801712:	8a 00                	mov    (%eax),%al
  801714:	3c 2f                	cmp    $0x2f,%al
  801716:	7e 19                	jle    801731 <strtol+0xc2>
  801718:	8b 45 08             	mov    0x8(%ebp),%eax
  80171b:	8a 00                	mov    (%eax),%al
  80171d:	3c 39                	cmp    $0x39,%al
  80171f:	7f 10                	jg     801731 <strtol+0xc2>
			dig = *s - '0';
  801721:	8b 45 08             	mov    0x8(%ebp),%eax
  801724:	8a 00                	mov    (%eax),%al
  801726:	0f be c0             	movsbl %al,%eax
  801729:	83 e8 30             	sub    $0x30,%eax
  80172c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80172f:	eb 42                	jmp    801773 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801731:	8b 45 08             	mov    0x8(%ebp),%eax
  801734:	8a 00                	mov    (%eax),%al
  801736:	3c 60                	cmp    $0x60,%al
  801738:	7e 19                	jle    801753 <strtol+0xe4>
  80173a:	8b 45 08             	mov    0x8(%ebp),%eax
  80173d:	8a 00                	mov    (%eax),%al
  80173f:	3c 7a                	cmp    $0x7a,%al
  801741:	7f 10                	jg     801753 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801743:	8b 45 08             	mov    0x8(%ebp),%eax
  801746:	8a 00                	mov    (%eax),%al
  801748:	0f be c0             	movsbl %al,%eax
  80174b:	83 e8 57             	sub    $0x57,%eax
  80174e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801751:	eb 20                	jmp    801773 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801753:	8b 45 08             	mov    0x8(%ebp),%eax
  801756:	8a 00                	mov    (%eax),%al
  801758:	3c 40                	cmp    $0x40,%al
  80175a:	7e 39                	jle    801795 <strtol+0x126>
  80175c:	8b 45 08             	mov    0x8(%ebp),%eax
  80175f:	8a 00                	mov    (%eax),%al
  801761:	3c 5a                	cmp    $0x5a,%al
  801763:	7f 30                	jg     801795 <strtol+0x126>
			dig = *s - 'A' + 10;
  801765:	8b 45 08             	mov    0x8(%ebp),%eax
  801768:	8a 00                	mov    (%eax),%al
  80176a:	0f be c0             	movsbl %al,%eax
  80176d:	83 e8 37             	sub    $0x37,%eax
  801770:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801773:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801776:	3b 45 10             	cmp    0x10(%ebp),%eax
  801779:	7d 19                	jge    801794 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80177b:	ff 45 08             	incl   0x8(%ebp)
  80177e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801781:	0f af 45 10          	imul   0x10(%ebp),%eax
  801785:	89 c2                	mov    %eax,%edx
  801787:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80178a:	01 d0                	add    %edx,%eax
  80178c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80178f:	e9 7b ff ff ff       	jmp    80170f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801794:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801795:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801799:	74 08                	je     8017a3 <strtol+0x134>
		*endptr = (char *) s;
  80179b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80179e:	8b 55 08             	mov    0x8(%ebp),%edx
  8017a1:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8017a3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8017a7:	74 07                	je     8017b0 <strtol+0x141>
  8017a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017ac:	f7 d8                	neg    %eax
  8017ae:	eb 03                	jmp    8017b3 <strtol+0x144>
  8017b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8017b3:	c9                   	leave  
  8017b4:	c3                   	ret    

008017b5 <ltostr>:

void
ltostr(long value, char *str)
{
  8017b5:	55                   	push   %ebp
  8017b6:	89 e5                	mov    %esp,%ebp
  8017b8:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8017bb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8017c2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8017c9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8017cd:	79 13                	jns    8017e2 <ltostr+0x2d>
	{
		neg = 1;
  8017cf:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8017d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d9:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8017dc:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8017df:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8017e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e5:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8017ea:	99                   	cltd   
  8017eb:	f7 f9                	idiv   %ecx
  8017ed:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8017f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017f3:	8d 50 01             	lea    0x1(%eax),%edx
  8017f6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8017f9:	89 c2                	mov    %eax,%edx
  8017fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017fe:	01 d0                	add    %edx,%eax
  801800:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801803:	83 c2 30             	add    $0x30,%edx
  801806:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801808:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80180b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801810:	f7 e9                	imul   %ecx
  801812:	c1 fa 02             	sar    $0x2,%edx
  801815:	89 c8                	mov    %ecx,%eax
  801817:	c1 f8 1f             	sar    $0x1f,%eax
  80181a:	29 c2                	sub    %eax,%edx
  80181c:	89 d0                	mov    %edx,%eax
  80181e:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801821:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801825:	75 bb                	jne    8017e2 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801827:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80182e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801831:	48                   	dec    %eax
  801832:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801835:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801839:	74 3d                	je     801878 <ltostr+0xc3>
		start = 1 ;
  80183b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801842:	eb 34                	jmp    801878 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801844:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801847:	8b 45 0c             	mov    0xc(%ebp),%eax
  80184a:	01 d0                	add    %edx,%eax
  80184c:	8a 00                	mov    (%eax),%al
  80184e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801851:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801854:	8b 45 0c             	mov    0xc(%ebp),%eax
  801857:	01 c2                	add    %eax,%edx
  801859:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80185c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80185f:	01 c8                	add    %ecx,%eax
  801861:	8a 00                	mov    (%eax),%al
  801863:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801865:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801868:	8b 45 0c             	mov    0xc(%ebp),%eax
  80186b:	01 c2                	add    %eax,%edx
  80186d:	8a 45 eb             	mov    -0x15(%ebp),%al
  801870:	88 02                	mov    %al,(%edx)
		start++ ;
  801872:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801875:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801878:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80187b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80187e:	7c c4                	jl     801844 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801880:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801883:	8b 45 0c             	mov    0xc(%ebp),%eax
  801886:	01 d0                	add    %edx,%eax
  801888:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80188b:	90                   	nop
  80188c:	c9                   	leave  
  80188d:	c3                   	ret    

0080188e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80188e:	55                   	push   %ebp
  80188f:	89 e5                	mov    %esp,%ebp
  801891:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801894:	ff 75 08             	pushl  0x8(%ebp)
  801897:	e8 73 fa ff ff       	call   80130f <strlen>
  80189c:	83 c4 04             	add    $0x4,%esp
  80189f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8018a2:	ff 75 0c             	pushl  0xc(%ebp)
  8018a5:	e8 65 fa ff ff       	call   80130f <strlen>
  8018aa:	83 c4 04             	add    $0x4,%esp
  8018ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8018b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8018b7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8018be:	eb 17                	jmp    8018d7 <strcconcat+0x49>
		final[s] = str1[s] ;
  8018c0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8018c6:	01 c2                	add    %eax,%edx
  8018c8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8018cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ce:	01 c8                	add    %ecx,%eax
  8018d0:	8a 00                	mov    (%eax),%al
  8018d2:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8018d4:	ff 45 fc             	incl   -0x4(%ebp)
  8018d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018da:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8018dd:	7c e1                	jl     8018c0 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8018df:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8018e6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8018ed:	eb 1f                	jmp    80190e <strcconcat+0x80>
		final[s++] = str2[i] ;
  8018ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018f2:	8d 50 01             	lea    0x1(%eax),%edx
  8018f5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8018f8:	89 c2                	mov    %eax,%edx
  8018fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8018fd:	01 c2                	add    %eax,%edx
  8018ff:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801902:	8b 45 0c             	mov    0xc(%ebp),%eax
  801905:	01 c8                	add    %ecx,%eax
  801907:	8a 00                	mov    (%eax),%al
  801909:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80190b:	ff 45 f8             	incl   -0x8(%ebp)
  80190e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801911:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801914:	7c d9                	jl     8018ef <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801916:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801919:	8b 45 10             	mov    0x10(%ebp),%eax
  80191c:	01 d0                	add    %edx,%eax
  80191e:	c6 00 00             	movb   $0x0,(%eax)
}
  801921:	90                   	nop
  801922:	c9                   	leave  
  801923:	c3                   	ret    

00801924 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801924:	55                   	push   %ebp
  801925:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801927:	8b 45 14             	mov    0x14(%ebp),%eax
  80192a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801930:	8b 45 14             	mov    0x14(%ebp),%eax
  801933:	8b 00                	mov    (%eax),%eax
  801935:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80193c:	8b 45 10             	mov    0x10(%ebp),%eax
  80193f:	01 d0                	add    %edx,%eax
  801941:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801947:	eb 0c                	jmp    801955 <strsplit+0x31>
			*string++ = 0;
  801949:	8b 45 08             	mov    0x8(%ebp),%eax
  80194c:	8d 50 01             	lea    0x1(%eax),%edx
  80194f:	89 55 08             	mov    %edx,0x8(%ebp)
  801952:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801955:	8b 45 08             	mov    0x8(%ebp),%eax
  801958:	8a 00                	mov    (%eax),%al
  80195a:	84 c0                	test   %al,%al
  80195c:	74 18                	je     801976 <strsplit+0x52>
  80195e:	8b 45 08             	mov    0x8(%ebp),%eax
  801961:	8a 00                	mov    (%eax),%al
  801963:	0f be c0             	movsbl %al,%eax
  801966:	50                   	push   %eax
  801967:	ff 75 0c             	pushl  0xc(%ebp)
  80196a:	e8 32 fb ff ff       	call   8014a1 <strchr>
  80196f:	83 c4 08             	add    $0x8,%esp
  801972:	85 c0                	test   %eax,%eax
  801974:	75 d3                	jne    801949 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801976:	8b 45 08             	mov    0x8(%ebp),%eax
  801979:	8a 00                	mov    (%eax),%al
  80197b:	84 c0                	test   %al,%al
  80197d:	74 5a                	je     8019d9 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80197f:	8b 45 14             	mov    0x14(%ebp),%eax
  801982:	8b 00                	mov    (%eax),%eax
  801984:	83 f8 0f             	cmp    $0xf,%eax
  801987:	75 07                	jne    801990 <strsplit+0x6c>
		{
			return 0;
  801989:	b8 00 00 00 00       	mov    $0x0,%eax
  80198e:	eb 66                	jmp    8019f6 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801990:	8b 45 14             	mov    0x14(%ebp),%eax
  801993:	8b 00                	mov    (%eax),%eax
  801995:	8d 48 01             	lea    0x1(%eax),%ecx
  801998:	8b 55 14             	mov    0x14(%ebp),%edx
  80199b:	89 0a                	mov    %ecx,(%edx)
  80199d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8019a7:	01 c2                	add    %eax,%edx
  8019a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ac:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8019ae:	eb 03                	jmp    8019b3 <strsplit+0x8f>
			string++;
  8019b0:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8019b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b6:	8a 00                	mov    (%eax),%al
  8019b8:	84 c0                	test   %al,%al
  8019ba:	74 8b                	je     801947 <strsplit+0x23>
  8019bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bf:	8a 00                	mov    (%eax),%al
  8019c1:	0f be c0             	movsbl %al,%eax
  8019c4:	50                   	push   %eax
  8019c5:	ff 75 0c             	pushl  0xc(%ebp)
  8019c8:	e8 d4 fa ff ff       	call   8014a1 <strchr>
  8019cd:	83 c4 08             	add    $0x8,%esp
  8019d0:	85 c0                	test   %eax,%eax
  8019d2:	74 dc                	je     8019b0 <strsplit+0x8c>
			string++;
	}
  8019d4:	e9 6e ff ff ff       	jmp    801947 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8019d9:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8019da:	8b 45 14             	mov    0x14(%ebp),%eax
  8019dd:	8b 00                	mov    (%eax),%eax
  8019df:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8019e9:	01 d0                	add    %edx,%eax
  8019eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8019f1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8019f6:	c9                   	leave  
  8019f7:	c3                   	ret    

008019f8 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8019f8:	55                   	push   %ebp
  8019f9:	89 e5                	mov    %esp,%ebp
  8019fb:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8019fe:	83 ec 04             	sub    $0x4,%esp
  801a01:	68 7c 45 80 00       	push   $0x80457c
  801a06:	68 3f 01 00 00       	push   $0x13f
  801a0b:	68 9e 45 80 00       	push   $0x80459e
  801a10:	e8 a1 ed ff ff       	call   8007b6 <_panic>

00801a15 <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  801a15:	55                   	push   %ebp
  801a16:	89 e5                	mov    %esp,%ebp
  801a18:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801a1b:	83 ec 0c             	sub    $0xc,%esp
  801a1e:	ff 75 08             	pushl  0x8(%ebp)
  801a21:	e8 90 0c 00 00       	call   8026b6 <sys_sbrk>
  801a26:	83 c4 10             	add    $0x10,%esp
}
  801a29:	c9                   	leave  
  801a2a:	c3                   	ret    

00801a2b <malloc>:
#define num_of_page ((USER_HEAP_MAX - USER_HEAP_START) / PAGE_SIZE)

int pagesAllocated[num_of_page] = { 0 };
int shardIDs[num_of_page] = { 0 };
bool markedPages[num_of_page] = { 0 };
void* malloc(uint32 size) {
  801a2b:	55                   	push   %ebp
  801a2c:	89 e5                	mov    %esp,%ebp
  801a2e:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  801a31:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a35:	75 0a                	jne    801a41 <malloc+0x16>
		return NULL;
  801a37:	b8 00 00 00 00       	mov    $0x0,%eax
  801a3c:	e9 9e 01 00 00       	jmp    801bdf <malloc+0x1b4>

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

	//  our new code
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  801a41:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801a48:	77 2c                	ja     801a76 <malloc+0x4b>
		if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  801a4a:	e8 eb 0a 00 00       	call   80253a <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a4f:	85 c0                	test   %eax,%eax
  801a51:	74 19                	je     801a6c <malloc+0x41>

			void * block = alloc_block_FF(size);
  801a53:	83 ec 0c             	sub    $0xc,%esp
  801a56:	ff 75 08             	pushl  0x8(%ebp)
  801a59:	e8 85 11 00 00       	call   802be3 <alloc_block_FF>
  801a5e:	83 c4 10             	add    $0x10,%esp
  801a61:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			return block;
  801a64:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a67:	e9 73 01 00 00       	jmp    801bdf <malloc+0x1b4>
		} else {
			return NULL;
  801a6c:	b8 00 00 00 00       	mov    $0x0,%eax
  801a71:	e9 69 01 00 00       	jmp    801bdf <malloc+0x1b4>
		}
	}

	uint32 numOfPages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801a76:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801a7d:	8b 55 08             	mov    0x8(%ebp),%edx
  801a80:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a83:	01 d0                	add    %edx,%eax
  801a85:	48                   	dec    %eax
  801a86:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801a89:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a8c:	ba 00 00 00 00       	mov    $0x0,%edx
  801a91:	f7 75 e0             	divl   -0x20(%ebp)
  801a94:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a97:	29 d0                	sub    %edx,%eax
  801a99:	c1 e8 0c             	shr    $0xc,%eax
  801a9c:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 freePagesCount = 0;
  801a9f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801aa6:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  801aad:	a1 24 50 80 00       	mov    0x805024,%eax
  801ab2:	8b 40 7c             	mov    0x7c(%eax),%eax
  801ab5:	05 00 10 00 00       	add    $0x1000,%eax
  801aba:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  801abd:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801ac2:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801ac5:	89 45 d0             	mov    %eax,-0x30(%ebp)

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  801ac8:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  801acf:	8b 55 08             	mov    0x8(%ebp),%edx
  801ad2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801ad5:	01 d0                	add    %edx,%eax
  801ad7:	48                   	dec    %eax
  801ad8:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801adb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801ade:	ba 00 00 00 00       	mov    $0x0,%edx
  801ae3:	f7 75 cc             	divl   -0x34(%ebp)
  801ae6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801ae9:	29 d0                	sub    %edx,%eax
  801aeb:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801aee:	76 0a                	jbe    801afa <malloc+0xcf>
		return NULL;
  801af0:	b8 00 00 00 00       	mov    $0x0,%eax
  801af5:	e9 e5 00 00 00       	jmp    801bdf <malloc+0x1b4>
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  801afa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801afd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801b00:	eb 48                	jmp    801b4a <malloc+0x11f>
	{
		uint32 idx = (i - currentAddr) / PAGE_SIZE;
  801b02:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b05:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801b08:	c1 e8 0c             	shr    $0xc,%eax
  801b0b:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if (!markedPages[idx]) {
  801b0e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801b11:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  801b18:	85 c0                	test   %eax,%eax
  801b1a:	75 11                	jne    801b2d <malloc+0x102>
			freePagesCount++;
  801b1c:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801b1f:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801b23:	75 16                	jne    801b3b <malloc+0x110>
				start = i;
  801b25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b28:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b2b:	eb 0e                	jmp    801b3b <malloc+0x110>
			}
		} else {
			freePagesCount = 0;
  801b2d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  801b34:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == numOfPages) {
  801b3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b3e:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801b41:	74 12                	je     801b55 <malloc+0x12a>

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  801b43:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801b4a:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801b51:	76 af                	jbe    801b02 <malloc+0xd7>
  801b53:	eb 01                	jmp    801b56 <malloc+0x12b>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == numOfPages) {
			break;
  801b55:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
  801b56:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801b5a:	74 08                	je     801b64 <malloc+0x139>
  801b5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b5f:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801b62:	74 07                	je     801b6b <malloc+0x140>
		return NULL;
  801b64:	b8 00 00 00 00       	mov    $0x0,%eax
  801b69:	eb 74                	jmp    801bdf <malloc+0x1b4>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  801b6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b6e:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801b71:	c1 e8 0c             	shr    $0xc,%eax
  801b74:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numOfPages;
  801b77:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801b7a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801b7d:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  801b84:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801b87:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801b8a:	eb 11                	jmp    801b9d <malloc+0x172>
		markedPages[i] = 1;
  801b8c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b8f:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  801b96:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = numOfPages;
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  801b9a:	ff 45 e8             	incl   -0x18(%ebp)
  801b9d:	8b 55 c0             	mov    -0x40(%ebp),%edx
  801ba0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ba3:	01 d0                	add    %edx,%eax
  801ba5:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801ba8:	77 e2                	ja     801b8c <malloc+0x161>
		markedPages[i] = 1;
	}

	sys_allocate_user_mem(start, ROUNDUP(size, PAGE_SIZE));
  801baa:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801bb1:	8b 55 08             	mov    0x8(%ebp),%edx
  801bb4:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801bb7:	01 d0                	add    %edx,%eax
  801bb9:	48                   	dec    %eax
  801bba:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801bbd:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801bc0:	ba 00 00 00 00       	mov    $0x0,%edx
  801bc5:	f7 75 bc             	divl   -0x44(%ebp)
  801bc8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801bcb:	29 d0                	sub    %edx,%eax
  801bcd:	83 ec 08             	sub    $0x8,%esp
  801bd0:	50                   	push   %eax
  801bd1:	ff 75 f0             	pushl  -0x10(%ebp)
  801bd4:	e8 14 0b 00 00       	call   8026ed <sys_allocate_user_mem>
  801bd9:	83 c4 10             	add    $0x10,%esp
	return (void*) start;
  801bdc:	8b 45 f0             	mov    -0x10(%ebp),%eax

}
  801bdf:	c9                   	leave  
  801be0:	c3                   	ret    

00801be1 <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address) {
  801be1:	55                   	push   %ebp
  801be2:	89 e5                	mov    %esp,%ebp
  801be4:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
  801be7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801beb:	0f 84 ee 00 00 00    	je     801cdf <free+0xfe>
		return;
	}

	if (virtual_address
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  801bf1:	a1 24 50 80 00       	mov    0x805024,%eax
  801bf6:	8b 40 74             	mov    0x74(%eax),%eax

	if (virtual_address == NULL) {
		return;
	}

	if (virtual_address
  801bf9:	3b 45 08             	cmp    0x8(%ebp),%eax
  801bfc:	77 09                	ja     801c07 <free+0x26>
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  801bfe:	81 7d 08 00 00 00 a0 	cmpl   $0xa0000000,0x8(%ebp)
  801c05:	76 14                	jbe    801c1b <free+0x3a>
		panic("INVALID VIRTUAL ADDRESS!!");
  801c07:	83 ec 04             	sub    $0x4,%esp
  801c0a:	68 ac 45 80 00       	push   $0x8045ac
  801c0f:	6a 68                	push   $0x68
  801c11:	68 c6 45 80 00       	push   $0x8045c6
  801c16:	e8 9b eb ff ff       	call   8007b6 <_panic>
	}
	if (virtual_address >= (void *) (myEnv->uheapStart)
  801c1b:	a1 24 50 80 00       	mov    0x805024,%eax
  801c20:	8b 40 74             	mov    0x74(%eax),%eax
  801c23:	3b 45 08             	cmp    0x8(%ebp),%eax
  801c26:	77 20                	ja     801c48 <free+0x67>
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
  801c28:	a1 24 50 80 00       	mov    0x805024,%eax
  801c2d:	8b 40 78             	mov    0x78(%eax),%eax
  801c30:	3b 45 08             	cmp    0x8(%ebp),%eax
  801c33:	76 13                	jbe    801c48 <free+0x67>
		free_block(virtual_address);
  801c35:	83 ec 0c             	sub    $0xc,%esp
  801c38:	ff 75 08             	pushl  0x8(%ebp)
  801c3b:	e8 6c 16 00 00       	call   8032ac <free_block>
  801c40:	83 c4 10             	add    $0x10,%esp
		return;
  801c43:	e9 98 00 00 00       	jmp    801ce0 <free+0xff>
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  801c48:	8b 55 08             	mov    0x8(%ebp),%edx
  801c4b:	a1 24 50 80 00       	mov    0x805024,%eax
  801c50:	8b 40 7c             	mov    0x7c(%eax),%eax
  801c53:	29 c2                	sub    %eax,%edx
  801c55:	89 d0                	mov    %edx,%eax
  801c57:	2d 00 10 00 00       	sub    $0x1000,%eax
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
		free_block(virtual_address);
		return;
	}

	uint32 pageIdx = ((uint32) virtual_address
  801c5c:	c1 e8 0c             	shr    $0xc,%eax
  801c5f:	89 45 ec             	mov    %eax,-0x14(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  801c62:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801c69:	eb 16                	jmp    801c81 <free+0xa0>
		markedPages[idx + pageIdx] = 0;
  801c6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c71:	01 d0                	add    %edx,%eax
  801c73:	c7 04 85 40 50 90 00 	movl   $0x0,0x905040(,%eax,4)
  801c7a:	00 00 00 00 
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  801c7e:	ff 45 f4             	incl   -0xc(%ebp)
  801c81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c84:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  801c8b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801c8e:	7f db                	jg     801c6b <free+0x8a>
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;
  801c90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c93:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  801c9a:	c1 e0 0c             	shl    $0xc,%eax
  801c9d:	89 45 e8             	mov    %eax,-0x18(%ebp)

	for (uint32 i = (uint32) virtual_address;
  801ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ca6:	eb 1a                	jmp    801cc2 <free+0xe1>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
  801ca8:	83 ec 08             	sub    $0x8,%esp
  801cab:	68 00 10 00 00       	push   $0x1000
  801cb0:	ff 75 f0             	pushl  -0x10(%ebp)
  801cb3:	e8 19 0a 00 00       	call   8026d1 <sys_free_user_mem>
  801cb8:	83 c4 10             	add    $0x10,%esp
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
  801cbb:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  801cc2:	8b 55 08             	mov    0x8(%ebp),%edx
  801cc5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801cc8:	01 d0                	add    %edx,%eax
	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
  801cca:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801ccd:	77 d9                	ja     801ca8 <free+0xc7>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;
  801ccf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cd2:	c7 04 85 40 50 80 00 	movl   $0x0,0x805040(,%eax,4)
  801cd9:	00 00 00 00 
  801cdd:	eb 01                	jmp    801ce0 <free+0xff>
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
		return;
  801cdf:	90                   	nop
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;

}
  801ce0:	c9                   	leave  
  801ce1:	c3                   	ret    

00801ce2 <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  801ce2:	55                   	push   %ebp
  801ce3:	89 e5                	mov    %esp,%ebp
  801ce5:	83 ec 58             	sub    $0x58,%esp
  801ce8:	8b 45 10             	mov    0x10(%ebp),%eax
  801ceb:	88 45 b4             	mov    %al,-0x4c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  801cee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801cf2:	75 0a                	jne    801cfe <smalloc+0x1c>
		return NULL;
  801cf4:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf9:	e9 7d 01 00 00       	jmp    801e7b <smalloc+0x199>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	uint32 num_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801cfe:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  801d05:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d0b:	01 d0                	add    %edx,%eax
  801d0d:	48                   	dec    %eax
  801d0e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801d11:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d14:	ba 00 00 00 00       	mov    $0x0,%edx
  801d19:	f7 75 e4             	divl   -0x1c(%ebp)
  801d1c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d1f:	29 d0                	sub    %edx,%eax
  801d21:	c1 e8 0c             	shr    $0xc,%eax
  801d24:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 freePagesCount = 0;
  801d27:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801d2e:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  801d35:	a1 24 50 80 00       	mov    0x805024,%eax
  801d3a:	8b 40 7c             	mov    0x7c(%eax),%eax
  801d3d:	05 00 10 00 00       	add    $0x1000,%eax
  801d42:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  801d45:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801d4a:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801d4d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  801d50:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801d57:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d5a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801d5d:	01 d0                	add    %edx,%eax
  801d5f:	48                   	dec    %eax
  801d60:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801d63:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801d66:	ba 00 00 00 00       	mov    $0x0,%edx
  801d6b:	f7 75 d0             	divl   -0x30(%ebp)
  801d6e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801d71:	29 d0                	sub    %edx,%eax
  801d73:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801d76:	76 0a                	jbe    801d82 <smalloc+0xa0>
		return NULL;
  801d78:	b8 00 00 00 00       	mov    $0x0,%eax
  801d7d:	e9 f9 00 00 00       	jmp    801e7b <smalloc+0x199>
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801d82:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d85:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801d88:	eb 48                	jmp    801dd2 <smalloc+0xf0>
		uint32 idx = (s - currentAddr) / PAGE_SIZE;
  801d8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d8d:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801d90:	c1 e8 0c             	shr    $0xc,%eax
  801d93:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (!markedPages[idx]) {
  801d96:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801d99:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  801da0:	85 c0                	test   %eax,%eax
  801da2:	75 11                	jne    801db5 <smalloc+0xd3>
			freePagesCount++;
  801da4:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801da7:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801dab:	75 16                	jne    801dc3 <smalloc+0xe1>
				start = s;
  801dad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801db0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801db3:	eb 0e                	jmp    801dc3 <smalloc+0xe1>
			}
		} else {
			freePagesCount = 0;
  801db5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  801dbc:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == num_Of_Pages) {
  801dc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc6:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801dc9:	74 12                	je     801ddd <smalloc+0xfb>
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801dcb:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801dd2:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801dd9:	76 af                	jbe    801d8a <smalloc+0xa8>
  801ddb:	eb 01                	jmp    801dde <smalloc+0xfc>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == num_Of_Pages) {
			break;
  801ddd:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
  801dde:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801de2:	74 08                	je     801dec <smalloc+0x10a>
  801de4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801dea:	74 0a                	je     801df6 <smalloc+0x114>
		return NULL;
  801dec:	b8 00 00 00 00       	mov    $0x0,%eax
  801df1:	e9 85 00 00 00       	jmp    801e7b <smalloc+0x199>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  801df6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801df9:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801dfc:	c1 e8 0c             	shr    $0xc,%eax
  801dff:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	pagesAllocated[startPage] = num_Of_Pages;
  801e02:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801e05:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801e08:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  801e0f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801e12:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801e15:	eb 11                	jmp    801e28 <smalloc+0x146>
		markedPages[s] = 1;
  801e17:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e1a:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  801e21:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = num_Of_Pages;
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  801e25:	ff 45 e8             	incl   -0x18(%ebp)
  801e28:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801e2b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e2e:	01 d0                	add    %edx,%eax
  801e30:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801e33:	77 e2                	ja     801e17 <smalloc+0x135>
		markedPages[s] = 1;
	}
	int sharedobjID = sys_createSharedObject(sharedVarName, size, isWritable,
  801e35:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e38:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
  801e3c:	52                   	push   %edx
  801e3d:	50                   	push   %eax
  801e3e:	ff 75 0c             	pushl  0xc(%ebp)
  801e41:	ff 75 08             	pushl  0x8(%ebp)
  801e44:	e8 8f 04 00 00       	call   8022d8 <sys_createSharedObject>
  801e49:	83 c4 10             	add    $0x10,%esp
  801e4c:	89 45 c0             	mov    %eax,-0x40(%ebp)
			(void*) start);

	if (sharedobjID >= 0) {
  801e4f:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  801e53:	78 12                	js     801e67 <smalloc+0x185>
		shardIDs[startPage] = sharedobjID;
  801e55:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801e58:	8b 55 c0             	mov    -0x40(%ebp),%edx
  801e5b:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  801e62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e65:	eb 14                	jmp    801e7b <smalloc+0x199>
	}
	free((void*) start);
  801e67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e6a:	83 ec 0c             	sub    $0xc,%esp
  801e6d:	50                   	push   %eax
  801e6e:	e8 6e fd ff ff       	call   801be1 <free>
  801e73:	83 c4 10             	add    $0x10,%esp
	return NULL;
  801e76:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e7b:	c9                   	leave  
  801e7c:	c3                   	ret    

00801e7d <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  801e7d:	55                   	push   %ebp
  801e7e:	89 e5                	mov    %esp,%ebp
  801e80:	83 ec 48             	sub    $0x48,%esp
	//cprintf("SSSSSGEEETTT\n");
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID, sharedVarName);
  801e83:	83 ec 08             	sub    $0x8,%esp
  801e86:	ff 75 0c             	pushl  0xc(%ebp)
  801e89:	ff 75 08             	pushl  0x8(%ebp)
  801e8c:	e8 71 04 00 00       	call   802302 <sys_getSizeOfSharedObject>
  801e91:	83 c4 10             	add    $0x10,%esp
  801e94:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (size < 0)
		return NULL;
	uint32 numb_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801e97:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801e9e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801ea1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ea4:	01 d0                	add    %edx,%eax
  801ea6:	48                   	dec    %eax
  801ea7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801eaa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ead:	ba 00 00 00 00       	mov    $0x0,%edx
  801eb2:	f7 75 e0             	divl   -0x20(%ebp)
  801eb5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801eb8:	29 d0                	sub    %edx,%eax
  801eba:	c1 e8 0c             	shr    $0xc,%eax
  801ebd:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 free_Pages_Count = 0;
  801ec0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801ec7:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
  801ece:	a1 24 50 80 00       	mov    0x805024,%eax
  801ed3:	8b 40 7c             	mov    0x7c(%eax),%eax
  801ed6:	05 00 10 00 00       	add    $0x1000,%eax
  801edb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
  801ede:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801ee3:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801ee6:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
  801ee9:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  801ef0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801ef3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801ef6:	01 d0                	add    %edx,%eax
  801ef8:	48                   	dec    %eax
  801ef9:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801efc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801eff:	ba 00 00 00 00       	mov    $0x0,%edx
  801f04:	f7 75 cc             	divl   -0x34(%ebp)
  801f07:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801f0a:	29 d0                	sub    %edx,%eax
  801f0c:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801f0f:	76 0a                	jbe    801f1b <sget+0x9e>
		return NULL;
  801f11:	b8 00 00 00 00       	mov    $0x0,%eax
  801f16:	e9 f7 00 00 00       	jmp    802012 <sget+0x195>
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801f1b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f1e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801f21:	eb 48                	jmp    801f6b <sget+0xee>
		uint32 idx = (s - current_Addr) / PAGE_SIZE;
  801f23:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f26:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801f29:	c1 e8 0c             	shr    $0xc,%eax
  801f2c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if (!markedPages[idx]) {
  801f2f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801f32:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  801f39:	85 c0                	test   %eax,%eax
  801f3b:	75 11                	jne    801f4e <sget+0xd1>
			free_Pages_Count++;
  801f3d:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801f40:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801f44:	75 16                	jne    801f5c <sget+0xdf>
				start = s;
  801f46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f49:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f4c:	eb 0e                	jmp    801f5c <sget+0xdf>
			}
		} else {
			free_Pages_Count = 0;
  801f4e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  801f55:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (free_Pages_Count == numb_Of_Pages) {
  801f5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5f:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801f62:	74 12                	je     801f76 <sget+0xf9>
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
		return NULL;
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801f64:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801f6b:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801f72:	76 af                	jbe    801f23 <sget+0xa6>
  801f74:	eb 01                	jmp    801f77 <sget+0xfa>
		} else {
			free_Pages_Count = 0;
			start = (uint32) -1;
		}
		if (free_Pages_Count == numb_Of_Pages) {
			break;
  801f76:	90                   	nop
		}
	}
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
  801f77:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801f7b:	74 08                	je     801f85 <sget+0x108>
  801f7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f80:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801f83:	74 0a                	je     801f8f <sget+0x112>
		return NULL;
  801f85:	b8 00 00 00 00       	mov    $0x0,%eax
  801f8a:	e9 83 00 00 00       	jmp    802012 <sget+0x195>
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
  801f8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f92:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801f95:	c1 e8 0c             	shr    $0xc,%eax
  801f98:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numb_Of_Pages;
  801f9b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801f9e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801fa1:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  801fa8:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801fab:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801fae:	eb 11                	jmp    801fc1 <sget+0x144>
		markedPages[k] = 1;
  801fb0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fb3:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  801fba:	01 00 00 00 
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
	pagesAllocated[startPage] = numb_Of_Pages;
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  801fbe:	ff 45 e8             	incl   -0x18(%ebp)
  801fc1:	8b 55 c0             	mov    -0x40(%ebp),%edx
  801fc4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801fc7:	01 d0                	add    %edx,%eax
  801fc9:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801fcc:	77 e2                	ja     801fb0 <sget+0x133>
		markedPages[k] = 1;
	}
	int ss = sys_getSharedObject(ownerEnvID, sharedVarName, (void*) start);
  801fce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fd1:	83 ec 04             	sub    $0x4,%esp
  801fd4:	50                   	push   %eax
  801fd5:	ff 75 0c             	pushl  0xc(%ebp)
  801fd8:	ff 75 08             	pushl  0x8(%ebp)
  801fdb:	e8 3f 03 00 00       	call   80231f <sys_getSharedObject>
  801fe0:	83 c4 10             	add    $0x10,%esp
  801fe3:	89 45 bc             	mov    %eax,-0x44(%ebp)
	if (ss >= 0) {
  801fe6:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  801fea:	78 12                	js     801ffe <sget+0x181>
		shardIDs[startPage] = ss;
  801fec:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801fef:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801ff2:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  801ff9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ffc:	eb 14                	jmp    802012 <sget+0x195>
	}
	free((void*) start);
  801ffe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802001:	83 ec 0c             	sub    $0xc,%esp
  802004:	50                   	push   %eax
  802005:	e8 d7 fb ff ff       	call   801be1 <free>
  80200a:	83 c4 10             	add    $0x10,%esp
	return NULL;
  80200d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802012:	c9                   	leave  
  802013:	c3                   	ret    

00802014 <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  802014:	55                   	push   %ebp
  802015:	89 e5                	mov    %esp,%ebp
  802017:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  80201a:	8b 55 08             	mov    0x8(%ebp),%edx
  80201d:	a1 24 50 80 00       	mov    0x805024,%eax
  802022:	8b 40 7c             	mov    0x7c(%eax),%eax
  802025:	29 c2                	sub    %eax,%edx
  802027:	89 d0                	mov    %edx,%eax
  802029:	2d 00 10 00 00       	sub    $0x1000,%eax

void sfree(void* virtual_address) {
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
  80202e:	c1 e8 0c             	shr    $0xc,%eax
  802031:	89 45 f4             	mov    %eax,-0xc(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
	int id = shardIDs[pageIdx];
  802034:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802037:	8b 04 85 40 50 88 00 	mov    0x885040(,%eax,4),%eax
  80203e:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int result = sys_freeSharedObject(id, virtual_address);
  802041:	83 ec 08             	sub    $0x8,%esp
  802044:	ff 75 08             	pushl  0x8(%ebp)
  802047:	ff 75 f0             	pushl  -0x10(%ebp)
  80204a:	e8 ef 02 00 00       	call   80233e <sys_freeSharedObject>
  80204f:	83 c4 10             	add    $0x10,%esp
  802052:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (result == 0) {
  802055:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802059:	75 0e                	jne    802069 <sfree+0x55>
		shardIDs[pageIdx] = -1;  // Reset the ID after freeing
  80205b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205e:	c7 04 85 40 50 88 00 	movl   $0xffffffff,0x885040(,%eax,4)
  802065:	ff ff ff ff 
	}

}
  802069:	90                   	nop
  80206a:	c9                   	leave  
  80206b:	c3                   	ret    

0080206c <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  80206c:	55                   	push   %ebp
  80206d:	89 e5                	mov    %esp,%ebp
  80206f:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802072:	83 ec 04             	sub    $0x4,%esp
  802075:	68 d4 45 80 00       	push   $0x8045d4
  80207a:	68 19 01 00 00       	push   $0x119
  80207f:	68 c6 45 80 00       	push   $0x8045c6
  802084:	e8 2d e7 ff ff       	call   8007b6 <_panic>

00802089 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  802089:	55                   	push   %ebp
  80208a:	89 e5                	mov    %esp,%ebp
  80208c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80208f:	83 ec 04             	sub    $0x4,%esp
  802092:	68 fa 45 80 00       	push   $0x8045fa
  802097:	68 23 01 00 00       	push   $0x123
  80209c:	68 c6 45 80 00       	push   $0x8045c6
  8020a1:	e8 10 e7 ff ff       	call   8007b6 <_panic>

008020a6 <shrink>:

}
void shrink(uint32 newSize) {
  8020a6:	55                   	push   %ebp
  8020a7:	89 e5                	mov    %esp,%ebp
  8020a9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020ac:	83 ec 04             	sub    $0x4,%esp
  8020af:	68 fa 45 80 00       	push   $0x8045fa
  8020b4:	68 27 01 00 00       	push   $0x127
  8020b9:	68 c6 45 80 00       	push   $0x8045c6
  8020be:	e8 f3 e6 ff ff       	call   8007b6 <_panic>

008020c3 <freeHeap>:

}
void freeHeap(void* virtual_address) {
  8020c3:	55                   	push   %ebp
  8020c4:	89 e5                	mov    %esp,%ebp
  8020c6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020c9:	83 ec 04             	sub    $0x4,%esp
  8020cc:	68 fa 45 80 00       	push   $0x8045fa
  8020d1:	68 2b 01 00 00       	push   $0x12b
  8020d6:	68 c6 45 80 00       	push   $0x8045c6
  8020db:	e8 d6 e6 ff ff       	call   8007b6 <_panic>

008020e0 <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  8020e0:	55                   	push   %ebp
  8020e1:	89 e5                	mov    %esp,%ebp
  8020e3:	57                   	push   %edi
  8020e4:	56                   	push   %esi
  8020e5:	53                   	push   %ebx
  8020e6:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8020e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020ef:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020f2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020f5:	8b 7d 18             	mov    0x18(%ebp),%edi
  8020f8:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8020fb:	cd 30                	int    $0x30
  8020fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  802100:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802103:	83 c4 10             	add    $0x10,%esp
  802106:	5b                   	pop    %ebx
  802107:	5e                   	pop    %esi
  802108:	5f                   	pop    %edi
  802109:	5d                   	pop    %ebp
  80210a:	c3                   	ret    

0080210b <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  80210b:	55                   	push   %ebp
  80210c:	89 e5                	mov    %esp,%ebp
  80210e:	83 ec 04             	sub    $0x4,%esp
  802111:	8b 45 10             	mov    0x10(%ebp),%eax
  802114:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  802117:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80211b:	8b 45 08             	mov    0x8(%ebp),%eax
  80211e:	6a 00                	push   $0x0
  802120:	6a 00                	push   $0x0
  802122:	52                   	push   %edx
  802123:	ff 75 0c             	pushl  0xc(%ebp)
  802126:	50                   	push   %eax
  802127:	6a 00                	push   $0x0
  802129:	e8 b2 ff ff ff       	call   8020e0 <syscall>
  80212e:	83 c4 18             	add    $0x18,%esp
}
  802131:	90                   	nop
  802132:	c9                   	leave  
  802133:	c3                   	ret    

00802134 <sys_cgetc>:

int sys_cgetc(void) {
  802134:	55                   	push   %ebp
  802135:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802137:	6a 00                	push   $0x0
  802139:	6a 00                	push   $0x0
  80213b:	6a 00                	push   $0x0
  80213d:	6a 00                	push   $0x0
  80213f:	6a 00                	push   $0x0
  802141:	6a 02                	push   $0x2
  802143:	e8 98 ff ff ff       	call   8020e0 <syscall>
  802148:	83 c4 18             	add    $0x18,%esp
}
  80214b:	c9                   	leave  
  80214c:	c3                   	ret    

0080214d <sys_lock_cons>:

void sys_lock_cons(void) {
  80214d:	55                   	push   %ebp
  80214e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802150:	6a 00                	push   $0x0
  802152:	6a 00                	push   $0x0
  802154:	6a 00                	push   $0x0
  802156:	6a 00                	push   $0x0
  802158:	6a 00                	push   $0x0
  80215a:	6a 03                	push   $0x3
  80215c:	e8 7f ff ff ff       	call   8020e0 <syscall>
  802161:	83 c4 18             	add    $0x18,%esp
}
  802164:	90                   	nop
  802165:	c9                   	leave  
  802166:	c3                   	ret    

00802167 <sys_unlock_cons>:
void sys_unlock_cons(void) {
  802167:	55                   	push   %ebp
  802168:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80216a:	6a 00                	push   $0x0
  80216c:	6a 00                	push   $0x0
  80216e:	6a 00                	push   $0x0
  802170:	6a 00                	push   $0x0
  802172:	6a 00                	push   $0x0
  802174:	6a 04                	push   $0x4
  802176:	e8 65 ff ff ff       	call   8020e0 <syscall>
  80217b:	83 c4 18             	add    $0x18,%esp
}
  80217e:	90                   	nop
  80217f:	c9                   	leave  
  802180:	c3                   	ret    

00802181 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  802181:	55                   	push   %ebp
  802182:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  802184:	8b 55 0c             	mov    0xc(%ebp),%edx
  802187:	8b 45 08             	mov    0x8(%ebp),%eax
  80218a:	6a 00                	push   $0x0
  80218c:	6a 00                	push   $0x0
  80218e:	6a 00                	push   $0x0
  802190:	52                   	push   %edx
  802191:	50                   	push   %eax
  802192:	6a 08                	push   $0x8
  802194:	e8 47 ff ff ff       	call   8020e0 <syscall>
  802199:	83 c4 18             	add    $0x18,%esp
}
  80219c:	c9                   	leave  
  80219d:	c3                   	ret    

0080219e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  80219e:	55                   	push   %ebp
  80219f:	89 e5                	mov    %esp,%ebp
  8021a1:	56                   	push   %esi
  8021a2:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  8021a3:	8b 75 18             	mov    0x18(%ebp),%esi
  8021a6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021a9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021af:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b2:	56                   	push   %esi
  8021b3:	53                   	push   %ebx
  8021b4:	51                   	push   %ecx
  8021b5:	52                   	push   %edx
  8021b6:	50                   	push   %eax
  8021b7:	6a 09                	push   $0x9
  8021b9:	e8 22 ff ff ff       	call   8020e0 <syscall>
  8021be:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  8021c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021c4:	5b                   	pop    %ebx
  8021c5:	5e                   	pop    %esi
  8021c6:	5d                   	pop    %ebp
  8021c7:	c3                   	ret    

008021c8 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  8021c8:	55                   	push   %ebp
  8021c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8021cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d1:	6a 00                	push   $0x0
  8021d3:	6a 00                	push   $0x0
  8021d5:	6a 00                	push   $0x0
  8021d7:	52                   	push   %edx
  8021d8:	50                   	push   %eax
  8021d9:	6a 0a                	push   $0xa
  8021db:	e8 00 ff ff ff       	call   8020e0 <syscall>
  8021e0:	83 c4 18             	add    $0x18,%esp
}
  8021e3:	c9                   	leave  
  8021e4:	c3                   	ret    

008021e5 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  8021e5:	55                   	push   %ebp
  8021e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  8021e8:	6a 00                	push   $0x0
  8021ea:	6a 00                	push   $0x0
  8021ec:	6a 00                	push   $0x0
  8021ee:	ff 75 0c             	pushl  0xc(%ebp)
  8021f1:	ff 75 08             	pushl  0x8(%ebp)
  8021f4:	6a 0b                	push   $0xb
  8021f6:	e8 e5 fe ff ff       	call   8020e0 <syscall>
  8021fb:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  8021fe:	c9                   	leave  
  8021ff:	c3                   	ret    

00802200 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  802200:	55                   	push   %ebp
  802201:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802203:	6a 00                	push   $0x0
  802205:	6a 00                	push   $0x0
  802207:	6a 00                	push   $0x0
  802209:	6a 00                	push   $0x0
  80220b:	6a 00                	push   $0x0
  80220d:	6a 0c                	push   $0xc
  80220f:	e8 cc fe ff ff       	call   8020e0 <syscall>
  802214:	83 c4 18             	add    $0x18,%esp
}
  802217:	c9                   	leave  
  802218:	c3                   	ret    

00802219 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  802219:	55                   	push   %ebp
  80221a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80221c:	6a 00                	push   $0x0
  80221e:	6a 00                	push   $0x0
  802220:	6a 00                	push   $0x0
  802222:	6a 00                	push   $0x0
  802224:	6a 00                	push   $0x0
  802226:	6a 0d                	push   $0xd
  802228:	e8 b3 fe ff ff       	call   8020e0 <syscall>
  80222d:	83 c4 18             	add    $0x18,%esp
}
  802230:	c9                   	leave  
  802231:	c3                   	ret    

00802232 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  802232:	55                   	push   %ebp
  802233:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802235:	6a 00                	push   $0x0
  802237:	6a 00                	push   $0x0
  802239:	6a 00                	push   $0x0
  80223b:	6a 00                	push   $0x0
  80223d:	6a 00                	push   $0x0
  80223f:	6a 0e                	push   $0xe
  802241:	e8 9a fe ff ff       	call   8020e0 <syscall>
  802246:	83 c4 18             	add    $0x18,%esp
}
  802249:	c9                   	leave  
  80224a:	c3                   	ret    

0080224b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  80224b:	55                   	push   %ebp
  80224c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  80224e:	6a 00                	push   $0x0
  802250:	6a 00                	push   $0x0
  802252:	6a 00                	push   $0x0
  802254:	6a 00                	push   $0x0
  802256:	6a 00                	push   $0x0
  802258:	6a 0f                	push   $0xf
  80225a:	e8 81 fe ff ff       	call   8020e0 <syscall>
  80225f:	83 c4 18             	add    $0x18,%esp
}
  802262:	c9                   	leave  
  802263:	c3                   	ret    

00802264 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  802264:	55                   	push   %ebp
  802265:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  802267:	6a 00                	push   $0x0
  802269:	6a 00                	push   $0x0
  80226b:	6a 00                	push   $0x0
  80226d:	6a 00                	push   $0x0
  80226f:	ff 75 08             	pushl  0x8(%ebp)
  802272:	6a 10                	push   $0x10
  802274:	e8 67 fe ff ff       	call   8020e0 <syscall>
  802279:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  80227c:	c9                   	leave  
  80227d:	c3                   	ret    

0080227e <sys_scarce_memory>:

void sys_scarce_memory() {
  80227e:	55                   	push   %ebp
  80227f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  802281:	6a 00                	push   $0x0
  802283:	6a 00                	push   $0x0
  802285:	6a 00                	push   $0x0
  802287:	6a 00                	push   $0x0
  802289:	6a 00                	push   $0x0
  80228b:	6a 11                	push   $0x11
  80228d:	e8 4e fe ff ff       	call   8020e0 <syscall>
  802292:	83 c4 18             	add    $0x18,%esp
}
  802295:	90                   	nop
  802296:	c9                   	leave  
  802297:	c3                   	ret    

00802298 <sys_cputc>:

void sys_cputc(const char c) {
  802298:	55                   	push   %ebp
  802299:	89 e5                	mov    %esp,%ebp
  80229b:	83 ec 04             	sub    $0x4,%esp
  80229e:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8022a4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8022a8:	6a 00                	push   $0x0
  8022aa:	6a 00                	push   $0x0
  8022ac:	6a 00                	push   $0x0
  8022ae:	6a 00                	push   $0x0
  8022b0:	50                   	push   %eax
  8022b1:	6a 01                	push   $0x1
  8022b3:	e8 28 fe ff ff       	call   8020e0 <syscall>
  8022b8:	83 c4 18             	add    $0x18,%esp
}
  8022bb:	90                   	nop
  8022bc:	c9                   	leave  
  8022bd:	c3                   	ret    

008022be <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  8022be:	55                   	push   %ebp
  8022bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  8022c1:	6a 00                	push   $0x0
  8022c3:	6a 00                	push   $0x0
  8022c5:	6a 00                	push   $0x0
  8022c7:	6a 00                	push   $0x0
  8022c9:	6a 00                	push   $0x0
  8022cb:	6a 14                	push   $0x14
  8022cd:	e8 0e fe ff ff       	call   8020e0 <syscall>
  8022d2:	83 c4 18             	add    $0x18,%esp
}
  8022d5:	90                   	nop
  8022d6:	c9                   	leave  
  8022d7:	c3                   	ret    

008022d8 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  8022d8:	55                   	push   %ebp
  8022d9:	89 e5                	mov    %esp,%ebp
  8022db:	83 ec 04             	sub    $0x4,%esp
  8022de:	8b 45 10             	mov    0x10(%ebp),%eax
  8022e1:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  8022e4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8022e7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8022eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ee:	6a 00                	push   $0x0
  8022f0:	51                   	push   %ecx
  8022f1:	52                   	push   %edx
  8022f2:	ff 75 0c             	pushl  0xc(%ebp)
  8022f5:	50                   	push   %eax
  8022f6:	6a 15                	push   $0x15
  8022f8:	e8 e3 fd ff ff       	call   8020e0 <syscall>
  8022fd:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  802300:	c9                   	leave  
  802301:	c3                   	ret    

00802302 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  802302:	55                   	push   %ebp
  802303:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  802305:	8b 55 0c             	mov    0xc(%ebp),%edx
  802308:	8b 45 08             	mov    0x8(%ebp),%eax
  80230b:	6a 00                	push   $0x0
  80230d:	6a 00                	push   $0x0
  80230f:	6a 00                	push   $0x0
  802311:	52                   	push   %edx
  802312:	50                   	push   %eax
  802313:	6a 16                	push   $0x16
  802315:	e8 c6 fd ff ff       	call   8020e0 <syscall>
  80231a:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  80231d:	c9                   	leave  
  80231e:	c3                   	ret    

0080231f <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  80231f:	55                   	push   %ebp
  802320:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  802322:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802325:	8b 55 0c             	mov    0xc(%ebp),%edx
  802328:	8b 45 08             	mov    0x8(%ebp),%eax
  80232b:	6a 00                	push   $0x0
  80232d:	6a 00                	push   $0x0
  80232f:	51                   	push   %ecx
  802330:	52                   	push   %edx
  802331:	50                   	push   %eax
  802332:	6a 17                	push   $0x17
  802334:	e8 a7 fd ff ff       	call   8020e0 <syscall>
  802339:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  80233c:	c9                   	leave  
  80233d:	c3                   	ret    

0080233e <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  80233e:	55                   	push   %ebp
  80233f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  802341:	8b 55 0c             	mov    0xc(%ebp),%edx
  802344:	8b 45 08             	mov    0x8(%ebp),%eax
  802347:	6a 00                	push   $0x0
  802349:	6a 00                	push   $0x0
  80234b:	6a 00                	push   $0x0
  80234d:	52                   	push   %edx
  80234e:	50                   	push   %eax
  80234f:	6a 18                	push   $0x18
  802351:	e8 8a fd ff ff       	call   8020e0 <syscall>
  802356:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  802359:	c9                   	leave  
  80235a:	c3                   	ret    

0080235b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  80235b:	55                   	push   %ebp
  80235c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  80235e:	8b 45 08             	mov    0x8(%ebp),%eax
  802361:	6a 00                	push   $0x0
  802363:	ff 75 14             	pushl  0x14(%ebp)
  802366:	ff 75 10             	pushl  0x10(%ebp)
  802369:	ff 75 0c             	pushl  0xc(%ebp)
  80236c:	50                   	push   %eax
  80236d:	6a 19                	push   $0x19
  80236f:	e8 6c fd ff ff       	call   8020e0 <syscall>
  802374:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  802377:	c9                   	leave  
  802378:	c3                   	ret    

00802379 <sys_run_env>:

void sys_run_env(int32 envId) {
  802379:	55                   	push   %ebp
  80237a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  80237c:	8b 45 08             	mov    0x8(%ebp),%eax
  80237f:	6a 00                	push   $0x0
  802381:	6a 00                	push   $0x0
  802383:	6a 00                	push   $0x0
  802385:	6a 00                	push   $0x0
  802387:	50                   	push   %eax
  802388:	6a 1a                	push   $0x1a
  80238a:	e8 51 fd ff ff       	call   8020e0 <syscall>
  80238f:	83 c4 18             	add    $0x18,%esp
}
  802392:	90                   	nop
  802393:	c9                   	leave  
  802394:	c3                   	ret    

00802395 <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  802395:	55                   	push   %ebp
  802396:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802398:	8b 45 08             	mov    0x8(%ebp),%eax
  80239b:	6a 00                	push   $0x0
  80239d:	6a 00                	push   $0x0
  80239f:	6a 00                	push   $0x0
  8023a1:	6a 00                	push   $0x0
  8023a3:	50                   	push   %eax
  8023a4:	6a 1b                	push   $0x1b
  8023a6:	e8 35 fd ff ff       	call   8020e0 <syscall>
  8023ab:	83 c4 18             	add    $0x18,%esp
}
  8023ae:	c9                   	leave  
  8023af:	c3                   	ret    

008023b0 <sys_getenvid>:

int32 sys_getenvid(void) {
  8023b0:	55                   	push   %ebp
  8023b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8023b3:	6a 00                	push   $0x0
  8023b5:	6a 00                	push   $0x0
  8023b7:	6a 00                	push   $0x0
  8023b9:	6a 00                	push   $0x0
  8023bb:	6a 00                	push   $0x0
  8023bd:	6a 05                	push   $0x5
  8023bf:	e8 1c fd ff ff       	call   8020e0 <syscall>
  8023c4:	83 c4 18             	add    $0x18,%esp
}
  8023c7:	c9                   	leave  
  8023c8:	c3                   	ret    

008023c9 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  8023c9:	55                   	push   %ebp
  8023ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8023cc:	6a 00                	push   $0x0
  8023ce:	6a 00                	push   $0x0
  8023d0:	6a 00                	push   $0x0
  8023d2:	6a 00                	push   $0x0
  8023d4:	6a 00                	push   $0x0
  8023d6:	6a 06                	push   $0x6
  8023d8:	e8 03 fd ff ff       	call   8020e0 <syscall>
  8023dd:	83 c4 18             	add    $0x18,%esp
}
  8023e0:	c9                   	leave  
  8023e1:	c3                   	ret    

008023e2 <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  8023e2:	55                   	push   %ebp
  8023e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8023e5:	6a 00                	push   $0x0
  8023e7:	6a 00                	push   $0x0
  8023e9:	6a 00                	push   $0x0
  8023eb:	6a 00                	push   $0x0
  8023ed:	6a 00                	push   $0x0
  8023ef:	6a 07                	push   $0x7
  8023f1:	e8 ea fc ff ff       	call   8020e0 <syscall>
  8023f6:	83 c4 18             	add    $0x18,%esp
}
  8023f9:	c9                   	leave  
  8023fa:	c3                   	ret    

008023fb <sys_exit_env>:

void sys_exit_env(void) {
  8023fb:	55                   	push   %ebp
  8023fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8023fe:	6a 00                	push   $0x0
  802400:	6a 00                	push   $0x0
  802402:	6a 00                	push   $0x0
  802404:	6a 00                	push   $0x0
  802406:	6a 00                	push   $0x0
  802408:	6a 1c                	push   $0x1c
  80240a:	e8 d1 fc ff ff       	call   8020e0 <syscall>
  80240f:	83 c4 18             	add    $0x18,%esp
}
  802412:	90                   	nop
  802413:	c9                   	leave  
  802414:	c3                   	ret    

00802415 <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  802415:	55                   	push   %ebp
  802416:	89 e5                	mov    %esp,%ebp
  802418:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  80241b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80241e:	8d 50 04             	lea    0x4(%eax),%edx
  802421:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802424:	6a 00                	push   $0x0
  802426:	6a 00                	push   $0x0
  802428:	6a 00                	push   $0x0
  80242a:	52                   	push   %edx
  80242b:	50                   	push   %eax
  80242c:	6a 1d                	push   $0x1d
  80242e:	e8 ad fc ff ff       	call   8020e0 <syscall>
  802433:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  802436:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802439:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80243c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80243f:	89 01                	mov    %eax,(%ecx)
  802441:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802444:	8b 45 08             	mov    0x8(%ebp),%eax
  802447:	c9                   	leave  
  802448:	c2 04 00             	ret    $0x4

0080244b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  80244b:	55                   	push   %ebp
  80244c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  80244e:	6a 00                	push   $0x0
  802450:	6a 00                	push   $0x0
  802452:	ff 75 10             	pushl  0x10(%ebp)
  802455:	ff 75 0c             	pushl  0xc(%ebp)
  802458:	ff 75 08             	pushl  0x8(%ebp)
  80245b:	6a 13                	push   $0x13
  80245d:	e8 7e fc ff ff       	call   8020e0 <syscall>
  802462:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  802465:	90                   	nop
}
  802466:	c9                   	leave  
  802467:	c3                   	ret    

00802468 <sys_rcr2>:
uint32 sys_rcr2() {
  802468:	55                   	push   %ebp
  802469:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80246b:	6a 00                	push   $0x0
  80246d:	6a 00                	push   $0x0
  80246f:	6a 00                	push   $0x0
  802471:	6a 00                	push   $0x0
  802473:	6a 00                	push   $0x0
  802475:	6a 1e                	push   $0x1e
  802477:	e8 64 fc ff ff       	call   8020e0 <syscall>
  80247c:	83 c4 18             	add    $0x18,%esp
}
  80247f:	c9                   	leave  
  802480:	c3                   	ret    

00802481 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  802481:	55                   	push   %ebp
  802482:	89 e5                	mov    %esp,%ebp
  802484:	83 ec 04             	sub    $0x4,%esp
  802487:	8b 45 08             	mov    0x8(%ebp),%eax
  80248a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80248d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802491:	6a 00                	push   $0x0
  802493:	6a 00                	push   $0x0
  802495:	6a 00                	push   $0x0
  802497:	6a 00                	push   $0x0
  802499:	50                   	push   %eax
  80249a:	6a 1f                	push   $0x1f
  80249c:	e8 3f fc ff ff       	call   8020e0 <syscall>
  8024a1:	83 c4 18             	add    $0x18,%esp
	return;
  8024a4:	90                   	nop
}
  8024a5:	c9                   	leave  
  8024a6:	c3                   	ret    

008024a7 <rsttst>:
void rsttst() {
  8024a7:	55                   	push   %ebp
  8024a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8024aa:	6a 00                	push   $0x0
  8024ac:	6a 00                	push   $0x0
  8024ae:	6a 00                	push   $0x0
  8024b0:	6a 00                	push   $0x0
  8024b2:	6a 00                	push   $0x0
  8024b4:	6a 21                	push   $0x21
  8024b6:	e8 25 fc ff ff       	call   8020e0 <syscall>
  8024bb:	83 c4 18             	add    $0x18,%esp
	return;
  8024be:	90                   	nop
}
  8024bf:	c9                   	leave  
  8024c0:	c3                   	ret    

008024c1 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  8024c1:	55                   	push   %ebp
  8024c2:	89 e5                	mov    %esp,%ebp
  8024c4:	83 ec 04             	sub    $0x4,%esp
  8024c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8024ca:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8024cd:	8b 55 18             	mov    0x18(%ebp),%edx
  8024d0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8024d4:	52                   	push   %edx
  8024d5:	50                   	push   %eax
  8024d6:	ff 75 10             	pushl  0x10(%ebp)
  8024d9:	ff 75 0c             	pushl  0xc(%ebp)
  8024dc:	ff 75 08             	pushl  0x8(%ebp)
  8024df:	6a 20                	push   $0x20
  8024e1:	e8 fa fb ff ff       	call   8020e0 <syscall>
  8024e6:	83 c4 18             	add    $0x18,%esp
	return;
  8024e9:	90                   	nop
}
  8024ea:	c9                   	leave  
  8024eb:	c3                   	ret    

008024ec <chktst>:
void chktst(uint32 n) {
  8024ec:	55                   	push   %ebp
  8024ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8024ef:	6a 00                	push   $0x0
  8024f1:	6a 00                	push   $0x0
  8024f3:	6a 00                	push   $0x0
  8024f5:	6a 00                	push   $0x0
  8024f7:	ff 75 08             	pushl  0x8(%ebp)
  8024fa:	6a 22                	push   $0x22
  8024fc:	e8 df fb ff ff       	call   8020e0 <syscall>
  802501:	83 c4 18             	add    $0x18,%esp
	return;
  802504:	90                   	nop
}
  802505:	c9                   	leave  
  802506:	c3                   	ret    

00802507 <inctst>:

void inctst() {
  802507:	55                   	push   %ebp
  802508:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80250a:	6a 00                	push   $0x0
  80250c:	6a 00                	push   $0x0
  80250e:	6a 00                	push   $0x0
  802510:	6a 00                	push   $0x0
  802512:	6a 00                	push   $0x0
  802514:	6a 23                	push   $0x23
  802516:	e8 c5 fb ff ff       	call   8020e0 <syscall>
  80251b:	83 c4 18             	add    $0x18,%esp
	return;
  80251e:	90                   	nop
}
  80251f:	c9                   	leave  
  802520:	c3                   	ret    

00802521 <gettst>:
uint32 gettst() {
  802521:	55                   	push   %ebp
  802522:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802524:	6a 00                	push   $0x0
  802526:	6a 00                	push   $0x0
  802528:	6a 00                	push   $0x0
  80252a:	6a 00                	push   $0x0
  80252c:	6a 00                	push   $0x0
  80252e:	6a 24                	push   $0x24
  802530:	e8 ab fb ff ff       	call   8020e0 <syscall>
  802535:	83 c4 18             	add    $0x18,%esp
}
  802538:	c9                   	leave  
  802539:	c3                   	ret    

0080253a <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  80253a:	55                   	push   %ebp
  80253b:	89 e5                	mov    %esp,%ebp
  80253d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802540:	6a 00                	push   $0x0
  802542:	6a 00                	push   $0x0
  802544:	6a 00                	push   $0x0
  802546:	6a 00                	push   $0x0
  802548:	6a 00                	push   $0x0
  80254a:	6a 25                	push   $0x25
  80254c:	e8 8f fb ff ff       	call   8020e0 <syscall>
  802551:	83 c4 18             	add    $0x18,%esp
  802554:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802557:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80255b:	75 07                	jne    802564 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80255d:	b8 01 00 00 00       	mov    $0x1,%eax
  802562:	eb 05                	jmp    802569 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802564:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802569:	c9                   	leave  
  80256a:	c3                   	ret    

0080256b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  80256b:	55                   	push   %ebp
  80256c:	89 e5                	mov    %esp,%ebp
  80256e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802571:	6a 00                	push   $0x0
  802573:	6a 00                	push   $0x0
  802575:	6a 00                	push   $0x0
  802577:	6a 00                	push   $0x0
  802579:	6a 00                	push   $0x0
  80257b:	6a 25                	push   $0x25
  80257d:	e8 5e fb ff ff       	call   8020e0 <syscall>
  802582:	83 c4 18             	add    $0x18,%esp
  802585:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802588:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80258c:	75 07                	jne    802595 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80258e:	b8 01 00 00 00       	mov    $0x1,%eax
  802593:	eb 05                	jmp    80259a <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802595:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80259a:	c9                   	leave  
  80259b:	c3                   	ret    

0080259c <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  80259c:	55                   	push   %ebp
  80259d:	89 e5                	mov    %esp,%ebp
  80259f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025a2:	6a 00                	push   $0x0
  8025a4:	6a 00                	push   $0x0
  8025a6:	6a 00                	push   $0x0
  8025a8:	6a 00                	push   $0x0
  8025aa:	6a 00                	push   $0x0
  8025ac:	6a 25                	push   $0x25
  8025ae:	e8 2d fb ff ff       	call   8020e0 <syscall>
  8025b3:	83 c4 18             	add    $0x18,%esp
  8025b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8025b9:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8025bd:	75 07                	jne    8025c6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8025bf:	b8 01 00 00 00       	mov    $0x1,%eax
  8025c4:	eb 05                	jmp    8025cb <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8025c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025cb:	c9                   	leave  
  8025cc:	c3                   	ret    

008025cd <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  8025cd:	55                   	push   %ebp
  8025ce:	89 e5                	mov    %esp,%ebp
  8025d0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025d3:	6a 00                	push   $0x0
  8025d5:	6a 00                	push   $0x0
  8025d7:	6a 00                	push   $0x0
  8025d9:	6a 00                	push   $0x0
  8025db:	6a 00                	push   $0x0
  8025dd:	6a 25                	push   $0x25
  8025df:	e8 fc fa ff ff       	call   8020e0 <syscall>
  8025e4:	83 c4 18             	add    $0x18,%esp
  8025e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8025ea:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8025ee:	75 07                	jne    8025f7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8025f0:	b8 01 00 00 00       	mov    $0x1,%eax
  8025f5:	eb 05                	jmp    8025fc <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8025f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025fc:	c9                   	leave  
  8025fd:	c3                   	ret    

008025fe <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  8025fe:	55                   	push   %ebp
  8025ff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802601:	6a 00                	push   $0x0
  802603:	6a 00                	push   $0x0
  802605:	6a 00                	push   $0x0
  802607:	6a 00                	push   $0x0
  802609:	ff 75 08             	pushl  0x8(%ebp)
  80260c:	6a 26                	push   $0x26
  80260e:	e8 cd fa ff ff       	call   8020e0 <syscall>
  802613:	83 c4 18             	add    $0x18,%esp
	return;
  802616:	90                   	nop
}
  802617:	c9                   	leave  
  802618:	c3                   	ret    

00802619 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  802619:	55                   	push   %ebp
  80261a:	89 e5                	mov    %esp,%ebp
  80261c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  80261d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802620:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802623:	8b 55 0c             	mov    0xc(%ebp),%edx
  802626:	8b 45 08             	mov    0x8(%ebp),%eax
  802629:	6a 00                	push   $0x0
  80262b:	53                   	push   %ebx
  80262c:	51                   	push   %ecx
  80262d:	52                   	push   %edx
  80262e:	50                   	push   %eax
  80262f:	6a 27                	push   $0x27
  802631:	e8 aa fa ff ff       	call   8020e0 <syscall>
  802636:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  802639:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80263c:	c9                   	leave  
  80263d:	c3                   	ret    

0080263e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  80263e:	55                   	push   %ebp
  80263f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  802641:	8b 55 0c             	mov    0xc(%ebp),%edx
  802644:	8b 45 08             	mov    0x8(%ebp),%eax
  802647:	6a 00                	push   $0x0
  802649:	6a 00                	push   $0x0
  80264b:	6a 00                	push   $0x0
  80264d:	52                   	push   %edx
  80264e:	50                   	push   %eax
  80264f:	6a 28                	push   $0x28
  802651:	e8 8a fa ff ff       	call   8020e0 <syscall>
  802656:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  802659:	c9                   	leave  
  80265a:	c3                   	ret    

0080265b <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  80265b:	55                   	push   %ebp
  80265c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  80265e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802661:	8b 55 0c             	mov    0xc(%ebp),%edx
  802664:	8b 45 08             	mov    0x8(%ebp),%eax
  802667:	6a 00                	push   $0x0
  802669:	51                   	push   %ecx
  80266a:	ff 75 10             	pushl  0x10(%ebp)
  80266d:	52                   	push   %edx
  80266e:	50                   	push   %eax
  80266f:	6a 29                	push   $0x29
  802671:	e8 6a fa ff ff       	call   8020e0 <syscall>
  802676:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  802679:	c9                   	leave  
  80267a:	c3                   	ret    

0080267b <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  80267b:	55                   	push   %ebp
  80267c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80267e:	6a 00                	push   $0x0
  802680:	6a 00                	push   $0x0
  802682:	ff 75 10             	pushl  0x10(%ebp)
  802685:	ff 75 0c             	pushl  0xc(%ebp)
  802688:	ff 75 08             	pushl  0x8(%ebp)
  80268b:	6a 12                	push   $0x12
  80268d:	e8 4e fa ff ff       	call   8020e0 <syscall>
  802692:	83 c4 18             	add    $0x18,%esp
	return;
  802695:	90                   	nop
}
  802696:	c9                   	leave  
  802697:	c3                   	ret    

00802698 <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  802698:	55                   	push   %ebp
  802699:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  80269b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80269e:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a1:	6a 00                	push   $0x0
  8026a3:	6a 00                	push   $0x0
  8026a5:	6a 00                	push   $0x0
  8026a7:	52                   	push   %edx
  8026a8:	50                   	push   %eax
  8026a9:	6a 2a                	push   $0x2a
  8026ab:	e8 30 fa ff ff       	call   8020e0 <syscall>
  8026b0:	83 c4 18             	add    $0x18,%esp
	return;
  8026b3:	90                   	nop
}
  8026b4:	c9                   	leave  
  8026b5:	c3                   	ret    

008026b6 <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  8026b6:	55                   	push   %ebp
  8026b7:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  8026b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026bc:	6a 00                	push   $0x0
  8026be:	6a 00                	push   $0x0
  8026c0:	6a 00                	push   $0x0
  8026c2:	6a 00                	push   $0x0
  8026c4:	50                   	push   %eax
  8026c5:	6a 2b                	push   $0x2b
  8026c7:	e8 14 fa ff ff       	call   8020e0 <syscall>
  8026cc:	83 c4 18             	add    $0x18,%esp
}
  8026cf:	c9                   	leave  
  8026d0:	c3                   	ret    

008026d1 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  8026d1:	55                   	push   %ebp
  8026d2:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8026d4:	6a 00                	push   $0x0
  8026d6:	6a 00                	push   $0x0
  8026d8:	6a 00                	push   $0x0
  8026da:	ff 75 0c             	pushl  0xc(%ebp)
  8026dd:	ff 75 08             	pushl  0x8(%ebp)
  8026e0:	6a 2c                	push   $0x2c
  8026e2:	e8 f9 f9 ff ff       	call   8020e0 <syscall>
  8026e7:	83 c4 18             	add    $0x18,%esp
	return;
  8026ea:	90                   	nop
}
  8026eb:	c9                   	leave  
  8026ec:	c3                   	ret    

008026ed <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  8026ed:	55                   	push   %ebp
  8026ee:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8026f0:	6a 00                	push   $0x0
  8026f2:	6a 00                	push   $0x0
  8026f4:	6a 00                	push   $0x0
  8026f6:	ff 75 0c             	pushl  0xc(%ebp)
  8026f9:	ff 75 08             	pushl  0x8(%ebp)
  8026fc:	6a 2d                	push   $0x2d
  8026fe:	e8 dd f9 ff ff       	call   8020e0 <syscall>
  802703:	83 c4 18             	add    $0x18,%esp
	return;
  802706:	90                   	nop
}
  802707:	c9                   	leave  
  802708:	c3                   	ret    

00802709 <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  802709:	55                   	push   %ebp
  80270a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  80270c:	8b 45 08             	mov    0x8(%ebp),%eax
  80270f:	6a 00                	push   $0x0
  802711:	6a 00                	push   $0x0
  802713:	6a 00                	push   $0x0
  802715:	6a 00                	push   $0x0
  802717:	50                   	push   %eax
  802718:	6a 2f                	push   $0x2f
  80271a:	e8 c1 f9 ff ff       	call   8020e0 <syscall>
  80271f:	83 c4 18             	add    $0x18,%esp
	return;
  802722:	90                   	nop
}
  802723:	c9                   	leave  
  802724:	c3                   	ret    

00802725 <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  802725:	55                   	push   %ebp
  802726:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  802728:	8b 55 0c             	mov    0xc(%ebp),%edx
  80272b:	8b 45 08             	mov    0x8(%ebp),%eax
  80272e:	6a 00                	push   $0x0
  802730:	6a 00                	push   $0x0
  802732:	6a 00                	push   $0x0
  802734:	52                   	push   %edx
  802735:	50                   	push   %eax
  802736:	6a 30                	push   $0x30
  802738:	e8 a3 f9 ff ff       	call   8020e0 <syscall>
  80273d:	83 c4 18             	add    $0x18,%esp
	return;
  802740:	90                   	nop
}
  802741:	c9                   	leave  
  802742:	c3                   	ret    

00802743 <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  802743:	55                   	push   %ebp
  802744:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  802746:	8b 45 08             	mov    0x8(%ebp),%eax
  802749:	6a 00                	push   $0x0
  80274b:	6a 00                	push   $0x0
  80274d:	6a 00                	push   $0x0
  80274f:	6a 00                	push   $0x0
  802751:	50                   	push   %eax
  802752:	6a 31                	push   $0x31
  802754:	e8 87 f9 ff ff       	call   8020e0 <syscall>
  802759:	83 c4 18             	add    $0x18,%esp
	return;
  80275c:	90                   	nop
}
  80275d:	c9                   	leave  
  80275e:	c3                   	ret    

0080275f <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  80275f:	55                   	push   %ebp
  802760:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  802762:	8b 55 0c             	mov    0xc(%ebp),%edx
  802765:	8b 45 08             	mov    0x8(%ebp),%eax
  802768:	6a 00                	push   $0x0
  80276a:	6a 00                	push   $0x0
  80276c:	6a 00                	push   $0x0
  80276e:	52                   	push   %edx
  80276f:	50                   	push   %eax
  802770:	6a 2e                	push   $0x2e
  802772:	e8 69 f9 ff ff       	call   8020e0 <syscall>
  802777:	83 c4 18             	add    $0x18,%esp
    return;
  80277a:	90                   	nop
}
  80277b:	c9                   	leave  
  80277c:	c3                   	ret    

0080277d <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  80277d:	55                   	push   %ebp
  80277e:	89 e5                	mov    %esp,%ebp
  802780:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802783:	8b 45 08             	mov    0x8(%ebp),%eax
  802786:	83 e8 04             	sub    $0x4,%eax
  802789:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  80278c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80278f:	8b 00                	mov    (%eax),%eax
  802791:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802794:	c9                   	leave  
  802795:	c3                   	ret    

00802796 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802796:	55                   	push   %ebp
  802797:	89 e5                	mov    %esp,%ebp
  802799:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80279c:	8b 45 08             	mov    0x8(%ebp),%eax
  80279f:	83 e8 04             	sub    $0x4,%eax
  8027a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  8027a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027a8:	8b 00                	mov    (%eax),%eax
  8027aa:	83 e0 01             	and    $0x1,%eax
  8027ad:	85 c0                	test   %eax,%eax
  8027af:	0f 94 c0             	sete   %al
}
  8027b2:	c9                   	leave  
  8027b3:	c3                   	ret    

008027b4 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8027b4:	55                   	push   %ebp
  8027b5:	89 e5                	mov    %esp,%ebp
  8027b7:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8027ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8027c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027c4:	83 f8 02             	cmp    $0x2,%eax
  8027c7:	74 2b                	je     8027f4 <alloc_block+0x40>
  8027c9:	83 f8 02             	cmp    $0x2,%eax
  8027cc:	7f 07                	jg     8027d5 <alloc_block+0x21>
  8027ce:	83 f8 01             	cmp    $0x1,%eax
  8027d1:	74 0e                	je     8027e1 <alloc_block+0x2d>
  8027d3:	eb 58                	jmp    80282d <alloc_block+0x79>
  8027d5:	83 f8 03             	cmp    $0x3,%eax
  8027d8:	74 2d                	je     802807 <alloc_block+0x53>
  8027da:	83 f8 04             	cmp    $0x4,%eax
  8027dd:	74 3b                	je     80281a <alloc_block+0x66>
  8027df:	eb 4c                	jmp    80282d <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8027e1:	83 ec 0c             	sub    $0xc,%esp
  8027e4:	ff 75 08             	pushl  0x8(%ebp)
  8027e7:	e8 f7 03 00 00       	call   802be3 <alloc_block_FF>
  8027ec:	83 c4 10             	add    $0x10,%esp
  8027ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8027f2:	eb 4a                	jmp    80283e <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8027f4:	83 ec 0c             	sub    $0xc,%esp
  8027f7:	ff 75 08             	pushl  0x8(%ebp)
  8027fa:	e8 f0 11 00 00       	call   8039ef <alloc_block_NF>
  8027ff:	83 c4 10             	add    $0x10,%esp
  802802:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802805:	eb 37                	jmp    80283e <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802807:	83 ec 0c             	sub    $0xc,%esp
  80280a:	ff 75 08             	pushl  0x8(%ebp)
  80280d:	e8 08 08 00 00       	call   80301a <alloc_block_BF>
  802812:	83 c4 10             	add    $0x10,%esp
  802815:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802818:	eb 24                	jmp    80283e <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  80281a:	83 ec 0c             	sub    $0xc,%esp
  80281d:	ff 75 08             	pushl  0x8(%ebp)
  802820:	e8 ad 11 00 00       	call   8039d2 <alloc_block_WF>
  802825:	83 c4 10             	add    $0x10,%esp
  802828:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80282b:	eb 11                	jmp    80283e <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  80282d:	83 ec 0c             	sub    $0xc,%esp
  802830:	68 0c 46 80 00       	push   $0x80460c
  802835:	e8 39 e2 ff ff       	call   800a73 <cprintf>
  80283a:	83 c4 10             	add    $0x10,%esp
		break;
  80283d:	90                   	nop
	}
	return va;
  80283e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802841:	c9                   	leave  
  802842:	c3                   	ret    

00802843 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802843:	55                   	push   %ebp
  802844:	89 e5                	mov    %esp,%ebp
  802846:	53                   	push   %ebx
  802847:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  80284a:	83 ec 0c             	sub    $0xc,%esp
  80284d:	68 2c 46 80 00       	push   $0x80462c
  802852:	e8 1c e2 ff ff       	call   800a73 <cprintf>
  802857:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  80285a:	83 ec 0c             	sub    $0xc,%esp
  80285d:	68 57 46 80 00       	push   $0x804657
  802862:	e8 0c e2 ff ff       	call   800a73 <cprintf>
  802867:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  80286a:	8b 45 08             	mov    0x8(%ebp),%eax
  80286d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802870:	eb 37                	jmp    8028a9 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802872:	83 ec 0c             	sub    $0xc,%esp
  802875:	ff 75 f4             	pushl  -0xc(%ebp)
  802878:	e8 19 ff ff ff       	call   802796 <is_free_block>
  80287d:	83 c4 10             	add    $0x10,%esp
  802880:	0f be d8             	movsbl %al,%ebx
  802883:	83 ec 0c             	sub    $0xc,%esp
  802886:	ff 75 f4             	pushl  -0xc(%ebp)
  802889:	e8 ef fe ff ff       	call   80277d <get_block_size>
  80288e:	83 c4 10             	add    $0x10,%esp
  802891:	83 ec 04             	sub    $0x4,%esp
  802894:	53                   	push   %ebx
  802895:	50                   	push   %eax
  802896:	68 6f 46 80 00       	push   $0x80466f
  80289b:	e8 d3 e1 ff ff       	call   800a73 <cprintf>
  8028a0:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8028a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8028a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028ad:	74 07                	je     8028b6 <print_blocks_list+0x73>
  8028af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b2:	8b 00                	mov    (%eax),%eax
  8028b4:	eb 05                	jmp    8028bb <print_blocks_list+0x78>
  8028b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8028bb:	89 45 10             	mov    %eax,0x10(%ebp)
  8028be:	8b 45 10             	mov    0x10(%ebp),%eax
  8028c1:	85 c0                	test   %eax,%eax
  8028c3:	75 ad                	jne    802872 <print_blocks_list+0x2f>
  8028c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028c9:	75 a7                	jne    802872 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8028cb:	83 ec 0c             	sub    $0xc,%esp
  8028ce:	68 2c 46 80 00       	push   $0x80462c
  8028d3:	e8 9b e1 ff ff       	call   800a73 <cprintf>
  8028d8:	83 c4 10             	add    $0x10,%esp

}
  8028db:	90                   	nop
  8028dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8028df:	c9                   	leave  
  8028e0:	c3                   	ret    

008028e1 <initialize_dynamic_allocator>:

//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8028e1:	55                   	push   %ebp
  8028e2:	89 e5                	mov    %esp,%ebp
  8028e4:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8028e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028ea:	83 e0 01             	and    $0x1,%eax
  8028ed:	85 c0                	test   %eax,%eax
  8028ef:	74 03                	je     8028f4 <initialize_dynamic_allocator+0x13>
  8028f1:	ff 45 0c             	incl   0xc(%ebp)
		if (initSizeOfAllocatedSpace == 0)
  8028f4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8028f8:	0f 84 f8 00 00 00    	je     8029f6 <initialize_dynamic_allocator+0x115>
			return ;
		is_initialized = 1;
  8028fe:	c7 05 40 50 98 00 01 	movl   $0x1,0x985040
  802905:	00 00 00 
	//TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("initialize_dynamic_allocator is not implemented yet");
	//Your Code is Here...

	if(is_initialized){
  802908:	a1 40 50 98 00       	mov    0x985040,%eax
  80290d:	85 c0                	test   %eax,%eax
  80290f:	0f 84 e2 00 00 00    	je     8029f7 <initialize_dynamic_allocator+0x116>

		// begin block with size 0 and lsb = 1 (allocated)
		uint32* beginBlock = (uint32*)daStart;
  802915:	8b 45 08             	mov    0x8(%ebp),%eax
  802918:	89 45 f4             	mov    %eax,-0xc(%ebp)
		*beginBlock = 0 | 1; // size = 0, LSB as a flag = 1
  80291b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		// end block with size 0 and lsb = 1 (allocated)
		uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);
  802924:	8b 55 08             	mov    0x8(%ebp),%edx
  802927:	8b 45 0c             	mov    0xc(%ebp),%eax
  80292a:	01 d0                	add    %edx,%eax
  80292c:	83 e8 04             	sub    $0x4,%eax
  80292f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		*endBlock = 0 | 1; // size = 0, LSB as a flag = 1
  802932:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802935:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

		// the block that between begin and end blocks
		struct BlockElement* block = (struct BlockElement*)(daStart + 8);
  80293b:	8b 45 08             	mov    0x8(%ebp),%eax
  80293e:	83 c0 08             	add    $0x8,%eax
  802941:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 blockSize = initSizeOfAllocatedSpace - 8; // subtract size of begin and end blocks
  802944:	8b 45 0c             	mov    0xc(%ebp),%eax
  802947:	83 e8 08             	sub    $0x8,%eax
  80294a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(block,blockSize,0);
  80294d:	83 ec 04             	sub    $0x4,%esp
  802950:	6a 00                	push   $0x0
  802952:	ff 75 e8             	pushl  -0x18(%ebp)
  802955:	ff 75 ec             	pushl  -0x14(%ebp)
  802958:	e8 9c 00 00 00       	call   8029f9 <set_block_data>
  80295d:	83 c4 10             	add    $0x10,%esp

		block->prev_next_info.le_next = NULL;
  802960:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802963:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block->prev_next_info.le_prev = NULL;
  802969:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80296c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

		LIST_INIT(&freeBlocksList);
  802973:	c7 05 48 50 98 00 00 	movl   $0x0,0x985048
  80297a:	00 00 00 
  80297d:	c7 05 4c 50 98 00 00 	movl   $0x0,0x98504c
  802984:	00 00 00 
  802987:	c7 05 54 50 98 00 00 	movl   $0x0,0x985054
  80298e:	00 00 00 
		LIST_INSERT_HEAD(&freeBlocksList, block);
  802991:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802995:	75 17                	jne    8029ae <initialize_dynamic_allocator+0xcd>
  802997:	83 ec 04             	sub    $0x4,%esp
  80299a:	68 88 46 80 00       	push   $0x804688
  80299f:	68 80 00 00 00       	push   $0x80
  8029a4:	68 ab 46 80 00       	push   $0x8046ab
  8029a9:	e8 08 de ff ff       	call   8007b6 <_panic>
  8029ae:	8b 15 48 50 98 00    	mov    0x985048,%edx
  8029b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029b7:	89 10                	mov    %edx,(%eax)
  8029b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029bc:	8b 00                	mov    (%eax),%eax
  8029be:	85 c0                	test   %eax,%eax
  8029c0:	74 0d                	je     8029cf <initialize_dynamic_allocator+0xee>
  8029c2:	a1 48 50 98 00       	mov    0x985048,%eax
  8029c7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029ca:	89 50 04             	mov    %edx,0x4(%eax)
  8029cd:	eb 08                	jmp    8029d7 <initialize_dynamic_allocator+0xf6>
  8029cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029d2:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8029d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029da:	a3 48 50 98 00       	mov    %eax,0x985048
  8029df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029e9:	a1 54 50 98 00       	mov    0x985054,%eax
  8029ee:	40                   	inc    %eax
  8029ef:	a3 54 50 98 00       	mov    %eax,0x985054
  8029f4:	eb 01                	jmp    8029f7 <initialize_dynamic_allocator+0x116>
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
		if (initSizeOfAllocatedSpace == 0)
			return ;
  8029f6:	90                   	nop
		block->prev_next_info.le_prev = NULL;

		LIST_INIT(&freeBlocksList);
		LIST_INSERT_HEAD(&freeBlocksList, block);
	}
}
  8029f7:	c9                   	leave  
  8029f8:	c3                   	ret    

008029f9 <set_block_data>:
//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8029f9:	55                   	push   %ebp
  8029fa:	89 e5                	mov    %esp,%ebp
  8029fc:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("set_block_data is not implemented yet");
	//Your Code is Here...

	if(totalSize % 2 != 0)
  8029ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a02:	83 e0 01             	and    $0x1,%eax
  802a05:	85 c0                	test   %eax,%eax
  802a07:	74 03                	je     802a0c <set_block_data+0x13>
	{
		totalSize++;
  802a09:	ff 45 0c             	incl   0xc(%ebp)
	}

	uint32* header = (uint32 *)((uint32*)va-1);
  802a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0f:	83 e8 04             	sub    $0x4,%eax
  802a12:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//	size => totalSize with LSB = 0		 set LSB = 1 if isAllocated
	*header = (totalSize & ~1) | (isAllocated & 1);
  802a15:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a18:	83 e0 fe             	and    $0xfffffffe,%eax
  802a1b:	89 c2                	mov    %eax,%edx
  802a1d:	8b 45 10             	mov    0x10(%ebp),%eax
  802a20:	83 e0 01             	and    $0x1,%eax
  802a23:	09 c2                	or     %eax,%edx
  802a25:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a28:	89 10                	mov    %edx,(%eax)
	uint32* footer = (uint32*) (va + totalSize - 8);
  802a2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a2d:	8d 50 f8             	lea    -0x8(%eax),%edx
  802a30:	8b 45 08             	mov    0x8(%ebp),%eax
  802a33:	01 d0                	add    %edx,%eax
  802a35:	89 45 f8             	mov    %eax,-0x8(%ebp)
	*footer = (totalSize & ~1) | (isAllocated & 1);
  802a38:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a3b:	83 e0 fe             	and    $0xfffffffe,%eax
  802a3e:	89 c2                	mov    %eax,%edx
  802a40:	8b 45 10             	mov    0x10(%ebp),%eax
  802a43:	83 e0 01             	and    $0x1,%eax
  802a46:	09 c2                	or     %eax,%edx
  802a48:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802a4b:	89 10                	mov    %edx,(%eax)
}
  802a4d:	90                   	nop
  802a4e:	c9                   	leave  
  802a4f:	c3                   	ret    

00802a50 <insert_sorted_in_freeList>:
//=========================================
void insert_sorted_in_freeList(struct BlockElement *newBlock)
{
  802a50:	55                   	push   %ebp
  802a51:	89 e5                	mov    %esp,%ebp
  802a53:	83 ec 18             	sub    $0x18,%esp
	if(LIST_EMPTY(&freeBlocksList))
  802a56:	a1 48 50 98 00       	mov    0x985048,%eax
  802a5b:	85 c0                	test   %eax,%eax
  802a5d:	75 68                	jne    802ac7 <insert_sorted_in_freeList+0x77>
	{
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
  802a5f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a63:	75 17                	jne    802a7c <insert_sorted_in_freeList+0x2c>
  802a65:	83 ec 04             	sub    $0x4,%esp
  802a68:	68 88 46 80 00       	push   $0x804688
  802a6d:	68 9d 00 00 00       	push   $0x9d
  802a72:	68 ab 46 80 00       	push   $0x8046ab
  802a77:	e8 3a dd ff ff       	call   8007b6 <_panic>
  802a7c:	8b 15 48 50 98 00    	mov    0x985048,%edx
  802a82:	8b 45 08             	mov    0x8(%ebp),%eax
  802a85:	89 10                	mov    %edx,(%eax)
  802a87:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8a:	8b 00                	mov    (%eax),%eax
  802a8c:	85 c0                	test   %eax,%eax
  802a8e:	74 0d                	je     802a9d <insert_sorted_in_freeList+0x4d>
  802a90:	a1 48 50 98 00       	mov    0x985048,%eax
  802a95:	8b 55 08             	mov    0x8(%ebp),%edx
  802a98:	89 50 04             	mov    %edx,0x4(%eax)
  802a9b:	eb 08                	jmp    802aa5 <insert_sorted_in_freeList+0x55>
  802a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa0:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa8:	a3 48 50 98 00       	mov    %eax,0x985048
  802aad:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ab7:	a1 54 50 98 00       	mov    0x985054,%eax
  802abc:	40                   	inc    %eax
  802abd:	a3 54 50 98 00       	mov    %eax,0x985054
		return;
  802ac2:	e9 1a 01 00 00       	jmp    802be1 <insert_sorted_in_freeList+0x191>
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  802ac7:	a1 48 50 98 00       	mov    0x985048,%eax
  802acc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802acf:	eb 7f                	jmp    802b50 <insert_sorted_in_freeList+0x100>
	{
		if(blk > newBlock) // if address of blk > address of newBlock => add newBlock before blk
  802ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad4:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ad7:	76 6f                	jbe    802b48 <insert_sorted_in_freeList+0xf8>
		{
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
  802ad9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802add:	74 06                	je     802ae5 <insert_sorted_in_freeList+0x95>
  802adf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ae3:	75 17                	jne    802afc <insert_sorted_in_freeList+0xac>
  802ae5:	83 ec 04             	sub    $0x4,%esp
  802ae8:	68 c4 46 80 00       	push   $0x8046c4
  802aed:	68 a6 00 00 00       	push   $0xa6
  802af2:	68 ab 46 80 00       	push   $0x8046ab
  802af7:	e8 ba dc ff ff       	call   8007b6 <_panic>
  802afc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aff:	8b 50 04             	mov    0x4(%eax),%edx
  802b02:	8b 45 08             	mov    0x8(%ebp),%eax
  802b05:	89 50 04             	mov    %edx,0x4(%eax)
  802b08:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b0e:	89 10                	mov    %edx,(%eax)
  802b10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b13:	8b 40 04             	mov    0x4(%eax),%eax
  802b16:	85 c0                	test   %eax,%eax
  802b18:	74 0d                	je     802b27 <insert_sorted_in_freeList+0xd7>
  802b1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1d:	8b 40 04             	mov    0x4(%eax),%eax
  802b20:	8b 55 08             	mov    0x8(%ebp),%edx
  802b23:	89 10                	mov    %edx,(%eax)
  802b25:	eb 08                	jmp    802b2f <insert_sorted_in_freeList+0xdf>
  802b27:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2a:	a3 48 50 98 00       	mov    %eax,0x985048
  802b2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b32:	8b 55 08             	mov    0x8(%ebp),%edx
  802b35:	89 50 04             	mov    %edx,0x4(%eax)
  802b38:	a1 54 50 98 00       	mov    0x985054,%eax
  802b3d:	40                   	inc    %eax
  802b3e:	a3 54 50 98 00       	mov    %eax,0x985054
			return;
  802b43:	e9 99 00 00 00       	jmp    802be1 <insert_sorted_in_freeList+0x191>
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
		return;
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  802b48:	a1 50 50 98 00       	mov    0x985050,%eax
  802b4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b50:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b54:	74 07                	je     802b5d <insert_sorted_in_freeList+0x10d>
  802b56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b59:	8b 00                	mov    (%eax),%eax
  802b5b:	eb 05                	jmp    802b62 <insert_sorted_in_freeList+0x112>
  802b5d:	b8 00 00 00 00       	mov    $0x0,%eax
  802b62:	a3 50 50 98 00       	mov    %eax,0x985050
  802b67:	a1 50 50 98 00       	mov    0x985050,%eax
  802b6c:	85 c0                	test   %eax,%eax
  802b6e:	0f 85 5d ff ff ff    	jne    802ad1 <insert_sorted_in_freeList+0x81>
  802b74:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b78:	0f 85 53 ff ff ff    	jne    802ad1 <insert_sorted_in_freeList+0x81>
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
			return;
		}
	}
	// if no blk its address > newBlock
	LIST_INSERT_TAIL(&freeBlocksList, newBlock);
  802b7e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b82:	75 17                	jne    802b9b <insert_sorted_in_freeList+0x14b>
  802b84:	83 ec 04             	sub    $0x4,%esp
  802b87:	68 fc 46 80 00       	push   $0x8046fc
  802b8c:	68 ab 00 00 00       	push   $0xab
  802b91:	68 ab 46 80 00       	push   $0x8046ab
  802b96:	e8 1b dc ff ff       	call   8007b6 <_panic>
  802b9b:	8b 15 4c 50 98 00    	mov    0x98504c,%edx
  802ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba4:	89 50 04             	mov    %edx,0x4(%eax)
  802ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  802baa:	8b 40 04             	mov    0x4(%eax),%eax
  802bad:	85 c0                	test   %eax,%eax
  802baf:	74 0c                	je     802bbd <insert_sorted_in_freeList+0x16d>
  802bb1:	a1 4c 50 98 00       	mov    0x98504c,%eax
  802bb6:	8b 55 08             	mov    0x8(%ebp),%edx
  802bb9:	89 10                	mov    %edx,(%eax)
  802bbb:	eb 08                	jmp    802bc5 <insert_sorted_in_freeList+0x175>
  802bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc0:	a3 48 50 98 00       	mov    %eax,0x985048
  802bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc8:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bd6:	a1 54 50 98 00       	mov    0x985054,%eax
  802bdb:	40                   	inc    %eax
  802bdc:	a3 54 50 98 00       	mov    %eax,0x985054
}
  802be1:	c9                   	leave  
  802be2:	c3                   	ret    

00802be3 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  802be3:	55                   	push   %ebp
  802be4:	89 e5                	mov    %esp,%ebp
  802be6:	83 ec 78             	sub    $0x78,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802be9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bec:	83 e0 01             	and    $0x1,%eax
  802bef:	85 c0                	test   %eax,%eax
  802bf1:	74 03                	je     802bf6 <alloc_block_FF+0x13>
  802bf3:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802bf6:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802bfa:	77 07                	ja     802c03 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802bfc:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802c03:	a1 40 50 98 00       	mov    0x985040,%eax
  802c08:	85 c0                	test   %eax,%eax
  802c0a:	75 63                	jne    802c6f <alloc_block_FF+0x8c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0f:	83 c0 10             	add    $0x10,%eax
  802c12:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802c15:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802c1c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c22:	01 d0                	add    %edx,%eax
  802c24:	48                   	dec    %eax
  802c25:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802c28:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c2b:	ba 00 00 00 00       	mov    $0x0,%edx
  802c30:	f7 75 ec             	divl   -0x14(%ebp)
  802c33:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c36:	29 d0                	sub    %edx,%eax
  802c38:	c1 e8 0c             	shr    $0xc,%eax
  802c3b:	83 ec 0c             	sub    $0xc,%esp
  802c3e:	50                   	push   %eax
  802c3f:	e8 d1 ed ff ff       	call   801a15 <sbrk>
  802c44:	83 c4 10             	add    $0x10,%esp
  802c47:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802c4a:	83 ec 0c             	sub    $0xc,%esp
  802c4d:	6a 00                	push   $0x0
  802c4f:	e8 c1 ed ff ff       	call   801a15 <sbrk>
  802c54:	83 c4 10             	add    $0x10,%esp
  802c57:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802c5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c5d:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802c60:	83 ec 08             	sub    $0x8,%esp
  802c63:	50                   	push   %eax
  802c64:	ff 75 e4             	pushl  -0x1c(%ebp)
  802c67:	e8 75 fc ff ff       	call   8028e1 <initialize_dynamic_allocator>
  802c6c:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(size == 0)
  802c6f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c73:	75 0a                	jne    802c7f <alloc_block_FF+0x9c>
	{
		return NULL;
  802c75:	b8 00 00 00 00       	mov    $0x0,%eax
  802c7a:	e9 99 03 00 00       	jmp    803018 <alloc_block_FF+0x435>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  802c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c82:	83 c0 08             	add    $0x8,%eax
  802c85:	89 45 dc             	mov    %eax,-0x24(%ebp)

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802c88:	a1 48 50 98 00       	mov    0x985048,%eax
  802c8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c90:	e9 03 02 00 00       	jmp    802e98 <alloc_block_FF+0x2b5>
	{
		uint32 blockSize = get_block_size(block); // Get size without the (LSB) allocation flag
  802c95:	83 ec 0c             	sub    $0xc,%esp
  802c98:	ff 75 f4             	pushl  -0xc(%ebp)
  802c9b:	e8 dd fa ff ff       	call   80277d <get_block_size>
  802ca0:	83 c4 10             	add    $0x10,%esp
  802ca3:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if(blockSize >= totalSize)
  802ca6:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802ca9:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802cac:	0f 82 de 01 00 00    	jb     802e90 <alloc_block_FF+0x2ad>
		{	//if we can put another block with min size 16
			if(blockSize >= totalSize + 4*sizeof(uint32))
  802cb2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cb5:	83 c0 10             	add    $0x10,%eax
  802cb8:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  802cbb:	0f 87 32 01 00 00    	ja     802df3 <alloc_block_FF+0x210>
			{
				// the size that will remain from the block that we will allocate a new block in it
				uint32 remainingSize = blockSize - totalSize;
  802cc1:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802cc4:	2b 45 dc             	sub    -0x24(%ebp),%eax
  802cc7:	89 45 98             	mov    %eax,-0x68(%ebp)

				// the remaining free space from the block that we use to allocate in it
				struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)block + totalSize);
  802cca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ccd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cd0:	01 d0                	add    %edx,%eax
  802cd2:	89 45 94             	mov    %eax,-0x6c(%ebp)
				set_block_data(remainingFreeBlock, remainingSize, 0);
  802cd5:	83 ec 04             	sub    $0x4,%esp
  802cd8:	6a 00                	push   $0x0
  802cda:	ff 75 98             	pushl  -0x68(%ebp)
  802cdd:	ff 75 94             	pushl  -0x6c(%ebp)
  802ce0:	e8 14 fd ff ff       	call   8029f9 <set_block_data>
  802ce5:	83 c4 10             	add    $0x10,%esp
				// add it after the block we allocated to be sorted by addresses
				LIST_INSERT_AFTER(&freeBlocksList, block,remainingFreeBlock);
  802ce8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cec:	74 06                	je     802cf4 <alloc_block_FF+0x111>
  802cee:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
  802cf2:	75 17                	jne    802d0b <alloc_block_FF+0x128>
  802cf4:	83 ec 04             	sub    $0x4,%esp
  802cf7:	68 20 47 80 00       	push   $0x804720
  802cfc:	68 de 00 00 00       	push   $0xde
  802d01:	68 ab 46 80 00       	push   $0x8046ab
  802d06:	e8 ab da ff ff       	call   8007b6 <_panic>
  802d0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0e:	8b 10                	mov    (%eax),%edx
  802d10:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802d13:	89 10                	mov    %edx,(%eax)
  802d15:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802d18:	8b 00                	mov    (%eax),%eax
  802d1a:	85 c0                	test   %eax,%eax
  802d1c:	74 0b                	je     802d29 <alloc_block_FF+0x146>
  802d1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d21:	8b 00                	mov    (%eax),%eax
  802d23:	8b 55 94             	mov    -0x6c(%ebp),%edx
  802d26:	89 50 04             	mov    %edx,0x4(%eax)
  802d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2c:	8b 55 94             	mov    -0x6c(%ebp),%edx
  802d2f:	89 10                	mov    %edx,(%eax)
  802d31:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802d34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d37:	89 50 04             	mov    %edx,0x4(%eax)
  802d3a:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802d3d:	8b 00                	mov    (%eax),%eax
  802d3f:	85 c0                	test   %eax,%eax
  802d41:	75 08                	jne    802d4b <alloc_block_FF+0x168>
  802d43:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802d46:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802d4b:	a1 54 50 98 00       	mov    0x985054,%eax
  802d50:	40                   	inc    %eax
  802d51:	a3 54 50 98 00       	mov    %eax,0x985054

				// update the allocated block and remove it from freeBlocksList
				set_block_data(block,totalSize,1);
  802d56:	83 ec 04             	sub    $0x4,%esp
  802d59:	6a 01                	push   $0x1
  802d5b:	ff 75 dc             	pushl  -0x24(%ebp)
  802d5e:	ff 75 f4             	pushl  -0xc(%ebp)
  802d61:	e8 93 fc ff ff       	call   8029f9 <set_block_data>
  802d66:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  802d69:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d6d:	75 17                	jne    802d86 <alloc_block_FF+0x1a3>
  802d6f:	83 ec 04             	sub    $0x4,%esp
  802d72:	68 54 47 80 00       	push   $0x804754
  802d77:	68 e3 00 00 00       	push   $0xe3
  802d7c:	68 ab 46 80 00       	push   $0x8046ab
  802d81:	e8 30 da ff ff       	call   8007b6 <_panic>
  802d86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d89:	8b 00                	mov    (%eax),%eax
  802d8b:	85 c0                	test   %eax,%eax
  802d8d:	74 10                	je     802d9f <alloc_block_FF+0x1bc>
  802d8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d92:	8b 00                	mov    (%eax),%eax
  802d94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d97:	8b 52 04             	mov    0x4(%edx),%edx
  802d9a:	89 50 04             	mov    %edx,0x4(%eax)
  802d9d:	eb 0b                	jmp    802daa <alloc_block_FF+0x1c7>
  802d9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da2:	8b 40 04             	mov    0x4(%eax),%eax
  802da5:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802daa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dad:	8b 40 04             	mov    0x4(%eax),%eax
  802db0:	85 c0                	test   %eax,%eax
  802db2:	74 0f                	je     802dc3 <alloc_block_FF+0x1e0>
  802db4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db7:	8b 40 04             	mov    0x4(%eax),%eax
  802dba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dbd:	8b 12                	mov    (%edx),%edx
  802dbf:	89 10                	mov    %edx,(%eax)
  802dc1:	eb 0a                	jmp    802dcd <alloc_block_FF+0x1ea>
  802dc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc6:	8b 00                	mov    (%eax),%eax
  802dc8:	a3 48 50 98 00       	mov    %eax,0x985048
  802dcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802de0:	a1 54 50 98 00       	mov    0x985054,%eax
  802de5:	48                   	dec    %eax
  802de6:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  802deb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dee:	e9 25 02 00 00       	jmp    803018 <alloc_block_FF+0x435>
			}
			else // if set internal fragmentation
			{
				// add the remaining size to the block we allocate so it will be the same main block size
				set_block_data(block,blockSize,1);
  802df3:	83 ec 04             	sub    $0x4,%esp
  802df6:	6a 01                	push   $0x1
  802df8:	ff 75 9c             	pushl  -0x64(%ebp)
  802dfb:	ff 75 f4             	pushl  -0xc(%ebp)
  802dfe:	e8 f6 fb ff ff       	call   8029f9 <set_block_data>
  802e03:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  802e06:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e0a:	75 17                	jne    802e23 <alloc_block_FF+0x240>
  802e0c:	83 ec 04             	sub    $0x4,%esp
  802e0f:	68 54 47 80 00       	push   $0x804754
  802e14:	68 eb 00 00 00       	push   $0xeb
  802e19:	68 ab 46 80 00       	push   $0x8046ab
  802e1e:	e8 93 d9 ff ff       	call   8007b6 <_panic>
  802e23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e26:	8b 00                	mov    (%eax),%eax
  802e28:	85 c0                	test   %eax,%eax
  802e2a:	74 10                	je     802e3c <alloc_block_FF+0x259>
  802e2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2f:	8b 00                	mov    (%eax),%eax
  802e31:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e34:	8b 52 04             	mov    0x4(%edx),%edx
  802e37:	89 50 04             	mov    %edx,0x4(%eax)
  802e3a:	eb 0b                	jmp    802e47 <alloc_block_FF+0x264>
  802e3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3f:	8b 40 04             	mov    0x4(%eax),%eax
  802e42:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802e47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4a:	8b 40 04             	mov    0x4(%eax),%eax
  802e4d:	85 c0                	test   %eax,%eax
  802e4f:	74 0f                	je     802e60 <alloc_block_FF+0x27d>
  802e51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e54:	8b 40 04             	mov    0x4(%eax),%eax
  802e57:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e5a:	8b 12                	mov    (%edx),%edx
  802e5c:	89 10                	mov    %edx,(%eax)
  802e5e:	eb 0a                	jmp    802e6a <alloc_block_FF+0x287>
  802e60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e63:	8b 00                	mov    (%eax),%eax
  802e65:	a3 48 50 98 00       	mov    %eax,0x985048
  802e6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e76:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e7d:	a1 54 50 98 00       	mov    0x985054,%eax
  802e82:	48                   	dec    %eax
  802e83:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  802e88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8b:	e9 88 01 00 00       	jmp    803018 <alloc_block_FF+0x435>
		return NULL;
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802e90:	a1 50 50 98 00       	mov    0x985050,%eax
  802e95:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e98:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e9c:	74 07                	je     802ea5 <alloc_block_FF+0x2c2>
  802e9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea1:	8b 00                	mov    (%eax),%eax
  802ea3:	eb 05                	jmp    802eaa <alloc_block_FF+0x2c7>
  802ea5:	b8 00 00 00 00       	mov    $0x0,%eax
  802eaa:	a3 50 50 98 00       	mov    %eax,0x985050
  802eaf:	a1 50 50 98 00       	mov    0x985050,%eax
  802eb4:	85 c0                	test   %eax,%eax
  802eb6:	0f 85 d9 fd ff ff    	jne    802c95 <alloc_block_FF+0xb2>
  802ebc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ec0:	0f 85 cf fd ff ff    	jne    802c95 <alloc_block_FF+0xb2>

//	uint32 *endBlock = &kheapBreak;

	// if we don't find any enough space to allocate the block

	void *oldBreak = sbrk(ROUNDUP(totalSize, PAGE_SIZE) / PAGE_SIZE);
  802ec6:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802ecd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ed0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ed3:	01 d0                	add    %edx,%eax
  802ed5:	48                   	dec    %eax
  802ed6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802ed9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802edc:	ba 00 00 00 00       	mov    $0x0,%edx
  802ee1:	f7 75 d8             	divl   -0x28(%ebp)
  802ee4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ee7:	29 d0                	sub    %edx,%eax
  802ee9:	c1 e8 0c             	shr    $0xc,%eax
  802eec:	83 ec 0c             	sub    $0xc,%esp
  802eef:	50                   	push   %eax
  802ef0:	e8 20 eb ff ff       	call   801a15 <sbrk>
  802ef5:	83 c4 10             	add    $0x10,%esp
  802ef8:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (oldBreak == (void*)-1) {
  802efb:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802eff:	75 0a                	jne    802f0b <alloc_block_FF+0x328>
		return NULL;
  802f01:	b8 00 00 00 00       	mov    $0x0,%eax
  802f06:	e9 0d 01 00 00       	jmp    803018 <alloc_block_FF+0x435>
	}
	//uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);

	uint32* endBlk = (uint32 *)((char *)oldBreak - 4);
  802f0b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f0e:	83 e8 04             	sub    $0x4,%eax
  802f11:	89 45 cc             	mov    %eax,-0x34(%ebp)
	//endBlk = endBlk+(char *) ROUNDUP(totalSize, PAGE_SIZE);

	endBlk = endBlk + (ROUNDUP(totalSize, PAGE_SIZE) / sizeof(uint32));
  802f14:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  802f1b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f1e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802f21:	01 d0                	add    %edx,%eax
  802f23:	48                   	dec    %eax
  802f24:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  802f27:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802f2a:	ba 00 00 00 00       	mov    $0x0,%edx
  802f2f:	f7 75 c8             	divl   -0x38(%ebp)
  802f32:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802f35:	29 d0                	sub    %edx,%eax
  802f37:	c1 e8 02             	shr    $0x2,%eax
  802f3a:	c1 e0 02             	shl    $0x2,%eax
  802f3d:	01 45 cc             	add    %eax,-0x34(%ebp)
	*endBlk = 0 | 1;
  802f40:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f43:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	uint32 *footerLast = ((uint32*)oldBreak - 2);
  802f49:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f4c:	83 e8 08             	sub    $0x8,%eax
  802f4f:	89 45 c0             	mov    %eax,-0x40(%ebp)
	uint32 lastSize = (*footerLast) & ~(0x1);
  802f52:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802f55:	8b 00                	mov    (%eax),%eax
  802f57:	83 e0 fe             	and    $0xfffffffe,%eax
  802f5a:	89 45 bc             	mov    %eax,-0x44(%ebp)
	// the last block for the block that we want to free it
	struct BlockElement *laskBlk = (struct BlockElement *)((char*)oldBreak - lastSize);
  802f5d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802f60:	f7 d8                	neg    %eax
  802f62:	89 c2                	mov    %eax,%edx
  802f64:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f67:	01 d0                	add    %edx,%eax
  802f69:	89 45 b8             	mov    %eax,-0x48(%ebp)
	uint32 isLastFree = is_free_block(laskBlk);
  802f6c:	83 ec 0c             	sub    $0xc,%esp
  802f6f:	ff 75 b8             	pushl  -0x48(%ebp)
  802f72:	e8 1f f8 ff ff       	call   802796 <is_free_block>
  802f77:	83 c4 10             	add    $0x10,%esp
  802f7a:	0f be c0             	movsbl %al,%eax
  802f7d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(isLastFree)
  802f80:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  802f84:	74 42                	je     802fc8 <alloc_block_FF+0x3e5>
	{
		// merge the block will be free with its prev block
		uint32 newBlkSize = lastSize + ROUNDUP(totalSize, PAGE_SIZE); // size of main block and its prev block
  802f86:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802f8d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f90:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802f93:	01 d0                	add    %edx,%eax
  802f95:	48                   	dec    %eax
  802f96:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802f99:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802f9c:	ba 00 00 00 00       	mov    $0x0,%edx
  802fa1:	f7 75 b0             	divl   -0x50(%ebp)
  802fa4:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802fa7:	29 d0                	sub    %edx,%eax
  802fa9:	89 c2                	mov    %eax,%edx
  802fab:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802fae:	01 d0                	add    %edx,%eax
  802fb0:	89 45 a8             	mov    %eax,-0x58(%ebp)
		// extends last block size to contain its size and the size of new space
		set_block_data(laskBlk,newBlkSize,0);
  802fb3:	83 ec 04             	sub    $0x4,%esp
  802fb6:	6a 00                	push   $0x0
  802fb8:	ff 75 a8             	pushl  -0x58(%ebp)
  802fbb:	ff 75 b8             	pushl  -0x48(%ebp)
  802fbe:	e8 36 fa ff ff       	call   8029f9 <set_block_data>
  802fc3:	83 c4 10             	add    $0x10,%esp
  802fc6:	eb 42                	jmp    80300a <alloc_block_FF+0x427>
	}
	else
	{
		set_block_data(oldBreak,ROUNDUP(totalSize, PAGE_SIZE),0);
  802fc8:	c7 45 a4 00 10 00 00 	movl   $0x1000,-0x5c(%ebp)
  802fcf:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802fd2:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802fd5:	01 d0                	add    %edx,%eax
  802fd7:	48                   	dec    %eax
  802fd8:	89 45 a0             	mov    %eax,-0x60(%ebp)
  802fdb:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802fde:	ba 00 00 00 00       	mov    $0x0,%edx
  802fe3:	f7 75 a4             	divl   -0x5c(%ebp)
  802fe6:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802fe9:	29 d0                	sub    %edx,%eax
  802feb:	83 ec 04             	sub    $0x4,%esp
  802fee:	6a 00                	push   $0x0
  802ff0:	50                   	push   %eax
  802ff1:	ff 75 d0             	pushl  -0x30(%ebp)
  802ff4:	e8 00 fa ff ff       	call   8029f9 <set_block_data>
  802ff9:	83 c4 10             	add    $0x10,%esp
		insert_sorted_in_freeList((struct BlockElement *)oldBreak);
  802ffc:	83 ec 0c             	sub    $0xc,%esp
  802fff:	ff 75 d0             	pushl  -0x30(%ebp)
  803002:	e8 49 fa ff ff       	call   802a50 <insert_sorted_in_freeList>
  803007:	83 c4 10             	add    $0x10,%esp
//		LIST_INSERT_TAIL(&freeBlocksList,newBreak);
	}
//	set_block_data((struct BlockElement *)newBreak, totalSize, 1);
	return alloc_block_FF(size);
  80300a:	83 ec 0c             	sub    $0xc,%esp
  80300d:	ff 75 08             	pushl  0x8(%ebp)
  803010:	e8 ce fb ff ff       	call   802be3 <alloc_block_FF>
  803015:	83 c4 10             	add    $0x10,%esp
}
  803018:	c9                   	leave  
  803019:	c3                   	ret    

0080301a <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  80301a:	55                   	push   %ebp
  80301b:	89 e5                	mov    %esp,%ebp
  80301d:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS1 - BONUS] [3] DYNAMIC ALLOCATOR - alloc_block_BF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_BF is not implemented yet");
	//Your Code is Here...
	if(size == 0)
  803020:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803024:	75 0a                	jne    803030 <alloc_block_BF+0x16>
	{
		return NULL;
  803026:	b8 00 00 00 00       	mov    $0x0,%eax
  80302b:	e9 7a 02 00 00       	jmp    8032aa <alloc_block_BF+0x290>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  803030:	8b 45 08             	mov    0x8(%ebp),%eax
  803033:	83 c0 08             	add    $0x8,%eax
  803036:	89 45 e8             	mov    %eax,-0x18(%ebp)

	struct BlockElement *minBlk= NULL;
  803039:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 minSize = 0xfffffff; // a large number
  803040:	c7 45 f0 ff ff ff 0f 	movl   $0xfffffff,-0x10(%ebp)
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  803047:	a1 48 50 98 00       	mov    0x985048,%eax
  80304c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80304f:	eb 32                	jmp    803083 <alloc_block_BF+0x69>
	{
		uint32 blockSize = get_block_size(block);
  803051:	ff 75 ec             	pushl  -0x14(%ebp)
  803054:	e8 24 f7 ff ff       	call   80277d <get_block_size>
  803059:	83 c4 04             	add    $0x4,%esp
  80305c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		// if this block can take the new block and its size < min size of all blocks
		if(blockSize >= totalSize && blockSize < minSize)
  80305f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803062:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803065:	72 14                	jb     80307b <alloc_block_BF+0x61>
  803067:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80306a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80306d:	73 0c                	jae    80307b <alloc_block_BF+0x61>
		{
			minBlk = block;
  80306f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803072:	89 45 f4             	mov    %eax,-0xc(%ebp)
			minSize = blockSize;
  803075:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803078:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *minBlk= NULL;
	uint32 minSize = 0xfffffff; // a large number
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  80307b:	a1 50 50 98 00       	mov    0x985050,%eax
  803080:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803083:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803087:	74 07                	je     803090 <alloc_block_BF+0x76>
  803089:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80308c:	8b 00                	mov    (%eax),%eax
  80308e:	eb 05                	jmp    803095 <alloc_block_BF+0x7b>
  803090:	b8 00 00 00 00       	mov    $0x0,%eax
  803095:	a3 50 50 98 00       	mov    %eax,0x985050
  80309a:	a1 50 50 98 00       	mov    0x985050,%eax
  80309f:	85 c0                	test   %eax,%eax
  8030a1:	75 ae                	jne    803051 <alloc_block_BF+0x37>
  8030a3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8030a7:	75 a8                	jne    803051 <alloc_block_BF+0x37>
			minSize = blockSize;
		}
	}

	// if we don't find any enough space to allocate the block
	if(minBlk == NULL)
  8030a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030ad:	75 22                	jne    8030d1 <alloc_block_BF+0xb7>
	{
		void *newBlock = sbrk(totalSize);
  8030af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b2:	83 ec 0c             	sub    $0xc,%esp
  8030b5:	50                   	push   %eax
  8030b6:	e8 5a e9 ff ff       	call   801a15 <sbrk>
  8030bb:	83 c4 10             	add    $0x10,%esp
  8030be:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (newBlock == (void*)-1) {
  8030c1:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8030c5:	75 0a                	jne    8030d1 <alloc_block_BF+0xb7>
			return NULL;
  8030c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8030cc:	e9 d9 01 00 00       	jmp    8032aa <alloc_block_BF+0x290>
		}
	}

	//if we can put another block with min size 16
	if(minSize >= totalSize + 4*sizeof(uint32))
  8030d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d4:	83 c0 10             	add    $0x10,%eax
  8030d7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8030da:	0f 87 32 01 00 00    	ja     803212 <alloc_block_BF+0x1f8>
	{
		// the size that will remain from the block that we will allocate a new block in it
		uint32 remainingSize= minSize - totalSize;
  8030e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030e3:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8030e6:	89 45 dc             	mov    %eax,-0x24(%ebp)

		// the remaining free space from the block that we use to allocate in it
		struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)minBlk + totalSize);
  8030e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ef:	01 d0                	add    %edx,%eax
  8030f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
		set_block_data(remainingFreeBlock, remainingSize, 0);
  8030f4:	83 ec 04             	sub    $0x4,%esp
  8030f7:	6a 00                	push   $0x0
  8030f9:	ff 75 dc             	pushl  -0x24(%ebp)
  8030fc:	ff 75 d8             	pushl  -0x28(%ebp)
  8030ff:	e8 f5 f8 ff ff       	call   8029f9 <set_block_data>
  803104:	83 c4 10             	add    $0x10,%esp
		// add it after the block we allocated to be sorted by addresses
		LIST_INSERT_AFTER(&freeBlocksList, minBlk,remainingFreeBlock);
  803107:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80310b:	74 06                	je     803113 <alloc_block_BF+0xf9>
  80310d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  803111:	75 17                	jne    80312a <alloc_block_BF+0x110>
  803113:	83 ec 04             	sub    $0x4,%esp
  803116:	68 20 47 80 00       	push   $0x804720
  80311b:	68 49 01 00 00       	push   $0x149
  803120:	68 ab 46 80 00       	push   $0x8046ab
  803125:	e8 8c d6 ff ff       	call   8007b6 <_panic>
  80312a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312d:	8b 10                	mov    (%eax),%edx
  80312f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803132:	89 10                	mov    %edx,(%eax)
  803134:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803137:	8b 00                	mov    (%eax),%eax
  803139:	85 c0                	test   %eax,%eax
  80313b:	74 0b                	je     803148 <alloc_block_BF+0x12e>
  80313d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803140:	8b 00                	mov    (%eax),%eax
  803142:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803145:	89 50 04             	mov    %edx,0x4(%eax)
  803148:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80314e:	89 10                	mov    %edx,(%eax)
  803150:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803153:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803156:	89 50 04             	mov    %edx,0x4(%eax)
  803159:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80315c:	8b 00                	mov    (%eax),%eax
  80315e:	85 c0                	test   %eax,%eax
  803160:	75 08                	jne    80316a <alloc_block_BF+0x150>
  803162:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803165:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80316a:	a1 54 50 98 00       	mov    0x985054,%eax
  80316f:	40                   	inc    %eax
  803170:	a3 54 50 98 00       	mov    %eax,0x985054

		// update the allocated block and remove it from freeBlocksList
		set_block_data(minBlk,totalSize,1);
  803175:	83 ec 04             	sub    $0x4,%esp
  803178:	6a 01                	push   $0x1
  80317a:	ff 75 e8             	pushl  -0x18(%ebp)
  80317d:	ff 75 f4             	pushl  -0xc(%ebp)
  803180:	e8 74 f8 ff ff       	call   8029f9 <set_block_data>
  803185:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  803188:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80318c:	75 17                	jne    8031a5 <alloc_block_BF+0x18b>
  80318e:	83 ec 04             	sub    $0x4,%esp
  803191:	68 54 47 80 00       	push   $0x804754
  803196:	68 4e 01 00 00       	push   $0x14e
  80319b:	68 ab 46 80 00       	push   $0x8046ab
  8031a0:	e8 11 d6 ff ff       	call   8007b6 <_panic>
  8031a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a8:	8b 00                	mov    (%eax),%eax
  8031aa:	85 c0                	test   %eax,%eax
  8031ac:	74 10                	je     8031be <alloc_block_BF+0x1a4>
  8031ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b1:	8b 00                	mov    (%eax),%eax
  8031b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031b6:	8b 52 04             	mov    0x4(%edx),%edx
  8031b9:	89 50 04             	mov    %edx,0x4(%eax)
  8031bc:	eb 0b                	jmp    8031c9 <alloc_block_BF+0x1af>
  8031be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c1:	8b 40 04             	mov    0x4(%eax),%eax
  8031c4:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8031c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031cc:	8b 40 04             	mov    0x4(%eax),%eax
  8031cf:	85 c0                	test   %eax,%eax
  8031d1:	74 0f                	je     8031e2 <alloc_block_BF+0x1c8>
  8031d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d6:	8b 40 04             	mov    0x4(%eax),%eax
  8031d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031dc:	8b 12                	mov    (%edx),%edx
  8031de:	89 10                	mov    %edx,(%eax)
  8031e0:	eb 0a                	jmp    8031ec <alloc_block_BF+0x1d2>
  8031e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e5:	8b 00                	mov    (%eax),%eax
  8031e7:	a3 48 50 98 00       	mov    %eax,0x985048
  8031ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031ff:	a1 54 50 98 00       	mov    0x985054,%eax
  803204:	48                   	dec    %eax
  803205:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  80320a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320d:	e9 98 00 00 00       	jmp    8032aa <alloc_block_BF+0x290>
	}
	else // if set internal fragmentation
	{
		// add the remaining size to the block we allocate so it will be the same main block size
		set_block_data(minBlk,minSize,1);
  803212:	83 ec 04             	sub    $0x4,%esp
  803215:	6a 01                	push   $0x1
  803217:	ff 75 f0             	pushl  -0x10(%ebp)
  80321a:	ff 75 f4             	pushl  -0xc(%ebp)
  80321d:	e8 d7 f7 ff ff       	call   8029f9 <set_block_data>
  803222:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  803225:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803229:	75 17                	jne    803242 <alloc_block_BF+0x228>
  80322b:	83 ec 04             	sub    $0x4,%esp
  80322e:	68 54 47 80 00       	push   $0x804754
  803233:	68 56 01 00 00       	push   $0x156
  803238:	68 ab 46 80 00       	push   $0x8046ab
  80323d:	e8 74 d5 ff ff       	call   8007b6 <_panic>
  803242:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803245:	8b 00                	mov    (%eax),%eax
  803247:	85 c0                	test   %eax,%eax
  803249:	74 10                	je     80325b <alloc_block_BF+0x241>
  80324b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324e:	8b 00                	mov    (%eax),%eax
  803250:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803253:	8b 52 04             	mov    0x4(%edx),%edx
  803256:	89 50 04             	mov    %edx,0x4(%eax)
  803259:	eb 0b                	jmp    803266 <alloc_block_BF+0x24c>
  80325b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325e:	8b 40 04             	mov    0x4(%eax),%eax
  803261:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803266:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803269:	8b 40 04             	mov    0x4(%eax),%eax
  80326c:	85 c0                	test   %eax,%eax
  80326e:	74 0f                	je     80327f <alloc_block_BF+0x265>
  803270:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803273:	8b 40 04             	mov    0x4(%eax),%eax
  803276:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803279:	8b 12                	mov    (%edx),%edx
  80327b:	89 10                	mov    %edx,(%eax)
  80327d:	eb 0a                	jmp    803289 <alloc_block_BF+0x26f>
  80327f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803282:	8b 00                	mov    (%eax),%eax
  803284:	a3 48 50 98 00       	mov    %eax,0x985048
  803289:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803292:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803295:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80329c:	a1 54 50 98 00       	mov    0x985054,%eax
  8032a1:	48                   	dec    %eax
  8032a2:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  8032a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
	}
	return NULL;
}
  8032aa:	c9                   	leave  
  8032ab:	c3                   	ret    

008032ac <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8032ac:	55                   	push   %ebp
  8032ad:	89 e5                	mov    %esp,%ebp
  8032af:	83 ec 48             	sub    $0x48,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
  8032b2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032b6:	0f 84 6a 02 00 00    	je     803526 <free_block+0x27a>
	{
		return;
	}

	uint32 freeSize = get_block_size(va);
  8032bc:	ff 75 08             	pushl  0x8(%ebp)
  8032bf:	e8 b9 f4 ff ff       	call   80277d <get_block_size>
  8032c4:	83 c4 04             	add    $0x4,%esp
  8032c7:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// footer for the prev block for the block that we want to free it
	uint32 *footerPrev = ((uint32*)va - 2 );
  8032ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8032cd:	83 e8 08             	sub    $0x8,%eax
  8032d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 pSize = (*footerPrev) & ~(0x1);
  8032d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032d6:	8b 00                	mov    (%eax),%eax
  8032d8:	83 e0 fe             	and    $0xfffffffe,%eax
  8032db:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// the prev block for the block that we want to free it
	struct BlockElement * prevBlk = (struct BlockElement *)((char*)va - pSize);
  8032de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032e1:	f7 d8                	neg    %eax
  8032e3:	89 c2                	mov    %eax,%edx
  8032e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e8:	01 d0                	add    %edx,%eax
  8032ea:	89 45 e8             	mov    %eax,-0x18(%ebp)
	uint32 isPrevFree = is_free_block(prevBlk);
  8032ed:	ff 75 e8             	pushl  -0x18(%ebp)
  8032f0:	e8 a1 f4 ff ff       	call   802796 <is_free_block>
  8032f5:	83 c4 04             	add    $0x4,%esp
  8032f8:	0f be c0             	movsbl %al,%eax
  8032fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
  8032fe:	8b 55 08             	mov    0x8(%ebp),%edx
  803301:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803304:	01 d0                	add    %edx,%eax
  803306:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  803309:	ff 75 e0             	pushl  -0x20(%ebp)
  80330c:	e8 85 f4 ff ff       	call   802796 <is_free_block>
  803311:	83 c4 04             	add    $0x4,%esp
  803314:	0f be c0             	movsbl %al,%eax
  803317:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if(isPrevFree == 1 && isNextFree == 0)
  80331a:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  80331e:	75 34                	jne    803354 <free_block+0xa8>
  803320:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803324:	75 2e                	jne    803354 <free_block+0xa8>
	{
		// merge the block will be free with its prev block
		uint32 prevSize = get_block_size(prevBlk);
  803326:	ff 75 e8             	pushl  -0x18(%ebp)
  803329:	e8 4f f4 ff ff       	call   80277d <get_block_size>
  80332e:	83 c4 04             	add    $0x4,%esp
  803331:	89 45 d8             	mov    %eax,-0x28(%ebp)
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
  803334:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803337:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80333a:	01 d0                	add    %edx,%eax
  80333c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
  80333f:	6a 00                	push   $0x0
  803341:	ff 75 d4             	pushl  -0x2c(%ebp)
  803344:	ff 75 e8             	pushl  -0x18(%ebp)
  803347:	e8 ad f6 ff ff       	call   8029f9 <set_block_data>
  80334c:	83 c4 0c             	add    $0xc,%esp
	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
	uint32 isNextFree = is_free_block(nextBlk);

	if(isPrevFree == 1 && isNextFree == 0)
	{
  80334f:	e9 d3 01 00 00       	jmp    803527 <free_block+0x27b>
		uint32 prevSize = get_block_size(prevBlk);
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
  803354:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  803358:	0f 85 c8 00 00 00    	jne    803426 <free_block+0x17a>
  80335e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803362:	0f 85 be 00 00 00    	jne    803426 <free_block+0x17a>
	{
		// merge the block will be free with its next block
		uint32 nextSize = get_block_size(nextBlk);
  803368:	ff 75 e0             	pushl  -0x20(%ebp)
  80336b:	e8 0d f4 ff ff       	call   80277d <get_block_size>
  803370:	83 c4 04             	add    $0x4,%esp
  803373:	89 45 d0             	mov    %eax,-0x30(%ebp)
		uint32 totalSize = freeSize + nextSize; // size of main block and its next block
  803376:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803379:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80337c:	01 d0                	add    %edx,%eax
  80337e:	89 45 cc             	mov    %eax,-0x34(%ebp)
		// update the size of block to contain its size and the size of next block
		set_block_data(va,totalSize,0);
  803381:	6a 00                	push   $0x0
  803383:	ff 75 cc             	pushl  -0x34(%ebp)
  803386:	ff 75 08             	pushl  0x8(%ebp)
  803389:	e8 6b f6 ff ff       	call   8029f9 <set_block_data>
  80338e:	83 c4 0c             	add    $0xc,%esp
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
  803391:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803395:	75 17                	jne    8033ae <free_block+0x102>
  803397:	83 ec 04             	sub    $0x4,%esp
  80339a:	68 54 47 80 00       	push   $0x804754
  80339f:	68 87 01 00 00       	push   $0x187
  8033a4:	68 ab 46 80 00       	push   $0x8046ab
  8033a9:	e8 08 d4 ff ff       	call   8007b6 <_panic>
  8033ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033b1:	8b 00                	mov    (%eax),%eax
  8033b3:	85 c0                	test   %eax,%eax
  8033b5:	74 10                	je     8033c7 <free_block+0x11b>
  8033b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033ba:	8b 00                	mov    (%eax),%eax
  8033bc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033bf:	8b 52 04             	mov    0x4(%edx),%edx
  8033c2:	89 50 04             	mov    %edx,0x4(%eax)
  8033c5:	eb 0b                	jmp    8033d2 <free_block+0x126>
  8033c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033ca:	8b 40 04             	mov    0x4(%eax),%eax
  8033cd:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8033d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033d5:	8b 40 04             	mov    0x4(%eax),%eax
  8033d8:	85 c0                	test   %eax,%eax
  8033da:	74 0f                	je     8033eb <free_block+0x13f>
  8033dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033df:	8b 40 04             	mov    0x4(%eax),%eax
  8033e2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033e5:	8b 12                	mov    (%edx),%edx
  8033e7:	89 10                	mov    %edx,(%eax)
  8033e9:	eb 0a                	jmp    8033f5 <free_block+0x149>
  8033eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033ee:	8b 00                	mov    (%eax),%eax
  8033f0:	a3 48 50 98 00       	mov    %eax,0x985048
  8033f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803401:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803408:	a1 54 50 98 00       	mov    0x985054,%eax
  80340d:	48                   	dec    %eax
  80340e:	a3 54 50 98 00       	mov    %eax,0x985054
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  803413:	83 ec 0c             	sub    $0xc,%esp
  803416:	ff 75 08             	pushl  0x8(%ebp)
  803419:	e8 32 f6 ff ff       	call   802a50 <insert_sorted_in_freeList>
  80341e:	83 c4 10             	add    $0x10,%esp
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
	{
  803421:	e9 01 01 00 00       	jmp    803527 <free_block+0x27b>
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
  803426:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  80342a:	0f 85 d3 00 00 00    	jne    803503 <free_block+0x257>
  803430:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  803434:	0f 85 c9 00 00 00    	jne    803503 <free_block+0x257>
	{
		// merge the block will be free with its prev and next blocks
		uint32 prevSize = get_block_size(prevBlk);
  80343a:	83 ec 0c             	sub    $0xc,%esp
  80343d:	ff 75 e8             	pushl  -0x18(%ebp)
  803440:	e8 38 f3 ff ff       	call   80277d <get_block_size>
  803445:	83 c4 10             	add    $0x10,%esp
  803448:	89 45 c8             	mov    %eax,-0x38(%ebp)
		uint32 nextSize = get_block_size(nextBlk);
  80344b:	83 ec 0c             	sub    $0xc,%esp
  80344e:	ff 75 e0             	pushl  -0x20(%ebp)
  803451:	e8 27 f3 ff ff       	call   80277d <get_block_size>
  803456:	83 c4 10             	add    $0x10,%esp
  803459:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 totalSize = freeSize + prevSize + nextSize; // size of main block and its prev and next blocks
  80345c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80345f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803462:	01 c2                	add    %eax,%edx
  803464:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803467:	01 d0                	add    %edx,%eax
  803469:	89 45 c0             	mov    %eax,-0x40(%ebp)
		// extends prev block size to contain its size and the size of main and next blocks
		set_block_data(prevBlk,totalSize,0);
  80346c:	83 ec 04             	sub    $0x4,%esp
  80346f:	6a 00                	push   $0x0
  803471:	ff 75 c0             	pushl  -0x40(%ebp)
  803474:	ff 75 e8             	pushl  -0x18(%ebp)
  803477:	e8 7d f5 ff ff       	call   8029f9 <set_block_data>
  80347c:	83 c4 10             	add    $0x10,%esp
		// remove next block because we merge it with its prev blocks
		LIST_REMOVE(&freeBlocksList, nextBlk);
  80347f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803483:	75 17                	jne    80349c <free_block+0x1f0>
  803485:	83 ec 04             	sub    $0x4,%esp
  803488:	68 54 47 80 00       	push   $0x804754
  80348d:	68 94 01 00 00       	push   $0x194
  803492:	68 ab 46 80 00       	push   $0x8046ab
  803497:	e8 1a d3 ff ff       	call   8007b6 <_panic>
  80349c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80349f:	8b 00                	mov    (%eax),%eax
  8034a1:	85 c0                	test   %eax,%eax
  8034a3:	74 10                	je     8034b5 <free_block+0x209>
  8034a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034a8:	8b 00                	mov    (%eax),%eax
  8034aa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8034ad:	8b 52 04             	mov    0x4(%edx),%edx
  8034b0:	89 50 04             	mov    %edx,0x4(%eax)
  8034b3:	eb 0b                	jmp    8034c0 <free_block+0x214>
  8034b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034b8:	8b 40 04             	mov    0x4(%eax),%eax
  8034bb:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8034c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034c3:	8b 40 04             	mov    0x4(%eax),%eax
  8034c6:	85 c0                	test   %eax,%eax
  8034c8:	74 0f                	je     8034d9 <free_block+0x22d>
  8034ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034cd:	8b 40 04             	mov    0x4(%eax),%eax
  8034d0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8034d3:	8b 12                	mov    (%edx),%edx
  8034d5:	89 10                	mov    %edx,(%eax)
  8034d7:	eb 0a                	jmp    8034e3 <free_block+0x237>
  8034d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034dc:	8b 00                	mov    (%eax),%eax
  8034de:	a3 48 50 98 00       	mov    %eax,0x985048
  8034e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034ef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034f6:	a1 54 50 98 00       	mov    0x985054,%eax
  8034fb:	48                   	dec    %eax
  8034fc:	a3 54 50 98 00       	mov    %eax,0x985054
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
	{
  803501:	eb 24                	jmp    803527 <free_block+0x27b>
	}
	else
	{
		// free it without any merge
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
  803503:	83 ec 04             	sub    $0x4,%esp
  803506:	6a 00                	push   $0x0
  803508:	ff 75 f4             	pushl  -0xc(%ebp)
  80350b:	ff 75 08             	pushl  0x8(%ebp)
  80350e:	e8 e6 f4 ff ff       	call   8029f9 <set_block_data>
  803513:	83 c4 10             	add    $0x10,%esp
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  803516:	83 ec 0c             	sub    $0xc,%esp
  803519:	ff 75 08             	pushl  0x8(%ebp)
  80351c:	e8 2f f5 ff ff       	call   802a50 <insert_sorted_in_freeList>
  803521:	83 c4 10             	add    $0x10,%esp
  803524:	eb 01                	jmp    803527 <free_block+0x27b>
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
	{
		return;
  803526:	90                   	nop
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
}
  803527:	c9                   	leave  
  803528:	c3                   	ret    

00803529 <realloc_block_FF>:
//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
  803529:	55                   	push   %ebp
  80352a:	89 e5                	mov    %esp,%ebp
  80352c:	83 ec 38             	sub    $0x38,%esp
	//TODO: [PROJECT'24.MS1 - #08] [3] DYNAMIC ALLOCATOR - realloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(va == NULL && new_size == 0)
  80352f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803533:	75 10                	jne    803545 <realloc_block_FF+0x1c>
  803535:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803539:	75 0a                	jne    803545 <realloc_block_FF+0x1c>
	{
		return NULL;
  80353b:	b8 00 00 00 00       	mov    $0x0,%eax
  803540:	e9 8b 04 00 00       	jmp    8039d0 <realloc_block_FF+0x4a7>
	}

	if(new_size == 0)
  803545:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803549:	75 18                	jne    803563 <realloc_block_FF+0x3a>
	{
		free_block(va);
  80354b:	83 ec 0c             	sub    $0xc,%esp
  80354e:	ff 75 08             	pushl  0x8(%ebp)
  803551:	e8 56 fd ff ff       	call   8032ac <free_block>
  803556:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803559:	b8 00 00 00 00       	mov    $0x0,%eax
  80355e:	e9 6d 04 00 00       	jmp    8039d0 <realloc_block_FF+0x4a7>
	}

	if(va == NULL)
  803563:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803567:	75 13                	jne    80357c <realloc_block_FF+0x53>
	{
		return alloc_block_FF(new_size);
  803569:	83 ec 0c             	sub    $0xc,%esp
  80356c:	ff 75 0c             	pushl  0xc(%ebp)
  80356f:	e8 6f f6 ff ff       	call   802be3 <alloc_block_FF>
  803574:	83 c4 10             	add    $0x10,%esp
  803577:	e9 54 04 00 00       	jmp    8039d0 <realloc_block_FF+0x4a7>
	}

	// if size is odd must be increment it by one
	if (new_size % 2 != 0)
  80357c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80357f:	83 e0 01             	and    $0x1,%eax
  803582:	85 c0                	test   %eax,%eax
  803584:	74 03                	je     803589 <realloc_block_FF+0x60>
	{
		new_size++;
  803586:	ff 45 0c             	incl   0xc(%ebp)
	}

	// if size < 8 must be equal it to 8 because min size 8 excluding metadata
	if(new_size < 8)
  803589:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80358d:	77 07                	ja     803596 <realloc_block_FF+0x6d>
	{
		new_size = 8;
  80358f:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	}

	new_size += 8; // adds its footer and header size
  803596:	83 45 0c 08          	addl   $0x8,0xc(%ebp)

	uint32 actualSize = get_block_size(va);
  80359a:	83 ec 0c             	sub    $0xc,%esp
  80359d:	ff 75 08             	pushl  0x8(%ebp)
  8035a0:	e8 d8 f1 ff ff       	call   80277d <get_block_size>
  8035a5:	83 c4 10             	add    $0x10,%esp
  8035a8:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(actualSize == new_size)
  8035ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ae:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8035b1:	75 08                	jne    8035bb <realloc_block_FF+0x92>
	{
		// don't change any thing
		return va;
  8035b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b6:	e9 15 04 00 00       	jmp    8039d0 <realloc_block_FF+0x4a7>
	}

	// next block for the block we want to change its size
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + actualSize);
  8035bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8035be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c1:	01 d0                	add    %edx,%eax
  8035c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  8035c6:	83 ec 0c             	sub    $0xc,%esp
  8035c9:	ff 75 f0             	pushl  -0x10(%ebp)
  8035cc:	e8 c5 f1 ff ff       	call   802796 <is_free_block>
  8035d1:	83 c4 10             	add    $0x10,%esp
  8035d4:	0f be c0             	movsbl %al,%eax
  8035d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 nextSize = get_block_size(nextBlk);
  8035da:	83 ec 0c             	sub    $0xc,%esp
  8035dd:	ff 75 f0             	pushl  -0x10(%ebp)
  8035e0:	e8 98 f1 ff ff       	call   80277d <get_block_size>
  8035e5:	83 c4 10             	add    $0x10,%esp
  8035e8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// increase the size of block
	if(new_size > actualSize)
  8035eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035ee:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8035f1:	0f 86 a7 02 00 00    	jbe    80389e <realloc_block_FF+0x375>
	{
		if(isNextFree)
  8035f7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8035fb:	0f 84 86 02 00 00    	je     803887 <realloc_block_FF+0x35e>
		{
			if(nextSize + actualSize == new_size) // block and nextblock = newSizeBlock
  803601:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803604:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803607:	01 d0                	add    %edx,%eax
  803609:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80360c:	0f 85 b2 00 00 00    	jne    8036c4 <realloc_block_FF+0x19b>
			{
				set_block_data(va,new_size,!(is_free_block(va)));// update size in block
  803612:	83 ec 0c             	sub    $0xc,%esp
  803615:	ff 75 08             	pushl  0x8(%ebp)
  803618:	e8 79 f1 ff ff       	call   802796 <is_free_block>
  80361d:	83 c4 10             	add    $0x10,%esp
  803620:	84 c0                	test   %al,%al
  803622:	0f 94 c0             	sete   %al
  803625:	0f b6 c0             	movzbl %al,%eax
  803628:	83 ec 04             	sub    $0x4,%esp
  80362b:	50                   	push   %eax
  80362c:	ff 75 0c             	pushl  0xc(%ebp)
  80362f:	ff 75 08             	pushl  0x8(%ebp)
  803632:	e8 c2 f3 ff ff       	call   8029f9 <set_block_data>
  803637:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);// remove next because it is = zero
  80363a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80363e:	75 17                	jne    803657 <realloc_block_FF+0x12e>
  803640:	83 ec 04             	sub    $0x4,%esp
  803643:	68 54 47 80 00       	push   $0x804754
  803648:	68 db 01 00 00       	push   $0x1db
  80364d:	68 ab 46 80 00       	push   $0x8046ab
  803652:	e8 5f d1 ff ff       	call   8007b6 <_panic>
  803657:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80365a:	8b 00                	mov    (%eax),%eax
  80365c:	85 c0                	test   %eax,%eax
  80365e:	74 10                	je     803670 <realloc_block_FF+0x147>
  803660:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803663:	8b 00                	mov    (%eax),%eax
  803665:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803668:	8b 52 04             	mov    0x4(%edx),%edx
  80366b:	89 50 04             	mov    %edx,0x4(%eax)
  80366e:	eb 0b                	jmp    80367b <realloc_block_FF+0x152>
  803670:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803673:	8b 40 04             	mov    0x4(%eax),%eax
  803676:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80367b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80367e:	8b 40 04             	mov    0x4(%eax),%eax
  803681:	85 c0                	test   %eax,%eax
  803683:	74 0f                	je     803694 <realloc_block_FF+0x16b>
  803685:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803688:	8b 40 04             	mov    0x4(%eax),%eax
  80368b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80368e:	8b 12                	mov    (%edx),%edx
  803690:	89 10                	mov    %edx,(%eax)
  803692:	eb 0a                	jmp    80369e <realloc_block_FF+0x175>
  803694:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803697:	8b 00                	mov    (%eax),%eax
  803699:	a3 48 50 98 00       	mov    %eax,0x985048
  80369e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036aa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036b1:	a1 54 50 98 00       	mov    0x985054,%eax
  8036b6:	48                   	dec    %eax
  8036b7:	a3 54 50 98 00       	mov    %eax,0x985054
				return va;
  8036bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8036bf:	e9 0c 03 00 00       	jmp    8039d0 <realloc_block_FF+0x4a7>
			}
			else if(nextSize + actualSize > new_size) // new size is less than next and main blocks
  8036c4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ca:	01 d0                	add    %edx,%eax
  8036cc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8036cf:	0f 86 b2 01 00 00    	jbe    803887 <realloc_block_FF+0x35e>
			{
				uint32 requiredSize = new_size - actualSize; // size that we need from the next block
  8036d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036d8:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8036db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				uint32 remainingNext = nextSize - requiredSize; // size that will remain from the next block after we split it
  8036de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036e1:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8036e4:	89 45 e0             	mov    %eax,-0x20(%ebp)

				// if next size will not fit another block (internal fragmentation)
				if(remainingNext < 16)
  8036e7:	83 7d e0 0f          	cmpl   $0xf,-0x20(%ebp)
  8036eb:	0f 87 b8 00 00 00    	ja     8037a9 <realloc_block_FF+0x280>
				{
					// we will take the main size of the block and its next size also
					set_block_data(va,actualSize + nextSize,!(is_free_block(va)));
  8036f1:	83 ec 0c             	sub    $0xc,%esp
  8036f4:	ff 75 08             	pushl  0x8(%ebp)
  8036f7:	e8 9a f0 ff ff       	call   802796 <is_free_block>
  8036fc:	83 c4 10             	add    $0x10,%esp
  8036ff:	84 c0                	test   %al,%al
  803701:	0f 94 c0             	sete   %al
  803704:	0f b6 c0             	movzbl %al,%eax
  803707:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80370a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80370d:	01 ca                	add    %ecx,%edx
  80370f:	83 ec 04             	sub    $0x4,%esp
  803712:	50                   	push   %eax
  803713:	52                   	push   %edx
  803714:	ff 75 08             	pushl  0x8(%ebp)
  803717:	e8 dd f2 ff ff       	call   8029f9 <set_block_data>
  80371c:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,nextBlk);
  80371f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803723:	75 17                	jne    80373c <realloc_block_FF+0x213>
  803725:	83 ec 04             	sub    $0x4,%esp
  803728:	68 54 47 80 00       	push   $0x804754
  80372d:	68 e8 01 00 00       	push   $0x1e8
  803732:	68 ab 46 80 00       	push   $0x8046ab
  803737:	e8 7a d0 ff ff       	call   8007b6 <_panic>
  80373c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80373f:	8b 00                	mov    (%eax),%eax
  803741:	85 c0                	test   %eax,%eax
  803743:	74 10                	je     803755 <realloc_block_FF+0x22c>
  803745:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803748:	8b 00                	mov    (%eax),%eax
  80374a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80374d:	8b 52 04             	mov    0x4(%edx),%edx
  803750:	89 50 04             	mov    %edx,0x4(%eax)
  803753:	eb 0b                	jmp    803760 <realloc_block_FF+0x237>
  803755:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803758:	8b 40 04             	mov    0x4(%eax),%eax
  80375b:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803760:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803763:	8b 40 04             	mov    0x4(%eax),%eax
  803766:	85 c0                	test   %eax,%eax
  803768:	74 0f                	je     803779 <realloc_block_FF+0x250>
  80376a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80376d:	8b 40 04             	mov    0x4(%eax),%eax
  803770:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803773:	8b 12                	mov    (%edx),%edx
  803775:	89 10                	mov    %edx,(%eax)
  803777:	eb 0a                	jmp    803783 <realloc_block_FF+0x25a>
  803779:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80377c:	8b 00                	mov    (%eax),%eax
  80377e:	a3 48 50 98 00       	mov    %eax,0x985048
  803783:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803786:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80378c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80378f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803796:	a1 54 50 98 00       	mov    0x985054,%eax
  80379b:	48                   	dec    %eax
  80379c:	a3 54 50 98 00       	mov    %eax,0x985054
					return va;
  8037a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a4:	e9 27 02 00 00       	jmp    8039d0 <realloc_block_FF+0x4a7>
				}
				else // if next size can be fit another block (split)
				{
					LIST_REMOVE(&freeBlocksList,nextBlk);
  8037a9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8037ad:	75 17                	jne    8037c6 <realloc_block_FF+0x29d>
  8037af:	83 ec 04             	sub    $0x4,%esp
  8037b2:	68 54 47 80 00       	push   $0x804754
  8037b7:	68 ed 01 00 00       	push   $0x1ed
  8037bc:	68 ab 46 80 00       	push   $0x8046ab
  8037c1:	e8 f0 cf ff ff       	call   8007b6 <_panic>
  8037c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037c9:	8b 00                	mov    (%eax),%eax
  8037cb:	85 c0                	test   %eax,%eax
  8037cd:	74 10                	je     8037df <realloc_block_FF+0x2b6>
  8037cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037d2:	8b 00                	mov    (%eax),%eax
  8037d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037d7:	8b 52 04             	mov    0x4(%edx),%edx
  8037da:	89 50 04             	mov    %edx,0x4(%eax)
  8037dd:	eb 0b                	jmp    8037ea <realloc_block_FF+0x2c1>
  8037df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037e2:	8b 40 04             	mov    0x4(%eax),%eax
  8037e5:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8037ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037ed:	8b 40 04             	mov    0x4(%eax),%eax
  8037f0:	85 c0                	test   %eax,%eax
  8037f2:	74 0f                	je     803803 <realloc_block_FF+0x2da>
  8037f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037f7:	8b 40 04             	mov    0x4(%eax),%eax
  8037fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037fd:	8b 12                	mov    (%edx),%edx
  8037ff:	89 10                	mov    %edx,(%eax)
  803801:	eb 0a                	jmp    80380d <realloc_block_FF+0x2e4>
  803803:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803806:	8b 00                	mov    (%eax),%eax
  803808:	a3 48 50 98 00       	mov    %eax,0x985048
  80380d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803810:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803816:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803819:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803820:	a1 54 50 98 00       	mov    0x985054,%eax
  803825:	48                   	dec    %eax
  803826:	a3 54 50 98 00       	mov    %eax,0x985054
					nextBlk = (struct BlockElement *)((char *)va + new_size); //update nextBlk address
  80382b:	8b 55 08             	mov    0x8(%ebp),%edx
  80382e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803831:	01 d0                	add    %edx,%eax
  803833:	89 45 f0             	mov    %eax,-0x10(%ebp)
					set_block_data(nextBlk,remainingNext,0); // update nextBlkSize
  803836:	83 ec 04             	sub    $0x4,%esp
  803839:	6a 00                	push   $0x0
  80383b:	ff 75 e0             	pushl  -0x20(%ebp)
  80383e:	ff 75 f0             	pushl  -0x10(%ebp)
  803841:	e8 b3 f1 ff ff       	call   8029f9 <set_block_data>
  803846:	83 c4 10             	add    $0x10,%esp
					set_block_data(va,new_size,!(is_free_block(va))); // update size of newblock
  803849:	83 ec 0c             	sub    $0xc,%esp
  80384c:	ff 75 08             	pushl  0x8(%ebp)
  80384f:	e8 42 ef ff ff       	call   802796 <is_free_block>
  803854:	83 c4 10             	add    $0x10,%esp
  803857:	84 c0                	test   %al,%al
  803859:	0f 94 c0             	sete   %al
  80385c:	0f b6 c0             	movzbl %al,%eax
  80385f:	83 ec 04             	sub    $0x4,%esp
  803862:	50                   	push   %eax
  803863:	ff 75 0c             	pushl  0xc(%ebp)
  803866:	ff 75 08             	pushl  0x8(%ebp)
  803869:	e8 8b f1 ff ff       	call   8029f9 <set_block_data>
  80386e:	83 c4 10             	add    $0x10,%esp
					insert_sorted_in_freeList(nextBlk);
  803871:	83 ec 0c             	sub    $0xc,%esp
  803874:	ff 75 f0             	pushl  -0x10(%ebp)
  803877:	e8 d4 f1 ff ff       	call   802a50 <insert_sorted_in_freeList>
  80387c:	83 c4 10             	add    $0x10,%esp
					return va;
  80387f:	8b 45 08             	mov    0x8(%ebp),%eax
  803882:	e9 49 01 00 00       	jmp    8039d0 <realloc_block_FF+0x4a7>
				}
			}
		}
		// if next block isn't free or not fit the new size
		return alloc_block_FF(new_size - 8);
  803887:	8b 45 0c             	mov    0xc(%ebp),%eax
  80388a:	83 e8 08             	sub    $0x8,%eax
  80388d:	83 ec 0c             	sub    $0xc,%esp
  803890:	50                   	push   %eax
  803891:	e8 4d f3 ff ff       	call   802be3 <alloc_block_FF>
  803896:	83 c4 10             	add    $0x10,%esp
  803899:	e9 32 01 00 00       	jmp    8039d0 <realloc_block_FF+0x4a7>
	}
	else if(new_size < actualSize) // to shrink block
  80389e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038a1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8038a4:	0f 83 21 01 00 00    	jae    8039cb <realloc_block_FF+0x4a2>
	{
		uint32 remainingSize = actualSize - new_size; // size that will remain from the main block after we shrink it
  8038aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038ad:	2b 45 0c             	sub    0xc(%ebp),%eax
  8038b0:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(remainingSize < 16 && isNextFree == 0) // internal fragmentation
  8038b3:	83 7d dc 0f          	cmpl   $0xf,-0x24(%ebp)
  8038b7:	77 0e                	ja     8038c7 <realloc_block_FF+0x39e>
  8038b9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8038bd:	75 08                	jne    8038c7 <realloc_block_FF+0x39e>
		{
			// don't change its size
			return va;
  8038bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c2:	e9 09 01 00 00       	jmp    8039d0 <realloc_block_FF+0x4a7>
		}
		else // remainingSize fit in a new block
		{
			struct BlockElement *mainBlk = (struct BlockElement *)va;
  8038c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ca:	89 45 d8             	mov    %eax,-0x28(%ebp)
			// update main block with new size
			set_block_data(mainBlk,new_size,!(is_free_block(va)));
  8038cd:	83 ec 0c             	sub    $0xc,%esp
  8038d0:	ff 75 08             	pushl  0x8(%ebp)
  8038d3:	e8 be ee ff ff       	call   802796 <is_free_block>
  8038d8:	83 c4 10             	add    $0x10,%esp
  8038db:	84 c0                	test   %al,%al
  8038dd:	0f 94 c0             	sete   %al
  8038e0:	0f b6 c0             	movzbl %al,%eax
  8038e3:	83 ec 04             	sub    $0x4,%esp
  8038e6:	50                   	push   %eax
  8038e7:	ff 75 0c             	pushl  0xc(%ebp)
  8038ea:	ff 75 d8             	pushl  -0x28(%ebp)
  8038ed:	e8 07 f1 ff ff       	call   8029f9 <set_block_data>
  8038f2:	83 c4 10             	add    $0x10,%esp

			// the blk with remaining size
			struct BlockElement *remainingBlk=(struct BlockElement *)((char*)mainBlk + new_size);
  8038f5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8038f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038fb:	01 d0                	add    %edx,%eax
  8038fd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			set_block_data(remainingBlk,remainingSize,0);
  803900:	83 ec 04             	sub    $0x4,%esp
  803903:	6a 00                	push   $0x0
  803905:	ff 75 dc             	pushl  -0x24(%ebp)
  803908:	ff 75 d4             	pushl  -0x2c(%ebp)
  80390b:	e8 e9 f0 ff ff       	call   8029f9 <set_block_data>
  803910:	83 c4 10             	add    $0x10,%esp

			if(isNextFree)
  803913:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803917:	0f 84 9b 00 00 00    	je     8039b8 <realloc_block_FF+0x48f>
			{
				// merge splited block with its next block
				set_block_data(remainingBlk,(remainingSize + nextSize),0);//merge remaining with its next block
  80391d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803920:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803923:	01 d0                	add    %edx,%eax
  803925:	83 ec 04             	sub    $0x4,%esp
  803928:	6a 00                	push   $0x0
  80392a:	50                   	push   %eax
  80392b:	ff 75 d4             	pushl  -0x2c(%ebp)
  80392e:	e8 c6 f0 ff ff       	call   8029f9 <set_block_data>
  803933:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);
  803936:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80393a:	75 17                	jne    803953 <realloc_block_FF+0x42a>
  80393c:	83 ec 04             	sub    $0x4,%esp
  80393f:	68 54 47 80 00       	push   $0x804754
  803944:	68 10 02 00 00       	push   $0x210
  803949:	68 ab 46 80 00       	push   $0x8046ab
  80394e:	e8 63 ce ff ff       	call   8007b6 <_panic>
  803953:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803956:	8b 00                	mov    (%eax),%eax
  803958:	85 c0                	test   %eax,%eax
  80395a:	74 10                	je     80396c <realloc_block_FF+0x443>
  80395c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80395f:	8b 00                	mov    (%eax),%eax
  803961:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803964:	8b 52 04             	mov    0x4(%edx),%edx
  803967:	89 50 04             	mov    %edx,0x4(%eax)
  80396a:	eb 0b                	jmp    803977 <realloc_block_FF+0x44e>
  80396c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80396f:	8b 40 04             	mov    0x4(%eax),%eax
  803972:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803977:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80397a:	8b 40 04             	mov    0x4(%eax),%eax
  80397d:	85 c0                	test   %eax,%eax
  80397f:	74 0f                	je     803990 <realloc_block_FF+0x467>
  803981:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803984:	8b 40 04             	mov    0x4(%eax),%eax
  803987:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80398a:	8b 12                	mov    (%edx),%edx
  80398c:	89 10                	mov    %edx,(%eax)
  80398e:	eb 0a                	jmp    80399a <realloc_block_FF+0x471>
  803990:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803993:	8b 00                	mov    (%eax),%eax
  803995:	a3 48 50 98 00       	mov    %eax,0x985048
  80399a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80399d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039a6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039ad:	a1 54 50 98 00       	mov    0x985054,%eax
  8039b2:	48                   	dec    %eax
  8039b3:	a3 54 50 98 00       	mov    %eax,0x985054
			}
			insert_sorted_in_freeList(remainingBlk);
  8039b8:	83 ec 0c             	sub    $0xc,%esp
  8039bb:	ff 75 d4             	pushl  -0x2c(%ebp)
  8039be:	e8 8d f0 ff ff       	call   802a50 <insert_sorted_in_freeList>
  8039c3:	83 c4 10             	add    $0x10,%esp
			return mainBlk;
  8039c6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8039c9:	eb 05                	jmp    8039d0 <realloc_block_FF+0x4a7>
		}
	}
	return NULL;
  8039cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8039d0:	c9                   	leave  
  8039d1:	c3                   	ret    

008039d2 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8039d2:	55                   	push   %ebp
  8039d3:	89 e5                	mov    %esp,%ebp
  8039d5:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8039d8:	83 ec 04             	sub    $0x4,%esp
  8039db:	68 74 47 80 00       	push   $0x804774
  8039e0:	68 20 02 00 00       	push   $0x220
  8039e5:	68 ab 46 80 00       	push   $0x8046ab
  8039ea:	e8 c7 cd ff ff       	call   8007b6 <_panic>

008039ef <alloc_block_NF>:
}
//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8039ef:	55                   	push   %ebp
  8039f0:	89 e5                	mov    %esp,%ebp
  8039f2:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8039f5:	83 ec 04             	sub    $0x4,%esp
  8039f8:	68 9c 47 80 00       	push   $0x80479c
  8039fd:	68 28 02 00 00       	push   $0x228
  803a02:	68 ab 46 80 00       	push   $0x8046ab
  803a07:	e8 aa cd ff ff       	call   8007b6 <_panic>

00803a0c <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  803a0c:	55                   	push   %ebp
  803a0d:	89 e5                	mov    %esp,%ebp
  803a0f:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("create_semaphore is not implemented yet");
	//Your Code is Here...

	//create object of __semdata struct and allocate it using smalloc with sizeof __semdata struct
	struct __semdata* semaphoryData = (struct __semdata *)smalloc(semaphoreName , sizeof(struct __semdata) ,1);
  803a12:	83 ec 04             	sub    $0x4,%esp
  803a15:	6a 01                	push   $0x1
  803a17:	6a 58                	push   $0x58
  803a19:	ff 75 0c             	pushl  0xc(%ebp)
  803a1c:	e8 c1 e2 ff ff       	call   801ce2 <smalloc>
  803a21:	83 c4 10             	add    $0x10,%esp
  803a24:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(semaphoryData == NULL)
  803a27:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a2b:	75 14                	jne    803a41 <create_semaphore+0x35>
	{
		panic("Not Enough Space to allocate semdata object!!");
  803a2d:	83 ec 04             	sub    $0x4,%esp
  803a30:	68 c4 47 80 00       	push   $0x8047c4
  803a35:	6a 10                	push   $0x10
  803a37:	68 f2 47 80 00       	push   $0x8047f2
  803a3c:	e8 75 cd ff ff       	call   8007b6 <_panic>
	}
	//aboveObject.queue pass it to init_queue() function
	sys_init_queue(&(semaphoryData->queue));
  803a41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a44:	83 ec 0c             	sub    $0xc,%esp
  803a47:	50                   	push   %eax
  803a48:	e8 bc ec ff ff       	call   802709 <sys_init_queue>
  803a4d:	83 c4 10             	add    $0x10,%esp
	//lock variable initially with zero
	semaphoryData->lock = 0;
  803a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a53:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
	//initialize aboveObject with semaphore name and value
	strncpy(semaphoryData->name , semaphoreName , sizeof(semaphoryData->name));
  803a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a5d:	83 c0 18             	add    $0x18,%eax
  803a60:	83 ec 04             	sub    $0x4,%esp
  803a63:	6a 40                	push   $0x40
  803a65:	ff 75 0c             	pushl  0xc(%ebp)
  803a68:	50                   	push   %eax
  803a69:	e8 1e d9 ff ff       	call   80138c <strncpy>
  803a6e:	83 c4 10             	add    $0x10,%esp
	semaphoryData->count = value;
  803a71:	8b 55 10             	mov    0x10(%ebp),%edx
  803a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a77:	89 50 10             	mov    %edx,0x10(%eax)

	//create object of semaphore struct
	struct semaphore semaphory;
	//add aboveObject to this semaphore object
	semaphory.semdata = semaphoryData;
  803a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//return semaphore object
	return semaphory;
  803a80:	8b 45 08             	mov    0x8(%ebp),%eax
  803a83:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a86:	89 10                	mov    %edx,(%eax)
}
  803a88:	8b 45 08             	mov    0x8(%ebp),%eax
  803a8b:	c9                   	leave  
  803a8c:	c2 04 00             	ret    $0x4

00803a8f <get_semaphore>:
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  803a8f:	55                   	push   %ebp
  803a90:	89 e5                	mov    %esp,%ebp
  803a92:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("get_semaphore is not implemented yet");
	//Your Code is Here...

	// get the semdata object that is allocated, using sget
	struct __semdata* semaphoryData = sget(ownerEnvID, semaphoreName);
  803a95:	83 ec 08             	sub    $0x8,%esp
  803a98:	ff 75 10             	pushl  0x10(%ebp)
  803a9b:	ff 75 0c             	pushl  0xc(%ebp)
  803a9e:	e8 da e3 ff ff       	call   801e7d <sget>
  803aa3:	83 c4 10             	add    $0x10,%esp
  803aa6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(semaphoryData == NULL)
  803aa9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803aad:	75 14                	jne    803ac3 <get_semaphore+0x34>
	{
		panic("semdatat object does not exist!!");
  803aaf:	83 ec 04             	sub    $0x4,%esp
  803ab2:	68 04 48 80 00       	push   $0x804804
  803ab7:	6a 2c                	push   $0x2c
  803ab9:	68 f2 47 80 00       	push   $0x8047f2
  803abe:	e8 f3 cc ff ff       	call   8007b6 <_panic>
	}
	//create object of semaphore struct
	struct semaphore semaphory;
	//add semdata object to this semaphore object
	semaphory.semdata = semaphoryData;
  803ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ac6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	return semaphory;
  803ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  803acc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803acf:	89 10                	mov    %edx,(%eax)
}
  803ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  803ad4:	c9                   	leave  
  803ad5:	c2 04 00             	ret    $0x4

00803ad8 <wait_semaphore>:

void wait_semaphore(struct semaphore sem)
{
  803ad8:	55                   	push   %ebp
  803ad9:	89 e5                	mov    %esp,%ebp
  803adb:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("wait_semaphore is not implemented yet");
	//Your Code is Here...

	//acquire semaphore lock
	uint32 myKey = 1;
  803ade:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	do
	{
		xchg(&myKey, sem.semdata->lock); // xchg atomically exchanges values
  803ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  803ae8:	8b 40 14             	mov    0x14(%eax),%eax
  803aeb:	8d 55 e8             	lea    -0x18(%ebp),%edx
  803aee:	89 55 f4             	mov    %edx,-0xc(%ebp)
  803af1:	89 45 f0             	mov    %eax,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  803af4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803af7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803afa:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803afd:	f0 87 02             	lock xchg %eax,(%edx)
  803b00:	89 45 ec             	mov    %eax,-0x14(%ebp)
	} while (myKey != 0);
  803b03:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b06:	85 c0                	test   %eax,%eax
  803b08:	75 db                	jne    803ae5 <wait_semaphore+0xd>

	//decrement the semaphore counter
	sem.semdata->count--;
  803b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  803b0d:	8b 50 10             	mov    0x10(%eax),%edx
  803b10:	4a                   	dec    %edx
  803b11:	89 50 10             	mov    %edx,0x10(%eax)

	if (sem.semdata->count < 0)
  803b14:	8b 45 08             	mov    0x8(%ebp),%eax
  803b17:	8b 40 10             	mov    0x10(%eax),%eax
  803b1a:	85 c0                	test   %eax,%eax
  803b1c:	79 18                	jns    803b36 <wait_semaphore+0x5e>
	{
		// block the current process
		sys_block_process(&(sem.semdata->queue),&(sem.semdata->lock));
  803b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  803b21:	8d 50 14             	lea    0x14(%eax),%edx
  803b24:	8b 45 08             	mov    0x8(%ebp),%eax
  803b27:	83 ec 08             	sub    $0x8,%esp
  803b2a:	52                   	push   %edx
  803b2b:	50                   	push   %eax
  803b2c:	e8 f4 eb ff ff       	call   802725 <sys_block_process>
  803b31:	83 c4 10             	add    $0x10,%esp
  803b34:	eb 0a                	jmp    803b40 <wait_semaphore+0x68>
		return;
	}
	//release semaphore lock
	sem.semdata->lock = 0;
  803b36:	8b 45 08             	mov    0x8(%ebp),%eax
  803b39:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
}
  803b40:	c9                   	leave  
  803b41:	c3                   	ret    

00803b42 <signal_semaphore>:

void signal_semaphore(struct semaphore sem)
{
  803b42:	55                   	push   %ebp
  803b43:	89 e5                	mov    %esp,%ebp
  803b45:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("signal_semaphore is not implemented yet");
	//Your Code is Here...

	//acquire semaphore lock
	uint32 myKey = 1;
  803b48:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	do
	{
		xchg(&myKey, sem.semdata->lock); // xchg atomically exchanges values
  803b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  803b52:	8b 40 14             	mov    0x14(%eax),%eax
  803b55:	8d 55 e8             	lea    -0x18(%ebp),%edx
  803b58:	89 55 f4             	mov    %edx,-0xc(%ebp)
  803b5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803b5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b64:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803b67:	f0 87 02             	lock xchg %eax,(%edx)
  803b6a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	} while (myKey != 0);
  803b6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b70:	85 c0                	test   %eax,%eax
  803b72:	75 db                	jne    803b4f <signal_semaphore+0xd>

	// increment the semaphore counter
	sem.semdata->count++;
  803b74:	8b 45 08             	mov    0x8(%ebp),%eax
  803b77:	8b 50 10             	mov    0x10(%eax),%edx
  803b7a:	42                   	inc    %edx
  803b7b:	89 50 10             	mov    %edx,0x10(%eax)

	if (sem.semdata->count <= 0) {
  803b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  803b81:	8b 40 10             	mov    0x10(%eax),%eax
  803b84:	85 c0                	test   %eax,%eax
  803b86:	7f 0f                	jg     803b97 <signal_semaphore+0x55>
		// unblock the current process
		sys_unblock_process(&(sem.semdata->queue));
  803b88:	8b 45 08             	mov    0x8(%ebp),%eax
  803b8b:	83 ec 0c             	sub    $0xc,%esp
  803b8e:	50                   	push   %eax
  803b8f:	e8 af eb ff ff       	call   802743 <sys_unblock_process>
  803b94:	83 c4 10             	add    $0x10,%esp
	}

	// release the lock
	sem.semdata->lock = 0;
  803b97:	8b 45 08             	mov    0x8(%ebp),%eax
  803b9a:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
}
  803ba1:	90                   	nop
  803ba2:	c9                   	leave  
  803ba3:	c3                   	ret    

00803ba4 <semaphore_count>:

int semaphore_count(struct semaphore sem)
{
  803ba4:	55                   	push   %ebp
  803ba5:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  803ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  803baa:	8b 40 10             	mov    0x10(%eax),%eax
}
  803bad:	5d                   	pop    %ebp
  803bae:	c3                   	ret    
  803baf:	90                   	nop

00803bb0 <__udivdi3>:
  803bb0:	55                   	push   %ebp
  803bb1:	57                   	push   %edi
  803bb2:	56                   	push   %esi
  803bb3:	53                   	push   %ebx
  803bb4:	83 ec 1c             	sub    $0x1c,%esp
  803bb7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803bbb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803bbf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803bc3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803bc7:	89 ca                	mov    %ecx,%edx
  803bc9:	89 f8                	mov    %edi,%eax
  803bcb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803bcf:	85 f6                	test   %esi,%esi
  803bd1:	75 2d                	jne    803c00 <__udivdi3+0x50>
  803bd3:	39 cf                	cmp    %ecx,%edi
  803bd5:	77 65                	ja     803c3c <__udivdi3+0x8c>
  803bd7:	89 fd                	mov    %edi,%ebp
  803bd9:	85 ff                	test   %edi,%edi
  803bdb:	75 0b                	jne    803be8 <__udivdi3+0x38>
  803bdd:	b8 01 00 00 00       	mov    $0x1,%eax
  803be2:	31 d2                	xor    %edx,%edx
  803be4:	f7 f7                	div    %edi
  803be6:	89 c5                	mov    %eax,%ebp
  803be8:	31 d2                	xor    %edx,%edx
  803bea:	89 c8                	mov    %ecx,%eax
  803bec:	f7 f5                	div    %ebp
  803bee:	89 c1                	mov    %eax,%ecx
  803bf0:	89 d8                	mov    %ebx,%eax
  803bf2:	f7 f5                	div    %ebp
  803bf4:	89 cf                	mov    %ecx,%edi
  803bf6:	89 fa                	mov    %edi,%edx
  803bf8:	83 c4 1c             	add    $0x1c,%esp
  803bfb:	5b                   	pop    %ebx
  803bfc:	5e                   	pop    %esi
  803bfd:	5f                   	pop    %edi
  803bfe:	5d                   	pop    %ebp
  803bff:	c3                   	ret    
  803c00:	39 ce                	cmp    %ecx,%esi
  803c02:	77 28                	ja     803c2c <__udivdi3+0x7c>
  803c04:	0f bd fe             	bsr    %esi,%edi
  803c07:	83 f7 1f             	xor    $0x1f,%edi
  803c0a:	75 40                	jne    803c4c <__udivdi3+0x9c>
  803c0c:	39 ce                	cmp    %ecx,%esi
  803c0e:	72 0a                	jb     803c1a <__udivdi3+0x6a>
  803c10:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803c14:	0f 87 9e 00 00 00    	ja     803cb8 <__udivdi3+0x108>
  803c1a:	b8 01 00 00 00       	mov    $0x1,%eax
  803c1f:	89 fa                	mov    %edi,%edx
  803c21:	83 c4 1c             	add    $0x1c,%esp
  803c24:	5b                   	pop    %ebx
  803c25:	5e                   	pop    %esi
  803c26:	5f                   	pop    %edi
  803c27:	5d                   	pop    %ebp
  803c28:	c3                   	ret    
  803c29:	8d 76 00             	lea    0x0(%esi),%esi
  803c2c:	31 ff                	xor    %edi,%edi
  803c2e:	31 c0                	xor    %eax,%eax
  803c30:	89 fa                	mov    %edi,%edx
  803c32:	83 c4 1c             	add    $0x1c,%esp
  803c35:	5b                   	pop    %ebx
  803c36:	5e                   	pop    %esi
  803c37:	5f                   	pop    %edi
  803c38:	5d                   	pop    %ebp
  803c39:	c3                   	ret    
  803c3a:	66 90                	xchg   %ax,%ax
  803c3c:	89 d8                	mov    %ebx,%eax
  803c3e:	f7 f7                	div    %edi
  803c40:	31 ff                	xor    %edi,%edi
  803c42:	89 fa                	mov    %edi,%edx
  803c44:	83 c4 1c             	add    $0x1c,%esp
  803c47:	5b                   	pop    %ebx
  803c48:	5e                   	pop    %esi
  803c49:	5f                   	pop    %edi
  803c4a:	5d                   	pop    %ebp
  803c4b:	c3                   	ret    
  803c4c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803c51:	89 eb                	mov    %ebp,%ebx
  803c53:	29 fb                	sub    %edi,%ebx
  803c55:	89 f9                	mov    %edi,%ecx
  803c57:	d3 e6                	shl    %cl,%esi
  803c59:	89 c5                	mov    %eax,%ebp
  803c5b:	88 d9                	mov    %bl,%cl
  803c5d:	d3 ed                	shr    %cl,%ebp
  803c5f:	89 e9                	mov    %ebp,%ecx
  803c61:	09 f1                	or     %esi,%ecx
  803c63:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803c67:	89 f9                	mov    %edi,%ecx
  803c69:	d3 e0                	shl    %cl,%eax
  803c6b:	89 c5                	mov    %eax,%ebp
  803c6d:	89 d6                	mov    %edx,%esi
  803c6f:	88 d9                	mov    %bl,%cl
  803c71:	d3 ee                	shr    %cl,%esi
  803c73:	89 f9                	mov    %edi,%ecx
  803c75:	d3 e2                	shl    %cl,%edx
  803c77:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c7b:	88 d9                	mov    %bl,%cl
  803c7d:	d3 e8                	shr    %cl,%eax
  803c7f:	09 c2                	or     %eax,%edx
  803c81:	89 d0                	mov    %edx,%eax
  803c83:	89 f2                	mov    %esi,%edx
  803c85:	f7 74 24 0c          	divl   0xc(%esp)
  803c89:	89 d6                	mov    %edx,%esi
  803c8b:	89 c3                	mov    %eax,%ebx
  803c8d:	f7 e5                	mul    %ebp
  803c8f:	39 d6                	cmp    %edx,%esi
  803c91:	72 19                	jb     803cac <__udivdi3+0xfc>
  803c93:	74 0b                	je     803ca0 <__udivdi3+0xf0>
  803c95:	89 d8                	mov    %ebx,%eax
  803c97:	31 ff                	xor    %edi,%edi
  803c99:	e9 58 ff ff ff       	jmp    803bf6 <__udivdi3+0x46>
  803c9e:	66 90                	xchg   %ax,%ax
  803ca0:	8b 54 24 08          	mov    0x8(%esp),%edx
  803ca4:	89 f9                	mov    %edi,%ecx
  803ca6:	d3 e2                	shl    %cl,%edx
  803ca8:	39 c2                	cmp    %eax,%edx
  803caa:	73 e9                	jae    803c95 <__udivdi3+0xe5>
  803cac:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803caf:	31 ff                	xor    %edi,%edi
  803cb1:	e9 40 ff ff ff       	jmp    803bf6 <__udivdi3+0x46>
  803cb6:	66 90                	xchg   %ax,%ax
  803cb8:	31 c0                	xor    %eax,%eax
  803cba:	e9 37 ff ff ff       	jmp    803bf6 <__udivdi3+0x46>
  803cbf:	90                   	nop

00803cc0 <__umoddi3>:
  803cc0:	55                   	push   %ebp
  803cc1:	57                   	push   %edi
  803cc2:	56                   	push   %esi
  803cc3:	53                   	push   %ebx
  803cc4:	83 ec 1c             	sub    $0x1c,%esp
  803cc7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803ccb:	8b 74 24 34          	mov    0x34(%esp),%esi
  803ccf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803cd3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803cd7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803cdb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803cdf:	89 f3                	mov    %esi,%ebx
  803ce1:	89 fa                	mov    %edi,%edx
  803ce3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ce7:	89 34 24             	mov    %esi,(%esp)
  803cea:	85 c0                	test   %eax,%eax
  803cec:	75 1a                	jne    803d08 <__umoddi3+0x48>
  803cee:	39 f7                	cmp    %esi,%edi
  803cf0:	0f 86 a2 00 00 00    	jbe    803d98 <__umoddi3+0xd8>
  803cf6:	89 c8                	mov    %ecx,%eax
  803cf8:	89 f2                	mov    %esi,%edx
  803cfa:	f7 f7                	div    %edi
  803cfc:	89 d0                	mov    %edx,%eax
  803cfe:	31 d2                	xor    %edx,%edx
  803d00:	83 c4 1c             	add    $0x1c,%esp
  803d03:	5b                   	pop    %ebx
  803d04:	5e                   	pop    %esi
  803d05:	5f                   	pop    %edi
  803d06:	5d                   	pop    %ebp
  803d07:	c3                   	ret    
  803d08:	39 f0                	cmp    %esi,%eax
  803d0a:	0f 87 ac 00 00 00    	ja     803dbc <__umoddi3+0xfc>
  803d10:	0f bd e8             	bsr    %eax,%ebp
  803d13:	83 f5 1f             	xor    $0x1f,%ebp
  803d16:	0f 84 ac 00 00 00    	je     803dc8 <__umoddi3+0x108>
  803d1c:	bf 20 00 00 00       	mov    $0x20,%edi
  803d21:	29 ef                	sub    %ebp,%edi
  803d23:	89 fe                	mov    %edi,%esi
  803d25:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803d29:	89 e9                	mov    %ebp,%ecx
  803d2b:	d3 e0                	shl    %cl,%eax
  803d2d:	89 d7                	mov    %edx,%edi
  803d2f:	89 f1                	mov    %esi,%ecx
  803d31:	d3 ef                	shr    %cl,%edi
  803d33:	09 c7                	or     %eax,%edi
  803d35:	89 e9                	mov    %ebp,%ecx
  803d37:	d3 e2                	shl    %cl,%edx
  803d39:	89 14 24             	mov    %edx,(%esp)
  803d3c:	89 d8                	mov    %ebx,%eax
  803d3e:	d3 e0                	shl    %cl,%eax
  803d40:	89 c2                	mov    %eax,%edx
  803d42:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d46:	d3 e0                	shl    %cl,%eax
  803d48:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d4c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d50:	89 f1                	mov    %esi,%ecx
  803d52:	d3 e8                	shr    %cl,%eax
  803d54:	09 d0                	or     %edx,%eax
  803d56:	d3 eb                	shr    %cl,%ebx
  803d58:	89 da                	mov    %ebx,%edx
  803d5a:	f7 f7                	div    %edi
  803d5c:	89 d3                	mov    %edx,%ebx
  803d5e:	f7 24 24             	mull   (%esp)
  803d61:	89 c6                	mov    %eax,%esi
  803d63:	89 d1                	mov    %edx,%ecx
  803d65:	39 d3                	cmp    %edx,%ebx
  803d67:	0f 82 87 00 00 00    	jb     803df4 <__umoddi3+0x134>
  803d6d:	0f 84 91 00 00 00    	je     803e04 <__umoddi3+0x144>
  803d73:	8b 54 24 04          	mov    0x4(%esp),%edx
  803d77:	29 f2                	sub    %esi,%edx
  803d79:	19 cb                	sbb    %ecx,%ebx
  803d7b:	89 d8                	mov    %ebx,%eax
  803d7d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803d81:	d3 e0                	shl    %cl,%eax
  803d83:	89 e9                	mov    %ebp,%ecx
  803d85:	d3 ea                	shr    %cl,%edx
  803d87:	09 d0                	or     %edx,%eax
  803d89:	89 e9                	mov    %ebp,%ecx
  803d8b:	d3 eb                	shr    %cl,%ebx
  803d8d:	89 da                	mov    %ebx,%edx
  803d8f:	83 c4 1c             	add    $0x1c,%esp
  803d92:	5b                   	pop    %ebx
  803d93:	5e                   	pop    %esi
  803d94:	5f                   	pop    %edi
  803d95:	5d                   	pop    %ebp
  803d96:	c3                   	ret    
  803d97:	90                   	nop
  803d98:	89 fd                	mov    %edi,%ebp
  803d9a:	85 ff                	test   %edi,%edi
  803d9c:	75 0b                	jne    803da9 <__umoddi3+0xe9>
  803d9e:	b8 01 00 00 00       	mov    $0x1,%eax
  803da3:	31 d2                	xor    %edx,%edx
  803da5:	f7 f7                	div    %edi
  803da7:	89 c5                	mov    %eax,%ebp
  803da9:	89 f0                	mov    %esi,%eax
  803dab:	31 d2                	xor    %edx,%edx
  803dad:	f7 f5                	div    %ebp
  803daf:	89 c8                	mov    %ecx,%eax
  803db1:	f7 f5                	div    %ebp
  803db3:	89 d0                	mov    %edx,%eax
  803db5:	e9 44 ff ff ff       	jmp    803cfe <__umoddi3+0x3e>
  803dba:	66 90                	xchg   %ax,%ax
  803dbc:	89 c8                	mov    %ecx,%eax
  803dbe:	89 f2                	mov    %esi,%edx
  803dc0:	83 c4 1c             	add    $0x1c,%esp
  803dc3:	5b                   	pop    %ebx
  803dc4:	5e                   	pop    %esi
  803dc5:	5f                   	pop    %edi
  803dc6:	5d                   	pop    %ebp
  803dc7:	c3                   	ret    
  803dc8:	3b 04 24             	cmp    (%esp),%eax
  803dcb:	72 06                	jb     803dd3 <__umoddi3+0x113>
  803dcd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803dd1:	77 0f                	ja     803de2 <__umoddi3+0x122>
  803dd3:	89 f2                	mov    %esi,%edx
  803dd5:	29 f9                	sub    %edi,%ecx
  803dd7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803ddb:	89 14 24             	mov    %edx,(%esp)
  803dde:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803de2:	8b 44 24 04          	mov    0x4(%esp),%eax
  803de6:	8b 14 24             	mov    (%esp),%edx
  803de9:	83 c4 1c             	add    $0x1c,%esp
  803dec:	5b                   	pop    %ebx
  803ded:	5e                   	pop    %esi
  803dee:	5f                   	pop    %edi
  803def:	5d                   	pop    %ebp
  803df0:	c3                   	ret    
  803df1:	8d 76 00             	lea    0x0(%esi),%esi
  803df4:	2b 04 24             	sub    (%esp),%eax
  803df7:	19 fa                	sbb    %edi,%edx
  803df9:	89 d1                	mov    %edx,%ecx
  803dfb:	89 c6                	mov    %eax,%esi
  803dfd:	e9 71 ff ff ff       	jmp    803d73 <__umoddi3+0xb3>
  803e02:	66 90                	xchg   %ax,%ax
  803e04:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803e08:	72 ea                	jb     803df4 <__umoddi3+0x134>
  803e0a:	89 d9                	mov    %ebx,%ecx
  803e0c:	e9 62 ff ff ff       	jmp    803d73 <__umoddi3+0xb3>
