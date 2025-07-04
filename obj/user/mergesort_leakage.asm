
obj/user/mergesort_leakage:     file format elf32-i386


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
  800031:	e8 01 07 00 00       	call   800737 <libmain>
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
	{
		//2012: lock the interrupt
//		sys_lock_cons();
		int NumOfElements;
		int *Elements;
		sys_lock_cons();
  800041:	e8 cd 21 00 00       	call   802213 <sys_lock_cons>
		{
			cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 40 3d 80 00       	push   $0x803d40
  80004e:	e8 e6 0a 00 00       	call   800b39 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 42 3d 80 00       	push   $0x803d42
  80005e:	e8 d6 0a 00 00       	call   800b39 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 58 3d 80 00       	push   $0x803d58
  80006e:	e8 c6 0a 00 00       	call   800b39 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 42 3d 80 00       	push   $0x803d42
  80007e:	e8 b6 0a 00 00       	call   800b39 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
			cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 40 3d 80 00       	push   $0x803d40
  80008e:	e8 a6 0a 00 00       	call   800b39 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
			readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 70 3d 80 00       	push   $0x803d70
  8000a5:	e8 23 11 00 00       	call   8011cd <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
			NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 75 16 00 00       	call   801735 <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 1c 1a 00 00       	call   801af1 <malloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
			cprintf("Chose the initialization method:\n") ;
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	68 90 3d 80 00       	push   $0x803d90
  8000e3:	e8 51 0a 00 00       	call   800b39 <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 b2 3d 80 00       	push   $0x803db2
  8000f3:	e8 41 0a 00 00       	call   800b39 <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 c0 3d 80 00       	push   $0x803dc0
  800103:	e8 31 0a 00 00       	call   800b39 <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 cf 3d 80 00       	push   $0x803dcf
  800113:	e8 21 0a 00 00       	call   800b39 <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 df 3d 80 00       	push   $0x803ddf
  800123:	e8 11 0a 00 00       	call   800b39 <cprintf>
  800128:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  80012b:	e8 ea 05 00 00       	call   80071a <getchar>
  800130:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  800133:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	50                   	push   %eax
  80013b:	e8 bb 05 00 00       	call   8006fb <cputchar>
  800140:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	6a 0a                	push   $0xa
  800148:	e8 ae 05 00 00       	call   8006fb <cputchar>
  80014d:	83 c4 10             	add    $0x10,%esp
			} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800150:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  800154:	74 0c                	je     800162 <_main+0x12a>
  800156:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  80015a:	74 06                	je     800162 <_main+0x12a>
  80015c:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800160:	75 b9                	jne    80011b <_main+0xe3>
		}
		sys_unlock_cons();
  800162:	e8 c6 20 00 00       	call   80222d <sys_unlock_cons>
//		sys_unlock_cons();

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
  800183:	e8 e6 01 00 00       	call   80036e <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f0             	pushl  -0x10(%ebp)
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	e8 04 02 00 00       	call   80039f <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a9:	e8 26 02 00 00       	call   8003d4 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 13 02 00 00       	call   8003d4 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001c4:	83 ec 04             	sub    $0x4,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	6a 01                	push   $0x1
  8001cc:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cf:	e8 d2 02 00 00       	call   8004a6 <MSort>
  8001d4:	83 c4 10             	add    $0x10,%esp

//		sys_lock_cons();
		sys_lock_cons();
  8001d7:	e8 37 20 00 00       	call   802213 <sys_lock_cons>
		{
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	68 e8 3d 80 00       	push   $0x803de8
  8001e4:	e8 50 09 00 00       	call   800b39 <cprintf>
  8001e9:	83 c4 10             	add    $0x10,%esp
			//PrintElements(Elements, NumOfElements);
		}
		sys_unlock_cons();
  8001ec:	e8 3c 20 00 00       	call   80222d <sys_unlock_cons>
//		sys_unlock_cons();

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001f1:	83 ec 08             	sub    $0x8,%esp
  8001f4:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001fa:	e8 c5 00 00 00       	call   8002c4 <CheckSorted>
  8001ff:	83 c4 10             	add    $0x10,%esp
  800202:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800205:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800209:	75 14                	jne    80021f <_main+0x1e7>
  80020b:	83 ec 04             	sub    $0x4,%esp
  80020e:	68 1c 3e 80 00       	push   $0x803e1c
  800213:	6a 51                	push   $0x51
  800215:	68 3e 3e 80 00       	push   $0x803e3e
  80021a:	e8 5d 06 00 00       	call   80087c <_panic>
		else
		{
//			sys_lock_cons();
			sys_lock_cons();
  80021f:	e8 ef 1f 00 00       	call   802213 <sys_lock_cons>
			{
				cprintf("===============================================\n") ;
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	68 58 3e 80 00       	push   $0x803e58
  80022c:	e8 08 09 00 00       	call   800b39 <cprintf>
  800231:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	68 8c 3e 80 00       	push   $0x803e8c
  80023c:	e8 f8 08 00 00       	call   800b39 <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 c0 3e 80 00       	push   $0x803ec0
  80024c:	e8 e8 08 00 00       	call   800b39 <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
			}
			sys_unlock_cons();
  800254:	e8 d4 1f 00 00       	call   80222d <sys_unlock_cons>
		}

		//free(Elements) ;

//		sys_lock_cons();
		sys_lock_cons();
  800259:	e8 b5 1f 00 00       	call   802213 <sys_lock_cons>
		{
			Chose = 0 ;
  80025e:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800262:	eb 42                	jmp    8002a6 <_main+0x26e>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800264:	83 ec 0c             	sub    $0xc,%esp
  800267:	68 f2 3e 80 00       	push   $0x803ef2
  80026c:	e8 c8 08 00 00       	call   800b39 <cprintf>
  800271:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800274:	e8 a1 04 00 00       	call   80071a <getchar>
  800279:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  80027c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800280:	83 ec 0c             	sub    $0xc,%esp
  800283:	50                   	push   %eax
  800284:	e8 72 04 00 00       	call   8006fb <cputchar>
  800289:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	6a 0a                	push   $0xa
  800291:	e8 65 04 00 00       	call   8006fb <cputchar>
  800296:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800299:	83 ec 0c             	sub    $0xc,%esp
  80029c:	6a 0a                	push   $0xa
  80029e:	e8 58 04 00 00       	call   8006fb <cputchar>
  8002a3:	83 c4 10             	add    $0x10,%esp

//		sys_lock_cons();
		sys_lock_cons();
		{
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002a6:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002aa:	74 06                	je     8002b2 <_main+0x27a>
  8002ac:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002b0:	75 b2                	jne    800264 <_main+0x22c>
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		}
		sys_unlock_cons();
  8002b2:	e8 76 1f 00 00       	call   80222d <sys_unlock_cons>
//		sys_unlock_cons();

	} while (Chose == 'y');
  8002b7:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002bb:	0f 84 80 fd ff ff    	je     800041 <_main+0x9>

}
  8002c1:	90                   	nop
  8002c2:	c9                   	leave  
  8002c3:	c3                   	ret    

008002c4 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8002c4:	55                   	push   %ebp
  8002c5:	89 e5                	mov    %esp,%ebp
  8002c7:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8002ca:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8002d1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8002d8:	eb 33                	jmp    80030d <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8002da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e7:	01 d0                	add    %edx,%eax
  8002e9:	8b 10                	mov    (%eax),%edx
  8002eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002ee:	40                   	inc    %eax
  8002ef:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f9:	01 c8                	add    %ecx,%eax
  8002fb:	8b 00                	mov    (%eax),%eax
  8002fd:	39 c2                	cmp    %eax,%edx
  8002ff:	7e 09                	jle    80030a <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800301:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800308:	eb 0c                	jmp    800316 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80030a:	ff 45 f8             	incl   -0x8(%ebp)
  80030d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800310:	48                   	dec    %eax
  800311:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800314:	7f c4                	jg     8002da <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800316:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800319:	c9                   	leave  
  80031a:	c3                   	ret    

0080031b <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80031b:	55                   	push   %ebp
  80031c:	89 e5                	mov    %esp,%ebp
  80031e:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800321:	8b 45 0c             	mov    0xc(%ebp),%eax
  800324:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80032b:	8b 45 08             	mov    0x8(%ebp),%eax
  80032e:	01 d0                	add    %edx,%eax
  800330:	8b 00                	mov    (%eax),%eax
  800332:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800335:	8b 45 0c             	mov    0xc(%ebp),%eax
  800338:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80033f:	8b 45 08             	mov    0x8(%ebp),%eax
  800342:	01 c2                	add    %eax,%edx
  800344:	8b 45 10             	mov    0x10(%ebp),%eax
  800347:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80034e:	8b 45 08             	mov    0x8(%ebp),%eax
  800351:	01 c8                	add    %ecx,%eax
  800353:	8b 00                	mov    (%eax),%eax
  800355:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800357:	8b 45 10             	mov    0x10(%ebp),%eax
  80035a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800361:	8b 45 08             	mov    0x8(%ebp),%eax
  800364:	01 c2                	add    %eax,%edx
  800366:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800369:	89 02                	mov    %eax,(%edx)
}
  80036b:	90                   	nop
  80036c:	c9                   	leave  
  80036d:	c3                   	ret    

0080036e <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80036e:	55                   	push   %ebp
  80036f:	89 e5                	mov    %esp,%ebp
  800371:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800374:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80037b:	eb 17                	jmp    800394 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80037d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800380:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800387:	8b 45 08             	mov    0x8(%ebp),%eax
  80038a:	01 c2                	add    %eax,%edx
  80038c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80038f:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800391:	ff 45 fc             	incl   -0x4(%ebp)
  800394:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800397:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80039a:	7c e1                	jl     80037d <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  80039c:	90                   	nop
  80039d:	c9                   	leave  
  80039e:	c3                   	ret    

0080039f <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  80039f:	55                   	push   %ebp
  8003a0:	89 e5                	mov    %esp,%ebp
  8003a2:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003ac:	eb 1b                	jmp    8003c9 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8003ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bb:	01 c2                	add    %eax,%edx
  8003bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c0:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8003c3:	48                   	dec    %eax
  8003c4:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003c6:	ff 45 fc             	incl   -0x4(%ebp)
  8003c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003cc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003cf:	7c dd                	jl     8003ae <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8003d1:	90                   	nop
  8003d2:	c9                   	leave  
  8003d3:	c3                   	ret    

008003d4 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8003d4:	55                   	push   %ebp
  8003d5:	89 e5                	mov    %esp,%ebp
  8003d7:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8003da:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003dd:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8003e2:	f7 e9                	imul   %ecx
  8003e4:	c1 f9 1f             	sar    $0x1f,%ecx
  8003e7:	89 d0                	mov    %edx,%eax
  8003e9:	29 c8                	sub    %ecx,%eax
  8003eb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8003ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003f5:	eb 1e                	jmp    800415 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  8003f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800401:	8b 45 08             	mov    0x8(%ebp),%eax
  800404:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800407:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80040a:	99                   	cltd   
  80040b:	f7 7d f8             	idivl  -0x8(%ebp)
  80040e:	89 d0                	mov    %edx,%eax
  800410:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800412:	ff 45 fc             	incl   -0x4(%ebp)
  800415:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800418:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80041b:	7c da                	jl     8003f7 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  80041d:	90                   	nop
  80041e:	c9                   	leave  
  80041f:	c3                   	ret    

00800420 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800420:	55                   	push   %ebp
  800421:	89 e5                	mov    %esp,%ebp
  800423:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800426:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80042d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800434:	eb 42                	jmp    800478 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800436:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800439:	99                   	cltd   
  80043a:	f7 7d f0             	idivl  -0x10(%ebp)
  80043d:	89 d0                	mov    %edx,%eax
  80043f:	85 c0                	test   %eax,%eax
  800441:	75 10                	jne    800453 <PrintElements+0x33>
			cprintf("\n");
  800443:	83 ec 0c             	sub    $0xc,%esp
  800446:	68 40 3d 80 00       	push   $0x803d40
  80044b:	e8 e9 06 00 00       	call   800b39 <cprintf>
  800450:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800456:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80045d:	8b 45 08             	mov    0x8(%ebp),%eax
  800460:	01 d0                	add    %edx,%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	83 ec 08             	sub    $0x8,%esp
  800467:	50                   	push   %eax
  800468:	68 10 3f 80 00       	push   $0x803f10
  80046d:	e8 c7 06 00 00       	call   800b39 <cprintf>
  800472:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800475:	ff 45 f4             	incl   -0xc(%ebp)
  800478:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047b:	48                   	dec    %eax
  80047c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80047f:	7f b5                	jg     800436 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800484:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80048b:	8b 45 08             	mov    0x8(%ebp),%eax
  80048e:	01 d0                	add    %edx,%eax
  800490:	8b 00                	mov    (%eax),%eax
  800492:	83 ec 08             	sub    $0x8,%esp
  800495:	50                   	push   %eax
  800496:	68 15 3f 80 00       	push   $0x803f15
  80049b:	e8 99 06 00 00       	call   800b39 <cprintf>
  8004a0:	83 c4 10             	add    $0x10,%esp

}
  8004a3:	90                   	nop
  8004a4:	c9                   	leave  
  8004a5:	c3                   	ret    

008004a6 <MSort>:


void MSort(int* A, int p, int r)
{
  8004a6:	55                   	push   %ebp
  8004a7:	89 e5                	mov    %esp,%ebp
  8004a9:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  8004ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004af:	3b 45 10             	cmp    0x10(%ebp),%eax
  8004b2:	7d 54                	jge    800508 <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  8004b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ba:	01 d0                	add    %edx,%eax
  8004bc:	89 c2                	mov    %eax,%edx
  8004be:	c1 ea 1f             	shr    $0x1f,%edx
  8004c1:	01 d0                	add    %edx,%eax
  8004c3:	d1 f8                	sar    %eax
  8004c5:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  8004c8:	83 ec 04             	sub    $0x4,%esp
  8004cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8004ce:	ff 75 0c             	pushl  0xc(%ebp)
  8004d1:	ff 75 08             	pushl  0x8(%ebp)
  8004d4:	e8 cd ff ff ff       	call   8004a6 <MSort>
  8004d9:	83 c4 10             	add    $0x10,%esp

	MSort(A, q + 1, r);
  8004dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004df:	40                   	inc    %eax
  8004e0:	83 ec 04             	sub    $0x4,%esp
  8004e3:	ff 75 10             	pushl  0x10(%ebp)
  8004e6:	50                   	push   %eax
  8004e7:	ff 75 08             	pushl  0x8(%ebp)
  8004ea:	e8 b7 ff ff ff       	call   8004a6 <MSort>
  8004ef:	83 c4 10             	add    $0x10,%esp

	Merge(A, p, q, r);
  8004f2:	ff 75 10             	pushl  0x10(%ebp)
  8004f5:	ff 75 f4             	pushl  -0xc(%ebp)
  8004f8:	ff 75 0c             	pushl  0xc(%ebp)
  8004fb:	ff 75 08             	pushl  0x8(%ebp)
  8004fe:	e8 08 00 00 00       	call   80050b <Merge>
  800503:	83 c4 10             	add    $0x10,%esp
  800506:	eb 01                	jmp    800509 <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  800508:	90                   	nop

	MSort(A, q + 1, r);

	Merge(A, p, q, r);

}
  800509:	c9                   	leave  
  80050a:	c3                   	ret    

0080050b <Merge>:

void Merge(int* A, int p, int q, int r)
{
  80050b:	55                   	push   %ebp
  80050c:	89 e5                	mov    %esp,%ebp
  80050e:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  800511:	8b 45 10             	mov    0x10(%ebp),%eax
  800514:	2b 45 0c             	sub    0xc(%ebp),%eax
  800517:	40                   	inc    %eax
  800518:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  80051b:	8b 45 14             	mov    0x14(%ebp),%eax
  80051e:	2b 45 10             	sub    0x10(%ebp),%eax
  800521:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  800524:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  80052b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int* Left = malloc(sizeof(int) * leftCapacity);
  800532:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800535:	c1 e0 02             	shl    $0x2,%eax
  800538:	83 ec 0c             	sub    $0xc,%esp
  80053b:	50                   	push   %eax
  80053c:	e8 b0 15 00 00       	call   801af1 <malloc>
  800541:	83 c4 10             	add    $0x10,%esp
  800544:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  800547:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80054a:	c1 e0 02             	shl    $0x2,%eax
  80054d:	83 ec 0c             	sub    $0xc,%esp
  800550:	50                   	push   %eax
  800551:	e8 9b 15 00 00       	call   801af1 <malloc>
  800556:	83 c4 10             	add    $0x10,%esp
  800559:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//	int Left[5000] ;
	//	int Right[5000] ;

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  80055c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800563:	eb 2f                	jmp    800594 <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  800565:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800568:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80056f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800572:	01 c2                	add    %eax,%edx
  800574:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800577:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80057a:	01 c8                	add    %ecx,%eax
  80057c:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800581:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800588:	8b 45 08             	mov    0x8(%ebp),%eax
  80058b:	01 c8                	add    %ecx,%eax
  80058d:	8b 00                	mov    (%eax),%eax
  80058f:	89 02                	mov    %eax,(%edx)

	//	int Left[5000] ;
	//	int Right[5000] ;

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  800591:	ff 45 ec             	incl   -0x14(%ebp)
  800594:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800597:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80059a:	7c c9                	jl     800565 <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  80059c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005a3:	eb 2a                	jmp    8005cf <Merge+0xc4>
	{
		Right[j] = A[q + j];
  8005a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005a8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005af:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005b2:	01 c2                	add    %eax,%edx
  8005b4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005ba:	01 c8                	add    %ecx,%eax
  8005bc:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c6:	01 c8                	add    %ecx,%eax
  8005c8:	8b 00                	mov    (%eax),%eax
  8005ca:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005cc:	ff 45 e8             	incl   -0x18(%ebp)
  8005cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005d2:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005d5:	7c ce                	jl     8005a5 <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8005d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005dd:	e9 0a 01 00 00       	jmp    8006ec <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  8005e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005e5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005e8:	0f 8d 95 00 00 00    	jge    800683 <Merge+0x178>
  8005ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005f1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005f4:	0f 8d 89 00 00 00    	jge    800683 <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8005fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005fd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800604:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800607:	01 d0                	add    %edx,%eax
  800609:	8b 10                	mov    (%eax),%edx
  80060b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80060e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800615:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800618:	01 c8                	add    %ecx,%eax
  80061a:	8b 00                	mov    (%eax),%eax
  80061c:	39 c2                	cmp    %eax,%edx
  80061e:	7d 33                	jge    800653 <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  800620:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800623:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800628:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80062f:	8b 45 08             	mov    0x8(%ebp),%eax
  800632:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800638:	8d 50 01             	lea    0x1(%eax),%edx
  80063b:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80063e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800645:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800648:	01 d0                	add    %edx,%eax
  80064a:	8b 00                	mov    (%eax),%eax
  80064c:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80064e:	e9 96 00 00 00       	jmp    8006e9 <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  800653:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800656:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80065b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800662:	8b 45 08             	mov    0x8(%ebp),%eax
  800665:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800668:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80066b:	8d 50 01             	lea    0x1(%eax),%edx
  80066e:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800671:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800678:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80067b:	01 d0                	add    %edx,%eax
  80067d:	8b 00                	mov    (%eax),%eax
  80067f:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800681:	eb 66                	jmp    8006e9 <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  800683:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800686:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800689:	7d 30                	jge    8006bb <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  80068b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80068e:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800693:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80069a:	8b 45 08             	mov    0x8(%ebp),%eax
  80069d:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006a3:	8d 50 01             	lea    0x1(%eax),%edx
  8006a6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8006a9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006b0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006b3:	01 d0                	add    %edx,%eax
  8006b5:	8b 00                	mov    (%eax),%eax
  8006b7:	89 01                	mov    %eax,(%ecx)
  8006b9:	eb 2e                	jmp    8006e9 <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  8006bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006be:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cd:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006d3:	8d 50 01             	lea    0x1(%eax),%edx
  8006d6:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8006d9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006e0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006e3:	01 d0                	add    %edx,%eax
  8006e5:	8b 00                	mov    (%eax),%eax
  8006e7:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8006e9:	ff 45 e4             	incl   -0x1c(%ebp)
  8006ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006ef:	3b 45 14             	cmp    0x14(%ebp),%eax
  8006f2:	0f 8e ea fe ff ff    	jle    8005e2 <Merge+0xd7>
		{
			A[k - 1] = Right[rightIndex++];
		}
	}

}
  8006f8:	90                   	nop
  8006f9:	c9                   	leave  
  8006fa:	c3                   	ret    

008006fb <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8006fb:	55                   	push   %ebp
  8006fc:	89 e5                	mov    %esp,%ebp
  8006fe:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  800701:	8b 45 08             	mov    0x8(%ebp),%eax
  800704:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800707:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80070b:	83 ec 0c             	sub    $0xc,%esp
  80070e:	50                   	push   %eax
  80070f:	e8 4a 1c 00 00       	call   80235e <sys_cputc>
  800714:	83 c4 10             	add    $0x10,%esp
}
  800717:	90                   	nop
  800718:	c9                   	leave  
  800719:	c3                   	ret    

0080071a <getchar>:


int
getchar(void)
{
  80071a:	55                   	push   %ebp
  80071b:	89 e5                	mov    %esp,%ebp
  80071d:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  800720:	e8 d5 1a 00 00       	call   8021fa <sys_cgetc>
  800725:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  800728:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80072b:	c9                   	leave  
  80072c:	c3                   	ret    

0080072d <iscons>:

int iscons(int fdnum)
{
  80072d:	55                   	push   %ebp
  80072e:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800730:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800735:	5d                   	pop    %ebp
  800736:	c3                   	ret    

00800737 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800737:	55                   	push   %ebp
  800738:	89 e5                	mov    %esp,%ebp
  80073a:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80073d:	e8 4d 1d 00 00       	call   80248f <sys_getenvindex>
  800742:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800745:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800748:	89 d0                	mov    %edx,%eax
  80074a:	c1 e0 02             	shl    $0x2,%eax
  80074d:	01 d0                	add    %edx,%eax
  80074f:	c1 e0 03             	shl    $0x3,%eax
  800752:	01 d0                	add    %edx,%eax
  800754:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80075b:	01 d0                	add    %edx,%eax
  80075d:	c1 e0 02             	shl    $0x2,%eax
  800760:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800765:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80076a:	a1 24 50 80 00       	mov    0x805024,%eax
  80076f:	8a 40 20             	mov    0x20(%eax),%al
  800772:	84 c0                	test   %al,%al
  800774:	74 0d                	je     800783 <libmain+0x4c>
		binaryname = myEnv->prog_name;
  800776:	a1 24 50 80 00       	mov    0x805024,%eax
  80077b:	83 c0 20             	add    $0x20,%eax
  80077e:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800783:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800787:	7e 0a                	jle    800793 <libmain+0x5c>
		binaryname = argv[0];
  800789:	8b 45 0c             	mov    0xc(%ebp),%eax
  80078c:	8b 00                	mov    (%eax),%eax
  80078e:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  800793:	83 ec 08             	sub    $0x8,%esp
  800796:	ff 75 0c             	pushl  0xc(%ebp)
  800799:	ff 75 08             	pushl  0x8(%ebp)
  80079c:	e8 97 f8 ff ff       	call   800038 <_main>
  8007a1:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8007a4:	a1 00 50 80 00       	mov    0x805000,%eax
  8007a9:	85 c0                	test   %eax,%eax
  8007ab:	0f 84 9f 00 00 00    	je     800850 <libmain+0x119>
	{
		sys_lock_cons();
  8007b1:	e8 5d 1a 00 00       	call   802213 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8007b6:	83 ec 0c             	sub    $0xc,%esp
  8007b9:	68 34 3f 80 00       	push   $0x803f34
  8007be:	e8 76 03 00 00       	call   800b39 <cprintf>
  8007c3:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8007c6:	a1 24 50 80 00       	mov    0x805024,%eax
  8007cb:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8007d1:	a1 24 50 80 00       	mov    0x805024,%eax
  8007d6:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8007dc:	83 ec 04             	sub    $0x4,%esp
  8007df:	52                   	push   %edx
  8007e0:	50                   	push   %eax
  8007e1:	68 5c 3f 80 00       	push   $0x803f5c
  8007e6:	e8 4e 03 00 00       	call   800b39 <cprintf>
  8007eb:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8007ee:	a1 24 50 80 00       	mov    0x805024,%eax
  8007f3:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8007f9:	a1 24 50 80 00       	mov    0x805024,%eax
  8007fe:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800804:	a1 24 50 80 00       	mov    0x805024,%eax
  800809:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  80080f:	51                   	push   %ecx
  800810:	52                   	push   %edx
  800811:	50                   	push   %eax
  800812:	68 84 3f 80 00       	push   $0x803f84
  800817:	e8 1d 03 00 00       	call   800b39 <cprintf>
  80081c:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80081f:	a1 24 50 80 00       	mov    0x805024,%eax
  800824:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  80082a:	83 ec 08             	sub    $0x8,%esp
  80082d:	50                   	push   %eax
  80082e:	68 dc 3f 80 00       	push   $0x803fdc
  800833:	e8 01 03 00 00       	call   800b39 <cprintf>
  800838:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80083b:	83 ec 0c             	sub    $0xc,%esp
  80083e:	68 34 3f 80 00       	push   $0x803f34
  800843:	e8 f1 02 00 00       	call   800b39 <cprintf>
  800848:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80084b:	e8 dd 19 00 00       	call   80222d <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800850:	e8 19 00 00 00       	call   80086e <exit>
}
  800855:	90                   	nop
  800856:	c9                   	leave  
  800857:	c3                   	ret    

00800858 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800858:	55                   	push   %ebp
  800859:	89 e5                	mov    %esp,%ebp
  80085b:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80085e:	83 ec 0c             	sub    $0xc,%esp
  800861:	6a 00                	push   $0x0
  800863:	e8 f3 1b 00 00       	call   80245b <sys_destroy_env>
  800868:	83 c4 10             	add    $0x10,%esp
}
  80086b:	90                   	nop
  80086c:	c9                   	leave  
  80086d:	c3                   	ret    

0080086e <exit>:

void
exit(void)
{
  80086e:	55                   	push   %ebp
  80086f:	89 e5                	mov    %esp,%ebp
  800871:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800874:	e8 48 1c 00 00       	call   8024c1 <sys_exit_env>
}
  800879:	90                   	nop
  80087a:	c9                   	leave  
  80087b:	c3                   	ret    

0080087c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80087c:	55                   	push   %ebp
  80087d:	89 e5                	mov    %esp,%ebp
  80087f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800882:	8d 45 10             	lea    0x10(%ebp),%eax
  800885:	83 c0 04             	add    $0x4,%eax
  800888:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80088b:	a1 60 50 98 00       	mov    0x985060,%eax
  800890:	85 c0                	test   %eax,%eax
  800892:	74 16                	je     8008aa <_panic+0x2e>
		cprintf("%s: ", argv0);
  800894:	a1 60 50 98 00       	mov    0x985060,%eax
  800899:	83 ec 08             	sub    $0x8,%esp
  80089c:	50                   	push   %eax
  80089d:	68 f0 3f 80 00       	push   $0x803ff0
  8008a2:	e8 92 02 00 00       	call   800b39 <cprintf>
  8008a7:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8008aa:	a1 04 50 80 00       	mov    0x805004,%eax
  8008af:	ff 75 0c             	pushl  0xc(%ebp)
  8008b2:	ff 75 08             	pushl  0x8(%ebp)
  8008b5:	50                   	push   %eax
  8008b6:	68 f5 3f 80 00       	push   $0x803ff5
  8008bb:	e8 79 02 00 00       	call   800b39 <cprintf>
  8008c0:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8008c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8008c6:	83 ec 08             	sub    $0x8,%esp
  8008c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8008cc:	50                   	push   %eax
  8008cd:	e8 fc 01 00 00       	call   800ace <vcprintf>
  8008d2:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8008d5:	83 ec 08             	sub    $0x8,%esp
  8008d8:	6a 00                	push   $0x0
  8008da:	68 11 40 80 00       	push   $0x804011
  8008df:	e8 ea 01 00 00       	call   800ace <vcprintf>
  8008e4:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8008e7:	e8 82 ff ff ff       	call   80086e <exit>

	// should not return here
	while (1) ;
  8008ec:	eb fe                	jmp    8008ec <_panic+0x70>

008008ee <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8008ee:	55                   	push   %ebp
  8008ef:	89 e5                	mov    %esp,%ebp
  8008f1:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8008f4:	a1 24 50 80 00       	mov    0x805024,%eax
  8008f9:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8008ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800902:	39 c2                	cmp    %eax,%edx
  800904:	74 14                	je     80091a <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800906:	83 ec 04             	sub    $0x4,%esp
  800909:	68 14 40 80 00       	push   $0x804014
  80090e:	6a 26                	push   $0x26
  800910:	68 60 40 80 00       	push   $0x804060
  800915:	e8 62 ff ff ff       	call   80087c <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80091a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800921:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800928:	e9 c5 00 00 00       	jmp    8009f2 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80092d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800930:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800937:	8b 45 08             	mov    0x8(%ebp),%eax
  80093a:	01 d0                	add    %edx,%eax
  80093c:	8b 00                	mov    (%eax),%eax
  80093e:	85 c0                	test   %eax,%eax
  800940:	75 08                	jne    80094a <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800942:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800945:	e9 a5 00 00 00       	jmp    8009ef <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80094a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800951:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800958:	eb 69                	jmp    8009c3 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80095a:	a1 24 50 80 00       	mov    0x805024,%eax
  80095f:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800965:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800968:	89 d0                	mov    %edx,%eax
  80096a:	01 c0                	add    %eax,%eax
  80096c:	01 d0                	add    %edx,%eax
  80096e:	c1 e0 03             	shl    $0x3,%eax
  800971:	01 c8                	add    %ecx,%eax
  800973:	8a 40 04             	mov    0x4(%eax),%al
  800976:	84 c0                	test   %al,%al
  800978:	75 46                	jne    8009c0 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80097a:	a1 24 50 80 00       	mov    0x805024,%eax
  80097f:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800985:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800988:	89 d0                	mov    %edx,%eax
  80098a:	01 c0                	add    %eax,%eax
  80098c:	01 d0                	add    %edx,%eax
  80098e:	c1 e0 03             	shl    $0x3,%eax
  800991:	01 c8                	add    %ecx,%eax
  800993:	8b 00                	mov    (%eax),%eax
  800995:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800998:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80099b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8009a0:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8009a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009a5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8009ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8009af:	01 c8                	add    %ecx,%eax
  8009b1:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009b3:	39 c2                	cmp    %eax,%edx
  8009b5:	75 09                	jne    8009c0 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8009b7:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8009be:	eb 15                	jmp    8009d5 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009c0:	ff 45 e8             	incl   -0x18(%ebp)
  8009c3:	a1 24 50 80 00       	mov    0x805024,%eax
  8009c8:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8009ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8009d1:	39 c2                	cmp    %eax,%edx
  8009d3:	77 85                	ja     80095a <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8009d5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8009d9:	75 14                	jne    8009ef <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8009db:	83 ec 04             	sub    $0x4,%esp
  8009de:	68 6c 40 80 00       	push   $0x80406c
  8009e3:	6a 3a                	push   $0x3a
  8009e5:	68 60 40 80 00       	push   $0x804060
  8009ea:	e8 8d fe ff ff       	call   80087c <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8009ef:	ff 45 f0             	incl   -0x10(%ebp)
  8009f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009f5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8009f8:	0f 8c 2f ff ff ff    	jl     80092d <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8009fe:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a05:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a0c:	eb 26                	jmp    800a34 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a0e:	a1 24 50 80 00       	mov    0x805024,%eax
  800a13:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800a19:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a1c:	89 d0                	mov    %edx,%eax
  800a1e:	01 c0                	add    %eax,%eax
  800a20:	01 d0                	add    %edx,%eax
  800a22:	c1 e0 03             	shl    $0x3,%eax
  800a25:	01 c8                	add    %ecx,%eax
  800a27:	8a 40 04             	mov    0x4(%eax),%al
  800a2a:	3c 01                	cmp    $0x1,%al
  800a2c:	75 03                	jne    800a31 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800a2e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a31:	ff 45 e0             	incl   -0x20(%ebp)
  800a34:	a1 24 50 80 00       	mov    0x805024,%eax
  800a39:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800a3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a42:	39 c2                	cmp    %eax,%edx
  800a44:	77 c8                	ja     800a0e <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a49:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800a4c:	74 14                	je     800a62 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800a4e:	83 ec 04             	sub    $0x4,%esp
  800a51:	68 c0 40 80 00       	push   $0x8040c0
  800a56:	6a 44                	push   $0x44
  800a58:	68 60 40 80 00       	push   $0x804060
  800a5d:	e8 1a fe ff ff       	call   80087c <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800a62:	90                   	nop
  800a63:	c9                   	leave  
  800a64:	c3                   	ret    

00800a65 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800a65:	55                   	push   %ebp
  800a66:	89 e5                	mov    %esp,%ebp
  800a68:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800a6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6e:	8b 00                	mov    (%eax),%eax
  800a70:	8d 48 01             	lea    0x1(%eax),%ecx
  800a73:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a76:	89 0a                	mov    %ecx,(%edx)
  800a78:	8b 55 08             	mov    0x8(%ebp),%edx
  800a7b:	88 d1                	mov    %dl,%cl
  800a7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a80:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800a84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a87:	8b 00                	mov    (%eax),%eax
  800a89:	3d ff 00 00 00       	cmp    $0xff,%eax
  800a8e:	75 2c                	jne    800abc <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800a90:	a0 44 50 98 00       	mov    0x985044,%al
  800a95:	0f b6 c0             	movzbl %al,%eax
  800a98:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a9b:	8b 12                	mov    (%edx),%edx
  800a9d:	89 d1                	mov    %edx,%ecx
  800a9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aa2:	83 c2 08             	add    $0x8,%edx
  800aa5:	83 ec 04             	sub    $0x4,%esp
  800aa8:	50                   	push   %eax
  800aa9:	51                   	push   %ecx
  800aaa:	52                   	push   %edx
  800aab:	e8 21 17 00 00       	call   8021d1 <sys_cputs>
  800ab0:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800ab3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800abc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800abf:	8b 40 04             	mov    0x4(%eax),%eax
  800ac2:	8d 50 01             	lea    0x1(%eax),%edx
  800ac5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac8:	89 50 04             	mov    %edx,0x4(%eax)
}
  800acb:	90                   	nop
  800acc:	c9                   	leave  
  800acd:	c3                   	ret    

00800ace <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800ace:	55                   	push   %ebp
  800acf:	89 e5                	mov    %esp,%ebp
  800ad1:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800ad7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800ade:	00 00 00 
	b.cnt = 0;
  800ae1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800ae8:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800aeb:	ff 75 0c             	pushl  0xc(%ebp)
  800aee:	ff 75 08             	pushl  0x8(%ebp)
  800af1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800af7:	50                   	push   %eax
  800af8:	68 65 0a 80 00       	push   $0x800a65
  800afd:	e8 11 02 00 00       	call   800d13 <vprintfmt>
  800b02:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800b05:	a0 44 50 98 00       	mov    0x985044,%al
  800b0a:	0f b6 c0             	movzbl %al,%eax
  800b0d:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800b13:	83 ec 04             	sub    $0x4,%esp
  800b16:	50                   	push   %eax
  800b17:	52                   	push   %edx
  800b18:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b1e:	83 c0 08             	add    $0x8,%eax
  800b21:	50                   	push   %eax
  800b22:	e8 aa 16 00 00       	call   8021d1 <sys_cputs>
  800b27:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800b2a:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
	return b.cnt;
  800b31:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800b37:	c9                   	leave  
  800b38:	c3                   	ret    

00800b39 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800b39:	55                   	push   %ebp
  800b3a:	89 e5                	mov    %esp,%ebp
  800b3c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800b3f:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
	va_start(ap, fmt);
  800b46:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b49:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4f:	83 ec 08             	sub    $0x8,%esp
  800b52:	ff 75 f4             	pushl  -0xc(%ebp)
  800b55:	50                   	push   %eax
  800b56:	e8 73 ff ff ff       	call   800ace <vcprintf>
  800b5b:	83 c4 10             	add    $0x10,%esp
  800b5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800b61:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b64:	c9                   	leave  
  800b65:	c3                   	ret    

00800b66 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800b66:	55                   	push   %ebp
  800b67:	89 e5                	mov    %esp,%ebp
  800b69:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800b6c:	e8 a2 16 00 00       	call   802213 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800b71:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b74:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800b77:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7a:	83 ec 08             	sub    $0x8,%esp
  800b7d:	ff 75 f4             	pushl  -0xc(%ebp)
  800b80:	50                   	push   %eax
  800b81:	e8 48 ff ff ff       	call   800ace <vcprintf>
  800b86:	83 c4 10             	add    $0x10,%esp
  800b89:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800b8c:	e8 9c 16 00 00       	call   80222d <sys_unlock_cons>
	return cnt;
  800b91:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b94:	c9                   	leave  
  800b95:	c3                   	ret    

00800b96 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b96:	55                   	push   %ebp
  800b97:	89 e5                	mov    %esp,%ebp
  800b99:	53                   	push   %ebx
  800b9a:	83 ec 14             	sub    $0x14,%esp
  800b9d:	8b 45 10             	mov    0x10(%ebp),%eax
  800ba0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ba3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ba6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800ba9:	8b 45 18             	mov    0x18(%ebp),%eax
  800bac:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800bb4:	77 55                	ja     800c0b <printnum+0x75>
  800bb6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800bb9:	72 05                	jb     800bc0 <printnum+0x2a>
  800bbb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800bbe:	77 4b                	ja     800c0b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800bc0:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800bc3:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800bc6:	8b 45 18             	mov    0x18(%ebp),%eax
  800bc9:	ba 00 00 00 00       	mov    $0x0,%edx
  800bce:	52                   	push   %edx
  800bcf:	50                   	push   %eax
  800bd0:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd3:	ff 75 f0             	pushl  -0x10(%ebp)
  800bd6:	e8 f9 2e 00 00       	call   803ad4 <__udivdi3>
  800bdb:	83 c4 10             	add    $0x10,%esp
  800bde:	83 ec 04             	sub    $0x4,%esp
  800be1:	ff 75 20             	pushl  0x20(%ebp)
  800be4:	53                   	push   %ebx
  800be5:	ff 75 18             	pushl  0x18(%ebp)
  800be8:	52                   	push   %edx
  800be9:	50                   	push   %eax
  800bea:	ff 75 0c             	pushl  0xc(%ebp)
  800bed:	ff 75 08             	pushl  0x8(%ebp)
  800bf0:	e8 a1 ff ff ff       	call   800b96 <printnum>
  800bf5:	83 c4 20             	add    $0x20,%esp
  800bf8:	eb 1a                	jmp    800c14 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800bfa:	83 ec 08             	sub    $0x8,%esp
  800bfd:	ff 75 0c             	pushl  0xc(%ebp)
  800c00:	ff 75 20             	pushl  0x20(%ebp)
  800c03:	8b 45 08             	mov    0x8(%ebp),%eax
  800c06:	ff d0                	call   *%eax
  800c08:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c0b:	ff 4d 1c             	decl   0x1c(%ebp)
  800c0e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c12:	7f e6                	jg     800bfa <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c14:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c17:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c1f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c22:	53                   	push   %ebx
  800c23:	51                   	push   %ecx
  800c24:	52                   	push   %edx
  800c25:	50                   	push   %eax
  800c26:	e8 b9 2f 00 00       	call   803be4 <__umoddi3>
  800c2b:	83 c4 10             	add    $0x10,%esp
  800c2e:	05 34 43 80 00       	add    $0x804334,%eax
  800c33:	8a 00                	mov    (%eax),%al
  800c35:	0f be c0             	movsbl %al,%eax
  800c38:	83 ec 08             	sub    $0x8,%esp
  800c3b:	ff 75 0c             	pushl  0xc(%ebp)
  800c3e:	50                   	push   %eax
  800c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c42:	ff d0                	call   *%eax
  800c44:	83 c4 10             	add    $0x10,%esp
}
  800c47:	90                   	nop
  800c48:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c4b:	c9                   	leave  
  800c4c:	c3                   	ret    

00800c4d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800c4d:	55                   	push   %ebp
  800c4e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c50:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c54:	7e 1c                	jle    800c72 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800c56:	8b 45 08             	mov    0x8(%ebp),%eax
  800c59:	8b 00                	mov    (%eax),%eax
  800c5b:	8d 50 08             	lea    0x8(%eax),%edx
  800c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c61:	89 10                	mov    %edx,(%eax)
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	8b 00                	mov    (%eax),%eax
  800c68:	83 e8 08             	sub    $0x8,%eax
  800c6b:	8b 50 04             	mov    0x4(%eax),%edx
  800c6e:	8b 00                	mov    (%eax),%eax
  800c70:	eb 40                	jmp    800cb2 <getuint+0x65>
	else if (lflag)
  800c72:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c76:	74 1e                	je     800c96 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800c78:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7b:	8b 00                	mov    (%eax),%eax
  800c7d:	8d 50 04             	lea    0x4(%eax),%edx
  800c80:	8b 45 08             	mov    0x8(%ebp),%eax
  800c83:	89 10                	mov    %edx,(%eax)
  800c85:	8b 45 08             	mov    0x8(%ebp),%eax
  800c88:	8b 00                	mov    (%eax),%eax
  800c8a:	83 e8 04             	sub    $0x4,%eax
  800c8d:	8b 00                	mov    (%eax),%eax
  800c8f:	ba 00 00 00 00       	mov    $0x0,%edx
  800c94:	eb 1c                	jmp    800cb2 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800c96:	8b 45 08             	mov    0x8(%ebp),%eax
  800c99:	8b 00                	mov    (%eax),%eax
  800c9b:	8d 50 04             	lea    0x4(%eax),%edx
  800c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca1:	89 10                	mov    %edx,(%eax)
  800ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca6:	8b 00                	mov    (%eax),%eax
  800ca8:	83 e8 04             	sub    $0x4,%eax
  800cab:	8b 00                	mov    (%eax),%eax
  800cad:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800cb2:	5d                   	pop    %ebp
  800cb3:	c3                   	ret    

00800cb4 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800cb4:	55                   	push   %ebp
  800cb5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800cb7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800cbb:	7e 1c                	jle    800cd9 <getint+0x25>
		return va_arg(*ap, long long);
  800cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc0:	8b 00                	mov    (%eax),%eax
  800cc2:	8d 50 08             	lea    0x8(%eax),%edx
  800cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc8:	89 10                	mov    %edx,(%eax)
  800cca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccd:	8b 00                	mov    (%eax),%eax
  800ccf:	83 e8 08             	sub    $0x8,%eax
  800cd2:	8b 50 04             	mov    0x4(%eax),%edx
  800cd5:	8b 00                	mov    (%eax),%eax
  800cd7:	eb 38                	jmp    800d11 <getint+0x5d>
	else if (lflag)
  800cd9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cdd:	74 1a                	je     800cf9 <getint+0x45>
		return va_arg(*ap, long);
  800cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce2:	8b 00                	mov    (%eax),%eax
  800ce4:	8d 50 04             	lea    0x4(%eax),%edx
  800ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cea:	89 10                	mov    %edx,(%eax)
  800cec:	8b 45 08             	mov    0x8(%ebp),%eax
  800cef:	8b 00                	mov    (%eax),%eax
  800cf1:	83 e8 04             	sub    $0x4,%eax
  800cf4:	8b 00                	mov    (%eax),%eax
  800cf6:	99                   	cltd   
  800cf7:	eb 18                	jmp    800d11 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfc:	8b 00                	mov    (%eax),%eax
  800cfe:	8d 50 04             	lea    0x4(%eax),%edx
  800d01:	8b 45 08             	mov    0x8(%ebp),%eax
  800d04:	89 10                	mov    %edx,(%eax)
  800d06:	8b 45 08             	mov    0x8(%ebp),%eax
  800d09:	8b 00                	mov    (%eax),%eax
  800d0b:	83 e8 04             	sub    $0x4,%eax
  800d0e:	8b 00                	mov    (%eax),%eax
  800d10:	99                   	cltd   
}
  800d11:	5d                   	pop    %ebp
  800d12:	c3                   	ret    

00800d13 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d13:	55                   	push   %ebp
  800d14:	89 e5                	mov    %esp,%ebp
  800d16:	56                   	push   %esi
  800d17:	53                   	push   %ebx
  800d18:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d1b:	eb 17                	jmp    800d34 <vprintfmt+0x21>
			if (ch == '\0')
  800d1d:	85 db                	test   %ebx,%ebx
  800d1f:	0f 84 c1 03 00 00    	je     8010e6 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800d25:	83 ec 08             	sub    $0x8,%esp
  800d28:	ff 75 0c             	pushl  0xc(%ebp)
  800d2b:	53                   	push   %ebx
  800d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2f:	ff d0                	call   *%eax
  800d31:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d34:	8b 45 10             	mov    0x10(%ebp),%eax
  800d37:	8d 50 01             	lea    0x1(%eax),%edx
  800d3a:	89 55 10             	mov    %edx,0x10(%ebp)
  800d3d:	8a 00                	mov    (%eax),%al
  800d3f:	0f b6 d8             	movzbl %al,%ebx
  800d42:	83 fb 25             	cmp    $0x25,%ebx
  800d45:	75 d6                	jne    800d1d <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800d47:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800d4b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800d52:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800d59:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800d60:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d67:	8b 45 10             	mov    0x10(%ebp),%eax
  800d6a:	8d 50 01             	lea    0x1(%eax),%edx
  800d6d:	89 55 10             	mov    %edx,0x10(%ebp)
  800d70:	8a 00                	mov    (%eax),%al
  800d72:	0f b6 d8             	movzbl %al,%ebx
  800d75:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800d78:	83 f8 5b             	cmp    $0x5b,%eax
  800d7b:	0f 87 3d 03 00 00    	ja     8010be <vprintfmt+0x3ab>
  800d81:	8b 04 85 58 43 80 00 	mov    0x804358(,%eax,4),%eax
  800d88:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800d8a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800d8e:	eb d7                	jmp    800d67 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800d90:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800d94:	eb d1                	jmp    800d67 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d96:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800d9d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800da0:	89 d0                	mov    %edx,%eax
  800da2:	c1 e0 02             	shl    $0x2,%eax
  800da5:	01 d0                	add    %edx,%eax
  800da7:	01 c0                	add    %eax,%eax
  800da9:	01 d8                	add    %ebx,%eax
  800dab:	83 e8 30             	sub    $0x30,%eax
  800dae:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800db1:	8b 45 10             	mov    0x10(%ebp),%eax
  800db4:	8a 00                	mov    (%eax),%al
  800db6:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800db9:	83 fb 2f             	cmp    $0x2f,%ebx
  800dbc:	7e 3e                	jle    800dfc <vprintfmt+0xe9>
  800dbe:	83 fb 39             	cmp    $0x39,%ebx
  800dc1:	7f 39                	jg     800dfc <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800dc3:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800dc6:	eb d5                	jmp    800d9d <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800dc8:	8b 45 14             	mov    0x14(%ebp),%eax
  800dcb:	83 c0 04             	add    $0x4,%eax
  800dce:	89 45 14             	mov    %eax,0x14(%ebp)
  800dd1:	8b 45 14             	mov    0x14(%ebp),%eax
  800dd4:	83 e8 04             	sub    $0x4,%eax
  800dd7:	8b 00                	mov    (%eax),%eax
  800dd9:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800ddc:	eb 1f                	jmp    800dfd <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800dde:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800de2:	79 83                	jns    800d67 <vprintfmt+0x54>
				width = 0;
  800de4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800deb:	e9 77 ff ff ff       	jmp    800d67 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800df0:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800df7:	e9 6b ff ff ff       	jmp    800d67 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800dfc:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800dfd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e01:	0f 89 60 ff ff ff    	jns    800d67 <vprintfmt+0x54>
				width = precision, precision = -1;
  800e07:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e0a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e0d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e14:	e9 4e ff ff ff       	jmp    800d67 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e19:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800e1c:	e9 46 ff ff ff       	jmp    800d67 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800e21:	8b 45 14             	mov    0x14(%ebp),%eax
  800e24:	83 c0 04             	add    $0x4,%eax
  800e27:	89 45 14             	mov    %eax,0x14(%ebp)
  800e2a:	8b 45 14             	mov    0x14(%ebp),%eax
  800e2d:	83 e8 04             	sub    $0x4,%eax
  800e30:	8b 00                	mov    (%eax),%eax
  800e32:	83 ec 08             	sub    $0x8,%esp
  800e35:	ff 75 0c             	pushl  0xc(%ebp)
  800e38:	50                   	push   %eax
  800e39:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3c:	ff d0                	call   *%eax
  800e3e:	83 c4 10             	add    $0x10,%esp
			break;
  800e41:	e9 9b 02 00 00       	jmp    8010e1 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800e46:	8b 45 14             	mov    0x14(%ebp),%eax
  800e49:	83 c0 04             	add    $0x4,%eax
  800e4c:	89 45 14             	mov    %eax,0x14(%ebp)
  800e4f:	8b 45 14             	mov    0x14(%ebp),%eax
  800e52:	83 e8 04             	sub    $0x4,%eax
  800e55:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800e57:	85 db                	test   %ebx,%ebx
  800e59:	79 02                	jns    800e5d <vprintfmt+0x14a>
				err = -err;
  800e5b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800e5d:	83 fb 64             	cmp    $0x64,%ebx
  800e60:	7f 0b                	jg     800e6d <vprintfmt+0x15a>
  800e62:	8b 34 9d a0 41 80 00 	mov    0x8041a0(,%ebx,4),%esi
  800e69:	85 f6                	test   %esi,%esi
  800e6b:	75 19                	jne    800e86 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e6d:	53                   	push   %ebx
  800e6e:	68 45 43 80 00       	push   $0x804345
  800e73:	ff 75 0c             	pushl  0xc(%ebp)
  800e76:	ff 75 08             	pushl  0x8(%ebp)
  800e79:	e8 70 02 00 00       	call   8010ee <printfmt>
  800e7e:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e81:	e9 5b 02 00 00       	jmp    8010e1 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e86:	56                   	push   %esi
  800e87:	68 4e 43 80 00       	push   $0x80434e
  800e8c:	ff 75 0c             	pushl  0xc(%ebp)
  800e8f:	ff 75 08             	pushl  0x8(%ebp)
  800e92:	e8 57 02 00 00       	call   8010ee <printfmt>
  800e97:	83 c4 10             	add    $0x10,%esp
			break;
  800e9a:	e9 42 02 00 00       	jmp    8010e1 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800e9f:	8b 45 14             	mov    0x14(%ebp),%eax
  800ea2:	83 c0 04             	add    $0x4,%eax
  800ea5:	89 45 14             	mov    %eax,0x14(%ebp)
  800ea8:	8b 45 14             	mov    0x14(%ebp),%eax
  800eab:	83 e8 04             	sub    $0x4,%eax
  800eae:	8b 30                	mov    (%eax),%esi
  800eb0:	85 f6                	test   %esi,%esi
  800eb2:	75 05                	jne    800eb9 <vprintfmt+0x1a6>
				p = "(null)";
  800eb4:	be 51 43 80 00       	mov    $0x804351,%esi
			if (width > 0 && padc != '-')
  800eb9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ebd:	7e 6d                	jle    800f2c <vprintfmt+0x219>
  800ebf:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ec3:	74 67                	je     800f2c <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ec5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ec8:	83 ec 08             	sub    $0x8,%esp
  800ecb:	50                   	push   %eax
  800ecc:	56                   	push   %esi
  800ecd:	e8 26 05 00 00       	call   8013f8 <strnlen>
  800ed2:	83 c4 10             	add    $0x10,%esp
  800ed5:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ed8:	eb 16                	jmp    800ef0 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800eda:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ede:	83 ec 08             	sub    $0x8,%esp
  800ee1:	ff 75 0c             	pushl  0xc(%ebp)
  800ee4:	50                   	push   %eax
  800ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee8:	ff d0                	call   *%eax
  800eea:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800eed:	ff 4d e4             	decl   -0x1c(%ebp)
  800ef0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ef4:	7f e4                	jg     800eda <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ef6:	eb 34                	jmp    800f2c <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800ef8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800efc:	74 1c                	je     800f1a <vprintfmt+0x207>
  800efe:	83 fb 1f             	cmp    $0x1f,%ebx
  800f01:	7e 05                	jle    800f08 <vprintfmt+0x1f5>
  800f03:	83 fb 7e             	cmp    $0x7e,%ebx
  800f06:	7e 12                	jle    800f1a <vprintfmt+0x207>
					putch('?', putdat);
  800f08:	83 ec 08             	sub    $0x8,%esp
  800f0b:	ff 75 0c             	pushl  0xc(%ebp)
  800f0e:	6a 3f                	push   $0x3f
  800f10:	8b 45 08             	mov    0x8(%ebp),%eax
  800f13:	ff d0                	call   *%eax
  800f15:	83 c4 10             	add    $0x10,%esp
  800f18:	eb 0f                	jmp    800f29 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800f1a:	83 ec 08             	sub    $0x8,%esp
  800f1d:	ff 75 0c             	pushl  0xc(%ebp)
  800f20:	53                   	push   %ebx
  800f21:	8b 45 08             	mov    0x8(%ebp),%eax
  800f24:	ff d0                	call   *%eax
  800f26:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f29:	ff 4d e4             	decl   -0x1c(%ebp)
  800f2c:	89 f0                	mov    %esi,%eax
  800f2e:	8d 70 01             	lea    0x1(%eax),%esi
  800f31:	8a 00                	mov    (%eax),%al
  800f33:	0f be d8             	movsbl %al,%ebx
  800f36:	85 db                	test   %ebx,%ebx
  800f38:	74 24                	je     800f5e <vprintfmt+0x24b>
  800f3a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f3e:	78 b8                	js     800ef8 <vprintfmt+0x1e5>
  800f40:	ff 4d e0             	decl   -0x20(%ebp)
  800f43:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f47:	79 af                	jns    800ef8 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f49:	eb 13                	jmp    800f5e <vprintfmt+0x24b>
				putch(' ', putdat);
  800f4b:	83 ec 08             	sub    $0x8,%esp
  800f4e:	ff 75 0c             	pushl  0xc(%ebp)
  800f51:	6a 20                	push   $0x20
  800f53:	8b 45 08             	mov    0x8(%ebp),%eax
  800f56:	ff d0                	call   *%eax
  800f58:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f5b:	ff 4d e4             	decl   -0x1c(%ebp)
  800f5e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f62:	7f e7                	jg     800f4b <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800f64:	e9 78 01 00 00       	jmp    8010e1 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800f69:	83 ec 08             	sub    $0x8,%esp
  800f6c:	ff 75 e8             	pushl  -0x18(%ebp)
  800f6f:	8d 45 14             	lea    0x14(%ebp),%eax
  800f72:	50                   	push   %eax
  800f73:	e8 3c fd ff ff       	call   800cb4 <getint>
  800f78:	83 c4 10             	add    $0x10,%esp
  800f7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f7e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800f81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f84:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f87:	85 d2                	test   %edx,%edx
  800f89:	79 23                	jns    800fae <vprintfmt+0x29b>
				putch('-', putdat);
  800f8b:	83 ec 08             	sub    $0x8,%esp
  800f8e:	ff 75 0c             	pushl  0xc(%ebp)
  800f91:	6a 2d                	push   $0x2d
  800f93:	8b 45 08             	mov    0x8(%ebp),%eax
  800f96:	ff d0                	call   *%eax
  800f98:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800f9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fa1:	f7 d8                	neg    %eax
  800fa3:	83 d2 00             	adc    $0x0,%edx
  800fa6:	f7 da                	neg    %edx
  800fa8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fab:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800fae:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800fb5:	e9 bc 00 00 00       	jmp    801076 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800fba:	83 ec 08             	sub    $0x8,%esp
  800fbd:	ff 75 e8             	pushl  -0x18(%ebp)
  800fc0:	8d 45 14             	lea    0x14(%ebp),%eax
  800fc3:	50                   	push   %eax
  800fc4:	e8 84 fc ff ff       	call   800c4d <getuint>
  800fc9:	83 c4 10             	add    $0x10,%esp
  800fcc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fcf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800fd2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800fd9:	e9 98 00 00 00       	jmp    801076 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800fde:	83 ec 08             	sub    $0x8,%esp
  800fe1:	ff 75 0c             	pushl  0xc(%ebp)
  800fe4:	6a 58                	push   $0x58
  800fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe9:	ff d0                	call   *%eax
  800feb:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800fee:	83 ec 08             	sub    $0x8,%esp
  800ff1:	ff 75 0c             	pushl  0xc(%ebp)
  800ff4:	6a 58                	push   $0x58
  800ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff9:	ff d0                	call   *%eax
  800ffb:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ffe:	83 ec 08             	sub    $0x8,%esp
  801001:	ff 75 0c             	pushl  0xc(%ebp)
  801004:	6a 58                	push   $0x58
  801006:	8b 45 08             	mov    0x8(%ebp),%eax
  801009:	ff d0                	call   *%eax
  80100b:	83 c4 10             	add    $0x10,%esp
			break;
  80100e:	e9 ce 00 00 00       	jmp    8010e1 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801013:	83 ec 08             	sub    $0x8,%esp
  801016:	ff 75 0c             	pushl  0xc(%ebp)
  801019:	6a 30                	push   $0x30
  80101b:	8b 45 08             	mov    0x8(%ebp),%eax
  80101e:	ff d0                	call   *%eax
  801020:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801023:	83 ec 08             	sub    $0x8,%esp
  801026:	ff 75 0c             	pushl  0xc(%ebp)
  801029:	6a 78                	push   $0x78
  80102b:	8b 45 08             	mov    0x8(%ebp),%eax
  80102e:	ff d0                	call   *%eax
  801030:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801033:	8b 45 14             	mov    0x14(%ebp),%eax
  801036:	83 c0 04             	add    $0x4,%eax
  801039:	89 45 14             	mov    %eax,0x14(%ebp)
  80103c:	8b 45 14             	mov    0x14(%ebp),%eax
  80103f:	83 e8 04             	sub    $0x4,%eax
  801042:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801044:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801047:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80104e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801055:	eb 1f                	jmp    801076 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801057:	83 ec 08             	sub    $0x8,%esp
  80105a:	ff 75 e8             	pushl  -0x18(%ebp)
  80105d:	8d 45 14             	lea    0x14(%ebp),%eax
  801060:	50                   	push   %eax
  801061:	e8 e7 fb ff ff       	call   800c4d <getuint>
  801066:	83 c4 10             	add    $0x10,%esp
  801069:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80106c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80106f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801076:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80107a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80107d:	83 ec 04             	sub    $0x4,%esp
  801080:	52                   	push   %edx
  801081:	ff 75 e4             	pushl  -0x1c(%ebp)
  801084:	50                   	push   %eax
  801085:	ff 75 f4             	pushl  -0xc(%ebp)
  801088:	ff 75 f0             	pushl  -0x10(%ebp)
  80108b:	ff 75 0c             	pushl  0xc(%ebp)
  80108e:	ff 75 08             	pushl  0x8(%ebp)
  801091:	e8 00 fb ff ff       	call   800b96 <printnum>
  801096:	83 c4 20             	add    $0x20,%esp
			break;
  801099:	eb 46                	jmp    8010e1 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80109b:	83 ec 08             	sub    $0x8,%esp
  80109e:	ff 75 0c             	pushl  0xc(%ebp)
  8010a1:	53                   	push   %ebx
  8010a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a5:	ff d0                	call   *%eax
  8010a7:	83 c4 10             	add    $0x10,%esp
			break;
  8010aa:	eb 35                	jmp    8010e1 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8010ac:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
			break;
  8010b3:	eb 2c                	jmp    8010e1 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8010b5:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
			break;
  8010bc:	eb 23                	jmp    8010e1 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8010be:	83 ec 08             	sub    $0x8,%esp
  8010c1:	ff 75 0c             	pushl  0xc(%ebp)
  8010c4:	6a 25                	push   $0x25
  8010c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c9:	ff d0                	call   *%eax
  8010cb:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010ce:	ff 4d 10             	decl   0x10(%ebp)
  8010d1:	eb 03                	jmp    8010d6 <vprintfmt+0x3c3>
  8010d3:	ff 4d 10             	decl   0x10(%ebp)
  8010d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d9:	48                   	dec    %eax
  8010da:	8a 00                	mov    (%eax),%al
  8010dc:	3c 25                	cmp    $0x25,%al
  8010de:	75 f3                	jne    8010d3 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8010e0:	90                   	nop
		}
	}
  8010e1:	e9 35 fc ff ff       	jmp    800d1b <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8010e6:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8010e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010ea:	5b                   	pop    %ebx
  8010eb:	5e                   	pop    %esi
  8010ec:	5d                   	pop    %ebp
  8010ed:	c3                   	ret    

008010ee <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8010ee:	55                   	push   %ebp
  8010ef:	89 e5                	mov    %esp,%ebp
  8010f1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8010f4:	8d 45 10             	lea    0x10(%ebp),%eax
  8010f7:	83 c0 04             	add    $0x4,%eax
  8010fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8010fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801100:	ff 75 f4             	pushl  -0xc(%ebp)
  801103:	50                   	push   %eax
  801104:	ff 75 0c             	pushl  0xc(%ebp)
  801107:	ff 75 08             	pushl  0x8(%ebp)
  80110a:	e8 04 fc ff ff       	call   800d13 <vprintfmt>
  80110f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801112:	90                   	nop
  801113:	c9                   	leave  
  801114:	c3                   	ret    

00801115 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801115:	55                   	push   %ebp
  801116:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801118:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111b:	8b 40 08             	mov    0x8(%eax),%eax
  80111e:	8d 50 01             	lea    0x1(%eax),%edx
  801121:	8b 45 0c             	mov    0xc(%ebp),%eax
  801124:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801127:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112a:	8b 10                	mov    (%eax),%edx
  80112c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112f:	8b 40 04             	mov    0x4(%eax),%eax
  801132:	39 c2                	cmp    %eax,%edx
  801134:	73 12                	jae    801148 <sprintputch+0x33>
		*b->buf++ = ch;
  801136:	8b 45 0c             	mov    0xc(%ebp),%eax
  801139:	8b 00                	mov    (%eax),%eax
  80113b:	8d 48 01             	lea    0x1(%eax),%ecx
  80113e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801141:	89 0a                	mov    %ecx,(%edx)
  801143:	8b 55 08             	mov    0x8(%ebp),%edx
  801146:	88 10                	mov    %dl,(%eax)
}
  801148:	90                   	nop
  801149:	5d                   	pop    %ebp
  80114a:	c3                   	ret    

0080114b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80114b:	55                   	push   %ebp
  80114c:	89 e5                	mov    %esp,%ebp
  80114e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801151:	8b 45 08             	mov    0x8(%ebp),%eax
  801154:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801157:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80115d:	8b 45 08             	mov    0x8(%ebp),%eax
  801160:	01 d0                	add    %edx,%eax
  801162:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801165:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80116c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801170:	74 06                	je     801178 <vsnprintf+0x2d>
  801172:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801176:	7f 07                	jg     80117f <vsnprintf+0x34>
		return -E_INVAL;
  801178:	b8 03 00 00 00       	mov    $0x3,%eax
  80117d:	eb 20                	jmp    80119f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80117f:	ff 75 14             	pushl  0x14(%ebp)
  801182:	ff 75 10             	pushl  0x10(%ebp)
  801185:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801188:	50                   	push   %eax
  801189:	68 15 11 80 00       	push   $0x801115
  80118e:	e8 80 fb ff ff       	call   800d13 <vprintfmt>
  801193:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801196:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801199:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80119c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80119f:	c9                   	leave  
  8011a0:	c3                   	ret    

008011a1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011a1:	55                   	push   %ebp
  8011a2:	89 e5                	mov    %esp,%ebp
  8011a4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8011a7:	8d 45 10             	lea    0x10(%ebp),%eax
  8011aa:	83 c0 04             	add    $0x4,%eax
  8011ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8011b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8011b6:	50                   	push   %eax
  8011b7:	ff 75 0c             	pushl  0xc(%ebp)
  8011ba:	ff 75 08             	pushl  0x8(%ebp)
  8011bd:	e8 89 ff ff ff       	call   80114b <vsnprintf>
  8011c2:	83 c4 10             	add    $0x10,%esp
  8011c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8011c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8011cb:	c9                   	leave  
  8011cc:	c3                   	ret    

008011cd <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8011cd:	55                   	push   %ebp
  8011ce:	89 e5                	mov    %esp,%ebp
  8011d0:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  8011d3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011d7:	74 13                	je     8011ec <readline+0x1f>
		cprintf("%s", prompt);
  8011d9:	83 ec 08             	sub    $0x8,%esp
  8011dc:	ff 75 08             	pushl  0x8(%ebp)
  8011df:	68 c8 44 80 00       	push   $0x8044c8
  8011e4:	e8 50 f9 ff ff       	call   800b39 <cprintf>
  8011e9:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8011ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8011f3:	83 ec 0c             	sub    $0xc,%esp
  8011f6:	6a 00                	push   $0x0
  8011f8:	e8 30 f5 ff ff       	call   80072d <iscons>
  8011fd:	83 c4 10             	add    $0x10,%esp
  801200:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801203:	e8 12 f5 ff ff       	call   80071a <getchar>
  801208:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  80120b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80120f:	79 22                	jns    801233 <readline+0x66>
			if (c != -E_EOF)
  801211:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801215:	0f 84 ad 00 00 00    	je     8012c8 <readline+0xfb>
				cprintf("read error: %e\n", c);
  80121b:	83 ec 08             	sub    $0x8,%esp
  80121e:	ff 75 ec             	pushl  -0x14(%ebp)
  801221:	68 cb 44 80 00       	push   $0x8044cb
  801226:	e8 0e f9 ff ff       	call   800b39 <cprintf>
  80122b:	83 c4 10             	add    $0x10,%esp
			break;
  80122e:	e9 95 00 00 00       	jmp    8012c8 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801233:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801237:	7e 34                	jle    80126d <readline+0xa0>
  801239:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801240:	7f 2b                	jg     80126d <readline+0xa0>
			if (echoing)
  801242:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801246:	74 0e                	je     801256 <readline+0x89>
				cputchar(c);
  801248:	83 ec 0c             	sub    $0xc,%esp
  80124b:	ff 75 ec             	pushl  -0x14(%ebp)
  80124e:	e8 a8 f4 ff ff       	call   8006fb <cputchar>
  801253:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801256:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801259:	8d 50 01             	lea    0x1(%eax),%edx
  80125c:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80125f:	89 c2                	mov    %eax,%edx
  801261:	8b 45 0c             	mov    0xc(%ebp),%eax
  801264:	01 d0                	add    %edx,%eax
  801266:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801269:	88 10                	mov    %dl,(%eax)
  80126b:	eb 56                	jmp    8012c3 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  80126d:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801271:	75 1f                	jne    801292 <readline+0xc5>
  801273:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801277:	7e 19                	jle    801292 <readline+0xc5>
			if (echoing)
  801279:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80127d:	74 0e                	je     80128d <readline+0xc0>
				cputchar(c);
  80127f:	83 ec 0c             	sub    $0xc,%esp
  801282:	ff 75 ec             	pushl  -0x14(%ebp)
  801285:	e8 71 f4 ff ff       	call   8006fb <cputchar>
  80128a:	83 c4 10             	add    $0x10,%esp

			i--;
  80128d:	ff 4d f4             	decl   -0xc(%ebp)
  801290:	eb 31                	jmp    8012c3 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801292:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801296:	74 0a                	je     8012a2 <readline+0xd5>
  801298:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80129c:	0f 85 61 ff ff ff    	jne    801203 <readline+0x36>
			if (echoing)
  8012a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012a6:	74 0e                	je     8012b6 <readline+0xe9>
				cputchar(c);
  8012a8:	83 ec 0c             	sub    $0xc,%esp
  8012ab:	ff 75 ec             	pushl  -0x14(%ebp)
  8012ae:	e8 48 f4 ff ff       	call   8006fb <cputchar>
  8012b3:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8012b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012bc:	01 d0                	add    %edx,%eax
  8012be:	c6 00 00             	movb   $0x0,(%eax)
			break;
  8012c1:	eb 06                	jmp    8012c9 <readline+0xfc>
		}
	}
  8012c3:	e9 3b ff ff ff       	jmp    801203 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  8012c8:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  8012c9:	90                   	nop
  8012ca:	c9                   	leave  
  8012cb:	c3                   	ret    

008012cc <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8012cc:	55                   	push   %ebp
  8012cd:	89 e5                	mov    %esp,%ebp
  8012cf:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  8012d2:	e8 3c 0f 00 00       	call   802213 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  8012d7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012db:	74 13                	je     8012f0 <atomic_readline+0x24>
			cprintf("%s", prompt);
  8012dd:	83 ec 08             	sub    $0x8,%esp
  8012e0:	ff 75 08             	pushl  0x8(%ebp)
  8012e3:	68 c8 44 80 00       	push   $0x8044c8
  8012e8:	e8 4c f8 ff ff       	call   800b39 <cprintf>
  8012ed:	83 c4 10             	add    $0x10,%esp

		i = 0;
  8012f0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  8012f7:	83 ec 0c             	sub    $0xc,%esp
  8012fa:	6a 00                	push   $0x0
  8012fc:	e8 2c f4 ff ff       	call   80072d <iscons>
  801301:	83 c4 10             	add    $0x10,%esp
  801304:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  801307:	e8 0e f4 ff ff       	call   80071a <getchar>
  80130c:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  80130f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801313:	79 22                	jns    801337 <atomic_readline+0x6b>
				if (c != -E_EOF)
  801315:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801319:	0f 84 ad 00 00 00    	je     8013cc <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  80131f:	83 ec 08             	sub    $0x8,%esp
  801322:	ff 75 ec             	pushl  -0x14(%ebp)
  801325:	68 cb 44 80 00       	push   $0x8044cb
  80132a:	e8 0a f8 ff ff       	call   800b39 <cprintf>
  80132f:	83 c4 10             	add    $0x10,%esp
				break;
  801332:	e9 95 00 00 00       	jmp    8013cc <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  801337:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  80133b:	7e 34                	jle    801371 <atomic_readline+0xa5>
  80133d:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801344:	7f 2b                	jg     801371 <atomic_readline+0xa5>
				if (echoing)
  801346:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80134a:	74 0e                	je     80135a <atomic_readline+0x8e>
					cputchar(c);
  80134c:	83 ec 0c             	sub    $0xc,%esp
  80134f:	ff 75 ec             	pushl  -0x14(%ebp)
  801352:	e8 a4 f3 ff ff       	call   8006fb <cputchar>
  801357:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  80135a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80135d:	8d 50 01             	lea    0x1(%eax),%edx
  801360:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801363:	89 c2                	mov    %eax,%edx
  801365:	8b 45 0c             	mov    0xc(%ebp),%eax
  801368:	01 d0                	add    %edx,%eax
  80136a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80136d:	88 10                	mov    %dl,(%eax)
  80136f:	eb 56                	jmp    8013c7 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  801371:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801375:	75 1f                	jne    801396 <atomic_readline+0xca>
  801377:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80137b:	7e 19                	jle    801396 <atomic_readline+0xca>
				if (echoing)
  80137d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801381:	74 0e                	je     801391 <atomic_readline+0xc5>
					cputchar(c);
  801383:	83 ec 0c             	sub    $0xc,%esp
  801386:	ff 75 ec             	pushl  -0x14(%ebp)
  801389:	e8 6d f3 ff ff       	call   8006fb <cputchar>
  80138e:	83 c4 10             	add    $0x10,%esp
				i--;
  801391:	ff 4d f4             	decl   -0xc(%ebp)
  801394:	eb 31                	jmp    8013c7 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  801396:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80139a:	74 0a                	je     8013a6 <atomic_readline+0xda>
  80139c:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8013a0:	0f 85 61 ff ff ff    	jne    801307 <atomic_readline+0x3b>
				if (echoing)
  8013a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013aa:	74 0e                	je     8013ba <atomic_readline+0xee>
					cputchar(c);
  8013ac:	83 ec 0c             	sub    $0xc,%esp
  8013af:	ff 75 ec             	pushl  -0x14(%ebp)
  8013b2:	e8 44 f3 ff ff       	call   8006fb <cputchar>
  8013b7:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  8013ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c0:	01 d0                	add    %edx,%eax
  8013c2:	c6 00 00             	movb   $0x0,(%eax)
				break;
  8013c5:	eb 06                	jmp    8013cd <atomic_readline+0x101>
			}
		}
  8013c7:	e9 3b ff ff ff       	jmp    801307 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  8013cc:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  8013cd:	e8 5b 0e 00 00       	call   80222d <sys_unlock_cons>
}
  8013d2:	90                   	nop
  8013d3:	c9                   	leave  
  8013d4:	c3                   	ret    

008013d5 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  8013d5:	55                   	push   %ebp
  8013d6:	89 e5                	mov    %esp,%ebp
  8013d8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8013db:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013e2:	eb 06                	jmp    8013ea <strlen+0x15>
		n++;
  8013e4:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8013e7:	ff 45 08             	incl   0x8(%ebp)
  8013ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ed:	8a 00                	mov    (%eax),%al
  8013ef:	84 c0                	test   %al,%al
  8013f1:	75 f1                	jne    8013e4 <strlen+0xf>
		n++;
	return n;
  8013f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013f6:	c9                   	leave  
  8013f7:	c3                   	ret    

008013f8 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8013f8:	55                   	push   %ebp
  8013f9:	89 e5                	mov    %esp,%ebp
  8013fb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013fe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801405:	eb 09                	jmp    801410 <strnlen+0x18>
		n++;
  801407:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80140a:	ff 45 08             	incl   0x8(%ebp)
  80140d:	ff 4d 0c             	decl   0xc(%ebp)
  801410:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801414:	74 09                	je     80141f <strnlen+0x27>
  801416:	8b 45 08             	mov    0x8(%ebp),%eax
  801419:	8a 00                	mov    (%eax),%al
  80141b:	84 c0                	test   %al,%al
  80141d:	75 e8                	jne    801407 <strnlen+0xf>
		n++;
	return n;
  80141f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801422:	c9                   	leave  
  801423:	c3                   	ret    

00801424 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801424:	55                   	push   %ebp
  801425:	89 e5                	mov    %esp,%ebp
  801427:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80142a:	8b 45 08             	mov    0x8(%ebp),%eax
  80142d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801430:	90                   	nop
  801431:	8b 45 08             	mov    0x8(%ebp),%eax
  801434:	8d 50 01             	lea    0x1(%eax),%edx
  801437:	89 55 08             	mov    %edx,0x8(%ebp)
  80143a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80143d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801440:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801443:	8a 12                	mov    (%edx),%dl
  801445:	88 10                	mov    %dl,(%eax)
  801447:	8a 00                	mov    (%eax),%al
  801449:	84 c0                	test   %al,%al
  80144b:	75 e4                	jne    801431 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80144d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801450:	c9                   	leave  
  801451:	c3                   	ret    

00801452 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801452:	55                   	push   %ebp
  801453:	89 e5                	mov    %esp,%ebp
  801455:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801458:	8b 45 08             	mov    0x8(%ebp),%eax
  80145b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80145e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801465:	eb 1f                	jmp    801486 <strncpy+0x34>
		*dst++ = *src;
  801467:	8b 45 08             	mov    0x8(%ebp),%eax
  80146a:	8d 50 01             	lea    0x1(%eax),%edx
  80146d:	89 55 08             	mov    %edx,0x8(%ebp)
  801470:	8b 55 0c             	mov    0xc(%ebp),%edx
  801473:	8a 12                	mov    (%edx),%dl
  801475:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801477:	8b 45 0c             	mov    0xc(%ebp),%eax
  80147a:	8a 00                	mov    (%eax),%al
  80147c:	84 c0                	test   %al,%al
  80147e:	74 03                	je     801483 <strncpy+0x31>
			src++;
  801480:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801483:	ff 45 fc             	incl   -0x4(%ebp)
  801486:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801489:	3b 45 10             	cmp    0x10(%ebp),%eax
  80148c:	72 d9                	jb     801467 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80148e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801491:	c9                   	leave  
  801492:	c3                   	ret    

00801493 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801493:	55                   	push   %ebp
  801494:	89 e5                	mov    %esp,%ebp
  801496:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801499:	8b 45 08             	mov    0x8(%ebp),%eax
  80149c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80149f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014a3:	74 30                	je     8014d5 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8014a5:	eb 16                	jmp    8014bd <strlcpy+0x2a>
			*dst++ = *src++;
  8014a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014aa:	8d 50 01             	lea    0x1(%eax),%edx
  8014ad:	89 55 08             	mov    %edx,0x8(%ebp)
  8014b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014b3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014b6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8014b9:	8a 12                	mov    (%edx),%dl
  8014bb:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8014bd:	ff 4d 10             	decl   0x10(%ebp)
  8014c0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014c4:	74 09                	je     8014cf <strlcpy+0x3c>
  8014c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c9:	8a 00                	mov    (%eax),%al
  8014cb:	84 c0                	test   %al,%al
  8014cd:	75 d8                	jne    8014a7 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8014cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8014d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8014d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014db:	29 c2                	sub    %eax,%edx
  8014dd:	89 d0                	mov    %edx,%eax
}
  8014df:	c9                   	leave  
  8014e0:	c3                   	ret    

008014e1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8014e1:	55                   	push   %ebp
  8014e2:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8014e4:	eb 06                	jmp    8014ec <strcmp+0xb>
		p++, q++;
  8014e6:	ff 45 08             	incl   0x8(%ebp)
  8014e9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8014ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ef:	8a 00                	mov    (%eax),%al
  8014f1:	84 c0                	test   %al,%al
  8014f3:	74 0e                	je     801503 <strcmp+0x22>
  8014f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f8:	8a 10                	mov    (%eax),%dl
  8014fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014fd:	8a 00                	mov    (%eax),%al
  8014ff:	38 c2                	cmp    %al,%dl
  801501:	74 e3                	je     8014e6 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801503:	8b 45 08             	mov    0x8(%ebp),%eax
  801506:	8a 00                	mov    (%eax),%al
  801508:	0f b6 d0             	movzbl %al,%edx
  80150b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150e:	8a 00                	mov    (%eax),%al
  801510:	0f b6 c0             	movzbl %al,%eax
  801513:	29 c2                	sub    %eax,%edx
  801515:	89 d0                	mov    %edx,%eax
}
  801517:	5d                   	pop    %ebp
  801518:	c3                   	ret    

00801519 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801519:	55                   	push   %ebp
  80151a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80151c:	eb 09                	jmp    801527 <strncmp+0xe>
		n--, p++, q++;
  80151e:	ff 4d 10             	decl   0x10(%ebp)
  801521:	ff 45 08             	incl   0x8(%ebp)
  801524:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801527:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80152b:	74 17                	je     801544 <strncmp+0x2b>
  80152d:	8b 45 08             	mov    0x8(%ebp),%eax
  801530:	8a 00                	mov    (%eax),%al
  801532:	84 c0                	test   %al,%al
  801534:	74 0e                	je     801544 <strncmp+0x2b>
  801536:	8b 45 08             	mov    0x8(%ebp),%eax
  801539:	8a 10                	mov    (%eax),%dl
  80153b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80153e:	8a 00                	mov    (%eax),%al
  801540:	38 c2                	cmp    %al,%dl
  801542:	74 da                	je     80151e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801544:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801548:	75 07                	jne    801551 <strncmp+0x38>
		return 0;
  80154a:	b8 00 00 00 00       	mov    $0x0,%eax
  80154f:	eb 14                	jmp    801565 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801551:	8b 45 08             	mov    0x8(%ebp),%eax
  801554:	8a 00                	mov    (%eax),%al
  801556:	0f b6 d0             	movzbl %al,%edx
  801559:	8b 45 0c             	mov    0xc(%ebp),%eax
  80155c:	8a 00                	mov    (%eax),%al
  80155e:	0f b6 c0             	movzbl %al,%eax
  801561:	29 c2                	sub    %eax,%edx
  801563:	89 d0                	mov    %edx,%eax
}
  801565:	5d                   	pop    %ebp
  801566:	c3                   	ret    

00801567 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801567:	55                   	push   %ebp
  801568:	89 e5                	mov    %esp,%ebp
  80156a:	83 ec 04             	sub    $0x4,%esp
  80156d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801570:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801573:	eb 12                	jmp    801587 <strchr+0x20>
		if (*s == c)
  801575:	8b 45 08             	mov    0x8(%ebp),%eax
  801578:	8a 00                	mov    (%eax),%al
  80157a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80157d:	75 05                	jne    801584 <strchr+0x1d>
			return (char *) s;
  80157f:	8b 45 08             	mov    0x8(%ebp),%eax
  801582:	eb 11                	jmp    801595 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801584:	ff 45 08             	incl   0x8(%ebp)
  801587:	8b 45 08             	mov    0x8(%ebp),%eax
  80158a:	8a 00                	mov    (%eax),%al
  80158c:	84 c0                	test   %al,%al
  80158e:	75 e5                	jne    801575 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801590:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801595:	c9                   	leave  
  801596:	c3                   	ret    

00801597 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801597:	55                   	push   %ebp
  801598:	89 e5                	mov    %esp,%ebp
  80159a:	83 ec 04             	sub    $0x4,%esp
  80159d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015a3:	eb 0d                	jmp    8015b2 <strfind+0x1b>
		if (*s == c)
  8015a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a8:	8a 00                	mov    (%eax),%al
  8015aa:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015ad:	74 0e                	je     8015bd <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8015af:	ff 45 08             	incl   0x8(%ebp)
  8015b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b5:	8a 00                	mov    (%eax),%al
  8015b7:	84 c0                	test   %al,%al
  8015b9:	75 ea                	jne    8015a5 <strfind+0xe>
  8015bb:	eb 01                	jmp    8015be <strfind+0x27>
		if (*s == c)
			break;
  8015bd:	90                   	nop
	return (char *) s;
  8015be:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015c1:	c9                   	leave  
  8015c2:	c3                   	ret    

008015c3 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8015c3:	55                   	push   %ebp
  8015c4:	89 e5                	mov    %esp,%ebp
  8015c6:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8015c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8015cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8015d5:	eb 0e                	jmp    8015e5 <memset+0x22>
		*p++ = c;
  8015d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015da:	8d 50 01             	lea    0x1(%eax),%edx
  8015dd:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8015e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e3:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8015e5:	ff 4d f8             	decl   -0x8(%ebp)
  8015e8:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8015ec:	79 e9                	jns    8015d7 <memset+0x14>
		*p++ = c;

	return v;
  8015ee:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015f1:	c9                   	leave  
  8015f2:	c3                   	ret    

008015f3 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8015f3:	55                   	push   %ebp
  8015f4:	89 e5                	mov    %esp,%ebp
  8015f6:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8015f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8015ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801602:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801605:	eb 16                	jmp    80161d <memcpy+0x2a>
		*d++ = *s++;
  801607:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80160a:	8d 50 01             	lea    0x1(%eax),%edx
  80160d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801610:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801613:	8d 4a 01             	lea    0x1(%edx),%ecx
  801616:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801619:	8a 12                	mov    (%edx),%dl
  80161b:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80161d:	8b 45 10             	mov    0x10(%ebp),%eax
  801620:	8d 50 ff             	lea    -0x1(%eax),%edx
  801623:	89 55 10             	mov    %edx,0x10(%ebp)
  801626:	85 c0                	test   %eax,%eax
  801628:	75 dd                	jne    801607 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80162a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80162d:	c9                   	leave  
  80162e:	c3                   	ret    

0080162f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80162f:	55                   	push   %ebp
  801630:	89 e5                	mov    %esp,%ebp
  801632:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801635:	8b 45 0c             	mov    0xc(%ebp),%eax
  801638:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80163b:	8b 45 08             	mov    0x8(%ebp),%eax
  80163e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801641:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801644:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801647:	73 50                	jae    801699 <memmove+0x6a>
  801649:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80164c:	8b 45 10             	mov    0x10(%ebp),%eax
  80164f:	01 d0                	add    %edx,%eax
  801651:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801654:	76 43                	jbe    801699 <memmove+0x6a>
		s += n;
  801656:	8b 45 10             	mov    0x10(%ebp),%eax
  801659:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80165c:	8b 45 10             	mov    0x10(%ebp),%eax
  80165f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801662:	eb 10                	jmp    801674 <memmove+0x45>
			*--d = *--s;
  801664:	ff 4d f8             	decl   -0x8(%ebp)
  801667:	ff 4d fc             	decl   -0x4(%ebp)
  80166a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80166d:	8a 10                	mov    (%eax),%dl
  80166f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801672:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801674:	8b 45 10             	mov    0x10(%ebp),%eax
  801677:	8d 50 ff             	lea    -0x1(%eax),%edx
  80167a:	89 55 10             	mov    %edx,0x10(%ebp)
  80167d:	85 c0                	test   %eax,%eax
  80167f:	75 e3                	jne    801664 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801681:	eb 23                	jmp    8016a6 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801683:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801686:	8d 50 01             	lea    0x1(%eax),%edx
  801689:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80168c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80168f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801692:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801695:	8a 12                	mov    (%edx),%dl
  801697:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801699:	8b 45 10             	mov    0x10(%ebp),%eax
  80169c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80169f:	89 55 10             	mov    %edx,0x10(%ebp)
  8016a2:	85 c0                	test   %eax,%eax
  8016a4:	75 dd                	jne    801683 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8016a6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016a9:	c9                   	leave  
  8016aa:	c3                   	ret    

008016ab <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8016ab:	55                   	push   %ebp
  8016ac:	89 e5                	mov    %esp,%ebp
  8016ae:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8016b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8016b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016ba:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8016bd:	eb 2a                	jmp    8016e9 <memcmp+0x3e>
		if (*s1 != *s2)
  8016bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016c2:	8a 10                	mov    (%eax),%dl
  8016c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016c7:	8a 00                	mov    (%eax),%al
  8016c9:	38 c2                	cmp    %al,%dl
  8016cb:	74 16                	je     8016e3 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8016cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016d0:	8a 00                	mov    (%eax),%al
  8016d2:	0f b6 d0             	movzbl %al,%edx
  8016d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016d8:	8a 00                	mov    (%eax),%al
  8016da:	0f b6 c0             	movzbl %al,%eax
  8016dd:	29 c2                	sub    %eax,%edx
  8016df:	89 d0                	mov    %edx,%eax
  8016e1:	eb 18                	jmp    8016fb <memcmp+0x50>
		s1++, s2++;
  8016e3:	ff 45 fc             	incl   -0x4(%ebp)
  8016e6:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8016e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ec:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016ef:	89 55 10             	mov    %edx,0x10(%ebp)
  8016f2:	85 c0                	test   %eax,%eax
  8016f4:	75 c9                	jne    8016bf <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016fb:	c9                   	leave  
  8016fc:	c3                   	ret    

008016fd <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8016fd:	55                   	push   %ebp
  8016fe:	89 e5                	mov    %esp,%ebp
  801700:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801703:	8b 55 08             	mov    0x8(%ebp),%edx
  801706:	8b 45 10             	mov    0x10(%ebp),%eax
  801709:	01 d0                	add    %edx,%eax
  80170b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80170e:	eb 15                	jmp    801725 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801710:	8b 45 08             	mov    0x8(%ebp),%eax
  801713:	8a 00                	mov    (%eax),%al
  801715:	0f b6 d0             	movzbl %al,%edx
  801718:	8b 45 0c             	mov    0xc(%ebp),%eax
  80171b:	0f b6 c0             	movzbl %al,%eax
  80171e:	39 c2                	cmp    %eax,%edx
  801720:	74 0d                	je     80172f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801722:	ff 45 08             	incl   0x8(%ebp)
  801725:	8b 45 08             	mov    0x8(%ebp),%eax
  801728:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80172b:	72 e3                	jb     801710 <memfind+0x13>
  80172d:	eb 01                	jmp    801730 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80172f:	90                   	nop
	return (void *) s;
  801730:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801733:	c9                   	leave  
  801734:	c3                   	ret    

00801735 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801735:	55                   	push   %ebp
  801736:	89 e5                	mov    %esp,%ebp
  801738:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80173b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801742:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801749:	eb 03                	jmp    80174e <strtol+0x19>
		s++;
  80174b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80174e:	8b 45 08             	mov    0x8(%ebp),%eax
  801751:	8a 00                	mov    (%eax),%al
  801753:	3c 20                	cmp    $0x20,%al
  801755:	74 f4                	je     80174b <strtol+0x16>
  801757:	8b 45 08             	mov    0x8(%ebp),%eax
  80175a:	8a 00                	mov    (%eax),%al
  80175c:	3c 09                	cmp    $0x9,%al
  80175e:	74 eb                	je     80174b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801760:	8b 45 08             	mov    0x8(%ebp),%eax
  801763:	8a 00                	mov    (%eax),%al
  801765:	3c 2b                	cmp    $0x2b,%al
  801767:	75 05                	jne    80176e <strtol+0x39>
		s++;
  801769:	ff 45 08             	incl   0x8(%ebp)
  80176c:	eb 13                	jmp    801781 <strtol+0x4c>
	else if (*s == '-')
  80176e:	8b 45 08             	mov    0x8(%ebp),%eax
  801771:	8a 00                	mov    (%eax),%al
  801773:	3c 2d                	cmp    $0x2d,%al
  801775:	75 0a                	jne    801781 <strtol+0x4c>
		s++, neg = 1;
  801777:	ff 45 08             	incl   0x8(%ebp)
  80177a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801781:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801785:	74 06                	je     80178d <strtol+0x58>
  801787:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80178b:	75 20                	jne    8017ad <strtol+0x78>
  80178d:	8b 45 08             	mov    0x8(%ebp),%eax
  801790:	8a 00                	mov    (%eax),%al
  801792:	3c 30                	cmp    $0x30,%al
  801794:	75 17                	jne    8017ad <strtol+0x78>
  801796:	8b 45 08             	mov    0x8(%ebp),%eax
  801799:	40                   	inc    %eax
  80179a:	8a 00                	mov    (%eax),%al
  80179c:	3c 78                	cmp    $0x78,%al
  80179e:	75 0d                	jne    8017ad <strtol+0x78>
		s += 2, base = 16;
  8017a0:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8017a4:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8017ab:	eb 28                	jmp    8017d5 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8017ad:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017b1:	75 15                	jne    8017c8 <strtol+0x93>
  8017b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b6:	8a 00                	mov    (%eax),%al
  8017b8:	3c 30                	cmp    $0x30,%al
  8017ba:	75 0c                	jne    8017c8 <strtol+0x93>
		s++, base = 8;
  8017bc:	ff 45 08             	incl   0x8(%ebp)
  8017bf:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8017c6:	eb 0d                	jmp    8017d5 <strtol+0xa0>
	else if (base == 0)
  8017c8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017cc:	75 07                	jne    8017d5 <strtol+0xa0>
		base = 10;
  8017ce:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d8:	8a 00                	mov    (%eax),%al
  8017da:	3c 2f                	cmp    $0x2f,%al
  8017dc:	7e 19                	jle    8017f7 <strtol+0xc2>
  8017de:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e1:	8a 00                	mov    (%eax),%al
  8017e3:	3c 39                	cmp    $0x39,%al
  8017e5:	7f 10                	jg     8017f7 <strtol+0xc2>
			dig = *s - '0';
  8017e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ea:	8a 00                	mov    (%eax),%al
  8017ec:	0f be c0             	movsbl %al,%eax
  8017ef:	83 e8 30             	sub    $0x30,%eax
  8017f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017f5:	eb 42                	jmp    801839 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8017f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fa:	8a 00                	mov    (%eax),%al
  8017fc:	3c 60                	cmp    $0x60,%al
  8017fe:	7e 19                	jle    801819 <strtol+0xe4>
  801800:	8b 45 08             	mov    0x8(%ebp),%eax
  801803:	8a 00                	mov    (%eax),%al
  801805:	3c 7a                	cmp    $0x7a,%al
  801807:	7f 10                	jg     801819 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801809:	8b 45 08             	mov    0x8(%ebp),%eax
  80180c:	8a 00                	mov    (%eax),%al
  80180e:	0f be c0             	movsbl %al,%eax
  801811:	83 e8 57             	sub    $0x57,%eax
  801814:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801817:	eb 20                	jmp    801839 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801819:	8b 45 08             	mov    0x8(%ebp),%eax
  80181c:	8a 00                	mov    (%eax),%al
  80181e:	3c 40                	cmp    $0x40,%al
  801820:	7e 39                	jle    80185b <strtol+0x126>
  801822:	8b 45 08             	mov    0x8(%ebp),%eax
  801825:	8a 00                	mov    (%eax),%al
  801827:	3c 5a                	cmp    $0x5a,%al
  801829:	7f 30                	jg     80185b <strtol+0x126>
			dig = *s - 'A' + 10;
  80182b:	8b 45 08             	mov    0x8(%ebp),%eax
  80182e:	8a 00                	mov    (%eax),%al
  801830:	0f be c0             	movsbl %al,%eax
  801833:	83 e8 37             	sub    $0x37,%eax
  801836:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801839:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80183c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80183f:	7d 19                	jge    80185a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801841:	ff 45 08             	incl   0x8(%ebp)
  801844:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801847:	0f af 45 10          	imul   0x10(%ebp),%eax
  80184b:	89 c2                	mov    %eax,%edx
  80184d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801850:	01 d0                	add    %edx,%eax
  801852:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801855:	e9 7b ff ff ff       	jmp    8017d5 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80185a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80185b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80185f:	74 08                	je     801869 <strtol+0x134>
		*endptr = (char *) s;
  801861:	8b 45 0c             	mov    0xc(%ebp),%eax
  801864:	8b 55 08             	mov    0x8(%ebp),%edx
  801867:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801869:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80186d:	74 07                	je     801876 <strtol+0x141>
  80186f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801872:	f7 d8                	neg    %eax
  801874:	eb 03                	jmp    801879 <strtol+0x144>
  801876:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801879:	c9                   	leave  
  80187a:	c3                   	ret    

0080187b <ltostr>:

void
ltostr(long value, char *str)
{
  80187b:	55                   	push   %ebp
  80187c:	89 e5                	mov    %esp,%ebp
  80187e:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801881:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801888:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80188f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801893:	79 13                	jns    8018a8 <ltostr+0x2d>
	{
		neg = 1;
  801895:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80189c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80189f:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8018a2:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8018a5:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8018a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ab:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8018b0:	99                   	cltd   
  8018b1:	f7 f9                	idiv   %ecx
  8018b3:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8018b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018b9:	8d 50 01             	lea    0x1(%eax),%edx
  8018bc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018bf:	89 c2                	mov    %eax,%edx
  8018c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c4:	01 d0                	add    %edx,%eax
  8018c6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018c9:	83 c2 30             	add    $0x30,%edx
  8018cc:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8018ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018d1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8018d6:	f7 e9                	imul   %ecx
  8018d8:	c1 fa 02             	sar    $0x2,%edx
  8018db:	89 c8                	mov    %ecx,%eax
  8018dd:	c1 f8 1f             	sar    $0x1f,%eax
  8018e0:	29 c2                	sub    %eax,%edx
  8018e2:	89 d0                	mov    %edx,%eax
  8018e4:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8018e7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018eb:	75 bb                	jne    8018a8 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8018ed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8018f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018f7:	48                   	dec    %eax
  8018f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8018fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018ff:	74 3d                	je     80193e <ltostr+0xc3>
		start = 1 ;
  801901:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801908:	eb 34                	jmp    80193e <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80190a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80190d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801910:	01 d0                	add    %edx,%eax
  801912:	8a 00                	mov    (%eax),%al
  801914:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801917:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80191a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80191d:	01 c2                	add    %eax,%edx
  80191f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801922:	8b 45 0c             	mov    0xc(%ebp),%eax
  801925:	01 c8                	add    %ecx,%eax
  801927:	8a 00                	mov    (%eax),%al
  801929:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80192b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80192e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801931:	01 c2                	add    %eax,%edx
  801933:	8a 45 eb             	mov    -0x15(%ebp),%al
  801936:	88 02                	mov    %al,(%edx)
		start++ ;
  801938:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80193b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80193e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801941:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801944:	7c c4                	jl     80190a <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801946:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801949:	8b 45 0c             	mov    0xc(%ebp),%eax
  80194c:	01 d0                	add    %edx,%eax
  80194e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801951:	90                   	nop
  801952:	c9                   	leave  
  801953:	c3                   	ret    

00801954 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801954:	55                   	push   %ebp
  801955:	89 e5                	mov    %esp,%ebp
  801957:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80195a:	ff 75 08             	pushl  0x8(%ebp)
  80195d:	e8 73 fa ff ff       	call   8013d5 <strlen>
  801962:	83 c4 04             	add    $0x4,%esp
  801965:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801968:	ff 75 0c             	pushl  0xc(%ebp)
  80196b:	e8 65 fa ff ff       	call   8013d5 <strlen>
  801970:	83 c4 04             	add    $0x4,%esp
  801973:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801976:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80197d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801984:	eb 17                	jmp    80199d <strcconcat+0x49>
		final[s] = str1[s] ;
  801986:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801989:	8b 45 10             	mov    0x10(%ebp),%eax
  80198c:	01 c2                	add    %eax,%edx
  80198e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801991:	8b 45 08             	mov    0x8(%ebp),%eax
  801994:	01 c8                	add    %ecx,%eax
  801996:	8a 00                	mov    (%eax),%al
  801998:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80199a:	ff 45 fc             	incl   -0x4(%ebp)
  80199d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019a0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8019a3:	7c e1                	jl     801986 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8019a5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8019ac:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8019b3:	eb 1f                	jmp    8019d4 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8019b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019b8:	8d 50 01             	lea    0x1(%eax),%edx
  8019bb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8019be:	89 c2                	mov    %eax,%edx
  8019c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8019c3:	01 c2                	add    %eax,%edx
  8019c5:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8019c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019cb:	01 c8                	add    %ecx,%eax
  8019cd:	8a 00                	mov    (%eax),%al
  8019cf:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8019d1:	ff 45 f8             	incl   -0x8(%ebp)
  8019d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019d7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019da:	7c d9                	jl     8019b5 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8019dc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019df:	8b 45 10             	mov    0x10(%ebp),%eax
  8019e2:	01 d0                	add    %edx,%eax
  8019e4:	c6 00 00             	movb   $0x0,(%eax)
}
  8019e7:	90                   	nop
  8019e8:	c9                   	leave  
  8019e9:	c3                   	ret    

008019ea <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8019ea:	55                   	push   %ebp
  8019eb:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8019ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8019f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8019f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8019f9:	8b 00                	mov    (%eax),%eax
  8019fb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a02:	8b 45 10             	mov    0x10(%ebp),%eax
  801a05:	01 d0                	add    %edx,%eax
  801a07:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a0d:	eb 0c                	jmp    801a1b <strsplit+0x31>
			*string++ = 0;
  801a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a12:	8d 50 01             	lea    0x1(%eax),%edx
  801a15:	89 55 08             	mov    %edx,0x8(%ebp)
  801a18:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1e:	8a 00                	mov    (%eax),%al
  801a20:	84 c0                	test   %al,%al
  801a22:	74 18                	je     801a3c <strsplit+0x52>
  801a24:	8b 45 08             	mov    0x8(%ebp),%eax
  801a27:	8a 00                	mov    (%eax),%al
  801a29:	0f be c0             	movsbl %al,%eax
  801a2c:	50                   	push   %eax
  801a2d:	ff 75 0c             	pushl  0xc(%ebp)
  801a30:	e8 32 fb ff ff       	call   801567 <strchr>
  801a35:	83 c4 08             	add    $0x8,%esp
  801a38:	85 c0                	test   %eax,%eax
  801a3a:	75 d3                	jne    801a0f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3f:	8a 00                	mov    (%eax),%al
  801a41:	84 c0                	test   %al,%al
  801a43:	74 5a                	je     801a9f <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a45:	8b 45 14             	mov    0x14(%ebp),%eax
  801a48:	8b 00                	mov    (%eax),%eax
  801a4a:	83 f8 0f             	cmp    $0xf,%eax
  801a4d:	75 07                	jne    801a56 <strsplit+0x6c>
		{
			return 0;
  801a4f:	b8 00 00 00 00       	mov    $0x0,%eax
  801a54:	eb 66                	jmp    801abc <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a56:	8b 45 14             	mov    0x14(%ebp),%eax
  801a59:	8b 00                	mov    (%eax),%eax
  801a5b:	8d 48 01             	lea    0x1(%eax),%ecx
  801a5e:	8b 55 14             	mov    0x14(%ebp),%edx
  801a61:	89 0a                	mov    %ecx,(%edx)
  801a63:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a6a:	8b 45 10             	mov    0x10(%ebp),%eax
  801a6d:	01 c2                	add    %eax,%edx
  801a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a72:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a74:	eb 03                	jmp    801a79 <strsplit+0x8f>
			string++;
  801a76:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a79:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7c:	8a 00                	mov    (%eax),%al
  801a7e:	84 c0                	test   %al,%al
  801a80:	74 8b                	je     801a0d <strsplit+0x23>
  801a82:	8b 45 08             	mov    0x8(%ebp),%eax
  801a85:	8a 00                	mov    (%eax),%al
  801a87:	0f be c0             	movsbl %al,%eax
  801a8a:	50                   	push   %eax
  801a8b:	ff 75 0c             	pushl  0xc(%ebp)
  801a8e:	e8 d4 fa ff ff       	call   801567 <strchr>
  801a93:	83 c4 08             	add    $0x8,%esp
  801a96:	85 c0                	test   %eax,%eax
  801a98:	74 dc                	je     801a76 <strsplit+0x8c>
			string++;
	}
  801a9a:	e9 6e ff ff ff       	jmp    801a0d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801a9f:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801aa0:	8b 45 14             	mov    0x14(%ebp),%eax
  801aa3:	8b 00                	mov    (%eax),%eax
  801aa5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801aac:	8b 45 10             	mov    0x10(%ebp),%eax
  801aaf:	01 d0                	add    %edx,%eax
  801ab1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801ab7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801abc:	c9                   	leave  
  801abd:	c3                   	ret    

00801abe <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801abe:	55                   	push   %ebp
  801abf:	89 e5                	mov    %esp,%ebp
  801ac1:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801ac4:	83 ec 04             	sub    $0x4,%esp
  801ac7:	68 dc 44 80 00       	push   $0x8044dc
  801acc:	68 3f 01 00 00       	push   $0x13f
  801ad1:	68 fe 44 80 00       	push   $0x8044fe
  801ad6:	e8 a1 ed ff ff       	call   80087c <_panic>

00801adb <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  801adb:	55                   	push   %ebp
  801adc:	89 e5                	mov    %esp,%ebp
  801ade:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801ae1:	83 ec 0c             	sub    $0xc,%esp
  801ae4:	ff 75 08             	pushl  0x8(%ebp)
  801ae7:	e8 90 0c 00 00       	call   80277c <sys_sbrk>
  801aec:	83 c4 10             	add    $0x10,%esp
}
  801aef:	c9                   	leave  
  801af0:	c3                   	ret    

00801af1 <malloc>:
#define num_of_page ((USER_HEAP_MAX - USER_HEAP_START) / PAGE_SIZE)

int pagesAllocated[num_of_page] = { 0 };
int shardIDs[num_of_page] = { 0 };
bool markedPages[num_of_page] = { 0 };
void* malloc(uint32 size) {
  801af1:	55                   	push   %ebp
  801af2:	89 e5                	mov    %esp,%ebp
  801af4:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  801af7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801afb:	75 0a                	jne    801b07 <malloc+0x16>
		return NULL;
  801afd:	b8 00 00 00 00       	mov    $0x0,%eax
  801b02:	e9 9e 01 00 00       	jmp    801ca5 <malloc+0x1b4>

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

	//  our new code
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  801b07:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801b0e:	77 2c                	ja     801b3c <malloc+0x4b>
		if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  801b10:	e8 eb 0a 00 00       	call   802600 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b15:	85 c0                	test   %eax,%eax
  801b17:	74 19                	je     801b32 <malloc+0x41>

			void * block = alloc_block_FF(size);
  801b19:	83 ec 0c             	sub    $0xc,%esp
  801b1c:	ff 75 08             	pushl  0x8(%ebp)
  801b1f:	e8 85 11 00 00       	call   802ca9 <alloc_block_FF>
  801b24:	83 c4 10             	add    $0x10,%esp
  801b27:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			return block;
  801b2a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b2d:	e9 73 01 00 00       	jmp    801ca5 <malloc+0x1b4>
		} else {
			return NULL;
  801b32:	b8 00 00 00 00       	mov    $0x0,%eax
  801b37:	e9 69 01 00 00       	jmp    801ca5 <malloc+0x1b4>
		}
	}

	uint32 numOfPages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801b3c:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801b43:	8b 55 08             	mov    0x8(%ebp),%edx
  801b46:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b49:	01 d0                	add    %edx,%eax
  801b4b:	48                   	dec    %eax
  801b4c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801b4f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b52:	ba 00 00 00 00       	mov    $0x0,%edx
  801b57:	f7 75 e0             	divl   -0x20(%ebp)
  801b5a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b5d:	29 d0                	sub    %edx,%eax
  801b5f:	c1 e8 0c             	shr    $0xc,%eax
  801b62:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 freePagesCount = 0;
  801b65:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801b6c:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  801b73:	a1 24 50 80 00       	mov    0x805024,%eax
  801b78:	8b 40 7c             	mov    0x7c(%eax),%eax
  801b7b:	05 00 10 00 00       	add    $0x1000,%eax
  801b80:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  801b83:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801b88:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801b8b:	89 45 d0             	mov    %eax,-0x30(%ebp)

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  801b8e:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  801b95:	8b 55 08             	mov    0x8(%ebp),%edx
  801b98:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801b9b:	01 d0                	add    %edx,%eax
  801b9d:	48                   	dec    %eax
  801b9e:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801ba1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801ba4:	ba 00 00 00 00       	mov    $0x0,%edx
  801ba9:	f7 75 cc             	divl   -0x34(%ebp)
  801bac:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801baf:	29 d0                	sub    %edx,%eax
  801bb1:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801bb4:	76 0a                	jbe    801bc0 <malloc+0xcf>
		return NULL;
  801bb6:	b8 00 00 00 00       	mov    $0x0,%eax
  801bbb:	e9 e5 00 00 00       	jmp    801ca5 <malloc+0x1b4>
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  801bc0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801bc3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801bc6:	eb 48                	jmp    801c10 <malloc+0x11f>
	{
		uint32 idx = (i - currentAddr) / PAGE_SIZE;
  801bc8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bcb:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801bce:	c1 e8 0c             	shr    $0xc,%eax
  801bd1:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if (!markedPages[idx]) {
  801bd4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801bd7:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  801bde:	85 c0                	test   %eax,%eax
  801be0:	75 11                	jne    801bf3 <malloc+0x102>
			freePagesCount++;
  801be2:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801be5:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801be9:	75 16                	jne    801c01 <malloc+0x110>
				start = i;
  801beb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801bf1:	eb 0e                	jmp    801c01 <malloc+0x110>
			}
		} else {
			freePagesCount = 0;
  801bf3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  801bfa:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == numOfPages) {
  801c01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c04:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801c07:	74 12                	je     801c1b <malloc+0x12a>

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  801c09:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801c10:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801c17:	76 af                	jbe    801bc8 <malloc+0xd7>
  801c19:	eb 01                	jmp    801c1c <malloc+0x12b>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == numOfPages) {
			break;
  801c1b:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
  801c1c:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801c20:	74 08                	je     801c2a <malloc+0x139>
  801c22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c25:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801c28:	74 07                	je     801c31 <malloc+0x140>
		return NULL;
  801c2a:	b8 00 00 00 00       	mov    $0x0,%eax
  801c2f:	eb 74                	jmp    801ca5 <malloc+0x1b4>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  801c31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c34:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801c37:	c1 e8 0c             	shr    $0xc,%eax
  801c3a:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numOfPages;
  801c3d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801c40:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801c43:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  801c4a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801c4d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801c50:	eb 11                	jmp    801c63 <malloc+0x172>
		markedPages[i] = 1;
  801c52:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c55:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  801c5c:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = numOfPages;
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  801c60:	ff 45 e8             	incl   -0x18(%ebp)
  801c63:	8b 55 c0             	mov    -0x40(%ebp),%edx
  801c66:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c69:	01 d0                	add    %edx,%eax
  801c6b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801c6e:	77 e2                	ja     801c52 <malloc+0x161>
		markedPages[i] = 1;
	}

	sys_allocate_user_mem(start, ROUNDUP(size, PAGE_SIZE));
  801c70:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801c77:	8b 55 08             	mov    0x8(%ebp),%edx
  801c7a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801c7d:	01 d0                	add    %edx,%eax
  801c7f:	48                   	dec    %eax
  801c80:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801c83:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801c86:	ba 00 00 00 00       	mov    $0x0,%edx
  801c8b:	f7 75 bc             	divl   -0x44(%ebp)
  801c8e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801c91:	29 d0                	sub    %edx,%eax
  801c93:	83 ec 08             	sub    $0x8,%esp
  801c96:	50                   	push   %eax
  801c97:	ff 75 f0             	pushl  -0x10(%ebp)
  801c9a:	e8 14 0b 00 00       	call   8027b3 <sys_allocate_user_mem>
  801c9f:	83 c4 10             	add    $0x10,%esp
	return (void*) start;
  801ca2:	8b 45 f0             	mov    -0x10(%ebp),%eax

}
  801ca5:	c9                   	leave  
  801ca6:	c3                   	ret    

00801ca7 <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address) {
  801ca7:	55                   	push   %ebp
  801ca8:	89 e5                	mov    %esp,%ebp
  801caa:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
  801cad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801cb1:	0f 84 ee 00 00 00    	je     801da5 <free+0xfe>
		return;
	}

	if (virtual_address
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  801cb7:	a1 24 50 80 00       	mov    0x805024,%eax
  801cbc:	8b 40 74             	mov    0x74(%eax),%eax

	if (virtual_address == NULL) {
		return;
	}

	if (virtual_address
  801cbf:	3b 45 08             	cmp    0x8(%ebp),%eax
  801cc2:	77 09                	ja     801ccd <free+0x26>
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  801cc4:	81 7d 08 00 00 00 a0 	cmpl   $0xa0000000,0x8(%ebp)
  801ccb:	76 14                	jbe    801ce1 <free+0x3a>
		panic("INVALID VIRTUAL ADDRESS!!");
  801ccd:	83 ec 04             	sub    $0x4,%esp
  801cd0:	68 0c 45 80 00       	push   $0x80450c
  801cd5:	6a 68                	push   $0x68
  801cd7:	68 26 45 80 00       	push   $0x804526
  801cdc:	e8 9b eb ff ff       	call   80087c <_panic>
	}
	if (virtual_address >= (void *) (myEnv->uheapStart)
  801ce1:	a1 24 50 80 00       	mov    0x805024,%eax
  801ce6:	8b 40 74             	mov    0x74(%eax),%eax
  801ce9:	3b 45 08             	cmp    0x8(%ebp),%eax
  801cec:	77 20                	ja     801d0e <free+0x67>
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
  801cee:	a1 24 50 80 00       	mov    0x805024,%eax
  801cf3:	8b 40 78             	mov    0x78(%eax),%eax
  801cf6:	3b 45 08             	cmp    0x8(%ebp),%eax
  801cf9:	76 13                	jbe    801d0e <free+0x67>
		free_block(virtual_address);
  801cfb:	83 ec 0c             	sub    $0xc,%esp
  801cfe:	ff 75 08             	pushl  0x8(%ebp)
  801d01:	e8 6c 16 00 00       	call   803372 <free_block>
  801d06:	83 c4 10             	add    $0x10,%esp
		return;
  801d09:	e9 98 00 00 00       	jmp    801da6 <free+0xff>
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  801d0e:	8b 55 08             	mov    0x8(%ebp),%edx
  801d11:	a1 24 50 80 00       	mov    0x805024,%eax
  801d16:	8b 40 7c             	mov    0x7c(%eax),%eax
  801d19:	29 c2                	sub    %eax,%edx
  801d1b:	89 d0                	mov    %edx,%eax
  801d1d:	2d 00 10 00 00       	sub    $0x1000,%eax
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
		free_block(virtual_address);
		return;
	}

	uint32 pageIdx = ((uint32) virtual_address
  801d22:	c1 e8 0c             	shr    $0xc,%eax
  801d25:	89 45 ec             	mov    %eax,-0x14(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  801d28:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801d2f:	eb 16                	jmp    801d47 <free+0xa0>
		markedPages[idx + pageIdx] = 0;
  801d31:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d37:	01 d0                	add    %edx,%eax
  801d39:	c7 04 85 40 50 90 00 	movl   $0x0,0x905040(,%eax,4)
  801d40:	00 00 00 00 
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  801d44:	ff 45 f4             	incl   -0xc(%ebp)
  801d47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d4a:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  801d51:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801d54:	7f db                	jg     801d31 <free+0x8a>
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;
  801d56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d59:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  801d60:	c1 e0 0c             	shl    $0xc,%eax
  801d63:	89 45 e8             	mov    %eax,-0x18(%ebp)

	for (uint32 i = (uint32) virtual_address;
  801d66:	8b 45 08             	mov    0x8(%ebp),%eax
  801d69:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d6c:	eb 1a                	jmp    801d88 <free+0xe1>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
  801d6e:	83 ec 08             	sub    $0x8,%esp
  801d71:	68 00 10 00 00       	push   $0x1000
  801d76:	ff 75 f0             	pushl  -0x10(%ebp)
  801d79:	e8 19 0a 00 00       	call   802797 <sys_free_user_mem>
  801d7e:	83 c4 10             	add    $0x10,%esp
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
  801d81:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  801d88:	8b 55 08             	mov    0x8(%ebp),%edx
  801d8b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d8e:	01 d0                	add    %edx,%eax
	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
  801d90:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801d93:	77 d9                	ja     801d6e <free+0xc7>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;
  801d95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d98:	c7 04 85 40 50 80 00 	movl   $0x0,0x805040(,%eax,4)
  801d9f:	00 00 00 00 
  801da3:	eb 01                	jmp    801da6 <free+0xff>
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
		return;
  801da5:	90                   	nop
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;

}
  801da6:	c9                   	leave  
  801da7:	c3                   	ret    

00801da8 <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  801da8:	55                   	push   %ebp
  801da9:	89 e5                	mov    %esp,%ebp
  801dab:	83 ec 58             	sub    $0x58,%esp
  801dae:	8b 45 10             	mov    0x10(%ebp),%eax
  801db1:	88 45 b4             	mov    %al,-0x4c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  801db4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801db8:	75 0a                	jne    801dc4 <smalloc+0x1c>
		return NULL;
  801dba:	b8 00 00 00 00       	mov    $0x0,%eax
  801dbf:	e9 7d 01 00 00       	jmp    801f41 <smalloc+0x199>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	uint32 num_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801dc4:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  801dcb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801dd1:	01 d0                	add    %edx,%eax
  801dd3:	48                   	dec    %eax
  801dd4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801dd7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801dda:	ba 00 00 00 00       	mov    $0x0,%edx
  801ddf:	f7 75 e4             	divl   -0x1c(%ebp)
  801de2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801de5:	29 d0                	sub    %edx,%eax
  801de7:	c1 e8 0c             	shr    $0xc,%eax
  801dea:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 freePagesCount = 0;
  801ded:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801df4:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  801dfb:	a1 24 50 80 00       	mov    0x805024,%eax
  801e00:	8b 40 7c             	mov    0x7c(%eax),%eax
  801e03:	05 00 10 00 00       	add    $0x1000,%eax
  801e08:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  801e0b:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801e10:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801e13:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  801e16:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801e1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e20:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e23:	01 d0                	add    %edx,%eax
  801e25:	48                   	dec    %eax
  801e26:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801e29:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801e2c:	ba 00 00 00 00       	mov    $0x0,%edx
  801e31:	f7 75 d0             	divl   -0x30(%ebp)
  801e34:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801e37:	29 d0                	sub    %edx,%eax
  801e39:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801e3c:	76 0a                	jbe    801e48 <smalloc+0xa0>
		return NULL;
  801e3e:	b8 00 00 00 00       	mov    $0x0,%eax
  801e43:	e9 f9 00 00 00       	jmp    801f41 <smalloc+0x199>
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801e48:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e4b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801e4e:	eb 48                	jmp    801e98 <smalloc+0xf0>
		uint32 idx = (s - currentAddr) / PAGE_SIZE;
  801e50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e53:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801e56:	c1 e8 0c             	shr    $0xc,%eax
  801e59:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (!markedPages[idx]) {
  801e5c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801e5f:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  801e66:	85 c0                	test   %eax,%eax
  801e68:	75 11                	jne    801e7b <smalloc+0xd3>
			freePagesCount++;
  801e6a:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801e6d:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801e71:	75 16                	jne    801e89 <smalloc+0xe1>
				start = s;
  801e73:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e76:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e79:	eb 0e                	jmp    801e89 <smalloc+0xe1>
			}
		} else {
			freePagesCount = 0;
  801e7b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  801e82:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == num_Of_Pages) {
  801e89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e8c:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801e8f:	74 12                	je     801ea3 <smalloc+0xfb>
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801e91:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801e98:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801e9f:	76 af                	jbe    801e50 <smalloc+0xa8>
  801ea1:	eb 01                	jmp    801ea4 <smalloc+0xfc>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == num_Of_Pages) {
			break;
  801ea3:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
  801ea4:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801ea8:	74 08                	je     801eb2 <smalloc+0x10a>
  801eaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ead:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801eb0:	74 0a                	je     801ebc <smalloc+0x114>
		return NULL;
  801eb2:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb7:	e9 85 00 00 00       	jmp    801f41 <smalloc+0x199>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  801ebc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ebf:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801ec2:	c1 e8 0c             	shr    $0xc,%eax
  801ec5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	pagesAllocated[startPage] = num_Of_Pages;
  801ec8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801ecb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801ece:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  801ed5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801ed8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801edb:	eb 11                	jmp    801eee <smalloc+0x146>
		markedPages[s] = 1;
  801edd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ee0:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  801ee7:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = num_Of_Pages;
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  801eeb:	ff 45 e8             	incl   -0x18(%ebp)
  801eee:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801ef1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ef4:	01 d0                	add    %edx,%eax
  801ef6:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801ef9:	77 e2                	ja     801edd <smalloc+0x135>
		markedPages[s] = 1;
	}
	int sharedobjID = sys_createSharedObject(sharedVarName, size, isWritable,
  801efb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801efe:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
  801f02:	52                   	push   %edx
  801f03:	50                   	push   %eax
  801f04:	ff 75 0c             	pushl  0xc(%ebp)
  801f07:	ff 75 08             	pushl  0x8(%ebp)
  801f0a:	e8 8f 04 00 00       	call   80239e <sys_createSharedObject>
  801f0f:	83 c4 10             	add    $0x10,%esp
  801f12:	89 45 c0             	mov    %eax,-0x40(%ebp)
			(void*) start);

	if (sharedobjID >= 0) {
  801f15:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  801f19:	78 12                	js     801f2d <smalloc+0x185>
		shardIDs[startPage] = sharedobjID;
  801f1b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801f1e:	8b 55 c0             	mov    -0x40(%ebp),%edx
  801f21:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  801f28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f2b:	eb 14                	jmp    801f41 <smalloc+0x199>
	}
	free((void*) start);
  801f2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f30:	83 ec 0c             	sub    $0xc,%esp
  801f33:	50                   	push   %eax
  801f34:	e8 6e fd ff ff       	call   801ca7 <free>
  801f39:	83 c4 10             	add    $0x10,%esp
	return NULL;
  801f3c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f41:	c9                   	leave  
  801f42:	c3                   	ret    

00801f43 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  801f43:	55                   	push   %ebp
  801f44:	89 e5                	mov    %esp,%ebp
  801f46:	83 ec 48             	sub    $0x48,%esp
	//cprintf("SSSSSGEEETTT\n");
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID, sharedVarName);
  801f49:	83 ec 08             	sub    $0x8,%esp
  801f4c:	ff 75 0c             	pushl  0xc(%ebp)
  801f4f:	ff 75 08             	pushl  0x8(%ebp)
  801f52:	e8 71 04 00 00       	call   8023c8 <sys_getSizeOfSharedObject>
  801f57:	83 c4 10             	add    $0x10,%esp
  801f5a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (size < 0)
		return NULL;
	uint32 numb_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801f5d:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801f64:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801f67:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f6a:	01 d0                	add    %edx,%eax
  801f6c:	48                   	dec    %eax
  801f6d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801f70:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801f73:	ba 00 00 00 00       	mov    $0x0,%edx
  801f78:	f7 75 e0             	divl   -0x20(%ebp)
  801f7b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801f7e:	29 d0                	sub    %edx,%eax
  801f80:	c1 e8 0c             	shr    $0xc,%eax
  801f83:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 free_Pages_Count = 0;
  801f86:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801f8d:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
  801f94:	a1 24 50 80 00       	mov    0x805024,%eax
  801f99:	8b 40 7c             	mov    0x7c(%eax),%eax
  801f9c:	05 00 10 00 00       	add    $0x1000,%eax
  801fa1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
  801fa4:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801fa9:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801fac:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
  801faf:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  801fb6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801fb9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801fbc:	01 d0                	add    %edx,%eax
  801fbe:	48                   	dec    %eax
  801fbf:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801fc2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801fc5:	ba 00 00 00 00       	mov    $0x0,%edx
  801fca:	f7 75 cc             	divl   -0x34(%ebp)
  801fcd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801fd0:	29 d0                	sub    %edx,%eax
  801fd2:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801fd5:	76 0a                	jbe    801fe1 <sget+0x9e>
		return NULL;
  801fd7:	b8 00 00 00 00       	mov    $0x0,%eax
  801fdc:	e9 f7 00 00 00       	jmp    8020d8 <sget+0x195>
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801fe1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801fe4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801fe7:	eb 48                	jmp    802031 <sget+0xee>
		uint32 idx = (s - current_Addr) / PAGE_SIZE;
  801fe9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fec:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801fef:	c1 e8 0c             	shr    $0xc,%eax
  801ff2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if (!markedPages[idx]) {
  801ff5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801ff8:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  801fff:	85 c0                	test   %eax,%eax
  802001:	75 11                	jne    802014 <sget+0xd1>
			free_Pages_Count++;
  802003:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  802006:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80200a:	75 16                	jne    802022 <sget+0xdf>
				start = s;
  80200c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80200f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802012:	eb 0e                	jmp    802022 <sget+0xdf>
			}
		} else {
			free_Pages_Count = 0;
  802014:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  80201b:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (free_Pages_Count == numb_Of_Pages) {
  802022:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802025:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  802028:	74 12                	je     80203c <sget+0xf9>
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
		return NULL;
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  80202a:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  802031:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  802038:	76 af                	jbe    801fe9 <sget+0xa6>
  80203a:	eb 01                	jmp    80203d <sget+0xfa>
		} else {
			free_Pages_Count = 0;
			start = (uint32) -1;
		}
		if (free_Pages_Count == numb_Of_Pages) {
			break;
  80203c:	90                   	nop
		}
	}
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
  80203d:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802041:	74 08                	je     80204b <sget+0x108>
  802043:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802046:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  802049:	74 0a                	je     802055 <sget+0x112>
		return NULL;
  80204b:	b8 00 00 00 00       	mov    $0x0,%eax
  802050:	e9 83 00 00 00       	jmp    8020d8 <sget+0x195>
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
  802055:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802058:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80205b:	c1 e8 0c             	shr    $0xc,%eax
  80205e:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numb_Of_Pages;
  802061:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802064:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802067:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  80206e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802071:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802074:	eb 11                	jmp    802087 <sget+0x144>
		markedPages[k] = 1;
  802076:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802079:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  802080:	01 00 00 00 
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
	pagesAllocated[startPage] = numb_Of_Pages;
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  802084:	ff 45 e8             	incl   -0x18(%ebp)
  802087:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80208a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80208d:	01 d0                	add    %edx,%eax
  80208f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802092:	77 e2                	ja     802076 <sget+0x133>
		markedPages[k] = 1;
	}
	int ss = sys_getSharedObject(ownerEnvID, sharedVarName, (void*) start);
  802094:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802097:	83 ec 04             	sub    $0x4,%esp
  80209a:	50                   	push   %eax
  80209b:	ff 75 0c             	pushl  0xc(%ebp)
  80209e:	ff 75 08             	pushl  0x8(%ebp)
  8020a1:	e8 3f 03 00 00       	call   8023e5 <sys_getSharedObject>
  8020a6:	83 c4 10             	add    $0x10,%esp
  8020a9:	89 45 bc             	mov    %eax,-0x44(%ebp)
	if (ss >= 0) {
  8020ac:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  8020b0:	78 12                	js     8020c4 <sget+0x181>
		shardIDs[startPage] = ss;
  8020b2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8020b5:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8020b8:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  8020bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020c2:	eb 14                	jmp    8020d8 <sget+0x195>
	}
	free((void*) start);
  8020c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020c7:	83 ec 0c             	sub    $0xc,%esp
  8020ca:	50                   	push   %eax
  8020cb:	e8 d7 fb ff ff       	call   801ca7 <free>
  8020d0:	83 c4 10             	add    $0x10,%esp
	return NULL;
  8020d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020d8:	c9                   	leave  
  8020d9:	c3                   	ret    

008020da <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  8020da:	55                   	push   %ebp
  8020db:	89 e5                	mov    %esp,%ebp
  8020dd:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  8020e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8020e3:	a1 24 50 80 00       	mov    0x805024,%eax
  8020e8:	8b 40 7c             	mov    0x7c(%eax),%eax
  8020eb:	29 c2                	sub    %eax,%edx
  8020ed:	89 d0                	mov    %edx,%eax
  8020ef:	2d 00 10 00 00       	sub    $0x1000,%eax

void sfree(void* virtual_address) {
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
  8020f4:	c1 e8 0c             	shr    $0xc,%eax
  8020f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
	int id = shardIDs[pageIdx];
  8020fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fd:	8b 04 85 40 50 88 00 	mov    0x885040(,%eax,4),%eax
  802104:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int result = sys_freeSharedObject(id, virtual_address);
  802107:	83 ec 08             	sub    $0x8,%esp
  80210a:	ff 75 08             	pushl  0x8(%ebp)
  80210d:	ff 75 f0             	pushl  -0x10(%ebp)
  802110:	e8 ef 02 00 00       	call   802404 <sys_freeSharedObject>
  802115:	83 c4 10             	add    $0x10,%esp
  802118:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (result == 0) {
  80211b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80211f:	75 0e                	jne    80212f <sfree+0x55>
		shardIDs[pageIdx] = -1;  // Reset the ID after freeing
  802121:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802124:	c7 04 85 40 50 88 00 	movl   $0xffffffff,0x885040(,%eax,4)
  80212b:	ff ff ff ff 
	}

}
  80212f:	90                   	nop
  802130:	c9                   	leave  
  802131:	c3                   	ret    

00802132 <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  802132:	55                   	push   %ebp
  802133:	89 e5                	mov    %esp,%ebp
  802135:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802138:	83 ec 04             	sub    $0x4,%esp
  80213b:	68 34 45 80 00       	push   $0x804534
  802140:	68 19 01 00 00       	push   $0x119
  802145:	68 26 45 80 00       	push   $0x804526
  80214a:	e8 2d e7 ff ff       	call   80087c <_panic>

0080214f <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  80214f:	55                   	push   %ebp
  802150:	89 e5                	mov    %esp,%ebp
  802152:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802155:	83 ec 04             	sub    $0x4,%esp
  802158:	68 5a 45 80 00       	push   $0x80455a
  80215d:	68 23 01 00 00       	push   $0x123
  802162:	68 26 45 80 00       	push   $0x804526
  802167:	e8 10 e7 ff ff       	call   80087c <_panic>

0080216c <shrink>:

}
void shrink(uint32 newSize) {
  80216c:	55                   	push   %ebp
  80216d:	89 e5                	mov    %esp,%ebp
  80216f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802172:	83 ec 04             	sub    $0x4,%esp
  802175:	68 5a 45 80 00       	push   $0x80455a
  80217a:	68 27 01 00 00       	push   $0x127
  80217f:	68 26 45 80 00       	push   $0x804526
  802184:	e8 f3 e6 ff ff       	call   80087c <_panic>

00802189 <freeHeap>:

}
void freeHeap(void* virtual_address) {
  802189:	55                   	push   %ebp
  80218a:	89 e5                	mov    %esp,%ebp
  80218c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80218f:	83 ec 04             	sub    $0x4,%esp
  802192:	68 5a 45 80 00       	push   $0x80455a
  802197:	68 2b 01 00 00       	push   $0x12b
  80219c:	68 26 45 80 00       	push   $0x804526
  8021a1:	e8 d6 e6 ff ff       	call   80087c <_panic>

008021a6 <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  8021a6:	55                   	push   %ebp
  8021a7:	89 e5                	mov    %esp,%ebp
  8021a9:	57                   	push   %edi
  8021aa:	56                   	push   %esi
  8021ab:	53                   	push   %ebx
  8021ac:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8021af:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021b5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021b8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021bb:	8b 7d 18             	mov    0x18(%ebp),%edi
  8021be:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8021c1:	cd 30                	int    $0x30
  8021c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  8021c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8021c9:	83 c4 10             	add    $0x10,%esp
  8021cc:	5b                   	pop    %ebx
  8021cd:	5e                   	pop    %esi
  8021ce:	5f                   	pop    %edi
  8021cf:	5d                   	pop    %ebp
  8021d0:	c3                   	ret    

008021d1 <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  8021d1:	55                   	push   %ebp
  8021d2:	89 e5                	mov    %esp,%ebp
  8021d4:	83 ec 04             	sub    $0x4,%esp
  8021d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8021da:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  8021dd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8021e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e4:	6a 00                	push   $0x0
  8021e6:	6a 00                	push   $0x0
  8021e8:	52                   	push   %edx
  8021e9:	ff 75 0c             	pushl  0xc(%ebp)
  8021ec:	50                   	push   %eax
  8021ed:	6a 00                	push   $0x0
  8021ef:	e8 b2 ff ff ff       	call   8021a6 <syscall>
  8021f4:	83 c4 18             	add    $0x18,%esp
}
  8021f7:	90                   	nop
  8021f8:	c9                   	leave  
  8021f9:	c3                   	ret    

008021fa <sys_cgetc>:

int sys_cgetc(void) {
  8021fa:	55                   	push   %ebp
  8021fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 00                	push   $0x0
  802201:	6a 00                	push   $0x0
  802203:	6a 00                	push   $0x0
  802205:	6a 00                	push   $0x0
  802207:	6a 02                	push   $0x2
  802209:	e8 98 ff ff ff       	call   8021a6 <syscall>
  80220e:	83 c4 18             	add    $0x18,%esp
}
  802211:	c9                   	leave  
  802212:	c3                   	ret    

00802213 <sys_lock_cons>:

void sys_lock_cons(void) {
  802213:	55                   	push   %ebp
  802214:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802216:	6a 00                	push   $0x0
  802218:	6a 00                	push   $0x0
  80221a:	6a 00                	push   $0x0
  80221c:	6a 00                	push   $0x0
  80221e:	6a 00                	push   $0x0
  802220:	6a 03                	push   $0x3
  802222:	e8 7f ff ff ff       	call   8021a6 <syscall>
  802227:	83 c4 18             	add    $0x18,%esp
}
  80222a:	90                   	nop
  80222b:	c9                   	leave  
  80222c:	c3                   	ret    

0080222d <sys_unlock_cons>:
void sys_unlock_cons(void) {
  80222d:	55                   	push   %ebp
  80222e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802230:	6a 00                	push   $0x0
  802232:	6a 00                	push   $0x0
  802234:	6a 00                	push   $0x0
  802236:	6a 00                	push   $0x0
  802238:	6a 00                	push   $0x0
  80223a:	6a 04                	push   $0x4
  80223c:	e8 65 ff ff ff       	call   8021a6 <syscall>
  802241:	83 c4 18             	add    $0x18,%esp
}
  802244:	90                   	nop
  802245:	c9                   	leave  
  802246:	c3                   	ret    

00802247 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  802247:	55                   	push   %ebp
  802248:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  80224a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80224d:	8b 45 08             	mov    0x8(%ebp),%eax
  802250:	6a 00                	push   $0x0
  802252:	6a 00                	push   $0x0
  802254:	6a 00                	push   $0x0
  802256:	52                   	push   %edx
  802257:	50                   	push   %eax
  802258:	6a 08                	push   $0x8
  80225a:	e8 47 ff ff ff       	call   8021a6 <syscall>
  80225f:	83 c4 18             	add    $0x18,%esp
}
  802262:	c9                   	leave  
  802263:	c3                   	ret    

00802264 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  802264:	55                   	push   %ebp
  802265:	89 e5                	mov    %esp,%ebp
  802267:	56                   	push   %esi
  802268:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  802269:	8b 75 18             	mov    0x18(%ebp),%esi
  80226c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80226f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802272:	8b 55 0c             	mov    0xc(%ebp),%edx
  802275:	8b 45 08             	mov    0x8(%ebp),%eax
  802278:	56                   	push   %esi
  802279:	53                   	push   %ebx
  80227a:	51                   	push   %ecx
  80227b:	52                   	push   %edx
  80227c:	50                   	push   %eax
  80227d:	6a 09                	push   $0x9
  80227f:	e8 22 ff ff ff       	call   8021a6 <syscall>
  802284:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  802287:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80228a:	5b                   	pop    %ebx
  80228b:	5e                   	pop    %esi
  80228c:	5d                   	pop    %ebp
  80228d:	c3                   	ret    

0080228e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  80228e:	55                   	push   %ebp
  80228f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802291:	8b 55 0c             	mov    0xc(%ebp),%edx
  802294:	8b 45 08             	mov    0x8(%ebp),%eax
  802297:	6a 00                	push   $0x0
  802299:	6a 00                	push   $0x0
  80229b:	6a 00                	push   $0x0
  80229d:	52                   	push   %edx
  80229e:	50                   	push   %eax
  80229f:	6a 0a                	push   $0xa
  8022a1:	e8 00 ff ff ff       	call   8021a6 <syscall>
  8022a6:	83 c4 18             	add    $0x18,%esp
}
  8022a9:	c9                   	leave  
  8022aa:	c3                   	ret    

008022ab <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  8022ab:	55                   	push   %ebp
  8022ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  8022ae:	6a 00                	push   $0x0
  8022b0:	6a 00                	push   $0x0
  8022b2:	6a 00                	push   $0x0
  8022b4:	ff 75 0c             	pushl  0xc(%ebp)
  8022b7:	ff 75 08             	pushl  0x8(%ebp)
  8022ba:	6a 0b                	push   $0xb
  8022bc:	e8 e5 fe ff ff       	call   8021a6 <syscall>
  8022c1:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  8022c4:	c9                   	leave  
  8022c5:	c3                   	ret    

008022c6 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  8022c6:	55                   	push   %ebp
  8022c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8022c9:	6a 00                	push   $0x0
  8022cb:	6a 00                	push   $0x0
  8022cd:	6a 00                	push   $0x0
  8022cf:	6a 00                	push   $0x0
  8022d1:	6a 00                	push   $0x0
  8022d3:	6a 0c                	push   $0xc
  8022d5:	e8 cc fe ff ff       	call   8021a6 <syscall>
  8022da:	83 c4 18             	add    $0x18,%esp
}
  8022dd:	c9                   	leave  
  8022de:	c3                   	ret    

008022df <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  8022df:	55                   	push   %ebp
  8022e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8022e2:	6a 00                	push   $0x0
  8022e4:	6a 00                	push   $0x0
  8022e6:	6a 00                	push   $0x0
  8022e8:	6a 00                	push   $0x0
  8022ea:	6a 00                	push   $0x0
  8022ec:	6a 0d                	push   $0xd
  8022ee:	e8 b3 fe ff ff       	call   8021a6 <syscall>
  8022f3:	83 c4 18             	add    $0x18,%esp
}
  8022f6:	c9                   	leave  
  8022f7:	c3                   	ret    

008022f8 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  8022f8:	55                   	push   %ebp
  8022f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8022fb:	6a 00                	push   $0x0
  8022fd:	6a 00                	push   $0x0
  8022ff:	6a 00                	push   $0x0
  802301:	6a 00                	push   $0x0
  802303:	6a 00                	push   $0x0
  802305:	6a 0e                	push   $0xe
  802307:	e8 9a fe ff ff       	call   8021a6 <syscall>
  80230c:	83 c4 18             	add    $0x18,%esp
}
  80230f:	c9                   	leave  
  802310:	c3                   	ret    

00802311 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  802311:	55                   	push   %ebp
  802312:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  802314:	6a 00                	push   $0x0
  802316:	6a 00                	push   $0x0
  802318:	6a 00                	push   $0x0
  80231a:	6a 00                	push   $0x0
  80231c:	6a 00                	push   $0x0
  80231e:	6a 0f                	push   $0xf
  802320:	e8 81 fe ff ff       	call   8021a6 <syscall>
  802325:	83 c4 18             	add    $0x18,%esp
}
  802328:	c9                   	leave  
  802329:	c3                   	ret    

0080232a <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  80232a:	55                   	push   %ebp
  80232b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  80232d:	6a 00                	push   $0x0
  80232f:	6a 00                	push   $0x0
  802331:	6a 00                	push   $0x0
  802333:	6a 00                	push   $0x0
  802335:	ff 75 08             	pushl  0x8(%ebp)
  802338:	6a 10                	push   $0x10
  80233a:	e8 67 fe ff ff       	call   8021a6 <syscall>
  80233f:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  802342:	c9                   	leave  
  802343:	c3                   	ret    

00802344 <sys_scarce_memory>:

void sys_scarce_memory() {
  802344:	55                   	push   %ebp
  802345:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  802347:	6a 00                	push   $0x0
  802349:	6a 00                	push   $0x0
  80234b:	6a 00                	push   $0x0
  80234d:	6a 00                	push   $0x0
  80234f:	6a 00                	push   $0x0
  802351:	6a 11                	push   $0x11
  802353:	e8 4e fe ff ff       	call   8021a6 <syscall>
  802358:	83 c4 18             	add    $0x18,%esp
}
  80235b:	90                   	nop
  80235c:	c9                   	leave  
  80235d:	c3                   	ret    

0080235e <sys_cputc>:

void sys_cputc(const char c) {
  80235e:	55                   	push   %ebp
  80235f:	89 e5                	mov    %esp,%ebp
  802361:	83 ec 04             	sub    $0x4,%esp
  802364:	8b 45 08             	mov    0x8(%ebp),%eax
  802367:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80236a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80236e:	6a 00                	push   $0x0
  802370:	6a 00                	push   $0x0
  802372:	6a 00                	push   $0x0
  802374:	6a 00                	push   $0x0
  802376:	50                   	push   %eax
  802377:	6a 01                	push   $0x1
  802379:	e8 28 fe ff ff       	call   8021a6 <syscall>
  80237e:	83 c4 18             	add    $0x18,%esp
}
  802381:	90                   	nop
  802382:	c9                   	leave  
  802383:	c3                   	ret    

00802384 <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  802384:	55                   	push   %ebp
  802385:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  802387:	6a 00                	push   $0x0
  802389:	6a 00                	push   $0x0
  80238b:	6a 00                	push   $0x0
  80238d:	6a 00                	push   $0x0
  80238f:	6a 00                	push   $0x0
  802391:	6a 14                	push   $0x14
  802393:	e8 0e fe ff ff       	call   8021a6 <syscall>
  802398:	83 c4 18             	add    $0x18,%esp
}
  80239b:	90                   	nop
  80239c:	c9                   	leave  
  80239d:	c3                   	ret    

0080239e <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  80239e:	55                   	push   %ebp
  80239f:	89 e5                	mov    %esp,%ebp
  8023a1:	83 ec 04             	sub    $0x4,%esp
  8023a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8023a7:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  8023aa:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8023ad:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8023b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b4:	6a 00                	push   $0x0
  8023b6:	51                   	push   %ecx
  8023b7:	52                   	push   %edx
  8023b8:	ff 75 0c             	pushl  0xc(%ebp)
  8023bb:	50                   	push   %eax
  8023bc:	6a 15                	push   $0x15
  8023be:	e8 e3 fd ff ff       	call   8021a6 <syscall>
  8023c3:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  8023c6:	c9                   	leave  
  8023c7:	c3                   	ret    

008023c8 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  8023c8:	55                   	push   %ebp
  8023c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  8023cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d1:	6a 00                	push   $0x0
  8023d3:	6a 00                	push   $0x0
  8023d5:	6a 00                	push   $0x0
  8023d7:	52                   	push   %edx
  8023d8:	50                   	push   %eax
  8023d9:	6a 16                	push   $0x16
  8023db:	e8 c6 fd ff ff       	call   8021a6 <syscall>
  8023e0:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  8023e3:	c9                   	leave  
  8023e4:	c3                   	ret    

008023e5 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  8023e5:	55                   	push   %ebp
  8023e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  8023e8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8023eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f1:	6a 00                	push   $0x0
  8023f3:	6a 00                	push   $0x0
  8023f5:	51                   	push   %ecx
  8023f6:	52                   	push   %edx
  8023f7:	50                   	push   %eax
  8023f8:	6a 17                	push   $0x17
  8023fa:	e8 a7 fd ff ff       	call   8021a6 <syscall>
  8023ff:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  802402:	c9                   	leave  
  802403:	c3                   	ret    

00802404 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  802404:	55                   	push   %ebp
  802405:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  802407:	8b 55 0c             	mov    0xc(%ebp),%edx
  80240a:	8b 45 08             	mov    0x8(%ebp),%eax
  80240d:	6a 00                	push   $0x0
  80240f:	6a 00                	push   $0x0
  802411:	6a 00                	push   $0x0
  802413:	52                   	push   %edx
  802414:	50                   	push   %eax
  802415:	6a 18                	push   $0x18
  802417:	e8 8a fd ff ff       	call   8021a6 <syscall>
  80241c:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  80241f:	c9                   	leave  
  802420:	c3                   	ret    

00802421 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  802421:	55                   	push   %ebp
  802422:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  802424:	8b 45 08             	mov    0x8(%ebp),%eax
  802427:	6a 00                	push   $0x0
  802429:	ff 75 14             	pushl  0x14(%ebp)
  80242c:	ff 75 10             	pushl  0x10(%ebp)
  80242f:	ff 75 0c             	pushl  0xc(%ebp)
  802432:	50                   	push   %eax
  802433:	6a 19                	push   $0x19
  802435:	e8 6c fd ff ff       	call   8021a6 <syscall>
  80243a:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  80243d:	c9                   	leave  
  80243e:	c3                   	ret    

0080243f <sys_run_env>:

void sys_run_env(int32 envId) {
  80243f:	55                   	push   %ebp
  802440:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  802442:	8b 45 08             	mov    0x8(%ebp),%eax
  802445:	6a 00                	push   $0x0
  802447:	6a 00                	push   $0x0
  802449:	6a 00                	push   $0x0
  80244b:	6a 00                	push   $0x0
  80244d:	50                   	push   %eax
  80244e:	6a 1a                	push   $0x1a
  802450:	e8 51 fd ff ff       	call   8021a6 <syscall>
  802455:	83 c4 18             	add    $0x18,%esp
}
  802458:	90                   	nop
  802459:	c9                   	leave  
  80245a:	c3                   	ret    

0080245b <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  80245b:	55                   	push   %ebp
  80245c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80245e:	8b 45 08             	mov    0x8(%ebp),%eax
  802461:	6a 00                	push   $0x0
  802463:	6a 00                	push   $0x0
  802465:	6a 00                	push   $0x0
  802467:	6a 00                	push   $0x0
  802469:	50                   	push   %eax
  80246a:	6a 1b                	push   $0x1b
  80246c:	e8 35 fd ff ff       	call   8021a6 <syscall>
  802471:	83 c4 18             	add    $0x18,%esp
}
  802474:	c9                   	leave  
  802475:	c3                   	ret    

00802476 <sys_getenvid>:

int32 sys_getenvid(void) {
  802476:	55                   	push   %ebp
  802477:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802479:	6a 00                	push   $0x0
  80247b:	6a 00                	push   $0x0
  80247d:	6a 00                	push   $0x0
  80247f:	6a 00                	push   $0x0
  802481:	6a 00                	push   $0x0
  802483:	6a 05                	push   $0x5
  802485:	e8 1c fd ff ff       	call   8021a6 <syscall>
  80248a:	83 c4 18             	add    $0x18,%esp
}
  80248d:	c9                   	leave  
  80248e:	c3                   	ret    

0080248f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  80248f:	55                   	push   %ebp
  802490:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802492:	6a 00                	push   $0x0
  802494:	6a 00                	push   $0x0
  802496:	6a 00                	push   $0x0
  802498:	6a 00                	push   $0x0
  80249a:	6a 00                	push   $0x0
  80249c:	6a 06                	push   $0x6
  80249e:	e8 03 fd ff ff       	call   8021a6 <syscall>
  8024a3:	83 c4 18             	add    $0x18,%esp
}
  8024a6:	c9                   	leave  
  8024a7:	c3                   	ret    

008024a8 <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  8024a8:	55                   	push   %ebp
  8024a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8024ab:	6a 00                	push   $0x0
  8024ad:	6a 00                	push   $0x0
  8024af:	6a 00                	push   $0x0
  8024b1:	6a 00                	push   $0x0
  8024b3:	6a 00                	push   $0x0
  8024b5:	6a 07                	push   $0x7
  8024b7:	e8 ea fc ff ff       	call   8021a6 <syscall>
  8024bc:	83 c4 18             	add    $0x18,%esp
}
  8024bf:	c9                   	leave  
  8024c0:	c3                   	ret    

008024c1 <sys_exit_env>:

void sys_exit_env(void) {
  8024c1:	55                   	push   %ebp
  8024c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8024c4:	6a 00                	push   $0x0
  8024c6:	6a 00                	push   $0x0
  8024c8:	6a 00                	push   $0x0
  8024ca:	6a 00                	push   $0x0
  8024cc:	6a 00                	push   $0x0
  8024ce:	6a 1c                	push   $0x1c
  8024d0:	e8 d1 fc ff ff       	call   8021a6 <syscall>
  8024d5:	83 c4 18             	add    $0x18,%esp
}
  8024d8:	90                   	nop
  8024d9:	c9                   	leave  
  8024da:	c3                   	ret    

008024db <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  8024db:	55                   	push   %ebp
  8024dc:	89 e5                	mov    %esp,%ebp
  8024de:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  8024e1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8024e4:	8d 50 04             	lea    0x4(%eax),%edx
  8024e7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8024ea:	6a 00                	push   $0x0
  8024ec:	6a 00                	push   $0x0
  8024ee:	6a 00                	push   $0x0
  8024f0:	52                   	push   %edx
  8024f1:	50                   	push   %eax
  8024f2:	6a 1d                	push   $0x1d
  8024f4:	e8 ad fc ff ff       	call   8021a6 <syscall>
  8024f9:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  8024fc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802502:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802505:	89 01                	mov    %eax,(%ecx)
  802507:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80250a:	8b 45 08             	mov    0x8(%ebp),%eax
  80250d:	c9                   	leave  
  80250e:	c2 04 00             	ret    $0x4

00802511 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  802511:	55                   	push   %ebp
  802512:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  802514:	6a 00                	push   $0x0
  802516:	6a 00                	push   $0x0
  802518:	ff 75 10             	pushl  0x10(%ebp)
  80251b:	ff 75 0c             	pushl  0xc(%ebp)
  80251e:	ff 75 08             	pushl  0x8(%ebp)
  802521:	6a 13                	push   $0x13
  802523:	e8 7e fc ff ff       	call   8021a6 <syscall>
  802528:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  80252b:	90                   	nop
}
  80252c:	c9                   	leave  
  80252d:	c3                   	ret    

0080252e <sys_rcr2>:
uint32 sys_rcr2() {
  80252e:	55                   	push   %ebp
  80252f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802531:	6a 00                	push   $0x0
  802533:	6a 00                	push   $0x0
  802535:	6a 00                	push   $0x0
  802537:	6a 00                	push   $0x0
  802539:	6a 00                	push   $0x0
  80253b:	6a 1e                	push   $0x1e
  80253d:	e8 64 fc ff ff       	call   8021a6 <syscall>
  802542:	83 c4 18             	add    $0x18,%esp
}
  802545:	c9                   	leave  
  802546:	c3                   	ret    

00802547 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  802547:	55                   	push   %ebp
  802548:	89 e5                	mov    %esp,%ebp
  80254a:	83 ec 04             	sub    $0x4,%esp
  80254d:	8b 45 08             	mov    0x8(%ebp),%eax
  802550:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802553:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802557:	6a 00                	push   $0x0
  802559:	6a 00                	push   $0x0
  80255b:	6a 00                	push   $0x0
  80255d:	6a 00                	push   $0x0
  80255f:	50                   	push   %eax
  802560:	6a 1f                	push   $0x1f
  802562:	e8 3f fc ff ff       	call   8021a6 <syscall>
  802567:	83 c4 18             	add    $0x18,%esp
	return;
  80256a:	90                   	nop
}
  80256b:	c9                   	leave  
  80256c:	c3                   	ret    

0080256d <rsttst>:
void rsttst() {
  80256d:	55                   	push   %ebp
  80256e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802570:	6a 00                	push   $0x0
  802572:	6a 00                	push   $0x0
  802574:	6a 00                	push   $0x0
  802576:	6a 00                	push   $0x0
  802578:	6a 00                	push   $0x0
  80257a:	6a 21                	push   $0x21
  80257c:	e8 25 fc ff ff       	call   8021a6 <syscall>
  802581:	83 c4 18             	add    $0x18,%esp
	return;
  802584:	90                   	nop
}
  802585:	c9                   	leave  
  802586:	c3                   	ret    

00802587 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  802587:	55                   	push   %ebp
  802588:	89 e5                	mov    %esp,%ebp
  80258a:	83 ec 04             	sub    $0x4,%esp
  80258d:	8b 45 14             	mov    0x14(%ebp),%eax
  802590:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802593:	8b 55 18             	mov    0x18(%ebp),%edx
  802596:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80259a:	52                   	push   %edx
  80259b:	50                   	push   %eax
  80259c:	ff 75 10             	pushl  0x10(%ebp)
  80259f:	ff 75 0c             	pushl  0xc(%ebp)
  8025a2:	ff 75 08             	pushl  0x8(%ebp)
  8025a5:	6a 20                	push   $0x20
  8025a7:	e8 fa fb ff ff       	call   8021a6 <syscall>
  8025ac:	83 c4 18             	add    $0x18,%esp
	return;
  8025af:	90                   	nop
}
  8025b0:	c9                   	leave  
  8025b1:	c3                   	ret    

008025b2 <chktst>:
void chktst(uint32 n) {
  8025b2:	55                   	push   %ebp
  8025b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8025b5:	6a 00                	push   $0x0
  8025b7:	6a 00                	push   $0x0
  8025b9:	6a 00                	push   $0x0
  8025bb:	6a 00                	push   $0x0
  8025bd:	ff 75 08             	pushl  0x8(%ebp)
  8025c0:	6a 22                	push   $0x22
  8025c2:	e8 df fb ff ff       	call   8021a6 <syscall>
  8025c7:	83 c4 18             	add    $0x18,%esp
	return;
  8025ca:	90                   	nop
}
  8025cb:	c9                   	leave  
  8025cc:	c3                   	ret    

008025cd <inctst>:

void inctst() {
  8025cd:	55                   	push   %ebp
  8025ce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8025d0:	6a 00                	push   $0x0
  8025d2:	6a 00                	push   $0x0
  8025d4:	6a 00                	push   $0x0
  8025d6:	6a 00                	push   $0x0
  8025d8:	6a 00                	push   $0x0
  8025da:	6a 23                	push   $0x23
  8025dc:	e8 c5 fb ff ff       	call   8021a6 <syscall>
  8025e1:	83 c4 18             	add    $0x18,%esp
	return;
  8025e4:	90                   	nop
}
  8025e5:	c9                   	leave  
  8025e6:	c3                   	ret    

008025e7 <gettst>:
uint32 gettst() {
  8025e7:	55                   	push   %ebp
  8025e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8025ea:	6a 00                	push   $0x0
  8025ec:	6a 00                	push   $0x0
  8025ee:	6a 00                	push   $0x0
  8025f0:	6a 00                	push   $0x0
  8025f2:	6a 00                	push   $0x0
  8025f4:	6a 24                	push   $0x24
  8025f6:	e8 ab fb ff ff       	call   8021a6 <syscall>
  8025fb:	83 c4 18             	add    $0x18,%esp
}
  8025fe:	c9                   	leave  
  8025ff:	c3                   	ret    

00802600 <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  802600:	55                   	push   %ebp
  802601:	89 e5                	mov    %esp,%ebp
  802603:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802606:	6a 00                	push   $0x0
  802608:	6a 00                	push   $0x0
  80260a:	6a 00                	push   $0x0
  80260c:	6a 00                	push   $0x0
  80260e:	6a 00                	push   $0x0
  802610:	6a 25                	push   $0x25
  802612:	e8 8f fb ff ff       	call   8021a6 <syscall>
  802617:	83 c4 18             	add    $0x18,%esp
  80261a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80261d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802621:	75 07                	jne    80262a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802623:	b8 01 00 00 00       	mov    $0x1,%eax
  802628:	eb 05                	jmp    80262f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80262a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80262f:	c9                   	leave  
  802630:	c3                   	ret    

00802631 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  802631:	55                   	push   %ebp
  802632:	89 e5                	mov    %esp,%ebp
  802634:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802637:	6a 00                	push   $0x0
  802639:	6a 00                	push   $0x0
  80263b:	6a 00                	push   $0x0
  80263d:	6a 00                	push   $0x0
  80263f:	6a 00                	push   $0x0
  802641:	6a 25                	push   $0x25
  802643:	e8 5e fb ff ff       	call   8021a6 <syscall>
  802648:	83 c4 18             	add    $0x18,%esp
  80264b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80264e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802652:	75 07                	jne    80265b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802654:	b8 01 00 00 00       	mov    $0x1,%eax
  802659:	eb 05                	jmp    802660 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80265b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802660:	c9                   	leave  
  802661:	c3                   	ret    

00802662 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  802662:	55                   	push   %ebp
  802663:	89 e5                	mov    %esp,%ebp
  802665:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802668:	6a 00                	push   $0x0
  80266a:	6a 00                	push   $0x0
  80266c:	6a 00                	push   $0x0
  80266e:	6a 00                	push   $0x0
  802670:	6a 00                	push   $0x0
  802672:	6a 25                	push   $0x25
  802674:	e8 2d fb ff ff       	call   8021a6 <syscall>
  802679:	83 c4 18             	add    $0x18,%esp
  80267c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80267f:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802683:	75 07                	jne    80268c <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802685:	b8 01 00 00 00       	mov    $0x1,%eax
  80268a:	eb 05                	jmp    802691 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80268c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802691:	c9                   	leave  
  802692:	c3                   	ret    

00802693 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  802693:	55                   	push   %ebp
  802694:	89 e5                	mov    %esp,%ebp
  802696:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802699:	6a 00                	push   $0x0
  80269b:	6a 00                	push   $0x0
  80269d:	6a 00                	push   $0x0
  80269f:	6a 00                	push   $0x0
  8026a1:	6a 00                	push   $0x0
  8026a3:	6a 25                	push   $0x25
  8026a5:	e8 fc fa ff ff       	call   8021a6 <syscall>
  8026aa:	83 c4 18             	add    $0x18,%esp
  8026ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8026b0:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8026b4:	75 07                	jne    8026bd <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8026b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8026bb:	eb 05                	jmp    8026c2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8026bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026c2:	c9                   	leave  
  8026c3:	c3                   	ret    

008026c4 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  8026c4:	55                   	push   %ebp
  8026c5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8026c7:	6a 00                	push   $0x0
  8026c9:	6a 00                	push   $0x0
  8026cb:	6a 00                	push   $0x0
  8026cd:	6a 00                	push   $0x0
  8026cf:	ff 75 08             	pushl  0x8(%ebp)
  8026d2:	6a 26                	push   $0x26
  8026d4:	e8 cd fa ff ff       	call   8021a6 <syscall>
  8026d9:	83 c4 18             	add    $0x18,%esp
	return;
  8026dc:	90                   	nop
}
  8026dd:	c9                   	leave  
  8026de:	c3                   	ret    

008026df <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  8026df:	55                   	push   %ebp
  8026e0:	89 e5                	mov    %esp,%ebp
  8026e2:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  8026e3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8026e6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8026e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ef:	6a 00                	push   $0x0
  8026f1:	53                   	push   %ebx
  8026f2:	51                   	push   %ecx
  8026f3:	52                   	push   %edx
  8026f4:	50                   	push   %eax
  8026f5:	6a 27                	push   $0x27
  8026f7:	e8 aa fa ff ff       	call   8021a6 <syscall>
  8026fc:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  8026ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802702:	c9                   	leave  
  802703:	c3                   	ret    

00802704 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  802704:	55                   	push   %ebp
  802705:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  802707:	8b 55 0c             	mov    0xc(%ebp),%edx
  80270a:	8b 45 08             	mov    0x8(%ebp),%eax
  80270d:	6a 00                	push   $0x0
  80270f:	6a 00                	push   $0x0
  802711:	6a 00                	push   $0x0
  802713:	52                   	push   %edx
  802714:	50                   	push   %eax
  802715:	6a 28                	push   $0x28
  802717:	e8 8a fa ff ff       	call   8021a6 <syscall>
  80271c:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  80271f:	c9                   	leave  
  802720:	c3                   	ret    

00802721 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  802721:	55                   	push   %ebp
  802722:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  802724:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802727:	8b 55 0c             	mov    0xc(%ebp),%edx
  80272a:	8b 45 08             	mov    0x8(%ebp),%eax
  80272d:	6a 00                	push   $0x0
  80272f:	51                   	push   %ecx
  802730:	ff 75 10             	pushl  0x10(%ebp)
  802733:	52                   	push   %edx
  802734:	50                   	push   %eax
  802735:	6a 29                	push   $0x29
  802737:	e8 6a fa ff ff       	call   8021a6 <syscall>
  80273c:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  80273f:	c9                   	leave  
  802740:	c3                   	ret    

00802741 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  802741:	55                   	push   %ebp
  802742:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802744:	6a 00                	push   $0x0
  802746:	6a 00                	push   $0x0
  802748:	ff 75 10             	pushl  0x10(%ebp)
  80274b:	ff 75 0c             	pushl  0xc(%ebp)
  80274e:	ff 75 08             	pushl  0x8(%ebp)
  802751:	6a 12                	push   $0x12
  802753:	e8 4e fa ff ff       	call   8021a6 <syscall>
  802758:	83 c4 18             	add    $0x18,%esp
	return;
  80275b:	90                   	nop
}
  80275c:	c9                   	leave  
  80275d:	c3                   	ret    

0080275e <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  80275e:	55                   	push   %ebp
  80275f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  802761:	8b 55 0c             	mov    0xc(%ebp),%edx
  802764:	8b 45 08             	mov    0x8(%ebp),%eax
  802767:	6a 00                	push   $0x0
  802769:	6a 00                	push   $0x0
  80276b:	6a 00                	push   $0x0
  80276d:	52                   	push   %edx
  80276e:	50                   	push   %eax
  80276f:	6a 2a                	push   $0x2a
  802771:	e8 30 fa ff ff       	call   8021a6 <syscall>
  802776:	83 c4 18             	add    $0x18,%esp
	return;
  802779:	90                   	nop
}
  80277a:	c9                   	leave  
  80277b:	c3                   	ret    

0080277c <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  80277c:	55                   	push   %ebp
  80277d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  80277f:	8b 45 08             	mov    0x8(%ebp),%eax
  802782:	6a 00                	push   $0x0
  802784:	6a 00                	push   $0x0
  802786:	6a 00                	push   $0x0
  802788:	6a 00                	push   $0x0
  80278a:	50                   	push   %eax
  80278b:	6a 2b                	push   $0x2b
  80278d:	e8 14 fa ff ff       	call   8021a6 <syscall>
  802792:	83 c4 18             	add    $0x18,%esp
}
  802795:	c9                   	leave  
  802796:	c3                   	ret    

00802797 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  802797:	55                   	push   %ebp
  802798:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80279a:	6a 00                	push   $0x0
  80279c:	6a 00                	push   $0x0
  80279e:	6a 00                	push   $0x0
  8027a0:	ff 75 0c             	pushl  0xc(%ebp)
  8027a3:	ff 75 08             	pushl  0x8(%ebp)
  8027a6:	6a 2c                	push   $0x2c
  8027a8:	e8 f9 f9 ff ff       	call   8021a6 <syscall>
  8027ad:	83 c4 18             	add    $0x18,%esp
	return;
  8027b0:	90                   	nop
}
  8027b1:	c9                   	leave  
  8027b2:	c3                   	ret    

008027b3 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  8027b3:	55                   	push   %ebp
  8027b4:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8027b6:	6a 00                	push   $0x0
  8027b8:	6a 00                	push   $0x0
  8027ba:	6a 00                	push   $0x0
  8027bc:	ff 75 0c             	pushl  0xc(%ebp)
  8027bf:	ff 75 08             	pushl  0x8(%ebp)
  8027c2:	6a 2d                	push   $0x2d
  8027c4:	e8 dd f9 ff ff       	call   8021a6 <syscall>
  8027c9:	83 c4 18             	add    $0x18,%esp
	return;
  8027cc:	90                   	nop
}
  8027cd:	c9                   	leave  
  8027ce:	c3                   	ret    

008027cf <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  8027cf:	55                   	push   %ebp
  8027d0:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  8027d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d5:	6a 00                	push   $0x0
  8027d7:	6a 00                	push   $0x0
  8027d9:	6a 00                	push   $0x0
  8027db:	6a 00                	push   $0x0
  8027dd:	50                   	push   %eax
  8027de:	6a 2f                	push   $0x2f
  8027e0:	e8 c1 f9 ff ff       	call   8021a6 <syscall>
  8027e5:	83 c4 18             	add    $0x18,%esp
	return;
  8027e8:	90                   	nop
}
  8027e9:	c9                   	leave  
  8027ea:	c3                   	ret    

008027eb <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  8027eb:	55                   	push   %ebp
  8027ec:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  8027ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f4:	6a 00                	push   $0x0
  8027f6:	6a 00                	push   $0x0
  8027f8:	6a 00                	push   $0x0
  8027fa:	52                   	push   %edx
  8027fb:	50                   	push   %eax
  8027fc:	6a 30                	push   $0x30
  8027fe:	e8 a3 f9 ff ff       	call   8021a6 <syscall>
  802803:	83 c4 18             	add    $0x18,%esp
	return;
  802806:	90                   	nop
}
  802807:	c9                   	leave  
  802808:	c3                   	ret    

00802809 <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  802809:	55                   	push   %ebp
  80280a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  80280c:	8b 45 08             	mov    0x8(%ebp),%eax
  80280f:	6a 00                	push   $0x0
  802811:	6a 00                	push   $0x0
  802813:	6a 00                	push   $0x0
  802815:	6a 00                	push   $0x0
  802817:	50                   	push   %eax
  802818:	6a 31                	push   $0x31
  80281a:	e8 87 f9 ff ff       	call   8021a6 <syscall>
  80281f:	83 c4 18             	add    $0x18,%esp
	return;
  802822:	90                   	nop
}
  802823:	c9                   	leave  
  802824:	c3                   	ret    

00802825 <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  802825:	55                   	push   %ebp
  802826:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  802828:	8b 55 0c             	mov    0xc(%ebp),%edx
  80282b:	8b 45 08             	mov    0x8(%ebp),%eax
  80282e:	6a 00                	push   $0x0
  802830:	6a 00                	push   $0x0
  802832:	6a 00                	push   $0x0
  802834:	52                   	push   %edx
  802835:	50                   	push   %eax
  802836:	6a 2e                	push   $0x2e
  802838:	e8 69 f9 ff ff       	call   8021a6 <syscall>
  80283d:	83 c4 18             	add    $0x18,%esp
    return;
  802840:	90                   	nop
}
  802841:	c9                   	leave  
  802842:	c3                   	ret    

00802843 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802843:	55                   	push   %ebp
  802844:	89 e5                	mov    %esp,%ebp
  802846:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802849:	8b 45 08             	mov    0x8(%ebp),%eax
  80284c:	83 e8 04             	sub    $0x4,%eax
  80284f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802852:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802855:	8b 00                	mov    (%eax),%eax
  802857:	83 e0 fe             	and    $0xfffffffe,%eax
}
  80285a:	c9                   	leave  
  80285b:	c3                   	ret    

0080285c <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  80285c:	55                   	push   %ebp
  80285d:	89 e5                	mov    %esp,%ebp
  80285f:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802862:	8b 45 08             	mov    0x8(%ebp),%eax
  802865:	83 e8 04             	sub    $0x4,%eax
  802868:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  80286b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80286e:	8b 00                	mov    (%eax),%eax
  802870:	83 e0 01             	and    $0x1,%eax
  802873:	85 c0                	test   %eax,%eax
  802875:	0f 94 c0             	sete   %al
}
  802878:	c9                   	leave  
  802879:	c3                   	ret    

0080287a <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  80287a:	55                   	push   %ebp
  80287b:	89 e5                	mov    %esp,%ebp
  80287d:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802880:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802887:	8b 45 0c             	mov    0xc(%ebp),%eax
  80288a:	83 f8 02             	cmp    $0x2,%eax
  80288d:	74 2b                	je     8028ba <alloc_block+0x40>
  80288f:	83 f8 02             	cmp    $0x2,%eax
  802892:	7f 07                	jg     80289b <alloc_block+0x21>
  802894:	83 f8 01             	cmp    $0x1,%eax
  802897:	74 0e                	je     8028a7 <alloc_block+0x2d>
  802899:	eb 58                	jmp    8028f3 <alloc_block+0x79>
  80289b:	83 f8 03             	cmp    $0x3,%eax
  80289e:	74 2d                	je     8028cd <alloc_block+0x53>
  8028a0:	83 f8 04             	cmp    $0x4,%eax
  8028a3:	74 3b                	je     8028e0 <alloc_block+0x66>
  8028a5:	eb 4c                	jmp    8028f3 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8028a7:	83 ec 0c             	sub    $0xc,%esp
  8028aa:	ff 75 08             	pushl  0x8(%ebp)
  8028ad:	e8 f7 03 00 00       	call   802ca9 <alloc_block_FF>
  8028b2:	83 c4 10             	add    $0x10,%esp
  8028b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8028b8:	eb 4a                	jmp    802904 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8028ba:	83 ec 0c             	sub    $0xc,%esp
  8028bd:	ff 75 08             	pushl  0x8(%ebp)
  8028c0:	e8 f0 11 00 00       	call   803ab5 <alloc_block_NF>
  8028c5:	83 c4 10             	add    $0x10,%esp
  8028c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8028cb:	eb 37                	jmp    802904 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8028cd:	83 ec 0c             	sub    $0xc,%esp
  8028d0:	ff 75 08             	pushl  0x8(%ebp)
  8028d3:	e8 08 08 00 00       	call   8030e0 <alloc_block_BF>
  8028d8:	83 c4 10             	add    $0x10,%esp
  8028db:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8028de:	eb 24                	jmp    802904 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8028e0:	83 ec 0c             	sub    $0xc,%esp
  8028e3:	ff 75 08             	pushl  0x8(%ebp)
  8028e6:	e8 ad 11 00 00       	call   803a98 <alloc_block_WF>
  8028eb:	83 c4 10             	add    $0x10,%esp
  8028ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8028f1:	eb 11                	jmp    802904 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8028f3:	83 ec 0c             	sub    $0xc,%esp
  8028f6:	68 6c 45 80 00       	push   $0x80456c
  8028fb:	e8 39 e2 ff ff       	call   800b39 <cprintf>
  802900:	83 c4 10             	add    $0x10,%esp
		break;
  802903:	90                   	nop
	}
	return va;
  802904:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802907:	c9                   	leave  
  802908:	c3                   	ret    

00802909 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802909:	55                   	push   %ebp
  80290a:	89 e5                	mov    %esp,%ebp
  80290c:	53                   	push   %ebx
  80290d:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802910:	83 ec 0c             	sub    $0xc,%esp
  802913:	68 8c 45 80 00       	push   $0x80458c
  802918:	e8 1c e2 ff ff       	call   800b39 <cprintf>
  80291d:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802920:	83 ec 0c             	sub    $0xc,%esp
  802923:	68 b7 45 80 00       	push   $0x8045b7
  802928:	e8 0c e2 ff ff       	call   800b39 <cprintf>
  80292d:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802930:	8b 45 08             	mov    0x8(%ebp),%eax
  802933:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802936:	eb 37                	jmp    80296f <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802938:	83 ec 0c             	sub    $0xc,%esp
  80293b:	ff 75 f4             	pushl  -0xc(%ebp)
  80293e:	e8 19 ff ff ff       	call   80285c <is_free_block>
  802943:	83 c4 10             	add    $0x10,%esp
  802946:	0f be d8             	movsbl %al,%ebx
  802949:	83 ec 0c             	sub    $0xc,%esp
  80294c:	ff 75 f4             	pushl  -0xc(%ebp)
  80294f:	e8 ef fe ff ff       	call   802843 <get_block_size>
  802954:	83 c4 10             	add    $0x10,%esp
  802957:	83 ec 04             	sub    $0x4,%esp
  80295a:	53                   	push   %ebx
  80295b:	50                   	push   %eax
  80295c:	68 cf 45 80 00       	push   $0x8045cf
  802961:	e8 d3 e1 ff ff       	call   800b39 <cprintf>
  802966:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802969:	8b 45 10             	mov    0x10(%ebp),%eax
  80296c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80296f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802973:	74 07                	je     80297c <print_blocks_list+0x73>
  802975:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802978:	8b 00                	mov    (%eax),%eax
  80297a:	eb 05                	jmp    802981 <print_blocks_list+0x78>
  80297c:	b8 00 00 00 00       	mov    $0x0,%eax
  802981:	89 45 10             	mov    %eax,0x10(%ebp)
  802984:	8b 45 10             	mov    0x10(%ebp),%eax
  802987:	85 c0                	test   %eax,%eax
  802989:	75 ad                	jne    802938 <print_blocks_list+0x2f>
  80298b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80298f:	75 a7                	jne    802938 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802991:	83 ec 0c             	sub    $0xc,%esp
  802994:	68 8c 45 80 00       	push   $0x80458c
  802999:	e8 9b e1 ff ff       	call   800b39 <cprintf>
  80299e:	83 c4 10             	add    $0x10,%esp

}
  8029a1:	90                   	nop
  8029a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8029a5:	c9                   	leave  
  8029a6:	c3                   	ret    

008029a7 <initialize_dynamic_allocator>:

//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8029a7:	55                   	push   %ebp
  8029a8:	89 e5                	mov    %esp,%ebp
  8029aa:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8029ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029b0:	83 e0 01             	and    $0x1,%eax
  8029b3:	85 c0                	test   %eax,%eax
  8029b5:	74 03                	je     8029ba <initialize_dynamic_allocator+0x13>
  8029b7:	ff 45 0c             	incl   0xc(%ebp)
		if (initSizeOfAllocatedSpace == 0)
  8029ba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8029be:	0f 84 f8 00 00 00    	je     802abc <initialize_dynamic_allocator+0x115>
			return ;
		is_initialized = 1;
  8029c4:	c7 05 40 50 98 00 01 	movl   $0x1,0x985040
  8029cb:	00 00 00 
	//TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("initialize_dynamic_allocator is not implemented yet");
	//Your Code is Here...

	if(is_initialized){
  8029ce:	a1 40 50 98 00       	mov    0x985040,%eax
  8029d3:	85 c0                	test   %eax,%eax
  8029d5:	0f 84 e2 00 00 00    	je     802abd <initialize_dynamic_allocator+0x116>

		// begin block with size 0 and lsb = 1 (allocated)
		uint32* beginBlock = (uint32*)daStart;
  8029db:	8b 45 08             	mov    0x8(%ebp),%eax
  8029de:	89 45 f4             	mov    %eax,-0xc(%ebp)
		*beginBlock = 0 | 1; // size = 0, LSB as a flag = 1
  8029e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		// end block with size 0 and lsb = 1 (allocated)
		uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);
  8029ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8029ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029f0:	01 d0                	add    %edx,%eax
  8029f2:	83 e8 04             	sub    $0x4,%eax
  8029f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		*endBlock = 0 | 1; // size = 0, LSB as a flag = 1
  8029f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029fb:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

		// the block that between begin and end blocks
		struct BlockElement* block = (struct BlockElement*)(daStart + 8);
  802a01:	8b 45 08             	mov    0x8(%ebp),%eax
  802a04:	83 c0 08             	add    $0x8,%eax
  802a07:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 blockSize = initSizeOfAllocatedSpace - 8; // subtract size of begin and end blocks
  802a0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a0d:	83 e8 08             	sub    $0x8,%eax
  802a10:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(block,blockSize,0);
  802a13:	83 ec 04             	sub    $0x4,%esp
  802a16:	6a 00                	push   $0x0
  802a18:	ff 75 e8             	pushl  -0x18(%ebp)
  802a1b:	ff 75 ec             	pushl  -0x14(%ebp)
  802a1e:	e8 9c 00 00 00       	call   802abf <set_block_data>
  802a23:	83 c4 10             	add    $0x10,%esp

		block->prev_next_info.le_next = NULL;
  802a26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a29:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block->prev_next_info.le_prev = NULL;
  802a2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a32:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

		LIST_INIT(&freeBlocksList);
  802a39:	c7 05 48 50 98 00 00 	movl   $0x0,0x985048
  802a40:	00 00 00 
  802a43:	c7 05 4c 50 98 00 00 	movl   $0x0,0x98504c
  802a4a:	00 00 00 
  802a4d:	c7 05 54 50 98 00 00 	movl   $0x0,0x985054
  802a54:	00 00 00 
		LIST_INSERT_HEAD(&freeBlocksList, block);
  802a57:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a5b:	75 17                	jne    802a74 <initialize_dynamic_allocator+0xcd>
  802a5d:	83 ec 04             	sub    $0x4,%esp
  802a60:	68 e8 45 80 00       	push   $0x8045e8
  802a65:	68 80 00 00 00       	push   $0x80
  802a6a:	68 0b 46 80 00       	push   $0x80460b
  802a6f:	e8 08 de ff ff       	call   80087c <_panic>
  802a74:	8b 15 48 50 98 00    	mov    0x985048,%edx
  802a7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a7d:	89 10                	mov    %edx,(%eax)
  802a7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a82:	8b 00                	mov    (%eax),%eax
  802a84:	85 c0                	test   %eax,%eax
  802a86:	74 0d                	je     802a95 <initialize_dynamic_allocator+0xee>
  802a88:	a1 48 50 98 00       	mov    0x985048,%eax
  802a8d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a90:	89 50 04             	mov    %edx,0x4(%eax)
  802a93:	eb 08                	jmp    802a9d <initialize_dynamic_allocator+0xf6>
  802a95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a98:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802a9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aa0:	a3 48 50 98 00       	mov    %eax,0x985048
  802aa5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aa8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aaf:	a1 54 50 98 00       	mov    0x985054,%eax
  802ab4:	40                   	inc    %eax
  802ab5:	a3 54 50 98 00       	mov    %eax,0x985054
  802aba:	eb 01                	jmp    802abd <initialize_dynamic_allocator+0x116>
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
		if (initSizeOfAllocatedSpace == 0)
			return ;
  802abc:	90                   	nop
		block->prev_next_info.le_prev = NULL;

		LIST_INIT(&freeBlocksList);
		LIST_INSERT_HEAD(&freeBlocksList, block);
	}
}
  802abd:	c9                   	leave  
  802abe:	c3                   	ret    

00802abf <set_block_data>:
//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802abf:	55                   	push   %ebp
  802ac0:	89 e5                	mov    %esp,%ebp
  802ac2:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("set_block_data is not implemented yet");
	//Your Code is Here...

	if(totalSize % 2 != 0)
  802ac5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ac8:	83 e0 01             	and    $0x1,%eax
  802acb:	85 c0                	test   %eax,%eax
  802acd:	74 03                	je     802ad2 <set_block_data+0x13>
	{
		totalSize++;
  802acf:	ff 45 0c             	incl   0xc(%ebp)
	}

	uint32* header = (uint32 *)((uint32*)va-1);
  802ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad5:	83 e8 04             	sub    $0x4,%eax
  802ad8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//	size => totalSize with LSB = 0		 set LSB = 1 if isAllocated
	*header = (totalSize & ~1) | (isAllocated & 1);
  802adb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ade:	83 e0 fe             	and    $0xfffffffe,%eax
  802ae1:	89 c2                	mov    %eax,%edx
  802ae3:	8b 45 10             	mov    0x10(%ebp),%eax
  802ae6:	83 e0 01             	and    $0x1,%eax
  802ae9:	09 c2                	or     %eax,%edx
  802aeb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802aee:	89 10                	mov    %edx,(%eax)
	uint32* footer = (uint32*) (va + totalSize - 8);
  802af0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802af3:	8d 50 f8             	lea    -0x8(%eax),%edx
  802af6:	8b 45 08             	mov    0x8(%ebp),%eax
  802af9:	01 d0                	add    %edx,%eax
  802afb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	*footer = (totalSize & ~1) | (isAllocated & 1);
  802afe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b01:	83 e0 fe             	and    $0xfffffffe,%eax
  802b04:	89 c2                	mov    %eax,%edx
  802b06:	8b 45 10             	mov    0x10(%ebp),%eax
  802b09:	83 e0 01             	and    $0x1,%eax
  802b0c:	09 c2                	or     %eax,%edx
  802b0e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802b11:	89 10                	mov    %edx,(%eax)
}
  802b13:	90                   	nop
  802b14:	c9                   	leave  
  802b15:	c3                   	ret    

00802b16 <insert_sorted_in_freeList>:
//=========================================
void insert_sorted_in_freeList(struct BlockElement *newBlock)
{
  802b16:	55                   	push   %ebp
  802b17:	89 e5                	mov    %esp,%ebp
  802b19:	83 ec 18             	sub    $0x18,%esp
	if(LIST_EMPTY(&freeBlocksList))
  802b1c:	a1 48 50 98 00       	mov    0x985048,%eax
  802b21:	85 c0                	test   %eax,%eax
  802b23:	75 68                	jne    802b8d <insert_sorted_in_freeList+0x77>
	{
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
  802b25:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b29:	75 17                	jne    802b42 <insert_sorted_in_freeList+0x2c>
  802b2b:	83 ec 04             	sub    $0x4,%esp
  802b2e:	68 e8 45 80 00       	push   $0x8045e8
  802b33:	68 9d 00 00 00       	push   $0x9d
  802b38:	68 0b 46 80 00       	push   $0x80460b
  802b3d:	e8 3a dd ff ff       	call   80087c <_panic>
  802b42:	8b 15 48 50 98 00    	mov    0x985048,%edx
  802b48:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4b:	89 10                	mov    %edx,(%eax)
  802b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b50:	8b 00                	mov    (%eax),%eax
  802b52:	85 c0                	test   %eax,%eax
  802b54:	74 0d                	je     802b63 <insert_sorted_in_freeList+0x4d>
  802b56:	a1 48 50 98 00       	mov    0x985048,%eax
  802b5b:	8b 55 08             	mov    0x8(%ebp),%edx
  802b5e:	89 50 04             	mov    %edx,0x4(%eax)
  802b61:	eb 08                	jmp    802b6b <insert_sorted_in_freeList+0x55>
  802b63:	8b 45 08             	mov    0x8(%ebp),%eax
  802b66:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6e:	a3 48 50 98 00       	mov    %eax,0x985048
  802b73:	8b 45 08             	mov    0x8(%ebp),%eax
  802b76:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b7d:	a1 54 50 98 00       	mov    0x985054,%eax
  802b82:	40                   	inc    %eax
  802b83:	a3 54 50 98 00       	mov    %eax,0x985054
		return;
  802b88:	e9 1a 01 00 00       	jmp    802ca7 <insert_sorted_in_freeList+0x191>
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  802b8d:	a1 48 50 98 00       	mov    0x985048,%eax
  802b92:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b95:	eb 7f                	jmp    802c16 <insert_sorted_in_freeList+0x100>
	{
		if(blk > newBlock) // if address of blk > address of newBlock => add newBlock before blk
  802b97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b9d:	76 6f                	jbe    802c0e <insert_sorted_in_freeList+0xf8>
		{
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
  802b9f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ba3:	74 06                	je     802bab <insert_sorted_in_freeList+0x95>
  802ba5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ba9:	75 17                	jne    802bc2 <insert_sorted_in_freeList+0xac>
  802bab:	83 ec 04             	sub    $0x4,%esp
  802bae:	68 24 46 80 00       	push   $0x804624
  802bb3:	68 a6 00 00 00       	push   $0xa6
  802bb8:	68 0b 46 80 00       	push   $0x80460b
  802bbd:	e8 ba dc ff ff       	call   80087c <_panic>
  802bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc5:	8b 50 04             	mov    0x4(%eax),%edx
  802bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcb:	89 50 04             	mov    %edx,0x4(%eax)
  802bce:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bd4:	89 10                	mov    %edx,(%eax)
  802bd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd9:	8b 40 04             	mov    0x4(%eax),%eax
  802bdc:	85 c0                	test   %eax,%eax
  802bde:	74 0d                	je     802bed <insert_sorted_in_freeList+0xd7>
  802be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be3:	8b 40 04             	mov    0x4(%eax),%eax
  802be6:	8b 55 08             	mov    0x8(%ebp),%edx
  802be9:	89 10                	mov    %edx,(%eax)
  802beb:	eb 08                	jmp    802bf5 <insert_sorted_in_freeList+0xdf>
  802bed:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf0:	a3 48 50 98 00       	mov    %eax,0x985048
  802bf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf8:	8b 55 08             	mov    0x8(%ebp),%edx
  802bfb:	89 50 04             	mov    %edx,0x4(%eax)
  802bfe:	a1 54 50 98 00       	mov    0x985054,%eax
  802c03:	40                   	inc    %eax
  802c04:	a3 54 50 98 00       	mov    %eax,0x985054
			return;
  802c09:	e9 99 00 00 00       	jmp    802ca7 <insert_sorted_in_freeList+0x191>
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
		return;
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  802c0e:	a1 50 50 98 00       	mov    0x985050,%eax
  802c13:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c16:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c1a:	74 07                	je     802c23 <insert_sorted_in_freeList+0x10d>
  802c1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1f:	8b 00                	mov    (%eax),%eax
  802c21:	eb 05                	jmp    802c28 <insert_sorted_in_freeList+0x112>
  802c23:	b8 00 00 00 00       	mov    $0x0,%eax
  802c28:	a3 50 50 98 00       	mov    %eax,0x985050
  802c2d:	a1 50 50 98 00       	mov    0x985050,%eax
  802c32:	85 c0                	test   %eax,%eax
  802c34:	0f 85 5d ff ff ff    	jne    802b97 <insert_sorted_in_freeList+0x81>
  802c3a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c3e:	0f 85 53 ff ff ff    	jne    802b97 <insert_sorted_in_freeList+0x81>
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
			return;
		}
	}
	// if no blk its address > newBlock
	LIST_INSERT_TAIL(&freeBlocksList, newBlock);
  802c44:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c48:	75 17                	jne    802c61 <insert_sorted_in_freeList+0x14b>
  802c4a:	83 ec 04             	sub    $0x4,%esp
  802c4d:	68 5c 46 80 00       	push   $0x80465c
  802c52:	68 ab 00 00 00       	push   $0xab
  802c57:	68 0b 46 80 00       	push   $0x80460b
  802c5c:	e8 1b dc ff ff       	call   80087c <_panic>
  802c61:	8b 15 4c 50 98 00    	mov    0x98504c,%edx
  802c67:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6a:	89 50 04             	mov    %edx,0x4(%eax)
  802c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c70:	8b 40 04             	mov    0x4(%eax),%eax
  802c73:	85 c0                	test   %eax,%eax
  802c75:	74 0c                	je     802c83 <insert_sorted_in_freeList+0x16d>
  802c77:	a1 4c 50 98 00       	mov    0x98504c,%eax
  802c7c:	8b 55 08             	mov    0x8(%ebp),%edx
  802c7f:	89 10                	mov    %edx,(%eax)
  802c81:	eb 08                	jmp    802c8b <insert_sorted_in_freeList+0x175>
  802c83:	8b 45 08             	mov    0x8(%ebp),%eax
  802c86:	a3 48 50 98 00       	mov    %eax,0x985048
  802c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8e:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802c93:	8b 45 08             	mov    0x8(%ebp),%eax
  802c96:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c9c:	a1 54 50 98 00       	mov    0x985054,%eax
  802ca1:	40                   	inc    %eax
  802ca2:	a3 54 50 98 00       	mov    %eax,0x985054
}
  802ca7:	c9                   	leave  
  802ca8:	c3                   	ret    

00802ca9 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  802ca9:	55                   	push   %ebp
  802caa:	89 e5                	mov    %esp,%ebp
  802cac:	83 ec 78             	sub    $0x78,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802caf:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb2:	83 e0 01             	and    $0x1,%eax
  802cb5:	85 c0                	test   %eax,%eax
  802cb7:	74 03                	je     802cbc <alloc_block_FF+0x13>
  802cb9:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802cbc:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802cc0:	77 07                	ja     802cc9 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802cc2:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802cc9:	a1 40 50 98 00       	mov    0x985040,%eax
  802cce:	85 c0                	test   %eax,%eax
  802cd0:	75 63                	jne    802d35 <alloc_block_FF+0x8c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd5:	83 c0 10             	add    $0x10,%eax
  802cd8:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802cdb:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802ce2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ce5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ce8:	01 d0                	add    %edx,%eax
  802cea:	48                   	dec    %eax
  802ceb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802cee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cf1:	ba 00 00 00 00       	mov    $0x0,%edx
  802cf6:	f7 75 ec             	divl   -0x14(%ebp)
  802cf9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cfc:	29 d0                	sub    %edx,%eax
  802cfe:	c1 e8 0c             	shr    $0xc,%eax
  802d01:	83 ec 0c             	sub    $0xc,%esp
  802d04:	50                   	push   %eax
  802d05:	e8 d1 ed ff ff       	call   801adb <sbrk>
  802d0a:	83 c4 10             	add    $0x10,%esp
  802d0d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802d10:	83 ec 0c             	sub    $0xc,%esp
  802d13:	6a 00                	push   $0x0
  802d15:	e8 c1 ed ff ff       	call   801adb <sbrk>
  802d1a:	83 c4 10             	add    $0x10,%esp
  802d1d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802d20:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d23:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802d26:	83 ec 08             	sub    $0x8,%esp
  802d29:	50                   	push   %eax
  802d2a:	ff 75 e4             	pushl  -0x1c(%ebp)
  802d2d:	e8 75 fc ff ff       	call   8029a7 <initialize_dynamic_allocator>
  802d32:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(size == 0)
  802d35:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d39:	75 0a                	jne    802d45 <alloc_block_FF+0x9c>
	{
		return NULL;
  802d3b:	b8 00 00 00 00       	mov    $0x0,%eax
  802d40:	e9 99 03 00 00       	jmp    8030de <alloc_block_FF+0x435>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  802d45:	8b 45 08             	mov    0x8(%ebp),%eax
  802d48:	83 c0 08             	add    $0x8,%eax
  802d4b:	89 45 dc             	mov    %eax,-0x24(%ebp)

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802d4e:	a1 48 50 98 00       	mov    0x985048,%eax
  802d53:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d56:	e9 03 02 00 00       	jmp    802f5e <alloc_block_FF+0x2b5>
	{
		uint32 blockSize = get_block_size(block); // Get size without the (LSB) allocation flag
  802d5b:	83 ec 0c             	sub    $0xc,%esp
  802d5e:	ff 75 f4             	pushl  -0xc(%ebp)
  802d61:	e8 dd fa ff ff       	call   802843 <get_block_size>
  802d66:	83 c4 10             	add    $0x10,%esp
  802d69:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if(blockSize >= totalSize)
  802d6c:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802d6f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802d72:	0f 82 de 01 00 00    	jb     802f56 <alloc_block_FF+0x2ad>
		{	//if we can put another block with min size 16
			if(blockSize >= totalSize + 4*sizeof(uint32))
  802d78:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d7b:	83 c0 10             	add    $0x10,%eax
  802d7e:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  802d81:	0f 87 32 01 00 00    	ja     802eb9 <alloc_block_FF+0x210>
			{
				// the size that will remain from the block that we will allocate a new block in it
				uint32 remainingSize = blockSize - totalSize;
  802d87:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802d8a:	2b 45 dc             	sub    -0x24(%ebp),%eax
  802d8d:	89 45 98             	mov    %eax,-0x68(%ebp)

				// the remaining free space from the block that we use to allocate in it
				struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)block + totalSize);
  802d90:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d93:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d96:	01 d0                	add    %edx,%eax
  802d98:	89 45 94             	mov    %eax,-0x6c(%ebp)
				set_block_data(remainingFreeBlock, remainingSize, 0);
  802d9b:	83 ec 04             	sub    $0x4,%esp
  802d9e:	6a 00                	push   $0x0
  802da0:	ff 75 98             	pushl  -0x68(%ebp)
  802da3:	ff 75 94             	pushl  -0x6c(%ebp)
  802da6:	e8 14 fd ff ff       	call   802abf <set_block_data>
  802dab:	83 c4 10             	add    $0x10,%esp
				// add it after the block we allocated to be sorted by addresses
				LIST_INSERT_AFTER(&freeBlocksList, block,remainingFreeBlock);
  802dae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802db2:	74 06                	je     802dba <alloc_block_FF+0x111>
  802db4:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
  802db8:	75 17                	jne    802dd1 <alloc_block_FF+0x128>
  802dba:	83 ec 04             	sub    $0x4,%esp
  802dbd:	68 80 46 80 00       	push   $0x804680
  802dc2:	68 de 00 00 00       	push   $0xde
  802dc7:	68 0b 46 80 00       	push   $0x80460b
  802dcc:	e8 ab da ff ff       	call   80087c <_panic>
  802dd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd4:	8b 10                	mov    (%eax),%edx
  802dd6:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802dd9:	89 10                	mov    %edx,(%eax)
  802ddb:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802dde:	8b 00                	mov    (%eax),%eax
  802de0:	85 c0                	test   %eax,%eax
  802de2:	74 0b                	je     802def <alloc_block_FF+0x146>
  802de4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de7:	8b 00                	mov    (%eax),%eax
  802de9:	8b 55 94             	mov    -0x6c(%ebp),%edx
  802dec:	89 50 04             	mov    %edx,0x4(%eax)
  802def:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df2:	8b 55 94             	mov    -0x6c(%ebp),%edx
  802df5:	89 10                	mov    %edx,(%eax)
  802df7:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802dfa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dfd:	89 50 04             	mov    %edx,0x4(%eax)
  802e00:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802e03:	8b 00                	mov    (%eax),%eax
  802e05:	85 c0                	test   %eax,%eax
  802e07:	75 08                	jne    802e11 <alloc_block_FF+0x168>
  802e09:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802e0c:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802e11:	a1 54 50 98 00       	mov    0x985054,%eax
  802e16:	40                   	inc    %eax
  802e17:	a3 54 50 98 00       	mov    %eax,0x985054

				// update the allocated block and remove it from freeBlocksList
				set_block_data(block,totalSize,1);
  802e1c:	83 ec 04             	sub    $0x4,%esp
  802e1f:	6a 01                	push   $0x1
  802e21:	ff 75 dc             	pushl  -0x24(%ebp)
  802e24:	ff 75 f4             	pushl  -0xc(%ebp)
  802e27:	e8 93 fc ff ff       	call   802abf <set_block_data>
  802e2c:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  802e2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e33:	75 17                	jne    802e4c <alloc_block_FF+0x1a3>
  802e35:	83 ec 04             	sub    $0x4,%esp
  802e38:	68 b4 46 80 00       	push   $0x8046b4
  802e3d:	68 e3 00 00 00       	push   $0xe3
  802e42:	68 0b 46 80 00       	push   $0x80460b
  802e47:	e8 30 da ff ff       	call   80087c <_panic>
  802e4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4f:	8b 00                	mov    (%eax),%eax
  802e51:	85 c0                	test   %eax,%eax
  802e53:	74 10                	je     802e65 <alloc_block_FF+0x1bc>
  802e55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e58:	8b 00                	mov    (%eax),%eax
  802e5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e5d:	8b 52 04             	mov    0x4(%edx),%edx
  802e60:	89 50 04             	mov    %edx,0x4(%eax)
  802e63:	eb 0b                	jmp    802e70 <alloc_block_FF+0x1c7>
  802e65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e68:	8b 40 04             	mov    0x4(%eax),%eax
  802e6b:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802e70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e73:	8b 40 04             	mov    0x4(%eax),%eax
  802e76:	85 c0                	test   %eax,%eax
  802e78:	74 0f                	je     802e89 <alloc_block_FF+0x1e0>
  802e7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7d:	8b 40 04             	mov    0x4(%eax),%eax
  802e80:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e83:	8b 12                	mov    (%edx),%edx
  802e85:	89 10                	mov    %edx,(%eax)
  802e87:	eb 0a                	jmp    802e93 <alloc_block_FF+0x1ea>
  802e89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8c:	8b 00                	mov    (%eax),%eax
  802e8e:	a3 48 50 98 00       	mov    %eax,0x985048
  802e93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e96:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ea6:	a1 54 50 98 00       	mov    0x985054,%eax
  802eab:	48                   	dec    %eax
  802eac:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  802eb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb4:	e9 25 02 00 00       	jmp    8030de <alloc_block_FF+0x435>
			}
			else // if set internal fragmentation
			{
				// add the remaining size to the block we allocate so it will be the same main block size
				set_block_data(block,blockSize,1);
  802eb9:	83 ec 04             	sub    $0x4,%esp
  802ebc:	6a 01                	push   $0x1
  802ebe:	ff 75 9c             	pushl  -0x64(%ebp)
  802ec1:	ff 75 f4             	pushl  -0xc(%ebp)
  802ec4:	e8 f6 fb ff ff       	call   802abf <set_block_data>
  802ec9:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  802ecc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ed0:	75 17                	jne    802ee9 <alloc_block_FF+0x240>
  802ed2:	83 ec 04             	sub    $0x4,%esp
  802ed5:	68 b4 46 80 00       	push   $0x8046b4
  802eda:	68 eb 00 00 00       	push   $0xeb
  802edf:	68 0b 46 80 00       	push   $0x80460b
  802ee4:	e8 93 d9 ff ff       	call   80087c <_panic>
  802ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eec:	8b 00                	mov    (%eax),%eax
  802eee:	85 c0                	test   %eax,%eax
  802ef0:	74 10                	je     802f02 <alloc_block_FF+0x259>
  802ef2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef5:	8b 00                	mov    (%eax),%eax
  802ef7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802efa:	8b 52 04             	mov    0x4(%edx),%edx
  802efd:	89 50 04             	mov    %edx,0x4(%eax)
  802f00:	eb 0b                	jmp    802f0d <alloc_block_FF+0x264>
  802f02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f05:	8b 40 04             	mov    0x4(%eax),%eax
  802f08:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802f0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f10:	8b 40 04             	mov    0x4(%eax),%eax
  802f13:	85 c0                	test   %eax,%eax
  802f15:	74 0f                	je     802f26 <alloc_block_FF+0x27d>
  802f17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1a:	8b 40 04             	mov    0x4(%eax),%eax
  802f1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f20:	8b 12                	mov    (%edx),%edx
  802f22:	89 10                	mov    %edx,(%eax)
  802f24:	eb 0a                	jmp    802f30 <alloc_block_FF+0x287>
  802f26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f29:	8b 00                	mov    (%eax),%eax
  802f2b:	a3 48 50 98 00       	mov    %eax,0x985048
  802f30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f33:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f43:	a1 54 50 98 00       	mov    0x985054,%eax
  802f48:	48                   	dec    %eax
  802f49:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  802f4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f51:	e9 88 01 00 00       	jmp    8030de <alloc_block_FF+0x435>
		return NULL;
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802f56:	a1 50 50 98 00       	mov    0x985050,%eax
  802f5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f5e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f62:	74 07                	je     802f6b <alloc_block_FF+0x2c2>
  802f64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f67:	8b 00                	mov    (%eax),%eax
  802f69:	eb 05                	jmp    802f70 <alloc_block_FF+0x2c7>
  802f6b:	b8 00 00 00 00       	mov    $0x0,%eax
  802f70:	a3 50 50 98 00       	mov    %eax,0x985050
  802f75:	a1 50 50 98 00       	mov    0x985050,%eax
  802f7a:	85 c0                	test   %eax,%eax
  802f7c:	0f 85 d9 fd ff ff    	jne    802d5b <alloc_block_FF+0xb2>
  802f82:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f86:	0f 85 cf fd ff ff    	jne    802d5b <alloc_block_FF+0xb2>

//	uint32 *endBlock = &kheapBreak;

	// if we don't find any enough space to allocate the block

	void *oldBreak = sbrk(ROUNDUP(totalSize, PAGE_SIZE) / PAGE_SIZE);
  802f8c:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802f93:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f96:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802f99:	01 d0                	add    %edx,%eax
  802f9b:	48                   	dec    %eax
  802f9c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802f9f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802fa2:	ba 00 00 00 00       	mov    $0x0,%edx
  802fa7:	f7 75 d8             	divl   -0x28(%ebp)
  802faa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802fad:	29 d0                	sub    %edx,%eax
  802faf:	c1 e8 0c             	shr    $0xc,%eax
  802fb2:	83 ec 0c             	sub    $0xc,%esp
  802fb5:	50                   	push   %eax
  802fb6:	e8 20 eb ff ff       	call   801adb <sbrk>
  802fbb:	83 c4 10             	add    $0x10,%esp
  802fbe:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (oldBreak == (void*)-1) {
  802fc1:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802fc5:	75 0a                	jne    802fd1 <alloc_block_FF+0x328>
		return NULL;
  802fc7:	b8 00 00 00 00       	mov    $0x0,%eax
  802fcc:	e9 0d 01 00 00       	jmp    8030de <alloc_block_FF+0x435>
	}
	//uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);

	uint32* endBlk = (uint32 *)((char *)oldBreak - 4);
  802fd1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802fd4:	83 e8 04             	sub    $0x4,%eax
  802fd7:	89 45 cc             	mov    %eax,-0x34(%ebp)
	//endBlk = endBlk+(char *) ROUNDUP(totalSize, PAGE_SIZE);

	endBlk = endBlk + (ROUNDUP(totalSize, PAGE_SIZE) / sizeof(uint32));
  802fda:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  802fe1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802fe4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802fe7:	01 d0                	add    %edx,%eax
  802fe9:	48                   	dec    %eax
  802fea:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  802fed:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802ff0:	ba 00 00 00 00       	mov    $0x0,%edx
  802ff5:	f7 75 c8             	divl   -0x38(%ebp)
  802ff8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802ffb:	29 d0                	sub    %edx,%eax
  802ffd:	c1 e8 02             	shr    $0x2,%eax
  803000:	c1 e0 02             	shl    $0x2,%eax
  803003:	01 45 cc             	add    %eax,-0x34(%ebp)
	*endBlk = 0 | 1;
  803006:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803009:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	uint32 *footerLast = ((uint32*)oldBreak - 2);
  80300f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803012:	83 e8 08             	sub    $0x8,%eax
  803015:	89 45 c0             	mov    %eax,-0x40(%ebp)
	uint32 lastSize = (*footerLast) & ~(0x1);
  803018:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80301b:	8b 00                	mov    (%eax),%eax
  80301d:	83 e0 fe             	and    $0xfffffffe,%eax
  803020:	89 45 bc             	mov    %eax,-0x44(%ebp)
	// the last block for the block that we want to free it
	struct BlockElement *laskBlk = (struct BlockElement *)((char*)oldBreak - lastSize);
  803023:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803026:	f7 d8                	neg    %eax
  803028:	89 c2                	mov    %eax,%edx
  80302a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80302d:	01 d0                	add    %edx,%eax
  80302f:	89 45 b8             	mov    %eax,-0x48(%ebp)
	uint32 isLastFree = is_free_block(laskBlk);
  803032:	83 ec 0c             	sub    $0xc,%esp
  803035:	ff 75 b8             	pushl  -0x48(%ebp)
  803038:	e8 1f f8 ff ff       	call   80285c <is_free_block>
  80303d:	83 c4 10             	add    $0x10,%esp
  803040:	0f be c0             	movsbl %al,%eax
  803043:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(isLastFree)
  803046:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  80304a:	74 42                	je     80308e <alloc_block_FF+0x3e5>
	{
		// merge the block will be free with its prev block
		uint32 newBlkSize = lastSize + ROUNDUP(totalSize, PAGE_SIZE); // size of main block and its prev block
  80304c:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  803053:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803056:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803059:	01 d0                	add    %edx,%eax
  80305b:	48                   	dec    %eax
  80305c:	89 45 ac             	mov    %eax,-0x54(%ebp)
  80305f:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803062:	ba 00 00 00 00       	mov    $0x0,%edx
  803067:	f7 75 b0             	divl   -0x50(%ebp)
  80306a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80306d:	29 d0                	sub    %edx,%eax
  80306f:	89 c2                	mov    %eax,%edx
  803071:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803074:	01 d0                	add    %edx,%eax
  803076:	89 45 a8             	mov    %eax,-0x58(%ebp)
		// extends last block size to contain its size and the size of new space
		set_block_data(laskBlk,newBlkSize,0);
  803079:	83 ec 04             	sub    $0x4,%esp
  80307c:	6a 00                	push   $0x0
  80307e:	ff 75 a8             	pushl  -0x58(%ebp)
  803081:	ff 75 b8             	pushl  -0x48(%ebp)
  803084:	e8 36 fa ff ff       	call   802abf <set_block_data>
  803089:	83 c4 10             	add    $0x10,%esp
  80308c:	eb 42                	jmp    8030d0 <alloc_block_FF+0x427>
	}
	else
	{
		set_block_data(oldBreak,ROUNDUP(totalSize, PAGE_SIZE),0);
  80308e:	c7 45 a4 00 10 00 00 	movl   $0x1000,-0x5c(%ebp)
  803095:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803098:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80309b:	01 d0                	add    %edx,%eax
  80309d:	48                   	dec    %eax
  80309e:	89 45 a0             	mov    %eax,-0x60(%ebp)
  8030a1:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8030a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8030a9:	f7 75 a4             	divl   -0x5c(%ebp)
  8030ac:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8030af:	29 d0                	sub    %edx,%eax
  8030b1:	83 ec 04             	sub    $0x4,%esp
  8030b4:	6a 00                	push   $0x0
  8030b6:	50                   	push   %eax
  8030b7:	ff 75 d0             	pushl  -0x30(%ebp)
  8030ba:	e8 00 fa ff ff       	call   802abf <set_block_data>
  8030bf:	83 c4 10             	add    $0x10,%esp
		insert_sorted_in_freeList((struct BlockElement *)oldBreak);
  8030c2:	83 ec 0c             	sub    $0xc,%esp
  8030c5:	ff 75 d0             	pushl  -0x30(%ebp)
  8030c8:	e8 49 fa ff ff       	call   802b16 <insert_sorted_in_freeList>
  8030cd:	83 c4 10             	add    $0x10,%esp
//		LIST_INSERT_TAIL(&freeBlocksList,newBreak);
	}
//	set_block_data((struct BlockElement *)newBreak, totalSize, 1);
	return alloc_block_FF(size);
  8030d0:	83 ec 0c             	sub    $0xc,%esp
  8030d3:	ff 75 08             	pushl  0x8(%ebp)
  8030d6:	e8 ce fb ff ff       	call   802ca9 <alloc_block_FF>
  8030db:	83 c4 10             	add    $0x10,%esp
}
  8030de:	c9                   	leave  
  8030df:	c3                   	ret    

008030e0 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8030e0:	55                   	push   %ebp
  8030e1:	89 e5                	mov    %esp,%ebp
  8030e3:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS1 - BONUS] [3] DYNAMIC ALLOCATOR - alloc_block_BF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_BF is not implemented yet");
	//Your Code is Here...
	if(size == 0)
  8030e6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030ea:	75 0a                	jne    8030f6 <alloc_block_BF+0x16>
	{
		return NULL;
  8030ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8030f1:	e9 7a 02 00 00       	jmp    803370 <alloc_block_BF+0x290>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  8030f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f9:	83 c0 08             	add    $0x8,%eax
  8030fc:	89 45 e8             	mov    %eax,-0x18(%ebp)

	struct BlockElement *minBlk= NULL;
  8030ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 minSize = 0xfffffff; // a large number
  803106:	c7 45 f0 ff ff ff 0f 	movl   $0xfffffff,-0x10(%ebp)
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  80310d:	a1 48 50 98 00       	mov    0x985048,%eax
  803112:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803115:	eb 32                	jmp    803149 <alloc_block_BF+0x69>
	{
		uint32 blockSize = get_block_size(block);
  803117:	ff 75 ec             	pushl  -0x14(%ebp)
  80311a:	e8 24 f7 ff ff       	call   802843 <get_block_size>
  80311f:	83 c4 04             	add    $0x4,%esp
  803122:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		// if this block can take the new block and its size < min size of all blocks
		if(blockSize >= totalSize && blockSize < minSize)
  803125:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803128:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80312b:	72 14                	jb     803141 <alloc_block_BF+0x61>
  80312d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803130:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803133:	73 0c                	jae    803141 <alloc_block_BF+0x61>
		{
			minBlk = block;
  803135:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803138:	89 45 f4             	mov    %eax,-0xc(%ebp)
			minSize = blockSize;
  80313b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80313e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *minBlk= NULL;
	uint32 minSize = 0xfffffff; // a large number
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  803141:	a1 50 50 98 00       	mov    0x985050,%eax
  803146:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803149:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80314d:	74 07                	je     803156 <alloc_block_BF+0x76>
  80314f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803152:	8b 00                	mov    (%eax),%eax
  803154:	eb 05                	jmp    80315b <alloc_block_BF+0x7b>
  803156:	b8 00 00 00 00       	mov    $0x0,%eax
  80315b:	a3 50 50 98 00       	mov    %eax,0x985050
  803160:	a1 50 50 98 00       	mov    0x985050,%eax
  803165:	85 c0                	test   %eax,%eax
  803167:	75 ae                	jne    803117 <alloc_block_BF+0x37>
  803169:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80316d:	75 a8                	jne    803117 <alloc_block_BF+0x37>
			minSize = blockSize;
		}
	}

	// if we don't find any enough space to allocate the block
	if(minBlk == NULL)
  80316f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803173:	75 22                	jne    803197 <alloc_block_BF+0xb7>
	{
		void *newBlock = sbrk(totalSize);
  803175:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803178:	83 ec 0c             	sub    $0xc,%esp
  80317b:	50                   	push   %eax
  80317c:	e8 5a e9 ff ff       	call   801adb <sbrk>
  803181:	83 c4 10             	add    $0x10,%esp
  803184:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (newBlock == (void*)-1) {
  803187:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  80318b:	75 0a                	jne    803197 <alloc_block_BF+0xb7>
			return NULL;
  80318d:	b8 00 00 00 00       	mov    $0x0,%eax
  803192:	e9 d9 01 00 00       	jmp    803370 <alloc_block_BF+0x290>
		}
	}

	//if we can put another block with min size 16
	if(minSize >= totalSize + 4*sizeof(uint32))
  803197:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80319a:	83 c0 10             	add    $0x10,%eax
  80319d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8031a0:	0f 87 32 01 00 00    	ja     8032d8 <alloc_block_BF+0x1f8>
	{
		// the size that will remain from the block that we will allocate a new block in it
		uint32 remainingSize= minSize - totalSize;
  8031a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031a9:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8031ac:	89 45 dc             	mov    %eax,-0x24(%ebp)

		// the remaining free space from the block that we use to allocate in it
		struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)minBlk + totalSize);
  8031af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b5:	01 d0                	add    %edx,%eax
  8031b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
		set_block_data(remainingFreeBlock, remainingSize, 0);
  8031ba:	83 ec 04             	sub    $0x4,%esp
  8031bd:	6a 00                	push   $0x0
  8031bf:	ff 75 dc             	pushl  -0x24(%ebp)
  8031c2:	ff 75 d8             	pushl  -0x28(%ebp)
  8031c5:	e8 f5 f8 ff ff       	call   802abf <set_block_data>
  8031ca:	83 c4 10             	add    $0x10,%esp
		// add it after the block we allocated to be sorted by addresses
		LIST_INSERT_AFTER(&freeBlocksList, minBlk,remainingFreeBlock);
  8031cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031d1:	74 06                	je     8031d9 <alloc_block_BF+0xf9>
  8031d3:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8031d7:	75 17                	jne    8031f0 <alloc_block_BF+0x110>
  8031d9:	83 ec 04             	sub    $0x4,%esp
  8031dc:	68 80 46 80 00       	push   $0x804680
  8031e1:	68 49 01 00 00       	push   $0x149
  8031e6:	68 0b 46 80 00       	push   $0x80460b
  8031eb:	e8 8c d6 ff ff       	call   80087c <_panic>
  8031f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f3:	8b 10                	mov    (%eax),%edx
  8031f5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8031f8:	89 10                	mov    %edx,(%eax)
  8031fa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8031fd:	8b 00                	mov    (%eax),%eax
  8031ff:	85 c0                	test   %eax,%eax
  803201:	74 0b                	je     80320e <alloc_block_BF+0x12e>
  803203:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803206:	8b 00                	mov    (%eax),%eax
  803208:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80320b:	89 50 04             	mov    %edx,0x4(%eax)
  80320e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803211:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803214:	89 10                	mov    %edx,(%eax)
  803216:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803219:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80321c:	89 50 04             	mov    %edx,0x4(%eax)
  80321f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803222:	8b 00                	mov    (%eax),%eax
  803224:	85 c0                	test   %eax,%eax
  803226:	75 08                	jne    803230 <alloc_block_BF+0x150>
  803228:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80322b:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803230:	a1 54 50 98 00       	mov    0x985054,%eax
  803235:	40                   	inc    %eax
  803236:	a3 54 50 98 00       	mov    %eax,0x985054

		// update the allocated block and remove it from freeBlocksList
		set_block_data(minBlk,totalSize,1);
  80323b:	83 ec 04             	sub    $0x4,%esp
  80323e:	6a 01                	push   $0x1
  803240:	ff 75 e8             	pushl  -0x18(%ebp)
  803243:	ff 75 f4             	pushl  -0xc(%ebp)
  803246:	e8 74 f8 ff ff       	call   802abf <set_block_data>
  80324b:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  80324e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803252:	75 17                	jne    80326b <alloc_block_BF+0x18b>
  803254:	83 ec 04             	sub    $0x4,%esp
  803257:	68 b4 46 80 00       	push   $0x8046b4
  80325c:	68 4e 01 00 00       	push   $0x14e
  803261:	68 0b 46 80 00       	push   $0x80460b
  803266:	e8 11 d6 ff ff       	call   80087c <_panic>
  80326b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326e:	8b 00                	mov    (%eax),%eax
  803270:	85 c0                	test   %eax,%eax
  803272:	74 10                	je     803284 <alloc_block_BF+0x1a4>
  803274:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803277:	8b 00                	mov    (%eax),%eax
  803279:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80327c:	8b 52 04             	mov    0x4(%edx),%edx
  80327f:	89 50 04             	mov    %edx,0x4(%eax)
  803282:	eb 0b                	jmp    80328f <alloc_block_BF+0x1af>
  803284:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803287:	8b 40 04             	mov    0x4(%eax),%eax
  80328a:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80328f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803292:	8b 40 04             	mov    0x4(%eax),%eax
  803295:	85 c0                	test   %eax,%eax
  803297:	74 0f                	je     8032a8 <alloc_block_BF+0x1c8>
  803299:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80329c:	8b 40 04             	mov    0x4(%eax),%eax
  80329f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032a2:	8b 12                	mov    (%edx),%edx
  8032a4:	89 10                	mov    %edx,(%eax)
  8032a6:	eb 0a                	jmp    8032b2 <alloc_block_BF+0x1d2>
  8032a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ab:	8b 00                	mov    (%eax),%eax
  8032ad:	a3 48 50 98 00       	mov    %eax,0x985048
  8032b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032c5:	a1 54 50 98 00       	mov    0x985054,%eax
  8032ca:	48                   	dec    %eax
  8032cb:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  8032d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d3:	e9 98 00 00 00       	jmp    803370 <alloc_block_BF+0x290>
	}
	else // if set internal fragmentation
	{
		// add the remaining size to the block we allocate so it will be the same main block size
		set_block_data(minBlk,minSize,1);
  8032d8:	83 ec 04             	sub    $0x4,%esp
  8032db:	6a 01                	push   $0x1
  8032dd:	ff 75 f0             	pushl  -0x10(%ebp)
  8032e0:	ff 75 f4             	pushl  -0xc(%ebp)
  8032e3:	e8 d7 f7 ff ff       	call   802abf <set_block_data>
  8032e8:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  8032eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032ef:	75 17                	jne    803308 <alloc_block_BF+0x228>
  8032f1:	83 ec 04             	sub    $0x4,%esp
  8032f4:	68 b4 46 80 00       	push   $0x8046b4
  8032f9:	68 56 01 00 00       	push   $0x156
  8032fe:	68 0b 46 80 00       	push   $0x80460b
  803303:	e8 74 d5 ff ff       	call   80087c <_panic>
  803308:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80330b:	8b 00                	mov    (%eax),%eax
  80330d:	85 c0                	test   %eax,%eax
  80330f:	74 10                	je     803321 <alloc_block_BF+0x241>
  803311:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803314:	8b 00                	mov    (%eax),%eax
  803316:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803319:	8b 52 04             	mov    0x4(%edx),%edx
  80331c:	89 50 04             	mov    %edx,0x4(%eax)
  80331f:	eb 0b                	jmp    80332c <alloc_block_BF+0x24c>
  803321:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803324:	8b 40 04             	mov    0x4(%eax),%eax
  803327:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80332c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80332f:	8b 40 04             	mov    0x4(%eax),%eax
  803332:	85 c0                	test   %eax,%eax
  803334:	74 0f                	je     803345 <alloc_block_BF+0x265>
  803336:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803339:	8b 40 04             	mov    0x4(%eax),%eax
  80333c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80333f:	8b 12                	mov    (%edx),%edx
  803341:	89 10                	mov    %edx,(%eax)
  803343:	eb 0a                	jmp    80334f <alloc_block_BF+0x26f>
  803345:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803348:	8b 00                	mov    (%eax),%eax
  80334a:	a3 48 50 98 00       	mov    %eax,0x985048
  80334f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803352:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803358:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803362:	a1 54 50 98 00       	mov    0x985054,%eax
  803367:	48                   	dec    %eax
  803368:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  80336d:	8b 45 f4             	mov    -0xc(%ebp),%eax
	}
	return NULL;
}
  803370:	c9                   	leave  
  803371:	c3                   	ret    

00803372 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803372:	55                   	push   %ebp
  803373:	89 e5                	mov    %esp,%ebp
  803375:	83 ec 48             	sub    $0x48,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
  803378:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80337c:	0f 84 6a 02 00 00    	je     8035ec <free_block+0x27a>
	{
		return;
	}

	uint32 freeSize = get_block_size(va);
  803382:	ff 75 08             	pushl  0x8(%ebp)
  803385:	e8 b9 f4 ff ff       	call   802843 <get_block_size>
  80338a:	83 c4 04             	add    $0x4,%esp
  80338d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// footer for the prev block for the block that we want to free it
	uint32 *footerPrev = ((uint32*)va - 2 );
  803390:	8b 45 08             	mov    0x8(%ebp),%eax
  803393:	83 e8 08             	sub    $0x8,%eax
  803396:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 pSize = (*footerPrev) & ~(0x1);
  803399:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80339c:	8b 00                	mov    (%eax),%eax
  80339e:	83 e0 fe             	and    $0xfffffffe,%eax
  8033a1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// the prev block for the block that we want to free it
	struct BlockElement * prevBlk = (struct BlockElement *)((char*)va - pSize);
  8033a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033a7:	f7 d8                	neg    %eax
  8033a9:	89 c2                	mov    %eax,%edx
  8033ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ae:	01 d0                	add    %edx,%eax
  8033b0:	89 45 e8             	mov    %eax,-0x18(%ebp)
	uint32 isPrevFree = is_free_block(prevBlk);
  8033b3:	ff 75 e8             	pushl  -0x18(%ebp)
  8033b6:	e8 a1 f4 ff ff       	call   80285c <is_free_block>
  8033bb:	83 c4 04             	add    $0x4,%esp
  8033be:	0f be c0             	movsbl %al,%eax
  8033c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
  8033c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8033c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ca:	01 d0                	add    %edx,%eax
  8033cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  8033cf:	ff 75 e0             	pushl  -0x20(%ebp)
  8033d2:	e8 85 f4 ff ff       	call   80285c <is_free_block>
  8033d7:	83 c4 04             	add    $0x4,%esp
  8033da:	0f be c0             	movsbl %al,%eax
  8033dd:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if(isPrevFree == 1 && isNextFree == 0)
  8033e0:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  8033e4:	75 34                	jne    80341a <free_block+0xa8>
  8033e6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8033ea:	75 2e                	jne    80341a <free_block+0xa8>
	{
		// merge the block will be free with its prev block
		uint32 prevSize = get_block_size(prevBlk);
  8033ec:	ff 75 e8             	pushl  -0x18(%ebp)
  8033ef:	e8 4f f4 ff ff       	call   802843 <get_block_size>
  8033f4:	83 c4 04             	add    $0x4,%esp
  8033f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
  8033fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033fd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803400:	01 d0                	add    %edx,%eax
  803402:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
  803405:	6a 00                	push   $0x0
  803407:	ff 75 d4             	pushl  -0x2c(%ebp)
  80340a:	ff 75 e8             	pushl  -0x18(%ebp)
  80340d:	e8 ad f6 ff ff       	call   802abf <set_block_data>
  803412:	83 c4 0c             	add    $0xc,%esp
	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
	uint32 isNextFree = is_free_block(nextBlk);

	if(isPrevFree == 1 && isNextFree == 0)
	{
  803415:	e9 d3 01 00 00       	jmp    8035ed <free_block+0x27b>
		uint32 prevSize = get_block_size(prevBlk);
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
  80341a:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  80341e:	0f 85 c8 00 00 00    	jne    8034ec <free_block+0x17a>
  803424:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803428:	0f 85 be 00 00 00    	jne    8034ec <free_block+0x17a>
	{
		// merge the block will be free with its next block
		uint32 nextSize = get_block_size(nextBlk);
  80342e:	ff 75 e0             	pushl  -0x20(%ebp)
  803431:	e8 0d f4 ff ff       	call   802843 <get_block_size>
  803436:	83 c4 04             	add    $0x4,%esp
  803439:	89 45 d0             	mov    %eax,-0x30(%ebp)
		uint32 totalSize = freeSize + nextSize; // size of main block and its next block
  80343c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80343f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803442:	01 d0                	add    %edx,%eax
  803444:	89 45 cc             	mov    %eax,-0x34(%ebp)
		// update the size of block to contain its size and the size of next block
		set_block_data(va,totalSize,0);
  803447:	6a 00                	push   $0x0
  803449:	ff 75 cc             	pushl  -0x34(%ebp)
  80344c:	ff 75 08             	pushl  0x8(%ebp)
  80344f:	e8 6b f6 ff ff       	call   802abf <set_block_data>
  803454:	83 c4 0c             	add    $0xc,%esp
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
  803457:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80345b:	75 17                	jne    803474 <free_block+0x102>
  80345d:	83 ec 04             	sub    $0x4,%esp
  803460:	68 b4 46 80 00       	push   $0x8046b4
  803465:	68 87 01 00 00       	push   $0x187
  80346a:	68 0b 46 80 00       	push   $0x80460b
  80346f:	e8 08 d4 ff ff       	call   80087c <_panic>
  803474:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803477:	8b 00                	mov    (%eax),%eax
  803479:	85 c0                	test   %eax,%eax
  80347b:	74 10                	je     80348d <free_block+0x11b>
  80347d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803480:	8b 00                	mov    (%eax),%eax
  803482:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803485:	8b 52 04             	mov    0x4(%edx),%edx
  803488:	89 50 04             	mov    %edx,0x4(%eax)
  80348b:	eb 0b                	jmp    803498 <free_block+0x126>
  80348d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803490:	8b 40 04             	mov    0x4(%eax),%eax
  803493:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803498:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80349b:	8b 40 04             	mov    0x4(%eax),%eax
  80349e:	85 c0                	test   %eax,%eax
  8034a0:	74 0f                	je     8034b1 <free_block+0x13f>
  8034a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034a5:	8b 40 04             	mov    0x4(%eax),%eax
  8034a8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8034ab:	8b 12                	mov    (%edx),%edx
  8034ad:	89 10                	mov    %edx,(%eax)
  8034af:	eb 0a                	jmp    8034bb <free_block+0x149>
  8034b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034b4:	8b 00                	mov    (%eax),%eax
  8034b6:	a3 48 50 98 00       	mov    %eax,0x985048
  8034bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034c7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034ce:	a1 54 50 98 00       	mov    0x985054,%eax
  8034d3:	48                   	dec    %eax
  8034d4:	a3 54 50 98 00       	mov    %eax,0x985054
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  8034d9:	83 ec 0c             	sub    $0xc,%esp
  8034dc:	ff 75 08             	pushl  0x8(%ebp)
  8034df:	e8 32 f6 ff ff       	call   802b16 <insert_sorted_in_freeList>
  8034e4:	83 c4 10             	add    $0x10,%esp
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
	{
  8034e7:	e9 01 01 00 00       	jmp    8035ed <free_block+0x27b>
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
  8034ec:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  8034f0:	0f 85 d3 00 00 00    	jne    8035c9 <free_block+0x257>
  8034f6:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  8034fa:	0f 85 c9 00 00 00    	jne    8035c9 <free_block+0x257>
	{
		// merge the block will be free with its prev and next blocks
		uint32 prevSize = get_block_size(prevBlk);
  803500:	83 ec 0c             	sub    $0xc,%esp
  803503:	ff 75 e8             	pushl  -0x18(%ebp)
  803506:	e8 38 f3 ff ff       	call   802843 <get_block_size>
  80350b:	83 c4 10             	add    $0x10,%esp
  80350e:	89 45 c8             	mov    %eax,-0x38(%ebp)
		uint32 nextSize = get_block_size(nextBlk);
  803511:	83 ec 0c             	sub    $0xc,%esp
  803514:	ff 75 e0             	pushl  -0x20(%ebp)
  803517:	e8 27 f3 ff ff       	call   802843 <get_block_size>
  80351c:	83 c4 10             	add    $0x10,%esp
  80351f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 totalSize = freeSize + prevSize + nextSize; // size of main block and its prev and next blocks
  803522:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803525:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803528:	01 c2                	add    %eax,%edx
  80352a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80352d:	01 d0                	add    %edx,%eax
  80352f:	89 45 c0             	mov    %eax,-0x40(%ebp)
		// extends prev block size to contain its size and the size of main and next blocks
		set_block_data(prevBlk,totalSize,0);
  803532:	83 ec 04             	sub    $0x4,%esp
  803535:	6a 00                	push   $0x0
  803537:	ff 75 c0             	pushl  -0x40(%ebp)
  80353a:	ff 75 e8             	pushl  -0x18(%ebp)
  80353d:	e8 7d f5 ff ff       	call   802abf <set_block_data>
  803542:	83 c4 10             	add    $0x10,%esp
		// remove next block because we merge it with its prev blocks
		LIST_REMOVE(&freeBlocksList, nextBlk);
  803545:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803549:	75 17                	jne    803562 <free_block+0x1f0>
  80354b:	83 ec 04             	sub    $0x4,%esp
  80354e:	68 b4 46 80 00       	push   $0x8046b4
  803553:	68 94 01 00 00       	push   $0x194
  803558:	68 0b 46 80 00       	push   $0x80460b
  80355d:	e8 1a d3 ff ff       	call   80087c <_panic>
  803562:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803565:	8b 00                	mov    (%eax),%eax
  803567:	85 c0                	test   %eax,%eax
  803569:	74 10                	je     80357b <free_block+0x209>
  80356b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80356e:	8b 00                	mov    (%eax),%eax
  803570:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803573:	8b 52 04             	mov    0x4(%edx),%edx
  803576:	89 50 04             	mov    %edx,0x4(%eax)
  803579:	eb 0b                	jmp    803586 <free_block+0x214>
  80357b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80357e:	8b 40 04             	mov    0x4(%eax),%eax
  803581:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803586:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803589:	8b 40 04             	mov    0x4(%eax),%eax
  80358c:	85 c0                	test   %eax,%eax
  80358e:	74 0f                	je     80359f <free_block+0x22d>
  803590:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803593:	8b 40 04             	mov    0x4(%eax),%eax
  803596:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803599:	8b 12                	mov    (%edx),%edx
  80359b:	89 10                	mov    %edx,(%eax)
  80359d:	eb 0a                	jmp    8035a9 <free_block+0x237>
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
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
	{
  8035c7:	eb 24                	jmp    8035ed <free_block+0x27b>
	}
	else
	{
		// free it without any merge
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
  8035c9:	83 ec 04             	sub    $0x4,%esp
  8035cc:	6a 00                	push   $0x0
  8035ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8035d1:	ff 75 08             	pushl  0x8(%ebp)
  8035d4:	e8 e6 f4 ff ff       	call   802abf <set_block_data>
  8035d9:	83 c4 10             	add    $0x10,%esp
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  8035dc:	83 ec 0c             	sub    $0xc,%esp
  8035df:	ff 75 08             	pushl  0x8(%ebp)
  8035e2:	e8 2f f5 ff ff       	call   802b16 <insert_sorted_in_freeList>
  8035e7:	83 c4 10             	add    $0x10,%esp
  8035ea:	eb 01                	jmp    8035ed <free_block+0x27b>
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
	{
		return;
  8035ec:	90                   	nop
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
}
  8035ed:	c9                   	leave  
  8035ee:	c3                   	ret    

008035ef <realloc_block_FF>:
//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
  8035ef:	55                   	push   %ebp
  8035f0:	89 e5                	mov    %esp,%ebp
  8035f2:	83 ec 38             	sub    $0x38,%esp
	//TODO: [PROJECT'24.MS1 - #08] [3] DYNAMIC ALLOCATOR - realloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(va == NULL && new_size == 0)
  8035f5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035f9:	75 10                	jne    80360b <realloc_block_FF+0x1c>
  8035fb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8035ff:	75 0a                	jne    80360b <realloc_block_FF+0x1c>
	{
		return NULL;
  803601:	b8 00 00 00 00       	mov    $0x0,%eax
  803606:	e9 8b 04 00 00       	jmp    803a96 <realloc_block_FF+0x4a7>
	}

	if(new_size == 0)
  80360b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80360f:	75 18                	jne    803629 <realloc_block_FF+0x3a>
	{
		free_block(va);
  803611:	83 ec 0c             	sub    $0xc,%esp
  803614:	ff 75 08             	pushl  0x8(%ebp)
  803617:	e8 56 fd ff ff       	call   803372 <free_block>
  80361c:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80361f:	b8 00 00 00 00       	mov    $0x0,%eax
  803624:	e9 6d 04 00 00       	jmp    803a96 <realloc_block_FF+0x4a7>
	}

	if(va == NULL)
  803629:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80362d:	75 13                	jne    803642 <realloc_block_FF+0x53>
	{
		return alloc_block_FF(new_size);
  80362f:	83 ec 0c             	sub    $0xc,%esp
  803632:	ff 75 0c             	pushl  0xc(%ebp)
  803635:	e8 6f f6 ff ff       	call   802ca9 <alloc_block_FF>
  80363a:	83 c4 10             	add    $0x10,%esp
  80363d:	e9 54 04 00 00       	jmp    803a96 <realloc_block_FF+0x4a7>
	}

	// if size is odd must be increment it by one
	if (new_size % 2 != 0)
  803642:	8b 45 0c             	mov    0xc(%ebp),%eax
  803645:	83 e0 01             	and    $0x1,%eax
  803648:	85 c0                	test   %eax,%eax
  80364a:	74 03                	je     80364f <realloc_block_FF+0x60>
	{
		new_size++;
  80364c:	ff 45 0c             	incl   0xc(%ebp)
	}

	// if size < 8 must be equal it to 8 because min size 8 excluding metadata
	if(new_size < 8)
  80364f:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803653:	77 07                	ja     80365c <realloc_block_FF+0x6d>
	{
		new_size = 8;
  803655:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	}

	new_size += 8; // adds its footer and header size
  80365c:	83 45 0c 08          	addl   $0x8,0xc(%ebp)

	uint32 actualSize = get_block_size(va);
  803660:	83 ec 0c             	sub    $0xc,%esp
  803663:	ff 75 08             	pushl  0x8(%ebp)
  803666:	e8 d8 f1 ff ff       	call   802843 <get_block_size>
  80366b:	83 c4 10             	add    $0x10,%esp
  80366e:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(actualSize == new_size)
  803671:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803674:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803677:	75 08                	jne    803681 <realloc_block_FF+0x92>
	{
		// don't change any thing
		return va;
  803679:	8b 45 08             	mov    0x8(%ebp),%eax
  80367c:	e9 15 04 00 00       	jmp    803a96 <realloc_block_FF+0x4a7>
	}

	// next block for the block we want to change its size
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + actualSize);
  803681:	8b 55 08             	mov    0x8(%ebp),%edx
  803684:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803687:	01 d0                	add    %edx,%eax
  803689:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  80368c:	83 ec 0c             	sub    $0xc,%esp
  80368f:	ff 75 f0             	pushl  -0x10(%ebp)
  803692:	e8 c5 f1 ff ff       	call   80285c <is_free_block>
  803697:	83 c4 10             	add    $0x10,%esp
  80369a:	0f be c0             	movsbl %al,%eax
  80369d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 nextSize = get_block_size(nextBlk);
  8036a0:	83 ec 0c             	sub    $0xc,%esp
  8036a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8036a6:	e8 98 f1 ff ff       	call   802843 <get_block_size>
  8036ab:	83 c4 10             	add    $0x10,%esp
  8036ae:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// increase the size of block
	if(new_size > actualSize)
  8036b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036b4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8036b7:	0f 86 a7 02 00 00    	jbe    803964 <realloc_block_FF+0x375>
	{
		if(isNextFree)
  8036bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8036c1:	0f 84 86 02 00 00    	je     80394d <realloc_block_FF+0x35e>
		{
			if(nextSize + actualSize == new_size) // block and nextblock = newSizeBlock
  8036c7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036cd:	01 d0                	add    %edx,%eax
  8036cf:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8036d2:	0f 85 b2 00 00 00    	jne    80378a <realloc_block_FF+0x19b>
			{
				set_block_data(va,new_size,!(is_free_block(va)));// update size in block
  8036d8:	83 ec 0c             	sub    $0xc,%esp
  8036db:	ff 75 08             	pushl  0x8(%ebp)
  8036de:	e8 79 f1 ff ff       	call   80285c <is_free_block>
  8036e3:	83 c4 10             	add    $0x10,%esp
  8036e6:	84 c0                	test   %al,%al
  8036e8:	0f 94 c0             	sete   %al
  8036eb:	0f b6 c0             	movzbl %al,%eax
  8036ee:	83 ec 04             	sub    $0x4,%esp
  8036f1:	50                   	push   %eax
  8036f2:	ff 75 0c             	pushl  0xc(%ebp)
  8036f5:	ff 75 08             	pushl  0x8(%ebp)
  8036f8:	e8 c2 f3 ff ff       	call   802abf <set_block_data>
  8036fd:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);// remove next because it is = zero
  803700:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803704:	75 17                	jne    80371d <realloc_block_FF+0x12e>
  803706:	83 ec 04             	sub    $0x4,%esp
  803709:	68 b4 46 80 00       	push   $0x8046b4
  80370e:	68 db 01 00 00       	push   $0x1db
  803713:	68 0b 46 80 00       	push   $0x80460b
  803718:	e8 5f d1 ff ff       	call   80087c <_panic>
  80371d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803720:	8b 00                	mov    (%eax),%eax
  803722:	85 c0                	test   %eax,%eax
  803724:	74 10                	je     803736 <realloc_block_FF+0x147>
  803726:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803729:	8b 00                	mov    (%eax),%eax
  80372b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80372e:	8b 52 04             	mov    0x4(%edx),%edx
  803731:	89 50 04             	mov    %edx,0x4(%eax)
  803734:	eb 0b                	jmp    803741 <realloc_block_FF+0x152>
  803736:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803739:	8b 40 04             	mov    0x4(%eax),%eax
  80373c:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803741:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803744:	8b 40 04             	mov    0x4(%eax),%eax
  803747:	85 c0                	test   %eax,%eax
  803749:	74 0f                	je     80375a <realloc_block_FF+0x16b>
  80374b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80374e:	8b 40 04             	mov    0x4(%eax),%eax
  803751:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803754:	8b 12                	mov    (%edx),%edx
  803756:	89 10                	mov    %edx,(%eax)
  803758:	eb 0a                	jmp    803764 <realloc_block_FF+0x175>
  80375a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80375d:	8b 00                	mov    (%eax),%eax
  80375f:	a3 48 50 98 00       	mov    %eax,0x985048
  803764:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803767:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80376d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803770:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803777:	a1 54 50 98 00       	mov    0x985054,%eax
  80377c:	48                   	dec    %eax
  80377d:	a3 54 50 98 00       	mov    %eax,0x985054
				return va;
  803782:	8b 45 08             	mov    0x8(%ebp),%eax
  803785:	e9 0c 03 00 00       	jmp    803a96 <realloc_block_FF+0x4a7>
			}
			else if(nextSize + actualSize > new_size) // new size is less than next and main blocks
  80378a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80378d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803790:	01 d0                	add    %edx,%eax
  803792:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803795:	0f 86 b2 01 00 00    	jbe    80394d <realloc_block_FF+0x35e>
			{
				uint32 requiredSize = new_size - actualSize; // size that we need from the next block
  80379b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80379e:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8037a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				uint32 remainingNext = nextSize - requiredSize; // size that will remain from the next block after we split it
  8037a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037a7:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8037aa:	89 45 e0             	mov    %eax,-0x20(%ebp)

				// if next size will not fit another block (internal fragmentation)
				if(remainingNext < 16)
  8037ad:	83 7d e0 0f          	cmpl   $0xf,-0x20(%ebp)
  8037b1:	0f 87 b8 00 00 00    	ja     80386f <realloc_block_FF+0x280>
				{
					// we will take the main size of the block and its next size also
					set_block_data(va,actualSize + nextSize,!(is_free_block(va)));
  8037b7:	83 ec 0c             	sub    $0xc,%esp
  8037ba:	ff 75 08             	pushl  0x8(%ebp)
  8037bd:	e8 9a f0 ff ff       	call   80285c <is_free_block>
  8037c2:	83 c4 10             	add    $0x10,%esp
  8037c5:	84 c0                	test   %al,%al
  8037c7:	0f 94 c0             	sete   %al
  8037ca:	0f b6 c0             	movzbl %al,%eax
  8037cd:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8037d0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037d3:	01 ca                	add    %ecx,%edx
  8037d5:	83 ec 04             	sub    $0x4,%esp
  8037d8:	50                   	push   %eax
  8037d9:	52                   	push   %edx
  8037da:	ff 75 08             	pushl  0x8(%ebp)
  8037dd:	e8 dd f2 ff ff       	call   802abf <set_block_data>
  8037e2:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,nextBlk);
  8037e5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8037e9:	75 17                	jne    803802 <realloc_block_FF+0x213>
  8037eb:	83 ec 04             	sub    $0x4,%esp
  8037ee:	68 b4 46 80 00       	push   $0x8046b4
  8037f3:	68 e8 01 00 00       	push   $0x1e8
  8037f8:	68 0b 46 80 00       	push   $0x80460b
  8037fd:	e8 7a d0 ff ff       	call   80087c <_panic>
  803802:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803805:	8b 00                	mov    (%eax),%eax
  803807:	85 c0                	test   %eax,%eax
  803809:	74 10                	je     80381b <realloc_block_FF+0x22c>
  80380b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80380e:	8b 00                	mov    (%eax),%eax
  803810:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803813:	8b 52 04             	mov    0x4(%edx),%edx
  803816:	89 50 04             	mov    %edx,0x4(%eax)
  803819:	eb 0b                	jmp    803826 <realloc_block_FF+0x237>
  80381b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80381e:	8b 40 04             	mov    0x4(%eax),%eax
  803821:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803826:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803829:	8b 40 04             	mov    0x4(%eax),%eax
  80382c:	85 c0                	test   %eax,%eax
  80382e:	74 0f                	je     80383f <realloc_block_FF+0x250>
  803830:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803833:	8b 40 04             	mov    0x4(%eax),%eax
  803836:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803839:	8b 12                	mov    (%edx),%edx
  80383b:	89 10                	mov    %edx,(%eax)
  80383d:	eb 0a                	jmp    803849 <realloc_block_FF+0x25a>
  80383f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803842:	8b 00                	mov    (%eax),%eax
  803844:	a3 48 50 98 00       	mov    %eax,0x985048
  803849:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80384c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803852:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803855:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80385c:	a1 54 50 98 00       	mov    0x985054,%eax
  803861:	48                   	dec    %eax
  803862:	a3 54 50 98 00       	mov    %eax,0x985054
					return va;
  803867:	8b 45 08             	mov    0x8(%ebp),%eax
  80386a:	e9 27 02 00 00       	jmp    803a96 <realloc_block_FF+0x4a7>
				}
				else // if next size can be fit another block (split)
				{
					LIST_REMOVE(&freeBlocksList,nextBlk);
  80386f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803873:	75 17                	jne    80388c <realloc_block_FF+0x29d>
  803875:	83 ec 04             	sub    $0x4,%esp
  803878:	68 b4 46 80 00       	push   $0x8046b4
  80387d:	68 ed 01 00 00       	push   $0x1ed
  803882:	68 0b 46 80 00       	push   $0x80460b
  803887:	e8 f0 cf ff ff       	call   80087c <_panic>
  80388c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80388f:	8b 00                	mov    (%eax),%eax
  803891:	85 c0                	test   %eax,%eax
  803893:	74 10                	je     8038a5 <realloc_block_FF+0x2b6>
  803895:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803898:	8b 00                	mov    (%eax),%eax
  80389a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80389d:	8b 52 04             	mov    0x4(%edx),%edx
  8038a0:	89 50 04             	mov    %edx,0x4(%eax)
  8038a3:	eb 0b                	jmp    8038b0 <realloc_block_FF+0x2c1>
  8038a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038a8:	8b 40 04             	mov    0x4(%eax),%eax
  8038ab:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8038b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038b3:	8b 40 04             	mov    0x4(%eax),%eax
  8038b6:	85 c0                	test   %eax,%eax
  8038b8:	74 0f                	je     8038c9 <realloc_block_FF+0x2da>
  8038ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038bd:	8b 40 04             	mov    0x4(%eax),%eax
  8038c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8038c3:	8b 12                	mov    (%edx),%edx
  8038c5:	89 10                	mov    %edx,(%eax)
  8038c7:	eb 0a                	jmp    8038d3 <realloc_block_FF+0x2e4>
  8038c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038cc:	8b 00                	mov    (%eax),%eax
  8038ce:	a3 48 50 98 00       	mov    %eax,0x985048
  8038d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038e6:	a1 54 50 98 00       	mov    0x985054,%eax
  8038eb:	48                   	dec    %eax
  8038ec:	a3 54 50 98 00       	mov    %eax,0x985054
					nextBlk = (struct BlockElement *)((char *)va + new_size); //update nextBlk address
  8038f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8038f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038f7:	01 d0                	add    %edx,%eax
  8038f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
					set_block_data(nextBlk,remainingNext,0); // update nextBlkSize
  8038fc:	83 ec 04             	sub    $0x4,%esp
  8038ff:	6a 00                	push   $0x0
  803901:	ff 75 e0             	pushl  -0x20(%ebp)
  803904:	ff 75 f0             	pushl  -0x10(%ebp)
  803907:	e8 b3 f1 ff ff       	call   802abf <set_block_data>
  80390c:	83 c4 10             	add    $0x10,%esp
					set_block_data(va,new_size,!(is_free_block(va))); // update size of newblock
  80390f:	83 ec 0c             	sub    $0xc,%esp
  803912:	ff 75 08             	pushl  0x8(%ebp)
  803915:	e8 42 ef ff ff       	call   80285c <is_free_block>
  80391a:	83 c4 10             	add    $0x10,%esp
  80391d:	84 c0                	test   %al,%al
  80391f:	0f 94 c0             	sete   %al
  803922:	0f b6 c0             	movzbl %al,%eax
  803925:	83 ec 04             	sub    $0x4,%esp
  803928:	50                   	push   %eax
  803929:	ff 75 0c             	pushl  0xc(%ebp)
  80392c:	ff 75 08             	pushl  0x8(%ebp)
  80392f:	e8 8b f1 ff ff       	call   802abf <set_block_data>
  803934:	83 c4 10             	add    $0x10,%esp
					insert_sorted_in_freeList(nextBlk);
  803937:	83 ec 0c             	sub    $0xc,%esp
  80393a:	ff 75 f0             	pushl  -0x10(%ebp)
  80393d:	e8 d4 f1 ff ff       	call   802b16 <insert_sorted_in_freeList>
  803942:	83 c4 10             	add    $0x10,%esp
					return va;
  803945:	8b 45 08             	mov    0x8(%ebp),%eax
  803948:	e9 49 01 00 00       	jmp    803a96 <realloc_block_FF+0x4a7>
				}
			}
		}
		// if next block isn't free or not fit the new size
		return alloc_block_FF(new_size - 8);
  80394d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803950:	83 e8 08             	sub    $0x8,%eax
  803953:	83 ec 0c             	sub    $0xc,%esp
  803956:	50                   	push   %eax
  803957:	e8 4d f3 ff ff       	call   802ca9 <alloc_block_FF>
  80395c:	83 c4 10             	add    $0x10,%esp
  80395f:	e9 32 01 00 00       	jmp    803a96 <realloc_block_FF+0x4a7>
	}
	else if(new_size < actualSize) // to shrink block
  803964:	8b 45 0c             	mov    0xc(%ebp),%eax
  803967:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80396a:	0f 83 21 01 00 00    	jae    803a91 <realloc_block_FF+0x4a2>
	{
		uint32 remainingSize = actualSize - new_size; // size that will remain from the main block after we shrink it
  803970:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803973:	2b 45 0c             	sub    0xc(%ebp),%eax
  803976:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(remainingSize < 16 && isNextFree == 0) // internal fragmentation
  803979:	83 7d dc 0f          	cmpl   $0xf,-0x24(%ebp)
  80397d:	77 0e                	ja     80398d <realloc_block_FF+0x39e>
  80397f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803983:	75 08                	jne    80398d <realloc_block_FF+0x39e>
		{
			// don't change its size
			return va;
  803985:	8b 45 08             	mov    0x8(%ebp),%eax
  803988:	e9 09 01 00 00       	jmp    803a96 <realloc_block_FF+0x4a7>
		}
		else // remainingSize fit in a new block
		{
			struct BlockElement *mainBlk = (struct BlockElement *)va;
  80398d:	8b 45 08             	mov    0x8(%ebp),%eax
  803990:	89 45 d8             	mov    %eax,-0x28(%ebp)
			// update main block with new size
			set_block_data(mainBlk,new_size,!(is_free_block(va)));
  803993:	83 ec 0c             	sub    $0xc,%esp
  803996:	ff 75 08             	pushl  0x8(%ebp)
  803999:	e8 be ee ff ff       	call   80285c <is_free_block>
  80399e:	83 c4 10             	add    $0x10,%esp
  8039a1:	84 c0                	test   %al,%al
  8039a3:	0f 94 c0             	sete   %al
  8039a6:	0f b6 c0             	movzbl %al,%eax
  8039a9:	83 ec 04             	sub    $0x4,%esp
  8039ac:	50                   	push   %eax
  8039ad:	ff 75 0c             	pushl  0xc(%ebp)
  8039b0:	ff 75 d8             	pushl  -0x28(%ebp)
  8039b3:	e8 07 f1 ff ff       	call   802abf <set_block_data>
  8039b8:	83 c4 10             	add    $0x10,%esp

			// the blk with remaining size
			struct BlockElement *remainingBlk=(struct BlockElement *)((char*)mainBlk + new_size);
  8039bb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8039be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039c1:	01 d0                	add    %edx,%eax
  8039c3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			set_block_data(remainingBlk,remainingSize,0);
  8039c6:	83 ec 04             	sub    $0x4,%esp
  8039c9:	6a 00                	push   $0x0
  8039cb:	ff 75 dc             	pushl  -0x24(%ebp)
  8039ce:	ff 75 d4             	pushl  -0x2c(%ebp)
  8039d1:	e8 e9 f0 ff ff       	call   802abf <set_block_data>
  8039d6:	83 c4 10             	add    $0x10,%esp

			if(isNextFree)
  8039d9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8039dd:	0f 84 9b 00 00 00    	je     803a7e <realloc_block_FF+0x48f>
			{
				// merge splited block with its next block
				set_block_data(remainingBlk,(remainingSize + nextSize),0);//merge remaining with its next block
  8039e3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8039e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039e9:	01 d0                	add    %edx,%eax
  8039eb:	83 ec 04             	sub    $0x4,%esp
  8039ee:	6a 00                	push   $0x0
  8039f0:	50                   	push   %eax
  8039f1:	ff 75 d4             	pushl  -0x2c(%ebp)
  8039f4:	e8 c6 f0 ff ff       	call   802abf <set_block_data>
  8039f9:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);
  8039fc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803a00:	75 17                	jne    803a19 <realloc_block_FF+0x42a>
  803a02:	83 ec 04             	sub    $0x4,%esp
  803a05:	68 b4 46 80 00       	push   $0x8046b4
  803a0a:	68 10 02 00 00       	push   $0x210
  803a0f:	68 0b 46 80 00       	push   $0x80460b
  803a14:	e8 63 ce ff ff       	call   80087c <_panic>
  803a19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a1c:	8b 00                	mov    (%eax),%eax
  803a1e:	85 c0                	test   %eax,%eax
  803a20:	74 10                	je     803a32 <realloc_block_FF+0x443>
  803a22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a25:	8b 00                	mov    (%eax),%eax
  803a27:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a2a:	8b 52 04             	mov    0x4(%edx),%edx
  803a2d:	89 50 04             	mov    %edx,0x4(%eax)
  803a30:	eb 0b                	jmp    803a3d <realloc_block_FF+0x44e>
  803a32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a35:	8b 40 04             	mov    0x4(%eax),%eax
  803a38:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803a3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a40:	8b 40 04             	mov    0x4(%eax),%eax
  803a43:	85 c0                	test   %eax,%eax
  803a45:	74 0f                	je     803a56 <realloc_block_FF+0x467>
  803a47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a4a:	8b 40 04             	mov    0x4(%eax),%eax
  803a4d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a50:	8b 12                	mov    (%edx),%edx
  803a52:	89 10                	mov    %edx,(%eax)
  803a54:	eb 0a                	jmp    803a60 <realloc_block_FF+0x471>
  803a56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a59:	8b 00                	mov    (%eax),%eax
  803a5b:	a3 48 50 98 00       	mov    %eax,0x985048
  803a60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a63:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a6c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a73:	a1 54 50 98 00       	mov    0x985054,%eax
  803a78:	48                   	dec    %eax
  803a79:	a3 54 50 98 00       	mov    %eax,0x985054
			}
			insert_sorted_in_freeList(remainingBlk);
  803a7e:	83 ec 0c             	sub    $0xc,%esp
  803a81:	ff 75 d4             	pushl  -0x2c(%ebp)
  803a84:	e8 8d f0 ff ff       	call   802b16 <insert_sorted_in_freeList>
  803a89:	83 c4 10             	add    $0x10,%esp
			return mainBlk;
  803a8c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803a8f:	eb 05                	jmp    803a96 <realloc_block_FF+0x4a7>
		}
	}
	return NULL;
  803a91:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a96:	c9                   	leave  
  803a97:	c3                   	ret    

00803a98 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803a98:	55                   	push   %ebp
  803a99:	89 e5                	mov    %esp,%ebp
  803a9b:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803a9e:	83 ec 04             	sub    $0x4,%esp
  803aa1:	68 d4 46 80 00       	push   $0x8046d4
  803aa6:	68 20 02 00 00       	push   $0x220
  803aab:	68 0b 46 80 00       	push   $0x80460b
  803ab0:	e8 c7 cd ff ff       	call   80087c <_panic>

00803ab5 <alloc_block_NF>:
}
//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803ab5:	55                   	push   %ebp
  803ab6:	89 e5                	mov    %esp,%ebp
  803ab8:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803abb:	83 ec 04             	sub    $0x4,%esp
  803abe:	68 fc 46 80 00       	push   $0x8046fc
  803ac3:	68 28 02 00 00       	push   $0x228
  803ac8:	68 0b 46 80 00       	push   $0x80460b
  803acd:	e8 aa cd ff ff       	call   80087c <_panic>
  803ad2:	66 90                	xchg   %ax,%ax

00803ad4 <__udivdi3>:
  803ad4:	55                   	push   %ebp
  803ad5:	57                   	push   %edi
  803ad6:	56                   	push   %esi
  803ad7:	53                   	push   %ebx
  803ad8:	83 ec 1c             	sub    $0x1c,%esp
  803adb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803adf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803ae3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803ae7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803aeb:	89 ca                	mov    %ecx,%edx
  803aed:	89 f8                	mov    %edi,%eax
  803aef:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803af3:	85 f6                	test   %esi,%esi
  803af5:	75 2d                	jne    803b24 <__udivdi3+0x50>
  803af7:	39 cf                	cmp    %ecx,%edi
  803af9:	77 65                	ja     803b60 <__udivdi3+0x8c>
  803afb:	89 fd                	mov    %edi,%ebp
  803afd:	85 ff                	test   %edi,%edi
  803aff:	75 0b                	jne    803b0c <__udivdi3+0x38>
  803b01:	b8 01 00 00 00       	mov    $0x1,%eax
  803b06:	31 d2                	xor    %edx,%edx
  803b08:	f7 f7                	div    %edi
  803b0a:	89 c5                	mov    %eax,%ebp
  803b0c:	31 d2                	xor    %edx,%edx
  803b0e:	89 c8                	mov    %ecx,%eax
  803b10:	f7 f5                	div    %ebp
  803b12:	89 c1                	mov    %eax,%ecx
  803b14:	89 d8                	mov    %ebx,%eax
  803b16:	f7 f5                	div    %ebp
  803b18:	89 cf                	mov    %ecx,%edi
  803b1a:	89 fa                	mov    %edi,%edx
  803b1c:	83 c4 1c             	add    $0x1c,%esp
  803b1f:	5b                   	pop    %ebx
  803b20:	5e                   	pop    %esi
  803b21:	5f                   	pop    %edi
  803b22:	5d                   	pop    %ebp
  803b23:	c3                   	ret    
  803b24:	39 ce                	cmp    %ecx,%esi
  803b26:	77 28                	ja     803b50 <__udivdi3+0x7c>
  803b28:	0f bd fe             	bsr    %esi,%edi
  803b2b:	83 f7 1f             	xor    $0x1f,%edi
  803b2e:	75 40                	jne    803b70 <__udivdi3+0x9c>
  803b30:	39 ce                	cmp    %ecx,%esi
  803b32:	72 0a                	jb     803b3e <__udivdi3+0x6a>
  803b34:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803b38:	0f 87 9e 00 00 00    	ja     803bdc <__udivdi3+0x108>
  803b3e:	b8 01 00 00 00       	mov    $0x1,%eax
  803b43:	89 fa                	mov    %edi,%edx
  803b45:	83 c4 1c             	add    $0x1c,%esp
  803b48:	5b                   	pop    %ebx
  803b49:	5e                   	pop    %esi
  803b4a:	5f                   	pop    %edi
  803b4b:	5d                   	pop    %ebp
  803b4c:	c3                   	ret    
  803b4d:	8d 76 00             	lea    0x0(%esi),%esi
  803b50:	31 ff                	xor    %edi,%edi
  803b52:	31 c0                	xor    %eax,%eax
  803b54:	89 fa                	mov    %edi,%edx
  803b56:	83 c4 1c             	add    $0x1c,%esp
  803b59:	5b                   	pop    %ebx
  803b5a:	5e                   	pop    %esi
  803b5b:	5f                   	pop    %edi
  803b5c:	5d                   	pop    %ebp
  803b5d:	c3                   	ret    
  803b5e:	66 90                	xchg   %ax,%ax
  803b60:	89 d8                	mov    %ebx,%eax
  803b62:	f7 f7                	div    %edi
  803b64:	31 ff                	xor    %edi,%edi
  803b66:	89 fa                	mov    %edi,%edx
  803b68:	83 c4 1c             	add    $0x1c,%esp
  803b6b:	5b                   	pop    %ebx
  803b6c:	5e                   	pop    %esi
  803b6d:	5f                   	pop    %edi
  803b6e:	5d                   	pop    %ebp
  803b6f:	c3                   	ret    
  803b70:	bd 20 00 00 00       	mov    $0x20,%ebp
  803b75:	89 eb                	mov    %ebp,%ebx
  803b77:	29 fb                	sub    %edi,%ebx
  803b79:	89 f9                	mov    %edi,%ecx
  803b7b:	d3 e6                	shl    %cl,%esi
  803b7d:	89 c5                	mov    %eax,%ebp
  803b7f:	88 d9                	mov    %bl,%cl
  803b81:	d3 ed                	shr    %cl,%ebp
  803b83:	89 e9                	mov    %ebp,%ecx
  803b85:	09 f1                	or     %esi,%ecx
  803b87:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803b8b:	89 f9                	mov    %edi,%ecx
  803b8d:	d3 e0                	shl    %cl,%eax
  803b8f:	89 c5                	mov    %eax,%ebp
  803b91:	89 d6                	mov    %edx,%esi
  803b93:	88 d9                	mov    %bl,%cl
  803b95:	d3 ee                	shr    %cl,%esi
  803b97:	89 f9                	mov    %edi,%ecx
  803b99:	d3 e2                	shl    %cl,%edx
  803b9b:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b9f:	88 d9                	mov    %bl,%cl
  803ba1:	d3 e8                	shr    %cl,%eax
  803ba3:	09 c2                	or     %eax,%edx
  803ba5:	89 d0                	mov    %edx,%eax
  803ba7:	89 f2                	mov    %esi,%edx
  803ba9:	f7 74 24 0c          	divl   0xc(%esp)
  803bad:	89 d6                	mov    %edx,%esi
  803baf:	89 c3                	mov    %eax,%ebx
  803bb1:	f7 e5                	mul    %ebp
  803bb3:	39 d6                	cmp    %edx,%esi
  803bb5:	72 19                	jb     803bd0 <__udivdi3+0xfc>
  803bb7:	74 0b                	je     803bc4 <__udivdi3+0xf0>
  803bb9:	89 d8                	mov    %ebx,%eax
  803bbb:	31 ff                	xor    %edi,%edi
  803bbd:	e9 58 ff ff ff       	jmp    803b1a <__udivdi3+0x46>
  803bc2:	66 90                	xchg   %ax,%ax
  803bc4:	8b 54 24 08          	mov    0x8(%esp),%edx
  803bc8:	89 f9                	mov    %edi,%ecx
  803bca:	d3 e2                	shl    %cl,%edx
  803bcc:	39 c2                	cmp    %eax,%edx
  803bce:	73 e9                	jae    803bb9 <__udivdi3+0xe5>
  803bd0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803bd3:	31 ff                	xor    %edi,%edi
  803bd5:	e9 40 ff ff ff       	jmp    803b1a <__udivdi3+0x46>
  803bda:	66 90                	xchg   %ax,%ax
  803bdc:	31 c0                	xor    %eax,%eax
  803bde:	e9 37 ff ff ff       	jmp    803b1a <__udivdi3+0x46>
  803be3:	90                   	nop

00803be4 <__umoddi3>:
  803be4:	55                   	push   %ebp
  803be5:	57                   	push   %edi
  803be6:	56                   	push   %esi
  803be7:	53                   	push   %ebx
  803be8:	83 ec 1c             	sub    $0x1c,%esp
  803beb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803bef:	8b 74 24 34          	mov    0x34(%esp),%esi
  803bf3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803bf7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803bfb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803bff:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c03:	89 f3                	mov    %esi,%ebx
  803c05:	89 fa                	mov    %edi,%edx
  803c07:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c0b:	89 34 24             	mov    %esi,(%esp)
  803c0e:	85 c0                	test   %eax,%eax
  803c10:	75 1a                	jne    803c2c <__umoddi3+0x48>
  803c12:	39 f7                	cmp    %esi,%edi
  803c14:	0f 86 a2 00 00 00    	jbe    803cbc <__umoddi3+0xd8>
  803c1a:	89 c8                	mov    %ecx,%eax
  803c1c:	89 f2                	mov    %esi,%edx
  803c1e:	f7 f7                	div    %edi
  803c20:	89 d0                	mov    %edx,%eax
  803c22:	31 d2                	xor    %edx,%edx
  803c24:	83 c4 1c             	add    $0x1c,%esp
  803c27:	5b                   	pop    %ebx
  803c28:	5e                   	pop    %esi
  803c29:	5f                   	pop    %edi
  803c2a:	5d                   	pop    %ebp
  803c2b:	c3                   	ret    
  803c2c:	39 f0                	cmp    %esi,%eax
  803c2e:	0f 87 ac 00 00 00    	ja     803ce0 <__umoddi3+0xfc>
  803c34:	0f bd e8             	bsr    %eax,%ebp
  803c37:	83 f5 1f             	xor    $0x1f,%ebp
  803c3a:	0f 84 ac 00 00 00    	je     803cec <__umoddi3+0x108>
  803c40:	bf 20 00 00 00       	mov    $0x20,%edi
  803c45:	29 ef                	sub    %ebp,%edi
  803c47:	89 fe                	mov    %edi,%esi
  803c49:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803c4d:	89 e9                	mov    %ebp,%ecx
  803c4f:	d3 e0                	shl    %cl,%eax
  803c51:	89 d7                	mov    %edx,%edi
  803c53:	89 f1                	mov    %esi,%ecx
  803c55:	d3 ef                	shr    %cl,%edi
  803c57:	09 c7                	or     %eax,%edi
  803c59:	89 e9                	mov    %ebp,%ecx
  803c5b:	d3 e2                	shl    %cl,%edx
  803c5d:	89 14 24             	mov    %edx,(%esp)
  803c60:	89 d8                	mov    %ebx,%eax
  803c62:	d3 e0                	shl    %cl,%eax
  803c64:	89 c2                	mov    %eax,%edx
  803c66:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c6a:	d3 e0                	shl    %cl,%eax
  803c6c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c70:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c74:	89 f1                	mov    %esi,%ecx
  803c76:	d3 e8                	shr    %cl,%eax
  803c78:	09 d0                	or     %edx,%eax
  803c7a:	d3 eb                	shr    %cl,%ebx
  803c7c:	89 da                	mov    %ebx,%edx
  803c7e:	f7 f7                	div    %edi
  803c80:	89 d3                	mov    %edx,%ebx
  803c82:	f7 24 24             	mull   (%esp)
  803c85:	89 c6                	mov    %eax,%esi
  803c87:	89 d1                	mov    %edx,%ecx
  803c89:	39 d3                	cmp    %edx,%ebx
  803c8b:	0f 82 87 00 00 00    	jb     803d18 <__umoddi3+0x134>
  803c91:	0f 84 91 00 00 00    	je     803d28 <__umoddi3+0x144>
  803c97:	8b 54 24 04          	mov    0x4(%esp),%edx
  803c9b:	29 f2                	sub    %esi,%edx
  803c9d:	19 cb                	sbb    %ecx,%ebx
  803c9f:	89 d8                	mov    %ebx,%eax
  803ca1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803ca5:	d3 e0                	shl    %cl,%eax
  803ca7:	89 e9                	mov    %ebp,%ecx
  803ca9:	d3 ea                	shr    %cl,%edx
  803cab:	09 d0                	or     %edx,%eax
  803cad:	89 e9                	mov    %ebp,%ecx
  803caf:	d3 eb                	shr    %cl,%ebx
  803cb1:	89 da                	mov    %ebx,%edx
  803cb3:	83 c4 1c             	add    $0x1c,%esp
  803cb6:	5b                   	pop    %ebx
  803cb7:	5e                   	pop    %esi
  803cb8:	5f                   	pop    %edi
  803cb9:	5d                   	pop    %ebp
  803cba:	c3                   	ret    
  803cbb:	90                   	nop
  803cbc:	89 fd                	mov    %edi,%ebp
  803cbe:	85 ff                	test   %edi,%edi
  803cc0:	75 0b                	jne    803ccd <__umoddi3+0xe9>
  803cc2:	b8 01 00 00 00       	mov    $0x1,%eax
  803cc7:	31 d2                	xor    %edx,%edx
  803cc9:	f7 f7                	div    %edi
  803ccb:	89 c5                	mov    %eax,%ebp
  803ccd:	89 f0                	mov    %esi,%eax
  803ccf:	31 d2                	xor    %edx,%edx
  803cd1:	f7 f5                	div    %ebp
  803cd3:	89 c8                	mov    %ecx,%eax
  803cd5:	f7 f5                	div    %ebp
  803cd7:	89 d0                	mov    %edx,%eax
  803cd9:	e9 44 ff ff ff       	jmp    803c22 <__umoddi3+0x3e>
  803cde:	66 90                	xchg   %ax,%ax
  803ce0:	89 c8                	mov    %ecx,%eax
  803ce2:	89 f2                	mov    %esi,%edx
  803ce4:	83 c4 1c             	add    $0x1c,%esp
  803ce7:	5b                   	pop    %ebx
  803ce8:	5e                   	pop    %esi
  803ce9:	5f                   	pop    %edi
  803cea:	5d                   	pop    %ebp
  803ceb:	c3                   	ret    
  803cec:	3b 04 24             	cmp    (%esp),%eax
  803cef:	72 06                	jb     803cf7 <__umoddi3+0x113>
  803cf1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803cf5:	77 0f                	ja     803d06 <__umoddi3+0x122>
  803cf7:	89 f2                	mov    %esi,%edx
  803cf9:	29 f9                	sub    %edi,%ecx
  803cfb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803cff:	89 14 24             	mov    %edx,(%esp)
  803d02:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d06:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d0a:	8b 14 24             	mov    (%esp),%edx
  803d0d:	83 c4 1c             	add    $0x1c,%esp
  803d10:	5b                   	pop    %ebx
  803d11:	5e                   	pop    %esi
  803d12:	5f                   	pop    %edi
  803d13:	5d                   	pop    %ebp
  803d14:	c3                   	ret    
  803d15:	8d 76 00             	lea    0x0(%esi),%esi
  803d18:	2b 04 24             	sub    (%esp),%eax
  803d1b:	19 fa                	sbb    %edi,%edx
  803d1d:	89 d1                	mov    %edx,%ecx
  803d1f:	89 c6                	mov    %eax,%esi
  803d21:	e9 71 ff ff ff       	jmp    803c97 <__umoddi3+0xb3>
  803d26:	66 90                	xchg   %ax,%ax
  803d28:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803d2c:	72 ea                	jb     803d18 <__umoddi3+0x134>
  803d2e:	89 d9                	mov    %ebx,%ecx
  803d30:	e9 62 ff ff ff       	jmp    803c97 <__umoddi3+0xb3>
