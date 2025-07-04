
obj/user/mergesort_static:     file format elf32-i386


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
  800031:	e8 d5 06 00 00       	call   80070b <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void Merge(int* A, int p, int q, int r);

uint32 CheckSorted(int *Elements, int NumOfElements);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 28 01 00 00    	sub    $0x128,%esp
	char Line[255] ;
	char Chose ;
	int numOfRep = 0;
  800041:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	do
	{
		numOfRep++ ;
  800048:	ff 45 f0             	incl   -0x10(%ebp)
		//2012: lock the interrupt
		sys_lock_cons();
  80004b:	e8 c4 18 00 00       	call   801914 <sys_lock_cons>

		cprintf("\n");
  800050:	83 ec 0c             	sub    $0xc,%esp
  800053:	68 c0 21 80 00       	push   $0x8021c0
  800058:	e8 b0 0a 00 00       	call   800b0d <cprintf>
  80005d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800060:	83 ec 0c             	sub    $0xc,%esp
  800063:	68 c2 21 80 00       	push   $0x8021c2
  800068:	e8 a0 0a 00 00       	call   800b0d <cprintf>
  80006d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800070:	83 ec 0c             	sub    $0xc,%esp
  800073:	68 d8 21 80 00       	push   $0x8021d8
  800078:	e8 90 0a 00 00       	call   800b0d <cprintf>
  80007d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800080:	83 ec 0c             	sub    $0xc,%esp
  800083:	68 c2 21 80 00       	push   $0x8021c2
  800088:	e8 80 0a 00 00       	call   800b0d <cprintf>
  80008d:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800090:	83 ec 0c             	sub    $0xc,%esp
  800093:	68 c0 21 80 00       	push   $0x8021c0
  800098:	e8 70 0a 00 00       	call   800b0d <cprintf>
  80009d:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = 800000;
  8000a0:	c7 45 ec 00 35 0c 00 	movl   $0xc3500,-0x14(%ebp)
		cprintf("Enter the number of elements: %d\n", NumOfElements) ;
  8000a7:	83 ec 08             	sub    $0x8,%esp
  8000aa:	ff 75 ec             	pushl  -0x14(%ebp)
  8000ad:	68 f0 21 80 00       	push   $0x8021f0
  8000b2:	e8 56 0a 00 00       	call   800b0d <cprintf>
  8000b7:	83 c4 10             	add    $0x10,%esp

		cprintf("Chose the initialization method:\n") ;
  8000ba:	83 ec 0c             	sub    $0xc,%esp
  8000bd:	68 14 22 80 00       	push   $0x802214
  8000c2:	e8 46 0a 00 00       	call   800b0d <cprintf>
  8000c7:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000ca:	83 ec 0c             	sub    $0xc,%esp
  8000cd:	68 36 22 80 00       	push   $0x802236
  8000d2:	e8 36 0a 00 00       	call   800b0d <cprintf>
  8000d7:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000da:	83 ec 0c             	sub    $0xc,%esp
  8000dd:	68 44 22 80 00       	push   $0x802244
  8000e2:	e8 26 0a 00 00       	call   800b0d <cprintf>
  8000e7:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  8000ea:	83 ec 0c             	sub    $0xc,%esp
  8000ed:	68 53 22 80 00       	push   $0x802253
  8000f2:	e8 16 0a 00 00       	call   800b0d <cprintf>
  8000f7:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  8000fa:	83 ec 0c             	sub    $0xc,%esp
  8000fd:	68 63 22 80 00       	push   $0x802263
  800102:	e8 06 0a 00 00       	call   800b0d <cprintf>
  800107:	83 c4 10             	add    $0x10,%esp
			Chose = 'c' ;
  80010a:	c6 45 f7 63          	movb   $0x63,-0x9(%ebp)
			cputchar(Chose);
  80010e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800112:	83 ec 0c             	sub    $0xc,%esp
  800115:	50                   	push   %eax
  800116:	e8 b4 05 00 00       	call   8006cf <cputchar>
  80011b:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	6a 0a                	push   $0xa
  800123:	e8 a7 05 00 00       	call   8006cf <cputchar>
  800128:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  80012b:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  80012f:	74 0c                	je     80013d <_main+0x105>
  800131:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  800135:	74 06                	je     80013d <_main+0x105>
  800137:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  80013b:	75 bd                	jne    8000fa <_main+0xc2>

		//2012: lock the interrupt
		sys_unlock_cons();
  80013d:	e8 ec 17 00 00       	call   80192e <sys_unlock_cons>

		//int *Elements = malloc(sizeof(int) * NumOfElements) ;
		int *Elements = __Elements;
  800142:	c7 45 e8 60 04 b1 00 	movl   $0xb10460,-0x18(%ebp)
		int  i ;
		switch (Chose)
  800149:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80014d:	83 f8 62             	cmp    $0x62,%eax
  800150:	74 1d                	je     80016f <_main+0x137>
  800152:	83 f8 63             	cmp    $0x63,%eax
  800155:	74 2b                	je     800182 <_main+0x14a>
  800157:	83 f8 61             	cmp    $0x61,%eax
  80015a:	75 39                	jne    800195 <_main+0x15d>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  80015c:	83 ec 08             	sub    $0x8,%esp
  80015f:	ff 75 ec             	pushl  -0x14(%ebp)
  800162:	ff 75 e8             	pushl  -0x18(%ebp)
  800165:	e8 e7 01 00 00       	call   800351 <InitializeAscending>
  80016a:	83 c4 10             	add    $0x10,%esp
			break ;
  80016d:	eb 37                	jmp    8001a6 <_main+0x16e>
		case 'b':
			InitializeIdentical(Elements, NumOfElements);
  80016f:	83 ec 08             	sub    $0x8,%esp
  800172:	ff 75 ec             	pushl  -0x14(%ebp)
  800175:	ff 75 e8             	pushl  -0x18(%ebp)
  800178:	e8 05 02 00 00       	call   800382 <InitializeIdentical>
  80017d:	83 c4 10             	add    $0x10,%esp
			break ;
  800180:	eb 24                	jmp    8001a6 <_main+0x16e>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  800182:	83 ec 08             	sub    $0x8,%esp
  800185:	ff 75 ec             	pushl  -0x14(%ebp)
  800188:	ff 75 e8             	pushl  -0x18(%ebp)
  80018b:	e8 27 02 00 00       	call   8003b7 <InitializeSemiRandom>
  800190:	83 c4 10             	add    $0x10,%esp
			break ;
  800193:	eb 11                	jmp    8001a6 <_main+0x16e>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  800195:	83 ec 08             	sub    $0x8,%esp
  800198:	ff 75 ec             	pushl  -0x14(%ebp)
  80019b:	ff 75 e8             	pushl  -0x18(%ebp)
  80019e:	e8 14 02 00 00       	call   8003b7 <InitializeSemiRandom>
  8001a3:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001a6:	83 ec 04             	sub    $0x4,%esp
  8001a9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ac:	6a 01                	push   $0x1
  8001ae:	ff 75 e8             	pushl  -0x18(%ebp)
  8001b1:	e8 e0 02 00 00       	call   800496 <MSort>
  8001b6:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001b9:	e8 56 17 00 00       	call   801914 <sys_lock_cons>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001be:	83 ec 0c             	sub    $0xc,%esp
  8001c1:	68 6c 22 80 00       	push   $0x80226c
  8001c6:	e8 42 09 00 00       	call   800b0d <cprintf>
  8001cb:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_unlock_cons();
  8001ce:	e8 5b 17 00 00       	call   80192e <sys_unlock_cons>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001d3:	83 ec 08             	sub    $0x8,%esp
  8001d6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001d9:	ff 75 e8             	pushl  -0x18(%ebp)
  8001dc:	e8 c6 00 00 00       	call   8002a7 <CheckSorted>
  8001e1:	83 c4 10             	add    $0x10,%esp
  8001e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001e7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8001eb:	75 14                	jne    800201 <_main+0x1c9>
  8001ed:	83 ec 04             	sub    $0x4,%esp
  8001f0:	68 a0 22 80 00       	push   $0x8022a0
  8001f5:	6a 51                	push   $0x51
  8001f7:	68 c2 22 80 00       	push   $0x8022c2
  8001fc:	e8 4f 06 00 00       	call   800850 <_panic>
		else
		{
			sys_lock_cons();
  800201:	e8 0e 17 00 00       	call   801914 <sys_lock_cons>
			cprintf("===============================================\n") ;
  800206:	83 ec 0c             	sub    $0xc,%esp
  800209:	68 dc 22 80 00       	push   $0x8022dc
  80020e:	e8 fa 08 00 00       	call   800b0d <cprintf>
  800213:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800216:	83 ec 0c             	sub    $0xc,%esp
  800219:	68 10 23 80 00       	push   $0x802310
  80021e:	e8 ea 08 00 00       	call   800b0d <cprintf>
  800223:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800226:	83 ec 0c             	sub    $0xc,%esp
  800229:	68 44 23 80 00       	push   $0x802344
  80022e:	e8 da 08 00 00       	call   800b0d <cprintf>
  800233:	83 c4 10             	add    $0x10,%esp
			sys_unlock_cons();
  800236:	e8 f3 16 00 00       	call   80192e <sys_unlock_cons>
		}

		//free(Elements) ;

		sys_lock_cons();
  80023b:	e8 d4 16 00 00       	call   801914 <sys_lock_cons>
		Chose = 0 ;
  800240:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
		while (Chose != 'y' && Chose != 'n')
  800244:	eb 3e                	jmp    800284 <_main+0x24c>
		{
			cprintf("Do you want to repeat (y/n): ") ;
  800246:	83 ec 0c             	sub    $0xc,%esp
  800249:	68 76 23 80 00       	push   $0x802376
  80024e:	e8 ba 08 00 00       	call   800b0d <cprintf>
  800253:	83 c4 10             	add    $0x10,%esp
			Chose = 'n' ;
  800256:	c6 45 f7 6e          	movb   $0x6e,-0x9(%ebp)
			cputchar(Chose);
  80025a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80025e:	83 ec 0c             	sub    $0xc,%esp
  800261:	50                   	push   %eax
  800262:	e8 68 04 00 00       	call   8006cf <cputchar>
  800267:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  80026a:	83 ec 0c             	sub    $0xc,%esp
  80026d:	6a 0a                	push   $0xa
  80026f:	e8 5b 04 00 00       	call   8006cf <cputchar>
  800274:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800277:	83 ec 0c             	sub    $0xc,%esp
  80027a:	6a 0a                	push   $0xa
  80027c:	e8 4e 04 00 00       	call   8006cf <cputchar>
  800281:	83 c4 10             	add    $0x10,%esp

		//free(Elements) ;

		sys_lock_cons();
		Chose = 0 ;
		while (Chose != 'y' && Chose != 'n')
  800284:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  800288:	74 06                	je     800290 <_main+0x258>
  80028a:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  80028e:	75 b6                	jne    800246 <_main+0x20e>
			Chose = 'n' ;
			cputchar(Chose);
			cputchar('\n');
			cputchar('\n');
		}
		sys_unlock_cons();
  800290:	e8 99 16 00 00       	call   80192e <sys_unlock_cons>

	} while (Chose == 'y');
  800295:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  800299:	0f 84 a9 fd ff ff    	je     800048 <_main+0x10>

	//To indicate that it's completed successfully
	inctst();
  80029f:	e8 2a 1a 00 00       	call   801cce <inctst>

}
  8002a4:	90                   	nop
  8002a5:	c9                   	leave  
  8002a6:	c3                   	ret    

008002a7 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8002a7:	55                   	push   %ebp
  8002a8:	89 e5                	mov    %esp,%ebp
  8002aa:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8002ad:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8002b4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8002bb:	eb 33                	jmp    8002f0 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8002bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002c0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ca:	01 d0                	add    %edx,%eax
  8002cc:	8b 10                	mov    (%eax),%edx
  8002ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002d1:	40                   	inc    %eax
  8002d2:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8002dc:	01 c8                	add    %ecx,%eax
  8002de:	8b 00                	mov    (%eax),%eax
  8002e0:	39 c2                	cmp    %eax,%edx
  8002e2:	7e 09                	jle    8002ed <CheckSorted+0x46>
		{
			Sorted = 0 ;
  8002e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  8002eb:	eb 0c                	jmp    8002f9 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8002ed:	ff 45 f8             	incl   -0x8(%ebp)
  8002f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f3:	48                   	dec    %eax
  8002f4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8002f7:	7f c4                	jg     8002bd <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  8002f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8002fc:	c9                   	leave  
  8002fd:	c3                   	ret    

008002fe <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  8002fe:	55                   	push   %ebp
  8002ff:	89 e5                	mov    %esp,%ebp
  800301:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800304:	8b 45 0c             	mov    0xc(%ebp),%eax
  800307:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80030e:	8b 45 08             	mov    0x8(%ebp),%eax
  800311:	01 d0                	add    %edx,%eax
  800313:	8b 00                	mov    (%eax),%eax
  800315:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800318:	8b 45 0c             	mov    0xc(%ebp),%eax
  80031b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800322:	8b 45 08             	mov    0x8(%ebp),%eax
  800325:	01 c2                	add    %eax,%edx
  800327:	8b 45 10             	mov    0x10(%ebp),%eax
  80032a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800331:	8b 45 08             	mov    0x8(%ebp),%eax
  800334:	01 c8                	add    %ecx,%eax
  800336:	8b 00                	mov    (%eax),%eax
  800338:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  80033a:	8b 45 10             	mov    0x10(%ebp),%eax
  80033d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800344:	8b 45 08             	mov    0x8(%ebp),%eax
  800347:	01 c2                	add    %eax,%edx
  800349:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80034c:	89 02                	mov    %eax,(%edx)
}
  80034e:	90                   	nop
  80034f:	c9                   	leave  
  800350:	c3                   	ret    

00800351 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  800351:	55                   	push   %ebp
  800352:	89 e5                	mov    %esp,%ebp
  800354:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800357:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80035e:	eb 17                	jmp    800377 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  800360:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800363:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80036a:	8b 45 08             	mov    0x8(%ebp),%eax
  80036d:	01 c2                	add    %eax,%edx
  80036f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800372:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800374:	ff 45 fc             	incl   -0x4(%ebp)
  800377:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80037a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80037d:	7c e1                	jl     800360 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  80037f:	90                   	nop
  800380:	c9                   	leave  
  800381:	c3                   	ret    

00800382 <InitializeIdentical>:

void InitializeIdentical(int *Elements, int NumOfElements)
{
  800382:	55                   	push   %ebp
  800383:	89 e5                	mov    %esp,%ebp
  800385:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800388:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80038f:	eb 1b                	jmp    8003ac <InitializeIdentical+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  800391:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800394:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80039b:	8b 45 08             	mov    0x8(%ebp),%eax
  80039e:	01 c2                	add    %eax,%edx
  8003a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a3:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8003a6:	48                   	dec    %eax
  8003a7:	89 02                	mov    %eax,(%edx)
}

void InitializeIdentical(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003a9:	ff 45 fc             	incl   -0x4(%ebp)
  8003ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003af:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003b2:	7c dd                	jl     800391 <InitializeIdentical+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8003b4:	90                   	nop
  8003b5:	c9                   	leave  
  8003b6:	c3                   	ret    

008003b7 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8003b7:	55                   	push   %ebp
  8003b8:	89 e5                	mov    %esp,%ebp
  8003ba:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8003bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003c0:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8003c5:	f7 e9                	imul   %ecx
  8003c7:	c1 f9 1f             	sar    $0x1f,%ecx
  8003ca:	89 d0                	mov    %edx,%eax
  8003cc:	29 c8                	sub    %ecx,%eax
  8003ce:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (Repetition == 0)
  8003d1:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8003d5:	75 07                	jne    8003de <InitializeSemiRandom+0x27>
			Repetition = 3;
  8003d7:	c7 45 f8 03 00 00 00 	movl   $0x3,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8003de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003e5:	eb 1e                	jmp    800405 <InitializeSemiRandom+0x4e>
	{
		Elements[i] = i % Repetition ;
  8003e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003ea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f4:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8003f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003fa:	99                   	cltd   
  8003fb:	f7 7d f8             	idivl  -0x8(%ebp)
  8003fe:	89 d0                	mov    %edx,%eax
  800400:	89 01                	mov    %eax,(%ecx)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	if (Repetition == 0)
			Repetition = 3;
	for (i = 0 ; i < NumOfElements ; i++)
  800402:	ff 45 fc             	incl   -0x4(%ebp)
  800405:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800408:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80040b:	7c da                	jl     8003e7 <InitializeSemiRandom+0x30>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  80040d:	90                   	nop
  80040e:	c9                   	leave  
  80040f:	c3                   	ret    

00800410 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800410:	55                   	push   %ebp
  800411:	89 e5                	mov    %esp,%ebp
  800413:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800416:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80041d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800424:	eb 42                	jmp    800468 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800426:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800429:	99                   	cltd   
  80042a:	f7 7d f0             	idivl  -0x10(%ebp)
  80042d:	89 d0                	mov    %edx,%eax
  80042f:	85 c0                	test   %eax,%eax
  800431:	75 10                	jne    800443 <PrintElements+0x33>
			cprintf("\n");
  800433:	83 ec 0c             	sub    $0xc,%esp
  800436:	68 c0 21 80 00       	push   $0x8021c0
  80043b:	e8 cd 06 00 00       	call   800b0d <cprintf>
  800440:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800446:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80044d:	8b 45 08             	mov    0x8(%ebp),%eax
  800450:	01 d0                	add    %edx,%eax
  800452:	8b 00                	mov    (%eax),%eax
  800454:	83 ec 08             	sub    $0x8,%esp
  800457:	50                   	push   %eax
  800458:	68 94 23 80 00       	push   $0x802394
  80045d:	e8 ab 06 00 00       	call   800b0d <cprintf>
  800462:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800465:	ff 45 f4             	incl   -0xc(%ebp)
  800468:	8b 45 0c             	mov    0xc(%ebp),%eax
  80046b:	48                   	dec    %eax
  80046c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80046f:	7f b5                	jg     800426 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800471:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800474:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80047b:	8b 45 08             	mov    0x8(%ebp),%eax
  80047e:	01 d0                	add    %edx,%eax
  800480:	8b 00                	mov    (%eax),%eax
  800482:	83 ec 08             	sub    $0x8,%esp
  800485:	50                   	push   %eax
  800486:	68 99 23 80 00       	push   $0x802399
  80048b:	e8 7d 06 00 00       	call   800b0d <cprintf>
  800490:	83 c4 10             	add    $0x10,%esp

}
  800493:	90                   	nop
  800494:	c9                   	leave  
  800495:	c3                   	ret    

00800496 <MSort>:


void MSort(int* A, int p, int r)
{
  800496:	55                   	push   %ebp
  800497:	89 e5                	mov    %esp,%ebp
  800499:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  80049c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80049f:	3b 45 10             	cmp    0x10(%ebp),%eax
  8004a2:	7d 54                	jge    8004f8 <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  8004a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8004aa:	01 d0                	add    %edx,%eax
  8004ac:	89 c2                	mov    %eax,%edx
  8004ae:	c1 ea 1f             	shr    $0x1f,%edx
  8004b1:	01 d0                	add    %edx,%eax
  8004b3:	d1 f8                	sar    %eax
  8004b5:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  8004b8:	83 ec 04             	sub    $0x4,%esp
  8004bb:	ff 75 f4             	pushl  -0xc(%ebp)
  8004be:	ff 75 0c             	pushl  0xc(%ebp)
  8004c1:	ff 75 08             	pushl  0x8(%ebp)
  8004c4:	e8 cd ff ff ff       	call   800496 <MSort>
  8004c9:	83 c4 10             	add    $0x10,%esp

	MSort(A, q + 1, r);
  8004cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004cf:	40                   	inc    %eax
  8004d0:	83 ec 04             	sub    $0x4,%esp
  8004d3:	ff 75 10             	pushl  0x10(%ebp)
  8004d6:	50                   	push   %eax
  8004d7:	ff 75 08             	pushl  0x8(%ebp)
  8004da:	e8 b7 ff ff ff       	call   800496 <MSort>
  8004df:	83 c4 10             	add    $0x10,%esp

	Merge(A, p, q, r);
  8004e2:	ff 75 10             	pushl  0x10(%ebp)
  8004e5:	ff 75 f4             	pushl  -0xc(%ebp)
  8004e8:	ff 75 0c             	pushl  0xc(%ebp)
  8004eb:	ff 75 08             	pushl  0x8(%ebp)
  8004ee:	e8 08 00 00 00       	call   8004fb <Merge>
  8004f3:	83 c4 10             	add    $0x10,%esp
  8004f6:	eb 01                	jmp    8004f9 <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  8004f8:	90                   	nop

	MSort(A, q + 1, r);

	Merge(A, p, q, r);

}
  8004f9:	c9                   	leave  
  8004fa:	c3                   	ret    

008004fb <Merge>:

void Merge(int* A, int p, int q, int r)
{
  8004fb:	55                   	push   %ebp
  8004fc:	89 e5                	mov    %esp,%ebp
  8004fe:	83 ec 30             	sub    $0x30,%esp
	int leftCapacity = q - p + 1;
  800501:	8b 45 10             	mov    0x10(%ebp),%eax
  800504:	2b 45 0c             	sub    0xc(%ebp),%eax
  800507:	40                   	inc    %eax
  800508:	89 45 e8             	mov    %eax,-0x18(%ebp)

	int rightCapacity = r - q;
  80050b:	8b 45 14             	mov    0x14(%ebp),%eax
  80050e:	2b 45 10             	sub    0x10(%ebp),%eax
  800511:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	int leftIndex = 0;
  800514:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

	int rightIndex = 0;
  80051b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	//int* Left = malloc(sizeof(int) * leftCapacity);
	int* Left = __Left ;
  800522:	c7 45 e0 40 30 80 00 	movl   $0x803040,-0x20(%ebp)
	int* Right = __Right;
  800529:	c7 45 dc 60 d8 e1 00 	movl   $0xe1d860,-0x24(%ebp)

	//	int Left[5000] ;
	//	int Right[5000] ;

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  800530:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800537:	eb 2f                	jmp    800568 <Merge+0x6d>
	{
		Left[i] = A[p + i - 1];
  800539:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80053c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800543:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800546:	01 c2                	add    %eax,%edx
  800548:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80054b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80054e:	01 c8                	add    %ecx,%eax
  800550:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800555:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80055c:	8b 45 08             	mov    0x8(%ebp),%eax
  80055f:	01 c8                	add    %ecx,%eax
  800561:	8b 00                	mov    (%eax),%eax
  800563:	89 02                	mov    %eax,(%edx)

	//	int Left[5000] ;
	//	int Right[5000] ;

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  800565:	ff 45 f4             	incl   -0xc(%ebp)
  800568:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80056b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80056e:	7c c9                	jl     800539 <Merge+0x3e>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  800570:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800577:	eb 2a                	jmp    8005a3 <Merge+0xa8>
	{
		Right[j] = A[q + j];
  800579:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80057c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800583:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800586:	01 c2                	add    %eax,%edx
  800588:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80058b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80058e:	01 c8                	add    %ecx,%eax
  800590:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800597:	8b 45 08             	mov    0x8(%ebp),%eax
  80059a:	01 c8                	add    %ecx,%eax
  80059c:	8b 00                	mov    (%eax),%eax
  80059e:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005a0:	ff 45 f0             	incl   -0x10(%ebp)
  8005a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005a6:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8005a9:	7c ce                	jl     800579 <Merge+0x7e>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8005ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8005b1:	e9 0a 01 00 00       	jmp    8006c0 <Merge+0x1c5>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  8005b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8005b9:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8005bc:	0f 8d 95 00 00 00    	jge    800657 <Merge+0x15c>
  8005c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8005c5:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8005c8:	0f 8d 89 00 00 00    	jge    800657 <Merge+0x15c>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8005ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8005d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005db:	01 d0                	add    %edx,%eax
  8005dd:	8b 10                	mov    (%eax),%edx
  8005df:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8005e2:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005ec:	01 c8                	add    %ecx,%eax
  8005ee:	8b 00                	mov    (%eax),%eax
  8005f0:	39 c2                	cmp    %eax,%edx
  8005f2:	7d 33                	jge    800627 <Merge+0x12c>
			{
				A[k - 1] = Left[leftIndex++];
  8005f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005f7:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8005fc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800603:	8b 45 08             	mov    0x8(%ebp),%eax
  800606:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800609:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80060c:	8d 50 01             	lea    0x1(%eax),%edx
  80060f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800612:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800619:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80061c:	01 d0                	add    %edx,%eax
  80061e:	8b 00                	mov    (%eax),%eax
  800620:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800622:	e9 96 00 00 00       	jmp    8006bd <Merge+0x1c2>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  800627:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80062a:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80062f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800636:	8b 45 08             	mov    0x8(%ebp),%eax
  800639:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80063c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80063f:	8d 50 01             	lea    0x1(%eax),%edx
  800642:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800645:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80064c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80064f:	01 d0                	add    %edx,%eax
  800651:	8b 00                	mov    (%eax),%eax
  800653:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800655:	eb 66                	jmp    8006bd <Merge+0x1c2>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  800657:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80065a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80065d:	7d 30                	jge    80068f <Merge+0x194>
		{
			A[k - 1] = Left[leftIndex++];
  80065f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800662:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800667:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80066e:	8b 45 08             	mov    0x8(%ebp),%eax
  800671:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800674:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800677:	8d 50 01             	lea    0x1(%eax),%edx
  80067a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80067d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800684:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800687:	01 d0                	add    %edx,%eax
  800689:	8b 00                	mov    (%eax),%eax
  80068b:	89 01                	mov    %eax,(%ecx)
  80068d:	eb 2e                	jmp    8006bd <Merge+0x1c2>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  80068f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800692:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800697:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80069e:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a1:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8006a7:	8d 50 01             	lea    0x1(%eax),%edx
  8006aa:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8006ad:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006b7:	01 d0                	add    %edx,%eax
  8006b9:	8b 00                	mov    (%eax),%eax
  8006bb:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8006bd:	ff 45 ec             	incl   -0x14(%ebp)
  8006c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006c3:	3b 45 14             	cmp    0x14(%ebp),%eax
  8006c6:	0f 8e ea fe ff ff    	jle    8005b6 <Merge+0xbb>
		{
			A[k - 1] = Right[rightIndex++];
		}
	}

}
  8006cc:	90                   	nop
  8006cd:	c9                   	leave  
  8006ce:	c3                   	ret    

008006cf <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8006cf:	55                   	push   %ebp
  8006d0:	89 e5                	mov    %esp,%ebp
  8006d2:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8006d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d8:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8006db:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8006df:	83 ec 0c             	sub    $0xc,%esp
  8006e2:	50                   	push   %eax
  8006e3:	e8 77 13 00 00       	call   801a5f <sys_cputc>
  8006e8:	83 c4 10             	add    $0x10,%esp
}
  8006eb:	90                   	nop
  8006ec:	c9                   	leave  
  8006ed:	c3                   	ret    

008006ee <getchar>:


int
getchar(void)
{
  8006ee:	55                   	push   %ebp
  8006ef:	89 e5                	mov    %esp,%ebp
  8006f1:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  8006f4:	e8 02 12 00 00       	call   8018fb <sys_cgetc>
  8006f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  8006fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8006ff:	c9                   	leave  
  800700:	c3                   	ret    

00800701 <iscons>:

int iscons(int fdnum)
{
  800701:	55                   	push   %ebp
  800702:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800704:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800709:	5d                   	pop    %ebp
  80070a:	c3                   	ret    

0080070b <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80070b:	55                   	push   %ebp
  80070c:	89 e5                	mov    %esp,%ebp
  80070e:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800711:	e8 7a 14 00 00       	call   801b90 <sys_getenvindex>
  800716:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800719:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80071c:	89 d0                	mov    %edx,%eax
  80071e:	c1 e0 02             	shl    $0x2,%eax
  800721:	01 d0                	add    %edx,%eax
  800723:	c1 e0 03             	shl    $0x3,%eax
  800726:	01 d0                	add    %edx,%eax
  800728:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80072f:	01 d0                	add    %edx,%eax
  800731:	c1 e0 02             	shl    $0x2,%eax
  800734:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800739:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80073e:	a1 20 30 80 00       	mov    0x803020,%eax
  800743:	8a 40 20             	mov    0x20(%eax),%al
  800746:	84 c0                	test   %al,%al
  800748:	74 0d                	je     800757 <libmain+0x4c>
		binaryname = myEnv->prog_name;
  80074a:	a1 20 30 80 00       	mov    0x803020,%eax
  80074f:	83 c0 20             	add    $0x20,%eax
  800752:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800757:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80075b:	7e 0a                	jle    800767 <libmain+0x5c>
		binaryname = argv[0];
  80075d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800760:	8b 00                	mov    (%eax),%eax
  800762:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  800767:	83 ec 08             	sub    $0x8,%esp
  80076a:	ff 75 0c             	pushl  0xc(%ebp)
  80076d:	ff 75 08             	pushl  0x8(%ebp)
  800770:	e8 c3 f8 ff ff       	call   800038 <_main>
  800775:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800778:	a1 00 30 80 00       	mov    0x803000,%eax
  80077d:	85 c0                	test   %eax,%eax
  80077f:	0f 84 9f 00 00 00    	je     800824 <libmain+0x119>
	{
		sys_lock_cons();
  800785:	e8 8a 11 00 00       	call   801914 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80078a:	83 ec 0c             	sub    $0xc,%esp
  80078d:	68 b8 23 80 00       	push   $0x8023b8
  800792:	e8 76 03 00 00       	call   800b0d <cprintf>
  800797:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80079a:	a1 20 30 80 00       	mov    0x803020,%eax
  80079f:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8007a5:	a1 20 30 80 00       	mov    0x803020,%eax
  8007aa:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8007b0:	83 ec 04             	sub    $0x4,%esp
  8007b3:	52                   	push   %edx
  8007b4:	50                   	push   %eax
  8007b5:	68 e0 23 80 00       	push   $0x8023e0
  8007ba:	e8 4e 03 00 00       	call   800b0d <cprintf>
  8007bf:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8007c2:	a1 20 30 80 00       	mov    0x803020,%eax
  8007c7:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8007cd:	a1 20 30 80 00       	mov    0x803020,%eax
  8007d2:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8007d8:	a1 20 30 80 00       	mov    0x803020,%eax
  8007dd:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  8007e3:	51                   	push   %ecx
  8007e4:	52                   	push   %edx
  8007e5:	50                   	push   %eax
  8007e6:	68 08 24 80 00       	push   $0x802408
  8007eb:	e8 1d 03 00 00       	call   800b0d <cprintf>
  8007f0:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8007f3:	a1 20 30 80 00       	mov    0x803020,%eax
  8007f8:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8007fe:	83 ec 08             	sub    $0x8,%esp
  800801:	50                   	push   %eax
  800802:	68 60 24 80 00       	push   $0x802460
  800807:	e8 01 03 00 00       	call   800b0d <cprintf>
  80080c:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80080f:	83 ec 0c             	sub    $0xc,%esp
  800812:	68 b8 23 80 00       	push   $0x8023b8
  800817:	e8 f1 02 00 00       	call   800b0d <cprintf>
  80081c:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80081f:	e8 0a 11 00 00       	call   80192e <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800824:	e8 19 00 00 00       	call   800842 <exit>
}
  800829:	90                   	nop
  80082a:	c9                   	leave  
  80082b:	c3                   	ret    

0080082c <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80082c:	55                   	push   %ebp
  80082d:	89 e5                	mov    %esp,%ebp
  80082f:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800832:	83 ec 0c             	sub    $0xc,%esp
  800835:	6a 00                	push   $0x0
  800837:	e8 20 13 00 00       	call   801b5c <sys_destroy_env>
  80083c:	83 c4 10             	add    $0x10,%esp
}
  80083f:	90                   	nop
  800840:	c9                   	leave  
  800841:	c3                   	ret    

00800842 <exit>:

void
exit(void)
{
  800842:	55                   	push   %ebp
  800843:	89 e5                	mov    %esp,%ebp
  800845:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800848:	e8 75 13 00 00       	call   801bc2 <sys_exit_env>
}
  80084d:	90                   	nop
  80084e:	c9                   	leave  
  80084f:	c3                   	ret    

00800850 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800850:	55                   	push   %ebp
  800851:	89 e5                	mov    %esp,%ebp
  800853:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800856:	8d 45 10             	lea    0x10(%ebp),%eax
  800859:	83 c0 04             	add    $0x4,%eax
  80085c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80085f:	a1 64 ac 12 01       	mov    0x112ac64,%eax
  800864:	85 c0                	test   %eax,%eax
  800866:	74 16                	je     80087e <_panic+0x2e>
		cprintf("%s: ", argv0);
  800868:	a1 64 ac 12 01       	mov    0x112ac64,%eax
  80086d:	83 ec 08             	sub    $0x8,%esp
  800870:	50                   	push   %eax
  800871:	68 74 24 80 00       	push   $0x802474
  800876:	e8 92 02 00 00       	call   800b0d <cprintf>
  80087b:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80087e:	a1 04 30 80 00       	mov    0x803004,%eax
  800883:	ff 75 0c             	pushl  0xc(%ebp)
  800886:	ff 75 08             	pushl  0x8(%ebp)
  800889:	50                   	push   %eax
  80088a:	68 79 24 80 00       	push   $0x802479
  80088f:	e8 79 02 00 00       	call   800b0d <cprintf>
  800894:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800897:	8b 45 10             	mov    0x10(%ebp),%eax
  80089a:	83 ec 08             	sub    $0x8,%esp
  80089d:	ff 75 f4             	pushl  -0xc(%ebp)
  8008a0:	50                   	push   %eax
  8008a1:	e8 fc 01 00 00       	call   800aa2 <vcprintf>
  8008a6:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8008a9:	83 ec 08             	sub    $0x8,%esp
  8008ac:	6a 00                	push   $0x0
  8008ae:	68 95 24 80 00       	push   $0x802495
  8008b3:	e8 ea 01 00 00       	call   800aa2 <vcprintf>
  8008b8:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8008bb:	e8 82 ff ff ff       	call   800842 <exit>

	// should not return here
	while (1) ;
  8008c0:	eb fe                	jmp    8008c0 <_panic+0x70>

008008c2 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8008c2:	55                   	push   %ebp
  8008c3:	89 e5                	mov    %esp,%ebp
  8008c5:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8008c8:	a1 20 30 80 00       	mov    0x803020,%eax
  8008cd:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8008d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d6:	39 c2                	cmp    %eax,%edx
  8008d8:	74 14                	je     8008ee <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8008da:	83 ec 04             	sub    $0x4,%esp
  8008dd:	68 98 24 80 00       	push   $0x802498
  8008e2:	6a 26                	push   $0x26
  8008e4:	68 e4 24 80 00       	push   $0x8024e4
  8008e9:	e8 62 ff ff ff       	call   800850 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8008ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8008f5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8008fc:	e9 c5 00 00 00       	jmp    8009c6 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800901:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800904:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80090b:	8b 45 08             	mov    0x8(%ebp),%eax
  80090e:	01 d0                	add    %edx,%eax
  800910:	8b 00                	mov    (%eax),%eax
  800912:	85 c0                	test   %eax,%eax
  800914:	75 08                	jne    80091e <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800916:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800919:	e9 a5 00 00 00       	jmp    8009c3 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80091e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800925:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80092c:	eb 69                	jmp    800997 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80092e:	a1 20 30 80 00       	mov    0x803020,%eax
  800933:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800939:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80093c:	89 d0                	mov    %edx,%eax
  80093e:	01 c0                	add    %eax,%eax
  800940:	01 d0                	add    %edx,%eax
  800942:	c1 e0 03             	shl    $0x3,%eax
  800945:	01 c8                	add    %ecx,%eax
  800947:	8a 40 04             	mov    0x4(%eax),%al
  80094a:	84 c0                	test   %al,%al
  80094c:	75 46                	jne    800994 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80094e:	a1 20 30 80 00       	mov    0x803020,%eax
  800953:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800959:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80095c:	89 d0                	mov    %edx,%eax
  80095e:	01 c0                	add    %eax,%eax
  800960:	01 d0                	add    %edx,%eax
  800962:	c1 e0 03             	shl    $0x3,%eax
  800965:	01 c8                	add    %ecx,%eax
  800967:	8b 00                	mov    (%eax),%eax
  800969:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80096c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80096f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800974:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800976:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800979:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800980:	8b 45 08             	mov    0x8(%ebp),%eax
  800983:	01 c8                	add    %ecx,%eax
  800985:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800987:	39 c2                	cmp    %eax,%edx
  800989:	75 09                	jne    800994 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80098b:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800992:	eb 15                	jmp    8009a9 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800994:	ff 45 e8             	incl   -0x18(%ebp)
  800997:	a1 20 30 80 00       	mov    0x803020,%eax
  80099c:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8009a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8009a5:	39 c2                	cmp    %eax,%edx
  8009a7:	77 85                	ja     80092e <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8009a9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8009ad:	75 14                	jne    8009c3 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8009af:	83 ec 04             	sub    $0x4,%esp
  8009b2:	68 f0 24 80 00       	push   $0x8024f0
  8009b7:	6a 3a                	push   $0x3a
  8009b9:	68 e4 24 80 00       	push   $0x8024e4
  8009be:	e8 8d fe ff ff       	call   800850 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8009c3:	ff 45 f0             	incl   -0x10(%ebp)
  8009c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009c9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8009cc:	0f 8c 2f ff ff ff    	jl     800901 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8009d2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009d9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8009e0:	eb 26                	jmp    800a08 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8009e2:	a1 20 30 80 00       	mov    0x803020,%eax
  8009e7:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8009ed:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009f0:	89 d0                	mov    %edx,%eax
  8009f2:	01 c0                	add    %eax,%eax
  8009f4:	01 d0                	add    %edx,%eax
  8009f6:	c1 e0 03             	shl    $0x3,%eax
  8009f9:	01 c8                	add    %ecx,%eax
  8009fb:	8a 40 04             	mov    0x4(%eax),%al
  8009fe:	3c 01                	cmp    $0x1,%al
  800a00:	75 03                	jne    800a05 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800a02:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a05:	ff 45 e0             	incl   -0x20(%ebp)
  800a08:	a1 20 30 80 00       	mov    0x803020,%eax
  800a0d:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800a13:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a16:	39 c2                	cmp    %eax,%edx
  800a18:	77 c8                	ja     8009e2 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800a1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a1d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800a20:	74 14                	je     800a36 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800a22:	83 ec 04             	sub    $0x4,%esp
  800a25:	68 44 25 80 00       	push   $0x802544
  800a2a:	6a 44                	push   $0x44
  800a2c:	68 e4 24 80 00       	push   $0x8024e4
  800a31:	e8 1a fe ff ff       	call   800850 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800a36:	90                   	nop
  800a37:	c9                   	leave  
  800a38:	c3                   	ret    

00800a39 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800a39:	55                   	push   %ebp
  800a3a:	89 e5                	mov    %esp,%ebp
  800a3c:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800a3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a42:	8b 00                	mov    (%eax),%eax
  800a44:	8d 48 01             	lea    0x1(%eax),%ecx
  800a47:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a4a:	89 0a                	mov    %ecx,(%edx)
  800a4c:	8b 55 08             	mov    0x8(%ebp),%edx
  800a4f:	88 d1                	mov    %dl,%cl
  800a51:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a54:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800a58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a5b:	8b 00                	mov    (%eax),%eax
  800a5d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800a62:	75 2c                	jne    800a90 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800a64:	a0 40 04 b1 00       	mov    0xb10440,%al
  800a69:	0f b6 c0             	movzbl %al,%eax
  800a6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a6f:	8b 12                	mov    (%edx),%edx
  800a71:	89 d1                	mov    %edx,%ecx
  800a73:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a76:	83 c2 08             	add    $0x8,%edx
  800a79:	83 ec 04             	sub    $0x4,%esp
  800a7c:	50                   	push   %eax
  800a7d:	51                   	push   %ecx
  800a7e:	52                   	push   %edx
  800a7f:	e8 4e 0e 00 00       	call   8018d2 <sys_cputs>
  800a84:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800a87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800a90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a93:	8b 40 04             	mov    0x4(%eax),%eax
  800a96:	8d 50 01             	lea    0x1(%eax),%edx
  800a99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a9c:	89 50 04             	mov    %edx,0x4(%eax)
}
  800a9f:	90                   	nop
  800aa0:	c9                   	leave  
  800aa1:	c3                   	ret    

00800aa2 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800aa2:	55                   	push   %ebp
  800aa3:	89 e5                	mov    %esp,%ebp
  800aa5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800aab:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800ab2:	00 00 00 
	b.cnt = 0;
  800ab5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800abc:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800abf:	ff 75 0c             	pushl  0xc(%ebp)
  800ac2:	ff 75 08             	pushl  0x8(%ebp)
  800ac5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800acb:	50                   	push   %eax
  800acc:	68 39 0a 80 00       	push   $0x800a39
  800ad1:	e8 11 02 00 00       	call   800ce7 <vprintfmt>
  800ad6:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800ad9:	a0 40 04 b1 00       	mov    0xb10440,%al
  800ade:	0f b6 c0             	movzbl %al,%eax
  800ae1:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800ae7:	83 ec 04             	sub    $0x4,%esp
  800aea:	50                   	push   %eax
  800aeb:	52                   	push   %edx
  800aec:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800af2:	83 c0 08             	add    $0x8,%eax
  800af5:	50                   	push   %eax
  800af6:	e8 d7 0d 00 00       	call   8018d2 <sys_cputs>
  800afb:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800afe:	c6 05 40 04 b1 00 00 	movb   $0x0,0xb10440
	return b.cnt;
  800b05:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800b0b:	c9                   	leave  
  800b0c:	c3                   	ret    

00800b0d <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800b0d:	55                   	push   %ebp
  800b0e:	89 e5                	mov    %esp,%ebp
  800b10:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800b13:	c6 05 40 04 b1 00 01 	movb   $0x1,0xb10440
	va_start(ap, fmt);
  800b1a:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b20:	8b 45 08             	mov    0x8(%ebp),%eax
  800b23:	83 ec 08             	sub    $0x8,%esp
  800b26:	ff 75 f4             	pushl  -0xc(%ebp)
  800b29:	50                   	push   %eax
  800b2a:	e8 73 ff ff ff       	call   800aa2 <vcprintf>
  800b2f:	83 c4 10             	add    $0x10,%esp
  800b32:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800b35:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b38:	c9                   	leave  
  800b39:	c3                   	ret    

00800b3a <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800b3a:	55                   	push   %ebp
  800b3b:	89 e5                	mov    %esp,%ebp
  800b3d:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800b40:	e8 cf 0d 00 00       	call   801914 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800b45:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b48:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4e:	83 ec 08             	sub    $0x8,%esp
  800b51:	ff 75 f4             	pushl  -0xc(%ebp)
  800b54:	50                   	push   %eax
  800b55:	e8 48 ff ff ff       	call   800aa2 <vcprintf>
  800b5a:	83 c4 10             	add    $0x10,%esp
  800b5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800b60:	e8 c9 0d 00 00       	call   80192e <sys_unlock_cons>
	return cnt;
  800b65:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b68:	c9                   	leave  
  800b69:	c3                   	ret    

00800b6a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b6a:	55                   	push   %ebp
  800b6b:	89 e5                	mov    %esp,%ebp
  800b6d:	53                   	push   %ebx
  800b6e:	83 ec 14             	sub    $0x14,%esp
  800b71:	8b 45 10             	mov    0x10(%ebp),%eax
  800b74:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b77:	8b 45 14             	mov    0x14(%ebp),%eax
  800b7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800b7d:	8b 45 18             	mov    0x18(%ebp),%eax
  800b80:	ba 00 00 00 00       	mov    $0x0,%edx
  800b85:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b88:	77 55                	ja     800bdf <printnum+0x75>
  800b8a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b8d:	72 05                	jb     800b94 <printnum+0x2a>
  800b8f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b92:	77 4b                	ja     800bdf <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800b94:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800b97:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800b9a:	8b 45 18             	mov    0x18(%ebp),%eax
  800b9d:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba2:	52                   	push   %edx
  800ba3:	50                   	push   %eax
  800ba4:	ff 75 f4             	pushl  -0xc(%ebp)
  800ba7:	ff 75 f0             	pushl  -0x10(%ebp)
  800baa:	e8 95 13 00 00       	call   801f44 <__udivdi3>
  800baf:	83 c4 10             	add    $0x10,%esp
  800bb2:	83 ec 04             	sub    $0x4,%esp
  800bb5:	ff 75 20             	pushl  0x20(%ebp)
  800bb8:	53                   	push   %ebx
  800bb9:	ff 75 18             	pushl  0x18(%ebp)
  800bbc:	52                   	push   %edx
  800bbd:	50                   	push   %eax
  800bbe:	ff 75 0c             	pushl  0xc(%ebp)
  800bc1:	ff 75 08             	pushl  0x8(%ebp)
  800bc4:	e8 a1 ff ff ff       	call   800b6a <printnum>
  800bc9:	83 c4 20             	add    $0x20,%esp
  800bcc:	eb 1a                	jmp    800be8 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800bce:	83 ec 08             	sub    $0x8,%esp
  800bd1:	ff 75 0c             	pushl  0xc(%ebp)
  800bd4:	ff 75 20             	pushl  0x20(%ebp)
  800bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bda:	ff d0                	call   *%eax
  800bdc:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800bdf:	ff 4d 1c             	decl   0x1c(%ebp)
  800be2:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800be6:	7f e6                	jg     800bce <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800be8:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800beb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bf0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bf3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bf6:	53                   	push   %ebx
  800bf7:	51                   	push   %ecx
  800bf8:	52                   	push   %edx
  800bf9:	50                   	push   %eax
  800bfa:	e8 55 14 00 00       	call   802054 <__umoddi3>
  800bff:	83 c4 10             	add    $0x10,%esp
  800c02:	05 b4 27 80 00       	add    $0x8027b4,%eax
  800c07:	8a 00                	mov    (%eax),%al
  800c09:	0f be c0             	movsbl %al,%eax
  800c0c:	83 ec 08             	sub    $0x8,%esp
  800c0f:	ff 75 0c             	pushl  0xc(%ebp)
  800c12:	50                   	push   %eax
  800c13:	8b 45 08             	mov    0x8(%ebp),%eax
  800c16:	ff d0                	call   *%eax
  800c18:	83 c4 10             	add    $0x10,%esp
}
  800c1b:	90                   	nop
  800c1c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c1f:	c9                   	leave  
  800c20:	c3                   	ret    

00800c21 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800c21:	55                   	push   %ebp
  800c22:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c24:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c28:	7e 1c                	jle    800c46 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2d:	8b 00                	mov    (%eax),%eax
  800c2f:	8d 50 08             	lea    0x8(%eax),%edx
  800c32:	8b 45 08             	mov    0x8(%ebp),%eax
  800c35:	89 10                	mov    %edx,(%eax)
  800c37:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3a:	8b 00                	mov    (%eax),%eax
  800c3c:	83 e8 08             	sub    $0x8,%eax
  800c3f:	8b 50 04             	mov    0x4(%eax),%edx
  800c42:	8b 00                	mov    (%eax),%eax
  800c44:	eb 40                	jmp    800c86 <getuint+0x65>
	else if (lflag)
  800c46:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c4a:	74 1e                	je     800c6a <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4f:	8b 00                	mov    (%eax),%eax
  800c51:	8d 50 04             	lea    0x4(%eax),%edx
  800c54:	8b 45 08             	mov    0x8(%ebp),%eax
  800c57:	89 10                	mov    %edx,(%eax)
  800c59:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5c:	8b 00                	mov    (%eax),%eax
  800c5e:	83 e8 04             	sub    $0x4,%eax
  800c61:	8b 00                	mov    (%eax),%eax
  800c63:	ba 00 00 00 00       	mov    $0x0,%edx
  800c68:	eb 1c                	jmp    800c86 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6d:	8b 00                	mov    (%eax),%eax
  800c6f:	8d 50 04             	lea    0x4(%eax),%edx
  800c72:	8b 45 08             	mov    0x8(%ebp),%eax
  800c75:	89 10                	mov    %edx,(%eax)
  800c77:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7a:	8b 00                	mov    (%eax),%eax
  800c7c:	83 e8 04             	sub    $0x4,%eax
  800c7f:	8b 00                	mov    (%eax),%eax
  800c81:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800c86:	5d                   	pop    %ebp
  800c87:	c3                   	ret    

00800c88 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800c88:	55                   	push   %ebp
  800c89:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c8b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c8f:	7e 1c                	jle    800cad <getint+0x25>
		return va_arg(*ap, long long);
  800c91:	8b 45 08             	mov    0x8(%ebp),%eax
  800c94:	8b 00                	mov    (%eax),%eax
  800c96:	8d 50 08             	lea    0x8(%eax),%edx
  800c99:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9c:	89 10                	mov    %edx,(%eax)
  800c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca1:	8b 00                	mov    (%eax),%eax
  800ca3:	83 e8 08             	sub    $0x8,%eax
  800ca6:	8b 50 04             	mov    0x4(%eax),%edx
  800ca9:	8b 00                	mov    (%eax),%eax
  800cab:	eb 38                	jmp    800ce5 <getint+0x5d>
	else if (lflag)
  800cad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cb1:	74 1a                	je     800ccd <getint+0x45>
		return va_arg(*ap, long);
  800cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb6:	8b 00                	mov    (%eax),%eax
  800cb8:	8d 50 04             	lea    0x4(%eax),%edx
  800cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbe:	89 10                	mov    %edx,(%eax)
  800cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc3:	8b 00                	mov    (%eax),%eax
  800cc5:	83 e8 04             	sub    $0x4,%eax
  800cc8:	8b 00                	mov    (%eax),%eax
  800cca:	99                   	cltd   
  800ccb:	eb 18                	jmp    800ce5 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd0:	8b 00                	mov    (%eax),%eax
  800cd2:	8d 50 04             	lea    0x4(%eax),%edx
  800cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd8:	89 10                	mov    %edx,(%eax)
  800cda:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdd:	8b 00                	mov    (%eax),%eax
  800cdf:	83 e8 04             	sub    $0x4,%eax
  800ce2:	8b 00                	mov    (%eax),%eax
  800ce4:	99                   	cltd   
}
  800ce5:	5d                   	pop    %ebp
  800ce6:	c3                   	ret    

00800ce7 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800ce7:	55                   	push   %ebp
  800ce8:	89 e5                	mov    %esp,%ebp
  800cea:	56                   	push   %esi
  800ceb:	53                   	push   %ebx
  800cec:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cef:	eb 17                	jmp    800d08 <vprintfmt+0x21>
			if (ch == '\0')
  800cf1:	85 db                	test   %ebx,%ebx
  800cf3:	0f 84 c1 03 00 00    	je     8010ba <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800cf9:	83 ec 08             	sub    $0x8,%esp
  800cfc:	ff 75 0c             	pushl  0xc(%ebp)
  800cff:	53                   	push   %ebx
  800d00:	8b 45 08             	mov    0x8(%ebp),%eax
  800d03:	ff d0                	call   *%eax
  800d05:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d08:	8b 45 10             	mov    0x10(%ebp),%eax
  800d0b:	8d 50 01             	lea    0x1(%eax),%edx
  800d0e:	89 55 10             	mov    %edx,0x10(%ebp)
  800d11:	8a 00                	mov    (%eax),%al
  800d13:	0f b6 d8             	movzbl %al,%ebx
  800d16:	83 fb 25             	cmp    $0x25,%ebx
  800d19:	75 d6                	jne    800cf1 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800d1b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800d1f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800d26:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800d2d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800d34:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d3e:	8d 50 01             	lea    0x1(%eax),%edx
  800d41:	89 55 10             	mov    %edx,0x10(%ebp)
  800d44:	8a 00                	mov    (%eax),%al
  800d46:	0f b6 d8             	movzbl %al,%ebx
  800d49:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800d4c:	83 f8 5b             	cmp    $0x5b,%eax
  800d4f:	0f 87 3d 03 00 00    	ja     801092 <vprintfmt+0x3ab>
  800d55:	8b 04 85 d8 27 80 00 	mov    0x8027d8(,%eax,4),%eax
  800d5c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800d5e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800d62:	eb d7                	jmp    800d3b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800d64:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800d68:	eb d1                	jmp    800d3b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d6a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800d71:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800d74:	89 d0                	mov    %edx,%eax
  800d76:	c1 e0 02             	shl    $0x2,%eax
  800d79:	01 d0                	add    %edx,%eax
  800d7b:	01 c0                	add    %eax,%eax
  800d7d:	01 d8                	add    %ebx,%eax
  800d7f:	83 e8 30             	sub    $0x30,%eax
  800d82:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800d85:	8b 45 10             	mov    0x10(%ebp),%eax
  800d88:	8a 00                	mov    (%eax),%al
  800d8a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800d8d:	83 fb 2f             	cmp    $0x2f,%ebx
  800d90:	7e 3e                	jle    800dd0 <vprintfmt+0xe9>
  800d92:	83 fb 39             	cmp    $0x39,%ebx
  800d95:	7f 39                	jg     800dd0 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d97:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d9a:	eb d5                	jmp    800d71 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800d9c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d9f:	83 c0 04             	add    $0x4,%eax
  800da2:	89 45 14             	mov    %eax,0x14(%ebp)
  800da5:	8b 45 14             	mov    0x14(%ebp),%eax
  800da8:	83 e8 04             	sub    $0x4,%eax
  800dab:	8b 00                	mov    (%eax),%eax
  800dad:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800db0:	eb 1f                	jmp    800dd1 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800db2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800db6:	79 83                	jns    800d3b <vprintfmt+0x54>
				width = 0;
  800db8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800dbf:	e9 77 ff ff ff       	jmp    800d3b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800dc4:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800dcb:	e9 6b ff ff ff       	jmp    800d3b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800dd0:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800dd1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dd5:	0f 89 60 ff ff ff    	jns    800d3b <vprintfmt+0x54>
				width = precision, precision = -1;
  800ddb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800dde:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800de1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800de8:	e9 4e ff ff ff       	jmp    800d3b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ded:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800df0:	e9 46 ff ff ff       	jmp    800d3b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800df5:	8b 45 14             	mov    0x14(%ebp),%eax
  800df8:	83 c0 04             	add    $0x4,%eax
  800dfb:	89 45 14             	mov    %eax,0x14(%ebp)
  800dfe:	8b 45 14             	mov    0x14(%ebp),%eax
  800e01:	83 e8 04             	sub    $0x4,%eax
  800e04:	8b 00                	mov    (%eax),%eax
  800e06:	83 ec 08             	sub    $0x8,%esp
  800e09:	ff 75 0c             	pushl  0xc(%ebp)
  800e0c:	50                   	push   %eax
  800e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e10:	ff d0                	call   *%eax
  800e12:	83 c4 10             	add    $0x10,%esp
			break;
  800e15:	e9 9b 02 00 00       	jmp    8010b5 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800e1a:	8b 45 14             	mov    0x14(%ebp),%eax
  800e1d:	83 c0 04             	add    $0x4,%eax
  800e20:	89 45 14             	mov    %eax,0x14(%ebp)
  800e23:	8b 45 14             	mov    0x14(%ebp),%eax
  800e26:	83 e8 04             	sub    $0x4,%eax
  800e29:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800e2b:	85 db                	test   %ebx,%ebx
  800e2d:	79 02                	jns    800e31 <vprintfmt+0x14a>
				err = -err;
  800e2f:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800e31:	83 fb 64             	cmp    $0x64,%ebx
  800e34:	7f 0b                	jg     800e41 <vprintfmt+0x15a>
  800e36:	8b 34 9d 20 26 80 00 	mov    0x802620(,%ebx,4),%esi
  800e3d:	85 f6                	test   %esi,%esi
  800e3f:	75 19                	jne    800e5a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e41:	53                   	push   %ebx
  800e42:	68 c5 27 80 00       	push   $0x8027c5
  800e47:	ff 75 0c             	pushl  0xc(%ebp)
  800e4a:	ff 75 08             	pushl  0x8(%ebp)
  800e4d:	e8 70 02 00 00       	call   8010c2 <printfmt>
  800e52:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e55:	e9 5b 02 00 00       	jmp    8010b5 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e5a:	56                   	push   %esi
  800e5b:	68 ce 27 80 00       	push   $0x8027ce
  800e60:	ff 75 0c             	pushl  0xc(%ebp)
  800e63:	ff 75 08             	pushl  0x8(%ebp)
  800e66:	e8 57 02 00 00       	call   8010c2 <printfmt>
  800e6b:	83 c4 10             	add    $0x10,%esp
			break;
  800e6e:	e9 42 02 00 00       	jmp    8010b5 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800e73:	8b 45 14             	mov    0x14(%ebp),%eax
  800e76:	83 c0 04             	add    $0x4,%eax
  800e79:	89 45 14             	mov    %eax,0x14(%ebp)
  800e7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800e7f:	83 e8 04             	sub    $0x4,%eax
  800e82:	8b 30                	mov    (%eax),%esi
  800e84:	85 f6                	test   %esi,%esi
  800e86:	75 05                	jne    800e8d <vprintfmt+0x1a6>
				p = "(null)";
  800e88:	be d1 27 80 00       	mov    $0x8027d1,%esi
			if (width > 0 && padc != '-')
  800e8d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e91:	7e 6d                	jle    800f00 <vprintfmt+0x219>
  800e93:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800e97:	74 67                	je     800f00 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e99:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e9c:	83 ec 08             	sub    $0x8,%esp
  800e9f:	50                   	push   %eax
  800ea0:	56                   	push   %esi
  800ea1:	e8 1e 03 00 00       	call   8011c4 <strnlen>
  800ea6:	83 c4 10             	add    $0x10,%esp
  800ea9:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800eac:	eb 16                	jmp    800ec4 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800eae:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800eb2:	83 ec 08             	sub    $0x8,%esp
  800eb5:	ff 75 0c             	pushl  0xc(%ebp)
  800eb8:	50                   	push   %eax
  800eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebc:	ff d0                	call   *%eax
  800ebe:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ec1:	ff 4d e4             	decl   -0x1c(%ebp)
  800ec4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ec8:	7f e4                	jg     800eae <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800eca:	eb 34                	jmp    800f00 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800ecc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800ed0:	74 1c                	je     800eee <vprintfmt+0x207>
  800ed2:	83 fb 1f             	cmp    $0x1f,%ebx
  800ed5:	7e 05                	jle    800edc <vprintfmt+0x1f5>
  800ed7:	83 fb 7e             	cmp    $0x7e,%ebx
  800eda:	7e 12                	jle    800eee <vprintfmt+0x207>
					putch('?', putdat);
  800edc:	83 ec 08             	sub    $0x8,%esp
  800edf:	ff 75 0c             	pushl  0xc(%ebp)
  800ee2:	6a 3f                	push   $0x3f
  800ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee7:	ff d0                	call   *%eax
  800ee9:	83 c4 10             	add    $0x10,%esp
  800eec:	eb 0f                	jmp    800efd <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800eee:	83 ec 08             	sub    $0x8,%esp
  800ef1:	ff 75 0c             	pushl  0xc(%ebp)
  800ef4:	53                   	push   %ebx
  800ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef8:	ff d0                	call   *%eax
  800efa:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800efd:	ff 4d e4             	decl   -0x1c(%ebp)
  800f00:	89 f0                	mov    %esi,%eax
  800f02:	8d 70 01             	lea    0x1(%eax),%esi
  800f05:	8a 00                	mov    (%eax),%al
  800f07:	0f be d8             	movsbl %al,%ebx
  800f0a:	85 db                	test   %ebx,%ebx
  800f0c:	74 24                	je     800f32 <vprintfmt+0x24b>
  800f0e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f12:	78 b8                	js     800ecc <vprintfmt+0x1e5>
  800f14:	ff 4d e0             	decl   -0x20(%ebp)
  800f17:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f1b:	79 af                	jns    800ecc <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f1d:	eb 13                	jmp    800f32 <vprintfmt+0x24b>
				putch(' ', putdat);
  800f1f:	83 ec 08             	sub    $0x8,%esp
  800f22:	ff 75 0c             	pushl  0xc(%ebp)
  800f25:	6a 20                	push   $0x20
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	ff d0                	call   *%eax
  800f2c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f2f:	ff 4d e4             	decl   -0x1c(%ebp)
  800f32:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f36:	7f e7                	jg     800f1f <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800f38:	e9 78 01 00 00       	jmp    8010b5 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800f3d:	83 ec 08             	sub    $0x8,%esp
  800f40:	ff 75 e8             	pushl  -0x18(%ebp)
  800f43:	8d 45 14             	lea    0x14(%ebp),%eax
  800f46:	50                   	push   %eax
  800f47:	e8 3c fd ff ff       	call   800c88 <getint>
  800f4c:	83 c4 10             	add    $0x10,%esp
  800f4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f52:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800f55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f58:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f5b:	85 d2                	test   %edx,%edx
  800f5d:	79 23                	jns    800f82 <vprintfmt+0x29b>
				putch('-', putdat);
  800f5f:	83 ec 08             	sub    $0x8,%esp
  800f62:	ff 75 0c             	pushl  0xc(%ebp)
  800f65:	6a 2d                	push   $0x2d
  800f67:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6a:	ff d0                	call   *%eax
  800f6c:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800f6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f72:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f75:	f7 d8                	neg    %eax
  800f77:	83 d2 00             	adc    $0x0,%edx
  800f7a:	f7 da                	neg    %edx
  800f7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f7f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800f82:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f89:	e9 bc 00 00 00       	jmp    80104a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800f8e:	83 ec 08             	sub    $0x8,%esp
  800f91:	ff 75 e8             	pushl  -0x18(%ebp)
  800f94:	8d 45 14             	lea    0x14(%ebp),%eax
  800f97:	50                   	push   %eax
  800f98:	e8 84 fc ff ff       	call   800c21 <getuint>
  800f9d:	83 c4 10             	add    $0x10,%esp
  800fa0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fa3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800fa6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800fad:	e9 98 00 00 00       	jmp    80104a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800fb2:	83 ec 08             	sub    $0x8,%esp
  800fb5:	ff 75 0c             	pushl  0xc(%ebp)
  800fb8:	6a 58                	push   $0x58
  800fba:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbd:	ff d0                	call   *%eax
  800fbf:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800fc2:	83 ec 08             	sub    $0x8,%esp
  800fc5:	ff 75 0c             	pushl  0xc(%ebp)
  800fc8:	6a 58                	push   $0x58
  800fca:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcd:	ff d0                	call   *%eax
  800fcf:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800fd2:	83 ec 08             	sub    $0x8,%esp
  800fd5:	ff 75 0c             	pushl  0xc(%ebp)
  800fd8:	6a 58                	push   $0x58
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdd:	ff d0                	call   *%eax
  800fdf:	83 c4 10             	add    $0x10,%esp
			break;
  800fe2:	e9 ce 00 00 00       	jmp    8010b5 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800fe7:	83 ec 08             	sub    $0x8,%esp
  800fea:	ff 75 0c             	pushl  0xc(%ebp)
  800fed:	6a 30                	push   $0x30
  800fef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff2:	ff d0                	call   *%eax
  800ff4:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ff7:	83 ec 08             	sub    $0x8,%esp
  800ffa:	ff 75 0c             	pushl  0xc(%ebp)
  800ffd:	6a 78                	push   $0x78
  800fff:	8b 45 08             	mov    0x8(%ebp),%eax
  801002:	ff d0                	call   *%eax
  801004:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801007:	8b 45 14             	mov    0x14(%ebp),%eax
  80100a:	83 c0 04             	add    $0x4,%eax
  80100d:	89 45 14             	mov    %eax,0x14(%ebp)
  801010:	8b 45 14             	mov    0x14(%ebp),%eax
  801013:	83 e8 04             	sub    $0x4,%eax
  801016:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801018:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80101b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801022:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801029:	eb 1f                	jmp    80104a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80102b:	83 ec 08             	sub    $0x8,%esp
  80102e:	ff 75 e8             	pushl  -0x18(%ebp)
  801031:	8d 45 14             	lea    0x14(%ebp),%eax
  801034:	50                   	push   %eax
  801035:	e8 e7 fb ff ff       	call   800c21 <getuint>
  80103a:	83 c4 10             	add    $0x10,%esp
  80103d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801040:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801043:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80104a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80104e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801051:	83 ec 04             	sub    $0x4,%esp
  801054:	52                   	push   %edx
  801055:	ff 75 e4             	pushl  -0x1c(%ebp)
  801058:	50                   	push   %eax
  801059:	ff 75 f4             	pushl  -0xc(%ebp)
  80105c:	ff 75 f0             	pushl  -0x10(%ebp)
  80105f:	ff 75 0c             	pushl  0xc(%ebp)
  801062:	ff 75 08             	pushl  0x8(%ebp)
  801065:	e8 00 fb ff ff       	call   800b6a <printnum>
  80106a:	83 c4 20             	add    $0x20,%esp
			break;
  80106d:	eb 46                	jmp    8010b5 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80106f:	83 ec 08             	sub    $0x8,%esp
  801072:	ff 75 0c             	pushl  0xc(%ebp)
  801075:	53                   	push   %ebx
  801076:	8b 45 08             	mov    0x8(%ebp),%eax
  801079:	ff d0                	call   *%eax
  80107b:	83 c4 10             	add    $0x10,%esp
			break;
  80107e:	eb 35                	jmp    8010b5 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801080:	c6 05 40 04 b1 00 00 	movb   $0x0,0xb10440
			break;
  801087:	eb 2c                	jmp    8010b5 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801089:	c6 05 40 04 b1 00 01 	movb   $0x1,0xb10440
			break;
  801090:	eb 23                	jmp    8010b5 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801092:	83 ec 08             	sub    $0x8,%esp
  801095:	ff 75 0c             	pushl  0xc(%ebp)
  801098:	6a 25                	push   $0x25
  80109a:	8b 45 08             	mov    0x8(%ebp),%eax
  80109d:	ff d0                	call   *%eax
  80109f:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010a2:	ff 4d 10             	decl   0x10(%ebp)
  8010a5:	eb 03                	jmp    8010aa <vprintfmt+0x3c3>
  8010a7:	ff 4d 10             	decl   0x10(%ebp)
  8010aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ad:	48                   	dec    %eax
  8010ae:	8a 00                	mov    (%eax),%al
  8010b0:	3c 25                	cmp    $0x25,%al
  8010b2:	75 f3                	jne    8010a7 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8010b4:	90                   	nop
		}
	}
  8010b5:	e9 35 fc ff ff       	jmp    800cef <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8010ba:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8010bb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010be:	5b                   	pop    %ebx
  8010bf:	5e                   	pop    %esi
  8010c0:	5d                   	pop    %ebp
  8010c1:	c3                   	ret    

008010c2 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8010c2:	55                   	push   %ebp
  8010c3:	89 e5                	mov    %esp,%ebp
  8010c5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8010c8:	8d 45 10             	lea    0x10(%ebp),%eax
  8010cb:	83 c0 04             	add    $0x4,%eax
  8010ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8010d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8010d7:	50                   	push   %eax
  8010d8:	ff 75 0c             	pushl  0xc(%ebp)
  8010db:	ff 75 08             	pushl  0x8(%ebp)
  8010de:	e8 04 fc ff ff       	call   800ce7 <vprintfmt>
  8010e3:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8010e6:	90                   	nop
  8010e7:	c9                   	leave  
  8010e8:	c3                   	ret    

008010e9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8010e9:	55                   	push   %ebp
  8010ea:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8010ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ef:	8b 40 08             	mov    0x8(%eax),%eax
  8010f2:	8d 50 01             	lea    0x1(%eax),%edx
  8010f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f8:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8010fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fe:	8b 10                	mov    (%eax),%edx
  801100:	8b 45 0c             	mov    0xc(%ebp),%eax
  801103:	8b 40 04             	mov    0x4(%eax),%eax
  801106:	39 c2                	cmp    %eax,%edx
  801108:	73 12                	jae    80111c <sprintputch+0x33>
		*b->buf++ = ch;
  80110a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110d:	8b 00                	mov    (%eax),%eax
  80110f:	8d 48 01             	lea    0x1(%eax),%ecx
  801112:	8b 55 0c             	mov    0xc(%ebp),%edx
  801115:	89 0a                	mov    %ecx,(%edx)
  801117:	8b 55 08             	mov    0x8(%ebp),%edx
  80111a:	88 10                	mov    %dl,(%eax)
}
  80111c:	90                   	nop
  80111d:	5d                   	pop    %ebp
  80111e:	c3                   	ret    

0080111f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80111f:	55                   	push   %ebp
  801120:	89 e5                	mov    %esp,%ebp
  801122:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801125:	8b 45 08             	mov    0x8(%ebp),%eax
  801128:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80112b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801131:	8b 45 08             	mov    0x8(%ebp),%eax
  801134:	01 d0                	add    %edx,%eax
  801136:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801139:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801140:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801144:	74 06                	je     80114c <vsnprintf+0x2d>
  801146:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80114a:	7f 07                	jg     801153 <vsnprintf+0x34>
		return -E_INVAL;
  80114c:	b8 03 00 00 00       	mov    $0x3,%eax
  801151:	eb 20                	jmp    801173 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801153:	ff 75 14             	pushl  0x14(%ebp)
  801156:	ff 75 10             	pushl  0x10(%ebp)
  801159:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80115c:	50                   	push   %eax
  80115d:	68 e9 10 80 00       	push   $0x8010e9
  801162:	e8 80 fb ff ff       	call   800ce7 <vprintfmt>
  801167:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80116a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80116d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801170:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801173:	c9                   	leave  
  801174:	c3                   	ret    

00801175 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801175:	55                   	push   %ebp
  801176:	89 e5                	mov    %esp,%ebp
  801178:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80117b:	8d 45 10             	lea    0x10(%ebp),%eax
  80117e:	83 c0 04             	add    $0x4,%eax
  801181:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801184:	8b 45 10             	mov    0x10(%ebp),%eax
  801187:	ff 75 f4             	pushl  -0xc(%ebp)
  80118a:	50                   	push   %eax
  80118b:	ff 75 0c             	pushl  0xc(%ebp)
  80118e:	ff 75 08             	pushl  0x8(%ebp)
  801191:	e8 89 ff ff ff       	call   80111f <vsnprintf>
  801196:	83 c4 10             	add    $0x10,%esp
  801199:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80119c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80119f:	c9                   	leave  
  8011a0:	c3                   	ret    

008011a1 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  8011a1:	55                   	push   %ebp
  8011a2:	89 e5                	mov    %esp,%ebp
  8011a4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8011a7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011ae:	eb 06                	jmp    8011b6 <strlen+0x15>
		n++;
  8011b0:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8011b3:	ff 45 08             	incl   0x8(%ebp)
  8011b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b9:	8a 00                	mov    (%eax),%al
  8011bb:	84 c0                	test   %al,%al
  8011bd:	75 f1                	jne    8011b0 <strlen+0xf>
		n++;
	return n;
  8011bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8011c2:	c9                   	leave  
  8011c3:	c3                   	ret    

008011c4 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8011c4:	55                   	push   %ebp
  8011c5:	89 e5                	mov    %esp,%ebp
  8011c7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011d1:	eb 09                	jmp    8011dc <strnlen+0x18>
		n++;
  8011d3:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011d6:	ff 45 08             	incl   0x8(%ebp)
  8011d9:	ff 4d 0c             	decl   0xc(%ebp)
  8011dc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011e0:	74 09                	je     8011eb <strnlen+0x27>
  8011e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e5:	8a 00                	mov    (%eax),%al
  8011e7:	84 c0                	test   %al,%al
  8011e9:	75 e8                	jne    8011d3 <strnlen+0xf>
		n++;
	return n;
  8011eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8011ee:	c9                   	leave  
  8011ef:	c3                   	ret    

008011f0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8011f0:	55                   	push   %ebp
  8011f1:	89 e5                	mov    %esp,%ebp
  8011f3:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8011f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8011fc:	90                   	nop
  8011fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801200:	8d 50 01             	lea    0x1(%eax),%edx
  801203:	89 55 08             	mov    %edx,0x8(%ebp)
  801206:	8b 55 0c             	mov    0xc(%ebp),%edx
  801209:	8d 4a 01             	lea    0x1(%edx),%ecx
  80120c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80120f:	8a 12                	mov    (%edx),%dl
  801211:	88 10                	mov    %dl,(%eax)
  801213:	8a 00                	mov    (%eax),%al
  801215:	84 c0                	test   %al,%al
  801217:	75 e4                	jne    8011fd <strcpy+0xd>
		/* do nothing */;
	return ret;
  801219:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80121c:	c9                   	leave  
  80121d:	c3                   	ret    

0080121e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80121e:	55                   	push   %ebp
  80121f:	89 e5                	mov    %esp,%ebp
  801221:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801224:	8b 45 08             	mov    0x8(%ebp),%eax
  801227:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80122a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801231:	eb 1f                	jmp    801252 <strncpy+0x34>
		*dst++ = *src;
  801233:	8b 45 08             	mov    0x8(%ebp),%eax
  801236:	8d 50 01             	lea    0x1(%eax),%edx
  801239:	89 55 08             	mov    %edx,0x8(%ebp)
  80123c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80123f:	8a 12                	mov    (%edx),%dl
  801241:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801243:	8b 45 0c             	mov    0xc(%ebp),%eax
  801246:	8a 00                	mov    (%eax),%al
  801248:	84 c0                	test   %al,%al
  80124a:	74 03                	je     80124f <strncpy+0x31>
			src++;
  80124c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80124f:	ff 45 fc             	incl   -0x4(%ebp)
  801252:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801255:	3b 45 10             	cmp    0x10(%ebp),%eax
  801258:	72 d9                	jb     801233 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80125a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80125d:	c9                   	leave  
  80125e:	c3                   	ret    

0080125f <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80125f:	55                   	push   %ebp
  801260:	89 e5                	mov    %esp,%ebp
  801262:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801265:	8b 45 08             	mov    0x8(%ebp),%eax
  801268:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80126b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80126f:	74 30                	je     8012a1 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801271:	eb 16                	jmp    801289 <strlcpy+0x2a>
			*dst++ = *src++;
  801273:	8b 45 08             	mov    0x8(%ebp),%eax
  801276:	8d 50 01             	lea    0x1(%eax),%edx
  801279:	89 55 08             	mov    %edx,0x8(%ebp)
  80127c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80127f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801282:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801285:	8a 12                	mov    (%edx),%dl
  801287:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801289:	ff 4d 10             	decl   0x10(%ebp)
  80128c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801290:	74 09                	je     80129b <strlcpy+0x3c>
  801292:	8b 45 0c             	mov    0xc(%ebp),%eax
  801295:	8a 00                	mov    (%eax),%al
  801297:	84 c0                	test   %al,%al
  801299:	75 d8                	jne    801273 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80129b:	8b 45 08             	mov    0x8(%ebp),%eax
  80129e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8012a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8012a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012a7:	29 c2                	sub    %eax,%edx
  8012a9:	89 d0                	mov    %edx,%eax
}
  8012ab:	c9                   	leave  
  8012ac:	c3                   	ret    

008012ad <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8012ad:	55                   	push   %ebp
  8012ae:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8012b0:	eb 06                	jmp    8012b8 <strcmp+0xb>
		p++, q++;
  8012b2:	ff 45 08             	incl   0x8(%ebp)
  8012b5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8012b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bb:	8a 00                	mov    (%eax),%al
  8012bd:	84 c0                	test   %al,%al
  8012bf:	74 0e                	je     8012cf <strcmp+0x22>
  8012c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c4:	8a 10                	mov    (%eax),%dl
  8012c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c9:	8a 00                	mov    (%eax),%al
  8012cb:	38 c2                	cmp    %al,%dl
  8012cd:	74 e3                	je     8012b2 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8012cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d2:	8a 00                	mov    (%eax),%al
  8012d4:	0f b6 d0             	movzbl %al,%edx
  8012d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012da:	8a 00                	mov    (%eax),%al
  8012dc:	0f b6 c0             	movzbl %al,%eax
  8012df:	29 c2                	sub    %eax,%edx
  8012e1:	89 d0                	mov    %edx,%eax
}
  8012e3:	5d                   	pop    %ebp
  8012e4:	c3                   	ret    

008012e5 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8012e5:	55                   	push   %ebp
  8012e6:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8012e8:	eb 09                	jmp    8012f3 <strncmp+0xe>
		n--, p++, q++;
  8012ea:	ff 4d 10             	decl   0x10(%ebp)
  8012ed:	ff 45 08             	incl   0x8(%ebp)
  8012f0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8012f3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012f7:	74 17                	je     801310 <strncmp+0x2b>
  8012f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fc:	8a 00                	mov    (%eax),%al
  8012fe:	84 c0                	test   %al,%al
  801300:	74 0e                	je     801310 <strncmp+0x2b>
  801302:	8b 45 08             	mov    0x8(%ebp),%eax
  801305:	8a 10                	mov    (%eax),%dl
  801307:	8b 45 0c             	mov    0xc(%ebp),%eax
  80130a:	8a 00                	mov    (%eax),%al
  80130c:	38 c2                	cmp    %al,%dl
  80130e:	74 da                	je     8012ea <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801310:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801314:	75 07                	jne    80131d <strncmp+0x38>
		return 0;
  801316:	b8 00 00 00 00       	mov    $0x0,%eax
  80131b:	eb 14                	jmp    801331 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80131d:	8b 45 08             	mov    0x8(%ebp),%eax
  801320:	8a 00                	mov    (%eax),%al
  801322:	0f b6 d0             	movzbl %al,%edx
  801325:	8b 45 0c             	mov    0xc(%ebp),%eax
  801328:	8a 00                	mov    (%eax),%al
  80132a:	0f b6 c0             	movzbl %al,%eax
  80132d:	29 c2                	sub    %eax,%edx
  80132f:	89 d0                	mov    %edx,%eax
}
  801331:	5d                   	pop    %ebp
  801332:	c3                   	ret    

00801333 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801333:	55                   	push   %ebp
  801334:	89 e5                	mov    %esp,%ebp
  801336:	83 ec 04             	sub    $0x4,%esp
  801339:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80133f:	eb 12                	jmp    801353 <strchr+0x20>
		if (*s == c)
  801341:	8b 45 08             	mov    0x8(%ebp),%eax
  801344:	8a 00                	mov    (%eax),%al
  801346:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801349:	75 05                	jne    801350 <strchr+0x1d>
			return (char *) s;
  80134b:	8b 45 08             	mov    0x8(%ebp),%eax
  80134e:	eb 11                	jmp    801361 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801350:	ff 45 08             	incl   0x8(%ebp)
  801353:	8b 45 08             	mov    0x8(%ebp),%eax
  801356:	8a 00                	mov    (%eax),%al
  801358:	84 c0                	test   %al,%al
  80135a:	75 e5                	jne    801341 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80135c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801361:	c9                   	leave  
  801362:	c3                   	ret    

00801363 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801363:	55                   	push   %ebp
  801364:	89 e5                	mov    %esp,%ebp
  801366:	83 ec 04             	sub    $0x4,%esp
  801369:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80136f:	eb 0d                	jmp    80137e <strfind+0x1b>
		if (*s == c)
  801371:	8b 45 08             	mov    0x8(%ebp),%eax
  801374:	8a 00                	mov    (%eax),%al
  801376:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801379:	74 0e                	je     801389 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80137b:	ff 45 08             	incl   0x8(%ebp)
  80137e:	8b 45 08             	mov    0x8(%ebp),%eax
  801381:	8a 00                	mov    (%eax),%al
  801383:	84 c0                	test   %al,%al
  801385:	75 ea                	jne    801371 <strfind+0xe>
  801387:	eb 01                	jmp    80138a <strfind+0x27>
		if (*s == c)
			break;
  801389:	90                   	nop
	return (char *) s;
  80138a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80138d:	c9                   	leave  
  80138e:	c3                   	ret    

0080138f <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80138f:	55                   	push   %ebp
  801390:	89 e5                	mov    %esp,%ebp
  801392:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801395:	8b 45 08             	mov    0x8(%ebp),%eax
  801398:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80139b:	8b 45 10             	mov    0x10(%ebp),%eax
  80139e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8013a1:	eb 0e                	jmp    8013b1 <memset+0x22>
		*p++ = c;
  8013a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013a6:	8d 50 01             	lea    0x1(%eax),%edx
  8013a9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013af:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8013b1:	ff 4d f8             	decl   -0x8(%ebp)
  8013b4:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8013b8:	79 e9                	jns    8013a3 <memset+0x14>
		*p++ = c;

	return v;
  8013ba:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013bd:	c9                   	leave  
  8013be:	c3                   	ret    

008013bf <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8013bf:	55                   	push   %ebp
  8013c0:	89 e5                	mov    %esp,%ebp
  8013c2:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8013c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8013cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ce:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8013d1:	eb 16                	jmp    8013e9 <memcpy+0x2a>
		*d++ = *s++;
  8013d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013d6:	8d 50 01             	lea    0x1(%eax),%edx
  8013d9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013dc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013df:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013e2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8013e5:	8a 12                	mov    (%edx),%dl
  8013e7:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8013e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ec:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013ef:	89 55 10             	mov    %edx,0x10(%ebp)
  8013f2:	85 c0                	test   %eax,%eax
  8013f4:	75 dd                	jne    8013d3 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8013f6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013f9:	c9                   	leave  
  8013fa:	c3                   	ret    

008013fb <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8013fb:	55                   	push   %ebp
  8013fc:	89 e5                	mov    %esp,%ebp
  8013fe:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801401:	8b 45 0c             	mov    0xc(%ebp),%eax
  801404:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801407:	8b 45 08             	mov    0x8(%ebp),%eax
  80140a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80140d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801410:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801413:	73 50                	jae    801465 <memmove+0x6a>
  801415:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801418:	8b 45 10             	mov    0x10(%ebp),%eax
  80141b:	01 d0                	add    %edx,%eax
  80141d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801420:	76 43                	jbe    801465 <memmove+0x6a>
		s += n;
  801422:	8b 45 10             	mov    0x10(%ebp),%eax
  801425:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801428:	8b 45 10             	mov    0x10(%ebp),%eax
  80142b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80142e:	eb 10                	jmp    801440 <memmove+0x45>
			*--d = *--s;
  801430:	ff 4d f8             	decl   -0x8(%ebp)
  801433:	ff 4d fc             	decl   -0x4(%ebp)
  801436:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801439:	8a 10                	mov    (%eax),%dl
  80143b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80143e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801440:	8b 45 10             	mov    0x10(%ebp),%eax
  801443:	8d 50 ff             	lea    -0x1(%eax),%edx
  801446:	89 55 10             	mov    %edx,0x10(%ebp)
  801449:	85 c0                	test   %eax,%eax
  80144b:	75 e3                	jne    801430 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80144d:	eb 23                	jmp    801472 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80144f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801452:	8d 50 01             	lea    0x1(%eax),%edx
  801455:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801458:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80145b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80145e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801461:	8a 12                	mov    (%edx),%dl
  801463:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801465:	8b 45 10             	mov    0x10(%ebp),%eax
  801468:	8d 50 ff             	lea    -0x1(%eax),%edx
  80146b:	89 55 10             	mov    %edx,0x10(%ebp)
  80146e:	85 c0                	test   %eax,%eax
  801470:	75 dd                	jne    80144f <memmove+0x54>
			*d++ = *s++;

	return dst;
  801472:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801475:	c9                   	leave  
  801476:	c3                   	ret    

00801477 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801477:	55                   	push   %ebp
  801478:	89 e5                	mov    %esp,%ebp
  80147a:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80147d:	8b 45 08             	mov    0x8(%ebp),%eax
  801480:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801483:	8b 45 0c             	mov    0xc(%ebp),%eax
  801486:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801489:	eb 2a                	jmp    8014b5 <memcmp+0x3e>
		if (*s1 != *s2)
  80148b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80148e:	8a 10                	mov    (%eax),%dl
  801490:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801493:	8a 00                	mov    (%eax),%al
  801495:	38 c2                	cmp    %al,%dl
  801497:	74 16                	je     8014af <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801499:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80149c:	8a 00                	mov    (%eax),%al
  80149e:	0f b6 d0             	movzbl %al,%edx
  8014a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014a4:	8a 00                	mov    (%eax),%al
  8014a6:	0f b6 c0             	movzbl %al,%eax
  8014a9:	29 c2                	sub    %eax,%edx
  8014ab:	89 d0                	mov    %edx,%eax
  8014ad:	eb 18                	jmp    8014c7 <memcmp+0x50>
		s1++, s2++;
  8014af:	ff 45 fc             	incl   -0x4(%ebp)
  8014b2:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8014b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014bb:	89 55 10             	mov    %edx,0x10(%ebp)
  8014be:	85 c0                	test   %eax,%eax
  8014c0:	75 c9                	jne    80148b <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8014c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014c7:	c9                   	leave  
  8014c8:	c3                   	ret    

008014c9 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8014c9:	55                   	push   %ebp
  8014ca:	89 e5                	mov    %esp,%ebp
  8014cc:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8014cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8014d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d5:	01 d0                	add    %edx,%eax
  8014d7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8014da:	eb 15                	jmp    8014f1 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8014dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014df:	8a 00                	mov    (%eax),%al
  8014e1:	0f b6 d0             	movzbl %al,%edx
  8014e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e7:	0f b6 c0             	movzbl %al,%eax
  8014ea:	39 c2                	cmp    %eax,%edx
  8014ec:	74 0d                	je     8014fb <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8014ee:	ff 45 08             	incl   0x8(%ebp)
  8014f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8014f7:	72 e3                	jb     8014dc <memfind+0x13>
  8014f9:	eb 01                	jmp    8014fc <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8014fb:	90                   	nop
	return (void *) s;
  8014fc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014ff:	c9                   	leave  
  801500:	c3                   	ret    

00801501 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801501:	55                   	push   %ebp
  801502:	89 e5                	mov    %esp,%ebp
  801504:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801507:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80150e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801515:	eb 03                	jmp    80151a <strtol+0x19>
		s++;
  801517:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80151a:	8b 45 08             	mov    0x8(%ebp),%eax
  80151d:	8a 00                	mov    (%eax),%al
  80151f:	3c 20                	cmp    $0x20,%al
  801521:	74 f4                	je     801517 <strtol+0x16>
  801523:	8b 45 08             	mov    0x8(%ebp),%eax
  801526:	8a 00                	mov    (%eax),%al
  801528:	3c 09                	cmp    $0x9,%al
  80152a:	74 eb                	je     801517 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80152c:	8b 45 08             	mov    0x8(%ebp),%eax
  80152f:	8a 00                	mov    (%eax),%al
  801531:	3c 2b                	cmp    $0x2b,%al
  801533:	75 05                	jne    80153a <strtol+0x39>
		s++;
  801535:	ff 45 08             	incl   0x8(%ebp)
  801538:	eb 13                	jmp    80154d <strtol+0x4c>
	else if (*s == '-')
  80153a:	8b 45 08             	mov    0x8(%ebp),%eax
  80153d:	8a 00                	mov    (%eax),%al
  80153f:	3c 2d                	cmp    $0x2d,%al
  801541:	75 0a                	jne    80154d <strtol+0x4c>
		s++, neg = 1;
  801543:	ff 45 08             	incl   0x8(%ebp)
  801546:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80154d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801551:	74 06                	je     801559 <strtol+0x58>
  801553:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801557:	75 20                	jne    801579 <strtol+0x78>
  801559:	8b 45 08             	mov    0x8(%ebp),%eax
  80155c:	8a 00                	mov    (%eax),%al
  80155e:	3c 30                	cmp    $0x30,%al
  801560:	75 17                	jne    801579 <strtol+0x78>
  801562:	8b 45 08             	mov    0x8(%ebp),%eax
  801565:	40                   	inc    %eax
  801566:	8a 00                	mov    (%eax),%al
  801568:	3c 78                	cmp    $0x78,%al
  80156a:	75 0d                	jne    801579 <strtol+0x78>
		s += 2, base = 16;
  80156c:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801570:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801577:	eb 28                	jmp    8015a1 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801579:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80157d:	75 15                	jne    801594 <strtol+0x93>
  80157f:	8b 45 08             	mov    0x8(%ebp),%eax
  801582:	8a 00                	mov    (%eax),%al
  801584:	3c 30                	cmp    $0x30,%al
  801586:	75 0c                	jne    801594 <strtol+0x93>
		s++, base = 8;
  801588:	ff 45 08             	incl   0x8(%ebp)
  80158b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801592:	eb 0d                	jmp    8015a1 <strtol+0xa0>
	else if (base == 0)
  801594:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801598:	75 07                	jne    8015a1 <strtol+0xa0>
		base = 10;
  80159a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8015a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a4:	8a 00                	mov    (%eax),%al
  8015a6:	3c 2f                	cmp    $0x2f,%al
  8015a8:	7e 19                	jle    8015c3 <strtol+0xc2>
  8015aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ad:	8a 00                	mov    (%eax),%al
  8015af:	3c 39                	cmp    $0x39,%al
  8015b1:	7f 10                	jg     8015c3 <strtol+0xc2>
			dig = *s - '0';
  8015b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b6:	8a 00                	mov    (%eax),%al
  8015b8:	0f be c0             	movsbl %al,%eax
  8015bb:	83 e8 30             	sub    $0x30,%eax
  8015be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8015c1:	eb 42                	jmp    801605 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8015c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c6:	8a 00                	mov    (%eax),%al
  8015c8:	3c 60                	cmp    $0x60,%al
  8015ca:	7e 19                	jle    8015e5 <strtol+0xe4>
  8015cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cf:	8a 00                	mov    (%eax),%al
  8015d1:	3c 7a                	cmp    $0x7a,%al
  8015d3:	7f 10                	jg     8015e5 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8015d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d8:	8a 00                	mov    (%eax),%al
  8015da:	0f be c0             	movsbl %al,%eax
  8015dd:	83 e8 57             	sub    $0x57,%eax
  8015e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8015e3:	eb 20                	jmp    801605 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8015e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e8:	8a 00                	mov    (%eax),%al
  8015ea:	3c 40                	cmp    $0x40,%al
  8015ec:	7e 39                	jle    801627 <strtol+0x126>
  8015ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f1:	8a 00                	mov    (%eax),%al
  8015f3:	3c 5a                	cmp    $0x5a,%al
  8015f5:	7f 30                	jg     801627 <strtol+0x126>
			dig = *s - 'A' + 10;
  8015f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fa:	8a 00                	mov    (%eax),%al
  8015fc:	0f be c0             	movsbl %al,%eax
  8015ff:	83 e8 37             	sub    $0x37,%eax
  801602:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801605:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801608:	3b 45 10             	cmp    0x10(%ebp),%eax
  80160b:	7d 19                	jge    801626 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80160d:	ff 45 08             	incl   0x8(%ebp)
  801610:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801613:	0f af 45 10          	imul   0x10(%ebp),%eax
  801617:	89 c2                	mov    %eax,%edx
  801619:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80161c:	01 d0                	add    %edx,%eax
  80161e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801621:	e9 7b ff ff ff       	jmp    8015a1 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801626:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801627:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80162b:	74 08                	je     801635 <strtol+0x134>
		*endptr = (char *) s;
  80162d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801630:	8b 55 08             	mov    0x8(%ebp),%edx
  801633:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801635:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801639:	74 07                	je     801642 <strtol+0x141>
  80163b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80163e:	f7 d8                	neg    %eax
  801640:	eb 03                	jmp    801645 <strtol+0x144>
  801642:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801645:	c9                   	leave  
  801646:	c3                   	ret    

00801647 <ltostr>:

void
ltostr(long value, char *str)
{
  801647:	55                   	push   %ebp
  801648:	89 e5                	mov    %esp,%ebp
  80164a:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80164d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801654:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80165b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80165f:	79 13                	jns    801674 <ltostr+0x2d>
	{
		neg = 1;
  801661:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801668:	8b 45 0c             	mov    0xc(%ebp),%eax
  80166b:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80166e:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801671:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801674:	8b 45 08             	mov    0x8(%ebp),%eax
  801677:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80167c:	99                   	cltd   
  80167d:	f7 f9                	idiv   %ecx
  80167f:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801682:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801685:	8d 50 01             	lea    0x1(%eax),%edx
  801688:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80168b:	89 c2                	mov    %eax,%edx
  80168d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801690:	01 d0                	add    %edx,%eax
  801692:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801695:	83 c2 30             	add    $0x30,%edx
  801698:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80169a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80169d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8016a2:	f7 e9                	imul   %ecx
  8016a4:	c1 fa 02             	sar    $0x2,%edx
  8016a7:	89 c8                	mov    %ecx,%eax
  8016a9:	c1 f8 1f             	sar    $0x1f,%eax
  8016ac:	29 c2                	sub    %eax,%edx
  8016ae:	89 d0                	mov    %edx,%eax
  8016b0:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8016b3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016b7:	75 bb                	jne    801674 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8016b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8016c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016c3:	48                   	dec    %eax
  8016c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8016c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8016cb:	74 3d                	je     80170a <ltostr+0xc3>
		start = 1 ;
  8016cd:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8016d4:	eb 34                	jmp    80170a <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8016d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016dc:	01 d0                	add    %edx,%eax
  8016de:	8a 00                	mov    (%eax),%al
  8016e0:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8016e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e9:	01 c2                	add    %eax,%edx
  8016eb:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8016ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f1:	01 c8                	add    %ecx,%eax
  8016f3:	8a 00                	mov    (%eax),%al
  8016f5:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8016f7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016fd:	01 c2                	add    %eax,%edx
  8016ff:	8a 45 eb             	mov    -0x15(%ebp),%al
  801702:	88 02                	mov    %al,(%edx)
		start++ ;
  801704:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801707:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80170a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80170d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801710:	7c c4                	jl     8016d6 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801712:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801715:	8b 45 0c             	mov    0xc(%ebp),%eax
  801718:	01 d0                	add    %edx,%eax
  80171a:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80171d:	90                   	nop
  80171e:	c9                   	leave  
  80171f:	c3                   	ret    

00801720 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801720:	55                   	push   %ebp
  801721:	89 e5                	mov    %esp,%ebp
  801723:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801726:	ff 75 08             	pushl  0x8(%ebp)
  801729:	e8 73 fa ff ff       	call   8011a1 <strlen>
  80172e:	83 c4 04             	add    $0x4,%esp
  801731:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801734:	ff 75 0c             	pushl  0xc(%ebp)
  801737:	e8 65 fa ff ff       	call   8011a1 <strlen>
  80173c:	83 c4 04             	add    $0x4,%esp
  80173f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801742:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801749:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801750:	eb 17                	jmp    801769 <strcconcat+0x49>
		final[s] = str1[s] ;
  801752:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801755:	8b 45 10             	mov    0x10(%ebp),%eax
  801758:	01 c2                	add    %eax,%edx
  80175a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80175d:	8b 45 08             	mov    0x8(%ebp),%eax
  801760:	01 c8                	add    %ecx,%eax
  801762:	8a 00                	mov    (%eax),%al
  801764:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801766:	ff 45 fc             	incl   -0x4(%ebp)
  801769:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80176c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80176f:	7c e1                	jl     801752 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801771:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801778:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80177f:	eb 1f                	jmp    8017a0 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801781:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801784:	8d 50 01             	lea    0x1(%eax),%edx
  801787:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80178a:	89 c2                	mov    %eax,%edx
  80178c:	8b 45 10             	mov    0x10(%ebp),%eax
  80178f:	01 c2                	add    %eax,%edx
  801791:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801794:	8b 45 0c             	mov    0xc(%ebp),%eax
  801797:	01 c8                	add    %ecx,%eax
  801799:	8a 00                	mov    (%eax),%al
  80179b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80179d:	ff 45 f8             	incl   -0x8(%ebp)
  8017a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017a3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8017a6:	7c d9                	jl     801781 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8017a8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ae:	01 d0                	add    %edx,%eax
  8017b0:	c6 00 00             	movb   $0x0,(%eax)
}
  8017b3:	90                   	nop
  8017b4:	c9                   	leave  
  8017b5:	c3                   	ret    

008017b6 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8017b6:	55                   	push   %ebp
  8017b7:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8017b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8017bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8017c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8017c5:	8b 00                	mov    (%eax),%eax
  8017c7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8017d1:	01 d0                	add    %edx,%eax
  8017d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8017d9:	eb 0c                	jmp    8017e7 <strsplit+0x31>
			*string++ = 0;
  8017db:	8b 45 08             	mov    0x8(%ebp),%eax
  8017de:	8d 50 01             	lea    0x1(%eax),%edx
  8017e1:	89 55 08             	mov    %edx,0x8(%ebp)
  8017e4:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8017e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ea:	8a 00                	mov    (%eax),%al
  8017ec:	84 c0                	test   %al,%al
  8017ee:	74 18                	je     801808 <strsplit+0x52>
  8017f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f3:	8a 00                	mov    (%eax),%al
  8017f5:	0f be c0             	movsbl %al,%eax
  8017f8:	50                   	push   %eax
  8017f9:	ff 75 0c             	pushl  0xc(%ebp)
  8017fc:	e8 32 fb ff ff       	call   801333 <strchr>
  801801:	83 c4 08             	add    $0x8,%esp
  801804:	85 c0                	test   %eax,%eax
  801806:	75 d3                	jne    8017db <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801808:	8b 45 08             	mov    0x8(%ebp),%eax
  80180b:	8a 00                	mov    (%eax),%al
  80180d:	84 c0                	test   %al,%al
  80180f:	74 5a                	je     80186b <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801811:	8b 45 14             	mov    0x14(%ebp),%eax
  801814:	8b 00                	mov    (%eax),%eax
  801816:	83 f8 0f             	cmp    $0xf,%eax
  801819:	75 07                	jne    801822 <strsplit+0x6c>
		{
			return 0;
  80181b:	b8 00 00 00 00       	mov    $0x0,%eax
  801820:	eb 66                	jmp    801888 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801822:	8b 45 14             	mov    0x14(%ebp),%eax
  801825:	8b 00                	mov    (%eax),%eax
  801827:	8d 48 01             	lea    0x1(%eax),%ecx
  80182a:	8b 55 14             	mov    0x14(%ebp),%edx
  80182d:	89 0a                	mov    %ecx,(%edx)
  80182f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801836:	8b 45 10             	mov    0x10(%ebp),%eax
  801839:	01 c2                	add    %eax,%edx
  80183b:	8b 45 08             	mov    0x8(%ebp),%eax
  80183e:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801840:	eb 03                	jmp    801845 <strsplit+0x8f>
			string++;
  801842:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801845:	8b 45 08             	mov    0x8(%ebp),%eax
  801848:	8a 00                	mov    (%eax),%al
  80184a:	84 c0                	test   %al,%al
  80184c:	74 8b                	je     8017d9 <strsplit+0x23>
  80184e:	8b 45 08             	mov    0x8(%ebp),%eax
  801851:	8a 00                	mov    (%eax),%al
  801853:	0f be c0             	movsbl %al,%eax
  801856:	50                   	push   %eax
  801857:	ff 75 0c             	pushl  0xc(%ebp)
  80185a:	e8 d4 fa ff ff       	call   801333 <strchr>
  80185f:	83 c4 08             	add    $0x8,%esp
  801862:	85 c0                	test   %eax,%eax
  801864:	74 dc                	je     801842 <strsplit+0x8c>
			string++;
	}
  801866:	e9 6e ff ff ff       	jmp    8017d9 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80186b:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80186c:	8b 45 14             	mov    0x14(%ebp),%eax
  80186f:	8b 00                	mov    (%eax),%eax
  801871:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801878:	8b 45 10             	mov    0x10(%ebp),%eax
  80187b:	01 d0                	add    %edx,%eax
  80187d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801883:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801888:	c9                   	leave  
  801889:	c3                   	ret    

0080188a <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80188a:	55                   	push   %ebp
  80188b:	89 e5                	mov    %esp,%ebp
  80188d:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801890:	83 ec 04             	sub    $0x4,%esp
  801893:	68 48 29 80 00       	push   $0x802948
  801898:	68 3f 01 00 00       	push   $0x13f
  80189d:	68 6a 29 80 00       	push   $0x80296a
  8018a2:	e8 a9 ef ff ff       	call   800850 <_panic>

008018a7 <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  8018a7:	55                   	push   %ebp
  8018a8:	89 e5                	mov    %esp,%ebp
  8018aa:	57                   	push   %edi
  8018ab:	56                   	push   %esi
  8018ac:	53                   	push   %ebx
  8018ad:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018b9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018bc:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018bf:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018c2:	cd 30                	int    $0x30
  8018c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  8018c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018ca:	83 c4 10             	add    $0x10,%esp
  8018cd:	5b                   	pop    %ebx
  8018ce:	5e                   	pop    %esi
  8018cf:	5f                   	pop    %edi
  8018d0:	5d                   	pop    %ebp
  8018d1:	c3                   	ret    

008018d2 <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  8018d2:	55                   	push   %ebp
  8018d3:	89 e5                	mov    %esp,%ebp
  8018d5:	83 ec 04             	sub    $0x4,%esp
  8018d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8018db:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  8018de:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	52                   	push   %edx
  8018ea:	ff 75 0c             	pushl  0xc(%ebp)
  8018ed:	50                   	push   %eax
  8018ee:	6a 00                	push   $0x0
  8018f0:	e8 b2 ff ff ff       	call   8018a7 <syscall>
  8018f5:	83 c4 18             	add    $0x18,%esp
}
  8018f8:	90                   	nop
  8018f9:	c9                   	leave  
  8018fa:	c3                   	ret    

008018fb <sys_cgetc>:

int sys_cgetc(void) {
  8018fb:	55                   	push   %ebp
  8018fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	6a 02                	push   $0x2
  80190a:	e8 98 ff ff ff       	call   8018a7 <syscall>
  80190f:	83 c4 18             	add    $0x18,%esp
}
  801912:	c9                   	leave  
  801913:	c3                   	ret    

00801914 <sys_lock_cons>:

void sys_lock_cons(void) {
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	6a 03                	push   $0x3
  801923:	e8 7f ff ff ff       	call   8018a7 <syscall>
  801928:	83 c4 18             	add    $0x18,%esp
}
  80192b:	90                   	nop
  80192c:	c9                   	leave  
  80192d:	c3                   	ret    

0080192e <sys_unlock_cons>:
void sys_unlock_cons(void) {
  80192e:	55                   	push   %ebp
  80192f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	6a 04                	push   $0x4
  80193d:	e8 65 ff ff ff       	call   8018a7 <syscall>
  801942:	83 c4 18             	add    $0x18,%esp
}
  801945:	90                   	nop
  801946:	c9                   	leave  
  801947:	c3                   	ret    

00801948 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  801948:	55                   	push   %ebp
  801949:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  80194b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80194e:	8b 45 08             	mov    0x8(%ebp),%eax
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	52                   	push   %edx
  801958:	50                   	push   %eax
  801959:	6a 08                	push   $0x8
  80195b:	e8 47 ff ff ff       	call   8018a7 <syscall>
  801960:	83 c4 18             	add    $0x18,%esp
}
  801963:	c9                   	leave  
  801964:	c3                   	ret    

00801965 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  801965:	55                   	push   %ebp
  801966:	89 e5                	mov    %esp,%ebp
  801968:	56                   	push   %esi
  801969:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  80196a:	8b 75 18             	mov    0x18(%ebp),%esi
  80196d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801970:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801973:	8b 55 0c             	mov    0xc(%ebp),%edx
  801976:	8b 45 08             	mov    0x8(%ebp),%eax
  801979:	56                   	push   %esi
  80197a:	53                   	push   %ebx
  80197b:	51                   	push   %ecx
  80197c:	52                   	push   %edx
  80197d:	50                   	push   %eax
  80197e:	6a 09                	push   $0x9
  801980:	e8 22 ff ff ff       	call   8018a7 <syscall>
  801985:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  801988:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80198b:	5b                   	pop    %ebx
  80198c:	5e                   	pop    %esi
  80198d:	5d                   	pop    %ebp
  80198e:	c3                   	ret    

0080198f <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  80198f:	55                   	push   %ebp
  801990:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801992:	8b 55 0c             	mov    0xc(%ebp),%edx
  801995:	8b 45 08             	mov    0x8(%ebp),%eax
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	52                   	push   %edx
  80199f:	50                   	push   %eax
  8019a0:	6a 0a                	push   $0xa
  8019a2:	e8 00 ff ff ff       	call   8018a7 <syscall>
  8019a7:	83 c4 18             	add    $0x18,%esp
}
  8019aa:	c9                   	leave  
  8019ab:	c3                   	ret    

008019ac <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  8019ac:	55                   	push   %ebp
  8019ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	ff 75 0c             	pushl  0xc(%ebp)
  8019b8:	ff 75 08             	pushl  0x8(%ebp)
  8019bb:	6a 0b                	push   $0xb
  8019bd:	e8 e5 fe ff ff       	call   8018a7 <syscall>
  8019c2:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  8019c5:	c9                   	leave  
  8019c6:	c3                   	ret    

008019c7 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  8019c7:	55                   	push   %ebp
  8019c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 0c                	push   $0xc
  8019d6:	e8 cc fe ff ff       	call   8018a7 <syscall>
  8019db:	83 c4 18             	add    $0x18,%esp
}
  8019de:	c9                   	leave  
  8019df:	c3                   	ret    

008019e0 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 0d                	push   $0xd
  8019ef:	e8 b3 fe ff ff       	call   8018a7 <syscall>
  8019f4:	83 c4 18             	add    $0x18,%esp
}
  8019f7:	c9                   	leave  
  8019f8:	c3                   	ret    

008019f9 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  8019f9:	55                   	push   %ebp
  8019fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 0e                	push   $0xe
  801a08:	e8 9a fe ff ff       	call   8018a7 <syscall>
  801a0d:	83 c4 18             	add    $0x18,%esp
}
  801a10:	c9                   	leave  
  801a11:	c3                   	ret    

00801a12 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  801a12:	55                   	push   %ebp
  801a13:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 0f                	push   $0xf
  801a21:	e8 81 fe ff ff       	call   8018a7 <syscall>
  801a26:	83 c4 18             	add    $0x18,%esp
}
  801a29:	c9                   	leave  
  801a2a:	c3                   	ret    

00801a2b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  801a2b:	55                   	push   %ebp
  801a2c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	ff 75 08             	pushl  0x8(%ebp)
  801a39:	6a 10                	push   $0x10
  801a3b:	e8 67 fe ff ff       	call   8018a7 <syscall>
  801a40:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  801a43:	c9                   	leave  
  801a44:	c3                   	ret    

00801a45 <sys_scarce_memory>:

void sys_scarce_memory() {
  801a45:	55                   	push   %ebp
  801a46:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	6a 11                	push   $0x11
  801a54:	e8 4e fe ff ff       	call   8018a7 <syscall>
  801a59:	83 c4 18             	add    $0x18,%esp
}
  801a5c:	90                   	nop
  801a5d:	c9                   	leave  
  801a5e:	c3                   	ret    

00801a5f <sys_cputc>:

void sys_cputc(const char c) {
  801a5f:	55                   	push   %ebp
  801a60:	89 e5                	mov    %esp,%ebp
  801a62:	83 ec 04             	sub    $0x4,%esp
  801a65:	8b 45 08             	mov    0x8(%ebp),%eax
  801a68:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a6b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	50                   	push   %eax
  801a78:	6a 01                	push   $0x1
  801a7a:	e8 28 fe ff ff       	call   8018a7 <syscall>
  801a7f:	83 c4 18             	add    $0x18,%esp
}
  801a82:	90                   	nop
  801a83:	c9                   	leave  
  801a84:	c3                   	ret    

00801a85 <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  801a85:	55                   	push   %ebp
  801a86:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 14                	push   $0x14
  801a94:	e8 0e fe ff ff       	call   8018a7 <syscall>
  801a99:	83 c4 18             	add    $0x18,%esp
}
  801a9c:	90                   	nop
  801a9d:	c9                   	leave  
  801a9e:	c3                   	ret    

00801a9f <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  801a9f:	55                   	push   %ebp
  801aa0:	89 e5                	mov    %esp,%ebp
  801aa2:	83 ec 04             	sub    $0x4,%esp
  801aa5:	8b 45 10             	mov    0x10(%ebp),%eax
  801aa8:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  801aab:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801aae:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab5:	6a 00                	push   $0x0
  801ab7:	51                   	push   %ecx
  801ab8:	52                   	push   %edx
  801ab9:	ff 75 0c             	pushl  0xc(%ebp)
  801abc:	50                   	push   %eax
  801abd:	6a 15                	push   $0x15
  801abf:	e8 e3 fd ff ff       	call   8018a7 <syscall>
  801ac4:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  801ac7:	c9                   	leave  
  801ac8:	c3                   	ret    

00801ac9 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  801ac9:	55                   	push   %ebp
  801aca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  801acc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801acf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	52                   	push   %edx
  801ad9:	50                   	push   %eax
  801ada:	6a 16                	push   $0x16
  801adc:	e8 c6 fd ff ff       	call   8018a7 <syscall>
  801ae1:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  801ae4:	c9                   	leave  
  801ae5:	c3                   	ret    

00801ae6 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  801ae6:	55                   	push   %ebp
  801ae7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  801ae9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801aec:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aef:	8b 45 08             	mov    0x8(%ebp),%eax
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	51                   	push   %ecx
  801af7:	52                   	push   %edx
  801af8:	50                   	push   %eax
  801af9:	6a 17                	push   $0x17
  801afb:	e8 a7 fd ff ff       	call   8018a7 <syscall>
  801b00:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  801b03:	c9                   	leave  
  801b04:	c3                   	ret    

00801b05 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  801b05:	55                   	push   %ebp
  801b06:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  801b08:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	52                   	push   %edx
  801b15:	50                   	push   %eax
  801b16:	6a 18                	push   $0x18
  801b18:	e8 8a fd ff ff       	call   8018a7 <syscall>
  801b1d:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  801b20:	c9                   	leave  
  801b21:	c3                   	ret    

00801b22 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  801b22:	55                   	push   %ebp
  801b23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  801b25:	8b 45 08             	mov    0x8(%ebp),%eax
  801b28:	6a 00                	push   $0x0
  801b2a:	ff 75 14             	pushl  0x14(%ebp)
  801b2d:	ff 75 10             	pushl  0x10(%ebp)
  801b30:	ff 75 0c             	pushl  0xc(%ebp)
  801b33:	50                   	push   %eax
  801b34:	6a 19                	push   $0x19
  801b36:	e8 6c fd ff ff       	call   8018a7 <syscall>
  801b3b:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  801b3e:	c9                   	leave  
  801b3f:	c3                   	ret    

00801b40 <sys_run_env>:

void sys_run_env(int32 envId) {
  801b40:	55                   	push   %ebp
  801b41:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  801b43:	8b 45 08             	mov    0x8(%ebp),%eax
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	50                   	push   %eax
  801b4f:	6a 1a                	push   $0x1a
  801b51:	e8 51 fd ff ff       	call   8018a7 <syscall>
  801b56:	83 c4 18             	add    $0x18,%esp
}
  801b59:	90                   	nop
  801b5a:	c9                   	leave  
  801b5b:	c3                   	ret    

00801b5c <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  801b5c:	55                   	push   %ebp
  801b5d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	50                   	push   %eax
  801b6b:	6a 1b                	push   $0x1b
  801b6d:	e8 35 fd ff ff       	call   8018a7 <syscall>
  801b72:	83 c4 18             	add    $0x18,%esp
}
  801b75:	c9                   	leave  
  801b76:	c3                   	ret    

00801b77 <sys_getenvid>:

int32 sys_getenvid(void) {
  801b77:	55                   	push   %ebp
  801b78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	6a 05                	push   $0x5
  801b86:	e8 1c fd ff ff       	call   8018a7 <syscall>
  801b8b:	83 c4 18             	add    $0x18,%esp
}
  801b8e:	c9                   	leave  
  801b8f:	c3                   	ret    

00801b90 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  801b90:	55                   	push   %ebp
  801b91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 06                	push   $0x6
  801b9f:	e8 03 fd ff ff       	call   8018a7 <syscall>
  801ba4:	83 c4 18             	add    $0x18,%esp
}
  801ba7:	c9                   	leave  
  801ba8:	c3                   	ret    

00801ba9 <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  801ba9:	55                   	push   %ebp
  801baa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 07                	push   $0x7
  801bb8:	e8 ea fc ff ff       	call   8018a7 <syscall>
  801bbd:	83 c4 18             	add    $0x18,%esp
}
  801bc0:	c9                   	leave  
  801bc1:	c3                   	ret    

00801bc2 <sys_exit_env>:

void sys_exit_env(void) {
  801bc2:	55                   	push   %ebp
  801bc3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 1c                	push   $0x1c
  801bd1:	e8 d1 fc ff ff       	call   8018a7 <syscall>
  801bd6:	83 c4 18             	add    $0x18,%esp
}
  801bd9:	90                   	nop
  801bda:	c9                   	leave  
  801bdb:	c3                   	ret    

00801bdc <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  801bdc:	55                   	push   %ebp
  801bdd:	89 e5                	mov    %esp,%ebp
  801bdf:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  801be2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801be5:	8d 50 04             	lea    0x4(%eax),%edx
  801be8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	52                   	push   %edx
  801bf2:	50                   	push   %eax
  801bf3:	6a 1d                	push   $0x1d
  801bf5:	e8 ad fc ff ff       	call   8018a7 <syscall>
  801bfa:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  801bfd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c00:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c03:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c06:	89 01                	mov    %eax,(%ecx)
  801c08:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0e:	c9                   	leave  
  801c0f:	c2 04 00             	ret    $0x4

00801c12 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  801c12:	55                   	push   %ebp
  801c13:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	ff 75 10             	pushl  0x10(%ebp)
  801c1c:	ff 75 0c             	pushl  0xc(%ebp)
  801c1f:	ff 75 08             	pushl  0x8(%ebp)
  801c22:	6a 13                	push   $0x13
  801c24:	e8 7e fc ff ff       	call   8018a7 <syscall>
  801c29:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  801c2c:	90                   	nop
}
  801c2d:	c9                   	leave  
  801c2e:	c3                   	ret    

00801c2f <sys_rcr2>:
uint32 sys_rcr2() {
  801c2f:	55                   	push   %ebp
  801c30:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 1e                	push   $0x1e
  801c3e:	e8 64 fc ff ff       	call   8018a7 <syscall>
  801c43:	83 c4 18             	add    $0x18,%esp
}
  801c46:	c9                   	leave  
  801c47:	c3                   	ret    

00801c48 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  801c48:	55                   	push   %ebp
  801c49:	89 e5                	mov    %esp,%ebp
  801c4b:	83 ec 04             	sub    $0x4,%esp
  801c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c51:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c54:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	50                   	push   %eax
  801c61:	6a 1f                	push   $0x1f
  801c63:	e8 3f fc ff ff       	call   8018a7 <syscall>
  801c68:	83 c4 18             	add    $0x18,%esp
	return;
  801c6b:	90                   	nop
}
  801c6c:	c9                   	leave  
  801c6d:	c3                   	ret    

00801c6e <rsttst>:
void rsttst() {
  801c6e:	55                   	push   %ebp
  801c6f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 21                	push   $0x21
  801c7d:	e8 25 fc ff ff       	call   8018a7 <syscall>
  801c82:	83 c4 18             	add    $0x18,%esp
	return;
  801c85:	90                   	nop
}
  801c86:	c9                   	leave  
  801c87:	c3                   	ret    

00801c88 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  801c88:	55                   	push   %ebp
  801c89:	89 e5                	mov    %esp,%ebp
  801c8b:	83 ec 04             	sub    $0x4,%esp
  801c8e:	8b 45 14             	mov    0x14(%ebp),%eax
  801c91:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c94:	8b 55 18             	mov    0x18(%ebp),%edx
  801c97:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c9b:	52                   	push   %edx
  801c9c:	50                   	push   %eax
  801c9d:	ff 75 10             	pushl  0x10(%ebp)
  801ca0:	ff 75 0c             	pushl  0xc(%ebp)
  801ca3:	ff 75 08             	pushl  0x8(%ebp)
  801ca6:	6a 20                	push   $0x20
  801ca8:	e8 fa fb ff ff       	call   8018a7 <syscall>
  801cad:	83 c4 18             	add    $0x18,%esp
	return;
  801cb0:	90                   	nop
}
  801cb1:	c9                   	leave  
  801cb2:	c3                   	ret    

00801cb3 <chktst>:
void chktst(uint32 n) {
  801cb3:	55                   	push   %ebp
  801cb4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	ff 75 08             	pushl  0x8(%ebp)
  801cc1:	6a 22                	push   $0x22
  801cc3:	e8 df fb ff ff       	call   8018a7 <syscall>
  801cc8:	83 c4 18             	add    $0x18,%esp
	return;
  801ccb:	90                   	nop
}
  801ccc:	c9                   	leave  
  801ccd:	c3                   	ret    

00801cce <inctst>:

void inctst() {
  801cce:	55                   	push   %ebp
  801ccf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 00                	push   $0x0
  801cdb:	6a 23                	push   $0x23
  801cdd:	e8 c5 fb ff ff       	call   8018a7 <syscall>
  801ce2:	83 c4 18             	add    $0x18,%esp
	return;
  801ce5:	90                   	nop
}
  801ce6:	c9                   	leave  
  801ce7:	c3                   	ret    

00801ce8 <gettst>:
uint32 gettst() {
  801ce8:	55                   	push   %ebp
  801ce9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 24                	push   $0x24
  801cf7:	e8 ab fb ff ff       	call   8018a7 <syscall>
  801cfc:	83 c4 18             	add    $0x18,%esp
}
  801cff:	c9                   	leave  
  801d00:	c3                   	ret    

00801d01 <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  801d01:	55                   	push   %ebp
  801d02:	89 e5                	mov    %esp,%ebp
  801d04:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d07:	6a 00                	push   $0x0
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 25                	push   $0x25
  801d13:	e8 8f fb ff ff       	call   8018a7 <syscall>
  801d18:	83 c4 18             	add    $0x18,%esp
  801d1b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d1e:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d22:	75 07                	jne    801d2b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d24:	b8 01 00 00 00       	mov    $0x1,%eax
  801d29:	eb 05                	jmp    801d30 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d2b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d30:	c9                   	leave  
  801d31:	c3                   	ret    

00801d32 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  801d32:	55                   	push   %ebp
  801d33:	89 e5                	mov    %esp,%ebp
  801d35:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 00                	push   $0x0
  801d42:	6a 25                	push   $0x25
  801d44:	e8 5e fb ff ff       	call   8018a7 <syscall>
  801d49:	83 c4 18             	add    $0x18,%esp
  801d4c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d4f:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d53:	75 07                	jne    801d5c <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d55:	b8 01 00 00 00       	mov    $0x1,%eax
  801d5a:	eb 05                	jmp    801d61 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d5c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d61:	c9                   	leave  
  801d62:	c3                   	ret    

00801d63 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  801d63:	55                   	push   %ebp
  801d64:	89 e5                	mov    %esp,%ebp
  801d66:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	6a 25                	push   $0x25
  801d75:	e8 2d fb ff ff       	call   8018a7 <syscall>
  801d7a:	83 c4 18             	add    $0x18,%esp
  801d7d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d80:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d84:	75 07                	jne    801d8d <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d86:	b8 01 00 00 00       	mov    $0x1,%eax
  801d8b:	eb 05                	jmp    801d92 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d92:	c9                   	leave  
  801d93:	c3                   	ret    

00801d94 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  801d94:	55                   	push   %ebp
  801d95:	89 e5                	mov    %esp,%ebp
  801d97:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d9a:	6a 00                	push   $0x0
  801d9c:	6a 00                	push   $0x0
  801d9e:	6a 00                	push   $0x0
  801da0:	6a 00                	push   $0x0
  801da2:	6a 00                	push   $0x0
  801da4:	6a 25                	push   $0x25
  801da6:	e8 fc fa ff ff       	call   8018a7 <syscall>
  801dab:	83 c4 18             	add    $0x18,%esp
  801dae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801db1:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801db5:	75 07                	jne    801dbe <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801db7:	b8 01 00 00 00       	mov    $0x1,%eax
  801dbc:	eb 05                	jmp    801dc3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801dbe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dc3:	c9                   	leave  
  801dc4:	c3                   	ret    

00801dc5 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  801dc5:	55                   	push   %ebp
  801dc6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 00                	push   $0x0
  801dd0:	ff 75 08             	pushl  0x8(%ebp)
  801dd3:	6a 26                	push   $0x26
  801dd5:	e8 cd fa ff ff       	call   8018a7 <syscall>
  801dda:	83 c4 18             	add    $0x18,%esp
	return;
  801ddd:	90                   	nop
}
  801dde:	c9                   	leave  
  801ddf:	c3                   	ret    

00801de0 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  801de0:	55                   	push   %ebp
  801de1:	89 e5                	mov    %esp,%ebp
  801de3:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  801de4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801de7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dea:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ded:	8b 45 08             	mov    0x8(%ebp),%eax
  801df0:	6a 00                	push   $0x0
  801df2:	53                   	push   %ebx
  801df3:	51                   	push   %ecx
  801df4:	52                   	push   %edx
  801df5:	50                   	push   %eax
  801df6:	6a 27                	push   $0x27
  801df8:	e8 aa fa ff ff       	call   8018a7 <syscall>
  801dfd:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  801e00:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e03:	c9                   	leave  
  801e04:	c3                   	ret    

00801e05 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  801e05:	55                   	push   %ebp
  801e06:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  801e08:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	52                   	push   %edx
  801e15:	50                   	push   %eax
  801e16:	6a 28                	push   $0x28
  801e18:	e8 8a fa ff ff       	call   8018a7 <syscall>
  801e1d:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  801e20:	c9                   	leave  
  801e21:	c3                   	ret    

00801e22 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  801e22:	55                   	push   %ebp
  801e23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  801e25:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e28:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2e:	6a 00                	push   $0x0
  801e30:	51                   	push   %ecx
  801e31:	ff 75 10             	pushl  0x10(%ebp)
  801e34:	52                   	push   %edx
  801e35:	50                   	push   %eax
  801e36:	6a 29                	push   $0x29
  801e38:	e8 6a fa ff ff       	call   8018a7 <syscall>
  801e3d:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  801e40:	c9                   	leave  
  801e41:	c3                   	ret    

00801e42 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  801e42:	55                   	push   %ebp
  801e43:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e45:	6a 00                	push   $0x0
  801e47:	6a 00                	push   $0x0
  801e49:	ff 75 10             	pushl  0x10(%ebp)
  801e4c:	ff 75 0c             	pushl  0xc(%ebp)
  801e4f:	ff 75 08             	pushl  0x8(%ebp)
  801e52:	6a 12                	push   $0x12
  801e54:	e8 4e fa ff ff       	call   8018a7 <syscall>
  801e59:	83 c4 18             	add    $0x18,%esp
	return;
  801e5c:	90                   	nop
}
  801e5d:	c9                   	leave  
  801e5e:	c3                   	ret    

00801e5f <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  801e5f:	55                   	push   %ebp
  801e60:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  801e62:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e65:	8b 45 08             	mov    0x8(%ebp),%eax
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	6a 00                	push   $0x0
  801e6e:	52                   	push   %edx
  801e6f:	50                   	push   %eax
  801e70:	6a 2a                	push   $0x2a
  801e72:	e8 30 fa ff ff       	call   8018a7 <syscall>
  801e77:	83 c4 18             	add    $0x18,%esp
	return;
  801e7a:	90                   	nop
}
  801e7b:	c9                   	leave  
  801e7c:	c3                   	ret    

00801e7d <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  801e7d:	55                   	push   %ebp
  801e7e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  801e80:	8b 45 08             	mov    0x8(%ebp),%eax
  801e83:	6a 00                	push   $0x0
  801e85:	6a 00                	push   $0x0
  801e87:	6a 00                	push   $0x0
  801e89:	6a 00                	push   $0x0
  801e8b:	50                   	push   %eax
  801e8c:	6a 2b                	push   $0x2b
  801e8e:	e8 14 fa ff ff       	call   8018a7 <syscall>
  801e93:	83 c4 18             	add    $0x18,%esp
}
  801e96:	c9                   	leave  
  801e97:	c3                   	ret    

00801e98 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  801e98:	55                   	push   %ebp
  801e99:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	ff 75 0c             	pushl  0xc(%ebp)
  801ea4:	ff 75 08             	pushl  0x8(%ebp)
  801ea7:	6a 2c                	push   $0x2c
  801ea9:	e8 f9 f9 ff ff       	call   8018a7 <syscall>
  801eae:	83 c4 18             	add    $0x18,%esp
	return;
  801eb1:	90                   	nop
}
  801eb2:	c9                   	leave  
  801eb3:	c3                   	ret    

00801eb4 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  801eb4:	55                   	push   %ebp
  801eb5:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 00                	push   $0x0
  801ebd:	ff 75 0c             	pushl  0xc(%ebp)
  801ec0:	ff 75 08             	pushl  0x8(%ebp)
  801ec3:	6a 2d                	push   $0x2d
  801ec5:	e8 dd f9 ff ff       	call   8018a7 <syscall>
  801eca:	83 c4 18             	add    $0x18,%esp
	return;
  801ecd:	90                   	nop
}
  801ece:	c9                   	leave  
  801ecf:	c3                   	ret    

00801ed0 <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  801ed0:	55                   	push   %ebp
  801ed1:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  801ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed6:	6a 00                	push   $0x0
  801ed8:	6a 00                	push   $0x0
  801eda:	6a 00                	push   $0x0
  801edc:	6a 00                	push   $0x0
  801ede:	50                   	push   %eax
  801edf:	6a 2f                	push   $0x2f
  801ee1:	e8 c1 f9 ff ff       	call   8018a7 <syscall>
  801ee6:	83 c4 18             	add    $0x18,%esp
	return;
  801ee9:	90                   	nop
}
  801eea:	c9                   	leave  
  801eeb:	c3                   	ret    

00801eec <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  801eec:	55                   	push   %ebp
  801eed:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  801eef:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef5:	6a 00                	push   $0x0
  801ef7:	6a 00                	push   $0x0
  801ef9:	6a 00                	push   $0x0
  801efb:	52                   	push   %edx
  801efc:	50                   	push   %eax
  801efd:	6a 30                	push   $0x30
  801eff:	e8 a3 f9 ff ff       	call   8018a7 <syscall>
  801f04:	83 c4 18             	add    $0x18,%esp
	return;
  801f07:	90                   	nop
}
  801f08:	c9                   	leave  
  801f09:	c3                   	ret    

00801f0a <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  801f0a:	55                   	push   %ebp
  801f0b:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  801f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f10:	6a 00                	push   $0x0
  801f12:	6a 00                	push   $0x0
  801f14:	6a 00                	push   $0x0
  801f16:	6a 00                	push   $0x0
  801f18:	50                   	push   %eax
  801f19:	6a 31                	push   $0x31
  801f1b:	e8 87 f9 ff ff       	call   8018a7 <syscall>
  801f20:	83 c4 18             	add    $0x18,%esp
	return;
  801f23:	90                   	nop
}
  801f24:	c9                   	leave  
  801f25:	c3                   	ret    

00801f26 <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  801f26:	55                   	push   %ebp
  801f27:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801f29:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2f:	6a 00                	push   $0x0
  801f31:	6a 00                	push   $0x0
  801f33:	6a 00                	push   $0x0
  801f35:	52                   	push   %edx
  801f36:	50                   	push   %eax
  801f37:	6a 2e                	push   $0x2e
  801f39:	e8 69 f9 ff ff       	call   8018a7 <syscall>
  801f3e:	83 c4 18             	add    $0x18,%esp
    return;
  801f41:	90                   	nop
}
  801f42:	c9                   	leave  
  801f43:	c3                   	ret    

00801f44 <__udivdi3>:
  801f44:	55                   	push   %ebp
  801f45:	57                   	push   %edi
  801f46:	56                   	push   %esi
  801f47:	53                   	push   %ebx
  801f48:	83 ec 1c             	sub    $0x1c,%esp
  801f4b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801f4f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801f53:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801f57:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f5b:	89 ca                	mov    %ecx,%edx
  801f5d:	89 f8                	mov    %edi,%eax
  801f5f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801f63:	85 f6                	test   %esi,%esi
  801f65:	75 2d                	jne    801f94 <__udivdi3+0x50>
  801f67:	39 cf                	cmp    %ecx,%edi
  801f69:	77 65                	ja     801fd0 <__udivdi3+0x8c>
  801f6b:	89 fd                	mov    %edi,%ebp
  801f6d:	85 ff                	test   %edi,%edi
  801f6f:	75 0b                	jne    801f7c <__udivdi3+0x38>
  801f71:	b8 01 00 00 00       	mov    $0x1,%eax
  801f76:	31 d2                	xor    %edx,%edx
  801f78:	f7 f7                	div    %edi
  801f7a:	89 c5                	mov    %eax,%ebp
  801f7c:	31 d2                	xor    %edx,%edx
  801f7e:	89 c8                	mov    %ecx,%eax
  801f80:	f7 f5                	div    %ebp
  801f82:	89 c1                	mov    %eax,%ecx
  801f84:	89 d8                	mov    %ebx,%eax
  801f86:	f7 f5                	div    %ebp
  801f88:	89 cf                	mov    %ecx,%edi
  801f8a:	89 fa                	mov    %edi,%edx
  801f8c:	83 c4 1c             	add    $0x1c,%esp
  801f8f:	5b                   	pop    %ebx
  801f90:	5e                   	pop    %esi
  801f91:	5f                   	pop    %edi
  801f92:	5d                   	pop    %ebp
  801f93:	c3                   	ret    
  801f94:	39 ce                	cmp    %ecx,%esi
  801f96:	77 28                	ja     801fc0 <__udivdi3+0x7c>
  801f98:	0f bd fe             	bsr    %esi,%edi
  801f9b:	83 f7 1f             	xor    $0x1f,%edi
  801f9e:	75 40                	jne    801fe0 <__udivdi3+0x9c>
  801fa0:	39 ce                	cmp    %ecx,%esi
  801fa2:	72 0a                	jb     801fae <__udivdi3+0x6a>
  801fa4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801fa8:	0f 87 9e 00 00 00    	ja     80204c <__udivdi3+0x108>
  801fae:	b8 01 00 00 00       	mov    $0x1,%eax
  801fb3:	89 fa                	mov    %edi,%edx
  801fb5:	83 c4 1c             	add    $0x1c,%esp
  801fb8:	5b                   	pop    %ebx
  801fb9:	5e                   	pop    %esi
  801fba:	5f                   	pop    %edi
  801fbb:	5d                   	pop    %ebp
  801fbc:	c3                   	ret    
  801fbd:	8d 76 00             	lea    0x0(%esi),%esi
  801fc0:	31 ff                	xor    %edi,%edi
  801fc2:	31 c0                	xor    %eax,%eax
  801fc4:	89 fa                	mov    %edi,%edx
  801fc6:	83 c4 1c             	add    $0x1c,%esp
  801fc9:	5b                   	pop    %ebx
  801fca:	5e                   	pop    %esi
  801fcb:	5f                   	pop    %edi
  801fcc:	5d                   	pop    %ebp
  801fcd:	c3                   	ret    
  801fce:	66 90                	xchg   %ax,%ax
  801fd0:	89 d8                	mov    %ebx,%eax
  801fd2:	f7 f7                	div    %edi
  801fd4:	31 ff                	xor    %edi,%edi
  801fd6:	89 fa                	mov    %edi,%edx
  801fd8:	83 c4 1c             	add    $0x1c,%esp
  801fdb:	5b                   	pop    %ebx
  801fdc:	5e                   	pop    %esi
  801fdd:	5f                   	pop    %edi
  801fde:	5d                   	pop    %ebp
  801fdf:	c3                   	ret    
  801fe0:	bd 20 00 00 00       	mov    $0x20,%ebp
  801fe5:	89 eb                	mov    %ebp,%ebx
  801fe7:	29 fb                	sub    %edi,%ebx
  801fe9:	89 f9                	mov    %edi,%ecx
  801feb:	d3 e6                	shl    %cl,%esi
  801fed:	89 c5                	mov    %eax,%ebp
  801fef:	88 d9                	mov    %bl,%cl
  801ff1:	d3 ed                	shr    %cl,%ebp
  801ff3:	89 e9                	mov    %ebp,%ecx
  801ff5:	09 f1                	or     %esi,%ecx
  801ff7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801ffb:	89 f9                	mov    %edi,%ecx
  801ffd:	d3 e0                	shl    %cl,%eax
  801fff:	89 c5                	mov    %eax,%ebp
  802001:	89 d6                	mov    %edx,%esi
  802003:	88 d9                	mov    %bl,%cl
  802005:	d3 ee                	shr    %cl,%esi
  802007:	89 f9                	mov    %edi,%ecx
  802009:	d3 e2                	shl    %cl,%edx
  80200b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80200f:	88 d9                	mov    %bl,%cl
  802011:	d3 e8                	shr    %cl,%eax
  802013:	09 c2                	or     %eax,%edx
  802015:	89 d0                	mov    %edx,%eax
  802017:	89 f2                	mov    %esi,%edx
  802019:	f7 74 24 0c          	divl   0xc(%esp)
  80201d:	89 d6                	mov    %edx,%esi
  80201f:	89 c3                	mov    %eax,%ebx
  802021:	f7 e5                	mul    %ebp
  802023:	39 d6                	cmp    %edx,%esi
  802025:	72 19                	jb     802040 <__udivdi3+0xfc>
  802027:	74 0b                	je     802034 <__udivdi3+0xf0>
  802029:	89 d8                	mov    %ebx,%eax
  80202b:	31 ff                	xor    %edi,%edi
  80202d:	e9 58 ff ff ff       	jmp    801f8a <__udivdi3+0x46>
  802032:	66 90                	xchg   %ax,%ax
  802034:	8b 54 24 08          	mov    0x8(%esp),%edx
  802038:	89 f9                	mov    %edi,%ecx
  80203a:	d3 e2                	shl    %cl,%edx
  80203c:	39 c2                	cmp    %eax,%edx
  80203e:	73 e9                	jae    802029 <__udivdi3+0xe5>
  802040:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802043:	31 ff                	xor    %edi,%edi
  802045:	e9 40 ff ff ff       	jmp    801f8a <__udivdi3+0x46>
  80204a:	66 90                	xchg   %ax,%ax
  80204c:	31 c0                	xor    %eax,%eax
  80204e:	e9 37 ff ff ff       	jmp    801f8a <__udivdi3+0x46>
  802053:	90                   	nop

00802054 <__umoddi3>:
  802054:	55                   	push   %ebp
  802055:	57                   	push   %edi
  802056:	56                   	push   %esi
  802057:	53                   	push   %ebx
  802058:	83 ec 1c             	sub    $0x1c,%esp
  80205b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80205f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802063:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802067:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80206b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80206f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802073:	89 f3                	mov    %esi,%ebx
  802075:	89 fa                	mov    %edi,%edx
  802077:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80207b:	89 34 24             	mov    %esi,(%esp)
  80207e:	85 c0                	test   %eax,%eax
  802080:	75 1a                	jne    80209c <__umoddi3+0x48>
  802082:	39 f7                	cmp    %esi,%edi
  802084:	0f 86 a2 00 00 00    	jbe    80212c <__umoddi3+0xd8>
  80208a:	89 c8                	mov    %ecx,%eax
  80208c:	89 f2                	mov    %esi,%edx
  80208e:	f7 f7                	div    %edi
  802090:	89 d0                	mov    %edx,%eax
  802092:	31 d2                	xor    %edx,%edx
  802094:	83 c4 1c             	add    $0x1c,%esp
  802097:	5b                   	pop    %ebx
  802098:	5e                   	pop    %esi
  802099:	5f                   	pop    %edi
  80209a:	5d                   	pop    %ebp
  80209b:	c3                   	ret    
  80209c:	39 f0                	cmp    %esi,%eax
  80209e:	0f 87 ac 00 00 00    	ja     802150 <__umoddi3+0xfc>
  8020a4:	0f bd e8             	bsr    %eax,%ebp
  8020a7:	83 f5 1f             	xor    $0x1f,%ebp
  8020aa:	0f 84 ac 00 00 00    	je     80215c <__umoddi3+0x108>
  8020b0:	bf 20 00 00 00       	mov    $0x20,%edi
  8020b5:	29 ef                	sub    %ebp,%edi
  8020b7:	89 fe                	mov    %edi,%esi
  8020b9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8020bd:	89 e9                	mov    %ebp,%ecx
  8020bf:	d3 e0                	shl    %cl,%eax
  8020c1:	89 d7                	mov    %edx,%edi
  8020c3:	89 f1                	mov    %esi,%ecx
  8020c5:	d3 ef                	shr    %cl,%edi
  8020c7:	09 c7                	or     %eax,%edi
  8020c9:	89 e9                	mov    %ebp,%ecx
  8020cb:	d3 e2                	shl    %cl,%edx
  8020cd:	89 14 24             	mov    %edx,(%esp)
  8020d0:	89 d8                	mov    %ebx,%eax
  8020d2:	d3 e0                	shl    %cl,%eax
  8020d4:	89 c2                	mov    %eax,%edx
  8020d6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8020da:	d3 e0                	shl    %cl,%eax
  8020dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020e0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8020e4:	89 f1                	mov    %esi,%ecx
  8020e6:	d3 e8                	shr    %cl,%eax
  8020e8:	09 d0                	or     %edx,%eax
  8020ea:	d3 eb                	shr    %cl,%ebx
  8020ec:	89 da                	mov    %ebx,%edx
  8020ee:	f7 f7                	div    %edi
  8020f0:	89 d3                	mov    %edx,%ebx
  8020f2:	f7 24 24             	mull   (%esp)
  8020f5:	89 c6                	mov    %eax,%esi
  8020f7:	89 d1                	mov    %edx,%ecx
  8020f9:	39 d3                	cmp    %edx,%ebx
  8020fb:	0f 82 87 00 00 00    	jb     802188 <__umoddi3+0x134>
  802101:	0f 84 91 00 00 00    	je     802198 <__umoddi3+0x144>
  802107:	8b 54 24 04          	mov    0x4(%esp),%edx
  80210b:	29 f2                	sub    %esi,%edx
  80210d:	19 cb                	sbb    %ecx,%ebx
  80210f:	89 d8                	mov    %ebx,%eax
  802111:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802115:	d3 e0                	shl    %cl,%eax
  802117:	89 e9                	mov    %ebp,%ecx
  802119:	d3 ea                	shr    %cl,%edx
  80211b:	09 d0                	or     %edx,%eax
  80211d:	89 e9                	mov    %ebp,%ecx
  80211f:	d3 eb                	shr    %cl,%ebx
  802121:	89 da                	mov    %ebx,%edx
  802123:	83 c4 1c             	add    $0x1c,%esp
  802126:	5b                   	pop    %ebx
  802127:	5e                   	pop    %esi
  802128:	5f                   	pop    %edi
  802129:	5d                   	pop    %ebp
  80212a:	c3                   	ret    
  80212b:	90                   	nop
  80212c:	89 fd                	mov    %edi,%ebp
  80212e:	85 ff                	test   %edi,%edi
  802130:	75 0b                	jne    80213d <__umoddi3+0xe9>
  802132:	b8 01 00 00 00       	mov    $0x1,%eax
  802137:	31 d2                	xor    %edx,%edx
  802139:	f7 f7                	div    %edi
  80213b:	89 c5                	mov    %eax,%ebp
  80213d:	89 f0                	mov    %esi,%eax
  80213f:	31 d2                	xor    %edx,%edx
  802141:	f7 f5                	div    %ebp
  802143:	89 c8                	mov    %ecx,%eax
  802145:	f7 f5                	div    %ebp
  802147:	89 d0                	mov    %edx,%eax
  802149:	e9 44 ff ff ff       	jmp    802092 <__umoddi3+0x3e>
  80214e:	66 90                	xchg   %ax,%ax
  802150:	89 c8                	mov    %ecx,%eax
  802152:	89 f2                	mov    %esi,%edx
  802154:	83 c4 1c             	add    $0x1c,%esp
  802157:	5b                   	pop    %ebx
  802158:	5e                   	pop    %esi
  802159:	5f                   	pop    %edi
  80215a:	5d                   	pop    %ebp
  80215b:	c3                   	ret    
  80215c:	3b 04 24             	cmp    (%esp),%eax
  80215f:	72 06                	jb     802167 <__umoddi3+0x113>
  802161:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802165:	77 0f                	ja     802176 <__umoddi3+0x122>
  802167:	89 f2                	mov    %esi,%edx
  802169:	29 f9                	sub    %edi,%ecx
  80216b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80216f:	89 14 24             	mov    %edx,(%esp)
  802172:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802176:	8b 44 24 04          	mov    0x4(%esp),%eax
  80217a:	8b 14 24             	mov    (%esp),%edx
  80217d:	83 c4 1c             	add    $0x1c,%esp
  802180:	5b                   	pop    %ebx
  802181:	5e                   	pop    %esi
  802182:	5f                   	pop    %edi
  802183:	5d                   	pop    %ebp
  802184:	c3                   	ret    
  802185:	8d 76 00             	lea    0x0(%esi),%esi
  802188:	2b 04 24             	sub    (%esp),%eax
  80218b:	19 fa                	sbb    %edi,%edx
  80218d:	89 d1                	mov    %edx,%ecx
  80218f:	89 c6                	mov    %eax,%esi
  802191:	e9 71 ff ff ff       	jmp    802107 <__umoddi3+0xb3>
  802196:	66 90                	xchg   %ax,%ax
  802198:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80219c:	72 ea                	jb     802188 <__umoddi3+0x134>
  80219e:	89 d9                	mov    %ebx,%ecx
  8021a0:	e9 62 ff ff ff       	jmp    802107 <__umoddi3+0xb3>
