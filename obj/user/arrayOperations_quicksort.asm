
obj/user/arrayOperations_quicksort:     file format elf32-i386


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
  800031:	e8 ac 03 00 00       	call   8003e2 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

void QuickSort(int *Elements, int NumOfElements);
void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 38             	sub    $0x38,%esp
	int32 envID = sys_getenvid();
  80003e:	e8 ed 1c 00 00       	call   801d30 <sys_getenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int32 parentenvID = sys_getparentenvid();
  800046:	e8 17 1d 00 00       	call   801d62 <sys_getparentenvid>
  80004b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	int ret;
	/*[1] GET SEMAPHORES*/
	struct semaphore ready = get_semaphore(parentenvID, "Ready");
  80004e:	8d 45 d8             	lea    -0x28(%ebp),%eax
  800051:	83 ec 04             	sub    $0x4,%esp
  800054:	68 80 39 80 00       	push   $0x803980
  800059:	ff 75 ec             	pushl  -0x14(%ebp)
  80005c:	50                   	push   %eax
  80005d:	e8 ad 33 00 00       	call   80340f <get_semaphore>
  800062:	83 c4 0c             	add    $0xc,%esp
	struct semaphore finished = get_semaphore(parentenvID, "Finished");
  800065:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  800068:	83 ec 04             	sub    $0x4,%esp
  80006b:	68 86 39 80 00       	push   $0x803986
  800070:	ff 75 ec             	pushl  -0x14(%ebp)
  800073:	50                   	push   %eax
  800074:	e8 96 33 00 00       	call   80340f <get_semaphore>
  800079:	83 c4 0c             	add    $0xc,%esp

	/*[2] WAIT A READY SIGNAL FROM THE MASTER*/
	wait_semaphore(ready);
  80007c:	83 ec 0c             	sub    $0xc,%esp
  80007f:	ff 75 d8             	pushl  -0x28(%ebp)
  800082:	e8 d1 33 00 00       	call   803458 <wait_semaphore>
  800087:	83 c4 10             	add    $0x10,%esp

	/*[3] GET SHARED VARs*/
	//Get the cons_mutex ownerID
	int* consMutexOwnerID = sget(parentenvID, "cons_mutex ownerID") ;
  80008a:	83 ec 08             	sub    $0x8,%esp
  80008d:	68 8f 39 80 00       	push   $0x80398f
  800092:	ff 75 ec             	pushl  -0x14(%ebp)
  800095:	e8 63 17 00 00       	call   8017fd <sget>
  80009a:	83 c4 10             	add    $0x10,%esp
  80009d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct semaphore cons_mutex = get_semaphore(*consMutexOwnerID, "Console Mutex");
  8000a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000a3:	8b 10                	mov    (%eax),%edx
  8000a5:	8d 45 d0             	lea    -0x30(%ebp),%eax
  8000a8:	83 ec 04             	sub    $0x4,%esp
  8000ab:	68 a2 39 80 00       	push   $0x8039a2
  8000b0:	52                   	push   %edx
  8000b1:	50                   	push   %eax
  8000b2:	e8 58 33 00 00       	call   80340f <get_semaphore>
  8000b7:	83 c4 0c             	add    $0xc,%esp

	//Get the shared array & its size
	int *numOfElements = NULL;
  8000ba:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	int *sharedArray = NULL;
  8000c1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	sharedArray = sget(parentenvID,"arr") ;
  8000c8:	83 ec 08             	sub    $0x8,%esp
  8000cb:	68 b0 39 80 00       	push   $0x8039b0
  8000d0:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d3:	e8 25 17 00 00       	call   8017fd <sget>
  8000d8:	83 c4 10             	add    $0x10,%esp
  8000db:	89 45 e0             	mov    %eax,-0x20(%ebp)
	numOfElements = sget(parentenvID,"arrSize") ;
  8000de:	83 ec 08             	sub    $0x8,%esp
  8000e1:	68 b4 39 80 00       	push   $0x8039b4
  8000e6:	ff 75 ec             	pushl  -0x14(%ebp)
  8000e9:	e8 0f 17 00 00       	call   8017fd <sget>
  8000ee:	83 c4 10             	add    $0x10,%esp
  8000f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	/*[4] DO THE JOB*/
	//take a copy from the original array
	int *sortedArray;
	sortedArray = smalloc("quicksortedArr", sizeof(int) * *numOfElements, 0) ;
  8000f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f7:	8b 00                	mov    (%eax),%eax
  8000f9:	c1 e0 02             	shl    $0x2,%eax
  8000fc:	83 ec 04             	sub    $0x4,%esp
  8000ff:	6a 00                	push   $0x0
  800101:	50                   	push   %eax
  800102:	68 bc 39 80 00       	push   $0x8039bc
  800107:	e8 56 15 00 00       	call   801662 <smalloc>
  80010c:	83 c4 10             	add    $0x10,%esp
  80010f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  800112:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800119:	eb 25                	jmp    800140 <_main+0x108>
	{
		sortedArray[i] = sharedArray[i];
  80011b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80011e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800125:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800128:	01 c2                	add    %eax,%edx
  80012a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80012d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800134:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800137:	01 c8                	add    %ecx,%eax
  800139:	8b 00                	mov    (%eax),%eax
  80013b:	89 02                	mov    %eax,(%edx)
	/*[4] DO THE JOB*/
	//take a copy from the original array
	int *sortedArray;
	sortedArray = smalloc("quicksortedArr", sizeof(int) * *numOfElements, 0) ;
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  80013d:	ff 45 f4             	incl   -0xc(%ebp)
  800140:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800143:	8b 00                	mov    (%eax),%eax
  800145:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800148:	7f d1                	jg     80011b <_main+0xe3>
	{
		sortedArray[i] = sharedArray[i];
	}
	QuickSort(sortedArray, *numOfElements);
  80014a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80014d:	8b 00                	mov    (%eax),%eax
  80014f:	83 ec 08             	sub    $0x8,%esp
  800152:	50                   	push   %eax
  800153:	ff 75 dc             	pushl  -0x24(%ebp)
  800156:	e8 60 00 00 00       	call   8001bb <QuickSort>
  80015b:	83 c4 10             	add    $0x10,%esp

	wait_semaphore(cons_mutex);
  80015e:	83 ec 0c             	sub    $0xc,%esp
  800161:	ff 75 d0             	pushl  -0x30(%ebp)
  800164:	e8 ef 32 00 00       	call   803458 <wait_semaphore>
  800169:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("Quick sort is Finished!!!!\n") ;
  80016c:	83 ec 0c             	sub    $0xc,%esp
  80016f:	68 cb 39 80 00       	push   $0x8039cb
  800174:	e8 82 04 00 00       	call   8005fb <cprintf>
  800179:	83 c4 10             	add    $0x10,%esp
		cprintf("will notify the master now...\n");
  80017c:	83 ec 0c             	sub    $0xc,%esp
  80017f:	68 e8 39 80 00       	push   $0x8039e8
  800184:	e8 72 04 00 00       	call   8005fb <cprintf>
  800189:	83 c4 10             	add    $0x10,%esp
		cprintf("Quick sort says GOOD BYE :)\n") ;
  80018c:	83 ec 0c             	sub    $0xc,%esp
  80018f:	68 07 3a 80 00       	push   $0x803a07
  800194:	e8 62 04 00 00       	call   8005fb <cprintf>
  800199:	83 c4 10             	add    $0x10,%esp
	}
	signal_semaphore(cons_mutex);
  80019c:	83 ec 0c             	sub    $0xc,%esp
  80019f:	ff 75 d0             	pushl  -0x30(%ebp)
  8001a2:	e8 1b 33 00 00       	call   8034c2 <signal_semaphore>
  8001a7:	83 c4 10             	add    $0x10,%esp

	/*[5] DECLARE FINISHING*/
	signal_semaphore(finished);
  8001aa:	83 ec 0c             	sub    $0xc,%esp
  8001ad:	ff 75 d4             	pushl  -0x2c(%ebp)
  8001b0:	e8 0d 33 00 00       	call   8034c2 <signal_semaphore>
  8001b5:	83 c4 10             	add    $0x10,%esp
}
  8001b8:	90                   	nop
  8001b9:	c9                   	leave  
  8001ba:	c3                   	ret    

008001bb <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  8001bb:	55                   	push   %ebp
  8001bc:	89 e5                	mov    %esp,%ebp
  8001be:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  8001c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001c4:	48                   	dec    %eax
  8001c5:	50                   	push   %eax
  8001c6:	6a 00                	push   $0x0
  8001c8:	ff 75 0c             	pushl  0xc(%ebp)
  8001cb:	ff 75 08             	pushl  0x8(%ebp)
  8001ce:	e8 06 00 00 00       	call   8001d9 <QSort>
  8001d3:	83 c4 10             	add    $0x10,%esp
}
  8001d6:	90                   	nop
  8001d7:	c9                   	leave  
  8001d8:	c3                   	ret    

008001d9 <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  8001d9:	55                   	push   %ebp
  8001da:	89 e5                	mov    %esp,%ebp
  8001dc:	83 ec 28             	sub    $0x28,%esp
	if (startIndex >= finalIndex) return;
  8001df:	8b 45 10             	mov    0x10(%ebp),%eax
  8001e2:	3b 45 14             	cmp    0x14(%ebp),%eax
  8001e5:	0f 8d 1b 01 00 00    	jge    800306 <QSort+0x12d>
	int pvtIndex = RAND(startIndex, finalIndex) ;
  8001eb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8001ee:	83 ec 0c             	sub    $0xc,%esp
  8001f1:	50                   	push   %eax
  8001f2:	e8 9e 1b 00 00       	call   801d95 <sys_get_virtual_time>
  8001f7:	83 c4 0c             	add    $0xc,%esp
  8001fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001fd:	8b 55 14             	mov    0x14(%ebp),%edx
  800200:	2b 55 10             	sub    0x10(%ebp),%edx
  800203:	89 d1                	mov    %edx,%ecx
  800205:	ba 00 00 00 00       	mov    $0x0,%edx
  80020a:	f7 f1                	div    %ecx
  80020c:	8b 45 10             	mov    0x10(%ebp),%eax
  80020f:	01 d0                	add    %edx,%eax
  800211:	89 45 ec             	mov    %eax,-0x14(%ebp)
	Swap(Elements, startIndex, pvtIndex);
  800214:	83 ec 04             	sub    $0x4,%esp
  800217:	ff 75 ec             	pushl  -0x14(%ebp)
  80021a:	ff 75 10             	pushl  0x10(%ebp)
  80021d:	ff 75 08             	pushl  0x8(%ebp)
  800220:	e8 e4 00 00 00       	call   800309 <Swap>
  800225:	83 c4 10             	add    $0x10,%esp

	int i = startIndex+1, j = finalIndex;
  800228:	8b 45 10             	mov    0x10(%ebp),%eax
  80022b:	40                   	inc    %eax
  80022c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80022f:	8b 45 14             	mov    0x14(%ebp),%eax
  800232:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  800235:	e9 80 00 00 00       	jmp    8002ba <QSort+0xe1>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  80023a:	ff 45 f4             	incl   -0xc(%ebp)
  80023d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800240:	3b 45 14             	cmp    0x14(%ebp),%eax
  800243:	7f 2b                	jg     800270 <QSort+0x97>
  800245:	8b 45 10             	mov    0x10(%ebp),%eax
  800248:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80024f:	8b 45 08             	mov    0x8(%ebp),%eax
  800252:	01 d0                	add    %edx,%eax
  800254:	8b 10                	mov    (%eax),%edx
  800256:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800259:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800260:	8b 45 08             	mov    0x8(%ebp),%eax
  800263:	01 c8                	add    %ecx,%eax
  800265:	8b 00                	mov    (%eax),%eax
  800267:	39 c2                	cmp    %eax,%edx
  800269:	7d cf                	jge    80023a <QSort+0x61>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  80026b:	eb 03                	jmp    800270 <QSort+0x97>
  80026d:	ff 4d f0             	decl   -0x10(%ebp)
  800270:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800273:	3b 45 10             	cmp    0x10(%ebp),%eax
  800276:	7e 26                	jle    80029e <QSort+0xc5>
  800278:	8b 45 10             	mov    0x10(%ebp),%eax
  80027b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800282:	8b 45 08             	mov    0x8(%ebp),%eax
  800285:	01 d0                	add    %edx,%eax
  800287:	8b 10                	mov    (%eax),%edx
  800289:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80028c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800293:	8b 45 08             	mov    0x8(%ebp),%eax
  800296:	01 c8                	add    %ecx,%eax
  800298:	8b 00                	mov    (%eax),%eax
  80029a:	39 c2                	cmp    %eax,%edx
  80029c:	7e cf                	jle    80026d <QSort+0x94>

		if (i <= j)
  80029e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002a1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8002a4:	7f 14                	jg     8002ba <QSort+0xe1>
		{
			Swap(Elements, i, j);
  8002a6:	83 ec 04             	sub    $0x4,%esp
  8002a9:	ff 75 f0             	pushl  -0x10(%ebp)
  8002ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8002af:	ff 75 08             	pushl  0x8(%ebp)
  8002b2:	e8 52 00 00 00       	call   800309 <Swap>
  8002b7:	83 c4 10             	add    $0x10,%esp
	int pvtIndex = RAND(startIndex, finalIndex) ;
	Swap(Elements, startIndex, pvtIndex);

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  8002ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002bd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8002c0:	0f 8e 77 ff ff ff    	jle    80023d <QSort+0x64>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  8002c6:	83 ec 04             	sub    $0x4,%esp
  8002c9:	ff 75 f0             	pushl  -0x10(%ebp)
  8002cc:	ff 75 10             	pushl  0x10(%ebp)
  8002cf:	ff 75 08             	pushl  0x8(%ebp)
  8002d2:	e8 32 00 00 00       	call   800309 <Swap>
  8002d7:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  8002da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002dd:	48                   	dec    %eax
  8002de:	50                   	push   %eax
  8002df:	ff 75 10             	pushl  0x10(%ebp)
  8002e2:	ff 75 0c             	pushl  0xc(%ebp)
  8002e5:	ff 75 08             	pushl  0x8(%ebp)
  8002e8:	e8 ec fe ff ff       	call   8001d9 <QSort>
  8002ed:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  8002f0:	ff 75 14             	pushl  0x14(%ebp)
  8002f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8002f6:	ff 75 0c             	pushl  0xc(%ebp)
  8002f9:	ff 75 08             	pushl  0x8(%ebp)
  8002fc:	e8 d8 fe ff ff       	call   8001d9 <QSort>
  800301:	83 c4 10             	add    $0x10,%esp
  800304:	eb 01                	jmp    800307 <QSort+0x12e>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  800306:	90                   	nop
	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);

	//cprintf("qs,after sorting: start = %d, end = %d\n", startIndex, finalIndex);

}
  800307:	c9                   	leave  
  800308:	c3                   	ret    

00800309 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  800309:	55                   	push   %ebp
  80030a:	89 e5                	mov    %esp,%ebp
  80030c:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  80030f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800312:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800319:	8b 45 08             	mov    0x8(%ebp),%eax
  80031c:	01 d0                	add    %edx,%eax
  80031e:	8b 00                	mov    (%eax),%eax
  800320:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800323:	8b 45 0c             	mov    0xc(%ebp),%eax
  800326:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80032d:	8b 45 08             	mov    0x8(%ebp),%eax
  800330:	01 c2                	add    %eax,%edx
  800332:	8b 45 10             	mov    0x10(%ebp),%eax
  800335:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80033c:	8b 45 08             	mov    0x8(%ebp),%eax
  80033f:	01 c8                	add    %ecx,%eax
  800341:	8b 00                	mov    (%eax),%eax
  800343:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800345:	8b 45 10             	mov    0x10(%ebp),%eax
  800348:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80034f:	8b 45 08             	mov    0x8(%ebp),%eax
  800352:	01 c2                	add    %eax,%edx
  800354:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800357:	89 02                	mov    %eax,(%edx)
}
  800359:	90                   	nop
  80035a:	c9                   	leave  
  80035b:	c3                   	ret    

0080035c <PrintElements>:


void PrintElements(int *Elements, int NumOfElements)
{
  80035c:	55                   	push   %ebp
  80035d:	89 e5                	mov    %esp,%ebp
  80035f:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800362:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800369:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800370:	eb 42                	jmp    8003b4 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800372:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800375:	99                   	cltd   
  800376:	f7 7d f0             	idivl  -0x10(%ebp)
  800379:	89 d0                	mov    %edx,%eax
  80037b:	85 c0                	test   %eax,%eax
  80037d:	75 10                	jne    80038f <PrintElements+0x33>
			cprintf("\n");
  80037f:	83 ec 0c             	sub    $0xc,%esp
  800382:	68 24 3a 80 00       	push   $0x803a24
  800387:	e8 6f 02 00 00       	call   8005fb <cprintf>
  80038c:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  80038f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800392:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800399:	8b 45 08             	mov    0x8(%ebp),%eax
  80039c:	01 d0                	add    %edx,%eax
  80039e:	8b 00                	mov    (%eax),%eax
  8003a0:	83 ec 08             	sub    $0x8,%esp
  8003a3:	50                   	push   %eax
  8003a4:	68 26 3a 80 00       	push   $0x803a26
  8003a9:	e8 4d 02 00 00       	call   8005fb <cprintf>
  8003ae:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  8003b1:	ff 45 f4             	incl   -0xc(%ebp)
  8003b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b7:	48                   	dec    %eax
  8003b8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8003bb:	7f b5                	jg     800372 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  8003bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003c0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ca:	01 d0                	add    %edx,%eax
  8003cc:	8b 00                	mov    (%eax),%eax
  8003ce:	83 ec 08             	sub    $0x8,%esp
  8003d1:	50                   	push   %eax
  8003d2:	68 2b 3a 80 00       	push   $0x803a2b
  8003d7:	e8 1f 02 00 00       	call   8005fb <cprintf>
  8003dc:	83 c4 10             	add    $0x10,%esp

}
  8003df:	90                   	nop
  8003e0:	c9                   	leave  
  8003e1:	c3                   	ret    

008003e2 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8003e2:	55                   	push   %ebp
  8003e3:	89 e5                	mov    %esp,%ebp
  8003e5:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8003e8:	e8 5c 19 00 00       	call   801d49 <sys_getenvindex>
  8003ed:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8003f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003f3:	89 d0                	mov    %edx,%eax
  8003f5:	c1 e0 02             	shl    $0x2,%eax
  8003f8:	01 d0                	add    %edx,%eax
  8003fa:	c1 e0 03             	shl    $0x3,%eax
  8003fd:	01 d0                	add    %edx,%eax
  8003ff:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800406:	01 d0                	add    %edx,%eax
  800408:	c1 e0 02             	shl    $0x2,%eax
  80040b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800410:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800415:	a1 20 50 80 00       	mov    0x805020,%eax
  80041a:	8a 40 20             	mov    0x20(%eax),%al
  80041d:	84 c0                	test   %al,%al
  80041f:	74 0d                	je     80042e <libmain+0x4c>
		binaryname = myEnv->prog_name;
  800421:	a1 20 50 80 00       	mov    0x805020,%eax
  800426:	83 c0 20             	add    $0x20,%eax
  800429:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80042e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800432:	7e 0a                	jle    80043e <libmain+0x5c>
		binaryname = argv[0];
  800434:	8b 45 0c             	mov    0xc(%ebp),%eax
  800437:	8b 00                	mov    (%eax),%eax
  800439:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  80043e:	83 ec 08             	sub    $0x8,%esp
  800441:	ff 75 0c             	pushl  0xc(%ebp)
  800444:	ff 75 08             	pushl  0x8(%ebp)
  800447:	e8 ec fb ff ff       	call   800038 <_main>
  80044c:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80044f:	a1 00 50 80 00       	mov    0x805000,%eax
  800454:	85 c0                	test   %eax,%eax
  800456:	0f 84 9f 00 00 00    	je     8004fb <libmain+0x119>
	{
		sys_lock_cons();
  80045c:	e8 6c 16 00 00       	call   801acd <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800461:	83 ec 0c             	sub    $0xc,%esp
  800464:	68 48 3a 80 00       	push   $0x803a48
  800469:	e8 8d 01 00 00       	call   8005fb <cprintf>
  80046e:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800471:	a1 20 50 80 00       	mov    0x805020,%eax
  800476:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  80047c:	a1 20 50 80 00       	mov    0x805020,%eax
  800481:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800487:	83 ec 04             	sub    $0x4,%esp
  80048a:	52                   	push   %edx
  80048b:	50                   	push   %eax
  80048c:	68 70 3a 80 00       	push   $0x803a70
  800491:	e8 65 01 00 00       	call   8005fb <cprintf>
  800496:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800499:	a1 20 50 80 00       	mov    0x805020,%eax
  80049e:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8004a4:	a1 20 50 80 00       	mov    0x805020,%eax
  8004a9:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8004af:	a1 20 50 80 00       	mov    0x805020,%eax
  8004b4:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  8004ba:	51                   	push   %ecx
  8004bb:	52                   	push   %edx
  8004bc:	50                   	push   %eax
  8004bd:	68 98 3a 80 00       	push   $0x803a98
  8004c2:	e8 34 01 00 00       	call   8005fb <cprintf>
  8004c7:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8004ca:	a1 20 50 80 00       	mov    0x805020,%eax
  8004cf:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8004d5:	83 ec 08             	sub    $0x8,%esp
  8004d8:	50                   	push   %eax
  8004d9:	68 f0 3a 80 00       	push   $0x803af0
  8004de:	e8 18 01 00 00       	call   8005fb <cprintf>
  8004e3:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8004e6:	83 ec 0c             	sub    $0xc,%esp
  8004e9:	68 48 3a 80 00       	push   $0x803a48
  8004ee:	e8 08 01 00 00       	call   8005fb <cprintf>
  8004f3:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8004f6:	e8 ec 15 00 00       	call   801ae7 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8004fb:	e8 19 00 00 00       	call   800519 <exit>
}
  800500:	90                   	nop
  800501:	c9                   	leave  
  800502:	c3                   	ret    

00800503 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800503:	55                   	push   %ebp
  800504:	89 e5                	mov    %esp,%ebp
  800506:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800509:	83 ec 0c             	sub    $0xc,%esp
  80050c:	6a 00                	push   $0x0
  80050e:	e8 02 18 00 00       	call   801d15 <sys_destroy_env>
  800513:	83 c4 10             	add    $0x10,%esp
}
  800516:	90                   	nop
  800517:	c9                   	leave  
  800518:	c3                   	ret    

00800519 <exit>:

void
exit(void)
{
  800519:	55                   	push   %ebp
  80051a:	89 e5                	mov    %esp,%ebp
  80051c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80051f:	e8 57 18 00 00       	call   801d7b <sys_exit_env>
}
  800524:	90                   	nop
  800525:	c9                   	leave  
  800526:	c3                   	ret    

00800527 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800527:	55                   	push   %ebp
  800528:	89 e5                	mov    %esp,%ebp
  80052a:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80052d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800530:	8b 00                	mov    (%eax),%eax
  800532:	8d 48 01             	lea    0x1(%eax),%ecx
  800535:	8b 55 0c             	mov    0xc(%ebp),%edx
  800538:	89 0a                	mov    %ecx,(%edx)
  80053a:	8b 55 08             	mov    0x8(%ebp),%edx
  80053d:	88 d1                	mov    %dl,%cl
  80053f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800542:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800546:	8b 45 0c             	mov    0xc(%ebp),%eax
  800549:	8b 00                	mov    (%eax),%eax
  80054b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800550:	75 2c                	jne    80057e <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800552:	a0 44 50 98 00       	mov    0x985044,%al
  800557:	0f b6 c0             	movzbl %al,%eax
  80055a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80055d:	8b 12                	mov    (%edx),%edx
  80055f:	89 d1                	mov    %edx,%ecx
  800561:	8b 55 0c             	mov    0xc(%ebp),%edx
  800564:	83 c2 08             	add    $0x8,%edx
  800567:	83 ec 04             	sub    $0x4,%esp
  80056a:	50                   	push   %eax
  80056b:	51                   	push   %ecx
  80056c:	52                   	push   %edx
  80056d:	e8 19 15 00 00       	call   801a8b <sys_cputs>
  800572:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800575:	8b 45 0c             	mov    0xc(%ebp),%eax
  800578:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80057e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800581:	8b 40 04             	mov    0x4(%eax),%eax
  800584:	8d 50 01             	lea    0x1(%eax),%edx
  800587:	8b 45 0c             	mov    0xc(%ebp),%eax
  80058a:	89 50 04             	mov    %edx,0x4(%eax)
}
  80058d:	90                   	nop
  80058e:	c9                   	leave  
  80058f:	c3                   	ret    

00800590 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800590:	55                   	push   %ebp
  800591:	89 e5                	mov    %esp,%ebp
  800593:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800599:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005a0:	00 00 00 
	b.cnt = 0;
  8005a3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005aa:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8005ad:	ff 75 0c             	pushl  0xc(%ebp)
  8005b0:	ff 75 08             	pushl  0x8(%ebp)
  8005b3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005b9:	50                   	push   %eax
  8005ba:	68 27 05 80 00       	push   $0x800527
  8005bf:	e8 11 02 00 00       	call   8007d5 <vprintfmt>
  8005c4:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8005c7:	a0 44 50 98 00       	mov    0x985044,%al
  8005cc:	0f b6 c0             	movzbl %al,%eax
  8005cf:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8005d5:	83 ec 04             	sub    $0x4,%esp
  8005d8:	50                   	push   %eax
  8005d9:	52                   	push   %edx
  8005da:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005e0:	83 c0 08             	add    $0x8,%eax
  8005e3:	50                   	push   %eax
  8005e4:	e8 a2 14 00 00       	call   801a8b <sys_cputs>
  8005e9:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005ec:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
	return b.cnt;
  8005f3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005f9:	c9                   	leave  
  8005fa:	c3                   	ret    

008005fb <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8005fb:	55                   	push   %ebp
  8005fc:	89 e5                	mov    %esp,%ebp
  8005fe:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800601:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
	va_start(ap, fmt);
  800608:	8d 45 0c             	lea    0xc(%ebp),%eax
  80060b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80060e:	8b 45 08             	mov    0x8(%ebp),%eax
  800611:	83 ec 08             	sub    $0x8,%esp
  800614:	ff 75 f4             	pushl  -0xc(%ebp)
  800617:	50                   	push   %eax
  800618:	e8 73 ff ff ff       	call   800590 <vcprintf>
  80061d:	83 c4 10             	add    $0x10,%esp
  800620:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800623:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800626:	c9                   	leave  
  800627:	c3                   	ret    

00800628 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800628:	55                   	push   %ebp
  800629:	89 e5                	mov    %esp,%ebp
  80062b:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80062e:	e8 9a 14 00 00       	call   801acd <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800633:	8d 45 0c             	lea    0xc(%ebp),%eax
  800636:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800639:	8b 45 08             	mov    0x8(%ebp),%eax
  80063c:	83 ec 08             	sub    $0x8,%esp
  80063f:	ff 75 f4             	pushl  -0xc(%ebp)
  800642:	50                   	push   %eax
  800643:	e8 48 ff ff ff       	call   800590 <vcprintf>
  800648:	83 c4 10             	add    $0x10,%esp
  80064b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80064e:	e8 94 14 00 00       	call   801ae7 <sys_unlock_cons>
	return cnt;
  800653:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800656:	c9                   	leave  
  800657:	c3                   	ret    

00800658 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800658:	55                   	push   %ebp
  800659:	89 e5                	mov    %esp,%ebp
  80065b:	53                   	push   %ebx
  80065c:	83 ec 14             	sub    $0x14,%esp
  80065f:	8b 45 10             	mov    0x10(%ebp),%eax
  800662:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800665:	8b 45 14             	mov    0x14(%ebp),%eax
  800668:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80066b:	8b 45 18             	mov    0x18(%ebp),%eax
  80066e:	ba 00 00 00 00       	mov    $0x0,%edx
  800673:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800676:	77 55                	ja     8006cd <printnum+0x75>
  800678:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80067b:	72 05                	jb     800682 <printnum+0x2a>
  80067d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800680:	77 4b                	ja     8006cd <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800682:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800685:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800688:	8b 45 18             	mov    0x18(%ebp),%eax
  80068b:	ba 00 00 00 00       	mov    $0x0,%edx
  800690:	52                   	push   %edx
  800691:	50                   	push   %eax
  800692:	ff 75 f4             	pushl  -0xc(%ebp)
  800695:	ff 75 f0             	pushl  -0x10(%ebp)
  800698:	e8 7b 30 00 00       	call   803718 <__udivdi3>
  80069d:	83 c4 10             	add    $0x10,%esp
  8006a0:	83 ec 04             	sub    $0x4,%esp
  8006a3:	ff 75 20             	pushl  0x20(%ebp)
  8006a6:	53                   	push   %ebx
  8006a7:	ff 75 18             	pushl  0x18(%ebp)
  8006aa:	52                   	push   %edx
  8006ab:	50                   	push   %eax
  8006ac:	ff 75 0c             	pushl  0xc(%ebp)
  8006af:	ff 75 08             	pushl  0x8(%ebp)
  8006b2:	e8 a1 ff ff ff       	call   800658 <printnum>
  8006b7:	83 c4 20             	add    $0x20,%esp
  8006ba:	eb 1a                	jmp    8006d6 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006bc:	83 ec 08             	sub    $0x8,%esp
  8006bf:	ff 75 0c             	pushl  0xc(%ebp)
  8006c2:	ff 75 20             	pushl  0x20(%ebp)
  8006c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c8:	ff d0                	call   *%eax
  8006ca:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006cd:	ff 4d 1c             	decl   0x1c(%ebp)
  8006d0:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006d4:	7f e6                	jg     8006bc <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006d6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006d9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006e4:	53                   	push   %ebx
  8006e5:	51                   	push   %ecx
  8006e6:	52                   	push   %edx
  8006e7:	50                   	push   %eax
  8006e8:	e8 3b 31 00 00       	call   803828 <__umoddi3>
  8006ed:	83 c4 10             	add    $0x10,%esp
  8006f0:	05 34 3d 80 00       	add    $0x803d34,%eax
  8006f5:	8a 00                	mov    (%eax),%al
  8006f7:	0f be c0             	movsbl %al,%eax
  8006fa:	83 ec 08             	sub    $0x8,%esp
  8006fd:	ff 75 0c             	pushl  0xc(%ebp)
  800700:	50                   	push   %eax
  800701:	8b 45 08             	mov    0x8(%ebp),%eax
  800704:	ff d0                	call   *%eax
  800706:	83 c4 10             	add    $0x10,%esp
}
  800709:	90                   	nop
  80070a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80070d:	c9                   	leave  
  80070e:	c3                   	ret    

0080070f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80070f:	55                   	push   %ebp
  800710:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800712:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800716:	7e 1c                	jle    800734 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800718:	8b 45 08             	mov    0x8(%ebp),%eax
  80071b:	8b 00                	mov    (%eax),%eax
  80071d:	8d 50 08             	lea    0x8(%eax),%edx
  800720:	8b 45 08             	mov    0x8(%ebp),%eax
  800723:	89 10                	mov    %edx,(%eax)
  800725:	8b 45 08             	mov    0x8(%ebp),%eax
  800728:	8b 00                	mov    (%eax),%eax
  80072a:	83 e8 08             	sub    $0x8,%eax
  80072d:	8b 50 04             	mov    0x4(%eax),%edx
  800730:	8b 00                	mov    (%eax),%eax
  800732:	eb 40                	jmp    800774 <getuint+0x65>
	else if (lflag)
  800734:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800738:	74 1e                	je     800758 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80073a:	8b 45 08             	mov    0x8(%ebp),%eax
  80073d:	8b 00                	mov    (%eax),%eax
  80073f:	8d 50 04             	lea    0x4(%eax),%edx
  800742:	8b 45 08             	mov    0x8(%ebp),%eax
  800745:	89 10                	mov    %edx,(%eax)
  800747:	8b 45 08             	mov    0x8(%ebp),%eax
  80074a:	8b 00                	mov    (%eax),%eax
  80074c:	83 e8 04             	sub    $0x4,%eax
  80074f:	8b 00                	mov    (%eax),%eax
  800751:	ba 00 00 00 00       	mov    $0x0,%edx
  800756:	eb 1c                	jmp    800774 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800758:	8b 45 08             	mov    0x8(%ebp),%eax
  80075b:	8b 00                	mov    (%eax),%eax
  80075d:	8d 50 04             	lea    0x4(%eax),%edx
  800760:	8b 45 08             	mov    0x8(%ebp),%eax
  800763:	89 10                	mov    %edx,(%eax)
  800765:	8b 45 08             	mov    0x8(%ebp),%eax
  800768:	8b 00                	mov    (%eax),%eax
  80076a:	83 e8 04             	sub    $0x4,%eax
  80076d:	8b 00                	mov    (%eax),%eax
  80076f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800774:	5d                   	pop    %ebp
  800775:	c3                   	ret    

00800776 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800776:	55                   	push   %ebp
  800777:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800779:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80077d:	7e 1c                	jle    80079b <getint+0x25>
		return va_arg(*ap, long long);
  80077f:	8b 45 08             	mov    0x8(%ebp),%eax
  800782:	8b 00                	mov    (%eax),%eax
  800784:	8d 50 08             	lea    0x8(%eax),%edx
  800787:	8b 45 08             	mov    0x8(%ebp),%eax
  80078a:	89 10                	mov    %edx,(%eax)
  80078c:	8b 45 08             	mov    0x8(%ebp),%eax
  80078f:	8b 00                	mov    (%eax),%eax
  800791:	83 e8 08             	sub    $0x8,%eax
  800794:	8b 50 04             	mov    0x4(%eax),%edx
  800797:	8b 00                	mov    (%eax),%eax
  800799:	eb 38                	jmp    8007d3 <getint+0x5d>
	else if (lflag)
  80079b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80079f:	74 1a                	je     8007bb <getint+0x45>
		return va_arg(*ap, long);
  8007a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a4:	8b 00                	mov    (%eax),%eax
  8007a6:	8d 50 04             	lea    0x4(%eax),%edx
  8007a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ac:	89 10                	mov    %edx,(%eax)
  8007ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b1:	8b 00                	mov    (%eax),%eax
  8007b3:	83 e8 04             	sub    $0x4,%eax
  8007b6:	8b 00                	mov    (%eax),%eax
  8007b8:	99                   	cltd   
  8007b9:	eb 18                	jmp    8007d3 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007be:	8b 00                	mov    (%eax),%eax
  8007c0:	8d 50 04             	lea    0x4(%eax),%edx
  8007c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c6:	89 10                	mov    %edx,(%eax)
  8007c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cb:	8b 00                	mov    (%eax),%eax
  8007cd:	83 e8 04             	sub    $0x4,%eax
  8007d0:	8b 00                	mov    (%eax),%eax
  8007d2:	99                   	cltd   
}
  8007d3:	5d                   	pop    %ebp
  8007d4:	c3                   	ret    

008007d5 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007d5:	55                   	push   %ebp
  8007d6:	89 e5                	mov    %esp,%ebp
  8007d8:	56                   	push   %esi
  8007d9:	53                   	push   %ebx
  8007da:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007dd:	eb 17                	jmp    8007f6 <vprintfmt+0x21>
			if (ch == '\0')
  8007df:	85 db                	test   %ebx,%ebx
  8007e1:	0f 84 c1 03 00 00    	je     800ba8 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8007e7:	83 ec 08             	sub    $0x8,%esp
  8007ea:	ff 75 0c             	pushl  0xc(%ebp)
  8007ed:	53                   	push   %ebx
  8007ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f1:	ff d0                	call   *%eax
  8007f3:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8007f9:	8d 50 01             	lea    0x1(%eax),%edx
  8007fc:	89 55 10             	mov    %edx,0x10(%ebp)
  8007ff:	8a 00                	mov    (%eax),%al
  800801:	0f b6 d8             	movzbl %al,%ebx
  800804:	83 fb 25             	cmp    $0x25,%ebx
  800807:	75 d6                	jne    8007df <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800809:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80080d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800814:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80081b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800822:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800829:	8b 45 10             	mov    0x10(%ebp),%eax
  80082c:	8d 50 01             	lea    0x1(%eax),%edx
  80082f:	89 55 10             	mov    %edx,0x10(%ebp)
  800832:	8a 00                	mov    (%eax),%al
  800834:	0f b6 d8             	movzbl %al,%ebx
  800837:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80083a:	83 f8 5b             	cmp    $0x5b,%eax
  80083d:	0f 87 3d 03 00 00    	ja     800b80 <vprintfmt+0x3ab>
  800843:	8b 04 85 58 3d 80 00 	mov    0x803d58(,%eax,4),%eax
  80084a:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80084c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800850:	eb d7                	jmp    800829 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800852:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800856:	eb d1                	jmp    800829 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800858:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80085f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800862:	89 d0                	mov    %edx,%eax
  800864:	c1 e0 02             	shl    $0x2,%eax
  800867:	01 d0                	add    %edx,%eax
  800869:	01 c0                	add    %eax,%eax
  80086b:	01 d8                	add    %ebx,%eax
  80086d:	83 e8 30             	sub    $0x30,%eax
  800870:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800873:	8b 45 10             	mov    0x10(%ebp),%eax
  800876:	8a 00                	mov    (%eax),%al
  800878:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80087b:	83 fb 2f             	cmp    $0x2f,%ebx
  80087e:	7e 3e                	jle    8008be <vprintfmt+0xe9>
  800880:	83 fb 39             	cmp    $0x39,%ebx
  800883:	7f 39                	jg     8008be <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800885:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800888:	eb d5                	jmp    80085f <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80088a:	8b 45 14             	mov    0x14(%ebp),%eax
  80088d:	83 c0 04             	add    $0x4,%eax
  800890:	89 45 14             	mov    %eax,0x14(%ebp)
  800893:	8b 45 14             	mov    0x14(%ebp),%eax
  800896:	83 e8 04             	sub    $0x4,%eax
  800899:	8b 00                	mov    (%eax),%eax
  80089b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80089e:	eb 1f                	jmp    8008bf <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008a0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008a4:	79 83                	jns    800829 <vprintfmt+0x54>
				width = 0;
  8008a6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008ad:	e9 77 ff ff ff       	jmp    800829 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008b2:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008b9:	e9 6b ff ff ff       	jmp    800829 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008be:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008bf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008c3:	0f 89 60 ff ff ff    	jns    800829 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008cf:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008d6:	e9 4e ff ff ff       	jmp    800829 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008db:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008de:	e9 46 ff ff ff       	jmp    800829 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e6:	83 c0 04             	add    $0x4,%eax
  8008e9:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ef:	83 e8 04             	sub    $0x4,%eax
  8008f2:	8b 00                	mov    (%eax),%eax
  8008f4:	83 ec 08             	sub    $0x8,%esp
  8008f7:	ff 75 0c             	pushl  0xc(%ebp)
  8008fa:	50                   	push   %eax
  8008fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fe:	ff d0                	call   *%eax
  800900:	83 c4 10             	add    $0x10,%esp
			break;
  800903:	e9 9b 02 00 00       	jmp    800ba3 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800908:	8b 45 14             	mov    0x14(%ebp),%eax
  80090b:	83 c0 04             	add    $0x4,%eax
  80090e:	89 45 14             	mov    %eax,0x14(%ebp)
  800911:	8b 45 14             	mov    0x14(%ebp),%eax
  800914:	83 e8 04             	sub    $0x4,%eax
  800917:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800919:	85 db                	test   %ebx,%ebx
  80091b:	79 02                	jns    80091f <vprintfmt+0x14a>
				err = -err;
  80091d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80091f:	83 fb 64             	cmp    $0x64,%ebx
  800922:	7f 0b                	jg     80092f <vprintfmt+0x15a>
  800924:	8b 34 9d a0 3b 80 00 	mov    0x803ba0(,%ebx,4),%esi
  80092b:	85 f6                	test   %esi,%esi
  80092d:	75 19                	jne    800948 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80092f:	53                   	push   %ebx
  800930:	68 45 3d 80 00       	push   $0x803d45
  800935:	ff 75 0c             	pushl  0xc(%ebp)
  800938:	ff 75 08             	pushl  0x8(%ebp)
  80093b:	e8 70 02 00 00       	call   800bb0 <printfmt>
  800940:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800943:	e9 5b 02 00 00       	jmp    800ba3 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800948:	56                   	push   %esi
  800949:	68 4e 3d 80 00       	push   $0x803d4e
  80094e:	ff 75 0c             	pushl  0xc(%ebp)
  800951:	ff 75 08             	pushl  0x8(%ebp)
  800954:	e8 57 02 00 00       	call   800bb0 <printfmt>
  800959:	83 c4 10             	add    $0x10,%esp
			break;
  80095c:	e9 42 02 00 00       	jmp    800ba3 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800961:	8b 45 14             	mov    0x14(%ebp),%eax
  800964:	83 c0 04             	add    $0x4,%eax
  800967:	89 45 14             	mov    %eax,0x14(%ebp)
  80096a:	8b 45 14             	mov    0x14(%ebp),%eax
  80096d:	83 e8 04             	sub    $0x4,%eax
  800970:	8b 30                	mov    (%eax),%esi
  800972:	85 f6                	test   %esi,%esi
  800974:	75 05                	jne    80097b <vprintfmt+0x1a6>
				p = "(null)";
  800976:	be 51 3d 80 00       	mov    $0x803d51,%esi
			if (width > 0 && padc != '-')
  80097b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80097f:	7e 6d                	jle    8009ee <vprintfmt+0x219>
  800981:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800985:	74 67                	je     8009ee <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800987:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80098a:	83 ec 08             	sub    $0x8,%esp
  80098d:	50                   	push   %eax
  80098e:	56                   	push   %esi
  80098f:	e8 1e 03 00 00       	call   800cb2 <strnlen>
  800994:	83 c4 10             	add    $0x10,%esp
  800997:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80099a:	eb 16                	jmp    8009b2 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80099c:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009a0:	83 ec 08             	sub    $0x8,%esp
  8009a3:	ff 75 0c             	pushl  0xc(%ebp)
  8009a6:	50                   	push   %eax
  8009a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009aa:	ff d0                	call   *%eax
  8009ac:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009af:	ff 4d e4             	decl   -0x1c(%ebp)
  8009b2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009b6:	7f e4                	jg     80099c <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009b8:	eb 34                	jmp    8009ee <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009ba:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009be:	74 1c                	je     8009dc <vprintfmt+0x207>
  8009c0:	83 fb 1f             	cmp    $0x1f,%ebx
  8009c3:	7e 05                	jle    8009ca <vprintfmt+0x1f5>
  8009c5:	83 fb 7e             	cmp    $0x7e,%ebx
  8009c8:	7e 12                	jle    8009dc <vprintfmt+0x207>
					putch('?', putdat);
  8009ca:	83 ec 08             	sub    $0x8,%esp
  8009cd:	ff 75 0c             	pushl  0xc(%ebp)
  8009d0:	6a 3f                	push   $0x3f
  8009d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d5:	ff d0                	call   *%eax
  8009d7:	83 c4 10             	add    $0x10,%esp
  8009da:	eb 0f                	jmp    8009eb <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009dc:	83 ec 08             	sub    $0x8,%esp
  8009df:	ff 75 0c             	pushl  0xc(%ebp)
  8009e2:	53                   	push   %ebx
  8009e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e6:	ff d0                	call   *%eax
  8009e8:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009eb:	ff 4d e4             	decl   -0x1c(%ebp)
  8009ee:	89 f0                	mov    %esi,%eax
  8009f0:	8d 70 01             	lea    0x1(%eax),%esi
  8009f3:	8a 00                	mov    (%eax),%al
  8009f5:	0f be d8             	movsbl %al,%ebx
  8009f8:	85 db                	test   %ebx,%ebx
  8009fa:	74 24                	je     800a20 <vprintfmt+0x24b>
  8009fc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a00:	78 b8                	js     8009ba <vprintfmt+0x1e5>
  800a02:	ff 4d e0             	decl   -0x20(%ebp)
  800a05:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a09:	79 af                	jns    8009ba <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a0b:	eb 13                	jmp    800a20 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a0d:	83 ec 08             	sub    $0x8,%esp
  800a10:	ff 75 0c             	pushl  0xc(%ebp)
  800a13:	6a 20                	push   $0x20
  800a15:	8b 45 08             	mov    0x8(%ebp),%eax
  800a18:	ff d0                	call   *%eax
  800a1a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a1d:	ff 4d e4             	decl   -0x1c(%ebp)
  800a20:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a24:	7f e7                	jg     800a0d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a26:	e9 78 01 00 00       	jmp    800ba3 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a2b:	83 ec 08             	sub    $0x8,%esp
  800a2e:	ff 75 e8             	pushl  -0x18(%ebp)
  800a31:	8d 45 14             	lea    0x14(%ebp),%eax
  800a34:	50                   	push   %eax
  800a35:	e8 3c fd ff ff       	call   800776 <getint>
  800a3a:	83 c4 10             	add    $0x10,%esp
  800a3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a40:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a46:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a49:	85 d2                	test   %edx,%edx
  800a4b:	79 23                	jns    800a70 <vprintfmt+0x29b>
				putch('-', putdat);
  800a4d:	83 ec 08             	sub    $0x8,%esp
  800a50:	ff 75 0c             	pushl  0xc(%ebp)
  800a53:	6a 2d                	push   $0x2d
  800a55:	8b 45 08             	mov    0x8(%ebp),%eax
  800a58:	ff d0                	call   *%eax
  800a5a:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a63:	f7 d8                	neg    %eax
  800a65:	83 d2 00             	adc    $0x0,%edx
  800a68:	f7 da                	neg    %edx
  800a6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a6d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a70:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a77:	e9 bc 00 00 00       	jmp    800b38 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a7c:	83 ec 08             	sub    $0x8,%esp
  800a7f:	ff 75 e8             	pushl  -0x18(%ebp)
  800a82:	8d 45 14             	lea    0x14(%ebp),%eax
  800a85:	50                   	push   %eax
  800a86:	e8 84 fc ff ff       	call   80070f <getuint>
  800a8b:	83 c4 10             	add    $0x10,%esp
  800a8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a91:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a94:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a9b:	e9 98 00 00 00       	jmp    800b38 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800aa0:	83 ec 08             	sub    $0x8,%esp
  800aa3:	ff 75 0c             	pushl  0xc(%ebp)
  800aa6:	6a 58                	push   $0x58
  800aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aab:	ff d0                	call   *%eax
  800aad:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ab0:	83 ec 08             	sub    $0x8,%esp
  800ab3:	ff 75 0c             	pushl  0xc(%ebp)
  800ab6:	6a 58                	push   $0x58
  800ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  800abb:	ff d0                	call   *%eax
  800abd:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ac0:	83 ec 08             	sub    $0x8,%esp
  800ac3:	ff 75 0c             	pushl  0xc(%ebp)
  800ac6:	6a 58                	push   $0x58
  800ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  800acb:	ff d0                	call   *%eax
  800acd:	83 c4 10             	add    $0x10,%esp
			break;
  800ad0:	e9 ce 00 00 00       	jmp    800ba3 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800ad5:	83 ec 08             	sub    $0x8,%esp
  800ad8:	ff 75 0c             	pushl  0xc(%ebp)
  800adb:	6a 30                	push   $0x30
  800add:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae0:	ff d0                	call   *%eax
  800ae2:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ae5:	83 ec 08             	sub    $0x8,%esp
  800ae8:	ff 75 0c             	pushl  0xc(%ebp)
  800aeb:	6a 78                	push   $0x78
  800aed:	8b 45 08             	mov    0x8(%ebp),%eax
  800af0:	ff d0                	call   *%eax
  800af2:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800af5:	8b 45 14             	mov    0x14(%ebp),%eax
  800af8:	83 c0 04             	add    $0x4,%eax
  800afb:	89 45 14             	mov    %eax,0x14(%ebp)
  800afe:	8b 45 14             	mov    0x14(%ebp),%eax
  800b01:	83 e8 04             	sub    $0x4,%eax
  800b04:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b06:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b09:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b10:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b17:	eb 1f                	jmp    800b38 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b19:	83 ec 08             	sub    $0x8,%esp
  800b1c:	ff 75 e8             	pushl  -0x18(%ebp)
  800b1f:	8d 45 14             	lea    0x14(%ebp),%eax
  800b22:	50                   	push   %eax
  800b23:	e8 e7 fb ff ff       	call   80070f <getuint>
  800b28:	83 c4 10             	add    $0x10,%esp
  800b2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b2e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b31:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b38:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b3f:	83 ec 04             	sub    $0x4,%esp
  800b42:	52                   	push   %edx
  800b43:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b46:	50                   	push   %eax
  800b47:	ff 75 f4             	pushl  -0xc(%ebp)
  800b4a:	ff 75 f0             	pushl  -0x10(%ebp)
  800b4d:	ff 75 0c             	pushl  0xc(%ebp)
  800b50:	ff 75 08             	pushl  0x8(%ebp)
  800b53:	e8 00 fb ff ff       	call   800658 <printnum>
  800b58:	83 c4 20             	add    $0x20,%esp
			break;
  800b5b:	eb 46                	jmp    800ba3 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b5d:	83 ec 08             	sub    $0x8,%esp
  800b60:	ff 75 0c             	pushl  0xc(%ebp)
  800b63:	53                   	push   %ebx
  800b64:	8b 45 08             	mov    0x8(%ebp),%eax
  800b67:	ff d0                	call   *%eax
  800b69:	83 c4 10             	add    $0x10,%esp
			break;
  800b6c:	eb 35                	jmp    800ba3 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b6e:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
			break;
  800b75:	eb 2c                	jmp    800ba3 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b77:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
			break;
  800b7e:	eb 23                	jmp    800ba3 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b80:	83 ec 08             	sub    $0x8,%esp
  800b83:	ff 75 0c             	pushl  0xc(%ebp)
  800b86:	6a 25                	push   $0x25
  800b88:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8b:	ff d0                	call   *%eax
  800b8d:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b90:	ff 4d 10             	decl   0x10(%ebp)
  800b93:	eb 03                	jmp    800b98 <vprintfmt+0x3c3>
  800b95:	ff 4d 10             	decl   0x10(%ebp)
  800b98:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9b:	48                   	dec    %eax
  800b9c:	8a 00                	mov    (%eax),%al
  800b9e:	3c 25                	cmp    $0x25,%al
  800ba0:	75 f3                	jne    800b95 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800ba2:	90                   	nop
		}
	}
  800ba3:	e9 35 fc ff ff       	jmp    8007dd <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ba8:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ba9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bac:	5b                   	pop    %ebx
  800bad:	5e                   	pop    %esi
  800bae:	5d                   	pop    %ebp
  800baf:	c3                   	ret    

00800bb0 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bb0:	55                   	push   %ebp
  800bb1:	89 e5                	mov    %esp,%ebp
  800bb3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bb6:	8d 45 10             	lea    0x10(%ebp),%eax
  800bb9:	83 c0 04             	add    $0x4,%eax
  800bbc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bbf:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc2:	ff 75 f4             	pushl  -0xc(%ebp)
  800bc5:	50                   	push   %eax
  800bc6:	ff 75 0c             	pushl  0xc(%ebp)
  800bc9:	ff 75 08             	pushl  0x8(%ebp)
  800bcc:	e8 04 fc ff ff       	call   8007d5 <vprintfmt>
  800bd1:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800bd4:	90                   	nop
  800bd5:	c9                   	leave  
  800bd6:	c3                   	ret    

00800bd7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bd7:	55                   	push   %ebp
  800bd8:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bdd:	8b 40 08             	mov    0x8(%eax),%eax
  800be0:	8d 50 01             	lea    0x1(%eax),%edx
  800be3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be6:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800be9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bec:	8b 10                	mov    (%eax),%edx
  800bee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf1:	8b 40 04             	mov    0x4(%eax),%eax
  800bf4:	39 c2                	cmp    %eax,%edx
  800bf6:	73 12                	jae    800c0a <sprintputch+0x33>
		*b->buf++ = ch;
  800bf8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfb:	8b 00                	mov    (%eax),%eax
  800bfd:	8d 48 01             	lea    0x1(%eax),%ecx
  800c00:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c03:	89 0a                	mov    %ecx,(%edx)
  800c05:	8b 55 08             	mov    0x8(%ebp),%edx
  800c08:	88 10                	mov    %dl,(%eax)
}
  800c0a:	90                   	nop
  800c0b:	5d                   	pop    %ebp
  800c0c:	c3                   	ret    

00800c0d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c0d:	55                   	push   %ebp
  800c0e:	89 e5                	mov    %esp,%ebp
  800c10:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c13:	8b 45 08             	mov    0x8(%ebp),%eax
  800c16:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c22:	01 d0                	add    %edx,%eax
  800c24:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c27:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c2e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c32:	74 06                	je     800c3a <vsnprintf+0x2d>
  800c34:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c38:	7f 07                	jg     800c41 <vsnprintf+0x34>
		return -E_INVAL;
  800c3a:	b8 03 00 00 00       	mov    $0x3,%eax
  800c3f:	eb 20                	jmp    800c61 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c41:	ff 75 14             	pushl  0x14(%ebp)
  800c44:	ff 75 10             	pushl  0x10(%ebp)
  800c47:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c4a:	50                   	push   %eax
  800c4b:	68 d7 0b 80 00       	push   $0x800bd7
  800c50:	e8 80 fb ff ff       	call   8007d5 <vprintfmt>
  800c55:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c5b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c61:	c9                   	leave  
  800c62:	c3                   	ret    

00800c63 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c63:	55                   	push   %ebp
  800c64:	89 e5                	mov    %esp,%ebp
  800c66:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c69:	8d 45 10             	lea    0x10(%ebp),%eax
  800c6c:	83 c0 04             	add    $0x4,%eax
  800c6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c72:	8b 45 10             	mov    0x10(%ebp),%eax
  800c75:	ff 75 f4             	pushl  -0xc(%ebp)
  800c78:	50                   	push   %eax
  800c79:	ff 75 0c             	pushl  0xc(%ebp)
  800c7c:	ff 75 08             	pushl  0x8(%ebp)
  800c7f:	e8 89 ff ff ff       	call   800c0d <vsnprintf>
  800c84:	83 c4 10             	add    $0x10,%esp
  800c87:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c8d:	c9                   	leave  
  800c8e:	c3                   	ret    

00800c8f <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800c8f:	55                   	push   %ebp
  800c90:	89 e5                	mov    %esp,%ebp
  800c92:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c95:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c9c:	eb 06                	jmp    800ca4 <strlen+0x15>
		n++;
  800c9e:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ca1:	ff 45 08             	incl   0x8(%ebp)
  800ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca7:	8a 00                	mov    (%eax),%al
  800ca9:	84 c0                	test   %al,%al
  800cab:	75 f1                	jne    800c9e <strlen+0xf>
		n++;
	return n;
  800cad:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cb0:	c9                   	leave  
  800cb1:	c3                   	ret    

00800cb2 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cb2:	55                   	push   %ebp
  800cb3:	89 e5                	mov    %esp,%ebp
  800cb5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cb8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cbf:	eb 09                	jmp    800cca <strnlen+0x18>
		n++;
  800cc1:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cc4:	ff 45 08             	incl   0x8(%ebp)
  800cc7:	ff 4d 0c             	decl   0xc(%ebp)
  800cca:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cce:	74 09                	je     800cd9 <strnlen+0x27>
  800cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd3:	8a 00                	mov    (%eax),%al
  800cd5:	84 c0                	test   %al,%al
  800cd7:	75 e8                	jne    800cc1 <strnlen+0xf>
		n++;
	return n;
  800cd9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cdc:	c9                   	leave  
  800cdd:	c3                   	ret    

00800cde <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cde:	55                   	push   %ebp
  800cdf:	89 e5                	mov    %esp,%ebp
  800ce1:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cea:	90                   	nop
  800ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cee:	8d 50 01             	lea    0x1(%eax),%edx
  800cf1:	89 55 08             	mov    %edx,0x8(%ebp)
  800cf4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cf7:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cfa:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cfd:	8a 12                	mov    (%edx),%dl
  800cff:	88 10                	mov    %dl,(%eax)
  800d01:	8a 00                	mov    (%eax),%al
  800d03:	84 c0                	test   %al,%al
  800d05:	75 e4                	jne    800ceb <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d07:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d0a:	c9                   	leave  
  800d0b:	c3                   	ret    

00800d0c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d0c:	55                   	push   %ebp
  800d0d:	89 e5                	mov    %esp,%ebp
  800d0f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d12:	8b 45 08             	mov    0x8(%ebp),%eax
  800d15:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d18:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d1f:	eb 1f                	jmp    800d40 <strncpy+0x34>
		*dst++ = *src;
  800d21:	8b 45 08             	mov    0x8(%ebp),%eax
  800d24:	8d 50 01             	lea    0x1(%eax),%edx
  800d27:	89 55 08             	mov    %edx,0x8(%ebp)
  800d2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d2d:	8a 12                	mov    (%edx),%dl
  800d2f:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d34:	8a 00                	mov    (%eax),%al
  800d36:	84 c0                	test   %al,%al
  800d38:	74 03                	je     800d3d <strncpy+0x31>
			src++;
  800d3a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d3d:	ff 45 fc             	incl   -0x4(%ebp)
  800d40:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d43:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d46:	72 d9                	jb     800d21 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d48:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d4b:	c9                   	leave  
  800d4c:	c3                   	ret    

00800d4d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d4d:	55                   	push   %ebp
  800d4e:	89 e5                	mov    %esp,%ebp
  800d50:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d53:	8b 45 08             	mov    0x8(%ebp),%eax
  800d56:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d59:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d5d:	74 30                	je     800d8f <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d5f:	eb 16                	jmp    800d77 <strlcpy+0x2a>
			*dst++ = *src++;
  800d61:	8b 45 08             	mov    0x8(%ebp),%eax
  800d64:	8d 50 01             	lea    0x1(%eax),%edx
  800d67:	89 55 08             	mov    %edx,0x8(%ebp)
  800d6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d6d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d70:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d73:	8a 12                	mov    (%edx),%dl
  800d75:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d77:	ff 4d 10             	decl   0x10(%ebp)
  800d7a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d7e:	74 09                	je     800d89 <strlcpy+0x3c>
  800d80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d83:	8a 00                	mov    (%eax),%al
  800d85:	84 c0                	test   %al,%al
  800d87:	75 d8                	jne    800d61 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d89:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d8f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d92:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d95:	29 c2                	sub    %eax,%edx
  800d97:	89 d0                	mov    %edx,%eax
}
  800d99:	c9                   	leave  
  800d9a:	c3                   	ret    

00800d9b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d9b:	55                   	push   %ebp
  800d9c:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d9e:	eb 06                	jmp    800da6 <strcmp+0xb>
		p++, q++;
  800da0:	ff 45 08             	incl   0x8(%ebp)
  800da3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800da6:	8b 45 08             	mov    0x8(%ebp),%eax
  800da9:	8a 00                	mov    (%eax),%al
  800dab:	84 c0                	test   %al,%al
  800dad:	74 0e                	je     800dbd <strcmp+0x22>
  800daf:	8b 45 08             	mov    0x8(%ebp),%eax
  800db2:	8a 10                	mov    (%eax),%dl
  800db4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db7:	8a 00                	mov    (%eax),%al
  800db9:	38 c2                	cmp    %al,%dl
  800dbb:	74 e3                	je     800da0 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc0:	8a 00                	mov    (%eax),%al
  800dc2:	0f b6 d0             	movzbl %al,%edx
  800dc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc8:	8a 00                	mov    (%eax),%al
  800dca:	0f b6 c0             	movzbl %al,%eax
  800dcd:	29 c2                	sub    %eax,%edx
  800dcf:	89 d0                	mov    %edx,%eax
}
  800dd1:	5d                   	pop    %ebp
  800dd2:	c3                   	ret    

00800dd3 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800dd3:	55                   	push   %ebp
  800dd4:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800dd6:	eb 09                	jmp    800de1 <strncmp+0xe>
		n--, p++, q++;
  800dd8:	ff 4d 10             	decl   0x10(%ebp)
  800ddb:	ff 45 08             	incl   0x8(%ebp)
  800dde:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800de1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800de5:	74 17                	je     800dfe <strncmp+0x2b>
  800de7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dea:	8a 00                	mov    (%eax),%al
  800dec:	84 c0                	test   %al,%al
  800dee:	74 0e                	je     800dfe <strncmp+0x2b>
  800df0:	8b 45 08             	mov    0x8(%ebp),%eax
  800df3:	8a 10                	mov    (%eax),%dl
  800df5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df8:	8a 00                	mov    (%eax),%al
  800dfa:	38 c2                	cmp    %al,%dl
  800dfc:	74 da                	je     800dd8 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dfe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e02:	75 07                	jne    800e0b <strncmp+0x38>
		return 0;
  800e04:	b8 00 00 00 00       	mov    $0x0,%eax
  800e09:	eb 14                	jmp    800e1f <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0e:	8a 00                	mov    (%eax),%al
  800e10:	0f b6 d0             	movzbl %al,%edx
  800e13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e16:	8a 00                	mov    (%eax),%al
  800e18:	0f b6 c0             	movzbl %al,%eax
  800e1b:	29 c2                	sub    %eax,%edx
  800e1d:	89 d0                	mov    %edx,%eax
}
  800e1f:	5d                   	pop    %ebp
  800e20:	c3                   	ret    

00800e21 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e21:	55                   	push   %ebp
  800e22:	89 e5                	mov    %esp,%ebp
  800e24:	83 ec 04             	sub    $0x4,%esp
  800e27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e2d:	eb 12                	jmp    800e41 <strchr+0x20>
		if (*s == c)
  800e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e32:	8a 00                	mov    (%eax),%al
  800e34:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e37:	75 05                	jne    800e3e <strchr+0x1d>
			return (char *) s;
  800e39:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3c:	eb 11                	jmp    800e4f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e3e:	ff 45 08             	incl   0x8(%ebp)
  800e41:	8b 45 08             	mov    0x8(%ebp),%eax
  800e44:	8a 00                	mov    (%eax),%al
  800e46:	84 c0                	test   %al,%al
  800e48:	75 e5                	jne    800e2f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e4f:	c9                   	leave  
  800e50:	c3                   	ret    

00800e51 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e51:	55                   	push   %ebp
  800e52:	89 e5                	mov    %esp,%ebp
  800e54:	83 ec 04             	sub    $0x4,%esp
  800e57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e5d:	eb 0d                	jmp    800e6c <strfind+0x1b>
		if (*s == c)
  800e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e62:	8a 00                	mov    (%eax),%al
  800e64:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e67:	74 0e                	je     800e77 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e69:	ff 45 08             	incl   0x8(%ebp)
  800e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6f:	8a 00                	mov    (%eax),%al
  800e71:	84 c0                	test   %al,%al
  800e73:	75 ea                	jne    800e5f <strfind+0xe>
  800e75:	eb 01                	jmp    800e78 <strfind+0x27>
		if (*s == c)
			break;
  800e77:	90                   	nop
	return (char *) s;
  800e78:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e7b:	c9                   	leave  
  800e7c:	c3                   	ret    

00800e7d <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e7d:	55                   	push   %ebp
  800e7e:	89 e5                	mov    %esp,%ebp
  800e80:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e83:	8b 45 08             	mov    0x8(%ebp),%eax
  800e86:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e89:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e8f:	eb 0e                	jmp    800e9f <memset+0x22>
		*p++ = c;
  800e91:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e94:	8d 50 01             	lea    0x1(%eax),%edx
  800e97:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e9d:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e9f:	ff 4d f8             	decl   -0x8(%ebp)
  800ea2:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800ea6:	79 e9                	jns    800e91 <memset+0x14>
		*p++ = c;

	return v;
  800ea8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eab:	c9                   	leave  
  800eac:	c3                   	ret    

00800ead <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ead:	55                   	push   %ebp
  800eae:	89 e5                	mov    %esp,%ebp
  800eb0:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800eb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ebf:	eb 16                	jmp    800ed7 <memcpy+0x2a>
		*d++ = *s++;
  800ec1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ec4:	8d 50 01             	lea    0x1(%eax),%edx
  800ec7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800eca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ecd:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ed0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ed3:	8a 12                	mov    (%edx),%dl
  800ed5:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800ed7:	8b 45 10             	mov    0x10(%ebp),%eax
  800eda:	8d 50 ff             	lea    -0x1(%eax),%edx
  800edd:	89 55 10             	mov    %edx,0x10(%ebp)
  800ee0:	85 c0                	test   %eax,%eax
  800ee2:	75 dd                	jne    800ec1 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ee4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ee7:	c9                   	leave  
  800ee8:	c3                   	ret    

00800ee9 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ee9:	55                   	push   %ebp
  800eea:	89 e5                	mov    %esp,%ebp
  800eec:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800eef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800efb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800efe:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f01:	73 50                	jae    800f53 <memmove+0x6a>
  800f03:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f06:	8b 45 10             	mov    0x10(%ebp),%eax
  800f09:	01 d0                	add    %edx,%eax
  800f0b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f0e:	76 43                	jbe    800f53 <memmove+0x6a>
		s += n;
  800f10:	8b 45 10             	mov    0x10(%ebp),%eax
  800f13:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f16:	8b 45 10             	mov    0x10(%ebp),%eax
  800f19:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f1c:	eb 10                	jmp    800f2e <memmove+0x45>
			*--d = *--s;
  800f1e:	ff 4d f8             	decl   -0x8(%ebp)
  800f21:	ff 4d fc             	decl   -0x4(%ebp)
  800f24:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f27:	8a 10                	mov    (%eax),%dl
  800f29:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f2c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f31:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f34:	89 55 10             	mov    %edx,0x10(%ebp)
  800f37:	85 c0                	test   %eax,%eax
  800f39:	75 e3                	jne    800f1e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f3b:	eb 23                	jmp    800f60 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f3d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f40:	8d 50 01             	lea    0x1(%eax),%edx
  800f43:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f46:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f49:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f4c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f4f:	8a 12                	mov    (%edx),%dl
  800f51:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f53:	8b 45 10             	mov    0x10(%ebp),%eax
  800f56:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f59:	89 55 10             	mov    %edx,0x10(%ebp)
  800f5c:	85 c0                	test   %eax,%eax
  800f5e:	75 dd                	jne    800f3d <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f60:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f63:	c9                   	leave  
  800f64:	c3                   	ret    

00800f65 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f65:	55                   	push   %ebp
  800f66:	89 e5                	mov    %esp,%ebp
  800f68:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f74:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f77:	eb 2a                	jmp    800fa3 <memcmp+0x3e>
		if (*s1 != *s2)
  800f79:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f7c:	8a 10                	mov    (%eax),%dl
  800f7e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f81:	8a 00                	mov    (%eax),%al
  800f83:	38 c2                	cmp    %al,%dl
  800f85:	74 16                	je     800f9d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f87:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f8a:	8a 00                	mov    (%eax),%al
  800f8c:	0f b6 d0             	movzbl %al,%edx
  800f8f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f92:	8a 00                	mov    (%eax),%al
  800f94:	0f b6 c0             	movzbl %al,%eax
  800f97:	29 c2                	sub    %eax,%edx
  800f99:	89 d0                	mov    %edx,%eax
  800f9b:	eb 18                	jmp    800fb5 <memcmp+0x50>
		s1++, s2++;
  800f9d:	ff 45 fc             	incl   -0x4(%ebp)
  800fa0:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fa3:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fa9:	89 55 10             	mov    %edx,0x10(%ebp)
  800fac:	85 c0                	test   %eax,%eax
  800fae:	75 c9                	jne    800f79 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800fb0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fb5:	c9                   	leave  
  800fb6:	c3                   	ret    

00800fb7 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800fb7:	55                   	push   %ebp
  800fb8:	89 e5                	mov    %esp,%ebp
  800fba:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800fbd:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc0:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc3:	01 d0                	add    %edx,%eax
  800fc5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fc8:	eb 15                	jmp    800fdf <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fca:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcd:	8a 00                	mov    (%eax),%al
  800fcf:	0f b6 d0             	movzbl %al,%edx
  800fd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd5:	0f b6 c0             	movzbl %al,%eax
  800fd8:	39 c2                	cmp    %eax,%edx
  800fda:	74 0d                	je     800fe9 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800fdc:	ff 45 08             	incl   0x8(%ebp)
  800fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800fe5:	72 e3                	jb     800fca <memfind+0x13>
  800fe7:	eb 01                	jmp    800fea <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800fe9:	90                   	nop
	return (void *) s;
  800fea:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fed:	c9                   	leave  
  800fee:	c3                   	ret    

00800fef <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fef:	55                   	push   %ebp
  800ff0:	89 e5                	mov    %esp,%ebp
  800ff2:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800ff5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800ffc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801003:	eb 03                	jmp    801008 <strtol+0x19>
		s++;
  801005:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801008:	8b 45 08             	mov    0x8(%ebp),%eax
  80100b:	8a 00                	mov    (%eax),%al
  80100d:	3c 20                	cmp    $0x20,%al
  80100f:	74 f4                	je     801005 <strtol+0x16>
  801011:	8b 45 08             	mov    0x8(%ebp),%eax
  801014:	8a 00                	mov    (%eax),%al
  801016:	3c 09                	cmp    $0x9,%al
  801018:	74 eb                	je     801005 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80101a:	8b 45 08             	mov    0x8(%ebp),%eax
  80101d:	8a 00                	mov    (%eax),%al
  80101f:	3c 2b                	cmp    $0x2b,%al
  801021:	75 05                	jne    801028 <strtol+0x39>
		s++;
  801023:	ff 45 08             	incl   0x8(%ebp)
  801026:	eb 13                	jmp    80103b <strtol+0x4c>
	else if (*s == '-')
  801028:	8b 45 08             	mov    0x8(%ebp),%eax
  80102b:	8a 00                	mov    (%eax),%al
  80102d:	3c 2d                	cmp    $0x2d,%al
  80102f:	75 0a                	jne    80103b <strtol+0x4c>
		s++, neg = 1;
  801031:	ff 45 08             	incl   0x8(%ebp)
  801034:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80103b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80103f:	74 06                	je     801047 <strtol+0x58>
  801041:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801045:	75 20                	jne    801067 <strtol+0x78>
  801047:	8b 45 08             	mov    0x8(%ebp),%eax
  80104a:	8a 00                	mov    (%eax),%al
  80104c:	3c 30                	cmp    $0x30,%al
  80104e:	75 17                	jne    801067 <strtol+0x78>
  801050:	8b 45 08             	mov    0x8(%ebp),%eax
  801053:	40                   	inc    %eax
  801054:	8a 00                	mov    (%eax),%al
  801056:	3c 78                	cmp    $0x78,%al
  801058:	75 0d                	jne    801067 <strtol+0x78>
		s += 2, base = 16;
  80105a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80105e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801065:	eb 28                	jmp    80108f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801067:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80106b:	75 15                	jne    801082 <strtol+0x93>
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
  801070:	8a 00                	mov    (%eax),%al
  801072:	3c 30                	cmp    $0x30,%al
  801074:	75 0c                	jne    801082 <strtol+0x93>
		s++, base = 8;
  801076:	ff 45 08             	incl   0x8(%ebp)
  801079:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801080:	eb 0d                	jmp    80108f <strtol+0xa0>
	else if (base == 0)
  801082:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801086:	75 07                	jne    80108f <strtol+0xa0>
		base = 10;
  801088:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80108f:	8b 45 08             	mov    0x8(%ebp),%eax
  801092:	8a 00                	mov    (%eax),%al
  801094:	3c 2f                	cmp    $0x2f,%al
  801096:	7e 19                	jle    8010b1 <strtol+0xc2>
  801098:	8b 45 08             	mov    0x8(%ebp),%eax
  80109b:	8a 00                	mov    (%eax),%al
  80109d:	3c 39                	cmp    $0x39,%al
  80109f:	7f 10                	jg     8010b1 <strtol+0xc2>
			dig = *s - '0';
  8010a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a4:	8a 00                	mov    (%eax),%al
  8010a6:	0f be c0             	movsbl %al,%eax
  8010a9:	83 e8 30             	sub    $0x30,%eax
  8010ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010af:	eb 42                	jmp    8010f3 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b4:	8a 00                	mov    (%eax),%al
  8010b6:	3c 60                	cmp    $0x60,%al
  8010b8:	7e 19                	jle    8010d3 <strtol+0xe4>
  8010ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bd:	8a 00                	mov    (%eax),%al
  8010bf:	3c 7a                	cmp    $0x7a,%al
  8010c1:	7f 10                	jg     8010d3 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	8a 00                	mov    (%eax),%al
  8010c8:	0f be c0             	movsbl %al,%eax
  8010cb:	83 e8 57             	sub    $0x57,%eax
  8010ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010d1:	eb 20                	jmp    8010f3 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d6:	8a 00                	mov    (%eax),%al
  8010d8:	3c 40                	cmp    $0x40,%al
  8010da:	7e 39                	jle    801115 <strtol+0x126>
  8010dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010df:	8a 00                	mov    (%eax),%al
  8010e1:	3c 5a                	cmp    $0x5a,%al
  8010e3:	7f 30                	jg     801115 <strtol+0x126>
			dig = *s - 'A' + 10;
  8010e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e8:	8a 00                	mov    (%eax),%al
  8010ea:	0f be c0             	movsbl %al,%eax
  8010ed:	83 e8 37             	sub    $0x37,%eax
  8010f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010f6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010f9:	7d 19                	jge    801114 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8010fb:	ff 45 08             	incl   0x8(%ebp)
  8010fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801101:	0f af 45 10          	imul   0x10(%ebp),%eax
  801105:	89 c2                	mov    %eax,%edx
  801107:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80110a:	01 d0                	add    %edx,%eax
  80110c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80110f:	e9 7b ff ff ff       	jmp    80108f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801114:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801115:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801119:	74 08                	je     801123 <strtol+0x134>
		*endptr = (char *) s;
  80111b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111e:	8b 55 08             	mov    0x8(%ebp),%edx
  801121:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801123:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801127:	74 07                	je     801130 <strtol+0x141>
  801129:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80112c:	f7 d8                	neg    %eax
  80112e:	eb 03                	jmp    801133 <strtol+0x144>
  801130:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801133:	c9                   	leave  
  801134:	c3                   	ret    

00801135 <ltostr>:

void
ltostr(long value, char *str)
{
  801135:	55                   	push   %ebp
  801136:	89 e5                	mov    %esp,%ebp
  801138:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80113b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801142:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801149:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80114d:	79 13                	jns    801162 <ltostr+0x2d>
	{
		neg = 1;
  80114f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801156:	8b 45 0c             	mov    0xc(%ebp),%eax
  801159:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80115c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80115f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801162:	8b 45 08             	mov    0x8(%ebp),%eax
  801165:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80116a:	99                   	cltd   
  80116b:	f7 f9                	idiv   %ecx
  80116d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801170:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801173:	8d 50 01             	lea    0x1(%eax),%edx
  801176:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801179:	89 c2                	mov    %eax,%edx
  80117b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117e:	01 d0                	add    %edx,%eax
  801180:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801183:	83 c2 30             	add    $0x30,%edx
  801186:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801188:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80118b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801190:	f7 e9                	imul   %ecx
  801192:	c1 fa 02             	sar    $0x2,%edx
  801195:	89 c8                	mov    %ecx,%eax
  801197:	c1 f8 1f             	sar    $0x1f,%eax
  80119a:	29 c2                	sub    %eax,%edx
  80119c:	89 d0                	mov    %edx,%eax
  80119e:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8011a1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011a5:	75 bb                	jne    801162 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8011ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011b1:	48                   	dec    %eax
  8011b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011b9:	74 3d                	je     8011f8 <ltostr+0xc3>
		start = 1 ;
  8011bb:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011c2:	eb 34                	jmp    8011f8 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8011c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ca:	01 d0                	add    %edx,%eax
  8011cc:	8a 00                	mov    (%eax),%al
  8011ce:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d7:	01 c2                	add    %eax,%edx
  8011d9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011df:	01 c8                	add    %ecx,%eax
  8011e1:	8a 00                	mov    (%eax),%al
  8011e3:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8011e5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011eb:	01 c2                	add    %eax,%edx
  8011ed:	8a 45 eb             	mov    -0x15(%ebp),%al
  8011f0:	88 02                	mov    %al,(%edx)
		start++ ;
  8011f2:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011f5:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011fb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011fe:	7c c4                	jl     8011c4 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801200:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801203:	8b 45 0c             	mov    0xc(%ebp),%eax
  801206:	01 d0                	add    %edx,%eax
  801208:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80120b:	90                   	nop
  80120c:	c9                   	leave  
  80120d:	c3                   	ret    

0080120e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80120e:	55                   	push   %ebp
  80120f:	89 e5                	mov    %esp,%ebp
  801211:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801214:	ff 75 08             	pushl  0x8(%ebp)
  801217:	e8 73 fa ff ff       	call   800c8f <strlen>
  80121c:	83 c4 04             	add    $0x4,%esp
  80121f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801222:	ff 75 0c             	pushl  0xc(%ebp)
  801225:	e8 65 fa ff ff       	call   800c8f <strlen>
  80122a:	83 c4 04             	add    $0x4,%esp
  80122d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801230:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801237:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80123e:	eb 17                	jmp    801257 <strcconcat+0x49>
		final[s] = str1[s] ;
  801240:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801243:	8b 45 10             	mov    0x10(%ebp),%eax
  801246:	01 c2                	add    %eax,%edx
  801248:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80124b:	8b 45 08             	mov    0x8(%ebp),%eax
  80124e:	01 c8                	add    %ecx,%eax
  801250:	8a 00                	mov    (%eax),%al
  801252:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801254:	ff 45 fc             	incl   -0x4(%ebp)
  801257:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80125a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80125d:	7c e1                	jl     801240 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80125f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801266:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80126d:	eb 1f                	jmp    80128e <strcconcat+0x80>
		final[s++] = str2[i] ;
  80126f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801272:	8d 50 01             	lea    0x1(%eax),%edx
  801275:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801278:	89 c2                	mov    %eax,%edx
  80127a:	8b 45 10             	mov    0x10(%ebp),%eax
  80127d:	01 c2                	add    %eax,%edx
  80127f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801282:	8b 45 0c             	mov    0xc(%ebp),%eax
  801285:	01 c8                	add    %ecx,%eax
  801287:	8a 00                	mov    (%eax),%al
  801289:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80128b:	ff 45 f8             	incl   -0x8(%ebp)
  80128e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801291:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801294:	7c d9                	jl     80126f <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801296:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801299:	8b 45 10             	mov    0x10(%ebp),%eax
  80129c:	01 d0                	add    %edx,%eax
  80129e:	c6 00 00             	movb   $0x0,(%eax)
}
  8012a1:	90                   	nop
  8012a2:	c9                   	leave  
  8012a3:	c3                   	ret    

008012a4 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012a4:	55                   	push   %ebp
  8012a5:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8012aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8012b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8012b3:	8b 00                	mov    (%eax),%eax
  8012b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8012bf:	01 d0                	add    %edx,%eax
  8012c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012c7:	eb 0c                	jmp    8012d5 <strsplit+0x31>
			*string++ = 0;
  8012c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cc:	8d 50 01             	lea    0x1(%eax),%edx
  8012cf:	89 55 08             	mov    %edx,0x8(%ebp)
  8012d2:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d8:	8a 00                	mov    (%eax),%al
  8012da:	84 c0                	test   %al,%al
  8012dc:	74 18                	je     8012f6 <strsplit+0x52>
  8012de:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e1:	8a 00                	mov    (%eax),%al
  8012e3:	0f be c0             	movsbl %al,%eax
  8012e6:	50                   	push   %eax
  8012e7:	ff 75 0c             	pushl  0xc(%ebp)
  8012ea:	e8 32 fb ff ff       	call   800e21 <strchr>
  8012ef:	83 c4 08             	add    $0x8,%esp
  8012f2:	85 c0                	test   %eax,%eax
  8012f4:	75 d3                	jne    8012c9 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f9:	8a 00                	mov    (%eax),%al
  8012fb:	84 c0                	test   %al,%al
  8012fd:	74 5a                	je     801359 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012ff:	8b 45 14             	mov    0x14(%ebp),%eax
  801302:	8b 00                	mov    (%eax),%eax
  801304:	83 f8 0f             	cmp    $0xf,%eax
  801307:	75 07                	jne    801310 <strsplit+0x6c>
		{
			return 0;
  801309:	b8 00 00 00 00       	mov    $0x0,%eax
  80130e:	eb 66                	jmp    801376 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801310:	8b 45 14             	mov    0x14(%ebp),%eax
  801313:	8b 00                	mov    (%eax),%eax
  801315:	8d 48 01             	lea    0x1(%eax),%ecx
  801318:	8b 55 14             	mov    0x14(%ebp),%edx
  80131b:	89 0a                	mov    %ecx,(%edx)
  80131d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801324:	8b 45 10             	mov    0x10(%ebp),%eax
  801327:	01 c2                	add    %eax,%edx
  801329:	8b 45 08             	mov    0x8(%ebp),%eax
  80132c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80132e:	eb 03                	jmp    801333 <strsplit+0x8f>
			string++;
  801330:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801333:	8b 45 08             	mov    0x8(%ebp),%eax
  801336:	8a 00                	mov    (%eax),%al
  801338:	84 c0                	test   %al,%al
  80133a:	74 8b                	je     8012c7 <strsplit+0x23>
  80133c:	8b 45 08             	mov    0x8(%ebp),%eax
  80133f:	8a 00                	mov    (%eax),%al
  801341:	0f be c0             	movsbl %al,%eax
  801344:	50                   	push   %eax
  801345:	ff 75 0c             	pushl  0xc(%ebp)
  801348:	e8 d4 fa ff ff       	call   800e21 <strchr>
  80134d:	83 c4 08             	add    $0x8,%esp
  801350:	85 c0                	test   %eax,%eax
  801352:	74 dc                	je     801330 <strsplit+0x8c>
			string++;
	}
  801354:	e9 6e ff ff ff       	jmp    8012c7 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801359:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80135a:	8b 45 14             	mov    0x14(%ebp),%eax
  80135d:	8b 00                	mov    (%eax),%eax
  80135f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801366:	8b 45 10             	mov    0x10(%ebp),%eax
  801369:	01 d0                	add    %edx,%eax
  80136b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801371:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801376:	c9                   	leave  
  801377:	c3                   	ret    

00801378 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801378:	55                   	push   %ebp
  801379:	89 e5                	mov    %esp,%ebp
  80137b:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  80137e:	83 ec 04             	sub    $0x4,%esp
  801381:	68 c8 3e 80 00       	push   $0x803ec8
  801386:	68 3f 01 00 00       	push   $0x13f
  80138b:	68 ea 3e 80 00       	push   $0x803eea
  801390:	e8 9a 21 00 00       	call   80352f <_panic>

00801395 <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  801395:	55                   	push   %ebp
  801396:	89 e5                	mov    %esp,%ebp
  801398:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  80139b:	83 ec 0c             	sub    $0xc,%esp
  80139e:	ff 75 08             	pushl  0x8(%ebp)
  8013a1:	e8 90 0c 00 00       	call   802036 <sys_sbrk>
  8013a6:	83 c4 10             	add    $0x10,%esp
}
  8013a9:	c9                   	leave  
  8013aa:	c3                   	ret    

008013ab <malloc>:
#define num_of_page ((USER_HEAP_MAX - USER_HEAP_START) / PAGE_SIZE)

int pagesAllocated[num_of_page] = { 0 };
int shardIDs[num_of_page] = { 0 };
bool markedPages[num_of_page] = { 0 };
void* malloc(uint32 size) {
  8013ab:	55                   	push   %ebp
  8013ac:	89 e5                	mov    %esp,%ebp
  8013ae:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  8013b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013b5:	75 0a                	jne    8013c1 <malloc+0x16>
		return NULL;
  8013b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8013bc:	e9 9e 01 00 00       	jmp    80155f <malloc+0x1b4>

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

	//  our new code
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  8013c1:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8013c8:	77 2c                	ja     8013f6 <malloc+0x4b>
		if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  8013ca:	e8 eb 0a 00 00       	call   801eba <sys_isUHeapPlacementStrategyFIRSTFIT>
  8013cf:	85 c0                	test   %eax,%eax
  8013d1:	74 19                	je     8013ec <malloc+0x41>

			void * block = alloc_block_FF(size);
  8013d3:	83 ec 0c             	sub    $0xc,%esp
  8013d6:	ff 75 08             	pushl  0x8(%ebp)
  8013d9:	e8 85 11 00 00       	call   802563 <alloc_block_FF>
  8013de:	83 c4 10             	add    $0x10,%esp
  8013e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			return block;
  8013e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013e7:	e9 73 01 00 00       	jmp    80155f <malloc+0x1b4>
		} else {
			return NULL;
  8013ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8013f1:	e9 69 01 00 00       	jmp    80155f <malloc+0x1b4>
		}
	}

	uint32 numOfPages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  8013f6:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8013fd:	8b 55 08             	mov    0x8(%ebp),%edx
  801400:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801403:	01 d0                	add    %edx,%eax
  801405:	48                   	dec    %eax
  801406:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801409:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80140c:	ba 00 00 00 00       	mov    $0x0,%edx
  801411:	f7 75 e0             	divl   -0x20(%ebp)
  801414:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801417:	29 d0                	sub    %edx,%eax
  801419:	c1 e8 0c             	shr    $0xc,%eax
  80141c:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 freePagesCount = 0;
  80141f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801426:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  80142d:	a1 20 50 80 00       	mov    0x805020,%eax
  801432:	8b 40 7c             	mov    0x7c(%eax),%eax
  801435:	05 00 10 00 00       	add    $0x1000,%eax
  80143a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  80143d:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801442:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801445:	89 45 d0             	mov    %eax,-0x30(%ebp)

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  801448:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80144f:	8b 55 08             	mov    0x8(%ebp),%edx
  801452:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801455:	01 d0                	add    %edx,%eax
  801457:	48                   	dec    %eax
  801458:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80145b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80145e:	ba 00 00 00 00       	mov    $0x0,%edx
  801463:	f7 75 cc             	divl   -0x34(%ebp)
  801466:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801469:	29 d0                	sub    %edx,%eax
  80146b:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80146e:	76 0a                	jbe    80147a <malloc+0xcf>
		return NULL;
  801470:	b8 00 00 00 00       	mov    $0x0,%eax
  801475:	e9 e5 00 00 00       	jmp    80155f <malloc+0x1b4>
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  80147a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80147d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801480:	eb 48                	jmp    8014ca <malloc+0x11f>
	{
		uint32 idx = (i - currentAddr) / PAGE_SIZE;
  801482:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801485:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801488:	c1 e8 0c             	shr    $0xc,%eax
  80148b:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if (!markedPages[idx]) {
  80148e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801491:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  801498:	85 c0                	test   %eax,%eax
  80149a:	75 11                	jne    8014ad <malloc+0x102>
			freePagesCount++;
  80149c:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  80149f:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8014a3:	75 16                	jne    8014bb <malloc+0x110>
				start = i;
  8014a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014ab:	eb 0e                	jmp    8014bb <malloc+0x110>
			}
		} else {
			freePagesCount = 0;
  8014ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  8014b4:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == numOfPages) {
  8014bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014be:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8014c1:	74 12                	je     8014d5 <malloc+0x12a>

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  8014c3:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  8014ca:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  8014d1:	76 af                	jbe    801482 <malloc+0xd7>
  8014d3:	eb 01                	jmp    8014d6 <malloc+0x12b>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == numOfPages) {
			break;
  8014d5:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
  8014d6:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8014da:	74 08                	je     8014e4 <malloc+0x139>
  8014dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014df:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8014e2:	74 07                	je     8014eb <malloc+0x140>
		return NULL;
  8014e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8014e9:	eb 74                	jmp    80155f <malloc+0x1b4>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  8014eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014ee:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8014f1:	c1 e8 0c             	shr    $0xc,%eax
  8014f4:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numOfPages;
  8014f7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8014fa:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8014fd:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  801504:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801507:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80150a:	eb 11                	jmp    80151d <malloc+0x172>
		markedPages[i] = 1;
  80150c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80150f:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  801516:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = numOfPages;
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  80151a:	ff 45 e8             	incl   -0x18(%ebp)
  80151d:	8b 55 c0             	mov    -0x40(%ebp),%edx
  801520:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801523:	01 d0                	add    %edx,%eax
  801525:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801528:	77 e2                	ja     80150c <malloc+0x161>
		markedPages[i] = 1;
	}

	sys_allocate_user_mem(start, ROUNDUP(size, PAGE_SIZE));
  80152a:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801531:	8b 55 08             	mov    0x8(%ebp),%edx
  801534:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801537:	01 d0                	add    %edx,%eax
  801539:	48                   	dec    %eax
  80153a:	89 45 b8             	mov    %eax,-0x48(%ebp)
  80153d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801540:	ba 00 00 00 00       	mov    $0x0,%edx
  801545:	f7 75 bc             	divl   -0x44(%ebp)
  801548:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80154b:	29 d0                	sub    %edx,%eax
  80154d:	83 ec 08             	sub    $0x8,%esp
  801550:	50                   	push   %eax
  801551:	ff 75 f0             	pushl  -0x10(%ebp)
  801554:	e8 14 0b 00 00       	call   80206d <sys_allocate_user_mem>
  801559:	83 c4 10             	add    $0x10,%esp
	return (void*) start;
  80155c:	8b 45 f0             	mov    -0x10(%ebp),%eax

}
  80155f:	c9                   	leave  
  801560:	c3                   	ret    

00801561 <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address) {
  801561:	55                   	push   %ebp
  801562:	89 e5                	mov    %esp,%ebp
  801564:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
  801567:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80156b:	0f 84 ee 00 00 00    	je     80165f <free+0xfe>
		return;
	}

	if (virtual_address
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  801571:	a1 20 50 80 00       	mov    0x805020,%eax
  801576:	8b 40 74             	mov    0x74(%eax),%eax

	if (virtual_address == NULL) {
		return;
	}

	if (virtual_address
  801579:	3b 45 08             	cmp    0x8(%ebp),%eax
  80157c:	77 09                	ja     801587 <free+0x26>
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  80157e:	81 7d 08 00 00 00 a0 	cmpl   $0xa0000000,0x8(%ebp)
  801585:	76 14                	jbe    80159b <free+0x3a>
		panic("INVALID VIRTUAL ADDRESS!!");
  801587:	83 ec 04             	sub    $0x4,%esp
  80158a:	68 f8 3e 80 00       	push   $0x803ef8
  80158f:	6a 68                	push   $0x68
  801591:	68 12 3f 80 00       	push   $0x803f12
  801596:	e8 94 1f 00 00       	call   80352f <_panic>
	}
	if (virtual_address >= (void *) (myEnv->uheapStart)
  80159b:	a1 20 50 80 00       	mov    0x805020,%eax
  8015a0:	8b 40 74             	mov    0x74(%eax),%eax
  8015a3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8015a6:	77 20                	ja     8015c8 <free+0x67>
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
  8015a8:	a1 20 50 80 00       	mov    0x805020,%eax
  8015ad:	8b 40 78             	mov    0x78(%eax),%eax
  8015b0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8015b3:	76 13                	jbe    8015c8 <free+0x67>
		free_block(virtual_address);
  8015b5:	83 ec 0c             	sub    $0xc,%esp
  8015b8:	ff 75 08             	pushl  0x8(%ebp)
  8015bb:	e8 6c 16 00 00       	call   802c2c <free_block>
  8015c0:	83 c4 10             	add    $0x10,%esp
		return;
  8015c3:	e9 98 00 00 00       	jmp    801660 <free+0xff>
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  8015c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8015cb:	a1 20 50 80 00       	mov    0x805020,%eax
  8015d0:	8b 40 7c             	mov    0x7c(%eax),%eax
  8015d3:	29 c2                	sub    %eax,%edx
  8015d5:	89 d0                	mov    %edx,%eax
  8015d7:	2d 00 10 00 00       	sub    $0x1000,%eax
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
		free_block(virtual_address);
		return;
	}

	uint32 pageIdx = ((uint32) virtual_address
  8015dc:	c1 e8 0c             	shr    $0xc,%eax
  8015df:	89 45 ec             	mov    %eax,-0x14(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  8015e2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8015e9:	eb 16                	jmp    801601 <free+0xa0>
		markedPages[idx + pageIdx] = 0;
  8015eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015f1:	01 d0                	add    %edx,%eax
  8015f3:	c7 04 85 40 50 90 00 	movl   $0x0,0x905040(,%eax,4)
  8015fa:	00 00 00 00 
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  8015fe:	ff 45 f4             	incl   -0xc(%ebp)
  801601:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801604:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  80160b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80160e:	7f db                	jg     8015eb <free+0x8a>
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;
  801610:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801613:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  80161a:	c1 e0 0c             	shl    $0xc,%eax
  80161d:	89 45 e8             	mov    %eax,-0x18(%ebp)

	for (uint32 i = (uint32) virtual_address;
  801620:	8b 45 08             	mov    0x8(%ebp),%eax
  801623:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801626:	eb 1a                	jmp    801642 <free+0xe1>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
  801628:	83 ec 08             	sub    $0x8,%esp
  80162b:	68 00 10 00 00       	push   $0x1000
  801630:	ff 75 f0             	pushl  -0x10(%ebp)
  801633:	e8 19 0a 00 00       	call   802051 <sys_free_user_mem>
  801638:	83 c4 10             	add    $0x10,%esp
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
  80163b:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  801642:	8b 55 08             	mov    0x8(%ebp),%edx
  801645:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801648:	01 d0                	add    %edx,%eax
	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
  80164a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80164d:	77 d9                	ja     801628 <free+0xc7>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;
  80164f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801652:	c7 04 85 40 50 80 00 	movl   $0x0,0x805040(,%eax,4)
  801659:	00 00 00 00 
  80165d:	eb 01                	jmp    801660 <free+0xff>
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
		return;
  80165f:	90                   	nop
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;

}
  801660:	c9                   	leave  
  801661:	c3                   	ret    

00801662 <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  801662:	55                   	push   %ebp
  801663:	89 e5                	mov    %esp,%ebp
  801665:	83 ec 58             	sub    $0x58,%esp
  801668:	8b 45 10             	mov    0x10(%ebp),%eax
  80166b:	88 45 b4             	mov    %al,-0x4c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  80166e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801672:	75 0a                	jne    80167e <smalloc+0x1c>
		return NULL;
  801674:	b8 00 00 00 00       	mov    $0x0,%eax
  801679:	e9 7d 01 00 00       	jmp    8017fb <smalloc+0x199>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	uint32 num_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  80167e:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  801685:	8b 55 0c             	mov    0xc(%ebp),%edx
  801688:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80168b:	01 d0                	add    %edx,%eax
  80168d:	48                   	dec    %eax
  80168e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801691:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801694:	ba 00 00 00 00       	mov    $0x0,%edx
  801699:	f7 75 e4             	divl   -0x1c(%ebp)
  80169c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80169f:	29 d0                	sub    %edx,%eax
  8016a1:	c1 e8 0c             	shr    $0xc,%eax
  8016a4:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 freePagesCount = 0;
  8016a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  8016ae:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  8016b5:	a1 20 50 80 00       	mov    0x805020,%eax
  8016ba:	8b 40 7c             	mov    0x7c(%eax),%eax
  8016bd:	05 00 10 00 00       	add    $0x1000,%eax
  8016c2:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  8016c5:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8016ca:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8016cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  8016d0:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  8016d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016da:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8016dd:	01 d0                	add    %edx,%eax
  8016df:	48                   	dec    %eax
  8016e0:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8016e3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8016e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8016eb:	f7 75 d0             	divl   -0x30(%ebp)
  8016ee:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8016f1:	29 d0                	sub    %edx,%eax
  8016f3:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8016f6:	76 0a                	jbe    801702 <smalloc+0xa0>
		return NULL;
  8016f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8016fd:	e9 f9 00 00 00       	jmp    8017fb <smalloc+0x199>
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801702:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801705:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801708:	eb 48                	jmp    801752 <smalloc+0xf0>
		uint32 idx = (s - currentAddr) / PAGE_SIZE;
  80170a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80170d:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801710:	c1 e8 0c             	shr    $0xc,%eax
  801713:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (!markedPages[idx]) {
  801716:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801719:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  801720:	85 c0                	test   %eax,%eax
  801722:	75 11                	jne    801735 <smalloc+0xd3>
			freePagesCount++;
  801724:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801727:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80172b:	75 16                	jne    801743 <smalloc+0xe1>
				start = s;
  80172d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801730:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801733:	eb 0e                	jmp    801743 <smalloc+0xe1>
			}
		} else {
			freePagesCount = 0;
  801735:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  80173c:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == num_Of_Pages) {
  801743:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801746:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801749:	74 12                	je     80175d <smalloc+0xfb>
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  80174b:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801752:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801759:	76 af                	jbe    80170a <smalloc+0xa8>
  80175b:	eb 01                	jmp    80175e <smalloc+0xfc>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == num_Of_Pages) {
			break;
  80175d:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
  80175e:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801762:	74 08                	je     80176c <smalloc+0x10a>
  801764:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801767:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80176a:	74 0a                	je     801776 <smalloc+0x114>
		return NULL;
  80176c:	b8 00 00 00 00       	mov    $0x0,%eax
  801771:	e9 85 00 00 00       	jmp    8017fb <smalloc+0x199>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  801776:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801779:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80177c:	c1 e8 0c             	shr    $0xc,%eax
  80177f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	pagesAllocated[startPage] = num_Of_Pages;
  801782:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801785:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801788:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  80178f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801792:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801795:	eb 11                	jmp    8017a8 <smalloc+0x146>
		markedPages[s] = 1;
  801797:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80179a:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  8017a1:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = num_Of_Pages;
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  8017a5:	ff 45 e8             	incl   -0x18(%ebp)
  8017a8:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8017ab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8017ae:	01 d0                	add    %edx,%eax
  8017b0:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8017b3:	77 e2                	ja     801797 <smalloc+0x135>
		markedPages[s] = 1;
	}
	int sharedobjID = sys_createSharedObject(sharedVarName, size, isWritable,
  8017b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017b8:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
  8017bc:	52                   	push   %edx
  8017bd:	50                   	push   %eax
  8017be:	ff 75 0c             	pushl  0xc(%ebp)
  8017c1:	ff 75 08             	pushl  0x8(%ebp)
  8017c4:	e8 8f 04 00 00       	call   801c58 <sys_createSharedObject>
  8017c9:	83 c4 10             	add    $0x10,%esp
  8017cc:	89 45 c0             	mov    %eax,-0x40(%ebp)
			(void*) start);

	if (sharedobjID >= 0) {
  8017cf:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  8017d3:	78 12                	js     8017e7 <smalloc+0x185>
		shardIDs[startPage] = sharedobjID;
  8017d5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8017d8:	8b 55 c0             	mov    -0x40(%ebp),%edx
  8017db:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  8017e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017e5:	eb 14                	jmp    8017fb <smalloc+0x199>
	}
	free((void*) start);
  8017e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ea:	83 ec 0c             	sub    $0xc,%esp
  8017ed:	50                   	push   %eax
  8017ee:	e8 6e fd ff ff       	call   801561 <free>
  8017f3:	83 c4 10             	add    $0x10,%esp
	return NULL;
  8017f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017fb:	c9                   	leave  
  8017fc:	c3                   	ret    

008017fd <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  8017fd:	55                   	push   %ebp
  8017fe:	89 e5                	mov    %esp,%ebp
  801800:	83 ec 48             	sub    $0x48,%esp
	//cprintf("SSSSSGEEETTT\n");
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID, sharedVarName);
  801803:	83 ec 08             	sub    $0x8,%esp
  801806:	ff 75 0c             	pushl  0xc(%ebp)
  801809:	ff 75 08             	pushl  0x8(%ebp)
  80180c:	e8 71 04 00 00       	call   801c82 <sys_getSizeOfSharedObject>
  801811:	83 c4 10             	add    $0x10,%esp
  801814:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (size < 0)
		return NULL;
	uint32 numb_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801817:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80181e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801821:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801824:	01 d0                	add    %edx,%eax
  801826:	48                   	dec    %eax
  801827:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80182a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80182d:	ba 00 00 00 00       	mov    $0x0,%edx
  801832:	f7 75 e0             	divl   -0x20(%ebp)
  801835:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801838:	29 d0                	sub    %edx,%eax
  80183a:	c1 e8 0c             	shr    $0xc,%eax
  80183d:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 free_Pages_Count = 0;
  801840:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801847:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
  80184e:	a1 20 50 80 00       	mov    0x805020,%eax
  801853:	8b 40 7c             	mov    0x7c(%eax),%eax
  801856:	05 00 10 00 00       	add    $0x1000,%eax
  80185b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
  80185e:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801863:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801866:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
  801869:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  801870:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801873:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801876:	01 d0                	add    %edx,%eax
  801878:	48                   	dec    %eax
  801879:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80187c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80187f:	ba 00 00 00 00       	mov    $0x0,%edx
  801884:	f7 75 cc             	divl   -0x34(%ebp)
  801887:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80188a:	29 d0                	sub    %edx,%eax
  80188c:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80188f:	76 0a                	jbe    80189b <sget+0x9e>
		return NULL;
  801891:	b8 00 00 00 00       	mov    $0x0,%eax
  801896:	e9 f7 00 00 00       	jmp    801992 <sget+0x195>
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  80189b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80189e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8018a1:	eb 48                	jmp    8018eb <sget+0xee>
		uint32 idx = (s - current_Addr) / PAGE_SIZE;
  8018a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018a6:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8018a9:	c1 e8 0c             	shr    $0xc,%eax
  8018ac:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if (!markedPages[idx]) {
  8018af:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8018b2:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  8018b9:	85 c0                	test   %eax,%eax
  8018bb:	75 11                	jne    8018ce <sget+0xd1>
			free_Pages_Count++;
  8018bd:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  8018c0:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8018c4:	75 16                	jne    8018dc <sget+0xdf>
				start = s;
  8018c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8018cc:	eb 0e                	jmp    8018dc <sget+0xdf>
			}
		} else {
			free_Pages_Count = 0;
  8018ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  8018d5:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (free_Pages_Count == numb_Of_Pages) {
  8018dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018df:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8018e2:	74 12                	je     8018f6 <sget+0xf9>
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
		return NULL;
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  8018e4:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  8018eb:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  8018f2:	76 af                	jbe    8018a3 <sget+0xa6>
  8018f4:	eb 01                	jmp    8018f7 <sget+0xfa>
		} else {
			free_Pages_Count = 0;
			start = (uint32) -1;
		}
		if (free_Pages_Count == numb_Of_Pages) {
			break;
  8018f6:	90                   	nop
		}
	}
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
  8018f7:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8018fb:	74 08                	je     801905 <sget+0x108>
  8018fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801900:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801903:	74 0a                	je     80190f <sget+0x112>
		return NULL;
  801905:	b8 00 00 00 00       	mov    $0x0,%eax
  80190a:	e9 83 00 00 00       	jmp    801992 <sget+0x195>
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
  80190f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801912:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801915:	c1 e8 0c             	shr    $0xc,%eax
  801918:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numb_Of_Pages;
  80191b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80191e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801921:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  801928:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80192b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80192e:	eb 11                	jmp    801941 <sget+0x144>
		markedPages[k] = 1;
  801930:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801933:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  80193a:	01 00 00 00 
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
	pagesAllocated[startPage] = numb_Of_Pages;
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  80193e:	ff 45 e8             	incl   -0x18(%ebp)
  801941:	8b 55 c0             	mov    -0x40(%ebp),%edx
  801944:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801947:	01 d0                	add    %edx,%eax
  801949:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80194c:	77 e2                	ja     801930 <sget+0x133>
		markedPages[k] = 1;
	}
	int ss = sys_getSharedObject(ownerEnvID, sharedVarName, (void*) start);
  80194e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801951:	83 ec 04             	sub    $0x4,%esp
  801954:	50                   	push   %eax
  801955:	ff 75 0c             	pushl  0xc(%ebp)
  801958:	ff 75 08             	pushl  0x8(%ebp)
  80195b:	e8 3f 03 00 00       	call   801c9f <sys_getSharedObject>
  801960:	83 c4 10             	add    $0x10,%esp
  801963:	89 45 bc             	mov    %eax,-0x44(%ebp)
	if (ss >= 0) {
  801966:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  80196a:	78 12                	js     80197e <sget+0x181>
		shardIDs[startPage] = ss;
  80196c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80196f:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801972:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  801979:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80197c:	eb 14                	jmp    801992 <sget+0x195>
	}
	free((void*) start);
  80197e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801981:	83 ec 0c             	sub    $0xc,%esp
  801984:	50                   	push   %eax
  801985:	e8 d7 fb ff ff       	call   801561 <free>
  80198a:	83 c4 10             	add    $0x10,%esp
	return NULL;
  80198d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801992:	c9                   	leave  
  801993:	c3                   	ret    

00801994 <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  801994:	55                   	push   %ebp
  801995:	89 e5                	mov    %esp,%ebp
  801997:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  80199a:	8b 55 08             	mov    0x8(%ebp),%edx
  80199d:	a1 20 50 80 00       	mov    0x805020,%eax
  8019a2:	8b 40 7c             	mov    0x7c(%eax),%eax
  8019a5:	29 c2                	sub    %eax,%edx
  8019a7:	89 d0                	mov    %edx,%eax
  8019a9:	2d 00 10 00 00       	sub    $0x1000,%eax

void sfree(void* virtual_address) {
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
  8019ae:	c1 e8 0c             	shr    $0xc,%eax
  8019b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
	int id = shardIDs[pageIdx];
  8019b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019b7:	8b 04 85 40 50 88 00 	mov    0x885040(,%eax,4),%eax
  8019be:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int result = sys_freeSharedObject(id, virtual_address);
  8019c1:	83 ec 08             	sub    $0x8,%esp
  8019c4:	ff 75 08             	pushl  0x8(%ebp)
  8019c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8019ca:	e8 ef 02 00 00       	call   801cbe <sys_freeSharedObject>
  8019cf:	83 c4 10             	add    $0x10,%esp
  8019d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (result == 0) {
  8019d5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8019d9:	75 0e                	jne    8019e9 <sfree+0x55>
		shardIDs[pageIdx] = -1;  // Reset the ID after freeing
  8019db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019de:	c7 04 85 40 50 88 00 	movl   $0xffffffff,0x885040(,%eax,4)
  8019e5:	ff ff ff ff 
	}

}
  8019e9:	90                   	nop
  8019ea:	c9                   	leave  
  8019eb:	c3                   	ret    

008019ec <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  8019ec:	55                   	push   %ebp
  8019ed:	89 e5                	mov    %esp,%ebp
  8019ef:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8019f2:	83 ec 04             	sub    $0x4,%esp
  8019f5:	68 20 3f 80 00       	push   $0x803f20
  8019fa:	68 19 01 00 00       	push   $0x119
  8019ff:	68 12 3f 80 00       	push   $0x803f12
  801a04:	e8 26 1b 00 00       	call   80352f <_panic>

00801a09 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  801a09:	55                   	push   %ebp
  801a0a:	89 e5                	mov    %esp,%ebp
  801a0c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a0f:	83 ec 04             	sub    $0x4,%esp
  801a12:	68 46 3f 80 00       	push   $0x803f46
  801a17:	68 23 01 00 00       	push   $0x123
  801a1c:	68 12 3f 80 00       	push   $0x803f12
  801a21:	e8 09 1b 00 00       	call   80352f <_panic>

00801a26 <shrink>:

}
void shrink(uint32 newSize) {
  801a26:	55                   	push   %ebp
  801a27:	89 e5                	mov    %esp,%ebp
  801a29:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a2c:	83 ec 04             	sub    $0x4,%esp
  801a2f:	68 46 3f 80 00       	push   $0x803f46
  801a34:	68 27 01 00 00       	push   $0x127
  801a39:	68 12 3f 80 00       	push   $0x803f12
  801a3e:	e8 ec 1a 00 00       	call   80352f <_panic>

00801a43 <freeHeap>:

}
void freeHeap(void* virtual_address) {
  801a43:	55                   	push   %ebp
  801a44:	89 e5                	mov    %esp,%ebp
  801a46:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a49:	83 ec 04             	sub    $0x4,%esp
  801a4c:	68 46 3f 80 00       	push   $0x803f46
  801a51:	68 2b 01 00 00       	push   $0x12b
  801a56:	68 12 3f 80 00       	push   $0x803f12
  801a5b:	e8 cf 1a 00 00       	call   80352f <_panic>

00801a60 <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  801a60:	55                   	push   %ebp
  801a61:	89 e5                	mov    %esp,%ebp
  801a63:	57                   	push   %edi
  801a64:	56                   	push   %esi
  801a65:	53                   	push   %ebx
  801a66:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a69:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a6f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a72:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a75:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a78:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a7b:	cd 30                	int    $0x30
  801a7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  801a80:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a83:	83 c4 10             	add    $0x10,%esp
  801a86:	5b                   	pop    %ebx
  801a87:	5e                   	pop    %esi
  801a88:	5f                   	pop    %edi
  801a89:	5d                   	pop    %ebp
  801a8a:	c3                   	ret    

00801a8b <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  801a8b:	55                   	push   %ebp
  801a8c:	89 e5                	mov    %esp,%ebp
  801a8e:	83 ec 04             	sub    $0x4,%esp
  801a91:	8b 45 10             	mov    0x10(%ebp),%eax
  801a94:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  801a97:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	52                   	push   %edx
  801aa3:	ff 75 0c             	pushl  0xc(%ebp)
  801aa6:	50                   	push   %eax
  801aa7:	6a 00                	push   $0x0
  801aa9:	e8 b2 ff ff ff       	call   801a60 <syscall>
  801aae:	83 c4 18             	add    $0x18,%esp
}
  801ab1:	90                   	nop
  801ab2:	c9                   	leave  
  801ab3:	c3                   	ret    

00801ab4 <sys_cgetc>:

int sys_cgetc(void) {
  801ab4:	55                   	push   %ebp
  801ab5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 02                	push   $0x2
  801ac3:	e8 98 ff ff ff       	call   801a60 <syscall>
  801ac8:	83 c4 18             	add    $0x18,%esp
}
  801acb:	c9                   	leave  
  801acc:	c3                   	ret    

00801acd <sys_lock_cons>:

void sys_lock_cons(void) {
  801acd:	55                   	push   %ebp
  801ace:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 03                	push   $0x3
  801adc:	e8 7f ff ff ff       	call   801a60 <syscall>
  801ae1:	83 c4 18             	add    $0x18,%esp
}
  801ae4:	90                   	nop
  801ae5:	c9                   	leave  
  801ae6:	c3                   	ret    

00801ae7 <sys_unlock_cons>:
void sys_unlock_cons(void) {
  801ae7:	55                   	push   %ebp
  801ae8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 04                	push   $0x4
  801af6:	e8 65 ff ff ff       	call   801a60 <syscall>
  801afb:	83 c4 18             	add    $0x18,%esp
}
  801afe:	90                   	nop
  801aff:	c9                   	leave  
  801b00:	c3                   	ret    

00801b01 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  801b01:	55                   	push   %ebp
  801b02:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  801b04:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b07:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	52                   	push   %edx
  801b11:	50                   	push   %eax
  801b12:	6a 08                	push   $0x8
  801b14:	e8 47 ff ff ff       	call   801a60 <syscall>
  801b19:	83 c4 18             	add    $0x18,%esp
}
  801b1c:	c9                   	leave  
  801b1d:	c3                   	ret    

00801b1e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  801b1e:	55                   	push   %ebp
  801b1f:	89 e5                	mov    %esp,%ebp
  801b21:	56                   	push   %esi
  801b22:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  801b23:	8b 75 18             	mov    0x18(%ebp),%esi
  801b26:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b29:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b32:	56                   	push   %esi
  801b33:	53                   	push   %ebx
  801b34:	51                   	push   %ecx
  801b35:	52                   	push   %edx
  801b36:	50                   	push   %eax
  801b37:	6a 09                	push   $0x9
  801b39:	e8 22 ff ff ff       	call   801a60 <syscall>
  801b3e:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  801b41:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b44:	5b                   	pop    %ebx
  801b45:	5e                   	pop    %esi
  801b46:	5d                   	pop    %ebp
  801b47:	c3                   	ret    

00801b48 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  801b48:	55                   	push   %ebp
  801b49:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801b4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	52                   	push   %edx
  801b58:	50                   	push   %eax
  801b59:	6a 0a                	push   $0xa
  801b5b:	e8 00 ff ff ff       	call   801a60 <syscall>
  801b60:	83 c4 18             	add    $0x18,%esp
}
  801b63:	c9                   	leave  
  801b64:	c3                   	ret    

00801b65 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  801b65:	55                   	push   %ebp
  801b66:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	ff 75 0c             	pushl  0xc(%ebp)
  801b71:	ff 75 08             	pushl  0x8(%ebp)
  801b74:	6a 0b                	push   $0xb
  801b76:	e8 e5 fe ff ff       	call   801a60 <syscall>
  801b7b:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  801b7e:	c9                   	leave  
  801b7f:	c3                   	ret    

00801b80 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  801b80:	55                   	push   %ebp
  801b81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 0c                	push   $0xc
  801b8f:	e8 cc fe ff ff       	call   801a60 <syscall>
  801b94:	83 c4 18             	add    $0x18,%esp
}
  801b97:	c9                   	leave  
  801b98:	c3                   	ret    

00801b99 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  801b99:	55                   	push   %ebp
  801b9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 0d                	push   $0xd
  801ba8:	e8 b3 fe ff ff       	call   801a60 <syscall>
  801bad:	83 c4 18             	add    $0x18,%esp
}
  801bb0:	c9                   	leave  
  801bb1:	c3                   	ret    

00801bb2 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  801bb2:	55                   	push   %ebp
  801bb3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 0e                	push   $0xe
  801bc1:	e8 9a fe ff ff       	call   801a60 <syscall>
  801bc6:	83 c4 18             	add    $0x18,%esp
}
  801bc9:	c9                   	leave  
  801bca:	c3                   	ret    

00801bcb <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  801bcb:	55                   	push   %ebp
  801bcc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 0f                	push   $0xf
  801bda:	e8 81 fe ff ff       	call   801a60 <syscall>
  801bdf:	83 c4 18             	add    $0x18,%esp
}
  801be2:	c9                   	leave  
  801be3:	c3                   	ret    

00801be4 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  801be4:	55                   	push   %ebp
  801be5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	ff 75 08             	pushl  0x8(%ebp)
  801bf2:	6a 10                	push   $0x10
  801bf4:	e8 67 fe ff ff       	call   801a60 <syscall>
  801bf9:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  801bfc:	c9                   	leave  
  801bfd:	c3                   	ret    

00801bfe <sys_scarce_memory>:

void sys_scarce_memory() {
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 11                	push   $0x11
  801c0d:	e8 4e fe ff ff       	call   801a60 <syscall>
  801c12:	83 c4 18             	add    $0x18,%esp
}
  801c15:	90                   	nop
  801c16:	c9                   	leave  
  801c17:	c3                   	ret    

00801c18 <sys_cputc>:

void sys_cputc(const char c) {
  801c18:	55                   	push   %ebp
  801c19:	89 e5                	mov    %esp,%ebp
  801c1b:	83 ec 04             	sub    $0x4,%esp
  801c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c21:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c24:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	50                   	push   %eax
  801c31:	6a 01                	push   $0x1
  801c33:	e8 28 fe ff ff       	call   801a60 <syscall>
  801c38:	83 c4 18             	add    $0x18,%esp
}
  801c3b:	90                   	nop
  801c3c:	c9                   	leave  
  801c3d:	c3                   	ret    

00801c3e <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  801c3e:	55                   	push   %ebp
  801c3f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	6a 00                	push   $0x0
  801c47:	6a 00                	push   $0x0
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 14                	push   $0x14
  801c4d:	e8 0e fe ff ff       	call   801a60 <syscall>
  801c52:	83 c4 18             	add    $0x18,%esp
}
  801c55:	90                   	nop
  801c56:	c9                   	leave  
  801c57:	c3                   	ret    

00801c58 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  801c58:	55                   	push   %ebp
  801c59:	89 e5                	mov    %esp,%ebp
  801c5b:	83 ec 04             	sub    $0x4,%esp
  801c5e:	8b 45 10             	mov    0x10(%ebp),%eax
  801c61:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  801c64:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c67:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6e:	6a 00                	push   $0x0
  801c70:	51                   	push   %ecx
  801c71:	52                   	push   %edx
  801c72:	ff 75 0c             	pushl  0xc(%ebp)
  801c75:	50                   	push   %eax
  801c76:	6a 15                	push   $0x15
  801c78:	e8 e3 fd ff ff       	call   801a60 <syscall>
  801c7d:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  801c80:	c9                   	leave  
  801c81:	c3                   	ret    

00801c82 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  801c82:	55                   	push   %ebp
  801c83:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  801c85:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c88:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	52                   	push   %edx
  801c92:	50                   	push   %eax
  801c93:	6a 16                	push   $0x16
  801c95:	e8 c6 fd ff ff       	call   801a60 <syscall>
  801c9a:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  801c9d:	c9                   	leave  
  801c9e:	c3                   	ret    

00801c9f <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  801c9f:	55                   	push   %ebp
  801ca0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  801ca2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ca5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	51                   	push   %ecx
  801cb0:	52                   	push   %edx
  801cb1:	50                   	push   %eax
  801cb2:	6a 17                	push   $0x17
  801cb4:	e8 a7 fd ff ff       	call   801a60 <syscall>
  801cb9:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  801cbc:	c9                   	leave  
  801cbd:	c3                   	ret    

00801cbe <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  801cbe:	55                   	push   %ebp
  801cbf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  801cc1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	52                   	push   %edx
  801cce:	50                   	push   %eax
  801ccf:	6a 18                	push   $0x18
  801cd1:	e8 8a fd ff ff       	call   801a60 <syscall>
  801cd6:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  801cd9:	c9                   	leave  
  801cda:	c3                   	ret    

00801cdb <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  801cdb:	55                   	push   %ebp
  801cdc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  801cde:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce1:	6a 00                	push   $0x0
  801ce3:	ff 75 14             	pushl  0x14(%ebp)
  801ce6:	ff 75 10             	pushl  0x10(%ebp)
  801ce9:	ff 75 0c             	pushl  0xc(%ebp)
  801cec:	50                   	push   %eax
  801ced:	6a 19                	push   $0x19
  801cef:	e8 6c fd ff ff       	call   801a60 <syscall>
  801cf4:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  801cf7:	c9                   	leave  
  801cf8:	c3                   	ret    

00801cf9 <sys_run_env>:

void sys_run_env(int32 envId) {
  801cf9:	55                   	push   %ebp
  801cfa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  801cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	50                   	push   %eax
  801d08:	6a 1a                	push   $0x1a
  801d0a:	e8 51 fd ff ff       	call   801a60 <syscall>
  801d0f:	83 c4 18             	add    $0x18,%esp
}
  801d12:	90                   	nop
  801d13:	c9                   	leave  
  801d14:	c3                   	ret    

00801d15 <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  801d15:	55                   	push   %ebp
  801d16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801d18:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	50                   	push   %eax
  801d24:	6a 1b                	push   $0x1b
  801d26:	e8 35 fd ff ff       	call   801a60 <syscall>
  801d2b:	83 c4 18             	add    $0x18,%esp
}
  801d2e:	c9                   	leave  
  801d2f:	c3                   	ret    

00801d30 <sys_getenvid>:

int32 sys_getenvid(void) {
  801d30:	55                   	push   %ebp
  801d31:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d33:	6a 00                	push   $0x0
  801d35:	6a 00                	push   $0x0
  801d37:	6a 00                	push   $0x0
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 05                	push   $0x5
  801d3f:	e8 1c fd ff ff       	call   801a60 <syscall>
  801d44:	83 c4 18             	add    $0x18,%esp
}
  801d47:	c9                   	leave  
  801d48:	c3                   	ret    

00801d49 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  801d49:	55                   	push   %ebp
  801d4a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	6a 06                	push   $0x6
  801d58:	e8 03 fd ff ff       	call   801a60 <syscall>
  801d5d:	83 c4 18             	add    $0x18,%esp
}
  801d60:	c9                   	leave  
  801d61:	c3                   	ret    

00801d62 <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  801d62:	55                   	push   %ebp
  801d63:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d65:	6a 00                	push   $0x0
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 07                	push   $0x7
  801d71:	e8 ea fc ff ff       	call   801a60 <syscall>
  801d76:	83 c4 18             	add    $0x18,%esp
}
  801d79:	c9                   	leave  
  801d7a:	c3                   	ret    

00801d7b <sys_exit_env>:

void sys_exit_env(void) {
  801d7b:	55                   	push   %ebp
  801d7c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 00                	push   $0x0
  801d82:	6a 00                	push   $0x0
  801d84:	6a 00                	push   $0x0
  801d86:	6a 00                	push   $0x0
  801d88:	6a 1c                	push   $0x1c
  801d8a:	e8 d1 fc ff ff       	call   801a60 <syscall>
  801d8f:	83 c4 18             	add    $0x18,%esp
}
  801d92:	90                   	nop
  801d93:	c9                   	leave  
  801d94:	c3                   	ret    

00801d95 <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  801d95:	55                   	push   %ebp
  801d96:	89 e5                	mov    %esp,%ebp
  801d98:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  801d9b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d9e:	8d 50 04             	lea    0x4(%eax),%edx
  801da1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	6a 00                	push   $0x0
  801daa:	52                   	push   %edx
  801dab:	50                   	push   %eax
  801dac:	6a 1d                	push   $0x1d
  801dae:	e8 ad fc ff ff       	call   801a60 <syscall>
  801db3:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  801db6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801db9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801dbc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801dbf:	89 01                	mov    %eax,(%ecx)
  801dc1:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc7:	c9                   	leave  
  801dc8:	c2 04 00             	ret    $0x4

00801dcb <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  801dcb:	55                   	push   %ebp
  801dcc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 00                	push   $0x0
  801dd2:	ff 75 10             	pushl  0x10(%ebp)
  801dd5:	ff 75 0c             	pushl  0xc(%ebp)
  801dd8:	ff 75 08             	pushl  0x8(%ebp)
  801ddb:	6a 13                	push   $0x13
  801ddd:	e8 7e fc ff ff       	call   801a60 <syscall>
  801de2:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  801de5:	90                   	nop
}
  801de6:	c9                   	leave  
  801de7:	c3                   	ret    

00801de8 <sys_rcr2>:
uint32 sys_rcr2() {
  801de8:	55                   	push   %ebp
  801de9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801deb:	6a 00                	push   $0x0
  801ded:	6a 00                	push   $0x0
  801def:	6a 00                	push   $0x0
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	6a 1e                	push   $0x1e
  801df7:	e8 64 fc ff ff       	call   801a60 <syscall>
  801dfc:	83 c4 18             	add    $0x18,%esp
}
  801dff:	c9                   	leave  
  801e00:	c3                   	ret    

00801e01 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  801e01:	55                   	push   %ebp
  801e02:	89 e5                	mov    %esp,%ebp
  801e04:	83 ec 04             	sub    $0x4,%esp
  801e07:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e0d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	6a 00                	push   $0x0
  801e19:	50                   	push   %eax
  801e1a:	6a 1f                	push   $0x1f
  801e1c:	e8 3f fc ff ff       	call   801a60 <syscall>
  801e21:	83 c4 18             	add    $0x18,%esp
	return;
  801e24:	90                   	nop
}
  801e25:	c9                   	leave  
  801e26:	c3                   	ret    

00801e27 <rsttst>:
void rsttst() {
  801e27:	55                   	push   %ebp
  801e28:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 00                	push   $0x0
  801e32:	6a 00                	push   $0x0
  801e34:	6a 21                	push   $0x21
  801e36:	e8 25 fc ff ff       	call   801a60 <syscall>
  801e3b:	83 c4 18             	add    $0x18,%esp
	return;
  801e3e:	90                   	nop
}
  801e3f:	c9                   	leave  
  801e40:	c3                   	ret    

00801e41 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  801e41:	55                   	push   %ebp
  801e42:	89 e5                	mov    %esp,%ebp
  801e44:	83 ec 04             	sub    $0x4,%esp
  801e47:	8b 45 14             	mov    0x14(%ebp),%eax
  801e4a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e4d:	8b 55 18             	mov    0x18(%ebp),%edx
  801e50:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e54:	52                   	push   %edx
  801e55:	50                   	push   %eax
  801e56:	ff 75 10             	pushl  0x10(%ebp)
  801e59:	ff 75 0c             	pushl  0xc(%ebp)
  801e5c:	ff 75 08             	pushl  0x8(%ebp)
  801e5f:	6a 20                	push   $0x20
  801e61:	e8 fa fb ff ff       	call   801a60 <syscall>
  801e66:	83 c4 18             	add    $0x18,%esp
	return;
  801e69:	90                   	nop
}
  801e6a:	c9                   	leave  
  801e6b:	c3                   	ret    

00801e6c <chktst>:
void chktst(uint32 n) {
  801e6c:	55                   	push   %ebp
  801e6d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	6a 00                	push   $0x0
  801e75:	6a 00                	push   $0x0
  801e77:	ff 75 08             	pushl  0x8(%ebp)
  801e7a:	6a 22                	push   $0x22
  801e7c:	e8 df fb ff ff       	call   801a60 <syscall>
  801e81:	83 c4 18             	add    $0x18,%esp
	return;
  801e84:	90                   	nop
}
  801e85:	c9                   	leave  
  801e86:	c3                   	ret    

00801e87 <inctst>:

void inctst() {
  801e87:	55                   	push   %ebp
  801e88:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e8a:	6a 00                	push   $0x0
  801e8c:	6a 00                	push   $0x0
  801e8e:	6a 00                	push   $0x0
  801e90:	6a 00                	push   $0x0
  801e92:	6a 00                	push   $0x0
  801e94:	6a 23                	push   $0x23
  801e96:	e8 c5 fb ff ff       	call   801a60 <syscall>
  801e9b:	83 c4 18             	add    $0x18,%esp
	return;
  801e9e:	90                   	nop
}
  801e9f:	c9                   	leave  
  801ea0:	c3                   	ret    

00801ea1 <gettst>:
uint32 gettst() {
  801ea1:	55                   	push   %ebp
  801ea2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801ea4:	6a 00                	push   $0x0
  801ea6:	6a 00                	push   $0x0
  801ea8:	6a 00                	push   $0x0
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 00                	push   $0x0
  801eae:	6a 24                	push   $0x24
  801eb0:	e8 ab fb ff ff       	call   801a60 <syscall>
  801eb5:	83 c4 18             	add    $0x18,%esp
}
  801eb8:	c9                   	leave  
  801eb9:	c3                   	ret    

00801eba <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  801eba:	55                   	push   %ebp
  801ebb:	89 e5                	mov    %esp,%ebp
  801ebd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 00                	push   $0x0
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 25                	push   $0x25
  801ecc:	e8 8f fb ff ff       	call   801a60 <syscall>
  801ed1:	83 c4 18             	add    $0x18,%esp
  801ed4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ed7:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801edb:	75 07                	jne    801ee4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801edd:	b8 01 00 00 00       	mov    $0x1,%eax
  801ee2:	eb 05                	jmp    801ee9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ee4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ee9:	c9                   	leave  
  801eea:	c3                   	ret    

00801eeb <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  801eeb:	55                   	push   %ebp
  801eec:	89 e5                	mov    %esp,%ebp
  801eee:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ef1:	6a 00                	push   $0x0
  801ef3:	6a 00                	push   $0x0
  801ef5:	6a 00                	push   $0x0
  801ef7:	6a 00                	push   $0x0
  801ef9:	6a 00                	push   $0x0
  801efb:	6a 25                	push   $0x25
  801efd:	e8 5e fb ff ff       	call   801a60 <syscall>
  801f02:	83 c4 18             	add    $0x18,%esp
  801f05:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f08:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f0c:	75 07                	jne    801f15 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f0e:	b8 01 00 00 00       	mov    $0x1,%eax
  801f13:	eb 05                	jmp    801f1a <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f15:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f1a:	c9                   	leave  
  801f1b:	c3                   	ret    

00801f1c <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  801f1c:	55                   	push   %ebp
  801f1d:	89 e5                	mov    %esp,%ebp
  801f1f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f22:	6a 00                	push   $0x0
  801f24:	6a 00                	push   $0x0
  801f26:	6a 00                	push   $0x0
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 00                	push   $0x0
  801f2c:	6a 25                	push   $0x25
  801f2e:	e8 2d fb ff ff       	call   801a60 <syscall>
  801f33:	83 c4 18             	add    $0x18,%esp
  801f36:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f39:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f3d:	75 07                	jne    801f46 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f3f:	b8 01 00 00 00       	mov    $0x1,%eax
  801f44:	eb 05                	jmp    801f4b <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f46:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f4b:	c9                   	leave  
  801f4c:	c3                   	ret    

00801f4d <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  801f4d:	55                   	push   %ebp
  801f4e:	89 e5                	mov    %esp,%ebp
  801f50:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f53:	6a 00                	push   $0x0
  801f55:	6a 00                	push   $0x0
  801f57:	6a 00                	push   $0x0
  801f59:	6a 00                	push   $0x0
  801f5b:	6a 00                	push   $0x0
  801f5d:	6a 25                	push   $0x25
  801f5f:	e8 fc fa ff ff       	call   801a60 <syscall>
  801f64:	83 c4 18             	add    $0x18,%esp
  801f67:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f6a:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f6e:	75 07                	jne    801f77 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f70:	b8 01 00 00 00       	mov    $0x1,%eax
  801f75:	eb 05                	jmp    801f7c <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f77:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f7c:	c9                   	leave  
  801f7d:	c3                   	ret    

00801f7e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  801f7e:	55                   	push   %ebp
  801f7f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f81:	6a 00                	push   $0x0
  801f83:	6a 00                	push   $0x0
  801f85:	6a 00                	push   $0x0
  801f87:	6a 00                	push   $0x0
  801f89:	ff 75 08             	pushl  0x8(%ebp)
  801f8c:	6a 26                	push   $0x26
  801f8e:	e8 cd fa ff ff       	call   801a60 <syscall>
  801f93:	83 c4 18             	add    $0x18,%esp
	return;
  801f96:	90                   	nop
}
  801f97:	c9                   	leave  
  801f98:	c3                   	ret    

00801f99 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  801f99:	55                   	push   %ebp
  801f9a:	89 e5                	mov    %esp,%ebp
  801f9c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  801f9d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fa0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fa3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa9:	6a 00                	push   $0x0
  801fab:	53                   	push   %ebx
  801fac:	51                   	push   %ecx
  801fad:	52                   	push   %edx
  801fae:	50                   	push   %eax
  801faf:	6a 27                	push   $0x27
  801fb1:	e8 aa fa ff ff       	call   801a60 <syscall>
  801fb6:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  801fb9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fbc:	c9                   	leave  
  801fbd:	c3                   	ret    

00801fbe <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  801fbe:	55                   	push   %ebp
  801fbf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  801fc1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc7:	6a 00                	push   $0x0
  801fc9:	6a 00                	push   $0x0
  801fcb:	6a 00                	push   $0x0
  801fcd:	52                   	push   %edx
  801fce:	50                   	push   %eax
  801fcf:	6a 28                	push   $0x28
  801fd1:	e8 8a fa ff ff       	call   801a60 <syscall>
  801fd6:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  801fd9:	c9                   	leave  
  801fda:	c3                   	ret    

00801fdb <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  801fdb:	55                   	push   %ebp
  801fdc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  801fde:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801fe1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe7:	6a 00                	push   $0x0
  801fe9:	51                   	push   %ecx
  801fea:	ff 75 10             	pushl  0x10(%ebp)
  801fed:	52                   	push   %edx
  801fee:	50                   	push   %eax
  801fef:	6a 29                	push   $0x29
  801ff1:	e8 6a fa ff ff       	call   801a60 <syscall>
  801ff6:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  801ff9:	c9                   	leave  
  801ffa:	c3                   	ret    

00801ffb <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  801ffb:	55                   	push   %ebp
  801ffc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ffe:	6a 00                	push   $0x0
  802000:	6a 00                	push   $0x0
  802002:	ff 75 10             	pushl  0x10(%ebp)
  802005:	ff 75 0c             	pushl  0xc(%ebp)
  802008:	ff 75 08             	pushl  0x8(%ebp)
  80200b:	6a 12                	push   $0x12
  80200d:	e8 4e fa ff ff       	call   801a60 <syscall>
  802012:	83 c4 18             	add    $0x18,%esp
	return;
  802015:	90                   	nop
}
  802016:	c9                   	leave  
  802017:	c3                   	ret    

00802018 <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  802018:	55                   	push   %ebp
  802019:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  80201b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80201e:	8b 45 08             	mov    0x8(%ebp),%eax
  802021:	6a 00                	push   $0x0
  802023:	6a 00                	push   $0x0
  802025:	6a 00                	push   $0x0
  802027:	52                   	push   %edx
  802028:	50                   	push   %eax
  802029:	6a 2a                	push   $0x2a
  80202b:	e8 30 fa ff ff       	call   801a60 <syscall>
  802030:	83 c4 18             	add    $0x18,%esp
	return;
  802033:	90                   	nop
}
  802034:	c9                   	leave  
  802035:	c3                   	ret    

00802036 <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  802036:	55                   	push   %ebp
  802037:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  802039:	8b 45 08             	mov    0x8(%ebp),%eax
  80203c:	6a 00                	push   $0x0
  80203e:	6a 00                	push   $0x0
  802040:	6a 00                	push   $0x0
  802042:	6a 00                	push   $0x0
  802044:	50                   	push   %eax
  802045:	6a 2b                	push   $0x2b
  802047:	e8 14 fa ff ff       	call   801a60 <syscall>
  80204c:	83 c4 18             	add    $0x18,%esp
}
  80204f:	c9                   	leave  
  802050:	c3                   	ret    

00802051 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  802051:	55                   	push   %ebp
  802052:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802054:	6a 00                	push   $0x0
  802056:	6a 00                	push   $0x0
  802058:	6a 00                	push   $0x0
  80205a:	ff 75 0c             	pushl  0xc(%ebp)
  80205d:	ff 75 08             	pushl  0x8(%ebp)
  802060:	6a 2c                	push   $0x2c
  802062:	e8 f9 f9 ff ff       	call   801a60 <syscall>
  802067:	83 c4 18             	add    $0x18,%esp
	return;
  80206a:	90                   	nop
}
  80206b:	c9                   	leave  
  80206c:	c3                   	ret    

0080206d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  80206d:	55                   	push   %ebp
  80206e:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802070:	6a 00                	push   $0x0
  802072:	6a 00                	push   $0x0
  802074:	6a 00                	push   $0x0
  802076:	ff 75 0c             	pushl  0xc(%ebp)
  802079:	ff 75 08             	pushl  0x8(%ebp)
  80207c:	6a 2d                	push   $0x2d
  80207e:	e8 dd f9 ff ff       	call   801a60 <syscall>
  802083:	83 c4 18             	add    $0x18,%esp
	return;
  802086:	90                   	nop
}
  802087:	c9                   	leave  
  802088:	c3                   	ret    

00802089 <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  802089:	55                   	push   %ebp
  80208a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  80208c:	8b 45 08             	mov    0x8(%ebp),%eax
  80208f:	6a 00                	push   $0x0
  802091:	6a 00                	push   $0x0
  802093:	6a 00                	push   $0x0
  802095:	6a 00                	push   $0x0
  802097:	50                   	push   %eax
  802098:	6a 2f                	push   $0x2f
  80209a:	e8 c1 f9 ff ff       	call   801a60 <syscall>
  80209f:	83 c4 18             	add    $0x18,%esp
	return;
  8020a2:	90                   	nop
}
  8020a3:	c9                   	leave  
  8020a4:	c3                   	ret    

008020a5 <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  8020a5:	55                   	push   %ebp
  8020a6:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  8020a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ae:	6a 00                	push   $0x0
  8020b0:	6a 00                	push   $0x0
  8020b2:	6a 00                	push   $0x0
  8020b4:	52                   	push   %edx
  8020b5:	50                   	push   %eax
  8020b6:	6a 30                	push   $0x30
  8020b8:	e8 a3 f9 ff ff       	call   801a60 <syscall>
  8020bd:	83 c4 18             	add    $0x18,%esp
	return;
  8020c0:	90                   	nop
}
  8020c1:	c9                   	leave  
  8020c2:	c3                   	ret    

008020c3 <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  8020c3:	55                   	push   %ebp
  8020c4:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  8020c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c9:	6a 00                	push   $0x0
  8020cb:	6a 00                	push   $0x0
  8020cd:	6a 00                	push   $0x0
  8020cf:	6a 00                	push   $0x0
  8020d1:	50                   	push   %eax
  8020d2:	6a 31                	push   $0x31
  8020d4:	e8 87 f9 ff ff       	call   801a60 <syscall>
  8020d9:	83 c4 18             	add    $0x18,%esp
	return;
  8020dc:	90                   	nop
}
  8020dd:	c9                   	leave  
  8020de:	c3                   	ret    

008020df <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  8020df:	55                   	push   %ebp
  8020e0:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8020e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e8:	6a 00                	push   $0x0
  8020ea:	6a 00                	push   $0x0
  8020ec:	6a 00                	push   $0x0
  8020ee:	52                   	push   %edx
  8020ef:	50                   	push   %eax
  8020f0:	6a 2e                	push   $0x2e
  8020f2:	e8 69 f9 ff ff       	call   801a60 <syscall>
  8020f7:	83 c4 18             	add    $0x18,%esp
    return;
  8020fa:	90                   	nop
}
  8020fb:	c9                   	leave  
  8020fc:	c3                   	ret    

008020fd <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  8020fd:	55                   	push   %ebp
  8020fe:	89 e5                	mov    %esp,%ebp
  802100:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802103:	8b 45 08             	mov    0x8(%ebp),%eax
  802106:	83 e8 04             	sub    $0x4,%eax
  802109:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  80210c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80210f:	8b 00                	mov    (%eax),%eax
  802111:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802114:	c9                   	leave  
  802115:	c3                   	ret    

00802116 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802116:	55                   	push   %ebp
  802117:	89 e5                	mov    %esp,%ebp
  802119:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80211c:	8b 45 08             	mov    0x8(%ebp),%eax
  80211f:	83 e8 04             	sub    $0x4,%eax
  802122:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802125:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802128:	8b 00                	mov    (%eax),%eax
  80212a:	83 e0 01             	and    $0x1,%eax
  80212d:	85 c0                	test   %eax,%eax
  80212f:	0f 94 c0             	sete   %al
}
  802132:	c9                   	leave  
  802133:	c3                   	ret    

00802134 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802134:	55                   	push   %ebp
  802135:	89 e5                	mov    %esp,%ebp
  802137:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  80213a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802141:	8b 45 0c             	mov    0xc(%ebp),%eax
  802144:	83 f8 02             	cmp    $0x2,%eax
  802147:	74 2b                	je     802174 <alloc_block+0x40>
  802149:	83 f8 02             	cmp    $0x2,%eax
  80214c:	7f 07                	jg     802155 <alloc_block+0x21>
  80214e:	83 f8 01             	cmp    $0x1,%eax
  802151:	74 0e                	je     802161 <alloc_block+0x2d>
  802153:	eb 58                	jmp    8021ad <alloc_block+0x79>
  802155:	83 f8 03             	cmp    $0x3,%eax
  802158:	74 2d                	je     802187 <alloc_block+0x53>
  80215a:	83 f8 04             	cmp    $0x4,%eax
  80215d:	74 3b                	je     80219a <alloc_block+0x66>
  80215f:	eb 4c                	jmp    8021ad <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802161:	83 ec 0c             	sub    $0xc,%esp
  802164:	ff 75 08             	pushl  0x8(%ebp)
  802167:	e8 f7 03 00 00       	call   802563 <alloc_block_FF>
  80216c:	83 c4 10             	add    $0x10,%esp
  80216f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802172:	eb 4a                	jmp    8021be <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802174:	83 ec 0c             	sub    $0xc,%esp
  802177:	ff 75 08             	pushl  0x8(%ebp)
  80217a:	e8 f0 11 00 00       	call   80336f <alloc_block_NF>
  80217f:	83 c4 10             	add    $0x10,%esp
  802182:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802185:	eb 37                	jmp    8021be <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802187:	83 ec 0c             	sub    $0xc,%esp
  80218a:	ff 75 08             	pushl  0x8(%ebp)
  80218d:	e8 08 08 00 00       	call   80299a <alloc_block_BF>
  802192:	83 c4 10             	add    $0x10,%esp
  802195:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802198:	eb 24                	jmp    8021be <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  80219a:	83 ec 0c             	sub    $0xc,%esp
  80219d:	ff 75 08             	pushl  0x8(%ebp)
  8021a0:	e8 ad 11 00 00       	call   803352 <alloc_block_WF>
  8021a5:	83 c4 10             	add    $0x10,%esp
  8021a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8021ab:	eb 11                	jmp    8021be <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8021ad:	83 ec 0c             	sub    $0xc,%esp
  8021b0:	68 58 3f 80 00       	push   $0x803f58
  8021b5:	e8 41 e4 ff ff       	call   8005fb <cprintf>
  8021ba:	83 c4 10             	add    $0x10,%esp
		break;
  8021bd:	90                   	nop
	}
	return va;
  8021be:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8021c1:	c9                   	leave  
  8021c2:	c3                   	ret    

008021c3 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8021c3:	55                   	push   %ebp
  8021c4:	89 e5                	mov    %esp,%ebp
  8021c6:	53                   	push   %ebx
  8021c7:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8021ca:	83 ec 0c             	sub    $0xc,%esp
  8021cd:	68 78 3f 80 00       	push   $0x803f78
  8021d2:	e8 24 e4 ff ff       	call   8005fb <cprintf>
  8021d7:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8021da:	83 ec 0c             	sub    $0xc,%esp
  8021dd:	68 a3 3f 80 00       	push   $0x803fa3
  8021e2:	e8 14 e4 ff ff       	call   8005fb <cprintf>
  8021e7:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8021ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021f0:	eb 37                	jmp    802229 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8021f2:	83 ec 0c             	sub    $0xc,%esp
  8021f5:	ff 75 f4             	pushl  -0xc(%ebp)
  8021f8:	e8 19 ff ff ff       	call   802116 <is_free_block>
  8021fd:	83 c4 10             	add    $0x10,%esp
  802200:	0f be d8             	movsbl %al,%ebx
  802203:	83 ec 0c             	sub    $0xc,%esp
  802206:	ff 75 f4             	pushl  -0xc(%ebp)
  802209:	e8 ef fe ff ff       	call   8020fd <get_block_size>
  80220e:	83 c4 10             	add    $0x10,%esp
  802211:	83 ec 04             	sub    $0x4,%esp
  802214:	53                   	push   %ebx
  802215:	50                   	push   %eax
  802216:	68 bb 3f 80 00       	push   $0x803fbb
  80221b:	e8 db e3 ff ff       	call   8005fb <cprintf>
  802220:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802223:	8b 45 10             	mov    0x10(%ebp),%eax
  802226:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802229:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80222d:	74 07                	je     802236 <print_blocks_list+0x73>
  80222f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802232:	8b 00                	mov    (%eax),%eax
  802234:	eb 05                	jmp    80223b <print_blocks_list+0x78>
  802236:	b8 00 00 00 00       	mov    $0x0,%eax
  80223b:	89 45 10             	mov    %eax,0x10(%ebp)
  80223e:	8b 45 10             	mov    0x10(%ebp),%eax
  802241:	85 c0                	test   %eax,%eax
  802243:	75 ad                	jne    8021f2 <print_blocks_list+0x2f>
  802245:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802249:	75 a7                	jne    8021f2 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  80224b:	83 ec 0c             	sub    $0xc,%esp
  80224e:	68 78 3f 80 00       	push   $0x803f78
  802253:	e8 a3 e3 ff ff       	call   8005fb <cprintf>
  802258:	83 c4 10             	add    $0x10,%esp

}
  80225b:	90                   	nop
  80225c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80225f:	c9                   	leave  
  802260:	c3                   	ret    

00802261 <initialize_dynamic_allocator>:

//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802261:	55                   	push   %ebp
  802262:	89 e5                	mov    %esp,%ebp
  802264:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802267:	8b 45 0c             	mov    0xc(%ebp),%eax
  80226a:	83 e0 01             	and    $0x1,%eax
  80226d:	85 c0                	test   %eax,%eax
  80226f:	74 03                	je     802274 <initialize_dynamic_allocator+0x13>
  802271:	ff 45 0c             	incl   0xc(%ebp)
		if (initSizeOfAllocatedSpace == 0)
  802274:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802278:	0f 84 f8 00 00 00    	je     802376 <initialize_dynamic_allocator+0x115>
			return ;
		is_initialized = 1;
  80227e:	c7 05 40 50 98 00 01 	movl   $0x1,0x985040
  802285:	00 00 00 
	//TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("initialize_dynamic_allocator is not implemented yet");
	//Your Code is Here...

	if(is_initialized){
  802288:	a1 40 50 98 00       	mov    0x985040,%eax
  80228d:	85 c0                	test   %eax,%eax
  80228f:	0f 84 e2 00 00 00    	je     802377 <initialize_dynamic_allocator+0x116>

		// begin block with size 0 and lsb = 1 (allocated)
		uint32* beginBlock = (uint32*)daStart;
  802295:	8b 45 08             	mov    0x8(%ebp),%eax
  802298:	89 45 f4             	mov    %eax,-0xc(%ebp)
		*beginBlock = 0 | 1; // size = 0, LSB as a flag = 1
  80229b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		// end block with size 0 and lsb = 1 (allocated)
		uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);
  8022a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8022a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022aa:	01 d0                	add    %edx,%eax
  8022ac:	83 e8 04             	sub    $0x4,%eax
  8022af:	89 45 f0             	mov    %eax,-0x10(%ebp)
		*endBlock = 0 | 1; // size = 0, LSB as a flag = 1
  8022b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022b5:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

		// the block that between begin and end blocks
		struct BlockElement* block = (struct BlockElement*)(daStart + 8);
  8022bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022be:	83 c0 08             	add    $0x8,%eax
  8022c1:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 blockSize = initSizeOfAllocatedSpace - 8; // subtract size of begin and end blocks
  8022c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022c7:	83 e8 08             	sub    $0x8,%eax
  8022ca:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(block,blockSize,0);
  8022cd:	83 ec 04             	sub    $0x4,%esp
  8022d0:	6a 00                	push   $0x0
  8022d2:	ff 75 e8             	pushl  -0x18(%ebp)
  8022d5:	ff 75 ec             	pushl  -0x14(%ebp)
  8022d8:	e8 9c 00 00 00       	call   802379 <set_block_data>
  8022dd:	83 c4 10             	add    $0x10,%esp

		block->prev_next_info.le_next = NULL;
  8022e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block->prev_next_info.le_prev = NULL;
  8022e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022ec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

		LIST_INIT(&freeBlocksList);
  8022f3:	c7 05 48 50 98 00 00 	movl   $0x0,0x985048
  8022fa:	00 00 00 
  8022fd:	c7 05 4c 50 98 00 00 	movl   $0x0,0x98504c
  802304:	00 00 00 
  802307:	c7 05 54 50 98 00 00 	movl   $0x0,0x985054
  80230e:	00 00 00 
		LIST_INSERT_HEAD(&freeBlocksList, block);
  802311:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802315:	75 17                	jne    80232e <initialize_dynamic_allocator+0xcd>
  802317:	83 ec 04             	sub    $0x4,%esp
  80231a:	68 d4 3f 80 00       	push   $0x803fd4
  80231f:	68 80 00 00 00       	push   $0x80
  802324:	68 f7 3f 80 00       	push   $0x803ff7
  802329:	e8 01 12 00 00       	call   80352f <_panic>
  80232e:	8b 15 48 50 98 00    	mov    0x985048,%edx
  802334:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802337:	89 10                	mov    %edx,(%eax)
  802339:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80233c:	8b 00                	mov    (%eax),%eax
  80233e:	85 c0                	test   %eax,%eax
  802340:	74 0d                	je     80234f <initialize_dynamic_allocator+0xee>
  802342:	a1 48 50 98 00       	mov    0x985048,%eax
  802347:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80234a:	89 50 04             	mov    %edx,0x4(%eax)
  80234d:	eb 08                	jmp    802357 <initialize_dynamic_allocator+0xf6>
  80234f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802352:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802357:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80235a:	a3 48 50 98 00       	mov    %eax,0x985048
  80235f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802362:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802369:	a1 54 50 98 00       	mov    0x985054,%eax
  80236e:	40                   	inc    %eax
  80236f:	a3 54 50 98 00       	mov    %eax,0x985054
  802374:	eb 01                	jmp    802377 <initialize_dynamic_allocator+0x116>
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
		if (initSizeOfAllocatedSpace == 0)
			return ;
  802376:	90                   	nop
		block->prev_next_info.le_prev = NULL;

		LIST_INIT(&freeBlocksList);
		LIST_INSERT_HEAD(&freeBlocksList, block);
	}
}
  802377:	c9                   	leave  
  802378:	c3                   	ret    

00802379 <set_block_data>:
//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802379:	55                   	push   %ebp
  80237a:	89 e5                	mov    %esp,%ebp
  80237c:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("set_block_data is not implemented yet");
	//Your Code is Here...

	if(totalSize % 2 != 0)
  80237f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802382:	83 e0 01             	and    $0x1,%eax
  802385:	85 c0                	test   %eax,%eax
  802387:	74 03                	je     80238c <set_block_data+0x13>
	{
		totalSize++;
  802389:	ff 45 0c             	incl   0xc(%ebp)
	}

	uint32* header = (uint32 *)((uint32*)va-1);
  80238c:	8b 45 08             	mov    0x8(%ebp),%eax
  80238f:	83 e8 04             	sub    $0x4,%eax
  802392:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//	size => totalSize with LSB = 0		 set LSB = 1 if isAllocated
	*header = (totalSize & ~1) | (isAllocated & 1);
  802395:	8b 45 0c             	mov    0xc(%ebp),%eax
  802398:	83 e0 fe             	and    $0xfffffffe,%eax
  80239b:	89 c2                	mov    %eax,%edx
  80239d:	8b 45 10             	mov    0x10(%ebp),%eax
  8023a0:	83 e0 01             	and    $0x1,%eax
  8023a3:	09 c2                	or     %eax,%edx
  8023a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023a8:	89 10                	mov    %edx,(%eax)
	uint32* footer = (uint32*) (va + totalSize - 8);
  8023aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023ad:	8d 50 f8             	lea    -0x8(%eax),%edx
  8023b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b3:	01 d0                	add    %edx,%eax
  8023b5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	*footer = (totalSize & ~1) | (isAllocated & 1);
  8023b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023bb:	83 e0 fe             	and    $0xfffffffe,%eax
  8023be:	89 c2                	mov    %eax,%edx
  8023c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8023c3:	83 e0 01             	and    $0x1,%eax
  8023c6:	09 c2                	or     %eax,%edx
  8023c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8023cb:	89 10                	mov    %edx,(%eax)
}
  8023cd:	90                   	nop
  8023ce:	c9                   	leave  
  8023cf:	c3                   	ret    

008023d0 <insert_sorted_in_freeList>:
//=========================================
void insert_sorted_in_freeList(struct BlockElement *newBlock)
{
  8023d0:	55                   	push   %ebp
  8023d1:	89 e5                	mov    %esp,%ebp
  8023d3:	83 ec 18             	sub    $0x18,%esp
	if(LIST_EMPTY(&freeBlocksList))
  8023d6:	a1 48 50 98 00       	mov    0x985048,%eax
  8023db:	85 c0                	test   %eax,%eax
  8023dd:	75 68                	jne    802447 <insert_sorted_in_freeList+0x77>
	{
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
  8023df:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023e3:	75 17                	jne    8023fc <insert_sorted_in_freeList+0x2c>
  8023e5:	83 ec 04             	sub    $0x4,%esp
  8023e8:	68 d4 3f 80 00       	push   $0x803fd4
  8023ed:	68 9d 00 00 00       	push   $0x9d
  8023f2:	68 f7 3f 80 00       	push   $0x803ff7
  8023f7:	e8 33 11 00 00       	call   80352f <_panic>
  8023fc:	8b 15 48 50 98 00    	mov    0x985048,%edx
  802402:	8b 45 08             	mov    0x8(%ebp),%eax
  802405:	89 10                	mov    %edx,(%eax)
  802407:	8b 45 08             	mov    0x8(%ebp),%eax
  80240a:	8b 00                	mov    (%eax),%eax
  80240c:	85 c0                	test   %eax,%eax
  80240e:	74 0d                	je     80241d <insert_sorted_in_freeList+0x4d>
  802410:	a1 48 50 98 00       	mov    0x985048,%eax
  802415:	8b 55 08             	mov    0x8(%ebp),%edx
  802418:	89 50 04             	mov    %edx,0x4(%eax)
  80241b:	eb 08                	jmp    802425 <insert_sorted_in_freeList+0x55>
  80241d:	8b 45 08             	mov    0x8(%ebp),%eax
  802420:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802425:	8b 45 08             	mov    0x8(%ebp),%eax
  802428:	a3 48 50 98 00       	mov    %eax,0x985048
  80242d:	8b 45 08             	mov    0x8(%ebp),%eax
  802430:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802437:	a1 54 50 98 00       	mov    0x985054,%eax
  80243c:	40                   	inc    %eax
  80243d:	a3 54 50 98 00       	mov    %eax,0x985054
		return;
  802442:	e9 1a 01 00 00       	jmp    802561 <insert_sorted_in_freeList+0x191>
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  802447:	a1 48 50 98 00       	mov    0x985048,%eax
  80244c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80244f:	eb 7f                	jmp    8024d0 <insert_sorted_in_freeList+0x100>
	{
		if(blk > newBlock) // if address of blk > address of newBlock => add newBlock before blk
  802451:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802454:	3b 45 08             	cmp    0x8(%ebp),%eax
  802457:	76 6f                	jbe    8024c8 <insert_sorted_in_freeList+0xf8>
		{
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
  802459:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80245d:	74 06                	je     802465 <insert_sorted_in_freeList+0x95>
  80245f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802463:	75 17                	jne    80247c <insert_sorted_in_freeList+0xac>
  802465:	83 ec 04             	sub    $0x4,%esp
  802468:	68 10 40 80 00       	push   $0x804010
  80246d:	68 a6 00 00 00       	push   $0xa6
  802472:	68 f7 3f 80 00       	push   $0x803ff7
  802477:	e8 b3 10 00 00       	call   80352f <_panic>
  80247c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247f:	8b 50 04             	mov    0x4(%eax),%edx
  802482:	8b 45 08             	mov    0x8(%ebp),%eax
  802485:	89 50 04             	mov    %edx,0x4(%eax)
  802488:	8b 45 08             	mov    0x8(%ebp),%eax
  80248b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80248e:	89 10                	mov    %edx,(%eax)
  802490:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802493:	8b 40 04             	mov    0x4(%eax),%eax
  802496:	85 c0                	test   %eax,%eax
  802498:	74 0d                	je     8024a7 <insert_sorted_in_freeList+0xd7>
  80249a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249d:	8b 40 04             	mov    0x4(%eax),%eax
  8024a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8024a3:	89 10                	mov    %edx,(%eax)
  8024a5:	eb 08                	jmp    8024af <insert_sorted_in_freeList+0xdf>
  8024a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024aa:	a3 48 50 98 00       	mov    %eax,0x985048
  8024af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8024b5:	89 50 04             	mov    %edx,0x4(%eax)
  8024b8:	a1 54 50 98 00       	mov    0x985054,%eax
  8024bd:	40                   	inc    %eax
  8024be:	a3 54 50 98 00       	mov    %eax,0x985054
			return;
  8024c3:	e9 99 00 00 00       	jmp    802561 <insert_sorted_in_freeList+0x191>
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
		return;
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  8024c8:	a1 50 50 98 00       	mov    0x985050,%eax
  8024cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024d4:	74 07                	je     8024dd <insert_sorted_in_freeList+0x10d>
  8024d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d9:	8b 00                	mov    (%eax),%eax
  8024db:	eb 05                	jmp    8024e2 <insert_sorted_in_freeList+0x112>
  8024dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8024e2:	a3 50 50 98 00       	mov    %eax,0x985050
  8024e7:	a1 50 50 98 00       	mov    0x985050,%eax
  8024ec:	85 c0                	test   %eax,%eax
  8024ee:	0f 85 5d ff ff ff    	jne    802451 <insert_sorted_in_freeList+0x81>
  8024f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024f8:	0f 85 53 ff ff ff    	jne    802451 <insert_sorted_in_freeList+0x81>
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
			return;
		}
	}
	// if no blk its address > newBlock
	LIST_INSERT_TAIL(&freeBlocksList, newBlock);
  8024fe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802502:	75 17                	jne    80251b <insert_sorted_in_freeList+0x14b>
  802504:	83 ec 04             	sub    $0x4,%esp
  802507:	68 48 40 80 00       	push   $0x804048
  80250c:	68 ab 00 00 00       	push   $0xab
  802511:	68 f7 3f 80 00       	push   $0x803ff7
  802516:	e8 14 10 00 00       	call   80352f <_panic>
  80251b:	8b 15 4c 50 98 00    	mov    0x98504c,%edx
  802521:	8b 45 08             	mov    0x8(%ebp),%eax
  802524:	89 50 04             	mov    %edx,0x4(%eax)
  802527:	8b 45 08             	mov    0x8(%ebp),%eax
  80252a:	8b 40 04             	mov    0x4(%eax),%eax
  80252d:	85 c0                	test   %eax,%eax
  80252f:	74 0c                	je     80253d <insert_sorted_in_freeList+0x16d>
  802531:	a1 4c 50 98 00       	mov    0x98504c,%eax
  802536:	8b 55 08             	mov    0x8(%ebp),%edx
  802539:	89 10                	mov    %edx,(%eax)
  80253b:	eb 08                	jmp    802545 <insert_sorted_in_freeList+0x175>
  80253d:	8b 45 08             	mov    0x8(%ebp),%eax
  802540:	a3 48 50 98 00       	mov    %eax,0x985048
  802545:	8b 45 08             	mov    0x8(%ebp),%eax
  802548:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80254d:	8b 45 08             	mov    0x8(%ebp),%eax
  802550:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802556:	a1 54 50 98 00       	mov    0x985054,%eax
  80255b:	40                   	inc    %eax
  80255c:	a3 54 50 98 00       	mov    %eax,0x985054
}
  802561:	c9                   	leave  
  802562:	c3                   	ret    

00802563 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  802563:	55                   	push   %ebp
  802564:	89 e5                	mov    %esp,%ebp
  802566:	83 ec 78             	sub    $0x78,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802569:	8b 45 08             	mov    0x8(%ebp),%eax
  80256c:	83 e0 01             	and    $0x1,%eax
  80256f:	85 c0                	test   %eax,%eax
  802571:	74 03                	je     802576 <alloc_block_FF+0x13>
  802573:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802576:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80257a:	77 07                	ja     802583 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80257c:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802583:	a1 40 50 98 00       	mov    0x985040,%eax
  802588:	85 c0                	test   %eax,%eax
  80258a:	75 63                	jne    8025ef <alloc_block_FF+0x8c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80258c:	8b 45 08             	mov    0x8(%ebp),%eax
  80258f:	83 c0 10             	add    $0x10,%eax
  802592:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802595:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80259c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80259f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025a2:	01 d0                	add    %edx,%eax
  8025a4:	48                   	dec    %eax
  8025a5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8025a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8025b0:	f7 75 ec             	divl   -0x14(%ebp)
  8025b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025b6:	29 d0                	sub    %edx,%eax
  8025b8:	c1 e8 0c             	shr    $0xc,%eax
  8025bb:	83 ec 0c             	sub    $0xc,%esp
  8025be:	50                   	push   %eax
  8025bf:	e8 d1 ed ff ff       	call   801395 <sbrk>
  8025c4:	83 c4 10             	add    $0x10,%esp
  8025c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8025ca:	83 ec 0c             	sub    $0xc,%esp
  8025cd:	6a 00                	push   $0x0
  8025cf:	e8 c1 ed ff ff       	call   801395 <sbrk>
  8025d4:	83 c4 10             	add    $0x10,%esp
  8025d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8025da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025dd:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8025e0:	83 ec 08             	sub    $0x8,%esp
  8025e3:	50                   	push   %eax
  8025e4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8025e7:	e8 75 fc ff ff       	call   802261 <initialize_dynamic_allocator>
  8025ec:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(size == 0)
  8025ef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025f3:	75 0a                	jne    8025ff <alloc_block_FF+0x9c>
	{
		return NULL;
  8025f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8025fa:	e9 99 03 00 00       	jmp    802998 <alloc_block_FF+0x435>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  8025ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802602:	83 c0 08             	add    $0x8,%eax
  802605:	89 45 dc             	mov    %eax,-0x24(%ebp)

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802608:	a1 48 50 98 00       	mov    0x985048,%eax
  80260d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802610:	e9 03 02 00 00       	jmp    802818 <alloc_block_FF+0x2b5>
	{
		uint32 blockSize = get_block_size(block); // Get size without the (LSB) allocation flag
  802615:	83 ec 0c             	sub    $0xc,%esp
  802618:	ff 75 f4             	pushl  -0xc(%ebp)
  80261b:	e8 dd fa ff ff       	call   8020fd <get_block_size>
  802620:	83 c4 10             	add    $0x10,%esp
  802623:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if(blockSize >= totalSize)
  802626:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802629:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80262c:	0f 82 de 01 00 00    	jb     802810 <alloc_block_FF+0x2ad>
		{	//if we can put another block with min size 16
			if(blockSize >= totalSize + 4*sizeof(uint32))
  802632:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802635:	83 c0 10             	add    $0x10,%eax
  802638:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  80263b:	0f 87 32 01 00 00    	ja     802773 <alloc_block_FF+0x210>
			{
				// the size that will remain from the block that we will allocate a new block in it
				uint32 remainingSize = blockSize - totalSize;
  802641:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802644:	2b 45 dc             	sub    -0x24(%ebp),%eax
  802647:	89 45 98             	mov    %eax,-0x68(%ebp)

				// the remaining free space from the block that we use to allocate in it
				struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)block + totalSize);
  80264a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80264d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802650:	01 d0                	add    %edx,%eax
  802652:	89 45 94             	mov    %eax,-0x6c(%ebp)
				set_block_data(remainingFreeBlock, remainingSize, 0);
  802655:	83 ec 04             	sub    $0x4,%esp
  802658:	6a 00                	push   $0x0
  80265a:	ff 75 98             	pushl  -0x68(%ebp)
  80265d:	ff 75 94             	pushl  -0x6c(%ebp)
  802660:	e8 14 fd ff ff       	call   802379 <set_block_data>
  802665:	83 c4 10             	add    $0x10,%esp
				// add it after the block we allocated to be sorted by addresses
				LIST_INSERT_AFTER(&freeBlocksList, block,remainingFreeBlock);
  802668:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80266c:	74 06                	je     802674 <alloc_block_FF+0x111>
  80266e:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
  802672:	75 17                	jne    80268b <alloc_block_FF+0x128>
  802674:	83 ec 04             	sub    $0x4,%esp
  802677:	68 6c 40 80 00       	push   $0x80406c
  80267c:	68 de 00 00 00       	push   $0xde
  802681:	68 f7 3f 80 00       	push   $0x803ff7
  802686:	e8 a4 0e 00 00       	call   80352f <_panic>
  80268b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268e:	8b 10                	mov    (%eax),%edx
  802690:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802693:	89 10                	mov    %edx,(%eax)
  802695:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802698:	8b 00                	mov    (%eax),%eax
  80269a:	85 c0                	test   %eax,%eax
  80269c:	74 0b                	je     8026a9 <alloc_block_FF+0x146>
  80269e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a1:	8b 00                	mov    (%eax),%eax
  8026a3:	8b 55 94             	mov    -0x6c(%ebp),%edx
  8026a6:	89 50 04             	mov    %edx,0x4(%eax)
  8026a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ac:	8b 55 94             	mov    -0x6c(%ebp),%edx
  8026af:	89 10                	mov    %edx,(%eax)
  8026b1:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8026b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026b7:	89 50 04             	mov    %edx,0x4(%eax)
  8026ba:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8026bd:	8b 00                	mov    (%eax),%eax
  8026bf:	85 c0                	test   %eax,%eax
  8026c1:	75 08                	jne    8026cb <alloc_block_FF+0x168>
  8026c3:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8026c6:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8026cb:	a1 54 50 98 00       	mov    0x985054,%eax
  8026d0:	40                   	inc    %eax
  8026d1:	a3 54 50 98 00       	mov    %eax,0x985054

				// update the allocated block and remove it from freeBlocksList
				set_block_data(block,totalSize,1);
  8026d6:	83 ec 04             	sub    $0x4,%esp
  8026d9:	6a 01                	push   $0x1
  8026db:	ff 75 dc             	pushl  -0x24(%ebp)
  8026de:	ff 75 f4             	pushl  -0xc(%ebp)
  8026e1:	e8 93 fc ff ff       	call   802379 <set_block_data>
  8026e6:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  8026e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ed:	75 17                	jne    802706 <alloc_block_FF+0x1a3>
  8026ef:	83 ec 04             	sub    $0x4,%esp
  8026f2:	68 a0 40 80 00       	push   $0x8040a0
  8026f7:	68 e3 00 00 00       	push   $0xe3
  8026fc:	68 f7 3f 80 00       	push   $0x803ff7
  802701:	e8 29 0e 00 00       	call   80352f <_panic>
  802706:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802709:	8b 00                	mov    (%eax),%eax
  80270b:	85 c0                	test   %eax,%eax
  80270d:	74 10                	je     80271f <alloc_block_FF+0x1bc>
  80270f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802712:	8b 00                	mov    (%eax),%eax
  802714:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802717:	8b 52 04             	mov    0x4(%edx),%edx
  80271a:	89 50 04             	mov    %edx,0x4(%eax)
  80271d:	eb 0b                	jmp    80272a <alloc_block_FF+0x1c7>
  80271f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802722:	8b 40 04             	mov    0x4(%eax),%eax
  802725:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80272a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272d:	8b 40 04             	mov    0x4(%eax),%eax
  802730:	85 c0                	test   %eax,%eax
  802732:	74 0f                	je     802743 <alloc_block_FF+0x1e0>
  802734:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802737:	8b 40 04             	mov    0x4(%eax),%eax
  80273a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80273d:	8b 12                	mov    (%edx),%edx
  80273f:	89 10                	mov    %edx,(%eax)
  802741:	eb 0a                	jmp    80274d <alloc_block_FF+0x1ea>
  802743:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802746:	8b 00                	mov    (%eax),%eax
  802748:	a3 48 50 98 00       	mov    %eax,0x985048
  80274d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802750:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802756:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802759:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802760:	a1 54 50 98 00       	mov    0x985054,%eax
  802765:	48                   	dec    %eax
  802766:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  80276b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276e:	e9 25 02 00 00       	jmp    802998 <alloc_block_FF+0x435>
			}
			else // if set internal fragmentation
			{
				// add the remaining size to the block we allocate so it will be the same main block size
				set_block_data(block,blockSize,1);
  802773:	83 ec 04             	sub    $0x4,%esp
  802776:	6a 01                	push   $0x1
  802778:	ff 75 9c             	pushl  -0x64(%ebp)
  80277b:	ff 75 f4             	pushl  -0xc(%ebp)
  80277e:	e8 f6 fb ff ff       	call   802379 <set_block_data>
  802783:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  802786:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80278a:	75 17                	jne    8027a3 <alloc_block_FF+0x240>
  80278c:	83 ec 04             	sub    $0x4,%esp
  80278f:	68 a0 40 80 00       	push   $0x8040a0
  802794:	68 eb 00 00 00       	push   $0xeb
  802799:	68 f7 3f 80 00       	push   $0x803ff7
  80279e:	e8 8c 0d 00 00       	call   80352f <_panic>
  8027a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a6:	8b 00                	mov    (%eax),%eax
  8027a8:	85 c0                	test   %eax,%eax
  8027aa:	74 10                	je     8027bc <alloc_block_FF+0x259>
  8027ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027af:	8b 00                	mov    (%eax),%eax
  8027b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027b4:	8b 52 04             	mov    0x4(%edx),%edx
  8027b7:	89 50 04             	mov    %edx,0x4(%eax)
  8027ba:	eb 0b                	jmp    8027c7 <alloc_block_FF+0x264>
  8027bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bf:	8b 40 04             	mov    0x4(%eax),%eax
  8027c2:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8027c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ca:	8b 40 04             	mov    0x4(%eax),%eax
  8027cd:	85 c0                	test   %eax,%eax
  8027cf:	74 0f                	je     8027e0 <alloc_block_FF+0x27d>
  8027d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d4:	8b 40 04             	mov    0x4(%eax),%eax
  8027d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027da:	8b 12                	mov    (%edx),%edx
  8027dc:	89 10                	mov    %edx,(%eax)
  8027de:	eb 0a                	jmp    8027ea <alloc_block_FF+0x287>
  8027e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e3:	8b 00                	mov    (%eax),%eax
  8027e5:	a3 48 50 98 00       	mov    %eax,0x985048
  8027ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027fd:	a1 54 50 98 00       	mov    0x985054,%eax
  802802:	48                   	dec    %eax
  802803:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  802808:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280b:	e9 88 01 00 00       	jmp    802998 <alloc_block_FF+0x435>
		return NULL;
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802810:	a1 50 50 98 00       	mov    0x985050,%eax
  802815:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802818:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80281c:	74 07                	je     802825 <alloc_block_FF+0x2c2>
  80281e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802821:	8b 00                	mov    (%eax),%eax
  802823:	eb 05                	jmp    80282a <alloc_block_FF+0x2c7>
  802825:	b8 00 00 00 00       	mov    $0x0,%eax
  80282a:	a3 50 50 98 00       	mov    %eax,0x985050
  80282f:	a1 50 50 98 00       	mov    0x985050,%eax
  802834:	85 c0                	test   %eax,%eax
  802836:	0f 85 d9 fd ff ff    	jne    802615 <alloc_block_FF+0xb2>
  80283c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802840:	0f 85 cf fd ff ff    	jne    802615 <alloc_block_FF+0xb2>

//	uint32 *endBlock = &kheapBreak;

	// if we don't find any enough space to allocate the block

	void *oldBreak = sbrk(ROUNDUP(totalSize, PAGE_SIZE) / PAGE_SIZE);
  802846:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80284d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802850:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802853:	01 d0                	add    %edx,%eax
  802855:	48                   	dec    %eax
  802856:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802859:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80285c:	ba 00 00 00 00       	mov    $0x0,%edx
  802861:	f7 75 d8             	divl   -0x28(%ebp)
  802864:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802867:	29 d0                	sub    %edx,%eax
  802869:	c1 e8 0c             	shr    $0xc,%eax
  80286c:	83 ec 0c             	sub    $0xc,%esp
  80286f:	50                   	push   %eax
  802870:	e8 20 eb ff ff       	call   801395 <sbrk>
  802875:	83 c4 10             	add    $0x10,%esp
  802878:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (oldBreak == (void*)-1) {
  80287b:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  80287f:	75 0a                	jne    80288b <alloc_block_FF+0x328>
		return NULL;
  802881:	b8 00 00 00 00       	mov    $0x0,%eax
  802886:	e9 0d 01 00 00       	jmp    802998 <alloc_block_FF+0x435>
	}
	//uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);

	uint32* endBlk = (uint32 *)((char *)oldBreak - 4);
  80288b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80288e:	83 e8 04             	sub    $0x4,%eax
  802891:	89 45 cc             	mov    %eax,-0x34(%ebp)
	//endBlk = endBlk+(char *) ROUNDUP(totalSize, PAGE_SIZE);

	endBlk = endBlk + (ROUNDUP(totalSize, PAGE_SIZE) / sizeof(uint32));
  802894:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  80289b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80289e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8028a1:	01 d0                	add    %edx,%eax
  8028a3:	48                   	dec    %eax
  8028a4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8028a7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8028aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8028af:	f7 75 c8             	divl   -0x38(%ebp)
  8028b2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8028b5:	29 d0                	sub    %edx,%eax
  8028b7:	c1 e8 02             	shr    $0x2,%eax
  8028ba:	c1 e0 02             	shl    $0x2,%eax
  8028bd:	01 45 cc             	add    %eax,-0x34(%ebp)
	*endBlk = 0 | 1;
  8028c0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028c3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	uint32 *footerLast = ((uint32*)oldBreak - 2);
  8028c9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8028cc:	83 e8 08             	sub    $0x8,%eax
  8028cf:	89 45 c0             	mov    %eax,-0x40(%ebp)
	uint32 lastSize = (*footerLast) & ~(0x1);
  8028d2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8028d5:	8b 00                	mov    (%eax),%eax
  8028d7:	83 e0 fe             	and    $0xfffffffe,%eax
  8028da:	89 45 bc             	mov    %eax,-0x44(%ebp)
	// the last block for the block that we want to free it
	struct BlockElement *laskBlk = (struct BlockElement *)((char*)oldBreak - lastSize);
  8028dd:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8028e0:	f7 d8                	neg    %eax
  8028e2:	89 c2                	mov    %eax,%edx
  8028e4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8028e7:	01 d0                	add    %edx,%eax
  8028e9:	89 45 b8             	mov    %eax,-0x48(%ebp)
	uint32 isLastFree = is_free_block(laskBlk);
  8028ec:	83 ec 0c             	sub    $0xc,%esp
  8028ef:	ff 75 b8             	pushl  -0x48(%ebp)
  8028f2:	e8 1f f8 ff ff       	call   802116 <is_free_block>
  8028f7:	83 c4 10             	add    $0x10,%esp
  8028fa:	0f be c0             	movsbl %al,%eax
  8028fd:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(isLastFree)
  802900:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  802904:	74 42                	je     802948 <alloc_block_FF+0x3e5>
	{
		// merge the block will be free with its prev block
		uint32 newBlkSize = lastSize + ROUNDUP(totalSize, PAGE_SIZE); // size of main block and its prev block
  802906:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  80290d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802910:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802913:	01 d0                	add    %edx,%eax
  802915:	48                   	dec    %eax
  802916:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802919:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80291c:	ba 00 00 00 00       	mov    $0x0,%edx
  802921:	f7 75 b0             	divl   -0x50(%ebp)
  802924:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802927:	29 d0                	sub    %edx,%eax
  802929:	89 c2                	mov    %eax,%edx
  80292b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80292e:	01 d0                	add    %edx,%eax
  802930:	89 45 a8             	mov    %eax,-0x58(%ebp)
		// extends last block size to contain its size and the size of new space
		set_block_data(laskBlk,newBlkSize,0);
  802933:	83 ec 04             	sub    $0x4,%esp
  802936:	6a 00                	push   $0x0
  802938:	ff 75 a8             	pushl  -0x58(%ebp)
  80293b:	ff 75 b8             	pushl  -0x48(%ebp)
  80293e:	e8 36 fa ff ff       	call   802379 <set_block_data>
  802943:	83 c4 10             	add    $0x10,%esp
  802946:	eb 42                	jmp    80298a <alloc_block_FF+0x427>
	}
	else
	{
		set_block_data(oldBreak,ROUNDUP(totalSize, PAGE_SIZE),0);
  802948:	c7 45 a4 00 10 00 00 	movl   $0x1000,-0x5c(%ebp)
  80294f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802952:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802955:	01 d0                	add    %edx,%eax
  802957:	48                   	dec    %eax
  802958:	89 45 a0             	mov    %eax,-0x60(%ebp)
  80295b:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80295e:	ba 00 00 00 00       	mov    $0x0,%edx
  802963:	f7 75 a4             	divl   -0x5c(%ebp)
  802966:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802969:	29 d0                	sub    %edx,%eax
  80296b:	83 ec 04             	sub    $0x4,%esp
  80296e:	6a 00                	push   $0x0
  802970:	50                   	push   %eax
  802971:	ff 75 d0             	pushl  -0x30(%ebp)
  802974:	e8 00 fa ff ff       	call   802379 <set_block_data>
  802979:	83 c4 10             	add    $0x10,%esp
		insert_sorted_in_freeList((struct BlockElement *)oldBreak);
  80297c:	83 ec 0c             	sub    $0xc,%esp
  80297f:	ff 75 d0             	pushl  -0x30(%ebp)
  802982:	e8 49 fa ff ff       	call   8023d0 <insert_sorted_in_freeList>
  802987:	83 c4 10             	add    $0x10,%esp
//		LIST_INSERT_TAIL(&freeBlocksList,newBreak);
	}
//	set_block_data((struct BlockElement *)newBreak, totalSize, 1);
	return alloc_block_FF(size);
  80298a:	83 ec 0c             	sub    $0xc,%esp
  80298d:	ff 75 08             	pushl  0x8(%ebp)
  802990:	e8 ce fb ff ff       	call   802563 <alloc_block_FF>
  802995:	83 c4 10             	add    $0x10,%esp
}
  802998:	c9                   	leave  
  802999:	c3                   	ret    

0080299a <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  80299a:	55                   	push   %ebp
  80299b:	89 e5                	mov    %esp,%ebp
  80299d:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS1 - BONUS] [3] DYNAMIC ALLOCATOR - alloc_block_BF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_BF is not implemented yet");
	//Your Code is Here...
	if(size == 0)
  8029a0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029a4:	75 0a                	jne    8029b0 <alloc_block_BF+0x16>
	{
		return NULL;
  8029a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8029ab:	e9 7a 02 00 00       	jmp    802c2a <alloc_block_BF+0x290>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  8029b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b3:	83 c0 08             	add    $0x8,%eax
  8029b6:	89 45 e8             	mov    %eax,-0x18(%ebp)

	struct BlockElement *minBlk= NULL;
  8029b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 minSize = 0xfffffff; // a large number
  8029c0:	c7 45 f0 ff ff ff 0f 	movl   $0xfffffff,-0x10(%ebp)
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  8029c7:	a1 48 50 98 00       	mov    0x985048,%eax
  8029cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8029cf:	eb 32                	jmp    802a03 <alloc_block_BF+0x69>
	{
		uint32 blockSize = get_block_size(block);
  8029d1:	ff 75 ec             	pushl  -0x14(%ebp)
  8029d4:	e8 24 f7 ff ff       	call   8020fd <get_block_size>
  8029d9:	83 c4 04             	add    $0x4,%esp
  8029dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		// if this block can take the new block and its size < min size of all blocks
		if(blockSize >= totalSize && blockSize < minSize)
  8029df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029e2:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8029e5:	72 14                	jb     8029fb <alloc_block_BF+0x61>
  8029e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029ea:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8029ed:	73 0c                	jae    8029fb <alloc_block_BF+0x61>
		{
			minBlk = block;
  8029ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
			minSize = blockSize;
  8029f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *minBlk= NULL;
	uint32 minSize = 0xfffffff; // a large number
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  8029fb:	a1 50 50 98 00       	mov    0x985050,%eax
  802a00:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802a03:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a07:	74 07                	je     802a10 <alloc_block_BF+0x76>
  802a09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a0c:	8b 00                	mov    (%eax),%eax
  802a0e:	eb 05                	jmp    802a15 <alloc_block_BF+0x7b>
  802a10:	b8 00 00 00 00       	mov    $0x0,%eax
  802a15:	a3 50 50 98 00       	mov    %eax,0x985050
  802a1a:	a1 50 50 98 00       	mov    0x985050,%eax
  802a1f:	85 c0                	test   %eax,%eax
  802a21:	75 ae                	jne    8029d1 <alloc_block_BF+0x37>
  802a23:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a27:	75 a8                	jne    8029d1 <alloc_block_BF+0x37>
			minSize = blockSize;
		}
	}

	// if we don't find any enough space to allocate the block
	if(minBlk == NULL)
  802a29:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a2d:	75 22                	jne    802a51 <alloc_block_BF+0xb7>
	{
		void *newBlock = sbrk(totalSize);
  802a2f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a32:	83 ec 0c             	sub    $0xc,%esp
  802a35:	50                   	push   %eax
  802a36:	e8 5a e9 ff ff       	call   801395 <sbrk>
  802a3b:	83 c4 10             	add    $0x10,%esp
  802a3e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (newBlock == (void*)-1) {
  802a41:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  802a45:	75 0a                	jne    802a51 <alloc_block_BF+0xb7>
			return NULL;
  802a47:	b8 00 00 00 00       	mov    $0x0,%eax
  802a4c:	e9 d9 01 00 00       	jmp    802c2a <alloc_block_BF+0x290>
		}
	}

	//if we can put another block with min size 16
	if(minSize >= totalSize + 4*sizeof(uint32))
  802a51:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a54:	83 c0 10             	add    $0x10,%eax
  802a57:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802a5a:	0f 87 32 01 00 00    	ja     802b92 <alloc_block_BF+0x1f8>
	{
		// the size that will remain from the block that we will allocate a new block in it
		uint32 remainingSize= minSize - totalSize;
  802a60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a63:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802a66:	89 45 dc             	mov    %eax,-0x24(%ebp)

		// the remaining free space from the block that we use to allocate in it
		struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)minBlk + totalSize);
  802a69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a6c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a6f:	01 d0                	add    %edx,%eax
  802a71:	89 45 d8             	mov    %eax,-0x28(%ebp)
		set_block_data(remainingFreeBlock, remainingSize, 0);
  802a74:	83 ec 04             	sub    $0x4,%esp
  802a77:	6a 00                	push   $0x0
  802a79:	ff 75 dc             	pushl  -0x24(%ebp)
  802a7c:	ff 75 d8             	pushl  -0x28(%ebp)
  802a7f:	e8 f5 f8 ff ff       	call   802379 <set_block_data>
  802a84:	83 c4 10             	add    $0x10,%esp
		// add it after the block we allocated to be sorted by addresses
		LIST_INSERT_AFTER(&freeBlocksList, minBlk,remainingFreeBlock);
  802a87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a8b:	74 06                	je     802a93 <alloc_block_BF+0xf9>
  802a8d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802a91:	75 17                	jne    802aaa <alloc_block_BF+0x110>
  802a93:	83 ec 04             	sub    $0x4,%esp
  802a96:	68 6c 40 80 00       	push   $0x80406c
  802a9b:	68 49 01 00 00       	push   $0x149
  802aa0:	68 f7 3f 80 00       	push   $0x803ff7
  802aa5:	e8 85 0a 00 00       	call   80352f <_panic>
  802aaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aad:	8b 10                	mov    (%eax),%edx
  802aaf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ab2:	89 10                	mov    %edx,(%eax)
  802ab4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ab7:	8b 00                	mov    (%eax),%eax
  802ab9:	85 c0                	test   %eax,%eax
  802abb:	74 0b                	je     802ac8 <alloc_block_BF+0x12e>
  802abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac0:	8b 00                	mov    (%eax),%eax
  802ac2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802ac5:	89 50 04             	mov    %edx,0x4(%eax)
  802ac8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802ace:	89 10                	mov    %edx,(%eax)
  802ad0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ad3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ad6:	89 50 04             	mov    %edx,0x4(%eax)
  802ad9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802adc:	8b 00                	mov    (%eax),%eax
  802ade:	85 c0                	test   %eax,%eax
  802ae0:	75 08                	jne    802aea <alloc_block_BF+0x150>
  802ae2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ae5:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802aea:	a1 54 50 98 00       	mov    0x985054,%eax
  802aef:	40                   	inc    %eax
  802af0:	a3 54 50 98 00       	mov    %eax,0x985054

		// update the allocated block and remove it from freeBlocksList
		set_block_data(minBlk,totalSize,1);
  802af5:	83 ec 04             	sub    $0x4,%esp
  802af8:	6a 01                	push   $0x1
  802afa:	ff 75 e8             	pushl  -0x18(%ebp)
  802afd:	ff 75 f4             	pushl  -0xc(%ebp)
  802b00:	e8 74 f8 ff ff       	call   802379 <set_block_data>
  802b05:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  802b08:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b0c:	75 17                	jne    802b25 <alloc_block_BF+0x18b>
  802b0e:	83 ec 04             	sub    $0x4,%esp
  802b11:	68 a0 40 80 00       	push   $0x8040a0
  802b16:	68 4e 01 00 00       	push   $0x14e
  802b1b:	68 f7 3f 80 00       	push   $0x803ff7
  802b20:	e8 0a 0a 00 00       	call   80352f <_panic>
  802b25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b28:	8b 00                	mov    (%eax),%eax
  802b2a:	85 c0                	test   %eax,%eax
  802b2c:	74 10                	je     802b3e <alloc_block_BF+0x1a4>
  802b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b31:	8b 00                	mov    (%eax),%eax
  802b33:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b36:	8b 52 04             	mov    0x4(%edx),%edx
  802b39:	89 50 04             	mov    %edx,0x4(%eax)
  802b3c:	eb 0b                	jmp    802b49 <alloc_block_BF+0x1af>
  802b3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b41:	8b 40 04             	mov    0x4(%eax),%eax
  802b44:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4c:	8b 40 04             	mov    0x4(%eax),%eax
  802b4f:	85 c0                	test   %eax,%eax
  802b51:	74 0f                	je     802b62 <alloc_block_BF+0x1c8>
  802b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b56:	8b 40 04             	mov    0x4(%eax),%eax
  802b59:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b5c:	8b 12                	mov    (%edx),%edx
  802b5e:	89 10                	mov    %edx,(%eax)
  802b60:	eb 0a                	jmp    802b6c <alloc_block_BF+0x1d2>
  802b62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b65:	8b 00                	mov    (%eax),%eax
  802b67:	a3 48 50 98 00       	mov    %eax,0x985048
  802b6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b78:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b7f:	a1 54 50 98 00       	mov    0x985054,%eax
  802b84:	48                   	dec    %eax
  802b85:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  802b8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8d:	e9 98 00 00 00       	jmp    802c2a <alloc_block_BF+0x290>
	}
	else // if set internal fragmentation
	{
		// add the remaining size to the block we allocate so it will be the same main block size
		set_block_data(minBlk,minSize,1);
  802b92:	83 ec 04             	sub    $0x4,%esp
  802b95:	6a 01                	push   $0x1
  802b97:	ff 75 f0             	pushl  -0x10(%ebp)
  802b9a:	ff 75 f4             	pushl  -0xc(%ebp)
  802b9d:	e8 d7 f7 ff ff       	call   802379 <set_block_data>
  802ba2:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  802ba5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ba9:	75 17                	jne    802bc2 <alloc_block_BF+0x228>
  802bab:	83 ec 04             	sub    $0x4,%esp
  802bae:	68 a0 40 80 00       	push   $0x8040a0
  802bb3:	68 56 01 00 00       	push   $0x156
  802bb8:	68 f7 3f 80 00       	push   $0x803ff7
  802bbd:	e8 6d 09 00 00       	call   80352f <_panic>
  802bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc5:	8b 00                	mov    (%eax),%eax
  802bc7:	85 c0                	test   %eax,%eax
  802bc9:	74 10                	je     802bdb <alloc_block_BF+0x241>
  802bcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bce:	8b 00                	mov    (%eax),%eax
  802bd0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bd3:	8b 52 04             	mov    0x4(%edx),%edx
  802bd6:	89 50 04             	mov    %edx,0x4(%eax)
  802bd9:	eb 0b                	jmp    802be6 <alloc_block_BF+0x24c>
  802bdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bde:	8b 40 04             	mov    0x4(%eax),%eax
  802be1:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be9:	8b 40 04             	mov    0x4(%eax),%eax
  802bec:	85 c0                	test   %eax,%eax
  802bee:	74 0f                	je     802bff <alloc_block_BF+0x265>
  802bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf3:	8b 40 04             	mov    0x4(%eax),%eax
  802bf6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bf9:	8b 12                	mov    (%edx),%edx
  802bfb:	89 10                	mov    %edx,(%eax)
  802bfd:	eb 0a                	jmp    802c09 <alloc_block_BF+0x26f>
  802bff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c02:	8b 00                	mov    (%eax),%eax
  802c04:	a3 48 50 98 00       	mov    %eax,0x985048
  802c09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c15:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c1c:	a1 54 50 98 00       	mov    0x985054,%eax
  802c21:	48                   	dec    %eax
  802c22:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  802c27:	8b 45 f4             	mov    -0xc(%ebp),%eax
	}
	return NULL;
}
  802c2a:	c9                   	leave  
  802c2b:	c3                   	ret    

00802c2c <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802c2c:	55                   	push   %ebp
  802c2d:	89 e5                	mov    %esp,%ebp
  802c2f:	83 ec 48             	sub    $0x48,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
  802c32:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c36:	0f 84 6a 02 00 00    	je     802ea6 <free_block+0x27a>
	{
		return;
	}

	uint32 freeSize = get_block_size(va);
  802c3c:	ff 75 08             	pushl  0x8(%ebp)
  802c3f:	e8 b9 f4 ff ff       	call   8020fd <get_block_size>
  802c44:	83 c4 04             	add    $0x4,%esp
  802c47:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// footer for the prev block for the block that we want to free it
	uint32 *footerPrev = ((uint32*)va - 2 );
  802c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4d:	83 e8 08             	sub    $0x8,%eax
  802c50:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 pSize = (*footerPrev) & ~(0x1);
  802c53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c56:	8b 00                	mov    (%eax),%eax
  802c58:	83 e0 fe             	and    $0xfffffffe,%eax
  802c5b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// the prev block for the block that we want to free it
	struct BlockElement * prevBlk = (struct BlockElement *)((char*)va - pSize);
  802c5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c61:	f7 d8                	neg    %eax
  802c63:	89 c2                	mov    %eax,%edx
  802c65:	8b 45 08             	mov    0x8(%ebp),%eax
  802c68:	01 d0                	add    %edx,%eax
  802c6a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	uint32 isPrevFree = is_free_block(prevBlk);
  802c6d:	ff 75 e8             	pushl  -0x18(%ebp)
  802c70:	e8 a1 f4 ff ff       	call   802116 <is_free_block>
  802c75:	83 c4 04             	add    $0x4,%esp
  802c78:	0f be c0             	movsbl %al,%eax
  802c7b:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
  802c7e:	8b 55 08             	mov    0x8(%ebp),%edx
  802c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c84:	01 d0                	add    %edx,%eax
  802c86:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  802c89:	ff 75 e0             	pushl  -0x20(%ebp)
  802c8c:	e8 85 f4 ff ff       	call   802116 <is_free_block>
  802c91:	83 c4 04             	add    $0x4,%esp
  802c94:	0f be c0             	movsbl %al,%eax
  802c97:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if(isPrevFree == 1 && isNextFree == 0)
  802c9a:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  802c9e:	75 34                	jne    802cd4 <free_block+0xa8>
  802ca0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802ca4:	75 2e                	jne    802cd4 <free_block+0xa8>
	{
		// merge the block will be free with its prev block
		uint32 prevSize = get_block_size(prevBlk);
  802ca6:	ff 75 e8             	pushl  -0x18(%ebp)
  802ca9:	e8 4f f4 ff ff       	call   8020fd <get_block_size>
  802cae:	83 c4 04             	add    $0x4,%esp
  802cb1:	89 45 d8             	mov    %eax,-0x28(%ebp)
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
  802cb4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cb7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802cba:	01 d0                	add    %edx,%eax
  802cbc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
  802cbf:	6a 00                	push   $0x0
  802cc1:	ff 75 d4             	pushl  -0x2c(%ebp)
  802cc4:	ff 75 e8             	pushl  -0x18(%ebp)
  802cc7:	e8 ad f6 ff ff       	call   802379 <set_block_data>
  802ccc:	83 c4 0c             	add    $0xc,%esp
	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
	uint32 isNextFree = is_free_block(nextBlk);

	if(isPrevFree == 1 && isNextFree == 0)
	{
  802ccf:	e9 d3 01 00 00       	jmp    802ea7 <free_block+0x27b>
		uint32 prevSize = get_block_size(prevBlk);
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
  802cd4:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  802cd8:	0f 85 c8 00 00 00    	jne    802da6 <free_block+0x17a>
  802cde:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802ce2:	0f 85 be 00 00 00    	jne    802da6 <free_block+0x17a>
	{
		// merge the block will be free with its next block
		uint32 nextSize = get_block_size(nextBlk);
  802ce8:	ff 75 e0             	pushl  -0x20(%ebp)
  802ceb:	e8 0d f4 ff ff       	call   8020fd <get_block_size>
  802cf0:	83 c4 04             	add    $0x4,%esp
  802cf3:	89 45 d0             	mov    %eax,-0x30(%ebp)
		uint32 totalSize = freeSize + nextSize; // size of main block and its next block
  802cf6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cf9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802cfc:	01 d0                	add    %edx,%eax
  802cfe:	89 45 cc             	mov    %eax,-0x34(%ebp)
		// update the size of block to contain its size and the size of next block
		set_block_data(va,totalSize,0);
  802d01:	6a 00                	push   $0x0
  802d03:	ff 75 cc             	pushl  -0x34(%ebp)
  802d06:	ff 75 08             	pushl  0x8(%ebp)
  802d09:	e8 6b f6 ff ff       	call   802379 <set_block_data>
  802d0e:	83 c4 0c             	add    $0xc,%esp
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
  802d11:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802d15:	75 17                	jne    802d2e <free_block+0x102>
  802d17:	83 ec 04             	sub    $0x4,%esp
  802d1a:	68 a0 40 80 00       	push   $0x8040a0
  802d1f:	68 87 01 00 00       	push   $0x187
  802d24:	68 f7 3f 80 00       	push   $0x803ff7
  802d29:	e8 01 08 00 00       	call   80352f <_panic>
  802d2e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d31:	8b 00                	mov    (%eax),%eax
  802d33:	85 c0                	test   %eax,%eax
  802d35:	74 10                	je     802d47 <free_block+0x11b>
  802d37:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d3a:	8b 00                	mov    (%eax),%eax
  802d3c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d3f:	8b 52 04             	mov    0x4(%edx),%edx
  802d42:	89 50 04             	mov    %edx,0x4(%eax)
  802d45:	eb 0b                	jmp    802d52 <free_block+0x126>
  802d47:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d4a:	8b 40 04             	mov    0x4(%eax),%eax
  802d4d:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802d52:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d55:	8b 40 04             	mov    0x4(%eax),%eax
  802d58:	85 c0                	test   %eax,%eax
  802d5a:	74 0f                	je     802d6b <free_block+0x13f>
  802d5c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d5f:	8b 40 04             	mov    0x4(%eax),%eax
  802d62:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d65:	8b 12                	mov    (%edx),%edx
  802d67:	89 10                	mov    %edx,(%eax)
  802d69:	eb 0a                	jmp    802d75 <free_block+0x149>
  802d6b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d6e:	8b 00                	mov    (%eax),%eax
  802d70:	a3 48 50 98 00       	mov    %eax,0x985048
  802d75:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d78:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d7e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d81:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d88:	a1 54 50 98 00       	mov    0x985054,%eax
  802d8d:	48                   	dec    %eax
  802d8e:	a3 54 50 98 00       	mov    %eax,0x985054
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  802d93:	83 ec 0c             	sub    $0xc,%esp
  802d96:	ff 75 08             	pushl  0x8(%ebp)
  802d99:	e8 32 f6 ff ff       	call   8023d0 <insert_sorted_in_freeList>
  802d9e:	83 c4 10             	add    $0x10,%esp
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
	{
  802da1:	e9 01 01 00 00       	jmp    802ea7 <free_block+0x27b>
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
  802da6:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  802daa:	0f 85 d3 00 00 00    	jne    802e83 <free_block+0x257>
  802db0:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  802db4:	0f 85 c9 00 00 00    	jne    802e83 <free_block+0x257>
	{
		// merge the block will be free with its prev and next blocks
		uint32 prevSize = get_block_size(prevBlk);
  802dba:	83 ec 0c             	sub    $0xc,%esp
  802dbd:	ff 75 e8             	pushl  -0x18(%ebp)
  802dc0:	e8 38 f3 ff ff       	call   8020fd <get_block_size>
  802dc5:	83 c4 10             	add    $0x10,%esp
  802dc8:	89 45 c8             	mov    %eax,-0x38(%ebp)
		uint32 nextSize = get_block_size(nextBlk);
  802dcb:	83 ec 0c             	sub    $0xc,%esp
  802dce:	ff 75 e0             	pushl  -0x20(%ebp)
  802dd1:	e8 27 f3 ff ff       	call   8020fd <get_block_size>
  802dd6:	83 c4 10             	add    $0x10,%esp
  802dd9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 totalSize = freeSize + prevSize + nextSize; // size of main block and its prev and next blocks
  802ddc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ddf:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802de2:	01 c2                	add    %eax,%edx
  802de4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802de7:	01 d0                	add    %edx,%eax
  802de9:	89 45 c0             	mov    %eax,-0x40(%ebp)
		// extends prev block size to contain its size and the size of main and next blocks
		set_block_data(prevBlk,totalSize,0);
  802dec:	83 ec 04             	sub    $0x4,%esp
  802def:	6a 00                	push   $0x0
  802df1:	ff 75 c0             	pushl  -0x40(%ebp)
  802df4:	ff 75 e8             	pushl  -0x18(%ebp)
  802df7:	e8 7d f5 ff ff       	call   802379 <set_block_data>
  802dfc:	83 c4 10             	add    $0x10,%esp
		// remove next block because we merge it with its prev blocks
		LIST_REMOVE(&freeBlocksList, nextBlk);
  802dff:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802e03:	75 17                	jne    802e1c <free_block+0x1f0>
  802e05:	83 ec 04             	sub    $0x4,%esp
  802e08:	68 a0 40 80 00       	push   $0x8040a0
  802e0d:	68 94 01 00 00       	push   $0x194
  802e12:	68 f7 3f 80 00       	push   $0x803ff7
  802e17:	e8 13 07 00 00       	call   80352f <_panic>
  802e1c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e1f:	8b 00                	mov    (%eax),%eax
  802e21:	85 c0                	test   %eax,%eax
  802e23:	74 10                	je     802e35 <free_block+0x209>
  802e25:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e28:	8b 00                	mov    (%eax),%eax
  802e2a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e2d:	8b 52 04             	mov    0x4(%edx),%edx
  802e30:	89 50 04             	mov    %edx,0x4(%eax)
  802e33:	eb 0b                	jmp    802e40 <free_block+0x214>
  802e35:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e38:	8b 40 04             	mov    0x4(%eax),%eax
  802e3b:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802e40:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e43:	8b 40 04             	mov    0x4(%eax),%eax
  802e46:	85 c0                	test   %eax,%eax
  802e48:	74 0f                	je     802e59 <free_block+0x22d>
  802e4a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e4d:	8b 40 04             	mov    0x4(%eax),%eax
  802e50:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e53:	8b 12                	mov    (%edx),%edx
  802e55:	89 10                	mov    %edx,(%eax)
  802e57:	eb 0a                	jmp    802e63 <free_block+0x237>
  802e59:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e5c:	8b 00                	mov    (%eax),%eax
  802e5e:	a3 48 50 98 00       	mov    %eax,0x985048
  802e63:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e66:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e6c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e6f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e76:	a1 54 50 98 00       	mov    0x985054,%eax
  802e7b:	48                   	dec    %eax
  802e7c:	a3 54 50 98 00       	mov    %eax,0x985054
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
	{
  802e81:	eb 24                	jmp    802ea7 <free_block+0x27b>
	}
	else
	{
		// free it without any merge
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
  802e83:	83 ec 04             	sub    $0x4,%esp
  802e86:	6a 00                	push   $0x0
  802e88:	ff 75 f4             	pushl  -0xc(%ebp)
  802e8b:	ff 75 08             	pushl  0x8(%ebp)
  802e8e:	e8 e6 f4 ff ff       	call   802379 <set_block_data>
  802e93:	83 c4 10             	add    $0x10,%esp
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  802e96:	83 ec 0c             	sub    $0xc,%esp
  802e99:	ff 75 08             	pushl  0x8(%ebp)
  802e9c:	e8 2f f5 ff ff       	call   8023d0 <insert_sorted_in_freeList>
  802ea1:	83 c4 10             	add    $0x10,%esp
  802ea4:	eb 01                	jmp    802ea7 <free_block+0x27b>
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
	{
		return;
  802ea6:	90                   	nop
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
}
  802ea7:	c9                   	leave  
  802ea8:	c3                   	ret    

00802ea9 <realloc_block_FF>:
//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
  802ea9:	55                   	push   %ebp
  802eaa:	89 e5                	mov    %esp,%ebp
  802eac:	83 ec 38             	sub    $0x38,%esp
	//TODO: [PROJECT'24.MS1 - #08] [3] DYNAMIC ALLOCATOR - realloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(va == NULL && new_size == 0)
  802eaf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802eb3:	75 10                	jne    802ec5 <realloc_block_FF+0x1c>
  802eb5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802eb9:	75 0a                	jne    802ec5 <realloc_block_FF+0x1c>
	{
		return NULL;
  802ebb:	b8 00 00 00 00       	mov    $0x0,%eax
  802ec0:	e9 8b 04 00 00       	jmp    803350 <realloc_block_FF+0x4a7>
	}

	if(new_size == 0)
  802ec5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ec9:	75 18                	jne    802ee3 <realloc_block_FF+0x3a>
	{
		free_block(va);
  802ecb:	83 ec 0c             	sub    $0xc,%esp
  802ece:	ff 75 08             	pushl  0x8(%ebp)
  802ed1:	e8 56 fd ff ff       	call   802c2c <free_block>
  802ed6:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802ed9:	b8 00 00 00 00       	mov    $0x0,%eax
  802ede:	e9 6d 04 00 00       	jmp    803350 <realloc_block_FF+0x4a7>
	}

	if(va == NULL)
  802ee3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ee7:	75 13                	jne    802efc <realloc_block_FF+0x53>
	{
		return alloc_block_FF(new_size);
  802ee9:	83 ec 0c             	sub    $0xc,%esp
  802eec:	ff 75 0c             	pushl  0xc(%ebp)
  802eef:	e8 6f f6 ff ff       	call   802563 <alloc_block_FF>
  802ef4:	83 c4 10             	add    $0x10,%esp
  802ef7:	e9 54 04 00 00       	jmp    803350 <realloc_block_FF+0x4a7>
	}

	// if size is odd must be increment it by one
	if (new_size % 2 != 0)
  802efc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eff:	83 e0 01             	and    $0x1,%eax
  802f02:	85 c0                	test   %eax,%eax
  802f04:	74 03                	je     802f09 <realloc_block_FF+0x60>
	{
		new_size++;
  802f06:	ff 45 0c             	incl   0xc(%ebp)
	}

	// if size < 8 must be equal it to 8 because min size 8 excluding metadata
	if(new_size < 8)
  802f09:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  802f0d:	77 07                	ja     802f16 <realloc_block_FF+0x6d>
	{
		new_size = 8;
  802f0f:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	}

	new_size += 8; // adds its footer and header size
  802f16:	83 45 0c 08          	addl   $0x8,0xc(%ebp)

	uint32 actualSize = get_block_size(va);
  802f1a:	83 ec 0c             	sub    $0xc,%esp
  802f1d:	ff 75 08             	pushl  0x8(%ebp)
  802f20:	e8 d8 f1 ff ff       	call   8020fd <get_block_size>
  802f25:	83 c4 10             	add    $0x10,%esp
  802f28:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(actualSize == new_size)
  802f2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802f31:	75 08                	jne    802f3b <realloc_block_FF+0x92>
	{
		// don't change any thing
		return va;
  802f33:	8b 45 08             	mov    0x8(%ebp),%eax
  802f36:	e9 15 04 00 00       	jmp    803350 <realloc_block_FF+0x4a7>
	}

	// next block for the block we want to change its size
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + actualSize);
  802f3b:	8b 55 08             	mov    0x8(%ebp),%edx
  802f3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f41:	01 d0                	add    %edx,%eax
  802f43:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  802f46:	83 ec 0c             	sub    $0xc,%esp
  802f49:	ff 75 f0             	pushl  -0x10(%ebp)
  802f4c:	e8 c5 f1 ff ff       	call   802116 <is_free_block>
  802f51:	83 c4 10             	add    $0x10,%esp
  802f54:	0f be c0             	movsbl %al,%eax
  802f57:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 nextSize = get_block_size(nextBlk);
  802f5a:	83 ec 0c             	sub    $0xc,%esp
  802f5d:	ff 75 f0             	pushl  -0x10(%ebp)
  802f60:	e8 98 f1 ff ff       	call   8020fd <get_block_size>
  802f65:	83 c4 10             	add    $0x10,%esp
  802f68:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// increase the size of block
	if(new_size > actualSize)
  802f6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f6e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802f71:	0f 86 a7 02 00 00    	jbe    80321e <realloc_block_FF+0x375>
	{
		if(isNextFree)
  802f77:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f7b:	0f 84 86 02 00 00    	je     803207 <realloc_block_FF+0x35e>
		{
			if(nextSize + actualSize == new_size) // block and nextblock = newSizeBlock
  802f81:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f87:	01 d0                	add    %edx,%eax
  802f89:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802f8c:	0f 85 b2 00 00 00    	jne    803044 <realloc_block_FF+0x19b>
			{
				set_block_data(va,new_size,!(is_free_block(va)));// update size in block
  802f92:	83 ec 0c             	sub    $0xc,%esp
  802f95:	ff 75 08             	pushl  0x8(%ebp)
  802f98:	e8 79 f1 ff ff       	call   802116 <is_free_block>
  802f9d:	83 c4 10             	add    $0x10,%esp
  802fa0:	84 c0                	test   %al,%al
  802fa2:	0f 94 c0             	sete   %al
  802fa5:	0f b6 c0             	movzbl %al,%eax
  802fa8:	83 ec 04             	sub    $0x4,%esp
  802fab:	50                   	push   %eax
  802fac:	ff 75 0c             	pushl  0xc(%ebp)
  802faf:	ff 75 08             	pushl  0x8(%ebp)
  802fb2:	e8 c2 f3 ff ff       	call   802379 <set_block_data>
  802fb7:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);// remove next because it is = zero
  802fba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fbe:	75 17                	jne    802fd7 <realloc_block_FF+0x12e>
  802fc0:	83 ec 04             	sub    $0x4,%esp
  802fc3:	68 a0 40 80 00       	push   $0x8040a0
  802fc8:	68 db 01 00 00       	push   $0x1db
  802fcd:	68 f7 3f 80 00       	push   $0x803ff7
  802fd2:	e8 58 05 00 00       	call   80352f <_panic>
  802fd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fda:	8b 00                	mov    (%eax),%eax
  802fdc:	85 c0                	test   %eax,%eax
  802fde:	74 10                	je     802ff0 <realloc_block_FF+0x147>
  802fe0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe3:	8b 00                	mov    (%eax),%eax
  802fe5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fe8:	8b 52 04             	mov    0x4(%edx),%edx
  802feb:	89 50 04             	mov    %edx,0x4(%eax)
  802fee:	eb 0b                	jmp    802ffb <realloc_block_FF+0x152>
  802ff0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff3:	8b 40 04             	mov    0x4(%eax),%eax
  802ff6:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802ffb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ffe:	8b 40 04             	mov    0x4(%eax),%eax
  803001:	85 c0                	test   %eax,%eax
  803003:	74 0f                	je     803014 <realloc_block_FF+0x16b>
  803005:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803008:	8b 40 04             	mov    0x4(%eax),%eax
  80300b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80300e:	8b 12                	mov    (%edx),%edx
  803010:	89 10                	mov    %edx,(%eax)
  803012:	eb 0a                	jmp    80301e <realloc_block_FF+0x175>
  803014:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803017:	8b 00                	mov    (%eax),%eax
  803019:	a3 48 50 98 00       	mov    %eax,0x985048
  80301e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803021:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803027:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80302a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803031:	a1 54 50 98 00       	mov    0x985054,%eax
  803036:	48                   	dec    %eax
  803037:	a3 54 50 98 00       	mov    %eax,0x985054
				return va;
  80303c:	8b 45 08             	mov    0x8(%ebp),%eax
  80303f:	e9 0c 03 00 00       	jmp    803350 <realloc_block_FF+0x4a7>
			}
			else if(nextSize + actualSize > new_size) // new size is less than next and main blocks
  803044:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803047:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304a:	01 d0                	add    %edx,%eax
  80304c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80304f:	0f 86 b2 01 00 00    	jbe    803207 <realloc_block_FF+0x35e>
			{
				uint32 requiredSize = new_size - actualSize; // size that we need from the next block
  803055:	8b 45 0c             	mov    0xc(%ebp),%eax
  803058:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80305b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				uint32 remainingNext = nextSize - requiredSize; // size that will remain from the next block after we split it
  80305e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803061:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  803064:	89 45 e0             	mov    %eax,-0x20(%ebp)

				// if next size will not fit another block (internal fragmentation)
				if(remainingNext < 16)
  803067:	83 7d e0 0f          	cmpl   $0xf,-0x20(%ebp)
  80306b:	0f 87 b8 00 00 00    	ja     803129 <realloc_block_FF+0x280>
				{
					// we will take the main size of the block and its next size also
					set_block_data(va,actualSize + nextSize,!(is_free_block(va)));
  803071:	83 ec 0c             	sub    $0xc,%esp
  803074:	ff 75 08             	pushl  0x8(%ebp)
  803077:	e8 9a f0 ff ff       	call   802116 <is_free_block>
  80307c:	83 c4 10             	add    $0x10,%esp
  80307f:	84 c0                	test   %al,%al
  803081:	0f 94 c0             	sete   %al
  803084:	0f b6 c0             	movzbl %al,%eax
  803087:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80308a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80308d:	01 ca                	add    %ecx,%edx
  80308f:	83 ec 04             	sub    $0x4,%esp
  803092:	50                   	push   %eax
  803093:	52                   	push   %edx
  803094:	ff 75 08             	pushl  0x8(%ebp)
  803097:	e8 dd f2 ff ff       	call   802379 <set_block_data>
  80309c:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,nextBlk);
  80309f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030a3:	75 17                	jne    8030bc <realloc_block_FF+0x213>
  8030a5:	83 ec 04             	sub    $0x4,%esp
  8030a8:	68 a0 40 80 00       	push   $0x8040a0
  8030ad:	68 e8 01 00 00       	push   $0x1e8
  8030b2:	68 f7 3f 80 00       	push   $0x803ff7
  8030b7:	e8 73 04 00 00       	call   80352f <_panic>
  8030bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030bf:	8b 00                	mov    (%eax),%eax
  8030c1:	85 c0                	test   %eax,%eax
  8030c3:	74 10                	je     8030d5 <realloc_block_FF+0x22c>
  8030c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030c8:	8b 00                	mov    (%eax),%eax
  8030ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030cd:	8b 52 04             	mov    0x4(%edx),%edx
  8030d0:	89 50 04             	mov    %edx,0x4(%eax)
  8030d3:	eb 0b                	jmp    8030e0 <realloc_block_FF+0x237>
  8030d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030d8:	8b 40 04             	mov    0x4(%eax),%eax
  8030db:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8030e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030e3:	8b 40 04             	mov    0x4(%eax),%eax
  8030e6:	85 c0                	test   %eax,%eax
  8030e8:	74 0f                	je     8030f9 <realloc_block_FF+0x250>
  8030ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ed:	8b 40 04             	mov    0x4(%eax),%eax
  8030f0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030f3:	8b 12                	mov    (%edx),%edx
  8030f5:	89 10                	mov    %edx,(%eax)
  8030f7:	eb 0a                	jmp    803103 <realloc_block_FF+0x25a>
  8030f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030fc:	8b 00                	mov    (%eax),%eax
  8030fe:	a3 48 50 98 00       	mov    %eax,0x985048
  803103:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803106:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80310c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80310f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803116:	a1 54 50 98 00       	mov    0x985054,%eax
  80311b:	48                   	dec    %eax
  80311c:	a3 54 50 98 00       	mov    %eax,0x985054
					return va;
  803121:	8b 45 08             	mov    0x8(%ebp),%eax
  803124:	e9 27 02 00 00       	jmp    803350 <realloc_block_FF+0x4a7>
				}
				else // if next size can be fit another block (split)
				{
					LIST_REMOVE(&freeBlocksList,nextBlk);
  803129:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80312d:	75 17                	jne    803146 <realloc_block_FF+0x29d>
  80312f:	83 ec 04             	sub    $0x4,%esp
  803132:	68 a0 40 80 00       	push   $0x8040a0
  803137:	68 ed 01 00 00       	push   $0x1ed
  80313c:	68 f7 3f 80 00       	push   $0x803ff7
  803141:	e8 e9 03 00 00       	call   80352f <_panic>
  803146:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803149:	8b 00                	mov    (%eax),%eax
  80314b:	85 c0                	test   %eax,%eax
  80314d:	74 10                	je     80315f <realloc_block_FF+0x2b6>
  80314f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803152:	8b 00                	mov    (%eax),%eax
  803154:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803157:	8b 52 04             	mov    0x4(%edx),%edx
  80315a:	89 50 04             	mov    %edx,0x4(%eax)
  80315d:	eb 0b                	jmp    80316a <realloc_block_FF+0x2c1>
  80315f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803162:	8b 40 04             	mov    0x4(%eax),%eax
  803165:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80316a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80316d:	8b 40 04             	mov    0x4(%eax),%eax
  803170:	85 c0                	test   %eax,%eax
  803172:	74 0f                	je     803183 <realloc_block_FF+0x2da>
  803174:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803177:	8b 40 04             	mov    0x4(%eax),%eax
  80317a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80317d:	8b 12                	mov    (%edx),%edx
  80317f:	89 10                	mov    %edx,(%eax)
  803181:	eb 0a                	jmp    80318d <realloc_block_FF+0x2e4>
  803183:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803186:	8b 00                	mov    (%eax),%eax
  803188:	a3 48 50 98 00       	mov    %eax,0x985048
  80318d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803190:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803196:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803199:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031a0:	a1 54 50 98 00       	mov    0x985054,%eax
  8031a5:	48                   	dec    %eax
  8031a6:	a3 54 50 98 00       	mov    %eax,0x985054
					nextBlk = (struct BlockElement *)((char *)va + new_size); //update nextBlk address
  8031ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8031ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031b1:	01 d0                	add    %edx,%eax
  8031b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
					set_block_data(nextBlk,remainingNext,0); // update nextBlkSize
  8031b6:	83 ec 04             	sub    $0x4,%esp
  8031b9:	6a 00                	push   $0x0
  8031bb:	ff 75 e0             	pushl  -0x20(%ebp)
  8031be:	ff 75 f0             	pushl  -0x10(%ebp)
  8031c1:	e8 b3 f1 ff ff       	call   802379 <set_block_data>
  8031c6:	83 c4 10             	add    $0x10,%esp
					set_block_data(va,new_size,!(is_free_block(va))); // update size of newblock
  8031c9:	83 ec 0c             	sub    $0xc,%esp
  8031cc:	ff 75 08             	pushl  0x8(%ebp)
  8031cf:	e8 42 ef ff ff       	call   802116 <is_free_block>
  8031d4:	83 c4 10             	add    $0x10,%esp
  8031d7:	84 c0                	test   %al,%al
  8031d9:	0f 94 c0             	sete   %al
  8031dc:	0f b6 c0             	movzbl %al,%eax
  8031df:	83 ec 04             	sub    $0x4,%esp
  8031e2:	50                   	push   %eax
  8031e3:	ff 75 0c             	pushl  0xc(%ebp)
  8031e6:	ff 75 08             	pushl  0x8(%ebp)
  8031e9:	e8 8b f1 ff ff       	call   802379 <set_block_data>
  8031ee:	83 c4 10             	add    $0x10,%esp
					insert_sorted_in_freeList(nextBlk);
  8031f1:	83 ec 0c             	sub    $0xc,%esp
  8031f4:	ff 75 f0             	pushl  -0x10(%ebp)
  8031f7:	e8 d4 f1 ff ff       	call   8023d0 <insert_sorted_in_freeList>
  8031fc:	83 c4 10             	add    $0x10,%esp
					return va;
  8031ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803202:	e9 49 01 00 00       	jmp    803350 <realloc_block_FF+0x4a7>
				}
			}
		}
		// if next block isn't free or not fit the new size
		return alloc_block_FF(new_size - 8);
  803207:	8b 45 0c             	mov    0xc(%ebp),%eax
  80320a:	83 e8 08             	sub    $0x8,%eax
  80320d:	83 ec 0c             	sub    $0xc,%esp
  803210:	50                   	push   %eax
  803211:	e8 4d f3 ff ff       	call   802563 <alloc_block_FF>
  803216:	83 c4 10             	add    $0x10,%esp
  803219:	e9 32 01 00 00       	jmp    803350 <realloc_block_FF+0x4a7>
	}
	else if(new_size < actualSize) // to shrink block
  80321e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803221:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803224:	0f 83 21 01 00 00    	jae    80334b <realloc_block_FF+0x4a2>
	{
		uint32 remainingSize = actualSize - new_size; // size that will remain from the main block after we shrink it
  80322a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322d:	2b 45 0c             	sub    0xc(%ebp),%eax
  803230:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(remainingSize < 16 && isNextFree == 0) // internal fragmentation
  803233:	83 7d dc 0f          	cmpl   $0xf,-0x24(%ebp)
  803237:	77 0e                	ja     803247 <realloc_block_FF+0x39e>
  803239:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80323d:	75 08                	jne    803247 <realloc_block_FF+0x39e>
		{
			// don't change its size
			return va;
  80323f:	8b 45 08             	mov    0x8(%ebp),%eax
  803242:	e9 09 01 00 00       	jmp    803350 <realloc_block_FF+0x4a7>
		}
		else // remainingSize fit in a new block
		{
			struct BlockElement *mainBlk = (struct BlockElement *)va;
  803247:	8b 45 08             	mov    0x8(%ebp),%eax
  80324a:	89 45 d8             	mov    %eax,-0x28(%ebp)
			// update main block with new size
			set_block_data(mainBlk,new_size,!(is_free_block(va)));
  80324d:	83 ec 0c             	sub    $0xc,%esp
  803250:	ff 75 08             	pushl  0x8(%ebp)
  803253:	e8 be ee ff ff       	call   802116 <is_free_block>
  803258:	83 c4 10             	add    $0x10,%esp
  80325b:	84 c0                	test   %al,%al
  80325d:	0f 94 c0             	sete   %al
  803260:	0f b6 c0             	movzbl %al,%eax
  803263:	83 ec 04             	sub    $0x4,%esp
  803266:	50                   	push   %eax
  803267:	ff 75 0c             	pushl  0xc(%ebp)
  80326a:	ff 75 d8             	pushl  -0x28(%ebp)
  80326d:	e8 07 f1 ff ff       	call   802379 <set_block_data>
  803272:	83 c4 10             	add    $0x10,%esp

			// the blk with remaining size
			struct BlockElement *remainingBlk=(struct BlockElement *)((char*)mainBlk + new_size);
  803275:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803278:	8b 45 0c             	mov    0xc(%ebp),%eax
  80327b:	01 d0                	add    %edx,%eax
  80327d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			set_block_data(remainingBlk,remainingSize,0);
  803280:	83 ec 04             	sub    $0x4,%esp
  803283:	6a 00                	push   $0x0
  803285:	ff 75 dc             	pushl  -0x24(%ebp)
  803288:	ff 75 d4             	pushl  -0x2c(%ebp)
  80328b:	e8 e9 f0 ff ff       	call   802379 <set_block_data>
  803290:	83 c4 10             	add    $0x10,%esp

			if(isNextFree)
  803293:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803297:	0f 84 9b 00 00 00    	je     803338 <realloc_block_FF+0x48f>
			{
				// merge splited block with its next block
				set_block_data(remainingBlk,(remainingSize + nextSize),0);//merge remaining with its next block
  80329d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8032a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a3:	01 d0                	add    %edx,%eax
  8032a5:	83 ec 04             	sub    $0x4,%esp
  8032a8:	6a 00                	push   $0x0
  8032aa:	50                   	push   %eax
  8032ab:	ff 75 d4             	pushl  -0x2c(%ebp)
  8032ae:	e8 c6 f0 ff ff       	call   802379 <set_block_data>
  8032b3:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);
  8032b6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8032ba:	75 17                	jne    8032d3 <realloc_block_FF+0x42a>
  8032bc:	83 ec 04             	sub    $0x4,%esp
  8032bf:	68 a0 40 80 00       	push   $0x8040a0
  8032c4:	68 10 02 00 00       	push   $0x210
  8032c9:	68 f7 3f 80 00       	push   $0x803ff7
  8032ce:	e8 5c 02 00 00       	call   80352f <_panic>
  8032d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032d6:	8b 00                	mov    (%eax),%eax
  8032d8:	85 c0                	test   %eax,%eax
  8032da:	74 10                	je     8032ec <realloc_block_FF+0x443>
  8032dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032df:	8b 00                	mov    (%eax),%eax
  8032e1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032e4:	8b 52 04             	mov    0x4(%edx),%edx
  8032e7:	89 50 04             	mov    %edx,0x4(%eax)
  8032ea:	eb 0b                	jmp    8032f7 <realloc_block_FF+0x44e>
  8032ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032ef:	8b 40 04             	mov    0x4(%eax),%eax
  8032f2:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8032f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032fa:	8b 40 04             	mov    0x4(%eax),%eax
  8032fd:	85 c0                	test   %eax,%eax
  8032ff:	74 0f                	je     803310 <realloc_block_FF+0x467>
  803301:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803304:	8b 40 04             	mov    0x4(%eax),%eax
  803307:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80330a:	8b 12                	mov    (%edx),%edx
  80330c:	89 10                	mov    %edx,(%eax)
  80330e:	eb 0a                	jmp    80331a <realloc_block_FF+0x471>
  803310:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803313:	8b 00                	mov    (%eax),%eax
  803315:	a3 48 50 98 00       	mov    %eax,0x985048
  80331a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80331d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803323:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803326:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80332d:	a1 54 50 98 00       	mov    0x985054,%eax
  803332:	48                   	dec    %eax
  803333:	a3 54 50 98 00       	mov    %eax,0x985054
			}
			insert_sorted_in_freeList(remainingBlk);
  803338:	83 ec 0c             	sub    $0xc,%esp
  80333b:	ff 75 d4             	pushl  -0x2c(%ebp)
  80333e:	e8 8d f0 ff ff       	call   8023d0 <insert_sorted_in_freeList>
  803343:	83 c4 10             	add    $0x10,%esp
			return mainBlk;
  803346:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803349:	eb 05                	jmp    803350 <realloc_block_FF+0x4a7>
		}
	}
	return NULL;
  80334b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803350:	c9                   	leave  
  803351:	c3                   	ret    

00803352 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803352:	55                   	push   %ebp
  803353:	89 e5                	mov    %esp,%ebp
  803355:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803358:	83 ec 04             	sub    $0x4,%esp
  80335b:	68 c0 40 80 00       	push   $0x8040c0
  803360:	68 20 02 00 00       	push   $0x220
  803365:	68 f7 3f 80 00       	push   $0x803ff7
  80336a:	e8 c0 01 00 00       	call   80352f <_panic>

0080336f <alloc_block_NF>:
}
//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  80336f:	55                   	push   %ebp
  803370:	89 e5                	mov    %esp,%ebp
  803372:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803375:	83 ec 04             	sub    $0x4,%esp
  803378:	68 e8 40 80 00       	push   $0x8040e8
  80337d:	68 28 02 00 00       	push   $0x228
  803382:	68 f7 3f 80 00       	push   $0x803ff7
  803387:	e8 a3 01 00 00       	call   80352f <_panic>

0080338c <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  80338c:	55                   	push   %ebp
  80338d:	89 e5                	mov    %esp,%ebp
  80338f:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("create_semaphore is not implemented yet");
	//Your Code is Here...

	//create object of __semdata struct and allocate it using smalloc with sizeof __semdata struct
	struct __semdata* semaphoryData = (struct __semdata *)smalloc(semaphoreName , sizeof(struct __semdata) ,1);
  803392:	83 ec 04             	sub    $0x4,%esp
  803395:	6a 01                	push   $0x1
  803397:	6a 58                	push   $0x58
  803399:	ff 75 0c             	pushl  0xc(%ebp)
  80339c:	e8 c1 e2 ff ff       	call   801662 <smalloc>
  8033a1:	83 c4 10             	add    $0x10,%esp
  8033a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(semaphoryData == NULL)
  8033a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033ab:	75 14                	jne    8033c1 <create_semaphore+0x35>
	{
		panic("Not Enough Space to allocate semdata object!!");
  8033ad:	83 ec 04             	sub    $0x4,%esp
  8033b0:	68 10 41 80 00       	push   $0x804110
  8033b5:	6a 10                	push   $0x10
  8033b7:	68 3e 41 80 00       	push   $0x80413e
  8033bc:	e8 6e 01 00 00       	call   80352f <_panic>
	}
	//aboveObject.queue pass it to init_queue() function
	sys_init_queue(&(semaphoryData->queue));
  8033c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c4:	83 ec 0c             	sub    $0xc,%esp
  8033c7:	50                   	push   %eax
  8033c8:	e8 bc ec ff ff       	call   802089 <sys_init_queue>
  8033cd:	83 c4 10             	add    $0x10,%esp
	//lock variable initially with zero
	semaphoryData->lock = 0;
  8033d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d3:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
	//initialize aboveObject with semaphore name and value
	strncpy(semaphoryData->name , semaphoreName , sizeof(semaphoryData->name));
  8033da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033dd:	83 c0 18             	add    $0x18,%eax
  8033e0:	83 ec 04             	sub    $0x4,%esp
  8033e3:	6a 40                	push   $0x40
  8033e5:	ff 75 0c             	pushl  0xc(%ebp)
  8033e8:	50                   	push   %eax
  8033e9:	e8 1e d9 ff ff       	call   800d0c <strncpy>
  8033ee:	83 c4 10             	add    $0x10,%esp
	semaphoryData->count = value;
  8033f1:	8b 55 10             	mov    0x10(%ebp),%edx
  8033f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f7:	89 50 10             	mov    %edx,0x10(%eax)

	//create object of semaphore struct
	struct semaphore semaphory;
	//add aboveObject to this semaphore object
	semaphory.semdata = semaphoryData;
  8033fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//return semaphore object
	return semaphory;
  803400:	8b 45 08             	mov    0x8(%ebp),%eax
  803403:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803406:	89 10                	mov    %edx,(%eax)
}
  803408:	8b 45 08             	mov    0x8(%ebp),%eax
  80340b:	c9                   	leave  
  80340c:	c2 04 00             	ret    $0x4

0080340f <get_semaphore>:
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  80340f:	55                   	push   %ebp
  803410:	89 e5                	mov    %esp,%ebp
  803412:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("get_semaphore is not implemented yet");
	//Your Code is Here...

	// get the semdata object that is allocated, using sget
	struct __semdata* semaphoryData = sget(ownerEnvID, semaphoreName);
  803415:	83 ec 08             	sub    $0x8,%esp
  803418:	ff 75 10             	pushl  0x10(%ebp)
  80341b:	ff 75 0c             	pushl  0xc(%ebp)
  80341e:	e8 da e3 ff ff       	call   8017fd <sget>
  803423:	83 c4 10             	add    $0x10,%esp
  803426:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(semaphoryData == NULL)
  803429:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80342d:	75 14                	jne    803443 <get_semaphore+0x34>
	{
		panic("semdatat object does not exist!!");
  80342f:	83 ec 04             	sub    $0x4,%esp
  803432:	68 50 41 80 00       	push   $0x804150
  803437:	6a 2c                	push   $0x2c
  803439:	68 3e 41 80 00       	push   $0x80413e
  80343e:	e8 ec 00 00 00       	call   80352f <_panic>
	}
	//create object of semaphore struct
	struct semaphore semaphory;
	//add semdata object to this semaphore object
	semaphory.semdata = semaphoryData;
  803443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803446:	89 45 f0             	mov    %eax,-0x10(%ebp)
	return semaphory;
  803449:	8b 45 08             	mov    0x8(%ebp),%eax
  80344c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80344f:	89 10                	mov    %edx,(%eax)
}
  803451:	8b 45 08             	mov    0x8(%ebp),%eax
  803454:	c9                   	leave  
  803455:	c2 04 00             	ret    $0x4

00803458 <wait_semaphore>:

void wait_semaphore(struct semaphore sem)
{
  803458:	55                   	push   %ebp
  803459:	89 e5                	mov    %esp,%ebp
  80345b:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("wait_semaphore is not implemented yet");
	//Your Code is Here...

	//acquire semaphore lock
	uint32 myKey = 1;
  80345e:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	do
	{
		xchg(&myKey, sem.semdata->lock); // xchg atomically exchanges values
  803465:	8b 45 08             	mov    0x8(%ebp),%eax
  803468:	8b 40 14             	mov    0x14(%eax),%eax
  80346b:	8d 55 e8             	lea    -0x18(%ebp),%edx
  80346e:	89 55 f4             	mov    %edx,-0xc(%ebp)
  803471:	89 45 f0             	mov    %eax,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  803474:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803477:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80347a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80347d:	f0 87 02             	lock xchg %eax,(%edx)
  803480:	89 45 ec             	mov    %eax,-0x14(%ebp)
	} while (myKey != 0);
  803483:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803486:	85 c0                	test   %eax,%eax
  803488:	75 db                	jne    803465 <wait_semaphore+0xd>

	//decrement the semaphore counter
	sem.semdata->count--;
  80348a:	8b 45 08             	mov    0x8(%ebp),%eax
  80348d:	8b 50 10             	mov    0x10(%eax),%edx
  803490:	4a                   	dec    %edx
  803491:	89 50 10             	mov    %edx,0x10(%eax)

	if (sem.semdata->count < 0)
  803494:	8b 45 08             	mov    0x8(%ebp),%eax
  803497:	8b 40 10             	mov    0x10(%eax),%eax
  80349a:	85 c0                	test   %eax,%eax
  80349c:	79 18                	jns    8034b6 <wait_semaphore+0x5e>
	{
		// block the current process
		sys_block_process(&(sem.semdata->queue),&(sem.semdata->lock));
  80349e:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a1:	8d 50 14             	lea    0x14(%eax),%edx
  8034a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a7:	83 ec 08             	sub    $0x8,%esp
  8034aa:	52                   	push   %edx
  8034ab:	50                   	push   %eax
  8034ac:	e8 f4 eb ff ff       	call   8020a5 <sys_block_process>
  8034b1:	83 c4 10             	add    $0x10,%esp
  8034b4:	eb 0a                	jmp    8034c0 <wait_semaphore+0x68>
		return;
	}
	//release semaphore lock
	sem.semdata->lock = 0;
  8034b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b9:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
}
  8034c0:	c9                   	leave  
  8034c1:	c3                   	ret    

008034c2 <signal_semaphore>:

void signal_semaphore(struct semaphore sem)
{
  8034c2:	55                   	push   %ebp
  8034c3:	89 e5                	mov    %esp,%ebp
  8034c5:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("signal_semaphore is not implemented yet");
	//Your Code is Here...

	//acquire semaphore lock
	uint32 myKey = 1;
  8034c8:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	do
	{
		xchg(&myKey, sem.semdata->lock); // xchg atomically exchanges values
  8034cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d2:	8b 40 14             	mov    0x14(%eax),%eax
  8034d5:	8d 55 e8             	lea    -0x18(%ebp),%edx
  8034d8:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8034db:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8034de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034e4:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8034e7:	f0 87 02             	lock xchg %eax,(%edx)
  8034ea:	89 45 ec             	mov    %eax,-0x14(%ebp)
	} while (myKey != 0);
  8034ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034f0:	85 c0                	test   %eax,%eax
  8034f2:	75 db                	jne    8034cf <signal_semaphore+0xd>

	// increment the semaphore counter
	sem.semdata->count++;
  8034f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f7:	8b 50 10             	mov    0x10(%eax),%edx
  8034fa:	42                   	inc    %edx
  8034fb:	89 50 10             	mov    %edx,0x10(%eax)

	if (sem.semdata->count <= 0) {
  8034fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803501:	8b 40 10             	mov    0x10(%eax),%eax
  803504:	85 c0                	test   %eax,%eax
  803506:	7f 0f                	jg     803517 <signal_semaphore+0x55>
		// unblock the current process
		sys_unblock_process(&(sem.semdata->queue));
  803508:	8b 45 08             	mov    0x8(%ebp),%eax
  80350b:	83 ec 0c             	sub    $0xc,%esp
  80350e:	50                   	push   %eax
  80350f:	e8 af eb ff ff       	call   8020c3 <sys_unblock_process>
  803514:	83 c4 10             	add    $0x10,%esp
	}

	// release the lock
	sem.semdata->lock = 0;
  803517:	8b 45 08             	mov    0x8(%ebp),%eax
  80351a:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
}
  803521:	90                   	nop
  803522:	c9                   	leave  
  803523:	c3                   	ret    

00803524 <semaphore_count>:

int semaphore_count(struct semaphore sem)
{
  803524:	55                   	push   %ebp
  803525:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  803527:	8b 45 08             	mov    0x8(%ebp),%eax
  80352a:	8b 40 10             	mov    0x10(%eax),%eax
}
  80352d:	5d                   	pop    %ebp
  80352e:	c3                   	ret    

0080352f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80352f:	55                   	push   %ebp
  803530:	89 e5                	mov    %esp,%ebp
  803532:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803535:	8d 45 10             	lea    0x10(%ebp),%eax
  803538:	83 c0 04             	add    $0x4,%eax
  80353b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80353e:	a1 60 50 98 00       	mov    0x985060,%eax
  803543:	85 c0                	test   %eax,%eax
  803545:	74 16                	je     80355d <_panic+0x2e>
		cprintf("%s: ", argv0);
  803547:	a1 60 50 98 00       	mov    0x985060,%eax
  80354c:	83 ec 08             	sub    $0x8,%esp
  80354f:	50                   	push   %eax
  803550:	68 74 41 80 00       	push   $0x804174
  803555:	e8 a1 d0 ff ff       	call   8005fb <cprintf>
  80355a:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80355d:	a1 04 50 80 00       	mov    0x805004,%eax
  803562:	ff 75 0c             	pushl  0xc(%ebp)
  803565:	ff 75 08             	pushl  0x8(%ebp)
  803568:	50                   	push   %eax
  803569:	68 79 41 80 00       	push   $0x804179
  80356e:	e8 88 d0 ff ff       	call   8005fb <cprintf>
  803573:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803576:	8b 45 10             	mov    0x10(%ebp),%eax
  803579:	83 ec 08             	sub    $0x8,%esp
  80357c:	ff 75 f4             	pushl  -0xc(%ebp)
  80357f:	50                   	push   %eax
  803580:	e8 0b d0 ff ff       	call   800590 <vcprintf>
  803585:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803588:	83 ec 08             	sub    $0x8,%esp
  80358b:	6a 00                	push   $0x0
  80358d:	68 95 41 80 00       	push   $0x804195
  803592:	e8 f9 cf ff ff       	call   800590 <vcprintf>
  803597:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80359a:	e8 7a cf ff ff       	call   800519 <exit>

	// should not return here
	while (1) ;
  80359f:	eb fe                	jmp    80359f <_panic+0x70>

008035a1 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8035a1:	55                   	push   %ebp
  8035a2:	89 e5                	mov    %esp,%ebp
  8035a4:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8035a7:	a1 20 50 80 00       	mov    0x805020,%eax
  8035ac:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8035b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035b5:	39 c2                	cmp    %eax,%edx
  8035b7:	74 14                	je     8035cd <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8035b9:	83 ec 04             	sub    $0x4,%esp
  8035bc:	68 98 41 80 00       	push   $0x804198
  8035c1:	6a 26                	push   $0x26
  8035c3:	68 e4 41 80 00       	push   $0x8041e4
  8035c8:	e8 62 ff ff ff       	call   80352f <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8035cd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8035d4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8035db:	e9 c5 00 00 00       	jmp    8036a5 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8035e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035e3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8035ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ed:	01 d0                	add    %edx,%eax
  8035ef:	8b 00                	mov    (%eax),%eax
  8035f1:	85 c0                	test   %eax,%eax
  8035f3:	75 08                	jne    8035fd <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8035f5:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8035f8:	e9 a5 00 00 00       	jmp    8036a2 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8035fd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803604:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80360b:	eb 69                	jmp    803676 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80360d:	a1 20 50 80 00       	mov    0x805020,%eax
  803612:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  803618:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80361b:	89 d0                	mov    %edx,%eax
  80361d:	01 c0                	add    %eax,%eax
  80361f:	01 d0                	add    %edx,%eax
  803621:	c1 e0 03             	shl    $0x3,%eax
  803624:	01 c8                	add    %ecx,%eax
  803626:	8a 40 04             	mov    0x4(%eax),%al
  803629:	84 c0                	test   %al,%al
  80362b:	75 46                	jne    803673 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80362d:	a1 20 50 80 00       	mov    0x805020,%eax
  803632:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  803638:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80363b:	89 d0                	mov    %edx,%eax
  80363d:	01 c0                	add    %eax,%eax
  80363f:	01 d0                	add    %edx,%eax
  803641:	c1 e0 03             	shl    $0x3,%eax
  803644:	01 c8                	add    %ecx,%eax
  803646:	8b 00                	mov    (%eax),%eax
  803648:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80364b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80364e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803653:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803655:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803658:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80365f:	8b 45 08             	mov    0x8(%ebp),%eax
  803662:	01 c8                	add    %ecx,%eax
  803664:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803666:	39 c2                	cmp    %eax,%edx
  803668:	75 09                	jne    803673 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80366a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803671:	eb 15                	jmp    803688 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803673:	ff 45 e8             	incl   -0x18(%ebp)
  803676:	a1 20 50 80 00       	mov    0x805020,%eax
  80367b:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803681:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803684:	39 c2                	cmp    %eax,%edx
  803686:	77 85                	ja     80360d <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803688:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80368c:	75 14                	jne    8036a2 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80368e:	83 ec 04             	sub    $0x4,%esp
  803691:	68 f0 41 80 00       	push   $0x8041f0
  803696:	6a 3a                	push   $0x3a
  803698:	68 e4 41 80 00       	push   $0x8041e4
  80369d:	e8 8d fe ff ff       	call   80352f <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8036a2:	ff 45 f0             	incl   -0x10(%ebp)
  8036a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036a8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8036ab:	0f 8c 2f ff ff ff    	jl     8035e0 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8036b1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8036b8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8036bf:	eb 26                	jmp    8036e7 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8036c1:	a1 20 50 80 00       	mov    0x805020,%eax
  8036c6:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8036cc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8036cf:	89 d0                	mov    %edx,%eax
  8036d1:	01 c0                	add    %eax,%eax
  8036d3:	01 d0                	add    %edx,%eax
  8036d5:	c1 e0 03             	shl    $0x3,%eax
  8036d8:	01 c8                	add    %ecx,%eax
  8036da:	8a 40 04             	mov    0x4(%eax),%al
  8036dd:	3c 01                	cmp    $0x1,%al
  8036df:	75 03                	jne    8036e4 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8036e1:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8036e4:	ff 45 e0             	incl   -0x20(%ebp)
  8036e7:	a1 20 50 80 00       	mov    0x805020,%eax
  8036ec:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8036f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036f5:	39 c2                	cmp    %eax,%edx
  8036f7:	77 c8                	ja     8036c1 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8036f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036fc:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8036ff:	74 14                	je     803715 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803701:	83 ec 04             	sub    $0x4,%esp
  803704:	68 44 42 80 00       	push   $0x804244
  803709:	6a 44                	push   $0x44
  80370b:	68 e4 41 80 00       	push   $0x8041e4
  803710:	e8 1a fe ff ff       	call   80352f <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803715:	90                   	nop
  803716:	c9                   	leave  
  803717:	c3                   	ret    

00803718 <__udivdi3>:
  803718:	55                   	push   %ebp
  803719:	57                   	push   %edi
  80371a:	56                   	push   %esi
  80371b:	53                   	push   %ebx
  80371c:	83 ec 1c             	sub    $0x1c,%esp
  80371f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803723:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803727:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80372b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80372f:	89 ca                	mov    %ecx,%edx
  803731:	89 f8                	mov    %edi,%eax
  803733:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803737:	85 f6                	test   %esi,%esi
  803739:	75 2d                	jne    803768 <__udivdi3+0x50>
  80373b:	39 cf                	cmp    %ecx,%edi
  80373d:	77 65                	ja     8037a4 <__udivdi3+0x8c>
  80373f:	89 fd                	mov    %edi,%ebp
  803741:	85 ff                	test   %edi,%edi
  803743:	75 0b                	jne    803750 <__udivdi3+0x38>
  803745:	b8 01 00 00 00       	mov    $0x1,%eax
  80374a:	31 d2                	xor    %edx,%edx
  80374c:	f7 f7                	div    %edi
  80374e:	89 c5                	mov    %eax,%ebp
  803750:	31 d2                	xor    %edx,%edx
  803752:	89 c8                	mov    %ecx,%eax
  803754:	f7 f5                	div    %ebp
  803756:	89 c1                	mov    %eax,%ecx
  803758:	89 d8                	mov    %ebx,%eax
  80375a:	f7 f5                	div    %ebp
  80375c:	89 cf                	mov    %ecx,%edi
  80375e:	89 fa                	mov    %edi,%edx
  803760:	83 c4 1c             	add    $0x1c,%esp
  803763:	5b                   	pop    %ebx
  803764:	5e                   	pop    %esi
  803765:	5f                   	pop    %edi
  803766:	5d                   	pop    %ebp
  803767:	c3                   	ret    
  803768:	39 ce                	cmp    %ecx,%esi
  80376a:	77 28                	ja     803794 <__udivdi3+0x7c>
  80376c:	0f bd fe             	bsr    %esi,%edi
  80376f:	83 f7 1f             	xor    $0x1f,%edi
  803772:	75 40                	jne    8037b4 <__udivdi3+0x9c>
  803774:	39 ce                	cmp    %ecx,%esi
  803776:	72 0a                	jb     803782 <__udivdi3+0x6a>
  803778:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80377c:	0f 87 9e 00 00 00    	ja     803820 <__udivdi3+0x108>
  803782:	b8 01 00 00 00       	mov    $0x1,%eax
  803787:	89 fa                	mov    %edi,%edx
  803789:	83 c4 1c             	add    $0x1c,%esp
  80378c:	5b                   	pop    %ebx
  80378d:	5e                   	pop    %esi
  80378e:	5f                   	pop    %edi
  80378f:	5d                   	pop    %ebp
  803790:	c3                   	ret    
  803791:	8d 76 00             	lea    0x0(%esi),%esi
  803794:	31 ff                	xor    %edi,%edi
  803796:	31 c0                	xor    %eax,%eax
  803798:	89 fa                	mov    %edi,%edx
  80379a:	83 c4 1c             	add    $0x1c,%esp
  80379d:	5b                   	pop    %ebx
  80379e:	5e                   	pop    %esi
  80379f:	5f                   	pop    %edi
  8037a0:	5d                   	pop    %ebp
  8037a1:	c3                   	ret    
  8037a2:	66 90                	xchg   %ax,%ax
  8037a4:	89 d8                	mov    %ebx,%eax
  8037a6:	f7 f7                	div    %edi
  8037a8:	31 ff                	xor    %edi,%edi
  8037aa:	89 fa                	mov    %edi,%edx
  8037ac:	83 c4 1c             	add    $0x1c,%esp
  8037af:	5b                   	pop    %ebx
  8037b0:	5e                   	pop    %esi
  8037b1:	5f                   	pop    %edi
  8037b2:	5d                   	pop    %ebp
  8037b3:	c3                   	ret    
  8037b4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8037b9:	89 eb                	mov    %ebp,%ebx
  8037bb:	29 fb                	sub    %edi,%ebx
  8037bd:	89 f9                	mov    %edi,%ecx
  8037bf:	d3 e6                	shl    %cl,%esi
  8037c1:	89 c5                	mov    %eax,%ebp
  8037c3:	88 d9                	mov    %bl,%cl
  8037c5:	d3 ed                	shr    %cl,%ebp
  8037c7:	89 e9                	mov    %ebp,%ecx
  8037c9:	09 f1                	or     %esi,%ecx
  8037cb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8037cf:	89 f9                	mov    %edi,%ecx
  8037d1:	d3 e0                	shl    %cl,%eax
  8037d3:	89 c5                	mov    %eax,%ebp
  8037d5:	89 d6                	mov    %edx,%esi
  8037d7:	88 d9                	mov    %bl,%cl
  8037d9:	d3 ee                	shr    %cl,%esi
  8037db:	89 f9                	mov    %edi,%ecx
  8037dd:	d3 e2                	shl    %cl,%edx
  8037df:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037e3:	88 d9                	mov    %bl,%cl
  8037e5:	d3 e8                	shr    %cl,%eax
  8037e7:	09 c2                	or     %eax,%edx
  8037e9:	89 d0                	mov    %edx,%eax
  8037eb:	89 f2                	mov    %esi,%edx
  8037ed:	f7 74 24 0c          	divl   0xc(%esp)
  8037f1:	89 d6                	mov    %edx,%esi
  8037f3:	89 c3                	mov    %eax,%ebx
  8037f5:	f7 e5                	mul    %ebp
  8037f7:	39 d6                	cmp    %edx,%esi
  8037f9:	72 19                	jb     803814 <__udivdi3+0xfc>
  8037fb:	74 0b                	je     803808 <__udivdi3+0xf0>
  8037fd:	89 d8                	mov    %ebx,%eax
  8037ff:	31 ff                	xor    %edi,%edi
  803801:	e9 58 ff ff ff       	jmp    80375e <__udivdi3+0x46>
  803806:	66 90                	xchg   %ax,%ax
  803808:	8b 54 24 08          	mov    0x8(%esp),%edx
  80380c:	89 f9                	mov    %edi,%ecx
  80380e:	d3 e2                	shl    %cl,%edx
  803810:	39 c2                	cmp    %eax,%edx
  803812:	73 e9                	jae    8037fd <__udivdi3+0xe5>
  803814:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803817:	31 ff                	xor    %edi,%edi
  803819:	e9 40 ff ff ff       	jmp    80375e <__udivdi3+0x46>
  80381e:	66 90                	xchg   %ax,%ax
  803820:	31 c0                	xor    %eax,%eax
  803822:	e9 37 ff ff ff       	jmp    80375e <__udivdi3+0x46>
  803827:	90                   	nop

00803828 <__umoddi3>:
  803828:	55                   	push   %ebp
  803829:	57                   	push   %edi
  80382a:	56                   	push   %esi
  80382b:	53                   	push   %ebx
  80382c:	83 ec 1c             	sub    $0x1c,%esp
  80382f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803833:	8b 74 24 34          	mov    0x34(%esp),%esi
  803837:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80383b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80383f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803843:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803847:	89 f3                	mov    %esi,%ebx
  803849:	89 fa                	mov    %edi,%edx
  80384b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80384f:	89 34 24             	mov    %esi,(%esp)
  803852:	85 c0                	test   %eax,%eax
  803854:	75 1a                	jne    803870 <__umoddi3+0x48>
  803856:	39 f7                	cmp    %esi,%edi
  803858:	0f 86 a2 00 00 00    	jbe    803900 <__umoddi3+0xd8>
  80385e:	89 c8                	mov    %ecx,%eax
  803860:	89 f2                	mov    %esi,%edx
  803862:	f7 f7                	div    %edi
  803864:	89 d0                	mov    %edx,%eax
  803866:	31 d2                	xor    %edx,%edx
  803868:	83 c4 1c             	add    $0x1c,%esp
  80386b:	5b                   	pop    %ebx
  80386c:	5e                   	pop    %esi
  80386d:	5f                   	pop    %edi
  80386e:	5d                   	pop    %ebp
  80386f:	c3                   	ret    
  803870:	39 f0                	cmp    %esi,%eax
  803872:	0f 87 ac 00 00 00    	ja     803924 <__umoddi3+0xfc>
  803878:	0f bd e8             	bsr    %eax,%ebp
  80387b:	83 f5 1f             	xor    $0x1f,%ebp
  80387e:	0f 84 ac 00 00 00    	je     803930 <__umoddi3+0x108>
  803884:	bf 20 00 00 00       	mov    $0x20,%edi
  803889:	29 ef                	sub    %ebp,%edi
  80388b:	89 fe                	mov    %edi,%esi
  80388d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803891:	89 e9                	mov    %ebp,%ecx
  803893:	d3 e0                	shl    %cl,%eax
  803895:	89 d7                	mov    %edx,%edi
  803897:	89 f1                	mov    %esi,%ecx
  803899:	d3 ef                	shr    %cl,%edi
  80389b:	09 c7                	or     %eax,%edi
  80389d:	89 e9                	mov    %ebp,%ecx
  80389f:	d3 e2                	shl    %cl,%edx
  8038a1:	89 14 24             	mov    %edx,(%esp)
  8038a4:	89 d8                	mov    %ebx,%eax
  8038a6:	d3 e0                	shl    %cl,%eax
  8038a8:	89 c2                	mov    %eax,%edx
  8038aa:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038ae:	d3 e0                	shl    %cl,%eax
  8038b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8038b4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038b8:	89 f1                	mov    %esi,%ecx
  8038ba:	d3 e8                	shr    %cl,%eax
  8038bc:	09 d0                	or     %edx,%eax
  8038be:	d3 eb                	shr    %cl,%ebx
  8038c0:	89 da                	mov    %ebx,%edx
  8038c2:	f7 f7                	div    %edi
  8038c4:	89 d3                	mov    %edx,%ebx
  8038c6:	f7 24 24             	mull   (%esp)
  8038c9:	89 c6                	mov    %eax,%esi
  8038cb:	89 d1                	mov    %edx,%ecx
  8038cd:	39 d3                	cmp    %edx,%ebx
  8038cf:	0f 82 87 00 00 00    	jb     80395c <__umoddi3+0x134>
  8038d5:	0f 84 91 00 00 00    	je     80396c <__umoddi3+0x144>
  8038db:	8b 54 24 04          	mov    0x4(%esp),%edx
  8038df:	29 f2                	sub    %esi,%edx
  8038e1:	19 cb                	sbb    %ecx,%ebx
  8038e3:	89 d8                	mov    %ebx,%eax
  8038e5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8038e9:	d3 e0                	shl    %cl,%eax
  8038eb:	89 e9                	mov    %ebp,%ecx
  8038ed:	d3 ea                	shr    %cl,%edx
  8038ef:	09 d0                	or     %edx,%eax
  8038f1:	89 e9                	mov    %ebp,%ecx
  8038f3:	d3 eb                	shr    %cl,%ebx
  8038f5:	89 da                	mov    %ebx,%edx
  8038f7:	83 c4 1c             	add    $0x1c,%esp
  8038fa:	5b                   	pop    %ebx
  8038fb:	5e                   	pop    %esi
  8038fc:	5f                   	pop    %edi
  8038fd:	5d                   	pop    %ebp
  8038fe:	c3                   	ret    
  8038ff:	90                   	nop
  803900:	89 fd                	mov    %edi,%ebp
  803902:	85 ff                	test   %edi,%edi
  803904:	75 0b                	jne    803911 <__umoddi3+0xe9>
  803906:	b8 01 00 00 00       	mov    $0x1,%eax
  80390b:	31 d2                	xor    %edx,%edx
  80390d:	f7 f7                	div    %edi
  80390f:	89 c5                	mov    %eax,%ebp
  803911:	89 f0                	mov    %esi,%eax
  803913:	31 d2                	xor    %edx,%edx
  803915:	f7 f5                	div    %ebp
  803917:	89 c8                	mov    %ecx,%eax
  803919:	f7 f5                	div    %ebp
  80391b:	89 d0                	mov    %edx,%eax
  80391d:	e9 44 ff ff ff       	jmp    803866 <__umoddi3+0x3e>
  803922:	66 90                	xchg   %ax,%ax
  803924:	89 c8                	mov    %ecx,%eax
  803926:	89 f2                	mov    %esi,%edx
  803928:	83 c4 1c             	add    $0x1c,%esp
  80392b:	5b                   	pop    %ebx
  80392c:	5e                   	pop    %esi
  80392d:	5f                   	pop    %edi
  80392e:	5d                   	pop    %ebp
  80392f:	c3                   	ret    
  803930:	3b 04 24             	cmp    (%esp),%eax
  803933:	72 06                	jb     80393b <__umoddi3+0x113>
  803935:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803939:	77 0f                	ja     80394a <__umoddi3+0x122>
  80393b:	89 f2                	mov    %esi,%edx
  80393d:	29 f9                	sub    %edi,%ecx
  80393f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803943:	89 14 24             	mov    %edx,(%esp)
  803946:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80394a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80394e:	8b 14 24             	mov    (%esp),%edx
  803951:	83 c4 1c             	add    $0x1c,%esp
  803954:	5b                   	pop    %ebx
  803955:	5e                   	pop    %esi
  803956:	5f                   	pop    %edi
  803957:	5d                   	pop    %ebp
  803958:	c3                   	ret    
  803959:	8d 76 00             	lea    0x0(%esi),%esi
  80395c:	2b 04 24             	sub    (%esp),%eax
  80395f:	19 fa                	sbb    %edi,%edx
  803961:	89 d1                	mov    %edx,%ecx
  803963:	89 c6                	mov    %eax,%esi
  803965:	e9 71 ff ff ff       	jmp    8038db <__umoddi3+0xb3>
  80396a:	66 90                	xchg   %ax,%ax
  80396c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803970:	72 ea                	jb     80395c <__umoddi3+0x134>
  803972:	89 d9                	mov    %ebx,%ecx
  803974:	e9 62 ff ff ff       	jmp    8038db <__umoddi3+0xb3>
