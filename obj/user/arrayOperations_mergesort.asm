
obj/user/arrayOperations_mergesort:     file format elf32-i386


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
  800031:	e8 c9 04 00 00       	call   8004ff <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

//int *Left;
//int *Right;

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 38             	sub    $0x38,%esp
	int32 parentenvID = sys_getparentenvid();
  80003e:	e8 3c 1e 00 00       	call   801e7f <sys_getparentenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int ret;

	/*[1] GET SEMAPHORES*/
	struct semaphore ready = get_semaphore(parentenvID, "Ready");
  800046:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800049:	83 ec 04             	sub    $0x4,%esp
  80004c:	68 a0 3a 80 00       	push   $0x803aa0
  800051:	ff 75 f0             	pushl  -0x10(%ebp)
  800054:	50                   	push   %eax
  800055:	e8 d2 34 00 00       	call   80352c <get_semaphore>
  80005a:	83 c4 0c             	add    $0xc,%esp
	struct semaphore finished = get_semaphore(parentenvID, "Finished");
  80005d:	8d 45 d8             	lea    -0x28(%ebp),%eax
  800060:	83 ec 04             	sub    $0x4,%esp
  800063:	68 a6 3a 80 00       	push   $0x803aa6
  800068:	ff 75 f0             	pushl  -0x10(%ebp)
  80006b:	50                   	push   %eax
  80006c:	e8 bb 34 00 00       	call   80352c <get_semaphore>
  800071:	83 c4 0c             	add    $0xc,%esp

	/*[2] WAIT A READY SIGNAL FROM THE MASTER*/
	wait_semaphore(ready);
  800074:	83 ec 0c             	sub    $0xc,%esp
  800077:	ff 75 dc             	pushl  -0x24(%ebp)
  80007a:	e8 f6 34 00 00       	call   803575 <wait_semaphore>
  80007f:	83 c4 10             	add    $0x10,%esp

	/*[3] GET SHARED VARs*/
	//Get the cons_mutex ownerID
	int* consMutexOwnerID = sget(parentenvID, "cons_mutex ownerID") ;
  800082:	83 ec 08             	sub    $0x8,%esp
  800085:	68 af 3a 80 00       	push   $0x803aaf
  80008a:	ff 75 f0             	pushl  -0x10(%ebp)
  80008d:	e8 88 18 00 00       	call   80191a <sget>
  800092:	83 c4 10             	add    $0x10,%esp
  800095:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct semaphore cons_mutex = get_semaphore(*consMutexOwnerID, "Console Mutex");
  800098:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80009b:	8b 10                	mov    (%eax),%edx
  80009d:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  8000a0:	83 ec 04             	sub    $0x4,%esp
  8000a3:	68 c2 3a 80 00       	push   $0x803ac2
  8000a8:	52                   	push   %edx
  8000a9:	50                   	push   %eax
  8000aa:	e8 7d 34 00 00       	call   80352c <get_semaphore>
  8000af:	83 c4 0c             	add    $0xc,%esp

	//Get the shared array & its size
	int *numOfElements = NULL;
  8000b2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	int *sharedArray = NULL;
  8000b9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	sharedArray = sget(parentenvID, "arr") ;
  8000c0:	83 ec 08             	sub    $0x8,%esp
  8000c3:	68 d0 3a 80 00       	push   $0x803ad0
  8000c8:	ff 75 f0             	pushl  -0x10(%ebp)
  8000cb:	e8 4a 18 00 00       	call   80191a <sget>
  8000d0:	83 c4 10             	add    $0x10,%esp
  8000d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	numOfElements = sget(parentenvID, "arrSize") ;
  8000d6:	83 ec 08             	sub    $0x8,%esp
  8000d9:	68 d4 3a 80 00       	push   $0x803ad4
  8000de:	ff 75 f0             	pushl  -0x10(%ebp)
  8000e1:	e8 34 18 00 00       	call   80191a <sget>
  8000e6:	83 c4 10             	add    $0x10,%esp
  8000e9:	89 45 e8             	mov    %eax,-0x18(%ebp)

	/*[4] DO THE JOB*/
	//take a copy from the original array
	int *sortedArray;

	sortedArray = smalloc("mergesortedArr", sizeof(int) * *numOfElements, 0) ;
  8000ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000ef:	8b 00                	mov    (%eax),%eax
  8000f1:	c1 e0 02             	shl    $0x2,%eax
  8000f4:	83 ec 04             	sub    $0x4,%esp
  8000f7:	6a 00                	push   $0x0
  8000f9:	50                   	push   %eax
  8000fa:	68 dc 3a 80 00       	push   $0x803adc
  8000ff:	e8 7b 16 00 00       	call   80177f <smalloc>
  800104:	83 c4 10             	add    $0x10,%esp
  800107:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  80010a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800111:	eb 25                	jmp    800138 <_main+0x100>
	{
		sortedArray[i] = sharedArray[i];
  800113:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800116:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80011d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800120:	01 c2                	add    %eax,%edx
  800122:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800125:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80012c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80012f:	01 c8                	add    %ecx,%eax
  800131:	8b 00                	mov    (%eax),%eax
  800133:	89 02                	mov    %eax,(%edx)
	//take a copy from the original array
	int *sortedArray;

	sortedArray = smalloc("mergesortedArr", sizeof(int) * *numOfElements, 0) ;
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  800135:	ff 45 f4             	incl   -0xc(%ebp)
  800138:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80013b:	8b 00                	mov    (%eax),%eax
  80013d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800140:	7f d1                	jg     800113 <_main+0xdb>
	}
//	//Create two temps array for "left" & "right"
//	Left = smalloc("mergesortLeftArr", sizeof(int) * (*numOfElements), 1) ;
//	Right = smalloc("mergesortRightArr", sizeof(int) * (*numOfElements), 1) ;

	MSort(sortedArray, 1, *numOfElements);
  800142:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800145:	8b 00                	mov    (%eax),%eax
  800147:	83 ec 04             	sub    $0x4,%esp
  80014a:	50                   	push   %eax
  80014b:	6a 01                	push   $0x1
  80014d:	ff 75 e0             	pushl  -0x20(%ebp)
  800150:	e8 39 01 00 00       	call   80028e <MSort>
  800155:	83 c4 10             	add    $0x10,%esp

	wait_semaphore(cons_mutex);
  800158:	83 ec 0c             	sub    $0xc,%esp
  80015b:	ff 75 d4             	pushl  -0x2c(%ebp)
  80015e:	e8 12 34 00 00       	call   803575 <wait_semaphore>
  800163:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("Merge sort is Finished!!!!\n") ;
  800166:	83 ec 0c             	sub    $0xc,%esp
  800169:	68 eb 3a 80 00       	push   $0x803aeb
  80016e:	e8 a5 05 00 00       	call   800718 <cprintf>
  800173:	83 c4 10             	add    $0x10,%esp
		cprintf("will notify the master now...\n");
  800176:	83 ec 0c             	sub    $0xc,%esp
  800179:	68 08 3b 80 00       	push   $0x803b08
  80017e:	e8 95 05 00 00       	call   800718 <cprintf>
  800183:	83 c4 10             	add    $0x10,%esp
		cprintf("Merge sort says GOOD BYE :)\n") ;
  800186:	83 ec 0c             	sub    $0xc,%esp
  800189:	68 27 3b 80 00       	push   $0x803b27
  80018e:	e8 85 05 00 00       	call   800718 <cprintf>
  800193:	83 c4 10             	add    $0x10,%esp
	}
	signal_semaphore(cons_mutex);
  800196:	83 ec 0c             	sub    $0xc,%esp
  800199:	ff 75 d4             	pushl  -0x2c(%ebp)
  80019c:	e8 3e 34 00 00       	call   8035df <signal_semaphore>
  8001a1:	83 c4 10             	add    $0x10,%esp

	/*[5] DECLARE FINISHING*/
	signal_semaphore(finished);
  8001a4:	83 ec 0c             	sub    $0xc,%esp
  8001a7:	ff 75 d8             	pushl  -0x28(%ebp)
  8001aa:	e8 30 34 00 00       	call   8035df <signal_semaphore>
  8001af:	83 c4 10             	add    $0x10,%esp
}
  8001b2:	90                   	nop
  8001b3:	c9                   	leave  
  8001b4:	c3                   	ret    

008001b5 <Swap>:

void Swap(int *Elements, int First, int Second)
{
  8001b5:	55                   	push   %ebp
  8001b6:	89 e5                	mov    %esp,%ebp
  8001b8:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  8001bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001be:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8001c8:	01 d0                	add    %edx,%eax
  8001ca:	8b 00                	mov    (%eax),%eax
  8001cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  8001cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8001dc:	01 c2                	add    %eax,%edx
  8001de:	8b 45 10             	mov    0x10(%ebp),%eax
  8001e1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8001e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8001eb:	01 c8                	add    %ecx,%eax
  8001ed:	8b 00                	mov    (%eax),%eax
  8001ef:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  8001f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8001f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8001fe:	01 c2                	add    %eax,%edx
  800200:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800203:	89 02                	mov    %eax,(%edx)
}
  800205:	90                   	nop
  800206:	c9                   	leave  
  800207:	c3                   	ret    

00800208 <PrintElements>:


void PrintElements(int *Elements, int NumOfElements)
{
  800208:	55                   	push   %ebp
  800209:	89 e5                	mov    %esp,%ebp
  80020b:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  80020e:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800215:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80021c:	eb 42                	jmp    800260 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  80021e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800221:	99                   	cltd   
  800222:	f7 7d f0             	idivl  -0x10(%ebp)
  800225:	89 d0                	mov    %edx,%eax
  800227:	85 c0                	test   %eax,%eax
  800229:	75 10                	jne    80023b <PrintElements+0x33>
			cprintf("\n");
  80022b:	83 ec 0c             	sub    $0xc,%esp
  80022e:	68 44 3b 80 00       	push   $0x803b44
  800233:	e8 e0 04 00 00       	call   800718 <cprintf>
  800238:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  80023b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80023e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800245:	8b 45 08             	mov    0x8(%ebp),%eax
  800248:	01 d0                	add    %edx,%eax
  80024a:	8b 00                	mov    (%eax),%eax
  80024c:	83 ec 08             	sub    $0x8,%esp
  80024f:	50                   	push   %eax
  800250:	68 46 3b 80 00       	push   $0x803b46
  800255:	e8 be 04 00 00       	call   800718 <cprintf>
  80025a:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80025d:	ff 45 f4             	incl   -0xc(%ebp)
  800260:	8b 45 0c             	mov    0xc(%ebp),%eax
  800263:	48                   	dec    %eax
  800264:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800267:	7f b5                	jg     80021e <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800269:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80026c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800273:	8b 45 08             	mov    0x8(%ebp),%eax
  800276:	01 d0                	add    %edx,%eax
  800278:	8b 00                	mov    (%eax),%eax
  80027a:	83 ec 08             	sub    $0x8,%esp
  80027d:	50                   	push   %eax
  80027e:	68 4b 3b 80 00       	push   $0x803b4b
  800283:	e8 90 04 00 00       	call   800718 <cprintf>
  800288:	83 c4 10             	add    $0x10,%esp

}
  80028b:	90                   	nop
  80028c:	c9                   	leave  
  80028d:	c3                   	ret    

0080028e <MSort>:


void MSort(int* A, int p, int r)
{
  80028e:	55                   	push   %ebp
  80028f:	89 e5                	mov    %esp,%ebp
  800291:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  800294:	8b 45 0c             	mov    0xc(%ebp),%eax
  800297:	3b 45 10             	cmp    0x10(%ebp),%eax
  80029a:	7d 54                	jge    8002f0 <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  80029c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80029f:	8b 45 10             	mov    0x10(%ebp),%eax
  8002a2:	01 d0                	add    %edx,%eax
  8002a4:	89 c2                	mov    %eax,%edx
  8002a6:	c1 ea 1f             	shr    $0x1f,%edx
  8002a9:	01 d0                	add    %edx,%eax
  8002ab:	d1 f8                	sar    %eax
  8002ad:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  8002b0:	83 ec 04             	sub    $0x4,%esp
  8002b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8002b6:	ff 75 0c             	pushl  0xc(%ebp)
  8002b9:	ff 75 08             	pushl  0x8(%ebp)
  8002bc:	e8 cd ff ff ff       	call   80028e <MSort>
  8002c1:	83 c4 10             	add    $0x10,%esp
//	cprintf("LEFT is sorted: from %d to %d\n", p, q);

	MSort(A, q + 1, r);
  8002c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002c7:	40                   	inc    %eax
  8002c8:	83 ec 04             	sub    $0x4,%esp
  8002cb:	ff 75 10             	pushl  0x10(%ebp)
  8002ce:	50                   	push   %eax
  8002cf:	ff 75 08             	pushl  0x8(%ebp)
  8002d2:	e8 b7 ff ff ff       	call   80028e <MSort>
  8002d7:	83 c4 10             	add    $0x10,%esp
//	cprintf("RIGHT is sorted: from %d to %d\n", q+1, r);

	Merge(A, p, q, r);
  8002da:	ff 75 10             	pushl  0x10(%ebp)
  8002dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8002e0:	ff 75 0c             	pushl  0xc(%ebp)
  8002e3:	ff 75 08             	pushl  0x8(%ebp)
  8002e6:	e8 08 00 00 00       	call   8002f3 <Merge>
  8002eb:	83 c4 10             	add    $0x10,%esp
  8002ee:	eb 01                	jmp    8002f1 <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  8002f0:	90                   	nop
//	cprintf("RIGHT is sorted: from %d to %d\n", q+1, r);

	Merge(A, p, q, r);
	//cprintf("[%d %d] + [%d %d] = [%d %d]\n", p, q, q+1, r, p, r);

}
  8002f1:	c9                   	leave  
  8002f2:	c3                   	ret    

008002f3 <Merge>:

void Merge(int* A, int p, int q, int r)
{
  8002f3:	55                   	push   %ebp
  8002f4:	89 e5                	mov    %esp,%ebp
  8002f6:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  8002f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8002fc:	2b 45 0c             	sub    0xc(%ebp),%eax
  8002ff:	40                   	inc    %eax
  800300:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  800303:	8b 45 14             	mov    0x14(%ebp),%eax
  800306:	2b 45 10             	sub    0x10(%ebp),%eax
  800309:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  80030c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  800313:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int* Left = malloc(sizeof(int) * leftCapacity);
  80031a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80031d:	c1 e0 02             	shl    $0x2,%eax
  800320:	83 ec 0c             	sub    $0xc,%esp
  800323:	50                   	push   %eax
  800324:	e8 9f 11 00 00       	call   8014c8 <malloc>
  800329:	83 c4 10             	add    $0x10,%esp
  80032c:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  80032f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800332:	c1 e0 02             	shl    $0x2,%eax
  800335:	83 ec 0c             	sub    $0xc,%esp
  800338:	50                   	push   %eax
  800339:	e8 8a 11 00 00       	call   8014c8 <malloc>
  80033e:	83 c4 10             	add    $0x10,%esp
  800341:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  800344:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80034b:	eb 2f                	jmp    80037c <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  80034d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800350:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800357:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80035a:	01 c2                	add    %eax,%edx
  80035c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80035f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800362:	01 c8                	add    %ecx,%eax
  800364:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800369:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800370:	8b 45 08             	mov    0x8(%ebp),%eax
  800373:	01 c8                	add    %ecx,%eax
  800375:	8b 00                	mov    (%eax),%eax
  800377:	89 02                	mov    %eax,(%edx)
	int* Left = malloc(sizeof(int) * leftCapacity);

	int* Right = malloc(sizeof(int) * rightCapacity);

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  800379:	ff 45 ec             	incl   -0x14(%ebp)
  80037c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80037f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800382:	7c c9                	jl     80034d <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  800384:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80038b:	eb 2a                	jmp    8003b7 <Merge+0xc4>
	{
		Right[j] = A[q + j];
  80038d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800390:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800397:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80039a:	01 c2                	add    %eax,%edx
  80039c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80039f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003a2:	01 c8                	add    %ecx,%eax
  8003a4:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ae:	01 c8                	add    %ecx,%eax
  8003b0:	8b 00                	mov    (%eax),%eax
  8003b2:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8003b4:	ff 45 e8             	incl   -0x18(%ebp)
  8003b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003ba:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8003bd:	7c ce                	jl     80038d <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8003bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003c5:	e9 0a 01 00 00       	jmp    8004d4 <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  8003ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003cd:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8003d0:	0f 8d 95 00 00 00    	jge    80046b <Merge+0x178>
  8003d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003d9:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8003dc:	0f 8d 89 00 00 00    	jge    80046b <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8003e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003e5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003ec:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003ef:	01 d0                	add    %edx,%eax
  8003f1:	8b 10                	mov    (%eax),%edx
  8003f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003fd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800400:	01 c8                	add    %ecx,%eax
  800402:	8b 00                	mov    (%eax),%eax
  800404:	39 c2                	cmp    %eax,%edx
  800406:	7d 33                	jge    80043b <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  800408:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80040b:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800410:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800417:	8b 45 08             	mov    0x8(%ebp),%eax
  80041a:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80041d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800420:	8d 50 01             	lea    0x1(%eax),%edx
  800423:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800426:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80042d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800430:	01 d0                	add    %edx,%eax
  800432:	8b 00                	mov    (%eax),%eax
  800434:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800436:	e9 96 00 00 00       	jmp    8004d1 <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  80043b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80043e:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800443:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80044a:	8b 45 08             	mov    0x8(%ebp),%eax
  80044d:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800450:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800453:	8d 50 01             	lea    0x1(%eax),%edx
  800456:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800459:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800460:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800463:	01 d0                	add    %edx,%eax
  800465:	8b 00                	mov    (%eax),%eax
  800467:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800469:	eb 66                	jmp    8004d1 <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  80046b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80046e:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800471:	7d 30                	jge    8004a3 <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  800473:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800476:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80047b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800482:	8b 45 08             	mov    0x8(%ebp),%eax
  800485:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800488:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80048b:	8d 50 01             	lea    0x1(%eax),%edx
  80048e:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800491:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800498:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80049b:	01 d0                	add    %edx,%eax
  80049d:	8b 00                	mov    (%eax),%eax
  80049f:	89 01                	mov    %eax,(%ecx)
  8004a1:	eb 2e                	jmp    8004d1 <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  8004a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004a6:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8004ab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b5:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8004b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004bb:	8d 50 01             	lea    0x1(%eax),%edx
  8004be:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8004c1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004cb:	01 d0                	add    %edx,%eax
  8004cd:	8b 00                	mov    (%eax),%eax
  8004cf:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8004d1:	ff 45 e4             	incl   -0x1c(%ebp)
  8004d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004d7:	3b 45 14             	cmp    0x14(%ebp),%eax
  8004da:	0f 8e ea fe ff ff    	jle    8003ca <Merge+0xd7>
		{
			A[k - 1] = Right[rightIndex++];
		}
	}

	free(Left);
  8004e0:	83 ec 0c             	sub    $0xc,%esp
  8004e3:	ff 75 d8             	pushl  -0x28(%ebp)
  8004e6:	e8 93 11 00 00       	call   80167e <free>
  8004eb:	83 c4 10             	add    $0x10,%esp
	free(Right);
  8004ee:	83 ec 0c             	sub    $0xc,%esp
  8004f1:	ff 75 d4             	pushl  -0x2c(%ebp)
  8004f4:	e8 85 11 00 00       	call   80167e <free>
  8004f9:	83 c4 10             	add    $0x10,%esp

}
  8004fc:	90                   	nop
  8004fd:	c9                   	leave  
  8004fe:	c3                   	ret    

008004ff <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8004ff:	55                   	push   %ebp
  800500:	89 e5                	mov    %esp,%ebp
  800502:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800505:	e8 5c 19 00 00       	call   801e66 <sys_getenvindex>
  80050a:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80050d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800510:	89 d0                	mov    %edx,%eax
  800512:	c1 e0 02             	shl    $0x2,%eax
  800515:	01 d0                	add    %edx,%eax
  800517:	c1 e0 03             	shl    $0x3,%eax
  80051a:	01 d0                	add    %edx,%eax
  80051c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800523:	01 d0                	add    %edx,%eax
  800525:	c1 e0 02             	shl    $0x2,%eax
  800528:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80052d:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800532:	a1 20 50 80 00       	mov    0x805020,%eax
  800537:	8a 40 20             	mov    0x20(%eax),%al
  80053a:	84 c0                	test   %al,%al
  80053c:	74 0d                	je     80054b <libmain+0x4c>
		binaryname = myEnv->prog_name;
  80053e:	a1 20 50 80 00       	mov    0x805020,%eax
  800543:	83 c0 20             	add    $0x20,%eax
  800546:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80054b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80054f:	7e 0a                	jle    80055b <libmain+0x5c>
		binaryname = argv[0];
  800551:	8b 45 0c             	mov    0xc(%ebp),%eax
  800554:	8b 00                	mov    (%eax),%eax
  800556:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  80055b:	83 ec 08             	sub    $0x8,%esp
  80055e:	ff 75 0c             	pushl  0xc(%ebp)
  800561:	ff 75 08             	pushl  0x8(%ebp)
  800564:	e8 cf fa ff ff       	call   800038 <_main>
  800569:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80056c:	a1 00 50 80 00       	mov    0x805000,%eax
  800571:	85 c0                	test   %eax,%eax
  800573:	0f 84 9f 00 00 00    	je     800618 <libmain+0x119>
	{
		sys_lock_cons();
  800579:	e8 6c 16 00 00       	call   801bea <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80057e:	83 ec 0c             	sub    $0xc,%esp
  800581:	68 68 3b 80 00       	push   $0x803b68
  800586:	e8 8d 01 00 00       	call   800718 <cprintf>
  80058b:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80058e:	a1 20 50 80 00       	mov    0x805020,%eax
  800593:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800599:	a1 20 50 80 00       	mov    0x805020,%eax
  80059e:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8005a4:	83 ec 04             	sub    $0x4,%esp
  8005a7:	52                   	push   %edx
  8005a8:	50                   	push   %eax
  8005a9:	68 90 3b 80 00       	push   $0x803b90
  8005ae:	e8 65 01 00 00       	call   800718 <cprintf>
  8005b3:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8005b6:	a1 20 50 80 00       	mov    0x805020,%eax
  8005bb:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8005c1:	a1 20 50 80 00       	mov    0x805020,%eax
  8005c6:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8005cc:	a1 20 50 80 00       	mov    0x805020,%eax
  8005d1:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  8005d7:	51                   	push   %ecx
  8005d8:	52                   	push   %edx
  8005d9:	50                   	push   %eax
  8005da:	68 b8 3b 80 00       	push   $0x803bb8
  8005df:	e8 34 01 00 00       	call   800718 <cprintf>
  8005e4:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8005e7:	a1 20 50 80 00       	mov    0x805020,%eax
  8005ec:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8005f2:	83 ec 08             	sub    $0x8,%esp
  8005f5:	50                   	push   %eax
  8005f6:	68 10 3c 80 00       	push   $0x803c10
  8005fb:	e8 18 01 00 00       	call   800718 <cprintf>
  800600:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800603:	83 ec 0c             	sub    $0xc,%esp
  800606:	68 68 3b 80 00       	push   $0x803b68
  80060b:	e8 08 01 00 00       	call   800718 <cprintf>
  800610:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800613:	e8 ec 15 00 00       	call   801c04 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800618:	e8 19 00 00 00       	call   800636 <exit>
}
  80061d:	90                   	nop
  80061e:	c9                   	leave  
  80061f:	c3                   	ret    

00800620 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800620:	55                   	push   %ebp
  800621:	89 e5                	mov    %esp,%ebp
  800623:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800626:	83 ec 0c             	sub    $0xc,%esp
  800629:	6a 00                	push   $0x0
  80062b:	e8 02 18 00 00       	call   801e32 <sys_destroy_env>
  800630:	83 c4 10             	add    $0x10,%esp
}
  800633:	90                   	nop
  800634:	c9                   	leave  
  800635:	c3                   	ret    

00800636 <exit>:

void
exit(void)
{
  800636:	55                   	push   %ebp
  800637:	89 e5                	mov    %esp,%ebp
  800639:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80063c:	e8 57 18 00 00       	call   801e98 <sys_exit_env>
}
  800641:	90                   	nop
  800642:	c9                   	leave  
  800643:	c3                   	ret    

00800644 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800644:	55                   	push   %ebp
  800645:	89 e5                	mov    %esp,%ebp
  800647:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80064a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80064d:	8b 00                	mov    (%eax),%eax
  80064f:	8d 48 01             	lea    0x1(%eax),%ecx
  800652:	8b 55 0c             	mov    0xc(%ebp),%edx
  800655:	89 0a                	mov    %ecx,(%edx)
  800657:	8b 55 08             	mov    0x8(%ebp),%edx
  80065a:	88 d1                	mov    %dl,%cl
  80065c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80065f:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800663:	8b 45 0c             	mov    0xc(%ebp),%eax
  800666:	8b 00                	mov    (%eax),%eax
  800668:	3d ff 00 00 00       	cmp    $0xff,%eax
  80066d:	75 2c                	jne    80069b <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80066f:	a0 44 50 98 00       	mov    0x985044,%al
  800674:	0f b6 c0             	movzbl %al,%eax
  800677:	8b 55 0c             	mov    0xc(%ebp),%edx
  80067a:	8b 12                	mov    (%edx),%edx
  80067c:	89 d1                	mov    %edx,%ecx
  80067e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800681:	83 c2 08             	add    $0x8,%edx
  800684:	83 ec 04             	sub    $0x4,%esp
  800687:	50                   	push   %eax
  800688:	51                   	push   %ecx
  800689:	52                   	push   %edx
  80068a:	e8 19 15 00 00       	call   801ba8 <sys_cputs>
  80068f:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800692:	8b 45 0c             	mov    0xc(%ebp),%eax
  800695:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80069b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80069e:	8b 40 04             	mov    0x4(%eax),%eax
  8006a1:	8d 50 01             	lea    0x1(%eax),%edx
  8006a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006a7:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006aa:	90                   	nop
  8006ab:	c9                   	leave  
  8006ac:	c3                   	ret    

008006ad <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006ad:	55                   	push   %ebp
  8006ae:	89 e5                	mov    %esp,%ebp
  8006b0:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006b6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006bd:	00 00 00 
	b.cnt = 0;
  8006c0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006c7:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006ca:	ff 75 0c             	pushl  0xc(%ebp)
  8006cd:	ff 75 08             	pushl  0x8(%ebp)
  8006d0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006d6:	50                   	push   %eax
  8006d7:	68 44 06 80 00       	push   $0x800644
  8006dc:	e8 11 02 00 00       	call   8008f2 <vprintfmt>
  8006e1:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8006e4:	a0 44 50 98 00       	mov    0x985044,%al
  8006e9:	0f b6 c0             	movzbl %al,%eax
  8006ec:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8006f2:	83 ec 04             	sub    $0x4,%esp
  8006f5:	50                   	push   %eax
  8006f6:	52                   	push   %edx
  8006f7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006fd:	83 c0 08             	add    $0x8,%eax
  800700:	50                   	push   %eax
  800701:	e8 a2 14 00 00       	call   801ba8 <sys_cputs>
  800706:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800709:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
	return b.cnt;
  800710:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800716:	c9                   	leave  
  800717:	c3                   	ret    

00800718 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800718:	55                   	push   %ebp
  800719:	89 e5                	mov    %esp,%ebp
  80071b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80071e:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
	va_start(ap, fmt);
  800725:	8d 45 0c             	lea    0xc(%ebp),%eax
  800728:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80072b:	8b 45 08             	mov    0x8(%ebp),%eax
  80072e:	83 ec 08             	sub    $0x8,%esp
  800731:	ff 75 f4             	pushl  -0xc(%ebp)
  800734:	50                   	push   %eax
  800735:	e8 73 ff ff ff       	call   8006ad <vcprintf>
  80073a:	83 c4 10             	add    $0x10,%esp
  80073d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800740:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800743:	c9                   	leave  
  800744:	c3                   	ret    

00800745 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800745:	55                   	push   %ebp
  800746:	89 e5                	mov    %esp,%ebp
  800748:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80074b:	e8 9a 14 00 00       	call   801bea <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800750:	8d 45 0c             	lea    0xc(%ebp),%eax
  800753:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800756:	8b 45 08             	mov    0x8(%ebp),%eax
  800759:	83 ec 08             	sub    $0x8,%esp
  80075c:	ff 75 f4             	pushl  -0xc(%ebp)
  80075f:	50                   	push   %eax
  800760:	e8 48 ff ff ff       	call   8006ad <vcprintf>
  800765:	83 c4 10             	add    $0x10,%esp
  800768:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80076b:	e8 94 14 00 00       	call   801c04 <sys_unlock_cons>
	return cnt;
  800770:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800773:	c9                   	leave  
  800774:	c3                   	ret    

00800775 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800775:	55                   	push   %ebp
  800776:	89 e5                	mov    %esp,%ebp
  800778:	53                   	push   %ebx
  800779:	83 ec 14             	sub    $0x14,%esp
  80077c:	8b 45 10             	mov    0x10(%ebp),%eax
  80077f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800782:	8b 45 14             	mov    0x14(%ebp),%eax
  800785:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800788:	8b 45 18             	mov    0x18(%ebp),%eax
  80078b:	ba 00 00 00 00       	mov    $0x0,%edx
  800790:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800793:	77 55                	ja     8007ea <printnum+0x75>
  800795:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800798:	72 05                	jb     80079f <printnum+0x2a>
  80079a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80079d:	77 4b                	ja     8007ea <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80079f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007a2:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007a5:	8b 45 18             	mov    0x18(%ebp),%eax
  8007a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ad:	52                   	push   %edx
  8007ae:	50                   	push   %eax
  8007af:	ff 75 f4             	pushl  -0xc(%ebp)
  8007b2:	ff 75 f0             	pushl  -0x10(%ebp)
  8007b5:	e8 7e 30 00 00       	call   803838 <__udivdi3>
  8007ba:	83 c4 10             	add    $0x10,%esp
  8007bd:	83 ec 04             	sub    $0x4,%esp
  8007c0:	ff 75 20             	pushl  0x20(%ebp)
  8007c3:	53                   	push   %ebx
  8007c4:	ff 75 18             	pushl  0x18(%ebp)
  8007c7:	52                   	push   %edx
  8007c8:	50                   	push   %eax
  8007c9:	ff 75 0c             	pushl  0xc(%ebp)
  8007cc:	ff 75 08             	pushl  0x8(%ebp)
  8007cf:	e8 a1 ff ff ff       	call   800775 <printnum>
  8007d4:	83 c4 20             	add    $0x20,%esp
  8007d7:	eb 1a                	jmp    8007f3 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8007d9:	83 ec 08             	sub    $0x8,%esp
  8007dc:	ff 75 0c             	pushl  0xc(%ebp)
  8007df:	ff 75 20             	pushl  0x20(%ebp)
  8007e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e5:	ff d0                	call   *%eax
  8007e7:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007ea:	ff 4d 1c             	decl   0x1c(%ebp)
  8007ed:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8007f1:	7f e6                	jg     8007d9 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007f3:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8007f6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800801:	53                   	push   %ebx
  800802:	51                   	push   %ecx
  800803:	52                   	push   %edx
  800804:	50                   	push   %eax
  800805:	e8 3e 31 00 00       	call   803948 <__umoddi3>
  80080a:	83 c4 10             	add    $0x10,%esp
  80080d:	05 54 3e 80 00       	add    $0x803e54,%eax
  800812:	8a 00                	mov    (%eax),%al
  800814:	0f be c0             	movsbl %al,%eax
  800817:	83 ec 08             	sub    $0x8,%esp
  80081a:	ff 75 0c             	pushl  0xc(%ebp)
  80081d:	50                   	push   %eax
  80081e:	8b 45 08             	mov    0x8(%ebp),%eax
  800821:	ff d0                	call   *%eax
  800823:	83 c4 10             	add    $0x10,%esp
}
  800826:	90                   	nop
  800827:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80082a:	c9                   	leave  
  80082b:	c3                   	ret    

0080082c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80082c:	55                   	push   %ebp
  80082d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80082f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800833:	7e 1c                	jle    800851 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800835:	8b 45 08             	mov    0x8(%ebp),%eax
  800838:	8b 00                	mov    (%eax),%eax
  80083a:	8d 50 08             	lea    0x8(%eax),%edx
  80083d:	8b 45 08             	mov    0x8(%ebp),%eax
  800840:	89 10                	mov    %edx,(%eax)
  800842:	8b 45 08             	mov    0x8(%ebp),%eax
  800845:	8b 00                	mov    (%eax),%eax
  800847:	83 e8 08             	sub    $0x8,%eax
  80084a:	8b 50 04             	mov    0x4(%eax),%edx
  80084d:	8b 00                	mov    (%eax),%eax
  80084f:	eb 40                	jmp    800891 <getuint+0x65>
	else if (lflag)
  800851:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800855:	74 1e                	je     800875 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800857:	8b 45 08             	mov    0x8(%ebp),%eax
  80085a:	8b 00                	mov    (%eax),%eax
  80085c:	8d 50 04             	lea    0x4(%eax),%edx
  80085f:	8b 45 08             	mov    0x8(%ebp),%eax
  800862:	89 10                	mov    %edx,(%eax)
  800864:	8b 45 08             	mov    0x8(%ebp),%eax
  800867:	8b 00                	mov    (%eax),%eax
  800869:	83 e8 04             	sub    $0x4,%eax
  80086c:	8b 00                	mov    (%eax),%eax
  80086e:	ba 00 00 00 00       	mov    $0x0,%edx
  800873:	eb 1c                	jmp    800891 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800875:	8b 45 08             	mov    0x8(%ebp),%eax
  800878:	8b 00                	mov    (%eax),%eax
  80087a:	8d 50 04             	lea    0x4(%eax),%edx
  80087d:	8b 45 08             	mov    0x8(%ebp),%eax
  800880:	89 10                	mov    %edx,(%eax)
  800882:	8b 45 08             	mov    0x8(%ebp),%eax
  800885:	8b 00                	mov    (%eax),%eax
  800887:	83 e8 04             	sub    $0x4,%eax
  80088a:	8b 00                	mov    (%eax),%eax
  80088c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800891:	5d                   	pop    %ebp
  800892:	c3                   	ret    

00800893 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800893:	55                   	push   %ebp
  800894:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800896:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80089a:	7e 1c                	jle    8008b8 <getint+0x25>
		return va_arg(*ap, long long);
  80089c:	8b 45 08             	mov    0x8(%ebp),%eax
  80089f:	8b 00                	mov    (%eax),%eax
  8008a1:	8d 50 08             	lea    0x8(%eax),%edx
  8008a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a7:	89 10                	mov    %edx,(%eax)
  8008a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ac:	8b 00                	mov    (%eax),%eax
  8008ae:	83 e8 08             	sub    $0x8,%eax
  8008b1:	8b 50 04             	mov    0x4(%eax),%edx
  8008b4:	8b 00                	mov    (%eax),%eax
  8008b6:	eb 38                	jmp    8008f0 <getint+0x5d>
	else if (lflag)
  8008b8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008bc:	74 1a                	je     8008d8 <getint+0x45>
		return va_arg(*ap, long);
  8008be:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c1:	8b 00                	mov    (%eax),%eax
  8008c3:	8d 50 04             	lea    0x4(%eax),%edx
  8008c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c9:	89 10                	mov    %edx,(%eax)
  8008cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ce:	8b 00                	mov    (%eax),%eax
  8008d0:	83 e8 04             	sub    $0x4,%eax
  8008d3:	8b 00                	mov    (%eax),%eax
  8008d5:	99                   	cltd   
  8008d6:	eb 18                	jmp    8008f0 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8008d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008db:	8b 00                	mov    (%eax),%eax
  8008dd:	8d 50 04             	lea    0x4(%eax),%edx
  8008e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e3:	89 10                	mov    %edx,(%eax)
  8008e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e8:	8b 00                	mov    (%eax),%eax
  8008ea:	83 e8 04             	sub    $0x4,%eax
  8008ed:	8b 00                	mov    (%eax),%eax
  8008ef:	99                   	cltd   
}
  8008f0:	5d                   	pop    %ebp
  8008f1:	c3                   	ret    

008008f2 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8008f2:	55                   	push   %ebp
  8008f3:	89 e5                	mov    %esp,%ebp
  8008f5:	56                   	push   %esi
  8008f6:	53                   	push   %ebx
  8008f7:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008fa:	eb 17                	jmp    800913 <vprintfmt+0x21>
			if (ch == '\0')
  8008fc:	85 db                	test   %ebx,%ebx
  8008fe:	0f 84 c1 03 00 00    	je     800cc5 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800904:	83 ec 08             	sub    $0x8,%esp
  800907:	ff 75 0c             	pushl  0xc(%ebp)
  80090a:	53                   	push   %ebx
  80090b:	8b 45 08             	mov    0x8(%ebp),%eax
  80090e:	ff d0                	call   *%eax
  800910:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800913:	8b 45 10             	mov    0x10(%ebp),%eax
  800916:	8d 50 01             	lea    0x1(%eax),%edx
  800919:	89 55 10             	mov    %edx,0x10(%ebp)
  80091c:	8a 00                	mov    (%eax),%al
  80091e:	0f b6 d8             	movzbl %al,%ebx
  800921:	83 fb 25             	cmp    $0x25,%ebx
  800924:	75 d6                	jne    8008fc <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800926:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80092a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800931:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800938:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80093f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800946:	8b 45 10             	mov    0x10(%ebp),%eax
  800949:	8d 50 01             	lea    0x1(%eax),%edx
  80094c:	89 55 10             	mov    %edx,0x10(%ebp)
  80094f:	8a 00                	mov    (%eax),%al
  800951:	0f b6 d8             	movzbl %al,%ebx
  800954:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800957:	83 f8 5b             	cmp    $0x5b,%eax
  80095a:	0f 87 3d 03 00 00    	ja     800c9d <vprintfmt+0x3ab>
  800960:	8b 04 85 78 3e 80 00 	mov    0x803e78(,%eax,4),%eax
  800967:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800969:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80096d:	eb d7                	jmp    800946 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80096f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800973:	eb d1                	jmp    800946 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800975:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80097c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80097f:	89 d0                	mov    %edx,%eax
  800981:	c1 e0 02             	shl    $0x2,%eax
  800984:	01 d0                	add    %edx,%eax
  800986:	01 c0                	add    %eax,%eax
  800988:	01 d8                	add    %ebx,%eax
  80098a:	83 e8 30             	sub    $0x30,%eax
  80098d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800990:	8b 45 10             	mov    0x10(%ebp),%eax
  800993:	8a 00                	mov    (%eax),%al
  800995:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800998:	83 fb 2f             	cmp    $0x2f,%ebx
  80099b:	7e 3e                	jle    8009db <vprintfmt+0xe9>
  80099d:	83 fb 39             	cmp    $0x39,%ebx
  8009a0:	7f 39                	jg     8009db <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009a2:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009a5:	eb d5                	jmp    80097c <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8009aa:	83 c0 04             	add    $0x4,%eax
  8009ad:	89 45 14             	mov    %eax,0x14(%ebp)
  8009b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b3:	83 e8 04             	sub    $0x4,%eax
  8009b6:	8b 00                	mov    (%eax),%eax
  8009b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8009bb:	eb 1f                	jmp    8009dc <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8009bd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009c1:	79 83                	jns    800946 <vprintfmt+0x54>
				width = 0;
  8009c3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8009ca:	e9 77 ff ff ff       	jmp    800946 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8009cf:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8009d6:	e9 6b ff ff ff       	jmp    800946 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8009db:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8009dc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009e0:	0f 89 60 ff ff ff    	jns    800946 <vprintfmt+0x54>
				width = precision, precision = -1;
  8009e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009ec:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8009f3:	e9 4e ff ff ff       	jmp    800946 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009f8:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8009fb:	e9 46 ff ff ff       	jmp    800946 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a00:	8b 45 14             	mov    0x14(%ebp),%eax
  800a03:	83 c0 04             	add    $0x4,%eax
  800a06:	89 45 14             	mov    %eax,0x14(%ebp)
  800a09:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0c:	83 e8 04             	sub    $0x4,%eax
  800a0f:	8b 00                	mov    (%eax),%eax
  800a11:	83 ec 08             	sub    $0x8,%esp
  800a14:	ff 75 0c             	pushl  0xc(%ebp)
  800a17:	50                   	push   %eax
  800a18:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1b:	ff d0                	call   *%eax
  800a1d:	83 c4 10             	add    $0x10,%esp
			break;
  800a20:	e9 9b 02 00 00       	jmp    800cc0 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a25:	8b 45 14             	mov    0x14(%ebp),%eax
  800a28:	83 c0 04             	add    $0x4,%eax
  800a2b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a2e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a31:	83 e8 04             	sub    $0x4,%eax
  800a34:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a36:	85 db                	test   %ebx,%ebx
  800a38:	79 02                	jns    800a3c <vprintfmt+0x14a>
				err = -err;
  800a3a:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a3c:	83 fb 64             	cmp    $0x64,%ebx
  800a3f:	7f 0b                	jg     800a4c <vprintfmt+0x15a>
  800a41:	8b 34 9d c0 3c 80 00 	mov    0x803cc0(,%ebx,4),%esi
  800a48:	85 f6                	test   %esi,%esi
  800a4a:	75 19                	jne    800a65 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a4c:	53                   	push   %ebx
  800a4d:	68 65 3e 80 00       	push   $0x803e65
  800a52:	ff 75 0c             	pushl  0xc(%ebp)
  800a55:	ff 75 08             	pushl  0x8(%ebp)
  800a58:	e8 70 02 00 00       	call   800ccd <printfmt>
  800a5d:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a60:	e9 5b 02 00 00       	jmp    800cc0 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a65:	56                   	push   %esi
  800a66:	68 6e 3e 80 00       	push   $0x803e6e
  800a6b:	ff 75 0c             	pushl  0xc(%ebp)
  800a6e:	ff 75 08             	pushl  0x8(%ebp)
  800a71:	e8 57 02 00 00       	call   800ccd <printfmt>
  800a76:	83 c4 10             	add    $0x10,%esp
			break;
  800a79:	e9 42 02 00 00       	jmp    800cc0 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a7e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a81:	83 c0 04             	add    $0x4,%eax
  800a84:	89 45 14             	mov    %eax,0x14(%ebp)
  800a87:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8a:	83 e8 04             	sub    $0x4,%eax
  800a8d:	8b 30                	mov    (%eax),%esi
  800a8f:	85 f6                	test   %esi,%esi
  800a91:	75 05                	jne    800a98 <vprintfmt+0x1a6>
				p = "(null)";
  800a93:	be 71 3e 80 00       	mov    $0x803e71,%esi
			if (width > 0 && padc != '-')
  800a98:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a9c:	7e 6d                	jle    800b0b <vprintfmt+0x219>
  800a9e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800aa2:	74 67                	je     800b0b <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800aa4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800aa7:	83 ec 08             	sub    $0x8,%esp
  800aaa:	50                   	push   %eax
  800aab:	56                   	push   %esi
  800aac:	e8 1e 03 00 00       	call   800dcf <strnlen>
  800ab1:	83 c4 10             	add    $0x10,%esp
  800ab4:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ab7:	eb 16                	jmp    800acf <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ab9:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800abd:	83 ec 08             	sub    $0x8,%esp
  800ac0:	ff 75 0c             	pushl  0xc(%ebp)
  800ac3:	50                   	push   %eax
  800ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac7:	ff d0                	call   *%eax
  800ac9:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800acc:	ff 4d e4             	decl   -0x1c(%ebp)
  800acf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ad3:	7f e4                	jg     800ab9 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ad5:	eb 34                	jmp    800b0b <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800ad7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800adb:	74 1c                	je     800af9 <vprintfmt+0x207>
  800add:	83 fb 1f             	cmp    $0x1f,%ebx
  800ae0:	7e 05                	jle    800ae7 <vprintfmt+0x1f5>
  800ae2:	83 fb 7e             	cmp    $0x7e,%ebx
  800ae5:	7e 12                	jle    800af9 <vprintfmt+0x207>
					putch('?', putdat);
  800ae7:	83 ec 08             	sub    $0x8,%esp
  800aea:	ff 75 0c             	pushl  0xc(%ebp)
  800aed:	6a 3f                	push   $0x3f
  800aef:	8b 45 08             	mov    0x8(%ebp),%eax
  800af2:	ff d0                	call   *%eax
  800af4:	83 c4 10             	add    $0x10,%esp
  800af7:	eb 0f                	jmp    800b08 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800af9:	83 ec 08             	sub    $0x8,%esp
  800afc:	ff 75 0c             	pushl  0xc(%ebp)
  800aff:	53                   	push   %ebx
  800b00:	8b 45 08             	mov    0x8(%ebp),%eax
  800b03:	ff d0                	call   *%eax
  800b05:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b08:	ff 4d e4             	decl   -0x1c(%ebp)
  800b0b:	89 f0                	mov    %esi,%eax
  800b0d:	8d 70 01             	lea    0x1(%eax),%esi
  800b10:	8a 00                	mov    (%eax),%al
  800b12:	0f be d8             	movsbl %al,%ebx
  800b15:	85 db                	test   %ebx,%ebx
  800b17:	74 24                	je     800b3d <vprintfmt+0x24b>
  800b19:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b1d:	78 b8                	js     800ad7 <vprintfmt+0x1e5>
  800b1f:	ff 4d e0             	decl   -0x20(%ebp)
  800b22:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b26:	79 af                	jns    800ad7 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b28:	eb 13                	jmp    800b3d <vprintfmt+0x24b>
				putch(' ', putdat);
  800b2a:	83 ec 08             	sub    $0x8,%esp
  800b2d:	ff 75 0c             	pushl  0xc(%ebp)
  800b30:	6a 20                	push   $0x20
  800b32:	8b 45 08             	mov    0x8(%ebp),%eax
  800b35:	ff d0                	call   *%eax
  800b37:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b3a:	ff 4d e4             	decl   -0x1c(%ebp)
  800b3d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b41:	7f e7                	jg     800b2a <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b43:	e9 78 01 00 00       	jmp    800cc0 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b48:	83 ec 08             	sub    $0x8,%esp
  800b4b:	ff 75 e8             	pushl  -0x18(%ebp)
  800b4e:	8d 45 14             	lea    0x14(%ebp),%eax
  800b51:	50                   	push   %eax
  800b52:	e8 3c fd ff ff       	call   800893 <getint>
  800b57:	83 c4 10             	add    $0x10,%esp
  800b5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b5d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b63:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b66:	85 d2                	test   %edx,%edx
  800b68:	79 23                	jns    800b8d <vprintfmt+0x29b>
				putch('-', putdat);
  800b6a:	83 ec 08             	sub    $0x8,%esp
  800b6d:	ff 75 0c             	pushl  0xc(%ebp)
  800b70:	6a 2d                	push   $0x2d
  800b72:	8b 45 08             	mov    0x8(%ebp),%eax
  800b75:	ff d0                	call   *%eax
  800b77:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b7d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b80:	f7 d8                	neg    %eax
  800b82:	83 d2 00             	adc    $0x0,%edx
  800b85:	f7 da                	neg    %edx
  800b87:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b8a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b8d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b94:	e9 bc 00 00 00       	jmp    800c55 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b99:	83 ec 08             	sub    $0x8,%esp
  800b9c:	ff 75 e8             	pushl  -0x18(%ebp)
  800b9f:	8d 45 14             	lea    0x14(%ebp),%eax
  800ba2:	50                   	push   %eax
  800ba3:	e8 84 fc ff ff       	call   80082c <getuint>
  800ba8:	83 c4 10             	add    $0x10,%esp
  800bab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bae:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800bb1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bb8:	e9 98 00 00 00       	jmp    800c55 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800bbd:	83 ec 08             	sub    $0x8,%esp
  800bc0:	ff 75 0c             	pushl  0xc(%ebp)
  800bc3:	6a 58                	push   $0x58
  800bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc8:	ff d0                	call   *%eax
  800bca:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800bcd:	83 ec 08             	sub    $0x8,%esp
  800bd0:	ff 75 0c             	pushl  0xc(%ebp)
  800bd3:	6a 58                	push   $0x58
  800bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd8:	ff d0                	call   *%eax
  800bda:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800bdd:	83 ec 08             	sub    $0x8,%esp
  800be0:	ff 75 0c             	pushl  0xc(%ebp)
  800be3:	6a 58                	push   $0x58
  800be5:	8b 45 08             	mov    0x8(%ebp),%eax
  800be8:	ff d0                	call   *%eax
  800bea:	83 c4 10             	add    $0x10,%esp
			break;
  800bed:	e9 ce 00 00 00       	jmp    800cc0 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800bf2:	83 ec 08             	sub    $0x8,%esp
  800bf5:	ff 75 0c             	pushl  0xc(%ebp)
  800bf8:	6a 30                	push   $0x30
  800bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfd:	ff d0                	call   *%eax
  800bff:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c02:	83 ec 08             	sub    $0x8,%esp
  800c05:	ff 75 0c             	pushl  0xc(%ebp)
  800c08:	6a 78                	push   $0x78
  800c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0d:	ff d0                	call   *%eax
  800c0f:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c12:	8b 45 14             	mov    0x14(%ebp),%eax
  800c15:	83 c0 04             	add    $0x4,%eax
  800c18:	89 45 14             	mov    %eax,0x14(%ebp)
  800c1b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c1e:	83 e8 04             	sub    $0x4,%eax
  800c21:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c23:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c26:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c2d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c34:	eb 1f                	jmp    800c55 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c36:	83 ec 08             	sub    $0x8,%esp
  800c39:	ff 75 e8             	pushl  -0x18(%ebp)
  800c3c:	8d 45 14             	lea    0x14(%ebp),%eax
  800c3f:	50                   	push   %eax
  800c40:	e8 e7 fb ff ff       	call   80082c <getuint>
  800c45:	83 c4 10             	add    $0x10,%esp
  800c48:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c4b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c4e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c55:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c59:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c5c:	83 ec 04             	sub    $0x4,%esp
  800c5f:	52                   	push   %edx
  800c60:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c63:	50                   	push   %eax
  800c64:	ff 75 f4             	pushl  -0xc(%ebp)
  800c67:	ff 75 f0             	pushl  -0x10(%ebp)
  800c6a:	ff 75 0c             	pushl  0xc(%ebp)
  800c6d:	ff 75 08             	pushl  0x8(%ebp)
  800c70:	e8 00 fb ff ff       	call   800775 <printnum>
  800c75:	83 c4 20             	add    $0x20,%esp
			break;
  800c78:	eb 46                	jmp    800cc0 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c7a:	83 ec 08             	sub    $0x8,%esp
  800c7d:	ff 75 0c             	pushl  0xc(%ebp)
  800c80:	53                   	push   %ebx
  800c81:	8b 45 08             	mov    0x8(%ebp),%eax
  800c84:	ff d0                	call   *%eax
  800c86:	83 c4 10             	add    $0x10,%esp
			break;
  800c89:	eb 35                	jmp    800cc0 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800c8b:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
			break;
  800c92:	eb 2c                	jmp    800cc0 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800c94:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
			break;
  800c9b:	eb 23                	jmp    800cc0 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c9d:	83 ec 08             	sub    $0x8,%esp
  800ca0:	ff 75 0c             	pushl  0xc(%ebp)
  800ca3:	6a 25                	push   $0x25
  800ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca8:	ff d0                	call   *%eax
  800caa:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cad:	ff 4d 10             	decl   0x10(%ebp)
  800cb0:	eb 03                	jmp    800cb5 <vprintfmt+0x3c3>
  800cb2:	ff 4d 10             	decl   0x10(%ebp)
  800cb5:	8b 45 10             	mov    0x10(%ebp),%eax
  800cb8:	48                   	dec    %eax
  800cb9:	8a 00                	mov    (%eax),%al
  800cbb:	3c 25                	cmp    $0x25,%al
  800cbd:	75 f3                	jne    800cb2 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800cbf:	90                   	nop
		}
	}
  800cc0:	e9 35 fc ff ff       	jmp    8008fa <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800cc5:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800cc6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800cc9:	5b                   	pop    %ebx
  800cca:	5e                   	pop    %esi
  800ccb:	5d                   	pop    %ebp
  800ccc:	c3                   	ret    

00800ccd <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ccd:	55                   	push   %ebp
  800cce:	89 e5                	mov    %esp,%ebp
  800cd0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800cd3:	8d 45 10             	lea    0x10(%ebp),%eax
  800cd6:	83 c0 04             	add    $0x4,%eax
  800cd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800cdc:	8b 45 10             	mov    0x10(%ebp),%eax
  800cdf:	ff 75 f4             	pushl  -0xc(%ebp)
  800ce2:	50                   	push   %eax
  800ce3:	ff 75 0c             	pushl  0xc(%ebp)
  800ce6:	ff 75 08             	pushl  0x8(%ebp)
  800ce9:	e8 04 fc ff ff       	call   8008f2 <vprintfmt>
  800cee:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800cf1:	90                   	nop
  800cf2:	c9                   	leave  
  800cf3:	c3                   	ret    

00800cf4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800cf4:	55                   	push   %ebp
  800cf5:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800cf7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cfa:	8b 40 08             	mov    0x8(%eax),%eax
  800cfd:	8d 50 01             	lea    0x1(%eax),%edx
  800d00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d03:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d09:	8b 10                	mov    (%eax),%edx
  800d0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0e:	8b 40 04             	mov    0x4(%eax),%eax
  800d11:	39 c2                	cmp    %eax,%edx
  800d13:	73 12                	jae    800d27 <sprintputch+0x33>
		*b->buf++ = ch;
  800d15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d18:	8b 00                	mov    (%eax),%eax
  800d1a:	8d 48 01             	lea    0x1(%eax),%ecx
  800d1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d20:	89 0a                	mov    %ecx,(%edx)
  800d22:	8b 55 08             	mov    0x8(%ebp),%edx
  800d25:	88 10                	mov    %dl,(%eax)
}
  800d27:	90                   	nop
  800d28:	5d                   	pop    %ebp
  800d29:	c3                   	ret    

00800d2a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d2a:	55                   	push   %ebp
  800d2b:	89 e5                	mov    %esp,%ebp
  800d2d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d30:	8b 45 08             	mov    0x8(%ebp),%eax
  800d33:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d39:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3f:	01 d0                	add    %edx,%eax
  800d41:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d44:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d4b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d4f:	74 06                	je     800d57 <vsnprintf+0x2d>
  800d51:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d55:	7f 07                	jg     800d5e <vsnprintf+0x34>
		return -E_INVAL;
  800d57:	b8 03 00 00 00       	mov    $0x3,%eax
  800d5c:	eb 20                	jmp    800d7e <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d5e:	ff 75 14             	pushl  0x14(%ebp)
  800d61:	ff 75 10             	pushl  0x10(%ebp)
  800d64:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d67:	50                   	push   %eax
  800d68:	68 f4 0c 80 00       	push   $0x800cf4
  800d6d:	e8 80 fb ff ff       	call   8008f2 <vprintfmt>
  800d72:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d78:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d7e:	c9                   	leave  
  800d7f:	c3                   	ret    

00800d80 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d80:	55                   	push   %ebp
  800d81:	89 e5                	mov    %esp,%ebp
  800d83:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d86:	8d 45 10             	lea    0x10(%ebp),%eax
  800d89:	83 c0 04             	add    $0x4,%eax
  800d8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d8f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d92:	ff 75 f4             	pushl  -0xc(%ebp)
  800d95:	50                   	push   %eax
  800d96:	ff 75 0c             	pushl  0xc(%ebp)
  800d99:	ff 75 08             	pushl  0x8(%ebp)
  800d9c:	e8 89 ff ff ff       	call   800d2a <vsnprintf>
  800da1:	83 c4 10             	add    $0x10,%esp
  800da4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800da7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800daa:	c9                   	leave  
  800dab:	c3                   	ret    

00800dac <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800dac:	55                   	push   %ebp
  800dad:	89 e5                	mov    %esp,%ebp
  800daf:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800db2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800db9:	eb 06                	jmp    800dc1 <strlen+0x15>
		n++;
  800dbb:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800dbe:	ff 45 08             	incl   0x8(%ebp)
  800dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc4:	8a 00                	mov    (%eax),%al
  800dc6:	84 c0                	test   %al,%al
  800dc8:	75 f1                	jne    800dbb <strlen+0xf>
		n++;
	return n;
  800dca:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dcd:	c9                   	leave  
  800dce:	c3                   	ret    

00800dcf <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800dcf:	55                   	push   %ebp
  800dd0:	89 e5                	mov    %esp,%ebp
  800dd2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dd5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ddc:	eb 09                	jmp    800de7 <strnlen+0x18>
		n++;
  800dde:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800de1:	ff 45 08             	incl   0x8(%ebp)
  800de4:	ff 4d 0c             	decl   0xc(%ebp)
  800de7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800deb:	74 09                	je     800df6 <strnlen+0x27>
  800ded:	8b 45 08             	mov    0x8(%ebp),%eax
  800df0:	8a 00                	mov    (%eax),%al
  800df2:	84 c0                	test   %al,%al
  800df4:	75 e8                	jne    800dde <strnlen+0xf>
		n++;
	return n;
  800df6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800df9:	c9                   	leave  
  800dfa:	c3                   	ret    

00800dfb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800dfb:	55                   	push   %ebp
  800dfc:	89 e5                	mov    %esp,%ebp
  800dfe:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e01:	8b 45 08             	mov    0x8(%ebp),%eax
  800e04:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e07:	90                   	nop
  800e08:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0b:	8d 50 01             	lea    0x1(%eax),%edx
  800e0e:	89 55 08             	mov    %edx,0x8(%ebp)
  800e11:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e14:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e17:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e1a:	8a 12                	mov    (%edx),%dl
  800e1c:	88 10                	mov    %dl,(%eax)
  800e1e:	8a 00                	mov    (%eax),%al
  800e20:	84 c0                	test   %al,%al
  800e22:	75 e4                	jne    800e08 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e24:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e27:	c9                   	leave  
  800e28:	c3                   	ret    

00800e29 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e29:	55                   	push   %ebp
  800e2a:	89 e5                	mov    %esp,%ebp
  800e2c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e32:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e35:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e3c:	eb 1f                	jmp    800e5d <strncpy+0x34>
		*dst++ = *src;
  800e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e41:	8d 50 01             	lea    0x1(%eax),%edx
  800e44:	89 55 08             	mov    %edx,0x8(%ebp)
  800e47:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e4a:	8a 12                	mov    (%edx),%dl
  800e4c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e51:	8a 00                	mov    (%eax),%al
  800e53:	84 c0                	test   %al,%al
  800e55:	74 03                	je     800e5a <strncpy+0x31>
			src++;
  800e57:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e5a:	ff 45 fc             	incl   -0x4(%ebp)
  800e5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e60:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e63:	72 d9                	jb     800e3e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e65:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e68:	c9                   	leave  
  800e69:	c3                   	ret    

00800e6a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e6a:	55                   	push   %ebp
  800e6b:	89 e5                	mov    %esp,%ebp
  800e6d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e70:	8b 45 08             	mov    0x8(%ebp),%eax
  800e73:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e76:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e7a:	74 30                	je     800eac <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e7c:	eb 16                	jmp    800e94 <strlcpy+0x2a>
			*dst++ = *src++;
  800e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e81:	8d 50 01             	lea    0x1(%eax),%edx
  800e84:	89 55 08             	mov    %edx,0x8(%ebp)
  800e87:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e8a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e8d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e90:	8a 12                	mov    (%edx),%dl
  800e92:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e94:	ff 4d 10             	decl   0x10(%ebp)
  800e97:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e9b:	74 09                	je     800ea6 <strlcpy+0x3c>
  800e9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea0:	8a 00                	mov    (%eax),%al
  800ea2:	84 c0                	test   %al,%al
  800ea4:	75 d8                	jne    800e7e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800eac:	8b 55 08             	mov    0x8(%ebp),%edx
  800eaf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb2:	29 c2                	sub    %eax,%edx
  800eb4:	89 d0                	mov    %edx,%eax
}
  800eb6:	c9                   	leave  
  800eb7:	c3                   	ret    

00800eb8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800eb8:	55                   	push   %ebp
  800eb9:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ebb:	eb 06                	jmp    800ec3 <strcmp+0xb>
		p++, q++;
  800ebd:	ff 45 08             	incl   0x8(%ebp)
  800ec0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec6:	8a 00                	mov    (%eax),%al
  800ec8:	84 c0                	test   %al,%al
  800eca:	74 0e                	je     800eda <strcmp+0x22>
  800ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecf:	8a 10                	mov    (%eax),%dl
  800ed1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed4:	8a 00                	mov    (%eax),%al
  800ed6:	38 c2                	cmp    %al,%dl
  800ed8:	74 e3                	je     800ebd <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800eda:	8b 45 08             	mov    0x8(%ebp),%eax
  800edd:	8a 00                	mov    (%eax),%al
  800edf:	0f b6 d0             	movzbl %al,%edx
  800ee2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee5:	8a 00                	mov    (%eax),%al
  800ee7:	0f b6 c0             	movzbl %al,%eax
  800eea:	29 c2                	sub    %eax,%edx
  800eec:	89 d0                	mov    %edx,%eax
}
  800eee:	5d                   	pop    %ebp
  800eef:	c3                   	ret    

00800ef0 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800ef0:	55                   	push   %ebp
  800ef1:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800ef3:	eb 09                	jmp    800efe <strncmp+0xe>
		n--, p++, q++;
  800ef5:	ff 4d 10             	decl   0x10(%ebp)
  800ef8:	ff 45 08             	incl   0x8(%ebp)
  800efb:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800efe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f02:	74 17                	je     800f1b <strncmp+0x2b>
  800f04:	8b 45 08             	mov    0x8(%ebp),%eax
  800f07:	8a 00                	mov    (%eax),%al
  800f09:	84 c0                	test   %al,%al
  800f0b:	74 0e                	je     800f1b <strncmp+0x2b>
  800f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f10:	8a 10                	mov    (%eax),%dl
  800f12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f15:	8a 00                	mov    (%eax),%al
  800f17:	38 c2                	cmp    %al,%dl
  800f19:	74 da                	je     800ef5 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f1b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f1f:	75 07                	jne    800f28 <strncmp+0x38>
		return 0;
  800f21:	b8 00 00 00 00       	mov    $0x0,%eax
  800f26:	eb 14                	jmp    800f3c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f28:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2b:	8a 00                	mov    (%eax),%al
  800f2d:	0f b6 d0             	movzbl %al,%edx
  800f30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f33:	8a 00                	mov    (%eax),%al
  800f35:	0f b6 c0             	movzbl %al,%eax
  800f38:	29 c2                	sub    %eax,%edx
  800f3a:	89 d0                	mov    %edx,%eax
}
  800f3c:	5d                   	pop    %ebp
  800f3d:	c3                   	ret    

00800f3e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f3e:	55                   	push   %ebp
  800f3f:	89 e5                	mov    %esp,%ebp
  800f41:	83 ec 04             	sub    $0x4,%esp
  800f44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f47:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f4a:	eb 12                	jmp    800f5e <strchr+0x20>
		if (*s == c)
  800f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4f:	8a 00                	mov    (%eax),%al
  800f51:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f54:	75 05                	jne    800f5b <strchr+0x1d>
			return (char *) s;
  800f56:	8b 45 08             	mov    0x8(%ebp),%eax
  800f59:	eb 11                	jmp    800f6c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f5b:	ff 45 08             	incl   0x8(%ebp)
  800f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f61:	8a 00                	mov    (%eax),%al
  800f63:	84 c0                	test   %al,%al
  800f65:	75 e5                	jne    800f4c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f67:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f6c:	c9                   	leave  
  800f6d:	c3                   	ret    

00800f6e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f6e:	55                   	push   %ebp
  800f6f:	89 e5                	mov    %esp,%ebp
  800f71:	83 ec 04             	sub    $0x4,%esp
  800f74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f77:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f7a:	eb 0d                	jmp    800f89 <strfind+0x1b>
		if (*s == c)
  800f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7f:	8a 00                	mov    (%eax),%al
  800f81:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f84:	74 0e                	je     800f94 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f86:	ff 45 08             	incl   0x8(%ebp)
  800f89:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8c:	8a 00                	mov    (%eax),%al
  800f8e:	84 c0                	test   %al,%al
  800f90:	75 ea                	jne    800f7c <strfind+0xe>
  800f92:	eb 01                	jmp    800f95 <strfind+0x27>
		if (*s == c)
			break;
  800f94:	90                   	nop
	return (char *) s;
  800f95:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f98:	c9                   	leave  
  800f99:	c3                   	ret    

00800f9a <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800f9a:	55                   	push   %ebp
  800f9b:	89 e5                	mov    %esp,%ebp
  800f9d:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800fa6:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800fac:	eb 0e                	jmp    800fbc <memset+0x22>
		*p++ = c;
  800fae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fb1:	8d 50 01             	lea    0x1(%eax),%edx
  800fb4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fb7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fba:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800fbc:	ff 4d f8             	decl   -0x8(%ebp)
  800fbf:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800fc3:	79 e9                	jns    800fae <memset+0x14>
		*p++ = c;

	return v;
  800fc5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fc8:	c9                   	leave  
  800fc9:	c3                   	ret    

00800fca <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800fca:	55                   	push   %ebp
  800fcb:	89 e5                	mov    %esp,%ebp
  800fcd:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800fd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800fdc:	eb 16                	jmp    800ff4 <memcpy+0x2a>
		*d++ = *s++;
  800fde:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe1:	8d 50 01             	lea    0x1(%eax),%edx
  800fe4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fe7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fea:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fed:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ff0:	8a 12                	mov    (%edx),%dl
  800ff2:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800ff4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ffa:	89 55 10             	mov    %edx,0x10(%ebp)
  800ffd:	85 c0                	test   %eax,%eax
  800fff:	75 dd                	jne    800fde <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801001:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801004:	c9                   	leave  
  801005:	c3                   	ret    

00801006 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801006:	55                   	push   %ebp
  801007:	89 e5                	mov    %esp,%ebp
  801009:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80100c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801012:	8b 45 08             	mov    0x8(%ebp),%eax
  801015:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801018:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80101b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80101e:	73 50                	jae    801070 <memmove+0x6a>
  801020:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801023:	8b 45 10             	mov    0x10(%ebp),%eax
  801026:	01 d0                	add    %edx,%eax
  801028:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80102b:	76 43                	jbe    801070 <memmove+0x6a>
		s += n;
  80102d:	8b 45 10             	mov    0x10(%ebp),%eax
  801030:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801033:	8b 45 10             	mov    0x10(%ebp),%eax
  801036:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801039:	eb 10                	jmp    80104b <memmove+0x45>
			*--d = *--s;
  80103b:	ff 4d f8             	decl   -0x8(%ebp)
  80103e:	ff 4d fc             	decl   -0x4(%ebp)
  801041:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801044:	8a 10                	mov    (%eax),%dl
  801046:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801049:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80104b:	8b 45 10             	mov    0x10(%ebp),%eax
  80104e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801051:	89 55 10             	mov    %edx,0x10(%ebp)
  801054:	85 c0                	test   %eax,%eax
  801056:	75 e3                	jne    80103b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801058:	eb 23                	jmp    80107d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80105a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80105d:	8d 50 01             	lea    0x1(%eax),%edx
  801060:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801063:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801066:	8d 4a 01             	lea    0x1(%edx),%ecx
  801069:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80106c:	8a 12                	mov    (%edx),%dl
  80106e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801070:	8b 45 10             	mov    0x10(%ebp),%eax
  801073:	8d 50 ff             	lea    -0x1(%eax),%edx
  801076:	89 55 10             	mov    %edx,0x10(%ebp)
  801079:	85 c0                	test   %eax,%eax
  80107b:	75 dd                	jne    80105a <memmove+0x54>
			*d++ = *s++;

	return dst;
  80107d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801080:	c9                   	leave  
  801081:	c3                   	ret    

00801082 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801082:	55                   	push   %ebp
  801083:	89 e5                	mov    %esp,%ebp
  801085:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801088:	8b 45 08             	mov    0x8(%ebp),%eax
  80108b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80108e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801091:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801094:	eb 2a                	jmp    8010c0 <memcmp+0x3e>
		if (*s1 != *s2)
  801096:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801099:	8a 10                	mov    (%eax),%dl
  80109b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80109e:	8a 00                	mov    (%eax),%al
  8010a0:	38 c2                	cmp    %al,%dl
  8010a2:	74 16                	je     8010ba <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010a7:	8a 00                	mov    (%eax),%al
  8010a9:	0f b6 d0             	movzbl %al,%edx
  8010ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010af:	8a 00                	mov    (%eax),%al
  8010b1:	0f b6 c0             	movzbl %al,%eax
  8010b4:	29 c2                	sub    %eax,%edx
  8010b6:	89 d0                	mov    %edx,%eax
  8010b8:	eb 18                	jmp    8010d2 <memcmp+0x50>
		s1++, s2++;
  8010ba:	ff 45 fc             	incl   -0x4(%ebp)
  8010bd:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8010c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010c6:	89 55 10             	mov    %edx,0x10(%ebp)
  8010c9:	85 c0                	test   %eax,%eax
  8010cb:	75 c9                	jne    801096 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8010cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010d2:	c9                   	leave  
  8010d3:	c3                   	ret    

008010d4 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8010d4:	55                   	push   %ebp
  8010d5:	89 e5                	mov    %esp,%ebp
  8010d7:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8010da:	8b 55 08             	mov    0x8(%ebp),%edx
  8010dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e0:	01 d0                	add    %edx,%eax
  8010e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8010e5:	eb 15                	jmp    8010fc <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8010e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ea:	8a 00                	mov    (%eax),%al
  8010ec:	0f b6 d0             	movzbl %al,%edx
  8010ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f2:	0f b6 c0             	movzbl %al,%eax
  8010f5:	39 c2                	cmp    %eax,%edx
  8010f7:	74 0d                	je     801106 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8010f9:	ff 45 08             	incl   0x8(%ebp)
  8010fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ff:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801102:	72 e3                	jb     8010e7 <memfind+0x13>
  801104:	eb 01                	jmp    801107 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801106:	90                   	nop
	return (void *) s;
  801107:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80110a:	c9                   	leave  
  80110b:	c3                   	ret    

0080110c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80110c:	55                   	push   %ebp
  80110d:	89 e5                	mov    %esp,%ebp
  80110f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801112:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801119:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801120:	eb 03                	jmp    801125 <strtol+0x19>
		s++;
  801122:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801125:	8b 45 08             	mov    0x8(%ebp),%eax
  801128:	8a 00                	mov    (%eax),%al
  80112a:	3c 20                	cmp    $0x20,%al
  80112c:	74 f4                	je     801122 <strtol+0x16>
  80112e:	8b 45 08             	mov    0x8(%ebp),%eax
  801131:	8a 00                	mov    (%eax),%al
  801133:	3c 09                	cmp    $0x9,%al
  801135:	74 eb                	je     801122 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801137:	8b 45 08             	mov    0x8(%ebp),%eax
  80113a:	8a 00                	mov    (%eax),%al
  80113c:	3c 2b                	cmp    $0x2b,%al
  80113e:	75 05                	jne    801145 <strtol+0x39>
		s++;
  801140:	ff 45 08             	incl   0x8(%ebp)
  801143:	eb 13                	jmp    801158 <strtol+0x4c>
	else if (*s == '-')
  801145:	8b 45 08             	mov    0x8(%ebp),%eax
  801148:	8a 00                	mov    (%eax),%al
  80114a:	3c 2d                	cmp    $0x2d,%al
  80114c:	75 0a                	jne    801158 <strtol+0x4c>
		s++, neg = 1;
  80114e:	ff 45 08             	incl   0x8(%ebp)
  801151:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801158:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80115c:	74 06                	je     801164 <strtol+0x58>
  80115e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801162:	75 20                	jne    801184 <strtol+0x78>
  801164:	8b 45 08             	mov    0x8(%ebp),%eax
  801167:	8a 00                	mov    (%eax),%al
  801169:	3c 30                	cmp    $0x30,%al
  80116b:	75 17                	jne    801184 <strtol+0x78>
  80116d:	8b 45 08             	mov    0x8(%ebp),%eax
  801170:	40                   	inc    %eax
  801171:	8a 00                	mov    (%eax),%al
  801173:	3c 78                	cmp    $0x78,%al
  801175:	75 0d                	jne    801184 <strtol+0x78>
		s += 2, base = 16;
  801177:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80117b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801182:	eb 28                	jmp    8011ac <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801184:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801188:	75 15                	jne    80119f <strtol+0x93>
  80118a:	8b 45 08             	mov    0x8(%ebp),%eax
  80118d:	8a 00                	mov    (%eax),%al
  80118f:	3c 30                	cmp    $0x30,%al
  801191:	75 0c                	jne    80119f <strtol+0x93>
		s++, base = 8;
  801193:	ff 45 08             	incl   0x8(%ebp)
  801196:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80119d:	eb 0d                	jmp    8011ac <strtol+0xa0>
	else if (base == 0)
  80119f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011a3:	75 07                	jne    8011ac <strtol+0xa0>
		base = 10;
  8011a5:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8011af:	8a 00                	mov    (%eax),%al
  8011b1:	3c 2f                	cmp    $0x2f,%al
  8011b3:	7e 19                	jle    8011ce <strtol+0xc2>
  8011b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b8:	8a 00                	mov    (%eax),%al
  8011ba:	3c 39                	cmp    $0x39,%al
  8011bc:	7f 10                	jg     8011ce <strtol+0xc2>
			dig = *s - '0';
  8011be:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c1:	8a 00                	mov    (%eax),%al
  8011c3:	0f be c0             	movsbl %al,%eax
  8011c6:	83 e8 30             	sub    $0x30,%eax
  8011c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011cc:	eb 42                	jmp    801210 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8011ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d1:	8a 00                	mov    (%eax),%al
  8011d3:	3c 60                	cmp    $0x60,%al
  8011d5:	7e 19                	jle    8011f0 <strtol+0xe4>
  8011d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011da:	8a 00                	mov    (%eax),%al
  8011dc:	3c 7a                	cmp    $0x7a,%al
  8011de:	7f 10                	jg     8011f0 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8011e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e3:	8a 00                	mov    (%eax),%al
  8011e5:	0f be c0             	movsbl %al,%eax
  8011e8:	83 e8 57             	sub    $0x57,%eax
  8011eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011ee:	eb 20                	jmp    801210 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8011f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f3:	8a 00                	mov    (%eax),%al
  8011f5:	3c 40                	cmp    $0x40,%al
  8011f7:	7e 39                	jle    801232 <strtol+0x126>
  8011f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fc:	8a 00                	mov    (%eax),%al
  8011fe:	3c 5a                	cmp    $0x5a,%al
  801200:	7f 30                	jg     801232 <strtol+0x126>
			dig = *s - 'A' + 10;
  801202:	8b 45 08             	mov    0x8(%ebp),%eax
  801205:	8a 00                	mov    (%eax),%al
  801207:	0f be c0             	movsbl %al,%eax
  80120a:	83 e8 37             	sub    $0x37,%eax
  80120d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801210:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801213:	3b 45 10             	cmp    0x10(%ebp),%eax
  801216:	7d 19                	jge    801231 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801218:	ff 45 08             	incl   0x8(%ebp)
  80121b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80121e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801222:	89 c2                	mov    %eax,%edx
  801224:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801227:	01 d0                	add    %edx,%eax
  801229:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80122c:	e9 7b ff ff ff       	jmp    8011ac <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801231:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801232:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801236:	74 08                	je     801240 <strtol+0x134>
		*endptr = (char *) s;
  801238:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123b:	8b 55 08             	mov    0x8(%ebp),%edx
  80123e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801240:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801244:	74 07                	je     80124d <strtol+0x141>
  801246:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801249:	f7 d8                	neg    %eax
  80124b:	eb 03                	jmp    801250 <strtol+0x144>
  80124d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801250:	c9                   	leave  
  801251:	c3                   	ret    

00801252 <ltostr>:

void
ltostr(long value, char *str)
{
  801252:	55                   	push   %ebp
  801253:	89 e5                	mov    %esp,%ebp
  801255:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801258:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80125f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801266:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80126a:	79 13                	jns    80127f <ltostr+0x2d>
	{
		neg = 1;
  80126c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801273:	8b 45 0c             	mov    0xc(%ebp),%eax
  801276:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801279:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80127c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80127f:	8b 45 08             	mov    0x8(%ebp),%eax
  801282:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801287:	99                   	cltd   
  801288:	f7 f9                	idiv   %ecx
  80128a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80128d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801290:	8d 50 01             	lea    0x1(%eax),%edx
  801293:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801296:	89 c2                	mov    %eax,%edx
  801298:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129b:	01 d0                	add    %edx,%eax
  80129d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012a0:	83 c2 30             	add    $0x30,%edx
  8012a3:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012a5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012a8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012ad:	f7 e9                	imul   %ecx
  8012af:	c1 fa 02             	sar    $0x2,%edx
  8012b2:	89 c8                	mov    %ecx,%eax
  8012b4:	c1 f8 1f             	sar    $0x1f,%eax
  8012b7:	29 c2                	sub    %eax,%edx
  8012b9:	89 d0                	mov    %edx,%eax
  8012bb:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8012be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012c2:	75 bb                	jne    80127f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8012c4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8012cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012ce:	48                   	dec    %eax
  8012cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8012d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012d6:	74 3d                	je     801315 <ltostr+0xc3>
		start = 1 ;
  8012d8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8012df:	eb 34                	jmp    801315 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8012e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e7:	01 d0                	add    %edx,%eax
  8012e9:	8a 00                	mov    (%eax),%al
  8012eb:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8012ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f4:	01 c2                	add    %eax,%edx
  8012f6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8012f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fc:	01 c8                	add    %ecx,%eax
  8012fe:	8a 00                	mov    (%eax),%al
  801300:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801302:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801305:	8b 45 0c             	mov    0xc(%ebp),%eax
  801308:	01 c2                	add    %eax,%edx
  80130a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80130d:	88 02                	mov    %al,(%edx)
		start++ ;
  80130f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801312:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801315:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801318:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80131b:	7c c4                	jl     8012e1 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80131d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801320:	8b 45 0c             	mov    0xc(%ebp),%eax
  801323:	01 d0                	add    %edx,%eax
  801325:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801328:	90                   	nop
  801329:	c9                   	leave  
  80132a:	c3                   	ret    

0080132b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80132b:	55                   	push   %ebp
  80132c:	89 e5                	mov    %esp,%ebp
  80132e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801331:	ff 75 08             	pushl  0x8(%ebp)
  801334:	e8 73 fa ff ff       	call   800dac <strlen>
  801339:	83 c4 04             	add    $0x4,%esp
  80133c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80133f:	ff 75 0c             	pushl  0xc(%ebp)
  801342:	e8 65 fa ff ff       	call   800dac <strlen>
  801347:	83 c4 04             	add    $0x4,%esp
  80134a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80134d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801354:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80135b:	eb 17                	jmp    801374 <strcconcat+0x49>
		final[s] = str1[s] ;
  80135d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801360:	8b 45 10             	mov    0x10(%ebp),%eax
  801363:	01 c2                	add    %eax,%edx
  801365:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801368:	8b 45 08             	mov    0x8(%ebp),%eax
  80136b:	01 c8                	add    %ecx,%eax
  80136d:	8a 00                	mov    (%eax),%al
  80136f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801371:	ff 45 fc             	incl   -0x4(%ebp)
  801374:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801377:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80137a:	7c e1                	jl     80135d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80137c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801383:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80138a:	eb 1f                	jmp    8013ab <strcconcat+0x80>
		final[s++] = str2[i] ;
  80138c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80138f:	8d 50 01             	lea    0x1(%eax),%edx
  801392:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801395:	89 c2                	mov    %eax,%edx
  801397:	8b 45 10             	mov    0x10(%ebp),%eax
  80139a:	01 c2                	add    %eax,%edx
  80139c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80139f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a2:	01 c8                	add    %ecx,%eax
  8013a4:	8a 00                	mov    (%eax),%al
  8013a6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8013a8:	ff 45 f8             	incl   -0x8(%ebp)
  8013ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013ae:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013b1:	7c d9                	jl     80138c <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8013b3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b9:	01 d0                	add    %edx,%eax
  8013bb:	c6 00 00             	movb   $0x0,(%eax)
}
  8013be:	90                   	nop
  8013bf:	c9                   	leave  
  8013c0:	c3                   	ret    

008013c1 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8013c1:	55                   	push   %ebp
  8013c2:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8013c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8013c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8013cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8013d0:	8b 00                	mov    (%eax),%eax
  8013d2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8013dc:	01 d0                	add    %edx,%eax
  8013de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013e4:	eb 0c                	jmp    8013f2 <strsplit+0x31>
			*string++ = 0;
  8013e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e9:	8d 50 01             	lea    0x1(%eax),%edx
  8013ec:	89 55 08             	mov    %edx,0x8(%ebp)
  8013ef:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f5:	8a 00                	mov    (%eax),%al
  8013f7:	84 c0                	test   %al,%al
  8013f9:	74 18                	je     801413 <strsplit+0x52>
  8013fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fe:	8a 00                	mov    (%eax),%al
  801400:	0f be c0             	movsbl %al,%eax
  801403:	50                   	push   %eax
  801404:	ff 75 0c             	pushl  0xc(%ebp)
  801407:	e8 32 fb ff ff       	call   800f3e <strchr>
  80140c:	83 c4 08             	add    $0x8,%esp
  80140f:	85 c0                	test   %eax,%eax
  801411:	75 d3                	jne    8013e6 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801413:	8b 45 08             	mov    0x8(%ebp),%eax
  801416:	8a 00                	mov    (%eax),%al
  801418:	84 c0                	test   %al,%al
  80141a:	74 5a                	je     801476 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80141c:	8b 45 14             	mov    0x14(%ebp),%eax
  80141f:	8b 00                	mov    (%eax),%eax
  801421:	83 f8 0f             	cmp    $0xf,%eax
  801424:	75 07                	jne    80142d <strsplit+0x6c>
		{
			return 0;
  801426:	b8 00 00 00 00       	mov    $0x0,%eax
  80142b:	eb 66                	jmp    801493 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80142d:	8b 45 14             	mov    0x14(%ebp),%eax
  801430:	8b 00                	mov    (%eax),%eax
  801432:	8d 48 01             	lea    0x1(%eax),%ecx
  801435:	8b 55 14             	mov    0x14(%ebp),%edx
  801438:	89 0a                	mov    %ecx,(%edx)
  80143a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801441:	8b 45 10             	mov    0x10(%ebp),%eax
  801444:	01 c2                	add    %eax,%edx
  801446:	8b 45 08             	mov    0x8(%ebp),%eax
  801449:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80144b:	eb 03                	jmp    801450 <strsplit+0x8f>
			string++;
  80144d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801450:	8b 45 08             	mov    0x8(%ebp),%eax
  801453:	8a 00                	mov    (%eax),%al
  801455:	84 c0                	test   %al,%al
  801457:	74 8b                	je     8013e4 <strsplit+0x23>
  801459:	8b 45 08             	mov    0x8(%ebp),%eax
  80145c:	8a 00                	mov    (%eax),%al
  80145e:	0f be c0             	movsbl %al,%eax
  801461:	50                   	push   %eax
  801462:	ff 75 0c             	pushl  0xc(%ebp)
  801465:	e8 d4 fa ff ff       	call   800f3e <strchr>
  80146a:	83 c4 08             	add    $0x8,%esp
  80146d:	85 c0                	test   %eax,%eax
  80146f:	74 dc                	je     80144d <strsplit+0x8c>
			string++;
	}
  801471:	e9 6e ff ff ff       	jmp    8013e4 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801476:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801477:	8b 45 14             	mov    0x14(%ebp),%eax
  80147a:	8b 00                	mov    (%eax),%eax
  80147c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801483:	8b 45 10             	mov    0x10(%ebp),%eax
  801486:	01 d0                	add    %edx,%eax
  801488:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80148e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801493:	c9                   	leave  
  801494:	c3                   	ret    

00801495 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801495:	55                   	push   %ebp
  801496:	89 e5                	mov    %esp,%ebp
  801498:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  80149b:	83 ec 04             	sub    $0x4,%esp
  80149e:	68 e8 3f 80 00       	push   $0x803fe8
  8014a3:	68 3f 01 00 00       	push   $0x13f
  8014a8:	68 0a 40 80 00       	push   $0x80400a
  8014ad:	e8 9a 21 00 00       	call   80364c <_panic>

008014b2 <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  8014b2:	55                   	push   %ebp
  8014b3:	89 e5                	mov    %esp,%ebp
  8014b5:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  8014b8:	83 ec 0c             	sub    $0xc,%esp
  8014bb:	ff 75 08             	pushl  0x8(%ebp)
  8014be:	e8 90 0c 00 00       	call   802153 <sys_sbrk>
  8014c3:	83 c4 10             	add    $0x10,%esp
}
  8014c6:	c9                   	leave  
  8014c7:	c3                   	ret    

008014c8 <malloc>:
#define num_of_page ((USER_HEAP_MAX - USER_HEAP_START) / PAGE_SIZE)

int pagesAllocated[num_of_page] = { 0 };
int shardIDs[num_of_page] = { 0 };
bool markedPages[num_of_page] = { 0 };
void* malloc(uint32 size) {
  8014c8:	55                   	push   %ebp
  8014c9:	89 e5                	mov    %esp,%ebp
  8014cb:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  8014ce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014d2:	75 0a                	jne    8014de <malloc+0x16>
		return NULL;
  8014d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d9:	e9 9e 01 00 00       	jmp    80167c <malloc+0x1b4>

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

	//  our new code
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  8014de:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8014e5:	77 2c                	ja     801513 <malloc+0x4b>
		if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  8014e7:	e8 eb 0a 00 00       	call   801fd7 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014ec:	85 c0                	test   %eax,%eax
  8014ee:	74 19                	je     801509 <malloc+0x41>

			void * block = alloc_block_FF(size);
  8014f0:	83 ec 0c             	sub    $0xc,%esp
  8014f3:	ff 75 08             	pushl  0x8(%ebp)
  8014f6:	e8 85 11 00 00       	call   802680 <alloc_block_FF>
  8014fb:	83 c4 10             	add    $0x10,%esp
  8014fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			return block;
  801501:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801504:	e9 73 01 00 00       	jmp    80167c <malloc+0x1b4>
		} else {
			return NULL;
  801509:	b8 00 00 00 00       	mov    $0x0,%eax
  80150e:	e9 69 01 00 00       	jmp    80167c <malloc+0x1b4>
		}
	}

	uint32 numOfPages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801513:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80151a:	8b 55 08             	mov    0x8(%ebp),%edx
  80151d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801520:	01 d0                	add    %edx,%eax
  801522:	48                   	dec    %eax
  801523:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801526:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801529:	ba 00 00 00 00       	mov    $0x0,%edx
  80152e:	f7 75 e0             	divl   -0x20(%ebp)
  801531:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801534:	29 d0                	sub    %edx,%eax
  801536:	c1 e8 0c             	shr    $0xc,%eax
  801539:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 freePagesCount = 0;
  80153c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801543:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  80154a:	a1 20 50 80 00       	mov    0x805020,%eax
  80154f:	8b 40 7c             	mov    0x7c(%eax),%eax
  801552:	05 00 10 00 00       	add    $0x1000,%eax
  801557:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  80155a:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  80155f:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801562:	89 45 d0             	mov    %eax,-0x30(%ebp)

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  801565:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80156c:	8b 55 08             	mov    0x8(%ebp),%edx
  80156f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801572:	01 d0                	add    %edx,%eax
  801574:	48                   	dec    %eax
  801575:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801578:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80157b:	ba 00 00 00 00       	mov    $0x0,%edx
  801580:	f7 75 cc             	divl   -0x34(%ebp)
  801583:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801586:	29 d0                	sub    %edx,%eax
  801588:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80158b:	76 0a                	jbe    801597 <malloc+0xcf>
		return NULL;
  80158d:	b8 00 00 00 00       	mov    $0x0,%eax
  801592:	e9 e5 00 00 00       	jmp    80167c <malloc+0x1b4>
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  801597:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80159a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80159d:	eb 48                	jmp    8015e7 <malloc+0x11f>
	{
		uint32 idx = (i - currentAddr) / PAGE_SIZE;
  80159f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015a2:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8015a5:	c1 e8 0c             	shr    $0xc,%eax
  8015a8:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if (!markedPages[idx]) {
  8015ab:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8015ae:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  8015b5:	85 c0                	test   %eax,%eax
  8015b7:	75 11                	jne    8015ca <malloc+0x102>
			freePagesCount++;
  8015b9:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  8015bc:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8015c0:	75 16                	jne    8015d8 <malloc+0x110>
				start = i;
  8015c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015c8:	eb 0e                	jmp    8015d8 <malloc+0x110>
			}
		} else {
			freePagesCount = 0;
  8015ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  8015d1:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == numOfPages) {
  8015d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015db:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8015de:	74 12                	je     8015f2 <malloc+0x12a>

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  8015e0:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  8015e7:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  8015ee:	76 af                	jbe    80159f <malloc+0xd7>
  8015f0:	eb 01                	jmp    8015f3 <malloc+0x12b>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == numOfPages) {
			break;
  8015f2:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
  8015f3:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8015f7:	74 08                	je     801601 <malloc+0x139>
  8015f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015fc:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8015ff:	74 07                	je     801608 <malloc+0x140>
		return NULL;
  801601:	b8 00 00 00 00       	mov    $0x0,%eax
  801606:	eb 74                	jmp    80167c <malloc+0x1b4>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  801608:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80160b:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80160e:	c1 e8 0c             	shr    $0xc,%eax
  801611:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numOfPages;
  801614:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801617:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80161a:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  801621:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801624:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801627:	eb 11                	jmp    80163a <malloc+0x172>
		markedPages[i] = 1;
  801629:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80162c:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  801633:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = numOfPages;
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  801637:	ff 45 e8             	incl   -0x18(%ebp)
  80163a:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80163d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801640:	01 d0                	add    %edx,%eax
  801642:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801645:	77 e2                	ja     801629 <malloc+0x161>
		markedPages[i] = 1;
	}

	sys_allocate_user_mem(start, ROUNDUP(size, PAGE_SIZE));
  801647:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  80164e:	8b 55 08             	mov    0x8(%ebp),%edx
  801651:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801654:	01 d0                	add    %edx,%eax
  801656:	48                   	dec    %eax
  801657:	89 45 b8             	mov    %eax,-0x48(%ebp)
  80165a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80165d:	ba 00 00 00 00       	mov    $0x0,%edx
  801662:	f7 75 bc             	divl   -0x44(%ebp)
  801665:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801668:	29 d0                	sub    %edx,%eax
  80166a:	83 ec 08             	sub    $0x8,%esp
  80166d:	50                   	push   %eax
  80166e:	ff 75 f0             	pushl  -0x10(%ebp)
  801671:	e8 14 0b 00 00       	call   80218a <sys_allocate_user_mem>
  801676:	83 c4 10             	add    $0x10,%esp
	return (void*) start;
  801679:	8b 45 f0             	mov    -0x10(%ebp),%eax

}
  80167c:	c9                   	leave  
  80167d:	c3                   	ret    

0080167e <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address) {
  80167e:	55                   	push   %ebp
  80167f:	89 e5                	mov    %esp,%ebp
  801681:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
  801684:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801688:	0f 84 ee 00 00 00    	je     80177c <free+0xfe>
		return;
	}

	if (virtual_address
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  80168e:	a1 20 50 80 00       	mov    0x805020,%eax
  801693:	8b 40 74             	mov    0x74(%eax),%eax

	if (virtual_address == NULL) {
		return;
	}

	if (virtual_address
  801696:	3b 45 08             	cmp    0x8(%ebp),%eax
  801699:	77 09                	ja     8016a4 <free+0x26>
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  80169b:	81 7d 08 00 00 00 a0 	cmpl   $0xa0000000,0x8(%ebp)
  8016a2:	76 14                	jbe    8016b8 <free+0x3a>
		panic("INVALID VIRTUAL ADDRESS!!");
  8016a4:	83 ec 04             	sub    $0x4,%esp
  8016a7:	68 18 40 80 00       	push   $0x804018
  8016ac:	6a 68                	push   $0x68
  8016ae:	68 32 40 80 00       	push   $0x804032
  8016b3:	e8 94 1f 00 00       	call   80364c <_panic>
	}
	if (virtual_address >= (void *) (myEnv->uheapStart)
  8016b8:	a1 20 50 80 00       	mov    0x805020,%eax
  8016bd:	8b 40 74             	mov    0x74(%eax),%eax
  8016c0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8016c3:	77 20                	ja     8016e5 <free+0x67>
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
  8016c5:	a1 20 50 80 00       	mov    0x805020,%eax
  8016ca:	8b 40 78             	mov    0x78(%eax),%eax
  8016cd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8016d0:	76 13                	jbe    8016e5 <free+0x67>
		free_block(virtual_address);
  8016d2:	83 ec 0c             	sub    $0xc,%esp
  8016d5:	ff 75 08             	pushl  0x8(%ebp)
  8016d8:	e8 6c 16 00 00       	call   802d49 <free_block>
  8016dd:	83 c4 10             	add    $0x10,%esp
		return;
  8016e0:	e9 98 00 00 00       	jmp    80177d <free+0xff>
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  8016e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8016e8:	a1 20 50 80 00       	mov    0x805020,%eax
  8016ed:	8b 40 7c             	mov    0x7c(%eax),%eax
  8016f0:	29 c2                	sub    %eax,%edx
  8016f2:	89 d0                	mov    %edx,%eax
  8016f4:	2d 00 10 00 00       	sub    $0x1000,%eax
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
		free_block(virtual_address);
		return;
	}

	uint32 pageIdx = ((uint32) virtual_address
  8016f9:	c1 e8 0c             	shr    $0xc,%eax
  8016fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  8016ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801706:	eb 16                	jmp    80171e <free+0xa0>
		markedPages[idx + pageIdx] = 0;
  801708:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80170b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80170e:	01 d0                	add    %edx,%eax
  801710:	c7 04 85 40 50 90 00 	movl   $0x0,0x905040(,%eax,4)
  801717:	00 00 00 00 
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  80171b:	ff 45 f4             	incl   -0xc(%ebp)
  80171e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801721:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  801728:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80172b:	7f db                	jg     801708 <free+0x8a>
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;
  80172d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801730:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  801737:	c1 e0 0c             	shl    $0xc,%eax
  80173a:	89 45 e8             	mov    %eax,-0x18(%ebp)

	for (uint32 i = (uint32) virtual_address;
  80173d:	8b 45 08             	mov    0x8(%ebp),%eax
  801740:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801743:	eb 1a                	jmp    80175f <free+0xe1>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
  801745:	83 ec 08             	sub    $0x8,%esp
  801748:	68 00 10 00 00       	push   $0x1000
  80174d:	ff 75 f0             	pushl  -0x10(%ebp)
  801750:	e8 19 0a 00 00       	call   80216e <sys_free_user_mem>
  801755:	83 c4 10             	add    $0x10,%esp
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
  801758:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  80175f:	8b 55 08             	mov    0x8(%ebp),%edx
  801762:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801765:	01 d0                	add    %edx,%eax
	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
  801767:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80176a:	77 d9                	ja     801745 <free+0xc7>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;
  80176c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80176f:	c7 04 85 40 50 80 00 	movl   $0x0,0x805040(,%eax,4)
  801776:	00 00 00 00 
  80177a:	eb 01                	jmp    80177d <free+0xff>
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
		return;
  80177c:	90                   	nop
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;

}
  80177d:	c9                   	leave  
  80177e:	c3                   	ret    

0080177f <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  80177f:	55                   	push   %ebp
  801780:	89 e5                	mov    %esp,%ebp
  801782:	83 ec 58             	sub    $0x58,%esp
  801785:	8b 45 10             	mov    0x10(%ebp),%eax
  801788:	88 45 b4             	mov    %al,-0x4c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  80178b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80178f:	75 0a                	jne    80179b <smalloc+0x1c>
		return NULL;
  801791:	b8 00 00 00 00       	mov    $0x0,%eax
  801796:	e9 7d 01 00 00       	jmp    801918 <smalloc+0x199>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	uint32 num_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  80179b:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  8017a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017a8:	01 d0                	add    %edx,%eax
  8017aa:	48                   	dec    %eax
  8017ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8017ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8017b6:	f7 75 e4             	divl   -0x1c(%ebp)
  8017b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017bc:	29 d0                	sub    %edx,%eax
  8017be:	c1 e8 0c             	shr    $0xc,%eax
  8017c1:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 freePagesCount = 0;
  8017c4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  8017cb:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  8017d2:	a1 20 50 80 00       	mov    0x805020,%eax
  8017d7:	8b 40 7c             	mov    0x7c(%eax),%eax
  8017da:	05 00 10 00 00       	add    $0x1000,%eax
  8017df:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  8017e2:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8017e7:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8017ea:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  8017ed:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  8017f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8017fa:	01 d0                	add    %edx,%eax
  8017fc:	48                   	dec    %eax
  8017fd:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801800:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801803:	ba 00 00 00 00       	mov    $0x0,%edx
  801808:	f7 75 d0             	divl   -0x30(%ebp)
  80180b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80180e:	29 d0                	sub    %edx,%eax
  801810:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801813:	76 0a                	jbe    80181f <smalloc+0xa0>
		return NULL;
  801815:	b8 00 00 00 00       	mov    $0x0,%eax
  80181a:	e9 f9 00 00 00       	jmp    801918 <smalloc+0x199>
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  80181f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801822:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801825:	eb 48                	jmp    80186f <smalloc+0xf0>
		uint32 idx = (s - currentAddr) / PAGE_SIZE;
  801827:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80182a:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80182d:	c1 e8 0c             	shr    $0xc,%eax
  801830:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (!markedPages[idx]) {
  801833:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801836:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  80183d:	85 c0                	test   %eax,%eax
  80183f:	75 11                	jne    801852 <smalloc+0xd3>
			freePagesCount++;
  801841:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801844:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801848:	75 16                	jne    801860 <smalloc+0xe1>
				start = s;
  80184a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80184d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801850:	eb 0e                	jmp    801860 <smalloc+0xe1>
			}
		} else {
			freePagesCount = 0;
  801852:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  801859:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == num_Of_Pages) {
  801860:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801863:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801866:	74 12                	je     80187a <smalloc+0xfb>
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801868:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  80186f:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801876:	76 af                	jbe    801827 <smalloc+0xa8>
  801878:	eb 01                	jmp    80187b <smalloc+0xfc>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == num_Of_Pages) {
			break;
  80187a:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
  80187b:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80187f:	74 08                	je     801889 <smalloc+0x10a>
  801881:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801884:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801887:	74 0a                	je     801893 <smalloc+0x114>
		return NULL;
  801889:	b8 00 00 00 00       	mov    $0x0,%eax
  80188e:	e9 85 00 00 00       	jmp    801918 <smalloc+0x199>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  801893:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801896:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801899:	c1 e8 0c             	shr    $0xc,%eax
  80189c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	pagesAllocated[startPage] = num_Of_Pages;
  80189f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8018a2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8018a5:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  8018ac:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8018af:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8018b2:	eb 11                	jmp    8018c5 <smalloc+0x146>
		markedPages[s] = 1;
  8018b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018b7:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  8018be:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = num_Of_Pages;
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  8018c2:	ff 45 e8             	incl   -0x18(%ebp)
  8018c5:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8018c8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018cb:	01 d0                	add    %edx,%eax
  8018cd:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8018d0:	77 e2                	ja     8018b4 <smalloc+0x135>
		markedPages[s] = 1;
	}
	int sharedobjID = sys_createSharedObject(sharedVarName, size, isWritable,
  8018d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018d5:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
  8018d9:	52                   	push   %edx
  8018da:	50                   	push   %eax
  8018db:	ff 75 0c             	pushl  0xc(%ebp)
  8018de:	ff 75 08             	pushl  0x8(%ebp)
  8018e1:	e8 8f 04 00 00       	call   801d75 <sys_createSharedObject>
  8018e6:	83 c4 10             	add    $0x10,%esp
  8018e9:	89 45 c0             	mov    %eax,-0x40(%ebp)
			(void*) start);

	if (sharedobjID >= 0) {
  8018ec:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  8018f0:	78 12                	js     801904 <smalloc+0x185>
		shardIDs[startPage] = sharedobjID;
  8018f2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8018f5:	8b 55 c0             	mov    -0x40(%ebp),%edx
  8018f8:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  8018ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801902:	eb 14                	jmp    801918 <smalloc+0x199>
	}
	free((void*) start);
  801904:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801907:	83 ec 0c             	sub    $0xc,%esp
  80190a:	50                   	push   %eax
  80190b:	e8 6e fd ff ff       	call   80167e <free>
  801910:	83 c4 10             	add    $0x10,%esp
	return NULL;
  801913:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801918:	c9                   	leave  
  801919:	c3                   	ret    

0080191a <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  80191a:	55                   	push   %ebp
  80191b:	89 e5                	mov    %esp,%ebp
  80191d:	83 ec 48             	sub    $0x48,%esp
	//cprintf("SSSSSGEEETTT\n");
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID, sharedVarName);
  801920:	83 ec 08             	sub    $0x8,%esp
  801923:	ff 75 0c             	pushl  0xc(%ebp)
  801926:	ff 75 08             	pushl  0x8(%ebp)
  801929:	e8 71 04 00 00       	call   801d9f <sys_getSizeOfSharedObject>
  80192e:	83 c4 10             	add    $0x10,%esp
  801931:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (size < 0)
		return NULL;
	uint32 numb_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801934:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80193b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80193e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801941:	01 d0                	add    %edx,%eax
  801943:	48                   	dec    %eax
  801944:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801947:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80194a:	ba 00 00 00 00       	mov    $0x0,%edx
  80194f:	f7 75 e0             	divl   -0x20(%ebp)
  801952:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801955:	29 d0                	sub    %edx,%eax
  801957:	c1 e8 0c             	shr    $0xc,%eax
  80195a:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 free_Pages_Count = 0;
  80195d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801964:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
  80196b:	a1 20 50 80 00       	mov    0x805020,%eax
  801970:	8b 40 7c             	mov    0x7c(%eax),%eax
  801973:	05 00 10 00 00       	add    $0x1000,%eax
  801978:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
  80197b:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801980:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801983:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
  801986:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80198d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801990:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801993:	01 d0                	add    %edx,%eax
  801995:	48                   	dec    %eax
  801996:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801999:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80199c:	ba 00 00 00 00       	mov    $0x0,%edx
  8019a1:	f7 75 cc             	divl   -0x34(%ebp)
  8019a4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8019a7:	29 d0                	sub    %edx,%eax
  8019a9:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8019ac:	76 0a                	jbe    8019b8 <sget+0x9e>
		return NULL;
  8019ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8019b3:	e9 f7 00 00 00       	jmp    801aaf <sget+0x195>
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  8019b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8019bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8019be:	eb 48                	jmp    801a08 <sget+0xee>
		uint32 idx = (s - current_Addr) / PAGE_SIZE;
  8019c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019c3:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8019c6:	c1 e8 0c             	shr    $0xc,%eax
  8019c9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if (!markedPages[idx]) {
  8019cc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8019cf:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  8019d6:	85 c0                	test   %eax,%eax
  8019d8:	75 11                	jne    8019eb <sget+0xd1>
			free_Pages_Count++;
  8019da:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  8019dd:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8019e1:	75 16                	jne    8019f9 <sget+0xdf>
				start = s;
  8019e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019e9:	eb 0e                	jmp    8019f9 <sget+0xdf>
			}
		} else {
			free_Pages_Count = 0;
  8019eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  8019f2:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (free_Pages_Count == numb_Of_Pages) {
  8019f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019fc:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8019ff:	74 12                	je     801a13 <sget+0xf9>
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
		return NULL;
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801a01:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801a08:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801a0f:	76 af                	jbe    8019c0 <sget+0xa6>
  801a11:	eb 01                	jmp    801a14 <sget+0xfa>
		} else {
			free_Pages_Count = 0;
			start = (uint32) -1;
		}
		if (free_Pages_Count == numb_Of_Pages) {
			break;
  801a13:	90                   	nop
		}
	}
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
  801a14:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801a18:	74 08                	je     801a22 <sget+0x108>
  801a1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a1d:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801a20:	74 0a                	je     801a2c <sget+0x112>
		return NULL;
  801a22:	b8 00 00 00 00       	mov    $0x0,%eax
  801a27:	e9 83 00 00 00       	jmp    801aaf <sget+0x195>
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
  801a2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a2f:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801a32:	c1 e8 0c             	shr    $0xc,%eax
  801a35:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numb_Of_Pages;
  801a38:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801a3b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801a3e:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  801a45:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801a48:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801a4b:	eb 11                	jmp    801a5e <sget+0x144>
		markedPages[k] = 1;
  801a4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a50:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  801a57:	01 00 00 00 
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
	pagesAllocated[startPage] = numb_Of_Pages;
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  801a5b:	ff 45 e8             	incl   -0x18(%ebp)
  801a5e:	8b 55 c0             	mov    -0x40(%ebp),%edx
  801a61:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a64:	01 d0                	add    %edx,%eax
  801a66:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801a69:	77 e2                	ja     801a4d <sget+0x133>
		markedPages[k] = 1;
	}
	int ss = sys_getSharedObject(ownerEnvID, sharedVarName, (void*) start);
  801a6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a6e:	83 ec 04             	sub    $0x4,%esp
  801a71:	50                   	push   %eax
  801a72:	ff 75 0c             	pushl  0xc(%ebp)
  801a75:	ff 75 08             	pushl  0x8(%ebp)
  801a78:	e8 3f 03 00 00       	call   801dbc <sys_getSharedObject>
  801a7d:	83 c4 10             	add    $0x10,%esp
  801a80:	89 45 bc             	mov    %eax,-0x44(%ebp)
	if (ss >= 0) {
  801a83:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  801a87:	78 12                	js     801a9b <sget+0x181>
		shardIDs[startPage] = ss;
  801a89:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801a8c:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801a8f:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  801a96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a99:	eb 14                	jmp    801aaf <sget+0x195>
	}
	free((void*) start);
  801a9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a9e:	83 ec 0c             	sub    $0xc,%esp
  801aa1:	50                   	push   %eax
  801aa2:	e8 d7 fb ff ff       	call   80167e <free>
  801aa7:	83 c4 10             	add    $0x10,%esp
	return NULL;
  801aaa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aaf:	c9                   	leave  
  801ab0:	c3                   	ret    

00801ab1 <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  801ab1:	55                   	push   %ebp
  801ab2:	89 e5                	mov    %esp,%ebp
  801ab4:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  801ab7:	8b 55 08             	mov    0x8(%ebp),%edx
  801aba:	a1 20 50 80 00       	mov    0x805020,%eax
  801abf:	8b 40 7c             	mov    0x7c(%eax),%eax
  801ac2:	29 c2                	sub    %eax,%edx
  801ac4:	89 d0                	mov    %edx,%eax
  801ac6:	2d 00 10 00 00       	sub    $0x1000,%eax

void sfree(void* virtual_address) {
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
  801acb:	c1 e8 0c             	shr    $0xc,%eax
  801ace:	89 45 f4             	mov    %eax,-0xc(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
	int id = shardIDs[pageIdx];
  801ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ad4:	8b 04 85 40 50 88 00 	mov    0x885040(,%eax,4),%eax
  801adb:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int result = sys_freeSharedObject(id, virtual_address);
  801ade:	83 ec 08             	sub    $0x8,%esp
  801ae1:	ff 75 08             	pushl  0x8(%ebp)
  801ae4:	ff 75 f0             	pushl  -0x10(%ebp)
  801ae7:	e8 ef 02 00 00       	call   801ddb <sys_freeSharedObject>
  801aec:	83 c4 10             	add    $0x10,%esp
  801aef:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (result == 0) {
  801af2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801af6:	75 0e                	jne    801b06 <sfree+0x55>
		shardIDs[pageIdx] = -1;  // Reset the ID after freeing
  801af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801afb:	c7 04 85 40 50 88 00 	movl   $0xffffffff,0x885040(,%eax,4)
  801b02:	ff ff ff ff 
	}

}
  801b06:	90                   	nop
  801b07:	c9                   	leave  
  801b08:	c3                   	ret    

00801b09 <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  801b09:	55                   	push   %ebp
  801b0a:	89 e5                	mov    %esp,%ebp
  801b0c:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801b0f:	83 ec 04             	sub    $0x4,%esp
  801b12:	68 40 40 80 00       	push   $0x804040
  801b17:	68 19 01 00 00       	push   $0x119
  801b1c:	68 32 40 80 00       	push   $0x804032
  801b21:	e8 26 1b 00 00       	call   80364c <_panic>

00801b26 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  801b26:	55                   	push   %ebp
  801b27:	89 e5                	mov    %esp,%ebp
  801b29:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b2c:	83 ec 04             	sub    $0x4,%esp
  801b2f:	68 66 40 80 00       	push   $0x804066
  801b34:	68 23 01 00 00       	push   $0x123
  801b39:	68 32 40 80 00       	push   $0x804032
  801b3e:	e8 09 1b 00 00       	call   80364c <_panic>

00801b43 <shrink>:

}
void shrink(uint32 newSize) {
  801b43:	55                   	push   %ebp
  801b44:	89 e5                	mov    %esp,%ebp
  801b46:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b49:	83 ec 04             	sub    $0x4,%esp
  801b4c:	68 66 40 80 00       	push   $0x804066
  801b51:	68 27 01 00 00       	push   $0x127
  801b56:	68 32 40 80 00       	push   $0x804032
  801b5b:	e8 ec 1a 00 00       	call   80364c <_panic>

00801b60 <freeHeap>:

}
void freeHeap(void* virtual_address) {
  801b60:	55                   	push   %ebp
  801b61:	89 e5                	mov    %esp,%ebp
  801b63:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b66:	83 ec 04             	sub    $0x4,%esp
  801b69:	68 66 40 80 00       	push   $0x804066
  801b6e:	68 2b 01 00 00       	push   $0x12b
  801b73:	68 32 40 80 00       	push   $0x804032
  801b78:	e8 cf 1a 00 00       	call   80364c <_panic>

00801b7d <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  801b7d:	55                   	push   %ebp
  801b7e:	89 e5                	mov    %esp,%ebp
  801b80:	57                   	push   %edi
  801b81:	56                   	push   %esi
  801b82:	53                   	push   %ebx
  801b83:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b86:	8b 45 08             	mov    0x8(%ebp),%eax
  801b89:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b8c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b8f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b92:	8b 7d 18             	mov    0x18(%ebp),%edi
  801b95:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801b98:	cd 30                	int    $0x30
  801b9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  801b9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ba0:	83 c4 10             	add    $0x10,%esp
  801ba3:	5b                   	pop    %ebx
  801ba4:	5e                   	pop    %esi
  801ba5:	5f                   	pop    %edi
  801ba6:	5d                   	pop    %ebp
  801ba7:	c3                   	ret    

00801ba8 <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  801ba8:	55                   	push   %ebp
  801ba9:	89 e5                	mov    %esp,%ebp
  801bab:	83 ec 04             	sub    $0x4,%esp
  801bae:	8b 45 10             	mov    0x10(%ebp),%eax
  801bb1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  801bb4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	52                   	push   %edx
  801bc0:	ff 75 0c             	pushl  0xc(%ebp)
  801bc3:	50                   	push   %eax
  801bc4:	6a 00                	push   $0x0
  801bc6:	e8 b2 ff ff ff       	call   801b7d <syscall>
  801bcb:	83 c4 18             	add    $0x18,%esp
}
  801bce:	90                   	nop
  801bcf:	c9                   	leave  
  801bd0:	c3                   	ret    

00801bd1 <sys_cgetc>:

int sys_cgetc(void) {
  801bd1:	55                   	push   %ebp
  801bd2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 02                	push   $0x2
  801be0:	e8 98 ff ff ff       	call   801b7d <syscall>
  801be5:	83 c4 18             	add    $0x18,%esp
}
  801be8:	c9                   	leave  
  801be9:	c3                   	ret    

00801bea <sys_lock_cons>:

void sys_lock_cons(void) {
  801bea:	55                   	push   %ebp
  801beb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 03                	push   $0x3
  801bf9:	e8 7f ff ff ff       	call   801b7d <syscall>
  801bfe:	83 c4 18             	add    $0x18,%esp
}
  801c01:	90                   	nop
  801c02:	c9                   	leave  
  801c03:	c3                   	ret    

00801c04 <sys_unlock_cons>:
void sys_unlock_cons(void) {
  801c04:	55                   	push   %ebp
  801c05:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 04                	push   $0x4
  801c13:	e8 65 ff ff ff       	call   801b7d <syscall>
  801c18:	83 c4 18             	add    $0x18,%esp
}
  801c1b:	90                   	nop
  801c1c:	c9                   	leave  
  801c1d:	c3                   	ret    

00801c1e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  801c1e:	55                   	push   %ebp
  801c1f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  801c21:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c24:	8b 45 08             	mov    0x8(%ebp),%eax
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	52                   	push   %edx
  801c2e:	50                   	push   %eax
  801c2f:	6a 08                	push   $0x8
  801c31:	e8 47 ff ff ff       	call   801b7d <syscall>
  801c36:	83 c4 18             	add    $0x18,%esp
}
  801c39:	c9                   	leave  
  801c3a:	c3                   	ret    

00801c3b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  801c3b:	55                   	push   %ebp
  801c3c:	89 e5                	mov    %esp,%ebp
  801c3e:	56                   	push   %esi
  801c3f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  801c40:	8b 75 18             	mov    0x18(%ebp),%esi
  801c43:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c46:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c49:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4f:	56                   	push   %esi
  801c50:	53                   	push   %ebx
  801c51:	51                   	push   %ecx
  801c52:	52                   	push   %edx
  801c53:	50                   	push   %eax
  801c54:	6a 09                	push   $0x9
  801c56:	e8 22 ff ff ff       	call   801b7d <syscall>
  801c5b:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  801c5e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c61:	5b                   	pop    %ebx
  801c62:	5e                   	pop    %esi
  801c63:	5d                   	pop    %ebp
  801c64:	c3                   	ret    

00801c65 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  801c65:	55                   	push   %ebp
  801c66:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801c68:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	52                   	push   %edx
  801c75:	50                   	push   %eax
  801c76:	6a 0a                	push   $0xa
  801c78:	e8 00 ff ff ff       	call   801b7d <syscall>
  801c7d:	83 c4 18             	add    $0x18,%esp
}
  801c80:	c9                   	leave  
  801c81:	c3                   	ret    

00801c82 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  801c82:	55                   	push   %ebp
  801c83:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	ff 75 0c             	pushl  0xc(%ebp)
  801c8e:	ff 75 08             	pushl  0x8(%ebp)
  801c91:	6a 0b                	push   $0xb
  801c93:	e8 e5 fe ff ff       	call   801b7d <syscall>
  801c98:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  801c9b:	c9                   	leave  
  801c9c:	c3                   	ret    

00801c9d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  801c9d:	55                   	push   %ebp
  801c9e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 0c                	push   $0xc
  801cac:	e8 cc fe ff ff       	call   801b7d <syscall>
  801cb1:	83 c4 18             	add    $0x18,%esp
}
  801cb4:	c9                   	leave  
  801cb5:	c3                   	ret    

00801cb6 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  801cb6:	55                   	push   %ebp
  801cb7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 0d                	push   $0xd
  801cc5:	e8 b3 fe ff ff       	call   801b7d <syscall>
  801cca:	83 c4 18             	add    $0x18,%esp
}
  801ccd:	c9                   	leave  
  801cce:	c3                   	ret    

00801ccf <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  801ccf:	55                   	push   %ebp
  801cd0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 0e                	push   $0xe
  801cde:	e8 9a fe ff ff       	call   801b7d <syscall>
  801ce3:	83 c4 18             	add    $0x18,%esp
}
  801ce6:	c9                   	leave  
  801ce7:	c3                   	ret    

00801ce8 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  801ce8:	55                   	push   %ebp
  801ce9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 0f                	push   $0xf
  801cf7:	e8 81 fe ff ff       	call   801b7d <syscall>
  801cfc:	83 c4 18             	add    $0x18,%esp
}
  801cff:	c9                   	leave  
  801d00:	c3                   	ret    

00801d01 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  801d01:	55                   	push   %ebp
  801d02:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	6a 00                	push   $0x0
  801d0a:	6a 00                	push   $0x0
  801d0c:	ff 75 08             	pushl  0x8(%ebp)
  801d0f:	6a 10                	push   $0x10
  801d11:	e8 67 fe ff ff       	call   801b7d <syscall>
  801d16:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  801d19:	c9                   	leave  
  801d1a:	c3                   	ret    

00801d1b <sys_scarce_memory>:

void sys_scarce_memory() {
  801d1b:	55                   	push   %ebp
  801d1c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	6a 11                	push   $0x11
  801d2a:	e8 4e fe ff ff       	call   801b7d <syscall>
  801d2f:	83 c4 18             	add    $0x18,%esp
}
  801d32:	90                   	nop
  801d33:	c9                   	leave  
  801d34:	c3                   	ret    

00801d35 <sys_cputc>:

void sys_cputc(const char c) {
  801d35:	55                   	push   %ebp
  801d36:	89 e5                	mov    %esp,%ebp
  801d38:	83 ec 04             	sub    $0x4,%esp
  801d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801d41:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	50                   	push   %eax
  801d4e:	6a 01                	push   $0x1
  801d50:	e8 28 fe ff ff       	call   801b7d <syscall>
  801d55:	83 c4 18             	add    $0x18,%esp
}
  801d58:	90                   	nop
  801d59:	c9                   	leave  
  801d5a:	c3                   	ret    

00801d5b <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  801d5b:	55                   	push   %ebp
  801d5c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 14                	push   $0x14
  801d6a:	e8 0e fe ff ff       	call   801b7d <syscall>
  801d6f:	83 c4 18             	add    $0x18,%esp
}
  801d72:	90                   	nop
  801d73:	c9                   	leave  
  801d74:	c3                   	ret    

00801d75 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  801d75:	55                   	push   %ebp
  801d76:	89 e5                	mov    %esp,%ebp
  801d78:	83 ec 04             	sub    $0x4,%esp
  801d7b:	8b 45 10             	mov    0x10(%ebp),%eax
  801d7e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  801d81:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d84:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d88:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8b:	6a 00                	push   $0x0
  801d8d:	51                   	push   %ecx
  801d8e:	52                   	push   %edx
  801d8f:	ff 75 0c             	pushl  0xc(%ebp)
  801d92:	50                   	push   %eax
  801d93:	6a 15                	push   $0x15
  801d95:	e8 e3 fd ff ff       	call   801b7d <syscall>
  801d9a:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  801d9d:	c9                   	leave  
  801d9e:	c3                   	ret    

00801d9f <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  801d9f:	55                   	push   %ebp
  801da0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  801da2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801da5:	8b 45 08             	mov    0x8(%ebp),%eax
  801da8:	6a 00                	push   $0x0
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	52                   	push   %edx
  801daf:	50                   	push   %eax
  801db0:	6a 16                	push   $0x16
  801db2:	e8 c6 fd ff ff       	call   801b7d <syscall>
  801db7:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  801dba:	c9                   	leave  
  801dbb:	c3                   	ret    

00801dbc <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  801dbc:	55                   	push   %ebp
  801dbd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  801dbf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dc2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	51                   	push   %ecx
  801dcd:	52                   	push   %edx
  801dce:	50                   	push   %eax
  801dcf:	6a 17                	push   $0x17
  801dd1:	e8 a7 fd ff ff       	call   801b7d <syscall>
  801dd6:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  801dd9:	c9                   	leave  
  801dda:	c3                   	ret    

00801ddb <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  801ddb:	55                   	push   %ebp
  801ddc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  801dde:	8b 55 0c             	mov    0xc(%ebp),%edx
  801de1:	8b 45 08             	mov    0x8(%ebp),%eax
  801de4:	6a 00                	push   $0x0
  801de6:	6a 00                	push   $0x0
  801de8:	6a 00                	push   $0x0
  801dea:	52                   	push   %edx
  801deb:	50                   	push   %eax
  801dec:	6a 18                	push   $0x18
  801dee:	e8 8a fd ff ff       	call   801b7d <syscall>
  801df3:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  801df6:	c9                   	leave  
  801df7:	c3                   	ret    

00801df8 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  801df8:	55                   	push   %ebp
  801df9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  801dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfe:	6a 00                	push   $0x0
  801e00:	ff 75 14             	pushl  0x14(%ebp)
  801e03:	ff 75 10             	pushl  0x10(%ebp)
  801e06:	ff 75 0c             	pushl  0xc(%ebp)
  801e09:	50                   	push   %eax
  801e0a:	6a 19                	push   $0x19
  801e0c:	e8 6c fd ff ff       	call   801b7d <syscall>
  801e11:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  801e14:	c9                   	leave  
  801e15:	c3                   	ret    

00801e16 <sys_run_env>:

void sys_run_env(int32 envId) {
  801e16:	55                   	push   %ebp
  801e17:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  801e19:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1c:	6a 00                	push   $0x0
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	50                   	push   %eax
  801e25:	6a 1a                	push   $0x1a
  801e27:	e8 51 fd ff ff       	call   801b7d <syscall>
  801e2c:	83 c4 18             	add    $0x18,%esp
}
  801e2f:	90                   	nop
  801e30:	c9                   	leave  
  801e31:	c3                   	ret    

00801e32 <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  801e32:	55                   	push   %ebp
  801e33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801e35:	8b 45 08             	mov    0x8(%ebp),%eax
  801e38:	6a 00                	push   $0x0
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 00                	push   $0x0
  801e40:	50                   	push   %eax
  801e41:	6a 1b                	push   $0x1b
  801e43:	e8 35 fd ff ff       	call   801b7d <syscall>
  801e48:	83 c4 18             	add    $0x18,%esp
}
  801e4b:	c9                   	leave  
  801e4c:	c3                   	ret    

00801e4d <sys_getenvid>:

int32 sys_getenvid(void) {
  801e4d:	55                   	push   %ebp
  801e4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801e50:	6a 00                	push   $0x0
  801e52:	6a 00                	push   $0x0
  801e54:	6a 00                	push   $0x0
  801e56:	6a 00                	push   $0x0
  801e58:	6a 00                	push   $0x0
  801e5a:	6a 05                	push   $0x5
  801e5c:	e8 1c fd ff ff       	call   801b7d <syscall>
  801e61:	83 c4 18             	add    $0x18,%esp
}
  801e64:	c9                   	leave  
  801e65:	c3                   	ret    

00801e66 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  801e66:	55                   	push   %ebp
  801e67:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	6a 06                	push   $0x6
  801e75:	e8 03 fd ff ff       	call   801b7d <syscall>
  801e7a:	83 c4 18             	add    $0x18,%esp
}
  801e7d:	c9                   	leave  
  801e7e:	c3                   	ret    

00801e7f <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  801e7f:	55                   	push   %ebp
  801e80:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801e82:	6a 00                	push   $0x0
  801e84:	6a 00                	push   $0x0
  801e86:	6a 00                	push   $0x0
  801e88:	6a 00                	push   $0x0
  801e8a:	6a 00                	push   $0x0
  801e8c:	6a 07                	push   $0x7
  801e8e:	e8 ea fc ff ff       	call   801b7d <syscall>
  801e93:	83 c4 18             	add    $0x18,%esp
}
  801e96:	c9                   	leave  
  801e97:	c3                   	ret    

00801e98 <sys_exit_env>:

void sys_exit_env(void) {
  801e98:	55                   	push   %ebp
  801e99:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 00                	push   $0x0
  801ea5:	6a 1c                	push   $0x1c
  801ea7:	e8 d1 fc ff ff       	call   801b7d <syscall>
  801eac:	83 c4 18             	add    $0x18,%esp
}
  801eaf:	90                   	nop
  801eb0:	c9                   	leave  
  801eb1:	c3                   	ret    

00801eb2 <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  801eb2:	55                   	push   %ebp
  801eb3:	89 e5                	mov    %esp,%ebp
  801eb5:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  801eb8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ebb:	8d 50 04             	lea    0x4(%eax),%edx
  801ebe:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ec1:	6a 00                	push   $0x0
  801ec3:	6a 00                	push   $0x0
  801ec5:	6a 00                	push   $0x0
  801ec7:	52                   	push   %edx
  801ec8:	50                   	push   %eax
  801ec9:	6a 1d                	push   $0x1d
  801ecb:	e8 ad fc ff ff       	call   801b7d <syscall>
  801ed0:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  801ed3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ed6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ed9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801edc:	89 01                	mov    %eax,(%ecx)
  801ede:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee4:	c9                   	leave  
  801ee5:	c2 04 00             	ret    $0x4

00801ee8 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  801ee8:	55                   	push   %ebp
  801ee9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  801eeb:	6a 00                	push   $0x0
  801eed:	6a 00                	push   $0x0
  801eef:	ff 75 10             	pushl  0x10(%ebp)
  801ef2:	ff 75 0c             	pushl  0xc(%ebp)
  801ef5:	ff 75 08             	pushl  0x8(%ebp)
  801ef8:	6a 13                	push   $0x13
  801efa:	e8 7e fc ff ff       	call   801b7d <syscall>
  801eff:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  801f02:	90                   	nop
}
  801f03:	c9                   	leave  
  801f04:	c3                   	ret    

00801f05 <sys_rcr2>:
uint32 sys_rcr2() {
  801f05:	55                   	push   %ebp
  801f06:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801f08:	6a 00                	push   $0x0
  801f0a:	6a 00                	push   $0x0
  801f0c:	6a 00                	push   $0x0
  801f0e:	6a 00                	push   $0x0
  801f10:	6a 00                	push   $0x0
  801f12:	6a 1e                	push   $0x1e
  801f14:	e8 64 fc ff ff       	call   801b7d <syscall>
  801f19:	83 c4 18             	add    $0x18,%esp
}
  801f1c:	c9                   	leave  
  801f1d:	c3                   	ret    

00801f1e <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  801f1e:	55                   	push   %ebp
  801f1f:	89 e5                	mov    %esp,%ebp
  801f21:	83 ec 04             	sub    $0x4,%esp
  801f24:	8b 45 08             	mov    0x8(%ebp),%eax
  801f27:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801f2a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801f2e:	6a 00                	push   $0x0
  801f30:	6a 00                	push   $0x0
  801f32:	6a 00                	push   $0x0
  801f34:	6a 00                	push   $0x0
  801f36:	50                   	push   %eax
  801f37:	6a 1f                	push   $0x1f
  801f39:	e8 3f fc ff ff       	call   801b7d <syscall>
  801f3e:	83 c4 18             	add    $0x18,%esp
	return;
  801f41:	90                   	nop
}
  801f42:	c9                   	leave  
  801f43:	c3                   	ret    

00801f44 <rsttst>:
void rsttst() {
  801f44:	55                   	push   %ebp
  801f45:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801f47:	6a 00                	push   $0x0
  801f49:	6a 00                	push   $0x0
  801f4b:	6a 00                	push   $0x0
  801f4d:	6a 00                	push   $0x0
  801f4f:	6a 00                	push   $0x0
  801f51:	6a 21                	push   $0x21
  801f53:	e8 25 fc ff ff       	call   801b7d <syscall>
  801f58:	83 c4 18             	add    $0x18,%esp
	return;
  801f5b:	90                   	nop
}
  801f5c:	c9                   	leave  
  801f5d:	c3                   	ret    

00801f5e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  801f5e:	55                   	push   %ebp
  801f5f:	89 e5                	mov    %esp,%ebp
  801f61:	83 ec 04             	sub    $0x4,%esp
  801f64:	8b 45 14             	mov    0x14(%ebp),%eax
  801f67:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801f6a:	8b 55 18             	mov    0x18(%ebp),%edx
  801f6d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f71:	52                   	push   %edx
  801f72:	50                   	push   %eax
  801f73:	ff 75 10             	pushl  0x10(%ebp)
  801f76:	ff 75 0c             	pushl  0xc(%ebp)
  801f79:	ff 75 08             	pushl  0x8(%ebp)
  801f7c:	6a 20                	push   $0x20
  801f7e:	e8 fa fb ff ff       	call   801b7d <syscall>
  801f83:	83 c4 18             	add    $0x18,%esp
	return;
  801f86:	90                   	nop
}
  801f87:	c9                   	leave  
  801f88:	c3                   	ret    

00801f89 <chktst>:
void chktst(uint32 n) {
  801f89:	55                   	push   %ebp
  801f8a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801f8c:	6a 00                	push   $0x0
  801f8e:	6a 00                	push   $0x0
  801f90:	6a 00                	push   $0x0
  801f92:	6a 00                	push   $0x0
  801f94:	ff 75 08             	pushl  0x8(%ebp)
  801f97:	6a 22                	push   $0x22
  801f99:	e8 df fb ff ff       	call   801b7d <syscall>
  801f9e:	83 c4 18             	add    $0x18,%esp
	return;
  801fa1:	90                   	nop
}
  801fa2:	c9                   	leave  
  801fa3:	c3                   	ret    

00801fa4 <inctst>:

void inctst() {
  801fa4:	55                   	push   %ebp
  801fa5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801fa7:	6a 00                	push   $0x0
  801fa9:	6a 00                	push   $0x0
  801fab:	6a 00                	push   $0x0
  801fad:	6a 00                	push   $0x0
  801faf:	6a 00                	push   $0x0
  801fb1:	6a 23                	push   $0x23
  801fb3:	e8 c5 fb ff ff       	call   801b7d <syscall>
  801fb8:	83 c4 18             	add    $0x18,%esp
	return;
  801fbb:	90                   	nop
}
  801fbc:	c9                   	leave  
  801fbd:	c3                   	ret    

00801fbe <gettst>:
uint32 gettst() {
  801fbe:	55                   	push   %ebp
  801fbf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801fc1:	6a 00                	push   $0x0
  801fc3:	6a 00                	push   $0x0
  801fc5:	6a 00                	push   $0x0
  801fc7:	6a 00                	push   $0x0
  801fc9:	6a 00                	push   $0x0
  801fcb:	6a 24                	push   $0x24
  801fcd:	e8 ab fb ff ff       	call   801b7d <syscall>
  801fd2:	83 c4 18             	add    $0x18,%esp
}
  801fd5:	c9                   	leave  
  801fd6:	c3                   	ret    

00801fd7 <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  801fd7:	55                   	push   %ebp
  801fd8:	89 e5                	mov    %esp,%ebp
  801fda:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fdd:	6a 00                	push   $0x0
  801fdf:	6a 00                	push   $0x0
  801fe1:	6a 00                	push   $0x0
  801fe3:	6a 00                	push   $0x0
  801fe5:	6a 00                	push   $0x0
  801fe7:	6a 25                	push   $0x25
  801fe9:	e8 8f fb ff ff       	call   801b7d <syscall>
  801fee:	83 c4 18             	add    $0x18,%esp
  801ff1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ff4:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ff8:	75 07                	jne    802001 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ffa:	b8 01 00 00 00       	mov    $0x1,%eax
  801fff:	eb 05                	jmp    802006 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802001:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802006:	c9                   	leave  
  802007:	c3                   	ret    

00802008 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  802008:	55                   	push   %ebp
  802009:	89 e5                	mov    %esp,%ebp
  80200b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80200e:	6a 00                	push   $0x0
  802010:	6a 00                	push   $0x0
  802012:	6a 00                	push   $0x0
  802014:	6a 00                	push   $0x0
  802016:	6a 00                	push   $0x0
  802018:	6a 25                	push   $0x25
  80201a:	e8 5e fb ff ff       	call   801b7d <syscall>
  80201f:	83 c4 18             	add    $0x18,%esp
  802022:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802025:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802029:	75 07                	jne    802032 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80202b:	b8 01 00 00 00       	mov    $0x1,%eax
  802030:	eb 05                	jmp    802037 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802032:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802037:	c9                   	leave  
  802038:	c3                   	ret    

00802039 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  802039:	55                   	push   %ebp
  80203a:	89 e5                	mov    %esp,%ebp
  80203c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80203f:	6a 00                	push   $0x0
  802041:	6a 00                	push   $0x0
  802043:	6a 00                	push   $0x0
  802045:	6a 00                	push   $0x0
  802047:	6a 00                	push   $0x0
  802049:	6a 25                	push   $0x25
  80204b:	e8 2d fb ff ff       	call   801b7d <syscall>
  802050:	83 c4 18             	add    $0x18,%esp
  802053:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802056:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80205a:	75 07                	jne    802063 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80205c:	b8 01 00 00 00       	mov    $0x1,%eax
  802061:	eb 05                	jmp    802068 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802063:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802068:	c9                   	leave  
  802069:	c3                   	ret    

0080206a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  80206a:	55                   	push   %ebp
  80206b:	89 e5                	mov    %esp,%ebp
  80206d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802070:	6a 00                	push   $0x0
  802072:	6a 00                	push   $0x0
  802074:	6a 00                	push   $0x0
  802076:	6a 00                	push   $0x0
  802078:	6a 00                	push   $0x0
  80207a:	6a 25                	push   $0x25
  80207c:	e8 fc fa ff ff       	call   801b7d <syscall>
  802081:	83 c4 18             	add    $0x18,%esp
  802084:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802087:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80208b:	75 07                	jne    802094 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80208d:	b8 01 00 00 00       	mov    $0x1,%eax
  802092:	eb 05                	jmp    802099 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802094:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802099:	c9                   	leave  
  80209a:	c3                   	ret    

0080209b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  80209b:	55                   	push   %ebp
  80209c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80209e:	6a 00                	push   $0x0
  8020a0:	6a 00                	push   $0x0
  8020a2:	6a 00                	push   $0x0
  8020a4:	6a 00                	push   $0x0
  8020a6:	ff 75 08             	pushl  0x8(%ebp)
  8020a9:	6a 26                	push   $0x26
  8020ab:	e8 cd fa ff ff       	call   801b7d <syscall>
  8020b0:	83 c4 18             	add    $0x18,%esp
	return;
  8020b3:	90                   	nop
}
  8020b4:	c9                   	leave  
  8020b5:	c3                   	ret    

008020b6 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  8020b6:	55                   	push   %ebp
  8020b7:	89 e5                	mov    %esp,%ebp
  8020b9:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  8020ba:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020bd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c6:	6a 00                	push   $0x0
  8020c8:	53                   	push   %ebx
  8020c9:	51                   	push   %ecx
  8020ca:	52                   	push   %edx
  8020cb:	50                   	push   %eax
  8020cc:	6a 27                	push   $0x27
  8020ce:	e8 aa fa ff ff       	call   801b7d <syscall>
  8020d3:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  8020d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020d9:	c9                   	leave  
  8020da:	c3                   	ret    

008020db <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  8020db:	55                   	push   %ebp
  8020dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  8020de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e4:	6a 00                	push   $0x0
  8020e6:	6a 00                	push   $0x0
  8020e8:	6a 00                	push   $0x0
  8020ea:	52                   	push   %edx
  8020eb:	50                   	push   %eax
  8020ec:	6a 28                	push   $0x28
  8020ee:	e8 8a fa ff ff       	call   801b7d <syscall>
  8020f3:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  8020f6:	c9                   	leave  
  8020f7:	c3                   	ret    

008020f8 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  8020f8:	55                   	push   %ebp
  8020f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  8020fb:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8020fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  802101:	8b 45 08             	mov    0x8(%ebp),%eax
  802104:	6a 00                	push   $0x0
  802106:	51                   	push   %ecx
  802107:	ff 75 10             	pushl  0x10(%ebp)
  80210a:	52                   	push   %edx
  80210b:	50                   	push   %eax
  80210c:	6a 29                	push   $0x29
  80210e:	e8 6a fa ff ff       	call   801b7d <syscall>
  802113:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  802116:	c9                   	leave  
  802117:	c3                   	ret    

00802118 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  802118:	55                   	push   %ebp
  802119:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80211b:	6a 00                	push   $0x0
  80211d:	6a 00                	push   $0x0
  80211f:	ff 75 10             	pushl  0x10(%ebp)
  802122:	ff 75 0c             	pushl  0xc(%ebp)
  802125:	ff 75 08             	pushl  0x8(%ebp)
  802128:	6a 12                	push   $0x12
  80212a:	e8 4e fa ff ff       	call   801b7d <syscall>
  80212f:	83 c4 18             	add    $0x18,%esp
	return;
  802132:	90                   	nop
}
  802133:	c9                   	leave  
  802134:	c3                   	ret    

00802135 <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  802135:	55                   	push   %ebp
  802136:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  802138:	8b 55 0c             	mov    0xc(%ebp),%edx
  80213b:	8b 45 08             	mov    0x8(%ebp),%eax
  80213e:	6a 00                	push   $0x0
  802140:	6a 00                	push   $0x0
  802142:	6a 00                	push   $0x0
  802144:	52                   	push   %edx
  802145:	50                   	push   %eax
  802146:	6a 2a                	push   $0x2a
  802148:	e8 30 fa ff ff       	call   801b7d <syscall>
  80214d:	83 c4 18             	add    $0x18,%esp
	return;
  802150:	90                   	nop
}
  802151:	c9                   	leave  
  802152:	c3                   	ret    

00802153 <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  802153:	55                   	push   %ebp
  802154:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  802156:	8b 45 08             	mov    0x8(%ebp),%eax
  802159:	6a 00                	push   $0x0
  80215b:	6a 00                	push   $0x0
  80215d:	6a 00                	push   $0x0
  80215f:	6a 00                	push   $0x0
  802161:	50                   	push   %eax
  802162:	6a 2b                	push   $0x2b
  802164:	e8 14 fa ff ff       	call   801b7d <syscall>
  802169:	83 c4 18             	add    $0x18,%esp
}
  80216c:	c9                   	leave  
  80216d:	c3                   	ret    

0080216e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  80216e:	55                   	push   %ebp
  80216f:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802171:	6a 00                	push   $0x0
  802173:	6a 00                	push   $0x0
  802175:	6a 00                	push   $0x0
  802177:	ff 75 0c             	pushl  0xc(%ebp)
  80217a:	ff 75 08             	pushl  0x8(%ebp)
  80217d:	6a 2c                	push   $0x2c
  80217f:	e8 f9 f9 ff ff       	call   801b7d <syscall>
  802184:	83 c4 18             	add    $0x18,%esp
	return;
  802187:	90                   	nop
}
  802188:	c9                   	leave  
  802189:	c3                   	ret    

0080218a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  80218a:	55                   	push   %ebp
  80218b:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80218d:	6a 00                	push   $0x0
  80218f:	6a 00                	push   $0x0
  802191:	6a 00                	push   $0x0
  802193:	ff 75 0c             	pushl  0xc(%ebp)
  802196:	ff 75 08             	pushl  0x8(%ebp)
  802199:	6a 2d                	push   $0x2d
  80219b:	e8 dd f9 ff ff       	call   801b7d <syscall>
  8021a0:	83 c4 18             	add    $0x18,%esp
	return;
  8021a3:	90                   	nop
}
  8021a4:	c9                   	leave  
  8021a5:	c3                   	ret    

008021a6 <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  8021a6:	55                   	push   %ebp
  8021a7:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  8021a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ac:	6a 00                	push   $0x0
  8021ae:	6a 00                	push   $0x0
  8021b0:	6a 00                	push   $0x0
  8021b2:	6a 00                	push   $0x0
  8021b4:	50                   	push   %eax
  8021b5:	6a 2f                	push   $0x2f
  8021b7:	e8 c1 f9 ff ff       	call   801b7d <syscall>
  8021bc:	83 c4 18             	add    $0x18,%esp
	return;
  8021bf:	90                   	nop
}
  8021c0:	c9                   	leave  
  8021c1:	c3                   	ret    

008021c2 <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  8021c2:	55                   	push   %ebp
  8021c3:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  8021c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cb:	6a 00                	push   $0x0
  8021cd:	6a 00                	push   $0x0
  8021cf:	6a 00                	push   $0x0
  8021d1:	52                   	push   %edx
  8021d2:	50                   	push   %eax
  8021d3:	6a 30                	push   $0x30
  8021d5:	e8 a3 f9 ff ff       	call   801b7d <syscall>
  8021da:	83 c4 18             	add    $0x18,%esp
	return;
  8021dd:	90                   	nop
}
  8021de:	c9                   	leave  
  8021df:	c3                   	ret    

008021e0 <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  8021e0:	55                   	push   %ebp
  8021e1:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  8021e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e6:	6a 00                	push   $0x0
  8021e8:	6a 00                	push   $0x0
  8021ea:	6a 00                	push   $0x0
  8021ec:	6a 00                	push   $0x0
  8021ee:	50                   	push   %eax
  8021ef:	6a 31                	push   $0x31
  8021f1:	e8 87 f9 ff ff       	call   801b7d <syscall>
  8021f6:	83 c4 18             	add    $0x18,%esp
	return;
  8021f9:	90                   	nop
}
  8021fa:	c9                   	leave  
  8021fb:	c3                   	ret    

008021fc <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  8021fc:	55                   	push   %ebp
  8021fd:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8021ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  802202:	8b 45 08             	mov    0x8(%ebp),%eax
  802205:	6a 00                	push   $0x0
  802207:	6a 00                	push   $0x0
  802209:	6a 00                	push   $0x0
  80220b:	52                   	push   %edx
  80220c:	50                   	push   %eax
  80220d:	6a 2e                	push   $0x2e
  80220f:	e8 69 f9 ff ff       	call   801b7d <syscall>
  802214:	83 c4 18             	add    $0x18,%esp
    return;
  802217:	90                   	nop
}
  802218:	c9                   	leave  
  802219:	c3                   	ret    

0080221a <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  80221a:	55                   	push   %ebp
  80221b:	89 e5                	mov    %esp,%ebp
  80221d:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802220:	8b 45 08             	mov    0x8(%ebp),%eax
  802223:	83 e8 04             	sub    $0x4,%eax
  802226:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802229:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80222c:	8b 00                	mov    (%eax),%eax
  80222e:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802231:	c9                   	leave  
  802232:	c3                   	ret    

00802233 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802233:	55                   	push   %ebp
  802234:	89 e5                	mov    %esp,%ebp
  802236:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802239:	8b 45 08             	mov    0x8(%ebp),%eax
  80223c:	83 e8 04             	sub    $0x4,%eax
  80223f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802242:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802245:	8b 00                	mov    (%eax),%eax
  802247:	83 e0 01             	and    $0x1,%eax
  80224a:	85 c0                	test   %eax,%eax
  80224c:	0f 94 c0             	sete   %al
}
  80224f:	c9                   	leave  
  802250:	c3                   	ret    

00802251 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802251:	55                   	push   %ebp
  802252:	89 e5                	mov    %esp,%ebp
  802254:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802257:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  80225e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802261:	83 f8 02             	cmp    $0x2,%eax
  802264:	74 2b                	je     802291 <alloc_block+0x40>
  802266:	83 f8 02             	cmp    $0x2,%eax
  802269:	7f 07                	jg     802272 <alloc_block+0x21>
  80226b:	83 f8 01             	cmp    $0x1,%eax
  80226e:	74 0e                	je     80227e <alloc_block+0x2d>
  802270:	eb 58                	jmp    8022ca <alloc_block+0x79>
  802272:	83 f8 03             	cmp    $0x3,%eax
  802275:	74 2d                	je     8022a4 <alloc_block+0x53>
  802277:	83 f8 04             	cmp    $0x4,%eax
  80227a:	74 3b                	je     8022b7 <alloc_block+0x66>
  80227c:	eb 4c                	jmp    8022ca <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  80227e:	83 ec 0c             	sub    $0xc,%esp
  802281:	ff 75 08             	pushl  0x8(%ebp)
  802284:	e8 f7 03 00 00       	call   802680 <alloc_block_FF>
  802289:	83 c4 10             	add    $0x10,%esp
  80228c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80228f:	eb 4a                	jmp    8022db <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802291:	83 ec 0c             	sub    $0xc,%esp
  802294:	ff 75 08             	pushl  0x8(%ebp)
  802297:	e8 f0 11 00 00       	call   80348c <alloc_block_NF>
  80229c:	83 c4 10             	add    $0x10,%esp
  80229f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8022a2:	eb 37                	jmp    8022db <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8022a4:	83 ec 0c             	sub    $0xc,%esp
  8022a7:	ff 75 08             	pushl  0x8(%ebp)
  8022aa:	e8 08 08 00 00       	call   802ab7 <alloc_block_BF>
  8022af:	83 c4 10             	add    $0x10,%esp
  8022b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8022b5:	eb 24                	jmp    8022db <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8022b7:	83 ec 0c             	sub    $0xc,%esp
  8022ba:	ff 75 08             	pushl  0x8(%ebp)
  8022bd:	e8 ad 11 00 00       	call   80346f <alloc_block_WF>
  8022c2:	83 c4 10             	add    $0x10,%esp
  8022c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8022c8:	eb 11                	jmp    8022db <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8022ca:	83 ec 0c             	sub    $0xc,%esp
  8022cd:	68 78 40 80 00       	push   $0x804078
  8022d2:	e8 41 e4 ff ff       	call   800718 <cprintf>
  8022d7:	83 c4 10             	add    $0x10,%esp
		break;
  8022da:	90                   	nop
	}
	return va;
  8022db:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8022de:	c9                   	leave  
  8022df:	c3                   	ret    

008022e0 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8022e0:	55                   	push   %ebp
  8022e1:	89 e5                	mov    %esp,%ebp
  8022e3:	53                   	push   %ebx
  8022e4:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8022e7:	83 ec 0c             	sub    $0xc,%esp
  8022ea:	68 98 40 80 00       	push   $0x804098
  8022ef:	e8 24 e4 ff ff       	call   800718 <cprintf>
  8022f4:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8022f7:	83 ec 0c             	sub    $0xc,%esp
  8022fa:	68 c3 40 80 00       	push   $0x8040c3
  8022ff:	e8 14 e4 ff ff       	call   800718 <cprintf>
  802304:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802307:	8b 45 08             	mov    0x8(%ebp),%eax
  80230a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80230d:	eb 37                	jmp    802346 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  80230f:	83 ec 0c             	sub    $0xc,%esp
  802312:	ff 75 f4             	pushl  -0xc(%ebp)
  802315:	e8 19 ff ff ff       	call   802233 <is_free_block>
  80231a:	83 c4 10             	add    $0x10,%esp
  80231d:	0f be d8             	movsbl %al,%ebx
  802320:	83 ec 0c             	sub    $0xc,%esp
  802323:	ff 75 f4             	pushl  -0xc(%ebp)
  802326:	e8 ef fe ff ff       	call   80221a <get_block_size>
  80232b:	83 c4 10             	add    $0x10,%esp
  80232e:	83 ec 04             	sub    $0x4,%esp
  802331:	53                   	push   %ebx
  802332:	50                   	push   %eax
  802333:	68 db 40 80 00       	push   $0x8040db
  802338:	e8 db e3 ff ff       	call   800718 <cprintf>
  80233d:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802340:	8b 45 10             	mov    0x10(%ebp),%eax
  802343:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802346:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80234a:	74 07                	je     802353 <print_blocks_list+0x73>
  80234c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234f:	8b 00                	mov    (%eax),%eax
  802351:	eb 05                	jmp    802358 <print_blocks_list+0x78>
  802353:	b8 00 00 00 00       	mov    $0x0,%eax
  802358:	89 45 10             	mov    %eax,0x10(%ebp)
  80235b:	8b 45 10             	mov    0x10(%ebp),%eax
  80235e:	85 c0                	test   %eax,%eax
  802360:	75 ad                	jne    80230f <print_blocks_list+0x2f>
  802362:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802366:	75 a7                	jne    80230f <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802368:	83 ec 0c             	sub    $0xc,%esp
  80236b:	68 98 40 80 00       	push   $0x804098
  802370:	e8 a3 e3 ff ff       	call   800718 <cprintf>
  802375:	83 c4 10             	add    $0x10,%esp

}
  802378:	90                   	nop
  802379:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80237c:	c9                   	leave  
  80237d:	c3                   	ret    

0080237e <initialize_dynamic_allocator>:

//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  80237e:	55                   	push   %ebp
  80237f:	89 e5                	mov    %esp,%ebp
  802381:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802384:	8b 45 0c             	mov    0xc(%ebp),%eax
  802387:	83 e0 01             	and    $0x1,%eax
  80238a:	85 c0                	test   %eax,%eax
  80238c:	74 03                	je     802391 <initialize_dynamic_allocator+0x13>
  80238e:	ff 45 0c             	incl   0xc(%ebp)
		if (initSizeOfAllocatedSpace == 0)
  802391:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802395:	0f 84 f8 00 00 00    	je     802493 <initialize_dynamic_allocator+0x115>
			return ;
		is_initialized = 1;
  80239b:	c7 05 40 50 98 00 01 	movl   $0x1,0x985040
  8023a2:	00 00 00 
	//TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("initialize_dynamic_allocator is not implemented yet");
	//Your Code is Here...

	if(is_initialized){
  8023a5:	a1 40 50 98 00       	mov    0x985040,%eax
  8023aa:	85 c0                	test   %eax,%eax
  8023ac:	0f 84 e2 00 00 00    	je     802494 <initialize_dynamic_allocator+0x116>

		// begin block with size 0 and lsb = 1 (allocated)
		uint32* beginBlock = (uint32*)daStart;
  8023b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		*beginBlock = 0 | 1; // size = 0, LSB as a flag = 1
  8023b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bb:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		// end block with size 0 and lsb = 1 (allocated)
		uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);
  8023c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8023c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023c7:	01 d0                	add    %edx,%eax
  8023c9:	83 e8 04             	sub    $0x4,%eax
  8023cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
		*endBlock = 0 | 1; // size = 0, LSB as a flag = 1
  8023cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d2:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

		// the block that between begin and end blocks
		struct BlockElement* block = (struct BlockElement*)(daStart + 8);
  8023d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023db:	83 c0 08             	add    $0x8,%eax
  8023de:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 blockSize = initSizeOfAllocatedSpace - 8; // subtract size of begin and end blocks
  8023e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023e4:	83 e8 08             	sub    $0x8,%eax
  8023e7:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(block,blockSize,0);
  8023ea:	83 ec 04             	sub    $0x4,%esp
  8023ed:	6a 00                	push   $0x0
  8023ef:	ff 75 e8             	pushl  -0x18(%ebp)
  8023f2:	ff 75 ec             	pushl  -0x14(%ebp)
  8023f5:	e8 9c 00 00 00       	call   802496 <set_block_data>
  8023fa:	83 c4 10             	add    $0x10,%esp

		block->prev_next_info.le_next = NULL;
  8023fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802400:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block->prev_next_info.le_prev = NULL;
  802406:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802409:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

		LIST_INIT(&freeBlocksList);
  802410:	c7 05 48 50 98 00 00 	movl   $0x0,0x985048
  802417:	00 00 00 
  80241a:	c7 05 4c 50 98 00 00 	movl   $0x0,0x98504c
  802421:	00 00 00 
  802424:	c7 05 54 50 98 00 00 	movl   $0x0,0x985054
  80242b:	00 00 00 
		LIST_INSERT_HEAD(&freeBlocksList, block);
  80242e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802432:	75 17                	jne    80244b <initialize_dynamic_allocator+0xcd>
  802434:	83 ec 04             	sub    $0x4,%esp
  802437:	68 f4 40 80 00       	push   $0x8040f4
  80243c:	68 80 00 00 00       	push   $0x80
  802441:	68 17 41 80 00       	push   $0x804117
  802446:	e8 01 12 00 00       	call   80364c <_panic>
  80244b:	8b 15 48 50 98 00    	mov    0x985048,%edx
  802451:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802454:	89 10                	mov    %edx,(%eax)
  802456:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802459:	8b 00                	mov    (%eax),%eax
  80245b:	85 c0                	test   %eax,%eax
  80245d:	74 0d                	je     80246c <initialize_dynamic_allocator+0xee>
  80245f:	a1 48 50 98 00       	mov    0x985048,%eax
  802464:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802467:	89 50 04             	mov    %edx,0x4(%eax)
  80246a:	eb 08                	jmp    802474 <initialize_dynamic_allocator+0xf6>
  80246c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80246f:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802474:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802477:	a3 48 50 98 00       	mov    %eax,0x985048
  80247c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80247f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802486:	a1 54 50 98 00       	mov    0x985054,%eax
  80248b:	40                   	inc    %eax
  80248c:	a3 54 50 98 00       	mov    %eax,0x985054
  802491:	eb 01                	jmp    802494 <initialize_dynamic_allocator+0x116>
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
		if (initSizeOfAllocatedSpace == 0)
			return ;
  802493:	90                   	nop
		block->prev_next_info.le_prev = NULL;

		LIST_INIT(&freeBlocksList);
		LIST_INSERT_HEAD(&freeBlocksList, block);
	}
}
  802494:	c9                   	leave  
  802495:	c3                   	ret    

00802496 <set_block_data>:
//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802496:	55                   	push   %ebp
  802497:	89 e5                	mov    %esp,%ebp
  802499:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("set_block_data is not implemented yet");
	//Your Code is Here...

	if(totalSize % 2 != 0)
  80249c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80249f:	83 e0 01             	and    $0x1,%eax
  8024a2:	85 c0                	test   %eax,%eax
  8024a4:	74 03                	je     8024a9 <set_block_data+0x13>
	{
		totalSize++;
  8024a6:	ff 45 0c             	incl   0xc(%ebp)
	}

	uint32* header = (uint32 *)((uint32*)va-1);
  8024a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ac:	83 e8 04             	sub    $0x4,%eax
  8024af:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//	size => totalSize with LSB = 0		 set LSB = 1 if isAllocated
	*header = (totalSize & ~1) | (isAllocated & 1);
  8024b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024b5:	83 e0 fe             	and    $0xfffffffe,%eax
  8024b8:	89 c2                	mov    %eax,%edx
  8024ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8024bd:	83 e0 01             	and    $0x1,%eax
  8024c0:	09 c2                	or     %eax,%edx
  8024c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024c5:	89 10                	mov    %edx,(%eax)
	uint32* footer = (uint32*) (va + totalSize - 8);
  8024c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024ca:	8d 50 f8             	lea    -0x8(%eax),%edx
  8024cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d0:	01 d0                	add    %edx,%eax
  8024d2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	*footer = (totalSize & ~1) | (isAllocated & 1);
  8024d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024d8:	83 e0 fe             	and    $0xfffffffe,%eax
  8024db:	89 c2                	mov    %eax,%edx
  8024dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8024e0:	83 e0 01             	and    $0x1,%eax
  8024e3:	09 c2                	or     %eax,%edx
  8024e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024e8:	89 10                	mov    %edx,(%eax)
}
  8024ea:	90                   	nop
  8024eb:	c9                   	leave  
  8024ec:	c3                   	ret    

008024ed <insert_sorted_in_freeList>:
//=========================================
void insert_sorted_in_freeList(struct BlockElement *newBlock)
{
  8024ed:	55                   	push   %ebp
  8024ee:	89 e5                	mov    %esp,%ebp
  8024f0:	83 ec 18             	sub    $0x18,%esp
	if(LIST_EMPTY(&freeBlocksList))
  8024f3:	a1 48 50 98 00       	mov    0x985048,%eax
  8024f8:	85 c0                	test   %eax,%eax
  8024fa:	75 68                	jne    802564 <insert_sorted_in_freeList+0x77>
	{
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
  8024fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802500:	75 17                	jne    802519 <insert_sorted_in_freeList+0x2c>
  802502:	83 ec 04             	sub    $0x4,%esp
  802505:	68 f4 40 80 00       	push   $0x8040f4
  80250a:	68 9d 00 00 00       	push   $0x9d
  80250f:	68 17 41 80 00       	push   $0x804117
  802514:	e8 33 11 00 00       	call   80364c <_panic>
  802519:	8b 15 48 50 98 00    	mov    0x985048,%edx
  80251f:	8b 45 08             	mov    0x8(%ebp),%eax
  802522:	89 10                	mov    %edx,(%eax)
  802524:	8b 45 08             	mov    0x8(%ebp),%eax
  802527:	8b 00                	mov    (%eax),%eax
  802529:	85 c0                	test   %eax,%eax
  80252b:	74 0d                	je     80253a <insert_sorted_in_freeList+0x4d>
  80252d:	a1 48 50 98 00       	mov    0x985048,%eax
  802532:	8b 55 08             	mov    0x8(%ebp),%edx
  802535:	89 50 04             	mov    %edx,0x4(%eax)
  802538:	eb 08                	jmp    802542 <insert_sorted_in_freeList+0x55>
  80253a:	8b 45 08             	mov    0x8(%ebp),%eax
  80253d:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802542:	8b 45 08             	mov    0x8(%ebp),%eax
  802545:	a3 48 50 98 00       	mov    %eax,0x985048
  80254a:	8b 45 08             	mov    0x8(%ebp),%eax
  80254d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802554:	a1 54 50 98 00       	mov    0x985054,%eax
  802559:	40                   	inc    %eax
  80255a:	a3 54 50 98 00       	mov    %eax,0x985054
		return;
  80255f:	e9 1a 01 00 00       	jmp    80267e <insert_sorted_in_freeList+0x191>
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  802564:	a1 48 50 98 00       	mov    0x985048,%eax
  802569:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80256c:	eb 7f                	jmp    8025ed <insert_sorted_in_freeList+0x100>
	{
		if(blk > newBlock) // if address of blk > address of newBlock => add newBlock before blk
  80256e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802571:	3b 45 08             	cmp    0x8(%ebp),%eax
  802574:	76 6f                	jbe    8025e5 <insert_sorted_in_freeList+0xf8>
		{
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
  802576:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80257a:	74 06                	je     802582 <insert_sorted_in_freeList+0x95>
  80257c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802580:	75 17                	jne    802599 <insert_sorted_in_freeList+0xac>
  802582:	83 ec 04             	sub    $0x4,%esp
  802585:	68 30 41 80 00       	push   $0x804130
  80258a:	68 a6 00 00 00       	push   $0xa6
  80258f:	68 17 41 80 00       	push   $0x804117
  802594:	e8 b3 10 00 00       	call   80364c <_panic>
  802599:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259c:	8b 50 04             	mov    0x4(%eax),%edx
  80259f:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a2:	89 50 04             	mov    %edx,0x4(%eax)
  8025a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025ab:	89 10                	mov    %edx,(%eax)
  8025ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b0:	8b 40 04             	mov    0x4(%eax),%eax
  8025b3:	85 c0                	test   %eax,%eax
  8025b5:	74 0d                	je     8025c4 <insert_sorted_in_freeList+0xd7>
  8025b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ba:	8b 40 04             	mov    0x4(%eax),%eax
  8025bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8025c0:	89 10                	mov    %edx,(%eax)
  8025c2:	eb 08                	jmp    8025cc <insert_sorted_in_freeList+0xdf>
  8025c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c7:	a3 48 50 98 00       	mov    %eax,0x985048
  8025cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8025d2:	89 50 04             	mov    %edx,0x4(%eax)
  8025d5:	a1 54 50 98 00       	mov    0x985054,%eax
  8025da:	40                   	inc    %eax
  8025db:	a3 54 50 98 00       	mov    %eax,0x985054
			return;
  8025e0:	e9 99 00 00 00       	jmp    80267e <insert_sorted_in_freeList+0x191>
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
		return;
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  8025e5:	a1 50 50 98 00       	mov    0x985050,%eax
  8025ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025f1:	74 07                	je     8025fa <insert_sorted_in_freeList+0x10d>
  8025f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f6:	8b 00                	mov    (%eax),%eax
  8025f8:	eb 05                	jmp    8025ff <insert_sorted_in_freeList+0x112>
  8025fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ff:	a3 50 50 98 00       	mov    %eax,0x985050
  802604:	a1 50 50 98 00       	mov    0x985050,%eax
  802609:	85 c0                	test   %eax,%eax
  80260b:	0f 85 5d ff ff ff    	jne    80256e <insert_sorted_in_freeList+0x81>
  802611:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802615:	0f 85 53 ff ff ff    	jne    80256e <insert_sorted_in_freeList+0x81>
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
			return;
		}
	}
	// if no blk its address > newBlock
	LIST_INSERT_TAIL(&freeBlocksList, newBlock);
  80261b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80261f:	75 17                	jne    802638 <insert_sorted_in_freeList+0x14b>
  802621:	83 ec 04             	sub    $0x4,%esp
  802624:	68 68 41 80 00       	push   $0x804168
  802629:	68 ab 00 00 00       	push   $0xab
  80262e:	68 17 41 80 00       	push   $0x804117
  802633:	e8 14 10 00 00       	call   80364c <_panic>
  802638:	8b 15 4c 50 98 00    	mov    0x98504c,%edx
  80263e:	8b 45 08             	mov    0x8(%ebp),%eax
  802641:	89 50 04             	mov    %edx,0x4(%eax)
  802644:	8b 45 08             	mov    0x8(%ebp),%eax
  802647:	8b 40 04             	mov    0x4(%eax),%eax
  80264a:	85 c0                	test   %eax,%eax
  80264c:	74 0c                	je     80265a <insert_sorted_in_freeList+0x16d>
  80264e:	a1 4c 50 98 00       	mov    0x98504c,%eax
  802653:	8b 55 08             	mov    0x8(%ebp),%edx
  802656:	89 10                	mov    %edx,(%eax)
  802658:	eb 08                	jmp    802662 <insert_sorted_in_freeList+0x175>
  80265a:	8b 45 08             	mov    0x8(%ebp),%eax
  80265d:	a3 48 50 98 00       	mov    %eax,0x985048
  802662:	8b 45 08             	mov    0x8(%ebp),%eax
  802665:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80266a:	8b 45 08             	mov    0x8(%ebp),%eax
  80266d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802673:	a1 54 50 98 00       	mov    0x985054,%eax
  802678:	40                   	inc    %eax
  802679:	a3 54 50 98 00       	mov    %eax,0x985054
}
  80267e:	c9                   	leave  
  80267f:	c3                   	ret    

00802680 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  802680:	55                   	push   %ebp
  802681:	89 e5                	mov    %esp,%ebp
  802683:	83 ec 78             	sub    $0x78,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802686:	8b 45 08             	mov    0x8(%ebp),%eax
  802689:	83 e0 01             	and    $0x1,%eax
  80268c:	85 c0                	test   %eax,%eax
  80268e:	74 03                	je     802693 <alloc_block_FF+0x13>
  802690:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802693:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802697:	77 07                	ja     8026a0 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802699:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8026a0:	a1 40 50 98 00       	mov    0x985040,%eax
  8026a5:	85 c0                	test   %eax,%eax
  8026a7:	75 63                	jne    80270c <alloc_block_FF+0x8c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8026a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ac:	83 c0 10             	add    $0x10,%eax
  8026af:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8026b2:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8026b9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026bf:	01 d0                	add    %edx,%eax
  8026c1:	48                   	dec    %eax
  8026c2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8026c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8026cd:	f7 75 ec             	divl   -0x14(%ebp)
  8026d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026d3:	29 d0                	sub    %edx,%eax
  8026d5:	c1 e8 0c             	shr    $0xc,%eax
  8026d8:	83 ec 0c             	sub    $0xc,%esp
  8026db:	50                   	push   %eax
  8026dc:	e8 d1 ed ff ff       	call   8014b2 <sbrk>
  8026e1:	83 c4 10             	add    $0x10,%esp
  8026e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8026e7:	83 ec 0c             	sub    $0xc,%esp
  8026ea:	6a 00                	push   $0x0
  8026ec:	e8 c1 ed ff ff       	call   8014b2 <sbrk>
  8026f1:	83 c4 10             	add    $0x10,%esp
  8026f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8026f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026fa:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8026fd:	83 ec 08             	sub    $0x8,%esp
  802700:	50                   	push   %eax
  802701:	ff 75 e4             	pushl  -0x1c(%ebp)
  802704:	e8 75 fc ff ff       	call   80237e <initialize_dynamic_allocator>
  802709:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(size == 0)
  80270c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802710:	75 0a                	jne    80271c <alloc_block_FF+0x9c>
	{
		return NULL;
  802712:	b8 00 00 00 00       	mov    $0x0,%eax
  802717:	e9 99 03 00 00       	jmp    802ab5 <alloc_block_FF+0x435>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  80271c:	8b 45 08             	mov    0x8(%ebp),%eax
  80271f:	83 c0 08             	add    $0x8,%eax
  802722:	89 45 dc             	mov    %eax,-0x24(%ebp)

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802725:	a1 48 50 98 00       	mov    0x985048,%eax
  80272a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80272d:	e9 03 02 00 00       	jmp    802935 <alloc_block_FF+0x2b5>
	{
		uint32 blockSize = get_block_size(block); // Get size without the (LSB) allocation flag
  802732:	83 ec 0c             	sub    $0xc,%esp
  802735:	ff 75 f4             	pushl  -0xc(%ebp)
  802738:	e8 dd fa ff ff       	call   80221a <get_block_size>
  80273d:	83 c4 10             	add    $0x10,%esp
  802740:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if(blockSize >= totalSize)
  802743:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802746:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802749:	0f 82 de 01 00 00    	jb     80292d <alloc_block_FF+0x2ad>
		{	//if we can put another block with min size 16
			if(blockSize >= totalSize + 4*sizeof(uint32))
  80274f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802752:	83 c0 10             	add    $0x10,%eax
  802755:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  802758:	0f 87 32 01 00 00    	ja     802890 <alloc_block_FF+0x210>
			{
				// the size that will remain from the block that we will allocate a new block in it
				uint32 remainingSize = blockSize - totalSize;
  80275e:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802761:	2b 45 dc             	sub    -0x24(%ebp),%eax
  802764:	89 45 98             	mov    %eax,-0x68(%ebp)

				// the remaining free space from the block that we use to allocate in it
				struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)block + totalSize);
  802767:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80276a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80276d:	01 d0                	add    %edx,%eax
  80276f:	89 45 94             	mov    %eax,-0x6c(%ebp)
				set_block_data(remainingFreeBlock, remainingSize, 0);
  802772:	83 ec 04             	sub    $0x4,%esp
  802775:	6a 00                	push   $0x0
  802777:	ff 75 98             	pushl  -0x68(%ebp)
  80277a:	ff 75 94             	pushl  -0x6c(%ebp)
  80277d:	e8 14 fd ff ff       	call   802496 <set_block_data>
  802782:	83 c4 10             	add    $0x10,%esp
				// add it after the block we allocated to be sorted by addresses
				LIST_INSERT_AFTER(&freeBlocksList, block,remainingFreeBlock);
  802785:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802789:	74 06                	je     802791 <alloc_block_FF+0x111>
  80278b:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
  80278f:	75 17                	jne    8027a8 <alloc_block_FF+0x128>
  802791:	83 ec 04             	sub    $0x4,%esp
  802794:	68 8c 41 80 00       	push   $0x80418c
  802799:	68 de 00 00 00       	push   $0xde
  80279e:	68 17 41 80 00       	push   $0x804117
  8027a3:	e8 a4 0e 00 00       	call   80364c <_panic>
  8027a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ab:	8b 10                	mov    (%eax),%edx
  8027ad:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8027b0:	89 10                	mov    %edx,(%eax)
  8027b2:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8027b5:	8b 00                	mov    (%eax),%eax
  8027b7:	85 c0                	test   %eax,%eax
  8027b9:	74 0b                	je     8027c6 <alloc_block_FF+0x146>
  8027bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027be:	8b 00                	mov    (%eax),%eax
  8027c0:	8b 55 94             	mov    -0x6c(%ebp),%edx
  8027c3:	89 50 04             	mov    %edx,0x4(%eax)
  8027c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c9:	8b 55 94             	mov    -0x6c(%ebp),%edx
  8027cc:	89 10                	mov    %edx,(%eax)
  8027ce:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8027d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027d4:	89 50 04             	mov    %edx,0x4(%eax)
  8027d7:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8027da:	8b 00                	mov    (%eax),%eax
  8027dc:	85 c0                	test   %eax,%eax
  8027de:	75 08                	jne    8027e8 <alloc_block_FF+0x168>
  8027e0:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8027e3:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8027e8:	a1 54 50 98 00       	mov    0x985054,%eax
  8027ed:	40                   	inc    %eax
  8027ee:	a3 54 50 98 00       	mov    %eax,0x985054

				// update the allocated block and remove it from freeBlocksList
				set_block_data(block,totalSize,1);
  8027f3:	83 ec 04             	sub    $0x4,%esp
  8027f6:	6a 01                	push   $0x1
  8027f8:	ff 75 dc             	pushl  -0x24(%ebp)
  8027fb:	ff 75 f4             	pushl  -0xc(%ebp)
  8027fe:	e8 93 fc ff ff       	call   802496 <set_block_data>
  802803:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  802806:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80280a:	75 17                	jne    802823 <alloc_block_FF+0x1a3>
  80280c:	83 ec 04             	sub    $0x4,%esp
  80280f:	68 c0 41 80 00       	push   $0x8041c0
  802814:	68 e3 00 00 00       	push   $0xe3
  802819:	68 17 41 80 00       	push   $0x804117
  80281e:	e8 29 0e 00 00       	call   80364c <_panic>
  802823:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802826:	8b 00                	mov    (%eax),%eax
  802828:	85 c0                	test   %eax,%eax
  80282a:	74 10                	je     80283c <alloc_block_FF+0x1bc>
  80282c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282f:	8b 00                	mov    (%eax),%eax
  802831:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802834:	8b 52 04             	mov    0x4(%edx),%edx
  802837:	89 50 04             	mov    %edx,0x4(%eax)
  80283a:	eb 0b                	jmp    802847 <alloc_block_FF+0x1c7>
  80283c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283f:	8b 40 04             	mov    0x4(%eax),%eax
  802842:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802847:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284a:	8b 40 04             	mov    0x4(%eax),%eax
  80284d:	85 c0                	test   %eax,%eax
  80284f:	74 0f                	je     802860 <alloc_block_FF+0x1e0>
  802851:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802854:	8b 40 04             	mov    0x4(%eax),%eax
  802857:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80285a:	8b 12                	mov    (%edx),%edx
  80285c:	89 10                	mov    %edx,(%eax)
  80285e:	eb 0a                	jmp    80286a <alloc_block_FF+0x1ea>
  802860:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802863:	8b 00                	mov    (%eax),%eax
  802865:	a3 48 50 98 00       	mov    %eax,0x985048
  80286a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802873:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802876:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80287d:	a1 54 50 98 00       	mov    0x985054,%eax
  802882:	48                   	dec    %eax
  802883:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  802888:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288b:	e9 25 02 00 00       	jmp    802ab5 <alloc_block_FF+0x435>
			}
			else // if set internal fragmentation
			{
				// add the remaining size to the block we allocate so it will be the same main block size
				set_block_data(block,blockSize,1);
  802890:	83 ec 04             	sub    $0x4,%esp
  802893:	6a 01                	push   $0x1
  802895:	ff 75 9c             	pushl  -0x64(%ebp)
  802898:	ff 75 f4             	pushl  -0xc(%ebp)
  80289b:	e8 f6 fb ff ff       	call   802496 <set_block_data>
  8028a0:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  8028a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028a7:	75 17                	jne    8028c0 <alloc_block_FF+0x240>
  8028a9:	83 ec 04             	sub    $0x4,%esp
  8028ac:	68 c0 41 80 00       	push   $0x8041c0
  8028b1:	68 eb 00 00 00       	push   $0xeb
  8028b6:	68 17 41 80 00       	push   $0x804117
  8028bb:	e8 8c 0d 00 00       	call   80364c <_panic>
  8028c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c3:	8b 00                	mov    (%eax),%eax
  8028c5:	85 c0                	test   %eax,%eax
  8028c7:	74 10                	je     8028d9 <alloc_block_FF+0x259>
  8028c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cc:	8b 00                	mov    (%eax),%eax
  8028ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028d1:	8b 52 04             	mov    0x4(%edx),%edx
  8028d4:	89 50 04             	mov    %edx,0x4(%eax)
  8028d7:	eb 0b                	jmp    8028e4 <alloc_block_FF+0x264>
  8028d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028dc:	8b 40 04             	mov    0x4(%eax),%eax
  8028df:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8028e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e7:	8b 40 04             	mov    0x4(%eax),%eax
  8028ea:	85 c0                	test   %eax,%eax
  8028ec:	74 0f                	je     8028fd <alloc_block_FF+0x27d>
  8028ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f1:	8b 40 04             	mov    0x4(%eax),%eax
  8028f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028f7:	8b 12                	mov    (%edx),%edx
  8028f9:	89 10                	mov    %edx,(%eax)
  8028fb:	eb 0a                	jmp    802907 <alloc_block_FF+0x287>
  8028fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802900:	8b 00                	mov    (%eax),%eax
  802902:	a3 48 50 98 00       	mov    %eax,0x985048
  802907:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802910:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802913:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80291a:	a1 54 50 98 00       	mov    0x985054,%eax
  80291f:	48                   	dec    %eax
  802920:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  802925:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802928:	e9 88 01 00 00       	jmp    802ab5 <alloc_block_FF+0x435>
		return NULL;
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  80292d:	a1 50 50 98 00       	mov    0x985050,%eax
  802932:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802935:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802939:	74 07                	je     802942 <alloc_block_FF+0x2c2>
  80293b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293e:	8b 00                	mov    (%eax),%eax
  802940:	eb 05                	jmp    802947 <alloc_block_FF+0x2c7>
  802942:	b8 00 00 00 00       	mov    $0x0,%eax
  802947:	a3 50 50 98 00       	mov    %eax,0x985050
  80294c:	a1 50 50 98 00       	mov    0x985050,%eax
  802951:	85 c0                	test   %eax,%eax
  802953:	0f 85 d9 fd ff ff    	jne    802732 <alloc_block_FF+0xb2>
  802959:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80295d:	0f 85 cf fd ff ff    	jne    802732 <alloc_block_FF+0xb2>

//	uint32 *endBlock = &kheapBreak;

	// if we don't find any enough space to allocate the block

	void *oldBreak = sbrk(ROUNDUP(totalSize, PAGE_SIZE) / PAGE_SIZE);
  802963:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80296a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80296d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802970:	01 d0                	add    %edx,%eax
  802972:	48                   	dec    %eax
  802973:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802976:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802979:	ba 00 00 00 00       	mov    $0x0,%edx
  80297e:	f7 75 d8             	divl   -0x28(%ebp)
  802981:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802984:	29 d0                	sub    %edx,%eax
  802986:	c1 e8 0c             	shr    $0xc,%eax
  802989:	83 ec 0c             	sub    $0xc,%esp
  80298c:	50                   	push   %eax
  80298d:	e8 20 eb ff ff       	call   8014b2 <sbrk>
  802992:	83 c4 10             	add    $0x10,%esp
  802995:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (oldBreak == (void*)-1) {
  802998:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  80299c:	75 0a                	jne    8029a8 <alloc_block_FF+0x328>
		return NULL;
  80299e:	b8 00 00 00 00       	mov    $0x0,%eax
  8029a3:	e9 0d 01 00 00       	jmp    802ab5 <alloc_block_FF+0x435>
	}
	//uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);

	uint32* endBlk = (uint32 *)((char *)oldBreak - 4);
  8029a8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8029ab:	83 e8 04             	sub    $0x4,%eax
  8029ae:	89 45 cc             	mov    %eax,-0x34(%ebp)
	//endBlk = endBlk+(char *) ROUNDUP(totalSize, PAGE_SIZE);

	endBlk = endBlk + (ROUNDUP(totalSize, PAGE_SIZE) / sizeof(uint32));
  8029b1:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  8029b8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8029bb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8029be:	01 d0                	add    %edx,%eax
  8029c0:	48                   	dec    %eax
  8029c1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8029c4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8029c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8029cc:	f7 75 c8             	divl   -0x38(%ebp)
  8029cf:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8029d2:	29 d0                	sub    %edx,%eax
  8029d4:	c1 e8 02             	shr    $0x2,%eax
  8029d7:	c1 e0 02             	shl    $0x2,%eax
  8029da:	01 45 cc             	add    %eax,-0x34(%ebp)
	*endBlk = 0 | 1;
  8029dd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029e0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	uint32 *footerLast = ((uint32*)oldBreak - 2);
  8029e6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8029e9:	83 e8 08             	sub    $0x8,%eax
  8029ec:	89 45 c0             	mov    %eax,-0x40(%ebp)
	uint32 lastSize = (*footerLast) & ~(0x1);
  8029ef:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8029f2:	8b 00                	mov    (%eax),%eax
  8029f4:	83 e0 fe             	and    $0xfffffffe,%eax
  8029f7:	89 45 bc             	mov    %eax,-0x44(%ebp)
	// the last block for the block that we want to free it
	struct BlockElement *laskBlk = (struct BlockElement *)((char*)oldBreak - lastSize);
  8029fa:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8029fd:	f7 d8                	neg    %eax
  8029ff:	89 c2                	mov    %eax,%edx
  802a01:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802a04:	01 d0                	add    %edx,%eax
  802a06:	89 45 b8             	mov    %eax,-0x48(%ebp)
	uint32 isLastFree = is_free_block(laskBlk);
  802a09:	83 ec 0c             	sub    $0xc,%esp
  802a0c:	ff 75 b8             	pushl  -0x48(%ebp)
  802a0f:	e8 1f f8 ff ff       	call   802233 <is_free_block>
  802a14:	83 c4 10             	add    $0x10,%esp
  802a17:	0f be c0             	movsbl %al,%eax
  802a1a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(isLastFree)
  802a1d:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  802a21:	74 42                	je     802a65 <alloc_block_FF+0x3e5>
	{
		// merge the block will be free with its prev block
		uint32 newBlkSize = lastSize + ROUNDUP(totalSize, PAGE_SIZE); // size of main block and its prev block
  802a23:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802a2a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802a2d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a30:	01 d0                	add    %edx,%eax
  802a32:	48                   	dec    %eax
  802a33:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802a36:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802a39:	ba 00 00 00 00       	mov    $0x0,%edx
  802a3e:	f7 75 b0             	divl   -0x50(%ebp)
  802a41:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802a44:	29 d0                	sub    %edx,%eax
  802a46:	89 c2                	mov    %eax,%edx
  802a48:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802a4b:	01 d0                	add    %edx,%eax
  802a4d:	89 45 a8             	mov    %eax,-0x58(%ebp)
		// extends last block size to contain its size and the size of new space
		set_block_data(laskBlk,newBlkSize,0);
  802a50:	83 ec 04             	sub    $0x4,%esp
  802a53:	6a 00                	push   $0x0
  802a55:	ff 75 a8             	pushl  -0x58(%ebp)
  802a58:	ff 75 b8             	pushl  -0x48(%ebp)
  802a5b:	e8 36 fa ff ff       	call   802496 <set_block_data>
  802a60:	83 c4 10             	add    $0x10,%esp
  802a63:	eb 42                	jmp    802aa7 <alloc_block_FF+0x427>
	}
	else
	{
		set_block_data(oldBreak,ROUNDUP(totalSize, PAGE_SIZE),0);
  802a65:	c7 45 a4 00 10 00 00 	movl   $0x1000,-0x5c(%ebp)
  802a6c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802a6f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802a72:	01 d0                	add    %edx,%eax
  802a74:	48                   	dec    %eax
  802a75:	89 45 a0             	mov    %eax,-0x60(%ebp)
  802a78:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802a7b:	ba 00 00 00 00       	mov    $0x0,%edx
  802a80:	f7 75 a4             	divl   -0x5c(%ebp)
  802a83:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802a86:	29 d0                	sub    %edx,%eax
  802a88:	83 ec 04             	sub    $0x4,%esp
  802a8b:	6a 00                	push   $0x0
  802a8d:	50                   	push   %eax
  802a8e:	ff 75 d0             	pushl  -0x30(%ebp)
  802a91:	e8 00 fa ff ff       	call   802496 <set_block_data>
  802a96:	83 c4 10             	add    $0x10,%esp
		insert_sorted_in_freeList((struct BlockElement *)oldBreak);
  802a99:	83 ec 0c             	sub    $0xc,%esp
  802a9c:	ff 75 d0             	pushl  -0x30(%ebp)
  802a9f:	e8 49 fa ff ff       	call   8024ed <insert_sorted_in_freeList>
  802aa4:	83 c4 10             	add    $0x10,%esp
//		LIST_INSERT_TAIL(&freeBlocksList,newBreak);
	}
//	set_block_data((struct BlockElement *)newBreak, totalSize, 1);
	return alloc_block_FF(size);
  802aa7:	83 ec 0c             	sub    $0xc,%esp
  802aaa:	ff 75 08             	pushl  0x8(%ebp)
  802aad:	e8 ce fb ff ff       	call   802680 <alloc_block_FF>
  802ab2:	83 c4 10             	add    $0x10,%esp
}
  802ab5:	c9                   	leave  
  802ab6:	c3                   	ret    

00802ab7 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802ab7:	55                   	push   %ebp
  802ab8:	89 e5                	mov    %esp,%ebp
  802aba:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS1 - BONUS] [3] DYNAMIC ALLOCATOR - alloc_block_BF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_BF is not implemented yet");
	//Your Code is Here...
	if(size == 0)
  802abd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ac1:	75 0a                	jne    802acd <alloc_block_BF+0x16>
	{
		return NULL;
  802ac3:	b8 00 00 00 00       	mov    $0x0,%eax
  802ac8:	e9 7a 02 00 00       	jmp    802d47 <alloc_block_BF+0x290>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  802acd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad0:	83 c0 08             	add    $0x8,%eax
  802ad3:	89 45 e8             	mov    %eax,-0x18(%ebp)

	struct BlockElement *minBlk= NULL;
  802ad6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 minSize = 0xfffffff; // a large number
  802add:	c7 45 f0 ff ff ff 0f 	movl   $0xfffffff,-0x10(%ebp)
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802ae4:	a1 48 50 98 00       	mov    0x985048,%eax
  802ae9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802aec:	eb 32                	jmp    802b20 <alloc_block_BF+0x69>
	{
		uint32 blockSize = get_block_size(block);
  802aee:	ff 75 ec             	pushl  -0x14(%ebp)
  802af1:	e8 24 f7 ff ff       	call   80221a <get_block_size>
  802af6:	83 c4 04             	add    $0x4,%esp
  802af9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		// if this block can take the new block and its size < min size of all blocks
		if(blockSize >= totalSize && blockSize < minSize)
  802afc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802aff:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802b02:	72 14                	jb     802b18 <alloc_block_BF+0x61>
  802b04:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b07:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802b0a:	73 0c                	jae    802b18 <alloc_block_BF+0x61>
		{
			minBlk = block;
  802b0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
			minSize = blockSize;
  802b12:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b15:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *minBlk= NULL;
	uint32 minSize = 0xfffffff; // a large number
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802b18:	a1 50 50 98 00       	mov    0x985050,%eax
  802b1d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802b20:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b24:	74 07                	je     802b2d <alloc_block_BF+0x76>
  802b26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b29:	8b 00                	mov    (%eax),%eax
  802b2b:	eb 05                	jmp    802b32 <alloc_block_BF+0x7b>
  802b2d:	b8 00 00 00 00       	mov    $0x0,%eax
  802b32:	a3 50 50 98 00       	mov    %eax,0x985050
  802b37:	a1 50 50 98 00       	mov    0x985050,%eax
  802b3c:	85 c0                	test   %eax,%eax
  802b3e:	75 ae                	jne    802aee <alloc_block_BF+0x37>
  802b40:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b44:	75 a8                	jne    802aee <alloc_block_BF+0x37>
			minSize = blockSize;
		}
	}

	// if we don't find any enough space to allocate the block
	if(minBlk == NULL)
  802b46:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b4a:	75 22                	jne    802b6e <alloc_block_BF+0xb7>
	{
		void *newBlock = sbrk(totalSize);
  802b4c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b4f:	83 ec 0c             	sub    $0xc,%esp
  802b52:	50                   	push   %eax
  802b53:	e8 5a e9 ff ff       	call   8014b2 <sbrk>
  802b58:	83 c4 10             	add    $0x10,%esp
  802b5b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (newBlock == (void*)-1) {
  802b5e:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  802b62:	75 0a                	jne    802b6e <alloc_block_BF+0xb7>
			return NULL;
  802b64:	b8 00 00 00 00       	mov    $0x0,%eax
  802b69:	e9 d9 01 00 00       	jmp    802d47 <alloc_block_BF+0x290>
		}
	}

	//if we can put another block with min size 16
	if(minSize >= totalSize + 4*sizeof(uint32))
  802b6e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b71:	83 c0 10             	add    $0x10,%eax
  802b74:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802b77:	0f 87 32 01 00 00    	ja     802caf <alloc_block_BF+0x1f8>
	{
		// the size that will remain from the block that we will allocate a new block in it
		uint32 remainingSize= minSize - totalSize;
  802b7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b80:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802b83:	89 45 dc             	mov    %eax,-0x24(%ebp)

		// the remaining free space from the block that we use to allocate in it
		struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)minBlk + totalSize);
  802b86:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b89:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b8c:	01 d0                	add    %edx,%eax
  802b8e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		set_block_data(remainingFreeBlock, remainingSize, 0);
  802b91:	83 ec 04             	sub    $0x4,%esp
  802b94:	6a 00                	push   $0x0
  802b96:	ff 75 dc             	pushl  -0x24(%ebp)
  802b99:	ff 75 d8             	pushl  -0x28(%ebp)
  802b9c:	e8 f5 f8 ff ff       	call   802496 <set_block_data>
  802ba1:	83 c4 10             	add    $0x10,%esp
		// add it after the block we allocated to be sorted by addresses
		LIST_INSERT_AFTER(&freeBlocksList, minBlk,remainingFreeBlock);
  802ba4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ba8:	74 06                	je     802bb0 <alloc_block_BF+0xf9>
  802baa:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802bae:	75 17                	jne    802bc7 <alloc_block_BF+0x110>
  802bb0:	83 ec 04             	sub    $0x4,%esp
  802bb3:	68 8c 41 80 00       	push   $0x80418c
  802bb8:	68 49 01 00 00       	push   $0x149
  802bbd:	68 17 41 80 00       	push   $0x804117
  802bc2:	e8 85 0a 00 00       	call   80364c <_panic>
  802bc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bca:	8b 10                	mov    (%eax),%edx
  802bcc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802bcf:	89 10                	mov    %edx,(%eax)
  802bd1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802bd4:	8b 00                	mov    (%eax),%eax
  802bd6:	85 c0                	test   %eax,%eax
  802bd8:	74 0b                	je     802be5 <alloc_block_BF+0x12e>
  802bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdd:	8b 00                	mov    (%eax),%eax
  802bdf:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802be2:	89 50 04             	mov    %edx,0x4(%eax)
  802be5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802beb:	89 10                	mov    %edx,(%eax)
  802bed:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802bf0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bf3:	89 50 04             	mov    %edx,0x4(%eax)
  802bf6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802bf9:	8b 00                	mov    (%eax),%eax
  802bfb:	85 c0                	test   %eax,%eax
  802bfd:	75 08                	jne    802c07 <alloc_block_BF+0x150>
  802bff:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802c02:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802c07:	a1 54 50 98 00       	mov    0x985054,%eax
  802c0c:	40                   	inc    %eax
  802c0d:	a3 54 50 98 00       	mov    %eax,0x985054

		// update the allocated block and remove it from freeBlocksList
		set_block_data(minBlk,totalSize,1);
  802c12:	83 ec 04             	sub    $0x4,%esp
  802c15:	6a 01                	push   $0x1
  802c17:	ff 75 e8             	pushl  -0x18(%ebp)
  802c1a:	ff 75 f4             	pushl  -0xc(%ebp)
  802c1d:	e8 74 f8 ff ff       	call   802496 <set_block_data>
  802c22:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  802c25:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c29:	75 17                	jne    802c42 <alloc_block_BF+0x18b>
  802c2b:	83 ec 04             	sub    $0x4,%esp
  802c2e:	68 c0 41 80 00       	push   $0x8041c0
  802c33:	68 4e 01 00 00       	push   $0x14e
  802c38:	68 17 41 80 00       	push   $0x804117
  802c3d:	e8 0a 0a 00 00       	call   80364c <_panic>
  802c42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c45:	8b 00                	mov    (%eax),%eax
  802c47:	85 c0                	test   %eax,%eax
  802c49:	74 10                	je     802c5b <alloc_block_BF+0x1a4>
  802c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4e:	8b 00                	mov    (%eax),%eax
  802c50:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c53:	8b 52 04             	mov    0x4(%edx),%edx
  802c56:	89 50 04             	mov    %edx,0x4(%eax)
  802c59:	eb 0b                	jmp    802c66 <alloc_block_BF+0x1af>
  802c5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5e:	8b 40 04             	mov    0x4(%eax),%eax
  802c61:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c69:	8b 40 04             	mov    0x4(%eax),%eax
  802c6c:	85 c0                	test   %eax,%eax
  802c6e:	74 0f                	je     802c7f <alloc_block_BF+0x1c8>
  802c70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c73:	8b 40 04             	mov    0x4(%eax),%eax
  802c76:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c79:	8b 12                	mov    (%edx),%edx
  802c7b:	89 10                	mov    %edx,(%eax)
  802c7d:	eb 0a                	jmp    802c89 <alloc_block_BF+0x1d2>
  802c7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c82:	8b 00                	mov    (%eax),%eax
  802c84:	a3 48 50 98 00       	mov    %eax,0x985048
  802c89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c95:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c9c:	a1 54 50 98 00       	mov    0x985054,%eax
  802ca1:	48                   	dec    %eax
  802ca2:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  802ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802caa:	e9 98 00 00 00       	jmp    802d47 <alloc_block_BF+0x290>
	}
	else // if set internal fragmentation
	{
		// add the remaining size to the block we allocate so it will be the same main block size
		set_block_data(minBlk,minSize,1);
  802caf:	83 ec 04             	sub    $0x4,%esp
  802cb2:	6a 01                	push   $0x1
  802cb4:	ff 75 f0             	pushl  -0x10(%ebp)
  802cb7:	ff 75 f4             	pushl  -0xc(%ebp)
  802cba:	e8 d7 f7 ff ff       	call   802496 <set_block_data>
  802cbf:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  802cc2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cc6:	75 17                	jne    802cdf <alloc_block_BF+0x228>
  802cc8:	83 ec 04             	sub    $0x4,%esp
  802ccb:	68 c0 41 80 00       	push   $0x8041c0
  802cd0:	68 56 01 00 00       	push   $0x156
  802cd5:	68 17 41 80 00       	push   $0x804117
  802cda:	e8 6d 09 00 00       	call   80364c <_panic>
  802cdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce2:	8b 00                	mov    (%eax),%eax
  802ce4:	85 c0                	test   %eax,%eax
  802ce6:	74 10                	je     802cf8 <alloc_block_BF+0x241>
  802ce8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ceb:	8b 00                	mov    (%eax),%eax
  802ced:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cf0:	8b 52 04             	mov    0x4(%edx),%edx
  802cf3:	89 50 04             	mov    %edx,0x4(%eax)
  802cf6:	eb 0b                	jmp    802d03 <alloc_block_BF+0x24c>
  802cf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfb:	8b 40 04             	mov    0x4(%eax),%eax
  802cfe:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802d03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d06:	8b 40 04             	mov    0x4(%eax),%eax
  802d09:	85 c0                	test   %eax,%eax
  802d0b:	74 0f                	je     802d1c <alloc_block_BF+0x265>
  802d0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d10:	8b 40 04             	mov    0x4(%eax),%eax
  802d13:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d16:	8b 12                	mov    (%edx),%edx
  802d18:	89 10                	mov    %edx,(%eax)
  802d1a:	eb 0a                	jmp    802d26 <alloc_block_BF+0x26f>
  802d1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1f:	8b 00                	mov    (%eax),%eax
  802d21:	a3 48 50 98 00       	mov    %eax,0x985048
  802d26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d29:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d32:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d39:	a1 54 50 98 00       	mov    0x985054,%eax
  802d3e:	48                   	dec    %eax
  802d3f:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  802d44:	8b 45 f4             	mov    -0xc(%ebp),%eax
	}
	return NULL;
}
  802d47:	c9                   	leave  
  802d48:	c3                   	ret    

00802d49 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802d49:	55                   	push   %ebp
  802d4a:	89 e5                	mov    %esp,%ebp
  802d4c:	83 ec 48             	sub    $0x48,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
  802d4f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d53:	0f 84 6a 02 00 00    	je     802fc3 <free_block+0x27a>
	{
		return;
	}

	uint32 freeSize = get_block_size(va);
  802d59:	ff 75 08             	pushl  0x8(%ebp)
  802d5c:	e8 b9 f4 ff ff       	call   80221a <get_block_size>
  802d61:	83 c4 04             	add    $0x4,%esp
  802d64:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// footer for the prev block for the block that we want to free it
	uint32 *footerPrev = ((uint32*)va - 2 );
  802d67:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6a:	83 e8 08             	sub    $0x8,%eax
  802d6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 pSize = (*footerPrev) & ~(0x1);
  802d70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d73:	8b 00                	mov    (%eax),%eax
  802d75:	83 e0 fe             	and    $0xfffffffe,%eax
  802d78:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// the prev block for the block that we want to free it
	struct BlockElement * prevBlk = (struct BlockElement *)((char*)va - pSize);
  802d7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d7e:	f7 d8                	neg    %eax
  802d80:	89 c2                	mov    %eax,%edx
  802d82:	8b 45 08             	mov    0x8(%ebp),%eax
  802d85:	01 d0                	add    %edx,%eax
  802d87:	89 45 e8             	mov    %eax,-0x18(%ebp)
	uint32 isPrevFree = is_free_block(prevBlk);
  802d8a:	ff 75 e8             	pushl  -0x18(%ebp)
  802d8d:	e8 a1 f4 ff ff       	call   802233 <is_free_block>
  802d92:	83 c4 04             	add    $0x4,%esp
  802d95:	0f be c0             	movsbl %al,%eax
  802d98:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
  802d9b:	8b 55 08             	mov    0x8(%ebp),%edx
  802d9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da1:	01 d0                	add    %edx,%eax
  802da3:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  802da6:	ff 75 e0             	pushl  -0x20(%ebp)
  802da9:	e8 85 f4 ff ff       	call   802233 <is_free_block>
  802dae:	83 c4 04             	add    $0x4,%esp
  802db1:	0f be c0             	movsbl %al,%eax
  802db4:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if(isPrevFree == 1 && isNextFree == 0)
  802db7:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  802dbb:	75 34                	jne    802df1 <free_block+0xa8>
  802dbd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802dc1:	75 2e                	jne    802df1 <free_block+0xa8>
	{
		// merge the block will be free with its prev block
		uint32 prevSize = get_block_size(prevBlk);
  802dc3:	ff 75 e8             	pushl  -0x18(%ebp)
  802dc6:	e8 4f f4 ff ff       	call   80221a <get_block_size>
  802dcb:	83 c4 04             	add    $0x4,%esp
  802dce:	89 45 d8             	mov    %eax,-0x28(%ebp)
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
  802dd1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dd4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802dd7:	01 d0                	add    %edx,%eax
  802dd9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
  802ddc:	6a 00                	push   $0x0
  802dde:	ff 75 d4             	pushl  -0x2c(%ebp)
  802de1:	ff 75 e8             	pushl  -0x18(%ebp)
  802de4:	e8 ad f6 ff ff       	call   802496 <set_block_data>
  802de9:	83 c4 0c             	add    $0xc,%esp
	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
	uint32 isNextFree = is_free_block(nextBlk);

	if(isPrevFree == 1 && isNextFree == 0)
	{
  802dec:	e9 d3 01 00 00       	jmp    802fc4 <free_block+0x27b>
		uint32 prevSize = get_block_size(prevBlk);
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
  802df1:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  802df5:	0f 85 c8 00 00 00    	jne    802ec3 <free_block+0x17a>
  802dfb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802dff:	0f 85 be 00 00 00    	jne    802ec3 <free_block+0x17a>
	{
		// merge the block will be free with its next block
		uint32 nextSize = get_block_size(nextBlk);
  802e05:	ff 75 e0             	pushl  -0x20(%ebp)
  802e08:	e8 0d f4 ff ff       	call   80221a <get_block_size>
  802e0d:	83 c4 04             	add    $0x4,%esp
  802e10:	89 45 d0             	mov    %eax,-0x30(%ebp)
		uint32 totalSize = freeSize + nextSize; // size of main block and its next block
  802e13:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e16:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802e19:	01 d0                	add    %edx,%eax
  802e1b:	89 45 cc             	mov    %eax,-0x34(%ebp)
		// update the size of block to contain its size and the size of next block
		set_block_data(va,totalSize,0);
  802e1e:	6a 00                	push   $0x0
  802e20:	ff 75 cc             	pushl  -0x34(%ebp)
  802e23:	ff 75 08             	pushl  0x8(%ebp)
  802e26:	e8 6b f6 ff ff       	call   802496 <set_block_data>
  802e2b:	83 c4 0c             	add    $0xc,%esp
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
  802e2e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802e32:	75 17                	jne    802e4b <free_block+0x102>
  802e34:	83 ec 04             	sub    $0x4,%esp
  802e37:	68 c0 41 80 00       	push   $0x8041c0
  802e3c:	68 87 01 00 00       	push   $0x187
  802e41:	68 17 41 80 00       	push   $0x804117
  802e46:	e8 01 08 00 00       	call   80364c <_panic>
  802e4b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e4e:	8b 00                	mov    (%eax),%eax
  802e50:	85 c0                	test   %eax,%eax
  802e52:	74 10                	je     802e64 <free_block+0x11b>
  802e54:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e57:	8b 00                	mov    (%eax),%eax
  802e59:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e5c:	8b 52 04             	mov    0x4(%edx),%edx
  802e5f:	89 50 04             	mov    %edx,0x4(%eax)
  802e62:	eb 0b                	jmp    802e6f <free_block+0x126>
  802e64:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e67:	8b 40 04             	mov    0x4(%eax),%eax
  802e6a:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802e6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e72:	8b 40 04             	mov    0x4(%eax),%eax
  802e75:	85 c0                	test   %eax,%eax
  802e77:	74 0f                	je     802e88 <free_block+0x13f>
  802e79:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e7c:	8b 40 04             	mov    0x4(%eax),%eax
  802e7f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e82:	8b 12                	mov    (%edx),%edx
  802e84:	89 10                	mov    %edx,(%eax)
  802e86:	eb 0a                	jmp    802e92 <free_block+0x149>
  802e88:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e8b:	8b 00                	mov    (%eax),%eax
  802e8d:	a3 48 50 98 00       	mov    %eax,0x985048
  802e92:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e95:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e9b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e9e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ea5:	a1 54 50 98 00       	mov    0x985054,%eax
  802eaa:	48                   	dec    %eax
  802eab:	a3 54 50 98 00       	mov    %eax,0x985054
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  802eb0:	83 ec 0c             	sub    $0xc,%esp
  802eb3:	ff 75 08             	pushl  0x8(%ebp)
  802eb6:	e8 32 f6 ff ff       	call   8024ed <insert_sorted_in_freeList>
  802ebb:	83 c4 10             	add    $0x10,%esp
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
	{
  802ebe:	e9 01 01 00 00       	jmp    802fc4 <free_block+0x27b>
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
  802ec3:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  802ec7:	0f 85 d3 00 00 00    	jne    802fa0 <free_block+0x257>
  802ecd:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  802ed1:	0f 85 c9 00 00 00    	jne    802fa0 <free_block+0x257>
	{
		// merge the block will be free with its prev and next blocks
		uint32 prevSize = get_block_size(prevBlk);
  802ed7:	83 ec 0c             	sub    $0xc,%esp
  802eda:	ff 75 e8             	pushl  -0x18(%ebp)
  802edd:	e8 38 f3 ff ff       	call   80221a <get_block_size>
  802ee2:	83 c4 10             	add    $0x10,%esp
  802ee5:	89 45 c8             	mov    %eax,-0x38(%ebp)
		uint32 nextSize = get_block_size(nextBlk);
  802ee8:	83 ec 0c             	sub    $0xc,%esp
  802eeb:	ff 75 e0             	pushl  -0x20(%ebp)
  802eee:	e8 27 f3 ff ff       	call   80221a <get_block_size>
  802ef3:	83 c4 10             	add    $0x10,%esp
  802ef6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 totalSize = freeSize + prevSize + nextSize; // size of main block and its prev and next blocks
  802ef9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802efc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802eff:	01 c2                	add    %eax,%edx
  802f01:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802f04:	01 d0                	add    %edx,%eax
  802f06:	89 45 c0             	mov    %eax,-0x40(%ebp)
		// extends prev block size to contain its size and the size of main and next blocks
		set_block_data(prevBlk,totalSize,0);
  802f09:	83 ec 04             	sub    $0x4,%esp
  802f0c:	6a 00                	push   $0x0
  802f0e:	ff 75 c0             	pushl  -0x40(%ebp)
  802f11:	ff 75 e8             	pushl  -0x18(%ebp)
  802f14:	e8 7d f5 ff ff       	call   802496 <set_block_data>
  802f19:	83 c4 10             	add    $0x10,%esp
		// remove next block because we merge it with its prev blocks
		LIST_REMOVE(&freeBlocksList, nextBlk);
  802f1c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802f20:	75 17                	jne    802f39 <free_block+0x1f0>
  802f22:	83 ec 04             	sub    $0x4,%esp
  802f25:	68 c0 41 80 00       	push   $0x8041c0
  802f2a:	68 94 01 00 00       	push   $0x194
  802f2f:	68 17 41 80 00       	push   $0x804117
  802f34:	e8 13 07 00 00       	call   80364c <_panic>
  802f39:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f3c:	8b 00                	mov    (%eax),%eax
  802f3e:	85 c0                	test   %eax,%eax
  802f40:	74 10                	je     802f52 <free_block+0x209>
  802f42:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f45:	8b 00                	mov    (%eax),%eax
  802f47:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f4a:	8b 52 04             	mov    0x4(%edx),%edx
  802f4d:	89 50 04             	mov    %edx,0x4(%eax)
  802f50:	eb 0b                	jmp    802f5d <free_block+0x214>
  802f52:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f55:	8b 40 04             	mov    0x4(%eax),%eax
  802f58:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802f5d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f60:	8b 40 04             	mov    0x4(%eax),%eax
  802f63:	85 c0                	test   %eax,%eax
  802f65:	74 0f                	je     802f76 <free_block+0x22d>
  802f67:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f6a:	8b 40 04             	mov    0x4(%eax),%eax
  802f6d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f70:	8b 12                	mov    (%edx),%edx
  802f72:	89 10                	mov    %edx,(%eax)
  802f74:	eb 0a                	jmp    802f80 <free_block+0x237>
  802f76:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f79:	8b 00                	mov    (%eax),%eax
  802f7b:	a3 48 50 98 00       	mov    %eax,0x985048
  802f80:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f83:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f89:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f8c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f93:	a1 54 50 98 00       	mov    0x985054,%eax
  802f98:	48                   	dec    %eax
  802f99:	a3 54 50 98 00       	mov    %eax,0x985054
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
	{
  802f9e:	eb 24                	jmp    802fc4 <free_block+0x27b>
	}
	else
	{
		// free it without any merge
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
  802fa0:	83 ec 04             	sub    $0x4,%esp
  802fa3:	6a 00                	push   $0x0
  802fa5:	ff 75 f4             	pushl  -0xc(%ebp)
  802fa8:	ff 75 08             	pushl  0x8(%ebp)
  802fab:	e8 e6 f4 ff ff       	call   802496 <set_block_data>
  802fb0:	83 c4 10             	add    $0x10,%esp
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  802fb3:	83 ec 0c             	sub    $0xc,%esp
  802fb6:	ff 75 08             	pushl  0x8(%ebp)
  802fb9:	e8 2f f5 ff ff       	call   8024ed <insert_sorted_in_freeList>
  802fbe:	83 c4 10             	add    $0x10,%esp
  802fc1:	eb 01                	jmp    802fc4 <free_block+0x27b>
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
	{
		return;
  802fc3:	90                   	nop
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
}
  802fc4:	c9                   	leave  
  802fc5:	c3                   	ret    

00802fc6 <realloc_block_FF>:
//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
  802fc6:	55                   	push   %ebp
  802fc7:	89 e5                	mov    %esp,%ebp
  802fc9:	83 ec 38             	sub    $0x38,%esp
	//TODO: [PROJECT'24.MS1 - #08] [3] DYNAMIC ALLOCATOR - realloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(va == NULL && new_size == 0)
  802fcc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fd0:	75 10                	jne    802fe2 <realloc_block_FF+0x1c>
  802fd2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fd6:	75 0a                	jne    802fe2 <realloc_block_FF+0x1c>
	{
		return NULL;
  802fd8:	b8 00 00 00 00       	mov    $0x0,%eax
  802fdd:	e9 8b 04 00 00       	jmp    80346d <realloc_block_FF+0x4a7>
	}

	if(new_size == 0)
  802fe2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fe6:	75 18                	jne    803000 <realloc_block_FF+0x3a>
	{
		free_block(va);
  802fe8:	83 ec 0c             	sub    $0xc,%esp
  802feb:	ff 75 08             	pushl  0x8(%ebp)
  802fee:	e8 56 fd ff ff       	call   802d49 <free_block>
  802ff3:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802ff6:	b8 00 00 00 00       	mov    $0x0,%eax
  802ffb:	e9 6d 04 00 00       	jmp    80346d <realloc_block_FF+0x4a7>
	}

	if(va == NULL)
  803000:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803004:	75 13                	jne    803019 <realloc_block_FF+0x53>
	{
		return alloc_block_FF(new_size);
  803006:	83 ec 0c             	sub    $0xc,%esp
  803009:	ff 75 0c             	pushl  0xc(%ebp)
  80300c:	e8 6f f6 ff ff       	call   802680 <alloc_block_FF>
  803011:	83 c4 10             	add    $0x10,%esp
  803014:	e9 54 04 00 00       	jmp    80346d <realloc_block_FF+0x4a7>
	}

	// if size is odd must be increment it by one
	if (new_size % 2 != 0)
  803019:	8b 45 0c             	mov    0xc(%ebp),%eax
  80301c:	83 e0 01             	and    $0x1,%eax
  80301f:	85 c0                	test   %eax,%eax
  803021:	74 03                	je     803026 <realloc_block_FF+0x60>
	{
		new_size++;
  803023:	ff 45 0c             	incl   0xc(%ebp)
	}

	// if size < 8 must be equal it to 8 because min size 8 excluding metadata
	if(new_size < 8)
  803026:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80302a:	77 07                	ja     803033 <realloc_block_FF+0x6d>
	{
		new_size = 8;
  80302c:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	}

	new_size += 8; // adds its footer and header size
  803033:	83 45 0c 08          	addl   $0x8,0xc(%ebp)

	uint32 actualSize = get_block_size(va);
  803037:	83 ec 0c             	sub    $0xc,%esp
  80303a:	ff 75 08             	pushl  0x8(%ebp)
  80303d:	e8 d8 f1 ff ff       	call   80221a <get_block_size>
  803042:	83 c4 10             	add    $0x10,%esp
  803045:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(actualSize == new_size)
  803048:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80304e:	75 08                	jne    803058 <realloc_block_FF+0x92>
	{
		// don't change any thing
		return va;
  803050:	8b 45 08             	mov    0x8(%ebp),%eax
  803053:	e9 15 04 00 00       	jmp    80346d <realloc_block_FF+0x4a7>
	}

	// next block for the block we want to change its size
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + actualSize);
  803058:	8b 55 08             	mov    0x8(%ebp),%edx
  80305b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305e:	01 d0                	add    %edx,%eax
  803060:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  803063:	83 ec 0c             	sub    $0xc,%esp
  803066:	ff 75 f0             	pushl  -0x10(%ebp)
  803069:	e8 c5 f1 ff ff       	call   802233 <is_free_block>
  80306e:	83 c4 10             	add    $0x10,%esp
  803071:	0f be c0             	movsbl %al,%eax
  803074:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 nextSize = get_block_size(nextBlk);
  803077:	83 ec 0c             	sub    $0xc,%esp
  80307a:	ff 75 f0             	pushl  -0x10(%ebp)
  80307d:	e8 98 f1 ff ff       	call   80221a <get_block_size>
  803082:	83 c4 10             	add    $0x10,%esp
  803085:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// increase the size of block
	if(new_size > actualSize)
  803088:	8b 45 0c             	mov    0xc(%ebp),%eax
  80308b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80308e:	0f 86 a7 02 00 00    	jbe    80333b <realloc_block_FF+0x375>
	{
		if(isNextFree)
  803094:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803098:	0f 84 86 02 00 00    	je     803324 <realloc_block_FF+0x35e>
		{
			if(nextSize + actualSize == new_size) // block and nextblock = newSizeBlock
  80309e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a4:	01 d0                	add    %edx,%eax
  8030a6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8030a9:	0f 85 b2 00 00 00    	jne    803161 <realloc_block_FF+0x19b>
			{
				set_block_data(va,new_size,!(is_free_block(va)));// update size in block
  8030af:	83 ec 0c             	sub    $0xc,%esp
  8030b2:	ff 75 08             	pushl  0x8(%ebp)
  8030b5:	e8 79 f1 ff ff       	call   802233 <is_free_block>
  8030ba:	83 c4 10             	add    $0x10,%esp
  8030bd:	84 c0                	test   %al,%al
  8030bf:	0f 94 c0             	sete   %al
  8030c2:	0f b6 c0             	movzbl %al,%eax
  8030c5:	83 ec 04             	sub    $0x4,%esp
  8030c8:	50                   	push   %eax
  8030c9:	ff 75 0c             	pushl  0xc(%ebp)
  8030cc:	ff 75 08             	pushl  0x8(%ebp)
  8030cf:	e8 c2 f3 ff ff       	call   802496 <set_block_data>
  8030d4:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);// remove next because it is = zero
  8030d7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030db:	75 17                	jne    8030f4 <realloc_block_FF+0x12e>
  8030dd:	83 ec 04             	sub    $0x4,%esp
  8030e0:	68 c0 41 80 00       	push   $0x8041c0
  8030e5:	68 db 01 00 00       	push   $0x1db
  8030ea:	68 17 41 80 00       	push   $0x804117
  8030ef:	e8 58 05 00 00       	call   80364c <_panic>
  8030f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030f7:	8b 00                	mov    (%eax),%eax
  8030f9:	85 c0                	test   %eax,%eax
  8030fb:	74 10                	je     80310d <realloc_block_FF+0x147>
  8030fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803100:	8b 00                	mov    (%eax),%eax
  803102:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803105:	8b 52 04             	mov    0x4(%edx),%edx
  803108:	89 50 04             	mov    %edx,0x4(%eax)
  80310b:	eb 0b                	jmp    803118 <realloc_block_FF+0x152>
  80310d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803110:	8b 40 04             	mov    0x4(%eax),%eax
  803113:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803118:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80311b:	8b 40 04             	mov    0x4(%eax),%eax
  80311e:	85 c0                	test   %eax,%eax
  803120:	74 0f                	je     803131 <realloc_block_FF+0x16b>
  803122:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803125:	8b 40 04             	mov    0x4(%eax),%eax
  803128:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80312b:	8b 12                	mov    (%edx),%edx
  80312d:	89 10                	mov    %edx,(%eax)
  80312f:	eb 0a                	jmp    80313b <realloc_block_FF+0x175>
  803131:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803134:	8b 00                	mov    (%eax),%eax
  803136:	a3 48 50 98 00       	mov    %eax,0x985048
  80313b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80313e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803144:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803147:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80314e:	a1 54 50 98 00       	mov    0x985054,%eax
  803153:	48                   	dec    %eax
  803154:	a3 54 50 98 00       	mov    %eax,0x985054
				return va;
  803159:	8b 45 08             	mov    0x8(%ebp),%eax
  80315c:	e9 0c 03 00 00       	jmp    80346d <realloc_block_FF+0x4a7>
			}
			else if(nextSize + actualSize > new_size) // new size is less than next and main blocks
  803161:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803164:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803167:	01 d0                	add    %edx,%eax
  803169:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80316c:	0f 86 b2 01 00 00    	jbe    803324 <realloc_block_FF+0x35e>
			{
				uint32 requiredSize = new_size - actualSize; // size that we need from the next block
  803172:	8b 45 0c             	mov    0xc(%ebp),%eax
  803175:	2b 45 f4             	sub    -0xc(%ebp),%eax
  803178:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				uint32 remainingNext = nextSize - requiredSize; // size that will remain from the next block after we split it
  80317b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80317e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  803181:	89 45 e0             	mov    %eax,-0x20(%ebp)

				// if next size will not fit another block (internal fragmentation)
				if(remainingNext < 16)
  803184:	83 7d e0 0f          	cmpl   $0xf,-0x20(%ebp)
  803188:	0f 87 b8 00 00 00    	ja     803246 <realloc_block_FF+0x280>
				{
					// we will take the main size of the block and its next size also
					set_block_data(va,actualSize + nextSize,!(is_free_block(va)));
  80318e:	83 ec 0c             	sub    $0xc,%esp
  803191:	ff 75 08             	pushl  0x8(%ebp)
  803194:	e8 9a f0 ff ff       	call   802233 <is_free_block>
  803199:	83 c4 10             	add    $0x10,%esp
  80319c:	84 c0                	test   %al,%al
  80319e:	0f 94 c0             	sete   %al
  8031a1:	0f b6 c0             	movzbl %al,%eax
  8031a4:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8031a7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031aa:	01 ca                	add    %ecx,%edx
  8031ac:	83 ec 04             	sub    $0x4,%esp
  8031af:	50                   	push   %eax
  8031b0:	52                   	push   %edx
  8031b1:	ff 75 08             	pushl  0x8(%ebp)
  8031b4:	e8 dd f2 ff ff       	call   802496 <set_block_data>
  8031b9:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,nextBlk);
  8031bc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031c0:	75 17                	jne    8031d9 <realloc_block_FF+0x213>
  8031c2:	83 ec 04             	sub    $0x4,%esp
  8031c5:	68 c0 41 80 00       	push   $0x8041c0
  8031ca:	68 e8 01 00 00       	push   $0x1e8
  8031cf:	68 17 41 80 00       	push   $0x804117
  8031d4:	e8 73 04 00 00       	call   80364c <_panic>
  8031d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031dc:	8b 00                	mov    (%eax),%eax
  8031de:	85 c0                	test   %eax,%eax
  8031e0:	74 10                	je     8031f2 <realloc_block_FF+0x22c>
  8031e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031e5:	8b 00                	mov    (%eax),%eax
  8031e7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031ea:	8b 52 04             	mov    0x4(%edx),%edx
  8031ed:	89 50 04             	mov    %edx,0x4(%eax)
  8031f0:	eb 0b                	jmp    8031fd <realloc_block_FF+0x237>
  8031f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f5:	8b 40 04             	mov    0x4(%eax),%eax
  8031f8:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8031fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803200:	8b 40 04             	mov    0x4(%eax),%eax
  803203:	85 c0                	test   %eax,%eax
  803205:	74 0f                	je     803216 <realloc_block_FF+0x250>
  803207:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80320a:	8b 40 04             	mov    0x4(%eax),%eax
  80320d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803210:	8b 12                	mov    (%edx),%edx
  803212:	89 10                	mov    %edx,(%eax)
  803214:	eb 0a                	jmp    803220 <realloc_block_FF+0x25a>
  803216:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803219:	8b 00                	mov    (%eax),%eax
  80321b:	a3 48 50 98 00       	mov    %eax,0x985048
  803220:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803223:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803229:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80322c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803233:	a1 54 50 98 00       	mov    0x985054,%eax
  803238:	48                   	dec    %eax
  803239:	a3 54 50 98 00       	mov    %eax,0x985054
					return va;
  80323e:	8b 45 08             	mov    0x8(%ebp),%eax
  803241:	e9 27 02 00 00       	jmp    80346d <realloc_block_FF+0x4a7>
				}
				else // if next size can be fit another block (split)
				{
					LIST_REMOVE(&freeBlocksList,nextBlk);
  803246:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80324a:	75 17                	jne    803263 <realloc_block_FF+0x29d>
  80324c:	83 ec 04             	sub    $0x4,%esp
  80324f:	68 c0 41 80 00       	push   $0x8041c0
  803254:	68 ed 01 00 00       	push   $0x1ed
  803259:	68 17 41 80 00       	push   $0x804117
  80325e:	e8 e9 03 00 00       	call   80364c <_panic>
  803263:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803266:	8b 00                	mov    (%eax),%eax
  803268:	85 c0                	test   %eax,%eax
  80326a:	74 10                	je     80327c <realloc_block_FF+0x2b6>
  80326c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80326f:	8b 00                	mov    (%eax),%eax
  803271:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803274:	8b 52 04             	mov    0x4(%edx),%edx
  803277:	89 50 04             	mov    %edx,0x4(%eax)
  80327a:	eb 0b                	jmp    803287 <realloc_block_FF+0x2c1>
  80327c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80327f:	8b 40 04             	mov    0x4(%eax),%eax
  803282:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803287:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80328a:	8b 40 04             	mov    0x4(%eax),%eax
  80328d:	85 c0                	test   %eax,%eax
  80328f:	74 0f                	je     8032a0 <realloc_block_FF+0x2da>
  803291:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803294:	8b 40 04             	mov    0x4(%eax),%eax
  803297:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80329a:	8b 12                	mov    (%edx),%edx
  80329c:	89 10                	mov    %edx,(%eax)
  80329e:	eb 0a                	jmp    8032aa <realloc_block_FF+0x2e4>
  8032a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032a3:	8b 00                	mov    (%eax),%eax
  8032a5:	a3 48 50 98 00       	mov    %eax,0x985048
  8032aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032b6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032bd:	a1 54 50 98 00       	mov    0x985054,%eax
  8032c2:	48                   	dec    %eax
  8032c3:	a3 54 50 98 00       	mov    %eax,0x985054
					nextBlk = (struct BlockElement *)((char *)va + new_size); //update nextBlk address
  8032c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8032cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032ce:	01 d0                	add    %edx,%eax
  8032d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
					set_block_data(nextBlk,remainingNext,0); // update nextBlkSize
  8032d3:	83 ec 04             	sub    $0x4,%esp
  8032d6:	6a 00                	push   $0x0
  8032d8:	ff 75 e0             	pushl  -0x20(%ebp)
  8032db:	ff 75 f0             	pushl  -0x10(%ebp)
  8032de:	e8 b3 f1 ff ff       	call   802496 <set_block_data>
  8032e3:	83 c4 10             	add    $0x10,%esp
					set_block_data(va,new_size,!(is_free_block(va))); // update size of newblock
  8032e6:	83 ec 0c             	sub    $0xc,%esp
  8032e9:	ff 75 08             	pushl  0x8(%ebp)
  8032ec:	e8 42 ef ff ff       	call   802233 <is_free_block>
  8032f1:	83 c4 10             	add    $0x10,%esp
  8032f4:	84 c0                	test   %al,%al
  8032f6:	0f 94 c0             	sete   %al
  8032f9:	0f b6 c0             	movzbl %al,%eax
  8032fc:	83 ec 04             	sub    $0x4,%esp
  8032ff:	50                   	push   %eax
  803300:	ff 75 0c             	pushl  0xc(%ebp)
  803303:	ff 75 08             	pushl  0x8(%ebp)
  803306:	e8 8b f1 ff ff       	call   802496 <set_block_data>
  80330b:	83 c4 10             	add    $0x10,%esp
					insert_sorted_in_freeList(nextBlk);
  80330e:	83 ec 0c             	sub    $0xc,%esp
  803311:	ff 75 f0             	pushl  -0x10(%ebp)
  803314:	e8 d4 f1 ff ff       	call   8024ed <insert_sorted_in_freeList>
  803319:	83 c4 10             	add    $0x10,%esp
					return va;
  80331c:	8b 45 08             	mov    0x8(%ebp),%eax
  80331f:	e9 49 01 00 00       	jmp    80346d <realloc_block_FF+0x4a7>
				}
			}
		}
		// if next block isn't free or not fit the new size
		return alloc_block_FF(new_size - 8);
  803324:	8b 45 0c             	mov    0xc(%ebp),%eax
  803327:	83 e8 08             	sub    $0x8,%eax
  80332a:	83 ec 0c             	sub    $0xc,%esp
  80332d:	50                   	push   %eax
  80332e:	e8 4d f3 ff ff       	call   802680 <alloc_block_FF>
  803333:	83 c4 10             	add    $0x10,%esp
  803336:	e9 32 01 00 00       	jmp    80346d <realloc_block_FF+0x4a7>
	}
	else if(new_size < actualSize) // to shrink block
  80333b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80333e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803341:	0f 83 21 01 00 00    	jae    803468 <realloc_block_FF+0x4a2>
	{
		uint32 remainingSize = actualSize - new_size; // size that will remain from the main block after we shrink it
  803347:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80334a:	2b 45 0c             	sub    0xc(%ebp),%eax
  80334d:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(remainingSize < 16 && isNextFree == 0) // internal fragmentation
  803350:	83 7d dc 0f          	cmpl   $0xf,-0x24(%ebp)
  803354:	77 0e                	ja     803364 <realloc_block_FF+0x39e>
  803356:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80335a:	75 08                	jne    803364 <realloc_block_FF+0x39e>
		{
			// don't change its size
			return va;
  80335c:	8b 45 08             	mov    0x8(%ebp),%eax
  80335f:	e9 09 01 00 00       	jmp    80346d <realloc_block_FF+0x4a7>
		}
		else // remainingSize fit in a new block
		{
			struct BlockElement *mainBlk = (struct BlockElement *)va;
  803364:	8b 45 08             	mov    0x8(%ebp),%eax
  803367:	89 45 d8             	mov    %eax,-0x28(%ebp)
			// update main block with new size
			set_block_data(mainBlk,new_size,!(is_free_block(va)));
  80336a:	83 ec 0c             	sub    $0xc,%esp
  80336d:	ff 75 08             	pushl  0x8(%ebp)
  803370:	e8 be ee ff ff       	call   802233 <is_free_block>
  803375:	83 c4 10             	add    $0x10,%esp
  803378:	84 c0                	test   %al,%al
  80337a:	0f 94 c0             	sete   %al
  80337d:	0f b6 c0             	movzbl %al,%eax
  803380:	83 ec 04             	sub    $0x4,%esp
  803383:	50                   	push   %eax
  803384:	ff 75 0c             	pushl  0xc(%ebp)
  803387:	ff 75 d8             	pushl  -0x28(%ebp)
  80338a:	e8 07 f1 ff ff       	call   802496 <set_block_data>
  80338f:	83 c4 10             	add    $0x10,%esp

			// the blk with remaining size
			struct BlockElement *remainingBlk=(struct BlockElement *)((char*)mainBlk + new_size);
  803392:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803395:	8b 45 0c             	mov    0xc(%ebp),%eax
  803398:	01 d0                	add    %edx,%eax
  80339a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			set_block_data(remainingBlk,remainingSize,0);
  80339d:	83 ec 04             	sub    $0x4,%esp
  8033a0:	6a 00                	push   $0x0
  8033a2:	ff 75 dc             	pushl  -0x24(%ebp)
  8033a5:	ff 75 d4             	pushl  -0x2c(%ebp)
  8033a8:	e8 e9 f0 ff ff       	call   802496 <set_block_data>
  8033ad:	83 c4 10             	add    $0x10,%esp

			if(isNextFree)
  8033b0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8033b4:	0f 84 9b 00 00 00    	je     803455 <realloc_block_FF+0x48f>
			{
				// merge splited block with its next block
				set_block_data(remainingBlk,(remainingSize + nextSize),0);//merge remaining with its next block
  8033ba:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8033bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033c0:	01 d0                	add    %edx,%eax
  8033c2:	83 ec 04             	sub    $0x4,%esp
  8033c5:	6a 00                	push   $0x0
  8033c7:	50                   	push   %eax
  8033c8:	ff 75 d4             	pushl  -0x2c(%ebp)
  8033cb:	e8 c6 f0 ff ff       	call   802496 <set_block_data>
  8033d0:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);
  8033d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033d7:	75 17                	jne    8033f0 <realloc_block_FF+0x42a>
  8033d9:	83 ec 04             	sub    $0x4,%esp
  8033dc:	68 c0 41 80 00       	push   $0x8041c0
  8033e1:	68 10 02 00 00       	push   $0x210
  8033e6:	68 17 41 80 00       	push   $0x804117
  8033eb:	e8 5c 02 00 00       	call   80364c <_panic>
  8033f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033f3:	8b 00                	mov    (%eax),%eax
  8033f5:	85 c0                	test   %eax,%eax
  8033f7:	74 10                	je     803409 <realloc_block_FF+0x443>
  8033f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033fc:	8b 00                	mov    (%eax),%eax
  8033fe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803401:	8b 52 04             	mov    0x4(%edx),%edx
  803404:	89 50 04             	mov    %edx,0x4(%eax)
  803407:	eb 0b                	jmp    803414 <realloc_block_FF+0x44e>
  803409:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80340c:	8b 40 04             	mov    0x4(%eax),%eax
  80340f:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803414:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803417:	8b 40 04             	mov    0x4(%eax),%eax
  80341a:	85 c0                	test   %eax,%eax
  80341c:	74 0f                	je     80342d <realloc_block_FF+0x467>
  80341e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803421:	8b 40 04             	mov    0x4(%eax),%eax
  803424:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803427:	8b 12                	mov    (%edx),%edx
  803429:	89 10                	mov    %edx,(%eax)
  80342b:	eb 0a                	jmp    803437 <realloc_block_FF+0x471>
  80342d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803430:	8b 00                	mov    (%eax),%eax
  803432:	a3 48 50 98 00       	mov    %eax,0x985048
  803437:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80343a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803440:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803443:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80344a:	a1 54 50 98 00       	mov    0x985054,%eax
  80344f:	48                   	dec    %eax
  803450:	a3 54 50 98 00       	mov    %eax,0x985054
			}
			insert_sorted_in_freeList(remainingBlk);
  803455:	83 ec 0c             	sub    $0xc,%esp
  803458:	ff 75 d4             	pushl  -0x2c(%ebp)
  80345b:	e8 8d f0 ff ff       	call   8024ed <insert_sorted_in_freeList>
  803460:	83 c4 10             	add    $0x10,%esp
			return mainBlk;
  803463:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803466:	eb 05                	jmp    80346d <realloc_block_FF+0x4a7>
		}
	}
	return NULL;
  803468:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80346d:	c9                   	leave  
  80346e:	c3                   	ret    

0080346f <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  80346f:	55                   	push   %ebp
  803470:	89 e5                	mov    %esp,%ebp
  803472:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803475:	83 ec 04             	sub    $0x4,%esp
  803478:	68 e0 41 80 00       	push   $0x8041e0
  80347d:	68 20 02 00 00       	push   $0x220
  803482:	68 17 41 80 00       	push   $0x804117
  803487:	e8 c0 01 00 00       	call   80364c <_panic>

0080348c <alloc_block_NF>:
}
//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  80348c:	55                   	push   %ebp
  80348d:	89 e5                	mov    %esp,%ebp
  80348f:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803492:	83 ec 04             	sub    $0x4,%esp
  803495:	68 08 42 80 00       	push   $0x804208
  80349a:	68 28 02 00 00       	push   $0x228
  80349f:	68 17 41 80 00       	push   $0x804117
  8034a4:	e8 a3 01 00 00       	call   80364c <_panic>

008034a9 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  8034a9:	55                   	push   %ebp
  8034aa:	89 e5                	mov    %esp,%ebp
  8034ac:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("create_semaphore is not implemented yet");
	//Your Code is Here...

	//create object of __semdata struct and allocate it using smalloc with sizeof __semdata struct
	struct __semdata* semaphoryData = (struct __semdata *)smalloc(semaphoreName , sizeof(struct __semdata) ,1);
  8034af:	83 ec 04             	sub    $0x4,%esp
  8034b2:	6a 01                	push   $0x1
  8034b4:	6a 58                	push   $0x58
  8034b6:	ff 75 0c             	pushl  0xc(%ebp)
  8034b9:	e8 c1 e2 ff ff       	call   80177f <smalloc>
  8034be:	83 c4 10             	add    $0x10,%esp
  8034c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(semaphoryData == NULL)
  8034c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034c8:	75 14                	jne    8034de <create_semaphore+0x35>
	{
		panic("Not Enough Space to allocate semdata object!!");
  8034ca:	83 ec 04             	sub    $0x4,%esp
  8034cd:	68 30 42 80 00       	push   $0x804230
  8034d2:	6a 10                	push   $0x10
  8034d4:	68 5e 42 80 00       	push   $0x80425e
  8034d9:	e8 6e 01 00 00       	call   80364c <_panic>
	}
	//aboveObject.queue pass it to init_queue() function
	sys_init_queue(&(semaphoryData->queue));
  8034de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e1:	83 ec 0c             	sub    $0xc,%esp
  8034e4:	50                   	push   %eax
  8034e5:	e8 bc ec ff ff       	call   8021a6 <sys_init_queue>
  8034ea:	83 c4 10             	add    $0x10,%esp
	//lock variable initially with zero
	semaphoryData->lock = 0;
  8034ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f0:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
	//initialize aboveObject with semaphore name and value
	strncpy(semaphoryData->name , semaphoreName , sizeof(semaphoryData->name));
  8034f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034fa:	83 c0 18             	add    $0x18,%eax
  8034fd:	83 ec 04             	sub    $0x4,%esp
  803500:	6a 40                	push   $0x40
  803502:	ff 75 0c             	pushl  0xc(%ebp)
  803505:	50                   	push   %eax
  803506:	e8 1e d9 ff ff       	call   800e29 <strncpy>
  80350b:	83 c4 10             	add    $0x10,%esp
	semaphoryData->count = value;
  80350e:	8b 55 10             	mov    0x10(%ebp),%edx
  803511:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803514:	89 50 10             	mov    %edx,0x10(%eax)

	//create object of semaphore struct
	struct semaphore semaphory;
	//add aboveObject to this semaphore object
	semaphory.semdata = semaphoryData;
  803517:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80351a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//return semaphore object
	return semaphory;
  80351d:	8b 45 08             	mov    0x8(%ebp),%eax
  803520:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803523:	89 10                	mov    %edx,(%eax)
}
  803525:	8b 45 08             	mov    0x8(%ebp),%eax
  803528:	c9                   	leave  
  803529:	c2 04 00             	ret    $0x4

0080352c <get_semaphore>:
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  80352c:	55                   	push   %ebp
  80352d:	89 e5                	mov    %esp,%ebp
  80352f:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("get_semaphore is not implemented yet");
	//Your Code is Here...

	// get the semdata object that is allocated, using sget
	struct __semdata* semaphoryData = sget(ownerEnvID, semaphoreName);
  803532:	83 ec 08             	sub    $0x8,%esp
  803535:	ff 75 10             	pushl  0x10(%ebp)
  803538:	ff 75 0c             	pushl  0xc(%ebp)
  80353b:	e8 da e3 ff ff       	call   80191a <sget>
  803540:	83 c4 10             	add    $0x10,%esp
  803543:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(semaphoryData == NULL)
  803546:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80354a:	75 14                	jne    803560 <get_semaphore+0x34>
	{
		panic("semdatat object does not exist!!");
  80354c:	83 ec 04             	sub    $0x4,%esp
  80354f:	68 70 42 80 00       	push   $0x804270
  803554:	6a 2c                	push   $0x2c
  803556:	68 5e 42 80 00       	push   $0x80425e
  80355b:	e8 ec 00 00 00       	call   80364c <_panic>
	}
	//create object of semaphore struct
	struct semaphore semaphory;
	//add semdata object to this semaphore object
	semaphory.semdata = semaphoryData;
  803560:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803563:	89 45 f0             	mov    %eax,-0x10(%ebp)
	return semaphory;
  803566:	8b 45 08             	mov    0x8(%ebp),%eax
  803569:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80356c:	89 10                	mov    %edx,(%eax)
}
  80356e:	8b 45 08             	mov    0x8(%ebp),%eax
  803571:	c9                   	leave  
  803572:	c2 04 00             	ret    $0x4

00803575 <wait_semaphore>:

void wait_semaphore(struct semaphore sem)
{
  803575:	55                   	push   %ebp
  803576:	89 e5                	mov    %esp,%ebp
  803578:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("wait_semaphore is not implemented yet");
	//Your Code is Here...

	//acquire semaphore lock
	uint32 myKey = 1;
  80357b:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	do
	{
		xchg(&myKey, sem.semdata->lock); // xchg atomically exchanges values
  803582:	8b 45 08             	mov    0x8(%ebp),%eax
  803585:	8b 40 14             	mov    0x14(%eax),%eax
  803588:	8d 55 e8             	lea    -0x18(%ebp),%edx
  80358b:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80358e:	89 45 f0             	mov    %eax,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  803591:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803594:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803597:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80359a:	f0 87 02             	lock xchg %eax,(%edx)
  80359d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	} while (myKey != 0);
  8035a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035a3:	85 c0                	test   %eax,%eax
  8035a5:	75 db                	jne    803582 <wait_semaphore+0xd>

	//decrement the semaphore counter
	sem.semdata->count--;
  8035a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035aa:	8b 50 10             	mov    0x10(%eax),%edx
  8035ad:	4a                   	dec    %edx
  8035ae:	89 50 10             	mov    %edx,0x10(%eax)

	if (sem.semdata->count < 0)
  8035b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b4:	8b 40 10             	mov    0x10(%eax),%eax
  8035b7:	85 c0                	test   %eax,%eax
  8035b9:	79 18                	jns    8035d3 <wait_semaphore+0x5e>
	{
		// block the current process
		sys_block_process(&(sem.semdata->queue),&(sem.semdata->lock));
  8035bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8035be:	8d 50 14             	lea    0x14(%eax),%edx
  8035c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c4:	83 ec 08             	sub    $0x8,%esp
  8035c7:	52                   	push   %edx
  8035c8:	50                   	push   %eax
  8035c9:	e8 f4 eb ff ff       	call   8021c2 <sys_block_process>
  8035ce:	83 c4 10             	add    $0x10,%esp
  8035d1:	eb 0a                	jmp    8035dd <wait_semaphore+0x68>
		return;
	}
	//release semaphore lock
	sem.semdata->lock = 0;
  8035d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d6:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
}
  8035dd:	c9                   	leave  
  8035de:	c3                   	ret    

008035df <signal_semaphore>:

void signal_semaphore(struct semaphore sem)
{
  8035df:	55                   	push   %ebp
  8035e0:	89 e5                	mov    %esp,%ebp
  8035e2:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("signal_semaphore is not implemented yet");
	//Your Code is Here...

	//acquire semaphore lock
	uint32 myKey = 1;
  8035e5:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	do
	{
		xchg(&myKey, sem.semdata->lock); // xchg atomically exchanges values
  8035ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ef:	8b 40 14             	mov    0x14(%eax),%eax
  8035f2:	8d 55 e8             	lea    -0x18(%ebp),%edx
  8035f5:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8035f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8035fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803601:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803604:	f0 87 02             	lock xchg %eax,(%edx)
  803607:	89 45 ec             	mov    %eax,-0x14(%ebp)
	} while (myKey != 0);
  80360a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80360d:	85 c0                	test   %eax,%eax
  80360f:	75 db                	jne    8035ec <signal_semaphore+0xd>

	// increment the semaphore counter
	sem.semdata->count++;
  803611:	8b 45 08             	mov    0x8(%ebp),%eax
  803614:	8b 50 10             	mov    0x10(%eax),%edx
  803617:	42                   	inc    %edx
  803618:	89 50 10             	mov    %edx,0x10(%eax)

	if (sem.semdata->count <= 0) {
  80361b:	8b 45 08             	mov    0x8(%ebp),%eax
  80361e:	8b 40 10             	mov    0x10(%eax),%eax
  803621:	85 c0                	test   %eax,%eax
  803623:	7f 0f                	jg     803634 <signal_semaphore+0x55>
		// unblock the current process
		sys_unblock_process(&(sem.semdata->queue));
  803625:	8b 45 08             	mov    0x8(%ebp),%eax
  803628:	83 ec 0c             	sub    $0xc,%esp
  80362b:	50                   	push   %eax
  80362c:	e8 af eb ff ff       	call   8021e0 <sys_unblock_process>
  803631:	83 c4 10             	add    $0x10,%esp
	}

	// release the lock
	sem.semdata->lock = 0;
  803634:	8b 45 08             	mov    0x8(%ebp),%eax
  803637:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
}
  80363e:	90                   	nop
  80363f:	c9                   	leave  
  803640:	c3                   	ret    

00803641 <semaphore_count>:

int semaphore_count(struct semaphore sem)
{
  803641:	55                   	push   %ebp
  803642:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  803644:	8b 45 08             	mov    0x8(%ebp),%eax
  803647:	8b 40 10             	mov    0x10(%eax),%eax
}
  80364a:	5d                   	pop    %ebp
  80364b:	c3                   	ret    

0080364c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80364c:	55                   	push   %ebp
  80364d:	89 e5                	mov    %esp,%ebp
  80364f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803652:	8d 45 10             	lea    0x10(%ebp),%eax
  803655:	83 c0 04             	add    $0x4,%eax
  803658:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80365b:	a1 60 50 98 00       	mov    0x985060,%eax
  803660:	85 c0                	test   %eax,%eax
  803662:	74 16                	je     80367a <_panic+0x2e>
		cprintf("%s: ", argv0);
  803664:	a1 60 50 98 00       	mov    0x985060,%eax
  803669:	83 ec 08             	sub    $0x8,%esp
  80366c:	50                   	push   %eax
  80366d:	68 94 42 80 00       	push   $0x804294
  803672:	e8 a1 d0 ff ff       	call   800718 <cprintf>
  803677:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80367a:	a1 04 50 80 00       	mov    0x805004,%eax
  80367f:	ff 75 0c             	pushl  0xc(%ebp)
  803682:	ff 75 08             	pushl  0x8(%ebp)
  803685:	50                   	push   %eax
  803686:	68 99 42 80 00       	push   $0x804299
  80368b:	e8 88 d0 ff ff       	call   800718 <cprintf>
  803690:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803693:	8b 45 10             	mov    0x10(%ebp),%eax
  803696:	83 ec 08             	sub    $0x8,%esp
  803699:	ff 75 f4             	pushl  -0xc(%ebp)
  80369c:	50                   	push   %eax
  80369d:	e8 0b d0 ff ff       	call   8006ad <vcprintf>
  8036a2:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8036a5:	83 ec 08             	sub    $0x8,%esp
  8036a8:	6a 00                	push   $0x0
  8036aa:	68 b5 42 80 00       	push   $0x8042b5
  8036af:	e8 f9 cf ff ff       	call   8006ad <vcprintf>
  8036b4:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8036b7:	e8 7a cf ff ff       	call   800636 <exit>

	// should not return here
	while (1) ;
  8036bc:	eb fe                	jmp    8036bc <_panic+0x70>

008036be <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8036be:	55                   	push   %ebp
  8036bf:	89 e5                	mov    %esp,%ebp
  8036c1:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8036c4:	a1 20 50 80 00       	mov    0x805020,%eax
  8036c9:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8036cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036d2:	39 c2                	cmp    %eax,%edx
  8036d4:	74 14                	je     8036ea <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8036d6:	83 ec 04             	sub    $0x4,%esp
  8036d9:	68 b8 42 80 00       	push   $0x8042b8
  8036de:	6a 26                	push   $0x26
  8036e0:	68 04 43 80 00       	push   $0x804304
  8036e5:	e8 62 ff ff ff       	call   80364c <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8036ea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8036f1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8036f8:	e9 c5 00 00 00       	jmp    8037c2 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8036fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803700:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803707:	8b 45 08             	mov    0x8(%ebp),%eax
  80370a:	01 d0                	add    %edx,%eax
  80370c:	8b 00                	mov    (%eax),%eax
  80370e:	85 c0                	test   %eax,%eax
  803710:	75 08                	jne    80371a <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803712:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803715:	e9 a5 00 00 00       	jmp    8037bf <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80371a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803721:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803728:	eb 69                	jmp    803793 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80372a:	a1 20 50 80 00       	mov    0x805020,%eax
  80372f:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  803735:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803738:	89 d0                	mov    %edx,%eax
  80373a:	01 c0                	add    %eax,%eax
  80373c:	01 d0                	add    %edx,%eax
  80373e:	c1 e0 03             	shl    $0x3,%eax
  803741:	01 c8                	add    %ecx,%eax
  803743:	8a 40 04             	mov    0x4(%eax),%al
  803746:	84 c0                	test   %al,%al
  803748:	75 46                	jne    803790 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80374a:	a1 20 50 80 00       	mov    0x805020,%eax
  80374f:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  803755:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803758:	89 d0                	mov    %edx,%eax
  80375a:	01 c0                	add    %eax,%eax
  80375c:	01 d0                	add    %edx,%eax
  80375e:	c1 e0 03             	shl    $0x3,%eax
  803761:	01 c8                	add    %ecx,%eax
  803763:	8b 00                	mov    (%eax),%eax
  803765:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803768:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80376b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803770:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803772:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803775:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80377c:	8b 45 08             	mov    0x8(%ebp),%eax
  80377f:	01 c8                	add    %ecx,%eax
  803781:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803783:	39 c2                	cmp    %eax,%edx
  803785:	75 09                	jne    803790 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803787:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80378e:	eb 15                	jmp    8037a5 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803790:	ff 45 e8             	incl   -0x18(%ebp)
  803793:	a1 20 50 80 00       	mov    0x805020,%eax
  803798:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80379e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037a1:	39 c2                	cmp    %eax,%edx
  8037a3:	77 85                	ja     80372a <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8037a5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8037a9:	75 14                	jne    8037bf <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8037ab:	83 ec 04             	sub    $0x4,%esp
  8037ae:	68 10 43 80 00       	push   $0x804310
  8037b3:	6a 3a                	push   $0x3a
  8037b5:	68 04 43 80 00       	push   $0x804304
  8037ba:	e8 8d fe ff ff       	call   80364c <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8037bf:	ff 45 f0             	incl   -0x10(%ebp)
  8037c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037c5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8037c8:	0f 8c 2f ff ff ff    	jl     8036fd <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8037ce:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8037d5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8037dc:	eb 26                	jmp    803804 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8037de:	a1 20 50 80 00       	mov    0x805020,%eax
  8037e3:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8037e9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8037ec:	89 d0                	mov    %edx,%eax
  8037ee:	01 c0                	add    %eax,%eax
  8037f0:	01 d0                	add    %edx,%eax
  8037f2:	c1 e0 03             	shl    $0x3,%eax
  8037f5:	01 c8                	add    %ecx,%eax
  8037f7:	8a 40 04             	mov    0x4(%eax),%al
  8037fa:	3c 01                	cmp    $0x1,%al
  8037fc:	75 03                	jne    803801 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8037fe:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803801:	ff 45 e0             	incl   -0x20(%ebp)
  803804:	a1 20 50 80 00       	mov    0x805020,%eax
  803809:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80380f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803812:	39 c2                	cmp    %eax,%edx
  803814:	77 c8                	ja     8037de <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803816:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803819:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80381c:	74 14                	je     803832 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80381e:	83 ec 04             	sub    $0x4,%esp
  803821:	68 64 43 80 00       	push   $0x804364
  803826:	6a 44                	push   $0x44
  803828:	68 04 43 80 00       	push   $0x804304
  80382d:	e8 1a fe ff ff       	call   80364c <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803832:	90                   	nop
  803833:	c9                   	leave  
  803834:	c3                   	ret    
  803835:	66 90                	xchg   %ax,%ax
  803837:	90                   	nop

00803838 <__udivdi3>:
  803838:	55                   	push   %ebp
  803839:	57                   	push   %edi
  80383a:	56                   	push   %esi
  80383b:	53                   	push   %ebx
  80383c:	83 ec 1c             	sub    $0x1c,%esp
  80383f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803843:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803847:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80384b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80384f:	89 ca                	mov    %ecx,%edx
  803851:	89 f8                	mov    %edi,%eax
  803853:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803857:	85 f6                	test   %esi,%esi
  803859:	75 2d                	jne    803888 <__udivdi3+0x50>
  80385b:	39 cf                	cmp    %ecx,%edi
  80385d:	77 65                	ja     8038c4 <__udivdi3+0x8c>
  80385f:	89 fd                	mov    %edi,%ebp
  803861:	85 ff                	test   %edi,%edi
  803863:	75 0b                	jne    803870 <__udivdi3+0x38>
  803865:	b8 01 00 00 00       	mov    $0x1,%eax
  80386a:	31 d2                	xor    %edx,%edx
  80386c:	f7 f7                	div    %edi
  80386e:	89 c5                	mov    %eax,%ebp
  803870:	31 d2                	xor    %edx,%edx
  803872:	89 c8                	mov    %ecx,%eax
  803874:	f7 f5                	div    %ebp
  803876:	89 c1                	mov    %eax,%ecx
  803878:	89 d8                	mov    %ebx,%eax
  80387a:	f7 f5                	div    %ebp
  80387c:	89 cf                	mov    %ecx,%edi
  80387e:	89 fa                	mov    %edi,%edx
  803880:	83 c4 1c             	add    $0x1c,%esp
  803883:	5b                   	pop    %ebx
  803884:	5e                   	pop    %esi
  803885:	5f                   	pop    %edi
  803886:	5d                   	pop    %ebp
  803887:	c3                   	ret    
  803888:	39 ce                	cmp    %ecx,%esi
  80388a:	77 28                	ja     8038b4 <__udivdi3+0x7c>
  80388c:	0f bd fe             	bsr    %esi,%edi
  80388f:	83 f7 1f             	xor    $0x1f,%edi
  803892:	75 40                	jne    8038d4 <__udivdi3+0x9c>
  803894:	39 ce                	cmp    %ecx,%esi
  803896:	72 0a                	jb     8038a2 <__udivdi3+0x6a>
  803898:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80389c:	0f 87 9e 00 00 00    	ja     803940 <__udivdi3+0x108>
  8038a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8038a7:	89 fa                	mov    %edi,%edx
  8038a9:	83 c4 1c             	add    $0x1c,%esp
  8038ac:	5b                   	pop    %ebx
  8038ad:	5e                   	pop    %esi
  8038ae:	5f                   	pop    %edi
  8038af:	5d                   	pop    %ebp
  8038b0:	c3                   	ret    
  8038b1:	8d 76 00             	lea    0x0(%esi),%esi
  8038b4:	31 ff                	xor    %edi,%edi
  8038b6:	31 c0                	xor    %eax,%eax
  8038b8:	89 fa                	mov    %edi,%edx
  8038ba:	83 c4 1c             	add    $0x1c,%esp
  8038bd:	5b                   	pop    %ebx
  8038be:	5e                   	pop    %esi
  8038bf:	5f                   	pop    %edi
  8038c0:	5d                   	pop    %ebp
  8038c1:	c3                   	ret    
  8038c2:	66 90                	xchg   %ax,%ax
  8038c4:	89 d8                	mov    %ebx,%eax
  8038c6:	f7 f7                	div    %edi
  8038c8:	31 ff                	xor    %edi,%edi
  8038ca:	89 fa                	mov    %edi,%edx
  8038cc:	83 c4 1c             	add    $0x1c,%esp
  8038cf:	5b                   	pop    %ebx
  8038d0:	5e                   	pop    %esi
  8038d1:	5f                   	pop    %edi
  8038d2:	5d                   	pop    %ebp
  8038d3:	c3                   	ret    
  8038d4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8038d9:	89 eb                	mov    %ebp,%ebx
  8038db:	29 fb                	sub    %edi,%ebx
  8038dd:	89 f9                	mov    %edi,%ecx
  8038df:	d3 e6                	shl    %cl,%esi
  8038e1:	89 c5                	mov    %eax,%ebp
  8038e3:	88 d9                	mov    %bl,%cl
  8038e5:	d3 ed                	shr    %cl,%ebp
  8038e7:	89 e9                	mov    %ebp,%ecx
  8038e9:	09 f1                	or     %esi,%ecx
  8038eb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8038ef:	89 f9                	mov    %edi,%ecx
  8038f1:	d3 e0                	shl    %cl,%eax
  8038f3:	89 c5                	mov    %eax,%ebp
  8038f5:	89 d6                	mov    %edx,%esi
  8038f7:	88 d9                	mov    %bl,%cl
  8038f9:	d3 ee                	shr    %cl,%esi
  8038fb:	89 f9                	mov    %edi,%ecx
  8038fd:	d3 e2                	shl    %cl,%edx
  8038ff:	8b 44 24 08          	mov    0x8(%esp),%eax
  803903:	88 d9                	mov    %bl,%cl
  803905:	d3 e8                	shr    %cl,%eax
  803907:	09 c2                	or     %eax,%edx
  803909:	89 d0                	mov    %edx,%eax
  80390b:	89 f2                	mov    %esi,%edx
  80390d:	f7 74 24 0c          	divl   0xc(%esp)
  803911:	89 d6                	mov    %edx,%esi
  803913:	89 c3                	mov    %eax,%ebx
  803915:	f7 e5                	mul    %ebp
  803917:	39 d6                	cmp    %edx,%esi
  803919:	72 19                	jb     803934 <__udivdi3+0xfc>
  80391b:	74 0b                	je     803928 <__udivdi3+0xf0>
  80391d:	89 d8                	mov    %ebx,%eax
  80391f:	31 ff                	xor    %edi,%edi
  803921:	e9 58 ff ff ff       	jmp    80387e <__udivdi3+0x46>
  803926:	66 90                	xchg   %ax,%ax
  803928:	8b 54 24 08          	mov    0x8(%esp),%edx
  80392c:	89 f9                	mov    %edi,%ecx
  80392e:	d3 e2                	shl    %cl,%edx
  803930:	39 c2                	cmp    %eax,%edx
  803932:	73 e9                	jae    80391d <__udivdi3+0xe5>
  803934:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803937:	31 ff                	xor    %edi,%edi
  803939:	e9 40 ff ff ff       	jmp    80387e <__udivdi3+0x46>
  80393e:	66 90                	xchg   %ax,%ax
  803940:	31 c0                	xor    %eax,%eax
  803942:	e9 37 ff ff ff       	jmp    80387e <__udivdi3+0x46>
  803947:	90                   	nop

00803948 <__umoddi3>:
  803948:	55                   	push   %ebp
  803949:	57                   	push   %edi
  80394a:	56                   	push   %esi
  80394b:	53                   	push   %ebx
  80394c:	83 ec 1c             	sub    $0x1c,%esp
  80394f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803953:	8b 74 24 34          	mov    0x34(%esp),%esi
  803957:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80395b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80395f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803963:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803967:	89 f3                	mov    %esi,%ebx
  803969:	89 fa                	mov    %edi,%edx
  80396b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80396f:	89 34 24             	mov    %esi,(%esp)
  803972:	85 c0                	test   %eax,%eax
  803974:	75 1a                	jne    803990 <__umoddi3+0x48>
  803976:	39 f7                	cmp    %esi,%edi
  803978:	0f 86 a2 00 00 00    	jbe    803a20 <__umoddi3+0xd8>
  80397e:	89 c8                	mov    %ecx,%eax
  803980:	89 f2                	mov    %esi,%edx
  803982:	f7 f7                	div    %edi
  803984:	89 d0                	mov    %edx,%eax
  803986:	31 d2                	xor    %edx,%edx
  803988:	83 c4 1c             	add    $0x1c,%esp
  80398b:	5b                   	pop    %ebx
  80398c:	5e                   	pop    %esi
  80398d:	5f                   	pop    %edi
  80398e:	5d                   	pop    %ebp
  80398f:	c3                   	ret    
  803990:	39 f0                	cmp    %esi,%eax
  803992:	0f 87 ac 00 00 00    	ja     803a44 <__umoddi3+0xfc>
  803998:	0f bd e8             	bsr    %eax,%ebp
  80399b:	83 f5 1f             	xor    $0x1f,%ebp
  80399e:	0f 84 ac 00 00 00    	je     803a50 <__umoddi3+0x108>
  8039a4:	bf 20 00 00 00       	mov    $0x20,%edi
  8039a9:	29 ef                	sub    %ebp,%edi
  8039ab:	89 fe                	mov    %edi,%esi
  8039ad:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8039b1:	89 e9                	mov    %ebp,%ecx
  8039b3:	d3 e0                	shl    %cl,%eax
  8039b5:	89 d7                	mov    %edx,%edi
  8039b7:	89 f1                	mov    %esi,%ecx
  8039b9:	d3 ef                	shr    %cl,%edi
  8039bb:	09 c7                	or     %eax,%edi
  8039bd:	89 e9                	mov    %ebp,%ecx
  8039bf:	d3 e2                	shl    %cl,%edx
  8039c1:	89 14 24             	mov    %edx,(%esp)
  8039c4:	89 d8                	mov    %ebx,%eax
  8039c6:	d3 e0                	shl    %cl,%eax
  8039c8:	89 c2                	mov    %eax,%edx
  8039ca:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039ce:	d3 e0                	shl    %cl,%eax
  8039d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8039d4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039d8:	89 f1                	mov    %esi,%ecx
  8039da:	d3 e8                	shr    %cl,%eax
  8039dc:	09 d0                	or     %edx,%eax
  8039de:	d3 eb                	shr    %cl,%ebx
  8039e0:	89 da                	mov    %ebx,%edx
  8039e2:	f7 f7                	div    %edi
  8039e4:	89 d3                	mov    %edx,%ebx
  8039e6:	f7 24 24             	mull   (%esp)
  8039e9:	89 c6                	mov    %eax,%esi
  8039eb:	89 d1                	mov    %edx,%ecx
  8039ed:	39 d3                	cmp    %edx,%ebx
  8039ef:	0f 82 87 00 00 00    	jb     803a7c <__umoddi3+0x134>
  8039f5:	0f 84 91 00 00 00    	je     803a8c <__umoddi3+0x144>
  8039fb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8039ff:	29 f2                	sub    %esi,%edx
  803a01:	19 cb                	sbb    %ecx,%ebx
  803a03:	89 d8                	mov    %ebx,%eax
  803a05:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803a09:	d3 e0                	shl    %cl,%eax
  803a0b:	89 e9                	mov    %ebp,%ecx
  803a0d:	d3 ea                	shr    %cl,%edx
  803a0f:	09 d0                	or     %edx,%eax
  803a11:	89 e9                	mov    %ebp,%ecx
  803a13:	d3 eb                	shr    %cl,%ebx
  803a15:	89 da                	mov    %ebx,%edx
  803a17:	83 c4 1c             	add    $0x1c,%esp
  803a1a:	5b                   	pop    %ebx
  803a1b:	5e                   	pop    %esi
  803a1c:	5f                   	pop    %edi
  803a1d:	5d                   	pop    %ebp
  803a1e:	c3                   	ret    
  803a1f:	90                   	nop
  803a20:	89 fd                	mov    %edi,%ebp
  803a22:	85 ff                	test   %edi,%edi
  803a24:	75 0b                	jne    803a31 <__umoddi3+0xe9>
  803a26:	b8 01 00 00 00       	mov    $0x1,%eax
  803a2b:	31 d2                	xor    %edx,%edx
  803a2d:	f7 f7                	div    %edi
  803a2f:	89 c5                	mov    %eax,%ebp
  803a31:	89 f0                	mov    %esi,%eax
  803a33:	31 d2                	xor    %edx,%edx
  803a35:	f7 f5                	div    %ebp
  803a37:	89 c8                	mov    %ecx,%eax
  803a39:	f7 f5                	div    %ebp
  803a3b:	89 d0                	mov    %edx,%eax
  803a3d:	e9 44 ff ff ff       	jmp    803986 <__umoddi3+0x3e>
  803a42:	66 90                	xchg   %ax,%ax
  803a44:	89 c8                	mov    %ecx,%eax
  803a46:	89 f2                	mov    %esi,%edx
  803a48:	83 c4 1c             	add    $0x1c,%esp
  803a4b:	5b                   	pop    %ebx
  803a4c:	5e                   	pop    %esi
  803a4d:	5f                   	pop    %edi
  803a4e:	5d                   	pop    %ebp
  803a4f:	c3                   	ret    
  803a50:	3b 04 24             	cmp    (%esp),%eax
  803a53:	72 06                	jb     803a5b <__umoddi3+0x113>
  803a55:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803a59:	77 0f                	ja     803a6a <__umoddi3+0x122>
  803a5b:	89 f2                	mov    %esi,%edx
  803a5d:	29 f9                	sub    %edi,%ecx
  803a5f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803a63:	89 14 24             	mov    %edx,(%esp)
  803a66:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a6a:	8b 44 24 04          	mov    0x4(%esp),%eax
  803a6e:	8b 14 24             	mov    (%esp),%edx
  803a71:	83 c4 1c             	add    $0x1c,%esp
  803a74:	5b                   	pop    %ebx
  803a75:	5e                   	pop    %esi
  803a76:	5f                   	pop    %edi
  803a77:	5d                   	pop    %ebp
  803a78:	c3                   	ret    
  803a79:	8d 76 00             	lea    0x0(%esi),%esi
  803a7c:	2b 04 24             	sub    (%esp),%eax
  803a7f:	19 fa                	sbb    %edi,%edx
  803a81:	89 d1                	mov    %edx,%ecx
  803a83:	89 c6                	mov    %eax,%esi
  803a85:	e9 71 ff ff ff       	jmp    8039fb <__umoddi3+0xb3>
  803a8a:	66 90                	xchg   %ax,%ax
  803a8c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803a90:	72 ea                	jb     803a7c <__umoddi3+0x134>
  803a92:	89 d9                	mov    %ebx,%ecx
  803a94:	e9 62 ff ff ff       	jmp    8039fb <__umoddi3+0xb3>
